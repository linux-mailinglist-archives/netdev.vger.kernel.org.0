Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7736689B9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjAMCvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjAMCuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:50:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE25D8AA
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673578207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odERJ73Z3UfAhcbzEnILTL+WyS7927XUH/5iYtkYUew=;
        b=HY9I/kryrb59A20J+kbw9WRGO79tlF2SollYBfReDzqmZo3/OiBOurR8CCMTybbx3KrfGu
        lJnLp33RGE6gwCsITtl8+LnaxojGCO8vzxCXI+xJmmcHyurYYEL7sF6lIEslSGfW7PCdVm
        JLjWI8S3I1wcdaOmcMcEpcJnXOUq4HM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-QER0yvJmOzGBMWYU3KE2mA-1; Thu, 12 Jan 2023 21:50:05 -0500
X-MC-Unique: QER0yvJmOzGBMWYU3KE2mA-1
Received: by mail-pl1-f200.google.com with SMTP id l17-20020a170902f69100b001928d6b3efcso13785243plg.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odERJ73Z3UfAhcbzEnILTL+WyS7927XUH/5iYtkYUew=;
        b=QJslvfmPkS6r/Y4mvdkE+F6nl/6LW9DavD6RUpHLmH54PFkZCoZ9XJKx5e1DeUdd1s
         VktRQfZkmGR6AEV43HA6/jX4WTjr12CeydDGiXGXWXVV6Oahww9qvnGGLDFirJoCAwhT
         hrobZDARh0dYTN/982urCNjTw0Xk7YvY3VVdQciSYNfX27vpFOWbbjFN1HHiCVX1CRoB
         /V2LpB1rPMo2sicGKIY5Dw1Iqt9Zdgbrv8Qu/ze7ZSdPsE/rzA66INR8gAAIvhJEqqVC
         uAyFxK5shyeg56vbRIw8o4R/4UPIqPn8o4TsRhlyjPnG/3CTfGA3zWxiYUpu0gNFfBC6
         ba8Q==
X-Gm-Message-State: AFqh2kpcLV7Zgu/IcRZHwcW4bNm0NBIztCJAxfX4KP7E1i4BY+cbgXGz
        mdaEiZFIyZH8SKbWf0SVffQV8CF+gt2bl0kAV1jbqTvoELjG44tyPeLh9YhHo5elhgo5udyq+aY
        /xxeZk5Ya6z71Sovw
X-Received: by 2002:a17:90a:6344:b0:225:ce95:dc15 with SMTP id v4-20020a17090a634400b00225ce95dc15mr68433133pjs.29.1673578204456;
        Thu, 12 Jan 2023 18:50:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvjkjbMP4vKqVA3kL5O3q2YuiKZMzH0b0ScPMkUSeUY2VDrz1aY78FXrrFA3oTZm1pFUn6Fqw==
X-Received: by 2002:a17:90a:6344:b0:225:ce95:dc15 with SMTP id v4-20020a17090a634400b00225ce95dc15mr68433119pjs.29.1673578204181;
        Thu, 12 Jan 2023 18:50:04 -0800 (PST)
Received: from [10.72.12.164] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mn23-20020a17090b189700b00227223c58ecsm7212010pjb.42.2023.01.12.18.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 18:50:03 -0800 (PST)
Message-ID: <b99c54de-550e-fa4c-a26f-428096680f00@redhat.com>
Date:   Fri, 13 Jan 2023 10:49:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/9] virtio-net: set up xdp for multi buffer packets
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20230103064012.108029-1-hengqi@linux.alibaba.com>
 <20230103064012.108029-3-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230103064012.108029-3-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/1/3 14:40, Heng Qi 写道:
> When the xdp program sets xdp.frags, which means it can process
> multi-buffer packets over larger MTU, so we continue to support xdp.
> But for single-buffer xdp, we should keep checking for MTU.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 443aa7b8f0ad..60e199811212 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3074,7 +3074,9 @@ static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
>   static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   			   struct netlink_ext_ack *extack)
>   {
> -	unsigned long int max_sz = PAGE_SIZE - sizeof(struct padded_vnet_hdr);
> +	unsigned int room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> +					   sizeof(struct skb_shared_info));
> +	unsigned int max_sz = PAGE_SIZE - room - ETH_HLEN;
>   	struct virtnet_info *vi = netdev_priv(dev);
>   	struct bpf_prog *old_prog;
>   	u16 xdp_qp = 0, curr_qp;
> @@ -3095,9 +3097,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>   		return -EINVAL;
>   	}
>   
> -	if (dev->mtu > max_sz) {
> -		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
> -		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
> +	if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
> +		netdev_warn(dev, "single-buffer XDP requires MTU less than %u\n", max_sz);
>   		return -EINVAL;
>   	}


I think we probably need to backport this to -stable. So I suggest to 
move/squash the check of !prog->aux->xdp_has_frags to one of the 
following patch.

With this,

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>   

