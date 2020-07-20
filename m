Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B976226CEA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbgGTRJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:09:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57390 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbgGTRJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:09:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595264994; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pEBC16t+YV4FGYaWikogHtEEGJZCLsu+AxuloV4iKJY=;
 b=pbuBz3+5dDu/CxAFykykMKiM0b9Wdr0VK8+njYbR49/4eqjUjHbxA6AW4pv2n5Gqy7GCBnPI
 n+Bmp9tD/NOrMvaEcGi5Ec8CF0lKgIxfnfuDFdJvh2inVFsGGU2KsUOZPE2a6vNqbG0qM8fv
 P8E/XR/zoJwT0DThqT7rA5B5uPY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f15cfdfeef925b694313ec7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Jul 2020 17:09:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3BFFDC433C9; Mon, 20 Jul 2020 17:09:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCB1CC433C9;
        Mon, 20 Jul 2020 17:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCB1CC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/14 v3] ath9k: Check the return value of
 pcie_capability_read_*()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200713175529.29715-2-refactormyself@gmail.com>
References: <20200713175529.29715-2-refactormyself@gmail.com>
To:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>
Cc:     skhan@linuxfoundation.org, linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200720170951.3BFFDC433C9@smtp.codeaurora.org>
Date:   Mon, 20 Jul 2020 17:09:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Saheed O. Bolarinwa" <refactormyself@gmail.com> wrote:

> On failure pcie_capability_read_dword() sets it's last parameter, val
> to 0. However, with Patch 14/14, it is possible that val is set to ~0 on
> failure. This would introduce a bug because (x & x) == (~0 & x).
> 
> This bug can be avoided without changing the function's behaviour if the
> return value of pcie_capability_read_dword is checked to confirm success.
> 
> Check the return value of pcie_capability_read_dword() to ensure success.
> 
> Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
> Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9a8ab2bfb678 ath9k: Check the return value of pcie_capability_read_*()

-- 
https://patchwork.kernel.org/patch/11660731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

