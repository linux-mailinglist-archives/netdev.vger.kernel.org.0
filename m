Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707DB4CD6DE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiCDO5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbiCDO5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:57:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50E1BD9AC;
        Fri,  4 Mar 2022 06:56:25 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224EFZuS011976;
        Fri, 4 Mar 2022 14:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hUDIcnNiRpkx4ACdSK5QyG+INBUXgiHjMtuU7PlKHuU=;
 b=nissb5D7vXCkM7b3UMa4Fz1zik+RCMIVm7xgOenj9WsXmV93siFwhWGz/SATMfQkwI9H
 2RFq5jw+Uq/3hFYhp0WQDRoKDoKQVJ9UAEwd8kdA138ZIC5mLtofJ5xR4TU/2Yh3cooA
 Aye7NnxXHavwBgvlxJkXFtc7jtRDlPZnLYfq895RSqDvDtw5WRnoqz+RmP8v//T/+pia
 OD7ABQ9+Drs2OPOMaYWsdWvkfm+imYZi2wl4V4zZljuJbI0p40QxzFpz7AXc/mm7oyOD
 QchFwX0tzOsyq8AgS6DbvAEoiZifmF5PUzWJRDAJIoeIUFeqgE0t+ZH1Hn/aKsT7/w5B Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvhxxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224EZTP6129989;
        Fri, 4 Mar 2022 14:55:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3020.oracle.com with ESMTP id 3ek4jh0869-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:55:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvPwjchPoq0rbq11DNrGAKxKlUb/4HpXg54sv2BCDbWhTm11PfSq7ioFAAVeVN0RPYEjwjZCPSuN48XTfyx+40Hs5Kwt/ADrph5tCfPL86dRUEwJ0Xf2E96eAHRMO8btF4wOaVaP/0mGWPlmEa1ncT/yDaTgoVvqZC/AyjE1g2Jf1nTzOcTsMm7iTtgCv5kEw1AyjvRT0+q+PEr4awmU9eJb0x81KO6X+smhRVPCaumQfGCOm20lrCUBEKiXEH18GHZ7Rgu/qaseTMuxU7PzhX72FQFPIZqPEdFKT4OjXIc++HTdPp8XxkWJVWaSq243VDJWBB+m5wT2Rw2WjWYpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUDIcnNiRpkx4ACdSK5QyG+INBUXgiHjMtuU7PlKHuU=;
 b=euBeqJAUz6Blp2zd6W1JlbXV7mJ64OSI+AMOuAVCYfyF87IQRa/F6oWDUbDI7XDNaA1zv9XZPjz/TTJOxHyAcOi9TvzFFYqwACEW4Agf8a+qxGqiCJsOdzDhydGQZjiP0SGN5krONc2eGgEBuFG2Exk5X19x1Go1/KYkOtHtc2rY7oo/aYtzXsm+rd6YqBwHnTUdAGbQXdZ1PJ+beD/qfmma+QMzSxRDSYKCSMP38ZRsRxvc95MqN8iRpo4vIeic1giYdr6LelL3crLDr762ATSqvPudl59plz995Lkx8TMlTiBqVDw5yIxQcMC25NJ1MvMQMJQauKHr2oMuBPcVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUDIcnNiRpkx4ACdSK5QyG+INBUXgiHjMtuU7PlKHuU=;
 b=c3u/lCyrZKikmbKcUNqFQut7qyqP7kqtXIYGsxpoAknm3Oe7M8yWwLVeEgd1AyVjqyNYazMAP7lHbFpVWC0DnCUHutfQI7pTdfKECdEqI/FoE3gLMm+/JZ8QIaUWj3LCeYELcPjiLh6wGunO0jQN6Pn1mP50mw4i4WBtrNzJkwQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3977.namprd10.prod.outlook.com (2603:10b6:5:1d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 4 Mar
 2022 14:55:18 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 14:55:18 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v6 3/3] net: tun: track dropped skb via kfree_skb_reason()
