Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E24BE586
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380773AbiBUQjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380782AbiBUQjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:09 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE3022BEA;
        Mon, 21 Feb 2022 08:38:37 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A7F0ED24FD;
        Mon, 21 Feb 2022 16:29:16 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5F39CFF804;
        Mon, 21 Feb 2022 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRgKG648hOdSkPSK+Ra17yf3vVrdkJOIS/gSbgZNuPk=;
        b=S49qdn1hnZBcRsguEbukf7/eO6ALAhSvMvmyv2kEwe6zRJO88M9Dj5DXQ93SCdfGt4W+Qs
        OeYHM0jZJvDRWKkP/Ix1yc/hQ80Sd24VszyimxQYcN81tYCXYHtvp1KyV+75stqGE3QvDi
        Hfa8r+SqoDWwHFHVvI9Lb77xBgDZSdudMdYVjfNqwN9fitFBRdICbyHH7+z+rYyNsxeB/3
        r3/flFsSqEmQ1UTknn6jjSdYp+6ha1Ws3CraHqaxmYZXvRLjV9IQ3chkd/6c0PTQheAHYE
        XbVHbStw3GrlWR+wI8i3D42lXdzT2sIOFg7akx8vaOxGgDKXbqJUQ/ACG9rABw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC 03/10] base: swnode: use fwnode_get_match_data()
Date:   Mon, 21 Feb 2022 17:26:45 +0100
Message-Id: <20220221162652.103834-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow matching devices with software node with
device_get_match_data(), use fwnode_get_match_data() for
.device_get_match_data operation.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/swnode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 0a482212c7e8..783ad18f49af 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -662,6 +662,7 @@ software_node_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 static const struct fwnode_operations software_node_ops = {
 	.get = software_node_get,
 	.put = software_node_put,
+	.device_get_match_data = fwnode_get_match_data,
 	.property_present = software_node_property_present,
 	.property_read_int_array = software_node_read_int_array,
 	.property_read_string_array = software_node_read_string_array,
-- 
2.34.1

