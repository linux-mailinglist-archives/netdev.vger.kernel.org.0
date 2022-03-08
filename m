Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA24D2317
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350334AbiCHVNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350372AbiCHVM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:12:58 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BADB4D606
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:12:00 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228L6lu9001661;
        Tue, 8 Mar 2022 16:11:41 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3em3v0tcxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 16:11:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYDlzXJNM38j8BOY4Zhe3bypN3xeX55/DM34GTUnjUqJkOQZAcH/THZj0YyO7sFjJvQLiLKcPyZA9D+RAUcPfFXQZhP/eI5MC30tuIanSePyVZ622Sr91V4MLvKuIy+zK7eXdYEwi26926NaXBUlxUDxFulJ3VakPk0fNY8AjPZUXl0pU8/y1aAiALn+ggJSpXMY4APtg4C2198c0xPcy0UiO9yh4DUn2+jBagI3K0pzJ0h/MJu5u5u9+Rh/D8vE//pgCwzBGs+6AXRJD3+DzycTs+zcDJ7hVdhHW9QgLptwBnUv2XfBR0hOSacaGG1ZTX2qy2XGom0g6ilMyVYovA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlpW9xIsMG05UcOWSk5m03m3CbuvZMD9W+/I8PbTdCo=;
 b=hAPqypQD6Ht1kJ4PiQgtgG4vsf6DySQO+3pUQsrXG2ek/q+q7RDQ8IfWqpmmzGOVOuzFLa2EJ6s+B+8GmKJF2Imcc6QzKbbD4tG1HXtbLvzaqEdeuJlSEwNZwfDLRhUqnmx1IPWio8DXlrc4cTTlFzdB1+9PE/Cwn1pmK9ExV//SYOkiNvgB7f+VzIlkPzEnZcXrl8F9ShXSIesOx1cmaTKWNwYACx0A+QLej62n2TqGKyzXJQ1/KkNPwy/fEMivKF/eACCDY/ibRY3C7vx6Zc0W+5KOiKxwhgDp6O5i7auyvj914GAg4hxwE6LSyj4fXm8T6GJPPDMWyokfzCCbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlpW9xIsMG05UcOWSk5m03m3CbuvZMD9W+/I8PbTdCo=;
 b=hlJVanlkPQVdIOL9XlwEEvP4Mph57v6MpzsGPWZNKXZGZGKuPHwlgNu6kFIfAo7u25yucwxFz569KQ6aO9hUJSdynkbF+G/dDhxgfrLvtGpXdIvrCnw/Kz8Du3sHPXCf0y0Fxq8R+A1mru9aKGATxLhdAorJSjf11ccg8Ie7aV0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB4476.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:17::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 21:11:39 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 21:11:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, jwiedmann.dev@gmail.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling RX ring
