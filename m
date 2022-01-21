Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFD4967E9
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 23:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiAUWdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 17:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAUWdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 17:33:07 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC1FC06173D
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:33:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n196-20020a25d6cd000000b006139bdfade9so20487602ybg.17
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5xDmTx1HcQTTITEWfiJJPNcSAwFVBpoQdQ9YPk8f0So=;
        b=TubBJ9qyaV3+4h6NBhWEliH/409fVKCDCesuALRjU23RCg7UbYzG0cktz3YRWEa8fq
         8Dyoz6YNe/daJzisMM/GXTszg6vjZTsklDnNWIKI5sJxQMRPOObpY3QhUeFdYn4inPfy
         omjcymznWrxZ8Ebn1+zHxM8g8qczHFW+RhjPrj76BIzRUTebv9nZTY+6CQcJDICVIh7H
         hXeF2BB1leRIY0Zh9xz+DtogFw2FLm7qThYIrONmk9ObvZdVdX/OfIBu0IR+SMx+fmDw
         76Uj30WyPcy1wQ2sIXYeSdhUFSIGSKc2MF5hzpGz7VZrZYhiNL1/02bYmbfCAvxwRvNM
         M/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5xDmTx1HcQTTITEWfiJJPNcSAwFVBpoQdQ9YPk8f0So=;
        b=fdIUIJ792GS3ms2JBcE14vYCCPJA5E6pWaodx4tshpRfOrAr5luIpaVkM0NdSZYc40
         z3+qjmaJtU48Fddn0mr4RtU+LhYrmsqHyMGU750mdTLdSsE7lvHrN/A8WSENgZ3AHCWT
         WM/LhghNF1rARVzAztZbBQUboq1RnNaTGF4aCXITyeceeGPR1PkZVNMVLuTYMKExnqG4
         eKZDHPtTJtBBYQ1VyQ41eirK+0vZ6EjhqePqEDPiy0ls/sW8CIl7ePuBQoLvMmkA0DEE
         cb3bX971l1LSPU6MrHOhHxXWbX8vCgQmSXB/NopGJSf2w2POZUvnm/41SPRvzIhGd9hx
         a0ow==
X-Gm-Message-State: AOAM531vEOScizgautayANQkt1M/eYw9oH0fvSx7yt+OEdsVhNryubiM
        F+op/v8enLi3yQt+GnjztiblDMA=
X-Google-Smtp-Source: ABdhPJyyxCjmbj6SdsMngaLyJZ0ruAFmNEnKQB5zJY8tl7o1xfbYGaCgD+/phWcBLqqwOdggNv/XmDI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a647:98e5:9f:3032])
 (user=sdf job=sendgmr) by 2002:a81:7b45:0:b0:2ca:287c:6b90 with SMTP id
 00721157ae682-2ca287c6ddfmr07b3.53.1642804385097; Fri, 21 Jan 2022 14:33:05
 -0800 (PST)
