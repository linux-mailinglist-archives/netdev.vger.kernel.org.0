Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D946365121E
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 19:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiLSSln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 13:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiLSSlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 13:41:40 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37939FC2
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 10:41:38 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k16-20020a635a50000000b0042986056df6so5897667pgm.2
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 10:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNYwUfFTuoAl5hIOKZfjRFYuwooe+ZnU5TXmMtVw1Vw=;
        b=PCE1gF+1xjOltBu41UU9JPCPlViAY0cp05OJvxQyQmPrpc7dNlHqmkq7q85iScUgvx
         59kbvpZ4IjfRtmma8ODffuMTsAdjF6mc9FKVnFuKmw3rIELY0aR224rULoZiXejfOyPf
         FqKdlLrrnzQ6/TCerumh1X/uvJfXZqds67yZn+AFQJl4989wHnRjAT2AzwxFsBTJNKfx
         cL6dAu+m1G6g1ck0y4oLro0/8KGrxIl8w+FuqOar5e0t0qvTFZly6zsHf3kBOU8TZs8R
         LLRlKdcxr8DoXqpBUn8ZIP3Srjfi+Eo3QZ34EJGob+nKn5A2MI7/q1aI8OxYh9LPoYPL
         oMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SNYwUfFTuoAl5hIOKZfjRFYuwooe+ZnU5TXmMtVw1Vw=;
        b=QD3S7ECk5kF7SSi1B7PpsDu3myZyr7vxVWsF0CAHE3EWUHTOvujOXmRpExWycB7aY1
         X46B3vgFhgMkhaH75A20X/DtyamZwYcq2ifWnLBSKSzPlGKneQIL6ySK8c6/Bi4ZrJQO
         jKTzGHueZnExACoqdIkpa5HtXmAsF7lXsbj6SPX1pC6mfGJwXxFK5sjrk1E3bFKbEpmK
         j5G0dPTOAkHcSTYEql5VmQnTsFVl33jWv60e3tYcBjAdvH7JDpE9f7TCoyRQrxOXfHfS
         Du/8Bryjnx+Lgies+3VG6Fg/wOvcX7pQGqguondLiiaeTJmdxdawjvHaLn9xRxrytX1t
         dz5A==
X-Gm-Message-State: ANoB5pnUnrm0F+464tSfgxfAb9j4PR69xGOEd8Seg5mk9hkhXbdAeBXT
        PH5nqw0ZJRgPOjcVALFPp8D1wW8=
X-Google-Smtp-Source: AA0mqf5TTar+nQv3C/Qqpl/Q/pwSxFitrhZd1MdtZyr+Jmy7ViVHZitW9mXzJszzBU8Xm9p1hKZoeEI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:74c3:b0:189:71ff:cfb5 with SMTP id
 f3-20020a17090274c300b0018971ffcfb5mr60929233plt.7.1671475298158; Mon, 19 Dec
 2022 10:41:38 -0800 (PST)
Date:   Mon, 19 Dec 2022 10:41:36 -0800
In-Reply-To: <20221218051734.31411-1-cehrig@cloudflare.com>
Mime-Version: 1.0
References: <20221218051734.31411-1-cehrig@cloudflare.com>
Message-ID: <Y6CwYK4xMTJv/R7u@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add flag BPF_F_NO_TUNNEL_KEY to bpf_skb_set_tunnel_key()
From:   sdf@google.com
To:     Christian Ehrig <cehrig@cloudflare.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Paul Chaignon <paul@isovalent.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18, Christian Ehrig wrote:
> This patch allows to remove TUNNEL_KEY from the tunnel flags bitmap
> when using bpf_skb_set_tunnel_key by providing a BPF_F_NO_TUNNEL_KEY
> flag. On egress, the resulting tunnel header will not contain a tunnel
> key if the protocol and implementation supports it.

