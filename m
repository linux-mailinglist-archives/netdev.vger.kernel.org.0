Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7D104024
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfKTP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:56:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729198AbfKTP4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574265400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yaTkqQdIWgZMRM72EEX7JTxyVtAAHvFqpyGvxqamTPE=;
        b=U07g0uDuIcSP5s5k+91wxp6XM1VORLSJbuQJnSDrBQQzdW9Uf4w3x0NR1eNEhxRVCjn2mN
        HEGe675YmxqPMphdPyVpEf5nmBdUr13vmfezhwQb6dr2VxfqXFGIQhEFCeYef63p6AvNNa
        5QrLY8aF50QvfDKu4nvWlsqFmxfNio8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-45eM74xEO-qOGdKgyphmHA-1; Wed, 20 Nov 2019 10:56:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 461DB18B9FEE;
        Wed, 20 Nov 2019 15:56:37 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-116-141.ams2.redhat.com [10.36.116.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 672BC67278;
        Wed, 20 Nov 2019 15:56:35 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Mao Wenan <maowenan@huawei.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH net-next] vsock/vmci: make vmci_vsock_cb_host_called static
Date:   Wed, 20 Nov 2019 16:56:34 +0100
Message-Id: <20191120155634.43936-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 45eM74xEO-qOGdKgyphmHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

When using make C=3D2 drivers/misc/vmw_vmci/vmci_driver.o
to compile, below warning can be seen:
drivers/misc/vmw_vmci/vmci_driver.c:33:6: warning:
symbol 'vmci_vsock_cb_host_called' was not declared. Should it be static?

This patch make symbol vmci_vsock_cb_host_called static.

Fixes: b1bba80a4376 ("vsock/vmci: register vmci_transport only when VMCI gu=
est/host are active")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
Hi Dave,
do you think it could go through net-next since it solves a problem
introduced by "vsock: add multi-transports support" series?

Adding R-b from "kbuild test robot" that found the same issue.

Thanks,
Stefano
---
 drivers/misc/vmw_vmci/vmci_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vm=
ci_driver.c
index 95fed4664a2d..cbb706dabede 100644
--- a/drivers/misc/vmw_vmci/vmci_driver.c
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -30,7 +30,7 @@ static bool vmci_host_personality_initialized;
=20
 static DEFINE_MUTEX(vmci_vsock_mutex); /* protects vmci_vsock_transport_cb=
 */
 static vmci_vsock_cb vmci_vsock_transport_cb;
-bool vmci_vsock_cb_host_called;
+static bool vmci_vsock_cb_host_called;
=20
 /*
  * vmci_get_context_id() - Gets the current context ID.
--=20
2.21.0

