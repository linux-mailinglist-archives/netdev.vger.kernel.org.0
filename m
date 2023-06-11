Return-Path: <netdev+bounces-9872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 506F972B02F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 06:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D70D32813B8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 04:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9798115D4;
	Sun, 11 Jun 2023 04:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9815BC
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 04:10:26 +0000 (UTC)
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7D2134
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 21:10:23 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-56d1ca11031so260027b3.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 21:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686456622; x=1689048622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMB3adJq91lmz26k9tK4aZk1aiyVEZDuMjLj/Cm6kzg=;
        b=NE9vGfxUIOWLRVFEpJEHyGye9Jk4Ntx23JDuZMDrOZtfMReZmZ8ktidlssVRyO3ZoN
         i2EbPP4+Nie+csRMtqC04kbkJJcpmmNhhQOJPzgcLYuiZPNLUGQzTjxzPIARq2MnW2Dh
         qC/RQ2mNk5pmXUP1bEiWETxJHwgAP8c6yShGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686456622; x=1689048622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMB3adJq91lmz26k9tK4aZk1aiyVEZDuMjLj/Cm6kzg=;
        b=Ng1UPpQnm74WtcXITCq0PtAXsf3auqv2l021IuIUupEvTsxH1XmXYPVUO3aW4xB0te
         nXWZ1MLiYKunow6d/aLmW1mL9r3N79OaN/W1aCUZlcPyTH2cuKNO73ii+VZH65LuAGRb
         M1zv+KNgcjLl7/PV0Q4Rbrh28pscAK3GPUZpL6CZAJLvi0dAprh59K99/+AmHHZ9MyiI
         mEqWLUvE6b3oWlsgNLF+Vb+rUs6WOfa7xBKVh13aa2O2abCuq1NWgVzm2KUcgXhwZFkm
         fsl6WTUnQUK/c8aOKH9lR0yfwpm8aX09I1B5Aerpn7AEAIX2pUTo5mxeXZGSr7vI8bh0
         4Pgg==
X-Gm-Message-State: AC+VfDy2TfBA/f/sOMZLG0nCxW1S6pe3Uel7L/Y3yj9mXlkjyHUOXdX5
	ckvmcSyNljDZTfSpwtr9GBDSMg==
X-Google-Smtp-Source: ACHHUZ4u8ReVHTZZkfNuebRDlz/O7ySxjC41qdL3VvFEtj6Fovv1EcOZ9pFaWwiO88Puwsau1HLpRw==
X-Received: by 2002:a81:6d4d:0:b0:561:a422:f3cd with SMTP id i74-20020a816d4d000000b00561a422f3cdmr5950774ywc.30.1686456622296;
        Sat, 10 Jun 2023 21:10:22 -0700 (PDT)
Received: from [192.168.2.144] ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id y206-20020a817dd7000000b0055a881abfc3sm1668867ywc.135.2023.06.10.21.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 21:10:21 -0700 (PDT)
Message-ID: <adf56f38-55ba-a878-f48d-31e2b8a59b7b@cloudflare.com>
Date: Sat, 10 Jun 2023 23:10:20 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3] tcp: enforce receive buffer memory limits by
 allowing the tcp window to shrink
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20230609204706.2044591-1-mfreemon@cloudflare.com>
 <CANn89iK+Zged71Hc74Rwk31XdTNiakUnf+yqHDrx1pYKgrnaRw@mail.gmail.com>
