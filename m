Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7FF558EB4
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfF0XoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:44:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39710 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF0XoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:44:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so4413865qta.6
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=92lp0xgn9ozuwMluBb+GK89shu/nsFFXOrnchZ1oLZM=;
        b=gxtyizph6Kj+gyPRRJ7LQcJtp+zfH7VesgngdyUJSQfeM356239ZdLCQQQTNGB+kxs
         efOrPZGmDZK4l8OFlBbkGp7K3lAZe57QmMBwcJknAwj87jARDlMlbCRpHUqTEEgMqkL8
         m8FVCI/Vo4W8nqWlcq9Z8T+1ySIg1COKJ7IBEhuDq6kZ7DrT5AxCbXK757znuQ4Gu/X0
         w+AAZ7xWIkehTF2c1qSVD3wp0YACgzejuPXCnWMolf4x5gSOyukWbkSaZiHjTKoxofCT
         4V2wgZ660/yj2Z/qRkgDNgP4YUk6AfTt7IzFL/pLZ7E64UcwczJGEfb4qgnd+10aU/0y
         j/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=92lp0xgn9ozuwMluBb+GK89shu/nsFFXOrnchZ1oLZM=;
        b=MGLmKSiJs82Ay9w/qjbtcJl0ijvaHfmmB0ugZ156c4WP2hC3pJ9Fh/v6vmauLP+L88
         i+qpza/jxNgPtIEHe2wgLDxiQ/x6+rDa0S9Y6Lk58mkksyoQ2CKwAU7rs4ugZ6CCYeBy
         jEAeJhlyNQDdGf6yFGhUK24NRmr4uai6OXB6PsrpdgV+v2q5npo9ssOSSqHw1/QXfb29
         ThFBDabEnVXXo3W9BF2UOzMZ+o2OvjC6wLcCVSjzJF5L4PhE5yFiQdI1qumUFQiJZcYB
         NAXB/byt6gXJV7RI/g0TVF4RgxeJCWCXiATndgWy+FL6IXJWh+hpJlak6H6o9tnwlDtf
         CIzw==
X-Gm-Message-State: APjAAAUS089TkACKQPyOhXFcPAPpY4r/fX34Ase7pDySBj8izcv5Y61o
        A2Yy9K3pTtXVeoB2gIboh8pqcA==
X-Google-Smtp-Source: APXvYqy1SvIgYI2ik87ia6AysDGTbd87ks7pJeQh0D1L+uBT7qHQnOzSqDE7DcU24abOo5n5lDv+UQ==
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr5528922qta.171.1561679046578;
        Thu, 27 Jun 2019 16:44:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s44sm372502qtc.8.2019.06.27.16.44.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 16:44:06 -0700 (PDT)
Date:   Thu, 27 Jun 2019 16:44:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.io, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Message-ID: <20190627164402.31cbd466@cakuba.netronome.com>
In-Reply-To: <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
        <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 10:36:42 -0700, John Fastabend wrote:
> The tls close() callback currently drops the sock lock, makes a
> cancel_delayed_work_sync() call, and then relocks the sock. This
> seems suspect at best. The lock_sock() is applied to stop concurrent
> operations on the socket while tearing the sock down. Further we
> will need to add support for unhash() shortly and this complicates
> matters because the lock may or may not be held then.
> 
> So to fix the above situation and simplify the next patch to add
> unhash this patch creates a function tls_sk_proto_cleanup() that
> tears down the socket without calling lock_sock/release_sock. In
> order to flush the workqueue then we do the following,
> 
>   - Add a new bit to ctx, BIT_TX_CLOSING that is set when the
>     tls resources are being removed.
>   - Check this bit before scheduling any new work. This way we
>     avoid queueing new work after tear down has started.
>   - With the BIT_TX_CLOSING ensuring no new work is being added
>     convert the cancel_delayed_work_sync to flush_delayed_work()
>   - Finally call tlx_tx_records() to complete any available records
>     before,
>   - releasing and removing tls ctx.
> 
> The above is implemented for the software case namely any of
> the following configurations from build_protos,
> 
>    prot[TLS_SW][TLS_BASE]
>    prot[TLS_BASE][TLS_SW]
>    prot[TLS_SW][TLS_SW]
> 
> The implication is a follow up patch is needed to resolve the
> hardware offload case.
> 
> Tested with net selftests and bpf selftests.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/net/tls.h  |    4 ++--
>  net/tls/tls_main.c |   54 ++++++++++++++++++++++++++--------------------------
>  net/tls/tls_sw.c   |   50 ++++++++++++++++++++++++++++++++----------------
>  3 files changed, 62 insertions(+), 46 deletions(-)
> 
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 4a55ce6a303f..6fe1f5c96f4a 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -105,9 +105,7 @@ struct tls_device {
>  enum {
>  	TLS_BASE,
>  	TLS_SW,
> -#ifdef CONFIG_TLS_DEVICE
>  	TLS_HW,
> -#endif
>  	TLS_HW_RECORD,
>  	TLS_NUM_CONFIG,
>  };
> @@ -160,6 +158,7 @@ struct tls_sw_context_tx {
>  	int async_capable;
>  
>  #define BIT_TX_SCHEDULED	0

BTW do you understand why we track this bit separately?  Just to avoid
the irq operations in the workqueue code?

> +#define BIT_TX_CLOSING		1

But since we do have the above, and I think it's tested everywhere,
wouldn't setting SCHEDULED without accentually scheduling have
effectively the same result?

>  	unsigned long tx_bitmask;
>  };
>  
> @@ -327,6 +326,7 @@ void tls_sw_close(struct sock *sk, long timeout);
>  void tls_sw_free_resources_tx(struct sock *sk);
>  void tls_sw_free_resources_rx(struct sock *sk);
>  void tls_sw_release_resources_rx(struct sock *sk);
> +void tls_sw_release_strp_rx(struct tls_context *tls_ctx);
>  int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  		   int nonblock, int flags, int *addr_len);
>  bool tls_sw_stream_read(const struct sock *sk);
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index fc81ae18cc44..51cb19e24dd9 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -261,24 +261,9 @@ static void tls_ctx_free(struct tls_context *ctx)
>  	kfree(ctx);
>  }
>  
> -static void tls_sk_proto_close(struct sock *sk, long timeout)
> +static void tls_sk_proto_cleanup(struct sock *sk,
> +				 struct tls_context *ctx, long timeo)
>  {
> -	struct tls_context *ctx = tls_get_ctx(sk);
> -	long timeo = sock_sndtimeo(sk, 0);
> -	void (*sk_proto_close)(struct sock *sk, long timeout);
> -	bool free_ctx = false;
> -
> -	lock_sock(sk);
> -	sk_proto_close = ctx->sk_proto_close;
> -
> -	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
> -		goto skip_tx_cleanup;
> -
> -	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
> -		free_ctx = true;
> -		goto skip_tx_cleanup;
> -	}
> -
>  	if (!tls_complete_pending_work(sk, ctx, 0, &timeo))
>  		tls_handle_open_record(sk, 0);
>  
> @@ -299,22 +284,37 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
>  #ifdef CONFIG_TLS_DEVICE
>  	if (ctx->rx_conf == TLS_HW)
>  		tls_device_offload_cleanup_rx(sk);
> -
> -	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW) {
> -#else
> -	{
>  #endif
> -		tls_ctx_free(ctx);
> -		ctx = NULL;
> +}
> +
> +static void tls_sk_proto_close(struct sock *sk, long timeout)
> +{
> +	struct tls_context *ctx = tls_get_ctx(sk);
> +	long timeo = sock_sndtimeo(sk, 0);
> +	void (*sk_proto_close)(struct sock *sk, long timeout);
> +	bool free_ctx = false;

Set but not used?

> +
> +	lock_sock(sk);
> +	sk_proto_close = ctx->sk_proto_close;
> +
> +	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
> +		goto skip_tx_cleanup;
> +
> +	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
> +		free_ctx = true;
> +		goto skip_tx_cleanup;
>  	}
>  
> +	tls_sk_proto_cleanup(sk, ctx, timeo);
> +
>  skip_tx_cleanup:
>  	release_sock(sk);
> +	if (ctx->rx_conf == TLS_SW)
> +		tls_sw_release_strp_rx(ctx);
>  	sk_proto_close(sk, timeout);
> -	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
> -	 * for sk->sk_prot->unhash [tls_hw_unhash]
> -	 */
> -	if (free_ctx)
> +
> +	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
> +	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
>  		tls_ctx_free(ctx);
>  }
>  
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 455a782c7658..d234a6b818e6 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -473,7 +473,8 @@ static void tls_encrypt_done(struct crypto_async_request *req, int err)
>  		return;
>  
>  	/* Schedule the transmission */
> -	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
> +	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask) &&
> +	    !test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))

