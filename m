Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF343BCAC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbhJZVxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:53:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14022 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237347AbhJZVxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:53:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QL5aRf023930;
        Tue, 26 Oct 2021 21:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=WVao05kzzV0w2ML2+nZmgic2uNDo3FJ36/2th7L4hTk=;
 b=VZ145SuP/4aosc3bnh3yIjnR8i5lEIVsn2QRPKR08hiZyG2YH5eZd2w04hxKNcZ7Lv9Z
 MLmaZuz7TDIQ+GMExJos6x4rGShVS6thGN21ZrkasRNGQPloqnuj+3hxi4LhKzsw4bi5
 nBpfWKd79rX6bdXHvVkXVEmyTKMWq31mQx2Xq10l3Nn/1GFTQTszjTjWl5DAZhx/29dI
 NXDk/w2nXnOyy1067AwcwSujGzLcygZxR/AjSV8CBpSs8PV9fXmqGcI+x7HFQK0clU2X
 v4Nw9PY68LqrykrGFgAmue6aJwF09eHstPaF89TL3CgyRykgCJtI+22nU3kQjSItANy8 RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhysny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 21:51:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QLjE8H169797;
        Tue, 26 Oct 2021 21:51:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3bx4g8y691-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 21:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOqgQzfvbuIW5Sj+KOHMTWChAwPbpxgOgtonEMUE1FKgqqZgoQusODWjnuR/6v3SltMxBssWtkwEO9jPpTuGVyB6xuhqZpggQAisOvZPkhL2+9AmZZBqMEmj/52klhxzvoazycVZH3vKvpxYrn0JpVOaJdhusWYrGa18LZX0pKo7mIW+fUJnQ4BWlDl4y7sQhBP9b7AdUf7rG2hotditoZCvVb4CKYsyUO7BJWx7eiMrR9J5AgnPDl2u+v++w+BxUojkAxLd7YfZ0bXGxzEO60+AR0kVt0OuxKQH3KnIfy6o1uZkWQg9vo4l8N4XTpzAdpyvSdMjSFmch7LhBa7oVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVao05kzzV0w2ML2+nZmgic2uNDo3FJ36/2th7L4hTk=;
 b=L+way9SlwME3UV1/Cl7vEQ5+kXAZFTZuaLT7qQ83LN5Bl1gMXRX5FOz6Ls02U8yOUUIzt+UkVm8mPcM0EVYXHRLk8UxlefuxfJvZna+lX99PnIl+OxK5IejJiYQdm47s7YdwY2yOIX0xvo8v+iZui3MLpo306mcs+A3wmONwGzZzgdna22Q8k3zUOYUs5bJ6807YtaVe0iB/5t4TAccSrnsrltk5twGbD74EjkWbuOEx6m2WDs61kNN6zdoyZiuRKj1KtKOZ3g1y0nuo/VJI8vi4Hx66s/5MqdSNK3PwAPhhCVcrmmKKnBXekWLZe+f4M4L0N44psc8MCL4BTW8vxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVao05kzzV0w2ML2+nZmgic2uNDo3FJ36/2th7L4hTk=;
 b=EwrUu/7kb8akekp/AXxsJIaOy0kyC/cQjgf6a9uAIdEjTwYRIjY1Qc42TT9oC5mdLAzkyi++OSnDrS4yj9Dwpr0h57xPSWYxkikrMfIUgFu9/jJ2cSG/0H/0HhIkwORVWlmnNOe011nz3RmfvpzUXTxXb1ttzGVmPc1hiuctO4o=
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB3985.namprd10.prod.outlook.com (2603:10b6:a03:1fc::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 21:50:59 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021%7]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 21:50:58 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     pv-drivers@vmware.com, netdev@vger.kernel.org
Cc:     doshir@vmware.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] vmxnet3: do not stop tx queues after netif_device_detach()
Date:   Tue, 26 Oct 2021 14:50:31 -0700
Message-Id: <20211026215031.5157-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0027.namprd02.prod.outlook.com
 (2603:10b6:803:2e::13) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
