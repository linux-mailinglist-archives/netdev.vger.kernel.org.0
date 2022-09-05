Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D985AD801
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbiIERCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiIERCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:02:05 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50056.outbound.protection.outlook.com [40.107.5.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87F5D110;
        Mon,  5 Sep 2022 10:02:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEI+eLOT80EC0zv+36V3PSP0VfTDF4Wo0/rsXmO51lI6FIeDybySUx0vy7PIYylJ/Pij3Y+5cUstI8SHPH/+P4MAZicgK4o0zFAyWt+dyexEvsBwMG1JoTTeFZYzlR8u2iwcYC3YEbThZjNW80KKp+eqXBK3yNyAzdiKDHNDaCRQWHXjxV/HSo1XpVvcd0U/t3flDF1z/YOrVD5kzc9zqVz6J/hcUScmWyNdcCn3FQGwJgpjM6P6CNes4J6PJvKqoYSE+rb7ahruvicvCdHKZSekLlZRAkQHTVNFkKHHDgQ+FB8Mi3AIQ2AXthvntOmH8wzHLdT1LE86dEVzxxPmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3eM3qTwcNQni5jVHUpxGSa7RsQkFVsitIb+pjjX+CI=;
 b=Va9VGY5cDM7rDYLMs172ExFYeVKIbJwR/F9SODy6nPgYDyEcpSVAcJRK9oxW8r0jXyiAjjxEw1SJDH+eH0K0G46sBjlYrbVjrZHh5Jgw3LoODT6Ak1X6U5NFEP6jtBu9hnLHNO4dNDfd37SGXToe4DxyYgjVubHcPY0QPW2lNYpUsRNydLzSjNn78g/orFFv5v2rJQWh5kDEIwe5sOM9Wr4KHu6msm3HcMhUSEEYgicYms2I/yhrdL+U13/P/7H9S/tyx83eXkHYhCZmqtCBBKu0TW84sIhm1NHFmm8WoXsifDL90+GyCeEu8kWMZC7owF57BZ0WIQYvPAYvTtpjjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3eM3qTwcNQni5jVHUpxGSa7RsQkFVsitIb+pjjX+CI=;
 b=i7MpOJgl7Y2H59/8TedBvyQwKUee+toYM43U41WwQkXxyjwrOwmR2buxLW6mpIyXiijJI1GiPIbHvnRz5BizCdi+ovShag+1xWHKjhmJHktU8bj6wj/Y5XWJxHzYAAGwc6/kgzqLDPMygcxztRK43GUBEw4JUi0v84ySOX85k38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3897.eurprd04.prod.outlook.com (2603:10a6:8:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 17:02:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 17:02:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 3/3] net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set
Date:   Mon,  5 Sep 2022 20:01:25 +0300
Message-Id: <20220905170125.1269498-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bb456c0-d0e4-4a85-0ee6-08da8f605928
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fu/N0bIIqEQteBjxrV2g4Ja5ALpBImAt92QhXRiwe3X2ATD7evwdVBixXg1LqdfDxJJGM7D6gfQDv1r6mvdeXo9QHnwgrTmqEIQEg95k4iP4AKnZd0z4j9HHQ9f+LaEK11f+8yoj7BgkxeztnOsoAuJGcER5YI6vIbFdgen+AB970AJ6YEIg8f9Nt3ugYbfk/GTIGguyv5srWyMUvE8lncQJmWkChVfmv2i7ScFbrsfXIx/HTglk7eRKm+Ea6/KHZGP0hx2uHiHyo9dMb7HW6vftV1BNv4XNawOPwfGS8aBASKTPHnEb2B6oh2Aqp2Lxflr7uPHF5UVtuiWULvMVnjtkGKZHK5g1l+QUM5hUMxO0DO3PtuQTOFBRPtn4M3kmre+/XcN6EYglHMCHGrW84cIPZkbWdviK6RJs0lDx6pj0AULo9xgelCsUzh56PtXbdvt54JODvZHDxJ5bUMHaYqoOChCBYbmXnwt1CX003SfARIbXXUvLLrbuMAzPm+DAi0EDztIGu4vKaHMtX4duLyLMI0DWSVBMkCR6SuJ9Ul3uy1nSiwg3iLkyUVTI3Mvp5p3fCUOqi011ENRl7aPh5bUaZcLPzch0klORgUKcmCI932Jic8cQvX9QDVJsVBZ3MVUspD4bUdpGsYw2aXsGX7/zcGjH5NrunuxKJXrT0MFdkHoxMYsdYmNXXavOUiLLYG9aZ1jTrDlKSM7DkjePcbm9dEJPwsRMjUiNVJVN5Cbl7pBZuvYsLvFeajBPnw+jHNyhIJW0tzQ1RwrLjhsp/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(6666004)(8676002)(36756003)(4326008)(2906002)(8936002)(66476007)(5660300002)(7416002)(66946007)(66556008)(83380400001)(86362001)(54906003)(316002)(6916009)(44832011)(2616005)(478600001)(41300700001)(6506007)(6486002)(38100700002)(26005)(6512007)(38350700002)(1076003)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rY2bWPmhfZYSr1jhgth851XgVS6c9+2FHcPDzYpzh+pYuIrjGapL+j+hK1Es?=
 =?us-ascii?Q?SfHGMERiRq+JsHjTsL33oMu52BrfUQ3qRQFVR9/tb81N05I2xOHkey10hNGJ?=
 =?us-ascii?Q?P5FxY6iXm1Xe8OB4TJiI0/DMYfpp88jmQu4B/d90DVKUscIHCerjyrbyvcEJ?=
 =?us-ascii?Q?q2XTj4kfm3uwm96R8bqXbVtszfP5B+fiU35h+k34wOWsHQMaw4feSL00fvTz?=
 =?us-ascii?Q?lz2Gs7Bj4mRbJ8ML09bExGzAuwrV3UxH2a7H5nA4U6mV70zoObWrDEgZdOmG?=
 =?us-ascii?Q?lLxIWy2XoJcCIEtA+4kVyJj+19RM9VS61jhTZOZo26cxP83L4G4K5K15gBzw?=
 =?us-ascii?Q?mVQaFJCH4e7h/lX4By8tCZgSM4k3qPLmBCbN6HEn/3AG9UOksPSOUvtKOCG2?=
 =?us-ascii?Q?ic+8Zjp2CdSBK97+ApyZ9ARB20Dp/a7STHLxH78mVTY5tjoPwv0tJxd5qFEw?=
 =?us-ascii?Q?tWnJjQP3RG/3fZ/VRfszG/YHcGIqh4Z77fgMeEqE0jTyB0CGXNkC252B3X+w?=
 =?us-ascii?Q?AbDdoyApT0hBd9n4zqNRUuq12W1CwYFWt7gIvJqYTQIWctcWTSINflE74zuG?=
 =?us-ascii?Q?5arvvvMChmWDjHD+IDd/kSlUbuyvhPUe6IAn84M5iHlrzGF1oR4vM4heBbI7?=
 =?us-ascii?Q?+s6kCymTHZy8UwO9Zt1+5kgzcvpBdeqsbCNLACowLnmtJdtEI7FnwzLM8Tf1?=
 =?us-ascii?Q?COurbrqyTElW6YTEcqWFM4S4DnbJh1wkTGovIhgxQdbsVNz7CQ25z0ihy7Xz?=
 =?us-ascii?Q?1bwphxaYiyCnIsl2fOIjW8Kc0flZEat2Om7JuNRr2QRo6feMZ4fLv+arbig7?=
 =?us-ascii?Q?D8pxZwV/aE/b5IxEVpmmE+Rix7yhDVERw8llvIG/PuLb540llSs8Tz6ZChUp?=
 =?us-ascii?Q?vZUG+fKgYUugu+mcGTPp5+XcBFl0EGgDK/nS5+4tnFLCfd062Pq0RV9+oQ/n?=
 =?us-ascii?Q?gALefQkMeoQKQxD4SsYdbaaHLysHdzq4r5w2nfamk5cfNizmSScjIfefKuu/?=
 =?us-ascii?Q?3UbUIJ2JhomgU1EmRKU2UYgs7CFXsFtKvijRSx56LhDldFOPrYOJVj4pVZEd?=
 =?us-ascii?Q?ziJY+C3ifxqd0fQs6PprggtR212AkSfOfotqI8a6v8Qa9PhoAE8EIcDzWNa+?=
 =?us-ascii?Q?JIWBvL3T6zf0wc41ICPS767GLmEzdS+xHWvdH1iuhPY5pC5jydrqd5oATcPr?=
 =?us-ascii?Q?Qb6EwhuFI5YN/T7lQx3s7O5inGAUjro0QHQqz13MA2xfmC+a5WO8NqegSexH?=
 =?us-ascii?Q?hnjuzaCWifNFcEWSZ7q4qN18qwrUA+PDGefiv8piQ22EJ3cPv3WhZ10RxQoZ?=
 =?us-ascii?Q?KEz3iNLm3URMRPjufHAQ7HwPSFNq0tPe1em4yU91V9Mk7xCrBqfVMBGMkysU?=
 =?us-ascii?Q?ETMLjQXRf0DKuNqM0Gysz5ldVwourBm/aJx3hzNDQTf214BIWlD2Vv9rTC9w?=
 =?us-ascii?Q?AZSC+wCDMmf7qB9aQwLRpTFmVE/WEGpJg8rH+ugSwNwcWEEDrpp42TeDABPz?=
 =?us-ascii?Q?7/IaAJJuYwxeTweTlQqXh4oJ7IocTE5fzTS/vndEMVpfb+Mi/5PjKXn+niwi?=
 =?us-ascii?Q?WydiylLGo/OIST6awH5lYln9lHCvZTi0k1RXlzXPSQKBTbIoaLC8zpkt4dxF?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb456c0-d0e4-4a85-0ee6-08da8f605928
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 17:02:00.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkSgdoYtLKbMnzQhMumWFPWeYRObRev4KCGKrE53JP9aNhVvBzXDuHLc5Th7TuSaZjMJpyFLgEJsPdsubTXBLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read-modify-write of QSYS_TAG_CONFIG from vsc9959_sched_speed_set()
runs unlocked with respect to the other functions that access it, which
are vsc9959_tas_guard_bands_update(), vsc9959_qos_port_tas_set() and
vsc9959_tas_clock_adjust(). All the others are under ocelot->tas_lock,
so move the vsc9959_sched_speed_set() access under that lock as well, to
resolve the concurrency.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ad7c795d6612..f8f19a85744c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1759,13 +1759,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		break;
 	}
 
+	mutex_lock(&ocelot->tas_lock);
+
 	ocelot_rmw_rix(ocelot,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
 
-	mutex_lock(&ocelot->tas_lock);
-
 	if (ocelot_port->taprio)
 		vsc9959_tas_guard_bands_update(ocelot, port);
 
-- 
2.34.1