Date:   Fri,  4 Mar 2022 06:55:07 -0800
Message-Id: <20220304145507.1883-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304145507.1883-1-dongli.zhang@oracle.com>
References: <20220304145507.1883-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7078ffa6-a4c9-4087-dd53-08d9fdeefee4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3977:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB39776900D8F9645D1CE65DD0F0059@DM6PR10MB3977.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wBtCXJ3uFHtmAGOhcLBRD91d/7dERGNKfpmQQnT+zl5hs1l05Vh1JuHzC3eQ7SQ4CIGb+5Mkw8wgke9z01o9iOs2+4YUv87qb3q+ZrW9yOVUie9POf+gqYaIjBmc2NkKaHfOTMRaAYCgeVzTXzF9ZhAhkwRTJWrpFc256m0JHnBGASDSxI5vRadpcbI+FFaYig0j2MRLqtK7brj+H4OoKL/DooBV3zx2wCQFIaduwM+3SDBI9m0ZZ8ISAIfbAogt+JQt9ezDig1cuV6YpwhfQRb9jQ2F21UG6j/6jHxGll98bPtEZkQKllv4KfnLwR/tSNd1EzcBCfiPkfvtDAqnOctJwVqaR/TGKE+q3IqUK2TbqQt4d2ionG2ZEA6xKdtwu8x1U9kuQOxpGkbN2Nz6UCb1LNmFjymGSfYv4uUmnMFDuCqisywFNsQCYi+s/yiGXZPnUKlar498egnqVZw3QJg+nszZ5owZY7EwgRwYP0XJ1iw4S8ZvihPpskOls0MkQ6kBcpmLCLXjT0kl1Gl7LCiEXr22JimjAsSSCiSLeGEZbZ/gcnYFPYPUCC8fyepFkNkWpRCVJAOXSGEesM3s26+zO02dH6B2S7jmGN1KJifKXg8XkP82PsRNOHRNctntW3D/HSDK5Vvituaf4ChERPqT5XT7CKuVKAk6OdYqpoIqMqwdrU0P4JkWa5S36OcsBvgUSZK4e4/nhzQtYp3dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(316002)(86362001)(38100700002)(52116002)(1076003)(2616005)(6666004)(38350700002)(6512007)(6506007)(83380400001)(66556008)(66476007)(44832011)(66946007)(7416002)(4326008)(2906002)(36756003)(8936002)(5660300002)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XsZJFWYJP5Ilr0zPO6alzpVjzK5knGJVuCcOBaBQpFuRCPZtc4LJhx9p3vBn?=
 =?us-ascii?Q?vP8leycAarMt2nWEOBL2+hfo9Kc+82r1yA6QWsbk4vk/IC/RO83RYhN6SJUu?=
 =?us-ascii?Q?2rk+IfIzQJlt0AVm5Ysv5yIjxVi75l1qCOPoge8mO9O22GQZMQRBHUc8rN7n?=
 =?us-ascii?Q?5ShKNQjOk4bUZL3moMCKYDgYcKfmYj1fvMWg+y6q8d/8oyaKJNVr3bzw615/?=
 =?us-ascii?Q?RpBsoNRgP9RWoWHstjNuhCVgFM/w4/QqKz2GyH8KswFnR2cEfSC/JVrHdyl4?=
 =?us-ascii?Q?AsMBcvPHd/wZz3Qrv9jI1QhWPjSCs5AmyA07cuikxGcTl35St7iFZkxEOBEs?=
 =?us-ascii?Q?Y34PPvdTgPF9wZnlraA3To0GaFgBJgzreeZ1Q3VSOlbqfE4S+JGgnjVdaTJ1?=
 =?us-ascii?Q?nCp2E9zI9E50Yl1TZEs0zOrGoM8oT1U5l6GFnYvXPx0eS9ix+BlWEdbvcW6p?=
 =?us-ascii?Q?F+Jef/dwEieDZcsniV78dT5DPDZGAI8Tg6Jw0RLPt3obEoREz81WhHv0x1TE?=
 =?us-ascii?Q?PC+rY5A8Mpu/XatE9RNvdwG2165xo3N+5lSyGghV6ocHIRdh9iLNu59GphYS?=
 =?us-ascii?Q?XKyxZVAsmOKDymny8CbKp+xHhIWxr4l5LaGHUK0B70jUbACKQvxQ1rKIeHtR?=
 =?us-ascii?Q?mF/X/iF5/nM3nF6ZJvkri9Gm2bMFuxSXhSU3qesrwawvnpvzDVWLvgeizIP3?=
 =?us-ascii?Q?IytNv//L9rB5QIPawbb103peLVwKmwJITUrVdIGfYQbvx71UF5tyJUMESJ1a?=
 =?us-ascii?Q?zCoLMle5TNOKsYo4nzrAiNA6KCLWrkeYFB2eGzfvzx2fCbKVtH5IUryb0D8E?=
 =?us-ascii?Q?O+2Hsnq1IWi0coC2I/fmYKlFh1cV60c2P7RASGCK1O546YrYEx3mtyItUiTc?=
 =?us-ascii?Q?qF6zOuEJRgM/PiOisZqBZsFYiRZ2IYuq0wrvQsXykFKCrrJuCBRSyVHp3rvZ?=
 =?us-ascii?Q?PV8pdpV8yzXOYRQAjD5I/42nrgV1TxxIJmY83aeb0kSXS2kWv1s2yNPIfLRm?=
 =?us-ascii?Q?dinVGFhQx/PRck9O353wYeTXiLUCtzp2VkBI87AzLyKO3+0fYbRPT46g2SQ5?=
 =?us-ascii?Q?WLtchFXPg4rfe+GdU5+jRq1XOMNAnXNd4iAIA8LwURZ818GH+TARB97h3jmU?=
 =?us-ascii?Q?tmGA7tO72kFI2JWKsDvrMdvK/HgPfHBOPRVw9CToDDRrHWlxwUepZ1FZbyGi?=
 =?us-ascii?Q?Zq6JBhX83grMTASKKtyz796fuyxccEnbe5BZChjOFy3D/Ud9+4Y3nyeAppjp?=
 =?us-ascii?Q?vBIeS7yDoVEWNGiidN7jiDEq65neLYkqr2MfSAkJKxXXMl63E1xwd3nh+zlN?=
 =?us-ascii?Q?Hnt8WOB/8t7jKNkH9GCUjt1sVgm4m26hq+mBFU18MTiRG/8XOCu5wjFXwmR1?=
 =?us-ascii?Q?wQVuV6Rfc0LVnZuibhrbHS7Zq5Fvtv9sfGJZKavcUViXhbz1zda2JsvzXHEO?=
 =?us-ascii?Q?SW7bVlg8FzCL+H8fC/U9zzG/lCKtAWszBkY1KQSA8MnEWx4j3Fne3ecZOmlF?=
 =?us-ascii?Q?S6x6jzyKaZSB0BhhFwBrV1OAiZQRISEUUNDUm01MT/g6TGH8AClzyrMBroku?=
 =?us-ascii?Q?XAfUL7y/heyWHNf4Db7/zSahditsyqRyj577nwJTZ144yxyDZk+EQD0ot02t?=
 =?us-ascii?Q?uer5bnltpSjwB0kJYDwFelY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7078ffa6-a4c9-4087-dd53-08d9fdeefee4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 14:55:17.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xY9Zzbt8TzZKY309Onb1n9CucJq2gCLTbavV+Ewfe7brg2/+HAazETX5tLrQsd2+DnypaeeWpfv0z0NVrlyMVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3977
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040080
X-Proofpoint-ORIG-GUID: C08cUcD-gz7Btndm792AiSkD97cmXIWo
X-Proofpoint-GUID: C08cUcD-gz7Btndm792AiSkD97cmXIWo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TUN can be used as vhost-net backend. E.g, the tun_net_xmit() is the
interface to forward the skb from TUN to vhost-net/virtio-net.

