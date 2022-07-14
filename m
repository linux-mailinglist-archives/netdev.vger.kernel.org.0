Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E3D5747C8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbiGNJIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiGNJIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:08:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59288BC3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657789713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhoR2c2F66vIfN0BMmScdzEC1Hh+n4DXeB74Xk6woyY=;
        b=HZa9SCNjco1oYwGTv3bdk3HmfGJAVutxZDUAhzXMwvrYoMn9MmJOl48g2W1mKDmYqKKIdn
        qPO7kejAmwquzFqaF19Q42YKkAzDFNCNGZlxyBvSDp3CPiujhx9IfBdRb6Af4+sQDi63KR
        QsMCsLaX3LMaI/RL9CO9AHu/Bg5+lXo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-AkPh8iWRMJefy1Ga4ll_3w-1; Thu, 14 Jul 2022 05:08:32 -0400
X-MC-Unique: AkPh8iWRMJefy1Ga4ll_3w-1
Received: by mail-wm1-f70.google.com with SMTP id m20-20020a05600c4f5400b003a03aad6bdfso375807wmq.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vhoR2c2F66vIfN0BMmScdzEC1Hh+n4DXeB74Xk6woyY=;
        b=ipQAqR44sQsDPyS30q4Hk/LDFTTuCnMhg15LMCYMd/YPyAB2wlL+rNVxbeMp2oTfEa
         wdtcyt7+1+N+SMuWyHiQJnPqGvSbOwBlonmDM9VTj20W2pt7qEQiknCAewYtzmxj3IvX
         bT483cdeqFcJVDrnyNsJjIoKN/XUlfAeq22dun1Q4jqr4qmJEApDH47cU+z+wX3+KyaH
         Vuhb2vpKzJCTYj8kXsRGiF54S8MAya1siyJr3iSq5eZuAoti03H+ZIEd/KTk0cLYcNdi
         gs6BGvvQtJCvFPqzZf8TllZBprpsCQKBEJRb5ocBuWYksTN48f81LJDSeqLg2R1aWj/x
         wvCQ==
X-Gm-Message-State: AJIora+rZt8Y7j6e5VuSF/X/WRqH+LerGAbiO/lLkVThtFnjvkE1H8mI
        ren5klbI1FVTA4z+yBA7JI4uH47A1GQLBFgLovjPcn4j3jrQxrm2ptsXNSMZvLg00aDzKx/++Dz
        Wb07+t3ioXswQA987
X-Received: by 2002:a5d:4145:0:b0:21d:68ab:3bf with SMTP id c5-20020a5d4145000000b0021d68ab03bfmr7210250wrq.641.1657789710868;
        Thu, 14 Jul 2022 02:08:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tiLqD1Odk8IcLsFFg4YJDp3Doh2g6ZxQUdzjZoTORdLMIOMPUHGdvD+evdB/LIrDB618h0SQ==
X-Received: by 2002:a5d:4145:0:b0:21d:68ab:3bf with SMTP id c5-20020a5d4145000000b0021d68ab03bfmr7210227wrq.641.1657789710634;
        Thu, 14 Jul 2022 02:08:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id e9-20020adfef09000000b0021b89f8662esm974426wro.13.2022.07.14.02.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:08:30 -0700 (PDT)
Message-ID: <2a43287c8ec57119b9dcab46bd6fe7317b9f1f69.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] net: Add a bhash2 table hashed by port
 + address
From:   Paolo Abeni <pabeni@redhat.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net
Date:   Thu, 14 Jul 2022 11:08:29 +0200
In-Reply-To: <20220712235310.1935121-2-joannelkoong@gmail.com>
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
         <20220712235310.1935121-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> @@ -238,12 +331,23 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
>  			continue;
>  		head = &hinfo->bhash[inet_bhashfn(net, port,
>  						  hinfo->bhash_size)];
> +		head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> +
>  		spin_lock_bh(&head->lock);
> +
> +		if (inet_use_bhash2_on_bind(sk)) {
> +			if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, relax, false))
> +				goto next_port;
> +		}
> +
> +		spin_lock(&head2->lock);

Minor nit: it looks like you can compute hash2 but not use it if the
inet_bhash2_addr_any_conflict() call above is unsuccesful. You can move
the inet_bhashfn_portaddr() down. 


[...]

> @@ -675,6 +785,112 @@ void inet_unhash(struct sock *sk)
>  }
>  EXPORT_SYMBOL_GPL(inet_unhash);
>  
> +static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
> +				    const struct net *net, unsigned short port,
> +				    int l3mdev, const struct sock *sk)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (sk->sk_family == AF_INET6)
> +		return net_eq(ib2_net(tb), net) && tb->port == port &&
> +			tb->l3mdev == l3mdev &&
> +			ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
> +	else
> +#endif
> +		return net_eq(ib2_net(tb), net) && tb->port == port &&
> +			tb->l3mdev == l3mdev && tb->rcv_saddr == sk->sk_rcv_saddr;
> +}
> +
> +bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const struct net *net,
> +				      unsigned short port, int l3mdev, const struct sock *sk)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	struct in6_addr addr_any = {};
> +
> +	if (sk->sk_family == AF_INET6)
> +		return net_eq(ib2_net(tb), net) && tb->port == port &&
> +			tb->l3mdev == l3mdev &&
> +			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +	else
> +#endif
> +		return net_eq(ib2_net(tb), net) && tb->port == port &&
> +			tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
> +}
> +
> +/* The socket's bhash2 hashbucket spinlock must be held when this is called */
> +struct inet_bind2_bucket *
> +inet_bind2_bucket_find(const struct inet_bind_hashbucket *head, const struct net *net,
> +		       unsigned short port, int l3mdev, const struct sock *sk)
> +{
> +	struct inet_bind2_bucket *bhash2 = NULL;
> +
> +	inet_bind_bucket_for_each(bhash2, &head->chain)
> +		if (inet_bind2_bucket_match(bhash2, net, port, l3mdev, sk))
> +			break;
> +
> +	return bhash2;
> +}
> +
> +struct inet_bind_hashbucket *
> +inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port)
> +{
> +	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> +	u32 hash;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	struct in6_addr addr_any = {};
> +
> +	if (sk->sk_family == AF_INET6)
> +		hash = ipv6_portaddr_hash(net, &addr_any, port);
> +	else
> +#endif
> +		hash = ipv4_portaddr_hash(net, 0, port);
> +
> +	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> +}
> +
> +int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
> +{
> +	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> +	struct inet_bind_hashbucket *head, *head2;
> +	struct inet_bind2_bucket *tb2, *new_tb2;
> +	int l3mdev = inet_sk_bound_l3mdev(sk);
> +	int port = inet_sk(sk)->inet_num;
> +	struct net *net = sock_net(sk);
> +
> +	/* Allocate a bind2 bucket ahead of time to avoid permanently putting
> +	 * the bhash2 table in an inconsistent state if a new tb2 bucket
> +	 * allocation fails.
> +	 */
> +	new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
> +	if (!new_tb2)
> +		return -ENOMEM;
> +
> +	head = &hinfo->bhash[inet_bhashfn(net, port,
> +					  hinfo->bhash_size)];

Here 'head' is unused, you can avoid computing the related hash.


Cheers,

Paolo

