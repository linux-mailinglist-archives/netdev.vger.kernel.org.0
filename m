Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AFF3FD05D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbhIAAh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbhIAAh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:37:58 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD934C061575;
        Tue, 31 Aug 2021 17:37:02 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z2so1724513iln.0;
        Tue, 31 Aug 2021 17:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=uJK4ZZSDEP4YjA8edgfZhxskYILZT/03UHWDnmiGok8=;
        b=qgZ1YUREXxwMIug9mNQekf+6j3/t58KDMBsc0aU36bZ6wjsAARbIiQEnQOtf9Ovb+q
         7OTo2aE0v5ob+lUPjUtmlix6Ujdnsr7bPgoqjBsuBrQg0jupiwHLrphsqo/2lbWrHX4X
         QAFixdaeCpASgxzVhLsNmYCEaAqkLvURjUBwRNm8NpgGzCs5dLIxBKsckYVrAIMWoJ7l
         aX7A845VzJLFGob96TIraaSPS2/vUjJpeEvYZtvlWW+cMGekwTZ9+nTdglTjqoIJ9MXb
         koJcTkm/Fkb/EJ1ZsxnSUV5kv+FWHkQM5wCyBwi2rcJ9xjdobxy5tgGUrtksBc9aJ0+D
         KnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=uJK4ZZSDEP4YjA8edgfZhxskYILZT/03UHWDnmiGok8=;
        b=f2AIjfzFPGgb/nBlLOdlnda11+NpQ5jvo+PeAHDSRYGJjQw7DFs80C9Y2Qh9Z2uMf9
         B6bdM+o8ouuwIsxqWDN5uhX5XXtlCWGW0VOVZyohM06EJICEhOGOnm+e57vsc3lwpaZq
         yXH84LlDyXFaJMW1MZgDpM7npPEtaEW3UiqPewDRF4utkZ4b28fVPzFQDNrQMyG+c9wk
         BTgfs0rQnCxT/5WfhQzyTCVmG0cuDoobWK6zm3qnQOZJUqAyFEx6jh7VxeRhD8aNlul6
         Lq7YOctKCWJoOoAK0dInZGwqfqKTo0mM6jeF8eokj/HciXYtxU2VAmLcBi+e8Y5zjnK8
         A6MQ==
X-Gm-Message-State: AOAM533IIyblU+cr+Kbz2AbGMu+02U0+kzFsLvGm8qALeveO26n9sPAp
        Phna/dC4ouew2AZxtRISobw=
X-Google-Smtp-Source: ABdhPJxamCjTQZGe34ONPx0Ww+2T1IzT2rGI5cZW8cn2B2kJjzs/VZWfem94zF3x+ykld62tLESNMQ==
X-Received: by 2002:a92:280d:: with SMTP id l13mr22483031ilf.99.1630456622094;
        Tue, 31 Aug 2021 17:37:02 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n11sm10879364ilq.21.2021.08.31.17.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:37:01 -0700 (PDT)
Date:   Tue, 31 Aug 2021 17:36:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ecb262b05_6b87208c0@john-XPS-13-9370.notmuch>
In-Reply-To: <14b99bc75ce0f8d4968208fb0b420a054e45433e.1629473234.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <14b99bc75ce0f8d4968208fb0b420a054e45433e.1629473234.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 17/18] net: xdp: introduce
 bpf_xdp_adjust_data helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> For XDP frames split over multiple buffers, the xdp_md->data and
> xdp_md->data_end pointers will point to the start and end of the first
> fragment only. bpf_xdp_adjust_data can be used to access subsequent
> fragments by moving the data pointers. To use, an XDP program can call
> this helper with the byte offset of the packet payload that
> it wants to access; the helper will move xdp_md->data and xdp_md ->data_end
> so they point to the requested payload offset and to the end of the
> fragment containing this byte offset, and return the byte offset of the
> start of the fragment.
> To move back to the beginning of the packet, simply call the
> helper with an offset of '0'.
> Note also that the helpers that modify the packet boundaries
> (bpf_xdp_adjust_head(), bpf_xdp_adjust_tail() and
> bpf_xdp_adjust_meta()) will fail if the pointers have been
> moved; it is the responsibility of the BPF program to move them
> back before using these helpers.