Date:   Fri, 21 Jan 2022 14:33:02 -0800
In-Reply-To: <20220121205637.ip4eax3mhsaod74k@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <Yes0npx9SWJfHh9v@google.com>
Mime-Version: 1.0
References: <20220121073026.4173996-1-kafai@fb.com> <20220121073051.4180328-1-kafai@fb.com>
 <YesAbHLRYBJ8FwiK@google.com> <20220121205637.ip4eax3mhsaod74k@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC PATCH v3 net-next 4/4] bpf: Add __sk_buff->mono_delivery_time
 and handle __sk_buff->tstamp based on tc_at_ingress
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/21, Martin KaFai Lau wrote:
> On Fri, Jan 21, 2022 at 10:50:20AM -0800, sdf@google.com wrote:
> > On 01/20, Martin KaFai Lau wrote:
> > > __sk_buff->mono_delivery_time:
> > > This patch adds __sk_buff->mono_delivery_time to
> > > read and write the mono delivery_time in skb->tstamp.
> >
> > > The bpf rewrite is like:
> > > /* BPF_READ: __u64 a = __sk_buff->mono_delivery_time; */
> > > if (skb->mono_delivery_time)
> > > 	a = skb->tstamp;
> > > else
> > > 	a = 0;
> >
> > > /* BPF_WRITE: __sk_buff->mono_delivery_time = a; */
> > > skb->tstamp = a;
> > > skb->mono_delivery_time = !!a;
> >
> > > __sk_buff->tstamp:
> > > The bpf rewrite is like:
> > > /* BPF_READ: __u64 a = __sk_buff->tstamp; */
> > > if (skb->tc_at_ingress && skb->mono_delivery_time)
> > > 	a = 0;
> > > else
> > > 	a = skb->tstamp;
> >
> > > /* BPF_WRITE: __sk_buff->tstamp = a; */
> > > skb->tstamp = a;
> > > if (skb->tc_at_ingress || !a)
> > > 	skb->mono_delivery_time = 0;
> >
> > > At egress, reading is the same as before.  All skb->tstamp
> > > is the delivery_time.  Writing will not change the (kernel)
> > > skb->mono_delivery_time also unless 0 is being written.  This
> > > will be the same behavior as before.
> >
> > > (#) At ingress, the current bpf prog can only expect the
> > > (rcv) timestamp.  Thus, both reading and writing are now treated as
> > > operating on the (rcv) timestamp for the existing bpf prog.
> >
> > > During bpf load time, the verifier will learn if the
> > > bpf prog has accessed the new __sk_buff->mono_delivery_time.
> >
> > > When reading at ingress, if the bpf prog does not access the
> > > new __sk_buff->mono_delivery_time, it will be treated as the
> > > existing behavior as mentioned in (#) above.  If the (kernel)  
> skb->tstamp
> > > currently has a delivery_time,  it will temporary be saved first and  
> then
> > > set the skb->tstamp to either the ktime_get_real() or zero.  After
> > > the bpf prog finished running, if the bpf prog did not change
> > > the skb->tstamp,  the saved delivery_time will be restored
> > > back to the skb->tstamp.
> >
> > > When writing __sk_buff->tstamp at ingress, the
> > > skb->mono_delivery_time will be cleared because of
> > > the (#) mentioned above.
> >
> > > If the bpf prog does access the new __sk_buff->mono_delivery_time
> > > at ingress, it indicates that the bpf prog is aware of this new
> > > kernel support:
> > > the (kernel) skb->tstamp can have the delivery_time or the
> > > (rcv) timestamp at ingress.  If the __sk_buff->mono_delivery_time
> > > is available, the __sk_buff->tstamp will not be available and
> > > it will be zero.
> >
> > > The bpf rewrite needs to access the skb's mono_delivery_time
> > > and tc_at_ingress bit.  They are moved up in sk_buff so
> > > that bpf rewrite can be done at a fixed offset.  tc_skip_classify
> > > is moved together with tc_at_ingress.  To get one bit for
> > > mono_delivery_time, csum_not_inet is moved down and this bit
> > > is currently used by sctp.
> >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >   include/linux/filter.h         |  31 +++++++-
> > >   include/linux/skbuff.h         |  20 +++--
> > >   include/uapi/linux/bpf.h       |   1 +
> > >   net/core/filter.c              | 134  
> ++++++++++++++++++++++++++++++---
> > >   net/sched/act_bpf.c            |   5 +-
> > >   net/sched/cls_bpf.c            |   6 +-
> > >   tools/include/uapi/linux/bpf.h |   1 +
> > >   7 files changed, 171 insertions(+), 27 deletions(-)
> >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index 71fa57b88bfc..5cef695d6575 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -572,7 +572,8 @@ struct bpf_prog {
> > >   				has_callchain_buf:1, /* callchain buffer allocated? */
> > >   				enforce_expected_attach_type:1, /* Enforce expected_attach_type
> > > checking at attach time */
> > >   				call_get_stack:1, /* Do we call bpf_get_stack() or
> > > bpf_get_stackid() */
> > > -				call_get_func_ip:1; /* Do we call get_func_ip() */
> > > +				call_get_func_ip:1, /* Do we call get_func_ip() */
> > > +				delivery_time_access:1; /* Accessed  
> __sk_buff->mono_delivery_time */
> > >   	enum bpf_prog_type	type;		/* Type of BPF program */
> > >   	enum bpf_attach_type	expected_attach_type; /* For some prog types  
> */
> > >   	u32			len;		/* Number of filter blocks */
> > > @@ -699,6 +700,34 @@ static inline void  
> bpf_compute_data_pointers(struct
> > > sk_buff *skb)
> > >   	cb->data_end  = skb->data + skb_headlen(skb);
> > >   }
> >
> > > +static __always_inline u32 bpf_prog_run_at_ingress(const struct
> > > bpf_prog *prog,
> > > +						   struct sk_buff *skb)
> > > +{
> > > +	ktime_t tstamp, delivery_time = 0;
> > > +	int filter_res;
> > > +
> > > +	if (unlikely(skb->mono_delivery_time)  
> && !prog->delivery_time_access) {
> > > +		delivery_time = skb->tstamp;
> > > +		skb->mono_delivery_time = 0;
> > > +		if (static_branch_unlikely(&netstamp_needed_key))
> > > +			skb->tstamp = tstamp = ktime_get_real();
> > > +		else
> > > +			skb->tstamp = tstamp = 0;
> > > +	}
> > > +
> > > +	/* It is safe to push/pull even if skb_shared() */
> > > +	__skb_push(skb, skb->mac_len);
> > > +	bpf_compute_data_pointers(skb);
> > > +	filter_res = bpf_prog_run(prog, skb);
> > > +	__skb_pull(skb, skb->mac_len);
> > > +
> > > +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> > > +	if (unlikely(delivery_time) && skb_tstamp(skb) == tstamp)
> > > +		skb_set_delivery_time(skb, delivery_time, true);
> > > +
> > > +	return filter_res;
> > > +}
> > > +
> > >   /* Similar to bpf_compute_data_pointers(), except that save orginal
> > >    * data in cb->data and cb->meta_data for restore.
> > >    */
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index 4677bb6c7279..a14b04b86c13 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -866,22 +866,23 @@ struct sk_buff {
> > >   	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
> > >   	__u8			csum_complete_sw:1;
> > >   	__u8			csum_level:2;
> > > -	__u8			csum_not_inet:1;
> > >   	__u8			dst_pending_confirm:1;
> > > +	__u8			mono_delivery_time:1;
> > > +
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +	__u8			tc_skip_classify:1;
> > > +	__u8			tc_at_ingress:1;
> > > +#endif
> > >   #ifdef CONFIG_IPV6_NDISC_NODETYPE
> > >   	__u8			ndisc_nodetype:2;
> > >   #endif
> > > -
> > > +	__u8			csum_not_inet:1;
> > >   	__u8			ipvs_property:1;
> > >   	__u8			inner_protocol_type:1;
> > >   	__u8			remcsum_offload:1;
> > >   #ifdef CONFIG_NET_SWITCHDEV
> > >   	__u8			offload_fwd_mark:1;
> > >   	__u8			offload_l3_fwd_mark:1;
> > > -#endif
> > > -#ifdef CONFIG_NET_CLS_ACT
> > > -	__u8			tc_skip_classify:1;
> > > -	__u8			tc_at_ingress:1;
> > >   #endif
> > >   	__u8			redirected:1;
> > >   #ifdef CONFIG_NET_REDIRECT
> > > @@ -894,7 +895,6 @@ struct sk_buff {
> > >   	__u8			decrypted:1;
> > >   #endif
> > >   	__u8			slow_gro:1;
> > > -	__u8			mono_delivery_time:1;
> >
> > >   #ifdef CONFIG_NET_SCHED
> > >   	__u16			tc_index;	/* traffic control index */
> > > @@ -972,10 +972,16 @@ struct sk_buff {
> > >   /* if you move pkt_vlan_present around you also must adapt these
> > > constants */
> > >   #ifdef __BIG_ENDIAN_BITFIELD
> > >   #define PKT_VLAN_PRESENT_BIT	7
> > > +#define TC_AT_INGRESS_SHIFT	0
> > > +#define SKB_MONO_DELIVERY_TIME_SHIFT 2
> > >   #else
> > >   #define PKT_VLAN_PRESENT_BIT	0
> > > +#define TC_AT_INGRESS_SHIFT	7
> > > +#define SKB_MONO_DELIVERY_TIME_SHIFT 5
> > >   #endif
> > >   #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff,
> > > __pkt_vlan_present_offset)
> > > +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff,
> > > __pkt_vlan_present_offset)
> > > +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff,
> > > __pkt_vlan_present_offset)
> >
> > >   #ifdef __KERNEL__
> > >   /*
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index b0383d371b9a..83725c891f3c 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -5437,6 +5437,7 @@ struct __sk_buff {
> > >   	__u32 gso_size;
> > >   	__u32 :32;		/* Padding, future use. */
> > >   	__u64 hwtstamp;
> > > +	__u64 mono_delivery_time;
> > >   };
> >
> > >   struct bpf_tunnel_key {
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 4fc53d645a01..db17812f0f8c 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -7832,6 +7832,7 @@ static bool bpf_skb_is_valid_access(int off, int
> > > size, enum bpf_access_type type
> > >   			return false;
> > >   		break;
> > >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> > > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   		if (size != sizeof(__u64))
> > >   			return false;
> > >   		break;
> > > @@ -7872,6 +7873,7 @@ static bool sk_filter_is_valid_access(int off,  
> int
> > > size,
> > >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> > >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> > >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   		return false;
> > >   	}
> >
> > > @@ -7911,6 +7913,7 @@ static bool cg_skb_is_valid_access(int off, int
> > > size,
> > >   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
> > >   			break;
> > >   		case bpf_ctx_range(struct __sk_buff, tstamp):
> > > +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   			if (!bpf_capable())
> > >   				return false;
> > >   			break;
> > > @@ -7943,6 +7946,7 @@ static bool lwt_is_valid_access(int off, int  
> size,
> > >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> > >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> > >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   		return false;
> > >   	}
> >
> > > @@ -8169,6 +8173,7 @@ static bool tc_cls_act_is_valid_access(int off,
> > > int size,
> > >   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
> > >   		case bpf_ctx_range(struct __sk_buff, tstamp):
> > >   		case bpf_ctx_range(struct __sk_buff, queue_mapping):
> > > +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   			break;
> > >   		default:
> > >   			return false;
> > > @@ -8445,6 +8450,7 @@ static bool sk_skb_is_valid_access(int off, int
> > > size,
> > >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> > >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> > >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> > >   		return false;
> > >   	}
> >
> > > @@ -8603,6 +8609,114 @@ static struct bpf_insn
> > > *bpf_convert_shinfo_access(const struct bpf_insn *si,
> > >   	return insn;
> > >   }
> >
> >
> > [..]
> >
> > > +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn
> > > *si,
> > > +						struct bpf_insn *insn)
> > > +{
> > > +	__u8 value_reg = si->dst_reg;
> > > +	__u8 skb_reg = si->src_reg;
> > > +	__u8 tmp_reg = BPF_REG_AX;
> > > +
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,  
> TC_AT_INGRESS_OFFSET);
> > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> > > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
> > > +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
> > > +	 * so check the skb->mono_delivery_time.
> > > +	 */
> > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > > +				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
> > > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
> > > +	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
> > > +	*insn++ = BPF_MOV64_IMM(value_reg, 0);
> > > +	*insn++ = BPF_JMP_A(1);
> > > +#endif
> > > +
> > > +	*insn++ = BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
> > > +			      offsetof(struct sk_buff, tstamp));
> > > +	return insn;
> > > +}
> > > +
> > > +static struct bpf_insn *bpf_convert_tstamp_write(const struct  
> bpf_insn
> > > *si,
> > > +						 struct bpf_insn *insn)
> > > +{
> > > +	__u8 value_reg = si->src_reg;
> > > +	__u8 skb_reg = si->dst_reg;
> > > +	__u8 tmp_reg = BPF_REG_AX;
> > > +
> > > +	/* skb->tstamp = tstamp */
> > > +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> > > +			      offsetof(struct sk_buff, tstamp));
> > > +
> > > +#ifdef CONFIG_NET_CLS_ACT
> > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,  
> TC_AT_INGRESS_OFFSET);
> > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> > > +	*insn++ = BPF_JMP32_IMM(BPF_JNE, tmp_reg, 0, 1);
> > > +#endif
> > > +
> > > +	/* test tstamp != 0 */
> > > +	*insn++ = BPF_JMP_IMM(BPF_JNE, value_reg, 0, 3);
> > > +	/* writing __sk_buff->tstamp at ingress or writing 0,
> > > +	 * clear the skb->mono_delivery_time.
> > > +	 */
> > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > > +				~(1 << SKB_MONO_DELIVERY_TIME_SHIFT));
> > > +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> > > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > > +
> > > +	return insn;
> > > +}
> >
> > I wonder if we'll see the regression from this. We read/write tstamp
> > frequently and I'm not sure we care about the forwarding case.
> >
> > As a future work/follow up, do you think we can support cases like
> > bpf_prog_load(prog_type=SCHED_CLS expected_attach_type=TC_EGRESS) where
> > we can generate bytecode with only BPF_LDX_MEM/BPF_STX_MEM for  
> skb->tstamp?
> > (essentially a bytecode as it was prior to your patch series)
> >
> > Since we know that that specific program will run only at egress,
> > I'm assuming we can generate simpler bytecode? (of coarse it needs more
> > work on cls_bpf to enforce this new expected_attach_type constraint)
> The common (if not the only useful?) use case for reading/writing
> skb->tstamp should be at egress now.  For this case, the patch added
> test on skb->tc_at_ingress and test the writing value is non-zero.  The
> skb->mono_delivery_time bit should not be touched in this common
> case at egress.  Even with expected_attach_type=TC_EGRESS, it could save
> testing the tc_at_ingress (3 bpf insns) but it still needs to test the
> writing value is non-zero (1 bpf insn).  Regardless, I  doubt there
> is any meaningful difference for these two new tests considering other
> things that a typical bpf prog is doing (e.g. parsing header,
> lookup map...) and also other logic in the stack's egress path.

