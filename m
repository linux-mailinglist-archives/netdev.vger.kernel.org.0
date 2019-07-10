Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC1663F6F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 04:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfGJCpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 22:45:31 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46203 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGJCpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 22:45:30 -0400
Received: by mail-qk1-f196.google.com with SMTP id r4so722343qkm.13
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5MlFoEiTtYSTVJEd0HMKdj+ihpPJtAa4d5q9E1NXRJI=;
        b=Wt+9y0JGXadhEj9HiS2rfKl4+ms0KC+UhtzLXL6LPYEcXsujxEn8/JjRSRafjWv/iI
         GHfQYe9pYJ08iodBeu9FgA781m55PnAP+OBdl5hURTlSEh3nVOLip0evvIFFC8FjxkkV
         9eEkAYDemnt8UtsExQckSO4ivW2588WONe6gz8ZpYASBfoyml2ogqYEdSBfqSgApRVWH
         +GlnxhWjEpeMmgZA53HX1lJQ4HscXmnfRhMFevpqKT6xg6KOmvXP33Z0gISVS57rdWWk
         qsDhZ8eKv+uIRfw3sgG3Ha9E/vk5Ah31TttUV0+vKUjhE3uH2Hg1/0p0IE6e/koeUXkT
         153w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5MlFoEiTtYSTVJEd0HMKdj+ihpPJtAa4d5q9E1NXRJI=;
        b=MjbG25OU4GzXPjx67woGRIDF8WAz7U5LWiy++XNiP7t0TnoesWGt/UnbZzGmCzdZgd
         ihw15xPBGTpO4W1siBmYA2FRV1nUxPqsO+RZEqsNqVDNNyZiGoP5PhETQ5BYJ0IOVgwe
         wWmaIiCcuYxeVokM0Mn16u05AM5NiBZyPZTWT7UAsaCV9FbnV0oHoOllI9KM117X55dE
         9fzd3s4HQZTxhJyEHBlANo5ZWq/+aEQ1zc+IPd4tX3rFrmEKLqFhZ2+nlH2Tl3ZkYgC/
         UsjIzNLF8D0a1DAy2wfP/CcoxOrz66T0LKnA53bR8iGioihrhwAQWrcqJdN+KiROjgXJ
         jQBg==
X-Gm-Message-State: APjAAAWPddp/AyUzKBpoPujU82iKSX0G90ndgJ/essJagUEKIloduFfb
        F23ZAIMl0HMxaAq4zCcHCF18MA==
X-Google-Smtp-Source: APXvYqyuQt1e1waxiE9pFUL/sKhb/WjW8PONZ9WRuZlEEo+yY3XRXB3qpliQv9i1hpvmwbhogS9q7w==
X-Received: by 2002:a05:620a:11af:: with SMTP id c15mr19958626qkk.488.1562726729717;
        Tue, 09 Jul 2019 19:45:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 42sm402397qtm.27.2019.07.09.19.45.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 19:45:29 -0700 (PDT)
Date:   Tue, 9 Jul 2019 19:45:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Message-ID: <20190709194525.0d4c15a6@cakuba.netronome.com>
In-Reply-To: <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
        <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Jul 2019 19:14:05 +0000, John Fastabend wrote:
> @@ -287,6 +313,27 @@ static void tls_sk_proto_cleanup(struct sock *sk,
>  #endif
>  }
>  
> +static void tls_sk_proto_unhash(struct sock *sk)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +	long timeo = sock_sndtimeo(sk, 0);
> +	struct tls_context *ctx;
> +
> +	if (unlikely(!icsk->icsk_ulp_data)) {

Is this for when sockmap is stacked on top of TLS and TLS got removed
without letting sockmap know?

> +		if (sk->sk_prot->unhash)
> +			sk->sk_prot->unhash(sk);
> +	}
> +
> +	ctx = tls_get_ctx(sk);
> +	if (ctx->tx_conf == TLS_SW || ctx->rx_conf == TLS_SW)
> +		tls_sk_proto_cleanup(sk, ctx, timeo);
> +	icsk->icsk_ulp_data = NULL;

I think close only starts checking if ctx is NULL in patch 6.
Looks like some chunks of ctx checking/clearing got spread to
patch 1 and some to patch 6.

> +	tls_ctx_free_wq(ctx);
> +
> +	if (ctx->unhash)
> +		ctx->unhash(sk);
> +}
> +
>  static void tls_sk_proto_close(struct sock *sk, long timeout)
>  {
>  	struct tls_context *ctx = tls_get_ctx(sk);