Received: from localhost.localdomain (138.3.200.16) by SN4PR0201CA0027.namprd02.prod.outlook.com (2603:10b6:803:2e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Tue, 26 Oct 2021 21:50:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b74fdde-1cbc-4a97-9d87-08d998cab1f7
X-MS-TrafficTypeDiagnostic: BY5PR10MB3985:
X-Microsoft-Antispam-PRVS: <BY5PR10MB398561E351FBD7F1FC7FAECDF0849@BY5PR10MB3985.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4kr7NNkofVEfQPWd/+JhM5rI/eGIJtrnvyQINIKY/iQx3c8Bt6eIcr8KgA6QYROFGHhRzvEJsdCRS3PDtwabpwAtt3XvEect5Vtg//SQHYV6oUyY93/00DTCwVa2JPQDV2fy5FUk9RNkS+2UmY5d2pbpAqUGfZ0/lcyRYoHeQfPQpn6eesE/Umiyc0KpcR89B2kT/iLEl6F+6WEll7fKgfeW1d8Sg/ZC1h7+z6dmug4YFdLHQDtvCCKdOGTueXyr0MLQNzC7Z5RAccHmxxPhaP29HucuvfFnsgmSQpvIMzhUHPHcNm0ZekkT+Ob4yESIEFf0hKXHZ/Sybu4keLyVuCLiBTmettWXKMFHToiQgTF7iCEW7k12gGPyvveRAJ//gIfnoLMUh4NiCJnBbNihhnsVHt+fvID6flxfNBzUH9zAgSmOJ4a6128BZnuCml5P1KO84NlWPnTcP6yuhuC1PkjsVyy4mvHNKTPjKZB16s1BMcG9Z+agihBTFGGs1pr7nQZTYxcdaXuMNBh4hbg8hT0FA2PEen1O1CF2G/+OBDnfLGmaCMkIiUnRocr+UIpd/CpoGtjLysFC3ZDC6UDNE9kz1Zfw48VAE4GtRQlrneeCjiVD/595F7VljdB550GNRNQ4cTslfRKu4qelvGniLtM7mQoZFjiBfCLEH1x1LauYBv9iT+pm2P2w2yADdjHNBwmGWy2CizoFhrNpRuhhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(956004)(8676002)(2616005)(6666004)(6512007)(44832011)(186003)(26005)(1076003)(5660300002)(86362001)(38350700002)(38100700002)(66946007)(66476007)(66556008)(36756003)(8936002)(2906002)(83380400001)(508600001)(4744005)(6506007)(52116002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YEjEvEkEhRtgs9x5uSsjom42qIhSljM7hNTePdtVLmW3pVg3taST+IYY32Oe?=
 =?us-ascii?Q?egH0CZXOn6sHDfiaFN5F/HWMb/rUi3WDDn8rJNOCbWu6gNXhTp8uNuH5cVhZ?=
 =?us-ascii?Q?9LYKQkj8qR59qoBV9xcoRmnTW4+hE/lTl3/TAY7PqahZXa6skh0jKfFDLHoC?=
 =?us-ascii?Q?9yIIfhs9xrbzbVD9rVy9ODLFhlKea5eV3ek8qZfXPYlpvdl+xDWKAVVMgxDv?=
 =?us-ascii?Q?zctGDzSlGdfUyjf0e3G8Kyg/JoBSF5DHkUz5fjV/Du0te2kY0wDUXnQcO9qO?=
 =?us-ascii?Q?EPZqQQx2XmAIF0HjgTyhZXhPme8ZqL4PI4fEy6O8G7Hgv26566M958sjUdeQ?=
 =?us-ascii?Q?omXGCgNqEiKiO41wZ0OGwSkEdjeM/bdpURLejrcdX+DELyfexYuIFTx7ZQAw?=
 =?us-ascii?Q?PlYhWsCMyivd+dVBqnBUBup4tkWp0wtq13+/xqcHDUot1Q6aP1YyXgOCQ33B?=
 =?us-ascii?Q?7YSUrNaT6BgUGHrpk9hrbXoXfNuc9K82gM+9ynU9cmFNufWUccKn/EdSCYAt?=
 =?us-ascii?Q?s79dHpWmpcnyqcS5htM+o8SNAiuVczMzdaPDwFlhkPBIAjLSotr4ZkEPKN+R?=
 =?us-ascii?Q?Hq2GtaRoXlFdUwOeZTDyMvufTdtBYtnzrLuW3o7dgMbrd9ne3Ei9Rf8vGX9o?=
 =?us-ascii?Q?YFmw3ckiDPt1xb0WSjIFd/vf5Fy3kbY7f+Ot4ymXPtwGv98OPNAynK+BySnr?=
 =?us-ascii?Q?gjRN2Zx/qtLMYCoeh2yE70KeFyn2vg/O3eruTuGFHTtnN1ZNBfbzwwQs5WF0?=
 =?us-ascii?Q?0FSVdpn1BwqIOG1Ncj79PbAeQenMwTJvyB3WkgwwqcvJ1H5AeaVxAWEnebgt?=
 =?us-ascii?Q?UpZPX/f0geCLIpq6FUYhlLQ2+W9khgfyTgAmcqjuNsn6ETwLljyp9XfpmuM0?=
 =?us-ascii?Q?0GDgW4vFLpxfBZt4I6p71i8BXKIcL3ij67HyYbVqHamPI+xcMTfwmN2kV2kj?=
 =?us-ascii?Q?i9s0303xa6V3a8GJ74oGqeIXpgTdrlW6QUMdZSoKKUrpzoGeUiCweFN6prNi?=
 =?us-ascii?Q?yuvTw3FiFYrAoxgNuJi7tLi4q01ugbyAoZE2/Fbc7AYZUwAMPAnVsNGp8MDZ?=
 =?us-ascii?Q?z5pQxTyGH266i2Eu9wi/srtSY4fbD6F8IU+aoWu/XI7u9070/iFSZI0nX3dN?=
 =?us-ascii?Q?ZAtsOOPn7SOT/JMjUdEWNE7dablPk+VX3XfpyM/IJGlkfmXG1JJ/RGfm28b1?=
 =?us-ascii?Q?0TDPzJfyvFaDbQoO5ZLqo8AYteZPBgYQKQdHffc52cbduVYYNCFPZ5A1zmSP?=
 =?us-ascii?Q?aIywzOBzJj3jLGPcVHfILu/Z9NPSt34ntdHhfRHLbX+1wCQW3ZakXPDLX2km?=
 =?us-ascii?Q?EtpcqqwpBcDLF+BhgBiXfo8RjXaQNPz3NJ7wGj/ErNIOk99owngIRCHRmy7S?=
 =?us-ascii?Q?iZV/OygglnNAfZzbivcDU2qVmICV0wQqj5/3bpL/0qspp2qW0UueYfWg3TLP?=
 =?us-ascii?Q?Ae7sPL8F353ZRpnZJ3AFTXNcyTM4BGGnY7HEOksy35ydoNhql2ifO1ghqjk3?=
 =?us-ascii?Q?5W4uS696SXIqEotPnoJHKnbB6qXU9oFbllp6V5LCioF4ur6e71RdQDAmP69s?=
 =?us-ascii?Q?StI+j4RpOvyGM1S6JkbEbnHwGGv4Q+AE9Z8NdV4wWwxvUHBuj7PtOxB7T6Nb?=
 =?us-ascii?Q?mligD7rswpfHWMtf/7V8CSI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b74fdde-1cbc-4a97-9d87-08d998cab1f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 21:50:58.8295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWP1krO9gpGxYXwmxjkg5TkCU/gRvuEpwWpMi3BqiL0Qk4hCeg+cJ848F1MsABQVxHPdWoPtQfmuc4aKK8RYYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3985
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=952 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260118
X-Proofpoint-ORIG-GUID: XPxz6q_ZuwFhNtDzur6OdHMof5tctrnX
X-Proofpoint-GUID: XPxz6q_ZuwFhNtDzur6OdHMof5tctrnX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netif_device_detach() conditionally stops all tx queues if the queues
are running. There is no need to call netif_tx_stop_all_queues() again.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
While I do not have vmware env, I did test with QEMU + vmxnet3.

 drivers/net/vmxnet3/vmxnet3_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 142f70670f5c..8799854bacb2 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3833,7 +3833,6 @@ vmxnet3_suspend(struct device *device)
 	vmxnet3_free_intr_resources(adapter);
 
 	netif_device_detach(netdev);
-	netif_tx_stop_all_queues(netdev);
 
 	/* Create wake-up filters. */
 	pmConf = adapter->pm_conf;
-- 
2.17.1

