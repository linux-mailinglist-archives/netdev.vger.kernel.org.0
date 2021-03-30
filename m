Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920C034E576
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhC3KaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231579AbhC3KaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEHjyrMQ9w02QPNjO0W13IARmEEWc+zV1G/Z4aHbjxc=;
        b=a59M6qNB0Ro60Y3/zCsQuZ+vDMYhMGMDfEvjIWUgKTOscG9jf02dKr1aPA7sfZ5o5zXoPy
        WGW4vTF1827qGmxuLC+WJ3M3YXUfsWeI6IKyRhRhq1L59ucUvJluFUIDD9nup5Ar1BF7jy
        lYWC+/Duh0nnUWFwErLvptPtxho+qdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-erkuKh3WN3mUnZtFmJRtKw-1; Tue, 30 Mar 2021 06:29:58 -0400
X-MC-Unique: erkuKh3WN3mUnZtFmJRtKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3842010866A5;
        Tue, 30 Mar 2021 10:29:57 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FEC519C45;
        Tue, 30 Mar 2021 10:29:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 6/8] geneve: allow UDP L4 GRO passthrou
Date:   Tue, 30 Mar 2021 12:28:54 +0200
Message-Id: <fe0574b12962215a09e2609b6c49a573341ad5b2.1617099959.git.pabeni@redhat.com>
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

