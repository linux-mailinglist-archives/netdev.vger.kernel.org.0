Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4CA2B8A03
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 03:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgKSCMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 21:12:22 -0500
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:25596
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbgKSCMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 21:12:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQUI8Cx/HZFlH4hm/ZvXmWwdlViCeMFW12jzeTiV9E/4Wj3Q7hmwEdmhn4GAFdbAkisd9blNoNlQnJEmfLy26oOme2udYu87ipKah/aSbJWTcUyZJ4KIHxrvlORwkMRspO6WGGUVvWSkBKxQXLi7zPL/HN0yjyZQ0GB/5uGHI4ykyNicT5VItfGQqepdt91G3KS3T022aiHc1sDJ3erM4ltPuIwXmjnBbait/Ix3pZNVRv623nwmfg6HSCFVl/SIB7C0a+naOoJxOrcy1a2ry6YRSan9Ua1qVO1JLnzsBxpx6fm7cQ/ep8/XlYTIL2k5VImBKIxEZkZzeMAosCicqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSbAXEGFPpxFVYxRqB7XtqH0stt1BW2eRc7p8ECMJo=;
 b=HV/GmZNrfVeAx0WYe9sSySfsnuslPA/7srVg2WaOyTGV6aMzai6fTJdCRVhwmxQzMVggvcRPMflkGk9oPtoMoD7BdXUHzXO1vGLY53gdGYOrOAhLbFCd75sOyMopLo+MlO4bCfU+TW9IywiAsYi+4+9Dn/sojtfWdYg7Dxi1ddIqt4geZIYQKWvKQZ/6IYVxKx1L4/CXEqpjIFq6KNknRQwhtG+HGElC/wAwacV/4dG9IMUeO4TLlznKSyLuRrzhmKswuq0FbSeK6KiaIvHE+qm1m6ieE5z7XOWa1cqw90vRfLbDumRq5MngDQ5S2W/MxZoKoVKoYDtuIhY6k5OFcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSbAXEGFPpxFVYxRqB7XtqH0stt1BW2eRc7p8ECMJo=;
 b=IRF62gIw5iw1thznLhSAUg7602+zob6UVRsaDOZszNXaqiBoLy71KyYFZCvG8R3hjyB+Je2wFfb5x4D6RGZzty3Wjs4aG3g69oWTdD//+hoGbnP8+Alf8U+5VGHyD3yqPZsSPCqh+iR5Y9NoAUvxt7Sh78GCR32Vgglmc5WVw7M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synaptics.com;
