Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5FE6DA95E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 09:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbjDGHWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 03:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjDGHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 03:22:46 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22302A26D;
        Fri,  7 Apr 2023 00:22:39 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Pt8vB3ZVHzKrDv;
        Fri,  7 Apr 2023 15:21:58 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 7 Apr 2023 15:22:36 +0800
Message-ID: <1ddf7fc8-bcb3-ab48-4894-24158e8a9d0f@huawei.com>
Date:   Fri, 7 Apr 2023 15:22:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [syzbot] kernel panic: kernel stack overflow
To:     Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jarod Wilson <jarod@redhat.com>
CC:     syzbot <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <000000000000c8900705ead19e41@google.com>
 <CACT4Y+Zuoo_rgf=DP90wgSVm909Qboj5kdYQjZELPDfdkQWJqA@mail.gmail.com>
 <CANn89iLkk75vy6fKMzwQXFEBdyTrQghnFKSxR3HPaeWS4oT+8g@mail.gmail.com>
 <f22f16ec-e78b-bf9e-ea43-5232b2403fa1@gmail.com>
 <8bac748a-3309-b249-c098-f0a86ed7d384@gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <8bac748a-3309-b249-c098-f0a86ed7d384@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/10/21 19:08, Taehee Yoo 写道:
> Hi,
> 
> 2022. 10. 14. 오전 12:00에 Taehee Yoo 이(가) 쓴 글:
>  > Hi,
>  >
>  > On 10/12/22 21:19, Eric Dumazet wrote:
>  >  > On Wed, Oct 12, 2022 at 12:53 AM Dmitry Vyukov <dvyukov@google.com>
>  > wrote:
>  >  >>
>  >  >> On Wed, 12 Oct 2022 at 09:48, syzbot
>  >  >> <syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com> wrote:
>  >  >>>
>  >  >>> Hello,
>  >  >>>
>  >  >>> syzbot found the following issue on:
>  >  >>>
>  >  >>> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into
>  > for-kernelci
>  >  >>> git tree:
>  > git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git 
> for-kernelci
>  >  >>> console output:
>  > https://syzkaller.appspot.com/x/log.txt?x=14a03a2a880000
>  >  >>> kernel config:
>  > https://syzkaller.appspot.com/x/.config?x=aae2d21e7dd80684
>  >  >>> dashboard link:
>  > https://syzkaller.appspot.com/bug?extid=60748c96cf5c6df8e581
>  >  >>> compiler:       Debian clang version
>  > 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld
>  > (GNU Binutils for Debian) 2.35.2
>  >  >>> userspace arch: arm64
>  >  >>>
>  >  >>> Unfortunately, I don't have any reproducer for this issue yet.
>  >  >>>
>  >  >>> Downloadable assets:
>  >  >>> disk image:
>  > 
> https://storage.googleapis.com/syzbot-assets/11078f50b80b/disk-bbed346d.raw.xz
>  >
>  >  >>> vmlinux:
>  > 
> https://storage.googleapis.com/syzbot-assets/398e5f1e6c84/vmlinux-bbed346d.xz
>  >
>  >  >>>
>  >  >>> IMPORTANT: if you fix the issue, please add the following tag to
>  > the commit:
>  >  >>> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
>  >  >>
>  >  >> +Jiri
>  >  >>
>  >  >> It looks like the issue is with the team device. It seems to call
>  >  >> itself infinitely.
>  >  >> team_device_event was mentioned in stack overflow bugs in the past:
>  >  >>
>  > 
> https://groups.google.com/g/syzkaller-bugs/search?q=%22team_device_event%22
>  >  >>
>  >  >
>  >  >
>  >  > Taehee Yoo, can you take a look ?
>  >  >
>  >  > Patch series of yours was supposed to limit max nest level to 8
>  >  >
>  >  >
>  > 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=65921376425fc9c8b7ce647e1f7989f7cdf5dd70
>  >
>  >  >
>  >
>  > I found a reproducer.
>  >
>  > #test_team.sh
>  > ip link add dummy0 type dummy
>  > ip link set dummy0 up
>  > for a1 in {0..1}
>  > do
>  >          ip link add team$a1 type team
>  >          for a2 in {0..1}
>  >          do
>  >                  ip link add team$a1$a2 master team$a1 type team
>  >                  for a3 in {0..1}
>  >                  do
>  >                          ip link add team$a1$a2$a3 master team$a1$a2
>  > type team
>  >                          for a4 in {0..1}
>  >                          do
>  >                                  ip link add team$a1$a2$a3$a4 master
>  > team$a1$a2$a3 type team
>  >                                  for a5 in {0..1}
>  >                                  do
>  >                                          ip link add team$a1$a2$a3$a4$a5
>  > master team$a1$a2$a3$a4 type team
>  >                                          for a6 in {0..1}
>  >                                          do
>  >                                                  ip link add
>  > team$a1$a2$a3$a4$a5$a6 master team$a1$a2$a3$a4$a5 type team
>  >                                                  ip link add
>  > macvlan$a1$a2$a3$a4$a5$a6 link dummy0 master team$a1$a2$a3$a4$a5$a6 type
>  > macvlan
>  >                                                  ip link set
>  > macvlan$a1$a2$a3$a4$a5$a6 up
>  >                                                  ip link set
>  > team$a1$a2$a3$a4$a5$a6 up
>  >                                          done
>  >                                          ip link set 
> team$a1$a2$a3$a4$a5 up
>  >                                  done
>  >                                  ip link set team$a1$a2$a3$a4 up
>  >                          done
>  >                          ip link set team$a1$a2$a3 up
>  >                  done
>  >                  ip link set team$a1$a2 up
>  >          done
>  >          ip link set team$a1 up
>  > done
>  >
>  > #test_ethtool.sh
>  > for a1 in {0..1}
>  > do
>  >          ethtool -K team$a1 lro $1
>  >          for a2 in {0..1}
>  >          do
>  >                  ethtool -K team$a1$a2 lro $1
>  >                  for a3 in {0..1}
>  >                  do
>  >                          ethtool -K team$a1$a2$a3 lro $1
>  >                          for a4 in {0..1}
>  >                          do
>  >                                  ethtool -K team$a1$a2$a3$a4 lro $1
>  >                                  for a5 in {0..1}
>  >                                  do
>  >                                          ethtool -K team$a1$a2$a3$a4$a5
>  > lro $1
>  >                                          for a6 in {0..1}
>  >                                          do
>  >                                                  ethtool -K
>  > team$a1$a2$a3$a4$a5$a6 lro $1
>  >                                                  ethtool -K
>  > macvlan$a1$a2$a3$a4$a5$a6 lro $1
>  >                                          done
>  >                                  done
>  >                          done
>  >                  done
>  >          done
>  > done
>  >
>  > shell#1
>  > bash test_team.sh
>  > while :
>  > do
>  > bash test_ethtool.sh on
>  > done
>  > shell#2
>  > while :
>  > do
>  > bash test_ethtool.sh off
>  > done
>  >
>  > We can see a very similar call trace with the above reproducer.
>  > I think it is the same issue.
>  > Could you please test it?
>  >
>  > And, I found the fixed same issue too.
>  > 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.0&id=dd912306ff008891c82cd9f63e8181e47a9cb2fb
>  >
>  > https://groups.google.com/g/syzkaller-bugs/c/-5OV1OW-dS4/m/o2Oq6AYSAwAJ
>  >
> 
> I found the root cause of this issue.
> 
> This is simpler reproducer.
> 
> ip link add team0 type team
> ethtool -K team0 lro on
> for i in {1..100}
> do
>          ip link add team$i master team0 type team
>          ethtool -K team$i lro on
> done
> 
> ethtool -K team0 lro off
> 
> The above graph is like below:
>         team0
>           |
>    +------+------+-----+-----+
>    |      |      |     |     |
> team1  team2  team3  ...  team100
> 
> int __netdev_update_features(struct net_device *dev)
> {
>          struct net_device *upper, *lower;
>          netdev_features_t features;
>          struct list_head *iter;
>          int err = -1;
> ...
> sync_lower:
>          /* some features must be disabled on lower devices when disabled
>           * on an upper device (think: bonding master or bridge)
>           */
>          netdev_for_each_lower_dev(dev, lower, iter)
>                  netdev_sync_lower_features(dev, lower, features);
> ...
> 
> 
> static void netdev_sync_lower_features(struct net_device *upper,
>          struct net_device *lower, netdev_features_t features)
> {
>          netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
>          netdev_features_t feature;
>          int feature_bit;
> 
>          for_each_netdev_feature(upper_disables, feature_bit) {
>                  feature = __NETIF_F_BIT(feature_bit);
>                  if (!(features & feature) && (lower->features & 
> feature)) {
>                          netdev_dbg(upper, "Disabling feature %pNF on 
> lower dev %s.\n",
>                                     &feature, lower->name);
>                          lower->wanted_features &= ~feature;
>                          __netdev_update_features(lower);
> 
>                          if (unlikely(lower->features & feature))
>                                  netdev_WARN(upper, "failed to disable 
> %pNF on %s!\n",
>                                              &feature, lower->name);
>                          else
>                                  netdev_features_change(lower);<-----HERE
>                  }
>          }
> }
> 
> void netdev_features_change(struct net_device *dev)
> {
>          call_netdevice_notifiers(NETDEV_FEAT_CHANGE, dev);
> }
> 
> The code looks like an iterator.
> But it would work recursively because of notification.
> 
> When team0's feature(LRO) is changed with <ethtool -K team0 lro off>", 
> __netdev_update_features(team0) is called.
> __netdev_update_features(team0) internally sends NETDEV_FEAT_CHANGE 
> event to all lower interfaces(team1, team2, ... team100).
> team1 will receive NETDEV_FEAT_CHANGE, and it sends NETDEV_FEAT_CHANGE 
> to the upper interface(team0).
> team0 will receive NETDEV_FEAT_CHANGE again, and it sends 
> NETDEV_FEAT_CHANGE to the all lower interfaces(team1, team2, ... team100).
> (At this point, team1 flag was already set, so it will be skipped.)
> team2 will receive NETDEV_FEAT_CHANGE, and it sends NETDEV_FEAT_CHANGE 
> to the upper interface(team0).
> team0 will receive NETDEV_FEAT_CHANGE again again, and it sends 
> NETDEV_FEAT_CHANGE to the all lower interfaces(team1, team2, ... team100).
> (team1, team2 skipped.)
> ...
> So, if there are a few lower interfaces(roughly under 30 lower 
> interfaces), it anyway works even if internally works recursively.
> But so many lower interfaces exist, stack overflow will occur.
> This is the root cause of this issue.
> 
> I think synchronization direction should be one way.
> Up or Down.
> It means that if the team0 interface can send the NETDEV_FEAT_CHANGE 
> notification event to the lower interface,
> the lower interfaces should be disallowed to send NETDEV_FEAT_CHANGE 
> event to the upper interface.
> 
> bonding has same issue.

Excuse me, is there a fix for this issue? I had the same issue with the 
5.10 version of the bonding.


