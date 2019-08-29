Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B84A2944
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfH2V5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:57:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37260 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2V5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:57:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id f22so5706116edt.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=h/LiflgmlS4SoITeTs7hD6wJ/bWTXbbVkBj2pyRvMY4=;
        b=FsBfeb3WTBg5B9/dzpVkiety/3Onq1MbjEsTFJPwZvLfTUPeJlHixjq6yh1GEeuVUV
         fPmCs874UFiAFSCFx55oMYSUiS5fmqf4f3/04SoYBxlOYliTBweUUiR1Bedy9t3gBuGP
         A96VRTxtPy5GiNLeDXtK67xkZwq9Qc/OOU54Und8ymXa0w5sJah5RAtudSkfvTtx/h0X
         o1c5At5rqaMpQDzgvXt5fhqMdpUODR5DWrfmgVXxpHZ0I89LnUC5m+dN1s1aTPSHfMze
         J5JAwFHy/XSaHqmKMB1QRvtZaOBsf9BPls3UyrxqEhwjUNbu2MS71zZrwpYPfdMFRbjX
         DXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=h/LiflgmlS4SoITeTs7hD6wJ/bWTXbbVkBj2pyRvMY4=;
        b=rrtqbiyG0avb8PziC/2GugZ/PSYxfQpEQPYwjmFhmHBWwQG5EpemZTHCFz106LruEK
         Xk6AUtVdXT7Vh9gs5V3oJqQe4aYP+wAOwfxtojy8xrYfrj3YMpsnJIgdNwBspZzEpNdd
         MauYEcgGXmFifLbmMgdtAz5CYdYZmey9eKYZHvmNpIK+1u2hpUFo9Fdxql8/dsgvEtdH
         uK7PeiPVR5HEoW02kgmRdi5ghq7WjyraNCBJ0gdd+wURgUWko/g+6DsQKNzr/bWtnpmv
         +IbQl29vs+czzacYf+W3s1DNU/zbTSQjLTOprFS1CjyJwgYx9btz88dQZKgj8xw3Ac4V
         0O8w==
X-Gm-Message-State: APjAAAUQaSCzLhriSoA5cHD/aeY//NZ5END7x7Lcwy4LG1xR0Jekux+O
        HPozH7r7cGDr/fJqo6IaQH/13A==
X-Google-Smtp-Source: APXvYqzFCZoafc5BB0b1isIJWWfsdJCQ2/r5/OX0M0E3OB4DU2+FkkNqNIwC9beWRNrIHm3Y+kzxVg==
X-Received: by 2002:a17:906:848c:: with SMTP id m12mr6151077ejx.198.1567115828038;
        Thu, 29 Aug 2019 14:57:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i18sm539616ejy.74.2019.08.29.14.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 14:57:07 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:56:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     borisp@mellanox.com, Eric Dumazet <eric.dumazet@gmail.com>,
        aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: tls: export protocol version,
 cipher, tx_conf/rx_conf to socket diag
Message-ID: <20190829145642.3f3de3ae@cakuba.netronome.com>
In-Reply-To: <22da29aa0d0c683afeba7549cabc64c5e073d308.1567095873.git.dcaratti@redhat.com>
References: <cover.1567095873.git.dcaratti@redhat.com>
        <22da29aa0d0c683afeba7549cabc64c5e073d308.1567095873.git.dcaratti@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 18:48:04 +0200, Davide Caratti wrote:
> When an application configures kernel TLS on top of a TCP socket, it's
> now possible for inet_diag_handler() to collect information regarding the
> protocol version, the cipher type and TX / RX configuration, in case
> INET_DIAG_INFO is requested.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

> diff --git a/include/net/tls.h b/include/net/tls.h
> index 4997742475cd..990f1d9182a3 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -431,6 +431,25 @@ static inline bool is_tx_ready(struct tls_sw_context_tx *ctx)
>  	return READ_ONCE(rec->tx_ready);
>  }
>  
> +static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
> +{
> +	u16 config = tx ? ctx->tx_conf : ctx->rx_conf;
> +
> +	switch (config) {
> +	case TLS_BASE:
> +		return TLS_CONF_BASE;
> +	case TLS_SW:
> +		return TLS_CONF_SW;
> +#ifdef CONFIG_TLS_DEVICE

Recently the TLS_HW define was taken out of the ifdef, so the ifdef
around this is no longer necessary.

> +	case TLS_HW:
> +		return TLS_CONF_HW;
> +#endif
> +	case TLS_HW_RECORD:
> +		return TLS_CONF_HW_RECORD;
> +	}
> +	return 0;
> +}
> +
>  struct sk_buff *
>  tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
>  		      struct sk_buff *skb);

> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index f8f2d2c3d627..3351a2ace369 100644
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
> @@ -835,6 +836,67 @@ static void tls_update(struct sock *sk, struct proto *p)
>  	}
>  }
>  
> +static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
> +{
> +	struct tls_context *ctx;
> +	u16 version, cipher_type;

Unfortunately revere christmas tree will be needed :(

> +	struct nlattr *start;
> +	int err;
