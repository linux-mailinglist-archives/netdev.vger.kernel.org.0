Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206042D7612
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392467AbgLKMxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:53:01 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:56530 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406013AbgLKMwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:52:31 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2051.outbound.protection.outlook.com [104.47.36.51]) by mx3.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 11 Dec 2020 12:48:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kL8WCyBmiXhehmQJCrtBs87ggKu5FyDj4zCN7Q4xhPuuR7QNch7RPvTf8qZ2x4utcg0ua3RzHGAkPlpGuv8yRk1FIW91yTVLae52JwZ0r81u/pwW1CaKGxAr4Pz9lC75i0uihG8dtBZcKeJ+jCTBEjrOBA/J+z2ijFwuz6blmEkZej9TWBjPa8m3pOYvRQWp1r8dVtOxpUf5Q6IVYqGBUPiQ6/gVWoG+ormdrYvgLymqUl7AHglbnjygm0ZblQFbHZSC37sjHluu+WcO56dln8NEeYj4ajPlp5G/3aM0/ocXztiUslq8yLsPaC6jwD+F7APIMckwuLlGEU6bjE/1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3faP1DqIpZI/cJsldcWptIISD/Px2CLFUEujzoK5w4=;
 b=aSGSkVkii28d6u0fvuMCOuQnnWoECO3Fk8MB865lwrnSI79AxIApy2O/8MtDhIzEsoTJdfwn5PHKvNK1Sis9BbGATJ+kb7ccSKdh5DwdHoI/X9kkz5yGmRpgpiITkS2UiKdZ3reb1BLUXnQCmnSphz/cnWBqK6rzsJexSinvDFsfDosz+C6KmexZm3mu329ubM1uvuMdAxzW9VW4miL06TMQBjRUr+YJARjLHuWyDg8s6m7ewuOG74k/1GJr/c+ZTXp5P/60hKX5Lgg9TXV/x5ABTXRJvyvGmTS+ZSrqxF/rABOTq/qKAdo6WzkMBwAWQxB6LXXGoK4N5HnLFGWHGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3faP1DqIpZI/cJsldcWptIISD/Px2CLFUEujzoK5w4=;
 b=QS+v/jG+djQ++U4hU/XEUcVczbgQY0zjtRFPXGT1TGlF44SoXSj+jQt7nqzA5HLyO2ieZpJmO5F7VqQmU52dgc8De3TnGIWYpLYLIDjquE0+Ybj3AELCANUSkR688nvmT/4bs6tzzf6jHJx8OSNiwni471/w+K49IBADtG7XP90=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4384.namprd10.prod.outlook.com (2603:10b6:208:198::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 12:48:53 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365%9]) with mapi id 15.20.3654.019; Fri, 11 Dec 2020
 12:48:53 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v12 2/4] net: phy: Add 5GBASER interface mode
