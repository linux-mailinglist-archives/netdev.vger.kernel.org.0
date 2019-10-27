Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B44E632A
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 15:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfJ0Onh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 10:43:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34082 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfJ0Onf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 10:43:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id v3so7713227wmh.1;
        Sun, 27 Oct 2019 07:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qE0X3ogtNhn0ebFIC/w7JpP2rq2/beNy9tfdgFGDWNI=;
        b=c0fZnZa8IRC4VhCN+ke+befKGunIOO7DkdhdFaW+KDbpyWHkOsSjIKR9Dc0Rq7Kuj3
         Ncr3xzia093wSTG7NjjuBjEOWtDraFGsGPGhWkXSmkyaYAXRGMlB9f4dUS6EkQJ3h87m
         gfgMYdQ+LpSTpCSfgf/PfkwJXXm4DgWlfZExXMdaoyzWYDpTa17vp2m5Z048vWoi3i00
         rcrdtNHrHcrhEyE+Bb6tefzIrXXhFszP1SO1ADgz7YvTfDTI6Qm+FdmI/a3V8SNTbaez
         LA946Gk8I6ZGviJVfCUYd+IiTIJbKwK2jQvvWcsZQkd97KZuUI6T6IrzGOM5UW8dBgnJ
         N8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qE0X3ogtNhn0ebFIC/w7JpP2rq2/beNy9tfdgFGDWNI=;
        b=Mq0eXFIHbDsV7LucG/66LmzYxDqrpcqLXRjUyiUkrLkHzJIkGVIdI5RrRRC5YmJk4f
         KCdO9z43am4yvwVW/1AUVYFhuFQZifrN6KflBr6xfrTKP63OxNrNEY9H2x4j2c5SLmX6
         r4mWbpxarksGs9dMkNfRoiin504I2IkJNJ6TzLVjoMpeg+pwN816Shhelbv2S3fk7Njr
         xlT+L2AJiBNLFr+ksbwzTMvNLkm9xfb1OTGhLHdCveJon/GbjuGoaYCqWOdTqQD2IDZa
         ofTMoXP10JvEnARCHs9pQoO2KjnLiOqZuhjgZHd3E7uHLA9SE1WoQhUfhb7XCi0W2znd
         nLlA==
X-Gm-Message-State: APjAAAXxIjUdW+C2lFZLp6YJRWy8cHUPEZAN5DesgRcDoPnHWvKz/oYU
        o7TOnLeooGBtrNwie9g6rcI=
X-Google-Smtp-Source: APXvYqyBiUGAZ2CjiSe1OPmeBxzC1CyoaPv3kh/kHYYIFyajS1xQnlY1UJFFT+LYInWLXZcO8WGb+Q==
X-Received: by 2002:a7b:cd86:: with SMTP id y6mr12203560wmj.101.1572187413656;
        Sun, 27 Oct 2019 07:43:33 -0700 (PDT)
Received: from localhost (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id l15sm1194788wme.5.2019.10.27.07.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 07:43:32 -0700 (PDT)
Date:   Sun, 27 Oct 2019 09:12:13 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 08/14] vsock: add vsock_create_connected()
 called by transports
Message-ID: <20191027081213.GC4472@stefanha-x1.localdomain>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-9-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <20191023095554.11340-9-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 11:55:48AM +0200, Stefano Garzarella wrote:
> All transports call __vsock_create() with the same parameters,
> most of them depending on the parent socket. In order to simplify
> the VSOCK core APIs exposed to the transports, this patch adds
> the vsock_create_connected() callable from transports to create
> a new socket when a connection request is received.
> We also unexported the __vsock_create().
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/net/af_vsock.h                  |  5 +----
>  net/vmw_vsock/af_vsock.c                | 20 +++++++++++++-------
>  net/vmw_vsock/hyperv_transport.c        |  3 +--
>  net/vmw_vsock/virtio_transport_common.c |  3 +--
>  net/vmw_vsock/vmci_transport.c          |  3 +--
>  5 files changed, 17 insertions(+), 17 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl21UV0ACgkQnKSrs4Gr
c8j8/ggAyDA6UkgCfi0daj2HF5HCXYLlJ9/XXtklusGF1Wc9tWjzw/GXPdNlYum9
SqWtDu4YlWC3HH5TXKiMuTFjsumU6qJOSXKbPTFOmHdsQAnYeBMB1LZZRAd1O85T
LeBzRaNJjd+3qcjEeGf4gy7TuHGk49qnJaaP9n+SvheaN6DRf4cVJYhVYHf15xnI
qyhbT8cq5YcgszT/mp/D4guFPl9gYFPT7IqFvN8FOhELWmj7q6noJqAlEiUMsOSW
fg8L76b1v8h04Q7iF2lmvUMFu3q9POIgkxqCQcYZzxJUMFLJez2y8nWnRIbNLJnJ
l70AGpwkVMKXrJfa8DwyCI39cmT1Hg==
=06uZ
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
