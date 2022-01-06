Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B3D485FA3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiAFE0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiAFE0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:26:21 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E79AC061245;
        Wed,  5 Jan 2022 20:26:21 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 200so1533476pgg.3;
        Wed, 05 Jan 2022 20:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cWMCEHhsClba+3h4hHzfGJTFnu/ksTChHmm43SQVI1E=;
        b=DQuXQTyEa9uh8XBLpkYYIXep/xeERUjl1qsO3f/idRBqhcAWt5VhysJ2/ZmMM1x3Ln
         M9mDl6tkBf17hKrQxCqwal3NSVKQNOWx3WNwLxxavnJdUpLisAakaS1Shs/ZZVQzF53M
         WMlQ3cxOrOyi9rdXXOPZT2nW/6q2Sx4dzeCS+E7y+10YT0kduVZqsNhWpxMOjB/+FVV6
         fhKKvyKeEonFDh0cAOQuSH8xoyOvvvQWFE7+MGLHJIWUslh/saofXem62GjL+ljUqWwW
         VsCQUuasxvquwJnO+OrMoN4rYpeM23+6MI8UyFjA3RRsSqRmZdZu0g/jjzDURUUn1GES
         FGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cWMCEHhsClba+3h4hHzfGJTFnu/ksTChHmm43SQVI1E=;
        b=eJvhnx14ugCLdTauOn2VGnTzdZ2nx/zjhZF+9UKFAz+NGSu86KOV8Ed6EzWGzdODPm
         r95PqSLoKd2nUeozSm9jnHjWNo3wyjXjh2rx68+nWJhgStmmgJgHvzMYcM07tjhjTe6r
         5hLxHCT5D4Y+y2KlttwTcW5NXyWYU+KRNn9pb7cD+Uh+eWSIxqWO5SxN8MGn5bTwEQHC
         QiagcnZp8VGeO2lDxSq8csmskSE7sqNlBmbskaU/5x4p9YUM9dq/UMFgYlDaG+rAaMT5
         dJfLS0IIEdcygekjZlWQ35xgYM6Tu2Dx5TvFlPeO8ItyIVyDIvCVsFng3PDEK70t0d7n
         1Ezg==
X-Gm-Message-State: AOAM533YMGo3vn8vABhjvsV+8geOwv1/Kltzr/f69ZuDM6Vwu4F4pd7/
        WxeWue2IJjSiu+iIG0SdvQyw05BcHPQ=
X-Google-Smtp-Source: ABdhPJyiyaEoL8Fjyd/2d9qu7ExMe7LjW1Wc1WJe4PJGtfwxVZVMkrfsxra8jSMXtrGk8QJ2R9yHmg==
X-Received: by 2002:a05:6a00:23d2:b0:4ba:e5e6:94f2 with SMTP id g18-20020a056a0023d200b004bae5e694f2mr58210638pfc.14.1641443180788;
        Wed, 05 Jan 2022 20:26:20 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id d21sm619866pfv.45.2022.01.05.20.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 20:26:20 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:26:18 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 6/7] bpf: Add "live packet" mode for XDP in
 bpf_prog_run()
Message-ID: <20220106042618.kperh3ovyuckxecl@ast-mbp.dhcp.thefacebook.com>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-7-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220103150812.87914-7-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 04:08:11PM +0100, Toke Høiland-Jørgensen wrote:
> +static void xdp_test_run_init_page(struct page *page, void *arg)
> +{
> +	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
> +	struct xdp_buff *new_ctx, *orig_ctx;
> +	u32 headroom = XDP_PACKET_HEADROOM;
> +	struct xdp_test_data *xdp = arg;
> +	size_t frm_len, meta_len;
> +	struct xdp_frame *frm;
> +	void *data;
> +
> +	orig_ctx = xdp->orig_ctx;
> +	frm_len = orig_ctx->data_end - orig_ctx->data_meta;
> +	meta_len = orig_ctx->data - orig_ctx->data_meta;
> +	headroom -= meta_len;
> +
> +	new_ctx = &head->ctx;
> +	frm = &head->frm;
> +	data = &head->data;
> +	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
> +
> +	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
> +	xdp_prepare_buff(new_ctx, data, headroom, frm_len, true);
> +	new_ctx->data_meta = new_ctx->data + meta_len;

data vs data_meta is the other way around, no?

Probably needs a selftest to make sure.

> +static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
> +			   struct net_device *dev)
> +{
> +	gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
> +	void *skbs[TEST_XDP_BATCH];
> +	int i, n;
> +	LIST_HEAD(list);
> +
> +	n = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
> +	if (unlikely(n == 0)) {
> +		for (i = 0; i < nframes; i++)
> +			xdp_return_frame(frames[i]);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < nframes; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +		struct sk_buff *skb = skbs[i];
> +
> +		skb = __xdp_build_skb_from_frame(xdpf, skb, dev);
> +		if (!skb) {
> +			xdp_return_frame(xdpf);
> +			continue;
> +		}
> +
> +		list_add_tail(&skb->list, &list);
> +	}
> +	netif_receive_skb_list(&list);

Does it need local_bh_disable() like cpumap does?

I've applied patches 1 - 5.
