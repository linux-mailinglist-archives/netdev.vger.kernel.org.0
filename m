Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886721C1826
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgEAOpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729282AbgEAOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:06 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F158724956;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=qq2zKoYdCyEqjqt0U3RX9qvpvrnb6fBfrYVGRgOwH4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lbh0Vp46Y2jWH8lEr92N3b6ussd/33EaiPdihekY3jO3xEPEh64AmQt3OChsJgFlj
         zMu1Cgs68HCgzFHcGeL9WsJQRkGto8EsI5Kqau9iNF6FC5jXTarImOfE41hB90xQg0
         AY3xzBCL8+oU/SvEKf0B+VT7HXW+eCozkcQmmf4c=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCd8-Ej; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/37] docs: networking: convert xfrm_sync.txt to ReST
Date:   Fri,  1 May 2020 16:44:31 +0200
Message-Id: <ffea07769fc84dfdf950390d756ecd881c7d0b8f.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{xfrm_sync.txt => xfrm_sync.rst}          | 66 ++++++++++++-------
 2 files changed, 44 insertions(+), 23 deletions(-)
 rename Documentation/networking/{xfrm_sync.txt => xfrm_sync.rst} (82%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3fe70efb632e..ec83bd95e4e9 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -119,6 +119,7 @@ Contents:
    x25
    xfrm_device
    xfrm_proc
+   xfrm_sync
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/xfrm_sync.txt b/Documentation/networking/xfrm_sync.rst
similarity index 82%
rename from Documentation/networking/xfrm_sync.txt
rename to Documentation/networking/xfrm_sync.rst
index 8d88e0f2ec49..6246503ceab2 100644
--- a/Documentation/networking/xfrm_sync.txt
+++ b/Documentation/networking/xfrm_sync.rst
@@ -1,3 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+XFRM
+====
 
 The sync patches work is based on initial patches from
 Krisztian <hidden@balabit.hu> and others and additional patches
@@ -40,30 +45,32 @@ The netlink message types are:
 XFRM_MSG_NEWAE and XFRM_MSG_GETAE.
 
 A XFRM_MSG_GETAE does not have TLVs.
+
 A XFRM_MSG_NEWAE will have at least two TLVs (as is
 discussed further below).
 
-aevent_id structure looks like:
+aevent_id structure looks like::
 
    struct xfrm_aevent_id {
-             struct xfrm_usersa_id           sa_id;
-             xfrm_address_t                  saddr;
-             __u32                           flags;
-             __u32                           reqid;
+	     struct xfrm_usersa_id           sa_id;
+	     xfrm_address_t                  saddr;
+	     __u32                           flags;
+	     __u32                           reqid;
    };
 
 The unique SA is identified by the combination of xfrm_usersa_id,
 reqid and saddr.
 
 flags are used to indicate different things. The possible
-flags are:
-        XFRM_AE_RTHR=1, /* replay threshold*/
-        XFRM_AE_RVAL=2, /* replay value */
-        XFRM_AE_LVAL=4, /* lifetime value */
-        XFRM_AE_ETHR=8, /* expiry timer threshold */
-        XFRM_AE_CR=16, /* Event cause is replay update */
-        XFRM_AE_CE=32, /* Event cause is timer expiry */
-        XFRM_AE_CU=64, /* Event cause is policy update */
+flags are::
+
+	XFRM_AE_RTHR=1, /* replay threshold*/
+	XFRM_AE_RVAL=2, /* replay value */
+	XFRM_AE_LVAL=4, /* lifetime value */
+	XFRM_AE_ETHR=8, /* expiry timer threshold */
+	XFRM_AE_CR=16, /* Event cause is replay update */
+	XFRM_AE_CE=32, /* Event cause is timer expiry */
+	XFRM_AE_CU=64, /* Event cause is policy update */
 
 How these flags are used is dependent on the direction of the
 message (kernel<->user) as well the cause (config, query or event).
@@ -80,23 +87,27 @@ to get notified of these events.
 -----------------------------------------
 
 a) byte value (XFRMA_LTIME_VAL)
