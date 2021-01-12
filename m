Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC30D2F3A46
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406288AbhALT0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbhALT0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:26:21 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66674C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:25:41 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10CJP7VF028959;
        Tue, 12 Jan 2021 19:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from : to :
 cc : subject : in-reply-to : references; s=jan2016.eng;
 bh=VB5sguGvkpm2gwuQGyxWMS4ypS/Bpu2tcCQxZPkDAkw=;
 b=XrujiLYzNYbjLKjEN4GQxbec/tB4R5s8/45C4F0qhfgUnAJ59OXR+jh1Gd9wG2LQj/JF
 oUSi/ruTN7lgknCxXUR2lUU5CEp4TemHuxlvD/Yx94O/MZcZLX5vQhnQcLHUI0Bb9vUr
 GF+KAfkIhg+sn35xGXWw68FtyAwFHY7QiOcCRbN3aCQLk9VhmPnsQ/MWP1Vyf5CvDfeG
 Hm5A7MwYZF1eyCmiYiBSUdq59HCR26+F5jpDBhIXLjDqrjCGx9ELkja7O6KMs576WHuN
 SQL0n6RqvUqxBaqKOf9TaMrxn2eskMs/BIppcPWh0NmSAgYm85BCD0SMTF1R9fx3DWio lA== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 35y5sevt2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 19:25:39 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10CJJ1Lm014156;
        Tue, 12 Jan 2021 14:25:38 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.53])
        by prod-mail-ppoint6.akamai.com with ESMTP id 35y8q3xgbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 14:25:38 -0500
Received: from USMA1EX-CAS1.msg.corp.akamai.com (172.27.123.30) by
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 12 Jan 2021 14:25:37 -0500
Received: from bos-lhvedt (172.28.223.201) by USMA1EX-CAS1.msg.corp.akamai.com
 (172.27.123.30) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 14:25:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <24573.63409.26608.321427@gargle.gargle.HOWL>
Date:   Tue, 12 Jan 2021 11:25:37 -0800
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
In-Reply-To: <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
        <20210111222411.232916-5-hcaldwel@akamai.com>
        <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
        <24573.51244.563087.333291@gargle.gargle.HOWL>
        <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
X-Mailer: VM 8.2.0b under 28.0.50 (x86_64-pc-linux-gnu)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120112
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120113
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-12 18:05 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> On Tue, Jan 12, 2021 at 5:02 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
> >
> > On 2021-01-12 09:30 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > > I think the whole patch series is an attempt to badly break TCP stack.
> >
> > Can you explain the concern that you have about how these changes might
> > break the TCP stack?
> >
> > Patches 1 and 3 fix clear bugs.
> 
> Not clear to me at least.
> 
> If they were bug fixes, a FIxes: tag would be provided.

The underlying bugs that are addressed in patches 1 and 3 are present in
1da177e4c3f4 ("Linux-2.6.12-rc2") which looks to be the earliest parent
commit in the repository.  What should I do for a Fixes: tag in this
case?

> You are a first time contributor to linux TCP stack, so better make
> sure your claims are solid.

I fear that I may not have expressed the problems and solutions in a
manner that imparted the ideas well.

Maybe I added too much detail in the description for patch 1, which may
have obscured the problem: val is capped to sysctl_rmem_max *before* it
is doubled (resulting in the possibility for sk_rcvbuf to be set to
2*sysctl_rmem_max, rather than it being capped at sysctl_rmem_max).

Maybe I was not explicit enough in the description for patch 3: space is
expanded into sock_net(sk)->ipv4.sysctl_tcp_rmem[2] and sysctl_rmem_max
without first shrinking them to discount the overhead.

> > Patches 2 and 4 might be arguable, though.
> 
> So we have to pick up whatever pleases us ?

I have been treating all of these changes together because they all kind
of work together to provide a consistent model and configurability for
the initial receive window.

Patches 1 and 3 address bugs.
Patch 2 addresses an inconsistency in how overhead is treated specially
for TCP sockets.
Patch 4 addresses the 64KB limit which has been imposed.

If you think that they should be treated separately, I can separate them
to not be combined into a series.  Though tcp_space_from_win(),
introduced by patch 2, is also used by patch 3.

> > Is you objection primarily about the limit removed by patch 4?
> >
> > > Hint : 64K is really the max allowed by TCP standards. Yes, this is
> > > sad, but this is it.
> >
> > Do you mean the limit imposed by the size of the "Window Size" header
> > field?  This limitation is directly addressed by the check in
> > __tcp_transmit_skb():
> >
> >         if (likely(!(tcb->tcp_flags & TCPHDR_SYN))) {
> >                 th->window      = htons(tcp_select_window(sk));
> >                 tcp_ecn_send(sk, skb, th, tcp_header_size);
> >         } else {
> >                 /* RFC1323: The window in SYN & SYN/ACK segments
> >                  * is never scaled.
> >                  */
> >                 th->window      = htons(min(tp->rcv_wnd, 65535U));
> >         }
> >
> > and checking (and capping it there) allows for the field to not overflow
> > while also not artificially restricting the size of the window which
> > will later be advertised (once window scaling is negotiated).
> >
> > > I will not spend hours of work running  packetdrill tests over your
> > > changes, but I am sure they are now quite broken.
> > >
> > > If you believe auto tuning is broken, fix it properly, without trying
> > > to change all the code so that you can understand it.
> >
> > The removal of the limit specifically addresses the situation where auto
> > tuning cannot work: on the initial burst.
> 
> Which standard allows for a very big initial burst ?
> AFAIK, IW10 got a lot of pushback, and that was only for a burst of ~14600 bytes
> Allowing arbitrarily large windows needs IETF approval.

Should not a TCP implementation be generous in what it accepts?

The removal of the limit is not trying to force an increase of the size
of an initially sent burst, it is only trying to allow for the reception
of an initial burst which may have been sent by another host.

A sender should not rely on the receiver's advertised window to prevent
it from causing congestion.

> >  There is no way to know
> > whether an installation desires to receive a larger first burst unless
> > it is specifically configured - and this limit prevents such
> > configuration.
> >
> > > I strongly advise you read RFC 7323 before doing any changes in TCP
> > > stack, and asking us to spend time reviewing your patches.
> >
> > Can you point out the part of the RFC which would be violated by
> > initially (that is, the first packet after the SYN) advertising a window
> > larger than 64KB?
> 
> We handle gradual increase of rwin based on the behavior of
> applications and senders (skb len/truesize ratio)
> 
> Again if you believe autotuning is broken please fix it, instead of
> throwing it away.

Removing the limit is not an attempt to remove the autotuning, it is an
attempt to provide the ability for a user to increase what a TCP
connection can initially receive.  This can be used to configure where
autotuning *starts*.

> Changing initial RWIN can have subtle differences on how fast DRS algo
> can kick in.
> 
> This kind of change would need to be heavily tested, with millions of
> TCP flows in the wild.
> (ie not in a lab environment)
> 
> Have you done this ? What happens if flows are malicious and sent 100
> bytes per segment ?

Removing the limit would not remove protection from such an attack.  If
there was concern over such an attack at a particular installation, the
default sysctl_tcp_rmem[1] of 128KB could be depended upon (along with
the default tcp_adv_win_scale of 1) to achieve the same behavior that
the limit provides.

Instead, the removal of the limit allows for a user who is not concerned
about such an attack to configure an installation such that the
reception of larger than 64KB initial bursts is possible.

Removing the limit does not impose a choice on the user.  Leaving the
limit in place does.
