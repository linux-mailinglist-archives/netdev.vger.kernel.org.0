Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611C32D6C92
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403811AbgLKA2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:28:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:29947 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393591AbgLKA2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 19:28:17 -0500
IronPort-SDR: ZWlqEcNOg0wJgZb1m15NBDjVqIZugm+igkximO+pCsJqKcR2fpdArDqW4potDWX054Onh/5P8l
 H12EIyo4PzIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="174470813"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="174470813"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 16:27:35 -0800
IronPort-SDR: tvVHqrN1TnFQbGq+Bq70v0VXsh9jqG5jjJ3AafOQdjDSgRCsLQWmkqsQi1qC/UyvLkWpTK35kl
 YzdCSenY8LHQ==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="408854326"
Received: from fchin-mobl.amr.corp.intel.com (HELO ellie) ([10.212.125.148])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 16:27:32 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vedang Patel <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
In-Reply-To: <CAF=yD-Lf=JpkXvGs=AGtyhCEFcG_8_WgnNbg1cbGownohsHw8g@mail.gmail.com>
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
 <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-LkknU3GwJgG_OiMPFONZtO3ECHEX0QfTaUTTX_N0i-KA@mail.gmail.com>
 <VI1PR10MB24460D805E8091EB09F81199ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-Lf=JpkXvGs=AGtyhCEFcG_8_WgnNbg1cbGownohsHw8g@mail.gmail.com>
Date:   Thu, 10 Dec 2020 16:27:33 -0800
Message-ID: <87r1nxxk3u.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> writes:

>> > If I understand correctly, you are trying to achieve a single delivery time.
>> > The need for two separate timestamps passed along is only because the
>> > kernel is unable to do the time base conversion.
>>
>> Yes, a correct point.
>>
>> >
>> > Else, ETF could program the qdisc watchdog in system time and later,
>> > on dequeue, convert skb->tstamp to the h/w time base before
>> > passing it to the device.
>>
>> Or the skb->tstamp is HW time-stamp and the ETF convert it to system clock based.
>>
>> >
>> > It's still not entirely clear to me why the packet has to be held by
>> > ETF initially first, if it is held until delivery time by hardware
>> > later. But more on that below.
>>
>> Let plot a simple scenario.
>> App A send a packet with time-stamp 100.
>> After arrive a second packet from App B with time-stamp 90.
>> Without ETF, the second packet will have to wait till the interface hardware send the first packet on 100.
>> Making the second packet late by 10 + first packet send time.
>> Obviously other "normal" packets are send to the non-ETF queue, though they do not block ETF packets
>> The ETF delta is a barrier that the application have to send the packet before to ensure the packet do not tossed.
>
> Got it. The assumption here is that devices are FIFO. That is not
> necessarily the case, but I do not know whether it is in practice,
> e.g., on the i210.

On the i210 and i225, that's indeed the case, i.e. only the launch time
of the packet at the front of the queue is considered.

[...]

>> >>>>> It only requires that pacing qdiscs, both sch_etf and sch_fq,
>> >>>>> optionally skip queuing in their .enqueue callback and instead allow
>> >>>>> the skb to pass to the device driver as is, with skb->tstamp set. Only
>> >>>>> to devices that advertise support for h/w pacing offload.
>> >>>>>
>> >>>> I did not use "Fair Queue traffic policing".
>> >>>> As for ETF, it is all about ordering packets from different applications.
>> >>>> How can we achive it with skiping queuing?
>> >>>> Could you elaborate on this point?
>> >>>
>> >>> The qdisc can only defer pacing to hardware if hardware can ensure the
>> >>> same invariants on ordering, of course.
>> >>
>> >> Yes, this is why we suggest ETF order packets using the hardware time-stamp.
>> >> And pass the packet based on system time.
>> >> So ETF query the system clock only and not the PHC.
>> >
>> > On which note: with this patch set all applications have to agree to
>> > use h/w time base in etf_enqueue_timesortedlist. In practice that
>> > makes this h/w mode a qdisc used by a single process?
>>
>> A single process theoretically does not need ETF, just set the skb-> tstamp and use a pass through queue.
>> However the only way now to set TC_SETUP_QDISC_ETF in the driver is using ETF.
>
> Yes, and I'd like to eventually get rid of this constraint.
>

I'm interested in these kind of ideas :-)

What would be your end goal? Something like:
 - Any application is able to set SO_TXTIME;
 - We would have a best effort support for scheduling packets based on
 their transmission time enabled by default;
 - If the hardware supports, there would be a "offload" flag that could
 be enabled;

More or less this?


Cheers.
-- 
Vinicius
