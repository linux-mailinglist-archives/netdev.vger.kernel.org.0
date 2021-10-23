Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68BA438231
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 09:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhJWHcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 03:32:03 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19546 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhJWHcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Oct 2021 03:32:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634974183; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=EgTeU6Vkr3NhQq7X+wDt/Q6cik6UwYvhxwAg6xdACwQ=;
 b=e44XeOe+YXJrLwBuoaeSdfjD1vftSF5o9Lg2fTWABm4WMjieGn+kyVgp5K/qZrQVhAMwl6ih
 EfuR3Pk0wl1REeDzmYOXoL+bzPZEq2NpAC9A8HVhXkkJ6JsEwn6fTz9iH5RpS5nXtu6zJ6pb
 XBmAiW1MSGh3qcp8REKl+H+kSNk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6173b9d48e67b5f04ec5b1df (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 07:29:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88C13C4360D; Sat, 23 Oct 2021 07:29:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86696C4338F;
        Sat, 23 Oct 2021 07:29:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 86696C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] mt76: mt7921: fix Wformat build warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211022233251.29987-1-rdunlap@infradead.org>
References: <20211022233251.29987-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163497415831.29616.6366174077923713050.kvalo@codeaurora.org>
Date:   Sat, 23 Oct 2021 07:29:23 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> ARRAY_SIZE() is of type size_t, so the format specfier should
> be %zu instead of %lu.
> 
> Fixes this build warning:
> 
> ../drivers/net/wireless/mediatek/mt76/mt7921/main.c: In function ‘mt7921_get_et_stats’:
> ../drivers/net/wireless/mediatek/mt76/mt7921/main.c:1024:26: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Wformat=]
>    dev_err(dev->mt76.dev, "ei: %d  SSTATS_LEN: %lu",
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sean Wang <sean.wang@mediatek.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Cc: Ryder Lee <ryder.lee@mediatek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

a88cae727b3e mt76: mt7921: fix Wformat build warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211022233251.29987-1-rdunlap@infradead.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

