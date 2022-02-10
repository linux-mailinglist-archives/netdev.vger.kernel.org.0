Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94834B1248
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbiBJQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:03:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243971AbiBJQDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:03:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55231B8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644508983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XqMRSNji5KHFwBXLfzLcneZQrTGS+nQUHDyGuzlvgWY=;
        b=BFuhfulCHcpRU67OqFIboJWlAsdzPOuzMfZZIa9rqcLfucp2I3vnGWR03cOxLnluh6Q8FY
        Rjk1ogBJdOKd325kpnd+Tj5ffRLdO9YkfsS4CRXUEe8VYyZEeqG/WhWR38HM0zuHCupYq5
        YTJQzOgkrj0PEtSO8vxOVHFxLkT4qZs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-7FmTtbCNPq2pmbdoDmX9Ow-1; Thu, 10 Feb 2022 11:02:59 -0500
X-MC-Unique: 7FmTtbCNPq2pmbdoDmX9Ow-1
Received: by mail-qt1-f199.google.com with SMTP id e14-20020ac84b4e000000b002cfbbdf8206so4689410qts.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XqMRSNji5KHFwBXLfzLcneZQrTGS+nQUHDyGuzlvgWY=;
        b=ZfIQmh/O0OhYPuhFpEosj8UkaXF2r3h+gQ141QaHqZL1TqTEOuDQBY6gUwH00klyCn
         GVfJvOJWeX44GWNWkRactL37oA72nl6xxwj7f5KLL8ug6941iG4DoECJuTgiuoB+t2DJ
         4KNxdTrK5xmeSQ3897WFpRE/+Kp0l3et8scPM04iUuc3N6Albel9vb14kErWnkV0dAOJ
         6cPUrN+rjgBR9I2446rqIrm+28Y9eGkXSjDFKSV0uB7qPIfJd0bHKdNpbh7yzhcvrbkv
         PbL+/1NMvx5/gInPSOZ0QGegnzpkDc/RmeGswofHiQzT65QosCUZS/iLBlEWprbc7ZTH
         jrVw==
X-Gm-Message-State: AOAM532v8Mvi4rlIEPqGy+7JJb7aizEkIycZ4782fUr1ZX/XQmWC/vZg
        nMR9jGURPx7QU2tqZFgSQUFxxTkeOETpAcP56ADcT1zQqkRyuZYLmdqAj/kBFxiBmIPdLuw6NtQ
        LYH3xbMRKg4tPiLw4
X-Received: by 2002:ac8:470b:: with SMTP id f11mr5264447qtp.428.1644508979125;
        Thu, 10 Feb 2022 08:02:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJZidFHgX2qaFuNO4wwwWXQrdPSZ6BLsKxCMwzMjl3VQN+p8ixuoDBh/MeuJVBmzm2X+Enig==
X-Received: by 2002:ac8:470b:: with SMTP id f11mr5264402qtp.428.1644508978832;
        Thu, 10 Feb 2022 08:02:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id p15sm11231377qtk.56.2022.02.10.08.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:02:58 -0800 (PST)
Message-ID: <d5dd3f10c144f7150ec508fa8e6d7a78ceabfc10.camel@redhat.com>
Subject: Re: [PATCH] net: fix wrong network header length
From:   Paolo Abeni <pabeni@redhat.com>
To:     "lina.wang" <lina.wang@mediatek.com>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, zhuoliang@mediatek.com,
        chao.song@mediatek.com
Date:   Thu, 10 Feb 2022 17:02:53 +0100
In-Reply-To: <5ca86c46109794a627e6e2a62b140963217984a0.camel@mediatek.com>
References: <20220208025511.1019-1-lina.wang@mediatek.com>
         <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
         <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
         <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
         <5ca86c46109794a627e6e2a62b140963217984a0.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-09 at 18:25 +0800, lina.wang wrote:
> We use NETIF_F_GRO_FRAGLIST not for forwarding scenary, just for
> software udp gro. 
> 
I'm wondering why don't you simply enable UDP_GRO on the relevant
socket? 

> Whatever NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_FWD,
> skb_segment_list should not have bugs.

The bug is arguably in bpf_skb_proto_6_to_4(), even if fixing it in
skb_segment_list() is possibly easier.

> We modify skb_segment_list, not in epbf. One point is traversing the
> segments costly, another is what @Maciej said, *other* helper may have
> the same problem. In skb_segment_list, it calls
> skb_headers_offset_update to update different headroom, which implys
> header maybe different.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 75dfbde8d2e6..f15bbb7449ce 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3682,6 +3682,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  	struct sk_buff *tail = NULL;
>  	struct sk_buff *nskb, *tmp;
>  	int err;
> +	unsigned int len_diff = 0;

Mintor nit: please respect the reverse x-mas tree order.

>  
>  	skb_push(skb, -skb_network_offset(skb) + offset);

> @@ -3721,9 +3722,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  		skb_push(nskb, -skb_network_offset(nskb) + offset);
>  
>  		skb_release_head_state(nskb);
> +		len_diff = skb_network_header_len(nskb) - skb_network_header_len(skb);
>  		 __copy_skb_header(nskb, skb);
>  
>  		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> +		nskb->transport_header += len_diff;

This does not look correct ?!? the network hdr position for nskb will
still be uncorrect?!? and even the mac hdr likely?!? possibly you need
to change the offset in skb_headers_offset_update().

Paolo

