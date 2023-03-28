Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8846CCC76
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjC1V64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjC1V6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:58:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822E194
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:58:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x3-20020a62fb03000000b00622df3f5d0cso6384817pfm.10
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680040734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8yYfTRlVy8+a3jmgxVqWb3McvAzlOI0eWzfqMDXbjb8=;
        b=lQWr9ruWMNQzFwN+NqZhX+ZsQWL/uLkGdtGW//t2mxE5ASz7x0PvQ2GqN8PtUnIYTi
         LisiskLnzotzHe2F6xJD5Rr2Tl1ymDuahcNDHi33lsFk1p+7Rf8iRzRM20VEreK5MVhO
         lOkTGxRbesKwLf1dV1fwYPNJp00cmV10bDcZQncPTL7hyy7th2Ukcvbks8ju/7eHY0XV
         joBA0mxBfn7WhixeqYWCwXMons8geOV7uCMeYFI9bwv8GxIUUGi7ltjPouJiyyks/fZB
         2OeVe0TN0eMB9dj2Ty6mrYZFIHX4udnYHVvpWFEaaNcVOMB2A+p/MNIf5xA6MnfRsMaQ
         v3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680040734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8yYfTRlVy8+a3jmgxVqWb3McvAzlOI0eWzfqMDXbjb8=;
        b=L/h296mdzuA0xKby4Yvs+mLsBjK3/ceoYlb1HSk3zps5IQDK2es7Fd/A6Eamx0skdL
         55QMvNlxqGc+xWeP8PkWpVXvqx9tWnp/HV40PmeQTF2iZxtKg/1GX9NZoANHfA29uUGi
         Jc44z4Rby2ABDj7oul8CDlSpymR7ksrORu1dr0Q1OQGSFGhwv1Fg6GcOvSROozxlDkC/
         7ZRWZC+iDEPF01/YJZeVr/ewhv6s5MfHPpMkV6KedZ3siLM5ZAT7Gj7ALwxm8xtQuVRE
         CP7LRM2axXgx7BHqnyVrJCuYYoP1CkQNQNfx+daYAuj0jpePOsVRbaW8xmljWHLH320c
         4iXQ==
X-Gm-Message-State: AAQBX9fEww9iJSI/HfCaO49HzDAYLfZETO01QtC5GtRKDdyv3Nevew0K
        bm9m4QO5IqU7mHTIY5IxnlHJURU=
X-Google-Smtp-Source: AKy350aeM1DJXTixgfwMy9Tmk+d6l64HsTntHsGf93MuO5cskm0HFqWDJcVdNNqftsvPIS5nvLMBCfg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1414:b0:625:96ce:f774 with SMTP id
 l20-20020a056a00141400b0062596cef774mr9000445pfu.0.1680040733979; Tue, 28 Mar
 2023 14:58:53 -0700 (PDT)
Date:   Tue, 28 Mar 2023 14:58:52 -0700
In-Reply-To: <168003455815.3027256.7575362149566382055.stgit@firesoul>
Mime-Version: 1.0
References: <168003451121.3027256.13000250073816770554.stgit@firesoul> <168003455815.3027256.7575362149566382055.stgit@firesoul>
Message-ID: <ZCNjHAY81gS02FVW@google.com>
Subject: Re: [PATCH bpf RFC 1/4] xdp: rss hash types representation
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/28, Jesper Dangaard Brouer wrote:
> The RSS hash type specifies what portion of packet data NIC hardware used
> when calculating RSS hash value. The RSS types are focused on Internet
> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
> primarily TCP vs UDP, but some hardware supports SCTP.

> Hardware RSS types are differently encoded for each hardware NIC. Most
> hardware represent RSS hash type as a number. Determining L3 vs L4 often
> requires a mapping table as there often isn't a pattern or sorting
> according to ISO layer.

> The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
> be seen as a number that is ordered according by ISO layer, and can be bit
> masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
> for extending later while keeping these properties. This maps and unifies
> difference to hardware specific hashes.

Looks good overall. Any reason we're making this specific layout?
Why not simply the following?

enum {
	XDP_RSS_TYPE_NONE = 0,
	XDP_RSS_TYPE_IPV4 = BIT(0),
	XDP_RSS_TYPE_IPV6 = BIT(1),
	/* IPv6 with extension header. */
	/* let's note ^^^ it in the UAPI? */
	XDP_RSS_TYPE_IPV6_EX = BIT(2),
	XDP_RSS_TYPE_UDP = BIT(3),
	XDP_RSS_TYPE_TCP = BIT(4),
	XDP_RSS_TYPE_SCTP = BIT(5),
}

And then using XDP_RSS_TYPE_IPV4|XDP_RSS_TYPE_UDP vs XDP_RSS_TYPE_IPV6|XXX ?

> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() to return
> this RSS hash type on success.

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/net/xdp.h |   51  
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>   net/core/xdp.c    |    4 +++-
>   2 files changed, 54 insertions(+), 1 deletion(-)

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 5393b3ebe56e..63f462f5ea7f 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -8,6 +8,7 @@

>   #include <linux/skbuff.h> /* skb_shared_info */
>   #include <uapi/linux/netdev.h>
> +#include <linux/bitfield.h>

>   /**
>    * DOC: XDP RX-queue information
> @@ -396,6 +397,56 @@ XDP_METADATA_KFUNC_xxx
>   MAX_XDP_METADATA_KFUNC,
>   };

> +/* For partitioning of xdp_rss_hash_type */
> +#define RSS_L3		GENMASK(2,0) /* 3-bits = values between 1-7 */
> +#define L4_BIT		BIT(3)       /* 1-bit - L4 indication */
> +#define RSS_L4_IPV4	GENMASK(6,4) /* 3-bits */
> +#define RSS_L4_IPV6	GENMASK(9,7) /* 3-bits */
> +#define RSS_L4		GENMASK(9,3) /* = 7-bits - covering L4 IPV4+IPV6 */
> +#define L4_IPV6_EX_BIT	BIT(9)       /* 1-bit - L4 IPv6 with Extension  
> hdr */
> +				     /* 11-bits in total */
> +
> +/* The XDP RSS hash type (xdp_rss_hash_type) can both be seen as a  
> number that
> + * is ordered according by ISO layer, and can be bit masked to separate  
> IPv4 and
> + * IPv6 types for L4 protocols. Room is available for extending later  
> while
> + * keeping above properties, as this need to cover NIC hardware RSS  
> types.
> + */
> +enum xdp_rss_hash_type {
> +	XDP_RSS_TYPE_NONE            = 0,
> +	XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
> +
> +	XDP_RSS_TYPE_L3_MASK         = RSS_L3,
> +	XDP_RSS_TYPE_L3_IPV4         = FIELD_PREP_CONST(RSS_L3, 1),
> +	XDP_RSS_TYPE_L3_IPV6         = FIELD_PREP_CONST(RSS_L3, 2),
> +	XDP_RSS_TYPE_L3_IPV6_EX      = FIELD_PREP_CONST(RSS_L3, 4),
> +
> +	XDP_RSS_TYPE_L4_MASK         = RSS_L4,
> +	XDP_RSS_TYPE_L4_SHIFT        = __bf_shf(RSS_L4),
> +	XDP_RSS_TYPE_L4_MASK_EX      = RSS_L4 | L4_IPV6_EX_BIT,
> +
> +	XDP_RSS_TYPE_L4_IPV4_MASK    = RSS_L4_IPV4,
> +	XDP_RSS_TYPE_L4_BIT          = L4_BIT,
> +	XDP_RSS_TYPE_L4_IPV4_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 1),
> +	XDP_RSS_TYPE_L4_IPV4_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 2),
> +	XDP_RSS_TYPE_L4_IPV4_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 3),
> +
> +	XDP_RSS_TYPE_L4_IPV6_MASK    = RSS_L4_IPV6,
> +	XDP_RSS_TYPE_L4_IPV6_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 1),
> +	XDP_RSS_TYPE_L4_IPV6_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 2),
> +	XDP_RSS_TYPE_L4_IPV6_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 3),
> +
> +	XDP_RSS_TYPE_L4_IPV6_EX_MASK = L4_IPV6_EX_BIT,
> +	XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP |L4_IPV6_EX_BIT,
> +	XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP |L4_IPV6_EX_BIT,
> +	XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP|L4_IPV6_EX_BIT,
> +};
> +#undef RSS_L3
> +#undef L4_BIT
> +#undef RSS_L4_IPV4
> +#undef RSS_L4_IPV6
> +#undef RSS_L4
> +#undef L4_IPV6_EX_BIT
> +
>   #ifdef CONFIG_NET
>   u32 bpf_xdp_metadata_kfunc_id(int id);
>   bool bpf_dev_bound_kfunc_id(u32 btf_id);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 7133017bcd74..81d41df30695 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -721,12 +721,14 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const  
> struct xdp_md *ctx, u64 *tim
>    * @hash: Return value pointer.
>    *
>    * Return:
> - * * Returns 0 on success or ``-errno`` on error.
> + * * Returns (positive) RSS hash **type** on success or ``-errno`` on  
> error.
> + * * ``enum xdp_rss_hash_type`` : RSS hash type
>    * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
>    * * ``-ENODATA``    : means no RX-hash available for this frame
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32  
> *hash)
>   {
> +	BTF_TYPE_EMIT(enum xdp_rss_hash_type);
>   	return -EOPNOTSUPP;
>   }



