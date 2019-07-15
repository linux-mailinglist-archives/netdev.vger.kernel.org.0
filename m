Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2315A68E0E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733196AbfGOOD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:03:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732992AbfGOOD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 10:03:28 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6FDvLNY074365
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:03:27 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2trscfd5bf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:03:27 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 15 Jul 2019 15:03:23 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 15 Jul 2019 15:03:18 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6FE3HgH24969604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 14:03:17 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15BAAB2068;
        Mon, 15 Jul 2019 14:03:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1686B2067;
        Mon, 15 Jul 2019 14:03:16 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.164.210])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 14:03:16 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 988F216C3641; Mon, 15 Jul 2019 07:03:16 -0700 (PDT)
Date:   Mon, 15 Jul 2019 07:03:16 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
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
Reply-To: paulmck@linux.ibm.com
References: <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu>
 <20190714192951.GM26519@linux.ibm.com>
 <20190715031027.GA3336@linux.ibm.com>
 <20190715130101.GA5527@linux.ibm.com>
 <20190715133938.GH3419@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715133938.GH3419@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071514-2213-0000-0000-000003AF0900
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011432; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232545; UDB=6.00649377; IPR=6.01013847;
 MB=3.00027724; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-15 14:03:21
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071514-2214-0000-0000-00005F3E4521
Message-Id: <20190715140316.GR26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 03:39:38PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2019 at 06:01:01AM -0700, Paul E. McKenney wrote:
> > Title: Making SCHED_DEADLINE safe for kernel kthreads
> > 
> > Abstract:
> > 
> > Dmitry Vyukov's testing work identified some (ab)uses of sched_setattr()
> > that can result in SCHED_DEADLINE tasks starving RCU's kthreads for
> > extended time periods, not millisecond, not seconds, not minutes, not even
> > hours, but days. Given that RCU CPU stall warnings are issued whenever
> > an RCU grace period fails to complete within a few tens of seconds,
> > the system did not suffer silently. Although one could argue that people
> > should avoid abusing sched_setattr(), people are human and humans make
> > mistakes. Responding to simple mistakes with RCU CPU stall warnings is
> > all well and good, but a more severe case could OOM the system, which
> > is a particularly unhelpful error message.
> > 
> > It would be better if the system were capable of operating reasonably
> > despite such abuse. Several approaches have been suggested.
> > 
> > First, sched_setattr() could recognize parameter settings that put
> > kthreads at risk and refuse to honor those settings. This approach
> > of course requires that we identify precisely what combinations of
> > sched_setattr() parameters settings are risky, especially given that there
> > are likely to be parameter settings that are both risky and highly useful.
> 
> So we (the people poking at the DEADLINE code) are all aware of this,
> and on the TODO list for making DEADLINE available for !priv users is
> the item:
> 
>   - put limits on deadline/period
> 
> And note that that is both an upper and lower limit. The upper limit
> you've just found why we need it, the lower limit is required because
> you can DoS the hardware by causing deadlines/periods that are equal (or
> shorter) than the time it takes to program the hardware.
> 
> There might have even been some patches that do some of this, but I've
> held off because we have bigger problems and they would've established
> an ABI while it wasn't clear it was sufficient or the right form.

So I should withdraw the proposal?

							Thanx, Paul

