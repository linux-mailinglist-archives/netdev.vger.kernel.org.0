Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F3355A8
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFEDar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:30:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfFEDaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:30:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x553M5RW044551
        for <netdev@vger.kernel.org>; Tue, 4 Jun 2019 23:30:45 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sx3krm9yn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 23:30:45 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Wed, 5 Jun 2019 04:30:44 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Jun 2019 04:30:40 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x553UdK632375164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jun 2019 03:30:39 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7A60B2066;
        Wed,  5 Jun 2019 03:30:39 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5469B205F;
        Wed,  5 Jun 2019 03:30:39 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.212.108])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jun 2019 03:30:39 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 848C816C3783; Tue,  4 Jun 2019 20:30:39 -0700 (PDT)
Date:   Tue, 4 Jun 2019 20:30:39 -0700
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
References: <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
 <20190603195304.GK28207@linux.ibm.com>
 <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
 <20190604211449.GU28207@linux.ibm.com>
 <20190605022117.kw6tldcwhdkyqd6u@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605022117.kw6tldcwhdkyqd6u@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060503-0072-0000-0000-000004379A56
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011217; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01213397; UDB=6.00637747; IPR=6.00994469;
 MB=3.00027186; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-05 03:30:43
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060503-0073-0000-0000-00004C7F4EC0
Message-Id: <20190605033039.GY28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=918 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 10:21:17AM +0800, Herbert Xu wrote:
> On Tue, Jun 04, 2019 at 02:14:49PM -0700, Paul E. McKenney wrote:
> >
> > Yeah, I know, even with the "volatile" keyword, it is not entirely clear
> > how much reordering the compiler is allowed to do.  I was relying on
> > https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html, which says:
> 
> The volatile keyword doesn't give any guarantees of this kind.
> The key to ensuring ordering between unrelated variable/register
> reads/writes is the memory clobber:
> 
> 	6.47.2.6 Clobbers and Scratch Registers
> 
> 	...
> 
> 	"memory" The "memory" clobber tells the compiler that the assembly
> 	code performs memory reads or writes to items other than those
> 	listed in the input and output operands (for example, accessing
> 	the memory pointed to by one of the input parameters). To ensure
> 	memory contains correct values, GCC may need to flush specific
> 	register values to memory before executing the asm. Further,
> 	the compiler does not assume that any values read from memory
> 	before an asm remain unchanged after that asm; it reloads them as
> 	needed. Using the "memory" clobber effectively forms a read/write
> 	memory barrier for the compiler.
> 
> 	Note that this clobber does not prevent the processor from
> 	doing speculative reads past the asm statement. To prevent that,
> 	you need processor-specific fence instructions.
> 
> IOW you need a barrier().

Understood.  Does the patch I sent out a few hours ago cover it?  Or is
something else needed?

Other than updates to the RCU requirements documentation, which is
forthcoming.

							Thanx, Paul

