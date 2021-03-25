Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D203497EA
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCYRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:25:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhCYRZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEHjyrMQ9w02QPNjO0W13IARmEEWc+zV1G/Z4aHbjxc=;
        b=M9uK8M/IITldGkhuRXpo+VsNJVIxPSbfkyWXp/3G7EdbT70sA6AqEW8iUUtSf9ooOqI+/h
        3U0RhJdK4dIml3aHzGjX0GJG2JeOE6PIE9+1OOh4CgGvMhSGHxYpNH9NKiYkWdyPkAOS8u
        U6uqx22SEtC7JnCJtmUPFel2yG3Sgi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-OuwRvMXtNIGPTlQVxrtDCA-1; Thu, 25 Mar 2021 13:24:57 -0400
X-MC-Unique: OuwRvMXtNIGPTlQVxrtDCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 608CE101A016;
        Thu, 25 Mar 2021 17:24:33 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF28F5C241;
        Thu, 25 Mar 2021 17:24:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 6/8] geneve: allow UDP L4 GRO passthrou
Date:   Thu, 25 Mar 2021 18:24:05 +0100
Message-Id: <5b02ee61107d7bd146d14e984fdb7f78aa0a966a.1616692794.git.pabeni@redhat.com>
In-Reply-To: <cover.1616692794.git.pabeni@redhat.com>
References: <cover.1616692794.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the previous commit, let even geneve
passthrou the L4 GRO packets

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4ac0373326efd..5d7a2b1469f4c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -461,6 +461,7 @@ static struct socket *geneve_create_sock(struct net *net, bool ipv6,
 	if (err < 0)
 		return ERR_PTR(err);
 
+	udp_allow_gso(sock->sk);
 	return sock;
 }
 
-- 
2.26.2

