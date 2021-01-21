Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E391D2FEF3E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733237AbhAUPm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 10:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733008AbhAUPmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 10:42:18 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA38C061756;
        Thu, 21 Jan 2021 07:41:37 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id c128so1922320wme.2;
        Thu, 21 Jan 2021 07:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=klestWo2PrKy4XdpOkRsUnFJCmCxs6ZGgiiFSXp8mGQ=;
        b=mU4IBbICRoLVDsuNxMDJFuEkpp9tbf4k8j3PtFt2VR35nz4BZs3UaU90Fh+axknRnT
         L3Q+FwtIv/Ab+PfwyfcpGz1aUcYibXm+TtvpF4zmjQRQRQYbPa0eSmBz1CkVVR5fNkGf
         kmtxemTIos+nJNF1AIthX9pI6XV2Upa+r78jrQmvYfuI91V/561+7aHc7dVcA2L++5iC
         PM4pu7+lk++zVjq40dveVN6WgiLynkHhtrpUZClReXbfKX6LG2q0I+z/tfA72rFk8O3f
         /Wp3bthwzixQRmkKDOond1m422rCSb3KUxV2SeaDsHc5ZRcqPAkRwNeLYRjbUJE61I7J
         YFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=klestWo2PrKy4XdpOkRsUnFJCmCxs6ZGgiiFSXp8mGQ=;
        b=jNOhY8eP921dwu3aO6DDyAEa69akwYhPj3prOh6jcRvmfn1KDtN8kf4lG5PYwZp9LT
         c0yfZv+PK433Sv9PZ1Pz8Xjh+OHee7/TlgRXhNi+2B3/LYkhVwg2LMQ/k1jmMQUV3qs6
         Ec1c42vogD+YrAsrgx0W4QOh0qnFRrQyH+xr/bV2+yxkkZOsfLYqYcXooyMI43/cQtIG
         XdPr9hYYbRs8BmG2N93y9/omJ7XED5uwYqbcbWS6TpmaCPcJZWwJuk7S43VHBTaEYDUh
         TNU8UrjTEkQMrXJtplELce7gnQ7/qSTY8IdnzLn0U90PWo7a0U+4CwoQkBsLuJX86r+l
         luNA==
X-Gm-Message-State: AOAM530xqavxr66o/Fdv+WDnx2o+VoKbsQrVAhHg0Cd7It3FN0OxMt8e
        fQUZQo6/UfQQXi3PF/p49Lf2TdaYu4M=
X-Google-Smtp-Source: ABdhPJxP00z10/zywWz/crjSBdXq0t5+AHIDngQEQAu1TF/ApaslqqbKVD698mBRmijbupfBA3lWMQ==
X-Received: by 2002:a1c:e2d7:: with SMTP id z206mr7370319wmg.99.1611243696441;
        Thu, 21 Jan 2021 07:41:36 -0800 (PST)
Received: from [192.168.1.101] ([37.171.116.45])
        by smtp.gmail.com with ESMTPSA id h23sm8311369wmi.26.2021.01.21.07.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 07:41:35 -0800 (PST)
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
 <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dcee4592-9fa9-adbb-55ca-58a962076e7a@gmail.com>
Date:   Thu, 21 Jan 2021 16:41:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> This patch is used to construct skb based on page to save memory copy
> overhead.
> 
> This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> directly construct skb. If this feature is not supported, it is still
> necessary to copy data to construct skb.
> 
> ---------------- Performance Testing ------------
> 
> The test environment is Aliyun ECS server.
> Test cmd:
> ```
> xdpsock -i eth0 -t  -S -s <msg size>
> ```
> 
> Test result data:
> 
> size    64      512     1024    1500
> copy    1916747 1775988 1600203 1440054
> page    1974058 1953655 1945463 1904478
> percent 3.0%    10.0%   21.58%  32.3%
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 86 insertions(+), 18 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 4a83117..38af7f1 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  	sock_wfree(skb);
>  }
>  
> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> +					      struct xdp_desc *desc)
> +{
> +	u32 len, offset, copy, copied;
> +	struct sk_buff *skb;
> +	struct page *page;
> +	void *buffer;
> +	int err, i;
> +	u64 addr;
> +
> +	skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> +	if (unlikely(!skb))
> +		return ERR_PTR(err);
> +
> +	addr = desc->addr;
> +	len = desc->len;
> +
> +	buffer = xsk_buff_raw_get_data(xs->pool, addr);
> +	offset = offset_in_page(buffer);
> +	addr = buffer - xs->pool->addrs;
> +
> +	for (copied = 0, i = 0; copied < len; i++) {
> +		page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> +
> +		get_page(page);
> +
> +		copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> +
> +		skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +		copied += copy;
> +		addr += copy;
> +		offset = 0;
> +	}
> +
> +	skb->len += len;
> +	skb->data_len += len;

> +	skb->truesize += len;

This is not the truesize, unfortunately.

We need to account for the number of pages, not number of bytes.

> +
> +	refcount_add(len, &xs->sk.sk_wmem_alloc);
> +
> +	return skb;
> +}
> +


