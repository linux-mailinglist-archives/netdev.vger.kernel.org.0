Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590E2E30A2
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 10:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgL0Jlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 04:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgL0Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 04:41:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609062024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ba+iHfK0bJtNwDKtVlH80Ke13TbgM723LjJZBC9s0JU=;
        b=NR/m0dQaRouQFBDKKFzF0lCQMAIre5uibWHWS507zwuQo9POa8RBy3Pesrf+08JbCe6fDk
        56hz+9NkUDZ79m8vwUI3V9uyn42NhVhzGyZ+PJy5cMdc7FfopXNzDasACbmV6EXJf5reCd
        GlOFI8Kz7wLn2XeFjjF+hcvjsDcA+sw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-W7l7iGV9PLukRSCobkZB8A-1; Sun, 27 Dec 2020 04:40:22 -0500
X-MC-Unique: W7l7iGV9PLukRSCobkZB8A-1
Received: by mail-wr1-f70.google.com with SMTP id w5so4881216wrl.9
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 01:40:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ba+iHfK0bJtNwDKtVlH80Ke13TbgM723LjJZBC9s0JU=;
        b=c/2JcThkcKGtfD/qEW5XkuPEOn3e59TUTmZ/C2Ek8P3E1qiFGPEvKVLKdrYjq2vLs0
         Wbpl4xhx6mpUT5XHKcqx3l5E4/QUvG66gpl0Qpe6D1OJD9yvmNc2AzK+Bg3fHlAoMVso
         d/OKItpDAgkDegxybZ7OFHmLi/xP2ebwhiyCp4kuVjm+3jul5qjlW29r/IGaG3z14E1U
         UT41sniJM2zghQqKvV8w14tuuVT4bOYqYcUgAGm02CQYd6/k9lRehEe/BZkC+sZNv78q
         YSwTkFsA7/yt3DPFxV6G8PE9sFeRrYeuwy2rUUK9la8ja1SYDvb+oxO8cIOAqqg25Keh
         W+yA==
X-Gm-Message-State: AOAM533mWaCxCPrx2075j1Xdrifl8jWPrgfbgeZzE60PhouTytO77jdi
        Ja4XD+fHo8SkxDa+KTooRk1ihgbBHWzslSUasRvzwsBJkmcpA0UErEGsc+RMgI6vWgsscw0ECgo
        Rp3K5XrsfFE4M8iFZ
X-Received: by 2002:a1c:204e:: with SMTP id g75mr15980183wmg.100.1609062021401;
        Sun, 27 Dec 2020 01:40:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyn868LZXUswFzyOxoPt97OHLb1MgVvijGp9IAQ57ejvsHPsC2xdjBSXRQPWvCCGJfMwTu/Cg==
X-Received: by 2002:a1c:204e:: with SMTP id g75mr15980178wmg.100.1609062021283;
        Sun, 27 Dec 2020 01:40:21 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id o83sm14758474wme.21.2020.12.27.01.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 01:40:20 -0800 (PST)
Date:   Sun, 27 Dec 2020 04:40:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v2] tun: fix return value when the number of iovs
 exceeds MAX_SKB_FRAGS
Message-ID: <20201227044010-mutt-send-email-mst@kernel.org>
References: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 25, 2020 at 10:52:16AM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> we should use -EMSGSIZE instead of -ENOMEM.
> 
> The following distinctions are matters:
> 1. the caller need to drop the bad packet when -EMSGSIZE is returned,
>    which means meeting a persistent failure.
> 2. the caller can try again when -ENOMEM is returned, which means
>    meeting a transient failure.
> 
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v2:
>   * update commit log suggested by Willem de Bruijn
> ---
>  drivers/net/tun.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..15c6dd7fb04c 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1365,7 +1365,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>  	int i;
>  
>  	if (it->nr_segs > MAX_SKB_FRAGS + 1)
> -		return ERR_PTR(-ENOMEM);
> +		return ERR_PTR(-EMSGSIZE);
>  
>  	local_bh_disable();
>  	skb = napi_get_frags(&tfile->napi);
> -- 
> 2.23.0

