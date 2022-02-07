Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1404AC874
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiBGSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239273AbiBGSRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:17:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAC37C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644257831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdU7WqO0Ry21zoESqpPAeMlKhPgWFbV0TNGxL6U+ofw=;
        b=JuB4nUezEDYfaQ0wheTukW0fc84qMMfQUWjGHirwDSmvIUmwySzJbv3w+1Idnb7LeGmqZp
        0Rp52hupt56W6I538olbnsAN1OQ8GMVLHEOPCexfbBme+jZTlyv0v8QifVVpTM+kaPnLJs
        TuiOfKxUS3GVhyUmcS3bESY6AXdMNx4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-20QYK2Z8PWqD6Byf0vVQ4Q-1; Mon, 07 Feb 2022 13:17:10 -0500
X-MC-Unique: 20QYK2Z8PWqD6Byf0vVQ4Q-1
Received: by mail-wm1-f71.google.com with SMTP id h82-20020a1c2155000000b003552c13626cso8273665wmh.3
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 10:17:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EdU7WqO0Ry21zoESqpPAeMlKhPgWFbV0TNGxL6U+ofw=;
        b=lc3nSJEnmRspJM54ORJzHnfhRpiFlV4OgEz3+/0wWjaBvH0DK/hybKf4tpC5RL+s+H
         NCzvWx94MGq3fJsurWP6BZ8m7Z0mKBD4IbnSgzKRWzifL6uW2bVIH9QNg6TEAyb3x05/
         wDWuhC9zeIfe6Ar8dvog/YiMT23LfvDkIjMtb6VpWXe6JgdOUut6LoNOLEeZ7S/iMyFU
         /T/NLCoAqEvDbeUq6G0D6Au/wWAllBXZF+itwXMOdRNkWP8LNOg/ZeHchOqMXnAunST/
         PFuKb0Mie+S7FmjBzKSfxnKmacfLOkpLhAWdeXaffm1PndGnDbqiwSoOySxN8EdzVp0Y
         TIxg==
X-Gm-Message-State: AOAM531ZdvZwV9HkWFLDFO8ayr9DuXiik/LRC3N8NUVH8nbJrBoMov78
        G3i7fxnM877QE2VU4zcGi/mv2QJffypVs16Pwi2LFS/kS0CgkT6nKQAmg/H8yao0N7k0ICo9yVT
        CSmZNeF9OCp7zPrdj
X-Received: by 2002:adf:a51b:: with SMTP id i27mr581367wrb.172.1644257829315;
        Mon, 07 Feb 2022 10:17:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYoIvk4H3SrfjRLrVLsALIOQ3JHng8EY209TznpTyTedmDCbI8D/8WdWH7ELhivZlTANShmg==
X-Received: by 2002:adf:a51b:: with SMTP id i27mr581346wrb.172.1644257829112;
        Mon, 07 Feb 2022 10:17:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id u7sm2835623wrq.112.2022.02.07.10.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:17:08 -0800 (PST)
Message-ID: <42c623d9dc86399f62bef9bbe40b38aa7143a41b.camel@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: do not keep the dst cache when
 uncloning an skb dst and its metadata
From:   Paolo Abeni <pabeni@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pshelar@ovn.org,
        daniel@iogearbox.net
Date:   Mon, 07 Feb 2022 19:17:07 +0100
In-Reply-To: <20220207171319.157775-2-atenart@kernel.org>
References: <20220207171319.157775-1-atenart@kernel.org>
         <20220207171319.157775-2-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-07 at 18:13 +0100, Antoine Tenart wrote:
> When uncloning an skb dst and its associated metadata a new dst+metadata
> is allocated and the tunnel information from the old metadata is copied
> over there.
> 
> The issue is the tunnel metadata has references to cached dst, which are
> copied along the way. When a dst+metadata refcount drops to 0 the
> metadata is freed including the cached dst entries. As they are also
> referenced in the initial dst+metadata, this ends up in UaFs.
> 
> In practice the above did not happen because of another issue, the
> dst+metadata was never freed because its refcount never dropped to 0
> (this will be fixed in a subsequent patch).
> 
> Fix this by initializing the dst cache after copying the tunnel
> information from the old metadata to also unshare the dst cache.
> 
> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Vlad Buslov <vladbu@nvidia.com>
> Tested-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  include/net/dst_metadata.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 14efa0ded75d..b997e0c1e362 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -123,6 +123,19 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  
>  	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>  	       sizeof(struct ip_tunnel_info) + md_size);
> +#ifdef CONFIG_DST_CACHE
> +	/* Unclone the dst cache if there is one */
> +	if (new_md->u.tun_info.dst_cache.cache) {
> +		int ret;
> +
> +		ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> +		if (ret) {
> +			metadata_dst_free(new_md);
> +			return ERR_PTR(ret);
> +		}
> +	}
> +#endif
> +
>  	skb_dst_drop(skb);
>  	dst_hold(&new_md->dst);
>  	skb_dst_set(skb, &new_md->dst);

LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