I'm mostly concerned about reading where it seems like we can get back
to single BPF_LDX_MEM at egress. But I agree that I'm probably
over-thinking it and there won't be any extra visible hit due to those
3 insns that test skb->tc_at_ingress.

> For adding expected_attach_type=TC_EGRESS in the future for perf reason
> alone... hmm... I suspect it will make it harder/confuse to use but yeah  
> if
> there is a convincing difference to justify that.

> Unrelated to the perf topic but related to adding expected_attach_type,
> I had considered adding an expected_attach_type but not for the
> perf reason.

> The consideration was to use expected_attach_type to distinguish the
> __sk_buff->tstamp behavior on ingress, although I have a hard time
> thinking of a reasonable use case on accessing __sk_buff->tstamp at  
> ingress
> other than printing the (rcv) timestamp out (which could also be 0).

> However, I guess we have to assume we cannot break the ingress
> behavior now.  The dance in bpf_prog_run_at_ingress() in this patch
> is to keep the (rcv) timestamp behavior for the existing tc-bpf@ingress.
> My initial thought was to add expected_attach_type=TC_DELIVERY_TIME
> to signal the bpf prog is expecting skb->tstamp could have the  
> delviery_time at
> ingress but then later I think learning this in prog->delivery_time_access
> during verification should be as good, so dismissed the  
> expected_attach_type
> idea and save the user from remembering when to use this
> new expected_attach_type.

Yeah, having TC_INGRESS/TC_EGRESS expected_attach_type can be helpful,
maybe something we'll eventually have to do. Could open up things
like rx_tstamp / tx_tstamp in __sk_buff (which can return tstamp or 0
depending on skb->mono_delivery_time). Seems like an improvement over  
current
sometimes-rx-sometimes-tx-tstamp :-)

> Thanks for the review !
