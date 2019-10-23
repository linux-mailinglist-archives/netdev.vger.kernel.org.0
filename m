Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBFE16CD
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390978AbfJWJ4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:56:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58253 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390977AbfJWJ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aPIIe5WRZMPBUYONsseioAXZoYWf/JAlNNMg8lPt4/Q=;
        b=azPWANGdvj4l7XN7Fvr1B/9iA+AJyk8SeV3A7cvN3uLpWd84r4Xq13Dn4zJx7pNUo6yoS9
        QrhcL7LU8enuJ978G/bzo17GQRjWC4aLgdVmb9lAagq3mAS7sOJ99ziUxYWfZfflBLcNlZ
        2uM8/WKV2zH0Bl3BnSmQ8kP7cluHtbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-FiyjSVSIOxmusT0AUBY3yw-1; Wed, 23 Oct 2019 05:56:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87C66107AD33;
        Wed, 23 Oct 2019 09:56:14 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11CFC5C1B2;
        Wed, 23 Oct 2019 09:56:05 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 01/14] vsock/vmci: remove unused VSOCK_DEFAULT_CONNECT_TIMEOUT
Date:   Wed, 23 Oct 2019 11:55:41 +0200
Message-Id: <20191023095554.11340-2-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: FiyjSVSIOxmusT0AUBY3yw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSOCK_DEFAULT_CONNECT_TIMEOUT definition was introduced with
commit d021c344051af ("VSOCK: Introduce VM Sockets"), but it is
never used in the net/vmw_vsock/vmci_transport.c.

VSOCK_DEFAULT_CONNECT_TIMEOUT is used and defined in
net/vmw_vsock/af_vsock.c

Cc: Jorgen Hansen <jhansen@vmware.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vmci_transport.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 8c9c4ed90fa7..f8e3131ac480 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -78,11 +78,6 @@ static int PROTOCOL_OVERRIDE =3D -1;
 #define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
 #define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
=20
-/* The default peer timeout indicates how long we will wait for a peer res=
ponse
- * to a control message.
- */
-#define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
-
 /* Helper function to convert from a VMCI error code to a VSock error code=
. */
=20
 static s32 vmci_transport_error_to_vsock_error(s32 vmci_error)
--=20
2.21.0

