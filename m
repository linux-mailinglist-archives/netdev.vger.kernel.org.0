Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847843B10CC
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFVXwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFVXwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:52:09 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E7FC061756;
        Tue, 22 Jun 2021 16:49:51 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id a11so914414ilf.2;
        Tue, 22 Jun 2021 16:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yEin6NsZyITOBllQK+uSTWwo16L3MWUi4g+JR1qvUzI=;
        b=P+pdu9Za/3zTisEXn8J+GOH4NxNd+8jVxyj+BfEz1x5kI6gdMgvZ+4GSCoZcOR16gh
         Hflr7Ej+LezaBxMUVBUdEJmjYhzourZ5J7NZcjDcb8WWtZrWBBNwrlVVBUGF9Xl+Hkz3
         lCrcU6Qux7XLdTe1xM/HU0vmxE/yohv8mzgxS7y/CoxzvPOaH8G7+p1LR6iTZzQnzbzD
         sp4JPAzTCz0DpulCC4oIU+P8p13pFywhm2MaCviyb1Ip8iGCembMEVDanGaZ0f+RBfb0
         W4Jj68yjWihuNGzqhzquxaP3TmqWg6cdEO8nnQjDsVP3QgrF9QPJjaqyPlEqM2170yVM
         hGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yEin6NsZyITOBllQK+uSTWwo16L3MWUi4g+JR1qvUzI=;
        b=fpu2MARk7K1CnaH15/p17Qry2ISEGYzfZPjdBFffzyccGnWkF1qCKtEKs85Y91aw8E
         2n8zZIZAV6kIMn2JoTwrXgkVvaeVHQ7T2i8d5D+pkxF8ESg8mOO9Jai2XsXcOyiBD0Db
         I4Vgjja4My19GaNlyDVePgoBkZmral8aTicHH2yPuZmppU3DzkpfOnYqX7VSLt9/yQt/
         nl3UnfnMnEqU3n/7h1/7U6jyZIRZ5Cg1UkmRLlL9U17FSZEjkNpkz1V16WZllFVuyzTE
         fvX3XKCNo9SokD/n1WTdHviYrSGepeOMyJYzfC0HFv72WvxyW6Yv1UKuwxR/zuuCdMlh
         FkUQ==
X-Gm-Message-State: AOAM530HC+4HTnl6Ak9o0zbBW78pvG51kYSxq4QlGM7pNCwjc7t6WQP7
        EVfMLmXIdwrOetaUlw4ouQk=
X-Google-Smtp-Source: ABdhPJy+u6bR2D0CXhdELPS1jDzhkIxRyee9kBwEZsU02Vtar/ANqT3x+wKSaiHK2vGNmY2Zvs4Kyw==
X-Received: by 2002:a05:6e02:1c0d:: with SMTP id l13mr764086ilh.271.1624405791084;
        Tue, 22 Jun 2021 16:49:51 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id e2sm10666830iot.50.2021.06.22.16.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:49:50 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:49:42 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d27716b5a5a_1342e208d5@john-XPS-13-9370.notmuch>
In-Reply-To: <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
Subject: RE: [PATCH v9 bpf-next 10/14] bpf: add multi-buffer support to xdp
 copy helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This patch adds support for multi-buffer for the following helpers:
>   - bpf_xdp_output()
>   - bpf_perf_event_output()
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Ah ok so at least xdp_output will work with all bytes. But this is
getting close to having access into the frags so I think doing
the last bit shouldn't be too hard?

>  kernel/trace/bpf_trace.c                      |   3 +
>  net/core/filter.c                             |  72 +++++++++-
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++++++------
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  4 files changed, 160 insertions(+), 44 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d2d7cf6cfe83..ee926ec64f78 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1365,6 +1365,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
>  
>  extern const struct bpf_func_proto bpf_skb_output_proto;
>  extern const struct bpf_func_proto bpf_xdp_output_proto;
> +extern const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto;
>  
>  BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
>  	   struct bpf_map *, map, u64, flags)
> @@ -1460,6 +1461,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_sock_from_file_proto;
>  	case BPF_FUNC_get_socket_cookie:
>  		return &bpf_get_socket_ptr_cookie_proto;
> +	case BPF_FUNC_xdp_get_buff_len:
> +		return &bpf_xdp_get_buff_len_trace_proto;
>  #endif
>  	case BPF_FUNC_seq_printf:
>  		return prog->expected_attach_type == BPF_TRACE_ITER ?
> diff --git a/net/core/filter.c b/net/core/filter.c
> index b0855f2d4726..f7211b7908a9 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3939,6 +3939,15 @@ const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
>  	.arg1_type	= ARG_PTR_TO_CTX,
>  };
>  
> +BTF_ID_LIST_SINGLE(bpf_xdp_get_buff_len_bpf_ids, struct, xdp_buff)
> +
> +const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto = {
> +	.func		= bpf_xdp_get_buff_len,
> +	.gpl_only	= false,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg1_btf_id	= &bpf_xdp_get_buff_len_bpf_ids[0],
> +};
> +
>  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  {
>  	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> @@ -4606,10 +4615,56 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
>  };
>  #endif
>  
> -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>  				  unsigned long off, unsigned long len)
>  {
> -	memcpy(dst_buff, src_buff + off, len);
> +	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
> +	struct skb_shared_info *sinfo;
> +	unsigned long base_len;
> +
> +	if (likely(!xdp_buff_is_mb(xdp))) {
> +		memcpy(dst_buff, xdp->data + off, len);
> +		return 0;
> +	}
> +
> +	base_len = xdp->data_end - xdp->data;
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +	do {
> +		const void *src_buff = NULL;
> +		unsigned long copy_len = 0;
> +
> +		if (off < base_len) {
> +			src_buff = xdp->data + off;
> +			copy_len = min(len, base_len - off);
> +		} else {
> +			unsigned long frag_off_total = base_len;
> +			int i;
> +
> +			for (i = 0; i < sinfo->nr_frags; i++) {
> +				skb_frag_t *frag = &sinfo->frags[i];
> +				unsigned long frag_len, frag_off;
> +
> +				frag_len = skb_frag_size(frag);
> +				frag_off = off - frag_off_total;
> +				if (frag_off < frag_len) {
> +					src_buff = skb_frag_address(frag) +
> +						   frag_off;
> +					copy_len = min(len,
> +						       frag_len - frag_off);
> +					break;
> +				}
> +				frag_off_total += frag_len;
> +			}
> +		}
> +		if (!src_buff)
> +			break;
> +
> +		memcpy(dst_buff, src_buff, copy_len);
> +		off += copy_len;
> +		len -= copy_len;
> +		dst_buff += copy_len;

This block reads odd to be because it requires looping over the frags
multiple times? Why not something like this,

  if (off < base_len) {
   src_buff = xdp->data + off
   copy_len = min...
   memcpy(dst_buff, src_buff, copy_len)
   off += copylen
   len -= copylen
   dst_buff += copylen;
  }

  for (i = 0; i , nr_frags; i++) {
     frag = ...
     ...
     if frag_off < fraglen
        ...
        memcpy()
        update(off, len, dst_buff)
  }


Maybe use a helper to set off,len and dst_buff if worried about the
duplication. Seems cleaner than walking through 0..n-1 frags for
each copy.

> +	} while (len);
> +
>  	return 0;
>  }
