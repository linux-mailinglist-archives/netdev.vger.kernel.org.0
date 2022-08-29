Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320745A4B81
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiH2MWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiH2MVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:21:52 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171E7AC27;
        Mon, 29 Aug 2022 05:06:04 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 0D4FD1884A19;
        Mon, 29 Aug 2022 12:04:43 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id F05AD25032B8;
        Mon, 29 Aug 2022 12:04:42 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E3B269EC000C; Mon, 29 Aug 2022 12:04:42 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 14:04:42 +0200
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
In-Reply-To: <Ywyj1VF1wlYqlHb6@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
 <7654860e4d7d43c15d482c6caeb6a773@kapio-technology.com>
 <YwxtVhlPjq+M9QMY@shredder>
 <2967ccc234bb672f5440a4b175b73768@kapio-technology.com>
 <Ywyj1VF1wlYqlHb6@shredder>
User-Agent: Gigahost Webmail
Message-ID: <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
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

On 2022-08-29 13:32, Ido Schimmel wrote:
>> The final decision on this rests with you I would say.
> 
> If the requirement for this feature (with or without MAB) is to work
> with dynamic entries (which is not what is currently implemented in the
> selftests), then learning needs to be enabled for the sole reason of
> refreshing the dynamic entries added by user space. That is, updating
> 'fdb->updated' with current jiffies value.
> 
> So, is this the requirement? I checked the hostapd fork you posted some
> time ago and I get the impression that the answer is yes [1], but I 
> want
> to verify I'm not missing something.
> 
> [1] 
> https://github.com/westermo/hostapd/commit/95dc96f9e89131b2319f5eae8ae7ac99868b7cd0#diff-338b6fad34b4bdb015d7d96930974bd96796b754257473b6c91527789656d6edR11
> 
> 

I cannot say that it is a requirement with respect to the bridge 
implementation, but it is with the driver implementation. But you are 
right that it is to be used with dynamic entries.

>> > # ip link set dev swp1 up
>> > # ip link set dev swp2 up
>> > # ip link set dev br0 up
>> >
>> > 2. Assuming h1 behind swp1 was authorized using 802.1X:
>> >
>> > # bridge fdb replace $H1_MAC dev swp1 master dynamic
>> 
>> With the new MAB flag 'replace' is not needed when MAB is not enabled.
> 
> Yes, but replace works in both cases.
> 

Yes, of course.

>> 
>> >
>> > 3. Assuming 802.1X authentication failed for h2 behind swp2, enable MAB:
>> >
>> > # bridge link set dev swp2 mab on
>> >
>> > 4. Assuming $H2_MAC is in our allow list:
>> >
>> > # bridge fdb replace $H2_MAC dev swp2 master dynamic
>> >
>> > Learning is on in order to refresh the dynamic entries that user space
>> > installed.
>> 
>> Yes, port association is needed for those reasons. :-)
> 
> Given that the current tests use "static" entries that cannot age, is
> there a reason to have "learning on"?
> 

Port association is needed for MAB to work at all on mv88e6xxx, but for 
802.1X port association is only needed for dynamic ATU entries.

>> 
>> >
>> > (*) Need to add support for this option in iproute2. Already exposed
>> > over netlink (see 'IFLA_BR_MULTI_BOOLOPT').
>> 
>> Should I do that in this patch set?
> 
> No, I'm saying that this option is already exposed over netlink, but
> missing iproute2 support. No kernel changes needed.

Oh yes, I meant in the iproute2 accompanying patch set to this one?
