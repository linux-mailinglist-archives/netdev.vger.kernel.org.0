Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33139206F0E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389500AbgFXIiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388962AbgFXIiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:38:01 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C46C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:38:00 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g20so659807edm.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=NcMnqestfxxll9wJOJt/JcZOJawDDFPWqDhcaC32ncU=;
        b=R2MK1pnzR52NwibVALBFYchPK5IJLlCXTen3tb3gz8bzBQGFSh2RIOiC3Ul4AEmMz7
         hzQQqDIEsd4cj6XynzxgqlUBRoq8sFplEGpHxx9y5Ksvc8UdacXzS34goWtw0MYppZtY
         22QArMs/2SgMpkf4SNDcYUiZf+S0VKGL8oZ/Fag9v2dKagmzbibRI/W8+AEXPlOTfaLA
         IoYd+S1ZigO+BUDTKZe69zWPGjPtPCHpCXOQSm4Osjas0RNgIVQsqthqdkXwVHc9FYQK
         ojlzWvbmWMkLGRyimi60BCGxRDom+k8SS6D88fjVgbOnVqN1wa65SjftW2EsUKZZ74Gd
         MZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=NcMnqestfxxll9wJOJt/JcZOJawDDFPWqDhcaC32ncU=;
        b=eWigaq52+OSqHlO6/pLafdm2XNiBNTAosegUvON+HDymJgzH8JY+yGcF7xzsoLvMN5
         Y61ivH+qIt3if9BQS8fdNygrKGgMtZ1E4m3HjhaNMwTfq0m4EBfRnpqiN+7Bx/KzUvf7
         PuGEWooXb8H2+fzlV3DOkWRskV4ZrP0sC9tCasjl/TswnEH1ZuSAtNoNFu6Aa5jPk+Av
         FlGQR1hojwDaz/1Fl7m5wmFF326GwDyw1a3GgzYxdHwteWIQHHq6wso0Bq+hZJIViDnH
         qUX2wRn2B5Z0wPeou7D18pBnh1ySCX0doO/FXl4F4ZBJeTWy9vmH6/TYIfMMby6w7iLd
         oILQ==
X-Gm-Message-State: AOAM530HqKznkeZ1UvQ+dg5Z8DfR5zeziTAjclVv39rJvd/dHXGRcBUt
        Pfp7G2zRNcmmpEVs3XWQ/U5Qa7Gg6xZ47snUHAJzCtHrRkA=
X-Google-Smtp-Source: ABdhPJwbcR4onw1R2piP/Y+sNTOu9YpwpgRU0dIBX9EcZC0Qd77y6YQDU8kC8XQQzXD4hpDgk6iFG2BnUzWX2/ooco0=
X-Received: by 2002:aa7:d8c2:: with SMTP id k2mr15576827eds.346.1592987878912;
 Wed, 24 Jun 2020 01:37:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Wed, 24 Jun 2020 01:37:58
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <CADVnQynUJgMVBR7aiS4Qw1SZxtgNz16HjyP13JUwtR20veXv_Q@mail.gmail.com>
References: <20200623145343.7546-1-denis.kirjanov@suse.com> <CADVnQynUJgMVBR7aiS4Qw1SZxtgNz16HjyP13JUwtR20veXv_Q@mail.gmail.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 24 Jun 2020 11:37:58 +0300
Message-ID: <CAOJe8K0aD97V6+Sa6Mdx4CfmuCc1UNFV1n8VLFjvOoU_7Xxm9g@mail.gmail.com>
Subject: Re: [PATCH] tcp: don't ignore ECN CWR on pure ACK
To:     Neal Cardwell <ncardwell@google.com>
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

