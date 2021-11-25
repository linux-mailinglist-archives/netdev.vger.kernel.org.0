Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5145E34D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhKYX2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:28:31 -0500
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:16203
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231829AbhKYX0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:26:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jojd/F/7RnQPm6sAHgI+Ai+9huDZcrUUYJTVh7DrQDDisPfxNVKDamre65C9zp2wL/vQhFvi4C2BEBUDrNslJs+uYlHIsiifH2Z5tfuq8HLrgqN4oea39Ks3IE7WwgwyHYgAt631vYTdcSSRvoCJbDTa0LebRmKVV9eag/kmBvay76TMHEDyMKroDKyQK3QNz2IVkyExLvvSQvk9kOiPYP8LtIXSNAKLvkMC2n557fy0dgwz4fE2mDGajtdsnIRdsNJNT23oYFnBGlqOYakxYvHZAK5M+5o9M6FvH7xPXocdw6CK+lOFVsdq73zcB/ml+C7lvdGxvWuGiMAx21WouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCjNjExPNcbJ56UCemvri7tFPaRAHXp0zSPmZE9ouTM=;
 b=fyEKzieA1oM/4fSFD4PPs9HOGwtXm/Nr3OenjowjtXMbHlvO5MZGXL20qv6EPXb1oAGG0IE5jVYVV+1l4uN3RcgKVVRsjxtwYAgkqVXCY86tOFLcEYVl9ZIvdtj1dmKhJgdiOwQLlBIDLYtuRqyCOgdNjrUwGGTBrAYl/cptUiGUudbCLtj62aP1Dq9aZga2GZp8JnVU/c9YBKnOJUklPRxCxRxiqfETYVYMirAI8ylBPOX2jTRhgtka4RnhJetAKlFe1iJblimYK6mRD7/4o22CzlHasu9URRSEs5Twl+pY46iTD86YcfAd/sZT5NjRg8IjGjMXc/T52CkyM8xS3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCjNjExPNcbJ56UCemvri7tFPaRAHXp0zSPmZE9ouTM=;
 b=oPQmgwsqE0Kc47wOsTF7JOmpotfp2jdpEdWT0kTsZ5rbu5+vRdbmzPJGmyC6yn80Fw08AEZ6q/X8wvEDDtRKvnr5r0JpBXycI4GXlRUd/ku5f3B4LATzf9cMVysIqLrHRA8wLByOKpvzLD3eToKSDxrbugfe2N0XLFMUDr+OFlc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 23:21:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:21:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH net-next 3/4] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