Date:   Tue,  8 Mar 2022 15:10:13 -0600
Message-Id: <20220308211013.1530955-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:610:118::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f42e2b6d-73e4-4879-5ee0-08da01483c9d
X-MS-TrafficTypeDiagnostic: YQBPR0101MB4476:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB4476F01F085B5468C0DB5078EC099@YQBPR0101MB4476.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hR6xUabRCXVOiU+v9OSi80HCXA5LpF37rYKQ48qL3h1Ni8bGAuvOvieycGCLJje16ujEKK/h00BnxUFqaganRklcUUZIIdwaOgNBQRRgf9BPyoEkefU4eU5a+GI0Edg9ZwkYu00oVKd7CeaLsDtKdU7QAPRjVpcBY4ExVZ4dxKNKDzAsW6xW6+oN8SvKAIAhn8WOYKYEKORr0g5IVwZH/3aGsrZZHOTU+1tz86tv7dCyBO5mtrlXb4aT2Vwc2A3pBSu5CBAc9Kr5+qumKbgf5SPd+3wJCTqgEGU8vrUrk9X1Gu5VPXqrzFnKrg/zanMWLxUaGSHfdImP9nipwrl0UcIj6auTgkZwkx0my+8Vdq/R8+V/jNstbMareXM2gieMgxb9k7ho24OVAFxUhEKvoxZD83sFzKKKHXTsj/t2AR56s8TOLtDVU3/TobRo+eY0Zlb4GLff+9Vyi7Nj70wTqBudgwwCBQFQHkc3EK4hp2joHPQZ6ttBeoWdVIqZVqBlegGz9BVxpBlHBZnvYOsasXuMXUFHNUl+J78oBXR0FyLN9CY2eFASr2w5E64XVw0HoPEwsxIv9Opa+4qkdOsjAbo8hGRmKL5uYgfSEN9q7CZbWsLxrKSt700yKXQiZqNlbzsbwOUgYexctNb+caGXCwX2KtbE/XToWQKyqEga0VDXa7CSZDmfOFgDBWzksjSI63hgF4nHKKlBYTwcq0VvMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(2906002)(36756003)(107886003)(38100700002)(38350700002)(2616005)(1076003)(26005)(86362001)(186003)(316002)(44832011)(8936002)(5660300002)(6916009)(66476007)(66556008)(8676002)(4326008)(66946007)(6666004)(6512007)(6486002)(6506007)(52116002)(508600001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrX5Gfml3l8fA4Vv0SASKNTQPGAnrGFoTRUC0Wo358rhhqybKEkTefJNlExV?=
 =?us-ascii?Q?i95Jt2KWnm/8NSrIKuu27ak23WwL3HjNZc6BLbXEv6KVZoF3E5u1oFvQJFc8?=
 =?us-ascii?Q?mUEkhibb/In3MUyrF0BpyezLWqhIxx3H5vgkfHVlh2KNh4uuRNPHPcbADzy7?=
 =?us-ascii?Q?klx0Ro2uYVKrj+W09yuSXMctcVZ5UO/+uRUZjP1Z1oKoCJYoNWoeRElu+VFc?=
 =?us-ascii?Q?Yvjq15Mp3JM9D1+NK7ZG/uZxsbitbNu2o+wiryd+bIjBGevMP9GdaDx4FdwS?=
 =?us-ascii?Q?Q+b2q5USewcUOq+5W1V0tB+BJCGN9kIQHv3h+u8rVFmPmj5wHSgfxPjFUvh8?=
 =?us-ascii?Q?2OuV6pr3gUvm0qi2kka7O+prOigYV1KACk/OQeRvKGCnNZSlr+E8ifMcsvKU?=
 =?us-ascii?Q?u5K+ky1s8PkrHv1cjOrtvpvSzeGTkMGmaANONdVL78T9pelb5Nd5Uk3Uy4Wl?=
 =?us-ascii?Q?DnMNXLi/livFo0oklbfiXS8b9b53pie+KvNR8SjWlXCehpgj36M3gOWYhCKy?=
 =?us-ascii?Q?4Y1LXHhMKppCITh7MSc+SRZTe7oM1P/XpBVzgk5sqQxOinYDQEd+eEOlkSCL?=
 =?us-ascii?Q?1WKbJe7kYG7h/dA2VS0tYFCZW39qr3CdipTZHjgVETC5lzupRm/RZXMoMB8v?=
 =?us-ascii?Q?OtpPNM7CkAi2D7xy59nYyfmSewDHviPnzdsyuhxxu6HFSAhx7lmtJOmQ84ef?=
 =?us-ascii?Q?Mla3g596JiazDgYWEmPIjYUE2ASxZt0mNKJiSI7YnntPxWkBv61sxZHxhKvA?=
 =?us-ascii?Q?TOEzGgvVzaDjV8ZuXLnuqcPIFafbEMbFjVDcgt9R87Dkbzms4gCxhEvXE92N?=
 =?us-ascii?Q?j40RqKTOC01ZU5irG41QTUJPaEVic9dKHhoNHXkeo7Bz0sSedf8qY0KdQQBJ?=
 =?us-ascii?Q?ejChsR/uQSof1gfx6Dzzt5HeF5FJVXmACqnnGIANtNtb7QPlEngbeDocA+JL?=
 =?us-ascii?Q?r0mD10iPCyJ6Y4qhU1Y7ej9GAwjkxbW72FjFPMyDH5oR6J5HckO9brFcKNzG?=
 =?us-ascii?Q?YnJcbMArEtAGBfbCwcE+F+WeW7ndkMLwvUAOszgYASlWAG8n73qC7uE1G0ih?=
 =?us-ascii?Q?O8hb8rNvAfmxyLsD90XdH+VFWlt5qdbKPVpJaqLwbMzR+CsHRhOHqRfbivqF?=
 =?us-ascii?Q?j6pGbD4aftUbNhPcyriNO3RhJ98vjLakNoQLSIcY8fz2D8bLrVo7XrmfqAOi?=
 =?us-ascii?Q?qOfov7QV0qKWytTnqLkuTU5YT55XYcn3TBIO70F4nokLtTDg+FZ5Tqp2zq5A?=
 =?us-ascii?Q?ADWZb6xuX5dUpXV5/AUk22kfb3m8Zsdir7Jg6Rgm1MMUxtTU4kYHZ2t4ANB4?=
 =?us-ascii?Q?noO1PxxBro6IuSHH3gLPhx9IapllWgW7JyBVh9VXnacmhdgN4uLrSl1pOqb/?=
 =?us-ascii?Q?55YfYQec1xbqVHpStjWsTMaHIuHW2Fdxf55qiYBngXDxvIYcDFq/FbPEzSPY?=
 =?us-ascii?Q?oIBpMugQhWJ5kVzajsLu2zzcIj/HvVEvH1MIpMP88GqxdrGOAxCXkPdGdsuN?=
 =?us-ascii?Q?IsOakIvTnlA84YClRkz/xBHP3LatHw+ASBnnNNrHe9Zw10Vtp4hZU63FZPec?=
 =?us-ascii?Q?0cVPF2Iz2ZR3f/wfhAOXVuLyAATCCP8VUgN5ECg/3Bc8w6QCSVPllDl8e4ny?=
 =?us-ascii?Q?HFY/dYxzLbgVO0AxeJHNjRcYSZMEp7cQtNmIvExN/6zSvfNSYkI58cz0s1uw?=
 =?us-ascii?Q?nMQrZA=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42e2b6d-73e4-4879-5ee0-08da01483c9d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 21:11:39.3984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/Avz/42qodUa22O6g0LczWIN3YSYTOwdXKQWnjAqlDldrPriDzo+h1diZk7WwHBCjv2ZqP9dSsybIoKUBcVM0LzAQF4KSjWYSDMxmlVfRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB4476
X-Proofpoint-GUID: d6YnVDlSjGLC-G-N9gv5jFiRQFO2wVgU
X-Proofpoint-ORIG-GUID: d6YnVDlSjGLC-G-N9gv5jFiRQFO2wVgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 mlxlogscore=438 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080108
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_alloc_skb to allocate memory when refilling the RX ring in
axienet_poll for more efficiency.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a51a8228e1b7..1da90ec553c5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -965,7 +965,7 @@ static int axienet_poll(struct napi_struct *napi, int budget)
 			packets++;
 		}
 
-		new_skb = netdev_alloc_skb_ip_align(lp->ndev, lp->max_frm_size);
+		new_skb = napi_alloc_skb(napi, lp->max_frm_size);
 		if (!new_skb)
 			break;
 
-- 
2.31.1

