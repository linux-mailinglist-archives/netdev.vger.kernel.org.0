Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4066238AB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiKJBJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiKJBJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:09:49 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE06122B19;
        Wed,  9 Nov 2022 17:09:48 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l6so454035pjj.0;
        Wed, 09 Nov 2022 17:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfGRQSQzWUcWHhvGx9OcAXO2iDI/IcDCnXDogLAUWrU=;
        b=DjGzFxHU92SJ1Gorpoke4BoaJBROgNrQVyi2XHrmoh0+Y+habO59OgPQWGNQYk3l+f
         nBD80oZecQ/P34mc0092Y29YToE6LuaZB4CilD+TaNPwvPmyPftxsMAIx2NRH+BzXGCP
         gvFvBJSDLG3STOnkXiO/9GQWTV2bpzWRKBaFSMkJBCDNWnjjRvr7Y1jPyuQge2P2o9k6
         b8hW/WpdZGB1IchOV055IDTl4VMVQWEiicCP/xj4vdkT4IeMa7uupdPjc8vjV3gFBz6v
         d7Hm45bFIhzIJ/pTtzGefCevcG1gzu3qwR/rVE/SHPGXt1NE4GBfdfyO9R82hIqV06MZ
         LeuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DfGRQSQzWUcWHhvGx9OcAXO2iDI/IcDCnXDogLAUWrU=;
        b=wunAU4zc8r2ZBRknr/sqPQoObvhGRQJ0s1Pg3yi8lx8JJyY3EPVjsEDod0A94yAc85
         /5WvjBLqOp+ihrGMLh/t2tJTEYtDw/cww5Wbwe3BAwpPJ/iH588yr4+VkO3wBRH0R+t3
         LqxGjbNqpgFzS7u2oO/mXJIQ7Cwp1FuxuiECo34l+TlgFw1v96Jjv01eqTdqdlpVoW6H
         emKM30ts6kd1ZR58g7KPjqk9Pmk8VmBezxq9hMbTkW3kP9H49m95Mie2EcG37myguHQv
         GtSRM9ecNfECsuquZ557h2Z2m+Bq1+yXwZh6zg1rg3f76ndHJYRGQUk6kwRTjLz66HcE
         KTbA==
X-Gm-Message-State: ACrzQf2tEfRZ8pGNrofEs11OoBRHLpA0tJlRnzisTkmhE6ApBAVvCCwO
        8DcQfpy9u/EGWf5Qhupzj60=
X-Google-Smtp-Source: AMsMyM5DvZe68MCMKHJgldaKsX8W912cS0fByo9Z5Nhpztw6yP8XPnoDywvRgyvUzNZem2eB56O4Ww==
X-Received: by 2002:a17:90a:ce89:b0:213:167c:81e1 with SMTP id g9-20020a17090ace8900b00213167c81e1mr82528113pju.38.1668042588126;
        Wed, 09 Nov 2022 17:09:48 -0800 (PST)
Received: from localhost ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id y2-20020a626402000000b005632f6490aasm8862701pfb.77.2022.11.09.17.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:09:47 -0800 (PST)
Date:   Wed, 09 Nov 2022 17:09:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <636c4f5a3812f_13c9f4208b1@john.notmuch>
In-Reply-To: <20221104032532.1615099-7-sdf@google.com>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
Subject: RE: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb
 context
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> Implement new bpf_xdp_metadata_export_to_skb kfunc which
> prepares compatible xdp metadata for kernel consumption.
> This kfunc should be called prior to bpf_redirect
> or (unless already called) when XDP_PASS'ing the frame
> into the kernel.

Hi,

Had a couple high level questions so starting a new thread thought
it would be more confusing than helpful to add to the thread on
this patch.

> 
> The implementation currently maintains xdp_to_skb_metadata
> layout by calling bpf_xdp_metadata_rx_timestamp and placing
> small magic number. From skb_metdata_set, when we get expected magic number,
> we interpret metadata accordingly.

From commit message side I'm not able to parse this paragraph without
reading code. Maybe expand it a bit for next version or it could
just be me.

> 
> Both magic number and struct layout are randomized to make sure
> it doesn't leak into the userspace.

