Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDDB1EFC3E
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFEPNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:13:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39663 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726601AbgFEPNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 11:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591369983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CBCbgdlUb3ZI6Os4sqF1Nk3yry15HNXsqzRa5MBaYn8=;
        b=MYojUUUWIOA2BKLyex5tJGDXRDYA01uk2z4QzWlmUhkRj9hwc9p7sBS0eeobkY6xcl9RlN
        yP13j5htCX/+uUsmSUKnhy/dwXl3HXitVhjAXsXyxSHDrAJuhsXrVzMdN/vCtvJ18/fcFB
        qopEGB7MCSKnuqcZfPWSeTfPHfYF6Sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-zf-xYbqNPg-NokeOSQVPZQ-1; Fri, 05 Jun 2020 11:12:59 -0400
X-MC-Unique: zf-xYbqNPg-NokeOSQVPZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FD1A102C8A0;
        Fri,  5 Jun 2020 15:12:44 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-69.ams2.redhat.com [10.36.114.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02D2D10016DA;
        Fri,  5 Jun 2020 15:12:42 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] vsock/vmci: make vmci_vsock_transport_cb() static
Date:   Fri,  5 Jun 2020 17:12:41 +0200
Message-Id: <20200605151241.468292-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following gcc-9.3 warning when building with 'make W=1':
    net/vmw_vsock/vmci_transport.c:2058:6: warning: no previous prototype
        for ‘vmci_vsock_transport_cb’ [-Wmissing-prototypes]
     2058 | void vmci_vsock_transport_cb(bool is_host)
          |      ^~~~~~~~~~~~~~~~~~~~~~~

Fixes: b1bba80a4376 ("vsock/vmci: register vmci_transport only when VMCI guest/host are active")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vmci_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 4b8b1150a738..8b65323207db 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2055,7 +2055,7 @@ static bool vmci_check_transport(struct vsock_sock *vsk)
 	return vsk->transport == &vmci_transport;
 }
 
-void vmci_vsock_transport_cb(bool is_host)
+static void vmci_vsock_transport_cb(bool is_host)
 {
 	int features;
 
-- 
2.25.4