Probably doesn't matter but seems like CLOSING test should be before
the test_and_set().

>  		schedule_delayed_work(&ctx->tx_work.work, 1);
>  }
>  
> @@ -2058,16 +2059,26 @@ void tls_sw_free_resources_tx(struct sock *sk)
>  	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
>  	struct tls_rec *rec, *tmp;
>  
> +	/* Set TX CLOSING bit to stop tx_work from being scheduled
> +	 * while tearing down TX context. We will flush any pending
> +	 * work before free'ing ctx anyways. If already set then
> +	 * another call is already free'ing resources.
> +	 */

Oh, can we get multiple calls here?  Is this prep for unhash?

> +	if (test_and_set_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
> +		return;
> +
>  	/* Wait for any pending async encryptions to complete */
>  	smp_store_mb(ctx->async_notify, true);
>  	if (atomic_read(&ctx->encrypt_pending))
>  		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
>  
> -	release_sock(sk);
> -	cancel_delayed_work_sync(&ctx->tx_work.work);
> -	lock_sock(sk);
> -
> -	/* Tx whatever records we can transmit and abandon the rest */
> +	/* Flush work queue and then Tx whatever records we can
> +	 * transmit and abandon the rest, lock_sock(sk) must be
> +	 * held here. We ensure no further work is enqueue by
> +	 * checking CLOSING bit before queueing new work and
> +	 * setting it above.
> +	 */
> +	flush_delayed_work(&ctx->tx_work.work);
>  	tls_tx_records(sk, -1);
>  
>  	/* Free up un-sent records in tx_list. First, free
> @@ -2111,22 +2122,22 @@ void tls_sw_release_resources_rx(struct sock *sk)
>  		write_lock_bh(&sk->sk_callback_lock);
>  		sk->sk_data_ready = ctx->saved_data_ready;
>  		write_unlock_bh(&sk->sk_callback_lock);
> -		release_sock(sk);
> -		strp_done(&ctx->strp);
> -		lock_sock(sk);
>  	}
>  }
>  
> -void tls_sw_free_resources_rx(struct sock *sk)
> +void tls_sw_release_strp_rx(struct tls_context *tls_ctx)
>  {
> -	struct tls_context *tls_ctx = tls_get_ctx(sk);
>  	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
>  
> -	tls_sw_release_resources_rx(sk);
> -
> +	strp_done(&ctx->strp);
>  	kfree(ctx);
>  }
>  
> +void tls_sw_free_resources_rx(struct sock *sk)
> +{
> +	tls_sw_release_resources_rx(sk);
> +}

I don't understand the RX side well enough, but perhaps a separate
patch would make sense here?

>  /* The work handler to transmitt the encrypted records in tx_list */
>  static void tx_work_handler(struct work_struct *work)
>  {
> @@ -2140,9 +2151,14 @@ static void tx_work_handler(struct work_struct *work)
>  	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
>  		return;
>  
> -	lock_sock(sk);
> +	/* If we are running from a socket close operation then the
> +	 * lock is already held so we do not need to hold it.
> +	 */
> +	if (likely(!test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask)))
> +		lock_sock(sk);

	CPU 0 (free)		CPU 1 (wq)
				test_bit()
	lock(sk)
	set_bit()
				lock(sk)
	flush_work()

No?

>  	tls_tx_records(sk, -1);
> -	release_sock(sk);
> +	if (likely(!test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask)))
> +		release_sock(sk);
>  }
>  
>  void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
> @@ -2152,8 +2168,8 @@ void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
>  	/* Schedule the transmission if tx list is ready */
>  	if (is_tx_ready(tx_ctx) && !sk->sk_write_pending) {
>  		/* Schedule the transmission */
> -		if (!test_and_set_bit(BIT_TX_SCHEDULED,
> -				      &tx_ctx->tx_bitmask))
> +		if (!test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask) &&
> +		    !test_bit(BIT_TX_CLOSING, &tx_ctx->tx_bitmask))
>  			schedule_delayed_work(&tx_ctx->tx_work.work, 0);
>  	}
>  }
> 

