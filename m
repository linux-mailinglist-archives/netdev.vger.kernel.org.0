Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23490661174
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 21:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjAGUCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 15:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGUCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 15:02:48 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8956A958F;
        Sat,  7 Jan 2023 12:02:46 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id i127so3821918oif.8;
        Sat, 07 Jan 2023 12:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y6wqDn5CqaAzAfXghJKhjP3SloXU1oeIIGLXVsqIWo=;
        b=RruZuuZpvO1dPjO69khzGwvXX8s0OS6kNbbKPl/VCcXeqYhxdWl6cCVWZn3Q+8haDE
         z9TVWUQ6ojmUH8Vld9aoRApkRGyaZ0r3YvnVcwPv5P69FvUCbQqftQevr3AcKiPi9ecc
         u30hb/evjfymw0+KPgcAXe+6hAMZddE6pZC2JR2V6lx58BA8v+lf1PhW1qeTLwOCdtuI
         CFkPQ4hiaSsUBc9C17Ije/Q+u3jIVwoSMeL0U7AAVdsqz/aLSFfrRirE/RI6nZlIZOTS
         CnAFsXczlfbxz+bUXbBBF9rwqj50dKZXJ6+w16bXSScVu4iGXsCzqFhgAM59ymNV2c+V
         +ZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Y6wqDn5CqaAzAfXghJKhjP3SloXU1oeIIGLXVsqIWo=;
        b=oJceNBv8y7dHLdoJKdfCEOmOrp5BWMcBQN3i3o1CuXHLCV9LH8XsUlw3U0NYitZN+U
         YsmDh2X7PB73mJv+sFI+ViK4g97DyTyMiPBJb7T1qjdQZmGer81lVad1vXjkeI02tFZC
         MI6yo9AzyovfT24jUugeY+sAzn7HtLaJ21V10+n/ETJkbNUuGRCtkW++y3hE+LWPimR1
         OnrMKl/nMkfxk1HurL7qfzpznEbEUlK2o+FP+XQQVNcBcYUpuC5hfk8LjGjyFneXNpxi
         PTqlaYePosALr0KZxO3YoRhbdkZ9VXCFj6WXtWSxSyXl9CZPRPTogX7sEGzP65hQSx+2
         tclg==
X-Gm-Message-State: AFqh2kp/brvmNSac0XIKYweDf6QF+x+3JLe+tNg4ivaRZZDWznDKEphY
        Mgdi1yz3kpSbnljUPMMVhm+Nmgz7Y5o=
X-Google-Smtp-Source: AMrXdXtNbjEC8VmDq7VtZRnMMoqLLIfSyzWWZ0HvEqM48n5rZthSfkZ4qdI0qSIdjHO//p5sLEYtaw==
X-Received: by 2002:a05:6808:212a:b0:35e:bc7c:59a1 with SMTP id r42-20020a056808212a00b0035ebc7c59a1mr38021839oiw.47.1673121765721;
        Sat, 07 Jan 2023 12:02:45 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:d403:a631:b9f0:eacb])
        by smtp.gmail.com with ESMTPSA id a7-20020a056808098700b0034d9042758fsm1799526oic.24.2023.01.07.12.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 12:02:44 -0800 (PST)
