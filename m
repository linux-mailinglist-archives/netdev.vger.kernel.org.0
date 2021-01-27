Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316203058A0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhA0KjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 05:39:25 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:59030 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234160AbhA0Kgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 05:36:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611743781; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=CaXXVSQ1one582ViqeYOwh6mcykQucWxm/rUc3Fag+0=; b=eN+05usRmKt/Ll17H/omXuInwJKvJ6Um9F8Xwe8jUNX+sJbfMuYPI2v2wzggAAEXLXA6aqAJ
 3qYAAjk+ljJJ09TsDMnKL6sK2V+7ZI+rVud9csH8A9aATcnwdkIpQqS+/8gPrZq/CHEgkqau
 aEUehFGTceLwihgdm6cxn8Sgycs=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60114200bdcf4682871cf1bf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Jan 2021 10:35:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ABFF5C433C6; Wed, 27 Jan 2021 10:35:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 053AAC433C6;
        Wed, 27 Jan 2021 10:35:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 053AAC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
References: <20210125113654.2408057-1-arnd@kernel.org>
        <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
        <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
        <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
        <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
        <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
        <CAK8P3a3ygYTEwjLbFuArdfNF1-yydVjtS2NZDAURKjOJGAxkAQ@mail.gmail.com>
Date:   Wed, 27 Jan 2021 12:35:37 +0200
In-Reply-To: <CAK8P3a3ygYTEwjLbFuArdfNF1-yydVjtS2NZDAURKjOJGAxkAQ@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 25 Jan 2021 16:22:18 +0100")
Message-ID: <87bldaacqu.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> On Mon, Jan 25, 2021 at 4:04 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>> On Mon, 25 Jan 2021 at 15:38, Arnd Bergmann <arnd@kernel.org> wrote:
>> > On Mon, Jan 25, 2021 at 2:27 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>
>> I meant that having MAC80211_LEDS selected causes the ath9k driver to
>> toggle on/off the WiFi LED. Every second, regardless whether it's
>> doing something or not. In my setup, I have problems with a WiFi
>> dongle somehow crashing (WiFi disappears, nothing comes from the
>> dongle... maybe it's Atheros FW, maybe some HW problem) and I found
>> this LED on/off slightly increases the chances of this dongle-crash.
>> That was the actual reason behind my commits.
>>
>> Second reason is that I don't want to send USB commands every second
>> when the device is idle. It unnecessarily consumes power on my
>> low-power device.
>
> Ok, I see.
>
>> Of course another solution is to just disable the trigger via sysfs
>> LED API. It would also work but my patch allows entire code to be
>> compiled-out (which was conditional in ath9k already).
>>
>> Therefore the patch I sent allows the ath9k LED option to be fully
>> choosable. Someone wants every-second-LED-blink, sure, enable
>> ATH9K_LEDS and you have it. Someone wants to reduce the kernel size,
>> don't enable ATH9K_LEDS.
>
> Originally, I think this is what CONFIG_MAC80211_LEDS was meant
> for, but it seems that this is not actually practical, since this also
> gets selected by half of the drivers using it, while the other half have
> a dependency on it. Out of the ones that select it, some in turn
> select LEDS_CLASS, while some depend on it.
>
> I think this needs a larger-scale cleanup for consistency between
> (at least) all the wireless drivers using LEDs.

I agree, this needs cleanup.

> Either your patch or mine should get applied in the meantime, and I
> don't care much which one in this case, as we still have the remaining
> inconsistency.

My problem with Krzysztof's patch[1] is that it adds a new Kconfig
option for ath9k, is that really necessary? Like Arnd said, we should
fix drivers to use CONFIG_MAC80211_LEDS instead of having driver
specific options.

So I would prefer take this Arnd's patch instead and queue it for v5.11.
But as it modifies mac80211 I'll need an ack from Johannes, what do you
think?

[1] https://patchwork.kernel.org/project/linux-wireless/patch/20201227143034.1134829-1-krzk@kernel.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
