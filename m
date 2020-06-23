Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65734204803
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgFWDlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFWDlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:41:45 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5642C061573;
        Mon, 22 Jun 2020 20:41:43 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t7so206008qvl.8;
        Mon, 22 Jun 2020 20:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=xj/Gsmj77mr3C4A5wAtrYjiCvSAsueU/dEOO6zi1KOs=;
        b=Ck4HGWD6bLiRpoDh5KmS5OpkjfzaA7iBBegJcw10UCvtS/0ctmTmKNgh8halpeIijl
         EQqCq5eZT4Imy2aQPwZqfI4d72Tbl+vi7iY/p/OJQqtmoFX9OwJUawLYNQDKPSdvazse
         mEcWpCbJ/tI20Bg+fqIR3adGKCM/w00QsbUlcE2kQ9dvWyz56nuOy3cIkCfwqI5ZwCAT
         on73lCDR+Gr3skLWw0SDl45bHYt9dmfK0JEQJ9yVDTuTUMCFfHad9jLJosOMtZ4bmRTW
         jULtTq1I6+snRk4Wn8OqnkNuVptcu2lOc8Xec49rNRTObcfwSfdkrgvUf21mTIxuu1vU
         M2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=xj/Gsmj77mr3C4A5wAtrYjiCvSAsueU/dEOO6zi1KOs=;
        b=EDxximV6NvZ8+ND/eMNXBYHUWGlSPGwI/QizFpoR3tCAOAEXzzTdLzJ8Q4ZEaciWWt
         XRL9vUVNReCxBj+hQLYtgH3RITKmPzQXyR7lU5vWQr9mWEYxFTPfdg+Um1U6mxckGTN/
         WB+hbyFDIJlolNM77q+QYZtNyexvkQohzrF17us9nhOAeisHOrovEdMi894IL8DGTbQa
         vz9mZT+Cpfr5ceEpxKk6firoSRi6D/fjnDeTmQmdwG9QegQP2H7xyaQ1RzVA3D+iY+DH
         KC5kgb1ApxFfR5CMse1xiFacxRLKCYfv5zy95SMerzNTxlpbTEFT9/V9vd3LBtVfPkCO
         GDjw==
X-Gm-Message-State: AOAM530Kg7uIgk4MEKyommF5xet2v8WCsqVLo9ika3u9kEMK5uRNEi9K
        HiFBIviX+DXcEpApInvL854=
X-Google-Smtp-Source: ABdhPJwMoc4DPk/9PciwyodrJaIvZbOCelfdU0tIgMGx3WOO+CBKFb94dkmpCu0GKMv8UwA6YSdZbQ==
X-Received: by 2002:a05:6214:1333:: with SMTP id c19mr24617593qvv.72.1592883703067;
        Mon, 22 Jun 2020 20:41:43 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:316f:dfd5:1aaf:37b3])
        by smtp.googlemail.com with ESMTPSA id x26sm10652828qtp.54.2020.06.22.20.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 20:41:42 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        linux-decnet-user@lists.sourceforge.net (open list:DECnet NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/decnet] dn_route_rcv: remove redundant dev null check
Date:   Mon, 22 Jun 2020 23:41:19 -0400
Message-Id: <20200623034133.32589-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev cannot be NULL here since its already being accessed
before. Remove the redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 06b9983325cc..9eb7e4b62d9b 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -670,7 +670,7 @@ int dn_route_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type
 	if (decnet_debug_level & 1)
 		printk(KERN_DEBUG
 			"dn_route_rcv: got 0x%02x from %s [%d %d %d]\n",
-			(int)flags, (dev) ? dev->name : "???", len, skb->len,
+			(int)flags, dev->name, len, skb->len,
 			padlen);
 
 	if (flags & DN_RT_PKT_CNTL) {
-- 
2.17.1

