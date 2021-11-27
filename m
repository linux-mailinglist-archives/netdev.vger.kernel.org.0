Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86D545FE2C
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 11:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhK0Kql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 05:46:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230475AbhK0Kol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 05:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638009686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+oCtSZw+hU9Geau33+wFsSslq0uK7JYa5qmKFZ7JrpA=;
        b=bJr/DMBwofKchbc8PB73rAH7iJTg6BRY4wwp25ZFNnf7dAI6lIzXNoQNvPTzSeg/8cAA9m
        hReU/XJzf73mk03N0Z/qVpRuoIYSxptE83THHObePB7iW6grbQBFzjKXBKfXRSnDRedlN8
        KJN3Q85FO8LeKlsIlI6DUGiQaMUchwI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-J_mKI_-UMZa51oFESfEQJA-1; Sat, 27 Nov 2021 05:41:25 -0500
X-MC-Unique: J_mKI_-UMZa51oFESfEQJA-1
Received: by mail-wm1-f70.google.com with SMTP id 145-20020a1c0197000000b0032efc3eb9bcso8502907wmb.0
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 02:41:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=+oCtSZw+hU9Geau33+wFsSslq0uK7JYa5qmKFZ7JrpA=;
        b=NAeTGcP6FxbMsJdHnoa50E9zXaNFNq03v6URY8ElNmr3yT53gtYI1CKqeUFfE7FXs+
         XWtTim0MuAr18ZUKzxEtguyPTeiJq2pD8XBlbgnAx2Wl6i64at/HvCwedeGgPrv2N3Zs
         m+QOUz1ufnBF6QzXUDxsGYpB/4sc+VJzI97QutzDhvdV7+qgZ4k9Q3sYOcAfL5xTLGfG
         WoV03enlq4yxowLEhPFcG1iJmBZQiFU8KCH1JulbF8e+eqHHXvP+52NHXRPNuWWuM6F8
         7rpwRWfXjn84LIUZa0K2us1g17Ld8ggKc7qLsuegMllUdwvGe/m1SLjbgJ0nugkeLmU3
         9qnQ==
X-Gm-Message-State: AOAM533Q/CguX1dUuCzy/uQ1yvuepQRCwVKM3X9BXz2M8z4afgl0RHsu
        rqvQ93WJWk3BOGc6w12CY25hn1JlQpZfJP4ioiyZIT6cXLjj3D0+zUz8q8Cwj58PZtsmAu/6gXg
        ny4ZqP2Z7w7d13PdG
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr22496038wme.188.1638009683931;
        Sat, 27 Nov 2021 02:41:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1IaEBbJWuRPGq00LIOJhB7+MEfEQpVy32cGu/bVRUHgm5FT5gDXP+M17dNi3TJn2AI9ZJvw==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr22496006wme.188.1638009683598;
        Sat, 27 Nov 2021 02:41:23 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id q123sm13157656wma.30.2021.11.27.02.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 02:41:22 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <7a3b7d98-d882-5197-3dae-80ffe1e59af6@redhat.com>
Date:   Sat, 27 Nov 2021 11:41:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, bjorn@kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next 3/4] samples/bpf: xdpsock: add period cycle time
 to Tx operation
Content-Language: en-US
To:     Ong Boon Leong <boon.leong.ong@intel.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
 <20211124091821.3916046-4-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-4-boon.leong.ong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2021 10.18, Ong Boon Leong wrote:
> Tx cycle time is in micro-seconds unit. By combining the batch size (-b M)
> and Tx cycle time (-T|--tx-cycle N), xdpsock now can transmit batch-size of
> packets every N-us periodically.

Does this also work for --poll mode (which is a wakeup mode) ?

