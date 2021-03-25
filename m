Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7158B3497E7
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCYRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhCYRYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8nGXvEhoubQpdfWyC0jAayC/oK8IGGkMku9aG7BE8I=;
        b=JBQChQwGaJVaJi9XaY+lXVYa/36J6NqQ2NqL28ckejlasGKEMquB0toQNDQHQVYQugkakQ
        7meBii/A70DYsR/7XqsggSNab3uYtdGu0+xHA9PVb1iA0koVDXVNjIvN7Ru+heWOyIuZ/+
        2TUQsGJuE7ZFVUv5J4P8NbuW7HNj+cc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-z9we8UGZNqSfbvQaKdnKEQ-1; Thu, 25 Mar 2021 13:24:49 -0400
X-MC-Unique: z9we8UGZNqSfbvQaKdnKEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B6251059967;
        Thu, 25 Mar 2021 17:24:35 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B56125C3DF;
        Thu, 25 Mar 2021 17:24:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 7/8] bareudp: allow UDP L4 GRO passthrou
Date:   Thu, 25 Mar 2021 18:24:06 +0100
Message-Id: <b8715d3abee5153b835c092aa1ba4cfb76517d6a.1616692794.git.pabeni@redhat.com>
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