From: Mike Freemon <mfreemon@cloudflare.com>
In-Reply-To: <CANn89iK+Zged71Hc74Rwk31XdTNiakUnf+yqHDrx1pYKgrnaRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/9/23 20:43, Eric Dumazet wrote:
> On Fri, Jun 9, 2023 at 10:47 PM Mike Freemon <mfreemon@cloudflare.com> wrote:
>>
>> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>>
>> Under certain circumstances, the tcp receive buffer memory limit
>> set by autotuning (sk_rcvbuf) is increased due to incoming data
>> packets as a result of the window not closing when it should be.
>> This can result in the receive buffer growing all the way up to
>> tcp_rmem[2], even for tcp sessions with a low BDP.
>>
>> To reproduce:  Connect a TCP session with the receiver doing
>> nothing and the sender sending small packets (an infinite loop
>> of socket send() with 4 bytes of payload with a sleep of 1 ms
>> in between each send()).  This will cause the tcp receive buffer
>> to grow all the way up to tcp_rmem[2].
>>
>> As a result, a host can have individual tcp sessions with receive
>> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
>> limits, causing the host to go into tcp memory pressure mode.
>>
>> The fundamental issue is the relationship between the granularity
>> of the window scaling factor and the number of byte ACKed back
>> to the sender.  This problem has previously been identified in
>> RFC 7323, appendix F [1].
>>
>> The Linux kernel currently adheres to never shrinking the window.
>>
>> In addition to the overallocation of memory mentioned above, the
>> current behavior is functionally incorrect, because once tcp_rmem[2]
>> is reached when no remediations remain (i.e. tcp collapse fails to
>> free up any more memory and there are no packets to prune from the
>> out-of-order queue), the receiver will drop in-window packets
>> resulting in retransmissions and an eventual timeout of the tcp
>> session.  A receive buffer full condition should instead result
>> in a zero window and an indefinite wait.
>>
>> In practice, this problem is largely hidden for most flows.  It
>> is not applicable to mice flows.  Elephant flows can send data
>> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
>> triggering a zero window.
>>
>> But this problem does show up for other types of flows.  Examples
>> are websockets and other type of flows that send small amounts of
>> data spaced apart slightly in time.  In these cases, we directly
>> encounter the problem described in [1].
>>
>> RFC 7323, section 2.4 [2], says there are instances when a retracted
>> window can be offered, and that TCP implementations MUST ensure
>> that they handle a shrinking window, as specified in RFC 1122,
>> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
>> management have made clear that sender must accept a shrunk window
>> from the receiver, including RFC 793 [4] and RFC 1323 [5].
>>
>> This patch implements the functionality to shrink the tcp window
>> when necessary to keep the right edge within the memory limit by
>> autotuning (sk_rcvbuf).  This new functionality is enabled with
>> the new sysctl: net.ipv4.tcp_shrink_window
>>
>> Additional information can be found at:
>> https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buffers-and-how-we-fixed-it/
>>
>> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
>> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
>> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
>> [4] https://www.rfc-editor.org/rfc/rfc793
>> [5] https://www.rfc-editor.org/rfc/rfc1323
>>
>> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
>> ---
>>  Documentation/networking/ip-sysctl.rst | 13 +++++
>>  include/net/netns/ipv4.h               |  1 +
>>  net/ipv4/sysctl_net_ipv4.c             |  9 ++++
>>  net/ipv4/tcp_ipv4.c                    |  2 +
>>  net/ipv4/tcp_output.c                  | 73 ++++++++++++++++++++++++--
>>  5 files changed, 93 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index 366e2a5097d9..ddb895e8af56 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -981,6 +981,19 @@ tcp_tw_reuse - INTEGER
>>  tcp_window_scaling - BOOLEAN
>>         Enable window scaling as defined in RFC1323.
>>
>> +tcp_shrink_window - BOOLEAN
>> +       This changes how the TCP receive window is calculated.
>> +
>> +       RFC 7323, section 2.4, says there are instances when a retracted
>> +       window can be offered, and that TCP implementations MUST ensure
>> +       that they handle a shrinking window, as specified in RFC 1122.
>> +
>> +       - 0 - Disabled. The window is never shrunk.
>> +       - 1 - Enabled.  The window is shrunk when necessary to remain within
>> +                       the memory limit set by autotuning (sk_rcvbuf).
>> +
>> +       Default: 0
>> +
>>  tcp_wmem - vector of 3 INTEGERs: min, default, max
>>         min: Amount of memory reserved for send buffers for TCP sockets.
>>         Each TCP socket has rights to use it due to fact of its birth.
>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>> index a4efb7a2796c..f00374718159 100644
>> --- a/include/net/netns/ipv4.h
>> +++ b/include/net/netns/ipv4.h
>> @@ -65,6 +65,7 @@ struct netns_ipv4 {
>>  #endif
>>         bool                    fib_has_custom_local_routes;
>>         bool                    fib_offload_disabled;
>> +       u8                      sysctl_tcp_shrink_window;
>>  #ifdef CONFIG_IP_ROUTE_CLASSID
>>         atomic_t                fib_num_tclassid_users;
>>  #endif
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index 356afe54951c..2afb0870648b 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -1480,6 +1480,15 @@ static struct ctl_table ipv4_net_table[] = {
>>                 .extra1         = SYSCTL_ZERO,
>>                 .extra2         = &tcp_syn_linear_timeouts_max,
>>         },
>> +       {
>> +               .procname       = "tcp_shrink_window",
>> +               .data           = &init_net.ipv4.sysctl_tcp_shrink_window,
>> +               .maxlen         = sizeof(u8),
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dou8vec_minmax,
>> +               .extra1         = SYSCTL_ZERO,
>> +               .extra2         = SYSCTL_ONE,
>> +       },
>>         { }
>>  };
>>
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index 84a5d557dc1a..9213804b034f 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -3281,6 +3281,8 @@ static int __net_init tcp_sk_init(struct net *net)
>>                 net->ipv4.tcp_congestion_control = &tcp_reno;
>>
>>         net->ipv4.sysctl_tcp_syn_linear_timeouts = 4;
>> +       net->ipv4.sysctl_tcp_shrink_window = 0;
>> +
>>         return 0;
>>  }
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index f8ce77ce7c3e..5c86873e2193 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
>>         u32 old_win = tp->rcv_wnd;
>>         u32 cur_win = tcp_receive_window(tp);
>>         u32 new_win = __tcp_select_window(sk);
>> +       struct net *net = sock_net(sk);
> 
> Here you cache sock_net() in @net variable.
> 
>>
>> -       /* Never shrink the offered window */
>>         if (new_win < cur_win) {
>>                 /* Danger Will Robinson!
>>                  * Don't update rcv_wup/rcv_wnd here or else
>> @@ -270,11 +270,15 @@ static u16 tcp_select_window(struct sock *sk)
>>                  *
>>                  * Relax Will Robinson.
>>                  */
>> -               if (new_win == 0)
>> -                       NET_INC_STATS(sock_net(sk),
>> -                                     LINUX_MIB_TCPWANTZEROWINDOWADV);
>> -               new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
>> +               if (!READ_ONCE(net->ipv4.sysctl_tcp_shrink_window)) {
>> +                       /* Never shrink the offered window */
>> +                       if (new_win == 0)
>> +                               NET_INC_STATS(sock_net(sk),
> 
> You then can replace sock_net(sk) by @net here.
> 
>> +                                             LINUX_MIB_TCPWANTZEROWINDOWADV);
>> +                       new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
>> +               }
>>         }
>> +
>>         tp->rcv_wnd = new_win;
>>         tp->rcv_wup = tp->rcv_nxt;
>>
>> @@ -3003,6 +3007,7 @@ u32 __tcp_select_window(struct sock *sk)
>>  {
>>         struct inet_connection_sock *icsk = inet_csk(sk);
>>         struct tcp_sock *tp = tcp_sk(sk);
>> +       struct net *net = sock_net(sk);
>>         /* MSS for the peer's data.  Previous versions used mss_clamp
>>          * here.  I don't know if the value based on our guesses
>>          * of peer's MSS is better for the performance.  It's more correct
>> @@ -3024,6 +3029,12 @@ u32 __tcp_select_window(struct sock *sk)
>>                 if (mss <= 0)
>>                         return 0;
>>         }
>> +
>> +       if (READ_ONCE(net->ipv4.sysctl_tcp_shrink_window))
>> +               goto shrink_window_allowed;
>> +
>> +       /* do not allow window to shrink */
>> +
>>         if (free_space < (full_space >> 1)) {
>>                 icsk->icsk_ack.quick = 0;
>>
>> @@ -3077,6 +3088,58 @@ u32 __tcp_select_window(struct sock *sk)
>>                         window = free_space;
>>         }
>>
>> +       return window;
>> +
>> +shrink_window_allowed:
>> +       /* new window should always be an exact multiple of scaling factor */
>> +       free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
>> +
>> +       if (free_space < (full_space >> 1)) {
>> +               icsk->icsk_ack.quick = 0;
>> +
>> +               if (tcp_under_memory_pressure(sk))
>> +                       tcp_adjust_rcv_ssthresh(sk);
>> +
>> +               /* if free space is too low, return a zero window */
>> +               if (free_space < (allowed_space >> 4) || free_space < mss ||
>> +                       free_space < (1 << tp->rx_opt.rcv_wscale))
>> +                       return 0;
> 
> Are you sure this block can not be shared with the existing one ?
> 
> Existing one has this added part:
> 
> free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
> 
> Not sure why this would break the tcp_shrink_window == 1 case.

The main issue is the additional conditional on the if that returns 0:
    
    free_space < (1 << tp->rx_opt.rcv_wscale))

This is an important difference that I think needs to continue to be
different in the two cases.

I'll post a "v4" of the patch with the cleaned up code from the other 
comments so we can have a clean look at it.


