Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43B4BFA27
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiBVOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 09:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiBVOFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 09:05:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9595215F0B8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 06:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645538693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+0qFceD01hVCN/fQNTDDfz9J6CvlRYxeXEgGXKvXoqM=;
        b=jBFY5JDpnMkdk/t7rJKgFK+v5FycEB77hzFeLjG8zhJ69N0V8kEYeUf1+2WNnefAJFT6lK
        5wjS1V71b7QhwCsWNOcriH0D7E6/43STCrkOLV9v0vF1RzFxf1m0uxZ94iY5+2DzkSiZ8V
        Ml+66ZtJAqdA5crC+3HDNknPXwUAwIw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-wLvW01A3MMOxsJmlf5eqEw-1; Tue, 22 Feb 2022 09:04:51 -0500
X-MC-Unique: wLvW01A3MMOxsJmlf5eqEw-1
Received: by mail-wm1-f72.google.com with SMTP id o19-20020a05600c511300b00380d3de6ca4so603427wms.0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 06:04:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+0qFceD01hVCN/fQNTDDfz9J6CvlRYxeXEgGXKvXoqM=;
        b=whjJSYNf1MKU/pxZiPlaMELJ4i2Vh49tX/KkEJlL4378u4fqbqXyEkrEGnzmCG/N3/
         CpMzEcWT2ayJudYhaZFcSWZbf8vFIJYLYNmowSd76espcbfC+C+bXi3Q2OUs4hI9/CTW
         Upn6BFZJ5Ezzs4f964QU+esBwKd4e2E4TauTjiqumiXBVvyH0JbQVAmAqqpoyZcJpicc
         494JCUAGZA1JOLeqZST263Xf6wuFs+1i5y/4plkEYyv+g4tRqr3nKvOBhMllcNm9K+eP
         A7UICsoObNbdCLWJoLUqouTtgkpBT0IV5nVQllF3xtI9Re2AvyaclREMxDX4XdPBC6hd
         5+Zg==
X-Gm-Message-State: AOAM533iyqv5PReEYxkLPdYF3lpX9BHGJ1VvMmblDtxiR0bnWttC9p02
        a+zQSUusZnLpPvQK5+NWLtXF3DFkZN/meQ5q4+9tnYSO67hzbgaoiGdAcl2Ytu9L/g5RquYQJsS
        GkhbWcUkucDqxqI8r
X-Received: by 2002:a1c:2904:0:b0:37b:ea53:4cbf with SMTP id p4-20020a1c2904000000b0037bea534cbfmr3521210wmp.46.1645538690586;
        Tue, 22 Feb 2022 06:04:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnqfwv3DyvbfLKFUSw1w02W2csoa49y5OZ11ejqp+BgbeoaU6MPpX2ME5lsWarq+vpSzVxjA==
X-Received: by 2002:a1c:2904:0:b0:37b:ea53:4cbf with SMTP id p4-20020a1c2904000000b0037bea534cbfmr3521190wmp.46.1645538690376;
        Tue, 22 Feb 2022 06:04:50 -0800 (PST)
Received: from redhat.com ([2.55.129.240])
        by smtp.gmail.com with ESMTPSA id j6sm41356042wrt.70.2022.02.22.06.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:04:49 -0800 (PST)
Date:   Tue, 22 Feb 2022 09:04:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
Message-ID: <20220222090406-mutt-send-email-mst@kernel.org>
References: <20220221195303.13560-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221195303.13560-1-mail@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:23:03AM +0530, Anirudh Rayabharam wrote:
> In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> before proceeding with adding it to the iotlb.
> 
> Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> One instance where it can happen is when userspace sends an IOTLB
> message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> iotlb. Next time a packet is sent, iotlb_access_ok() loops
> indefinitely due to that erroneous entry:
> 
> 	Call Trace:
> 	 <TASK>
> 	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> 	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> 	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> 	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> 	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
> 	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 	 </TASK>
> 
> Reported by syzbot at:
> 	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> 
> Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
>  drivers/vhost/iotlb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 670d56c879e5..b9de74bd2f9c 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>  			      void *opaque)
>  {
>  	struct vhost_iotlb_map *map;
> +	u64 size = last - start + 1;
>  
> -	if (last < start)
> +	// size can overflow to 0 when start is 0 and last is (2^64 - 1).

Pls use the old-style /* */  comments.

> +	if (last < start || size == 0)
>  		return -EFAULT;
>  
>  	if (iotlb->limit &&
> @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>  		return -ENOMEM;
>  
>  	map->start = start;
> -	map->size = last - start + 1;
> +	map->size = size;
>  	map->last = last;
>  	map->addr = addr;
>  	map->perm = perm;
> -- 
> 2.35.1

