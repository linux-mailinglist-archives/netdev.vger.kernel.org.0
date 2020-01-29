Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3014CC7C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA2Obe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:31:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbgA2Obe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580308293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G7VPQyEy9jq501f9dCw0P5i1lWTGCoQFQqkVwBaZvh0=;
        b=Qo4uGXivZHOj4uZ9Ru4jyGoYSQkRcHxzi4rEttrCZBearSWhHP8vKOSDgmdPMnOb31MAQc
        bq+kQ6r6iqnG0xke1Q0vfZGp6PkPUIBj1bmrZZlAtMZ4IobR1JKtKnqNrhifsdRViR4lQ4
        W9eTOwe8xvr9Zs6CbMMR7Katr969x4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-pkhO9K4wOqSNieIqIQ8dEQ-1; Wed, 29 Jan 2020 09:31:31 -0500
X-MC-Unique: pkhO9K4wOqSNieIqIQ8dEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E5308F3695;
        Wed, 29 Jan 2020 14:31:30 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-116-61.ams2.redhat.com [10.36.116.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2230D10027BA;
        Wed, 29 Jan 2020 14:31:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ip link: xstats: fix TX IGMP reports string
Date:   Wed, 29 Jan 2020 15:31:11 +0100
Message-Id: <fce759168882726ddb51410ba35faf88b9c31970.1580307681.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This restore the string format we have before jsonification, adding a
missing space between v2 and v3 on TX IGMP reports string.

Fixes: a9bc23a79227a ("ip: bridge: add xstats json support")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/iplink_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 06f736d4dc710..868ea6e266ebe 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -742,7 +742,7 @@ static void bridge_print_stats_attr(struct rtattr *at=
tr, int ifindex)
 			print_string(PRINT_FP, NULL, "%-16s      ", "");
 			print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
 				  mstats->igmp_v1reports[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v2", "v2 %llu",
+			print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
 				  mstats->igmp_v2reports[BR_MCAST_DIR_TX]);
 			print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
 				  mstats->igmp_v3reports[BR_MCAST_DIR_TX]);
--=20
2.24.1

