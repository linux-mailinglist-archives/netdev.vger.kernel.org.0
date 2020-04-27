Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10B51BB139
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgD0WFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 461012078C;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=b6SmWk/tS2NNZD6gud57rFFy9m1IXlxDr9U59Q9cAGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnWvncRzP4eIl6sQYzWo2f1ba2SWNpBAg0KpcRaCXfwoD4NSRnYmrsophdGgrnXbx
         weC1J4+Oqf2eKR+cktuprYWaSuaiBIX9Bv2SZe8erk+1dXQrThvnzza0Nt+rIp/qQl
         vC6khWj3v+3ibOKPyOU/zJ2KanYdMcrYg0l3FhTE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Ini-GS; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/38] docs: networking: convert caif files to ReST
Date:   Tue, 28 Apr 2020 00:01:16 +0200
Message-Id: <25891dfabb48810620f82b82cc3479919bf27685.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two text files for caif, plus one already converted
file.

Convert the two remaining ones to ReST, create a new index.rst
file for CAIF, adding it to the main networking documentation
index.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/caif/caif.rst        |   2 -
 Documentation/networking/caif/index.rst       |  13 +
 .../caif/{Linux-CAIF.txt => linux_caif.rst}   |  54 +++--
 Documentation/networking/caif/spi_porting.rst | 229 ++++++++++++++++++
 Documentation/networking/caif/spi_porting.txt | 208 ----------------
 Documentation/networking/index.rst            |   1 +
 drivers/net/caif/Kconfig                      |   2 +-
 7 files changed, 281 insertions(+), 228 deletions(-)
 create mode 100644 Documentation/networking/caif/index.rst
 rename Documentation/networking/caif/{Linux-CAIF.txt => linux_caif.rst} (90%)
 create mode 100644 Documentation/networking/caif/spi_porting.rst
 delete mode 100644 Documentation/networking/caif/spi_porting.txt

diff --git a/Documentation/networking/caif/caif.rst b/Documentation/networking/caif/caif.rst
index 07afc8063d4d..a07213030ccf 100644
--- a/Documentation/networking/caif/caif.rst
+++ b/Documentation/networking/caif/caif.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 .. SPDX-License-Identifier: GPL-2.0
 .. include:: <isonum.txt>
 
diff --git a/Documentation/networking/caif/index.rst b/Documentation/networking/caif/index.rst
new file mode 100644
index 000000000000..86e5b7832ec3
--- /dev/null
+++ b/Documentation/networking/caif/index.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+CAIF
+====
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   linux_caif
+   caif
+   spi_porting
diff --git a/Documentation/networking/caif/Linux-CAIF.txt b/Documentation/networking/caif/linux_caif.rst
similarity index 90%
rename from Documentation/networking/caif/Linux-CAIF.txt
rename to Documentation/networking/caif/linux_caif.rst
index 0aa4bd381bec..a0480862ab8c 100644
--- a/Documentation/networking/caif/Linux-CAIF.txt
+++ b/Documentation/networking/caif/linux_caif.rst
@@ -1,12 +1,19 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+==========
 Linux CAIF
-===========
-copyright (C) ST-Ericsson AB 2010
-Author: Sjur Brendeland/ sjur.brandeland@stericsson.com
-License terms: GNU General Public License (GPL) version 2
+==========
+
+Copyright |copy| ST-Ericsson AB 2010
+
+:Author: Sjur Brendeland/ sjur.brandeland@stericsson.com
+:License terms: GNU General Public License (GPL) version 2
 
 
 Introduction
-------------
+============
+
 CAIF is a MUX protocol used by ST-Ericsson cellular modems for
 communication between Modem and host. The host processes can open virtual AT
 channels, initiate GPRS Data connections, Video channels and Utility Channels.
@@ -16,13 +23,16 @@ ST-Ericsson modems support a number of transports between modem
 and host. Currently, UART and Loopback are available for Linux.
 
 
