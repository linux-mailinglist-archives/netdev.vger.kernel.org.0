Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0618E363163
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhDQRYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:24:53 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:30410 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbhDQRYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:24:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618680264; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=1tfWMulYA+1iJVKuBHoeOHcKhvEi/SWMkXLaNEN2q/8=;
 b=lDIkiFUpdkwHYh307Zy4kGkW8ym8dOAVXe7p4oWN1j2bok1Xel8xuwvIOYdlihJ/HO6gaC5f
 3VX70VjjNCNeV1LC/l1WTsrID6+UWtPMOeovaVnQkk0hOggo84msqv9ibw8F5NFNtV5SMvvI
 AiNlo2f5VajCFZOQcW5Pb7rmrDA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 607b19c0febcffa80f265021 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:24:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29509C433D3; Sat, 17 Apr 2021 17:24:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A59ACC433D3;
        Sat, 17 Apr 2021 17:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A59ACC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: Fix possible buffer overflow in
 qtnf_event_handle_external_auth
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210317121706.389058-1-leegib@gmail.com>
References: <20210317121706.389058-1-leegib@gmail.com>
To:     Lee Gibson <leegib@gmail.com>
Cc:     imitsyanko@quantenna.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417172416.29509C433D3@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:24:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Gibson <leegib@gmail.com> wrote:

> Function qtnf_event_handle_external_auth calls memcpy without
> checking the length.
> A user could control that length and trigger a buffer overflow.
> Fix by checking the length is within the maximum allowed size.
> 
> Signed-off-by: Lee Gibson <leegib@gmail.com>

Please use clamp_val() instead, that's preferred over min_t().

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210317121706.389058-1-leegib@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

