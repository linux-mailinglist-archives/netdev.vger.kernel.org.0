Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD7C109D94
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfKZMKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:10:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727598AbfKZMKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574770248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bDyE3Rm+4mbLZds5u0BApB4j5+ip47hZxf0KbxNRu2M=;
        b=ItxUdpKLQ6Or2kmMm0c6SoUmc6gdXsjYRtChgz2c9m5Q02WQNtyrE4A+zvn2catLrCQmMf
        AZpnql3qHNyxwyNbauOqGm67bWG2qbPgSrs4pd+57A29WECSUMPUSaCei42KQO+mLB4wo7
        RNuWfatbDvhwnK8OF4jd71ZcyKMP898=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-aIV3a6IXMHu91Szdl6Gviw-1; Tue, 26 Nov 2019 07:10:43 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC22C800D5A;
        Tue, 26 Nov 2019 12:10:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-191.ams2.redhat.com [10.36.116.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCF805D9CA;
        Tue, 26 Nov 2019 12:10:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net 1/2] openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
Date:   Tue, 26 Nov 2019 13:10:29 +0100
Message-Id: <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
In-Reply-To: <cover.1574769406.git.pabeni@redhat.com>
References: <cover.1574769406.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: aIV3a6IXMHu91Szdl6Gviw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers already deal with errors correctly, dump a warn instead.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index d8c364d637b1..e94f675794f1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -882,7 +882,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const st=
ruct sw_flow *flow,
 =09retval =3D ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
 =09=09=09=09=09info->snd_portid, info->snd_seq, 0,
 =09=09=09=09=09cmd, ufid_flags);
-=09BUG_ON(retval < 0);
+=09WARN_ON_ONCE(retval < 0);
 =09return skb;
 }
=20
--=20
2.21.0

