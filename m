Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99502056D2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgFWQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732182AbgFWQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:12:50 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7356CC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:12:49 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e15so2357059vsc.7
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yV9W7hCQC44Hu6aRRgKF8wGpgTXyrT6P4Djt1SbuMbM=;
        b=Cyfysbo9MPXFgVVjn8Miluw1NQpRiMO4jLyv9ttuOz/rSdelqwf6TD1Gv2+e5bzoWT
         nW9KYsnPDcSkC33Pu8nMjtmJwBMVm4fFZYE8t4e/dWqRm/+irBNkUVuKahonti+bda6+
         hai9ALJe+/Je9Egax2LAk6NBoaxvke3HtrZqa1fXjx2YeRhLsBhFMUOv9RWou+g3HWHY
         Z6JMI14YfEzfUf8Uu8ArjHuXyN6x8+pY799gZa4z5lIhmcg95gByYc2LCNYabl5mM6a7
         YtdGtsEeNoKS1ZXLAM1wpRTbhg6QeCZZJTjBmtwQmrnWpoemSJVz7b9Icx+wnq1S1BjE
         jUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yV9W7hCQC44Hu6aRRgKF8wGpgTXyrT6P4Djt1SbuMbM=;
        b=sm6wUZI8lYxnKQJnm0twjog6sulLAVhoKbkBSvtQYi2fRkWi+tGi93G1WQE2zHOtoz
         A9UmsGGVva5TtDn7TEv97kTJhWnNCYYU7SI26TQf+6xS+2Y1BKlF5h5IRFvEHCsBps53
         A3VIYj3a11OBgtR1joFhBYSOdnMJXATkM26vYH67tm3hKSLgruPc3smHz95P2s3XTtyb
         1otZI4EQN07OQsx9xJOTcTNnjYP2CBEisKwpeLoL6OgVoLguow2W1P1VO9uwnwcV24D7
         uNrDItt/joydjV3DtqIqWwXbNJZAuvaJiX6AW0xDVJFCqYrZmRrxInJHNMzOKR/rYpg3
         s2uQ==
X-Gm-Message-State: AOAM533irDMIHE/EHT3ctSElZ8VFQVHhIKMpZZHc6UZxJlfqKFAdBl6p
        1lUAbdek+xP5uXs1IDX2aIGI78Ja7t8QpexOELWjNw==
X-Google-Smtp-Source: ABdhPJwBUOMgF50lu+I5j26A/NWdacsu845Lr8ae2lxKwStxH/E1rLS1iVeT/Bj4Rc3lZXRv800WTuJKPoDQ7MFnWrw=
X-Received: by 2002:a67:eb5a:: with SMTP id x26mr662664vso.199.1592928768133;
 Tue, 23 Jun 2020 09:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200623145343.7546-1-denis.kirjanov@suse.com>
In-Reply-To: <20200623145343.7546-1-denis.kirjanov@suse.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 23 Jun 2020 12:12:31 -0400
Message-ID: <CADVnQynUJgMVBR7aiS4Qw1SZxtgNz16HjyP13JUwtR20veXv_Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: don't ignore ECN CWR on pure ACK
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

