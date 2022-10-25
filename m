Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89F60CE40
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiJYODN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiJYOCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:02:42 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69D416DC25
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:00:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+xOH6lQ/feMXuQ+weVs2D3ZV6pzh0w58MEVzOEKiatzucD1N7FyVvCdh3vbGweG3yBOE18moRmeMViktJehPO96ENZH/yZknyrrAXso5KNy+wRIR1FrEBxNEUE/J6w5Mkr+KD36EKZ1Ofr9xxsnRKmkv2k7+vbeErZaj5OsM0RkoaJjbECvLkTjSvkRjoqdoL1h422iXtkBM8RKX8csQS+GePkSMigxbrOoDaUZF4/v4zWSsYC7+WBp8RijSx/SBU/58B60rC62f0c+ahdJS5pUJ1F7kdlxTwXkR50EDWER/CvCk2n7c3xCxHX4pl/2hiuagKTFp7O2VUMPTPYhzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/v0D/UnYXIrUJz5fgoLhWiuzfaySp+DbGaXSzBoE0c=;
 b=T712DA5E7f7WlV+z19MzIOPFZzs7XaQm+xa1q9rGLrdmHayWjzq4VYZPk7E5Ia0R7sAHhBHqPuTns0TSTi0RLSqJ9KBEDXWpnNMDVO6XtMawqYWmky1KNTZ1rf7wJpP1DYejGv7PLugSQFocJUPc40tCqcTSEvH0aLlyXBo49ikDBnNrXbVNFUx4vHD1uheJWC2pahwgKpBujl5l6+JK4gB5OBEPnO8/CWQwMY2hhiUnZENyg4lUA+td3zDSlV/awgtKUJ+u6phWE6Tg3dfTUNFk2GZU2ZuTwbXawjTGSQ5HI2VMQnV5c2n0Hh0vpSJfseb5Ncd2daJBONGA/8bU5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/v0D/UnYXIrUJz5fgoLhWiuzfaySp+DbGaXSzBoE0c=;
 b=NrbZ2ha+1NNJ7XSbkfticQxEi98k4pDvcNW+6aCln0gkzRVqX6j7ttJfBdt6Mh5mtJMa19/DUeN1CUaDWUEd2BBuaDmVYoHehF5qBieCp2MwGGZFe6eO0hjSUllyqMyMuHvAZoSyn4Yd87iL8hzXwrS/YiaVZxdezM4XdU88H/22I5a5Nl7hntUwPlvGDxv72/yrktYU0XD+P3Mk7yIddtBn2no1gOycgvFkgoZ39jyEvcsxW2jHAogCTSCMlzJtWK3/ne50zesSJ7CdjQ85DwcqwEb1lTkIZoH/KkuFnMWkgC01SHRxq+MP0r+rTNDy/JwuItp8apJc4FAK6IdH+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:24 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:23 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 03/23] net/tls: export get_netdev_for_sock