On 6/23/20, Neal Cardwell <ncardwell@google.com> wrote:
> On Tue, Jun 23, 2020 at 10:54 AM Denis Kirjanov <kda@linux-powerpc.org>
> wrote:
>>
>> there is a problem with the CWR flag set in an incoming ACK segment
>> and it leads to the situation when the ECE flag is latched forever
>>
>> the following packetdrill script shows what happens:
>>
>> // Stack receives incoming segments with CE set
>> +0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
>> +0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
>> +0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535
>>
>> // Stack repsonds with ECN ECHO
>> +0.0 >[noecn]  . 1001:1001(0) ack 12001
>> +0.0 >[noecn] E. 1001:1001(0) ack 13001
>> +0.0 >[noecn] E. 1001:1001(0) ack 14001
>>
>> // Write a packet
>> +0.1 write(3, ..., 1000) = 1000
>> +0.0 >[ect0] PE. 1001:2001(1000) ack 14001
>>
>> // Pure ACK received
>> +0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535
>>
>> // Since CWR was sent, this packet should NOT have ECE set
>>
>> +0.1 write(3, ..., 1000) = 1000
>> +0.0 >[ect0]  P. 2001:3001(1000) ack 14001
>> // but Linux will still keep ECE latched here, with packetdrill
>> // flagging a missing ECE flag, expecting
>> // >[ect0] PE. 2001:3001(1000) ack 14001
>> // in the script
>>
>> In the situation above we will continue to send ECN ECHO packets
>> and trigger the peer to reduce the congestion window.
>>
>> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
>> ---
>>  net/ipv4/tcp_input.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 12fda8f27b08..e00b88c8598d 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -3696,8 +3696,13 @@ static int tcp_ack(struct sock *sk, const struct
>> sk_buff *skb, int flag)
>>                                       &rexmit);
>>         }
>>
>> -       if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
>> +       if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP)) {
>> +               /* If we miss the CWR flag then ECE will be
>> +                * latched forever.
>> +                */
>> +               tcp_ecn_accept_cwr(sk, skb);
>>                 sk_dst_confirm(sk);
>> +       }
>>
>>         delivered = tcp_newly_delivered(sk, delivered, flag);
>>         lost = tp->lost - lost;                 /* freshly marked lost */
>> @@ -4800,8 +4805,6 @@ static void tcp_data_queue(struct sock *sk, struct
>> sk_buff *skb)
>>         skb_dst_drop(skb);
>>         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
>>
>> -       tcp_ecn_accept_cwr(sk, skb);
>> -
>>         tp->rx_opt.dsack = 0;
>>
>>         /*  Queue data for delivery to the user.
>> --
>> 2.27.0
>>
>
> Hi Denis -
>
> Thanks for this patch!

Hi Neal,

> A few thoughts:
>
> (1) Richard Scheffenegger (cc-ed) raised this issue in January.
>   IMHO The Linux TCP code is RFC-compliant here. If you have a
>   sender that is sending CWR on pure ACKs, then that sender is
>   violating RFC3168, which specifies that CWR should only sent on
>   data segments, so that the sender can be sure that there is a
>   cwnd reduction even if a packet with CWR set is lost:
>
>   RFC3168 says:
>
> """
> When an ECN-Capable TCP sender reduces its congestion window for
> any reason (because of a retransmit timeout, a Fast Retransmit,
> or in response to an ECN Notification), the TCP sender sets the
> CWR flag in the TCP header of the first new data packet sent
> after the window reduction.  If that data packet is dropped in
> the network, then the
> ...
> sending TCP will have to reduce the congestion window again and
> retransmit the dropped packet.
>
> We ensure that the "Congestion Window Reduced" information is
> reliably delivered to the TCP receiver.  This comes about from
> the fact that if the new data packet carrying the CWR flag is
> dropped, then the TCP sender will have to again reduce its
> congestion window, and send another new data packet with the CWR
> flag set.  Thus, the CWR bit in the TCP header SHOULD NOT be set
> on retransmitted packets.
>
> When the TCP data sender is ready to set the CWR bit after
> reducing the congestion window, it SHOULD set the CWR bit only on
> the first new data packet that it transmits.
> """
>
> (2) Even given (1), I would agree with Richard's point that TCP
>    receivers should accept CWR on pure ACKs, per the rationale of
>    Postel's robustness principle ("Be liberal in what you accept,
>    and conservative in what you send.")  Here we should be
>    liberal and accept the CWR in the pure ACK, particularly
>    because we know that at least one class of widely-deployed TCP
>    stacks (*BSD stacks) do this.
>
> (3) Given (2), I don't think this is the proper place to accept a
>    CWR.  That point in the code is not reached by a connection
>    that is only currently receiving data, because of the lines
>    above that say:
>
> if (!prior_packets)
> goto no_queue;

Right, here we don't loose a segment

>
>    Accepting CWR is something a data receiver does (to respond to
>    a data sender that is signalling that it has slowed down).  So
>    even though I agree we should make the code more
>    liberal/robust in acepting CWR on pure ACK, I don't think this
>    is the right spot to insert the code.
>
> (4) I would say this is an interoperability bug fix, so this
>    should be explicitly targetd to the "net" branch.
Sure

>
> (5) If you are able and have time, it would be nice to post the
>    full packetdrill script, either in the commit message, or as a
>    pull request to the packetdrill github project, so that the
>    Linux community may benefit from the full test case.

Initially I thought that we do have packetdrill scripts in the kernel
but we don't.
Sure, I'll post a patch.  Actually I've sent a different patch before
(regarding gcc 10 issue) and looks like the mailing list doesn't work.
Do I have to do that through gihub?

>
> Putting all that together, I think this patch should add a
> comment that this code snippet is accepting non-RFC3168-compliant
> behavior for the sake of robustness to known deployed stacks, and
> should put that code in a place reached by data receivers. I
> would suggest perhaps something like:

Thanks for review!
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 12fda8f27b08..717475b6f5c3 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3665,6 +3665,13 @@ static int tcp_ack(struct sock *sk, const
> struct sk_buff *skb, int flag)
>                 tcp_in_ack_event(sk, ack_ev_flags);
>         }
>
> +       /* An RFC3168-compliant sender should only set CWR on data
> segments.
> +        * ("it SHOULD set the CWR bit only on the first new data packet
> that
> +        * it transmits." However, we accept CWR on pure ACKs to be more
> robust
> +        * with widely-deployed TCP implementations that do this.
> +        */
> +       tcp_ecn_accept_cwr(sk, skb);
> +
>         /* We passed data and got it acked, remove any soft error
>          * log. Something worked...
>          */
> @@ -4800,8 +4807,6 @@ static void tcp_data_queue(struct sock *sk,
> struct sk_buff *skb)
>         skb_dst_drop(skb);
>         __skb_pull(skb, tcp_hdr(skb)->doff * 4);
>
> -       tcp_ecn_accept_cwr(sk, skb);
> -
>         tp->rx_opt.dsack = 0;
>
>         /*  Queue data for delivery to the user.
> ---
>
> best,
> neal
>