Date:   Sat, 7 Jan 2023 12:02:44 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] sock: add tracepoint for send recv length
Message-ID: <Y7nP5PAGxWZ+2GHN@pop-os.localdomain>
References: <20230107035923.363-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107035923.363-1-cuiyunhui@bytedance.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:59:23AM +0800, Yunhui Cui wrote:
> Add 2 tracepoints to monitor the tcp/udp traffic
> of per process and per cgroup.
> 
> Regarding monitoring the tcp/udp traffic of each process, there are two
> existing solutions, the first one is https://www.atoptool.nl/netatop.php.
> The second is via kprobe/kretprobe.
> 
> Netatop solution is implemented by registering the hook function at the
> hook point provided by the netfilter framework.
> 
> These hook functions may be in the soft interrupt context and cannot
> directly obtain the pid. Some data structures are added to bind packets
> and processes. For example, struct taskinfobucket, struct taskinfo ...
> 
> Every time the process sends and receives packets it needs multiple
> hashmaps,resulting in low performance and it has the problem fo inaccurate
> tcp/udp traffic statistics(for example: multiple threads share sockets).
> 
> We can obtain the information with kretprobe, but as we know, kprobe gets
> the result by trappig in an exception, which loses performance compared
> to tracepoint.
> 
> We compared the performance of tracepoints with the above two methods, and
> the results are as follows:
> 
> ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
> without trace:
> Time per request: 39.660 [ms] (mean)
> Time per request: 0.040 [ms] (mean, across all concurrent requests)
> 
> netatop:
> Time per request: 50.717 [ms] (mean)
> Time per request: 0.051 [ms] (mean, across all concurrent requests)
> 
> kr:
> Time per request: 43.168 [ms] (mean)
> Time per request: 0.043 [ms] (mean, across all concurrent requests)
> 
> tracepoint:
> Time per request: 41.004 [ms] (mean)
> Time per request: 0.041 [ms] (mean, across all concurrent requests
> 
> It can be seen that tracepoint has better performance.
> 
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>

Thanks for the numbers, they help a lot.

Acked-by: Cong Wang <cong.wang@bytedance.com>

A few minor issues below.


> ---
>  include/trace/events/sock.h | 49 +++++++++++++++++++++++++++++++++++++
>  net/socket.c                | 20 +++++++++++++--
>  2 files changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index 777ee6cbe933..16092c0406a2 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -263,6 +263,55 @@ TRACE_EVENT(inet_sk_error_report,
>  		  __entry->error)
>  );
>  
> +/*
> + * sock send/recv msg length
> + */
> +DECLARE_EVENT_CLASS(sock_msg_length,
> +
> +	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +		 int flags),
> +
> +	TP_ARGS(sk, family, protocol, ret, flags),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, sk)
> +		__field(__u16, family)
> +		__field(__u16, protocol)
> +		__field(int, length)
> +		__field(int, error)
> +		__field(int, flags)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->sk = sk;
> +		__entry->family = sk->sk_family;
> +		__entry->protocol = sk->sk_protocol;
> +		__entry->length = ret > 0 ? ret : 0;
> +		__entry->error = ret < 0 ? ret : 0;
> +		__entry->flags = flags;
> +	),
> +
> +	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
> +			__entry->sk,
> +			show_family_name(__entry->family),
> +			show_inet_protocol_name(__entry->protocol),
> +			__entry->length,
> +			__entry->error, __entry->flags)

Please align and pack those parameters properly.


> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_sendmsg_length,
> +	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +		 int flags),
> +
> +	TP_ARGS(sk, family, protocol, ret, flags)
> +);
> +
> +DEFINE_EVENT(sock_msg_length, sock_recvmsg_length,
> +	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> +		 int flags),
> +
> +	TP_ARGS(sk, family, protocol, ret, flags)
> +);

It might be a better idea to remove "msg" from the tracepoint names, in
case of any confusion with "sendpage". So
s/sock_sendmsg_length/sock_send_length/ ?


>  #endif /* _TRACE_SOCK_H */
>  
>  /* This part must be outside protection */
> diff --git a/net/socket.c b/net/socket.c
> index 888cd618a968..37578e8c685b 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -106,6 +106,7 @@
>  #include <net/busy_poll.h>
>  #include <linux/errqueue.h>
>  #include <linux/ptp_clock_kernel.h>
> +#include <trace/events/sock.h>
>  
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  unsigned int sysctl_net_busy_read __read_mostly;
> @@ -715,6 +716,9 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
>  				     inet_sendmsg, sock, msg,
>  				     msg_data_left(msg));
>  	BUG_ON(ret == -EIOCBQUEUED);
> +
> +	trace_sock_sendmsg_length(sock->sk, sock->sk->sk_family,
> +				  sock->sk->sk_protocol, ret, 0);
>  	return ret;
>  }
>  
> @@ -992,9 +996,16 @@ INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
>  static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
>  				     int flags)
>  {
> -	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> +	int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>  				  inet_recvmsg, sock, msg, msg_data_left(msg),
>  				  flags);

Please adjust the indentations properly.

Thanks.
