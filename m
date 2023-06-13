Return-Path: <netdev+bounces-10380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A03072E32E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4A60281210
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FD88827;
	Tue, 13 Jun 2023 12:39:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E80522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:39:12 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2127.outbound.protection.outlook.com [40.107.255.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4144E7A;
	Tue, 13 Jun 2023 05:39:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih6/4OUrW7uUyNKAqwMBAnAxQRwowt19DRSGBc65EQ1Ye9F2TlQfe23DtPsHJ1PaXvFk7O4RdWAsiU77w7/JYmSmjU73yABd+ZaeBETMDrH9TRoCPRUK9I+fNM35he1bJrUdJO7Ved0p3OzFUMMOtmbBJZGtyTA1Ms9PS+yveQAxWJiqWMVEIGjawe4pIUv2DHtdUiyEmBpEHm9V1T2xgWYgObwcdEDTA0uBVEp/57jZTogkGdMaRkrjHDA6IXvGQDP2dOB76iB8KhssqFc6YjEePFoVaSMGLjnJtdaFh9gbXL042Rvuc3PanOqBrsKVl+1aX69NrI7ODd0zC6kxbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef5eaAQ0bL992w0uALttC5XIlVGW112WdbWQwd+w7JE=;
 b=mixsIARvnVtXayQPviva586nsnF0tHbHzD6HjuNtjMIhhNZgxeuvAAXcohIVueXppswcufxwQBSBWI/OmmlZlEi8Qv6BQWYg2gn+J+ila2UetOPE8kHJerYM2CEKMvmobyDzkHlOE5qjvECzkIjxTH78vKNyHtPzeaY9cOXVe98SLg0H9Ri9yExts5unCyGdYYc/x1ek+FH562FbWh7dRrZaUS38go3eX6LPs7sQ55cf6No/SL2FNmR7sSEnw5vv7Z2N6r3le9ZE4MravLwW3x7xnpx872eKVkLZbMz32iQ4JNuCww1ZQDxc8jsGsjDNNdunnIF/J77MnfKBYHwfHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef5eaAQ0bL992w0uALttC5XIlVGW112WdbWQwd+w7JE=;
 b=FEzkHCNyM1WEJalojMjq0qbUXILEC/06PIrE6oYWxh/ttfohlg2qoLAAw0y2+Epc40nihu967AC2A2xHHNlbBQJMb1I2TkpL45ZITklFZ4LqcEIafJk6AOe1I4OpWOkGC4OjOF/Hkp/B4z+AEhXUUeVX6sL9I61sbpRcmYAWMYmuErC3Gi2f7ONEFn9WhpN+7ZsMsRO1S4ZhRfCIXPINp0KTS0bO4ajTK7aBZB37VNb7olWva7ZVgo7Zaehu4m/GY2LqwSGMvbbuEQgkdhz6j8/3k62FRY6U8Zka5hn36M60Lioba93bIcKlxxpSLxZZpP5VCXU7+1cboy8upZwocg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 KL1PR06MB6519.apcprd06.prod.outlook.com (2603:1096:820:f3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.47; Tue, 13 Jun 2023 12:39:01 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 12:39:01 +0000
From: Wang Ming <machel@vivo.com>
To: Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Wang Ming <machel@vivo.com>
Subject: [PATCH] drivers/thunder:improve-warning-message-in-device_for_each_child_node()
Date: Tue, 13 Jun 2023 20:38:15 +0800
Message-Id: <20230613123826.558-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYXPR01CA0054.jpnprd01.prod.outlook.com
 (2603:1096:403:a::24) To SG2PR06MB3743.apcprd06.prod.outlook.com
 (2603:1096:4:d0::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3743:EE_|KL1PR06MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a3c934-9d02-4571-31a2-08db6c0b2a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WSaXd3zWpemHm0rzwWHvbSHK90zROEjZM3u3eXcX/svbsB+eEHkplkLDDr9dOuY+w0OfoNMPfgPW+Tw15YGzVJx1XO5ryc+3LqXRdDI8ar3VKg6gaNbV9FzFq0FjzMyRYszfvYVrEMLMJUxsQ1wwMw+KSgSHi2Dgn5jvCHur/zHrgt3BkKRSHPvxdAPrpBy3DO5ae0WHBZAuHd5XUFHnEoLyHkEzIyOCINjJo/l1IOcRSppoe7psbUkA5tnmCQxn3ypCStPpDnnqAFkmGW/PNgdPrlofjHtCkiVlhWZMb6uhaCDqOEw/g0HWVN3i+rqPabutMmuDh/9AIeeh/LvknllrMWpOjxyvV05YMw6ZXItXgzJW59w7XcZqvoF68VrzsWxRVcgAr3FUoILln/M4HQ1tUgTaHyY97FKXt2JFbUeKcW8M4YR7vO9qQ1+OIFPqsL7GFbXZBwEioei4rwz7OsQecd/15qVTxtYmsUFelWdvnksVtXBp3XNYlml/Z0K0AfqdGH6qmeL/4FBtEgQhyodRuf8fn9Pl0cvptXUoCf1jb2T19vIFZXXxnTQeUY/hPKWKeZgngnRbzSfy+jHyAx+mro1JpgqR+8QHBhNy4mF87K3Aqq/FC3zhoAO+3aQJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(36756003)(86362001)(2906002)(15650500001)(6666004)(6486002)(52116002)(186003)(83380400001)(6512007)(6506007)(1076003)(26005)(107886003)(110136005)(66946007)(66556008)(66476007)(316002)(2616005)(38100700002)(38350700002)(4326008)(478600001)(8676002)(5660300002)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EL4h32xWp+Rbm6LIpdBs4RFv2hEYXU0Ikajd+6czd0H5D8WpOkoHxdPriojY?=
 =?us-ascii?Q?enOUvxJyMmi3s5cwRQcCznH91SOS14GSi4Qj/ttjW4d9lbOJmsBO5woYB6bD?=
 =?us-ascii?Q?HDNPynfhUnIMTCbmGFpRCOewOiLTKfVfm1SNIMqsdBLkWCFUpTblEZSsOvgK?=
 =?us-ascii?Q?FiOVyqfiy4NrE22NO/rJPSi+kLu+2n4wB49zr1Z3SpuHEP0AuTrw25yx1Bsp?=
 =?us-ascii?Q?G1q2MccJBZKvGEcBv35m040sBvJa5c1UJVpWUlq978Bszyv9pRtk/Axu18uA?=
 =?us-ascii?Q?HImyEsQuo4bk59ydIoMKog5MTFrRwwApqoodvlK4OPmiCpLEV18zeS1LY4SI?=
 =?us-ascii?Q?A9qu4WumfOnS798W9gIk/4OdHPukugeRFxVUn15/UkWlC8jsAEiJaPfx7Mm9?=
 =?us-ascii?Q?UJEsU3Tmop5PUS5vEwFFJWKDv70+TWSP4hXt8rmpRn1rqoblJQndA7/KG2Mx?=
 =?us-ascii?Q?2m8xwLDXm63AlgqKVfE3TFNICTBe/P9hpggFaJOkTfrA/Q0statyojxI7UR0?=
 =?us-ascii?Q?g6MUtgDiGljVaGO5dxvB9GClHVzGZ24rPGwM3CHaboRSstNqSxaR9OORj80y?=
 =?us-ascii?Q?+34Sn02+7IdtJrspypzRasLArIz3ixbYHGAzUqk5/nSDSW1znf0eaBGdZv2M?=
 =?us-ascii?Q?I4AxG4xjl0oAy1iMqNun0nSNdJHqBGISnJB5Lz+cfbr0JAAJo7FvPB8DdjUn?=
 =?us-ascii?Q?zMHyYR+9PcNbjHKFiRvWFll9kYKdGnnX6o9Zcds0R9sYes8ecPBxKWZM7qit?=
 =?us-ascii?Q?tfDZJQ8WYvO3zJfIrJxsznVa4VKjNYjQfelRaBQFb+jJL97rEkt2mBt5sAZi?=
 =?us-ascii?Q?oNfu+Ebb6dzHenqAJX8p/71J4XQRO1ZM914UJFolQaLMyD4JmlapG29fh/Ea?=
 =?us-ascii?Q?tqKSserIcNVrXuELj744jCWQYZU6S4C7eSu39/VifNTpjdHaVYk/JKtXrjmD?=
 =?us-ascii?Q?WaATcJOF3gLr/uLLTXKPqa4vVB54eVLqZdNSjLdxzCrsua1p4kZ6gw0OIbjv?=
 =?us-ascii?Q?rWE3pyCGR+bNYh2fc2rahV0mqSBTsChXv0vySv52e8feFxsJtnbh0Lhe2RqS?=
 =?us-ascii?Q?gHmRG1v+15194WpBpB2ulMDZvw8v5zzh0DmspGkCanyF720csK54cxBMLIhE?=
 =?us-ascii?Q?eF3ESnbZ0DXOSXCLLcLK1QrOGbEUbRGTdNkJf5DgamMKFHLv7ZUqXUtOvkJk?=
 =?us-ascii?Q?2SOIXslPf59ZXaV6t2d4rnwqV/tZUiXaLPp6ObWZXuhuDwHFPJeVTMs2UR/b?=
 =?us-ascii?Q?Nj81RQhhbKAK9kswkec9W6Td36SY+l3GpfFpxauetAwXMFEqP9bEtx5fVN4T?=
 =?us-ascii?Q?kamIqIOYygdO/e+eZXLioPHJPzSkyGYfN6R9mVZ6HEHpAsGTgb031j6zJ1Jx?=
 =?us-ascii?Q?GFXNqjGwO3N7YtQvap/IfV7Vu1JkTfZQEpWze7PfZ8geCD9blQwr+34MogBY?=
 =?us-ascii?Q?9lB5wFkppLyR88M+5u2YHAfrvhawNI9ZV5W0XbFU9DpuVXsWc4JFYvybb4ww?=
 =?us-ascii?Q?CBPIWr711/FF3EPpXNH1KgxaGrfCdWDS3wezuKX5GO0WjSNHCSG3j/zuGnfv?=
 =?us-ascii?Q?UR5rg1QBXzW5p88kkNZGW8R3YQFtuXotd6/K6u2P?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a3c934-9d02-4571-31a2-08db6c0b2a22
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 12:39:01.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4M56hJMvArewhdL5i+LOVnjDx46bRdGqOqp+XCv1EiLVqJW71MNR8n2E2PSIaDYr34mJYnWCMJtqRDK3XS9vPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6519
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In device_for_each_child_node(), it should have fwnode_handle_put()
before break to prevent stale device node references from being
left behind.

Signed-off-by: Wang Ming <machel@vivo.com>
---
 .../net/ethernet/cavium/thunder/thunder_bgx.c | 37 ++++++++++---------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/ne=
t/ethernet/cavium/thunder/thunder_bgx.c
index a317feb8d..d37ee2872 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -90,7 +90,7 @@ static const struct pci_device_id bgx_id_table[] =3D {

 MODULE_AUTHOR("Cavium Inc");
 MODULE_DESCRIPTION("Cavium Thunder BGX/MAC Driver");
-MODULE_LICENSE("GPL v2");
+MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, bgx_id_table);

@@ -174,10 +174,10 @@ static struct bgx *get_bgx(int node, int bgx_idx)
 }

 /* Return number of BGX present in HW */
-unsigned bgx_get_map(int node)
+unsigned int bgx_get_map(int node)
 {
        int i;
-       unsigned map =3D 0;
+       unsigned int map =3D 0;

        for (i =3D 0; i < max_bgx_per_node; i++) {
                if (bgx_vnic[(node * max_bgx_per_node) + i])
@@ -600,9 +600,9 @@ static void bgx_lmac_handler(struct net_device *netdev)
                link_changed =3D -1;

        if (phydev->link &&
-           (lmac->last_duplex !=3D phydev->duplex ||
-            lmac->last_link !=3D phydev->link ||
-            lmac->last_speed !=3D phydev->speed)) {
+               (lmac->last_duplex !=3D phydev->duplex ||
+               lmac->last_link !=3D phydev->link ||
+               lmac->last_speed !=3D phydev->speed)) {
                        link_changed =3D 1;
        }

@@ -783,7 +783,7 @@ static int bgx_lmac_xaui_init(struct bgx *bgx, struct l=
mac *lmac)
                bgx_reg_write(bgx, lmacid, BGX_SPUX_BR_PMD_LD_REP, 0x00);
                /* training enable */
                bgx_reg_modify(bgx, lmacid,
-                              BGX_SPUX_BR_PMD_CRTL, SPU_PMD_CRTL_TRAIN_EN)=
;
+                                        BGX_SPUX_BR_PMD_CRTL, SPU_PMD_CRTL=
_TRAIN_EN);
        }

        /* Append FCS to each packet */
@@ -1059,8 +1059,8 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid=
)
        lmac->bgx =3D bgx;

        if ((lmac->lmac_type =3D=3D BGX_MODE_SGMII) ||
-           (lmac->lmac_type =3D=3D BGX_MODE_QSGMII) ||
-           (lmac->lmac_type =3D=3D BGX_MODE_RGMII)) {
+               (lmac->lmac_type =3D=3D BGX_MODE_QSGMII) ||
+               (lmac->lmac_type =3D=3D BGX_MODE_RGMII)) {
                lmac->is_sgmii =3D true;
                if (bgx_lmac_sgmii_init(bgx, lmac))
                        return -1;
@@ -1096,9 +1096,9 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid=
)
        bgx_reg_write(bgx, lmacid, BGX_CMRX_RX_DMAC_CTL, 0x03);

        if ((lmac->lmac_type !=3D BGX_MODE_XFI) &&
-           (lmac->lmac_type !=3D BGX_MODE_XLAUI) &&
-           (lmac->lmac_type !=3D BGX_MODE_40G_KR) &&
-           (lmac->lmac_type !=3D BGX_MODE_10G_KR)) {
+               (lmac->lmac_type !=3D BGX_MODE_XLAUI) &&
+               (lmac->lmac_type !=3D BGX_MODE_40G_KR) &&
+               (lmac->lmac_type !=3D BGX_MODE_10G_KR)) {
                if (!lmac->phydev) {
                        if (lmac->autoneg) {
                                bgx_reg_write(bgx, lmacid,
@@ -1178,9 +1178,9 @@ static void bgx_lmac_disable(struct bgx *bgx, u8 lmac=
id)
        kfree(lmac->dmacs);

        if ((lmac->lmac_type !=3D BGX_MODE_XFI) &&
-           (lmac->lmac_type !=3D BGX_MODE_XLAUI) &&
-           (lmac->lmac_type !=3D BGX_MODE_40G_KR) &&
-           (lmac->lmac_type !=3D BGX_MODE_10G_KR) && lmac->phydev)
+               (lmac->lmac_type !=3D BGX_MODE_XLAUI) &&
+               (lmac->lmac_type !=3D BGX_MODE_40G_KR) &&
+               (lmac->lmac_type !=3D BGX_MODE_10G_KR) && lmac->phydev)
                phy_disconnect(lmac->phydev);

        lmac->phydev =3D NULL;
@@ -1199,7 +1199,7 @@ static void bgx_init_hw(struct bgx *bgx)
        for (i =3D 0; i < bgx->lmac_count; i++) {
                lmac =3D &bgx->lmac[i];
                bgx_reg_write(bgx, i, BGX_CMRX_CFG,
-                             (lmac->lmac_type << 8) | lmac->lane_to_sds);
+                                       (lmac->lmac_type << 8) | lmac->lane=
_to_sds);
                bgx->lmac[i].lmacid_bd =3D lmac_count;
                lmac_count++;
        }
@@ -1478,8 +1478,10 @@ static int bgx_init_of_phy(struct bgx *bgx)
                 * cannot handle it, so exit the loop.
                 */
                node =3D to_of_node(fwn);
-               if (!node)
+               if (!node) {
+                       fwnode_handle_put(fwn);
                        break;
+               }

                of_get_mac_address(node, bgx->lmac[lmac].mac);

@@ -1503,6 +1505,7 @@ static int bgx_init_of_phy(struct bgx *bgx)
                lmac++;
                if (lmac =3D=3D bgx->max_lmac) {
                        of_node_put(node);
+                       fwnode_handle_put(fwn);
                        break;
                }
        }
--
2.25.1


________________________________
=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=86=85=E5=
=AE=B9=E5=8F=AF=E8=83=BD=E5=90=AB=E6=9C=89=E6=9C=BA=E5=AF=86=E5=92=8C/=E6=
=88=96=E9=9A=90=E7=A7=81=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=8C=
=87=E5=AE=9A=E4=B8=AA=E4=BA=BA=E6=88=96=E6=9C=BA=E6=9E=84=E4=BD=BF=E7=94=A8=
=E3=80=82=E8=8B=A5=E6=82=A8=E9=9D=9E=E5=8F=91=E4=BB=B6=E4=BA=BA=E6=8C=87=E5=
=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E6=88=96=E5=85=B6=E4=BB=A3=E7=90=86=E4=BA=
=BA=EF=BC=8C=E8=AF=B7=E5=8B=BF=E4=BD=BF=E7=94=A8=E3=80=81=E4=BC=A0=E6=92=AD=
=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=96=E5=AD=98=E5=82=A8=E6=AD=A4=E9=82=AE=E4=
=BB=B6=E4=B9=8B=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=E6=88=96=E5=85=B6=E9=99=
=84=E4=BB=B6=E3=80=82=E5=A6=82=E6=82=A8=E8=AF=AF=E6=94=B6=E6=9C=AC=E9=82=AE=
=E4=BB=B6=EF=BC=8C=E8=AF=B7=E5=8D=B3=E4=BB=A5=E5=9B=9E=E5=A4=8D=E6=88=96=E7=
=94=B5=E8=AF=9D=E6=96=B9=E5=BC=8F=E9=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=
=BA=EF=BC=8C=E5=B9=B6=E5=B0=86=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6=E3=80=81=
=E9=99=84=E4=BB=B6=E5=8F=8A=E5=85=B6=E6=89=80=E6=9C=89=E5=A4=8D=E6=9C=AC=E5=
=88=A0=E9=99=A4=E3=80=82=E8=B0=A2=E8=B0=A2=E3=80=82
The contents of this message and any attachments may contain confidential a=
nd/or privileged information and are intended exclusively for the addressee=
(s). If you are not the intended recipient of this message or their agent, =
please note that any use, dissemination, copying, or storage of this messag=
e or its attachments is not allowed. If you receive this message in error, =
please notify the sender by reply the message or phone and delete this mess=
age, any attachments and any copies immediately.
Thank you

