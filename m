Return-Path: <netdev+bounces-9853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D21772AFC2
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE162813EB
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268D4A55;
	Sun, 11 Jun 2023 00:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109CA180
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:27:02 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94042D44
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:27:00 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-56ce61769b7so11009467b3.3
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686443220; x=1689035220;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/DmQZNtDUCdC1kreZPA6QWY80tFlQCUzTc/J8JMhtp0=;
        b=kqH0aItzXvDlSwY7k+xlN8WNTuE/2kH+6bYtu8bLIdVJEb/W0BunMthK0X/MpvfEPt
         yAE8Z5EQ7qySIRiV8+5/Uz8lhM0ORXsNfExTpZZvCATbM3Ja7O64mD3f6pXl9F/zIskw
         FbIsSWKC2u7TQyTfchqqoJDj/RFR3C8Hi1jVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686443220; x=1689035220;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DmQZNtDUCdC1kreZPA6QWY80tFlQCUzTc/J8JMhtp0=;
        b=IMP2PEga+z4I+WJ4rUUakjMl9DcQIxKArA7b/PE2C2FFQ60S3GCEr6Rd6qaDpwCOg3
         UOh+jHpQ4L3nTvPiZGXjzKN4I70GksP5jNxs/lnp5O5pL24b+tOQ0y5ynAYuiTzL2uK4
         0WFYIsED+1W4krGDw76FX6y2vuRLxAZUI3bs2t9I2ZUwqS+5SqMA0K+TkRbfruMprLCR
         RQaxszXaPAoS8z/uqbtUDBLB3gUtUWy+QWZhKTSiWRQ9yygbM3a0dVU/s89Z3ushH96a
         9Z0RpouD1vdBWmmiqAZgxUrB+1vmcNvCKKwwsYhoiz26WRFhyhToOWq9mQCacUPdLRj2
         5jfA==
X-Gm-Message-State: AC+VfDyzMjlAWUriq1tIZH9qsuzqSeQg+7olCFXkmMkMlL7noW497N4j
	bOA20mMHdUw05gCkTwJRwYnZ+n7zMiuytLafH5A=
X-Google-Smtp-Source: ACHHUZ6Jt8T4FRlHcAtFBczpBbVbVbuUbaxqZ4eYOl/Z3G48qLgqbpDjgbzE7WTRZILgXjT+IEfhOQ==
X-Received: by 2002:a81:7102:0:b0:565:df97:4439 with SMTP id m2-20020a817102000000b00565df974439mr5448296ywc.37.1686443219783;
        Sat, 10 Jun 2023 17:26:59 -0700 (PDT)
Received: from [192.168.2.144] ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id g188-20020a0dc4c5000000b0055a7c2375dfsm1552149ywd.101.2023.06.10.17.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 17:26:59 -0700 (PDT)
Message-ID: <3b29138f-99f6-c2ce-8c74-7a6e6fe86041@cloudflare.com>
Date: Sat, 10 Jun 2023 19:26:57 -0500
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
> 
> 
>> +       }
>> +
>> +       if (free_space > tp->rcv_ssthresh) {
>> +               free_space = tp->rcv_ssthresh;
>> +               /* new window should always be an exact multiple of scaling factor
>> +                *
>> +                * For this case, we ALIGN "up" (increase free_space) because
>> +                * we know free_space is not zero here, it has been reduced from
>> +                * the memory-based limit, and rcv_ssthresh is not a hard limit
>> +                * (unlike sk_rcvbuf).
>> +                */
>> +               free_space = ALIGN(free_space, (1 << tp->rx_opt.rcv_wscale));
>> +       }
>> +
>> +       /* Don't do rounding if we are using window scaling, since the
>> +        * scaled window will not line up with the MSS boundary anyway.
>> +        */
>> +       if (tp->rx_opt.rcv_wscale) {
>> +               window = free_space;
>> +       } else {
>> +               window = tp->rcv_wnd;
>> +               /* Get the largest window that is a nice multiple of mss.
>> +                * Window clamp already applied above.
>> +                * If our current window offering is within 1 mss of the
>> +                * free space we just keep it. This prevents the divide
>> +                * and multiply from happening most of the time.
>> +                * We also don't do any window rounding when the free space
>> +                * is too small.
>> +                */
>> +               if (window <= free_space - mss || window > free_space)
>> +                       window = rounddown(free_space, mss);
>> +               else if (mss == full_space &&
>> +                        free_space > window + (full_space >> 1))
>> +                       window = free_space;
>> +       }
>> +
> 
> I am a bit surprised we can not come up with something simpler.

Since sysctl_tcp_shrink_window was only intended to apply when rcv_wscale > 0, I can make
that explicit, which will eliminate this whole latter block of code.

