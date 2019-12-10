Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4BB118A63
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfLJOGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:06:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49595 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727320AbfLJOGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:06:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575986766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cYSQHCTDQkKzmRIgQpyk3DnPt+k/A4ckdhU2f8Or6g=;
        b=P2DE1MnXKTFdNhwL++hM0iTHgdmSS0Ase0l3GfVetA/M5pY7YcKz1NU/sHpaXk4HEEd8/6
        VN5jvrHSbnuNBb+zQcZCVqm+Lp7x/dv0p1ElczQ3mD14zSOLxmav74/jOQbLQ3U2Sq/TBH
        gWnnf0Klz3H454bFMiTNHQCymWs9Wfs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-QsUfGq7HPJmz7kgHiLOIsA-1; Tue, 10 Dec 2019 09:06:03 -0500
Received: by mail-wr1-f72.google.com with SMTP id t3so8932937wrm.23
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CI3qbc7xp4DF6AaDOfblCvC5kTkzEe7UO4aRTK6V7jk=;
        b=C5ZVmRTgYCoGAUv887Y8CcfsU57I3nPXxf/sP/B2z0DwH0X3E5pRMNzTdPVxhVkTy4
         2zAHxiew607CKGM9pghctRgttE0aJ/o/l5zVIwkK9WKcZA1E/oRRZmQ0HElOhaGmbywc
         qZEpPHYky0Z0jjD6tuIU4io0y1aoZTzpV1l/zq9SUq9QIAsjdGPHEs+r51mZ/QLbAFtE
         9VHps6aIGG2QVK7dfaOo8Zweu7L6lPDm52c6FLqxWKH/HPP/nnWKKCv6wLuBSkBNMSFd
         Jyj1QAvXp0++5rYWptsTTLmtlwSQGNjGrwRdPxQgHH2PLONvN3wAiq721NEqLkqjN+hr
         046w==
X-Gm-Message-State: APjAAAXw/Xx+o6Y2FfVK1zA/oc0gwLolMm9AzVs0Pq5jvwNEDztOicJO
        XaCxzEgoIaNUzO2j582J6PH1hN37zfYqSxXbhCgllvNNVA7KkDWvNPSLbmqlcD2lVE1mMZKxLoI
        nR93RF1nwDNKoPiRT
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr5415222wmm.70.1575986762103;
        Tue, 10 Dec 2019 06:06:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqzt2DwRGDx/tfuLDX74AYEnOhZaQrk2tBhSVe7oGiWrvR5kBtkcogM60airAVN4tsBt+f/Tiw==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr5415198wmm.70.1575986761941;
        Tue, 10 Dec 2019 06:06:01 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id a5sm3131833wmb.37.2019.12.10.06.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:06:01 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:05:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191210090505-mutt-send-email-mst@kernel.org>
References: <20191206143912.153583-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191206143912.153583-1-sgarzare@redhat.com>
X-MC-Unique: QsUfGq7HPJmz7kgHiLOIsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> When we receive a new packet from the guest, we check if the
> src_cid is correct, but we forgot to check the dst_cid.
>=20
> The host should accept only packets where dst_cid is
> equal to the host CID.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

what's the implication of processing incorrect dst cid?
I think mostly it's malformed guests, right?
Everyone else just passes the known host cid ...

> ---
>  drivers/vhost/vsock.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 50de0642dea6..c2d7d57e98cf 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -480,7 +480,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_w=
ork *work)
>  =09=09virtio_transport_deliver_tap_pkt(pkt);
> =20
>  =09=09/* Only accept correctly addressed packets */
> -=09=09if (le64_to_cpu(pkt->hdr.src_cid) =3D=3D vsock->guest_cid)
> +=09=09if (le64_to_cpu(pkt->hdr.src_cid) =3D=3D vsock->guest_cid &&
> +=09=09    le64_to_cpu(pkt->hdr.dst_cid) =3D=3D
> +=09=09    vhost_transport_get_local_cid())
>  =09=09=09virtio_transport_recv_pkt(&vhost_transport, pkt);
>  =09=09else
>  =09=09=09virtio_transport_free_pkt(pkt);
> --=20
> 2.23.0

