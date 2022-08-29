Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D420E5A512E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiH2QN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiH2QNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:13:23 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8641844D7;
        Mon, 29 Aug 2022 09:13:17 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3FDD418848CD;
        Mon, 29 Aug 2022 16:13:15 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 36E6B25032B7;
        Mon, 29 Aug 2022 16:13:15 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 26D919EC0004; Mon, 29 Aug 2022 16:13:15 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 18:13:14 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <YwzjPcQjfLPk3q/k@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
 <7654860e4d7d43c15d482c6caeb6a773@kapio-technology.com>
 <YwxtVhlPjq+M9QMY@shredder>
 <2967ccc234bb672f5440a4b175b73768@kapio-technology.com>
 <Ywyj1VF1wlYqlHb6@shredder>
 <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
 <YwzPJ2oCYJQHOsXD@shredder>
 <69db7606896c77924c11a6c175c4b1a6@kapio-technology.com>
 <YwzjPcQjfLPk3q/k@shredder>
User-Agent: Gigahost Webmail
Message-ID: <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-29 18:03, Ido Schimmel wrote:
> On Mon, Aug 29, 2022 at 05:08:23PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-08-29 16:37, Ido Schimmel wrote:
>> > On Mon, Aug 29, 2022 at 02:04:42PM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > On 2022-08-29 13:32, Ido Schimmel wrote:
>> > > Port association is needed for MAB to work at all on mv88e6xxx, but
>> > > for
>> > > 802.1X port association is only needed for dynamic ATU entries.
>> >
>> > Ageing of dynamic entries in the bridge requires learning to be on as
>> > well, but in these test cases you are only using static entries and
>> > there is no reason to enable learning in the bridge for that. I prefer
>> > not to leak this mv88e6xxx implementation detail to user space and
>> > instead have the driver enable port association based on whether
>> > "learning" or "mab" is on.
>> >
>> 
>> Then it makes most sense to have the mv88e6xxx driver enable port
>> association when then port is locked, as it does now.
> 
> As you wish, but like you wrote "802.1X port association is only needed
> for dynamic ATU entries" and in this case user space needs to enable
> learning (for refresh only) so you can really key off learning on
> "learning || mab". User space can decide to lock the port and work with
> static entries and then learning is not required.

I will of course remove all "learning on" in the selftests, which is 
what I think you are referring to. In the previous I am referring to the 
code in the driver itself which I understand shall turn on port 
association with locked ports, e.g. no need for "learning on" when using 
the feature in general outside selftests...
