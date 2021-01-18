Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E02FA5D3
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406473AbhARQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:15:13 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:62269 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406465AbhARQOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:14:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610986420; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=QSN4vwmJGElORk0Uljeje4PQPgKgyF8sRWakhbOM3fc=;
 b=a8rGQof37UebyKC+0dLYC2ezhDSJjMul9cdY7pTZJgmDQmo9z2CVpF/Vt7gfLfLWeg9bPdhO
 kKoSNEQiFjy43mVY7+jLYKSgUPfMo4tKkEIHJdlo2NRQVe22QibPDCMR63vvvN+tgWhNyMD4
 ZhIbsFyYoD5RXrxJZuBquFhViis=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6005b39902b2f1cb1a26d5f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Jan 2021 16:13:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0F041C43464; Mon, 18 Jan 2021 16:13:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94F5FC433CA;
        Mon, 18 Jan 2021 16:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94F5FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath10k: increase rx buffer size to 2048
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200205191043.21913-1-linus.luessing@c0d3.blue>
References: <20200205191043.21913-1-linus.luessing@c0d3.blue>
To:     =?utf-8?q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Linus_L?= =?utf-8?q?=C3=BCssing?= 
        <ll@simonwunderlich.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210118161313.0F041C43464@smtp.codeaurora.org>
Date:   Mon, 18 Jan 2021 16:13:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Lüssing <linus.luessing@c0d3.blue> wrote:

> Before, only frames with a maximum size of 1528 bytes could be
> transmitted between two 802.11s nodes.
> 
> For batman-adv for instance, which adds its own header to each frame,
> we typically need an MTU of at least 1532 bytes to be able to transmit
> without fragmentation.
> 
> This patch now increases the maxmimum frame size from 1528 to 1656
> bytes.
> 
> Tested with two ath10k devices in 802.11s mode, as well as with
> batman-adv on top of 802.11s with forwarding disabled.
> 
> Fix originally found and developed by Ben Greear.
> 
> Link: https://github.com/greearb/ath10k-ct/issues/89
> Link: https://github.com/greearb/ath10k-ct/commit/9e5ab25027e0971fa24ccf93373324c08c4e992d
> Cc: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3e6b9cf534ca ath10k: increase rx buffer size to 2048

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20200205191043.21913-1-linus.luessing@c0d3.blue/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

