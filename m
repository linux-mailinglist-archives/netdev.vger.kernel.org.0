Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EE32B03
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfFCImX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:42:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727698AbfFCImX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 04:42:23 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x538bcwu141161
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 04:42:22 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2svwneern4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 04:42:22 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 3 Jun 2019 09:42:21 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 09:42:16 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x538gFPw21299220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 08:42:15 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A43C3B2065;
        Mon,  3 Jun 2019 08:42:15 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7303EB2066;
        Mon,  3 Jun 2019 08:42:15 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.160.165])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 08:42:15 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id C316616C5D9E; Mon,  3 Jun 2019 01:42:14 -0700 (PDT)
Date:   Mon, 3 Jun 2019 01:42:14 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603040114.st646bujtgyu7adn@gondor.apana.org.au>
 <20190603072339.GH28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603072339.GH28207@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060308-0072-0000-0000-00000436B2E7
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011207; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212553; UDB=6.00637233; IPR=6.00993614;
 MB=3.00027161; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 08:42:19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060308-0073-0000-0000-00004C774240
Message-Id: <20190603084214.GA1496@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 12:23:39AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 03, 2019 at 12:01:14PM +0800, Herbert Xu wrote:
> > On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> > >
> > > 	CPU2:         if (b != 1)
> > > 	CPU2:                 b = 1;
> > 
> > Stop right there.  The kernel is full of code that assumes that
> > assignment to an int/long is atomic.  If your compiler breaks this
> > assumption that we can kiss the kernel good-bye.
> 
> Here you go:
> 
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56028
> 
> TL;DR: On x86, of you are doing a plain store of a 32-bit constant
> that has bits set only in the lower few bits of each 16-bit half of
> that constant, the compiler is plenty happy to use a pair of 16-bit
> store-immediate instructions to carry out that store.  This is also
> known as "store tearing".
> 
> The two bugs were filed (and after some back and forth, fixed) because
> someone forgot to exclude C11 atomics and volatile accesses from this
> store tearing.

I should hasten to add that I have not seen load tearing, nor have I seen
store tearing when storing a value unknown to the compiler.  However,
plain C-language loads and stores can be invented, fused, and a few other
"interesting" optimization can be applied.

On kissing the kernel goodbye, a reasonable strategy might be to
identify the transformations that are actually occuring (like the
stores of certain constants called out above) and fix those.  We do
occasionally use READ_ONCE() to prevent load-fusing optimizations that
would otherwise cause the compiler to turn while-loops into if-statements
guarding infinite loops.  There is also the possibility of having the
compiler guys give us more command-line arguments.

							Thanx, Paul