However, there are many "goto drop" in the TUN driver. Therefore, the
kfree_skb_reason() is involved at each "goto drop" to help userspace
ftrace/ebpf to track the reason for the loss of packets.

The below reasons are introduced:

- SKB_DROP_REASON_DEV_READY
- SKB_DROP_REASON_NOMEM
- SKB_DROP_REASON_HDR_TRUNC
- SKB_DROP_REASON_TAP_FILTER
- SKB_DROP_REASON_TAP_TXFILTER

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - revise the reason name
Changed since v2:
  - declare drop_reason as type "enum skb_drop_reason"
Changed since v3:
  - rename to TAP_FILTER and TAP_TXFILTER
  - honor reverse xmas tree style declaration for 'drop_reason' in
    tun_net_xmit()
Changed since v4:
  - expand comment on DEV_READY
  - change SKB_TRIM to NOMEM
  - chnage SKB_PULL to HDR_TRUNC

 drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
 include/linux/skbuff.h     | 18 ++++++++++++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6e06c846fe82..bab92e489fba 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1058,6 +1058,7 @@ static unsigned int run_ebpf_filter(struct tun_struct *tun,
 static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	enum skb_drop_reason drop_reason;
 	int txq = skb->queue_mapping;
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
@@ -1067,8 +1068,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (!tfile)
+	if (!tfile) {
+		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
+	}
 
 	if (!rcu_dereference(tun->steering_prog))
 		tun_automq_xmit(tun, skb);
@@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Drop if the filter does not like it.
 	 * This is a noop if the filter is disabled.
 	 * Filter can be enabled only for the TAP devices. */
-	if (!check_filter(&tun->txflt, skb))
+	if (!check_filter(&tun->txflt, skb)) {
+		drop_reason = SKB_DROP_REASON_TAP_TXFILTER;
 		goto drop;
+	}
 
 	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb))
