Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C721E43B100
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhJZLVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235424AbhJZLVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:21:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635247120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5d7gHBZazZOwKrch+gLmZ+IqICWgqP85pDZUly7TWn0=;
        b=BSOPz4+u9tVlzemHTGx8DRx+rABkDM1akUtheLNzBGP7dHTiEO9cecfooRzGne5pi9J9xI
        /MLKWoebunphefLzj15PN8iNmV9vfjl8zTdZd0W5pMr+ws4vmJ+vIH1BHNnDK+druCWAW6
        WEWU05icEo+bkfM4OS91QbhfXf+WiXU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-gd_UAW2PNGm530if1NXyow-1; Tue, 26 Oct 2021 07:18:39 -0400
X-MC-Unique: gd_UAW2PNGm530if1NXyow-1
Received: by mail-ed1-f69.google.com with SMTP id k28-20020a508adc000000b003dd5e21da4bso5097216edk.11
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 04:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5d7gHBZazZOwKrch+gLmZ+IqICWgqP85pDZUly7TWn0=;
        b=hLfNS9rQRWNl3Z4G8u4biIJaxQH9M0/Dw6PVmx4Qe78PUZvbTk/FQO1uKasIcUQ1R+
         ptUQsyY5An8uB5Dcq00BcEykX27aFSiRNlxc9pyttwqazX6H+aHjUFYPynTrmnsEUsnM
         gRRBhHH3wf8TXOTfFKcPhWYKIqGz8DRaDdrI5OvLTTT47GYhhorY9uCR8fIzY1BH2CRc
         UL6V4m7ibFrZAC7PB3gO4+Ri7S+dZBV+chyPMILnC9c+T3SDoWaI+o7v4wX0CFfD3Iiq
         Xknh4vo4TOmr9Rpenm0vf4euAJycuOrGW7ylnzT5LHfg3KyfGbHUbHVqrZhoCZ21Q8Do
         fSrQ==
X-Gm-Message-State: AOAM530/2CtEP7/GnDFezZZvuzQ4S2/otIwHz17+TkchVk8VfMEGQbBm
        eZb2701depDSAhymNXAgkmXaAXhiD7chP8ok/LNbgCBuvTSYcuDURLp2frya763zwgf5WWfLhzF
        bh+0GiBDdo79ZjIsz
X-Received: by 2002:a17:907:94cb:: with SMTP id dn11mr10234348ejc.481.1635247118098;
        Tue, 26 Oct 2021 04:18:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz63YvZ/9Kc/uXShHmBdC1rnHjFeqjAByBYS0jrsmNB++hzibEdtagftjF5cyjQiQ2o8hyMCA==
X-Received: by 2002:a17:907:94cb:: with SMTP id dn11mr10234329ejc.481.1635247117908;
        Tue, 26 Oct 2021 04:18:37 -0700 (PDT)
Received: from steredhat (host-79-30-88-77.retail.telecomitalia.it. [79.30.88.77])
        by smtp.gmail.com with ESMTPSA id z4sm12026897edd.46.2021.10.26.04.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 04:18:37 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:18:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 07/10] vsock/loopback: implement copy_peercred()
Message-ID: <CAGxU2F409zp+7qOXyR-ejM3ivSMai9gkc+jzd4aTmOeZGVsNDw@mail.gmail.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
 <20211021123714.1125384-8-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021123714.1125384-8-marcandre.lureau@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 04:37:11PM +0400, Marc-André Lureau wrote:
>Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
>---
> net/vmw_vsock/vsock_loopback.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 169a8cf65b39..59317baa4e5c 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -41,6 +41,12 @@ static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
>       return len;
> }
>
>+static void vsock_loopback_copy_peercred(struct sock *sk, struct virtio_vsock_pkt *pkt)
>+{
>+      /* on vsock loopback, set both peers by swaping the creds */
>+      sock_swap_peercred(sk, sk_vsock(pkt->vsk));
>+}
>+

It's a bit hacky set also the cred of `pkt->vsk`. I think here we should
only copy the cred of the remote peer.

Addind the call to t->copy_peercred() in the 
virtio_transport_recv_connecting() will set the other side.

Thanks,
Stefano

