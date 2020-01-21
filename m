Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12141440F6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgAUPvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:51:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729501AbgAUPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579621863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eMIlB257RM/m/+0lsubXpXw7AZgmiGqc6GHCz5AcBZA=;
        b=EyzzX8FchbI8IHG3v/za0RO0FaA8fSr+WqrpZzGyli7s+LknqLQZhzEzcjp4uUO2ADxrHT
        F3siZkAPv3XH7aBBGOV0bTL3zTc8J7B3PSSEHc+xblG7LvjCEV71VWhyDh/YNxVCERPIDK
        FwpO01zV7nVzIqlK6prlokUXSd+U8mY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-rcG6IqFPOdWH8joOKQsrfQ-1; Tue, 21 Jan 2020 10:50:59 -0500
X-MC-Unique: rcG6IqFPOdWH8joOKQsrfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7248618B5FA0;
        Tue, 21 Jan 2020 15:50:57 +0000 (UTC)
Received: from localhost (ovpn-117-223.ams2.redhat.com [10.36.117.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A3CC845C7;
        Tue, 21 Jan 2020 15:50:54 +0000 (UTC)
Date:   Tue, 21 Jan 2020 15:50:53 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200121155053.GD641751@stefanha-x1.localdomain>
References: <20200116172428.311437-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

What should vsock_dev_do_ioctl() IOCTL_VM_SOCKETS_GET_LOCAL_CID return?
The answer is probably dependent on the caller's network namespace.

Ultimately we may need per-namespace transports.  Imagine assigning a
G2H transport to a specific network namespace.

vsock_stream_connect() needs to be namespace-aware so that other
namespaces cannot use the G2H transport to send a connection
establishment packet.

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4nHd0ACgkQnKSrs4Gr
c8jZrQf/TRB2zBeMXsyYPUoUt2OUY/g4u8e60E+RzcZ4/AxMVlcoaGKuKtNk4DzL
Z+owz+Skn/cI4fcj0XUJrs8/O9Oqwtng0PXbIUE2sUxgd+xkB9j/zMpnwUwAHejI
M67cUcW7U6bo91TkPyp6hhjurVeMTqhxs2FYiDXuOWYxEAJwK+Rot5714FbNqujY
A7/lzlRk8GtJRI5OtH+IQaaE3y7DXzYZafwt/Vkr+LJHGSDtLoImGiziGgj/F4YB
SHxT1+d5fu9xiugvjiQFsA8l6uZjOQSQUXLbjLk3bRWRtRVV9Oa64pufh8B5yI0J
MEc1knCZqHNXlMS7KlHgjY7zhJcsnw==
=lL1o
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--

