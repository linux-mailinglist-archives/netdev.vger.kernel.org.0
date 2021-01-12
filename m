Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640A22F3D4C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbhALVhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437023AbhALUoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:44:06 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4699C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:43:25 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10CKZ53G017811;
        Tue, 12 Jan 2021 20:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from : to :
 cc : subject : in-reply-to : references; s=jan2016.eng;
 bh=qeZQhIil97saLQwFnYQ2DfTdDeQ57IpbG1bT/daK3M0=;
 b=QKywGqIOb0mTrZplhBoEICMCG/i6gTuxI9bkBmZu1b5GN7qm8qMPb6Qk4jULwvt35nvb
 /Fj767zaMd8/BmlCUo3XMSaQFZc8MACQDk4W4C/xoIM/qefadmcgH57S5mEBxbsQ6EJo
 ejsHkeX3PfYaq5MtNyaQVUrwc4WuNYeIXHMRuGRpb2nmJKUZ2fTrxPfwqQQ71BZXBhCr
 OORTN+1PkvZPnLFZmhOSKbCdGCnSIFZOM3NIQuzN2Y37VEU51HV2e87K3iKW7GJrKF/B
 UtQlW8Rsh9KL06dhE2VTeQ3JcDAck4+558pFenAtTQyqxHHHp4PUIs13+fRM0dkztE2s AA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 35y5sey853-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 20:43:23 +0000
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10CKZfvO002624;
        Tue, 12 Jan 2021 15:43:22 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.32])
        by prod-mail-ppoint2.akamai.com with ESMTP id 35y8q26p28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 15:43:22 -0500
Received: from usma1ex-cas4.msg.corp.akamai.com (172.27.123.57) by
 usma1ex-dag3mb3.msg.corp.akamai.com (172.27.123.58) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 12 Jan 2021 15:43:22 -0500
Received: from bos-lhvedt (172.28.223.201) by usma1ex-cas4.msg.corp.akamai.com
 (172.27.123.57) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 15:43:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <24574.2537.621032.690850@gargle.gargle.HOWL>
Date:   Tue, 12 Jan 2021 12:43:21 -0800
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
In-Reply-To: <CANn89iJWkgkF+kKDFnqAO9oMMziZGPe_QYMJvx80AbbTfQFQmQ@mail.gmail.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
        <20210111222411.232916-5-hcaldwel@akamai.com>
        <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
        <24573.51244.563087.333291@gargle.gargle.HOWL>
        <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
        <24573.63409.26608.321427@gargle.gargle.HOWL>
        <CANn89iJWkgkF+kKDFnqAO9oMMziZGPe_QYMJvx80AbbTfQFQmQ@mail.gmail.com>
X-Mailer: VM 8.2.0b under 28.0.50 (x86_64-pc-linux-gnu)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_16:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120122
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_16:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120122
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.19)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-12 21:26 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> On Tue, Jan 12, 2021 at 8:25 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
> >
> > On 2021-01-12 18:05 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > > On Tue, Jan 12, 2021 at 5:02 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
> > > >
> > > > On 2021-01-12 09:30 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > > > > I think the whole patch series is an attempt to badly break TCP stack.
> > > >
> > > > Can you explain the concern that you have about how these changes might
> > > > break the TCP stack?
> > > >
> > > > Patches 1 and 3 fix clear bugs.
> > >
> > > Not clear to me at least.
> > >
> > > If they were bug fixes, a FIxes: tag would be provided.
> >
> > The underlying bugs that are addressed in patches 1 and 3 are present in
> > 1da177e4c3f4 ("Linux-2.6.12-rc2") which looks to be the earliest parent
> > commit in the repository.  What should I do for a Fixes: tag in this
> > case?
> >
> > > You are a first time contributor to linux TCP stack, so better make
> > > sure your claims are solid.
> >
> > I fear that I may not have expressed the problems and solutions in a
> > manner that imparted the ideas well.
> >
> > Maybe I added too much detail in the description for patch 1, which may
> > have obscured the problem: val is capped to sysctl_rmem_max *before* it
> > is doubled (resulting in the possibility for sk_rcvbuf to be set to
> > 2*sysctl_rmem_max, rather than it being capped at sysctl_rmem_max).
> 
> This is fine. This has been done forever. Your change might break applications.

In what way might applications be broken?

It seems to be a very strange position to allow a configured maximum to
be violated because of obscure precedent.

It does not seem to be a supportable position to allow an application to
violate an installation's configuration because of a chance that the
application may behave differently if a setsockopt() call fails.  What
if a system administrator decides to reduce sysctl_rmem_max to half of
the current default?

> I would advise documenting this fact, since existing behavior will be kept
> in many linux hosts for years to come.
> 
> >
> > Maybe I was not explicit enough in the description for patch 3: space is
> > expanded into sock_net(sk)->ipv4.sysctl_tcp_rmem[2] and sysctl_rmem_max
> > without first shrinking them to discount the overhead.
> >
> > > > Patches 2 and 4 might be arguable, though.
> > >
> > > So we have to pick up whatever pleases us ?
> >
> > I have been treating all of these changes together because they all kind
> > of work together to provide a consistent model and configurability for
> > the initial receive window.
> >
> > Patches 1 and 3 address bugs.
> 
> Maybe, but will break applications.

How might patch 3 break an application?  It merely will reduce the
window scale value to something lower but still capable of representing
the largest window that a particular connection might advertise.

> > Patch 2 addresses an inconsistency in how overhead is treated specially
> > for TCP sockets.
> > Patch 4 addresses the 64KB limit which has been imposed.
> 
> For very good reasons.

What are the reasons?

> This is going nowhere. I will stop right now.

That is a shame :(.
