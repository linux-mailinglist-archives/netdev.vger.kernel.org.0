Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CED6D0DCF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjC3Sfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjC3Sfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:35:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE71B47F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:35:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s9-20020a634509000000b004fc1c14c9daso5795510pga.23
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680201340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ8KMmzZMobHnGFo0ko1eaVfakeUKqQliIoetDZ8YRE=;
        b=WgMZHweAIlvltzKw/+MMymuPl6RB4LL5CZYBxU4/ZD0skm5UDSzptayGoOpbfYINCi
         F4omkDCzLPbqgAxfokotNM3r7etG66+xL/trzKuF6wsdjRVxXvTOuCuM6HhhGSsnOX6G
         5ho/ZaMQNij5T/GjQVITrS6W+5MrPFgc5nEF4CILv5rSuqDvL/mEXWQ8D34L2uM3pXd/
         61qag+QhuH6AGSM11jyqfbr3pBmzCG80rt7SezTrXXpK5aPMpBSJ53baGNSu/GZME5QO
         sXSvq/ZUXH/umvLjnwiaghxQyglWLWHB4dvypDqXOseKdcjIAfmHat3cckTmOmQg9aPy
         MK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680201340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ8KMmzZMobHnGFo0ko1eaVfakeUKqQliIoetDZ8YRE=;
        b=HaUOtN0ZKdEm4vEDsHEJmrTZgsVNuFVqXM43zQob8GI0TC7wZgSdb9g8ByefO5DBi1
         ivStQkv/ZNkcGdPQ9FaxzGDnJCY/jvLOrnPEI3rpGk8k4gu6+CcZ0HzwMPVZWyBvzH7F
         kWrCs5ufIJDrfjzNUpVg7TxKeVZRfiDIgu3KW5cR65j61jlS6AG8yfFj2ILr/U1EiSqn
         RrIE5VUwjOy2N0JKlFEPLhFZo8SJucOnvxLIEEf/DLQelJu0r6wOTbQPVc7IXhTMD1/n
         aGtjyDF0JCI+AAbwj1Yu7qItMuBwy3RHcZREn4jQKaWCe2964nl6+4uoAJfINRlRnZt1
         tPzA==
X-Gm-Message-State: AAQBX9edlcYI+nXezjBSSqbrG17rcezVkO2mSUXqEhZNaazuZb1VO0vw
        Cd7cgROyVCau+TSJsmUGhgFFO14=
X-Google-Smtp-Source: AKy350YQ6/8gUx3E8iyg+pu8q3ARXIx8GYJQPh6U8FgTFFppyvYT8YPMwoiIG8aW+ins6SCLDnqLojs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:1c3:0:b0:513:5162:a692 with SMTP id
 186-20020a6301c3000000b005135162a692mr2124246pgb.5.1680201340149; Thu, 30 Mar
 2023 11:35:40 -0700 (PDT)
Date:   Thu, 30 Mar 2023 11:35:38 -0700
In-Reply-To: <168019606574.3557870.15629824904085210321.stgit@firesoul>
Mime-Version: 1.0
References: <168019602958.3557870.9960387532660882277.stgit@firesoul> <168019606574.3557870.15629824904085210321.stgit@firesoul>
Message-ID: <ZCXWerysZL1XwVfX@google.com>
Subject: Re: [PATCH bpf RFC-V3 1/5] xdp: rss hash types representation
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
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

On 03/30, Jesper Dangaard Brouer wrote:
> The RSS hash type specifies what portion of packet data NIC hardware used
> when calculating RSS hash value. The RSS types are focused on Internet
> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
> primarily TCP vs UDP, but some hardware supports SCTP.

> Hardware RSS types are differently encoded for each hardware NIC. Most
> hardware represent RSS hash type as a number. Determining L3 vs L4 often
> requires a mapping table as there often isn't a pattern or sorting
> according to ISO layer.

> The patch introduce a XDP RSS hash type (enum xdp_rss_hash_type) that
> contain combinations to be used by drivers, which gets build up with bits
> from enum xdp_rss_type_bits. Both enum xdp_rss_type_bits and
> xdp_rss_hash_type get exposed to BPF via BTF, and it is up to the
> BPF-programmer to match using these defines.

> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() adding
> a pointer value argument for provide the RSS hash type.

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/linux/netdevice.h |    3 ++-
>   include/net/xdp.h         |   46  
> +++++++++++++++++++++++++++++++++++++++++++++
>   net/core/xdp.c            |   10 +++++++++-
>   3 files changed, 57 insertions(+), 2 deletions(-)

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 470085b121d3..c35f04f636f1 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1624,7 +1624,8 @@ struct net_device_ops {

>   struct xdp_metadata_ops {
>   	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
> -	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash);
> +	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash,
> +			       enum xdp_rss_hash_type *rss_type);
>   };

>   /**
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 41c57b8b1671..130091a55a6f 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -8,6 +8,7 @@

>   #include <linux/skbuff.h> /* skb_shared_info */
>   #include <uapi/linux/netdev.h>
> +#include <linux/bitfield.h>

