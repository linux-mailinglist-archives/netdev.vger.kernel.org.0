Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA01422B00
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhJEO3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:29:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51421 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhJEO3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:29:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633444069; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=BdPdR4PiTT5ZNwLsK5hY8CDdVKLrTsD1mG8kU/GlKNk=;
 b=Z0rvafU21LYkrSTeFuEjbWwRLOTcTX/m+rlUcgi8XlWSqiM+qpcLWCIDEICUccdJIW/00GDa
 vH7hXwtt1EzpWiWFchMcYqstD0hMQf5jZEP6k+Nj/zMmncVSRRMw2x1nyY7SIYxzOX6NoS5Q
 tkEfEtcGDKLKGL625PLwfFnBhOc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 615c60e59ebaf35aaa322f52 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Oct 2021 14:27:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9B4DFC43460; Tue,  5 Oct 2021 14:27:48 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2ED39C4338F;
        Tue,  5 Oct 2021 14:27:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2ED39C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] ath9k: add option to reset the wifi chip via debugfs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210914192515.9273-2-linus.luessing@c0d3.blue>
References: <20210914192515.9273-2-linus.luessing@c0d3.blue>
To:     =?utf-8?q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Linus_L=C3=BCssing?= <ll@simonwunderlich.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20211005142748.9B4DFC43460@smtp.codeaurora.org>
Date:   Tue,  5 Oct 2021 14:27:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Lüssing <linus.luessing@c0d3.blue> wrote:

> Sometimes, in yet unknown cases the wifi chip stops working. To allow a
> watchdog in userspace to easily and quickly reset the wifi chip, add the
> according functionality to userspace. A reset can then be triggered
> via:
> 
>   $ echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/reset
> 
> The number of user resets can further be tracked in the row "User reset"
> in the same file.
> 
> So far people usually used "iw scan" to fix ath9k chip hangs from
> userspace. Which triggers the ath9k_queue_reset(), too. The reset file
> however has the advantage of less overhead, which makes debugging bugs
> within ath9k_queue_reset() easier.
> 
> Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

053f9852b95e ath9k: add option to reset the wifi chip via debugfs
4925642d5412 ath9k: Fix potential interrupt storm on queue reset

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210914192515.9273-2-linus.luessing@c0d3.blue/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

