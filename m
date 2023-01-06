Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD1660779
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbjAFT4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbjAFTz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:55:58 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB59C81D72
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 11:55:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y8-20020a170902b48800b00192a600df83so1819197plr.15
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 11:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mIPfW8itmy1nSGwQkVM3Is8GI7aiE3cD3klmvrspZs0=;
        b=gK3Rq0cvWTBHU4Zc/89GDyZmL/Xomq02yNExaES11bqv8Qq6JyQxyps2qm2tOQvOhp
         MbEEjC8t5aDfiWotmAxiEYDOrCrfryogB9kDZ8HBnvDDnv+wLO0I3D50hZDVOnxRh0QL
         KS0HCMkKuEwWmya6zPvpdkxXifclPDqjLFRVBR4+682IgC1pb2cdNqHshG3XiYX8+yQo
         /V8SUEOJm4t9FvsszVrJ0b+YhuIuFulrrZjiVP1oJAYuOOWeLl2PXrTjfIPNvoFkQryH
         /006iPK9TwLv4N5LGWPGQQSUzR6LlwzsNfUBS0Cq5LUlHdgT0xYxpGOyYrdCM+Pzt5o1
         9whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIPfW8itmy1nSGwQkVM3Is8GI7aiE3cD3klmvrspZs0=;
        b=8PTYU0d1GzlgV7baKM6e8xzvaVMRbAI1XpXneY+e5QePHFzSNpvOwGzRV/hIVIBHcM
         f7fWZWvReprlHdEK9BK2xbwP2SmBXDBncj7kZKmod9gTKUylGuPgKWwVGngs+RkHQ98O
         2FBcdKdmFRrkm0koz7h8GELDRbitWSxuwSZqI961UfQ5bXbfMpmMeIX7AIaWG2z8yN2M
         1YZTRHdwA3jYDcl61EOZl84WqDbkh/Pg+MCK/239PL4TKGrJByyyG8U0M/bCFfGUpZH2
         TQHDXa797jogfsHOcVOirWiUFrBda+pgrcw2nvo3Dm/c8Ya48RRAAZ7Zi8TGYQf5lRZj
         qaSQ==
X-Gm-Message-State: AFqh2koUnd7iAhVWxmZxfBnwivPDROQIBjj5skASIT2tb1ssQJDRk9yr
        EtIy0nZY7tG4WebKEYHxL1uyZgQ=
X-Google-Smtp-Source: AMrXdXvyR146I6BbPaAgJWkImFp33rAI/P5iLiFaYEMqoHm7uOIZBP467ozGpC8WQiBzBaYOkhw75fQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:6502:0:b0:577:d52e:b585 with SMTP id
 z2-20020a626502000000b00577d52eb585mr3905945pfb.57.1673034956425; Fri, 06 Jan
 2023 11:55:56 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:55:54 -0800
In-Reply-To: <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
Mime-Version: 1.0
References: <cover.1672976410.git.william.xuanziyang@huawei.com> <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
Message-ID: <Y7h8yrOEkPuHkNpJ@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
From:   sdf@google.com
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, willemb@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06, Ziyang Xuan wrote:
> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
> Main use case is for using cls_bpf on ingress hook to decapsulate
> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.

CC'd Willem since he has done bpf_skb_adjust_room changes in the past.
There might be a lot of GRO/GSO context I'm missing.

> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>   net/core/filter.c | 34 ++++++++++++++++++++++++++++++++--
>   1 file changed, 32 insertions(+), 2 deletions(-)

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 929358677183..73982fb4fe2e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3495,6 +3495,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb,  
> u32 off, u32 len_diff,
>   static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>   			      u64 flags)
>   {
> +	union {
> +		struct iphdr *v4;
> +		struct ipv6hdr *v6;
> +		unsigned char *hdr;
> +	} ip;
> +	__be16 proto;
>   	int ret;

>   	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
> @@ -3512,10 +3518,19 @@ static int bpf_skb_net_shrink(struct sk_buff  
> *skb, u32 off, u32 len_diff,
>   	if (unlikely(ret < 0))
>   		return ret;

> +	ip.hdr = skb_inner_network_header(skb);
> +	if (ip.v4->version == 4)
> +		proto = htons(ETH_P_IP);
> +	else
> +		proto = htons(ETH_P_IPV6);
> +
>   	ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
>   	if (unlikely(ret < 0))
>   		return ret;

> +	/* Match skb->protocol to new outer l3 protocol */
> +	skb->protocol = proto;
> +
>   	if (skb_is_gso(skb)) {
>   		struct skb_shared_info *shinfo = skb_shinfo(skb);

> @@ -3578,10 +3593,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,  
> skb, s32, len_diff,
>   	   u32, mode, u64, flags)
>   {
>   	u32 len_cur, len_diff_abs = abs(len_diff);
> -	u32 len_min = bpf_skb_net_base_len(skb);
> -	u32 len_max = BPF_SKB_MAX_LEN;
> +	u32 len_min, len_max = BPF_SKB_MAX_LEN;
>   	__be16 proto = skb->protocol;
>   	bool shrink = len_diff < 0;
> +	union {
> +		struct iphdr *v4;
> +		struct ipv6hdr *v6;
> +		unsigned char *hdr;
> +	} ip;
>   	u32 off;
>   	int ret;

> @@ -3594,6 +3613,9 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,  
> skb, s32, len_diff,
>   		     proto != htons(ETH_P_IPV6)))
>   		return -ENOTSUPP;

> +	if (unlikely(shrink && !skb->encapsulation))
> +		return -ENOTSUPP;
> +
>   	off = skb_mac_header_len(skb);
>   	switch (mode) {
>   	case BPF_ADJ_ROOM_NET:
> @@ -3605,6 +3627,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,  
> skb, s32, len_diff,
>   		return -ENOTSUPP;
>   	}

> +	if (shrink) {
> +		ip.hdr = skb_inner_network_header(skb);
> +		if (ip.v4->version == 4)
> +			len_min = sizeof(struct iphdr);
> +		else
> +			len_min = sizeof(struct ipv6hdr);
> +	}
> +
>   	len_cur = skb->len - skb_network_offset(skb);
>   	if ((shrink && (len_diff_abs >= len_cur ||
>   			len_cur - len_diff_abs < len_min)) ||
> --
> 2.25.1