+
 This TLV carries the running/current counter for byte lifetime since
 last event.
 
 b)replay value (XFRMA_REPLAY_VAL)
+
 This TLV carries the running/current counter for replay sequence since
 last event.
 
 c)replay threshold (XFRMA_REPLAY_THRESH)
+
 This TLV carries the threshold being used by the kernel to trigger events
 when the replay sequence is exceeded.
 
 d) expiry timer (XFRMA_ETIMER_THRESH)
+
 This is a timer value in milliseconds which is used as the nagle
 value to rate limit the events.
 
 3) Default configurations for the parameters:
-----------------------------------------------
+---------------------------------------------
 
 By default these events should be turned off unless there is
 at least one listener registered to listen to the multicast
@@ -108,6 +119,7 @@ we also provide default threshold values for these different parameters
 in case they are not specified.
 
 the two sysctls/proc entries are:
+
 a) /proc/sys/net/core/sysctl_xfrm_aevent_etime
 used to provide default values for the XFRMA_ETIMER_THRESH in incremental
 units of time of 100ms. The default is 10 (1 second)
@@ -120,37 +132,45 @@ in incremental packet count. The default is two packets.
 ----------------
 
 a) XFRM_MSG_GETAE issued by user-->kernel.
-XFRM_MSG_GETAE does not carry any TLVs.
+   XFRM_MSG_GETAE does not carry any TLVs.
+
 The response is a XFRM_MSG_NEWAE which is formatted based on what
 XFRM_MSG_GETAE queried for.
+
 The response will always have XFRMA_LTIME_VAL and XFRMA_REPLAY_VAL TLVs.
-*if XFRM_AE_RTHR flag is set, then XFRMA_REPLAY_THRESH is also retrieved
-*if XFRM_AE_ETHR flag is set, then XFRMA_ETIMER_THRESH is also retrieved
+* if XFRM_AE_RTHR flag is set, then XFRMA_REPLAY_THRESH is also retrieved
+* if XFRM_AE_ETHR flag is set, then XFRMA_ETIMER_THRESH is also retrieved
 
 b) XFRM_MSG_NEWAE is issued by either user space to configure
-or kernel to announce events or respond to a XFRM_MSG_GETAE.
+   or kernel to announce events or respond to a XFRM_MSG_GETAE.
 
 i) user --> kernel to configure a specific SA.
+
 any of the values or threshold parameters can be updated by passing the
 appropriate TLV.
+
 A response is issued back to the sender in user space to indicate success
 or failure.
+
 In the case of success, additionally an event with
 XFRM_MSG_NEWAE is also issued to any listeners as described in iii).
 
 ii) kernel->user direction as a response to XFRM_MSG_GETAE
+
 The response will always have XFRMA_LTIME_VAL and XFRMA_REPLAY_VAL TLVs.
+
 The threshold TLVs will be included if explicitly requested in
 the XFRM_MSG_GETAE message.
 
 iii) kernel->user to report as event if someone sets any values or
-thresholds for an SA using XFRM_MSG_NEWAE (as described in #i above).
-In such a case XFRM_AE_CU flag is set to inform the user that
-the change happened as a result of an update.
-The message will always have XFRMA_LTIME_VAL and XFRMA_REPLAY_VAL TLVs.
+     thresholds for an SA using XFRM_MSG_NEWAE (as described in #i above).
+     In such a case XFRM_AE_CU flag is set to inform the user that
+     the change happened as a result of an update.
+     The message will always have XFRMA_LTIME_VAL and XFRMA_REPLAY_VAL TLVs.
 
 iv) kernel->user to report event when replay threshold or a timeout
-is exceeded.
+    is exceeded.
+
 In such a case either XFRM_AE_CR (replay exceeded) or XFRM_AE_CE (timeout
 happened) is set to inform the user what happened.
 Note the two flags are mutually exclusive.
-- 
2.25.4

