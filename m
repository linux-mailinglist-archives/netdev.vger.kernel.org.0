Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2E6CCAEB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 21:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjC1TsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 15:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC1TsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 15:48:06 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DF2172C;
        Tue, 28 Mar 2023 12:48:04 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3DEC318839E9;
        Tue, 28 Mar 2023 19:48:03 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 369182500389;
        Tue, 28 Mar 2023 19:48:03 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 2E8489B403E2; Tue, 28 Mar 2023 19:48:03 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 7BA9491201E3;
        Tue, 28 Mar 2023 19:48:02 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Ido Schimmel <idosch@nvidia.com>,
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
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
In-Reply-To: <20230328114943.4mibmn2icutcio4m@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-3-netdev@kapio-technology.com>
 <20230327115206.jk5q5l753aoelwus@skbuf>
 <87355qb48h.fsf@kapio-technology.com>
 <20230327160009.bdswnalizdv2u77z@skbuf>
 <87pm8tooe1.fsf@kapio-technology.com>
 <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
Date:   Tue, 28 Mar 2023 21:45:26 +0200
Message-ID: <87cz4slkx5.fsf@kapio-technology.com>
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

On Tue, Mar 28, 2023 at 14:49, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 28, 2023 at 01:04:23PM +0200, Hans Schultz wrote:
>> On Tue, Mar 28, 2023 at 01:59, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >
>> > which idea is that, again?
>> 
>> So I cannot us the offloaded flag as it is added by DSA in the common
>> case when using 'bridge fdb replace ... dynamic'.
>
> Why not? I find it reasonable that the software bridge does not age out
> a dynamic FDB entry that is offloaded to hardware... the hardware should
> do that ("dynamic" being the key).

So the solution would be to not let the DSA layer send the
SWITCHDEV_FDB_OFFLOADED event in the case when the new dynamic flag is
set?
Thus other drivers that don't support the flag yet will install a
static entry in HW and the bridge will age it out as there is no offloaded
flag on. For the mv88e6xxx it will set the offloaded flag and HW will
age it.

> At least, I find it more reasonable
> than the current behavior, where the bridge notifies dynamic FDB entries
> to switchdev, but doesn't say they're dynamic, and switchdev treats them
> as static, so they don't roam from one bridge port to another until
> software sees a packet with that MAC DA, and they have the potential of
> blocking traffic because of that.
>
