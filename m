Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83D939A4E1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFCPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:42:36 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:56093 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhFCPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:42:36 -0400
Received: by mail-qt1-f201.google.com with SMTP id s11-20020ac8758b0000b029020e731296abso2727904qtq.22
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ylXTyxpFYn3LQgYPukgqBuWSxwDoIQ/GM2WEa6oXcPc=;
        b=Z0M5UdVLAie4Kz2qi2JmGCK7H1nmqBJIsDCXfCveGhFazpe5bVaYDNgvW8jrVs/lA2
         fbhcQTBA+B1gQycOUgrkfWeMdjvSNODrzQ0ojjA5PDOJSFTI26jfi9Wjln7GOFu2mnge
         N1AjftmimA0TX4+HRKRZUgWE2vHsnA0nutr+al+N6AJxp6ORDr/TtH3bte6RG1gelP4z
         SwZaz2qG86d8hWSQiTGewwHGMfpbwyF8sLsHuqxKnEg714XXYqc43WoSRc4YfhVr8Phd
         +YgCKzOW9cSnkYeicPWiViif+lFpIZNIfuGxIOB09k5kfZypnY+ZD2mmXzDQteQxEYqs
         3Rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ylXTyxpFYn3LQgYPukgqBuWSxwDoIQ/GM2WEa6oXcPc=;
        b=X9XbJoDz6jfJ21ujiP/d3mPFwbce23x4stJ1AtC04AsENlvD/2Ni3A1MFosr740dXA
         3/wTF58B28AhmWZ/YURcyaNhtbS1XxvLZeXcr3UtfZOXi+1vyoCgtJZju71jisX+Qzod
         IyXsQmLWATLZC32j7UqDxJmcaeFLaTySOYhTw76i67JfSce2sj+Y+0QvanKz0EuO6I8M
         vHu3wULsZMD37il0vknkUM90EpbrlMFs3Xyq7YVkbhKwJEA5I1+LNW8Ko/gDH3vPyIX3
         67Rmq4G1kQiTN6DhC+rHiECcOoVB7MFhFcAtjYRqSIQUkCp55ULmBiv/Dph/XIR1lRkP
         TD1w==
X-Gm-Message-State: AOAM531hEovecYoUZ3UuL5DCFQULcpbrjkPyryYAS0da0YYwbChepLlS
        kBLEf3k7DXa0Ghdba0q9jHZzg+I=
X-Google-Smtp-Source: ABdhPJyEuWjJh/n0LQykDQMN1HhV/NPolL5VymF8E1YE6jxna3GLaSZAhPkJ102sdF8UMPi9V2I06nY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:9d0a:7a1b:c5e:c9f])
 (user=sdf job=sendgmr) by 2002:a0c:e752:: with SMTP id g18mr57915qvn.24.1622734775800;
 Thu, 03 Jun 2021 08:39:35 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:39:33 -0700
In-Reply-To: <20210601221841.1251830-2-tannerlove.kernel@gmail.com>
Message-Id: <YLj3tX141kQFkm+N@google.com>
Mime-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com> <20210601221841.1251830-2-tannerlove.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
From:   sdf@google.com
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>

> Amend the bpf flow dissector program type to accept virtio_net_hdr
> members. Do this to enable bpf flow dissector programs to perform
> virtio-net header validation. The next patch in this series will add
> a flow dissection hook in virtio_net_hdr_to_skb and make use of this
> extended functionality. That commit message has more background on the
> use case.

> Signed-off-by: Tanner Love <tannerlove@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Petar Penkov <ppenkov@google.com>
> ---
>   drivers/net/bonding/bond_main.c |  2 +-
>   include/linux/skbuff.h          | 26 ++++++++++++----
>   include/net/flow_dissector.h    |  6 ++++
>   include/uapi/linux/bpf.h        |  6 ++++
>   net/core/filter.c               | 55 +++++++++++++++++++++++++++++++++
>   net/core/flow_dissector.c       | 24 ++++++++++++--
>   tools/include/uapi/linux/bpf.h  |  6 ++++
>   7 files changed, 116 insertions(+), 9 deletions(-)

