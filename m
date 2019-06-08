Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4493A137
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfFHSOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:14:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbfFHSOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 14:14:36 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x58I6i5h027875
        for <netdev@vger.kernel.org>; Sat, 8 Jun 2019 14:14:35 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t0960p0dv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 14:14:35 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sat, 8 Jun 2019 19:14:34 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 8 Jun 2019 19:14:30 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x58IETRY32768474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 8 Jun 2019 18:14:29 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D0D8B2064;
        Sat,  8 Jun 2019 18:14:29 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B056B205F;
        Sat,  8 Jun 2019 18:14:29 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.156.65])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  8 Jun 2019 18:14:28 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 5544016C5D9A; Sat,  8 Jun 2019 11:14:31 -0700 (PDT)
Date:   Sat, 8 Jun 2019 11:14:31 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj1G9nXMzAu=Ldbd4_bbzVtWgNORDKMD4bKTO6dRrMPmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060818-2213-0000-0000-0000039BFD59
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011234; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01215108; UDB=6.00638786; IPR=6.00996199;
 MB=3.00027236; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-08 18:14:33
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060818-2214-0000-0000-00005EC64B6B
Message-Id: <20190608181431.GL28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 10:42:41AM -0700, Linus Torvalds wrote:
> On Sat, Jun 8, 2019 at 8:32 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> >
> > On Fri, Jun 07, 2019 at 09:19:42AM -0700, Linus Torvalds wrote:
> > >
> > >  - bitfields obviously do need locks. 'char' does not.
> > >
> > > If there's somebody who really notices the alpha issue in PRACTICE, we
> > > can then bother to fix it. But there is approximately one user, and
> > > it's not a heavy-duty one.
> >
> > C11 and later compilers are supposed to use read-modify-write atomic
> > operations in this sort of situation anyway because they are not supposed
> > to introduce data races.

Apologies, I should have explicitly stated that I was talking about char
stores, not bitfield stores.  And last I checked, the C11 standard's
prohibition against data races did not extend to individual fields within
a bitfield.  So, yes, for bitfields, the programmer must use a lock or
similar if it is necessary for updates to fields within a bitfield to
be atomic.

> I don't think that's possible on any common architecture. The
> bitfields themselves will need locking, to serialize writes of
> different fields against each other.

Yes, and again the C standard doesn't make any atomicity guarantees
regarding storing to different fields within a bitfield.  The compiler is
free to assume that nothing else is happening anywhere in the bitfield
when storing to a field within that bitfield.  Which gets back to your
"bitfields obviously do need locks", and it is of course the developer
(not the compiler) who must supply those locks.  Plus a given lock must
cover the entire bitfield -- having one lock for half the fields within
a given bitfield and another lock for the other half will break.

Switching from bitfields to char, the C standard -does- require that
storing to one char must avoid even momentary corruption of adjacent
char, so given an old Alpha the compiler would need to use something
like an LL/SC loop.  If it fails to do so, that compiler is failing to
comply with the standard.

> There are no atomic rmw sequences that have reasonable performance for
> the bitfield updates themselves.

Agreed, in the general case.  In a few specific special cases, we do
sometimes hand-craft bitfields using shifts and masks, and sometimes
we use atomic RMW operations to update them.  I suppose we could use
unions as an alternative, but it is not clear to me that this would
help anything.

> The fields *around* the bitfields had better be safe, but that's
> something we already depend on, and which falls under the heading of
> "we don't accept garbage compilers".

And the C standard does require the compiler to make that guarantee, so
for once the standard is even on our side.  ;-)

							Thanx, Paul