Date:   Fri, 26 Nov 2021 01:21:17 +0200
Message-Id: <20211125232118.2644060-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS8PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:20b:311::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:21:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf4402eb-5fc9-4aad-ae88-08d9b06a59d9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862DEB103E990ECE46C5BB5E0629@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KStMqJcowPsc0DjjYxFn8225iPFDBwoVaaDhjeVij1UEUJuJBJPYWzfT/ZOjMi4qhphiXqqnK/Q58w91umrfsG0YtNkuN64LFyuCIHrpHGFb3evyhI//wda3rgHdvA73sJ8cZaqAeG5/S/mYXbZMqKYfh+ov/6i59ejXhfTZQEcAGw6sLDkQ3XujHpJWXFpRX1UDEXLRhwH0L9LHUH3nAawPYK6QcFPZBiR7SjLg+j4Is3k9im5b6fwetZkic0/Rr3Elqdd+EHpFTa4fay04buMY3xOdGsOgkpQhHQWnaWf9DUZMY52rGmQU/Fk40/STvjJsJ/goa1XHN2OhUXRFhDVGzEv2o8QOkdlxW3lyvcYEhGkWNt35ZBjbl4b78ER6/8FEF5wHda7yhGBXBnPJhRS/KVu3DcbBuSCtjxDshHoOvOreWRuZGHXoEIG0gvPV/SNFHaQPekrZgEMvPyBElkFZU8LCyVMpQ1ndp1HERhPAeeSNdvpmQKlqCzy7Qerqb4m0+OKYcR9JZ6VV12clm/mpTSzoNFLNWZ2BMw7du5AKb4xEzoUR0X4tKr9UNf8BO8oOWxBsbR9dZekv025M3ssMhoTZdV/luaxSXXArHswtqzJBPolL4e3vVFQl130jCCzrHEvIquOZ1hd5oeH9GEQ3NTGXHXIm220FvkrgrQ860GbvTE5bW5CB2WCKwuecSkZUw/tGA0WVJ22do9U7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(1076003)(8676002)(5660300002)(52116002)(2616005)(8936002)(6506007)(44832011)(83380400001)(6636002)(6666004)(186003)(956004)(4744005)(6512007)(6486002)(508600001)(66476007)(15650500001)(66946007)(66556008)(6862004)(37006003)(38350700002)(316002)(86362001)(38100700002)(36756003)(54906003)(2906002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+zKLuNXicb1wBvXnz/k5cPJ41CxSYWS1EKTXJpKy2SavMMShX68JbTuXeae?=
 =?us-ascii?Q?QRrXGLFKw2mLD5Q2rBdX/fcidz/qFH0lAI8TDpNCeVpcMwmkpwP1vSmuxbe8?=
 =?us-ascii?Q?1nOqTz0gi+6d3f4qrTAhX4dx56E1oXhLQqufDH0YurDJV7Jf4v6mgjq/sJvS?=
 =?us-ascii?Q?atl3ByBcO0V0B9aFbcuiFPCrJ8NLE9nU+j655Wp8t0xF9Gl5Lk9s/oe30j4m?=
 =?us-ascii?Q?P7ZXioxhjSanhQOhl9ppW62Z2frtcD2ibJkN7A5uYA4C7F4v306n65uAS0J+?=
 =?us-ascii?Q?SqJg5svDpCQlV0drTwLOf3U/EHMhoxOXegNcWINxvrkzi2jwDL5r/NroF4AF?=
 =?us-ascii?Q?iX+4ZORGzgVY+UzO1uPNh7dQoM1jbWz3lTPiUxXNRpXyPprvIRriRbNG4agb?=
 =?us-ascii?Q?4Obr0pqwNqctFOUJwbcZjHZl9QanfbvF+Lg/t39AFfuEQEyJr7O34sjzZAe+?=
 =?us-ascii?Q?eNDrEeCz5RwI8uvrB0klRNNnFIFPc+b4xEG8WHJDv/kSIMqppJyhXVgEH30z?=
 =?us-ascii?Q?WSWZ4U6POk9PTRI08pts8BEtLQKCAXERvarA6Aia5nqkcCxGLWX5hT6IU8gl?=
 =?us-ascii?Q?63yl9yhT8Qg68DCiWDyRwckp/RoaREnpOCMPISqwiH5bDNGrCO2tTx7CRFA6?=
 =?us-ascii?Q?FzX2f1/VAsml9IBMthWLQQCn8eO0LgGDX7DrUidC9pb/TuR6tr+aBOu1N/kN?=
 =?us-ascii?Q?vW8Z47gJPwO9g2ju2KrLjkFy1HJi4cR3LxWbf4VUQUFKBRKWO6gr+/ASAT7L?=
 =?us-ascii?Q?ymyf4VrIy9Pqqm018yjzZLCPZyy+XhcI26kULqO/q9HZI4Xv9cVuPwAaFDiE?=
 =?us-ascii?Q?cvz6xyviHLAbSi927C9j/y3Wf8Yfc0mDUgwKGZnxZWdbJhVCYnaOa2oN+Z0+?=
 =?us-ascii?Q?z/MMel9ukXENZPXLIuPRD5PqwLsBjN+2aWo7XIIyX4bdzTn+5rDcxLkQYkUf?=
 =?us-ascii?Q?nuUwCOlHO3nL414Xr9Zsmss6bNFSklLhA4CUUd0ipJp3TOBrfpJSYKFRJyUL?=
 =?us-ascii?Q?HE5p6NMFMoXsXLTtD3fVdqTMC9kDQ3lCcG5pDLEBuRgpsbA2cNX4wvUYBVJm?=
 =?us-ascii?Q?wRy+Zl2ZVMff6Fx7sIOZZXpU5HHN7UU+Qg+++GZ2v5c/espEJdh71zOo99JH?=
 =?us-ascii?Q?ecLUwouEv0sRW+MtLjaVTyBqA4gJqdt/X69gdv5Fttz3qbu23zmEaaXyrxnD?=
 =?us-ascii?Q?O6Q1NacT0BCiWYJ7LWU8pPZgRg7NofR2eOcP1J6ojSvHwTtiPNuHceHCHeeI?=
 =?us-ascii?Q?VXcxwvT+5a/u8Hf4pA/M1FiwRGKpUHzjBDj4yBfrY0m52DsrkMlCzaegApM9?=
 =?us-ascii?Q?l3ZXyLDFz9KzmFZKR+END51b1DFq5G9d0KXyM8DwxEY51ngolTnvw1Yon2h3?=
 =?us-ascii?Q?TQH0IObNtwNuNvGR0px/Lscj3U2Duz4p/2VTlYqGjFqTAF91ZGjKbP/MPgH6?=
 =?us-ascii?Q?LGSoZ9Fn4I3PjDdu0QaWNaFqG22obLL7LrGff/1Un2cU2PxfOU9hqgFgUv/5?=
 =?us-ascii?Q?Sb9ojToEHX6TttDEW24ApeBIWUJ6BSejLs9IIzySxrSh+MlmwHmKN/tV74qg?=
 =?us-ascii?Q?l3ceXx5xWLaD85GgpmKt3rR6Quz9ixcdORzAXsWw1yJiCqv2mNdNpZgKGEa2?=
 =?us-ascii?Q?LlX235ik2v97JWDlEZEDZ74=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4402eb-5fc9-4aad-ae88-08d9b06a59d9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:21:47.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyL9JpgWBjHC+6zDl/rFpCuaVt/wIKhR5smepWUKxv6BMSg9VCdeRoRpTIs4J+c6Uh14olQ0gssLwvBWhhVeiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As opposed to event messages (Sync, PdelayReq etc) which require
timestamping, general messages (Announce, FollowUp etc) do not.
In PTP they are part of different streams of data.

IEEE 1588-2008 Annex D.2 "UDP port numbers" states that the UDP
destination port assigned by IANA is 319 for event messages, and 320 for
general messages. Yet the kernel seems to be missing the definition for
general messages. This patch adds it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/ptp_classify.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index ae04968a3a47..9afd34a2d36c 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -37,6 +37,7 @@
 #define PTP_MSGTYPE_PDELAY_RESP 0x3
 
 #define PTP_EV_PORT 319
+#define PTP_GEN_PORT 320
 #define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
-- 
2.25.1

