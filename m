Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85374170A3
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 13:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245706AbhIXLKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 07:10:36 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:20511 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244460AbhIXLKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 07:10:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632481743; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6PEpuYItvKQKeYhp0TIEbF/yB5AlmPXVBivbxlY6pHU=;
 b=SRHSD1m4HsugVDwwsTnO+3pT+A0CMOfciZCB2h5fYAfRRv35V2NFV7niyPBH06+iYDEXsmCQ
 Wyfw2RKHXVgX0g4NlAYupvQTI66234nmnVH8h8Q+9wEajDpRJ5iPoQq7v0UWsaveNJp3ecbp
 ar9kQXuD+x/ede+/+uTmJCWUJbQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 614db1a96c4c0e0dc3b1a71b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 11:08:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 428D9C43619; Fri, 24 Sep 2021 11:08:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51D24C4338F;
        Fri, 24 Sep 2021 11:08:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 51D24C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v2] ath5k: fix building with LEDS=m
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210920122359.353810-1-arnd@kernel.org>
References: <20210920122359.353810-1-arnd@kernel.org>
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
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210924110825.428D9C43619@smtp.codeaurora.org>
Date:   Fri, 24 Sep 2021 11:08:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

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

Patch applied to wireless-drivers.git, thanks.

fb8c3a3c5240 ath5k: fix building with LEDS=m

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210920122359.353810-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