> For example to transmit 1 packet each 1ms cycle time for total of 2000000
> packets:
> 
>   $ xdpsock -i eth0 -T -N -z -T 1000 -b 1 -C 2000000
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           1.00
> rx                 0              0
> tx                 1000           1996872
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           1.00
> rx                 0              0
> tx                 1000           1997872
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           1.00
> rx                 0              0
> tx                 1000           1998872
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           1.00
> rx                 0              0
> tx                 1000           1999872
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           1.00
> rx                 0              0
> tx                 128            2000000
> 
>   sock0@enp0s29f1:2 txonly xdp-drv
>                     pps            pkts           0.00
> rx                 0              0
> tx                 0              2000000
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>   samples/bpf/xdpsock_user.c | 36 +++++++++++++++++++++++++++++++-----
>   1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 691f442bbb2..61d4063f11a 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -111,6 +111,7 @@ static u32 opt_num_xsks = 1;
>   static u32 prog_id;
>   static bool opt_busy_poll;
>   static bool opt_reduced_cap;
> +static unsigned long opt_cycle_time;
>   
>   struct vlan_ethhdr {
>   	unsigned char h_dest[6];
> @@ -173,6 +174,8 @@ struct xsk_socket_info {
>   	struct xsk_app_stats app_stats;
>   	struct xsk_driver_stats drv_stats;
>   	u32 outstanding_tx;
> +	unsigned long prev_tx_time;
> +	unsigned long tx_cycle_time;
>   };
>   
>   static int num_socks;
> @@ -972,6 +975,7 @@ static struct option long_options[] = {
>   	{"tx-vlan-pri", required_argument, 0, 'K'},
>   	{"tx-dmac", required_argument, 0, 'G'},
>   	{"tx-smac", required_argument, 0, 'H'},
> +	{"tx-cycle", required_argument, 0, 'T'},
>   	{"extra-stats", no_argument, 0, 'x'},
>   	{"quiet", no_argument, 0, 'Q'},
>   	{"app-stats", no_argument, 0, 'a'},
> @@ -1017,6 +1021,7 @@ static void usage(const char *prog)
>   		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
>   		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
>   		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
> +		"  -T, --tx-cycle=n     Tx cycle time in micro-seconds (For -t|--txonly).\n"
>   		"  -x, --extra-stats	Display extra statistics.\n"
>   		"  -Q, --quiet          Do not display any stats.\n"
>   		"  -a, --app-stats	Display application (syscall) statistics.\n"
> @@ -1039,7 +1044,7 @@ static void parse_command_line(int argc, char **argv)
>   	opterr = 0;
>   
>   	for (;;) {
> -		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
> +		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:T:xQaI:BR",
>   				long_options, &option_index);
>   		if (c == -1)
>   			break;
> @@ -1145,6 +1150,10 @@ static void parse_command_line(int argc, char **argv)
>   				usage(basename(argv[0]));
>   			}
>   			break;
> +		case 'T':
> +			opt_cycle_time = atoi(optarg);
> +			opt_cycle_time *= 1000;

Converting to nanosec, right(?).

> +			break;
>   		case 'x':
>   			opt_extra_stats = 1;
>   			break;
> @@ -1350,16 +1359,25 @@ static void rx_drop_all(void)
>   	}
>   }
>   
> -static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
> +static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
>   {
>   	u32 idx;
>   	unsigned int i;
>   
> +	if (xsk->tx_cycle_time) {
> +		unsigned long now = get_nsecs();
> +
> +		if ((now - xsk->prev_tx_time) < xsk->tx_cycle_time)
> +			return 0;

So, this test is actively spinning until the time is reached, spending 
100% CPU time on this. I guess we can have this as a test for most 
accurate transmit (cyclic period) with AF_XDP.

Do you have a use-case for this?

I have a customer use-case, but my customer don't want to actively spin.
My plan is to use clock_nanosleep() and wakeup slightly before the 
target time and then we can spin shortly for the Tx time slot.

I will need to code this up for the customer soon anyway... perhaps we 
can extend your code with this idea?

I have coded the period cycle Tx with UDP packets, here[1], if you like 
to see some code using clock_nanosleep().  Next step (for me) is doing 
this for AF_XDP (likely in my example[2].

[1] 
https://github.com/netoptimizer/network-testing/blob/master/src/udp_pacer.c

[2] 
https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction

> +
> +		xsk->prev_tx_time = now;

Would it be valuable to know how-much we shoot "over" the tx_cycle_time?

For my use-case, I will be monitoring the other-side receiving the 
packets (and using HW RX-time) to evaluate how accurate my sender is. In 
this case, I would like to know if my software "knew" if was not 100% 
accurate.


> +	}
> +
>   	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
>   				      batch_size) {
>   		complete_tx_only(xsk, batch_size);
>   		if (benchmark_done)
> -			return;
> +			return 0;
>   	}

I wonder if this step can introduce jitter/delay before the actual Tx 
happens?

I mean, the real transmit cannot happen before xsk_ring_prod__submit() 
is called.  If the cycles spend are exactly the same, it doesn't matter 
if you tx_cycle_time timestamp is done above.
Here you have a potential call to complete_tx_only(), which can 
introduce variance for your period.

I will suggest moving the TX completion handling, so it doesn't 
interfere with accurate TX.

>   
>   	for (i = 0; i < batch_size; i++) {
> @@ -1375,6 +1393,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
>   	*frame_nb += batch_size;
>   	*frame_nb %= NUM_FRAMES;
>   	complete_tx_only(xsk, batch_size);
> +
> +	return batch_size;
>   }
>   
>   static inline int get_batch_size(int pkt_cnt)
> @@ -1407,6 +1427,7 @@ static void complete_tx_only_all(void)
>   static void tx_only_all(void)
>   {
>   	struct pollfd fds[MAX_SOCKS] = {};
> +	unsigned long now = get_nsecs();
>   	u32 frame_nb[MAX_SOCKS] = {};
>   	int pkt_cnt = 0;
>   	int i, ret;
> @@ -1414,10 +1435,15 @@ static void tx_only_all(void)
>   	for (i = 0; i < num_socks; i++) {
>   		fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
>   		fds[0].events = POLLOUT;
> +		if (opt_cycle_time) {
> +			xsks[i]->prev_tx_time = now;
> +			xsks[i]->tx_cycle_time = opt_cycle_time;
> +		}
>   	}
>   
>   	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
>   		int batch_size = get_batch_size(pkt_cnt);
> +		int tx_cnt = 0;
>   
>   		if (opt_poll) {
>   			for (i = 0; i < num_socks; i++)
> @@ -1431,9 +1457,9 @@ static void tx_only_all(void)
>   		}
>   
>   		for (i = 0; i < num_socks; i++)
> -			tx_only(xsks[i], &frame_nb[i], batch_size);
> +			tx_cnt += tx_only(xsks[i], &frame_nb[i], batch_size);
>   
> -		pkt_cnt += batch_size;
> +		pkt_cnt += tx_cnt;
>   
>   		if (benchmark_done)
>   			break;
> 

