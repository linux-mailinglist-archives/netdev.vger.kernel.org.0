Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E67375A4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfFFNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:49:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726877AbfFFNtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:49:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56DgKQp115516
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 09:49:08 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy3b4tp2b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 09:49:03 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 6 Jun 2019 14:49:01 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 14:48:58 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56DmvcR37683528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 13:48:57 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E4DCB2067;
        Thu,  6 Jun 2019 13:48:57 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0D3AB2064;
        Thu,  6 Jun 2019 13:48:56 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.209.205])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 13:48:56 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 6315916C3783; Thu,  6 Jun 2019 06:48:56 -0700 (PDT)
Date:   Thu, 6 Jun 2019 06:48:56 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
 <20190606060511.GA28207@linux.ibm.com>
 <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
 <20190606090619.GC28207@linux.ibm.com>
 <20190606092855.dfeuvyk5lbvm4zbf@gondor.apana.org.au>
 <20190606105817.GE28207@linux.ibm.com>
 <20190606133824.aibysezb5qdo3x27@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606133824.aibysezb5qdo3x27@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060613-0052-0000-0000-000003CC3C7F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011223; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214073; UDB=6.00638158; IPR=6.00995153;
 MB=3.00027206; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 13:49:01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060613-0053-0000-0000-00006135265B
Message-Id: <20190606134856.GL28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 09:38:24PM +0800, Herbert Xu wrote:
> On Thu, Jun 06, 2019 at 03:58:17AM -0700, Paul E. McKenney wrote:
> >
> > I cannot immediately think of a way that the compiler could get this
> > wrong even in theory, but similar code sequences can be messed up.
> > The reason for this is that in theory, the compiler could use the
> > stored-to location as temporary storage, like this:
> > 
> > 	a = whatever;	// Compiler uses "a" as a temporary
> > 	do_something();
> > 	whatever = a;
> > 	a = 1;		// Intended store
> 
> Well if the compiler is going to do this then surely it would
> continue to do this even if you used WRITE_ONCE.  Remember a is
> not volatile, only the access of a through WRITE_ONCE is volatile.

I disagree.  Given a volatile store, the compiler cannot assume that the
stored-to location is normal memory at that point in time, and therefore
cannot assume that it is safe to invent a store to that location (as
shown above).  Thus far, the C++ standards committee seems on-board with
this, though time will tell.

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1382r1.pdf

							Thanx, Paul

