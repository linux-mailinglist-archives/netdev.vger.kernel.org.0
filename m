Return-Path: <netdev+bounces-709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 332F16F92FE
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5396E1C21B2B
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 16:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE738A953;
	Sat,  6 May 2023 16:04:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3667259C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:04:26 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-11.smtpout.orange.fr [80.12.242.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82437695
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:04:21 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id vKOPpaWk2Mk9uvKOQpAa5h; Sat, 06 May 2023 18:04:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683389060;
	bh=0FotBQHha+qZRI5XXIk6G0iRigNGwWlnzMiCXh1rLH4=;
	h=From:To:Cc:Subject:Date;
	b=hzhoxFp4qyXukAuHJwGCYHcARfYcqtaflHFyYmnwCigie8I9Dkr0YB30gX/hsHSDH
	 82HIL/wNNcR/7rkugu9UBXo4MG0m+SFLSc/luFK5VbaQzEqA6fnbEUwvVBcqKu+eSQ
	 FsaUvN9pb0a311jkTEzOvsokL9rtmSS6VNoslvbPgEeMx1PVIjJhepH3BqegU5+TKA
	 RH7zhU2aND9zTSbmOi38vS3auJLVG/tdPEg2wceGnLS1Jh3TKzgQVrQgApvUvAFHMA
	 p/XH7iws/UBPoiW5cZmJun5f2YIZ+pZME0lKx4ast4MF3UZg51mUydDGsqpZ2q6bqC
	 2vGIF8YaYvSDQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 06 May 2023 18:04:20 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Pravin B Shelar <pshelar@ovn.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org,
	dev@openvswitch.org
Subject: [PATCH net-next] net: openvswitch: Use struct_size()
Date: Sat,  6 May 2023 18:04:16 +0200
Message-Id: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use struct_size() instead of hand writing it.
This is less verbose and more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It will also help scripts when __counted_by macro will be added.
See [1].

[1]: https://lore.kernel.org/all/6453f739.170a0220.62695.7785@mx.google.com/
---
 net/openvswitch/meter.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index f2698d2316df..c4ebf810e4b1 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -69,9 +69,7 @@ static struct dp_meter_instance *dp_meter_instance_alloc(const u32 size)
 {
 	struct dp_meter_instance *ti;
 
-	ti = kvzalloc(sizeof(*ti) +
-		      sizeof(struct dp_meter *) * size,
-		      GFP_KERNEL);
+	ti = kvzalloc(struct_size(ti, dp_meters, size), GFP_KERNEL);
 	if (!ti)
 		return NULL;
 
-- 
2.34.1


