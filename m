Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4354286D2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhJKG2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:28:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13919 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhJKG2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 02:28:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633933602; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ZVQrWonnh9hRM9Qxp6VLOIO41IBcRwVY8KNlil4vdIk=;
 b=D1JAduLgYEmmosf0b5+nUkDKy84PiUe8ew198Im5sYUKH3N+mr8AKOhoVOmzrfu41lB39dQt
 hYxrQk8h6HV3l30iSt87vtrSQWtRxUGkYzKxkTwT68686ICLrtWwFwt1hw0mTZKE3QnsyaRy
 9hX8E8cIrFxgCnezLEafBVhwYxo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6163d90b4ccc4cf2c79b9896 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Oct 2021 06:26:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C9180C43616; Mon, 11 Oct 2021 06:26:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3848C4338F;
        Mon, 11 Oct 2021 06:26:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B3848C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath: dfs_pattern_detector: Fix possible null-pointer
 dereference in channel_detector_create()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210805153854.154066-1-islituo@gmail.com>
References: <20210805153854.154066-1-islituo@gmail.com>
To:     Tuo Li <islituo@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163393357512.20318.16433402434764020686.kvalo@codeaurora.org>
Date:   Mon, 11 Oct 2021 06:26:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tuo Li <islituo@gmail.com> wrote:

> kzalloc() is used to allocate memory for cd->detectors, and if it fails,
> channel_detector_exit() behind the label fail will be called:
>   channel_detector_exit(dpd, cd);
> 
> In channel_detector_exit(), cd->detectors is dereferenced through:
>   struct pri_detector *de = cd->detectors[i];
> 
> To fix this possible null-pointer dereference, check cd->detectors before
> the for loop to dereference cd->detectors.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4b6012a7830b ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210805153854.154066-1-islituo@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

