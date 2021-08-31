Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5554B3FCFD3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhHaXO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbhHaXO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:14:27 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02FDC061575;
        Tue, 31 Aug 2021 16:13:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a13so1542601iol.5;
        Tue, 31 Aug 2021 16:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3B4L8yeK1tSAPJP2FCIzPA6vRdgudqf09e09EGD5q1g=;
        b=tKcF5Yzf1JKmtN+ccr1+tQjzkqXXN7Nr0h9rk5KKNOPbX11ou4TF9mPSQKsHr0fG//
         kotUhxlJyjo6XSbuZPIY5BjuDUH21LOVVy8V6D85Vmd9JmQSGiDAmkPtH0k3JzAuVnJT
         DcwAZ84F5jWtfkYdqmOQAKs9IFkZsVW9GTeak7BJFvHXn32W9A46JFVAmBnqMcN9sHNv
         lXlOm1VVfYDyp1PZWRcMoCiOPIqfj+X7+R3Hq8WeRqIuOmRlt+cF80gKYPepIRAl2EpB
         9ddbzuLs6Ry9lKxsBs6+KaTs6REa7/7e0NKwbC4VYSQieDBSJVpaOn1ASbxb2rY814mr
         PCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3B4L8yeK1tSAPJP2FCIzPA6vRdgudqf09e09EGD5q1g=;
        b=gMib4m0yvQwTApB1AagrCA/0hb2SSYmLlTHECXiOTdbp7svMD/1JZm1drqztqIxDMi
         skzfpVfGb52nFHD3QUcZwzmHJ0/MFw0ydLUjYzpwiQtuSgqnTxw1CoiI3B5/Q/7TLUiu
         40biBOrNSH8o8hflhlA1u/kNP33xbtqOywurvHERlkIW2VwIKy7KcmcJf7/RSWJqqaJ9
         gZAnMtvqttRIT9fIjapJtpiwFcdm+j6MxwJ5B5eRmSxnF7XjrBQQ22YRoth9ZlGvkXxr
         PRG2DJVjvwVyRV2Wg0e995EdYk0LNWimgKznZmzYckZ89tbBQwVAULoGddVm58MUrK6/
         f31w==
X-Gm-Message-State: AOAM532We0OALhVq7laNrAovAPYuPFraKS8I0FOis5tlC491BLSvfSe3
        bPtMlcSlWvdrfOoBVeHGITw=
X-Google-Smtp-Source: ABdhPJzrv+tsecmvdUAL/8Xby9Rm62GQ1zqDa/yP+N90Pu+c8on3AHEAnFio1RUdeS2Nrx8nquy1jw==
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr4998897jan.98.1630451611063;
        Tue, 31 Aug 2021 16:13:31 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s9sm10186603iob.10.2021.08.31.16.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:13:30 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:13:23 -0700
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
Message-ID: <612eb79343225_6b872087a@john-XPS-13-9370.notmuch>
In-Reply-To: <ab0c64f1543239256ef63ec9b40f35a7491812c6.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <ab0c64f1543239256ef63ec9b40f35a7491812c6.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 01/18] net: skbuff: add size metadata to
 skb_shared_info for xdp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce xdp_frags_tsize field in skb_shared_info data structure
> to store xdp_buff/xdp_frame truesize (xdp_frags_tsize will be used
> in xdp multi-buff support). In order to not increase skb_shared_info
> size we will use a hole due to skb_shared_info alignment.
> Introduce xdp_frags_size field in skb_shared_info data structure
> reusing gso_type field in order to store xdp_buff/xdp_frame paged size.
> xdp_frags_size will be used in xdp multi-buff support.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

I assume we can use xdp_frags_tsize for anything else above XDP later?
Other than simple question looks OK to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> ---
>  include/linux/skbuff.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6bdb0db3e825..1abeba7ef82e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -522,13 +522,17 @@ struct skb_shared_info {
>  	unsigned short	gso_segs;
>  	struct sk_buff	*frag_list;
>  	struct skb_shared_hwtstamps hwtstamps;
> -	unsigned int	gso_type;
> +	union {
> +		unsigned int	gso_type;
> +		unsigned int	xdp_frags_size;
> +	};
>  	u32		tskey;
>  
>  	/*
>  	 * Warning : all fields before dataref are cleared in __alloc_skb()
>  	 */
>  	atomic_t	dataref;
> +	unsigned int	xdp_frags_tsize;
>  
>  	/* Intermediate layers must ensure that destructor_arg
>  	 * remains valid until skb destructor */
> -- 
> 2.31.1
> 