Date:   Tue, 25 Oct 2022 16:59:38 +0300
Message-Id: <20221025135958.6242-4-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0211.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::31) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b2bd992-6ea0-4117-10c5-08dab6914305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASyCTykCbTc6jG0UALZyMgwdX4TXfzQlM6VJDEZ9lVE+E1IoF4qnO2t/lnVhB+pMnP9vIOwssWMvPLo9aGqHRGUH7l9YEvknx7xHv8hi6bXUoPI22o76EZ/KqWn2KM3lwgiFwoKez8avCeE3qrlLwgt3zVRU30fmoSr4SXka/BxAQCXGfE26KtLZEzq+JlZ1jmRHn3Z0gO/tpOweGqmRh7zzDMOtmjYpJj4ukxGUYtXyAXt6rU80srhvCrZJUrfixFm4IYs8/pEXeUidOLpoFvZoMsfdqZKeEe0AvVBJdER7bLIxFhbUvxsNCloSyjl5r+IGr93Mki/07C0WTIdnSaRk6gDYj8TMdUHtvA7mB2r/bWSepOcdObWXrNr2yyd2/2OHrZYSYqDSwGt2sPK1bdFxOrVzvWQWfOdzXZCXp0voG4I4muKliot9OMm2TKvIVDZFCUvOxqWgE6ws73aHfkpaCDGdHhrrBxMWIs3Nhp14S5N1IEI0e9ubYJnVD1CFocYyFVUXiHKGAjcD7yah0bTo923iYE1lnKmjkIfYQq3qFGmSYcXMOXvLOeqHQeuXdYxJg2jglTMDRSrS8keGC1dnPA3ifcIR0+cJ9JGjqXFQF5tLyVgoQmp6LsvqliweRTR/KZkcXZTb4u+2Y05aAqEebuSEUxXE+d1jEN0tB1KY0tbVD2tIzwJTHPvqs/E0WtLFGpvR4hpUEsRSHBDYarGNE9edTEK7tMfgVmQIljcG5y/AFq3o1cv/Lr1Qfkva
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LH57ttiHV0XIwV6oa8ahLB8v+BEC1c6QKe6c983QG0SRf+Z7Rf1JP39m6R9k?=
 =?us-ascii?Q?cFcby36l9dxWGSAcFwkS7O2ycWMHdpoyPRVL1qV8zJnZJj06rlzdOZit9oNW?=
 =?us-ascii?Q?rj/RIl6Invbb6VYwpe2aZ09r0PMpA7mnvE12TCIhEapX3yHKtEqThNvf7i+X?=
 =?us-ascii?Q?pTz82nFn7KjNkmxCU6v8i33P/8vsLKLM4wfgj9UGkUxLvsnbjvflt8t9xIQL?=
 =?us-ascii?Q?z0UhIiJFVhhs6P5XKnc6YSWv4Oyu6EfAApGxQAX23XdmpHkcXG4YFe+x93Ow?=
 =?us-ascii?Q?1kwyEshxQt2XEWesuYiZ6/ll0kL9oE9+ETHOd+LQd06JIulqgpln4EyhlaBP?=
 =?us-ascii?Q?JzOCi1ZU65c71rbBYMaYkAhNzHx8hw9sFrmwlTFZBeqE4UrUf09s7GvuurmA?=
 =?us-ascii?Q?JXInAjI3z+FravNpl+Qf6AGzojdresvletPt8/Hwf7+l/t2rnoyhQIxTjcYr?=
 =?us-ascii?Q?lkiyjrNK+5UYTiE4Vc3Kpw8wZnMz4BVUVigLjg2VG2Jegr9VBmARtijhRaPA?=
 =?us-ascii?Q?4aABbIX+dtzKdwxJykoIJykKRy0KCSDUG1kOHJp77oXPnMMqnCVti7pLREgg?=
 =?us-ascii?Q?NuO/R8czpFjg3rzBfJIHQmT+yZrcMoFOoJFbtaH+3z2hmOdgVIE7jvYrgLzH?=
 =?us-ascii?Q?ygigvWb4c6fX49zF9yUvnrOvOBNMclHcZ0GNb9v1ZxOWk9NErJ3YZhOwKy1l?=
 =?us-ascii?Q?td+V9fWwplaW4GSaz0Rk43k+vslF7RMJaRgX0Dz+u0aaLhPB1hk4KCbYLr/n?=
 =?us-ascii?Q?LCz3VDU5jgJY9BqSTUrlWPm4gOy3CSNESVqK3uK/kFBg5u8lh9fQCa4ZbVU6?=
 =?us-ascii?Q?bCKWwK9oRbWdz+AIM7UJJuyivID3k1kuaMWb5ZKzrwLMF+EHqnMbJ4KO2DPu?=
 =?us-ascii?Q?iG7OsFZkiBMWqc1Zl9Fc8HZZLBhYwiQNXfNvgBuvuppyfkgvWVrNjNZY1BXg?=
 =?us-ascii?Q?dcp/BViSyUC3FYJxZ0OXxk4U6IYqAG/wRzQLQucJOY74AA8ez7oRgYRXwX3p?=
 =?us-ascii?Q?xSvT5OXbVFU8HrLOZWja6TnBunIFCxKi5dEoCfs6i4oojbr3QuWWecn6Henq?=
 =?us-ascii?Q?ENZ0Ub229APUkeEzE0jRqV+RPw3Tgn/y4Ky+6M0UY1u3QUS9AvtxV9Ljc0bO?=
 =?us-ascii?Q?K8pHo+wjNsuzHFSbT/4lZl1W7zEW0MKctHQksRarwKif59SKZHeuwkB2Au0c?=
 =?us-ascii?Q?/1OjNHMK1uYkt/rtnd42FgE9YsPm4vK48h/Uffy08FtwDnTV8FVsvgXr1Qqa?=
 =?us-ascii?Q?AgNJ9lFa95AXfB9oygZcT1nuIx8N5E1hnFQVwbmOlCxyr9JDoTSxaEkGCV0K?=
 =?us-ascii?Q?cO9QqKyikBpwxGa+Rw+IzFV7uNIIuCxSofCnFtw1DW74T/wUv0me3DyBfM2G?=
 =?us-ascii?Q?419mHMIm/zZ7qzW3sF1A2RPVmEJGmqgz3Qh1Nzhq+sqiQu9i24BiII2sHgeU?=
 =?us-ascii?Q?yj44AkpaPQ11adlL5DCL2cMq8Tf4wEfJPEcKKuN4W6oJOIesGsb0VyAp5nUw?=
 =?us-ascii?Q?DJdH/0rnBXggC2z5FiiyeyZDJO74o2dKpEgYMZC1a+M4YRt8IMiRDM/gA6zo?=
 =?us-ascii?Q?hAmx8OpWEPEmWMxOoRU5EpVrHUHzhsirylnA1q+a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2bd992-6ea0-4117-10c5-08dab6914305
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:23.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bt8nRafvjoZrzVmkpUaeA+Bl5/vXeDliGCWavA13L1yupT0MzUnF96LpaHwlNLCouuifVHBk2TFxN+vsCsBmdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

