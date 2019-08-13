Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F588B91F
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfHMMtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:49:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbfHMMtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:49:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DCmtam177067;
        Tue, 13 Aug 2019 12:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qTZYfY533gM7m4PsKVvKdAKeulPfWW1BX72qwu/Csrk=;
 b=bmyyGUCZjCw4iDEnI7eN1qIkc4JA3fOhtBMlmPJPFmnCeoJv7iczWAnovjKXyLZzsSXE
 WeKHuNZLmLoS6PVN72cd314GBdP45NaWVPEbVvX9sUxFJhjNQyPX/VqHGuIe3aAveXLy
 fQCggwFg3eePNY/1+w6SrHyL0u0J8JbVsIadnWmmHZoIWv4yVqHuQtZUVKCMikkHrlOg
 EQad5Mzaza8Mlpmk7unyFkuHiDSgVMwjrHAx7xrv/gKTvNxcV6GmU+xiaUu6mxG9/w/0
 vSXCeojkMU5RS74X/eGaossgAvuUruYV8nSjSKNfm7liYPIvms73OZPqUCJw4GM6QqMF 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqdyax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 12:48:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DCmc6n187709;
        Tue, 13 Aug 2019 12:48:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ubwcwr8xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 12:48:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DCmlAq017058;
        Tue, 13 Aug 2019 12:48:47 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 05:48:47 -0700
Date:   Tue, 13 Aug 2019 15:48:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kees Cook <keescook@chromium.org>,
        Nicolai Stange <nicstange@gmail.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Patrick Bellasi <patrick.bellasi@arm.com>,
        linux-sparse@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH net-next] net: can: Fix compiling warning
Message-ID: <20190813124838.GN1935@kadam>
References: <20190802033643.84243-1-maowenan@huawei.com>
 <0050efdb-af9f-49b9-8d83-f574b3d46a2e@hartkopp.net>
 <20190806135231.GJ1974@kadam>
 <6e1c5aa0-8ed3-eec3-a34d-867ea8f54e9d@hartkopp.net>
 <20190807105042.GK1974@kadam>
 <201908121001.0AC0A90@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908121001.0AC0A90@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 10:19:27AM -0700, Kees Cook wrote:
> On Wed, Aug 07, 2019 at 01:50:42PM +0300, Dan Carpenter wrote:
> > On Tue, Aug 06, 2019 at 06:41:44PM +0200, Oliver Hartkopp wrote:
> > > I compiled the code (the original version), but I do not get that "Should it
> > > be static?" warning:
> > > 
> > > user@box:~/net-next$ make C=1
> > >   CALL    scripts/checksyscalls.sh
> > >   CALL    scripts/atomic/check-atomics.sh
> > >   DESCEND  objtool
> > >   CHK     include/generated/compile.h
> > >   CHECK   net/can/af_can.c
> > > ./include/linux/sched.h:609:43: error: bad integer constant expression
> > > ./include/linux/sched.h:609:73: error: invalid named zero-width bitfield
> > > `value'
> > > ./include/linux/sched.h:610:43: error: bad integer constant expression
> > > ./include/linux/sched.h:610:67: error: invalid named zero-width bitfield
> > > `bucket_id'
> > >   CC [M]  net/can/af_can.o
> > 
> > The sched.h errors suppress Sparse warnings so it's broken/useless now.
> > The code looks like this:
> > 
> > include/linux/sched.h
> >    613  struct uclamp_se {
> >    614          unsigned int value              : bits_per(SCHED_CAPACITY_SCALE);
> >    615          unsigned int bucket_id          : bits_per(UCLAMP_BUCKETS);
> >    616          unsigned int active             : 1;
> >    617          unsigned int user_defined       : 1;
> >    618  };
> > 
> > bits_per() is zero and Sparse doesn't like zero sized bitfields.
> 
> I just noticed these sparse warnings too -- what's happening here? Are
> they _supposed_ to be 0-width fields? It doesn't look like it to me:

I'm sorr, I don't even know what code I was looking at before.  I think
my cscope database was stale?  You're right.  Sparse doesn't think it's
zero, it knows that it is 11 and 3.

What's happening is that it's failing the test in in
bad_integer_constant_expression():

	if (!(expr->flags & CEF_ICE))

The ICE in CEF_ICE stands for Integer Constant Expression.  The rule
here is that enums are not constant expressions in c99.  See the
explanation in commit 274c154704db ("constexpr: introduce additional
expression constness tracking flags").

I don't think the CEF_ICE is set properly in evaluate_conditional_expression().
If conditional is constant and it's true and the ->cond_true expression
is constant then the result should be constant as well.  It shouldn't
matter if the cond_false is constant.  But instead it is ANDing all
three sub expressions:

	expr->flags = (expr->conditional->flags & (*true)->flags &
			expr->cond_false->flags & ~CEF_CONST_MASK);

Or actually in this case it's doing:

	if (expr->conditional->flags & (CEF_ACE | CEF_ADDR))
		expr->flags = (*true)->flags & expr->cond_false->flags & ~CEF_CONST_MASK;

But it's the same problem because it's should ignore cond_false.

regards,
dan carpenter
