Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3255306F97
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 08:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhA1Hd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 02:33:27 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:38196 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhA1HbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 02:31:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611819041; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ma2PF13HPKHocMPcRDFwaF+lTIVz0C9tWL5CYpm4JgU=;
 b=EV/4Qq4mO+3XdZrV7x/WRRcuAry0D00exVUMrHUVT3oXWD1Wz/lRLXA7RsCbOdKGrlnQ+sdE
 aNQZ5yhAnqzIz6uC1o6eKioTKfWBwBvSTROSzXLb1AvEatZhWzSFlupFYEZ8ZfWoqm3tSw3U
 kjeEI9BPn5qkhoqLPItv9yYABgU=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60126801e325600642638c36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 07:30:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A219DC43466; Thu, 28 Jan 2021 07:30:08 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6FEF2C43461;
        Thu, 28 Jan 2021 07:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6FEF2C43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210125113654.2408057-1-arnd@kernel.org>
References: <20210125113654.2408057-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210128073008.A219DC43466@smtp.codeaurora.org>
Date:   Thu, 28 Jan 2021 07:30:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_ATH9K is built-in but LED support is in a loadable
> module, both ath9k drivers fails to link:
> 
> x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
> gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
> x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
> gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
> 
> The problem is that the 'imply' keyword does not enforce any dependency
> but is only a weak hint to Kconfig to enable another symbol from a
> defconfig file.
> 
> Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
> configuration but still allows building the driver without LED support.
> 
> The 'select MAC80211_LEDS' is now ensures that the LED support is
> actually used if it is present, and the added Kconfig dependency
> on MAC80211_LEDS ensures that it cannot be enabled manually when it
> has no effect.
> 
> Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Patch applied to wireless-drivers.git, thanks.

b64acb28da83 ath9k: fix build error with LEDS_CLASS=m

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210125113654.2408057-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

