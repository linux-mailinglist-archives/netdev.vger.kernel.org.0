Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31D76D013F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjC3KcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC3KcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:32:03 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED7A19F;
        Thu, 30 Mar 2023 03:31:59 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 550331883A12;
        Thu, 30 Mar 2023 10:31:57 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 3F89F2500389;
        Thu, 30 Mar 2023 10:31:57 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 342579B403F6; Thu, 30 Mar 2023 10:31:57 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 821C49B403E4;
        Thu, 30 Mar 2023 10:31:56 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
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
In-Reply-To: <ZCUuMosWbyq1pK8R@shredder>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder> <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder> <87fs9ollmn.fsf@kapio-technology.com>
 <ZCUuMosWbyq1pK8R@shredder>
Date:   Thu, 30 Mar 2023 12:29:18 +0200
Message-ID: <87mt3u7csh.fsf@kapio-technology.com>
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

On Thu, Mar 30, 2023 at 09:37, Ido Schimmel <idosch@nvidia.com> wrote:
> On Tue, Mar 28, 2023 at 09:30:08PM +0200, Hans Schultz wrote:
>> 
>> Sorry, but I have sent you several emails telling you about the problems
>> I have with running the selftests due to changes in the phy etc. Maybe
>> you have just not received all those emails?
>> 
>> Have you checked spamfilters?
>> 
>> With the kernels now, I cannot even test with the software bridge and
>> selftests as the compile fails - probably due to changes in uapi headers
>> compared to what the packages my system uses expects.
>
> My spam filters are fine. I saw your emails where you basically said
> that you are too lazy to setup a VM to test your patches and that your
> time is more valuable than mine, which is why I should be testing them.
> Stop making your problems our problems. It's hardly the first time. If
> you are unable to test your patches, then invest the time in fixing your
> setup instead of submitting completely broken patches and making it our
> problem to test and fix them. I refuse to invest time in reviewing /
> testing / reworking your submissions as long as you insist on doing less
> than the bare minimum.
>
> Good luck

I never said or indicated that my time is more valuable than yours. I
have a VM to run these things that some have spent countless hours to
develop with the right tools etc installed and set up. Fixing that
system will take quite many hours for me, so I am asking for some simple
assistance from someone who already has a system running supporting the
newest kernel.

Alternatively if there is an open sourced system available that would be
great.

As this patch-set is for the community and some companies that would
like to use it and not for myself, I am asking for some help from the
community with a task that when someone has the system in place should
not take more than 15-20 minutes, maybe even less.