I'm ok with this for a first iteration I guess with more work we
can make the helpers use the updated pointers though.

> 
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Overall looks good couple small nits/questions below. Thanks!

> ---
>  include/net/xdp.h              |  8 +++++
>  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++
>  net/bpf/test_run.c             |  8 +++++
>  net/core/filter.c              | 62 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++
>  5 files changed, 141 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index cdaecf8d4d61..ce4764c7cd40 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -82,6 +82,11 @@ struct xdp_buff {
>  	struct xdp_txq_info *txq;
>  	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
>  	u16 flags; /* supported values defined in xdp_flags */
> +	/* xdp multi-buff metadata used for frags iteration */
> +	struct {
> +		u16 headroom;	/* frame headroom: data - data_hard_start */
> +		u16 headlen;	/* first buffer length: data_end - data */
> +	} mb;
>  };
>  
>  static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
> @@ -127,6 +132,9 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>  	xdp->data = data;
>  	xdp->data_end = data + data_len;
>  	xdp->data_meta = meta_valid ? data : data + 1;
> +	/* mb metadata for frags iteration */
> +	xdp->mb.headroom = headroom;
> +	xdp->mb.headlen = data_len;
>  }
>  
>  /* Reserve memory area at end-of data area.
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9e2c3b12ea49..a7b5185a718a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4877,6 +4877,37 @@ union bpf_attr {
>   *		Get the total size of a given xdp buff (linear and paged area)
>   *	Return
>   *		The total size of a given xdp buffer.
> + *
> + * long bpf_xdp_adjust_data(struct xdp_buff *xdp_md, u32 offset)
> + *	Description
> + *		For XDP frames split over multiple buffers, the
> + *		*xdp_md*\ **->data** and*xdp_md *\ **->data_end** pointers
                                       ^^^^
missing space?

> + *		will point to the start and end of the first fragment only.
> + *		This helper can be used to access subsequent fragments by
> + *		moving the data pointers. To use, an XDP program can call
> + *		this helper with the byte offset of the packet payload that
> + *		it wants to access; the helper will move *xdp_md*\ **->data**
> + *		and *xdp_md *\ **->data_end** so they point to the requested
> + *		payload offset and to the end of the fragment containing this
> + *		byte offset, and return the byte offset of the start of the
> + *		fragment.
> + *		To move back to the beginning of the packet, simply call the
> + *		helper with an offset of '0'.
> + *		Note also that the helpers that modify the packet boundaries
> + *		(*bpf_xdp_adjust_head()*, *bpf_xdp_adjust_tail()* and
> + *		*bpf_xdp_adjust_meta()*) will fail if the pointers have been
> + *		moved; it is the responsibility of the BPF program to move them
> + *		back before using these helpers.
> + *
> + *		A call to this helper is susceptible to change the underlying
> + *		packet buffer. Therefore, at load time, all checks on pointers
> + *		previously done by the verifier are invalidated and must be
> + *		performed again, if the helper is used in combination with
> + *		direct packet access.
> + *	Return
> + *		offset between the beginning of the current fragment and
> + *		original *xdp_md*\ **->data** on success, or a negative error
> + *		in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -5055,6 +5086,7 @@ union bpf_attr {
>  	FN(get_func_ip),		\
>  	FN(get_attach_cookie),		\
>  	FN(xdp_get_buff_len),		\
> +	FN(xdp_adjust_data),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 869dcf23a1ca..f09c2c8c0d6c 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -757,6 +757,8 @@ static int xdp_convert_md_to_buff(struct xdp_md *xdp_md, struct xdp_buff *xdp)
>  	}
>  
>  	xdp->data = xdp->data_meta + xdp_md->data;
> +	xdp->mb.headroom = xdp->data - xdp->data_hard_start;
> +	xdp->mb.headlen = xdp->data_end - xdp->data;
>  	return 0;
>  
>  free_dev:
> @@ -871,6 +873,12 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	if (ret)
>  		goto out;
>  
> +	/* data pointers need to be reset after frag iteration */
> +	if (unlikely(xdp.data_hard_start + xdp.mb.headroom != xdp.data)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
>  	size = xdp.data_end - xdp.data_meta + sinfo->xdp_frags_size;
>  	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, sinfo, size,
>  			      retval, duration);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2122c00c680f..ed2a6632adce 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3827,6 +3827,10 @@ BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
>  	void *data_start = xdp_frame_end + metalen;
>  	void *data = xdp->data + offset;
>  
> +	/* data pointers need to be reset after frag iteration */
> +	if (unlikely(xdp->data_hard_start + xdp->mb.headroom != xdp->data))
> +		return -EINVAL;

