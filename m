Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3E6567E7
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiL0HkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiL0HkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554452652
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672126768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijp4/KDE7JPbV8flU95Sfl+xTfRImiWtlUkFnWEg/0E=;
        b=Tly+4QEYezBzxCbP3BVXS6aCeZiKpOKvFizhTDgYnqe5mB60RAYI4A7CqMbxoj/VwWphxN
        X6+2DV7pTYi/Y5LafFqKEm1AnFH9n0+T2EbV6Ba0lHt7uDWdpQ8DUvk5B1Sk6qC6Ppvzk3
        JKh1hay+9owFGvFS0qeLS9YxvWS+8+s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-36-eT-HshagMz68eQ2PF-RTBg-1; Tue, 27 Dec 2022 02:39:26 -0500
X-MC-Unique: eT-HshagMz68eQ2PF-RTBg-1
Received: by mail-ej1-f72.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso8630435ejb.5
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:39:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijp4/KDE7JPbV8flU95Sfl+xTfRImiWtlUkFnWEg/0E=;
        b=GJJHi6mYN8rUBnCy50rNhoLGiYRP0SPE05uiEx34Moqi7yAvG6rcdwd6U4T/7Buo8z
         U+Qlr2dsNTUT8YW5IZq67YuNx8jWhOZfqEbCOyBZcbXWKvviOvWBWnkPaKyUVbsBqL19
         dng/UTxsCBqvDxC7s0zcFTI7hiIM5GLVHwjhaLDfmhsiuLHMdZN31j3sDlYbrnKXCP64
         XO1PZbEFHBbHZZgQJnooANFP+r3pFfmLbXNRyMdP7d0MRP7rgMNvuDukp6rOYYvvtl99
         O3HOWuJkUgpDwIM5v5Ngs0b6xwQpYbgYRHzttfMFA2jDTbNbDE9FAPJhJsIA907Lg70l
         AeDg==
X-Gm-Message-State: AFqh2kqwFRIZTOT6sRAy72sE7wTDZF1/OHO5ymzAf80VdlgI0WxkJl0U
        7tAg0Qdy7E6dL0GUxc1q7V9ZzftUdbGDn82+t2CqZ+m1ne9BSfRd6qcDMtt2N91QRdhCIC1y85E
        WEWpVXGwRfN1RlI+U
X-Received: by 2002:a17:906:5012:b0:7c1:2e19:ba3f with SMTP id s18-20020a170906501200b007c12e19ba3fmr20934645ejj.57.1672126765787;
        Mon, 26 Dec 2022 23:39:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvEK74H/0mvVg5+sIWI5S05sZ4NLeTRvhDcGPRtrHczfjDKJoNMKT3etQeIE3+qjfimvG37zg==
X-Received: by 2002:a17:906:5012:b0:7c1:2e19:ba3f with SMTP id s18-20020a170906501200b007c12e19ba3fmr20934639ejj.57.1672126765571;
        Mon, 26 Dec 2022 23:39:25 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id ta13-20020a1709078c0d00b0077a201f6d1esm5705579ejc.87.2022.12.26.23.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:39:25 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:39:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 1/4] virtio-net: convert rx mode setting to use workqueue
Message-ID: <20221227023447-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226074908.8154-2-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 03:49:05PM +0800, Jason Wang wrote:
> @@ -2227,9 +2267,21 @@ static void virtnet_set_rx_mode(struct net_device *dev)
>  				  VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
>  		dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
>  
> +	rtnl_unlock();
> +
>  	kfree(buf);
>  }
>  
> +static void virtnet_set_rx_mode(struct net_device *dev)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +
> +	spin_lock(&vi->rx_mode_lock);
> +	if (vi->rx_mode_work_enabled)
> +		schedule_work(&vi->rx_mode_work);
> +	spin_unlock(&vi->rx_mode_lock);
> +}
> +
>  static int virtnet_vlan_rx_add_vid(struct net_device *dev,
>  				   __be16 proto, u16 vid)
>  {

Hmm so user tells us to e.g enable promisc. We report completion
but card is still dropping packets. I think this
has a chance to break some setups.

-- 
MST

