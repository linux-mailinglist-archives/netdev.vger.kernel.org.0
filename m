Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C146E57C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhLIJ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:27:38 -0500
Received: from mail-sgaapc01on2099.outbound.protection.outlook.com ([40.107.215.99]:3681
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233327AbhLIJ1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:27:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlqHLrXwg+GbyLtk5TW95dhWqmGkN+cK5u/6FWXRZDntzePnqnizk+OIpuB9IPFGSqEnk78kWJMXff7FYTj+9d7DT67GsrXgJrqbXdyb+1knK64wk/XXro3FJzRYNyzeCdUKoLSfyV2XmXM3zyXnU2UaLdh95hQ3BtgdaPOwkERjX1PqwPH0FHZnrA5LcWytBAfZNtmuwDgminSqK/83VjKnyzafwJWtABRmIoty7Imhqc8JjuZeTfNtOcfw4Wn7Ipxt0gL+tCOnwwiu1huaz7Fr/4e4QyzuSU5RVO/NbUGLzo2HefMfR5Aus/QMkXAvIOdurswLJbE632Ptvv0iPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3NJ5iInjPFP6OGwA1eZNNjwqk+mrDT/lCtyg0eU+Jc=;
 b=Jr6vLSgckVRH/hF8TRmbXDy0mPk08st2hUEIA1kKcUIFjvgw1556hOxOihV4zLDlFqleznz1F1iydGdY+yF3BPb81/DBzE3KbjfWqoqxLyCTc6zXPC5etcvXP3X4Pdy7+buIrq3ljltuP89y/4sg7m1Km5mKSeJ+31lM3LnRtJvFd6ZZwyjc4yrgR5DCxNudR4G9jiwKJttXhk/EFU8F0JZHlyAabPiE4iei024TsH0ekyO6NxCVhrwA/h2ZSg1nFz3fi72ntRDk3adaWolDsvp2r9+EWFOtt7USG7iymR3SHqUVvZOtynYP+tjYF/0PHtJLJ0Kb43EgsVOJQnrxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3NJ5iInjPFP6OGwA1eZNNjwqk+mrDT/lCtyg0eU+Jc=;
 b=f4dCN66XMBFxoLvNuskQSYK+YAPUvHKVQdSxB72SUUYqa5Ma5f4SPuVsm2rAwIk1SXudY4IAMyXJ34YT9LYEU16f9xPjA+8fu+apeZyxS+vLDqwR/VmQfeymnHyycWWCXKzQii1AVCRSXPstFdhERoGbLyw+QwqKhQyisNKIT98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB3486.apcprd06.prod.outlook.com (2603:1096:404:107::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 09:23:59 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092%8]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 09:23:59 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
Date:   Thu,  9 Dec 2021 01:22:50 -0800
Message-Id: <20211209092250.56430-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:202:2::30) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.vivo.xyz (218.213.202.189) by HK2PR0401CA0020.apcprd04.prod.outlook.com (2603:1096:202:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 09:23:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c251d159-ad09-4fa3-7602-08d9baf5a1b9
X-MS-TrafficTypeDiagnostic: TY2PR06MB3486:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB3486133A00A32D323ED0EBF6A2709@TY2PR06MB3486.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LEr8QO7Kxf/0viYeuw8F860qOSXZeIcDgXkKmN0Bpk3hZaPokz2kREEWG1oyRs+Tfa4qTX1nwGRQl4J2tNjGn3hs58rLkPP3/Q+u8GYxM0aJhQpzY2F2hJhD9/fbZJ2gtI9+XNJXOdOln3gjcrtq/GQTOw+fFbJUBtXES0zhIOAHf8cs38vX1biCP73dAK+I/fw+C8B51CoGpaeETVXwDIDZ3oq+q2g/D7J8V1zxzn/JkHNYqu3DXhEErNKy2VbCn13sP9ZVVWqYY0+YjdMeiGGCjaGVmxwlm+2FWZZITRhotWeaFEYL56WY6fpHC6hOYb8VEH7hzuRs3om7WG/Nm7AmYTGHOohpleuDD8Jv7drl7Tr/1LexqNPHk2gh8qw43utt4waXM6tyzhaobNxzm0C81a21q0T2pTjqjNcuSOCfxM74Pp8UV2EzH8oj9M8KF2E+MQqSXdHUrmQ51h3nybBhVb476iUdkXw+vq55mycdQG6fwZINimqlZ7MNqIgkN4oxR3W40IKNLTO1/1g6syg7PY6q8S9uyMrQNfAbCo8SA+FgsVp0ojNxomxfqPCYjAori9PyDlKpKjXFUdQTR5N6yXNZ/GphCon53eP3XQW434JJJkpc48XCnDFJe02FywLAuVBT9APzVv+KOz3Bu7E0vBdVicxabYYkM51NwtLVaObxNxKj8NA879x+KhDYIgfSUkO7Eta2kzgaH4jZjF05NvOSdHsgK1DZT9/UIl98/fGLdosoKpDxoaShBllm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8676002)(2906002)(83380400001)(66476007)(86362001)(921005)(36756003)(110136005)(508600001)(66556008)(66946007)(316002)(6666004)(8936002)(6486002)(26005)(956004)(52116002)(6512007)(186003)(2616005)(4326008)(4744005)(5660300002)(38100700002)(7416002)(38350700002)(107886003)(6506007)(182500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jl7AZs48NRRGb3DlY6qsugZZKIgXLkTYYokHQ7LwU13fZMk7/+SGkpjq3MaX?=
 =?us-ascii?Q?j+9zm2iicIKMKEQAq3X/wUfq2Kmy8ubaCmFeg9bboy1ccytaPP+/9Z0Bqfti?=
 =?us-ascii?Q?izVu8GlucPT0JMfuoh50VhN9LHYLW1DdOQ0ldc6dtK5NQS1pi9uxLLrnqBHB?=
 =?us-ascii?Q?9khimlR2O7BtUwUwMxm/hsM+CjP1X/kmUrwAGUD9NuSQnWZmAY8zxWwHy/FW?=
 =?us-ascii?Q?zw33gGqdq3nUwVYHqCOAWEJcob+QDFXp0CHD0nzBvbUEK1IvFeXSZc/EJ5Bb?=
 =?us-ascii?Q?tUixEB7pWfH6XM22zyC0fyy4yuesmLvTz1S+ArQwyeTHHKDT7WWgBB8NX5BZ?=
 =?us-ascii?Q?e7tdKtZDaXA1GXBHUcVCe9Qrd2+9x3dokdF+8Oysz6Yi07yZAp9rT18FVwgi?=
 =?us-ascii?Q?7J8W2AbBHlWfmgmchDMxsYTcHSGmskFF6XYRyemD+jdE06PIyknpbKuCELok?=
 =?us-ascii?Q?JKYuMdsoWCo/0FVT4tXhprDiOEeywO4OBioAigM/3sfxo8xa2U4LcCCynLbt?=
 =?us-ascii?Q?a/ufR3zQxDfR9zFPu27f8+xZXy9AWy0155B/DPD9+vcfe4zeCl8aGlCDCWu7?=
 =?us-ascii?Q?s3KcDzsAvB7AnI1uVcxO7Qc17R7cBu98MJ7ycQD1VvmcHP7b8bG66u7SbD4p?=
 =?us-ascii?Q?S06plil6P4HlldOqw/7uR0IuMKm8wfsI2BfOZLHi/8FBchgrzL3WBKIbFGWo?=
 =?us-ascii?Q?coGpugDHHIFNZzfeuP5iQn/WHZlwPTkM8fFgmg8ySJ/3AlMIP9VPzJ19w4WA?=
 =?us-ascii?Q?bTxJKxP1cF2y5yakF4snOw4w+0TatDMCK0UE6vBQsNGXmk7xlbffRefoXIQ/?=
 =?us-ascii?Q?rQcdAOl51/z9+biJIxeDW31qbzL0/rbaOOKWEvd7WPqOOhQ482WI7XkZw7Kl?=
 =?us-ascii?Q?ak+cF/a4dhzsaWely33jZumzBdu8dwOHVMTnIHBkRCyCOG9FEHB3rde1ARZD?=
 =?us-ascii?Q?jvd9M1urGFDTkUI69pBlDAmSTLJXYAcBZA484ID4kVVwF+QSdBwQKzWmOrRt?=
 =?us-ascii?Q?OO2Hc+DKISLbM4I8EBbxcrWeNwyGZkJAteNLYIL0ThnTVndyxa3a2lP6tDfU?=
 =?us-ascii?Q?KOid1OqhDbU/cQIzijDNdZmKOSee1wCxGtEVzVd45njmo9cTyUVIgWis+FK4?=
 =?us-ascii?Q?c6e411Q5o9tk56umtT5gKFOiQ2ut1LGZQyv5Rbgx6sT1hjq1rMcn6cxgRFTO?=
 =?us-ascii?Q?oSmG9/yWv1TQ5XYXkupMemz0PjJOoKTHRxvrgdw2LFiEOm830pWSkRT+18bl?=
 =?us-ascii?Q?5Dokx5PKhXw45L7ep/OIBxDxZhA7uKe3kotJSStxvhuyhbZ34KR3slaj85ye?=
 =?us-ascii?Q?AIftJomqB0ffLEyNAzbhMYd7owccN8wC/f3c2azAj5XWfIdxtG47g3dAfLy9?=
 =?us-ascii?Q?irCD3++JrMhy3dFNLTKJ32W0huU9RFatWMNhy89c5mGz1qmV76AVRt9Ne5JQ?=
 =?us-ascii?Q?QGkNncgEBKhvcXdRD7kO2U9O3LjBhBZo0jcehAFE5Jwg7esj0KLUi59n2hCK?=
 =?us-ascii?Q?2gGrXl5KxzLFkiUdnXRw9Mhh4BJRr/DYUEhJpv+D+gioHfZR59YCsyWZY37J?=
 =?us-ascii?Q?jboFHMAcPIihDRMyS/YW6NKa6YcptSneIqA2KsJRmDoaKG7EOlovZuIKsP5V?=
 =?us-ascii?Q?jixVsZBY+6m5SNvlBQNF/HU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c251d159-ad09-4fa3-7602-08d9baf5a1b9
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:23:59.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DNSZJQJrFTrdrhEs4dvWvqIliiSai4V2FK6B8z3rn5K+85rtmfczhXe8vupEYB0Bmh27enX85VLR+Tnk9Zr8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following swap.cocci warning:
./samples/bpf/xdpsock_user.c:528:22-23:
WARNING opportunity for swap()

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
Change log:
v2:
- Remove temp variable.
---
 samples/bpf/xsk_fwd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
index 1cd97c84c337..db15323728c0 100644
--- a/samples/bpf/xsk_fwd.c
+++ b/samples/bpf/xsk_fwd.c
@@ -651,11 +651,8 @@ static void swap_mac_addresses(void *data)
 	struct ether_header *eth = (struct ether_header *)data;
 	struct ether_addr *src_addr = (struct ether_addr *)&eth->ether_shost;
 	struct ether_addr *dst_addr = (struct ether_addr *)&eth->ether_dhost;
-	struct ether_addr tmp;
 
-	tmp = *src_addr;
-	*src_addr = *dst_addr;
-	*dst_addr = tmp;
+	swap(*src_addr, *dst_addr);
 }
 
 static void *
-- 
2.17.1

