Return-Path: <netdev+bounces-10610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C159972F58A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA1F01C208C2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A575EA5E;
	Wed, 14 Jun 2023 07:09:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999D17F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:09:10 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E43A1BD3;
	Wed, 14 Jun 2023 00:09:08 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977cf86aae5so52808966b.0;
        Wed, 14 Jun 2023 00:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686726547; x=1689318547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQ68G2T9sQKjPb+2pkANGWg3W2HeuEanoLaoohVC2mo=;
        b=K/CUsWp6tf8rMVWWwmL2Rxpb5lnD4znSw3ZLjYsCEf5ztUVzahW5PKWq2sexwsUbx6
         rbBAFfB5M1PYwDVjrSfWc5WaJFUGQQmUQZlcxpHPaUr7NfLQ8OB7U4U3B90VngDBTI7+
         WpXMf9UP76VxMmfJ1Yxxja9co+NEbVrLRSQruaAM6rWen8rNcXoeOciju5Qcq3UnAtTX
         AwxqHGVlRrhImBZ76j+vrHT18VAFUvt8bFTkwn2MwnFvYcdwLVq1LDxLK8veP/ATwFC9
         QyK3H1QBMQMhqQpEFOXkTG6Q0w/gUeVDFilLRtLn2m2KklC69VyFHlXCPuQWdnk9L+xn
         79dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686726547; x=1689318547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQ68G2T9sQKjPb+2pkANGWg3W2HeuEanoLaoohVC2mo=;
        b=baEn5B4/erawvorsyaifWTB0ok3azepMqTKGGmMP/H/b9VKSt9ga+EA+pPa1C2QDD0
         kW8uk4x2HSm5GeKVPbrDFhTKE1Xgzi1Mi7mFkFSbSixulUlWbmJMrd1H0Bl2vCdfqMgF
         WRIA7KkNovvYe7OKj4VbOe2qsD6gpKrbuBVOxmdJWE/Ky98J5dJPOuVVSAYz0cfEZ2/E
         gCAHYG25qG9x2Fh3lu4J1eEqGzAR+x/ooVl/Q7vz1/MsfV9ZZLdfvRa8w7/kib+eqyGD
         6Wx7HV4QMqIvc7WFw2HZYZYOG0kITizqmX0WKognWzxHl3HYt1mV5bdxJ6E2EHUA5Pm2
         eQwg==
X-Gm-Message-State: AC+VfDzoozGs4y/+e0yLv8MRPnpZhsfzioz80/ixkoq254LGzemrnnib
	lXGmbBO3+TTRYqw45gldKDc=
X-Google-Smtp-Source: ACHHUZ75lXtTVkbsy75zZgLVfmZqSpIPIV68GNPDB1JimL+QNuFasY8bcAhE87hFZNwdR2nGRQpNjw==
X-Received: by 2002:a17:907:168a:b0:982:3bae:afda with SMTP id hc10-20020a170907168a00b009823baeafdamr4073647ejc.45.1686726546545;
        Wed, 14 Jun 2023 00:09:06 -0700 (PDT)
Received: from localhost ([185.220.101.84])
        by smtp.gmail.com with ESMTPSA id rh15-20020a17090720ef00b00977d7bd9069sm7711888ejb.179.2023.06.14.00.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 00:09:05 -0700 (PDT)
Date: Wed, 14 Jun 2023 10:09:02 +0300
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
	rajur@chelsio.com, ayush.sawal@chelsio.com, dmichail@fungible.com,
	borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
	simon.horman@corigine.com, john.fastabend@gmail.com,
	anirudh.venkataramanan@intel.com, tariqt@nvidia.com, gal@nvidia.com,
	raeds@nvidia.com, liorna@nvidia.com, louis.peens@corigine.com,
	yinjun.zhang@corigine.com, na.wang@corigine.com,
	linux-rdma@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net-next] net: tls: make the offload check helper take
 skb not socket
Message-ID: <ZIlng6G_xP3V8O5E@mail.gmail.com>
References: <20230613205006.1995873-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613205006.1995873-1-kuba@kernel.org>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 13 Jun 2023 at 13:50:06 -0700, Jakub Kicinski wrote:
> All callers of tls_is_sk_tx_device_offloaded() currently do
> an equivalent of:
> 
>  if (skb->sk && tls_is_skb_tx_device_offloaded(skb->sk))
> 
> Have the helper accept skb and do the skb->sk check locally.
> Two drivers have local static inlines with similar wrappers
> already.
> 
> While at it change the ifdef condition to TLS_DEVICE.
> Only TLS_DEVICE selects SOCK_VALIDATE_XMIT, so the two are
> equivalent. This makes removing the duplicated IS_ENABLED()
> check in funeth more obviously correct.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>

Nice cleanup, thanks!

[...]

> diff --git a/include/net/tls.h b/include/net/tls.h
> index b7d0f1e3058b..5e71dd3df8ca 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -370,10 +370,12 @@ struct sk_buff *
>  tls_validate_xmit_skb_sw(struct sock *sk, struct net_device *dev,
>  			 struct sk_buff *skb);
>  
> -static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
> +static inline bool tls_is_skb_tx_device_offloaded(const struct sk_buff *skb)
>  {
> -#ifdef CONFIG_SOCK_VALIDATE_XMIT
> -	return sk_fullsock(sk) &&
> +#ifdef CONFIG_TLS_DEVICE
> +	struct sock *sk = skb->sk;
> +
> +	return sk && sk_fullsock(sk) &&
>  	       (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
>  	       &tls_validate_xmit_skb);
>  #else

After this change, the only usage of CONFIG_SOCK_VALIDATE_XMIT remains
in sk_validate_xmit_skb, which has #ifdef CONFIG_TLS_DEVICE inside
#ifdef CONFIG_SOCK_VALIDATE_XMIT. If feels a little bit weird, given
that both defines always have the same value, but maybe it's OK if we
consider that more users can start using sk_validate_xmit_skb in the
future.

