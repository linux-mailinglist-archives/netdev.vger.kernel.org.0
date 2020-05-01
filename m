Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5CB1C1858
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgEAOqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbgEAOpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:10 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1967249A2;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=WRDqPZ+9jZ7Sh4Rzrsi/WI+WQMyF4skUB3aR+mqKkaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+QT+cIYnuKkZ+Hk1Cdk4sw4Ir+eNQ9ca3iE5nirKf1jfyhGd+LtUFJPYonvsQ7KE
         /oiT19PYwNSFLCwgPg9qlhQxQCbhUcZhaZx0FRptRQghTMfpRjBHHnLETPmdes0Mv3
         skjnBymoijLFEBaw0F6kPoiDlCKEKuH5Ck3Xbvmc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeq-Vq; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        netdev@vger.kernel.org
Subject: [PATCH 29/37] docs: networking: device drivers: convert qualcomm/rmnet.txt to ReST
Date:   Fri,  1 May 2020 16:44:51 +0200
Message-Id: <41d85f504fe80c7f1baaa96095b8ce50f74e5681.1588344146.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../qualcomm/{rmnet.txt => rmnet.rst}         | 43 ++++++++++++-------
 MAINTAINERS                                   |  2 +-
 3 files changed, 30 insertions(+), 16 deletions(-)
 rename Documentation/networking/device_drivers/qualcomm/{rmnet.txt => rmnet.rst} (73%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 55837244eaad..66ed884548cc 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -44,6 +44,7 @@ Contents:
    microsoft/netvsc
    neterion/s2io
    neterion/vxge
+   qualcomm/rmnet
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/qualcomm/rmnet.txt b/Documentation/networking/device_drivers/qualcomm/rmnet.rst
similarity index 73%
rename from Documentation/networking/device_drivers/qualcomm/rmnet.txt
rename to Documentation/networking/device_drivers/qualcomm/rmnet.rst
index 6b341eaf2062..70643b58de05 100644
--- a/Documentation/networking/device_drivers/qualcomm/rmnet.txt
+++ b/Documentation/networking/device_drivers/qualcomm/rmnet.rst
@@ -1,4 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Rmnet Driver
+============
+
 1. Introduction
+===============
 
 rmnet driver is used for supporting the Multiplexing and aggregation
 Protocol (MAP). This protocol is used by all recent chipsets using Qualcomm
@@ -18,17 +25,18 @@ sending aggregated bunch of MAP frames. rmnet driver will de-aggregate
 these MAP frames and send them to appropriate PDN's.
 
 2. Packet format
+================
 
 a. MAP packet (data / control)
 
 MAP header has the same endianness of the IP packet.
 
-Packet format -
+Packet format::
 
-Bit             0             1           2-7      8 - 15           16 - 31
-Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
-Bit            32 - x
-Function     Raw  Bytes
+  Bit             0             1           2-7      8 - 15           16 - 31
+  Function   Command / Data   Reserved     Pad   Multiplexer ID    Payload length
+  Bit            32 - x
+  Function     Raw  Bytes
 
 Command (1)/ Data (0) bit value is to indicate if the packet is a MAP command
 or data packet. Control packet is used for transport level flow control. Data
@@ -44,24 +52,27 @@ Multiplexer ID is to indicate the PDN on which data has to be sent.
 Payload length includes the padding length but does not include MAP header
 length.
 
-b. MAP packet (command specific)
+b. MAP packet (command specific)::
 
-Bit             0             1           2-7      8 - 15           16 - 31
-Function   Command         Reserved     Pad   Multiplexer ID    Payload length
-Bit          32 - 39        40 - 45    46 - 47       48 - 63
-Function   Command name    Reserved   Command Type   Reserved
-Bit          64 - 95
-Function   Transaction ID
-Bit          96 - 127
-Function   Command data
+    Bit             0             1           2-7      8 - 15           16 - 31
+    Function   Command         Reserved     Pad   Multiplexer ID    Payload length
+    Bit          32 - 39        40 - 45    46 - 47       48 - 63
+    Function   Command name    Reserved   Command Type   Reserved
+    Bit          64 - 95
+    Function   Transaction ID
+    Bit          96 - 127
+    Function   Command data
 
 Command 1 indicates disabling flow while 2 is enabling flow
 
-Command types -
+Command types
+
+= ==========================================
 0 for MAP command request
 1 is to acknowledge the receipt of a command
 2 is for unsupported commands
 3 is for error during processing of commands
+= ==========================================
 
 c. Aggregation
 
@@ -71,9 +82,11 @@ packets and either ACK the MAP command or deliver the IP packet to the
 network stack as needed
 
 MAP header|IP Packet|Optional padding|MAP header|IP Packet|Optional padding....
+
 MAP header|IP Packet|Optional padding|MAP header|Command Packet|Optional pad...
 
 3. Userspace configuration
+==========================
 
 rmnet userspace configuration is done through netlink library librmnetctl
 and command line utility rmnetcli. Utility is hosted in codeaurora forum git.
diff --git a/MAINTAINERS b/MAINTAINERS
index 91da0be7f69e..0054a0a87d5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14066,7 +14066,7 @@ M:	Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
 M:	Sean Tranchetti <stranche@codeaurora.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/networking/device_drivers/qualcomm/rmnet.txt
+F:	Documentation/networking/device_drivers/qualcomm/rmnet.rst
 F:	drivers/net/ethernet/qualcomm/rmnet/
 F:	include/linux/if_rmnet.h
 
-- 
2.25.4