> diff --git a/drivers/net/bonding/bond_main.c  
> b/drivers/net/bonding/bond_main.c
> index 7e469c203ca5..5d2d7d5c5704 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3554,7 +3554,7 @@ static bool bond_flow_dissect(struct bonding *bond,  
> struct sk_buff *skb,
>   	case BOND_XMIT_POLICY_ENCAP34:
>   		memset(fk, 0, sizeof(*fk));
>   		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
> -					  fk, NULL, 0, 0, 0, 0);
> +					  fk, NULL, 0, 0, 0, 0, NULL);
>   	default:
>   		break;
>   	}
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index dbf820a50a39..fef8f4b5db6e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1312,18 +1312,20 @@ struct bpf_flow_dissector;
>   bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector  
> *ctx,
>   		      __be16 proto, int nhoff, int hlen, unsigned int flags);

> +struct virtio_net_hdr;
>   bool __skb_flow_dissect(const struct net *net,
>   			const struct sk_buff *skb,
>   			struct flow_dissector *flow_dissector,
>   			void *target_container, const void *data,
> -			__be16 proto, int nhoff, int hlen, unsigned int flags);
> +			__be16 proto, int nhoff, int hlen, unsigned int flags,
> +			const struct virtio_net_hdr *vhdr);

>   static inline bool skb_flow_dissect(const struct sk_buff *skb,
>   				    struct flow_dissector *flow_dissector,
>   				    void *target_container, unsigned int flags)
>   {
>   	return __skb_flow_dissect(NULL, skb, flow_dissector,
> -				  target_container, NULL, 0, 0, 0, flags);
> +				  target_container, NULL, 0, 0, 0, flags, NULL);
>   }

>   static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
> @@ -1332,7 +1334,20 @@ static inline bool  
> skb_flow_dissect_flow_keys(const struct sk_buff *skb,
>   {
>   	memset(flow, 0, sizeof(*flow));
>   	return __skb_flow_dissect(NULL, skb, &flow_keys_dissector,
> -				  flow, NULL, 0, 0, 0, flags);
> +				  flow, NULL, 0, 0, 0, flags, NULL);
> +}
> +
> +static inline bool
> +__skb_flow_dissect_flow_keys_basic(const struct net *net,
> +				   const struct sk_buff *skb,
> +				   struct flow_keys_basic *flow,
> +				   const void *data, __be16 proto,
> +				   int nhoff, int hlen, unsigned int flags,
> +				   const struct virtio_net_hdr *vhdr)
> +{
> +	memset(flow, 0, sizeof(*flow));
> +	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
> +				  data, proto, nhoff, hlen, flags, vhdr);
>   }

>   static inline bool
> @@ -1342,9 +1357,8 @@ skb_flow_dissect_flow_keys_basic(const struct net  
> *net,
>   				 const void *data, __be16 proto,
>   				 int nhoff, int hlen, unsigned int flags)
>   {
> -	memset(flow, 0, sizeof(*flow));
> -	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
> -				  data, proto, nhoff, hlen, flags);
> +	return __skb_flow_dissect_flow_keys_basic(net, skb, flow, data, proto,
> +						  nhoff, hlen, flags, NULL);
>   }

>   void skb_flow_dissect_meta(const struct sk_buff *skb,
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index ffd386ea0dbb..0796ad745e69 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -370,6 +370,12 @@ struct bpf_flow_dissector {
>   	const struct sk_buff	*skb;
>   	const void		*data;
>   	const void		*data_end;
> +	__u8			vhdr_flags;
> +	__u8			vhdr_gso_type;
> +	__u16			vhdr_hdr_len;
> +	__u16			vhdr_gso_size;
> +	__u16			vhdr_csum_start;
> +	__u16			vhdr_csum_offset;
>   };

>   static inline void
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 418b9b813d65..de525defd462 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5155,6 +5155,12 @@ struct __sk_buff {
>   	__u32 gso_segs;
>   	__bpf_md_ptr(struct bpf_sock *, sk);
>   	__u32 gso_size;

[..]

> +	__u8  vhdr_flags;
> +	__u8  vhdr_gso_type;
> +	__u16 vhdr_hdr_len;
> +	__u16 vhdr_gso_size;
> +	__u16 vhdr_csum_start;
> +	__u16 vhdr_csum_offset;

These are flow dissector specific, any reason not to add them to
struct bpf_flow_keys instead?
