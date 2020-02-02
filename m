Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6732114FB5B
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 04:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBBDkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 22:40:32 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55790 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgBBDkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 22:40:32 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so4736939pjz.5;
        Sat, 01 Feb 2020 19:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=zxDdizwVS9S9zbW6CYoZPwsd4Ai686l2FU5DDLJ17vw=;
        b=l08CHI0xbb5x/mRNuqhvo7dn96NZE1Rk5E9r+joP1rpIEgJmDAIxwW/Z3BrwtAKgMJ
         F1Mtx7YOwJ+Olbawcbt+h5aWvN2eF8Mos438at+QFcacHzkgqgQPsnOhzXpwfVfLY7Yg
         ya/ajubrJPb4AWOlEmAQG4bUtvjTWwWLfzSIAq1Oc0hb61lIwn990lLlVM8tIvkxscXU
         kC6kKyeQ1eOMvTxY2lIDVSQXGqiUdau/2h6bnaEBPZM0kvI6rabgRG0DnFcK9PGox5xj
         9PBKJ2lLvLZhx+l9Y4+FFKd2xzxRJFzJdSxTjHBzLTQsAyknU0GF3JPy090VJEhqWSLi
         ivaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=zxDdizwVS9S9zbW6CYoZPwsd4Ai686l2FU5DDLJ17vw=;
        b=QejVxrj/nR8DOUKaSSm0Ivlqc1I5UhRoFEwXTy5PPcU2OqaFp4M5jsq7n0T6sjZOcS
         l2dq7eqdaRyL4Mp+QtfOPY+VF+QhAw1svfcQT0BkP9M9R31XKRl6vYYBimL5lBQ8lb3+
         pD+NrZDU/BENh5G+YNBFi26GwHzPF/wf5PDm4d1dOlrpw2FA0q+vzftI196xbnghkwR+
         tLlhIjfgydMA3Cz0Za4pVK4wt2bR7oosyFnaXXnU3eWJaCujUX2G+lX7wHtvFOSi9cYT
         npF4UiQPwAmKxw4tljEj2UfglURpzhwhdqhxLuQwl0PwV1cLavK1u1mFgjBgkex5rq0I
         Un/w==
X-Gm-Message-State: APjAAAUx97xQm5EOygBkiZY0TLq0Inpt475giyyWAdt+smIv8Nf8f5oA
        MbXdH81RkQxgALE3vEadpyA=
X-Google-Smtp-Source: APXvYqxcmaKlufJVo2ihghkddnV8StYoKf1O5tQsIsCbOQbfm+SsL/iLjWNfn+zjre0huFPmE2bpIw==
X-Received: by 2002:a17:90b:87:: with SMTP id bb7mr21920033pjb.49.1580614831368;
        Sat, 01 Feb 2020 19:40:31 -0800 (PST)
Received: from localhost.localdomain ([116.84.110.10])
        by smtp.gmail.com with ESMTPSA id e15sm15691231pja.13.2020.02.01.19.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 19:40:30 -0800 (PST)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     sj38.park@gmail.com, David.Laight@aculab.com, aams@amazon.com,
        davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, shuah@kernel.org,
        sjpark@amazon.de
Subject: Re: Re: [PATCH v2.1 1/2] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Sun,  2 Feb 2020 04:40:19 +0100
Message-Id: <20200202034019.16097-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <735f9641-eb21-05f3-5fa4-2189ec84d5da@gmail.com> (raw)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 10:23:43 -0800 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> 
> 
> On 2/1/20 6:53 AM, sj38.park@gmail.com wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > When closing a connection, the two acks that required to change closing
> > socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
> > reverse order.  This is possible in RSS disabled environments such as a
> > connection inside a host.
> > 
> > For example, expected state transitions and required packets for the
> > disconnection will be similar to below flow.
> > 
> > 	 00 (Process A)				(Process B)
> > 	 01 ESTABLISHED				ESTABLISHED
> > 	 02 close()
> > 	 03 FIN_WAIT_1
> > 	 04 		---FIN-->
> > 	 05 					CLOSE_WAIT
> > 	 06 		<--ACK---
> > 	 07 FIN_WAIT_2
> > 	 08 		<--FIN/ACK---
> > 	 09 TIME_WAIT
> > 	 10 		---ACK-->
> > 	 11 					LAST_ACK
> > 	 12 CLOSED				CLOSED
> > 
> > In some cases such as LINGER option applied socket, the FIN and FIN/ACK
> > will be substituted to RST and RST/ACK, but there is no difference in
> > the main logic.
> > 
> > The acks in lines 6 and 8 are the acks.  If the line 8 packet is
> > processed before the line 6 packet, it will be just ignored as it is not
> > a expected packet, and the later process of the line 6 packet will
> > change the status of Process A to FIN_WAIT_2, but as it has already
> > handled line 8 packet, it will not go to TIME_WAIT and thus will not
> > send the line 10 packet to Process B.  Thus, Process B will left in
> > CLOSE_WAIT status, as below.
> > 
> > 	 00 (Process A)				(Process B)
> > 	 01 ESTABLISHED				ESTABLISHED
> > 	 02 close()
> > 	 03 FIN_WAIT_1
> > 	 04 		---FIN-->
> > 	 05 					CLOSE_WAIT
> > 	 06 				(<--ACK---)
> > 	 07	  			(<--FIN/ACK---)
> > 	 08 				(fired in right order)
> > 	 09 		<--FIN/ACK---
> > 	 10 		<--ACK---
> > 	 11 		(processed in reverse order)
> > 	 12 FIN_WAIT_2
> > 
> > Later, if the Process B sends SYN to Process A for reconnection using
> > the same port, Process A will responds with an ACK for the last flow,
> > which has no increased sequence number.  Thus, Process A will send RST,
> > wait for TIMEOUT_INIT (one second in default), and then try
> > reconnection.  If reconnections are frequent, the one second latency
> > spikes can be a big problem.  Below is a tcpdump results of the problem:
> > 
> >     14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
> >     14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
> >     14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
> >     /* ONE SECOND DELAY */
> >     15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
> > 
> > This commit mitigates the problem by reducing the delay for the next SYN
> > if the suspicous ACK is received while in SYN_SENT state.
> > 
> > Following commit will add a selftest, which can be also helpful for
> > understanding of this issue.
> > 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  net/ipv4/tcp_input.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 2a976f57f7e7..baa4fee117f9 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
> >  		 *        the segment and return)"
> >  		 */
> >  		if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> > -		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> > +		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> > +			/* Previous FIN/ACK or RST/ACK might be ignored. */
> > +			if (icsk->icsk_retransmits == 0)
> > +				inet_csk_reset_xmit_timer(sk,
> > +						ICSK_TIME_RETRANS,
> > +						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
> >  			goto reset_and_undo;
> > +		}
> >  
> >  		if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
> >  		    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> > 
> 
> Please add my
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Please resend the whole patch series as requested by netdev maintainers.
> 
> 
> vi +134 Documentation/networking/netdev-FAQ.rst
> 
> Q: I made changes to only a few patches in a patch series should I resend only those changed?
> ---------------------------------------------------------------------------------------------
> A: No, please resend the entire patch series and make sure you do number your
> patches such that it is clear this is the latest and greatest set of patches
> that can be applied.

Thank you, just sent it: https://lore.kernel.org/linux-kselftest/20200202033827.16304-1-sj38.park@gmail.com/

Also, appreciate for kindly noticing the rule :)


Thanks,
SeongJae Park

> 
> 
