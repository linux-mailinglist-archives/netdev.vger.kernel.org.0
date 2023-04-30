Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E8C6F2923
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjD3OHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3OHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F254C19BB
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682863607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/qFwCkDXym+BO05vYF8vpXsanmPn3ffsSFSPl68Sv4Y=;
        b=XYw/CfNoqOxY6vkppd0il0Dg99SI+v1J3/1YUCsofcPnctsnzDTfg0zjMxTl24yWBBYyCG
        kwvbA+q/RINZcGSoSKduOiKttzO6O5DOcjbkW7LDa3eOLN4ESamfNOUXjemZtBXiPOOklF
        6CGduUcJ987g9tDn74UbMfjLNFf84vw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-CRPKVT1qP628cTtjxyWzgQ-1; Sun, 30 Apr 2023 10:06:45 -0400
X-MC-Unique: CRPKVT1qP628cTtjxyWzgQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f315735edeso68216665e9.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682863604; x=1685455604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qFwCkDXym+BO05vYF8vpXsanmPn3ffsSFSPl68Sv4Y=;
        b=NpWaYgChk4g8owuyfOPPiLXy9H9aS/+lFZoeJm5IJFIIC8m7Ur0G5vjKmNGhf4G4e7
         BBgp6VhnDTAEXt1P27AxrXWU/da4tVZAFxcJU6EHN/lM9lNg4eKIlwWTo65ig25Adz8I
         AFsWi23PIxqKGpNs9/DQ1bogoPluYGdLLpe9mYFh6NtLRPfycNy2Cy5oUe/L7Orfe24Z
         aER/S6qjXOItHBqVMmJwH0gr2Fe3XQrOuxlQBtFfw+0uZR6iIDBaoCUw/ydEkQGSxF1R
         C9BtyyQs4Gngfu9PbIPlBkCbo1pDVwCBxn1hPaQwAANuUAL2kcvXsl6wh99QIMoJLf5Z
         KqhQ==
X-Gm-Message-State: AC+VfDz60pwdz6oyR3DDTHtgwyJneoiXnlp9SbcNpJby4x3b4bhGBvKl
        5hDHItt3vX6y+v3Xa9kjkWS16rqfiF+0nfZZMuYDlaz7XdfbPG7nZC7NRiRh3XfxJLvG1vuDW/T
        qbyuf7heJX5+WWSvu
X-Received: by 2002:a7b:c7c4:0:b0:3f1:6f57:6fd1 with SMTP id z4-20020a7bc7c4000000b003f16f576fd1mr8450906wmk.9.1682863604673;
        Sun, 30 Apr 2023 07:06:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ49qr4fnugfdl0poBdeno2pyYNH1DJqISB5JrW9YRnjnc+eSzsu886AyGUm1JWAYtIvaYCRKA==
X-Received: by 2002:a7b:c7c4:0:b0:3f1:6f57:6fd1 with SMTP id z4-20020a7bc7c4000000b003f16f576fd1mr8450897wmk.9.1682863604398;
        Sun, 30 Apr 2023 07:06:44 -0700 (PDT)
Received: from redhat.com ([2.52.139.131])
        by smtp.gmail.com with ESMTPSA id z23-20020a7bc7d7000000b003f1751016desm29757833wmk.28.2023.04.30.07.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:06:43 -0700 (PDT)
Date:   Sun, 30 Apr 2023 10:06:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Message-ID: <20230430100535-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 04:15:15PM +0300, Alvaro Karsz wrote:
> At the moment, if a virtio network device uses vrings with less than
> MAX_SKB_FRAGS + 2 entries, the device won't be functional.
> 
> The following condition vq->num_free >= 2 + MAX_SKB_FRAGS will always
> evaluate to false, leading to TX timeouts.
> 
> This patchset attempts this fix this bug, and to allow small rings down
> to 4 entries.
> The first patch introduces a new mechanism in virtio core - it allows to
> block features in probe time.
> 
> If a virtio drivers blocks features and fails probe, virtio core will
> reset the device, re-negotiate the features and probe again.
> 
> This is needed since some virtio net features are not supported with
> small rings.
> 
> This patchset follows a discussion in the mailing list [1].
> 
> This fixes only part of the bug, rings with less than 4 entries won't
> work.

Why the difference?

> My intention is to split the effort and fix the RING_SIZE < 4 case in a
> follow up patchset.
> 
> Maybe we should fail probe if RING_SIZE < 4 until the follow up patchset?

I'd keep current behaviour.

> I tested the patchset with SNET DPU (drivers/vdpa/solidrun), with packed
> and split VQs, with rings down to 4 entries, with and without
> VIRTIO_NET_F_MRG_RXBUF, with big MTUs.
> 
> I would appreciate more testing.
> Xuan: I wasn't able to test XDP with my setup, maybe you can help with
> that?
> 
> [1] https://lore.kernel.org/lkml/20230416074607.292616-1-alvaro.karsz@solid-run.com/
> 
> Alvaro Karsz (3):
>   virtio: re-negotiate features if probe fails and features are blocked
>   virtio-net: allow usage of vrings smaller than MAX_SKB_FRAGS + 2
>   virtio-net: block ethtool from converting a ring to a small ring
> 
>  drivers/net/virtio_net.c | 161 +++++++++++++++++++++++++++++++++++++--
>  drivers/virtio/virtio.c  |  73 +++++++++++++-----
>  include/linux/virtio.h   |   3 +
>  3 files changed, 212 insertions(+), 25 deletions(-)
> 
> -- 
> 2.34.1

