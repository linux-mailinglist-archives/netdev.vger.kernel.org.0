Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B236F79
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfFFJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:06:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727540AbfFFJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:06:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x568vcVS051289
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 05:06:25 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sxyqvgpdk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 05:06:25 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 6 Jun 2019 10:06:24 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 10:06:20 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5696Jn623396806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 09:06:19 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C52C3B2066;
        Thu,  6 Jun 2019 09:06:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92EA9B2064;
        Thu,  6 Jun 2019 09:06:19 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.136.182])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 09:06:19 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 157B316C15CF; Thu,  6 Jun 2019 02:06:19 -0700 (PDT)
Date:   Thu, 6 Jun 2019 02:06:19 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060609-0072-0000-0000-000004384692
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011223; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01213979; UDB=6.00638102; IPR=6.00995059;
 MB=3.00027204; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-06 09:06:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060609-0073-0000-0000-00004C856DA7
Message-Id: <20190606090619.GC28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:14:38PM +0800, Herbert Xu wrote:
> On Wed, Jun 05, 2019 at 11:05:11PM -0700, Paul E. McKenney wrote:
> >
> > In case you were wondering, the reason that I was giving you such
> > a hard time was that from what I could see, you were pushing for no
> > {READ,WRITE}_ONCE() at all.  ;-)
> 
> Hmm, that's exactly what it should be in net/ipv4/inet_fragment.c.
> We don't need the READ_ONCE/WRITE_ONCE (or volatile marking) at
> all.  Even if the compiler dices and slices the reads/writes of
> "a" into a thousand pieces, it should still work if the RCU
> primitives are worth their salt.

OK, so I take it that there is additional synchronization in there
somewhere that is not captured in your simplified example code?

Or is your point instead that given the initial value of "a" being
zero and the value stored to "a" being one, there is no way that
any possible load and store tearing (your slicing and dicing) could
possibly mess up the test of the value loaded from "a"?

> But I do concede that in the general RCU case you must have the
> READ_ONCE/WRITE_ONCE calls for rcu_dereference/rcu_assign_pointer.

OK, good that we are in agreement on this part, at least!  ;-)

							Thanx, Paul

