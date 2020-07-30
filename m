Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F992337D8
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgG3RoP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Jul 2020 13:44:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:2231 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbgG3RoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 13:44:14 -0400
IronPort-SDR: 2PqVmivZlOVaOfefTYO7sJ/jLQ4iH9jQmuOrgjkGOv7+ngqXGpug5eYMqG4+hpCs17VSD9ml7d
 0f1pgn5bqJ4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="139207403"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="139207403"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 10:44:13 -0700
IronPort-SDR: LLE0pIPCWMK2uvzuGWWuf8DNOAp3Rsw1AIjkgDvt7B1Efsz2JLGrSmhBrXmTN+ZIw4CYRLydTX
 3waYlbdAwzJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="490737568"
Received: from kyoungil-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.108.110])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jul 2020 10:44:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Zhang\, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "fweisbec\@gmail.com" <fweisbec@gmail.com>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs\@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: =?utf-8?B?5Zue5aSNOg==?= INFO: rcu detected stall in
 tc_modify_qdisc
In-Reply-To: <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com>
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com> <87tuxqxhgq.fsf@intel.com> <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com>
Date:   Thu, 30 Jul 2020 10:44:12 -0700
Message-ID: <87pn8cyk2b.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Dmitry Vyukov <dvyukov@google.com> writes:

> On Wed, Jul 29, 2020 at 9:13 PM Vinicius Costa Gomes
> <vinicius.gomes@intel.com> wrote:
>>
>> Hi,
>>
>> "Zhang, Qiang" <Qiang.Zhang@windriver.com> writes:
>>
>> > ________________________________________
>> > 发件人: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> 代表 syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>
>> > 发送时间: 2020年7月29日 13:53
>> > 收件人: davem@davemloft.net; fweisbec@gmail.com; jhs@mojatatu.com; jiri@resnulli.us; linux-kernel@vger.kernel.org; mingo@kernel.org; netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tglx@linutronix.de; vinicius.gomes@intel.com; xiyou.wangcong@gmail.com
>> > 主题: INFO: rcu detected stall in tc_modify_qdisc
>> >
>> > Hello,
>> >
>> > syzbot found the following issue on:
>> >
>> > HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to_kern()
>> > git tree:       net
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=12925e38900000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=9f78d5c664a8c33f4cce
>> > compiler:       gcc (GCC) 10.1.0-syz 20200507
>> > syz repro:
>> > https://syzkaller.appspot.com/x/repro.syz?x=16587f8c900000
>>
>> It seems that syzkaller is generating an schedule with too small
>> intervals (3ns in this case) which causes a hrtimer busy-loop which
>> starves other kernel threads.
>>
>> We could put some limits on the interval when running in software mode,
>> but I don't like this too much, because we are talking about users with
>> CAP_NET_ADMIN and they have easier ways to do bad things to the system.
>
> Hi Vinicius,
>
> Could you explain why you don't like the argument if it's for CAP_NET_ADMIN?
> Good code should check arguments regardless I think and it's useful to
> protect root from, say, programming bugs rather than kill the machine
> on any bug and misconfiguration. What am I missing?

I admit that I am on the fence on that argument: do not let even root
crash the system (the point that my code is crashing the system gives
weight to this side) vs. root has great powers, they need to know what
they are doing.

The argument that I used to convince myself was: root can easily create
a bunch of processes and give them the highest priority and do
effectively the same thing as this issue, so I went with a the "they
need to know what they are doing side".

A bit more on the specifics here:

  - Using a small interval size, is only a limitation of the taprio
  software mode, when using hardware offloads (which I think most users
  do), any interval size (supported by the hardware) can be used;

  - Choosing a good lower limit for this seems kind of hard: something
  below 1us would never work well, I think, but things 1us < x < 100us
  will depend on the hardware/kernel config/system load, and this is the
  range includes "useful" values for many systems.

Perhaps a middle ground would be to impose a limit based on the link
speed, the interval can never be smaller than the time it takes to send
the minimum ethernet frame (for 1G links this would be ~480ns, should be
enough to catch most programming mistakes). I am going to add this and
see how it looks like.

Sorry for the brain dump :-)

>
> Also are we talking about CAP_NET_ADMIN in a user ns as well
> (effectively nobody)?

Just checked, we are talking about CAP_NET_ADMIN in user namespace as
well.


Cheers,
-- 
Vinicius
