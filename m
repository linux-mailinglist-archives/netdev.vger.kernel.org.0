Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C608729E630
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgJ2IQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:16:59 -0400
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:52550 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729037AbgJ2IQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:16:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104]) by mx1.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 29 Oct 2020 08:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLff82fX8jth4FLeN8l8ISATwDn5XYdWCJ2c5/hUS89IjYb0lECkoxhFKejJZJhf1kNIbtwEXj/k4Y8rQYQU7ADErg6OoULl1PVl5ypOk9nKbVR5xDCBJEqSHjWNXlv9Twfiw2/XiUblsuLcm6Uf/mmhPl8UsOGWIwO7+oazVxeLGnAAMlZDMru+Q+FR3eCN7/CcLZn6+CPSgs8VPLCBYbHA/YOn9/3CfnJYzW/Nyy+UCkKss9oFMLBovwj+V2mbf0yBdvEhoFdBrXytm2Au8SPgaU6HpPTsMt4/VUEr69DUpyUntbr5xA11Jli5KR/WfcGpPpR6otyEaJuCQy0XIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS6JeNiz4Ffc2kkGBfBJMzLlhOhujnvTLRvEzo/13x0=;
 b=QVCQPBLEaiQ/phI4mHXVd3Ot1CWQtd/bG1Y+RL0g57wNoZoUoi6w7I5NQ4JwoxWCkj8/dMke9hwatZjfA+Y1KEha+iP3rA9NjtE2nmxFGvkrjenp2VvZ0/jbwRpymf/Rm4jRgxU6n58891XScHQUMBLv/5DP9cxavpv93AbJp2U+Rh/EFJQ1iZ3evgqXa86XK6sVKw2QXDvlb1l6N2yQ0a3Ke43iT/UwtdmVig24mSba7JKXCF5Wjo7mOwmPBJPjU0rPWFbDXnJ4D9KwB/2FBL79lsj/JHpM0qTdY050eSzROhJ3n+jr/PQQq/5P0MqYrAFRoWjVNxx2sqEVMK1xzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS6JeNiz4Ffc2kkGBfBJMzLlhOhujnvTLRvEzo/13x0=;
 b=pTMJt47cEAWZ29O5oh5hZVUfRw7dnAohL+XWqyKSKYt9PaasCMiJkuStzIOcb+crQmv+3hqyjkQgTlymCqVhhKW+A6RpYMs08tstbeydLFZEjf0g1Qri5FAF8xVv5S3g692lBjdFv8RfKLxD5Y6OTkItBb4CROTfLdnE9trL8pY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 05:42:21 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Thu, 29 Oct 2020
 05:42:21 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        marek.behun@nic.cz, ashkan.boldaji@digi.com
Subject: [PATCH v6 2/4] net: phy: Add 5GBASER interface mode
Date:   Thu, 29 Oct 2020 15:42:00 +1000
Message-Id: <9b93cc79d7cc07ee77808150ca76c9d243c8ca60.1603944740.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603944740.git.pavana.sharma@digi.com>
References: <cover.1603944740.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYCP282CA0018.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:80::30) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYCP282CA0018.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:80::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 05:42:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5e7eef4-51a1-491c-1634-08d87bcd67b4
X-MS-TrafficTypeDiagnostic: MN2PR10MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB41897A60C1541BDE235C2FA995140@MN2PR10MB4189.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bliv8L/ECH7f8GeK385w1g0YzCJVBEUwsDIHQIsYQ00RRljFaE4AKgZ+ysqAskyUaw4dhhNk2/jc1AL1/CI3dY02Z+ciZTB+npa2Zk2QngFVibEp8vDsp4cbBRQjFVgGGtRmICUGGfg0hg7Zk+2lsEzt8YEghhuJv02d/NNolqyxlIRwptc19ey7U/G1MvLOM/+G9FNP86eixHj2jXuO+omGBqYmJYRA/lo6sAn7tyvm9S7yv2OBwSgdGyz2OjwmSWSgOrVgcUZCEk4C+xeC1tcttFxox+S92VEQnXseYUsQgZ7dWBHCo0P5Z2BYD++2Y9DqyZBauyuh7e/K/5lFJcUrwvNY5Va0gkJo2ZlXhTlkHdnrSBiYxnxobA0j82D8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(376002)(366004)(396003)(2616005)(956004)(69590400008)(8936002)(66476007)(6666004)(16526019)(66946007)(316002)(186003)(2906002)(4744005)(44832011)(8676002)(6916009)(107886003)(6486002)(36756003)(26005)(66556008)(5660300002)(86362001)(6506007)(4326008)(6512007)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EvhDeRWlnvbbPIjpiTy+LR/Cqdz+RJgMXlwCRgt5SbuowgOGDFdgV3UG/EI/X3VbfQgOR7HhZPlLnJA10KqnSl1t5MiSHrViIFxXE+hW/geKsyInzYwFTpsQtSjSXbX/GT3VbJb06fRl064Esjs4IcfYdI63QH43efII5VCMs/pLiaTfgzyqshvKRHmjsQ/4vR90AxfvSGMN8D4SilfTGcPBxbnEwltnP6RksXq1MLpbxTKx2F1FlKbkZ/SFA1VHaV0TwLmDa3ftXhk8oTDHTQi73nmuv9UhBA9/B+lDfPzFLPsEb0LMw9Kkz1sW4TTVHaQwNhaJpIk22c1xwYceBhOmCoKDen07rGC5jFrYZxezqnBDuH2pvygmdos0FVmWzreVKA38oudGp55FCAX4boYeyE+R5hksksQQV5sCDrUCmtDPHvPGRIPC47ebPEs83UIHLiztecexl52IP99POqeBn+YCOGlwAWLY90u2BfA0bvbu6GyHkaei3QxIAtpMkhAeVpc0q7H27eOw0UdE+EMrJQFTJcEgju5LP5oOPX+eNJVtnk6dGHBmIwd5hYoupHk2sT3Qd35+RMzMDc3al7ci1nxcJLZMxHNYYNAOEsYnc0MFiR4b0PqdWlDrXKvlJ8oPj6/eKpoHdsdEc1H6CQ==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e7eef4-51a1-491c-1634-08d87bcd67b4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 05:42:21.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UFTo2z7NJfGaCkgkMyo817nESQtdFKEKh05eIOwrOkK8pKBvqsNgRLP+OO9QPAXl2iKF9bQRofJjGNODOEEOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-BESS-ID: 1603959389-893001-31478-248065-3
X-BESS-VER: 2019.3_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.58.104
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227845 [from 
        cloudscan16-168.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new mode supported by MV88E6393 family.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..9de7c57cfd38 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -107,6 +107,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
+	PHY_INTERFACE_MODE_5GBASER,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
@@ -187,6 +188,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
 		return "xaui";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_10GBASER:
 		return "10gbase-r";
 	case PHY_INTERFACE_MODE_USXGMII:
-- 
2.17.1

