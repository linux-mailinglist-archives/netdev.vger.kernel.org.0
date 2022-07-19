Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A260457AAAB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiGSXwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiGSXvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2930F4B49A;
        Tue, 19 Jul 2022 16:50:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TneW34d3a2486u7NtP44H2MYMxbEOUFLmZusGyToYP8LBINc/WWaF/kiHxLCxixT423ymHxzRWvRp6QB221yNMn3zVvxTrw7/TNA6OJKJNPuQ+pGZPbK8NNw7q1cKo7cIhU++lSAqo/lfI1F2HC/4+0eWZ59Hq6tDzJugi57KQIBsss90BPKe6P/AYypl5ZNMt/wki2E22VWwYXzXsg/+aqHs4eR6vFgNv0edjs/rFPPoG7E4sXaFoBU7dh8AqpecxtxvZOm0IuJS8roESrHaALYYxd6TJ8oDs/fHjpfjJ6J1052w8T4qKuT+ZtXOhaww2KflfXiPO7GAqtQzLkggQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sprp+V6GTFcU7jLzXBVWxu3favnUpiL20Gw7qI8FApo=;
 b=FvsprF6VcEoCHIqRuhVKzQtWU2+J340dFh1H1SIe85EwS4po7blf5/l+prmmoE3DAmD/KdpsGYBYYynZTEUS49vmviMFIlhEq2e4C8LiE+onrIDKDo6KrnR0nnxe5HMh2I77hPa67z85jvo7PS87qSQovzJ7NUir33Sqv/hN5VThG2G4F3FGh27u7M+A3lQpOJGmhCmoknaTVo85JxxpdfKCGpHsr39vw1KjL3+Fx6ctLRpzfF85C8EuDVy3sAB47RlPmr2O9n+8YeDpXkmlGf4EKhxcedxIXDtmjE23hz+3MBNMEC27u56IXR11egMuUCDB4wHAxy+gGs5OUvvziw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sprp+V6GTFcU7jLzXBVWxu3favnUpiL20Gw7qI8FApo=;
 b=k9QYGCSVF8CM+ViMy8UcOVqXSLZyJ5avgTYyXHNAhCIlBwH5WJwHOrO00XQdUbod3ZQ2l+0cu79icsMrwM/Hmgz26Vso62qoqR690SP3PIWSyvEYUxc3sf6nwOc4KmY9HcKKcQIzVeQ5XVAjdYmKxwtRHPwxG9buDJ6vSHqgGkEhIMOxNcoxG/kW1yGsz7DfZsVjCvFHRYMgwNe1Zb0gbkbuvl/NBtL5q1N3s7BZt5TegpycsqYhO9blKcL35CqZYcXGtsviESIm3JBAPz7TEWIMoxdD3DDpJj7rN0fqqGwIDqpBwkuKX4UCwzasXjgYBYYnAq3A2j6lBkpG1y2vCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 09/11] [RFC] net: phylink: Add support for CRS-based rate adaptation
