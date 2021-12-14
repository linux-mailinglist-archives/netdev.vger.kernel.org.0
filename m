Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBFE474234
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhLNMRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:17:04 -0500
Received: from mail-zr0che01on2122.outbound.protection.outlook.com ([40.107.24.122]:35264
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231878AbhLNMQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 07:16:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iW1SWwnsQNDNNeeIYRQr8kGZp5xEmAsXq6VIT/S+KscBgsGLNwBmonIvdR8SPvBhfUO1qfVmkFhUExq/WTcCn8l42HJY338YET5riid0Y3zjVLmMQwu2iM/H+Pw44vWzhxBJIlVIGQlkFaXi1W9XInD0LwFoxj2HcH5ND9VNaUU2dHMJtZHwuTKffRYI2YZhsyYvjsEy4Z8EkaSMEz2t/EKw5dczxyIhSCiiTpVu26Vlk4mRm/i6Pz144BC6VyoAI1nPmM2xQ+tKii/DsaRkIbzMWKJf3ISFn6ngohXydudk1UZyvuUifQvDMgjFJJVGYVcvrpcvab2BK6QbmIO7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3eOj4qiai22fOPOt13QN1y/qp7600LQSeJ3J+9UUY0=;
 b=gQgrXGFNkAMz0+fdxfLHWUBN8/8db0HeW6cgYUjrCS7W9YSyFbqU0UiaL2XbdP9NoN97gUY3kAmzenJaUH7rCyAxZLu75GuHKRwcaRnYnaZDbrJ7Y6S0J+kakeS56XNxOV4XzhBIuEi+WbVItoQk1vOrZ1nct330FrJPvAco+AgBxOEniZZDeON57+0J+kNweoMyNpPWs4deRVbVJHVPwc+zU2IkKmtD8E/JYC6eJOmoL8pjsmgCjt2KijctevKHvBVPBIF6RdTUB6gDL72+/6gXm03KFVfFj4pqd84MAsEl/Yz+Y+At3/FB6cgtxycUAjO4TuPQeSeCizBcgCmTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3eOj4qiai22fOPOt13QN1y/qp7600LQSeJ3J+9UUY0=;
 b=fIhhPaZG1dn8N9pZywGrOVJN2kUKK1Pw+ME/ammo3K6Fx/B/L0KAc+9DeSvBVvVc3+sMuLon4x2j2225fYjtccHBdXiT6p2OxfPQoovZviAoHOP776UojBLfdvSZcZ9QVDN2/IQP02IsEssrjIGlkh8pEmYBpnnPkbP/hVfEkv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:36::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 12:16:52 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 12:16:52 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Date:   Tue, 14 Dec 2021 13:16:38 +0100
Message-Id: <20211214121638.138784-4-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214121638.138784-1-philippe.schenker@toradex.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0167.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::15) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69a714ce-cbc4-4997-bbd2-08d9befb9cde
X-MS-TrafficTypeDiagnostic: ZR0P278MB0234:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB02343F9601B4156E83D9A4C6F4759@ZR0P278MB0234.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/eM5PKz5UDXQKWCP64iTAjpy0JANs40InVoAL5K0dYROIcJjGUBwDb8ZjG3QCICRDhMjQ9D1ISROfEkles/aj3hXQbie2bshc6zixniif1mxYZXXbAoShZGtyfU+gDbfV2rOM3g0h1wFWTqvzUdyqAWU/uv/HE+nN/hlxHar5AqytcLzHbbArsEsJ91G/l5nucJZUn+m/BCZ5OHqfwR5d1MRzLW1D6SyFCkCv6BIoKUMZ3lK1TFez5H5t/c73etUO5ckK5Xy/qaP7V9GU1Okjg8CzKhSMHoea5hg0RDR4naoad+IIOvH6vooONFssRxwC7MoH/4WXzuoRvXdFYmQ6mS2h/qaEurpGmshWTHAG203zVxjsnekCbE0minoEx6p82/SDxAzKi8Qms5G4f0gytYGeR1WpiqrsfOxcNHCnFAH+JClZpdiQk5piSkpGRQJJXP28Pa4dFdfZdf2jGk3EMzLkG7Ah/ySZNAKsw0gu944hSPdsSgo/PdHjH0HwO/Px0Mkro/6UmhHdWyx/ivcPN7YCNo2rG7qR5E7+WgvW7kF7/6v5O9EdExixHuktN/U3E9Jl/TYNG5WemCx9O9mcsxnjV/SVi3JF09uvgQr5Mp6CqUFEqiUNcJ3s82uO7T6aD1nMTrb/Q19v4KG5NscflkgaVN0RLwBuazNVIXt3+ZerwrolKLtdY1t0qgqP/FId8Vg+xTCHKSVl5DXjK/Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(8936002)(86362001)(6506007)(66946007)(52116002)(316002)(6486002)(54906003)(5660300002)(2616005)(1076003)(508600001)(38350700002)(38100700002)(4326008)(8676002)(186003)(6666004)(26005)(36756003)(6512007)(44832011)(83380400001)(66476007)(66556008)(7416002)(4744005)(110136005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WOWTzSg95kdKx8sSH3Ca17ldVG7nxAr6qc/T5luJopyVOL7DlJqS2K/dJvaK?=
 =?us-ascii?Q?02LssLF4s+QNQUfhDh8EuwdXqeGpT8UDNlDy3OFg7pyy3fnLFnUGbyVEOgWj?=
 =?us-ascii?Q?isx6LnflVZUThcBPYklwpdnhT4c2AkLucWyF1Yozix8h59rS2ISd0f1eV1z9?=
 =?us-ascii?Q?JIYSq3bYrcwJwXgdebSq5+VPbHYEXox0efEGjbdGRZ7WpIOLrbJcFsPpvKIv?=
 =?us-ascii?Q?XyS2UHenKTkV+Rlj3qEPdl8FuskH0aofLTd528m8pHNFYSPDsiXy51lG0wUt?=
 =?us-ascii?Q?8M1JqQERB3D7rYCODAk4GREdOjORO3HBJf3nCpDfm6knX1kMmRHMK9DRKt/+?=
 =?us-ascii?Q?r7EPVThxI6idS7R+XTk8JdRtY/mCTut9vBx7Ld3Ws9ozwozSxIjNEQpxbnvB?=
 =?us-ascii?Q?jWq/n/hRCg3zV7XKcxJH370CzPcl8mB6ti8zkZty5tBHCdDoCfSKUCd1NTVp?=
 =?us-ascii?Q?7EHJ/ux2iI4B1yiCnFps+3cSLJwOjPnkigRXHLcSD2q3dhb9cwCbDMpBN15V?=
 =?us-ascii?Q?Fnmx5fCDn0L6zXmSc0zMa613ZfR7K3TqCBVigbznYal+x3j9ELbVZlVnsJl3?=
 =?us-ascii?Q?EWmU7Iyr9b6TuV9nvQ8HeO2vTeMK1qHkj/x49zk0RMcVOmg4Eji1v04hmZC+?=
 =?us-ascii?Q?A8PUYt7NcRC46KMgEiToLWUiNKKj+SrKEGEbHMsOYTup/X6EkPP83t3AIsPg?=
 =?us-ascii?Q?I5/BXqHZwREWUT4/EI2PemheLZ0d2dqWKrLPVJzo1xny0XlIEBNZBDtmguJ4?=
 =?us-ascii?Q?na3fks2I2GtcGumj06e9VbC0EWiAV7ag+Cb14vW4+NKrJodix4q7IE0sbhNs?=
 =?us-ascii?Q?ALMkgZ9dSydpm+yxW1pBHg2J7Df3fA4Jc+hlN0INvO4jW7XETn0CE85KvS1a?=
 =?us-ascii?Q?+T9r1kjkSb41kMn57kVPt9CJ0psPtt6NIlUePPD6XFZtnPimzCbAOgvOL81n?=
 =?us-ascii?Q?qNDA+wsRSJBPYRFZ46kyWH/HmTQ7KCrzCRC8x2vinE7MFwml8H7B1wt+P5mW?=
 =?us-ascii?Q?RsHFSO9NwkgDX+K05JzyEzK5qf3h3Afq6xuAHO2RmWzFFrgDqe89EY6sPmB+?=
 =?us-ascii?Q?FQE5B45a+aP3PWVASmcZcf6b9WkkQHF/9wbJyPL1vEo0Dft42Gd7ZpwEfMFV?=
 =?us-ascii?Q?YXYQehlWcEnXnEaij13Up1xIBevftmBtqv30WmVy6XMwetc6doyTIv6VQ9pj?=
 =?us-ascii?Q?7uI5Iqf+OVUHgYUjA3Ds5eQwR9ZSu9chDFcotH9yRlWR9RM7ZP7PyiItYn9Z?=
 =?us-ascii?Q?TeuYnBiMlkFzxq5fmyJMm9NR39IQ/PYENuR7djEysUBFt1ga9pZCsC/z+4bi?=
 =?us-ascii?Q?ipgmu44+WrpjDi02gNY7rmATyZRKZtjDvEfBQo7OdQAwpIS94u/h64EPntlH?=
 =?us-ascii?Q?FlYMVPLnhqwWetHFsvpOqWsTNS7Ir8jR6jRNG2VE4pIFW+LbVXk1CF5uO59+?=
 =?us-ascii?Q?TnPcbPcmNkRgHxrGJy7QeN4XIInhX2zs2w/W0mPiDbNTVdCw9WvUHfvjW3XY?=
 =?us-ascii?Q?Cz7guDjzR/c1+CpU6mVxoYzKbD6Xu5SVFcmrmVsLwchK/FZwpZ6JbAKRASU9?=
 =?us-ascii?Q?8ci9J8shVid16y/CpR21MLhd5tl6KRd8Dg4llTQnBylXAIimEs2GdhcxejyV?=
 =?us-ascii?Q?RwdUP//EdRSEPQATDpZ+XIXkoLQq6T6D76Il839eCt+NPIV5nYmSnasvvyJr?=
 =?us-ascii?Q?TCNriQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a714ce-cbc4-4997-bbd2-08d9befb9cde
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 12:16:52.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHU/R5Xi7yCWxiaFwX1DDl5I6u/D2UF1L8h026ipOdwZFyWzQSgVx/ZHjLD2dtOi3fDP1SW5aJrMRpU3RyPxqeKIrIt1J/mLrM8zrp01pjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset the eth PHY after resume in case the power was switched off
during suspend, this is required by some PHYs if the reset signal
is controlled by software.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>

---

 drivers/net/ethernet/freescale/fec_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1b1f7f2a6130..c29eddbb0155 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4086,6 +4086,7 @@ static int __maybe_unused fec_resume(struct device *dev)
 		ret = regulator_enable(fep->reg_phy);
 		if (ret)
 			return ret;
+		phy_reset_after_power_on(ndev->phydev);
 	}
 
 	rtnl_lock();
-- 
2.34.1

