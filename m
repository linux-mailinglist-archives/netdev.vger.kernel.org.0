Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5600928B699
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgJLNfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbgJLNei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:34:38 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D20EC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:34:37 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id c1so5442350uap.3
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rKlAI4VcpxoazHMfmiz07xfIfCv2gl8wbl6h7oKeIcw=;
        b=O1SiDHg0N75UnJq9CLsvCVIYbB3HIpnq+lXG+u77urEnT4Y6aihwAgvRkc+5Hzd2cq
         SznlkCfBSTLBj3Xy+eH3B+uhxQNkVyRzM7/YIkMkdtpZhnJEQEMNgc8JgXVyGo82iXTl
         tpHaRoQQg2jxQ4KfwRMdSDoZFxyFL8L3QkCOM0rRvlU6D4ejP8eYXa3ZbzZFoLz6HQX/
         SMMR9divIfFz9N/6m6hIm7Mowwz4sghjoUJKWaU4zw6JPsEmgkOsGiUi00j9KkGqxKCY
         XlMnSrbmO4WNe2knKg0M1dCn9C26LK3jOYuQGXXBmvizlrKbVfeYrUrx98CVwtLFNSw5
         lLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rKlAI4VcpxoazHMfmiz07xfIfCv2gl8wbl6h7oKeIcw=;
        b=lpXJHMUPSOJt7ARR1adUk/8/09C+uqGwD9lICEIiWJA8Y5RwlgEt28W7K+86QGmJsq
         Aea4emh5fBii3DHezrqZfwDFbNrOWO/mHSg2Vjs0cflcTWzOGAvft/319dk9C65hlksn
         mgq+IZnjMheR1RSwcWqV2vxL04wL8wmXiyv+OQ8TmUbIlkLPW1InC4ikl/nbEOKUI/z1
         bpls/wEVUS9lQz0lmwTw3MfszfrSB2Nt3ZLcEPYFIF3CKP1Fz8vk6iJH33JzSxm5QdlM
         D/7FIZAQLTkbWGcwZUAbnQSWSz3XUZDjaOSyxT450p0nTSam7U6PPTX/kEVkXZaHGsNe
         y+jQ==
X-Gm-Message-State: AOAM531UDxMzEz/QxRq1JCIj+Fa1CwfjG1d6jMNvcQhXXy2DvYIL81tw
        3RT6mtRCoFTdN8Umik7441n5yXUJS2E=
X-Google-Smtp-Source: ABdhPJzCyoiiTgJL0Yni1valGHcX/qkG8E0UwyScnczqnzeIYmfidOcUUgTRvG8UMDweMazTEJubNg==
X-Received: by 2002:ab0:5e95:: with SMTP id y21mr758093uag.21.1602509676261;
        Mon, 12 Oct 2020 06:34:36 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id v2sm1573803vkd.40.2020.10.12.06.34.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 06:34:35 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id p5so3167647vkm.4
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:34:35 -0700 (PDT)
X-Received: by 2002:a1f:1f0d:: with SMTP id f13mr13410484vkf.1.1602509674648;
 Mon, 12 Oct 2020 06:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 12 Oct 2020 09:33:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdHG4n4xRgg0-3-wOEp_kKHrEV-eSH8YeQhMOsUbamCiw@mail.gmail.com>
Message-ID: <CA+FuTSdHG4n4xRgg0-3-wOEp_kKHrEV-eSH8YeQhMOsUbamCiw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] virtio-net: ethtool configurable RXCSUM
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 10:03 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>
> If Rx checksum is disabled, LRO should also be disabled.
>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

I had to recall why we cannot just rely on dev->features and
dev->hw_features to encode the set of feature capabilities, but need
guest_offloads_capable.

Flag NETIF_F_LRO encapsulates multiple VIRTIO_NET_F_GUEST_.. flags,
and a device may advertise a subset. We thus have to bound to the set
learned at probing time.
