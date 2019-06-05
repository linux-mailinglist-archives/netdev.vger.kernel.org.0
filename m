Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1DF367F3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfFEX0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:26:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39549 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFEX0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:26:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so588764qta.6
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 16:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XXYe6eyDoxpvzz5/t6fTpk8tBKQrm37Dh7l5QFZtsFU=;
        b=KPxh1qmNEIXY2Bl5akG9MoyYC82dDSbhAnkttfptfxml8ba3mPbqpNIVR+AuiNYTfP
         tatsNVgA4UF/YZRky7hInfPbQaTe63dMW4kcLAIEm9Q5ngbgCXMKjAqxPSJFIYy/GYN/
         EScj84gWpGQKSFbBTKsU3HmXsq55VoS91IwCB8ur0A5n+z04iKCUrSnCgNQ0wfIZv7tO
         yZm/PtG9HKRU03Xe7oESo3oyWgeBO3aUlLS5z0UA1/HzpbStVfvqW0zwVF7kZkA179pj
         BbjHz+W82mGiFqpQU/LQDwiH5P4dqBFHdckF6Eo+EbyqjlUu19TUZUoscaMuzb+PC1tu
         E5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XXYe6eyDoxpvzz5/t6fTpk8tBKQrm37Dh7l5QFZtsFU=;
        b=HSpihXazajc3g9yJsp1fhTt0PRMixcQX4LWnPxmbPCys9w56aXclL2/8bzxCeGlxfr
         d+xiZj23CVql0I60wuP08kQMLH35XEdVdr0gNaDNXfBJt1kLcW/9Py9y7dmUQuLRvwFu
         cBklC3SHbenRyk4a3Y99aCavQx9GtQ3EKiWMtsVhXy3SLKY2vxDk00ckCYb5JAvBfp24
         dElj2GGXo2re4uWp/bbsVuvuCZ3oVS2ePzU/coNKbQd36QvnncGFBCl90VVtHq0A+01d
         OYXs74aE27GS6rgdcDwB0JtIFzUyJCPZEAoi3mUrK8tIwWFOMb27QxpLig5lR7Wr7MXZ
         GPug==
X-Gm-Message-State: APjAAAWPAjnaUjfLD/b5AWc94U6T5fK20ozojnhNek/J3jQzq+QnrJDv
        pX7xI4PqQloh0V7P2tRmHh/+dw==
X-Google-Smtp-Source: APXvYqxZkXOfrFxtMXzo4fEdTSvNYj5e8DrjP6vOaUUbnaMEj16PakciBW4xaXsDV0F2V6oU+0RFvQ==
X-Received: by 2002:ac8:3296:: with SMTP id z22mr11387470qta.236.1559777160523;
        Wed, 05 Jun 2019 16:26:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l3sm28781qkd.49.2019.06.05.16.25.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 16:26:00 -0700 (PDT)
Date:   Wed, 5 Jun 2019 16:25:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/2] net: tls: export protocol version and
 cipher to socket diag
Message-ID: <20190605162555.59b4fb3e@cakuba.netronome.com>
In-Reply-To: <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
        <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 17:39:23 +0200, Davide Caratti wrote:
> When an application configures kernel TLS on top of a TCP socket, it's
> now possible for inet_diag_handler to collect information regarding the
> protocol version and the cipher, in case INET_DIAG_INFO is requested.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/uapi/linux/inet_diag.h |  1 +
>  include/uapi/linux/tls.h       |  8 +++++++
>  net/tls/tls_main.c             | 43 ++++++++++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+)
> 
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index 844133de3212..92208535c096 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -161,6 +161,7 @@ enum {
>  
>  enum {
>  	ULP_INFO_NAME,
> +	ULP_INFO_TLS,
>  	__ULP_INFO_MAX,
>  };
>  
> diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
> index 5b9c26753e46..442348bd2e54 100644
> --- a/include/uapi/linux/tls.h
> +++ b/include/uapi/linux/tls.h
> @@ -109,4 +109,12 @@ struct tls12_crypto_info_aes_ccm_128 {
>  	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
>  };
>  
> +enum {

USPEC

> +	TLS_INFO_VERSION,
> +	TLS_INFO_CIPHER,

We need some indication of the directions in which kTLS is active
(none, rx, tx, rx/tx).

Also perhaps could you add TLS_SW vs TLS_HW etc. ? :)

> +	__TLS_INFO_MAX,
> +};
> +

Traditionally we put no new line between enum and the max define.

> +#define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
> +
>  #endif /* _UAPI_LINUX_TLS_H */
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index fc81ae18cc44..14597526981c 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -39,6 +39,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/sched/signal.h>
>  #include <linux/inetdevice.h>
> +#include <linux/inet_diag.h>
> 
>  #include <net/tls.h>
>  
> @@ -798,6 +799,46 @@ static int tls_init(struct sock *sk)
>  	return rc;
>  }
>  
> +static int tls_get_info(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct tls_context *ctx = tls_get_ctx(sk);
> +	struct nlattr *start = 0;

Hm.. NULL?  Does this not give you a warning?

> +	int err = 0;

There should be no need to init this.

> +	if (sk->sk_state != TCP_ESTABLISHED)

Hmm.. why this check?  We never clean up the state once installed until
the socket dies completely (currently, pending John's unhash work).

> +		goto end;

Please don't do this, just return 0; here.

> +	start = nla_nest_start_noflag(skb, ULP_INFO_TLS);
> +	if (!start) {
> +		err = -EMSGSIZE;
> +		goto nla_failure;

		return -EMSGSIZE;

> +	}
> +	err = nla_put_u16(skb, TLS_INFO_VERSION, ctx->prot_info.version);
> +	if (err < 0)
> +		goto nla_failure;
> +	err = nla_put_u16(skb, TLS_INFO_CIPHER, ctx->prot_info.cipher_type);
> +	if (err < 0)
> +		goto nla_failure;
> +	nla_nest_end(skb, start);
> +end:
> +	return err;

	return 0;

> +nla_failure:
> +	nla_nest_cancel(skb, start);
> +	goto end;

	return err;

> +}
> +
> +static size_t tls_get_info_size(struct sock *sk)
> +{
> +	size_t size = 0;
> +
> +	if (sk->sk_state != TCP_ESTABLISHED)
> +		return size;
> +
> +	size +=   nla_total_size(0) /* ULP_INFO_TLS */
> +		+ nla_total_size(sizeof(__u16))	/* TLS_INFO_VERSION */
> +		+ nla_total_size(sizeof(__u16)); /* TLS_INFO_CIPHER */
> +	return size;
> +}

Same comments as on patch 1 and above.

>  void tls_register_device(struct tls_device *device)
>  {
>  	spin_lock_bh(&device_spinlock);

Thanks for working on this, it was on my todo list! :)
