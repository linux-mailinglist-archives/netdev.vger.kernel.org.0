Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378B868A5E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfGONXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:23:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbfGONXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yQyxE1Ka8nS34umw3hpmbSbzTCZ5gJ0CQHD8yI5d4wk=; b=VRX6bsGYqh416y4aHeiEW2HRR
        6U+RV1QBT3iWnePTvztjbiwJ6Dw1g4V6gbHjzBquAlktAysb5xe8Elj+DFs/+zggxWT4mL7Sm2Ri5
        fHm4Q3muM/TT7s8uHEZfI70HDeRCRWYEzUCENr9fMWYdA63nqnjrRWx91eXlxaIDQNTzqW9m0MR8H
        PiPSxpcQBnL8UqCTkAi8AkD1LfO+EmBF6e28iKnYFl/NiGMmIAAw8YDMqedVqmBPUk4LzAP78wZZL
        831kS76LQRdcs4aLioKEbymcdcm/qRxDfp5LLGAk6VxfPdhX05NjUDTegHXjehwZmYDinafYHbHD5
        g/l0dv4DQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hn0wO-0006PM-LJ; Mon, 15 Jul 2019 13:22:52 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E508120A7A4EF; Mon, 15 Jul 2019 15:22:50 +0200 (CEST)
Date:   Mon, 15 Jul 2019 15:22:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190715132250.GF3419@hirez.programming.kicks-ass.net>
References: <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707011655.GA22081@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 06:16:55PM -0700, Paul E. McKenney wrote:
> 4.	SCHED_DEADLINE treats the other three scheduling classes as each
> 	having a period, deadline, and a modest CPU consumption budget
> 	for the members of the class in aggregate.  But this has to have
> 	been discussed before.  How did that go?

Yeah; this has been proposed a number of times; and I think everybody
agrees that it is a good idea, but nobody has so far sat down and wrote
the patches.

Or rather; we would've gotten this for 'free' with the rt-cgroup
rewrite, but that's been stuck forever due to affinity being difficult.

