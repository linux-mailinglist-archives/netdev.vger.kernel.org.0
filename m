Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1256066D4DA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 04:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbjAQDHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 22:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjAQDHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 22:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F521F4B5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 19:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673924808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WCv8L9Niwto4Q2Ad+faNDvGVhVwAWcTAHe2m/50/oBY=;
        b=atVjC5jhFfA8e+yGVi0pTqKBOIQhzQapEBxIglrS2MAGrO62YwYCus4+UTsY2Ebh8qJ3MP
        baa8SsK4oUFxg2GeSipVxJTa17vNjDypPTEd/uVH9S7SvEszyckiZRX6Tsa82DdK+XKQBn
        iVtLHOxi/KAJTk/OQBLV/+d8HPK9DIA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-fJqp1TgyPgOqM6fTvWPr_g-1; Mon, 16 Jan 2023 22:06:46 -0500
X-MC-Unique: fJqp1TgyPgOqM6fTvWPr_g-1
Received: by mail-oi1-f198.google.com with SMTP id bp6-20020a056808238600b00360c55456bcso7567401oib.2
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 19:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WCv8L9Niwto4Q2Ad+faNDvGVhVwAWcTAHe2m/50/oBY=;
        b=QixYDM3ag/JESp/2F8lc2s+MjpPuIspotATuUwN43Ab1fm/WSRlbGJ8r3/Ad1AIfo5
         MWEhUu/2qlBv827wX/p10Qe1arOsoa6Tz0dfoBk9hBmhHsCp8h21Q0dCDQ1UXHk9mauN
         doCHjCdPmK0cdn2qIdvpcrXbrpiuboOZfxy5vdIdmaX2IqXGAKNvyP15mI+ciUXL6a+r
         QxNgvjROGyQHHiCfOjtNSVsYr/HIEVHvVCi4sAFEcEFnU25VJEpijOU0WarisTNnfoxz
         lrtlPFI6wy+hiXj3WzqQxnKT6kRzV5c+UCmDbTqZ8ssP6fnHjNSdSaEndwmoU8h7HnWR
         aSGg==
X-Gm-Message-State: AFqh2koFMWB2FzdwQqC/mUy6Laou9EmIGtSAvipeu7EtGr4NzKY/TcZO
        mwyygXWiwZ12F0pPx0wBZDQ5MR4aGCv3jc2aAsQl0CqSvwYwlyLvph2OMmouGp0sdmNy7OzrUZL
        GzSDKmTDUlVCM8Ak+Y9nixD1l4hc9x2AE
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id y14-20020a056871010e00b0015b96b59916mr144233oab.280.1673924806228;
        Mon, 16 Jan 2023 19:06:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuE4n9qengW9Wi+EitDgqK1mTSq/ug3YpFzqkdzLOAz1mDXbCkDmt8bbuyfQ5S9MX2FL0HT0CvWxCsOFkDEVFI=
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id
 y14-20020a056871010e00b0015b96b59916mr144225oab.280.1673924806018; Mon, 16
 Jan 2023 19:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20230116202708.276604-1-parav@nvidia.com>
In-Reply-To: <20230116202708.276604-1-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 17 Jan 2023 11:06:35 +0800
Message-ID: <CACGkMEuoZXG=p4oaFd-BMDm=UpkD8tzG+CMiMOpyUHw1DZnkgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] virtio_net: Reuse buffer free function
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexanderduyck@fb.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 4:27 AM Parav Pandit <parav@nvidia.com> wrote:
>
> virtnet_rq_free_unused_buf() helper function to free the buffer
> already exists. Avoid code duplication by reusing existing function.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Parav Pandit <parav@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..31d037df514f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1251,13 +1251,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>         if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>                 pr_debug("%s: short packet %i\n", dev->name, len);
>                 dev->stats.rx_length_errors++;
> -               if (vi->mergeable_rx_bufs) {
> -                       put_page(virt_to_head_page(buf));
> -               } else if (vi->big_packets) {
> -                       give_pages(rq, buf);
> -               } else {
> -                       put_page(virt_to_head_page(buf));
> -               }
> +               virtnet_rq_free_unused_buf(rq->vq, buf);
>                 return;
>         }
>
> --
> 2.26.2
>

