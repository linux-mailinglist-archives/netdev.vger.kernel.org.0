Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E191760910
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGEPRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:17:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726851AbfGEPRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:17:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x65FF8I9073561
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 11:17:04 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tj7d64hjp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 11:17:03 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 5 Jul 2019 16:17:03 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 5 Jul 2019 16:16:57 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x65FGulm38011348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jul 2019 15:16:56 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A237CB2067;
        Fri,  5 Jul 2019 15:16:56 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C56AB2064;
        Fri,  5 Jul 2019 15:16:56 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.224])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jul 2019 15:16:56 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 7E18316C40FB; Fri,  5 Jul 2019 08:16:58 -0700 (PDT)
Date:   Fri, 5 Jul 2019 08:16:58 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
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
References: <000000000000d3f34b058c3d5a4f@google.com>
 <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu>
 <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19070515-0064-0000-0000-000003F79AE7
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011383; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01227834; UDB=6.00646515; IPR=6.01009075;
 MB=3.00027598; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-05 15:17:01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070515-0065-0000-0000-00003E269009
Message-Id: <20190705151658.GP26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907050185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 03:24:26PM +0200, Dmitry Vyukov wrote:
> On Thu, Jun 27, 2019 at 12:47 AM Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > More details about what is going on.  First, it requires root, because
> > one of that is required is using sched_setattr (which is enough to
> > shoot yourself in the foot):
> >
> > sched_setattr(0, {size=0, sched_policy=0x6 /* SCHED_??? */, sched_flags=0, sched_nice=0, sched_priority=0, sched_runtime=2251799813724439, sched_deadline=4611686018427453437, sched_period=0}, 0) = 0
> >
> > This is setting the scheduler policy to be SCHED_DEADLINE, with a
> > runtime parameter of 2251799.813724439 seconds (or 26 days) and a
> > deadline of 4611686018.427453437 seconds (or 146 *years*).  This means
> > a particular kernel thread can run for up to 26 **days** before it is
> > scheduled away, and if a kernel reads gets woken up or sent a signal,
> > no worries, it will wake up roughly seven times the interval that Rip
> > Van Winkle spent snoozing in a cave in the Catskill Mountains (in
> > Washington Irving's short story).
> >
> > We then kick off a half-dozen threads all running:
> >
> >    sendfile(fd, fd, &pos, 0x8080fffffffe);
> >
> > (and since count is a ridiculously large number, this gets cut down to):
> >
> >    sendfile(fd, fd, &pos, 2147479552);
> >
> > Is it any wonder that we are seeing RCU stalls?   :-)
> 
> +Peter, Ingo for sched_setattr and +Paul for rcu
> 
> First of all: is it a semi-intended result of a root (CAP_SYS_NICE)
> doing local DoS abusing sched_setattr? It would perfectly reasonable
> to starve other processes, but I am not sure about rcu. In the end the
> high prio process can use rcu itself, and then it will simply blow
> system memory by stalling rcu. So it seems that rcu stalls should not
> happen as a result of weird sched_setattr values. If that is the case,
> what needs to be fixed? sched_setattr? rcu? sendfile?

Does the (untested, probably does not even build) patch shown below help?
This patch assumes that the kernel was built with CONFIG_PREEMPT=n.
And that I found all the tight loops on the do_sendfile() code path.

> If this is semi-intended, the only option I see is to disable
> something in syzkaller: sched_setattr entirely, or drop CAP_SYS_NICE,
> or ...? Any preference either way?

Long-running tight loops in the kernel really should contain
cond_resched() or better.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/fs/splice.c b/fs/splice.c
index 25212dcca2df..50aa3286764a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -985,6 +985,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 			sd->pos = prev_pos + ret;
 			goto out_release;
 		}
+		cond_resched();
 	}
 
 done:

