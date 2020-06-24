Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145022074C6
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390933AbgFXNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388453AbgFXNnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:43:18 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F51C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:43:18 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id q69so521691vkq.10
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jrv5CSZb7/fO7EFnHdE+w50bao0DyOhhXFqHweiSodA=;
        b=ETVJKi4EmM/M6dqb7CRh4y4ISfFAiej0VyAQb0J1V902U9dA84xmmbx1snO+1cQ6C6
         GPK+Pe8CW8PkoieyEx6gQ2otMxUYjebKkXFEcJgjHK+uHuvKq9xvSTlgaq13tYpYL3im
         iwAIGNsr9kK0e5a/+KjyIhwhxihKu/UvywuDW9IBwMOAg79lKh9tMTzqzO9+yF1PTb7W
         h6McqONVYMiyGr8FOB3E2xO17P5U7rE6aFDUCHb1wI0ZYLraYfsjsyaQ5qorBvqxJjun
         v4GALE46REhi91k2VAOeunCGrMQU5t0KEYYv/7u1RD2nIBXbXnlhzgoMGwm/kZBgm72q
         djWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jrv5CSZb7/fO7EFnHdE+w50bao0DyOhhXFqHweiSodA=;
        b=ugVVoDBpVePU6vN5ydB0IbMM2ifqEjr9TJ+YNLYJSgtfblkJLpX7hW2ZIXVH+i+0fe
         GarOClR1J9xNICrE1azDpZGZJciI5MTZGfYIfLnLqmSZZzoutmjrGHUIbkUYa8Ilu15H
         xVuItYJJ1h6SKbdh6RCiQmARnyVCTgYMcfoBRAAM0mSWYHs0QHwPxVY6jvy6mdTWC/yd
         1rBayoknk9+3t1t8Tyc1Dro4HQW/VXNGTrJOk7s4ud98HUDdgPO42EQaqFwHwnjFT4Ur
         UfHASGEfNqlK72zviKG1J1U/0efvAR2WNMcJXNf4g27WIf1oPl7G1Cd88cRKPZ6MPAqQ
         rYEw==
X-Gm-Message-State: AOAM532SYX3iaKS5UMEZKMJZPXdUJ7bBPFOvsUSBIExFoZwaGP3O7B0k
        FVVYPAXBDmiRZ9nTu1/Hn3k5ekrj5dZl4uEtz4u3ekl8TE8=
X-Google-Smtp-Source: ABdhPJye08fQLbpcnezcje1FZrZXwI1rO+IiKHjRsE5pDji6ixKzQQuFu54w79wty6aqBtVOvCUgMmyvxrIVN607smM=
X-Received: by 2002:a1f:e841:: with SMTP id f62mr23720663vkh.66.1593006196695;
 Wed, 24 Jun 2020 06:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200624095748.8246-1-denis.kirjanov@suse.com>
In-Reply-To: <20200624095748.8246-1-denis.kirjanov@suse.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 24 Jun 2020 09:43:00 -0400
Message-ID: <CADVnQym6aoueiB-auSxgp5tp0rjjte+MaxRPWd3t44F5VueKdA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: don't ignore ECN CWR on pure ACK
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Scheffenegger, Richard" <Richard.Scheffenegger@netapp.com>,
        Bob Briscoe <ietf@bobbriscoe.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 5:58 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
> there is a problem with the CWR flag set in an incoming ACK segment
> and it leads to the situation when the ECE flag is latched forever
>
> the following packetdrill script shows what happens:
>
> // Stack receives incoming segments with CE set
> +0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
> +0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
> +0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535
>
> // Stack repsonds with ECN ECHO
> +0.0 >[noecn]  . 1001:1001(0) ack 12001
> +0.0 >[noecn] E. 1001:1001(0) ack 13001
> +0.0 >[noecn] E. 1001:1001(0) ack 14001
>
> // Write a packet
> +0.1 write(3, ..., 1000) = 1000
> +0.0 >[ect0] PE. 1001:2001(1000) ack 14001
>
> // Pure ACK received
> +0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535
>
> // Since CWR was sent, this packet should NOT have ECE set
>
> +0.1 write(3, ..., 1000) = 1000
> +0.0 >[ect0]  P. 2001:3001(1000) ack 14001
> // but Linux will still keep ECE latched here, with packetdrill
> // flagging a missing ECE flag, expecting
> // >[ect0] PE. 2001:3001(1000) ack 14001
> // in the script
>
> In the situation above we will continue to send ECN ECHO packets
> and trigger the peer to reduce the congestion window. To avoid that
> we can check CWR on pure ACKs received.
>
> v2:
> - Adjusted the comment
> - move CWR check before checking for unacknowledged packets
>
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> ---
>  net/ipv4/tcp_input.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 12fda8f27b08..f1936c0cb684 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3665,6 +3665,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
>                 tcp_in_ack_event(sk, ack_ev_flags);
>         }
>
> +       /* This is a deviation from RFC3168 since it states that:
> +        * "When the TCP data sender is ready to set the CWR bit after reducing
> +        * the congestion window, it SHOULD set the CWR bit only on the first
> +        * new data packet that it transmits."
> +        * We accept CWR on pure ACKs to be more robust
> +        * with widely-deployed TCP implementations that do this.
> +        */
> +       tcp_ecn_accept_cwr(sk, skb);
> +
>         /* We passed data and got it acked, remove any soft error
>          * log. Something worked...
>          */
> @@ -4800,8 +4809,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>         skb_dst_drop(skb);
>         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
>
> -       tcp_ecn_accept_cwr(sk, skb);
> -
>         tp->rx_opt.dsack = 0;
>
>         /*  Queue data for delivery to the user.
> --

Thanks for the patch!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
