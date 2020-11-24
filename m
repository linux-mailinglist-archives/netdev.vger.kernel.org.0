Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161F32C1EC6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgKXHTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:19:44 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:11967 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729983AbgKXHTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:19:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606202383; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=E/zHSJyBKGvYROkUaoI8KWdVr1eUDpBgWWtODvR0Ztk=; b=jKPYT1/wGyZb+HPMjwEKSL+1eKmeg/uZo0wrwYsfIZ9cvzLtcPRBDYC9o5Yqqu0LW+vfqP3N
 y+ZQua5OzyajOM6ye4SSBN6M7TosL/7Yz+dKoj/jERouMgNBmBY3WRIJ3gEX+BqUSbpCFjUR
 xDUtQZcHGBwr7vVtd/TA60n9rFw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fbcb40eeb04c00160751219 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 07:19:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF99DC43461; Tue, 24 Nov 2020 07:19:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89F27C433ED;
        Tue, 24 Nov 2020 07:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89F27C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     hby <hby2003@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] brmcfmac: fix compile when DEBUG is defined
References: <20201122100606.20289-1-hby2003@163.com>
        <87r1okqd2n.fsf@codeaurora.org>
        <c3b297cf-268e-6f28-f585-5452dd8696f8@163.com>
Date:   Tue, 24 Nov 2020 09:19:38 +0200
In-Reply-To: <c3b297cf-268e-6f28-f585-5452dd8696f8@163.com> (hby's message of
        "Tue, 24 Nov 2020 09:46:23 +0800")
Message-ID: <87eekjql11.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hby <hby2003@163.com> writes:

> I am sorry for the HTML email, and I change the email client. The
> patch update.
>
> From b87d429158b4efc3f6835828f495a261e17d5af4 Mon Sep 17 00:00:00 2001
> From: hby <hby2003@163.com>
> Date: Tue, 24 Nov 2020 09:16:24 +0800
> Subject: [PATCH] brmcfmac: fix compile when DEBUG is defined
>
> The steps:
> 1. add "#define DEBUG" in
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c line 61.
> 2. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux
> bcm2835_defconfig
> 3. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux/
> zImage modules dtbs -j8
>
> Then, it will fail, the compile log described below:

It doesn't work like this, the patch handling is very much automated and
you can't just reply with a new patch. I strongly recommend to use git
send-email and read the wiki page below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
