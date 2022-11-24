Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4C6373FA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiKXIdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXIdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:33:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DD690398;
        Thu, 24 Nov 2022 00:33:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD68B826FD;
        Thu, 24 Nov 2022 08:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7F6C433D6;
        Thu, 24 Nov 2022 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669278816;
        bh=Qp4SAOZp+ePU4E/9TZpR/P1HKJj/ygWSn7O+PJrGOAY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Tzj0dfGEj2wSlf8ULFZvnSR8U7qnCI7PCyCLOa0+TM4leIHpKDHPhlmkow/si168+
         vngYH1KtLZ72ks0f95VzFZwkcMdFxMX2BRE8M10kEzPM7Gku/fJ2NLQmEhNi6mQn72
         KugTI3PaF2Mrt7KE/V1O7NCulKI0AgCXU/WlalD7vjQV9k3WSsTxjajTSEwgaVOPZ3
         KYfNoT3GoFqdwtR9ABFJmSt/IScn9POgrsGxSi6ox5rqqcTN7uWsjZ41cCWqnwwTtM
         fLhEhOPsX+WeOTSJICE+HZ4w2dT7slbBtgU1+DX0PqUFVfwuzUhjmhwkaQJ3EVJmI3
         Sv1MeFPMbP0wA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Bernie Huang <phhuang@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>
Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
In-Reply-To: <20221124082158.GE29978@pengutronix.de> (Sascha Hauer's message
        of "Thu, 24 Nov 2022 09:21:58 +0100")
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
        <20221122145527.GA29978@pengutronix.de>
        <015051d9a5b94bbca5135c58d2cfebf3@realtek.com>
        <20221124082158.GE29978@pengutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 24 Nov 2022 10:33:30 +0200
Message-ID: <87sfi87nvp.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

>> > There still is a problem with the RTL8822cu chipset I have here.  When
>> > using NetworkManager I immediately lose the connection to the AP after
>> > it has been connected:
>> > 
>> > [  376.213846] wlan0: authenticate with 76:83:c2:ce:81:b1
>> > [  380.085463] wlan0: send auth to 76:83:c2:ce:81:b1 (try 1/3)
>> > [  380.091446] wlan0: authenticated
>> > [  380.108864] wlan0: associate with 76:83:c2:ce:81:b1 (try 1/3)
>> > [ 380.136448] wlan0: RX AssocResp from 76:83:c2:ce:81:b1
>> > (capab=0x1411 status=0 aid=2)
>> > [  380.202955] wlan0: associated
>> > [  380.268140] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> > [  380.275328] wlan0: Connection to AP 76:83:c2:ce:81:b1 lost
>> > 
>> > That doesn't happen when using plain wpa_supplicant. This seems to go
>> > down to cd96e22bc1da ("rtw88: add beacon filter support"). After being
>> > connected I get a BCN_FILTER_CONNECTION_LOSS beacon. Plain
>> > wpa_supplicant seems to go another code patch and doesn't activate
>> > connection quality monitoring.
>> > 
>> > The connection to the AP works fluently also with NetworkManager though
>> > when I just ignore the BCN_FILTER_CONNECTION_LOSS beacon.
>> > 
>> > Any idea what may be wrong here?
>> > 
>> 
>> Please reference to below patch to see if it can work to you.
>> 
>> https://lore.kernel.org/linux-wireless/20221124064442.28042-1-pkshih@realtek.com/T/#u
>
> Great! That solves this issue \o/

Awesome, great work Ping and Ji-Pin!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
