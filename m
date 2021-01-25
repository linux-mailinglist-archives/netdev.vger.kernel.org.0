Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF43302FF8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbhAYXTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:19:13 -0500
Received: from conuserg-07.nifty.com ([210.131.2.74]:45011 "EHLO
        conuserg-07.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732869AbhAYXS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:18:29 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id 10PNHDrE029059;
        Tue, 26 Jan 2021 08:17:15 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com 10PNHDrE029059
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616635;
        bh=WrPKQeqA34xts7niB8PFxEYOBfloo3E7DEBAP1WH5S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5zUD85h9mIwaWEg3ScEhmqbCQh/EWjaJi592SWh/tlMqy1skgeJxtT2Rn6Ii8lMd
         GqHpI/8Eu7vpveuxP61ls5QXtLg+nO3jXj7Q1RCt5TtkkZggYLwrlGkII5QIfDlpm/
         C6D3hI3b/HAnfy2tm7TvGWYsJtmdI/wsJ9yPOSalzg5Ei4D9vYGAw4IlyCaiZRNySN
         cKlMHA5i3JmsyAj15NOINaG1miy8DcQa/DIY3U+obv8zjbh6jEHZ10VPXztarQs2r3
         9eKAoKLAW2bdDEARIqRMtbyUMerZeYj9hjFvzeBDS6biIArpWw8PEFwqH+FX10l1sb
         axpIu8kHIssEA==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: dcb: use obj-$(CONFIG_DCB) form in net/Makefile
Date:   Tue, 26 Jan 2021 08:16:56 +0900
Message-Id: <20210125231659.106201-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125231659.106201-1-masahiroy@kernel.org>
References: <20210125231659.106201-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_DCB is a bool option. Change the ifeq conditional to the
standard obj-$(CONFIG_DCB) form.

Use obj-y in net/dcb/Makefile because Kbuild visits this Makefile
only when CONFIG_DCB=y.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/Makefile     | 4 +---
 net/dcb/Makefile | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/Makefile b/net/Makefile
index 6fa3b2e26cab..a7e38bd463a4 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -55,9 +55,7 @@ obj-$(CONFIG_SMC)		+= smc/
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
 obj-$(CONFIG_CAIF)		+= caif/
-ifneq ($(CONFIG_DCB),)
-obj-y				+= dcb/
-endif
+obj-$(CONFIG_DCB)		+= dcb/
 obj-$(CONFIG_6LOWPAN)		+= 6lowpan/
 obj-$(CONFIG_IEEE802154)	+= ieee802154/
 obj-$(CONFIG_MAC802154)		+= mac802154/
diff --git a/net/dcb/Makefile b/net/dcb/Makefile
index 3016e5a7716a..2c0fa16ee2a9 100644
--- a/net/dcb/Makefile
+++ b/net/dcb/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_DCB) += dcbnl.o dcbevent.o
+obj-y += dcbnl.o dcbevent.o
-- 
2.27.0

