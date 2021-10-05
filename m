Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A09422B06
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhJEObW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:31:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54605 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbhJEObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:31:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633444170; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FxJv+xfRfX0wiXpi4iHFEWoHOtv7gBTnYPqMLSJu+pQ=;
 b=tfdL9FkNU8FsW0QVF6/EtrmCiGeFoWa9oMbH2RkaOosuuIrVbPlQEBHPGSyrEbM6st7st367
 Ov/1iBwbm+eCGKTWYRkl8Z1XyUUdXLm0gvz9fElop2L/JOzqujeU6C5IWHlxk/+nzPMdCAd0
 fNHZqMFP3D7cBs7L/G0uqPGasGY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 615c614a03355859c8c7a88b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 14:29:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6413FC43617; Tue,  5 Oct 2021 14:29:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A00F6C4338F;
        Tue,  5 Oct 2021 14:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A00F6C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Remove unused variable in
 ath11k_dp_rx_mon_merg_msdus()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210927150743.19816-1-tim.gardner@canonical.com>
References: <20210927150743.19816-1-tim.gardner@canonical.com>
To:     Tim Gardner <tim.gardner@canonical.com>
Cc:     ath11k@lists.infradead.org, tim.gardner@canonical.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20211005142930.6413FC43617@smtp.codeaurora.org>
Date:   Tue,  5 Oct 2021 14:29:30 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> wrote:

> Coverity complains that a constant variable guards dead code. In fact,
> mpdu_buf is set NULL and never updated.
> 
> 4834err_merge_fail:
>         null: At condition mpdu_buf, the value of mpdu_buf must be NULL.
>         dead_error_condition: The condition mpdu_buf cannot be true.
> CID 92162 (#1 of 1): 'Constant' variable guards dead code (DEADCODE)
> dead_error_line: Execution cannot reach the expression decap_format !=
>   DP_RX_DECAP_TYPE_RAW inside this statement: if (mpdu_buf && decap_forma....
> Local variable mpdu_buf is assigned only once, to a constant value, making it
>   effectively constant throughout its scope. If this is not the intent, examine
>   the logic to see if there is a missing assignment that would make mpdu_buf not
>   remain constant.
> 4835        if (mpdu_buf && decap_format != DP_RX_DECAP_TYPE_RAW) {
> 
> Fix this by removing mpdu_buf and unreachable code.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: ath11k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7210b4b77fe4 ath11k: Remove unused variable in ath11k_dp_rx_mon_merg_msdus()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210927150743.19816-1-tim.gardner@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