Date:   Fri, 11 Dec 2020 22:46:44 +1000
Message-Id: <5296c5dee3072ac0716de0042b3de344e7445d04.1607685097.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607685096.git.pavana.sharma@digi.com>
References: <cover.1607685096.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [220.244.12.163]
X-ClientProxiedBy: SY3PR01CA0106.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::15) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (220.244.12.163) by SY3PR01CA0106.ausprd01.prod.outlook.com (2603:10c6:0:1a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 12:48:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba1d3c49-7f5b-4cf9-fdcb-08d89dd31de7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4384AE9598713466F636CFEB95CA0@MN2PR10MB4384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bBJ7y2u8lzZfP7VhudpR4rXWxnAZLt2Pp/gj/BuYp0g+XfYeG238I7KaByS+FMb+xQ+CZUCHe66ho77tWQRSWD5jrP8rVJ+9NWAApbqVAoOeGj4W8Gi2dqkdI0FsUJVbulm0CQWVe9NZUEyDgXt3Lpg1RLtBamiealRR4BLDDJE8RfGD5rxLcFkENjxOKGO2Nqoo8edJjOds2+/ZKeUmBrEq9sszBWd80u69XrVWte3TU8dHVzrU/c/Ndh6qZ3aG6zHLUU4WdyyQqSKMGXVr2a3dRDgKuoduQKOF5aQ81lV4eenFdAfg4lOYPzdGsx4/YiVTJnM1tmGB/wdpY5c0CLzjKiPekBYHFmEV+weQHB/9j8Uiw0RkMWebss0Q2psgPLEq9Js6grbYt/nd2GaL1bjL5qsDZuRgqNYxhyGtkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(5660300002)(69590400008)(86362001)(508600001)(66556008)(4326008)(7416002)(8676002)(36756003)(956004)(26005)(52116002)(6916009)(16526019)(6486002)(186003)(6512007)(6506007)(44832011)(66476007)(8936002)(2616005)(34490700003)(2906002)(6666004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P0EnO0p60CaAgrjtlHVlwYCbN9Os1fZU81GlAjvoGLrQ2IOJx9w9nz6zsRaG?=
 =?us-ascii?Q?vO6PYDJDnPZ5GfNA1zI9UPYYVnAeQC8iLrE0fu4r8deeeyNUYLILtzJ/VQqs?=
 =?us-ascii?Q?Tnx0GIN+p3SENc3u6joFOWtffXQ4+i1iWLm/yOWj2CVYjxrX5tOo9LoEEFai?=
 =?us-ascii?Q?mX+e+wmFCrvS+DmogtimD5IEQmtHCLfRuFKMclSqH7XOg9Dbq3AYNRmRXAmQ?=
 =?us-ascii?Q?t6BLOQ614r1O5yrtZAiqE2v8TrHCHnYdvNnerFJOA/1ZGMgFjMUb1Qo3sf66?=
 =?us-ascii?Q?LoTot+p/OHOTLPPUkie4HoO+wtcdcLQi9C5KyrLZpAQ62NnhwM+rqZq6EGYO?=
 =?us-ascii?Q?PujA92AT3+rwlwIQh8q/SQeNTdVjubjybhsuxQY6mhyiGj6XNKkxvYMGqdXe?=
 =?us-ascii?Q?AvC6UiA1h0xFeNszjpu3usRoYNVEipgf8YLbpaQT1G4LHyAP3s5NmyJwVfKl?=
 =?us-ascii?Q?VTkf2+2pqtwLCL8++xWIBzoY9P3/lEMUq+rw0ohfdNkRg5BNF1N4rxUkgYJJ?=
 =?us-ascii?Q?AGGZzDQj9G80SgDTf5cVEUV+56WHZclBymDNwItya7Y/arz5FqC2UAxOBqlq?=
 =?us-ascii?Q?qpvrS470rmxVRN+5zBy2YRlxFpQkDIABygKO5HWL38IhWImO4LEVkxWqXSBr?=
 =?us-ascii?Q?amdM0usf0HlZhggDHYtwrPiu8jNTtYvpJsvarKL9acMKiFmxsVR+mEvp/EP0?=
 =?us-ascii?Q?5BqX86smsDH6r+lsGTVFA9Mnf64UONxYTjoNDQ0Ct0lhjsGT55sLuZz7Wcy0?=
 =?us-ascii?Q?QZ8GFYRCw0iW9tm5un2JlVupUWwP3qynU3ZtSwoGoZ147kUuyd0dEmGDk/ht?=
 =?us-ascii?Q?Hym0sf0iUk9OXp6N+Vt1+Xm2f1Wgdjhw1kk4C9YmtKob6Wr8pPnSgdXDPfyl?=
 =?us-ascii?Q?SYc1cD+x0ljzYvbql7Ny/eA+ZMpdq5I4ptcqfcqCBDsfoO4Qr9ICABM1MJZL?=
 =?us-ascii?Q?VTNDk6zdhT97TDCuCq+fnzTw/a6yhL4oiJ4cRsKbqZYd5lq7BK0a54PCZNJg?=
 =?us-ascii?Q?ZZaY?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 12:48:53.6516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1d3c49-7f5b-4cf9-fdcb-08d89dd31de7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8P6hGsqB0myLtvzKwpKbvvaGgnlkV2rmBtPipG9+sv51aiGFPlrhfzsRhx07Ca/enb2bDefFPICDJ8z+V2SZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4384
X-BESS-ID: 1607690934-893005-15672-75173-1
X-BESS-VER: 2019.1_20201210.2155
X-BESS-Apparent-Source-IP: 104.47.36.51
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228760 [from 
        cloudscan13-125.us-east-2a.ess.aws.cudaops.com]
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

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 381a95732b6a..868ee5cf7fce 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -207,6 +209,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