Date:   Tue, 19 Jul 2022 19:49:59 -0400
Message-Id: <20220719235002.1944800-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532bfd38-3b5d-4ebe-0634-08da69e17a6e
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETCQAifnR6H/nmen9eS87gfvMEkg1fYHQyv/YvXszpm2u6neEEPod/VeAotw7s3wxzrmWKyGfhQwK/KcjfyPjFqJDjUfXtQ6gHTbz6gdGjvEKyHyTOPVci9RCYl0kYv+v4t4ciVxcsQWsO2QOkM492vkLoQ7hnbM8JWlPrZ+l5l1kmKOKIAgCU1uojzbkfOSa2V22SCMY6Za6yf5OiqX75WH1zAnM0cQZn7Fb64xSWnW3SZhbWSxP3nRuD3nKK+UVwYJHY9b9UwM8ZgBWJPJYSzKrhMoFrBKMwFtiRmRO4c8AbxngiCQQEqYRd93i6ZIkIC7BFfLfmWjbE4fVH1V1Ofrb5H8ForE4iOLiuIB8jKZ1PsejVSqVMXQaRzHzrerbs83EXHKogyjCrMlQxLXBQATJbBe9QXfa4KCxM8FjQDYgOpzhm33wPjHJngT8VKZGxMU6RyI1wvtKgodIdH2v4MT1nEU1WKbZJp02KbMpxapfeHPnvsjJfbCaeRkZCX8wJDT2+mMp5BrXd1FJpENBRUozcSwFnZDyRTUym0I/OosRk+27ihvbWQ9Xx/jyzH4MG9EaZu4+zcJbwoTArGP1HJ5fxw1CWn6i8bZCW9Q+cr7OIkCSCl8w07L9mfnk+RTu06TErD7Us5yvgQrFzZFL84Z1gtD4a2k0rYeSs04nBeqg+DhYJVni8ANsJvE4CTo0bLaQN0tG59xh3eORDV/tsa/dZWh8MKe/W+Nq19WjXx5XjijxNbcjs4MIGwnKjeNA+7/2OIF53sN60pf/sou7q/6AEDw/CDYVMYYspuSZ8E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(107886003)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WcDEQF14gUcJkhexos9EXWATQyD6uP3W2JHvb1bDJL8UHAZ+45BqYcF3R+es?=
 =?us-ascii?Q?hFKx9PibYoYf5Gv8ZZoytlpydsyp9vOLotBYhWjVqS959u/npMcrLsb5QUN8?=
 =?us-ascii?Q?9hbyShbWTRvhWZE0RRXwnWPomnY2isAVYLOrmwHDMNXzdgljPxp43Usmw+Qp?=
 =?us-ascii?Q?GrpbROXtn5NFbKD2fDa6OA4ZwrhKKz2NTcyn11T4znYZYSQVAVDvvBU/feVY?=
 =?us-ascii?Q?l8pTJLntw/nk/Pf8W6i4YGhRparpTjbimwIILqyvWCI1Cpew0btG+9iZLhG2?=
 =?us-ascii?Q?x/VGrNj6n6aYRgebjXdV4qQzWDKNpOWOks3PrYFNatjKR8+clk6ZLAKR/vuw?=
 =?us-ascii?Q?44c1kXXgTIbb+9g9a3GV3S4slx2hiAb1QEDO9IYmYH/IAfhGdZp/tEDEvbgv?=
 =?us-ascii?Q?UpblLLUMDQVKNybsXDhznF7KfRrsRENUjM/GlLFQhCd36I244RaAx2vniPEu?=
 =?us-ascii?Q?85qc1hXCorTclB+//Lo9h+HfnYPfxyerKJuuwf+zHjC7+rNGBowhnzIxP/R9?=
 =?us-ascii?Q?9lSy3LYYu/W64sDrVajsOK3BFMzN89Qe3Ud4ftoqR86tRgfa7gTT3Wumx0IV?=
 =?us-ascii?Q?WLOaNYEMCeTUHwfoVqq17pSzbcHE9g2O5v+hh5hEYTSrmfe4oyKvu7q2CY0n?=
 =?us-ascii?Q?qGYIjLnynbde3mdQkMiJRsEHpIW3eNHv+zimRrDodDBwNdXEmMgXRTz1dH5h?=
 =?us-ascii?Q?IltC0360qUjbFd+LchWZXbm0TjY+iQdzFY2Stcr1WlSh4wuZsXsdT/I3U9qo?=
 =?us-ascii?Q?6liiPCrlZzYoFSH4ttadBSM1tfIY1gE4Rn0NVaoW+b9NFa4k0OP9Cl6CW4pd?=
 =?us-ascii?Q?RfczJdXB6nyWGMrqSKCFDAj6K/nlxegEJ141Soz/hIE5DqdpsechjJ2oRGLx?=
 =?us-ascii?Q?yVlfUBOcRFLdqKzzpfpqCwtmNV5dZyHj2fbJ5kuWYM3S6T65fR0L/bkVCxRn?=
 =?us-ascii?Q?iE6C0TG69l1VrzoyBgjMxWlHfI1vxPp4PiI3IlgcgFJbOYCBRRtE6US8QLLU?=
 =?us-ascii?Q?WC9gRswW2XV0Ps146UGI1bX9hZVZ4WZaPvsOZDYszaVkYr10p+KaGCHgOCvR?=
 =?us-ascii?Q?PD+e5JZg15Ab/nx1kZiQYVR/fBE7HFzLy8kaYIhjOY1LUO5HStGsujqtJX+I?=
 =?us-ascii?Q?3K0mmhKDuMRPJ6QwTG5MRDjFvQLAjjPWz6IIZcvd1oPzoY5aOiJS07kQ45Yk?=
 =?us-ascii?Q?qUobFv6toQUcc1i3JVHG6/XgwJZNYpPS2TguXR1s+IcBj9n23s/VwnGK0Nx0?=
 =?us-ascii?Q?3Lp/fdsNI0bBElllkWGM6P5nDpAOpUJiao63tBarKxQE7M48I2/90IfU/mv8?=
 =?us-ascii?Q?xf9Dyf2COr65+N7rAugAKSFhD/areualykboWB8bxUlB3ZejL783C8/T54fQ?=
 =?us-ascii?Q?PuapvHM87kCYQKjJOt93d3WTg4Vn8DmbHOlozvqteW3NSjNgktRM5giSofqP?=
 =?us-ascii?Q?Yu0bVB2iKARPyCmOthgylA6D8+qM5kLgzOfYFf88uCoC6oyQozBvgY2zd824?=
 =?us-ascii?Q?mM40gyeZ+llfpxmfCqIwoJxkvTRSSfk0RjHuGFrgPE2SfBM1Fr0PL4CcwHmK?=
 =?us-ascii?Q?Y/FPlXm7dAjpAWxBsA0AsP5X6yMfw7wVaS/lfCAwjKU1m8IWgfwwn3NdOM8h?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532bfd38-3b5d-4ebe-0634-08da69e17a6e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:37.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndGhlla++iTaYPm9eQa4Pr1tbm/4bpg0cHZtg4zIP5Gj63a/R0PsnZqwuXHbztcf+9u1fNhbnNYELez9xEY5mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for CRS-based rate adaptation, such as the type used
for 10PASS-TS and 2BASE-TL. As these link modes are not supported by any
in-tree phy, this patch is marked as RFC. It serves chiefly to
illustrate the approach to adding support for another rate adaptation
type.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f61040c93f3c..75b4994d68c8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -553,9 +553,18 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 		adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
 		break;
 	}
-	case RATE_ADAPT_CRS:
-		/* TODO */
+	case RATE_ADAPT_CRS: {
+		/* The MAC must support half duplex at the interface speed */
+		if (state.speed == SPEED_1000) {
+			if (mac_capabilities & MAC_1000HD)
+				adapted_caps = MAC_100 | MAC_10;
+		} else if (state.speed == SPEED_1000) {
+			if (mac_capabilities & MAC_100HD)
+				adapted_caps = MAC_10;
+		}
+		adapted_caps &= mac_capabilities;
 		break;
+	}
 	case RATE_ADAPT_OPEN_LOOP:
 		/* TODO */
 		break;
-- 
2.35.1.1320.gc452695387.dirty

