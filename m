Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0558634E577
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhC3Kaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhC3KaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8nGXvEhoubQpdfWyC0jAayC/oK8IGGkMku9aG7BE8I=;
        b=LcUf2eXuvrB/BuVruqAmC5AHvdWJ/Mt48fGB5ymu4lnEbG72jwKWmgFD052HL/czJwR3EY
        q5LrdE0qwFJlQhYGnxZSNO3XXige67IGIW3xYl0646Goo79bYkf7PoqQTkAyjMpN+ivu2t
        jZ4snYy3sQ4mZgEeZmkS1rvEoW6KpOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-b49dIGtaNH-7RH_b7KIrTQ-1; Tue, 30 Mar 2021 06:30:00 -0400
X-MC-Unique: b49dIGtaNH-7RH_b7KIrTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A10D1005D5D;
        Tue, 30 Mar 2021 10:29:59 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 934BA19C45;
        Tue, 30 Mar 2021 10:29:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 7/8] bareudp: allow UDP L4 GRO passthrou
Date:   Tue, 30 Mar 2021 12:28:55 +0200
Message-Id: <5a402b99d4d3fbcff6e9fdd02298ccf14164d34c.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous commit, let even geneve
passthrou the L4 GRO packets

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/bareudp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 7511bca9c15ed..edfad93e7b686 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -218,6 +218,7 @@ static struct socket *bareudp_create_sock(struct net *net, __be16 port)
 	if (err < 0)
 		return ERR_PTR(err);
 
+	udp_allow_gso(sock->sk);
 	return sock;
 }
 
-- 
2.26.2

