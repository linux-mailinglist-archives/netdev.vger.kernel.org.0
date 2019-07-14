Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1975668110
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfGNTaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:30:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728701AbfGNTaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:30:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6EJRPci036570
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 15:29:59 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tr7y1bwka-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 15:29:59 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sun, 14 Jul 2019 20:29:58 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Jul 2019 20:29:53 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6EJTqVB27066838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Jul 2019 19:29:52 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0161BB2065;
        Sun, 14 Jul 2019 19:29:52 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8E70B205F;
        Sun, 14 Jul 2019 19:29:51 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.203.247])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Jul 2019 19:29:51 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 6F92F16C8FBA; Sun, 14 Jul 2019 12:29:51 -0700 (PDT)
Date:   Sun, 14 Jul 2019 12:29:51 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Theodore Ts'o" <tytso@mit.edu>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Reply-To: paulmck@linux.ibm.com
References: <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714190522.GA24049@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071419-0064-0000-0000-000003FB8FF5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011428; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232183; UDB=6.00649155; IPR=6.01013476;
 MB=3.00027716; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-14 19:29:57
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071419-0065-0000-0000-00003E42BA00
Message-Id: <20190714192951.GM26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907140243
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 03:05:22PM -0400, Theodore Ts'o wrote:
> On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > But short term I don't see any other solution than stop testing
> > sched_setattr because it does not check arguments enough to prevent
> > system misbehavior. Which is a pity because syzkaller has found some
> > bad misconfigurations that were oversight on checking side.
> > Any other suggestions?
> 
> Or maybe syzkaller can put its own limitations on what parameters are
> sent to sched_setattr?  In practice, there are any number of ways a
> root user can shoot themselves in the foot when using sched_setattr or
> sched_setaffinity, for that matter.  I imagine there must be some such
> constraints already --- or else syzkaller might have set a kernel
> thread to run with priority SCHED_BATCH, with similar catastrophic
> effects --- or do similar configurations to make system threads
> completely unschedulable.
> 
> Real time administrators who know what they are doing --- and who know
> that their real-time threads are well behaved --- will always want to
> be able to do things that will be catastrophic if the real-time thread
> is *not* well behaved.  I don't it is possible to add safety checks
> which would allow the kernel to automatically detect and reject unsafe
> configurations.
> 
> An apt analogy might be civilian versus military aircraft.  Most
> airplanes are designed to be "inherently stable"; that way, modulo
> buggy/insane control systems like on the 737 Max, the airplane will
> automatically return to straight and level flight.  On the other hand,
> some military planes (for example, the F-16, F-22, F-36, the
> Eurofighter, etc.) are sometimes designed to be unstable, since that
> way they can be more maneuverable.
> 
> There are use cases for real-time Linux where this flexibility/power
> vs. stability tradeoff is going to argue for giving root the
> flexibility to crash the system.  Some of these systems might
> literally involve using real-time Linux in military applications,
> something for which Paul and I have had some experience.  :-)
> 
> Speaking of sched_setaffinity, one thing which we can do is have
> syzkaller move all of the system threads to they run on the "system
> CPU's", and then move the syzkaller processes which are testing the
> kernel to be on the "system under test CPU's".  Then regardless of
> what priority the syzkaller test programs try to run themselves at,
> they can't crash the system.
> 
> Some real-time systems do actually run this way, and it's a
> recommended configuration which is much safer than letting the
> real-time threads take over the whole system:
> 
> http://linuxrealtime.org/index.php/Improving_the_Real-Time_Properties#Isolating_the_Application

Good point!  We might still have issues with some per-CPU kthreads,
but perhaps use of nohz_full would help at least reduce these sorts
of problems.  (There could still be issues on CPUs with more than
one runnable threads.)

							Thanx, Paul

