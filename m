Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C664E1C01A0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgD3QHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2A1320873;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=hZ+wPwgu0dNDjrYHYJeJ+kFADL3g1Nq/98DRRRCT+94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFhErx71Mud5k0AUcbTo25KDPqPBQjfqjJ2iOPl5Vlt1Y1WWD5Hq9KzO3PGYavqj5
         ABjKKUQm3SUj1yHKM3DidjqAEy2hNzU6JVZD66Cds3ypQ4K7YiRzzRMVtsA8uiaeO4
         VNDsJk0536rSaMiFi2pLo8qAle19nyhFNmopBrKY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEF-0t; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-x25@vger.kernel.org
Subject: [PATCH 02/37] docs: networking: convert lapb-module.txt to ReST
Date:   Thu, 30 Apr 2020 18:03:57 +0200
Message-Id: <dfb05763848c4911dca874209ed4e3612a432972.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../{lapb-module.txt => lapb-module.rst}      | 120 ++++++++++++------
 MAINTAINERS                                   |   2 +-
 net/lapb/Kconfig                              |   2 +-
 4 files changed, 84 insertions(+), 41 deletions(-)
 rename Documentation/networking/{lapb-module.txt => lapb-module.rst} (74%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 0c5d7a037983..acd2567cf0d4 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -75,6 +75,7 @@ Contents:
    ipvs-sysctl
    kcm
    l2tp
+   lapb-module
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/lapb-module.txt b/Documentation/networking/lapb-module.rst
similarity index 74%
rename from Documentation/networking/lapb-module.txt
rename to Documentation/networking/lapb-module.rst
index d4fc8f221559..ff586bc9f005 100644
--- a/Documentation/networking/lapb-module.txt
+++ b/Documentation/networking/lapb-module.rst
@@ -1,8 +1,14 @@
-		The Linux LAPB Module Interface 1.3
+.. SPDX-License-Identifier: GPL-2.0
 
-		      Jonathan Naylor 29.12.96
+===============================
+The Linux LAPB Module Interface
+===============================
 
-Changed (Henner Eisen, 2000-10-29): int return value for data_indication() 
+Version 1.3
+
+Jonathan Naylor 29.12.96
+
+Changed (Henner Eisen, 2000-10-29): int return value for data_indication()
 
 The LAPB module will be a separately compiled module for use by any parts of
 the Linux operating system that require a LAPB service. This document
@@ -32,16 +38,16 @@ LAPB Initialisation Structure
 
 This structure is used only once, in the call to lapb_register (see below).
 It contains information about the device driver that requires the services
-of the LAPB module.
+of the LAPB module::
 
-struct lapb_register_struct {
-	void (*connect_confirmation)(int token, int reason);
-	void (*connect_indication)(int token, int reason);
-	void (*disconnect_confirmation)(int token, int reason);
-	void (*disconnect_indication)(int token, int reason);
-	int  (*data_indication)(int token, struct sk_buff *skb);
-	void (*data_transmit)(int token, struct sk_buff *skb);
-};
+	struct lapb_register_struct {
+		void (*connect_confirmation)(int token, int reason);
+		void (*connect_indication)(int token, int reason);
+		void (*disconnect_confirmation)(int token, int reason);
+		void (*disconnect_indication)(int token, int reason);
+		int  (*data_indication)(int token, struct sk_buff *skb);
+		void (*data_transmit)(int token, struct sk_buff *skb);
+	};
 
 Each member of this structure corresponds to a function in the device driver
 that is called when a particular event in the LAPB module occurs. These will
@@ -54,19 +60,19 @@ LAPB Parameter Structure
 
 This structure is used with the lapb_getparms and lapb_setparms functions
 (see below). They are used to allow the device driver to get and set the
-operational parameters of the LAPB implementation for a given connection.
+operational parameters of the LAPB implementation for a given connection::
 
-struct lapb_parms_struct {
-	unsigned int t1;
-	unsigned int t1timer;
-	unsigned int t2;
-	unsigned int t2timer;
-	unsigned int n2;
-	unsigned int n2count;
-	unsigned int window;
-	unsigned int state;
-	unsigned int mode;
-};
+	struct lapb_parms_struct {
+		unsigned int t1;
+		unsigned int t1timer;
+		unsigned int t2;
+		unsigned int t2timer;
+		unsigned int n2;
+		unsigned int n2count;
+		unsigned int window;
+		unsigned int state;
+		unsigned int mode;
+	};
 
 T1 and T2 are protocol timing parameters and are given in units of 100ms. N2
 is the maximum number of tries on the link before it is declared a failure.
@@ -78,11 +84,14 @@ link.
 The mode variable is a bit field used for setting (at present) three values.
 The bit fields have the following meanings:
 
+======  =================================================
 Bit	Meaning
+======  =================================================
 0	LAPB operation (0=LAPB_STANDARD 1=LAPB_EXTENDED).
 1	[SM]LP operation (0=LAPB_SLP 1=LAPB=MLP).
 2	DTE/DCE operation (0=LAPB_DTE 1=LAPB_DCE)
 3-31	Reserved, must be 0.
+======  =================================================
 
 Extended LAPB operation indicates the use of extended sequence numbers and
 consequently larger window sizes, the default is standard LAPB operation.
@@ -99,8 +108,9 @@ Functions
 
 The LAPB module provides a number of function entry points.
 
+::
 
-int lapb_register(void *token, struct lapb_register_struct);
+    int lapb_register(void *token, struct lapb_register_struct);
 
 This must be called before the LAPB module may be used. If the call is
 successful then LAPB_OK is returned. The token must be a unique identifier
@@ -111,33 +121,42 @@ For multiple LAPB links in a single device driver, multiple calls to
 lapb_register must be made. The format of the lapb_register_struct is given
 above. The return values are:
 
+=============		=============================
 LAPB_OK			LAPB registered successfully.
 LAPB_BADTOKEN		Token is already registered.
 LAPB_NOMEM		Out of memory
+=============		=============================
 
+::
 
-int lapb_unregister(void *token);
+    int lapb_unregister(void *token);
 
 This releases all the resources associated with a LAPB link. Any current
 LAPB link will be abandoned without further messages being passed. After
 this call, the value of token is no longer valid for any calls to the LAPB
 function. The valid return values are:
 
+=============		===============================
 LAPB_OK			LAPB unregistered successfully.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
+=============		===============================
 
+::
 
-int lapb_getparms(void *token, struct lapb_parms_struct *parms);
+    int lapb_getparms(void *token, struct lapb_parms_struct *parms);
 
 This allows the device driver to get the values of the current LAPB
 variables, the lapb_parms_struct is described above. The valid return values
 are:
 
+=============		=============================
 LAPB_OK			LAPB getparms was successful.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
+=============		=============================
 
+::
 
-int lapb_setparms(void *token, struct lapb_parms_struct *parms);
+    int lapb_setparms(void *token, struct lapb_parms_struct *parms);
 
 This allows the device driver to set the values of the current LAPB
 variables, the lapb_parms_struct is described above. The values of t1timer,
@@ -145,42 +164,54 @@ t2timer and n2count are ignored, likewise changing the mode bits when
 connected will be ignored. An error implies that none of the values have
 been changed. The valid return values are:
 
+=============		=================================================
 LAPB_OK			LAPB getparms was successful.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
 LAPB_INVALUE		One of the values was out of its allowable range.
+=============		=================================================
 
+::
 
-int lapb_connect_request(void *token);
+    int lapb_connect_request(void *token);
 
 Initiate a connect using the current parameter settings. The valid return
 values are:
 
+==============		=================================
 LAPB_OK			LAPB is starting to connect.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
 LAPB_CONNECTED		LAPB module is already connected.
+==============		=================================
 
+::
 
-int lapb_disconnect_request(void *token);
+    int lapb_disconnect_request(void *token);
 
 Initiate a disconnect. The valid return values are:
 
+=================	===============================
 LAPB_OK			LAPB is starting to disconnect.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
 LAPB_NOTCONNECTED	LAPB module is not connected.
+=================	===============================
 
+::
 
-int lapb_data_request(void *token, struct sk_buff *skb);
+    int lapb_data_request(void *token, struct sk_buff *skb);
 
 Queue data with the LAPB module for transmitting over the link. If the call
 is successful then the skbuff is owned by the LAPB module and may not be
 used by the device driver again. The valid return values are:
 
+=================	=============================
 LAPB_OK			LAPB has accepted the data.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
 LAPB_NOTCONNECTED	LAPB module is not connected.
+=================	=============================
 
+::
 
-int lapb_data_received(void *token, struct sk_buff *skb);
+    int lapb_data_received(void *token, struct sk_buff *skb);
 
 Queue data with the LAPB module which has been received from the device. It
 is expected that the data passed to the LAPB module has skb->data pointing
@@ -188,9 +219,10 @@ to the beginning of the LAPB data. If the call is successful then the skbuff
 is owned by the LAPB module and may not be used by the device driver again.
 The valid return values are:
 
+=============		===========================
 LAPB_OK			LAPB has accepted the data.
 LAPB_BADTOKEN		Invalid/unknown LAPB token.
-
+=============		===========================
 
 Callbacks
 ---------
@@ -200,49 +232,58 @@ module to call when an event occurs. They are registered with the LAPB
 module with lapb_register (see above) in the structure lapb_register_struct
 (see above).
 
+::
 
-void (*connect_confirmation)(void *token, int reason);
+    void (*connect_confirmation)(void *token, int reason);
 
 This is called by the LAPB module when a connection is established after
 being requested by a call to lapb_connect_request (see above). The reason is
 always LAPB_OK.
 
+::
 
-void (*connect_indication)(void *token, int reason);
+    void (*connect_indication)(void *token, int reason);
 
 This is called by the LAPB module when the link is established by the remote
 system. The value of reason is always LAPB_OK.
 
+::
 
-void (*disconnect_confirmation)(void *token, int reason);
+    void (*disconnect_confirmation)(void *token, int reason);
 
 This is called by the LAPB module when an event occurs after the device
 driver has called lapb_disconnect_request (see above). The reason indicates
 what has happened. In all cases the LAPB link can be regarded as being
 terminated. The values for reason are:
 
+=================	====================================================
 LAPB_OK			The LAPB link was terminated normally.
 LAPB_NOTCONNECTED	The remote system was not connected.
 LAPB_TIMEDOUT		No response was received in N2 tries from the remote
 			system.
+=================	====================================================
 
+::
 
-void (*disconnect_indication)(void *token, int reason);
+    void (*disconnect_indication)(void *token, int reason);
 
 This is called by the LAPB module when the link is terminated by the remote
 system or another event has occurred to terminate the link. This may be
 returned in response to a lapb_connect_request (see above) if the remote
 system refused the request. The values for reason are:
 
+=================	====================================================
 LAPB_OK			The LAPB link was terminated normally by the remote
 			system.
 LAPB_REFUSED		The remote system refused the connect request.
 LAPB_NOTCONNECTED	The remote system was not connected.
 LAPB_TIMEDOUT		No response was received in N2 tries from the remote
 			system.
+=================	====================================================
 
+::
 
-int (*data_indication)(void *token, struct sk_buff *skb);
+    int (*data_indication)(void *token, struct sk_buff *skb);
 
 This is called by the LAPB module when data has been received from the
 remote system that should be passed onto the next layer in the protocol
@@ -254,8 +295,9 @@ This method should return NET_RX_DROP (as defined in the header
 file include/linux/netdevice.h) if and only if the frame was dropped
 before it could be delivered to the upper layer.
 
+::
 
-void (*data_transmit)(void *token, struct sk_buff *skb);
+    void (*data_transmit)(void *token, struct sk_buff *skb);
 
 This is called by the LAPB module when data is to be transmitted to the
 remote system by the device driver. The skbuff becomes the property of the
diff --git a/MAINTAINERS b/MAINTAINERS
index b0cf6c358136..0db63acd07b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9546,7 +9546,7 @@ F:	drivers/soc/lantiq
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
-F:	Documentation/networking/lapb-module.txt
+F:	Documentation/networking/lapb-module.rst
 F:	include/*/lapb.h
 F:	net/lapb/
 
diff --git a/net/lapb/Kconfig b/net/lapb/Kconfig
index 6acfc999c952..5b50e8d64f26 100644
--- a/net/lapb/Kconfig
+++ b/net/lapb/Kconfig
@@ -15,7 +15,7 @@ config LAPB
 	  currently supports LAPB only over Ethernet connections. If you want
 	  to use LAPB connections over Ethernet, say Y here and to "LAPB over
 	  Ethernet driver" below. Read
-	  <file:Documentation/networking/lapb-module.txt> for technical
+	  <file:Documentation/networking/lapb-module.rst> for technical
 	  details.
 
 	  To compile this driver as a module, choose M here: the
-- 
2.25.4

