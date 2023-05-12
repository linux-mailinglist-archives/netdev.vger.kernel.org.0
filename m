Return-Path: <netdev+bounces-2254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B234700E8F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5158D1C2122A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20ECF1DDFF;
	Fri, 12 May 2023 18:19:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07555200B7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 18:19:57 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69F410D3
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:19:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6435432f56bso6518536b3a.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683915595; x=1686507595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Je0QZ3OEcPYIjlzwUZPK1i4M9j5mxA5BuIpDlUTvQs0=;
        b=m7pNH+tJv1eJb1PQNpYn7KL+B8x6ruIGuglVNB8oPweOb20MnT+8J0OjNba+0GMzAK
         i2qJQSsCLilZbh/VpSYzFhr+8TWJLN04ELWSCloAo8uOukOYPyZW2y8WCHI2gWKiGPQV
         mrdpFmtHsu5KgALTxLapvn6bfo9H/5o0X4lIsxV8DrTfvLPVA+RJ+JLrS8SyutdKHk91
         ZZOOJNOsgnh7HNk/c9g6OpoP2ftc70yyq7mybLStwyewVu3ewf9Fk314s4R2f5cbmvbp
         1CR/ln9gWb+p/8b1nsfv1vw52Mmb4WkjQI0lXCU+fYFEL2vb9AAks2Y6sdhizLX3G56c
         UgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683915595; x=1686507595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Je0QZ3OEcPYIjlzwUZPK1i4M9j5mxA5BuIpDlUTvQs0=;
        b=cscF1bJxxw2diJ1GhEuw5/yz7pAvIyuX4IYVciNLImOWTAQKGkyPC8cO+n3O0VHBUY
         /TlwSjfgJNcysiyxEJBPePSTzNlo+0vHyzXMliLKbM7JYwDCvJagy+Hy71h0IjRMu6KB
         Of6K65FmC25h9z9hfR7VDv2V6cewQRTm0csYskhjOAaTG4kixlEs5IVK4uwhS3YyBRDH
         5lt1ON6npJQTq9TpeoHF+Oh3iHroygElBt9FSJzuXBxHPj88W9UBatP3u3JAdPOpn+f3
         6bk8lfcRoZZtZn6alpdjJge3XXvriwsWzN+HSrj6gaaebqRTka1gQLm8YA6hsb/kkNhl
         TPeA==
X-Gm-Message-State: AC+VfDyy2HtqBvqxSzD846Xp+7eUhT4qUCsiJIAEWZ4FlBgkRv4xrrrY
	v+1VHlZ22k/Vk0mMXYtoz2ooHNs=
X-Google-Smtp-Source: ACHHUZ4ijGlK7Lm+EEX2bsGa22HNJnpvzQmaM/g3aYsO0WEKo4uUmlXchpuaAJE65klqvjmYPTAzyvA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:be7:b0:641:31b1:e781 with SMTP id
 x39-20020a056a000be700b0064131b1e781mr7072190pfu.5.1683915595291; Fri, 12 May
 2023 11:19:55 -0700 (PDT)
Date: Fri, 12 May 2023 11:19:53 -0700
In-Reply-To: <20230512152607.992209-7-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230512152607.992209-1-larysa.zaremba@intel.com> <20230512152607.992209-7-larysa.zaremba@intel.com>
Message-ID: <ZF6DHOtnr/AfYxML@google.com>
Subject: Re: [PATCH RESEND bpf-next 06/15] ice: Support HW timestamp hint
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
> Use previously refactored code and create a function
> that allows XDP code to read HW timestamp.
> 
> HW timestamp is the first supported hint in the driver,
> so also add xdp_metadata_ops.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h          |  2 ++
>  drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 22 +++++++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index aa32111afd6e..ba1bb8392db1 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -962,4 +962,6 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
>  	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
>  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
>  }
> +
> +extern const struct xdp_metadata_ops ice_xdp_md_ops;
>  #endif /* _ICE_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index a1f7c8edc22f..cda6c4a80737 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3378,6 +3378,7 @@ static void ice_set_ops(struct ice_vsi *vsi)
>  
>  	netdev->netdev_ops = &ice_netdev_ops;
>  	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
> +	netdev->xdp_metadata_ops = &ice_xdp_md_ops;
>  	ice_set_ethtool_ops(netdev);
>  
>  	if (vsi->type != ICE_VSI_PF)
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 2515f5f7a2b6..e9589cadf811 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -537,3 +537,25 @@ void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res,
>  			spin_unlock(&xdp_ring->tx_lock);
>  	}
>  }
> +
> +/**
> + * ice_xdp_rx_hw_ts - HW timestamp XDP hint handler
> + * @ctx: XDP buff pointer
> + * @ts_ns: destination address
> + *
> + * Copy HW timestamp (if available) to the destination address.
> + */
> +static int ice_xdp_rx_hw_ts(const struct xdp_md *ctx, u64 *ts_ns)
> +{
> +	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
> +
> +	if (!ice_ptp_copy_rx_hwts_from_desc(xdp_ext->rx_ring,
> +					    xdp_ext->eop_desc, ts_ns))
> +		return -EOPNOTSUPP;

Per Jesper's recent update, should this be ENODATA?