>   /**
>    * DOC: XDP RX-queue information
> @@ -425,6 +426,51 @@ XDP_METADATA_KFUNC_xxx
>   MAX_XDP_METADATA_KFUNC,
>   };

> +enum xdp_rss_type_bits {
> +	XDP_RSS_L3_IPV4		= BIT(0),
> +	XDP_RSS_L3_IPV6		= BIT(1),
> +
> +	/* The fixed (L3) IPv4 and IPv6 headers can both be followed by
> +	 * variable/dynamic headers, IPv4 called Options and IPv6 called
> +	 * Extension Headers. HW RSS type can contain this info.
> +	 */
> +	XDP_RSS_L3_DYNHDR	= BIT(2),
> +
> +	/* When RSS hash covers L4 then drivers MUST set XDP_RSS_L4 bit in
> +	 * addition to the protocol specific bit.  This ease interaction with
> +	 * SKBs and avoids reserving a fixed mask for future L4 protocol bits.
> +	 */
> +	XDP_RSS_L4		= BIT(3), /* L4 based hash, proto can be unknown */
> +	XDP_RSS_L4_TCP		= BIT(4),
> +	XDP_RSS_L4_UDP		= BIT(5),
> +	XDP_RSS_L4_SCTP		= BIT(6),
> +	XDP_RSS_L4_IPSEC	= BIT(7), /* L4 based hash include IPSEC SPI */
> +};
> +
> +/* RSS hash type combinations used for driver HW mapping */
> +enum xdp_rss_hash_type {
> +	XDP_RSS_TYPE_NONE            = 0,
> +	XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
> +
> +	XDP_RSS_TYPE_L3_IPV4         = XDP_RSS_L3_IPV4,
> +	XDP_RSS_TYPE_L3_IPV6         = XDP_RSS_L3_IPV6,
> +	XDP_RSS_TYPE_L3_IPV4_OPT     = XDP_RSS_L3_IPV4 | XDP_RSS_L3_DYNHDR,
> +	XDP_RSS_TYPE_L3_IPV6_EX      = XDP_RSS_L3_IPV6 | XDP_RSS_L3_DYNHDR,
> +
> +	XDP_RSS_TYPE_L4_ANY          = XDP_RSS_L4,
> +	XDP_RSS_TYPE_L4_IPV4_TCP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4 |  
> XDP_RSS_L4_TCP,
> +	XDP_RSS_TYPE_L4_IPV4_UDP     = XDP_RSS_L3_IPV4 | XDP_RSS_L4 |  
> XDP_RSS_L4_UDP,
> +	XDP_RSS_TYPE_L4_IPV4_SCTP    = XDP_RSS_L3_IPV4 | XDP_RSS_L4 |  
> XDP_RSS_L4_SCTP,
> +
> +	XDP_RSS_TYPE_L4_IPV6_TCP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4 |  
> XDP_RSS_L4_TCP,
> +	XDP_RSS_TYPE_L4_IPV6_UDP     = XDP_RSS_L3_IPV6 | XDP_RSS_L4 |  
> XDP_RSS_L4_UDP,
> +	XDP_RSS_TYPE_L4_IPV6_SCTP    = XDP_RSS_L3_IPV6 | XDP_RSS_L4 |  
> XDP_RSS_L4_SCTP,
> +
> +	XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP | 
> XDP_RSS_L3_DYNHDR,
> +	XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP | 
> XDP_RSS_L3_DYNHDR,
> +	XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP| 
> XDP_RSS_L3_DYNHDR,
> +};
> +
>   #ifdef CONFIG_NET
>   u32 bpf_xdp_metadata_kfunc_id(int id);
>   bool bpf_dev_bound_kfunc_id(u32 btf_id);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 528d4b37983d..38d2dee16b47 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -734,14 +734,22 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const  
> struct xdp_md *ctx, u64 *tim
>    * bpf_xdp_metadata_rx_hash - Read XDP frame RX hash.
>    * @ctx: XDP context pointer.
>    * @hash: Return value pointer.
> + * @rss_type: Return value pointer for RSS type.
> + *
> + * The RSS hash type (@rss_type) specifies what portion of packet  
> headers NIC
> + * hardware were used when calculating RSS hash value.  The type  
> combinations
> + * are defined via &enum xdp_rss_hash_type and individual bits can be  
> decoded
> + * via &enum xdp_rss_type_bits.
>    *
>    * Return:
>    * * Returns 0 on success or ``-errno`` on error.
>    * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
>    * * ``-ENODATA``    : means no RX-hash available for this frame
>    */
> -__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32  
> *hash)
> +__bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32  
> *hash,
> +					 enum xdp_rss_hash_type *rss_type)
>   {

[..]

> +	BTF_TYPE_EMIT(enum xdp_rss_type_bits);

nit: Do we still need this with an extra argument?

>   	return -EOPNOTSUPP;
>   }



