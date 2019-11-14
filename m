Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23444FC32E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKNJ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbfKNJ6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZC4IS+wABP7CjGBt1y2Fdpp5FeX+/EyGMLh5jKY6eME=;
        b=VJoGSgAe2fDS2MxTtqy9S1dMZvkW9ZhkwcerJCFN/csMv5ZzrDtUWEtmq+W3Fd/zQi4ocQ
        QjfyWs+giLEuVfVn2dVKhr3ZyopqO04dVAsApvFX2s5NMzoamrUcUHb/3dqtAF1jUPAtp2
        j+4F1awA64wVaDbpNV5jSraAO8QgfwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-crdwlIMvN4K-IxoPHTS3jQ-1; Thu, 14 Nov 2019 04:58:06 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9AAB107ACC5;
        Thu, 14 Nov 2019 09:58:04 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89442165D3;
        Thu, 14 Nov 2019 09:57:59 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 01/15] vsock/vmci: remove unused VSOCK_DEFAULT_CONNECT_TIMEOUT
Date:   Thu, 14 Nov 2019 10:57:36 +0100
Message-Id: <20191114095750.59106-2-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: crdwlIMvN4K-IxoPHTS3jQ-1
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
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vmci_transport.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 6ba98a1efe2e..cf3b78f0038f 100644
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

