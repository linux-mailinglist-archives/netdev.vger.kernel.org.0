Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D72257C01
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgHaPQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:16:57 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:26419 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728324AbgHaPQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:16:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598887014; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ysYzo+Er7KVYGGas/Ij6Cr6vjIBlCSJyFLaEx6zU4E4=;
 b=hwoHgINlXy1xEtDsnJpF7IABIyfz78UN34fk5FkA+MFAnwZXxyIHNX2ThE+yDcyy+BIVXSBP
 NkgGPmx6DYSrrEbkRt09pHaVvzZvmA1SUO/OszZ8RJmrE4ShOuIzDTMmD39dm2QP0nLJ56eo
 TRPaV+d7jzkt16y/32sZW8iieJU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f4d1464947f606f7e65d838 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 15:16:52
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D014C43395; Mon, 31 Aug 2020 15:16:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF877C433CB;
        Mon, 31 Aug 2020 15:16:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF877C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: fix missing error check on call to
 ath11k_pci_get_user_msi_assignment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200819111452.52419-1-colin.king@canonical.com>
References: <20200819111452.52419-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200831151652.4D014C43395@smtp.codeaurora.org>
Date:   Mon, 31 Aug 2020 15:16:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> The return error check on the call to ath11k_pci_get_user_msi_assignment is
> missing.  If an error does occur, num_vectors is still set to zero and
> later on a division by zero can occur when variable vector is being
> calculated.  Fix this by adding an error check after the call.
> 
> Addresses-Coverity: ("Division or modulo by zero")
> Fixes: d4ecb90b3857 ("ath11k: enable DP interrupt setup for QCA6390")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b2c094582e38 ath11k: fix missing error check on call to ath11k_pci_get_user_msi_assignment

-- 
https://patchwork.kernel.org/patch/11723523/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

