Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65DD4094
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfJKNIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbfJKNIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:08:09 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F4703067288;
        Fri, 11 Oct 2019 13:08:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-54.ams2.redhat.com [10.36.117.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AE6160A9F;
        Fri, 11 Oct 2019 13:08:07 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] vsock: add half-closed socket details in the implementation notes
Date:   Fri, 11 Oct 2019 15:07:57 +0200
Message-Id: <20191011130758.22134-2-sgarzare@redhat.com>
In-Reply-To: <20191011130758.22134-1-sgarzare@redhat.com>
References: <20191011130758.22134-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 11 Oct 2019 13:08:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmci_transport never allowed half-closed socket on the host side.
Since we want to have the same behaviour across all transports, we
add a section in the "Implementation notes".

Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2ab43b2bba31..27df57c2024b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -83,6 +83,10 @@
  *   TCP_ESTABLISHED - connected
  *   TCP_CLOSING - disconnecting
  *   TCP_LISTEN - listening
+ *
+ * - Half-closed socket is supported only on the guest side. recv() on the host
+ * side should return EOF when the guest closes a connection, also if some
+ * data is still in the receive queue.
  */
 
 #include <linux/types.h>
-- 
2.21.0

