Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB17B48CADE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356246AbiALSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:23:29 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:58245 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242533AbiALSX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:23:29 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT63l010893;
        Wed, 12 Jan 2022 13:23:19 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g26d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:23:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+UJftgMX1Qs46uT/jKSGHjkF+SyEKbMeyKFwRNSz0FEEkS6EndJs8lDUP6vjaJnaHIUn57Bceh5Ix6GLzkXv3IDJ35QKra9g+kU4SDSekb70ekMPnHHNYQ+NE05xq1F7o8BeMO++Vt8F2CiRhV7eStDKqoijQaFnjqTbmbtiLWR3hZAvFFyx/FSpf/zrO/2I48lBfKihzKWAL7/w1w/SyyJxvlEoPc4d4NWFRaOV+IdRbkNxMy/javDl3VICDIpzC7wEbtk46Qhmfl/6rkVQ5ZaXBkf/JEOW+O6ARvcSoDCUqo3BIwpCzej5rykog7q4pvZyTtAMbgrqpgHH36FEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJs9qM58TEFy9ATsjA2zXuNM/sfBfGQkOghuyQjdoJI=;
 b=IfU8IhgOHvM7wia1WOaiPco9wXskeSTgBJAabZhZIhKzmNCWN8Fcj+YDKD0g9DRJvBUUg2WQPP4PLAqxTHYydD5jmzOnhxnkkWuA36GhpBq5GtY2NbJPJ8I7dVFn4CuNvjBCEMFeN5AuD7XDifJt/BEhoXy7rFpBDHEIyZSoa57MJjanPOazbwXEI6mWurjSHydwPnB8o4r4jh2S65Qc8gCV9bMIW89tc4VXnYBqfDzd1i33GP+cuS1TKVhV7XJhmM8BmiJpidRYrw/Uv3bJt76D/5WtevKCUYFC7HZxJUd0lOMXDjdXtdrHmx7e/oOhAp4GDoFSy7+V1clKEq8KGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJs9qM58TEFy9ATsjA2zXuNM/sfBfGQkOghuyQjdoJI=;
 b=Kd/y9ex90k8d0wiv7l6w9M4KNjpIvztiAgun1GNxX3qiHW3ULJKat7+ueO4cDQseXlc2VVEQzhK84wHlmjbRK93rxwgJOAuvWkk4RIJM4fUTWuO7C/HKBjnGiXgTVCkR0yvGSzBNetzNLNArSrARJhhpV8vCnAxVJz77qEkgqxk=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 18:23:16 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:23:16 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] net: dsa: microchip: Document property to disable reference clock
