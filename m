Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750234BF25B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiBVHEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:04:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiBVHEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:04:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7E113D82;
        Mon, 21 Feb 2022 23:04:08 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 4so6193613pll.6;
        Mon, 21 Feb 2022 23:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WkP07DKCbnwQE6/X/KtSc8NN0wE1LkkRJITLBD5bT90=;
        b=Cgx51X5dhq03DBMkBAJBWHdLdLyireOnBdbzOl2oT9vlfuAYIlhMTYKGJHSlvW27S6
         0HY1tzvVTiMBESKMcAsNU6tMe3HF2nyIHG7nz50LXCFS7/Soze9Owm3gbrpw1vmIXpk9
         aDk7l8TOBo1nce1rOcqr6lfPpNbBOU+TgwuTBAw++Ji9RQtfrZ3wqqG0FIjtCKNcmnlN
         hottNQ1a656FeUT20hFC2aMfgpkpyneRxDxc+Qs8asDpksx7yMroDw7kcBPswtIhPQH7
         7oheje+5enoeG+9d/nEdlW76mAVFgL46Y21tLYplKbUbeXda8lFZIHZbOxV+szjkiwn2
         u5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WkP07DKCbnwQE6/X/KtSc8NN0wE1LkkRJITLBD5bT90=;
        b=pMwUnCKv4R13RLZ8Zt7NFIGaXg8ZyA9MColXnCphwUbrnlboozIixr4kLuMYNngcCB
         t8nTnZ05v/cpVKqrPv3vsnOA06AxoIITVMPNA+axAsEQaYYDZZAt3zxE+aromssi3J2u
         fiWP/vqjiKnwbtqu+rWX42SUryHbH8dC14qPBRCtYbyiVmfgfjj2zG8k8AvsBn0Byoid
         TWA8K318lLbLIekoy5cPYgrpAobPvxXbxkEhUueeFlwef3/FPSBm6hcmvPmTXSw2WrwD
         WfVn1JkG7CZE8zr81G6qcElXie98ezvvJwZ/4zd/b26j0CChaFyvn9Tzq3M9KB3w5N49
         lFDg==
X-Gm-Message-State: AOAM531WFAtuRoXhwTUuV9dL25lhCvFFPrQNJ8NZ/OxBYKwK4H0RcO51
        rt1wUHrc/6QFhPr3WO+eOBI=
X-Google-Smtp-Source: ABdhPJwEetUDw7xT6SNpQSeqBZeZ+X0VRGWtjPz6uapq4dZPXheAHZAioRRI5YVe6Eo5i+1//9ZncQ==
X-Received: by 2002:a17:90b:3b46:b0:1bc:4bc4:2f64 with SMTP id ot6-20020a17090b3b4600b001bc4bc42f64mr2700450pjb.203.1645513447686;
        Mon, 21 Feb 2022 23:04:07 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e2d6])
        by smtp.gmail.com with ESMTPSA id i17sm19190986pgn.82.2022.02.21.23.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 23:04:07 -0800 (PST)
Date:   Mon, 21 Feb 2022 23:04:05 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 08/15] bpf: Adapt copy_map_value for multiple
 offset case
