Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1025121903E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGHTL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:11:26 -0400
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:34312 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbgGHTLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:11:25 -0400
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.42/8.16.0.42) with SMTP id 068HEvL7005508;
        Wed, 8 Jul 2020 10:19:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=20180706; bh=NkZqSy0xFO8ii2rdvOsba2adKyBBwa3bmvWPVr7gdD4=;
 b=oHKMrv/oWfYGCnaS4BIuTUU0NoCJJGWMAuZxC93pru8XxA2hlnb5p2cx9lio9EKEb8TE
 sLfjLcdNbfDxMOemlJkXGr1WSTm4FBl8inySxfwn5NUWdMPhejx1+EGs1IMKXyaYH8xk
 lKVG6zgnFXiYshuHCrEmB3HMpucwnAGCGmCqt/JYStp/IzrbBUt25Jd5FbCucSYILi5X
 Hrpg2bnon3p7KhG65uLMuNZ4t3DAnjM6q1sqf+ehVLhk8QL3M3R129uM5A3e/fV6Zvg4
 Gic88ncP7O2luEafg68onGa8b42TvV32ns0SHfGIO5WSMx1WXJnQbXKfHOGY7FDQ2yj5 nA== 
Received: from rn-mailsvcp-mta-lapp03.rno.apple.com (rn-mailsvcp-mta-lapp03.rno.apple.com [10.225.203.151])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 322re36b52-35
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 08 Jul 2020 10:19:36 -0700
Received: from rn-mailsvcp-mmp-lapp02.rno.apple.com
 (rn-mailsvcp-mmp-lapp02.rno.apple.com [17.179.253.15])
 by rn-mailsvcp-mta-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QD500DKUUSLPAT0@rn-mailsvcp-mta-lapp03.rno.apple.com>;
 Wed, 08 Jul 2020 10:19:33 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp02.rno.apple.com by
 rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QD500S00UARE900@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Wed,
 08 Jul 2020 10:19:33 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 516b7ce625f7fc59894c2600aef8414a
X-Va-E-CD: 6501d2b2038db7550b1890cbdfe7c19b
X-Va-R-CD: 058ef0a58bcd31645fadb9ed01b1fc5d
X-Va-CD: 0
X-Va-ID: 1c2a3b51-4ea9-4758-9404-6a0dc201a4f0
X-V-A:  
X-V-T-CD: 516b7ce625f7fc59894c2600aef8414a
X-V-E-CD: 6501d2b2038db7550b1890cbdfe7c19b
X-V-R-CD: 058ef0a58bcd31645fadb9ed01b1fc5d
X-V-CD: 0
X-V-ID: e7a92e77-5d65-4e9e-b8e9-85b05285d7ee
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_15:2020-07-08,2020-07-08 signatures=0
Received: from localhost ([17.149.233.77])
 by rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QD5008RTUSI3M00@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Wed,
 08 Jul 2020 10:19:31 -0700 (PDT)
Date:   Wed, 08 Jul 2020 10:19:30 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Subject: Re: [PATCH net] tcp: Initialize ca_priv when inheriting from listener
Message-id: <20200708171930.GF58730@MacBook-Pro-64.local>
References: <20200708041030.24375-1-cpaasch@apple.com>
 <CANn89iLZ1kDbpm81ftXkrtKBNx-NVHSYzP++_Jd0-xwy2J2Mpg@mail.gmail.com>
 <CANn89i+mTjmvyd-=q=_tw7eYe6xAbto70YjsUrvn7TMT86qAdw@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <CANn89i+mTjmvyd-=q=_tw7eYe6xAbto70YjsUrvn7TMT86qAdw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_15:2020-07-08,2020-07-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/07/20 - 21:51, Eric Dumazet wrote:
> On Tue, Jul 7, 2020 at 9:43 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> 
> > Could this be done instead in tcp_disconnect() ?
> >
> 
> Note this might need to extend one of the change done in commit 4d4d3d1e8807d6
> ("[TCP]: Congestion control initialization.")
> 
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index 3172e31987be4232af90e7b204742c5bb09ef6ca..62878cf26d9cc5c0ae44d5ecdadd0b7a5acf5365
> 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -197,7 +197,7 @@ static void tcp_reinit_congestion_control(struct sock *sk,
>         icsk->icsk_ca_setsockopt = 1;
>         memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
> 
> -       if (sk->sk_state != TCP_CLOSE)
> +       if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
>                 tcp_init_congestion_control(sk);
>  }

Yes, that would work as well. In tcp_disconnect() it would have to be a
tcp_cleanup_congestion_control() followed by the memset to 0. Otherwise we
end up leaking memory for those that use AF_UNSPEC on a connection that did
have CDG allocate the gradients.

Thanks for the suggestion, I will work on a v2.


Christoph

