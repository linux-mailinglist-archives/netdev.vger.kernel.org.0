Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE8A687AF3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjBBK5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBBK5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA58A7F
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 02:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675335426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nLgisAhVhjxaFOYw08tk2NZkXdHAeHPvk91YSYHYTNo=;
        b=W29bVnF9nIRsBC4C0eECS/EYKXKvBDL9SIZ6IGx7F2hFo2DOwsDGBhbBUaXhU+hAi3aWCw
        Q/m9A45WwImHvH8z/f5BUViEVbxcC7vMlQk2Fa/+ai/hT5uz/1YgyN0i9QW59mdDASZ/XW
        nO5/kiksBatPcHcENTUlGflMkafct3s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-544-ARiGjZxuNRm3mpm11PzhvA-1; Thu, 02 Feb 2023 05:57:05 -0500
X-MC-Unique: ARiGjZxuNRm3mpm11PzhvA-1
Received: by mail-wr1-f69.google.com with SMTP id l8-20020adfc788000000b002bdfe72089cso166105wrg.21
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 02:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLgisAhVhjxaFOYw08tk2NZkXdHAeHPvk91YSYHYTNo=;
        b=rymUXy4XeDspb3Rs6eaOuI5aMD20yf4vKucv6mlBH6TXeisBNYSlCihg4IG14sY3TE
         f9yObibzl8j0LMsDsv14SV3fmkFKlyaraiikfK2Xl5itV5+V5CJDvjfFgbllDShTPISq
         t8AKl5VIJZiaJC/yGQhcDhfwfClJ+1Db5+1u5GFgI7uqaMtB7MktJRRA8Jv0eNOPImoC
         R+206ntP1ObOWyqhukHT3DlUJQ7hfDfog/U+ZgAkR1gdxwsBc/tfvdjaVZXnJrTBNzln
         s4dZWuJzMpOGFfz7+v+K73/e3q/CCgi4pQSJ/W4rmaDBZv7AwRaui3jzo5dWNKI2VB9H
         +aCw==
X-Gm-Message-State: AO0yUKWpCx+0RVNT2aLcJDldipVua8RdQCIbNFvVFWSSJBI3sXeTBemd
        Nc78Ls2NDY0GM83/KivaskV6sg7dOYfkkj5YmpjGoltT4WdlFmx/zPxn/uBu0uE/gry7Vi50F5W
        xrZpMWhgv//Hj4UeJ
X-Received: by 2002:a05:600c:3b0c:b0:3d2:813:138a with SMTP id m12-20020a05600c3b0c00b003d20813138amr1515649wms.35.1675335424011;
        Thu, 02 Feb 2023 02:57:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/psrnYQSpicehicPlykAuaLwGGouzJxfU7GSH68r+uUKziLdcFHTfe7pPMuUCzZZ/UZoUzFw==
X-Received: by 2002:a05:600c:3b0c:b0:3d2:813:138a with SMTP id m12-20020a05600c3b0c00b003d20813138amr1515635wms.35.1675335423854;
        Thu, 02 Feb 2023 02:57:03 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003daf6e3bc2fsm6888625wms.1.2023.02.02.02.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:57:03 -0800 (PST)
Date:   Thu, 2 Feb 2023 05:56:57 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 0/2] virtio-net: close() to follow mirror of open()
Message-ID: <20230202055630-mutt-send-email-mst@kernel.org>
References: <20230202050038.3187-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202050038.3187-1-parav@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:36AM +0200, Parav Pandit wrote:
> Hi,
> 
> This two small patches improves ndo_close() callback to follow
> the mirror sequence of ndo_open() callback. This improves the code auditing
> and also ensure that xdp rxq info is not unregistered while NAPI on
> RXQ is ongoing.


Acked-by: Michael S. Tsirkin <mst@redhat.com>

I'm guessing -net and 1/2 for stable?

> Please review.
> 
> Patch summary:
> patch-1 ensures that xdp rq info is unregistered after rq napi is disabled
> patch-2 keeps the mirror sequence for close() be mirror of open()
> 
> Parav Pandit (2):
>   virtio-net: Keep stop() to follow mirror sequence of open()
>   virtio-net: Maintain reverse cleanup order
> 
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.26.2

