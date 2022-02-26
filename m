Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A054C54AF
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiBZIvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBZIvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:51:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E23888FB;
        Sat, 26 Feb 2022 00:51:02 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4nBDN030117;
        Sat, 26 Feb 2022 08:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lWoLkNbmCRYkrhzFNc2KLmkNx5lb9VRFv/GA2vfSrRk=;
 b=fPc7vDXjfWjIbwnSdXosya6wV5ydFYR9Tsk49PDSLv2NLygtFtm0ps2xMjBV6Et9a6tO
 DsJXFmUWo8S/mB9opdZ17roN9MFzA3CDWq+mXvFgWge+6fL2vWyGq1TyS0jRS2GVcow1
 tr0KjqKf4bKTnMZ2HxvJ4j5ptdcCq2ui6OZoVs3xFEmml4qXKIv895aej2GwYT4nMngI
 X6tNjkRD4k9mgMAThwl3V8rkffOwNnOeMVmaGNtlAPDN/PxHk4A1rZkXYqiy/EHmDr9J
 5ew2bBPTs/h4OekkLxYCrPa+RccWgw9f/5QZFx9YRrYrUntiSP3ZUTeaew8nmz0LvATq zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamc8eby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:50:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8kO7t005020;
        Sat, 26 Feb 2022 08:50:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3ef9askqdw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:50:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtO4bBUnVPP7uFtOb1SBOWh8Q4ubZVg0vYwY5Z7HMz80PwdNypoyUYvgKLyhmvXuW/t6Wsh6bS06eKYfQ235gAeoluFd4Dz2hCS0oKIcrOlM49FMP3poD4vXw76h61rwFtc1VjPP6ja3dZyHWcwLwG1+cKzgD1Q2yJ77VOY0xfoL1mLUylwF93BJbKpxmxSqBUKxwnLBMUfPwsJngr8aZEmSqdsL1i7I2DdqWmsrNl6IBDP7aPAnhOcVnQ6Q1smK3aLT6N0uOzCokl/hGop2+f1ohIAvfiNMh4pT668UnmSUSuzpL2QyRB48LKQZt7MjZ+ECllC7LXFGiS1TBBBLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWoLkNbmCRYkrhzFNc2KLmkNx5lb9VRFv/GA2vfSrRk=;
 b=ktvaAyTFdbs+ilNgQ8N7iQOOX9FjLbJfcRAh7u0AF6D8juJpsETUZH4+gPnRevEE5YE/5vTd6TJiSAH+oRD1vbr2YlJDsIyFxIA+c5PsSKl/LYAz9ar2Qdzx2F1DF2xeAhdY2E4XzHKfoAnnL/bHu7BO649vW+1BTEWq7Zv+9GyvGrC3J87MNVExj4D2pKkm8fMMZ+xgcCSwS7Ea1IrZJvIze28eDzoLS1/akattukSKGRA3T+Pkgh+TZfbbNNvvBYRZkg5nQvDK/13ZbSQyy/1HaBQBorVZfhSF2lUStvKb5q0GJOlmorvrduoeD9xREDnmWdJgmP0z+X/Gwwronw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWoLkNbmCRYkrhzFNc2KLmkNx5lb9VRFv/GA2vfSrRk=;
 b=pjv47OVz4XU/fqo94/HtFT8ZOoVPztppHeeCUxl5PHiiJcShoDeDgZYVf9WFBK1u/U5JaazgzdhOKHiqvGim2XFlvA2C+CzoB8BXWWz/RpgOIIqSC/GO7zznVVtTx9iJ8WOtQScYdgodOGvpCUxIFiZMNoNWnRyLOxpZtPBNCII=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:49:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:49:56 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v4 4/4] net: tun: track dropped skb via kfree_skb_reason()
