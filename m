Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1DD57C75F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiGUJRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiGUJRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58B20691D4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658395048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bR+13URxlsE5fUg4TpB1VjQB2DqN5gnlwoyPW0ASkV4=;
        b=iw/Imv9PmgfqY2qXC2EKYrZ2QZrmrOPnLZWVlIJrClIIoC2eootbWaV1/k8+Wj8norcKjL
        07zBOwqSdxJwnD6+WZptfJPrVLmUTjS5pOs2/0w+rj6SNra6MuDBeT0PCwnGupwZOJaBwf
        nSMqF58TPQiF2JtQ7hD6eCkfi3LL1s8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-CkQ6nfePOoG7kUddrHy03g-1; Thu, 21 Jul 2022 05:17:27 -0400
X-MC-Unique: CkQ6nfePOoG7kUddrHy03g-1
Received: by mail-lj1-f197.google.com with SMTP id x21-20020a2e7c15000000b0025d5f706f66so157263ljc.5
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bR+13URxlsE5fUg4TpB1VjQB2DqN5gnlwoyPW0ASkV4=;
        b=MHcxtkWMQXDzH0gvfxa6Rx0AF1zkcHApzXy0gxZcEYZJGX/kujeqtKtcjCnkZ01x4+
         c5A6ctdy2YLvZdBc+i3sfa2ZdyE1YyrxY9TfQiCOIDsH+mOkAFmiW+uC33jw0xhJYtWw
         H2h3TrBZ5SUHjvuWJpGIZQVx+NbRki83l0jnVhG+OcTOS7NJAnHMcJcAtT3we2/Txyjg
         rqhQiGhpClSCFlLalS8seMgJ5ykhe6XtvQdDWkSQWO7iTZ5kY+duFZq984QWMqjX0YG+
         uv6YVonnedGxk7MTofCl/zFXcltSTZXBelV2iuBjQC/+ZpdNNqodvem3pouH1PbW45gY
         XNSA==
X-Gm-Message-State: AJIora+kygt/9k6rJ1YUJFojuoBBPt3F04GI0GdggJjblAHM1lpB8xdb
        Kw7m1SzTNT1XBvsTjBL3MIBX0gsiNA4xHak6wD9KRBAu0fC2QnU9sfeLaqvXO5FHh/Jh72Ff4HT
        D5LjO9eqfywDgla8Ekf7GJIvOpltXq6r9
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id o12-20020ac24c4c000000b00489fe2cc877mr23999864lfk.238.1658395045575;
        Thu, 21 Jul 2022 02:17:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u24Xku7CH2NvwPr1v5mlb7apJiFJtOLNJ3rS6Tv1FeUAK8VufO6AwqK+LPzXVGJzRjJ+q60K4VfTtan1dp7c4=
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id
 o12-20020ac24c4c000000b00489fe2cc877mr23999841lfk.238.1658395045042; Thu, 21
 Jul 2022 02:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 21 Jul 2022 17:17:13 +0800
Message-ID: <CACGkMEtvjy1_NYHOV=VKMWcggYnOUBk3PRue=t0Kd4wtHjfzQg@mail.gmail.com>
Subject: Re: [RFC 0/5] In virtio-spec 1.1, new feature bit VIRTIO_F_IN_ORDER
 was introduced.
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     eperezma <eperezma@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 4:44 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> When this feature has been negotiated, virtio driver will use
> descriptors in ring order: starting from offset 0 in the table, and
> wrapping around at the end of the table. Vhost devices will always use
> descriptors in the same order in which they have been made available.
> This can reduce virtio accesses to used ring.
>
> Based on updated virtio-spec, this series realized IN_ORDER prototype
> in virtio driver and vhost.

Thanks a lot for the series.

I wonder if you can share any performance numbers for this?

Thanks

>
> Guo Zhi (5):
>   vhost: reorder used descriptors in a batch
>   vhost: announce VIRTIO_F_IN_ORDER support
>   vhost_test: batch used buffer
>   virtio: get desc id in order
>   virtio: annouce VIRTIO_F_IN_ORDER support
>
>  drivers/vhost/test.c         | 15 +++++++++++-
>  drivers/vhost/vhost.c        | 44 ++++++++++++++++++++++++++++++++++--
>  drivers/vhost/vhost.h        |  4 ++++
>  drivers/virtio/virtio_ring.c | 39 +++++++++++++++++++++++++-------
>  4 files changed, 91 insertions(+), 11 deletions(-)
>
> --
> 2.17.1
>

