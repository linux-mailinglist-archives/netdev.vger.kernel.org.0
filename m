Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF1B9447
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393536AbfITPmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:42:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393522AbfITPmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:42:15 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4978302C084;
        Fri, 20 Sep 2019 15:42:15 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-68.ams2.redhat.com [10.36.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 235DA19C5B;
        Fri, 20 Sep 2019 15:42:13 +0000 (UTC)
Date:   Fri, 20 Sep 2019 17:41:52 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net v2 1/3] uapi, net/smc: move protocol constant definitions
 to UAPI
Message-ID: <1d8607a7bdcd846a090dd8b1cd3e56c06ab418e7.1568993930.git.esyr@redhat.com>
References: <cover.1568993930.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1568993930.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 20 Sep 2019 15:42:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMCPROTO_* constants are expected to be used by userspace[1],
but they were defined in a private header instead.

[1] http://manpages.ubuntu.com/manpages/cosmic/man7/af_smc.7.html

Fixes: ac7138746e14 ("smc: establish new socket family")
Fixes: aaa4d33f6da1 ("net/smc: enable ipv6 support for smc")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 include/uapi/linux/smc.h | 7 ++++++-
 net/smc/smc.h            | 4 +---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 0e11ca4..10561f8 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -2,7 +2,8 @@
 /*
  *  Shared Memory Communications over RDMA (SMC-R) and RoCE
  *
- *  Definitions for generic netlink based configuration of an SMC-R PNET table
+ *  Definitions for SMC protocol and generic netlink based configuration
+ *  of an SMC-R PNET table
  *
  *  Copyright IBM Corp. 2016
  *
@@ -12,6 +13,10 @@
 #ifndef _UAPI_LINUX_SMC_H_
 #define _UAPI_LINUX_SMC_H_
 
+/* AF_SMC socket protocols */
+#define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
+#define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
+
 /* Netlink SMC_PNETID attributes */
 enum {
 	SMC_PNETID_UNSPEC,
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 878313f..e60effc 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -15,12 +15,10 @@
 #include <linux/types.h>
 #include <linux/compiler.h> /* __aligned */
 #include <net/sock.h>
+#include <linux/smc.h>
 
 #include "smc_ib.h"
 
-#define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
-#define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
-
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
-- 
2.1.4

