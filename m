Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B94A45F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfFROsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:48:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45823 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfFROsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:48:30 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so30337474ioc.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q5ApBu4QPdOtAmgHGPD4ltsKGVLTkeEt25fSM3QBmGw=;
        b=OQkT4pPwyfTbEyqcY7eK/XXGvwDUIkP8s3sYKZJoE7OG2IBhDDiDH9pksT/I3+i3No
         i7BBBs15Ywnux0wmTAzvvBanV1JWIwn2CJqT1b0asBgR2M3JyiXA4aLonTC0Ve+YqiYw
         Y/BSYchJJIhcTQgKpkb1r+nTH8iaokUlEonIEWFbZHuJXwu/Oj6i50BVlks/ZfVoEs6d
         aTtrkKzekq6zfQPF5mZA2CUeercSD0RRx7YdhVDrDrQ6xAs92j69TRmgiq7HEiBTQSBc
         TEb1Jx54QWJZ209pg5TsYaQlWWqs731/G/Wvr1kiVg4Ia0mKBYhuso5f98Cg8f+KOsJR
         2KxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5ApBu4QPdOtAmgHGPD4ltsKGVLTkeEt25fSM3QBmGw=;
        b=uRAL0yts8Oc9Ao9/y4S7VTMg/u+tE6mOyI/YDVi7VviB/dLQRacb+xAmOCb48f48tB
         3sDdHWpaj9x5zU5rrVOcvOCs2+AQp2E4MQAypR0vMoHxzXaImfVwpeNDtGwa8+g8GqVM
         5xL9hRWWt36MvlD2SUX4azpbWio1mbMZIMXFPgs817GQOKqVfTwKD78STp7dfYIOd8G3
         nINmz7raxEYxiEXLZLfrTFu+6/aYSUFZ6uK0iJ7PEV2lzbRKTIEX1fuDJIDb0rVhMeYR
         Z/ucPUvwpiV1QE4FUJBSJfgqRktvutKhivcA84JBQMSDq56Eo/kPNxJOelPRwa9VfOt8
         Fa+Q==
X-Gm-Message-State: APjAAAWY1sbDuJm+6bHdNF2zOOaBt3jUOafj+cNU6rhwRvVZPETh4f4l
        w2gcm1V5kx0KCLdBPkVpixNd0XWE
X-Google-Smtp-Source: APXvYqyZF1UH5hQWqBmTnnT5UDmQ435PCzG6QoQQ5qs9KxuOfUmek/XvtSnQHQ16t20E5XhSjRtLdA==
X-Received: by 2002:a5e:c705:: with SMTP id f5mr8854194iop.113.1560869309118;
        Tue, 18 Jun 2019 07:48:29 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id c10sm18091645ioh.58.2019.06.18.07.48.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:48:28 -0700 (PDT)
Subject: Re: [PATCH net v5 3/6] ipv4: Dump route exceptions if requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
 <106687f38b1eaf957f4ff2bad343519231815482.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b85db470-81c2-3abe-a68b-154711147656@gmail.com>
Date:   Tue, 18 Jun 2019 08:48:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <106687f38b1eaf957f4ff2bad343519231815482.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> diff --git a/include/net/route.h b/include/net/route.h
> index 065b47754f05..f0d0086e76ce 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -221,6 +221,9 @@ void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
>  struct rtable *rt_dst_alloc(struct net_device *dev,
>  			     unsigned int flags, u16 type,
>  			     bool nopolicy, bool noxfrm, bool will_cache);
> +int rt_fill_info(struct net *net, __be32 dst, __be32 src, struct rtable *rt,
> +		 u32 table_id, struct flowi4 *fl4, struct sk_buff *skb,
> +		 u32 portid, u32 seq);
>  
>  struct in_ifaddr;
>  void fib_add_ifaddr(struct in_ifaddr *);
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 868c74771fa9..a00408827ae8 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -2000,28 +2000,92 @@ void fib_free_table(struct fib_table *tb)
>  	call_rcu(&tb->rcu, __trie_free_rcu);
>  }
>  
> +static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
> +				   struct netlink_callback *cb,
> +				   int *fa_index, int fa_start)
> +{
> +	struct net *net = sock_net(cb->skb->sk);
> +	struct fib_info *fi = fa->fa_info;
> +	struct fnhe_hash_bucket *bucket;
> +	struct fib_nh_common *nhc;
> +	int i, genid;
> +
> +	if (!fi || fi->fib_flags & RTNH_F_DEAD)
> +		return 0;
> +
> +	nhc = fib_info_nhc(fi, 0);

This should be a loop over fi->fib_nhs for net:
	for (i = 0; i < fi->fib_nhs; i++) {
		nhc = fib_info_nhc(fi, 0);
		...

and a loop over fib_info_num_path(fi) for net-next:
	for (i = 0; i < fib_info_num_path(fi); i++) {
		nhc = fib_info_nhc(fi, 0);
		...


> +	if (nhc->nhc_flags & RTNH_F_DEAD)
> +		return 0;

And then the loop over the exception bucket could be a helper in route.c
in which case you don't need to export rt_fill_info and nhc_exceptions
code does not spread to fib_trie.c


> +
> +	bucket = rcu_dereference(nhc->nhc_exceptions);
> +	if (!bucket)
> +		return 0;
> +
> +	genid = fnhe_genid(net);
> +
> +	for (i = 0; i < FNHE_HASH_SIZE; i++) {
> +		struct fib_nh_exception *fnhe;
> +
> +		for (fnhe = rcu_dereference(bucket[i].chain); fnhe;
> +		     fnhe = rcu_dereference(fnhe->fnhe_next)) {
> +			struct flowi4 fl4 = {};

rather than pass an empty flow struct, update rt_fill_info to handle a
NULL fl4; it's only a few checks.

> +			struct rtable *rt;
> +			int err;
> +
> +			if (*fa_index < fa_start)
> +				goto next;
> +
> +			if (fnhe->fnhe_genid != genid)
> +				goto next;
> +
> +			if (fnhe->fnhe_expires &&
> +			    time_after(jiffies, fnhe->fnhe_expires))
> +				goto next;
> +
> +			rt = rcu_dereference(fnhe->fnhe_rth_input);
> +			if (!rt)
> +				rt = rcu_dereference(fnhe->fnhe_rth_output);
> +			if (!rt)
> +				goto next;
> +
> +			err = rt_fill_info(net, fnhe->fnhe_daddr, 0, rt,
> +					   fa->tb_id, &fl4, skb,
> +					   NETLINK_CB(cb->skb).portid,
> +					   cb->nlh->nlmsg_seq);
> +			if (err)
> +				return err;
> +next:
> +			(*fa_index)++;
> +		}
> +	}
> +
> +	return 0;
> +}
> +


