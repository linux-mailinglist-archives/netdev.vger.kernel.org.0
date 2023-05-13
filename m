Return-Path: <netdev+bounces-2331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA257014EA
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 09:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42CC01C20FC8
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 07:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55B910F1;
	Sat, 13 May 2023 07:25:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD3A35
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 07:25:41 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53EB55A2
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 00:25:39 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id xjdGpI56xdpXhxjdGp2faT; Sat, 13 May 2023 09:25:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683962736;
	bh=dm1js3DpRsFKlJofm66SHdhk3V8VdMOV8treZOSyphE=;
	h=From:To:Cc:Subject:Date;
	b=L4AVwkN3WRFE2VGWXmE8i6eudxgexNn3dRrKFYAJWJRrKj+48u86O3eRTa5ol/AZb
	 Ki9sLnHYWUQZp+MCLK3ibmjUQGyAcnJAF8EBGQXsVZlDWXT3VsjwnTkecnfn4yqLaM
	 fOOrZ/SHL5u/GE/OF3m9V/jcaPeYnLVfspvIuswkcrWwNd3Xxb+u3VOzyhsSbwGWEV
	 zJ/lbxD9f2VmW0batGkWiNNU8T6LuGri1miPsYPEyrVDjyilBt6oNJtV+0loIZT4eD
	 VnahBKr19kFjfXZWiHjajVozLbRfVcUA8yYiKfuQaThBgDVBYCHk1Ypw6dVIJZe6wb
	 aZdeC5A4S2CrA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 13 May 2023 09:25:36 +0200
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
Subject: [RESEND PATCH net-next] net: openvswitch: Use struct_size()
Date: Sat, 13 May 2023 09:25:31 +0200
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use struct_size() instead of hand writing it.
This is less verbose and more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It will also help scripts when __counted_by macro will be added.
See [1].

[1]: https://lore.kernel.org/all/6453f739.170a0220.62695.7785@mx.google.com/


Resending now that net-next is re-opened.
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


