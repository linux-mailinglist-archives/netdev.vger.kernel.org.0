Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A76BBEF6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjCOVXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjCOVXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:23:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6727127D47;
        Wed, 15 Mar 2023 14:23:21 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so3610506pjz.1;
        Wed, 15 Mar 2023 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678915400;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpKNq1jPFRcrzw5GmHq4U9XoqgkDIbRL0krA5AsHags=;
        b=UJmHQHeCJ5Tfm9cYNpn+6q5FwjDmaZrArfaXw0UDkphx3LjtOyHbqdakpkAo2Hxklk
         dtmPJumnskFBmjSIwC2VjCbr5khJ94Kc3DA5nEXSoZCxgVBeTLoFZstc2jhTf+8N3lLL
         BjTbcXdEIlgESGl1AsgI99OUv3uWLxRCzL5JvQuGMIEG4x35srCHWN+9+9YKS08qmCUM
         0dY9DDMzmCTZpFPW0+g/q8OX6jPr3RNumGvruI+1lPKdDu/fT6/zxLxx7hgcXGM9GLuW
         KbTRxQvc66JG/d/HntJ6p7yFR92e99kfNlaPGCRgAyo1FYOSfYAGY8qCB0CypTF1tQkj
         wFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678915400;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kpKNq1jPFRcrzw5GmHq4U9XoqgkDIbRL0krA5AsHags=;
        b=WjvPnwtHVimagOMUs6x2VnXRM/do8xek996AwFZJTnUMpB7pg7jtXxfJxYClaeXbfP
         7hKwNcTVojzfNmrFlJ7HXoxSWrYscOr1y8TvfZFPwC0E3JtdHfFi8Hbt+YxWMbG6/DX6
         YS9qSp/C1GTCCyL/TRkyZTYy4mf3R2KBLV1fRNpbwpkwKvwtuVEGi0hOQJtF3SUxiWKc
         +NaYeIXJ0LigKIgiX2luGTBPwPwyUZry+3ehfFNI+/ZqWgPuxD7redJCVoHWWykrLlHu
         G+ZVHLgOqEyP4F/NscVuvy0uHEVWKo3DAVG4f6R3JShXRSBoOrm3t5O78FfQfzhtSh7A
         PmQw==
X-Gm-Message-State: AO0yUKVOAf21MX2wMTOyM+bAJlz5P2dax/VX12EMw5qM6+/1KL5rhICL
        m5l2S/kIwddBL5zChD5i33o=
X-Google-Smtp-Source: AK7set8JWNfawHmhD7QMbyFbUqc0eQMajqXNs7oBCS5kGrbPAgdcKs7dYXc4moXtIYe5XhhGpETEPg==
X-Received: by 2002:a17:903:11cd:b0:19c:e842:a9e0 with SMTP id q13-20020a17090311cd00b0019ce842a9e0mr1063192plh.16.1678915400327;
        Wed, 15 Mar 2023 14:23:20 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id jw24-20020a170903279800b001a072aedec7sm2594699plb.75.2023.03.15.14.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:23:19 -0700 (PDT)
Date:   Wed, 15 Mar 2023 14:23:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Message-ID: <641237468971a_63dce2081d@john.notmuch>
In-Reply-To: <20230314083901.40521-3-xuanzhuo@linux.alibaba.com>
References: <20230314083901.40521-1-xuanzhuo@linux.alibaba.com>
 <20230314083901.40521-3-xuanzhuo@linux.alibaba.com>
Subject: RE: [PATCH net 2/2] virtio_net: free xdp shinfo frags when
 build_skb_from_xdp_buff() fails
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo wrote:
> build_skb_from_xdp_buff() may return NULL, on this
> scene we need to free the frags of xdp shinfo.
> 
> Fixes: fab89bafa95b ("virtio-net: support multi-buffer xdp")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8ecf7a341d54..d36183be0481 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1273,9 +1273,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  
>  		switch (act) {
>  		case XDP_PASS:
> +			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> +			if (!head_skb)
> +				goto err_xdp_frags;
> +
>  			if (unlikely(xdp_page != page))
>  				put_page(page);
> -			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  			rcu_read_unlock();
>  			return head_skb;
>  		case XDP_TX:
> -- 
> 2.32.0.3.g01195cf9f
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