Date:   Wed, 12 Jan 2022 12:22:50 -0600
Message-Id: <20220112182251.876098-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112182251.876098-1-robert.hancock@calian.com>
References: <20220112182251.876098-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:104:1::11) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fda618d9-c4fd-4bad-1661-08d9d5f899b6
X-MS-TrafficTypeDiagnostic: YT2PR01MB6385:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB6385181991EDEFC9234151D9EC529@YT2PR01MB6385.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaRapOYghyYxQdyvmwPdYoB336fNUfxhrZ7nWB7J5RgHVKM6il+Db0yKwBhhsSFYMtF1Xm4Q1/uAfFecAJgaiFtBlDzApOJlghJGSJaoc3efzAOQ5a61KukeTaVrFF4xAgYgby+VSbnb9t/rjgESQoT+2fTzt8br5WjSzJhq3v6R64+GxkFEtsgynRoUMaiAS6bFMm9+M3h4gr/cAq5r2JP69x2HtIKk3zOmipJB5NwndSVPAbYVAvSkPEES32D+ADMdChtlZoE4lfXbbQDI+ehnoGwg2LdGCXa+4FW2HMlkm1LFunFvbFyXkSgQkn48OfXILYl7WnPwzQN9liBuQ1JsDiUgFwpUCF4bg6U+rwklg7Xq9Kg3z9zj3o8sgjDzl95fiUxyf8Iw6wxO6X72iPJ+x6q2LvJp4s7nH+CUku4OJiXyTljc+zL2Q2l2y9k7qdsyap3z/oFRBBg2YVXjUXQYUmzPqK+LZGj1ZLj4vH95pBlDQrPuH0v9NAEt3SV5ccmjYl+JKdDaF3xBpleagfshhnQnVlsW/DZ+9zPfV8puDvXNhxTPk4Ck6isENmtFbTMyecppq4tcgcwzrLsv88q8nws9FJRS+AWM6XTnA/ahym5a3oui0V4EvI0fqC4F3W/u/A3G7xofyREXaLEyqsZbENzn2+bIs5ACLCBsVwB7k0xehS4YOlqBRKO57A32jrfbppKSLXcOD41fS4EwYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(52116002)(316002)(7416002)(66946007)(86362001)(6666004)(44832011)(1076003)(66556008)(83380400001)(107886003)(5660300002)(2906002)(38350700002)(38100700002)(8936002)(6506007)(508600001)(36756003)(186003)(2616005)(4744005)(6486002)(6916009)(6512007)(4326008)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PFma3xOX+do37fyP+aOGA7BtYgn080alFPU8nVBfZDKlqzWHjrTZ11se8FxM?=
 =?us-ascii?Q?RFB5d0UQiTITXRZfIM37tsRNsUsznSFb2zn4ynwae1hLJ7aaWIqQXYzJ+Utg?=
 =?us-ascii?Q?+qBmOWubRL8rIag4G6inPTezCp/N8STw7WfvOotCSq5zrd8ZY9kgyGO51Rm8?=
 =?us-ascii?Q?b9AovyNk75ec8wxiRHJpnt4DtT/4/Tj2y9QJ2/6VtRREoglbt7H2+KrGU+sS?=
 =?us-ascii?Q?lf9TgRYVgb5VXyKqsSVjhgqhKjsY5Wn5tJlvwP2KTBYZdJzj6M9LX9EWzXIB?=
 =?us-ascii?Q?BUyJM5TDjNQYQ1QIR+jhtDqi+5+o3tQnGSq95n1qcRDeMHJQavJ2sA/bN2Wr?=
 =?us-ascii?Q?XdJ40atTaGMp07PLWMhW4sVQ3qIYvP+FIfHFKqBr8dWsNlWeppEDZZ1YA93P?=
 =?us-ascii?Q?QuBj6YC7+CrGEdQc+6J9b29/9gKzppWkLXpwtDyXrttv9qyMfSsuIR3GHTpd?=
 =?us-ascii?Q?UbVlnUOziJN+ClwpRmpfmzZploErpoxG2vZWfwo2UUhP6lV7Jv92H9FPHspY?=
 =?us-ascii?Q?yUDL2yNxytCLCag+0qU7Cx/0IoWCMRSEhC5Hl/nMG/Nspe2JZbPrOBSBeEKa?=
 =?us-ascii?Q?CylKXIEPMYR9BED+Ld1S47LI7S3QWNKOVNezCUekHMToh89nsBAz73sm0ZFY?=
 =?us-ascii?Q?C1YbeuVaDv+TSa1FtRswcF1+5L8tIrS5Efsg8hsxkDhMMjMEJIC1dieFm7Fp?=
 =?us-ascii?Q?ZjsebZUgntieceyUmp496q95BQ7Jilb4bJQFxJ0wUTJI7mSJReOVrnvLbQYC?=
 =?us-ascii?Q?kptSYjifXgZuukqpVUiTQ42jzpOtr/UkkgB0PjB9mDJ8LptU3mMWGt51qZ87?=
 =?us-ascii?Q?n+jCUE0m/2tZKx/XLXBck6HZMoLw+90yXqAUYYOadfTIa89M2fBUe2GeT0jp?=
 =?us-ascii?Q?6DPmmHl9RONQzBlIbZhtNLLTyZEJxFZWCJVRtbdgSy4tkBVeXwpIHUn13ytq?=
 =?us-ascii?Q?1U22NZXuwm+aNa2WfsIO/ArBAxUlDg7AS++fT8thpb9ayhyDqLea8plK7qDc?=
 =?us-ascii?Q?N7D9px3CPUwFWLEzQq5ZyHLJ7tUx3LPq2Il6/Ue9b/rNsbbTkDAJJxpapjld?=
 =?us-ascii?Q?FKRdShqFl0TRp4GPuxzki9Mlh+DHg/2InmKQ2RffBeokV1u+eZRSvtaVtQnq?=
 =?us-ascii?Q?ZCRK+zAiAODbcgZiV4VUc1WjAiTGhvvijiCvYtbPvR7488ypnkouCGMyvcc3?=
 =?us-ascii?Q?oq4JKBnPsx4ejlsCx/F062pm+q6B5Hl11mNqTFzCRh6JseuKYNPnFb0Ls7Tb?=
 =?us-ascii?Q?vcFYahTZcD3ar3yeilWQyKDSH0bJZRcNJVfQO7VA8Cxyx5AEKtcIbjS+cG9E?=
 =?us-ascii?Q?xymGEujOk3Q2HFDZyv6D3QMOg4AQq+Bj2rQvUQrOXlxlS8GnnA4z8NmsvV5t?=
 =?us-ascii?Q?b7K+C5+p/UY2pYNwi0IsFABnn/t25Znfok2O81bU5oBiR+0Jk6YPn6Ezd6vl?=
 =?us-ascii?Q?ak0QWgK7GwERVQQkeUcIZbIpyzbBoNQGq97lPldlzhiH0acH5V8tKa+ZlyOa?=
 =?us-ascii?Q?aBe28U6JLe7XjY8YjTbFTSgzG76d9BcsDftun4TLByi86K1qGiN3CdGLWvpv?=
 =?us-ascii?Q?jKWC+uFo8IoHMsVLrW1f/jG6Q5BNgEEO/uuPvJpGRD6dappdCSUyq2BWcvkI?=
 =?us-ascii?Q?3ynBzqkNNja5r9NdYKjcDH8I0SFv9jC5z5gUloKASg8Pau45omhxvVi/qW/b?=
 =?us-ascii?Q?PFDsMdfhzrbBW5nuyC7/RwtP8KE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda618d9-c4fd-4bad-1661-08d9d5f899b6
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:23:15.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOJ6fP9ZhtMdQFNjerKMCBdQWUd1oY+LKtm2kPTmOi5Jphx/z5gReqgFNTRtvU1IQ06sFiDZ2bQ31ekuxQIpBv0UgeYdmxa+jxd3uBGEI7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6385
X-Proofpoint-GUID: RPef-WG-YXJkGu50bJ02L82137Cu0Ns5
X-Proofpoint-ORIG-GUID: RPef-WG-YXJkGu50bJ02L82137Cu0Ns5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=994
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new microchip,synclko-disable property which can be
specified to disable the reference clock output from the device if not
required by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 84985f53bffd..7cc22ab1787c 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -42,6 +42,11 @@ properties:
     description:
       Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
 
+  microchip,synclko-disable:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set if the output SYNCLKO clock should be disabled.
+
 required:
   - compatible
   - reg
-- 
2.31.1