get_netdev_for_sock is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/net/sock.h   | 23 +++++++++++++++++++++++
 net/tls/tls_device.c | 16 ----------------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 928bb601fd8f..7928680f4bbd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2962,6 +2962,29 @@ int sock_get_timeout(long timeo, void *optval, bool old_timeval);
 int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
 			   sockptr_t optval, int optlen, bool old_timeval);
 
+/**
+ * get_netdev_for_sock() - get net_device from a connected socket.
+ * @sk:	Connected socket.
+ *
+ * get_netdev_for_sock() is a utility that is used to obtain the net_device
+ * structure from a connected socket. This function assumes that the socket
+ * is already connected. This function is used by TLS and ULP DDP offloads.
+ */
+static inline struct net_device *get_netdev_for_sock(struct sock *sk)
+{
+	struct dst_entry *dst = sk_dst_get(sk);
+	struct net_device *netdev = NULL;
+
+	if (likely(dst)) {
+		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
+		dev_hold(netdev);
+	}
+
+	dst_release(dst);
+
+	return netdev;
+}
+
 static inline bool sk_is_readable(struct sock *sk)
 {
 	if (sk->sk_prot->sock_is_readable)
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a03d66046ca3..1eb92dab4f34 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -120,22 +120,6 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 		tls_device_free_ctx(ctx);
 }
 
-/* We assume that the socket is already connected */
-static struct net_device *get_netdev_for_sock(struct sock *sk)
-{
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
-
-	if (likely(dst)) {
-		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
-		dev_hold(netdev);
-	}
-
-	dst_release(dst);
-
-	return netdev;
-}
-
 static void destroy_record(struct tls_record_info *record)
 {
 	int i;
-- 
2.31.1

