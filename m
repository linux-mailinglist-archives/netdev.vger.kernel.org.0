Return-Path: <netdev+bounces-2257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0B3700ECC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E059D281CDB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E081EA8C;
	Fri, 12 May 2023 18:30:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA21F16C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 18:30:13 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01D61B7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:29:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba22ced2e95so9365942276.1
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683916126; x=1686508126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g1YHZI5wWoilGiErbtfwlJ8t+YURSptBI7L1u7j3vVM=;
        b=K9UDN4B/R3ogwJmxTjdrEokIDh2/U9Ke5kzESmbqsjepMS+MzvNKwdyEGaOh8hfyYz
         VcQYpY3OPiM7e6Xqm14UIE3Wcrh3rautsuytlTioEMN+DimMMZ7G42wrPlH8x4ZVc8Sz
         fuo+/gxpvp/KUvo9o514Oztnpkdh1qkembXoIYCYH5jYJm5NQ5ZZIZQC00b7uVeGlNv7
         Gp/auxM9y4+WXLnOv9rj6MuMOL7vu0Unc1FhgmSmZgCB3jZjWWwZAeGMNqUty7PUZ1dv
         FbMgxDgd/CxxOU9sa0vqLh26yG4Mqg4eeJNw0QhTDkmuoXHoxl1Of7BF9DPmWUVWh94b
         Oh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683916126; x=1686508126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1YHZI5wWoilGiErbtfwlJ8t+YURSptBI7L1u7j3vVM=;
        b=fT1fL0HZIL7xoMEWX21XwlTQlWalU4kLYx6h5IzM8juN5JfMt4O+ifv0jcjJ/hLzk9
         vO84wvH6A43unnlCJo9dcRcPxOQ33LbbJ/dIZY9Mrk3H+Gcu5MwT18dHOpWMyfRid19v
         99Eua53YJnCqp9QmrWEdgWrLPnKad6AZRL/P734ldLBL6qMZM+GY+TVGbDO+ywUiViGC
         UHTrBoPrMtriVu2JQP6Q1tuedmLm0MN3m9PZA+U7tIpn/fPDyFx7SODjr+Qonw6loWBh
         FzrgDun61kyJSYJPuSId2AdeECDqPDPPShrdpGWy2RoOI7Y8uKDxXw7dKSafbIgLQMip
         utmQ==
X-Gm-Message-State: AC+VfDzb0o+bU0KagOD61mHxLW5HrmX6WxLyRW6jhvbiObkc+2sZ5hT0
	ovnGB58Up+j4fJUbPr8WKPJFc0M=
X-Google-Smtp-Source: ACHHUZ61qwr3BdPrPsjBchwqa5bp7Ymx46T3C17hhoEYce9/vXT91ouNeraL6bIM1/UVWg+lWqm0LXw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:874f:0:b0:b9d:fe66:a424 with SMTP id
 e15-20020a25874f000000b00b9dfe66a424mr16098075ybn.2.1683916126382; Fri, 12
 May 2023 11:28:46 -0700 (PDT)
Date: Fri, 12 May 2023 11:28:44 -0700
In-Reply-To: <20230512152607.992209-10-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230512152607.992209-1-larysa.zaremba@intel.com> <20230512152607.992209-10-larysa.zaremba@intel.com>
Message-ID: <ZF6FXNglntreqIgW@google.com>
Subject: Re: [PATCH RESEND bpf-next 09/15] xdp: Add VLAN tag hint
From: Stanislav Fomichev <sdf@google.com>
To: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Anatoly Burakov <anatoly.burakov@intel.com>, 
	Jesper Dangaard Brouer <brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, 
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>, 
	xdp-hints@xdp-project.net, netdev@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/12, Larysa Zaremba wrote:
> Implement functionality that enables drivers to expose VLAN tag
> to XDP code.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>  Documentation/networking/xdp-rx-metadata.rst | 11 ++++++++-
>  include/linux/netdevice.h                    |  2 ++
>  include/net/xdp.h                            |  4 ++++
>  kernel/bpf/offload.c                         |  4 ++++
>  net/core/xdp.c                               | 24 ++++++++++++++++++++
>  5 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> index 25ce72af81c2..73a78029c596 100644
> --- a/Documentation/networking/xdp-rx-metadata.rst
> +++ b/Documentation/networking/xdp-rx-metadata.rst
> @@ -18,7 +18,16 @@ Currently, the following kfuncs are supported. In the future, as more
>  metadata is supported, this set will grow:
>  
>  .. kernel-doc:: net/core/xdp.c
> -   :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
> +   :identifiers: bpf_xdp_metadata_rx_timestamp
> +
> +.. kernel-doc:: net/core/xdp.c
> +   :identifiers: bpf_xdp_metadata_rx_hash
> +
> +.. kernel-doc:: net/core/xdp.c
> +   :identifiers: bpf_xdp_metadata_rx_ctag
> +
> +.. kernel-doc:: net/core/xdp.c
> +   :identifiers: bpf_xdp_metadata_rx_stag
>  
>  An XDP program can use these kfuncs to read the metadata into stack
>  variables for its own consumption. Or, to pass the metadata on to other
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 08fbd4622ccf..fdae37fe11f5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1655,6 +1655,8 @@ struct xdp_metadata_ops {
>  	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
>  	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash,
>  			       enum xdp_rss_hash_type *rss_type);
> +	int	(*xmo_rx_ctag)(const struct xdp_md *ctx, u16 *vlan_tag);
> +	int	(*xmo_rx_stag)(const struct xdp_md *ctx, u16 *vlan_tag);
>  };
>  
>  /**
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 6381560efae2..2db7439fc60f 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -389,6 +389,10 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
>  			   bpf_xdp_metadata_rx_timestamp) \
>  	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
>  			   bpf_xdp_metadata_rx_hash) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_CTAG, \
> +			   bpf_xdp_metadata_rx_ctag) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_STAG, \
> +			   bpf_xdp_metadata_rx_stag) \
>  
>  enum {
>  #define XDP_METADATA_KFUNC(name, _) name,
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index d9c9f45e3529..2c6b6e82cfac 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -848,6 +848,10 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
>  		p = ops->xmo_rx_timestamp;
>  	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
>  		p = ops->xmo_rx_hash;
> +	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_CTAG))
> +		p = ops->xmo_rx_ctag;
> +	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_STAG))
> +		p = ops->xmo_rx_stag;
>  out:
>  	up_read(&bpf_devs_lock);
>  
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 41e5ca8643ec..eff21501609f 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -738,6 +738,30 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
>  	return -EOPNOTSUPP;
>  }
>  
> +/**
> + * bpf_xdp_metadata_rx_ctag - Read XDP packet inner vlan tag.
> + * @ctx: XDP context pointer.
> + * @vlan_tag: Return value pointer.
> + *
> + * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_xdp_metadata_rx_ctag(const struct xdp_md *ctx, u16 *vlan_tag)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +/**
> + * bpf_xdp_metadata_rx_stag - Read XDP packet outer vlan tag.
> + * @ctx: XDP context pointer.
> + * @vlan_tag: Return value pointer.
> + *
> + * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_xdp_metadata_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  __diag_pop();
>  
>  BTF_SET8_START(xdp_metadata_kfunc_ids)
> -- 
> 2.35.3
> 

