Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF7303005
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbhAYXV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:21:56 -0500
Received: from conuserg-07.nifty.com ([210.131.2.74]:45434 "EHLO
        conuserg-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732773AbhAYXS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:18:56 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 10PNHDrF029059;
        Tue, 26 Jan 2021 08:17:15 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 10PNHDrF029059
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616636;
        bh=jz816iUcsrN942sn+8G1ZahN4lP71JfFR3UR8yuy6ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hS3MD/0SZ/oSW94DVbpDux6WQYo4zuszhx9itIx6YF2V5vWYs/DiOQjX1oqcTW2AT
         8urH1Vu5WWSlDsn0oca9Y+tiAsDF3PgZI1AZ6ck8ykmb7wvbQLeEjf4i2TymeVPkoi
         uYQMNtd/xFOqVXffm8RqA/JFY7BwUc2uw8wRNknWy/svlfWQTufjJwsBmItfJTXgV7
         VnpervKUrCYVK4F86RVvGdic8oL+yzw/NfWMx6N8+5v/0mPOhbQ/f94VdTNxetHAJ9
         L1XuteFEc+8nV2sHjhbpT9LI+DiLzGTUaWtZgAX4TkVaZP9+kcbthoS2bAgbmXZGlV
         D4h1tsGeAE7+g==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: switchdev: use obj-$(CONFIG_NET_SWITCHDEV) form in net/Makefile
Date:   Tue, 26 Jan 2021 08:16:57 +0900
Message-Id: <20210125231659.106201-3-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125231659.106201-1-masahiroy@kernel.org>
References: <20210125231659.106201-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_NET_SWITCHDEV is a bool option. Change the ifeq conditional to
the standard obj-$(CONFIG_NET_SWITCHDEV) form.

Use obj-y in net/switchdev/Makefile because Kbuild visits this Makefile
only when CONFIG_NET_SWITCHDEV=y.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/Makefile           | 4 +---
 net/switchdev/Makefile | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index a7e38bd463a4..a18547c97cbb 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -72,9 +72,7 @@ obj-$(CONFIG_VSOCKETS)	+= vmw_vsock/
 obj-$(CONFIG_MPLS)		+= mpls/
 obj-$(CONFIG_NET_NSH)		+= nsh/
 obj-$(CONFIG_HSR)		+= hsr/
-ifneq ($(CONFIG_NET_SWITCHDEV),)
-obj-y				+= switchdev/
-endif
+obj-$(CONFIG_NET_SWITCHDEV)	+= switchdev/
 ifneq ($(CONFIG_NET_L3_MASTER_DEV),)
 obj-y				+= l3mdev/
 endif
diff --git a/net/switchdev/Makefile b/net/switchdev/Makefile
index bd69a3136e76..c5561d7f3a7c 100644
--- a/net/switchdev/Makefile
+++ b/net/switchdev/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the Switch device API
 #
 
-obj-$(CONFIG_NET_SWITCHDEV) += switchdev.o
+obj-y += switchdev.o
-- 
2.27.0