+	    sk_filter(tfile->socket.sk, skb)) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
+	}
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0)
+	if (len == 0) {
+		drop_reason = SKB_DROP_REASON_TAP_FILTER;
 		goto drop;
+	}
 
-	if (pskb_trim(skb, len))
+	if (pskb_trim(skb, len)) {
+		drop_reason = SKB_DROP_REASON_NOMEM;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
 		goto drop;
+	}
 
 	skb_tx_timestamp(skb);
 
@@ -1104,8 +1117,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb))
+	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
+	}
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
@@ -1122,7 +1137,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	skb_tx_error(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	rcu_read_unlock();
 	return NET_XMIT_DROP;
 }
@@ -1720,6 +1735,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
+	enum skb_drop_reason drop_reason;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1823,9 +1839,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (err) {
 			err = -EFAULT;
+			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
 drop:
 			atomic_long_inc(&tun->dev->rx_dropped);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, drop_reason);
 			if (frags) {
 				tfile->napi.skb = NULL;
 				mutex_unlock(&tfile->napi_mutex);
@@ -1872,6 +1889,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	case IFF_TAP:
 		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
 			err = -ENOMEM;
+			drop_reason = SKB_DROP_REASON_HDR_TRUNC;
 			goto drop;
 		}
 		skb->protocol = eth_type_trans(skb, tun->dev);
@@ -1925,6 +1943,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
 		err = -EIO;
 		rcu_read_unlock();
+		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
 	}
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 67cfff4065b6..34f572271c0c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -424,7 +424,25 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
 					 * header/metadata is invalid
 					 */
+	/* the device is not ready to xmit/recv due to any of its data
+	 * structure that is not up/ready/initialized, e.g., the IFF_UP is
+	 * not set, or driver specific tun->tfiles[txq] is not initialized
+	 */
+	SKB_DROP_REASON_DEV_READY,
 	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
+	SKB_DROP_REASON_NOMEM,		/* error due to OOM */
+	SKB_DROP_REASON_HDR_TRUNC,      /* failed to trunc/extract the header
+					 * from networking data, e.g., failed
+					 * to pull the protocol header from
+					 * frags via pskb_may_pull()
+					 */
+	SKB_DROP_REASON_TAP_FILTER,     /* dropped by (ebpf) filter directly
+					 * attached to tun/tap, e.g., via
+					 * TUNSETFILTEREBPF
+					 */
+	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
+					 * at tun/tap, e.g., check_filter()
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 240e7e7591fc..e1670e1e4934 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -55,7 +55,12 @@
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
 	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
 	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_DEV_READY, DEV_READY)		\
 	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
+	EM(SKB_DROP_REASON_NOMEM, NOMEM)			\
+	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
+	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
+	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

