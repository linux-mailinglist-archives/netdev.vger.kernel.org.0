Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD16F2FBACA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391145AbhASPMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:12:07 -0500
Received: from mail-eopbgr60130.outbound.protection.outlook.com ([40.107.6.130]:4772
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387558AbhASPLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqIPBQZXuiwunR9Zu0Z1ue9cQ2X+/926nauiP+nKXGFOe7YAic+rpcT3vXgfuqmsMAwCmLtjrXjuNSJ7OB5MOWzOk1dQ6kj67RNAw6+0WUmmhRsKbNXiQH4FzihI+XTKYN040imEVQCAfhrEIKWZIWnLMBD+jnNncoztC90qJN6EYNKB+zt6oRRxWhpegeDvv94RRgueSBUZNrikIrzUog+M3nvnqGb/Yy6BUNaKAEDHEvT11wsulh2SrfmxAYSJIYnSsqUB+BqyYqnSyNQ2N98HFI705aaD7SWhPKW3Onhc9nIQpyUdLapunDIfHYDa+BzNtg06osdy3SBzH2newQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Qtz1pn4sa2b1L7p/Hh8pnDUpzj+tfILsMm7l+2UgA=;
 b=dtrvy7latlpciMARj57nV3w9l4TTuJg5f+ifMZsuDRfIvzsQBCXfTO1JiCdYvtAFuWIFLZZsl7Mtnuq3e11P+IkONwyR7h0SjkfaTJg8IVKuUkRLXSvmA3n9p7dYgdPqWe0hHIeUcEFTcMegeaAYOzcO2Nfnv458Nf0qIt0TTd9FvDJUseTItRNz/E3BSxWSMsUyvbdYS+QMEyY/ZMigZaHKRv5jyXE9nFVGcfE4JWqkg8eziTTyMh9arzBoMeOb/N/VZTXS5EqHtSiPKLMPc8ikURvc7Z3bhWEUSfra4VE2KHElRPOyJUbf/sHmxWz5upZyNyR3gq9Oc60Hj4nyiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Qtz1pn4sa2b1L7p/Hh8pnDUpzj+tfILsMm7l+2UgA=;
 b=ASUqyIk7hLnck7ZjFT43wCA3gMJaCgvNPpzHOYe0xlLl1TWTLyNGTKJPmbsSR9pFJNdbjB4C4m0mDr+s/TgX/bcA7CBHsOgnsdVrOh0C+48nNIniChdF1swREExl8ONHEqKtNQ+QbjWWSWjfMlT/PEn+cW+DsShIgYCRY69h1E8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:15 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:15 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 10/17] ethernet: ucc_geth: constify ugeth_primary_info
Date:   Tue, 19 Jan 2021 16:07:55 +0100
Message-Id: <20210119150802.19997-11-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb6c4303-0231-4c84-8538-08d8bc8c2f90
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB368173EA646E5B6860F7CC7093A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emJb5SdAik3/4v9/KZuZSD+72JdIyPV7Qgs5ArKC28/rFLJ6dq1btOxWlM9zT2l82reYlSGSdVBjkqPz5ltAhWBPI39pcQvA06Hgy7LlVQRudR0sM2CUTq+Bp0SsluFCWz7XyrqQnIPh1c3Xbupp/rnK3O0BJQMVv+OCz3fBk5I6ZnWkdAGrQFitfmPklRJ8hQPe18pBHcDnfWHdtG0QScTOSPL6vnWNQ70y2G/MRDxXUbzI6ZqxIjKkq/ccdT/sVb5FRdJ6EAJxZpPgfb8YkeAO7kqwyMSbzLQM10G4njMveHKfm48W6Q6rIA84alB0NZ9Hz+ifFFO2kUbcr0QghC0u2paLd94pR59sxGTKLGa5Dr0zjUV3TfxWuoJYU19FXsSInOgfXyjssNK2CexR1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(4744005)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UtejaK43Z+9p0GHbD/8+rlQqYb67/xARTO1JKa3kOD5K9WTqhSpcRBKqaf/Y?=
 =?us-ascii?Q?cGTQj9uam3JIWa7PLWwqCqhdGSfkUVj2Wertix1KvMmQuZhV9VMrp3ptfgev?=
 =?us-ascii?Q?v0+ZkSgFmZ1GaIJoGKcCaNgfxcSaTGkgSnZTUDGrDrjW+UUiH0ERKAyjO4cD?=
 =?us-ascii?Q?v4DNg/L0+n7ul9le8Us+EZc7IWwqJde5bNZPUEziHISVbxPo27zc4Lv4B+XL?=
 =?us-ascii?Q?GnCRZb09HNl10DxylPSP0rzvhPcuNf893XeeBZS1RowzBQ8/Y1orjmBnORKn?=
 =?us-ascii?Q?S2UrPxstOhQfFeYDboz9zvrmNXnrcihMZq1A2/S8JPOxblSu3IdUaRjViVxj?=
 =?us-ascii?Q?h069Gif6G5fnjYGrm/Hxaz+mStgjrxkmDuHgunrdPH1UMkKs0097jscN7nKG?=
 =?us-ascii?Q?vDcRUea5biP6S36UDhkVWxmQuaWV5r7wvPXcBPOg1bmDU0nFRsvM1a4pMFpP?=
 =?us-ascii?Q?Zr8+sMXCBLaz6Kq3/8V20OIhbA6pjIOlhkBRtEHNUK5iiu5EEsaurfsfVcJo?=
 =?us-ascii?Q?jjjcfe5hNx7o/NNkwUCgAJbBj8zqLrz08mGN+TZm9UGHgaZn72z8MoE8tbqb?=
 =?us-ascii?Q?oL4PGuiURO9UXFu1mbpq7hWXEOScHFsJ29pF/Oo91MxffKX4dIKgOb4HPiZR?=
 =?us-ascii?Q?ZK5CnK6KuxbT7OskmQBq3t1BKvm+VGUsYKrk1TDIi6HoeWGyHSICnIH45P0k?=
 =?us-ascii?Q?06vvJ+s0Ap4tJ3v4J5OEvjjrEPXlYOA/pByCscj14i/qyPf6UFIqoa3jEh5C?=
 =?us-ascii?Q?DocFcpC60ppRQnuQj+p3DZU4rKbPc2RDjLJhriVVGja6Wn2DLbMUD0EroPF4?=
 =?us-ascii?Q?Tpe0NE/6dEjubTSeKyV9vRtbSa74N6zv4/orsdX8iZE0m8/0ECPN4Q8sG0gB?=
 =?us-ascii?Q?/flDiTqAx76bT0e9yr/jEeGqqaY/RyZHyghdvkPrIf/HHFhk3EPKxi8T89cw?=
 =?us-ascii?Q?rS4WXHcVGQEx309Zq496qv6pElrE0t6GyITnxP+HcOfI21ogZfGWmkXt1pL4?=
 =?us-ascii?Q?TCA1?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6c4303-0231-4c84-8538-08d8bc8c2f90
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:15.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U0IBJel+GfamQfyfDvTR1M1fSQGhTr66Ee6PKTJmcBRP9RhXgoKK8MoiKkXvB5ywa5xQ/+I5K4HLXSRx6b50CYFg0Xpds3Yt2JHHgJHUMg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 75d1fb049698..65ef7ae38912 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -70,7 +70,7 @@ static struct {
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
 
-static struct ucc_geth_info ugeth_primary_info = {
+static const struct ucc_geth_info ugeth_primary_info = {
 	.uf_info = {
 		    .bd_mem_part = MEM_PART_SYSTEM,
 		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
-- 
2.23.0

