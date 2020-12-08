Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08372D269F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgLHIvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:51:55 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:39681 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgLHIvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 03:51:54 -0500
Received: from orion.localdomain ([95.117.39.192]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MuDLZ-1jsNl916uj-00uX3P; Tue, 08 Dec 2020 09:49:14 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: 8021q: vlan: reduce noise in driver initialization
Date:   Tue,  8 Dec 2020 09:49:12 +0100
Message-Id: <20201208084912.20949-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:u/NqGZSnUD2+T9ooHNSky1mY6yEspYgStNGc0UKP62/LyrygxgX
 CMLPSJR2MW5KKlhYWQUCzY79MDqB3xJasAvcOWyt719ryMEZLqDPTZhXPNmtSsY1JpCZnaN
 jPvnp5z8dni4VoqMbuCA4g8/yAIFLTDRw31dAayUyFMWAtbm7jKn6cC5ODnehCXpGPL48mq
 Q4L5Dx8mN4oXUFuBQP9RQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1VQV3dkUVGY=:Mif1RSRLfYd57saG2d+UJx
 cuHN4Nc905Vpe2X0ejHif99kvfBuqNdtYxt1SgMeXK33xYdR2CvX7mxUPc/MZc9vOCfGEDD2s
 fUj/Vzhd+1XjDbpPSD1LgljPuFel8gLZ+XFY8w9WfEcGlAoHh7PYZjQxGHl/dC79afcZfKEOr
 ZT5xaqB4xToAJg1eMDeBSePELNPCmKoHnLHFhHKVr+a43YhFGhNwCs1TwTfaKmHVZMExQnMZ5
 d9AX615vE6GIEEFunh01C3f0yhl7BlOJCUs3NN+ytWsjDTJRwlugER60o9cKhlsC6z7/aJ+BJ
 31NpiBRvDNtZ8fvImRFi53nls7JrjEu1mefQRCOkd4m4tFvIYn8f3muBW+VtRjLCtfBG2TINo
 laiMDxtlKlRPJXMUL1Qon8pv/360/DLvCCX8J9xplZoWVkaWq0oYzXqz6gbGp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If drivers work properly, they should be silent. Thus remove the
unncessary noise von initialization.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/8021q/vlan.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index f292e0267bb9..9f4b1b9a37e4 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -42,9 +42,6 @@
 
 unsigned int vlan_net_id __read_mostly;
 
-const char vlan_fullname[] = "802.1Q VLAN Support";
-const char vlan_version[] = DRV_VERSION;
-
 /* End of global variables definitions. */
 
 static int vlan_group_prealloc_vid(struct vlan_group *vg,
@@ -687,8 +684,6 @@ static int __init vlan_proto_init(void)
 {
 	int err;
 
-	pr_info("%s v%s\n", vlan_fullname, vlan_version);
-
 	err = register_pernet_subsys(&vlan_net_ops);
 	if (err < 0)
 		goto err0;
-- 
2.11.0