On Tue, Jun 23, 2020 at 10:54 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
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
> and trigger the peer to reduce the congestion window.
>
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> ---
>  net/ipv4/tcp_input.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 12fda8f27b08..e00b88c8598d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3696,8 +3696,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
>                                       &rexmit);
>         }
>
> -       if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
> +       if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP)) {
> +               /* If we miss the CWR flag then ECE will be
> +                * latched forever.
> +                */
> +               tcp_ecn_accept_cwr(sk, skb);
>                 sk_dst_confirm(sk);
> +       }
>
>         delivered = tcp_newly_delivered(sk, delivered, flag);
>         lost = tp->lost - lost;                 /* freshly marked lost */
> @@ -4800,8 +4805,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>         skb_dst_drop(skb);
>         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
>
> -       tcp_ecn_accept_cwr(sk, skb);
> -
>         tp->rx_opt.dsack = 0;
>
>         /*  Queue data for delivery to the user.
> --
> 2.27.0
>

Hi Denis -

Thanks for this patch!

A few thoughts:

(1) Richard Scheffenegger (cc-ed) raised this issue in January.
  IMHO The Linux TCP code is RFC-compliant here. If you have a
  sender that is sending CWR on pure ACKs, then that sender is
  violating RFC3168, which specifies that CWR should only sent on
  data segments, so that the sender can be sure that there is a
  cwnd reduction even if a packet with CWR set is lost:

  RFC3168 says:

"""
When an ECN-Capable TCP sender reduces its congestion window for
any reason (because of a retransmit timeout, a Fast Retransmit,
or in response to an ECN Notification), the TCP sender sets the
CWR flag in the TCP header of the first new data packet sent
after the window reduction.  If that data packet is dropped in
the network, then the
...
sending TCP will have to reduce the congestion window again and
retransmit the dropped packet.

We ensure that the "Congestion Window Reduced" information is
reliably delivered to the TCP receiver.  This comes about from
the fact that if the new data packet carrying the CWR flag is
dropped, then the TCP sender will have to again reduce its
congestion window, and send another new data packet with the CWR
flag set.  Thus, the CWR bit in the TCP header SHOULD NOT be set
on retransmitted packets.

When the TCP data sender is ready to set the CWR bit after
reducing the congestion window, it SHOULD set the CWR bit only on
the first new data packet that it transmits.
"""

(2) Even given (1), I would agree with Richard's point that TCP
   receivers should accept CWR on pure ACKs, per the rationale of
   Postel's robustness principle ("Be liberal in what you accept,
   and conservative in what you send.")  Here we should be
   liberal and accept the CWR in the pure ACK, particularly
   because we know that at least one class of widely-deployed TCP
   stacks (*BSD stacks) do this.

(3) Given (2), I don't think this is the proper place to accept a
   CWR.  That point in the code is not reached by a connection
   that is only currently receiving data, because of the lines
   above that say:

if (!prior_packets)
goto no_queue;

   Accepting CWR is something a data receiver does (to respond to
   a data sender that is signalling that it has slowed down).  So
   even though I agree we should make the code more
   liberal/robust in acepting CWR on pure ACK, I don't think this
   is the right spot to insert the code.

(4) I would say this is an interoperability bug fix, so this
   should be explicitly targetd to the "net" branch.

(5) If you are able and have time, it would be nice to post the
   full packetdrill script, either in the commit message, or as a
   pull request to the packetdrill github project, so that the
   Linux community may benefit from the full test case.

Putting all that together, I think this patch should add a
comment that this code snippet is accepting non-RFC3168-compliant
behavior for the sake of robustness to known deployed stacks, and
should put that code in a place reached by data receivers. I
would suggest perhaps something like:

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08..717475b6f5c3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3665,6 +3665,13 @@ static int tcp_ack(struct sock *sk, const
struct sk_buff *skb, int flag)
                tcp_in_ack_event(sk, ack_ev_flags);
        }

+       /* An RFC3168-compliant sender should only set CWR on data segments.
+        * ("it SHOULD set the CWR bit only on the first new data packet that
+        * it transmits." However, we accept CWR on pure ACKs to be more robust
+        * with widely-deployed TCP implementations that do this.
+        */
+       tcp_ecn_accept_cwr(sk, skb);
+
        /* We passed data and got it acked, remove any soft error
         * log. Something worked...
         */
@@ -4800,8 +4807,6 @@ static void tcp_data_queue(struct sock *sk,
struct sk_buff *skb)
        skb_dst_drop(skb);
        __skb_pull(skb, tcp_hdr(skb)->doff * 4);

-       tcp_ecn_accept_cwr(sk, skb);
-
        tp->rx_opt.dsack = 0;

        /*  Queue data for delivery to the user.
---

best,
neal
