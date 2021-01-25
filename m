Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B13302FF7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbhAYXSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:18:38 -0500
Received: from conuserg-07.nifty.com ([210.131.2.74]:45009 "EHLO
        conuserg-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732868AbhAYXS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:18:28 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 10PNHDrG029059;
        Tue, 26 Jan 2021 08:17:16 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 10PNHDrG029059
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616637;
        bh=iXq4jdB7UEgroRe4zKSNMFcBItuQhSVkop/2HLSPejI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxHo4zwhczdB519VerKT+NnywXOHW/lPe7HSLefNfu7T4NiBe77sKVNPfT/TZf7K+
         DbaOxzyYw9poE/bjeLeMMBupB2fKFT5SvSGsgKfAAzULfEiGhSg26yn3aSROCQLsJA
         I8z0xvPo7kERLuIU/JCJgx7QnYo4VljSH82Hd6mC4YrnjRdyz19sYolM5NsVree6/R
         /3uJCnEeSduxXjm/lEzmqlUSooM09F4Pz1e6pVbWg4+P35C/OTsKrAEfUtgZ2nGNV9
         xtZk4qqHPZ2MQ2Us7E4gyTAfyex47TVm4DLK0+H5t1j848hNd3PwDJoIZq+L/sj93O
         aT/zHjNu7t4Yg==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: l3mdev: use obj-$(CONFIG_NET_L3_MASTER_DEV) form in net/Makefile
Date:   Tue, 26 Jan 2021 08:16:58 +0900
Message-Id: <20210125231659.106201-4-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125231659.106201-1-masahiroy@kernel.org>
References: <20210125231659.106201-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_NET_L3_MASTER_DEV is a bool option. Change the ifeq conditional
to the standard obj-$(CONFIG_NET_L3_MASTER_DEV) form.

Use obj-y in net/l3mdev/Makefile because Kbuild visits this Makefile
only when CONFIG_NET_L3_MASTER_DEV=y.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/Makefile        | 4 +---
 net/l3mdev/Makefile | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index a18547c97cbb..9ca9572188fe 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -73,9 +73,7 @@ obj-$(CONFIG_MPLS)		+= mpls/
 obj-$(CONFIG_NET_NSH)		+= nsh/
 obj-$(CONFIG_HSR)		+= hsr/
 obj-$(CONFIG_NET_SWITCHDEV)	+= switchdev/
-ifneq ($(CONFIG_NET_L3_MASTER_DEV),)
-obj-y				+= l3mdev/
-endif
+obj-$(CONFIG_NET_L3_MASTER_DEV)	+= l3mdev/
 obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
diff --git a/net/l3mdev/Makefile b/net/l3mdev/Makefile
index 59755a9e2f9b..9e7da0acc58c 100644
--- a/net/l3mdev/Makefile
+++ b/net/l3mdev/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the L3 device API
 #
 
-obj-$(CONFIG_NET_L3_MASTER_DEV) += l3mdev.o
+obj-y += l3mdev.o
-- 
2.27.0

