Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6A31383
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfEaRLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:11:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbfEaRLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:11:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VGqs9u067994
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:11:40 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2su6k6vnh3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:11:40 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 31 May 2019 18:11:39 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 May 2019 18:11:35 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4VHBYk938142336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 17:11:34 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7098BB2068;
        Fri, 31 May 2019 17:11:34 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 536BDB2067;
        Fri, 31 May 2019 17:11:34 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.70.82.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 31 May 2019 17:11:34 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id A21C416C37A7; Fri, 31 May 2019 10:11:35 -0700 (PDT)
Date:   Fri, 31 May 2019 10:11:35 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
Reply-To: paulmck@linux.ibm.com
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
 <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
 <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au>
 <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19053117-0064-0000-0000-000003E82A5B
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011191; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01211307; UDB=6.00636472; IPR=6.00992344;
 MB=3.00027134; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-31 17:11:38
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19053117-0065-0000-0000-00003DAEF887
Message-Id: <20190531171135.GM28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 08:45:47AM -0700, Eric Dumazet wrote:
> 
> 
> On 5/31/19 7:45 AM, Herbert Xu wrote:
> > On Fri, May 31, 2019 at 10:24:08AM +0200, Dmitry Vyukov wrote:
> >>
> >> OK, let's call it barrier. But we need more than a barrier here then.
> > 
> > READ_ONCE/WRITE_ONCE is not some magical dust that you sprinkle
> > around in your code to make it work without locks.  You need to
> > understand exactly why you need them and why the code would be
> > buggy if you don't use them.
> > 
> > In this case the code doesn't need them because an implicit
> > barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> > exists in both places.
> >
> 
> More over, adding READ_ONCE() while not really needed prevents some compiler
> optimizations.
> 
> ( Not in this particular case, since fqdir->dead is read exactly once, but we could
> have had a loop )
> 
> I have already explained that the READ_ONCE() was a leftover of the first version
> of the patch, that I refined later, adding correct (and slightly more complex) RCU
> barriers and rules.
> 
> Dmitry, the self-documentation argument is perfectly good, but Herbert
> put much nicer ad hoc comments.

I don't see all the code, but let me see if I understand based on the
pieces that I do see...

o	fqdir_exit() does a store-release to ->dead, then arranges
	for fqdir_rwork_fn() to be called from workqueue context
	after a grace period has elapsed.

o	If inet_frag_kill() is invoked only from fqdir_rwork_fn(),
	and if they are using the same fqdir, then inet_frag_kill()
	would always see fqdir->dead==true.

	But then it would not be necessary to check it, so this seems
	unlikely.

o	If fqdir_exit() does store-releases to a number of ->dead
	fields under rcu_read_lock(), and if the next fqdir_exit()
	won't happen until after all the callbacks complete
	(combination of flushing workqueues and rcu_barrier(), for
	example), then ->dead would be stable when inet_frag_kill()
	is invoked, and might be true or not.  (This again requires
	inet_frag_kill() be only invoked from fqdir_rwork_fn().)

So I can imagine cases where this would in fact work.  But did I get
it right or is something else happening?

							Thanx, Paul

