Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEF8D0E01
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfJILwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:52:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38715 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfJILwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:52:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so2560139wro.5;
        Wed, 09 Oct 2019 04:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7VJ857xf7kJYbDvUJe6HpwVbXrE5Sy9/QjGlnISt5HI=;
        b=T7djoM651ASFiFStwI/GcZ1ev87dCbWYHE4844UaAiakzYGNKTEdAI6/YNqDn7Wi/4
         ZP4Dz/F3ge+7+PuusD6uSZp62tzMYb9gOX8y3qdTiQ7JE9ezVO2RkrVUemDK0YhxZHKN
         V5XgqFhS6TMLfO7W47Xl8aHEAdSPe54UsqJ+Rr9XLuTy8W7ykO6UzrVH6PyT0SJ4eepl
         0t/fizwIdnfLxT612IAaLs6mA3A4hYhCJe97tIaS701tBHccNS6OLgBQC9WOg0dZIMDl
         SrF8ICiBeLIks97sM6yd9X9Jw21ImVbBqur27N6Fdup98+vGlbyF5r+Q44lCgqPUSsGY
         CDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7VJ857xf7kJYbDvUJe6HpwVbXrE5Sy9/QjGlnISt5HI=;
        b=hDR1ogLG4Q6O+YCSwJlFRoY5Rf+tA4ZmQcvjCrDpseEYxI3PTpn1BOdIM1cINkqn09
         8fU7fEa4rUoox8FQC/n2siGh8YHqhrmYvKW/iTgkc/8cflURF97tGim2a0erq+Qit7CE
         oyDD5toOdKXYzfZJk5WR4GEaGK9VY1eQox8jiqM9FJWJvOAWdwcM7c6Wuvysu/xbJc92
         DfrAgOWtgrHw1KoM/Bn8yfXKM6yfD7KhrU7EWp3tBBuypGsyIFm4Tv24M50Tb6eLrdT/
         ty+Vq9zQz6nIxT5hP/cleGx+RPwiiiCbMMUY9qg1yaC5r0H5Uufc/ksxP+TOtVH6QZ63
         6JOQ==
X-Gm-Message-State: APjAAAU1WKEYHt+9gio+cXqyI1smxHtrah+l37qoRkJLmGG3X9WeL3Hb
        P5ZDwJTzZ3YY2VOUPXjbAO8=
X-Google-Smtp-Source: APXvYqyvW0+QHKMoLgMknuglsyzr1heZ22+8CzIumVTWiRFwX8xngBSj/o885RGQvdjZD+abrBDN+w==
X-Received: by 2002:a05:6000:1288:: with SMTP id f8mr2476859wrx.111.1570621954039;
        Wed, 09 Oct 2019 04:52:34 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id r140sm3122984wme.47.2019.10.09.04.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:52:33 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:52:31 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 05/13] vsock/virtio: add transport parameter to the
 virtio_transport_reset_no_sock()
Message-ID: <20191009115231.GF5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-6-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yRA+Bmk8aPhU85Qt"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-6-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yRA+Bmk8aPhU85Qt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:55PM +0200, Stefano Garzarella wrote:
> We are going to add 'struct vsock_sock *' parameter to
> virtio_transport_get_ops().
>=20
> In some cases, like in the virtio_transport_reset_no_sock(),
> we don't have any socket assigned to the packet received,
> so we can't use the virtio_transport_get_ops().
>=20
> In order to allow virtio_transport_reset_no_sock() to use the
> '.send_pkt' callback from the 'vhost_transport' or 'virtio_transport',
> we add the 'struct virtio_transport *' to it and to its caller:
> virtio_transport_recv_pkt().
>=20
> We moved the 'vhost_transport' and 'virtio_transport' definition,
> to pass their address to the virtio_transport_recv_pkt().
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c                   |  94 +++++++-------
>  include/linux/virtio_vsock.h            |   3 +-
>  net/vmw_vsock/virtio_transport.c        | 160 ++++++++++++------------
>  net/vmw_vsock/virtio_transport_common.c |  12 +-
>  4 files changed, 135 insertions(+), 134 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yRA+Bmk8aPhU85Qt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dyf8ACgkQnKSrs4Gr
c8ipQAf+N9DOIP9BQ9hDc3C/yWPRdpws712iHQbOHVNiBXDKyxZsYFY51fCC7KyF
9YxSDHJ+9RDm2jzHdItNAwmxXaSpULxrORIVG2c67hxwahN9r90kpWe+yp90NJR9
WPk9aEgIxgSbypf1nzAbI4ZqJDmTXq7zd3yG6QngmvRhrYF0s81JSSYeVo+rN96G
qFFiYYEEA7nlESBV9INveLYF1W9qtNIyy0IgxM3gCrWOkNbRYTWDNAnBEipM/siE
apf48ghnlNeD77gwbjk0SREQStWdle319cCM03Fw1kYT4WoUOOulI2B2opJ2N0qt
eDpkxHTBrmJpGg+NU9sLUblRs7Rikg==
=d4Pb
-----END PGP SIGNATURE-----

--yRA+Bmk8aPhU85Qt--