-Architecture:
-------------
+Architecture
+============
+
 The implementation of CAIF is divided into:
+
 * CAIF Socket Layer and GPRS IP Interface.
 * CAIF Core Protocol Implementation
 * CAIF Link Layer, implemented as NET devices.
 
+::
 
   RTNL
    !
@@ -46,12 +56,12 @@ The implementation of CAIF is divided into:
 
 
 
-I M P L E M E N T A T I O N
-===========================
+Implementation
+==============
 
 
 CAIF Core Protocol Layer
-=========================================
+------------------------
 
 CAIF Core layer implements the CAIF protocol as defined by ST-Ericsson.
 It implements the CAIF protocol stack in a layered approach, where
@@ -59,8 +69,11 @@ each layer described in the specification is implemented as a separate layer.
 The architecture is inspired by the design patterns "Protocol Layer" and
 "Protocol Packet".
 
-== CAIF structure ==
+CAIF structure
+^^^^^^^^^^^^^^
+
 The Core CAIF implementation contains:
+
       -	Simple implementation of CAIF.
       -	Layered architecture (a la Streams), each layer in the CAIF
 	specification is implemented in a separate c-file.
@@ -73,7 +86,8 @@ The Core CAIF implementation contains:
 	to the called function (except for framing layers' receive function)
 
 Layered Architecture
---------------------
+====================
+
 The CAIF protocol can be divided into two parts: Support functions and Protocol
 Implementation. The support functions include:
 
@@ -112,7 +126,7 @@ The CAIF Protocol implementation contains:
       - CFSERL CAIF Serial layer. Handles concatenation/split of frames
 	into CAIF Frames with correct length.
 
-
+::
 
 		    +---------+
 		    | Config  |
@@ -143,18 +157,24 @@ The CAIF Protocol implementation contains:
 
 
 In this layered approach the following "rules" apply.
+
       - All layers embed the same structure "struct cflayer"
       - A layer does not depend on any other layer's private data.
-      - Layers are stacked by setting the pointers
+      - Layers are stacked by setting the pointers::
+
 		  layer->up , layer->dn
-      -	In order to send data upwards, each layer should do
+
+      -	In order to send data upwards, each layer should do::
+
 		 layer->up->receive(layer->up, packet);
-      - In order to send data downwards, each layer should do
+
+      - In order to send data downwards, each layer should do::
+
 		 layer->dn->transmit(layer->dn, packet);
 
 
 CAIF Socket and IP interface
-===========================
+============================
 
 The IP interface and CAIF socket API are implemented on top of the
 CAIF Core protocol. The IP Interface and CAIF socket have an instance of
diff --git a/Documentation/networking/caif/spi_porting.rst b/Documentation/networking/caif/spi_porting.rst
new file mode 100644
index 000000000000..d49f874b20ac
--- /dev/null
+++ b/Documentation/networking/caif/spi_porting.rst
@@ -0,0 +1,229 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+CAIF SPI porting
+================
+
+CAIF SPI basics
+===============
+
+Running CAIF over SPI needs some extra setup, owing to the nature of SPI.
+Two extra GPIOs have been added in order to negotiate the transfers
+between the master and the slave. The minimum requirement for running
+CAIF over SPI is a SPI slave chip and two GPIOs (more details below).
+Please note that running as a slave implies that you need to keep up
+with the master clock. An overrun or underrun event is fatal.
+
+CAIF SPI framework
+==================
+
+To make porting as easy as possible, the CAIF SPI has been divided in
+two parts. The first part (called the interface part) deals with all
+generic functionality such as length framing, SPI frame negotiation
+and SPI frame delivery and transmission. The other part is the CAIF
+SPI slave device part, which is the module that you have to write if
+you want to run SPI CAIF on a new hardware. This part takes care of
+the physical hardware, both with regard to SPI and to GPIOs.
+
+- Implementing a CAIF SPI device:
+
+	- Functionality provided by the CAIF SPI slave device:
+
+	In order to implement a SPI device you will, as a minimum,
+	need to implement the following
+	functions:
+
+	::
+
+	    int (*init_xfer) (struct cfspi_xfer * xfer, struct cfspi_dev *dev):
+
+	This function is called by the CAIF SPI interface to give
+	you a chance to set up your hardware to be ready to receive
+	a stream of data from the master. The xfer structure contains
+	both physical and logical addresses, as well as the total length
+	of the transfer in both directions.The dev parameter can be used
+	to map to different CAIF SPI slave devices.
+
+	::
+
+	    void (*sig_xfer) (bool xfer, struct cfspi_dev *dev):
+
+	This function is called by the CAIF SPI interface when the output
+	(SPI_INT) GPIO needs to change state. The boolean value of the xfer
+	variable indicates whether the GPIO should be asserted (HIGH) or
+	deasserted (LOW). The dev parameter can be used to map to different CAIF
+	SPI slave devices.
+
+	- Functionality provided by the CAIF SPI interface:
+
+	::
+
+	    void (*ss_cb) (bool assert, struct cfspi_ifc *ifc);
+
+	This function is called by the CAIF SPI slave device in order to
+	signal a change of state of the input GPIO (SS) to the interface.
+	Only active edges are mandatory to be reported.
+	This function can be called from IRQ context (recommended in order
+	not to introduce latency). The ifc parameter should be the pointer
+	returned from the platform probe function in the SPI device structure.
+
+	::
+
+	    void (*xfer_done_cb) (struct cfspi_ifc *ifc);
+
+	This function is called by the CAIF SPI slave device in order to
+	report that a transfer is completed. This function should only be
+	called once both the transmission and the reception are completed.
+	This function can be called from IRQ context (recommended in order
+	not to introduce latency). The ifc parameter should be the pointer
+	returned from the platform probe function in the SPI device structure.
+
+	- Connecting the bits and pieces:
+
+		- Filling in the SPI slave device structure:
+
+		  Connect the necessary callback functions.
+
+		  Indicate clock speed (used to calculate toggle delays).
+
+		  Chose a suitable name (helps debugging if you use several CAIF
+		  SPI slave devices).
+
+		  Assign your private data (can be used to map to your
+		  structure).
+
+		- Filling in the SPI slave platform device structure:
+
+		  Add name of driver to connect to ("cfspi_sspi").
+
+		  Assign the SPI slave device structure as platform data.
+
+Padding
+=======
+
+In order to optimize throughput, a number of SPI padding options are provided.
+Padding can be enabled independently for uplink and downlink transfers.
+Padding can be enabled for the head, the tail and for the total frame size.
+The padding needs to be correctly configured on both sides of the link.
+The padding can be changed via module parameters in cfspi_sspi.c or via
+the sysfs directory of the cfspi_sspi driver (before device registration).
+
+- CAIF SPI device template::
+
+    /*
+    *	Copyright (C) ST-Ericsson AB 2010
+    *	Author: Daniel Martensson / Daniel.Martensson@stericsson.com
+    *	License terms: GNU General Public License (GPL), version 2.
+    *
+    */
+
+    #include <linux/init.h>
+    #include <linux/module.h>
+    #include <linux/device.h>
+    #include <linux/wait.h>
+    #include <linux/interrupt.h>
+    #include <linux/dma-mapping.h>
+    #include <net/caif/caif_spi.h>
+
+    MODULE_LICENSE("GPL");
+
+    struct sspi_struct {
+	    struct cfspi_dev sdev;
+	    struct cfspi_xfer *xfer;
+    };
+
+    static struct sspi_struct slave;
+    static struct platform_device slave_device;
+
+    static irqreturn_t sspi_irq(int irq, void *arg)
+    {
+	    /* You only need to trigger on an edge to the active state of the
+	    * SS signal. Once a edge is detected, the ss_cb() function should be
+	    * called with the parameter assert set to true. It is OK
+	    * (and even advised) to call the ss_cb() function in IRQ context in
+	    * order not to add any delay. */
+
+	    return IRQ_HANDLED;
+    }
+
+    static void sspi_complete(void *context)
+    {
+	    /* Normally the DMA or the SPI framework will call you back
+	    * in something similar to this. The only thing you need to
+	    * do is to call the xfer_done_cb() function, providing the pointer
+	    * to the CAIF SPI interface. It is OK to call this function
+	    * from IRQ context. */
+    }
+
+    static int sspi_init_xfer(struct cfspi_xfer *xfer, struct cfspi_dev *dev)
+    {
+	    /* Store transfer info. For a normal implementation you should
+	    * set up your DMA here and make sure that you are ready to
+	    * receive the data from the master SPI. */
+
+	    struct sspi_struct *sspi = (struct sspi_struct *)dev->priv;
+
+	    sspi->xfer = xfer;
+
+	    return 0;
+    }
+
+    void sspi_sig_xfer(bool xfer, struct cfspi_dev *dev)
+    {
+	    /* If xfer is true then you should assert the SPI_INT to indicate to
+	    * the master that you are ready to receive the data from the master
+	    * SPI. If xfer is false then you should de-assert SPI_INT to indicate
+	    * that the transfer is done.
+	    */
+
+	    struct sspi_struct *sspi = (struct sspi_struct *)dev->priv;
+    }
+
+    static void sspi_release(struct device *dev)
+    {
+	    /*
+	    * Here you should release your SPI device resources.
+	    */
+    }
+
+    static int __init sspi_init(void)
+    {
+	    /* Here you should initialize your SPI device by providing the
+	    * necessary functions, clock speed, name and private data. Once
+	    * done, you can register your device with the
+	    * platform_device_register() function. This function will return
+	    * with the CAIF SPI interface initialized. This is probably also
+	    * the place where you should set up your GPIOs, interrupts and SPI
+	    * resources. */
+
+	    int res = 0;
+
+	    /* Initialize slave device. */
+	    slave.sdev.init_xfer = sspi_init_xfer;
+	    slave.sdev.sig_xfer = sspi_sig_xfer;
+	    slave.sdev.clk_mhz = 13;
+	    slave.sdev.priv = &slave;
+	    slave.sdev.name = "spi_sspi";
+	    slave_device.dev.release = sspi_release;
+
+	    /* Initialize platform device. */
+	    slave_device.name = "cfspi_sspi";
+	    slave_device.dev.platform_data = &slave.sdev;
+
+	    /* Register platform device. */
+	    res = platform_device_register(&slave_device);
+	    if (res) {
+		    printk(KERN_WARNING "sspi_init: failed to register dev.\n");
+		    return -ENODEV;
+	    }
+
+	    return res;
+    }
+
+    static void __exit sspi_exit(void)
+    {
+	    platform_device_del(&slave_device);
+    }
+
+    module_init(sspi_init);
+    module_exit(sspi_exit);
diff --git a/Documentation/networking/caif/spi_porting.txt b/Documentation/networking/caif/spi_porting.txt
deleted file mode 100644
index 9efd0687dc4c..000000000000
--- a/Documentation/networking/caif/spi_porting.txt
+++ /dev/null
@@ -1,208 +0,0 @@
-- CAIF SPI porting -
-
-- CAIF SPI basics:
-
-Running CAIF over SPI needs some extra setup, owing to the nature of SPI.
-Two extra GPIOs have been added in order to negotiate the transfers
- between the master and the slave. The minimum requirement for running
-CAIF over SPI is a SPI slave chip and two GPIOs (more details below).
-Please note that running as a slave implies that you need to keep up
-with the master clock. An overrun or underrun event is fatal.
-
-- CAIF SPI framework:
-
-To make porting as easy as possible, the CAIF SPI has been divided in
-two parts. The first part (called the interface part) deals with all
-generic functionality such as length framing, SPI frame negotiation
-and SPI frame delivery and transmission. The other part is the CAIF
-SPI slave device part, which is the module that you have to write if
-you want to run SPI CAIF on a new hardware. This part takes care of
-the physical hardware, both with regard to SPI and to GPIOs.
-
-- Implementing a CAIF SPI device:
-
-	- Functionality provided by the CAIF SPI slave device:
-
-	In order to implement a SPI device you will, as a minimum,
-	need to implement the following
-	functions:
-
-	int (*init_xfer) (struct cfspi_xfer * xfer, struct cfspi_dev *dev):
-
-	This function is called by the CAIF SPI interface to give
-	you a chance to set up your hardware to be ready to receive
-	a stream of data from the master. The xfer structure contains
-	both physical and logical addresses, as well as the total length
-	of the transfer in both directions.The dev parameter can be used
-	to map to different CAIF SPI slave devices.
-
-	void (*sig_xfer) (bool xfer, struct cfspi_dev *dev):
-
-	This function is called by the CAIF SPI interface when the output
-	(SPI_INT) GPIO needs to change state. The boolean value of the xfer
-	variable indicates whether the GPIO should be asserted (HIGH) or
-	deasserted (LOW). The dev parameter can be used to map to different CAIF
-	SPI slave devices.
-
-	- Functionality provided by the CAIF SPI interface:
-
-	void (*ss_cb) (bool assert, struct cfspi_ifc *ifc);
-
-	This function is called by the CAIF SPI slave device in order to
-	signal a change of state of the input GPIO (SS) to the interface.
-	Only active edges are mandatory to be reported.
-	This function can be called from IRQ context (recommended in order
-	not to introduce latency). The ifc parameter should be the pointer
-	returned from the platform probe function in the SPI device structure.
-
-	void (*xfer_done_cb) (struct cfspi_ifc *ifc);
-
-	This function is called by the CAIF SPI slave device in order to
-	report that a transfer is completed. This function should only be
-	called once both the transmission and the reception are completed.
-	This function can be called from IRQ context (recommended in order
-	not to introduce latency). The ifc parameter should be the pointer
-	returned from the platform probe function in the SPI device structure.
-
-	- Connecting the bits and pieces:
-
-		- Filling in the SPI slave device structure:
-
-		Connect the necessary callback functions.
-		Indicate clock speed (used to calculate toggle delays).
-		Chose a suitable name (helps debugging if you use several CAIF
-		SPI slave devices).
-		Assign your private data (can be used to map to your structure).
-
-		- Filling in the SPI slave platform device structure:
-		Add name of driver to connect to ("cfspi_sspi").
-		Assign the SPI slave device structure as platform data.
-
-- Padding:
-
-In order to optimize throughput, a number of SPI padding options are provided.
-Padding can be enabled independently for uplink and downlink transfers.
-Padding can be enabled for the head, the tail and for the total frame size.
-The padding needs to be correctly configured on both sides of the link.
-The padding can be changed via module parameters in cfspi_sspi.c or via
-the sysfs directory of the cfspi_sspi driver (before device registration).
-
-- CAIF SPI device template:
-
-/*
- *	Copyright (C) ST-Ericsson AB 2010
- *	Author: Daniel Martensson / Daniel.Martensson@stericsson.com
- *	License terms: GNU General Public License (GPL), version 2.
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/device.h>
-#include <linux/wait.h>
-#include <linux/interrupt.h>
-#include <linux/dma-mapping.h>
-#include <net/caif/caif_spi.h>
-
-MODULE_LICENSE("GPL");
-
-struct sspi_struct {
-	struct cfspi_dev sdev;
-	struct cfspi_xfer *xfer;
-};
-
-static struct sspi_struct slave;
-static struct platform_device slave_device;
-
-static irqreturn_t sspi_irq(int irq, void *arg)
-{
-	/* You only need to trigger on an edge to the active state of the
-	 * SS signal. Once a edge is detected, the ss_cb() function should be
-	 * called with the parameter assert set to true. It is OK
-	 * (and even advised) to call the ss_cb() function in IRQ context in
-	 * order not to add any delay. */
-
-	return IRQ_HANDLED;
-}
-
-static void sspi_complete(void *context)
-{
-	/* Normally the DMA or the SPI framework will call you back
-	 * in something similar to this. The only thing you need to
-	 * do is to call the xfer_done_cb() function, providing the pointer
-	 * to the CAIF SPI interface. It is OK to call this function
-	 * from IRQ context. */
-}
-
-static int sspi_init_xfer(struct cfspi_xfer *xfer, struct cfspi_dev *dev)
-{
-	/* Store transfer info. For a normal implementation you should
-	 * set up your DMA here and make sure that you are ready to
-	 * receive the data from the master SPI. */
-
-	struct sspi_struct *sspi = (struct sspi_struct *)dev->priv;
-
-	sspi->xfer = xfer;
-
-	return 0;
-}
-
-void sspi_sig_xfer(bool xfer, struct cfspi_dev *dev)
-{
-	/* If xfer is true then you should assert the SPI_INT to indicate to
-	 * the master that you are ready to receive the data from the master
-	 * SPI. If xfer is false then you should de-assert SPI_INT to indicate
-	 * that the transfer is done.
-	 */
-
-	struct sspi_struct *sspi = (struct sspi_struct *)dev->priv;
-}
-
-static void sspi_release(struct device *dev)
-{
-	/*
-	 * Here you should release your SPI device resources.
-	 */
-}
-
-static int __init sspi_init(void)
-{
-	/* Here you should initialize your SPI device by providing the
-	 * necessary functions, clock speed, name and private data. Once
-	 * done, you can register your device with the
-	 * platform_device_register() function. This function will return
-	 * with the CAIF SPI interface initialized. This is probably also
-	 * the place where you should set up your GPIOs, interrupts and SPI
-	 * resources. */
-
-	int res = 0;
-
-	/* Initialize slave device. */
-	slave.sdev.init_xfer = sspi_init_xfer;
-	slave.sdev.sig_xfer = sspi_sig_xfer;
-	slave.sdev.clk_mhz = 13;
-	slave.sdev.priv = &slave;
-	slave.sdev.name = "spi_sspi";
-	slave_device.dev.release = sspi_release;
-
-	/* Initialize platform device. */
-	slave_device.name = "cfspi_sspi";
-	slave_device.dev.platform_data = &slave.sdev;
-
-	/* Register platform device. */
-	res = platform_device_register(&slave_device);
-	if (res) {
-		printk(KERN_WARNING "sspi_init: failed to register dev.\n");
-		return -ENODEV;
-	}
-
-	return res;
-}
-
-static void __exit sspi_exit(void)
-{
-	platform_device_del(&slave_device);
-}
-
-module_init(sspi_init);
-module_exit(sspi_exit);
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 6538ede29661..5b3421ec25ec 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -15,6 +15,7 @@ Contents:
    device_drivers/index
    dsa/index
    devlink/index
+   caif/index
    ethtool-netlink
    ieee802154
    j1939
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index 9db0570c5beb..1f2f2e8209c3 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -28,7 +28,7 @@ config CAIF_SPI_SLAVE
 	  The CAIF Link layer SPI Protocol driver for Slave SPI interface.
 	  This driver implements a platform driver to accommodate for a
 	  platform specific SPI device. A sample CAIF SPI Platform device is
-	  provided in <file:Documentation/networking/caif/spi_porting.txt>.
+	  provided in <file:Documentation/networking/caif/spi_porting.rst>.
 
 config CAIF_SPI_SYNC
 	bool "Next command and length in start of frame"
-- 
2.25.4

