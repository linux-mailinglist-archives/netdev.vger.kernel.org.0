Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210226D18E7
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCaHqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCaHqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:46:23 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30E1A943;
        Fri, 31 Mar 2023 00:46:18 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 63BFC188443E;
        Fri, 31 Mar 2023 07:46:15 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 3241325038AA;
        Fri, 31 Mar 2023 07:46:15 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 21C839B403F4; Fri, 31 Mar 2023 07:46:15 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 6920D91201E3;
        Fri, 31 Mar 2023 07:46:14 +0000 (UTC)
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
In-Reply-To: <20230330192714.oqosvifrftirshej@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder> <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder> <874jq22h2u.fsf@kapio-technology.com>
 <20230330192714.oqosvifrftirshej@skbuf>
Date:   Fri, 31 Mar 2023 09:43:34 +0200
Message-ID: <874jq1mkm1.fsf@kapio-technology.com>
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

On Thu, Mar 30, 2023 at 22:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 30, 2023 at 09:07:53PM +0200, Hans Schultz wrote:
>> Not true, it reveals that I forgot to put it in the patch, that's all. As
>> I cannot run several of these tests because of memory constraints I link
>> the file to a copy in a rw area where I modify the list and just run one
>> of the subtests at a time. If I try to run the whole it always fails
>> after a couple of sub-tests with an error.
>> 
>> It seems to me that these scripts are quite memory consuming as they
>> accumulate memory consuption in relation to what is loaded along the
>> way. A major problem with my system.
>
> I'm sorry for perhaps asking something entirely obvious, but have you tried:
>
> kernel-dir $ rsync -avr tools/testing/selftests/ root@$board:selftests/
> board $ cd selftests/drivers/net/dsa/
> board $ ./bridge_locked_port.sh lan0 lan1 lan2 lan3
>
> ?
>
> This is how I always run them, and it worked fine with both Debian
> (where it's easy to add missing packages to the rootfs) or with a more
> embedded-oriented Buildroot.

I am not entirely clear of your idea. You need somehow to boot into a
system with the patched net-next kernel or you have a virtual machine
boot into a virtual OS. I guess it is the last option you refer to using
Debian?
