Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE056209EE4
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404866AbgFYMvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404650AbgFYMvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:51:42 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB06C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:51:42 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e15so3462319vsc.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jBdhd7Cbzzjy5U+lU4Sf+DU0eyd2qCZMw4KOM9KXX3k=;
        b=UbjznKUlrS7xNJB7OuVQx2pKc5BCqH1mzpKmS4m8ljst1qKs//xn7Te9J127ndgRE4
         zn48vM6lnB/k9ijglrrGEGrFwUxSVzvumT4MPyxpaO40tMrhao0FAkZsQ0awshT1+taq
         5znaDFTmovErjr6633dOlRG1mK6WhuANMSk8kHWo6HwqzsP5ml3BNFXG44JuoxaZBsS8
         rWnRJTvS0mMc8sPD5SSHHo8zkxA9yHliGMdLEtM8weO/ZAkfhG5xL+7ll2GqvWiXyRlp
         uRsoM5tVGr3MffDXRNS9oac2fl2MxIUo/YGG7IiC3gZ9Gu+Y61KNbYpmMnZl/ryFSakf
         ngkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jBdhd7Cbzzjy5U+lU4Sf+DU0eyd2qCZMw4KOM9KXX3k=;
        b=dvMHAK09MWrF38jz+EQSHKLNCfzwVT+zfmGPAxlG1iJGAk0jUVegWscjNHQNOLgKLq
         HcGXJk+4LppHVabEiGoiBbFLreVyUR1SFVLI2ouHmV1SpnccKBVxWrmu6XKz4TCTcFy6
         dI7Tf6T866RAKFhnx+CztBjwh2sqk+mmMXNplH/+SwEc1n5F7shrQ62I/ae4fo5LH0q6
         X2UsulUXJp+xrgvvd8+v92OHGUQDtKLR0+ZTu9+VqpwL0toTN0yYRAFWvPssvSw8unJP
         8ac3QEqX8kpg5Ctq2pXylLTW+leXs9aNmbLYIn47RujFMxNPSJ8vgf9bV3c40PuMCYuk
         xuaQ==
X-Gm-Message-State: AOAM531jRdVXfFAgUNuWwJx+0rFTuAzhkDehF7bX8T+JqqW6ESEPBjOC
        QQvjiMg3CyrFxB3aOH1GYR1ZqKWRw4VMhPBS5OXbDA==
X-Google-Smtp-Source: ABdhPJzuLzWEcb/uqrkcqyE87Gcok041fQYyKOMPpB3kaaMiZ2/pPV7z+V2SEksn1l2hFH40YmWnrteCI4YBEHsNW94=
X-Received: by 2002:a67:eb5a:: with SMTP id x26mr7932755vso.199.1593089500465;
 Thu, 25 Jun 2020 05:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200625115106.23370-1-denis.kirjanov@suse.com>
In-Reply-To: <20200625115106.23370-1-denis.kirjanov@suse.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 25 Jun 2020 08:51:22 -0400
Message-ID: <CADVnQykjvtgVDW9a4Jsj+o5LObB-vG=+p1MaDo37H0T6Zi0zRw@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: don't ignore ECN CWR on pure ACK
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

On Thu, Jun 25, 2020 at 7:51 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
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
> v3:
> - Add a sequence check to avoid sending an ACK to an ACK
>
> v2:
> - Adjusted the comment
> - move CWR check before checking for unacknowledged packets
>
> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> ---
>  net/ipv4/tcp_input.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 12fda8f27b08..f3a0eb139b76 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -261,7 +261,8 @@ static void tcp_ecn_accept_cwr(struct sock *sk, const struct sk_buff *skb)
>                  * cwnd may be very low (even just 1 packet), so we should ACK
>                  * immediately.
>                  */
> -               inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
> +               if (TCP_SKB_CB(skb)->seq != TCP_SKB_CB(skb)->end_seq)
> +                       inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
>         }
>  }
>
> @@ -3665,6 +3666,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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
> @@ -4800,8 +4810,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>         skb_dst_drop(skb);
>         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
>
> -       tcp_ecn_accept_cwr(sk, skb);
> -
>         tp->rx_opt.dsack = 0;
>
>         /*  Queue data for delivery to the user.
> --

Thanks, Denis!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