-EFAULT? It might be nice if error code is different from below
for debugging?

> +
>  	if (unlikely(data < data_start ||
>  		     data > xdp->data_end - ETH_HLEN))
>  		return -EINVAL;
> @@ -3836,6 +3840,9 @@ BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
>  			xdp->data_meta, metalen);
>  	xdp->data_meta += offset;
>  	xdp->data = data;
> +	/* update metada for multi-buff frag iteration */
> +	xdp->mb.headroom = xdp->data - xdp->data_hard_start;
> +	xdp->mb.headlen = xdp->data_end - xdp->data;
>  
>  	return 0;
>  }
> @@ -3910,6 +3917,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
>  	void *data_end = xdp->data_end + offset;
>  
> +	/* data pointer needs to be reset after frag iteration */
> +	if (unlikely(xdp->data + xdp->mb.headlen != xdp->data_end))
> +		return -EINVAL;

EFAULT?

> +
>  	if (unlikely(xdp_buff_is_mb(xdp)))
>  		return bpf_xdp_mb_adjust_tail(xdp, offset);
>  
> @@ -3949,6 +3960,10 @@ BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
>  	void *meta = xdp->data_meta + offset;
>  	unsigned long metalen = xdp->data - meta;
>  
> +	/* data pointer needs to be reset after frag iteration */
> +	if (unlikely(xdp->data_hard_start + xdp->mb.headroom != xdp->data))
> +		return -EINVAL;

same comment.

>  	if (xdp_data_meta_unsupported(xdp))
>  		return -ENOTSUPP;
>  	if (unlikely(meta < xdp_frame_end ||
> @@ -3970,6 +3985,48 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_2(bpf_xdp_adjust_data, struct xdp_buff *, xdp, u32, offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 base_offset = xdp->mb.headlen;
> +	int i;
> +
> +	if (!xdp_buff_is_mb(xdp) || offset > sinfo->xdp_frags_size)
> +		return -EINVAL;

Do we need to error this? If its not mb we can just return the same
as offset==0?

> +
> +	if (offset < xdp->mb.headlen) {
> +		/* linear area */
> +		xdp->data = xdp->data_hard_start + xdp->mb.headroom + offset;
> +		xdp->data_end = xdp->data_hard_start + xdp->mb.headroom +
> +				xdp->mb.headlen;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < sinfo->nr_frags; i++) {
> +		/* paged area */
> +		skb_frag_t *frag = &sinfo->frags[i];
> +		unsigned int size = skb_frag_size(frag);
> +
> +		if (offset < base_offset + size) {
> +			u8 *addr = skb_frag_address(frag);
> +
> +			xdp->data = addr + offset - base_offset;
> +			xdp->data_end = addr + size;
> +			break;
> +		}
> +		base_offset += size;
> +	}
> +	return base_offset;
> +}
