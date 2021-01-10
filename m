Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC3B2F080A
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbhAJPeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59100 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726929AbhAJPeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFV6Tl027243;
        Sun, 10 Jan 2021 07:31:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/g/es+Tg5FBzCKG2QIZyAEonCnsAEgNRvkP3FuHc02k=;
 b=ZYzw1kMml6yKG6aaT8MoAJ5yUsZM2gPe56roDFhZgDMKTdYgQOW1Yh8F62pW9z71HUSu
 GfFcJD2l0kK39eVcYBvDyDoQo9q/zWP4ljQPg/2o0M7mK0lPZffH/zy7rwVSoO1xc6KN
 0WCxFxA7ckS9iiPtk3pu77LeVfLnkdFIFhnPFNyNuamYEBHcBkCSUlbzF5f8VssgnHB3
 g3uLLsvV/od7e/MeeqeTinjJfu7wzKjvJucYB8sWjdmiPg1Niy9ooDZao6u5cDLeP/11
 WwpUIhR6I5Bm/78Kz5uxf7q3W5V34Sfdc+kcftXPcNJVXoACO2/1jGw/gEN/EpR4cIzP qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsj5fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:20 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:19 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 063BA3F704B;
        Sun, 10 Jan 2021 07:31:15 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  07/19] net: mvpp2: increase RXQ size to 1024 descriptors
Date:   Sun, 10 Jan 2021 17:30:11 +0200
Message-ID: <1610292623-15564-8-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

RXQ size increased to support Firmware Flow Control.
Minimum depletion thresholds to support FC is 1024 buffers.
Default set to 1024 descriptors and maximum size to 2048.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8dc669d..cac9885 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -715,8 +715,8 @@
 #define MVPP2_PORT_MAX_RXQ		32
 
 /* Max number of Rx descriptors */
-#define MVPP2_MAX_RXD_MAX		1024
-#define MVPP2_MAX_RXD_DFLT		128
+#define MVPP2_MAX_RXD_MAX		2048
+#define MVPP2_MAX_RXD_DFLT		1024
 
 /* Max number of Tx descriptors */
 #define MVPP2_MAX_TXD_MAX		2048
-- 
1.9.1

