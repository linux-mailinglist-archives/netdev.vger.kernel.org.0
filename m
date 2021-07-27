Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD223D6EDA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhG0GKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:10:53 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:29490 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhG0GKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:10:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627366252; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=mGArwDTjXra5T2pzBW7Oz+IaFD5IRPeuL9dvd7Qx/g4=; b=NyipvcG0lRH6k/Hw3YqgfNViIZRwsWa0XXd7r+Is+ti50AtZNFbNFK9BdRUul7IFpoH6gu1x
 NJ3YJcFotd2jnd9wIeSQSLLmSEMNcF5Dit1hc3VwL2D9C9Aex140X8J71HI7+JAtCYrcXt+6
 8JR/PA2KeNUgt+XLwAcYNLTjm6k=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60ffa36a9771b05b248831e5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Jul 2021 06:10:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7B1A5C433F1; Tue, 27 Jul 2021 06:10:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55400C433F1;
        Tue, 27 Jul 2021 06:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 55400C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hin-Tak Leung <htl10@users.sourceforge.net>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        Salah Triki <salah.triki@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
References: <20210724183457.GA470005@pc>
        <53895498.1259278.1627160074135@mail.yahoo.com>
Date:   Tue, 27 Jul 2021 09:10:45 +0300
In-Reply-To: <53895498.1259278.1627160074135@mail.yahoo.com> (Hin-Tak Leung's
        message of "Sat, 24 Jul 2021 20:54:34 +0000 (UTC)")
Message-ID: <87im0wguca.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hin-Tak Leung <htl10@users.sourceforge.net> writes:

> On Saturday, 24 July 2021, 19:35:12 BST, Salah Triki <salah.triki@gmail.com> wrote:
>
>> Replace udev with usb_get_dev() in order to make code cleaner.
>
>> Signed-off-by: Salah Triki <salah.triki@gmail.com>
>> ---
>> drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 4 +---
>> 1 file changed, 1 insertion(+), 3 deletions(-)
>
>> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>> index eb68b2d3caa1..30bb3c2b8407 100644
>> --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
>> @@ -1455,9 +1455,7 @@ static int rtl8187_probe(struct usb_interface *intf,
>
>>     SET_IEEE80211_DEV(dev, &intf->dev);
>>     usb_set_intfdata(intf, dev);
>> -    priv->udev = udev;
>> -
>> -    usb_get_dev(udev);
>> +    priv->udev = usb_get_dev(udev);
>
>>     skb_queue_head_init(&priv->rx_queue);
>
>> -- 
>> 2.25.1
>
> It is not cleaner - the change is not functionally equivalent. Before
> the change, the reference count is increased after the assignment; and
> after the change, before the assignment. So my question is, does the
> reference count increasing a little earlier matters? What can go wrong
> between very short time where the reference count increases, and
> priv->udev not yet assigned? I think there might be a race condition
> where the probbe function is called very shortly twice. Especially if
> the time of running the reference count function is non-trivial.
>
> Larry, what do you think? 

BTW, please don't use HTML in emails. Our lists drop all HTML mail (and
for a good reason).

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
