Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0A135D2C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbgAIPrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:47:16 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37426 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731177AbgAIPrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:47:16 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so7608499ioc.4
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 07:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=90BVnvN+InM0+64a8tsWf2Ocz4suvmN3B14zh4bqQLg=;
        b=o2ynFp8FYKuV0JiXrwErrGQatWvB9s8TQ1N1ZilzPtOaLxASvqsJuYHiPcuasAP+lf
         +K5dSfpRtOsJv1tV1SN3ZHe5Vczer7tFu33OU9PdVM4WRra/SguKnQgVjjTCcnhlAti6
         m5bsKl6CqhMYAkfp/+XRv239qDqILg/r4G8HOVzuyHj4HyevLdh4s5jkwGedh32jXWfr
         F7E1XLOuqZxCZEtKocysAl6bW5JUaQqeHXGtEsGYqR0GiVm+Z63th9rHd5HF3GC+qJi7
         JN8ptGP3+dVaknirq9nmbz5YXUWUuUk1R/x+iSAXk6D0/tQM/RR4t7ZbS/SzFu6EuDty
         tIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=90BVnvN+InM0+64a8tsWf2Ocz4suvmN3B14zh4bqQLg=;
        b=ZKTnD/tEQYoFSsQoUSiCfZxsWfBjlL8oe/olf4OHmoYjTTyLBtK+GMyyvXM5yEiytk
         zT44R4H6L+YtvxPBnu+M/dy3YOnR8d3F6FIlUzL4HYBo5aIQFKLawW17ALWLzX3/FDh/
         KQcbzRGu735FETRkcagcue+nCmZctn2ZhOhlLENd6b9kXY1VtTjbN8gb3fTqDEq2MhSy
         WKryVEQ43YjKziT6WIsZX+wte874RvBkv1u1HcuxyKxSx+Pd5Ws75pMM2f6WmtrBCxQX
         R9dHgNRsRRerUuXXchbe9YMHtuXUQDP+5nYQsebKxFtSXMDEUlNCtaShYHdZSL1WGYVF
         z1jQ==
X-Gm-Message-State: APjAAAVmtdz9ksV/3mw0En7z5hxHGTXOIYXquUrbQj1WIq0t9SPIH6o8
        YbetpNU6f7uYtZdImsQF7FJA0SErfqw=
X-Google-Smtp-Source: APXvYqzEt7a29LefUWWyO8Zh84uclb1GJF+ehRQ43t1/wAE9EEy6/YpYRTTDsCAVJgWxU6sYa/gArw==
X-Received: by 2002:a6b:6a02:: with SMTP id x2mr8040277iog.20.1578584835943;
        Thu, 09 Jan 2020 07:47:15 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:aca7:cb60:c47a:2485? ([2601:282:800:7a:aca7:cb60:c47a:2485])
        by smtp.googlemail.com with ESMTPSA id e65sm2147437ilg.2.2020.01.09.07.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:47:15 -0800 (PST)
Subject: Re: [PATCH net-next 03/10] ipv4: Add "offload" and "trap" indications
 to routes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20200107154517.239665-1-idosch@idosch.org>
 <20200107154517.239665-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <23c1daed-d770-a61b-2e89-8466de2afc70@gmail.com>
Date:   Thu, 9 Jan 2020 08:47:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107154517.239665-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 8:45 AM, Ido Schimmel wrote:
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 75af3f8ae50e..272c9f73e4b3 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1012,6 +1012,56 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
>  	return NULL;
>  }
>  
> +static struct fib_alias *
> +fib_find_matching_alias(struct net *net, u32 dst, int dst_len,
> +			const struct fib_info *fi, u8 tos, u8 type, u32 tb_id)
> +{
> +	u8 slen = KEYLENGTH - dst_len;
> +	struct key_vector *l, *tp;
> +	struct fib_table *tb;
> +	struct fib_alias *fa;
> +	struct trie *t;
> +
> +	tb = fib_get_table(net, tb_id);
> +	if (!tb)
> +		return NULL;
> +
> +	t = (struct trie *)tb->tb_data;
> +	l = fib_find_node(t, &tp, dst);
> +	if (!l)
> +		return NULL;
> +
> +	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
> +		if (fa->fa_slen == slen && fa->tb_id == tb_id &&
> +		    fa->fa_tos == tos && fa->fa_info == fi &&
> +		    fa->fa_type == type)
> +			return fa;
> +	}
> +
> +	return NULL;
> +}
> +
> +void fib_alias_hw_flags_set(struct net *net, u32 dst, int dst_len,
> +			    const struct fib_info *fi, u8 tos, u8 type,
> +			    u32 tb_id, bool offload, bool trap)

Seem like struct fib_rt_info from the previous patch be used here and
then passed to fib_find_matching_alias.


> +{
> +	struct fib_alias *fa_match;
> +
> +	rcu_read_lock();
> +
> +	fa_match = fib_find_matching_alias(net, dst, dst_len, fi, tos, type,
> +					   tb_id);
> +	if (!fa_match)
> +		goto out;
> +
> +	fa_match->offload = offload;
> +	fa_match->trap = trap;
> +
> +out:
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(fib_alias_hw_flags_set);
> +
>  static void trie_rebalance(struct trie *t, struct key_vector *tn)
>  {
>  	while (!IS_TRIE(tn))