Are we worried about leaking pointers into XDP program here? We already
leak pointers into XDP through helpers so I'm not sure it matters.

> 
> skb_metadata_set is amended with skb_metadata_import_from_xdp which
> tries to parse out the metadata and put it into skb.
> 
> See the comment for r1 vs r2/r3/r4/r5 conventions.

I think for next version an expanded commit message with use
cases would help. I had to follow the thread to get some ideas
why this might be useful.

> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/veth.c        |   4 +-
>  include/linux/bpf_patch.h |   2 +
>  include/linux/skbuff.h    |   4 ++
>  include/net/xdp.h         |  13 +++++
>  kernel/bpf/bpf_patch.c    |  30 +++++++++++
>  kernel/bpf/verifier.c     |  18 +++++++
>  net/core/skbuff.c         |  25 +++++++++
>  net/core/xdp.c            | 104 +++++++++++++++++++++++++++++++++++---
>  8 files changed, 193 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 0e629ceb087b..d4cd0938360b 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1673,7 +1673,9 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
>  			      struct bpf_patch *patch)
>  {
> -	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
> +		return xdp_metadata_export_to_skb(prog, patch);
> +	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
>  		/* return true; */
>  		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
>  	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> diff --git a/include/linux/bpf_patch.h b/include/linux/bpf_patch.h
> index 81ff738eef8d..359c165ad68b 100644
> --- a/include/linux/bpf_patch.h
> +++ b/include/linux/bpf_patch.h
> @@ -16,6 +16,8 @@ size_t bpf_patch_len(const struct bpf_patch *patch);
>  int bpf_patch_err(const struct bpf_patch *patch);
>  void __bpf_patch_append(struct bpf_patch *patch, struct bpf_insn insn);
>  struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch);
> +void bpf_patch_resolve_jmp(struct bpf_patch *patch);
> +u32 bpf_patch_magles_registers(const struct bpf_patch *patch);
>  
>  #define bpf_patch_append(patch, ...) ({ \
>  	struct bpf_insn insn[] = { __VA_ARGS__ }; \
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 59c9fd55699d..dba857f212d7 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
>  	       true : __skb_metadata_differs(skb_a, skb_b, len_a);
>  }
>  
> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
> +
>  static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
>  {
>  	skb_shinfo(skb)->meta_len = meta_len;
> +	if (meta_len)
> +		skb_metadata_import_from_xdp(skb, meta_len);
>  }
>  
>  static inline void skb_metadata_clear(struct sk_buff *skb)
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 2a82a98f2f9f..8c97c6996172 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -411,6 +411,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
>  #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
>  
>  #define XDP_METADATA_KFUNC_xxx	\
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_EXPORT_TO_SKB, \
> +			   bpf_xdp_metadata_export_to_skb) \
>  	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
>  			   bpf_xdp_metadata_rx_timestamp_supported) \
>  	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> @@ -423,14 +425,25 @@ XDP_METADATA_KFUNC_xxx
>  MAX_XDP_METADATA_KFUNC,
>  };
>  
> +struct xdp_to_skb_metadata {
> +	u32 magic; /* xdp_metadata_magic */
> +	u64 rx_timestamp;

Slightly confused. I thought/think most drivers populate the skb timestamp
if they can already? So why do we need to bounce these through some xdp
metadata? Won't all this cost more than the load/store directly from the
descriptor into the skb? Even if drivers are not populating skb now
shouldn't an ethtool knob be enough to turn this on?

I don't see the value of getting this in veth side its just a sw
timestamp there.

If its specific to cpumap shouldn't we land this in cpumap code paths
out of general XDP code paths?


> +} __randomize_layout;
> +
> +struct bpf_patch;
> +
>  #ifdef CONFIG_DEBUG_INFO_BTF
> +extern u32 xdp_metadata_magic;
>  extern struct btf_id_set8 xdp_metadata_kfunc_ids;
>  static inline u32 xdp_metadata_kfunc_id(int id)
>  {
>  	return xdp_metadata_kfunc_ids.pairs[id].id;
>  }
> +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
>  #else
> +#define xdp_metadata_magic 0
>  static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> +static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
>  #endif
>  
>  #endif /* __LINUX_NET_XDP_H__ */
> diff --git a/kernel/bpf/bpf_patch.c b/kernel/bpf/bpf_patch.c
> index 82a10bf5624a..8f1fef74299c 100644
> --- a/kernel/bpf/bpf_patch.c
> +++ b/kernel/bpf/bpf_patch.c
> @@ -49,3 +49,33 @@ struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch)
>  {
>  	return patch->insn;
>  }

