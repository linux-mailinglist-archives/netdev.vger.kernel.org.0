Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80ED587E6D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiHBOyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiHBOyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:54:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDB11EEE7
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 07:54:06 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j15so10133369wrr.2
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 07:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8yMT+d7jKYbct9ywMuRlFAbDkKmuVQ5EakaD36c9slk=;
        b=CMQLiS9HOwnNg3rY8qtgRK6nrDVuMUsvs6wiAvrK0Jsc9wCsX/Z9Y8ZhLkG90ee5nP
         0mKYV7MpjUQxzyyyPnnL0jzr9ELwIxVF6ao0kr8qgx6Gj5fskGO4F5brET1+NfCjreOY
         01d5GymnsTndyu90KkhIZTMqgY53S7JnmuFnbftLRweQ+ki7WfGQZwIHDLTqE2t+qSJl
         JwHbfd7pkHIpAqEazEOWAkushl9oKG5zISdt3UsWkDctdwMJEEjXxFzv3Q4/zPGX4WpI
         LA+HXuhaO+TiMnAbT6LBpAeYVUpmhmMYv0/cmX6N+Rz+L6drqXaQhwKNpbmZQqn8wyw7
         VdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8yMT+d7jKYbct9ywMuRlFAbDkKmuVQ5EakaD36c9slk=;
        b=PuZCyhs++HaqCOi8KANhxrlyGw+DS1ydHf0cV4SLzTJbcVv37Xhw+bcNz+XBokFz5u
         6Q9W8O13oSJ8eQfG0XfRMXxQoWIfJSF8Q/2hfGnycALRdsfw4I+SQzR+or471Gd6ejgP
         ipM2HygtBmjj/AU1O4Lgef8T8gDZ3yA8S8JfeQGIrkQLRNW3hwRfjSJTUeJs9MwXbPOJ
         riqfBV/V9bWl2xiKXuAwjKPVZcSImNBCcg9V0EKsigucVoZNA0YA8KVEcifIPNZuECv9
         dW98Z5Tn6WYgDvdrY/sMuygCfridlkOsLyM3AfgjcDRGnVWj50XtQoeoxqykRIK1wZ8C
         LMNQ==
X-Gm-Message-State: ACgBeo1XNkJcTL68WsEhbwRkbplf4qiO8jYSEo4f2q7UpTu5gK311Bgl
        m1GZHUpE3bkzcSg6uceWswqJACsr1+s=
X-Google-Smtp-Source: AA6agR7hzYzbqUwPO6huRe451ua7PVEfms7S0pCX39Ck2VPOAwwyV3C21sEx0mpIHboH9s9cZm309A==
X-Received: by 2002:adf:fe0d:0:b0:220:5f88:ebef with SMTP id n13-20020adffe0d000000b002205f88ebefmr7468216wrr.349.1659452044756;
        Tue, 02 Aug 2022 07:54:04 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id w13-20020adfee4d000000b0021f0af83142sm14929841wro.91.2022.08.02.07.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 07:54:04 -0700 (PDT)
