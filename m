Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0BFB122BA5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfLQMd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:28142 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfLQMdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="217506052"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 17 Dec 2019 04:33:50 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id BD3BD74C; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] thunderbolt: Update documentation with the USB4 information
Date:   Tue, 17 Dec 2019 15:33:45 +0300
Message-Id: <20191217123345.31850-10-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update user's and administrator's guide to mention USB4, how it relates
to Thunderbolt and and how it is supported in Linux.

While there add the missing SPDX identifier to the document.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/admin-guide/thunderbolt.rst | 30 +++++++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/thunderbolt.rst b/Documentation/admin-guide/thunderbolt.rst
index 898ad78f3cc7..10c4f0ce2ad0 100644
--- a/Documentation/admin-guide/thunderbolt.rst
+++ b/Documentation/admin-guide/thunderbolt.rst
@@ -1,6 +1,28 @@
-=============
- Thunderbolt
-=============
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+ USB4 and Thunderbolt
+======================
+USB4 is the public specification based on Thunderbolt 3 protocol with
+some differences at the register level among other things. Connection
+manager is an entity running on the host router (host controller)
+responsible for enumerating routers and establishing tunnels. A
+connection manager can be implemented either in firmware or software.
+Typically PCs come with a firmware connection manager for Thunderbolt 3
+and early USB4 capable systems. Apple systems on the other hand use
+software connection manager and the later USB4 compliant devices follow
+the suit.
+
+The Linux Thunderbolt driver supports both and can detect at runtime which
+connection manager implementation is to be used. To be on the safe side the
+software connection manager in Linux also advertises security level
+``user`` which means PCIe tunneling is disabled by default. The
+documentation below applies to both implementations with the exception that
+the software connection manager only supports ``user`` security level and
+is expected to be accompanied with an IOMMU based DMA protection.
+
+Security levels and how to use them
+-----------------------------------
 The interface presented here is not meant for end users. Instead there
 should be a userspace tool that handles all the low-level details, keeps
 a database of the authorized devices and prompts users for new connections.
@@ -18,8 +40,6 @@ This will authorize all devices automatically when they appear. However,
 keep in mind that this bypasses the security levels and makes the system
 vulnerable to DMA attacks.
 
-Security levels and how to use them
------------------------------------
 Starting with Intel Falcon Ridge Thunderbolt controller there are 4
 security levels available. Intel Titan Ridge added one more security level
 (usbonly). The reason for these is the fact that the connected devices can
-- 
2.24.0