Date:   Sat, 26 Feb 2022 00:49:29 -0800
Message-Id: <20220226084929.6417-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220226084929.6417-1-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b761cc9-2df6-4641-99e7-08d9f904f63a
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1768B3243C34E13F435F6A63F03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duMATBpFf+QDz4f5uYoqQfVruNYNs2RweqN5EAbEoA/aS11QLZptWC32rs4NBjAJgVkbY2Ok8W6yuSZ+mXe+NTAOoenucCY9AyLhxXhul98nkAIvPQxfg4060obzX8+RImOnL8/qZsoYgO/eENzVLI78HLfocfOeTWq2iBMz3WnrXuf0LuIwETStMF+aO6nGkn6zKYmt3fe2m8yPU/FGCkcUI4TLLF39H8qAvS1Y5aSAJRV6X4IaPyxkew6hzYeCOzsK7trHmiOt5ENdjA113MZ5KNAT7ocbIgONH3km1g4pykCqnVYS1IJ2nbs2bPxCXKuPb6XWDi40Sidmb0IqXayHiG5xazHk3esX6OsI3I8Nd8Y5ApSjoRO2CCGT9mp/dUQguULnSbjcF9rC5flYr2Dluoel+JPJjAn8vRsXqDj/9kmYQcMA9cFg9s4icc2RQV0IZ/Jobo5rXBFo10D4il81YdpTkQ4LE3fJ4Ta5GKR9HRPthKRb+wOqVVfVz96KUCqX1k3ugDPR5popC1cKi6uf6dI6Qp9XEeE5hh1VsJaijwIBa61WugjBcosnBrCi+1Ulyz560eDPUWcaB1Ca16dfwi7FS2QDYSzm0ghTh20tc66OF1lDfayQtsSekmItVENZNLdE8rAKcWetbdPJLi1MOxN6pIB3u5+ILj8OBBgjX+JSWKUSnv6GWpa6yzw37uaAEJjC4PqKEB11UJe+Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(316002)(6512007)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(26005)(7416002)(1076003)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38350700002)(38100700002)(4326008)(6486002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GCX1iIIDEF3yQFh6gZTkGAmR0TMYRhneHfk7w8r8XAAAEv07cMtpuuJYRRTp?=
 =?us-ascii?Q?UcU4/X87lIodT4z3Hl7PQmnKpHRZFZvhGAql5U3ReF9FvYjWFKjBVEbAyndx?=
 =?us-ascii?Q?55/l2kEKY1qSlQ5JMJ0ouOag4uDm9K11sVQc9yqvaVQe3MORHgqSnDEHudj4?=
 =?us-ascii?Q?k/2HDSw+hpR809obfWLww5WFA9U8ygEYj6X6VLkHD3WijfhDy9j0jtgAmJhU?=
 =?us-ascii?Q?/aWSrOj4CtGVUANe3+mYUH+3rII6aqNMavhJSqxeQ/9VQYVd/lyIATJy9wKQ?=
 =?us-ascii?Q?VQBtHGt+WMGabRXpylqa2Xzbwx6Yxi0gOj1duYYTCUehX0QdFOSOORBqLMq4?=
 =?us-ascii?Q?nNbFSbm2b7jCpsHvL77IaNGHYx/YK+77b7idbXcIU5bU8br7gZgtzlsqIf/R?=
 =?us-ascii?Q?DlFiixQQmstBtlmV6oGowDBhzYq3hDi0pk1N9OiSZGHSSXcDjZ0jscmOl7zt?=
 =?us-ascii?Q?auj86/O0tn+1pJ3VlumjeoCarIc9hVtW6c3hGVHxqf5MYtBhEFDnPJOvCTq6?=
 =?us-ascii?Q?0JwsYtQK8abS/KZ792vv+lQsOgyBWl4AozbSKNEkWesx+peCoaCML9jdY948?=
 =?us-ascii?Q?GBNJ/FCs2Vr3AsswkGbh1LOSw1cjFsr8XZ1s+wPga5blcK5e6doxzLU2wkXT?=
 =?us-ascii?Q?MtyA40dhEFM6KOgpCKLEBFiAhbPT7ksT6VloWWXNr05Buoy12pOcPzKRHrK8?=
 =?us-ascii?Q?HanXF4JWpu20SfhrVf/ghdTlymGzY7DwANKtmHbMjXuhJByegl6a2zu6P+HD?=
 =?us-ascii?Q?q7g3lc3MHmGJhZKMz8ioHDrI5jr/Qqr7zeDBki+jeu47rTFOyhK/DVtaViOg?=
 =?us-ascii?Q?uezlpivEv7NEyEcjGoKpd4bf4+4VAAnJCZW4udg5hbQf6bC+8cgIoudKSfNx?=
 =?us-ascii?Q?YbxNGJLezso4Eer3EK49Cbh5Vv7eMmlfHlH9LWpSZd4qDV/iMUN/lcDP4lfB?=
 =?us-ascii?Q?/IFclvuxIkRDiaYh9LuCnf2GOtx/qgkzriFDYEdKGh8OdXv3rb/gYI1lJCb9?=
 =?us-ascii?Q?/d2rBEv4ensNjwOksCiGMvcpQ2v2knERVTLEcttQPFniKjYE8u6CBLkQMuqL?=
 =?us-ascii?Q?H3fGojAieRaJ57mWBFdSQ83prD+MK/KyE9dUVlzurtlKhZbbpqB5hFinMii/?=
 =?us-ascii?Q?Tfk1DUzTtSOKVDD1C463yC18/ogNkC3FTnV+QZbJHx2LAOMxT6JsSIAm0WyD?=
 =?us-ascii?Q?PbCHPwRzic2/bo4ipyWGxCu1odxpPfibHbshlVPDV+YO9LM3btb+hDnATFkA?=
 =?us-ascii?Q?y/sBk5wRGmtgmk+Nt9jLbVOpShm3rN3nN6+qgO2KMwjQ5+7Bu1VANXgobp34?=
 =?us-ascii?Q?IPrNwxEhSruykZu1Wo+9x+yknuMb3LFRw2VqcjqtSbU1aGsbVQhpMnv4J+v2?=
 =?us-ascii?Q?+A5gmALysex5ZEHXFN2DP8xZ3h8pyA+6OvAp+O9ZjGhu5rSFTJ/5wLRhMWWw?=
 =?us-ascii?Q?8RI+jRlR31xwnb32XGsEfJKL59AS2711fPUqjvdJRgtRvUItZyaTzMeFlcK4?=
 =?us-ascii?Q?Eascl3s8NS3FOWCn9F984QYvVkxIuRMDlrlR942OHBUh3/axqJv29MdXAo5w?=
 =?us-ascii?Q?VPWiCGVbjw9AeC1cibCtCoBf5Lm1X1ERaeEJYe2dtaO+cPzjLACoSi30gPqZ?=
 =?us-ascii?Q?S0uZD5pRU8/YmVMhb2RclrQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b761cc9-2df6-4641-99e7-08d9f904f63a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:49:55.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TSOmg3mRZZCTvXGfLs2Nill7ChPst2bocZVykLDRyJ2gEUUlhKcIb5HA1QgKlkks/OEz4OmCSeEXDud34oGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260060
X-Proofpoint-ORIG-GUID: r6v3zIlrAYhklAweXJ4_AtLcag9pUhiA
X-Proofpoint-GUID: r6v3zIlrAYhklAweXJ4_AtLcag9pUhiA
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

- SKB_DROP_REASON_SKB_PULL
- SKB_DROP_REASON_SKB_TRIM
- SKB_DROP_REASON_DEV_READY
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

 drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
 include/linux/skbuff.h     | 10 ++++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aa27268edc5f..73ad2bb5e8ae 100644
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
+		drop_reason = SKB_DROP_REASON_SKB_TRIM;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
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
+			drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
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
+			drop_reason = SKB_DROP_REASON_SKB_PULL;
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
index 9f523da4d3f2..9a0a15a31591 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -385,10 +385,20 @@ enum skb_drop_reason {
 					 * sk_buff
 					 */
 	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
+	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */
 	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
 					 * device driver specific header
 					 */
+	SKB_DROP_REASON_DEV_READY,	/* device is not ready */
 	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
+	SKB_DROP_REASON_TAP_FILTER,	/* dropped by (ebpf) filter directly
+					 * attached to tun/tap, e.g., via
+					 * TUNSETFILTEREBPF
+					 */
+	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
+					 * at tun/tap, e.g., check_filter()
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 5b5f1351dcde..e8dcf784ac17 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -40,8 +40,13 @@
 	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
 	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_SKB_PULL, SKB_PULL)			\
+	EM(SKB_DROP_REASON_SKB_TRIM, SKB_TRIM)			\
 	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_DEV_READY, DEV_READY)		\
 	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
+	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
+	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