> At the moment bpf_tunnel_key wants a user to specify a numeric tunnel
> key. This will wrap the inner packet into a tunnel header with the key
> bit and value set accordingly. This is problematic when using a tunnel
> protocol that supports optional tunnel keys and a receiving tunnel
> device that is not expecting packets with the key bit set. The receiver
> won't decapsulate and drop the packet.

> RFC 2890 and RFC 2784 GRE tunnels are examples where this flag is
> useful. It allows for generating packets, that can be decapsulated by
> a GRE tunnel device not operating in collect metadata mode or not
> expecting the key bit set.

> Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>   include/uapi/linux/bpf.h       | 4 ++++
>   net/core/filter.c              | 5 ++++-
>   tools/include/uapi/linux/bpf.h | 4 ++++
>   3 files changed, 12 insertions(+), 1 deletion(-)

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 464ca3f01fe7..bc1a3d232ae4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2001,6 +2001,9 @@ union bpf_attr {
>    * 			sending the packet. This flag was added for GRE
>    * 			encapsulation, but might be used with other protocols
>    * 			as well in the future.
> + * 		**BPF_F_NO_TUNNEL_KEY**
> + * 			Add a flag to tunnel metadata indicating that no tunnel
> + * 			key should be set in the resulting tunnel header.
>    *
>    * 		Here is a typical usage on the transmit path:
>    *
> @@ -5764,6 +5767,7 @@ enum {
>   	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
>   	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
>   	BPF_F_SEQ_NUMBER		= (1ULL << 3),
> +	BPF_F_NO_TUNNEL_KEY		= (1ULL << 4),
>   };

>   /* BPF_FUNC_skb_get_tunnel_key flags. */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 929358677183..c746e4d77214 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4615,7 +4615,8 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff  
> *, skb,
>   	struct ip_tunnel_info *info;

>   	if (unlikely(flags & ~(BPF_F_TUNINFO_IPV6 | BPF_F_ZERO_CSUM_TX |
> -			       BPF_F_DONT_FRAGMENT | BPF_F_SEQ_NUMBER)))
> +			       BPF_F_DONT_FRAGMENT | BPF_F_SEQ_NUMBER |
> +			       BPF_F_NO_TUNNEL_KEY)))
>   		return -EINVAL;
>   	if (unlikely(size != sizeof(struct bpf_tunnel_key))) {
>   		switch (size) {
> @@ -4653,6 +4654,8 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff  
> *, skb,
>   		info->key.tun_flags &= ~TUNNEL_CSUM;
>   	if (flags & BPF_F_SEQ_NUMBER)
>   		info->key.tun_flags |= TUNNEL_SEQ;
> +	if (flags & BPF_F_NO_TUNNEL_KEY)
> +		info->key.tun_flags &= ~TUNNEL_KEY;

>   	info->key.tun_id = cpu_to_be64(from->tunnel_id);
>   	info->key.tos = from->tunnel_tos;
> diff --git a/tools/include/uapi/linux/bpf.h  
> b/tools/include/uapi/linux/bpf.h
> index 464ca3f01fe7..bc1a3d232ae4 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2001,6 +2001,9 @@ union bpf_attr {
>    * 			sending the packet. This flag was added for GRE
>    * 			encapsulation, but might be used with other protocols
>    * 			as well in the future.
> + * 		**BPF_F_NO_TUNNEL_KEY**
> + * 			Add a flag to tunnel metadata indicating that no tunnel
> + * 			key should be set in the resulting tunnel header.
>    *
>    * 		Here is a typical usage on the transmit path:
>    *
> @@ -5764,6 +5767,7 @@ enum {
>   	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
>   	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
>   	BPF_F_SEQ_NUMBER		= (1ULL << 3),
> +	BPF_F_NO_TUNNEL_KEY		= (1ULL << 4),
>   };

>   /* BPF_FUNC_skb_get_tunnel_key flags. */
> --
> 2.37.4

