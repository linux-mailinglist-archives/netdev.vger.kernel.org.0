Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1B6D20BA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjCaMqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjCaMqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:46:11 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8401FD00;
        Fri, 31 Mar 2023 05:45:55 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 920C21883AFB;
        Fri, 31 Mar 2023 12:45:52 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 83E4D25004E1;
        Fri, 31 Mar 2023 12:45:52 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 757369B403F7; Fri, 31 Mar 2023 12:45:52 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id C93F09B403E4;
        Fri, 31 Mar 2023 12:45:51 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
In-Reply-To: <20230331093732.s6loozkdhehewlm4@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder> <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder> <874jq22h2u.fsf@kapio-technology.com>
 <20230330192714.oqosvifrftirshej@skbuf>
 <871ql5mjjp.fsf@kapio-technology.com>
 <20230331093732.s6loozkdhehewlm4@skbuf>
Date:   Fri, 31 Mar 2023 14:43:11 +0200
Message-ID: <87tty1nlb4.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 12:37, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> So, by running the command I posted in the earlier email, you actually
> run it on the physical DSA user port interfaces, and it should pass
> there too.

Okay, that sounds like a good idea which I have not done before. I am
seeing how I can install Debian in an Qemu or VMWare setup to be able to
test that way.

> This is based on the equivalency principle between the
> software and the hardware data paths that I was talking about.
>
> If you're actively and repeatedly making an effort to work with your eyes
> closed, and then build strawmen around the fact that you don't see, then
> you're not going to get very friendly reactions from people, me included,
> who explain things to you that pertain to your due diligence. This is
> because these people know the things that they're explaining to you out
> of their own due diligence, and, as a result, are not easily fooled by
> your childish excuses.

I am not coming with excuses here, and certainly not childish ones at
that either. I am just pointing out that on my device the tests don't
run well because of memory shortage and my reasoning why I think it is
so.
I will as long as the system is as it is with these selftests, just run
single subtests at a time on target, but if I have new phy problems like
the one you have seen I have had before, then testing on target becomes
off limits.
