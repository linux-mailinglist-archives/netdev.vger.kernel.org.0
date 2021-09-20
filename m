Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CADA4114DE
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhITMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:50:17 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53197 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhITMuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:50:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632142128; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=oXH2r2YAvNR0xujgASmm26KkyFaQDUEkr4gUUo/Kmwg=; b=hM8HwFMGS85+BthQAQ51stwie8rcFasfrMNMyCSSTsinxAmENKuVy+qlvVeH0Jko+eIOfm1Y
 2hVvmTnkEoTwoz8hFfJz8DS0s9Xc4R/BTt/65p0o1mSwN6zFKAcCnKdFlW5cXUviJWnYs021
 FdnSucuUtr5/BGKimqVInlOwQao=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6148831165c3cc8c639e283a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Sep 2021 12:48:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2EC55C4338F; Mon, 20 Sep 2021 12:48:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 038A9C4338F;
        Mon, 20 Sep 2021 12:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 038A9C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] ath5k: fix building with LEDS=m
References: <20210920122359.353810-1-arnd@kernel.org>
Date:   Mon, 20 Sep 2021 15:48:10 +0300
In-Reply-To: <20210920122359.353810-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Mon, 20 Sep 2021 14:23:44 +0200")
Message-ID: <87sfxzwgz9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Randconfig builds still show a failure for the ath5k driver,
> similar to the one that was fixed for ath9k earlier:
>
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>   Selected by [m]:
>   - ATH5K [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && (PCI [=y] || ATH25) && MAC80211 [=y]
> net/mac80211/led.c: In function 'ieee80211_alloc_led_names':
> net/mac80211/led.c:34:22: error: 'struct led_trigger' has no member named 'name'
>    34 |         local->rx_led.name = kasprintf(GFP_KERNEL, "%srx",
>       |                      ^
>
> Copying the same logic from my ath9k patch makes this one work
> as well, stubbing out the calls to the LED subsystem.
>
> Fixes: b64acb28da83 ("ath9k: fix build error with LEDS_CLASS=m")
> Fixes: 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by default")
> Fixes: 3a078876caee ("ath5k: convert LED code to use mac80211 triggers")
> Link: https://lore.kernel.org/all/20210722105501.1000781-1-arnd@kernel.org/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v2:
> - avoid link failure when NEW_LEDS is disabled

I'll queue this to v5.15.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
