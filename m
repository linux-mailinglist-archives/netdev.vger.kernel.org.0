Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAA343395
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhCURCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhCURCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8nGXvEhoubQpdfWyC0jAayC/oK8IGGkMku9aG7BE8I=;
        b=TcqXS4U813Ho2ShBjiLBtA06OysvL8gtWdveCPxUQXvHkHUA2CNs9fUqf8J/V34DiSRKBm
        6kH5TILJHM5/Y9cE24Vu0rMYTe8MnIxaY6MKGQI+7O7mwYh93zHWeXCcDV1sJ9urWvMxR0
        RalEGCKXZEtDfC+CrcD62A6lz76OHY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-NYW0WQv7O9eaGSrcMKlj9Q-1; Sun, 21 Mar 2021 13:01:57 -0400
X-MC-Unique: NYW0WQv7O9eaGSrcMKlj9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BE69101371B;
        Sun, 21 Mar 2021 17:01:56 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C2B661F20;
        Sun, 21 Mar 2021 17:01:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 7/8] bareudp: allow UDP L4 GRO passthrou
Date:   Sun, 21 Mar 2021 18:01:18 +0100
Message-Id: <36e55e4f8cff3e54d763c7b67a4d1657870a9b17.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