Message-ID: <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
Date:   Tue, 2 Aug 2022 17:54:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220722235033.2594446-8-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2022 2:50 AM, Jakub Kicinski wrote:
> TLS is a relatively poor fit for strparser. We pause the input
> every time a message is received, wait for a read which will
> decrypt the message, start the parser, repeat. strparser is
> built to delineate the messages, wrap them in individual skbs
> and let them float off into the stack or a different socket.
> TLS wants the data pages and nothing else. There's no need
> for TLS to keep cloning (and occasionally skb_unclone()'ing)
> the TCP rx queue.
> 
> This patch uses a pre-allocated skb and attaches the skbs
> from the TCP rx queue to it as frags. TLS is careful never
> to modify the input skb without CoW'ing / detaching it first.
> 
> Since we call TCP rx queue cleanup directly we also get back
> the benefit of skb deferred free.
> 
> Overall this results in a 6% gain in my benchmarks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> ---
>   include/net/tls.h  |  19 +-
>   net/tls/tls.h      |  24 ++-
>   net/tls/tls_main.c |  20 +-
>   net/tls/tls_strp.c | 484 +++++++++++++++++++++++++++++++++++++++++++--
>   net/tls/tls_sw.c   |  80 ++++----
>   5 files changed, 558 insertions(+), 69 deletions(-)
> 

Hi Jakub,

The device offload flow got broken, we started getting the call trace 
below in our regressions tests.

Bisecting points to this one as the offending commit.

I taking a look, but I'm less familiar with this change.
Probably you have a direction?

Regards,
Tariq

  [  407.560799] rcu: INFO: rcu_sched self-detected stall on CPU
  [  407.561734] rcu: 	1-....: (5248 ticks this GP) 
idle=51b/1/0x4000000000000000 softirq=41347/41347 fqs=2625
  [  407.563101] 	(t=5250 jiffies g=65669 q=4492 ncpus=10)
  [  407.563859] NMI backtrace for cpu 1
  [  407.564430] CPU: 1 PID: 45266 Comm: iperf Not tainted 
5.19.0-rc7_for-upstream_min-debug_5f35d2896553 #1
  [  407.565766] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [  407.567319] Call Trace:
  [  407.567772]  <IRQ>
  [  407.568168]  dump_stack_lvl+0x34/0x44
  [  407.568763]  nmi_cpu_backtrace.cold+0x30/0x70
  [  407.569462]  ? lapic_can_unplug_cpu+0x70/0x70
  [  407.570146]  nmi_trigger_cpumask_backtrace+0xef/0x100
  [  407.570897]  trigger_single_cpu_backtrace+0x24/0x27
  [  407.571635]  rcu_dump_cpu_stacks+0xa0/0xd9
  [  407.572278]  rcu_sched_clock_irq.cold+0x111/0x2d3
  [  407.573004]  update_process_times+0x5b/0x90
  [  407.584227]  tick_sched_timer+0x88/0xa0
  [  407.584855]  ? tick_sched_do_timer+0xf0/0xf0
  [  407.585515]  __hrtimer_run_queues+0x139/0x290
  [  407.586199]  hrtimer_interrupt+0x10e/0x240
  [  407.586844]  __sysvec_apic_timer_interrupt+0x56/0xd0
  [  407.587575]  sysvec_apic_timer_interrupt+0x6d/0x90
  [  407.588293]  </IRQ>
  [  407.588699]  <TASK>
  [  407.589118]  asm_sysvec_apic_timer_interrupt+0x16/0x20
  [  407.589886] RIP: 0010:tls_device_decrypted+0x7a/0x2e0
  [  407.590641] Code: 83 e7 01 45 0f b6 e7 41 83 f7 01 48 85 d2 45 0f 
b6 ff 74 1b 0f b6 82 83 00 00 00 48 8b 12 c0 e8 06 41 21 c4 83 f0 01 41 
21 c7 <48> 85 d2 75 e5 8b 05 d3 71 ca 00 85 c0 0f 8f 4b 01 00 00 48 8b 85
  [  407.593152] RSP: 0018:ffff8881a113bb60 EFLAGS: 00000202
  [  407.593927] RAX: 0000000000000003 RBX: ffff88810e2d6000 RCX: 
0000000000000000
  [  407.594913] RDX: ffff8881792b80d8 RSI: ffff88814ef46800 RDI: 
ffff8881792b8000
  [  407.595904] RBP: ffff88814ef46800 R08: 7fffffffffffffff R09: 
0000000000000001
  [  407.596907] R10: ffff888105cd2200 R11: 0000000000022dd1 R12: 
0000000000000000
  [  407.597901] R13: ffff888108f45000 R14: ffff8881792b8000 R15: 
0000000000000001
  [  407.598897]  ? tls_rx_rec_wait+0x225/0x250
  [  407.599539]  tls_rx_one_record+0xe4/0x2d0
  [  407.600169]  tls_sw_recvmsg+0x380/0x910
  [  407.600773]  ? 0xffffffff81000000
  [  407.601336]  inet6_recvmsg+0x47/0xc0
  [  407.601932]  ____sys_recvmsg+0x109/0x120
  [  407.602554]  ? _copy_from_user+0x26/0x60
  [  407.603171]  ? iovec_from_user+0x4a/0x150
  [  407.603803]  ___sys_recvmsg+0xa4/0xe0
  [  407.604394]  ? mlx5e_ktls_add_rx+0x349/0x430 [mlx5_core]
  [  407.605262]  ? mlx5e_ktls_add_rx+0x3af/0x430 [mlx5_core]
  [  407.606082]  ? tls_device_attach+0x60/0xe0
  [  407.606721]  ? tls_set_device_offload_rx+0x11b/0x220
  [  407.607464]  __sys_recvmsg+0x4e/0x90
  [  407.608050]  do_syscall_64+0x3d/0x90
  [  407.608631]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
  [  407.609400] RIP: 0033:0x7f7a41f856dd

> diff --git a/include/net/tls.h b/include/net/tls.h
> index 181c496b01b8..abb050b0df83 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -108,18 +108,33 @@ struct tls_sw_context_tx {
>   	unsigned long tx_bitmask;
>   };
>   
> +struct tls_strparser {
> +	struct sock *sk;
> +
> +	u32 mark : 8;
> +	u32 stopped : 1;
> +	u32 copy_mode : 1;
> +	u32 msg_ready : 1;
> +
> +	struct strp_msg stm;
> +
> +	struct sk_buff *anchor;
> +	struct work_struct work;
> +};
> +
>   struct tls_sw_context_rx {
>   	struct crypto_aead *aead_recv;
>   	struct crypto_wait async_wait;
> -	struct strparser strp;
>   	struct sk_buff_head rx_list;	/* list of decrypted 'data' records */
>   	void (*saved_data_ready)(struct sock *sk);
>   
> -	struct sk_buff *recv_pkt;
>   	u8 reader_present;
>   	u8 async_capable:1;
>   	u8 zc_capable:1;
>   	u8 reader_contended:1;
> +
> +	struct tls_strparser strp;
> +
>   	atomic_t decrypt_pending;
>   	/* protect crypto_wait with decrypt_pending*/
>   	spinlock_t decrypt_compl_lock;
> diff --git a/net/tls/tls.h b/net/tls/tls.h
> index 154a3773e785..0e840a0c3437 100644
> --- a/net/tls/tls.h
> +++ b/net/tls/tls.h
> @@ -1,4 +1,5 @@
>   /*
> + * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
>    * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
>    * Copyright (c) 2016-2017, Dave Watson <davejwatson@fb.com>. All rights reserved.
>    *
> @@ -127,10 +128,24 @@ int tls_sw_fallback_init(struct sock *sk,
>   			 struct tls_offload_context_tx *offload_ctx,
>   			 struct tls_crypto_info *crypto_info);
>   
> +int tls_strp_dev_init(void);
> +void tls_strp_dev_exit(void);
> +
> +void tls_strp_done(struct tls_strparser *strp);
> +void tls_strp_stop(struct tls_strparser *strp);
> +int tls_strp_init(struct tls_strparser *strp, struct sock *sk);
> +void tls_strp_data_ready(struct tls_strparser *strp);
> +
> +void tls_strp_check_rcv(struct tls_strparser *strp);
> +void tls_strp_msg_done(struct tls_strparser *strp);
> +
> +int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb);
> +void tls_rx_msg_ready(struct tls_strparser *strp);
> +
> +void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh);
>   int tls_strp_msg_cow(struct tls_sw_context_rx *ctx);
>   struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx);
> -int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
> -		      struct sk_buff_head *dst);
> +int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst);
>   
>   static inline struct tls_msg *tls_msg(struct sk_buff *skb)
>   {
> @@ -141,12 +156,13 @@ static inline struct tls_msg *tls_msg(struct sk_buff *skb)
>   
>   static inline struct sk_buff *tls_strp_msg(struct tls_sw_context_rx *ctx)
>   {
> -	return ctx->recv_pkt;
> +	DEBUG_NET_WARN_ON_ONCE(!ctx->strp.msg_ready || !ctx->strp.anchor->len);
> +	return ctx->strp.anchor;
>   }
>   
>   static inline bool tls_strp_msg_ready(struct tls_sw_context_rx *ctx)
>   {
> -	return ctx->recv_pkt;
> +	return ctx->strp.msg_ready;
>   }
>   
>   #ifdef CONFIG_TLS_DEVICE
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 9703636cfc60..08ddf9d837ae 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -725,6 +725,10 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
>   	if (tx) {
>   		ctx->sk_write_space = sk->sk_write_space;
>   		sk->sk_write_space = tls_write_space;
> +	} else {
> +		struct tls_sw_context_rx *rx_ctx = tls_sw_ctx_rx(ctx);
> +
> +		tls_strp_check_rcv(&rx_ctx->strp);
>   	}
>   	return 0;
>   
> @@ -1141,20 +1145,28 @@ static int __init tls_register(void)
>   	if (err)
>   		return err;
>   
> +	err = tls_strp_dev_init();
> +	if (err)
> +		goto err_pernet;
> +
>   	err = tls_device_init();
> -	if (err) {
> -		unregister_pernet_subsys(&tls_proc_ops);
> -		return err;
> -	}
> +	if (err)
> +		goto err_strp;
>   
>   	tcp_register_ulp(&tcp_tls_ulp_ops);
>   
>   	return 0;
> +err_strp:
> +	tls_strp_dev_exit();
> +err_pernet:
> +	unregister_pernet_subsys(&tls_proc_ops);
> +	return err;
>   }
>   
>   static void __exit tls_unregister(void)
>   {
>   	tcp_unregister_ulp(&tcp_tls_ulp_ops);
> +	tls_strp_dev_exit();
>   	tls_device_cleanup();
>   	unregister_pernet_subsys(&tls_proc_ops);
>   }
> diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
> index d9bb4f23f01a..b945288c312e 100644
> --- a/net/tls/tls_strp.c
> +++ b/net/tls/tls_strp.c
> @@ -1,37 +1,493 @@
>   // SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2016 Tom Herbert <tom@herbertland.com> */
>   
>   #include <linux/skbuff.h>
> +#include <linux/workqueue.h>
> +#include <net/strparser.h>
> +#include <net/tcp.h>
> +#include <net/sock.h>
> +#include <net/tls.h>
>   
>   #include "tls.h"
>   
> -struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
> +static struct workqueue_struct *tls_strp_wq;
> +
> +static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
> +{
> +	if (strp->stopped)
> +		return;
> +
> +	strp->stopped = 1;
> +
> +	/* Report an error on the lower socket */
> +	strp->sk->sk_err = -err;
> +	sk_error_report(strp->sk);
> +}
> +
> +static void tls_strp_anchor_free(struct tls_strparser *strp)
>   {
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +
> +	DEBUG_NET_WARN_ON_ONCE(atomic_read(&shinfo->dataref) != 1);
> +	shinfo->frag_list = NULL;
> +	consume_skb(strp->anchor);
> +	strp->anchor = NULL;
> +}
> +
> +/* Create a new skb with the contents of input copied to its page frags */
> +static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
> +{
> +	struct strp_msg *rxm;
>   	struct sk_buff *skb;
> +	int i, err, offset;
> +
> +	skb = alloc_skb_with_frags(0, strp->anchor->len, TLS_PAGE_ORDER,
> +				   &err, strp->sk->sk_allocation);
> +	if (!skb)
> +		return NULL;
> +
> +	offset = strp->stm.offset;
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
>   
> -	skb = ctx->recv_pkt;
> -	ctx->recv_pkt = NULL;
> +		WARN_ON_ONCE(skb_copy_bits(strp->anchor, offset,
> +					   skb_frag_address(frag),
> +					   skb_frag_size(frag)));
> +		offset += skb_frag_size(frag);
> +	}
> +
> +	skb_copy_header(skb, strp->anchor);
> +	rxm = strp_msg(skb);
> +	rxm->offset = 0;
>   	return skb;
>   }
>   
> +/* Steal the input skb, input msg is invalid after calling this function */
> +struct sk_buff *tls_strp_msg_detach(struct tls_sw_context_rx *ctx)
> +{
> +	struct tls_strparser *strp = &ctx->strp;
> +
> +#ifdef CONFIG_TLS_DEVICE
> +	DEBUG_NET_WARN_ON_ONCE(!strp->anchor->decrypted);
> +#else
> +	/* This function turns an input into an output,
> +	 * that can only happen if we have offload.
> +	 */
> +	WARN_ON(1);
> +#endif
> +
> +	if (strp->copy_mode) {
> +		struct sk_buff *skb;
> +
> +		/* Replace anchor with an empty skb, this is a little
> +		 * dangerous but __tls_cur_msg() warns on empty skbs
> +		 * so hopefully we'll catch abuses.
> +		 */
> +		skb = alloc_skb(0, strp->sk->sk_allocation);
> +		if (!skb)
> +			return NULL;
> +
> +		swap(strp->anchor, skb);
> +		return skb;
> +	}
> +
> +	return tls_strp_msg_make_copy(strp);
> +}
> +
> +/* Force the input skb to be in copy mode. The data ownership remains
> + * with the input skb itself (meaning unpause will wipe it) but it can
> + * be modified.
> + */
>   int tls_strp_msg_cow(struct tls_sw_context_rx *ctx)
>   {
> -	struct sk_buff *unused;
> -	int nsg;
> +	struct tls_strparser *strp = &ctx->strp;
> +	struct sk_buff *skb;
> +
> +	if (strp->copy_mode)
> +		return 0;
> +
> +	skb = tls_strp_msg_make_copy(strp);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	tls_strp_anchor_free(strp);
> +	strp->anchor = skb;
> +
> +	tcp_read_done(strp->sk, strp->stm.full_len);
> +	strp->copy_mode = 1;
> +
> +	return 0;
> +}
> +
> +/* Make a clone (in the skb sense) of the input msg to keep a reference
> + * to the underlying data. The reference-holding skbs get placed on
> + * @dst.
> + */
> +int tls_strp_msg_hold(struct tls_strparser *strp, struct sk_buff_head *dst)
> +{
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +
> +	if (strp->copy_mode) {
> +		struct sk_buff *skb;
> +
> +		WARN_ON_ONCE(!shinfo->nr_frags);
> +
> +		/* We can't skb_clone() the anchor, it gets wiped by unpause */
> +		skb = alloc_skb(0, strp->sk->sk_allocation);
> +		if (!skb)
> +			return -ENOMEM;
> +
> +		__skb_queue_tail(dst, strp->anchor);
> +		strp->anchor = skb;
> +	} else {
> +		struct sk_buff *iter, *clone;
> +		int chunk, len, offset;
> +
> +		offset = strp->stm.offset;
> +		len = strp->stm.full_len;
> +		iter = shinfo->frag_list;
> +
> +		while (len > 0) {
> +			if (iter->len <= offset) {
> +				offset -= iter->len;
> +				goto next;
> +			}
> +
> +			chunk = iter->len - offset;
> +			offset = 0;
> +
> +			clone = skb_clone(iter, strp->sk->sk_allocation);
> +			if (!clone)
> +				return -ENOMEM;
> +			__skb_queue_tail(dst, clone);
> +
> +			len -= chunk;
> +next:
> +			iter = iter->next;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void tls_strp_flush_anchor_copy(struct tls_strparser *strp)
> +{
> +	struct skb_shared_info *shinfo = skb_shinfo(strp->anchor);
> +	int i;
> +
> +	DEBUG_NET_WARN_ON_ONCE(atomic_read(&shinfo->dataref) != 1);
> +
> +	for (i = 0; i < shinfo->nr_frags; i++)
> +		__skb_frag_unref(&shinfo->frags[i], false);
> +	shinfo->nr_frags = 0;
> +	strp->copy_mode = 0;
> +}
> +
> +static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
> +			   unsigned int offset, size_t in_len)
> +{
> +	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
> +	size_t sz, len, chunk;
> +	struct sk_buff *skb;
> +	skb_frag_t *frag;
> +
> +	if (strp->msg_ready)
> +		return 0;
> +
> +	skb = strp->anchor;
> +	frag = &skb_shinfo(skb)->frags[skb->len / PAGE_SIZE];
> +
> +	len = in_len;
> +	/* First make sure we got the header */
> +	if (!strp->stm.full_len) {
> +		/* Assume one page is more than enough for headers */
> +		chunk =	min_t(size_t, len, PAGE_SIZE - skb_frag_size(frag));
> +		WARN_ON_ONCE(skb_copy_bits(in_skb, offset,
> +					   skb_frag_address(frag) +
> +					   skb_frag_size(frag),
> +					   chunk));
> +
> +		sz = tls_rx_msg_size(strp, strp->anchor);
> +		if (sz < 0) {
> +			desc->error = sz;
> +			return 0;
> +		}
> +
> +		/* We may have over-read, sz == 0 is guaranteed under-read */
> +		if (sz > 0)
> +			chunk =	min_t(size_t, chunk, sz - skb->len);
> +
> +		skb->len += chunk;
> +		skb->data_len += chunk;
> +		skb_frag_size_add(frag, chunk);
> +		frag++;
> +		len -= chunk;
> +		offset += chunk;
> +
> +		strp->stm.full_len = sz;
> +		if (!strp->stm.full_len)
> +			goto read_done;
> +	}
> +
> +	/* Load up more data */
> +	while (len && strp->stm.full_len > skb->len) {
> +		chunk =	min_t(size_t, len, strp->stm.full_len - skb->len);
> +		chunk = min_t(size_t, chunk, PAGE_SIZE - skb_frag_size(frag));
> +		WARN_ON_ONCE(skb_copy_bits(in_skb, offset,
> +					   skb_frag_address(frag) +
> +					   skb_frag_size(frag),
> +					   chunk));
> +
> +		skb->len += chunk;
> +		skb->data_len += chunk;
> +		skb_frag_size_add(frag, chunk);
> +		frag++;
> +		len -= chunk;
> +		offset += chunk;
> +	}
> +
> +	if (strp->stm.full_len == skb->len) {
> +		desc->count = 0;
> +
> +		strp->msg_ready = 1;
> +		tls_rx_msg_ready(strp);
> +	}
> +
> +read_done:
> +	return in_len - len;
> +}
> +
> +static int tls_strp_read_copyin(struct tls_strparser *strp)
> +{
> +	struct socket *sock = strp->sk->sk_socket;
> +	read_descriptor_t desc;
> +
> +	desc.arg.data = strp;
> +	desc.error = 0;
> +	desc.count = 1; /* give more than one skb per call */
> +
> +	/* sk should be locked here, so okay to do read_sock */
> +	sock->ops->read_sock(strp->sk, &desc, tls_strp_copyin);
> +
> +	return desc.error;
> +}
> +
> +static int tls_strp_read_short(struct tls_strparser *strp)
> +{
> +	struct skb_shared_info *shinfo;
> +	struct page *page;
> +	int need_spc, len;
> +
> +	/* If the rbuf is small or rcv window has collapsed to 0 we need
> +	 * to read the data out. Otherwise the connection will stall.
> +	 * Without pressure threshold of INT_MAX will never be ready.
> +	 */
> +	if (likely(!tcp_epollin_ready(strp->sk, INT_MAX)))
> +		return 0;
> +
> +	shinfo = skb_shinfo(strp->anchor);
> +	shinfo->frag_list = NULL;
> +
> +	/* If we don't know the length go max plus page for cipher overhead */
> +	need_spc = strp->stm.full_len ?: TLS_MAX_PAYLOAD_SIZE + PAGE_SIZE;
> +
> +	for (len = need_spc; len > 0; len -= PAGE_SIZE) {
> +		page = alloc_page(strp->sk->sk_allocation);
> +		if (!page) {
> +			tls_strp_flush_anchor_copy(strp);
> +			return -ENOMEM;
> +		}
> +
> +		skb_fill_page_desc(strp->anchor, shinfo->nr_frags++,
> +				   page, 0, 0);
> +	}
> +
> +	strp->copy_mode = 1;
> +	strp->stm.offset = 0;
> +
> +	strp->anchor->len = 0;
> +	strp->anchor->data_len = 0;
> +	strp->anchor->truesize = round_up(need_spc, PAGE_SIZE);
> +
> +	tls_strp_read_copyin(strp);
> +
> +	return 0;
> +}
> +
> +static void tls_strp_load_anchor_with_queue(struct tls_strparser *strp, int len)
> +{
> +	struct tcp_sock *tp = tcp_sk(strp->sk);
> +	struct sk_buff *first;
> +	u32 offset;
> +
> +	first = tcp_recv_skb(strp->sk, tp->copied_seq, &offset);
> +	if (WARN_ON_ONCE(!first))
> +		return;
> +
> +	/* Bestow the state onto the anchor */
> +	strp->anchor->len = offset + len;
> +	strp->anchor->data_len = offset + len;
> +	strp->anchor->truesize = offset + len;
> +
> +	skb_shinfo(strp->anchor)->frag_list = first;
> +
> +	skb_copy_header(strp->anchor, first);
> +	strp->anchor->destructor = NULL;
> +
> +	strp->stm.offset = offset;
> +}
> +
> +void tls_strp_msg_load(struct tls_strparser *strp, bool force_refresh)
> +{
> +	struct strp_msg *rxm;
> +	struct tls_msg *tlm;
> +
> +	DEBUG_NET_WARN_ON_ONCE(!strp->msg_ready);
> +	DEBUG_NET_WARN_ON_ONCE(!strp->stm.full_len);
> +
> +	if (!strp->copy_mode && force_refresh) {
> +		if (WARN_ON(tcp_inq(strp->sk) < strp->stm.full_len))
> +			return;
> +
> +		tls_strp_load_anchor_with_queue(strp, strp->stm.full_len);
> +	}
> +
> +	rxm = strp_msg(strp->anchor);
> +	rxm->full_len	= strp->stm.full_len;
> +	rxm->offset	= strp->stm.offset;
> +	tlm = tls_msg(strp->anchor);
> +	tlm->control	= strp->mark;
> +}
> +
> +/* Called with lock held on lower socket */
> +static int tls_strp_read_sock(struct tls_strparser *strp)
> +{
> +	int sz, inq;
> +
> +	inq = tcp_inq(strp->sk);
> +	if (inq < 1)
> +		return 0;
> +
> +	if (unlikely(strp->copy_mode))
> +		return tls_strp_read_copyin(strp);
> +
> +	if (inq < strp->stm.full_len)
> +		return tls_strp_read_short(strp);
> +
> +	if (!strp->stm.full_len) {
> +		tls_strp_load_anchor_with_queue(strp, inq);
> +
> +		sz = tls_rx_msg_size(strp, strp->anchor);
> +		if (sz < 0) {
> +			tls_strp_abort_strp(strp, sz);
> +			return sz;
> +		}
> +
> +		strp->stm.full_len = sz;
> +
> +		if (!strp->stm.full_len || inq < strp->stm.full_len)
> +			return tls_strp_read_short(strp);
> +	}
> +
> +	strp->msg_ready = 1;
> +	tls_rx_msg_ready(strp);
> +
> +	return 0;
> +}
> +
> +void tls_strp_check_rcv(struct tls_strparser *strp)
> +{
> +	if (unlikely(strp->stopped) || strp->msg_ready)
> +		return;
> +
> +	if (tls_strp_read_sock(strp) == -ENOMEM)
> +		queue_work(tls_strp_wq, &strp->work);
> +}
> +
> +/* Lower sock lock held */
> +void tls_strp_data_ready(struct tls_strparser *strp)
> +{
> +	/* This check is needed to synchronize with do_tls_strp_work.
> +	 * do_tls_strp_work acquires a process lock (lock_sock) whereas
> +	 * the lock held here is bh_lock_sock. The two locks can be
> +	 * held by different threads at the same time, but bh_lock_sock
> +	 * allows a thread in BH context to safely check if the process
> +	 * lock is held. In this case, if the lock is held, queue work.
> +	 */
> +	if (sock_owned_by_user_nocheck(strp->sk)) {
> +		queue_work(tls_strp_wq, &strp->work);
> +		return;
> +	}
> +
> +	tls_strp_check_rcv(strp);
> +}
> +
> +static void tls_strp_work(struct work_struct *w)
> +{
> +	struct tls_strparser *strp =
> +		container_of(w, struct tls_strparser, work);
> +
> +	lock_sock(strp->sk);
> +	tls_strp_check_rcv(strp);
> +	release_sock(strp->sk);
> +}
> +
> +void tls_strp_msg_done(struct tls_strparser *strp)
> +{
> +	WARN_ON(!strp->stm.full_len);
> +
> +	if (likely(!strp->copy_mode))
> +		tcp_read_done(strp->sk, strp->stm.full_len);
> +	else
> +		tls_strp_flush_anchor_copy(strp);
> +
> +	strp->msg_ready = 0;
> +	memset(&strp->stm, 0, sizeof(strp->stm));
> +
> +	tls_strp_check_rcv(strp);
> +}
> +
> +void tls_strp_stop(struct tls_strparser *strp)
> +{
> +	strp->stopped = 1;
> +}
> +
> +int tls_strp_init(struct tls_strparser *strp, struct sock *sk)
> +{
> +	memset(strp, 0, sizeof(*strp));
> +
> +	strp->sk = sk;
> +
> +	strp->anchor = alloc_skb(0, GFP_KERNEL);
> +	if (!strp->anchor)
> +		return -ENOMEM;
> +
> +	INIT_WORK(&strp->work, tls_strp_work);
>   
> -	nsg = skb_cow_data(ctx->recv_pkt, 0, &unused);
> -	if (nsg < 0)
> -		return nsg;
>   	return 0;
>   }
>   
> -int tls_strp_msg_hold(struct sock *sk, struct sk_buff *skb,
> -		      struct sk_buff_head *dst)
> +/* strp must already be stopped so that tls_strp_recv will no longer be called.
> + * Note that tls_strp_done is not called with the lower socket held.
> + */
> +void tls_strp_done(struct tls_strparser *strp)
>   {
> -	struct sk_buff *clone;
> +	WARN_ON(!strp->stopped);
>   
> -	clone = skb_clone(skb, sk->sk_allocation);
> -	if (!clone)
> +	cancel_work_sync(&strp->work);
> +	tls_strp_anchor_free(strp);
> +}
> +
> +int __init tls_strp_dev_init(void)
> +{
> +	tls_strp_wq = create_singlethread_workqueue("kstrp");
> +	if (unlikely(!tls_strp_wq))
>   		return -ENOMEM;
> -	__skb_queue_tail(dst, clone);
> +
>   	return 0;
>   }
> +
> +void tls_strp_dev_exit(void)
> +{
> +	destroy_workqueue(tls_strp_wq);
> +}
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index bd4486819e64..0fc24a5ce208 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1283,7 +1283,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
>   
>   static int
>   tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
> -		long timeo)
> +		bool released, long timeo)
>   {
>   	struct tls_context *tls_ctx = tls_get_ctx(sk);
>   	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> @@ -1297,7 +1297,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>   			return sock_error(sk);
>   
>   		if (!skb_queue_empty(&sk->sk_receive_queue)) {
> -			__strp_unpause(&ctx->strp);
> +			tls_strp_check_rcv(&ctx->strp);
>   			if (tls_strp_msg_ready(ctx))
>   				break;
>   		}
> @@ -1311,6 +1311,7 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>   		if (nonblock || !timeo)
>   			return -EAGAIN;
>   
> +		released = true;
>   		add_wait_queue(sk_sleep(sk), &wait);
>   		sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
>   		sk_wait_event(sk, &timeo,
> @@ -1325,6 +1326,8 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
>   			return sock_intr_errno(timeo);
>   	}
>   
> +	tls_strp_msg_load(&ctx->strp, released);
> +
>   	return 1;
>   }
>   
> @@ -1570,7 +1573,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
>   	clear_skb = NULL;
>   
>   	if (unlikely(darg->async)) {
> -		err = tls_strp_msg_hold(sk, skb, &ctx->async_hold);
> +		err = tls_strp_msg_hold(&ctx->strp, &ctx->async_hold);
>   		if (err)
>   			__skb_queue_tail(&ctx->async_hold, darg->skb);
>   		return err;
> @@ -1734,9 +1737,7 @@ static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
>   
>   static void tls_rx_rec_done(struct tls_sw_context_rx *ctx)
>   {
> -	consume_skb(ctx->recv_pkt);
> -	ctx->recv_pkt = NULL;
> -	__strp_unpause(&ctx->strp);
> +	tls_strp_msg_done(&ctx->strp);
>   }
>   
>   /* This function traverses the rx_list in tls receive context to copies the
> @@ -1823,7 +1824,7 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
>   	return copied ? : err;
>   }
>   
> -static void
> +static bool
>   tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
>   		       size_t len_left, size_t decrypted, ssize_t done,
>   		       size_t *flushed_at)
> @@ -1831,14 +1832,14 @@ tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
>   	size_t max_rec;
>   
>   	if (len_left <= decrypted)
> -		return;
> +		return false;
>   
>   	max_rec = prot->overhead_size - prot->tail_size + TLS_MAX_PAYLOAD_SIZE;
>   	if (done - *flushed_at < SZ_128K && tcp_inq(sk) > max_rec)
> -		return;
> +		return false;
>   
>   	*flushed_at = done;
> -	sk_flush_backlog(sk);
> +	return sk_flush_backlog(sk);
>   }
>   
>   static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
> @@ -1916,6 +1917,7 @@ int tls_sw_recvmsg(struct sock *sk,
>   	long timeo;
>   	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
>   	bool is_peek = flags & MSG_PEEK;
> +	bool released = true;
>   	bool bpf_strp_enabled;
>   	bool zc_capable;
>   
> @@ -1952,7 +1954,8 @@ int tls_sw_recvmsg(struct sock *sk,
>   		struct tls_decrypt_arg darg;
>   		int to_decrypt, chunk;
>   
> -		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, timeo);
> +		err = tls_rx_rec_wait(sk, psock, flags & MSG_DONTWAIT, released,
> +				      timeo);
>   		if (err <= 0) {
>   			if (psock) {
>   				chunk = sk_msg_recvmsg(sk, psock, msg, len,
> @@ -1968,8 +1971,8 @@ int tls_sw_recvmsg(struct sock *sk,
>   
>   		memset(&darg.inargs, 0, sizeof(darg.inargs));
>   
> -		rxm = strp_msg(ctx->recv_pkt);
> -		tlm = tls_msg(ctx->recv_pkt);
> +		rxm = strp_msg(tls_strp_msg(ctx));
> +		tlm = tls_msg(tls_strp_msg(ctx));
>   
>   		to_decrypt = rxm->full_len - prot->overhead_size;
>   
> @@ -2008,8 +2011,9 @@ int tls_sw_recvmsg(struct sock *sk,
>   		}
>   
>   		/* periodically flush backlog, and feed strparser */
> -		tls_read_flush_backlog(sk, prot, len, to_decrypt,
> -				       decrypted + copied, &flushed_at);
> +		released = tls_read_flush_backlog(sk, prot, len, to_decrypt,
> +						  decrypted + copied,
> +						  &flushed_at);
>   
>   		/* TLS 1.3 may have updated the length by more than overhead */
>   		rxm = strp_msg(darg.skb);
> @@ -2020,7 +2024,7 @@ int tls_sw_recvmsg(struct sock *sk,
>   			bool partially_consumed = chunk > len;
>   			struct sk_buff *skb = darg.skb;
>   
> -			DEBUG_NET_WARN_ON_ONCE(darg.skb == ctx->recv_pkt);
> +			DEBUG_NET_WARN_ON_ONCE(darg.skb == tls_strp_msg(ctx));
>   
>   			if (async) {
>   				/* TLS 1.2-only, to_decrypt must be text len */
> @@ -2034,6 +2038,7 @@ int tls_sw_recvmsg(struct sock *sk,
>   			}
>   
>   			if (bpf_strp_enabled) {
> +				released = true;
>   				err = sk_psock_tls_strp_read(psock, skb);
>   				if (err != __SK_PASS) {
>   					rxm->offset = rxm->offset + rxm->full_len;
> @@ -2140,7 +2145,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>   		struct tls_decrypt_arg darg;
>   
>   		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
> -				      timeo);
> +				      true, timeo);
>   		if (err <= 0)
>   			goto splice_read_end;
>   
> @@ -2204,19 +2209,17 @@ bool tls_sw_sock_is_readable(struct sock *sk)
>   		!skb_queue_empty(&ctx->rx_list);
>   }
>   
> -static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
> +int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb)
>   {
>   	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
>   	struct tls_prot_info *prot = &tls_ctx->prot_info;
>   	char header[TLS_HEADER_SIZE + MAX_IV_SIZE];
> -	struct strp_msg *rxm = strp_msg(skb);
> -	struct tls_msg *tlm = tls_msg(skb);
>   	size_t cipher_overhead;
>   	size_t data_len = 0;
>   	int ret;
>   
>   	/* Verify that we have a full TLS header, or wait for more data */
> -	if (rxm->offset + prot->prepend_size > skb->len)
> +	if (strp->stm.offset + prot->prepend_size > skb->len)
>   		return 0;
>   
>   	/* Sanity-check size of on-stack buffer. */
> @@ -2226,11 +2229,11 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>   	}
>   
>   	/* Linearize header to local buffer */
> -	ret = skb_copy_bits(skb, rxm->offset, header, prot->prepend_size);
> +	ret = skb_copy_bits(skb, strp->stm.offset, header, prot->prepend_size);
>   	if (ret < 0)
>   		goto read_failure;
>   
> -	tlm->control = header[0];
> +	strp->mark = header[0];
>   
>   	data_len = ((header[4] & 0xFF) | (header[3] << 8));
>   
> @@ -2257,7 +2260,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>   	}
>   
>   	tls_device_rx_resync_new_rec(strp->sk, data_len + TLS_HEADER_SIZE,
> -				     TCP_SKB_CB(skb)->seq + rxm->offset);
> +				     TCP_SKB_CB(skb)->seq + strp->stm.offset);
>   	return data_len + TLS_HEADER_SIZE;
>   
>   read_failure:
> @@ -2266,14 +2269,11 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
>   	return ret;
>   }
>   
> -static void tls_queue(struct strparser *strp, struct sk_buff *skb)
> +void tls_rx_msg_ready(struct tls_strparser *strp)
>   {
> -	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
> -	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> -
> -	ctx->recv_pkt = skb;
> -	strp_pause(strp);
> +	struct tls_sw_context_rx *ctx;
>   
> +	ctx = container_of(strp, struct tls_sw_context_rx, strp);
>   	ctx->saved_data_ready(strp->sk);
>   }
>   
> @@ -2283,7 +2283,7 @@ static void tls_data_ready(struct sock *sk)
>   	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
>   	struct sk_psock *psock;
>   
> -	strp_data_ready(&ctx->strp);
> +	tls_strp_data_ready(&ctx->strp);
>   
>   	psock = sk_psock_get(sk);
>   	if (psock) {
> @@ -2359,13 +2359,11 @@ void tls_sw_release_resources_rx(struct sock *sk)
>   	kfree(tls_ctx->rx.iv);
>   
>   	if (ctx->aead_recv) {
> -		kfree_skb(ctx->recv_pkt);
> -		ctx->recv_pkt = NULL;
>   		__skb_queue_purge(&ctx->rx_list);
>   		crypto_free_aead(ctx->aead_recv);
> -		strp_stop(&ctx->strp);
> +		tls_strp_stop(&ctx->strp);
>   		/* If tls_sw_strparser_arm() was not called (cleanup paths)
> -		 * we still want to strp_stop(), but sk->sk_data_ready was
> +		 * we still want to tls_strp_stop(), but sk->sk_data_ready was
>   		 * never swapped.
>   		 */
>   		if (ctx->saved_data_ready) {
> @@ -2380,7 +2378,7 @@ void tls_sw_strparser_done(struct tls_context *tls_ctx)
>   {
>   	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
>   
> -	strp_done(&ctx->strp);
> +	tls_strp_done(&ctx->strp);
>   }
>   
>   void tls_sw_free_ctx_rx(struct tls_context *tls_ctx)
> @@ -2453,8 +2451,6 @@ void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)
>   	rx_ctx->saved_data_ready = sk->sk_data_ready;
>   	sk->sk_data_ready = tls_data_ready;
>   	write_unlock_bh(&sk->sk_callback_lock);
> -
> -	strp_check_rcv(&rx_ctx->strp);
>   }
>   
>   void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
> @@ -2474,7 +2470,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>   	struct tls_sw_context_rx *sw_ctx_rx = NULL;
>   	struct cipher_context *cctx;
>   	struct crypto_aead **aead;
> -	struct strp_callbacks cb;
>   	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
>   	struct crypto_tfm *tfm;
>   	char *iv, *rec_seq, *key, *salt, *cipher_name;
> @@ -2708,12 +2703,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>   			crypto_info->version != TLS_1_3_VERSION &&
>   			!!(tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC);
>   
> -		/* Set up strparser */
> -		memset(&cb, 0, sizeof(cb));
> -		cb.rcv_msg = tls_queue;
> -		cb.parse_msg = tls_read_size;
> -
> -		strp_init(&sw_ctx_rx->strp, sk, &cb);
> +		tls_strp_init(&sw_ctx_rx->strp, sk);
>   	}
>   
>   	goto out;
