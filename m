Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2062D458CD7
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhKVLBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:01:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhKVLBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 06:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637578707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=psTM8ISrjkyMgJwD8v5I4omETk3J8QMXgeddK2v/9Oo=;
        b=UlJGpV3w/eVYuHQRYce153GfsXzatRBfIDpgaCm93RNnPvSSjzGYn7La+m16hquE3o7Sc6
        2ZK1wXLhYEMcMCj5tHCCM5dIIVo51fu3Ek1zIGAk6DpVaaVudtXcdeY5gS84w+3y7vqOTi
        xAvSIX/rxgSnhsTPvnrJYYv/RrVuIqE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-uTlOifOWO823KJFOWfJu7g-1; Mon, 22 Nov 2021 05:58:25 -0500
X-MC-Unique: uTlOifOWO823KJFOWfJu7g-1
Received: by mail-ed1-f72.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso14527276edj.13
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 02:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=psTM8ISrjkyMgJwD8v5I4omETk3J8QMXgeddK2v/9Oo=;
        b=mP1g2MIyf+R4vdP0czcjKw9EWZkScjk4FcxKnROuRUixvnpE2TEQ+hOnHBrZUzaDnb
         kEWCB9rudxJ41k7z9t2wV2mODtlTPINMb7KV35biu26Fxi01ceYrDpm+GCIV+7AYiMkj
         pVUeKPnQo/J+S0itwn0ZdLAXXF83arLHbaSZgMyoyjuoihzGBtoq+CVjPaHB4W+DXzFZ
         3UlHHsPaCH4xww67X7/DdJkuP7sUDPu5FhBql9+AOAJuTIZeSm1viYk57qyGOcfJ0dAR
         31qhfCEgQyGIlckG5H6Jh0e7H9fTe571qqI2l8034UCnkjAzrbaTrfVrovAc+KVWKIPP
         etSA==
X-Gm-Message-State: AOAM533DUXuiBs7YlI7yA+bsLjLeKcV7lKoiRgbGwl4PVw5Rpe4dskSL
        +Pll+Wy/IiY9z25Lxrfzf5FtLo6r4GvzEBVEEuf1QIXSnfORBcRUZFO4OjCtB5kvx29XL3tovkZ
        gNlcsYXWm63/5hhmn
X-Received: by 2002:a17:906:bcce:: with SMTP id lw14mr39444154ejb.411.1637578704539;
        Mon, 22 Nov 2021 02:58:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5euxEOhXA4OuQ9nCYhyy7FrC86z4Kyu9dkiD0+vafLsMdUW/fn+csxa5thD15nAAx3gGTww==
X-Received: by 2002:a17:906:bcce:: with SMTP id lw14mr39444132ejb.411.1637578704379;
        Mon, 22 Nov 2021 02:58:24 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id w24sm3527362ejk.0.2021.11.22.02.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 02:58:24 -0800 (PST)
Date:   Mon, 22 Nov 2021 11:58:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        f.hetzelt@tu-berlin.de, david.kaplan@amd.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] vsock/virtio: suppress used length validation
Message-ID: <20211122105822.onarsa4sydzxqynu@steredhat>
References: <20211122093036.285952-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211122093036.285952-1-mst@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 04:32:01AM -0500, Michael S. Tsirkin wrote:
>It turns out that vhost vsock violates the virtio spec
>by supplying the out buffer length in the used length
>(should just be the in length).
>As a result, attempts to validate the used length fail with:
>vmw_vsock_virtio_transport virtio1: tx: used len 44 is larger than in buflen 0
>
>Since vsock driver does not use the length fox tx and
>validates the length before use for rx, it is safe to
>suppress the validation in virtio core for this driver.
>
>Reported-by: Halil Pasic <pasic@linux.ibm.com>
>Fixes: 939779f5152d ("virtio_ring: validate used buffer length")
>Cc: "Jason Wang" <jasowang@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 1 +
> 1 file changed, 1 insertion(+)

Thanks for this fix

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


I think we should also fix vhost-vsock violation (in stable branches 
too).
@Halil do you plan to send a fix? Otherwise I can do it ;-)

Thanks,
Stefano

