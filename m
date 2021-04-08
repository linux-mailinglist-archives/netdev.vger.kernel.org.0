Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF25F358EEC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhDHVEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhDHVEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:04:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917A7C061760;
        Thu,  8 Apr 2021 14:04:20 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g17so3297730edm.6;
        Thu, 08 Apr 2021 14:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZHlT3erWyxejqt9Ku+/7RfMkqFQwhzM6XW1YCf0d0iY=;
        b=pIeydTDCxXD9fCQih6JpBPkY6UE4AWcT3MCf855Bkr++YiFmOGriccstq+slOGYPdB
         P7fHai7TJrzXTafEyICHLmSUE0Vzx6myWLCf73WqolwmEFBoL3Y3wFVdDshR5LMyAFxV
         mHu3veMipsC6afhzrDz/R2t0bBVxSr8hlJKYggZ4yltIfNAu7C6LhkybhIZLHjeLYkuF
         lwWyvu+tr4GujgAVcuXGhHeaEt9A4nFBqtJgkHEfQEcgrgwPx+aUvUVIR8XCHouyapUK
         2EzJKUhQFwviHcVoUsGPog2OpC512vErAcSepEMkvpe/yku3iKDHBn0OaOZtdRmg/oxe
         AEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZHlT3erWyxejqt9Ku+/7RfMkqFQwhzM6XW1YCf0d0iY=;
        b=KP9zOWZIytsobNB8fYHPxnUWNnYu2aZXiR+Vp9yUN4AYCGol6s/5dBYuCgO8GYXcPi
         Z1pcU+1Kl5lpfnR5tmRR0LkiGHc8wa0I9qlCvOx1u5FDFJulyslui+cwXFhPMyHxhrF4
         qjAfK5L/d6y8cphwAN48tARcg1JHl+ITgVdPTYT1pie2tYuTauY4Q8USYaTVDjK/kFGd
         nPfcQb83h3tdOtoXt9kEh/MXCLcwUWBgys+Pq7Oel3zzmb5ENsxDb15kaVDnKit9hMeL
         s96wYvaqKgt7BkeywoOv/9rHubEuWiXVqRtxILuIyxGNopthQdOUGdtJOMTMnwKaEwYg
         vzxg==
X-Gm-Message-State: AOAM530Lm7dxF5gdqWo4rnIScjJ+KjoGPnRNxKxOAW5I9VXzw8mx7dr8
        xWG8aUnSLArxvV/b57zz1Tg=
X-Google-Smtp-Source: ABdhPJxxFDN5DA5yww98MuTAvWWxhj1ZNNt93ttn2P3g+9bPbQyjNqvjDLrH02o8sCL6BKdIgShNQA==
X-Received: by 2002:a05:6402:34cd:: with SMTP id w13mr14231267edc.73.1617915859217;
        Thu, 08 Apr 2021 14:04:19 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id o6sm275720edw.24.2021.04.08.14.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 14:04:18 -0700 (PDT)
Date:   Fri, 9 Apr 2021 00:04:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 09/14] bpd: add multi-buffer support to xdp
 copy helpers
Message-ID: <20210408210409.m76rfs65zbpo4sk7@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:51:01PM +0200, Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This patch adds support for multi-buffer for the following helpers:
>   - bpf_xdp_output()
>   - bpf_perf_event_output()
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Also there is a typo in the commit message: bpd -> bpf.

>  net/core/filter.c                             |  63 ++++++++-
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++++++------
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
>  3 files changed, 149 insertions(+), 44 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c4eb1392f88e..c00f52ab2532 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4549,10 +4549,56 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
>  };
>  #endif
>  
> -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>  				  unsigned long off, unsigned long len)
>  {
> -	memcpy(dst_buff, src_buff + off, len);
> +	struct xdp_buff *xdp = (struct xdp_buff *)ctx;

There is no need to cast a void pointer in C.

> +	struct xdp_shared_info *xdp_sinfo;
> +	unsigned long base_len;
> +
> +	if (likely(!xdp->mb)) {
> +		memcpy(dst_buff, xdp->data + off, len);
> +		return 0;
> +	}
> +
> +	base_len = xdp->data_end - xdp->data;

Would a static inline int xdp_buff_head_len() be useful?

> +	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
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
> +			for (i = 0; i < xdp_sinfo->nr_frags; i++) {
> +				skb_frag_t *frag = &xdp_sinfo->frags[i];
> +				unsigned long frag_len, frag_off;
> +
> +				frag_len = xdp_get_frag_size(frag);
> +				frag_off = off - frag_off_total;
> +				if (frag_off < frag_len) {
> +					src_buff = xdp_get_frag_address(frag) +
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
> +	} while (len);
> +
>  	return 0;
>  }
