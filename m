Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF13F5F0E1A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiI3OyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiI3Oxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:53:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B131C439;
        Fri, 30 Sep 2022 07:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F284EB8291A;
        Fri, 30 Sep 2022 14:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241ABC433D6;
        Fri, 30 Sep 2022 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664549526;
        bh=wAWWnDm7dRfdfL1HmqTHFE1I+5HoqUMPdvT4lPVEVoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bJQRnCgWgZS/Y4k3DPIVn8jCZvgWNT8MnReKAQQxb9c7BvikjAFxBUbelfmcH+g/8
         BnLeyvMclzeZw9EyFesPMH5HJftJHAQyAVx3uzjeOYbWf+tsLFfVnnsfbNYO/MpRWn
         89z7zInb1EqAj4CB3WO7e0+pAAsCIxVYGhnMj97QnCAf/VAwvyt2vJZSxob/n17hD+
         +3qptHAyJuCpgRLDppuF4+PSlZYWUIUx6bspwZuCzGROyytwzBG9k/Sp508GdImeej
         GXaeifMfOoC2Tut/0wuCnBLHLJgmYvD62nyPwwIezJpkF6cqAL+Bqo2gyw4/wTgMl1
         HLtS0Q7AAdxAw==
Date:   Fri, 30 Sep 2022 07:52:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <20220930075204.608b6351@kernel.org>
In-Reply-To: <Yzb3oNGNtq4GCS3M@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
        <20220929091036.3812327f@kernel.org>
        <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
        <20220929112744.27cc969b@kernel.org>
        <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
        <Yzb3oNGNtq4GCS3M@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 17:05:20 +0300 Ido Schimmel wrote:
> You can see build issues on patchwork:

Overall a helpful response, but that part you got wrong.

Do not point people to patchwork checks, please. It will only encourage
people to post stuff they haven't build tested themselves.

It's documented:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them

Only people who helped write the code and maintain the infra can decide
how to use it which means me, Kees, or Hangbin. Please and thank you :S
