Return-Path: <netdev+bounces-3751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F1D70884A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFBDB281A58
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCD4134AF;
	Thu, 18 May 2023 19:22:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2D134AB
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 19:22:20 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CA18F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:22:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d1d05a749so1165689b3a.2
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684437738; x=1687029738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=40jMST2UiyDVQhh7GdN9t9/gEu1qxxu1NZjroBqsdUI=;
        b=p8ktVfY+gzX0fkBNHeSvSf2wGLKyvNq0zKF6yUpGQzh5Vv83iWOppKi0Mm7dtb7sxT
         O2kdC1ihx39/ulz/5yQUuZdivyvRFJTDiXyfh6GKnj8Nm9Sg0PqT6nJ9AD8KnzynoRtN
         NBCVwpZJSTAPaRuThZ35o5Clhk9E1aY8r1gGSPn5Spha2OjhbdThL6PGpj4U+jdrcRHd
         CU5PpmXHCO3hXqTKlVBr7XgkmvF9wDc0Gdkrf9vvpytyCWBndx7Xd29kohOAGBEWC911
         h+GMtn8MbMFQtg1M/by6xIj/WzsFgFXlpmFe6oYV0ENPBXTEV0qfybB8PBcHF88814QF
         1j0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684437738; x=1687029738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40jMST2UiyDVQhh7GdN9t9/gEu1qxxu1NZjroBqsdUI=;
        b=Y0TsBj69vOeO7K7txJiKAvWFl4IDAAa3774dTLG19iXg5rkbdaDotQXsF8qe0W0c8f
         sk0puZaOHlAriHq0b7CRi5dYgawfb38Oh/niNNnxdVbda5wtlN92JIWF0vDT9xuc68Jz
         rGjH5pcNVto6uIE3bRvdW/DjOhQ0HHQiPxkFIaafSinpg2Em/THKIwq51O0f1Yg11n9c
         aCJdwNpEu81ZyLPkYEoi6NuvdRAshDj/EfZHUQ1aFnuURo2qGxvDaCCfbr/4ZcJEb5Yp
         R2bLDjq5ogHluJbkS5ObJBboqe3J56/OgpaCD4rl8+IudMHAnc1mOOx8+QoH/JI2Zf04
         DkuQ==
X-Gm-Message-State: AC+VfDwYmm2N8E0orpAhGm1JiyCS6QUeNGZPxfWuoHSVZuRAOipYHBJc
	QAKNUoDtfb8acTsG2ycovxVy1vU=
X-Google-Smtp-Source: ACHHUZ6XPXut5naqsnhDhPimYcozGf2NPtA5Pc0GAF3AU2ojDaaHj9pLux41ET4y7xMaYck6UT4cjWc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2ea2:b0:63d:2cff:bfbc with SMTP id
 fd34-20020a056a002ea200b0063d2cffbfbcmr1875393pfb.3.1684437737792; Thu, 18
 May 2023 12:22:17 -0700 (PDT)
Date: Thu, 18 May 2023 12:22:16 -0700
In-Reply-To: <20230518180545.159100-2-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com> <20230518180545.159100-2-maciej.fijalkowski@intel.com>
Message-ID: <ZGZ66D8x5Nbp2iYO@google.com>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
From: Stanislav Fomichev <sdf@google.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, netdev@vger.kernel.org, magnus.karlsson@intel.com, 
	tirthendu.sarkar@intel.com, bjorn@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/18, Maciej Fijalkowski wrote:
> From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> 
> Use the 'options' field in xdp_desc as a packet continuity marker. Since
> 'options' field was unused till now and was expected to be set to 0, the
> 'eop' descriptor will have it set to 0, while the non-eop descriptors
> will have to set it to 1. This ensures legacy applications continue to
> work without needing any change for single-buffer packets.
> 
> Add helper functions and extend xskq_prod_reserve_desc() to use the
> 'options' field.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
>  net/xdp/xsk.c               |  8 ++++----
>  net/xdp/xsk_queue.h         | 12 +++++++++---
>  3 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index a78a8096f4ce..4acc3a9430f3 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -108,4 +108,20 @@ struct xdp_desc {
>  
>  /* UMEM descriptor is __u64 */
>  
> +/* Flag indicating that the packet continues with the buffer pointed out by the
> + * next frame in the ring. The end of the packet is signalled by setting this
> + * bit to zero. For single buffer packets, every descriptor has 'options' set
> + * to 0 and this maintains backward compatibility.
> + */
> +#define XDP_PKT_CONTD (1 << 0)
> +
> +/* Maximum number of descriptors supported as frags for a packet. So the total
> + * number of descriptors supported for a packet is XSK_DESC_MAX_FRAGS + 1. The
> + * max frags supported by skb is 16 for page sizes greater than 4K and 17 or

This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
directly?