[...]

>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 42a35b59fb1e..37e3aef46525 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -72,6 +72,7 @@
>  #include <net/mptcp.h>
>  #include <net/mctp.h>
>  #include <net/page_pool.h>
> +#include <net/xdp.h>
>  
>  #include <linux/uaccess.h>
>  #include <trace/events/skb.h>
> @@ -6672,3 +6673,27 @@ nodefer:	__kfree_skb(skb);
>  	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
>  		smp_call_function_single_async(cpu, &sd->defer_csd);
>  }
> +
> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len)
> +{
> +	struct xdp_to_skb_metadata *meta = (void *)(skb_mac_header(skb) - len);
> +
> +	/* Optional SKB info, currently missing:
> +	 * - HW checksum info		(skb->ip_summed)
> +	 * - HW RX hash			(skb_set_hash)
> +	 * - RX ring dev queue index	(skb_record_rx_queue)
> +	 */
> +
> +	if (len != sizeof(struct xdp_to_skb_metadata))
> +		return;
> +
> +	if (meta->magic != xdp_metadata_magic)
> +		return;
> +
> +	if (meta->rx_timestamp) {
> +		*skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
> +			.hwtstamp = ns_to_ktime(meta->rx_timestamp),
> +		};
> +	}
> +}
> +EXPORT_SYMBOL(skb_metadata_import_from_xdp);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 22f1e44700eb..8204fa05c5e9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -653,12 +653,6 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>  	/* Essential SKB info: protocol and skb->dev */
>  	skb->protocol = eth_type_trans(skb, dev);
>  
> -	/* Optional SKB info, currently missing:
> -	 * - HW checksum info		(skb->ip_summed)
> -	 * - HW RX hash			(skb_set_hash)
> -	 * - RX ring dev queue index	(skb_record_rx_queue)
> -	 */
> -
>  	/* Until page_pool get SKB return path, release DMA here */
>  	xdp_release_frame(xdpf);
>  
> @@ -712,6 +706,13 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
>  	return nxdpf;
>  }
>  
> +/* For the packets directed to the kernel, this kfunc exports XDP metadata
> + * into skb context.
> + */
> +noinline void bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
> +{
> +}
> +
>  /* Indicates whether particular device supports rx_timestamp metadata.
>   * This is an optional helper to support marking some branches as
>   * "dead code" in the BPF programs.
> @@ -737,13 +738,104 @@ XDP_METADATA_KFUNC_xxx
>  #undef XDP_METADATA_KFUNC
>  BTF_SET8_END(xdp_metadata_kfunc_ids)
>  
> +/* Make sure userspace doesn't depend on our layout by using
> + * different pseudo-generated magic value.
> + */
> +u32 xdp_metadata_magic;
> +
>  static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
>  	.owner = THIS_MODULE,
>  	.set   = &xdp_metadata_kfunc_ids,
>  };
>  
> +/* Since we're not actually doing a call but instead rewriting
> + * in place, we can only afford to use R0-R5 scratch registers.

Why not just do a call? Its neat to inline this but your going
to build an skb next. Thats not cheap and the cost of a call
should be complete noise when hitting the entire stack?

Any benchmark to convince us this is worthwhile optimizations?

> + *
> + * We reserve R1 for bpf_xdp_metadata_export_to_skb and let individual
> + * metadata kfuncs use only R0,R4-R5.
> + *
> + * The above also means we _cannot_ easily call any other helper/kfunc
> + * because there is no place for us to preserve our R1 argument;
> + * existing R6-R9 belong to the callee.
> + */
> +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
> +{

[...]

>  }
>  late_initcall(xdp_metadata_init);

Thanks,
John


