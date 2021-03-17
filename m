Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE133EB73
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhCQI1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229787AbhCQI0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615969591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EwapMQi0nkg7eVnbf33AM5coVysoOM+HGdcBLVsx95o=;
        b=f/QzM11EGVFDOr1Tc43DKvtcbTyLiMlvmeqvzew7008PcXWVR/UYeHiFysFo6yfqmh8Po5
        X8G35CihJ32ATZQFav1VDOoBq+kzzJ4XAunclTIog8PuuGbF4PNAK9GkBP1vGTmx57DLM9
        4mQjlScJEBqzdPge2h1pWlujCOh9TMY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-d6Yn-tjyP9u9fu-MRzy4Mw-1; Wed, 17 Mar 2021 04:26:29 -0400
X-MC-Unique: d6Yn-tjyP9u9fu-MRzy4Mw-1
Received: by mail-ed1-f69.google.com with SMTP id v27so18935733edx.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 01:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EwapMQi0nkg7eVnbf33AM5coVysoOM+HGdcBLVsx95o=;
        b=M5tHpDiV/QfcVq+i2J1uzFCsYh0AWnc3BoRHjeTDHmmdNuXnPQIF76MrTsAz0AylgB
         +bF/z3h0F2p8hJaEy30LV9f2y9ObJwMNsRo579Dzv6yH2KMnEGLtPJitkGdPb/U8P2Uu
         RqsKcPpuA5jbFDBG00XJN1KIb1L4I77MzkBLTDo5mNeW111Ib2D5y+O1+1YoAGuUhcG1
         uDpr7u81DuIe3gsKINshbUn87UQOstW36MaqdmH9afeMwFbZ5VXXeRplYYDkSNCBsdtA
         lLeFlDh2rJ7oCVlrQfAFG/q1Apo5KoaLIu5udWiugGF+fkysrWWcXBvhOUf0xsq41a39
         4XKA==
X-Gm-Message-State: AOAM5316l60kvyD7vwvWoXHz9jiUT/DkQRzs2xFO8SmY3FtMkIIg7qx+
        07LMFRIJWyeHhE5jEJpjDVzJd30I/h42KKMouh5LIg4H4hYq0f7rv9a6F9KIU8upi1MpajlhhIF
        Wm4AdXa70alUAdeOJ
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr42273343edc.235.1615969588490;
        Wed, 17 Mar 2021 01:26:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs2IfIabALxEDPdD531JeAvmlPd3oXH08kwxGnDTWawZHEErYQNxcoHlVJ8xZAWJMW4AVeug==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr42273327edc.235.1615969588341;
        Wed, 17 Mar 2021 01:26:28 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id r19sm11964199edp.52.2021.03.17.01.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:26:27 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:26:25 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost: Fix vhost_vq_reset()
Message-ID: <20210317082625.euxknnggg4gv7i5m@steredhat>
References: <20210312140913.788592-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210312140913.788592-1-lvivier@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 03:09:13PM +0100, Laurent Vivier wrote:
>vhost_reset_is_le() is vhost_init_is_le(), and in the case of
>cross-endian legacy, vhost_init_is_le() depends on vq->user_be.
>
>vq->user_be is set by vhost_disable_cross_endian().
>
>But in vhost_vq_reset(), we have:
>
>    vhost_reset_is_le(vq);
>    vhost_disable_cross_endian(vq);
>
>And so user_be is used before being set.
>
>To fix that, reverse the lines order as there is no other dependency
>between them.
>
>Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>---
> drivers/vhost/vhost.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