Message-ID: <20220222070405.i6esgcf7ouqrmoef@ast-mbp.dhcp.thefacebook.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-9-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-9-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 07:18:06PM +0530, Kumar Kartikeya Dwivedi wrote:
> The changes in this patch deserve closer look, so it has been split into
> its own independent patch. While earlier we just had to skip two objects
> at most while copying in and out of map, now we have potentially many
> objects (at most 8 + 2 = 10, due to the BPF_MAP_VALUE_OFF_MAX limit).
> 
> Hence, divide the copy_map_value function into an inlined fast path and
> function call to slowpath. The slowpath handles the case of > 3 offsets,
> while we handle the most common cases (0, 1, 2, or 3 offsets) in the
> inline function itself.
> 
> In copy_map_value_slow, we use 11 offsets, just to make the for loop
> that copies the value free of edge cases for the last offset, by using
> map->value_size as final offset to subtract remaining area to copy from.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h  | 43 +++++++++++++++++++++++++++++++---
>  kernel/bpf/syscall.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 95 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ae599aaf8d4c..5d845ca02eba 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -253,12 +253,22 @@ static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
>  		memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
>  	if (unlikely(map_value_has_timer(map)))
>  		memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
> +	if (unlikely(map_value_has_ptr_to_btf_id(map))) {
> +		struct bpf_map_value_off *tab = map->ptr_off_tab;
> +		int i;
> +
> +		for (i = 0; i < tab->nr_off; i++)
> +			*(u64 *)(dst + tab->off[i].offset) = 0;
> +	}
>  }
>  
> +void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
> +			 u32 s_sz, u32 t_off, u32 t_sz);
> +
>  /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
>  static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>  {
> -	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0;
> +	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0, p_off = 0, p_sz = 0;
>  
>  	if (unlikely(map_value_has_spin_lock(map))) {
>  		s_off = map->spin_lock_off;
> @@ -268,13 +278,40 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>  		t_off = map->timer_off;
>  		t_sz = sizeof(struct bpf_timer);
>  	}
> +	/* Multiple offset case is slow, offload to function */
> +	if (unlikely(map_value_has_ptr_to_btf_id(map))) {
> +		struct bpf_map_value_off *tab = map->ptr_off_tab;
> +
> +		/* Inline the likely common case */
> +		if (likely(tab->nr_off == 1)) {
> +			p_off = tab->off[0].offset;
> +			p_sz = sizeof(u64);
> +		} else {
> +			copy_map_value_slow(map, dst, src, s_off, s_sz, t_off, t_sz);
> +			return;
> +		}
> +	}
> +
> +	if (unlikely(s_sz || t_sz || p_sz)) {
> +		/* The order is p_off, t_off, s_off, use insertion sort */
>  
> -	if (unlikely(s_sz || t_sz)) {
> +		if (t_off < p_off || !t_sz) {
> +			swap(t_off, p_off);
> +			swap(t_sz, p_sz);
> +		}
>  		if (s_off < t_off || !s_sz) {
>  			swap(s_off, t_off);
>  			swap(s_sz, t_sz);
> +			if (t_off < p_off || !t_sz) {
> +				swap(t_off, p_off);
> +				swap(t_sz, p_sz);
> +			}
>  		}
> -		memcpy(dst, src, t_off);
> +
> +		memcpy(dst, src, p_off);
> +		memcpy(dst + p_off + p_sz,
> +		       src + p_off + p_sz,
> +		       t_off - p_off - p_sz);
>  		memcpy(dst + t_off + t_sz,
>  		       src + t_off + t_sz,
>  		       s_off - t_off - t_sz);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index beb96866f34d..83d71d6912f5 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -30,6 +30,7 @@
>  #include <linux/pgtable.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/poll.h>
> +#include <linux/sort.h>
>  #include <linux/bpf-netns.h>
>  #include <linux/rcupdate_trace.h>
>  #include <linux/memcontrol.h>
> @@ -230,6 +231,60 @@ static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
>  	return err;
>  }
>  
> +static int copy_map_value_cmp(const void *_a, const void *_b)
> +{
> +	const u32 a = *(const u32 *)_a;
> +	const u32 b = *(const u32 *)_b;
> +
> +	/* We only need to sort based on offset */
> +	if (a < b)
> +		return -1;
> +	else if (a > b)
> +		return 1;
> +	return 0;
> +}
> +
> +void copy_map_value_slow(struct bpf_map *map, void *dst, void *src, u32 s_off,
> +			 u32 s_sz, u32 t_off, u32 t_sz)
> +{
> +	struct bpf_map_value_off *tab = map->ptr_off_tab; /* already set to non-NULL */
> +	/* 3 = 2 for bpf_timer, bpf_spin_lock, 1 for map->value_size sentinel */
> +	struct {
> +		u32 off;
> +		u32 sz;
> +	} off_arr[BPF_MAP_VALUE_OFF_MAX + 3];
> +	int i, cnt = 0;
> +
> +	/* Reconsider stack usage when bumping BPF_MAP_VALUE_OFF_MAX */
> +	BUILD_BUG_ON(sizeof(off_arr) != 88);
> +
> +	for (i = 0; i < tab->nr_off; i++) {
> +		off_arr[cnt].off = tab->off[i].offset;
> +		off_arr[cnt++].sz = sizeof(u64);
> +	}
> +	if (s_sz) {
> +		off_arr[cnt].off = s_off;
> +		off_arr[cnt++].sz = s_sz;
> +	}
> +	if (t_sz) {
> +		off_arr[cnt].off = t_off;
> +		off_arr[cnt++].sz = t_sz;
> +	}
> +	off_arr[cnt].off = map->value_size;
> +
> +	sort(off_arr, cnt, sizeof(off_arr[0]), copy_map_value_cmp, NULL);

Ouch. sort every time we need to copy map value?
sort it once please. 88 bytes in a map are worth it.
Especially since "slow" version will trigger with just 2 kptrs.
(if I understand this correctly).
