Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD23A14E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfFHSvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:51:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727309AbfFHSvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 14:51:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x58Il5wD144926
        for <netdev@vger.kernel.org>; Sat, 8 Jun 2019 14:51:38 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t06mwjg7j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 14:51:37 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sat, 8 Jun 2019 19:51:37 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Jun 2019 19:51:32 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x58IoGEV39387552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Jun 2019 18:50:16 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1442B2064;
        Sat,  8 Jun 2019 18:50:16 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF36FB205F;
        Sat,  8 Jun 2019 18:50:16 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.156.65])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  8 Jun 2019 18:50:16 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 1FDEA16C21CA; Sat,  8 Jun 2019 11:50:19 -0700 (PDT)
Date:   Sat, 8 Jun 2019 11:50:19 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
Reply-To: paulmck@linux.ibm.com
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
 <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
 <CAHk-=wgtY1hNQX9TM=4ono-UJ-hsoFA0OT36ixFWBG2eeO011w@mail.gmail.com>
 <20190608152707.GF28207@linux.ibm.com>
 <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
 <CAHk-=wiRduKzoLpAwU7iFiOJ6DX7RE+PZ_wFi9Cvq=hDoaNsPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiRduKzoLpAwU7iFiOJ6DX7RE+PZ_wFi9Cvq=hDoaNsPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060818-2213-0000-0000-0000039BFEAB
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011235; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01215120; UDB=6.00638794; IPR=6.00996212;
 MB=3.00027237; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-08 18:51:35
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060818-2214-0000-0000-00005EC66162
Message-Id: <20190608185019.GM28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=865 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 10:50:51AM -0700, Linus Torvalds wrote:
> On Sat, Jun 8, 2019 at 10:42 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > There are no atomic rmw sequences that have reasonable performance for
> > the bitfield updates themselves.
> 
> Note that this is purely about the writing side. Reads of bitfield
> values can be (and generally _should_ be) atomic, and hopefully C11
> means that you wouldn't see intermediate values.
> 
> But I'm not convinced about that either: one natural way to update a
> bitfield is to first do the masking, and then do the insertion of new
> bits, so a bitfield assignment very easily exposes non-real values to
> a concurrent read on another CPU.

Agreed on the "not convinced" part (though perhaps most implementations
would handle concurrent reads and writes involving different fields of
the same bitfield).  And the C standard does not guarantee this, because
data races are defined in terms of memory locations.  So as far as the
C standard is concerned, if there are two concurrent accesses to fields
within a bitfield that are not separated by ":0", there is a data race
and so the compiler can do whatever it wants.

But do we really care about this case?

> What I think C11 is supposed to protect is from compilers doing
> horribly bad things, and accessing bitfields with bigger types than
> the field itself, ie when you have
> 
>    struct {
>        char c;
>        int field1:5;
>    };
> 
> then a write to "field1" had better not touch "char c" as part of the
> rmw operation, because that would indeed introduce a data-race with a
> completely independent field that might have completely independent
> locking rules.
> 
> But
> 
>    struct {
>         int c:8;
>         int field1:5;
>    };
> 
> would not sanely have the same guarantees, even if the layout in
> memory might be identical. Once you have bitfields next to each other,
> and use a base type that means they can be combined together, they
> can't be sanely modified without locking.
>
> (And I don't know if C11 took up the "base type of the bitfield"
> thing. Maybe you still need to use the ":0" thing to force alignment,
> and maybe the C standards people still haven't made the underlying
> type be meaningful other than for sign handling).

The C standard draft (n2310) gives similar examples:

	EXAMPLE A structure declared as

		struct {
			char a;
			int b:5, c:11,:0, d:8;
			struct { int ee:8; } e;
		}

	contains four separate memory locations: The member a, and
	bit-fields d and e.ee are each separate memory locations,
	and can be modified concurrently without interfering with each
	other. The bit-fields b and c together constitute the fourth
	memory location. The bit-fields b and c cannot be concurrently
	modified, but b and a, for example, can be.

So yes, ":0" still forces alignment to the next storage unit.  And it
can be used to allow concurrent accesses to fields within a bitfield,
but only when those two fields are separated by ":0".

On the underlying type, according to J.3.9 of the current C working draft,
the following are implementation-specified behavior:

-	Whether a "plain" int bit-field is treated as a signed int
	bit-field or as an unsigned int bit-field (6.7.2, 6.7.2.1).

-	Whether atomic types are permitted for bit-fields (6.7.2.1).

This last is strange because you are not allowed to take the address of
a bit field, and the various operations on atomic types take addresses.
Search me!

							Thanx, Paul

