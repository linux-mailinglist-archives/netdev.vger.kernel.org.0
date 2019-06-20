Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924E54CEB1
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfFTNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:31:36 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45906 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfFTNbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:31:35 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so5726870ioc.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fag5wbxXspdvI0E/nq/PzUvz4eKC1B2Ly1U/ljGAEug=;
        b=RL7cBiizm2jE2H1gAGkZciGVxLExxyS2QyVwVnssdWH2YKZKeaaxDSIGIXUgyHDXD1
         Q5wK851v34hTtcqWAfGxWBq/HmADC71FF1EvJxNNPCGZqHHijnC1/cbEHx0di+q2jnGP
         qIp/aIGAZ3OOmQlkaYfsqLKy3CIBw+eZfTSNFwaCLGWITC97D2sPn8YoR6COc3gJx9JY
         N34UWTISLz2BKpDjZq7txC42xLB25lT6V3ZjTUjP1UPgA/MlUhZJsPZSgQXabbdsrSPK
         Ix9E2uJO8k9r3erGRmlS82VGmgr7dUbMEMpfevNfuLwKht+oYFva58iom4yfF2MVCpWw
         woAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fag5wbxXspdvI0E/nq/PzUvz4eKC1B2Ly1U/ljGAEug=;
        b=qY7vHsdzVWDcJdK4j9bcZZDXRV9+v/8zSlHytsxQw3qMBnHuznQ1QqgaLT/YeGzXcN
         rG5Ty9f2KgJ2cPKCTt7VJe64Nvx9JkERlGud2CBjOR9q9nZZhZYIpNWvDTcModo1BaR4
         1M4MS1fFR+TFN1EnVBL6ojwlncrcAOYibPC9DFO14423FL8OmdK/SlYsI75Q7vme55xI
         ZArfNHxkZmkU/oIXXRXywx6EGoaPvvyZ+G3q76PDY4xeJnwUwt0S/q5jsZKnk8HHxcJq
         tETLacfA3lwtsJ0gbUzA+myJi4mfQKLgQ19wJaaAzOBGO4e1XHClXJmSWKljL4t8q8CX
         oSrQ==
X-Gm-Message-State: APjAAAVJZ4X/nZfISzYZ3lf4yrSqe1estY4Q3GhcGAswNy/F9bG6d0BK
        zu1oOu9nEFoYXYxTpSqNXwzK46Fk
X-Google-Smtp-Source: APXvYqzuzwwxJaIpnK8Gu3aJ5e3tfvg5jo91EyHDUoTjdk2nbFFdltTGcbB1+PvPyKA3aeW5lOqrvA==
X-Received: by 2002:a6b:e20a:: with SMTP id z10mr19172121ioc.76.1561037494886;
        Thu, 20 Jun 2019 06:31:34 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id y20sm17454678ion.77.2019.06.20.06.31.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:31:34 -0700 (PDT)
Subject: Re: [PATCH net-next v6 04/11] ipv4: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <b5aacd9a3a3f4b256dfd091cdd8771d0f6a1aea2.1560987611.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <777387d8-fa15-388e-875a-02aa5df977dd@gmail.com>
Date:   Thu, 20 Jun 2019 07:31:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b5aacd9a3a3f4b256dfd091cdd8771d0f6a1aea2.1560987611.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 5:59 PM, Stefano Brivio wrote:
> diff --git a/include/net/route.h b/include/net/route.h
> index 065b47754f05..e7f65388a6d4 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -44,6 +44,7 @@
>  #define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
>  
>  struct fib_nh;
> +struct fib_alias;
>  struct fib_info;
>  struct uncached_list;
>  struct rtable {

we should not expose fib_alias to route.c.

> @@ -230,6 +231,9 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, u32 new_metric);
>  void rt_add_uncached_list(struct rtable *rt);
>  void rt_del_uncached_list(struct rtable *rt);
>  
> +int fnhe_dump_buckets(struct fib_alias *fa, int nhsel, struct sk_buff *skb,
> +		      struct netlink_callback *cb, int *fa_index, int fa_start);
> +
>  static inline void ip_rt_put(struct rtable *rt)
>  {
>  	/* dst_release() accepts a NULL parameter.
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 94e5d83db4db..03f51e5192e5 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -2078,28 +2078,51 @@ void fib_free_table(struct fib_table *tb)
>  	call_rcu(&tb->rcu, __trie_free_rcu);
>  }
>  
> +static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
> +				   struct netlink_callback *cb,
> +				   int *fa_index, int fa_start)
> +{
> +	struct fib_info *fi = fa->fa_info;
> +	int nhsel;
> +
> +	if (!fi || fi->fib_flags & RTNH_F_DEAD)
> +		return 0;
> +
> +	for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
> +		int err;
> +
> +		err = fnhe_dump_buckets(fa, nhsel, skb, cb, fa_index, fa_start);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}

fib_info would be the better argument to pass in to the fnhe dump, and
I think the loop over where the bucket is should be in route.c as well.
So how about fib_info_dump_fnhe() as the helper exposed from route.c,
and it does the loop over nexthops and calls fnhe_dump_buckets.

As for the loop, you could fill an skb without finishing a bucket inside
of a nexthop so you need top track which nexthop is current as well.

