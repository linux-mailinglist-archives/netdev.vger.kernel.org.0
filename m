Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E02F95A8
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 22:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbhAQV41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 16:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbhAQV4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 16:56:25 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50836C061573;
        Sun, 17 Jan 2021 13:55:44 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q1so29225994ion.8;
        Sun, 17 Jan 2021 13:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ctvjXGdaXDC97qx0Qw/h1S7m6/ENUO8dsG8lsqvyMR0=;
        b=Zn/utZQ2LyIY5hM+pKdrZ/so6TF+Ir1ZPEUjcGAhnl0ygr7GqTWHs96fxf2oQkhbT/
         L5UHoSiHCvvSjMhcAIOGfFUiT2Tx5bMDSVEBR8/nANpjAya2/g3K4wcAYytV3HA/lMek
         yc5dWAD+O/VbXmCL2X89HjaAPS2ZgTttceh+e765INTJHXEbLVP/mhYfIsToArB0n9WF
         GgMLKXZCbcP3Z7v7/j10+SNgIvyjixn4lYcWAZFy/nrZzg98zVZJGcT7seB8JTwdGLm6
         44tXgaP65moG4R339HpOwq2xUmckg5pH0dCabNMi7NCZ86s/uU6Qh0b1QJhMQorGWnOe
         tciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ctvjXGdaXDC97qx0Qw/h1S7m6/ENUO8dsG8lsqvyMR0=;
        b=UKdTvZ5BikBrVpywyfcP/WTWDwMrKjIbF90pN0b4g2a96Pt0IhTRdkLGuvgh6GcqI3
         8Ya3uRakIGa3cXm4r4v/bDwHNaeWXvvhHVVW2U0OUCDBd+KLDG5emaR8Su70/tOztsXD
         gZMtCIfhH/hafTzCjccx/b6B64uC8jhv4L2y4XxtcGHR9Az/8mPbn8PYFs9mrzu7IUjw
         5FvWi/a34O1bRbBbd5QJo+PYkk94ycsabsfL5JoUDd7WEWNx+FqsOSIfNsQpoB7169oN
         P2DMo8nIzT9H1O+2vKVqlafMh0nLWMDvTmnYrHpRxidEcI4TEoxwzMvvDpF60t/yT9j3
         ASJw==
X-Gm-Message-State: AOAM531SIhlyMu0J+qKnlutMdmyoch15fh33xqhYAyyWjQzOE6BiTgJu
        xIawKF2//8GwKIucOSMxAW8=
X-Google-Smtp-Source: ABdhPJziosWOSWluRVKVQr/5EZMKm/WaIh6/0ez4lejrg2hLALeDDiyMzCvCUiGtxvOxP2dfLX5GrA==
X-Received: by 2002:a05:6e02:934:: with SMTP id o20mr4457175ilt.211.1610920542130;
        Sun, 17 Jan 2021 13:55:42 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id p126sm2880937iof.55.2021.01.17.13.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:55:41 -0800 (PST)
Date:   Sun, 17 Jan 2021 13:55:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Meir Lichtinger <meirl@mellanox.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Message-ID: <6004b254ce7_2664208d0@john-XPS-13-9370.notmuch>
In-Reply-To: <579fa463bba42ac71591540a1811dca41d725350.1610764948.git.xuanzhuo@linux.alibaba.com>
References: <579fa463bba42ac71591540a1811dca41d725350.1610764948.git.xuanzhuo@linux.alibaba.com>
Subject: RE: [PATCH bpf-next] xsk: build skb by page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo wrote:
> This patch is used to construct skb based on page to save memory copy
> overhead.
> 
> This has one problem:
> 
> We construct the skb by fill the data page as a frag into the skb. In
> this way, the linear space is empty, and the header information is also
> in the frag, not in the linear space, which is not allowed for some
> network cards. For example, Mellanox Technologies MT27710 Family
> [ConnectX-4 Lx] will get the following error message:
> 
>     mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
>     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
>     WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
>     00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
>     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> 
> I also tried to use build_skb to construct skb, but because of the
> existence of skb_shinfo, it must be behind the linear space, so this
> method is not working. We can't put skb_shinfo on desc->addr, it will be
> exposed to users, this is not safe.
> 
> Finally, I added a feature NETIF_F_SKB_NO_LINEAR to identify whether the
> network card supports the header information of the packet in the frag
> and not in the linear space.
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

Looks like a good perf bump. Some easy suggestions below

> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> +				     struct xdp_desc *desc, int *err)
> +{

Passing a 'int *err' here is ugly IMO use the ERR_PTR/PTR_ERR macros
and roll it into the return value.

or maybe use the out: pattern used in the kernel, but just doing direct
returns like now but with ERR_PTR() would also be fine.

> +	struct sk_buff *skb ;
        struct sk_buff *skb = NULL;
        err = -ENOMEM;
> +
> +	if (xs->dev->features & NETIF_F_SKB_NO_LINEAR) {
> +		skb = xsk_build_skb_zerocopy(xs, desc);
> +		if (unlikely(!skb)) {
			goto out

> +			*err = -ENOMEM;
> +			return NULL;
> +		}
> +	} else {
> +		char *buffer;
> +		u64 addr;
> +		u32 len;
> +		int err;
> +
> +		len = desc->len;
> +		skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
> +		if (unlikely(!skb)) {
			goto out;
> +			*err = -ENOMEM;
> +			return NULL;
> +		}
> +
> +		skb_put(skb, len);
> +		addr = desc->addr;
> +		buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
> +		err = skb_store_bits(skb, 0, buffer, len);
> +
> +		if (unlikely(err)) {
> +			kfree_skb(skb);

			err = -EINVAL;
			goto out

> +			*err = -EINVAL;
> +			return NULL;
> +		}
> +	}
> +
> +	skb->dev = xs->dev;
> +	skb->priority = xs->sk.sk_priority;
> +	skb->mark = xs->sk.sk_mark;
> +	skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
> +	skb->destructor = xsk_destruct_skb;
> +
> +	return skb;

out:
	kfree_skb(skb)
	return ERR_PTR(err);

> +}
> +

Otherwise looks good thanks.
