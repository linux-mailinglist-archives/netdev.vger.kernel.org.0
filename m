Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE18618771
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiKCS2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCS2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:28:46 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2065.outbound.protection.outlook.com [40.107.103.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B0E63EB;
        Thu,  3 Nov 2022 11:28:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqrFqOLaSEQ0OIK6wVx+ElZZVFawBvCyvqUAjvTd6wbI1Xq/I0y+pRZDjY92KssmVi+WHZCug9oKSFI5Um7B3EWNWsnAYmJQEz2rF222OzVmz53u22c9DnmhFZpVwlO83I0cerIEaLo+e9ct+EiupoZrI9d7u9kvQ7AMRQ9+NXRDZLE4skfWeANgHeX9+1HQPz96vQqZIox92uPiWU2F2YaawsibNFXmqlyXSp7Q572opea6CIMouRfwOfuL2r1/ZAbuS9TwbrOmo9pU5p3hu+/R3z7+CpvztDoLbyx3zZJ08ecUOKMt4uHdltI9j0AlcW4ndqkP1lTKNwiNT8I6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4CYqLGHryYO83NW9akO+nbIKsX/zBftgQnOPt3Geac=;
 b=myCkFNq1xYlufsiv6tkaTtbjEX79gyJFMTtjfiop00ddLgz3ylkv3NZwyswN1t1zw1g/MINnFygIuNqo+d7Y7dfCnsFLHi5IJliLlgnhZbty6tg5BDJON/uHar+IFjbBPC3sTChpv7b5ouQmjQT5DnJ8qam4ShOShLjDfc41JNgwvM8cpIhDG5cs9tAQRL78SIAF3yji05SfDHcd0ov2irmyc93s1obFTLg1YitHiAsq4M7PvraW8aOnJVqSYp33XEtiXWM0WrUv0nL47HbqIbQxcLrfDg6AjBGUPKZjytOVDLBt9sKVXupXdSngVr4GiyZqFkVHnGsPNsIhBlsydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4CYqLGHryYO83NW9akO+nbIKsX/zBftgQnOPt3Geac=;
 b=JVdFW96RCI/fu0KNJ+1VZ4fAFj+/SLLDR0WWI22G5D/vNadrs8qvMCA+VbGH3E50KLfaXvfxRab4NP29no/0Kv7bohhxIYzqw3p3XWhoaYPDfjPI0rwQNbx9EOWyhh5zncOnxIA/jXD0z6HipV0n5DE9gp1p4yUVV4yrlrtEOfzYJlzAMOnsCoOzkIFDNF5/qOyxB3VizjlQoSnJ+sboy9mrPNSoe8pTKiDUgSVmpf9XP9A8CXePWVP0YMbBlI6Nwk/i4vfMa3OHwNpris4B93d9mrk4Xe++0pyWLFf9LAw7VpwD0af805vCZIgucnmZVisDbdQukNafYGeDHh9E8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM7PR03MB6369.eurprd03.prod.outlook.com (2603:10a6:20b:1b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 18:28:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 18:28:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] net: fman: Unregister ethernet device on removal
Date:   Thu,  3 Nov 2022 14:28:30 -0400
Message-Id: <20221103182831.2248833-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0433.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AM7PR03MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: c570bbd4-06e4-43da-04ad-08dabdc93b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSADTmO9aEiV8oxAAwJyhjEG3LhJBr8V79xX5NT1UgpJLvXWuef1wf8Xws5YhpkfdZ3WPPYskQ2xt7WCXrCfVDfHOmpE3Agivd40ZWs1uKmGZu9bCKn/R17QtEOidMfQgAloktloEnykXE+9vgY7V8thOoRzDULwQK9rz8pdC75iOqqvTgdqEE7+DsNp9vaPeTnyzss+jU6n9ZpU5YtcNMBOGmk7FCcWInipNjTZdE+SKbC1f3yhkq5NSnzTYFz864ghJq5tjBRzKZnupQc16fjZ2ExGed3DwlhjgNwoHtur1CySeblA8OtnOaymV1byVxaF67Ujkb3gnMJQz4fQ5+CrQzCUkjlil7YRiCPfSNuYXOfydMPQfN+JU4V9UIVX8lFRIPYNwxTVEUuQkWo3fsUiO//JrDf027U4tob8rZrmiS52SVbXXwqEA1H8F1o5cdeHEBfAK07+Jadpl3TWYre+n45sxMGaoRyJOXtSIehaYoQ38iMhwp7v1rBLkGzRtM8Gm1uqJNS2cxBzCdPX6Flcmnyaf1wlKl8dbE4seehmFXKC68Qw22FuIYHuv+Afts9tsVrkKWFWuH1+X5mXFItvM4TL8/wUSCUFXdE2aA1bAYtUZ/q4Geq5Zw6PLw58HQbuy+yV9VjTyJvSlk6b5kXoI3iDPM7iN96kH5EYR7Laewin0YYl2SpX+/eBFqtc7PBWeA/wukpYcBIdaQCYjpLeOGUGxYh0F6BQvDXjooBQgrVyu/L+Ge3jQFj8k9N4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(376002)(136003)(346002)(451199015)(38100700002)(52116002)(38350700002)(2616005)(6506007)(107886003)(6666004)(1076003)(186003)(2906002)(41300700001)(86362001)(6486002)(44832011)(478600001)(26005)(6512007)(110136005)(54906003)(8936002)(66946007)(66476007)(4326008)(66556008)(83380400001)(5660300002)(36756003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c3J8RkD5zbB+nbr0T+BGFIY49T32peskSA28Edg7YhY+naw0FghXj5rmRWks?=
 =?us-ascii?Q?KobxrO7EVCrL32Krjgb/EIbGnCrwvcJ2ywKmZZthG8nov9YcI+jQMINinmLg?=
 =?us-ascii?Q?ObcR0O8pRBiUJqNvfUB/9r8gbUks6DmNog5dXv5DggWmYL/oX21IRHwFiw9C?=
 =?us-ascii?Q?YGs5dHgSXeOzhKrJwDHx4LByr4VXj10wWDhwpscVKGpFfdiPRmKWdv+q62oV?=
 =?us-ascii?Q?SKMNOrXAUSW+vSuJaZUCmVS/otWeeZ91t8VaADHchEI/ujAdf8s48rOWWbpX?=
 =?us-ascii?Q?lZZ2DuITbTcuFxv6YOjbzErgS+m5qRazTh4DcETjf76LnlRlrT7+vDr5W57C?=
 =?us-ascii?Q?0Uy9bcED/MI5u+OsEX5CtunZyjCGAFnaSCGWcS6qGwk4Ax5QbdnJc1VdP51z?=
 =?us-ascii?Q?Z2EO81JtPFPQ2aqbcJafnISWJIyAnka8kedlHEDIbGSDaIHezysdoqPw3JIB?=
 =?us-ascii?Q?1kgw1jZ+NwqnbE1jQipXsoA7VlY87eBi+9p7TLOdQbdP9WVzFohSqBvTYY+Q?=
 =?us-ascii?Q?ytmeBneCpU01Re2JEeieccWhG/9oRINMRFyi5h8sx42pHiyEy4bZ+GVxvqDl?=
 =?us-ascii?Q?8Eu+Brs1/1MM77AbLvd+tM2BkEQKD/P633iYmpfMcxkpqMSZwBo7NbMAXVtG?=
 =?us-ascii?Q?cNhN5CYVdxzrXPGjWh965m9TCAyuljh6qSyxUpk7jEuJHk1UZEwq5WleUslt?=
 =?us-ascii?Q?NZNZBcVoIlBYLPoUJFgGa6ZUK9EU+E0atWKDg29UYYUr5MUdHSIZa9VKvWGI?=
 =?us-ascii?Q?sAKLCQgjxjYqmy66cfqBRg+8o3U5y6/6N543Dx/VLWPOSoeQCE48ErrXdhwJ?=
 =?us-ascii?Q?Zv7YK2lu8ze6I+OziMIYfe9elyS4HZYDFssOhW8flhCbmCxDFTnWiLGSBJ2t?=
 =?us-ascii?Q?OM+3ZZhpkaiq9H/qwxNmtHyhNOg1ThjFpyLrF1LtGy4PWljb+WXbUako43uq?=
 =?us-ascii?Q?bDZOPxnOhNgyE/7N4J6yBgkP+ZIsRhqcNOnH9jKUrluiJbBKKlgM2bFDJzzs?=
 =?us-ascii?Q?YsmLbek0NUiNg0y/pICNyDxN4i7KLw8W6hvni9WXPM9fi5XZeENWOzOfIBCu?=
 =?us-ascii?Q?cZDBo8uN58Xdpn/pBiulwhd9YnR9XVS7L3wy/F3be/ytJmPN3rovWdnmihIi?=
 =?us-ascii?Q?Qv0TIJG80Zzao7fdzWcevyJpd0EhUTdt04AFV27JjKiq2A4N1fkVF+S89iNq?=
 =?us-ascii?Q?E3hmX7rMPFpjy+vd1llolWDCU+ICpSMmHn4WYbcsyyye+NVv0KwLEbjS4qRd?=
 =?us-ascii?Q?PYr/kwpQgd3NoBDkyVIlRQAiLIyOmtmfEOhso/tl4N8dVvosvQzHGjuf9eM3?=
 =?us-ascii?Q?esqsqS7Kk4OtlH3ZsVhL4/wvmHBUcapeCmmBVHoxiDeqMcq+ty0dpmYbIZhM?=
 =?us-ascii?Q?VEqLOVOHRo0gY3jhmiqoZPo4T84nkj+bzwwNooEw6R1BYtae8IGIYNG3JbEJ?=
 =?us-ascii?Q?82liv5oKhlE43W3V1bgig6bxiJHz3JeqGsSW9duHiwid02iIa9opWN0xBWcR?=
 =?us-ascii?Q?4s06X+nEb5nMAOx33WN41CWC+P68XUINCBqpunWK/d9Q/hSLHeslOK/tmADJ?=
 =?us-ascii?Q?NoYmzQGsoE0Q9g6BUItpd+0NJ2F0j6heHsdFgFkua9LwiFyHRSmD/5Z5Pj0Q?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c570bbd4-06e4-43da-04ad-08dabdc93b98
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 18:28:41.3022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hR/2DKNpE0cg08PpoheuA/mLLm469pQm4/BJd9DPUQpei6AV1rDyw3DXQrpbzJoRPNoG7m17FguRF9lKwQfbCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6369
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the mac device gets removed, it leaves behind the ethernet device.
This will result in a segfault next time the ethernet device accesses
mac_dev. Remove the ethernet device when we get removed to prevent
this. This is not completely reversible, since some resources aren't
cleaned up properly, but that can be addressed later.

Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
So... why *do* we have a separate device for the ethernet interface?
Can't the mac device just register the netdev itself?

 drivers/net/ethernet/freescale/fman/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 65df308bad97..13e67f2864be 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -487,12 +487,21 @@ static int mac_probe(struct platform_device *_of_dev)
 	return err;
 }
 
+static int mac_remove(struct platform_device *pdev)
+{
+	struct mac_device *mac_dev = platform_get_drvdata(pdev);
+
+	platform_device_unregister(mac_dev->priv->eth_dev);
+	return 0;
+}
+
 static struct platform_driver mac_driver = {
 	.driver = {
 		.name		= KBUILD_MODNAME,
 		.of_match_table	= mac_match,
 	},
 	.probe		= mac_probe,
+	.remove		= mac_remove,
 };
 
 builtin_platform_driver(mac_driver);
-- 
2.35.1.1320.gc452695387.dirty

