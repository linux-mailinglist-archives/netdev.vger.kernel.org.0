Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90B537ADD
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiE3M5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiE3M5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:57:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622F5D127;
        Mon, 30 May 2022 05:57:12 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UBlFCt015426;
        Mon, 30 May 2022 05:56:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=4x2Kj3Z37xHSZ+jDDGeFI/X64XLEfx8wXlDouARLtRk=;
 b=Jzo+lZ9sWj303TkqsO0urTdP8N+I7SC3YJMGG/UuBnr4uNCrkpOsv3d2OIjg3bz9q0Jc
 3KnJ28sjMsB/WLDdr/9W+jck/clfJTfEFLm0JfqpiozH+kynx6yGuyjBwg3ES0q0uL0O
 jE3SwcYTEWybIrf1mI47dKQKUv5ezgcToQuiBn2vwCJ8m2XRpk3lTR8sTA1ljmnEBhg5
 Oh48GHg+e3IZXr/oqCtSwBsB9yEIZcN7gsYLEtcHOFd2DJhCKQSiQRO8baP2NaSsJOXH
 7qJcFTjji73rPQJ5kheZIWEANoOsbddLIYIltsnIgMp/pY57MX7JlUgp5J4TIaIkP3GS +A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gbk8n5fbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 05:56:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 May
 2022 05:56:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 May 2022 05:56:48 -0700
Received: from localhost.localdomain (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id 25E1F3F7081;
        Mon, 30 May 2022 05:56:48 -0700 (PDT)
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <cchavva@marvell.com>, <deppel@marvell.com>,
        Piyush Malgujar <pmalgujar@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 0/3] net: mdio: mdio-thunder: MDIO clock related changes for Marvell Octeon Family.
Date:   Mon, 30 May 2022 05:53:25 -0700
Message-ID: <20220530125329.30717-1-pmalgujar@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4sPBX4jc2_wi0qHvKbix-7Vi7MMFxA00
X-Proofpoint-GUID: 4sPBX4jc2_wi0qHvKbix-7Vi7MMFxA00
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_04,2022-05-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series mdio changes are pertaining to Marvell Octeon family.

1) clock gating:
	The purpose of this change is to apply clock gating for MDIO clock
	when there is no transaction happening. This will stop the MDC
	clock toggling in idle scenario.

2) Marvell MDIO clock frequency attribute change:
	This MDIO change provides an option for user to have the bus speed
	set to their needs. The clock-freq for Marvell Octeon defaults to
	3.125 MHz and not 2.5 MHz as standard. In case someone needs to use
	this attribute, they have to add an extra attribute
	"clock-frequency" in the mdio entry in their DTS and this driver
	will do the rest.
        The changes are made in a way that the clock will set to the
	nearest possible value based on the clock calculation and required
	frequency from DTS.
        
These changes has been verified internally with Marvell Octeon series.

Changes since V1:
* Separated the logical changes in separate patches
* Replaced macros with functions
* Used proper property name for DTS
* Updated DTS binding

Piyush Malgujar (3):
  net: mdio: mdio-thunder: stop toggling SMI clock on idle
  dt-bindings: net: cavium-mdio.txt: add clock-frequency attribute
  net: mdio: mdio-thunder: support for clock-freq attribute

 .../devicetree/bindings/net/cavium-mdio.txt   |  5 ++
 drivers/net/mdio/mdio-cavium.h                |  1 +
 drivers/net/mdio/mdio-thunder.c               | 68 +++++++++++++++++++
 3 files changed, 74 insertions(+)

-- 
2.17.1

