Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB37964E0E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfGJVhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:37:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJVhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:37:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6ALYxw8129323;
        Wed, 10 Jul 2019 21:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=0W6M2v+RzuMaZIKsyxLacBLW5qRq+E1Z+EV6R9iu5Og=;
 b=yS+wamjo8eakdVzQiyu9LCXeeH0Dlu9JAsF+b7KqaCUhOWDXXCm4fXcFTIzx4kyqdHXt
 /+l0z1GX7oCK5cH0V4I5NQgUH2Srl1O9Yxv+CE5hJKRHJuws9SyhWPqTvkQnvFCsEyma
 dCpMa5u8qGsSpx97lnzdq6brhtTsxtqwwwMGC8u3pC5csQyk6+/UW4o0+sEgEYEY6wNP
 cdxUcs4YjgfheMalrz5/HK+UBBZhYPXUdHYG2jjdl62mdw+kSEmdlAEa7TZXMB32KiPK
 7+jBoESLnc5S3+/uQB3JOMMRXof83p1x1KPLdfiVNqARouMno+HVWEnVYqduAfvVMM1X 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkpvknt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 21:36:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6ALXFuT070524;
        Wed, 10 Jul 2019 21:36:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tmmh3sn6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jul 2019 21:36:41 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6ALafvD076812;
        Wed, 10 Jul 2019 21:36:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh3sn67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 21:36:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6ALaetK025541;
        Wed, 10 Jul 2019 21:36:40 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 14:36:40 -0700
Date:   Wed, 10 Jul 2019 17:36:37 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>, brendan.d.gregg@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
Message-ID: <20190710213637.GB13962@oracle.com>
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
 <201907101542.x6AFgOO9012232@userv0121.oracle.com>
 <20190710181227.GA9925@oracle.com>
 <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
 <20190710143048.3923d1d9@lwn.net>
 <1de27d29-65bb-89d3-9fca-7c452cd66934@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1de27d29-65bb-89d3-9fca-7c452cd66934@iogearbox.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:19:43PM +0200, Daniel Borkmann wrote:
> On 07/10/2019 10:30 PM, Jonathan Corbet wrote:
> > On Wed, 10 Jul 2019 21:32:25 +0200
> > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > 
> >> Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
> >> seen a strong compelling argument for why this needs to reside in the kernel
> >> tree given we also have all the other tracing tools and many of which also
> >> rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
> >> a few.
> > 
> > So I'm just watching from the sidelines here, but I do feel the need to
> > point out that Kris appears to be trying to follow the previous feedback
> > he got from Alexei, where creating tools/dtrace is exactly what he was
> > told to do:
> > 
> >   https://lwn.net/ml/netdev/20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com/
> > 
> > Now he's being told the exact opposite.  Not the best experience for
> > somebody who is trying to make the kernel better.
> 
> Ugh, agree, sorry for the misleading direction. Alexei is currently offgrid
> this week, he might comment later.
> 
> It has nothing to do with making the _kernel_ better, it's a /user space/ front
> end for the existing kernel infrastructure like many of the other tracers out
> there. Don't get me wrong, adding the missing /kernel parts/ for it is a totally
> different subject [and _that_ is what is making the kernel better, not the former].

I disagree.  Yes, the current patch obviously isn't making the kernel better
because it doesn't touch the kernel.  But DTrace as a whole is not just a
/front end/ to the existing kernel infrastructure, and I did make that point
at LPC 2018 and in my emails.  Some of its more advanced features will lead
to contributions to the kernel that (by virtue of being developed as part of
this DTrace re-implementation) will more often than not be able to benefit
other tracers as well.  I do think that aspect qualifies as working towards
making the kenrel better.

> Hypothetical question: does it make the _kernel_ better if we suddenly add a huge
> and complex project like tools/mysql/ to the kernel tree? Nope.
> 
> > There are still people interested in DTrace out there.  How would you
> > recommend that Kris proceed at this point?
> 
> My recommendation to proceed is to maintain the dtrace user space tooling in
> its own separate project like the vast majority of all the other tracing projects
> (see also the other advantages that Steven pointed out from his experience), and
> extend the kernel bits whenever needed.

I wish that would have been the initial recommendation because it certainly
would have avoided me going down a path that was going to lead to rejection.

Either way, I do hope that as work progresses and contributions to the kernel
code are submitted in support of advancing tracing on Linux, those patches
will receive a fair review and consideration.  I can appreciate that some
people do not like DTrace or feel that it is not necessary, but personal
opinions about tools should not be a deciding factor in whether a contribution
has merit or not.

	Kris
