Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3738B2816B8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgJBPgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:36:39 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA8C0613D0;
        Fri,  2 Oct 2020 08:36:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y20so1897892iod.5;
        Fri, 02 Oct 2020 08:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ImpmaMEjXxTe6mBHL3no+s+EAw9gOhH9Z6rdXlHmk94=;
        b=C6YJo93GlqNig88Mq3XCN4PgaS+CZtoyuD4NXWDNsi4dt8VqabaEru6PvEkESxVhfz
         drbcsW66E4OL+sU7h9aBT64mWLWoBUxyYRDuB/L6mlIx6QN5YTq4Z7Xn5ziFjxqnmfnn
         A7ZLkm0c0NNPnwJeGokhkveUFCUpIVEk9ywInsU8jFZhsvOeMb3vjcCHgFtpZaLS6Zaq
         Mtos8RcLw8yBSaVZ8FAAbOs7hXk7BWKuMWsBLiCk+xIeKwx/FzJA7ylhdxqq01CGLTkd
         +tqBQ8KhlcZrDOJgcOFqetgjIcrFNp7hmr7vcZ4gae3qYbDdSIZRVTJM7orr4tDO4qPo
         2EHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ImpmaMEjXxTe6mBHL3no+s+EAw9gOhH9Z6rdXlHmk94=;
        b=hGnmGeQ9SV8RZmQLmuoRoo6TitR3hLq8IndDi2A5meGM8Sw4KJwX9ZnBVjDrGf4+YM
         fz+1kHxYXMG8zM4tPO0DDx1CRzf/RcjS1r9MprxV5TgcyT3eLNyNHJ8vtuUpbZ/QHerY
         nPOMnNZxvTugfZ/uz8JjnDZEvojLNLX4KzAhgUMrkQxqVjXGkq7OSfP3FPDp8Z9HMrb4
         aFCYy4JaCU+vt4Bh7FZz/VfocfTHBqZDMHg+gPFSLUIWawb8UIu6hpcS23o3VwDZvTMM
         zoGr3kM8HpQgnqbRbBRPy2crF/YgnLyVGirQ3+zYD90XUpSQKQ7SO8B3ytajRzO/4Vq4
         q5xg==
X-Gm-Message-State: AOAM532fj5D0tA4QRIpiClEtMdd9GaTR6myKGidTi9V026u8SY/H38MG
        +q63C+dvsZY41ez7w/fRAG8=
X-Google-Smtp-Source: ABdhPJzBX0h6AhqGSsUkDdz/yWGFuFtdmne76Kd90T1yZfVoy8NjzlwetQdQBpCZZ+s8Zzo31YMqag==
X-Received: by 2002:a5d:9813:: with SMTP id a19mr2462422iol.194.1601652997283;
        Fri, 02 Oct 2020 08:36:37 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d7sm924684ilr.31.2020.10.02.08.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 08:36:36 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:36:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Message-ID: <5f7748fc80bd9_38b02081@john-XPS-13-9370.notmuch>
In-Reply-To: <deb81e4cf02db9a1da2b4088a49afd7acf8b82b6.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <deb81e4cf02db9a1da2b4088a49afd7acf8b82b6.1601648734.git.lorenzo@kernel.org>
Subject: RE: [PATCH v4 bpf-next 06/13] bpf: introduce
 bpf_xdp_get_frags_{count, total_size} helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> Introduce the two following bpf helpers in order to provide some
> metadata about a xdp multi-buff fame to bpf layer:
> 
> - bpf_xdp_get_frags_count()
>   get the number of fragments for a given xdp multi-buffer.

Same comment as in the cover letter can you provide a use case
for how/where I would use xdp_get_frags_count()? Is it just for
debug? If its just debug do we really want a uapi helper for it.

> 
> * bpf_xdp_get_frags_total_size()
>   get the total size of fragments for a given xdp multi-buffer.

This is awkward IMO. If total size is needed it should return total size
in all cases not just in the mb case otherwise programs will have two
paths the mb path and the non-mb path. And if you have mixed workload
the branch predictor will miss? Plus its extra instructions to load.

And if its useful for something beyond just debug and its going to be
read every packet or something I think we should put it in the metadata
so that its not hidden behind a helper which likely will show up as
overhead on a 40+gbps nic. The use case I have in mind is counting
bytes maybe sliced by IP or protocol. Here you will always read it
and I don't want code with a if/else stuck in the middle when if
we do it right we have a single read.

> 
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 14 ++++++++++++
>  net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 ++++++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4f556cfcbfbe..0715995eb18c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3668,6 +3668,18 @@ union bpf_attr {
>   * 	Return
>   * 		The helper returns **TC_ACT_REDIRECT** on success or
>   * 		**TC_ACT_SHOT** on error.
> + *
> + * int bpf_xdp_get_frags_count(struct xdp_buff *xdp_md)
> + *	Description
> + *		Get the number of fragments for a given xdp multi-buffer.
> + *	Return
> + *		The number of fragments
> + *
> + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> + *	Description
> + *		Get the total size of fragments for a given xdp multi-buffer.

Why just fragments? Will I have to also add the initial frag0 to it
or not. I think the description is a bit ambiguous.

> + *	Return
> + *		The total size of fragments for a given xdp multi-buffer.
>   */

[...]

> +const struct bpf_func_proto bpf_xdp_get_frags_count_proto = {
> +	.func		= bpf_xdp_get_frags_count,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +};
> +
> +BPF_CALL_1(bpf_xdp_get_frags_total_size, struct  xdp_buff*, xdp)
> +{
> +	struct skb_shared_info *sinfo;
> +	int nfrags, i, size = 0;
> +
> +	if (likely(!xdp->mb))
> +		return 0;
> +
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +	nfrags = min_t(u8, sinfo->nr_frags, MAX_SKB_FRAGS);
> +
> +	for (i = 0; i < nfrags; i++)
> +		size += skb_frag_size(&sinfo->frags[i]);

Wont the hardware just know this? I think walking the frag list
just to get the total seems wrong. The hardware should have a
total_len field somewhere we can just read no? If mvneta doesn't
know the total length that seems like a driver limitation and we
shouldn't encode it in the helper.

> +
> +	return size;
> +}
