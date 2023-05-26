Return-Path: <netdev+bounces-5783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F12E712BBE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27BCC28191D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7145328C2A;
	Fri, 26 May 2023 17:27:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D23271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:27:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E618D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685122056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WfImwx6ANvfYODSJStVm7dBX9qtlhxDtNe8BZxfBw5w=;
	b=dEAiFUj5wmlHvTb18HNHigbDtqHuLGXtIqggdcN6fz3xDHwZteRx2BeKOvbvr1l61DFj5F
	ho529YIkk5juDI+tdN+UDUxVbIzAV+menW5ghaHQ8SUOYwZjYGNv+fdMh1xG/IXAVRktly
	F4ggGetxRq2Viz8KNIKlOSTqpnjy0rs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-fjFMXfz8NXaIMkaaZLgflA-1; Fri, 26 May 2023 13:27:33 -0400
X-MC-Unique: fjFMXfz8NXaIMkaaZLgflA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60CFD185A791;
	Fri, 26 May 2023 17:27:33 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.190])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1790F1121314;
	Fri, 26 May 2023 17:27:31 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com,
	roopa@nvidia.com,
	razor@blackwall.org
Subject: [PATCH iproute2-next] bridge: vni: remove useless checks on vni
Date: Fri, 26 May 2023 19:27:20 +0200
Message-Id: <ebcffc302b5886a71a3e7aaec4561be2d65de30f.1685095619.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After the (d == NULL || vni == NULL) check, vni cannot be NULL anymore.

This remove two useless conditional checks on vni value:
- the first check cannot be true, so remove the whole conditional block
- the second check is always true, so remove the check

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 bridge/vni.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/bridge/vni.c b/bridge/vni.c
index 940f251c..77328a4f 100644
--- a/bridge/vni.c
+++ b/bridge/vni.c
@@ -138,14 +138,8 @@ static int vni_modify(int cmd, int argc, char **argv)
 		return -1;
 	}
 
-	if (!vni && group_present) {
-		fprintf(stderr, "Group can only be specified with a vni\n");
-		return -1;
-	}
-
-	if (vni)
-		parse_vni_filter(vni, &req.n, sizeof(req),
-				 (group_present ? &daddr : NULL));
+	parse_vni_filter(vni, &req.n, sizeof(req),
+			 (group_present ? &daddr : NULL));
 
 	req.tmsg.ifindex = ll_name_to_index(d);
 	if (req.tmsg.ifindex == 0) {
-- 
2.40.1