Received: from CY1PR03MB2377.namprd03.prod.outlook.com (2603:10b6:600:1::13)
 by CY1PR03MB2300.namprd03.prod.outlook.com (2a01:111:e400:c615::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 02:12:19 +0000
Received: from CY1PR03MB2377.namprd03.prod.outlook.com
 ([fe80::7dcd:33f1:8c3c:d7b2]) by CY1PR03MB2377.namprd03.prod.outlook.com
 ([fe80::7dcd:33f1:8c3c:d7b2%11]) with mapi id 15.20.3589.021; Thu, 19 Nov
 2020 02:12:19 +0000
Date:   Thu, 19 Nov 2020 10:12:04 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Remove duplicated REG_PORT definition
Message-ID: <20201119101204.72fd5f0a@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR11CA0099.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::40) To CY1PR03MB2377.namprd03.prod.outlook.com
 (2603:10b6:600:1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR11CA0099.namprd11.prod.outlook.com (2603:10b6:a03:f4::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 02:12:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 248ae3b7-5c6a-4f69-6aeb-08d88c308ae6
X-MS-TrafficTypeDiagnostic: CY1PR03MB2300:
X-Microsoft-Antispam-PRVS: <CY1PR03MB230027A7DA6012B3428A34CFEDE00@CY1PR03MB2300.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9Z8d9p1SsT3c6Em0ivkszOV1TSHil37VzwjYBOhzSABfeDMd8/SeXBgTU/jgT8mOsXIwhoOZljcgyGRVwBz0QCZisKX4Xa7KESb9Up5NO65DFL22g7PTckyzUMQh1jtzYPc5DAJfus53zAU3iTJKanaWtu6A0Ii/GWTEk+k4xDmjevjKiibKubi/HacgW/YiOk01eNjTxoUKQbZmmpKXrTGgMi0OX9bnzkctb1TXH5dCQPAUSBpH7TzRG8qpdX4GbNo/vUpkb5NWiNAIesBgL0TTg1+Ms4Bs2HmA+dAfMbWllqWKTcTEsy5y8yrI7Vq3s5HpysjlMb4R1x4hcgdiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR03MB2377.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(4326008)(4744005)(6666004)(1076003)(66556008)(110136005)(6506007)(26005)(2906002)(5660300002)(316002)(9686003)(66476007)(52116002)(7696005)(956004)(186003)(66946007)(478600001)(8676002)(16526019)(8936002)(55016002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5VnaZlCvU1BuQBZh2Svbd8C21uEPrgoQCE9I6cpWpAcLpwPmCybG+SpoutS9GikZG5ssZI7JZo4moPo2BUmqhC2mJd4VL2lZBTm6nA62za4jmDyUMzD5hvWDJVK1MA3Ex3pDCiT3IR7096aQHEOvyQdfSFU0Ub2qRvOjTNWyFpX0q7zz99WMZ3Sa994c+9SHKaD7o61iUa1AzmrXOv6Aa0BsOwQClEw+bD64JuFsbwPiUE6dsr/JFYNK7ZOAOMeWxHcCNfukni8AgiojVz3CDs9G1mlU3eE3H0iSRDOgOXmRU9l0ELX8NKGEwm3u2/Q4EyNOkN4n9/tYBH5ObEShAGgVxezmYB5rXjla1Ht2czQr8wEMyrGuiubma925c9te4/HZI3JhQrCfEBXgS5TxZRnxYyaEZVV77y5higpIelcgpxvMqZzV8jxnqDCQFJm9j0TPcJXACf6fJGhsxA8T674lPsNcr+OWlO7gyLLgsvvJYs46IYQ6PyGiiyCzZR65gPoNdlELgivRxmvlGklWNzl1kpo2gR7fBpKeCJRyKbfCOyI3ao4Tb9iLihZ+6gHwqwPr5mwdKJU7ZoyMlRlWtr31iA5S6vbfsv37J+v6iM3D9+kTZM2osOooiTe7V56DQCXNlHDzcp27iTx1OQ+01TuZ6V0zfDoatQHhA4TEv3Lr1zfx5fu8QbJIBDIBgQaawUCtAffRTdqDFirMUVuSgEFJIMlIrP93v1fcOF0cGamQRmC7XxTaw0R1NY+uMEBF27IDSz0YqC5BMTFydzX0MHNE6MNAMUUFbL8KIRpqVrMi6mJHtA3+hFwL/6QR3xLcHL079ekhDW17spf326+XIN3ibmM63WU9lZWwz7MP/ItSIJd4XZLxcC4yKPoBfwpA6TUC2ftUr9uvfCgO5JEBUQ==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248ae3b7-5c6a-4f69-6aeb-08d88c308ae6
X-MS-Exchange-CrossTenant-AuthSource: CY1PR03MB2377.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 02:12:19.0580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AD/dVjJ4CvVuon0SlmeOZuCfO+6SrCVOfp4NH1sUj+4IhXkawDvJnGzc7DwCq6Q3AF9P2VjqFP57ZJdlFYFHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2300
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The REG_PORT is defined twice, so remove one of them.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index dec534a6ddb1..5648512c9300 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -43,8 +43,6 @@
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
 
-#define REG_PORT			0
-
 #define MWIFIEX_SDIO_IO_PORT_MASK		0xfffff
 
 #define MWIFIEX_SDIO_BYTE_MODE_MASK	0x80000000
-- 
2.29.2

