Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69715BEF27
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiITV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiITV3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:29:44 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064DEBC17;
        Tue, 20 Sep 2022 14:29:39 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id E87CF18845FF;
        Tue, 20 Sep 2022 21:29:12 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id D3A51250007B;
        Tue, 20 Sep 2022 21:29:12 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id C5ED9A0A1E65; Tue, 20 Sep 2022 21:29:12 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 20 Sep 2022 23:29:12 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
In-Reply-To: <Yx73FOpN5uhPQhFl@shredder>
References: <YwzjPcQjfLPk3q/k@shredder>
 <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
 <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
 <20220911001346.qno33l47i6nvgiwy@skbuf>
 <15ee472a68beca4a151118179da5e663@kapio-technology.com>
 <Yx73FOpN5uhPQhFl@shredder>
User-Agent: Gigahost Webmail
Message-ID: <086704ce7f323cc1b3cca78670b42095@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-12 11:08, Ido Schimmel wrote:
> On Sun, Sep 11, 2022 at 11:23:55AM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-09-11 02:13, Vladimir Oltean wrote:
>> > On Fri, Sep 09, 2022 at 03:11:56PM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > > > > On Wed, Sep 07, 2022 at 11:10:07PM +0200, netdev@kapio-technology.com wrote:
>> > > > > > > I am at the blackhole driver implementation now, as I suppose that the
>> > > > > > > iproute2 command should work with the mv88e6xxx driver when adding blackhole
>> > > > > > > entries (with a added selftest)?
>> > > > > > > I decided to add the blackhole feature as new ops for drivers with functions
>> > > > > > > blackhole_fdb_add() and blackhole_fdb_del(). Do you agree with that approach?
>> > > > > >
>> > > > > > I assume you are talking about extending 'dsa_switch_ops'?
>> > > > >
>> > > > > Yes, that is the idea.
>> > > > >
>> > > > > > If so, it's up to the DSA maintainers to decide.
>> > > >
>> > > > What will be the usefulness of adding a blackhole FDB entry from user
>> > > > space?
>> > >
>> > > With the software bridge it could be used to signal a untrusted host
>> > > in
>> > > connection with a locked port entry attempt. I don't see so much use
>> > > other
>> > > that test purposes with the driver though.
>> >
>> > Not a huge selling point, to be honest. Can't the blackhole flag remain
>> > settable only in the device -> bridge direction, with user space just
>> > reading it?
>> 
>> That is possible, but it would of course not make sense to have 
>> selftests of
>> the feature as that would not work unless there is a driver with this
>> capability (now just mv88e6xxx).
> 
> The new "blackhole" flag requires changes in the bridge driver and
> without allowing user space to add such entries, the only way to test
> these changes is with mv88e6xxx which many of us do not have...

I am now building from new system (comp), and the kernel selftests are 
not being installed correctly, so I haven't been able to run the 
selftests yet.

I have made a blackhole selftest, which looks like this:

test_blackhole_fdb()
{
         RET=0

         check_blackhole_fdb_support || return 0

         tcpdump_start $h2
         $MZ $h1 -q -t udp -a $h1 -b $h2
         tcpdump_stop
         tcpdump_show | grep -q udp
         check_err $? "test_blackhole_fdb: No packet seen on initial"
         tcpdump_cleanup

         bridge fdb add `mac_get $h2` dev br0 blackhole
         bridge fdb show dev br0 | grep -q "blackhole"
         check_err $? "test_blackhole_fdb: No blackhole FDB entry found"

         tcpdump_start $h2
         $MZ $h1 -q -t udp -a $h1 -b $h2
         tcpdump_stop
         tcpdump_show | grep -q udp
         check_fail $? "test_blackhole_fdb: packet seen with blackhole 
fdb entry"
         tcpdump_cleanup

         bridge fdb del `mac_get $h2` dev br0 blackhole
         bridge fdb show dev br0 | grep -q "blackhole"
         check_fail $? "test_blackhole_fdb: Blackhole FDB entry not 
deleted"

         tcpdump_start $h2
         $MZ $h1 -q -t udp -a $h1 -b $h2
         tcpdump_stop
         tcpdump_show | grep -q udp
         check_err $? "test_blackhole_fdb: No packet seen after removing 
blackhole FDB entry"
         tcpdump_cleanup

         log_test "Blackhole FDB entry test"
}

the setup is simple and is the same as in bridge_sticky_fdb.sh.

Does the test look sound or is there obvious mistakes?
