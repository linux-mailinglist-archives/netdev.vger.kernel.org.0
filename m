Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0DD218E2C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGHRZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:25:11 -0400
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:40694 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbgGHRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:25:11 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 13:25:10 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 068HJXp8021096;
        Wed, 8 Jul 2020 10:25:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=20180706; bh=FHWMBIBBYiy0/mj4Gxgjm76oRxg503z0uvWQmrltctI=;
 b=NMykBQ/f9ox1sZf6Agxu0k6pnN2zsL0zwJVMk2DhYMTjSPmYNvojd+Cac18cAa+O113U
 TEnCvriJzP9ypMmjLQgim+Qq0fUbOl2E4hND0Z4WV388DCmjTgvbLOLg4K3DpiAqXpnW
 Fldsv2QZws7fJP7KPCCUoHQ3AeUipTCRN5gXkcYubMnc9UKSL7xD6wY/YGqI4ZZIC5TQ
 ccpRt9WmD/6jTSaENE1mvG0I1lz8pzE8IyuYmpqLmj9jVfeoa/+I2Ge/9AOIFUN/FhAu
 Wu1Hu9paj8T/HvjK36oNVgUHauJGqWqcH28+WgEwQw9QpgKDet3AMpoC8r55tbEimXPO dA== 
Received: from rn-mailsvcp-mta-lapp02.rno.apple.com (rn-mailsvcp-mta-lapp02.rno.apple.com [10.225.203.150])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 322petn7xb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 08 Jul 2020 10:25:06 -0700
Received: from rn-mailsvcp-mmp-lapp02.rno.apple.com
 (rn-mailsvcp-mmp-lapp02.rno.apple.com [17.179.253.15])
 by rn-mailsvcp-mta-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QD500U5MV1SY0D0@rn-mailsvcp-mta-lapp02.rno.apple.com>;
 Wed, 08 Jul 2020 10:25:05 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp02.rno.apple.com by
 rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QD500S00UARE900@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Wed,
 08 Jul 2020 10:25:04 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 516b7ce625f7fc59894c2600aef8414a
X-Va-E-CD: 6501d2b2038db7550b1890cbdfe7c19b
X-Va-R-CD: 058ef0a58bcd31645fadb9ed01b1fc5d
X-Va-CD: 0
X-Va-ID: 05cac841-d1b0-4aab-ba8a-61bba1a8daab
X-V-A:  
X-V-T-CD: 516b7ce625f7fc59894c2600aef8414a
X-V-E-CD: 6501d2b2038db7550b1890cbdfe7c19b
X-V-R-CD: 058ef0a58bcd31645fadb9ed01b1fc5d
X-V-CD: 0
X-V-ID: 8e700de5-a427-48e1-bde3-8029c7c82569
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_15:2020-07-08,2020-07-08 signatures=0
Received: from localhost ([17.149.233.77])
 by rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QD5008LVV1S3M10@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Wed,
 08 Jul 2020 10:25:04 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:25:03 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Subject: Re: [PATCH net] tcp: Initialize ca_priv when inheriting from listener
Message-id: <20200708172503.GG58730@MacBook-Pro-64.local>
References: <20200708041030.24375-1-cpaasch@apple.com>
 <CANn89iLZ1kDbpm81ftXkrtKBNx-NVHSYzP++_Jd0-xwy2J2Mpg@mail.gmail.com>
 <CANn89i+mTjmvyd-=q=_tw7eYe6xAbto70YjsUrvn7TMT86qAdw@mail.gmail.com>
 <20200708171930.GF58730@MacBook-Pro-64.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20200708171930.GF58730@MacBook-Pro-64.local>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_15:2020-07-08,2020-07-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08/20 - 10:19, Christoph Paasch wrote:
> On 07/07/20 - 21:51, Eric Dumazet wrote:
> > On Tue, Jul 7, 2020 at 9:43 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > 
> > > Could this be done instead in tcp_disconnect() ?
> > >
> > 
> > Note this might need to extend one of the change done in commit 4d4d3d1e8807d6
> > ("[TCP]: Congestion control initialization.")
> > 
> > diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> > index 3172e31987be4232af90e7b204742c5bb09ef6ca..62878cf26d9cc5c0ae44d5ecdadd0b7a5acf5365
> > 100644
> > --- a/net/ipv4/tcp_cong.c
> > +++ b/net/ipv4/tcp_cong.c
> > @@ -197,7 +197,7 @@ static void tcp_reinit_congestion_control(struct sock *sk,
> >         icsk->icsk_ca_setsockopt = 1;
> >         memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
> > 
> > -       if (sk->sk_state != TCP_CLOSE)
> > +       if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> >                 tcp_init_congestion_control(sk);
> >  }
> 
> Yes, that would work as well. In tcp_disconnect() it would have to be a
> tcp_cleanup_congestion_control() followed by the memset to 0. Otherwise we

Correction:

Need to call icsk_ca_ops->release. The cleanup-function would also do a
bpf_module_put which we don't want here in tcp_disconnect.


Christoph

> end up leaking memory for those that use AF_UNSPEC on a connection that did
> have CDG allocate the gradients.
> 
> Thanks for the suggestion, I will work on a v2.
> 
> 
> Christoph
> 
