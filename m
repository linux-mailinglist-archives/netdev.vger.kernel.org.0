Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C342B5AF0C6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiIFQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234407AbiIFQkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:46 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750F86C32;
        Tue,  6 Sep 2022 09:19:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZidSmAHGIcOvST8aIPSSshZ0Yg7DR85LUbn/EBoicjnCVRIBqLxlEJfiMCr/ld+VxHbv7POpLKYbWhxEWRbTmKPIt98RWLPo6k1AtrRp6SLf+aTIwiDcO4WgrjnTsDVmSj90Q2d/b5g/2fEpspmadd8PzePxsr7EeQj0mqlcPVfLIT3hElJaikGhzcs6xKh+kzEwb+3YCuJ0snrUkgv/9JtUvJOduaIOdDOOQpRr4sWUWMfxkglzuZ3/vbFwjgrP0wYsNxIfLN0MCXmVDyl9eJsL/J2Os+dYr2MYchXK+Shb63rlzEEqS8r8lagH9USDn9tnzMT5+AhHGsdyvyI/7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxDmg6qikYu4QbaUo/BH/zYEJpPBspYcp6K1wav/omI=;
 b=dlObrz2XuCxaFckno9odiaGvLShuBscu54uI13n/iRuKsFdBCSG+40+xHmTx6jo0LYJn+C2V4CoZgUQ4XVl/uHxm4VaESh2K0wJY9mZbagoB/cQnXuxtZthR91a9MQLGCTe1XrjYZnLladUHHyYy9PKPVo48sQ3LyXfhEdOqEpjEDWWCLSgI2qQtT4N1ea2aOhrwDsIYei0yadxCsDxeYnl2h3f26OJsqF/u/6LstcaZset0tWFdb9VLNkklVSnYJ7uOncEni/MWOeVt5R44kgoTfATFwCfsZ8nFvDtbr2bwWHNMcI+v6vW0f38QhoUP9oZ5dNjzEomBPOPpUs8kSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxDmg6qikYu4QbaUo/BH/zYEJpPBspYcp6K1wav/omI=;
 b=JjndIRot23LKS9zpLcnRs2niL7WM0Xe6dUV/0IuifZ32quK6Er7g6lS/Z2BiEja3Tg9TtaStOXo1JSlQZxQD0yFno1aEPZBtxGyUO9aNIakwv+LubE2GYjSO0O6jSxsGQI8hA4gRWYnLRtANz4hIRvndFbU8fl33UvBQsl2jQcTE1FjGGUxiXZ9AxHVjFCoN2VQXhJvZrQMfyIuZUjHwjqjhN+gPXXUylj7HJ6BnRE5VADSDtei9SU5nyUqb0RD1Wod9MoRfpNYEeHB0x5SR3YaBrUKB289m9pt9gXDM5b5+pFMuT93jixp6UDU/CEHfj7dApJsiV1B19ls3fK3j6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2254.eurprd03.prod.outlook.com (2603:10a6:800:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:19:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
Date:   Tue,  6 Sep 2022 12:18:45 -0400
Message-Id: <20220906161852.1538270-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c39cd6-55db-4faf-3db3-08da902384da
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2254:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5yRGPrPkDb8RSggs31Mvnrb+830AdDNSo9qpoY978n4rVN5kvnxcHjLnqN7bu1QndinEs+6KVf5hTwmSe9SEP0H4IzAZaLo76fB38yjXH0nDn8mfSXaW/bYDbWm8gh6MSGdj+7JNbtq0yF0sPlEoEawIb3DTKjnHRPL6zy7vUQoAZquW4OuRhYnYStwiXTCUcVlYpmhnr5z802xLOUWZmF6Ur+Eux5JpfXwpaTCTa0R9dDENIsPkq4/kplfrtbgugaBSlxHqPa4Kvk1dchWrganpNaP3cTEb5FYtq1Ia2PwXzM3k3GEJyJ6FpPoOf5KZ5ZV/U4Fsmy9ZlXzpTvAFZTS4IBkpuCWlU7Vu2lo/pTu9Ai9Ixz3XLq+Wrz8JnGRdnjxkG3q0oE+H/YiyaLaMPui0dxQtDhjs+vvK116bfiPmTB1CYcrYcNYE/kputupyl01VUIikFkYfbzfaYjyOqKEdlIS2tZyIF8PwXgICl7Iekb73tu5NYmCWcwMl/estVHBdTLaC7OXilFmyoVCDUZEQP+pYTcoLR6QhncqRxYxatKkYr/gg9SQKn8aI8iK6Ujpc3x98u3YjJ7PiEj+hZYCKYrJiLtM5LmMsttZF2bhYtr5JE+aheZw9G48k3fLClR23MhjqyadcNUiElvcJfPeO/IpYAncKpeU8XHKB6wLAuyXbKrV3i+KZ5FE/M/deGmARkeeN/EtNpcOy99aP110Yeh6upcdb6GgRfr+QJ7PDhDYL2Fu34xvUSkCkrrx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(136003)(39850400004)(38100700002)(54906003)(38350700002)(110136005)(83380400001)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(44832011)(7416002)(8936002)(6506007)(5660300002)(2616005)(1076003)(52116002)(186003)(478600001)(41300700001)(6666004)(86362001)(6512007)(26005)(6486002)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EngBo/28MUTdAAOOVr7cMfWvg9ZF2ZgMGL5FJ7yqjRsPDfBkZywgeb+VYJwj?=
 =?us-ascii?Q?kQq8krqhNonnPs5Xb4fbpv04jpb/E3rQKiqKmXAzAGnlkurMttHSdA9+Jckq?=
 =?us-ascii?Q?dzbsX6irfZ2efPG3y7zNa+5LgCsZsGpkl2wQcaIQ9RGh1TX0Fa78IqtZljPb?=
 =?us-ascii?Q?DvXF9rMcc5uVIQOGImSp2sIz+M8WIRkPrn0Iiq5EwDNRWG10HHa40DkEwuQu?=
 =?us-ascii?Q?jXPgDdXBJ8X7gxvBmWawXELlAEXk8bvZDEapYiZ1aGMhiuA6ql+eHUVwWAzd?=
 =?us-ascii?Q?hk72xj9nMfC+8PJz/UZyUlya189/qZsqFYitbeLnU32MXCOg8zQMzJrgBtSY?=
 =?us-ascii?Q?F6QI3qmN6Vld7xyMb8cjTBwgqCfKyi2bZ3F+XmLkKnWjZ5qasDFKUzHJWs+e?=
 =?us-ascii?Q?E0HiHhi7+76Z/X8HFXqMQnRrJtN03lJzaRP8GBSD1xtLe9RzA6ICqDP3qo7O?=
 =?us-ascii?Q?ahMeDOT16UtxdxpChNCtZqXBoTzzVqTtJVKtE1X2gj57EgpJABUCdcIRnc/f?=
 =?us-ascii?Q?pEtSi/dIu6Ui/eEHdxA1yISbMpESrQB8umwzYxW68ClP91lh05lrygmyYcJG?=
 =?us-ascii?Q?ZBNMv7AXhfo0ssvgJQbBeI+eNXZd/NOA+VFBVrPd5cp+a/6l5zSGfZB8ECH7?=
 =?us-ascii?Q?TI0fGnWMGL1krDtrSBczvhPXc1M5hPOrHd9wEvmGxMQVL2h+n+dJKF8qDQuz?=
 =?us-ascii?Q?+em2KTwXROvQ6O4I9KhiX5nju1QNkCM6Kacq/vi0/cFwgUJHUx2heBE/tzGN?=
 =?us-ascii?Q?CJfjP4vC4lz9Ky5q+eMVKawhp6x6EVtYJel60xNKRAUxdHXR18zo1bIlYb4Z?=
 =?us-ascii?Q?uaa6T/ZjXaVQMzcyMIWWkbMnRYYB3CvCANpITf64Wr5/mTv2toFYZS84Zcsx?=
 =?us-ascii?Q?tNU9O3VZ0xB4DnGNTIg64yw+EduBuDzIb/m7DUE4mDLAZEp9U/yWQXAPO61G?=
 =?us-ascii?Q?88x2UWBNGlSPq7HmTRjO0QSQp1EnoFVEfB099Rucx2st7RBU2UdNcix3oa3F?=
 =?us-ascii?Q?pggUoy5ZVvhuBwV7QDjnTM9n2SM+buzEnEO1HGwQBJ8FpfDGtlfUhITjhT3f?=
 =?us-ascii?Q?DLX0hQBOOpNXI3rfOJDEZcegIkEI7MrQhPtiyo0LyviGD1X05icT4COSL47G?=
 =?us-ascii?Q?LfCdZC7mdbh3Aq3j4bEDnv7kCechipnGbZhLSPUU4CybtemJiwmvB7OAjlAv?=
 =?us-ascii?Q?hNCIWQdz+/XSRcmNbd2N1LGKSJ894F2rt/JkLp9S8Yf6OFOnqmtYCRT1nUa1?=
 =?us-ascii?Q?8aPuo0mwporqSbV+A4cIFctcSifH00C0H0htezeCLwC2gnp29BVD2OoarSRM?=
 =?us-ascii?Q?hxWu8lQUqxloVdb+u0BSFYsB8aM6QdU7JVEKtQmQ0GkakXVsXBzRBXa9v2GS?=
 =?us-ascii?Q?Ue7WL8BBC3pM7Onsm+4nwoOlowTfK7j4GHw7mLyh0d2doco3DIlsn5bBAO9M?=
 =?us-ascii?Q?n0NG4iSj8rIv1kDqUvpHP9gWJ/Vz6r3dWiWob8aF+l+eygCEdmt2O/wJkad4?=
 =?us-ascii?Q?23N7oqb5gWrOkjQFqn9mLxVaG+/MKT5ZdCJ5eh1loxRGWrg67Syv9UapEUl7?=
 =?us-ascii?Q?vfM09cFNhYyrQexfC5371bEfLh7c2zfteGR3yvmZgSPsbQc5sHsTm8Jw7IfG?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c39cd6-55db-4faf-3db3-08da902384da
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:05.4746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkEX/vPeBhYiW55bWTITPTORYSacvbucGAPJWkkgl19sSHMq4oamIfJbvd5UNAtifqplkuYfV0nrND8D5/7vGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This documents the possible MLO_PAUSE_* settings which can result from
different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
direct consequence of IEEE 802.3 Table 28B-2.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- New

 include/linux/phylink.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..a431a0b0d217 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,22 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
+	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE 802.3
+	 * Annex 28B for more information.
+	 *
+	 * The following table lists the values of MLO_PAUSE_* (aside from
+	 * MLO_PAUSE_AN) which might be requested depending on the results of
+	 * autonegotiation or user configuration:
+	 *
+	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
+	 * ============= ============== ==============================
+	 *             0              0 MLO_PAUSE_NONE
+	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
+	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
+	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
+	 *                              MLO_PAUSE_RX
+	 */
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
 	MAC_10HD	= BIT(2),
-- 
2.35.1.1320.gc452695387.dirty

