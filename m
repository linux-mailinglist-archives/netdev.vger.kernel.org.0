Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE7460CE44
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiJYODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiJYODN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18CF19375D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTGs01+vIzWKhW0pl2CMDaV+8InmwHFMBdvqEgqdelpcCE/0GW0lw1msqTiEBC4i4EZHuUGI2FTpKl9rdO0/brpntgpvZI3QFr3qn6KD7lNVxBY8dQ47+ZYVYfXaU106wlTTIV2caoTPoqjIdNTCfJ3iYpmT+ssI4guZ5ZKhKe8xwW6xT8e/e7oNlLKh8FUbVfQeL3SKX+RKRbcGdY6nJRGxU5oMItD7gjLDLUnzL1njeu9wcIVRw11o/6AfScg/jHcqby6AwpMUJNEnrVnINfgtSK3imGgNIrJcwGnTaBXxqY7RhFBv391IBFf9R75nhvRXW4e2bOnXEPxcnwE8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWpSVQk2eS4ZcKH9zxutXPwOI0lrlqDNiMiBUnL9g7o=;
 b=UgKjw6AsUOiHToqTNj7nikzDZniGjsLvlMPz8coss/RAAGniY+Jqmc72B7JCvwFl8fzGszpg4gwYkZEnFtnj3mLWqQuEN7057RWMEKfe+SdgxBenZcQMW2MXLao0oSlXUF61pFn91ILm7XTAqN2zC4S1/yZQBj3eMyKlNCdub1su/TYU2hVnGA+EYZcF1hdSU0dYTtr7PHq+QfwDMkB3GhaTHXjrwRZrISeyVVbXSLYtogB/kXCEwN7Zese20lFZGlA4mpZb7MA4p2tEEYe2dqKk0F2kHekK1WzezvdCO7gdQrRda6doHHxDDz2jUUvuV4N9n2Yels43zI5YYvS34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWpSVQk2eS4ZcKH9zxutXPwOI0lrlqDNiMiBUnL9g7o=;
 b=E22uVwoyvLdugCRyEHFVkujmIaGax4RO/ViNK/2Z9BxN69NbU4Z/xT9Wy0AC8RVBONQA+8RvPWfcUAmr+iTvTuAOX/lnzMwDqSu0EjeIEfL+9XndwW2PPvsh2PG2nWein3thle3whV9Obv2a6l0nEKyQwZ9BGpzldJOAhq8t49BYrs7NOLoqAfGG7YY70FhLjpHn7u9SOX3d/+peDzABsR+I74WPdyqPN72k3hfW2xQEgTqqc6FVqAiyqw8eBKzQPfTN8wo9svVewwYxjphpGfSzYUoYAkPrNXYUb8C8tIEu/QK4aETg9RinSGR5HcZ6dxGl5B+Lf0mvJ5mUfZtExQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB6906.namprd12.prod.outlook.com (2603:10b6:510:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 14:00:59 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:59 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 09/23] nvme-tcp: Add modparam to control the ULP offload enablement
Date:   Tue, 25 Oct 2022 16:59:44 +0300
Message-Id: <20221025135958.6242-10-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::16) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: 26dd637a-6ff1-458e-f2da-08dab6915852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6XhIuT7apuGGa4N0t3WCqr0XkW749JWDpCmyPyCiP8e3z3vqYOLZdi8QfAA82YUdSLXYZp5zknqErPV128AMdif9gcQcfpwq+Iv5UFji8z4f9yeDFDxdGFjyXiHGFQEx82dSvZhlydc0nNO/UaZccQR+ugtORpLxrP2KW/WN8n1u/vu6rC5T1YJxDHg5u7pthokC8nYbmo4UCHoC12flFTyGkVOZaqeeYMFAMp+FnNCQwNsIOrmpsNBtcBd+pwqxmjHpbFoHS/Ej4J+7bHuqW3acSCE+wTW9HaOxh7WlStXTDGgYLI7MqmRVRwPDxYZnZ7mbWTK1WzwCCG6l2ZUsazr96vSDgtL3ENq2qluxoXGag+m+KQrj9DUajWqtItzWeI9my7V7dAynClKdt1Pg791lzKE04wOgWj041NXLpTIv1oDCEwf8qxd9kruWGpVfoJGfxIBrqe1q40QYXUurpjPW9Lwgzw1i6zhzOnUtOIw6n+G5Xx5bjuIUmIqB3Tk87ef+df+2oW7KFpH3yXN1N90i1ftDIRSO5/mOtiHvGN9DWa845aW1M1dx49PzwMArMctYI4d8JnPH3ILigHH+2/0HmkxmKcTV0iCllgOUokggQA8SQfd5mGemRiYuAlyw1wS9fvBXCQw/HdIsl4qz1xhti+nNC9xFaucdG89gAkJwhog9jzSmeOjUWFsn1yoL2wcD/gsNFd7JWsG2xeklGjIUq3VdT9uv0vLUoEpBOo4nccqnQ9eCOBYdimquvqar
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(83380400001)(921005)(86362001)(7416002)(38100700002)(66556008)(5660300002)(66476007)(66946007)(8936002)(4326008)(41300700001)(8676002)(2906002)(6666004)(6506007)(186003)(26005)(2616005)(1076003)(6512007)(6636002)(478600001)(316002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vU4hto0OB41vYeqI4S8mQZBBrukidT/LIt0M0anBex37Jh8NSj0nMUEnLp/k?=
 =?us-ascii?Q?oEdtAt3XAfnPn3l62qvJv7c0bASbPK5UxNfJu4V/nKdHQmZArMCG26bPFAeM?=
 =?us-ascii?Q?aSRFGnRq7QdcnDY7fHKOkknUntDic0uow42iXnleRXwvrzXkKSJDQgfqdX67?=
 =?us-ascii?Q?lagneWm0aEbxfl2LNvZzGad09fCNISrg9GExAKlIxS/XhvoWOmmyvHsS8RsF?=
 =?us-ascii?Q?EEQ/2dGqD9wkmHi9jdX0mujagK0a5nZyMOl77fnHBZbBp1C6vU49zX/3jA7J?=
 =?us-ascii?Q?DEIPZEVUmRFFCMOptK7gfXLCJGvxZjHhc4EF6QOw6atiRs+KsrHuyN+OOpOX?=
 =?us-ascii?Q?N694fulrz+PU/5le5U2HOB9TGo7MiYTeLKgokr/eEUZeUFbM5kfgUVYYUk6J?=
 =?us-ascii?Q?06i9kCY2TgmiyB/xqxjhv3ec4l+deV5IXaSjXAAMDjIfvhyGvvGVFcEHybuq?=
 =?us-ascii?Q?E0EJwdCHUrEdkcwj7OO1tBqKCjRsJz98mQ7XaijklzCGRU6eXvJNL4tE8XLK?=
 =?us-ascii?Q?cFWESBUDCC7mm3sKexRxlsmDG7L+/nPgKc7KQMaeVRTgC0LVZuJYNMV7vdYJ?=
 =?us-ascii?Q?41LI65PRS/1gcucSmimfAwteROTM3mTs4v+y3HeZF4+i/lrguv18zjTKVd/c?=
 =?us-ascii?Q?1BH5MNXaGvvSbk+o0fgZOerfp5FpEtVKgEcw6ht7OWC1JOsZx0QSe5X5qNZl?=
 =?us-ascii?Q?eWTDkHvu4pbTTOXGlpBJH82hE9SCtJHj8D08vlMuuckcqfmm3scE/xXVtctA?=
 =?us-ascii?Q?E1bOSHTtzNHyL1TZL6P90qezDdG/4VNZEagKyJa/1RCDO1tlasEv8+bhmCu8?=
 =?us-ascii?Q?6bU3QNQRBiBzEBHd5xS6IUZLPXRIzyAqymnVtIPeeSyRjAc0mHrrYsYtEQVA?=
 =?us-ascii?Q?zaIRXEwnJDcOxA05y/ayhXPC0eObcsVE/6FBETsrN0KLwgWcnb86fL7jT3xm?=
 =?us-ascii?Q?e/acMap5vRol3xD4iE+i8+KMiuU0WyBapJ1QgW0Iqy6+V+V+vPRgfUYJ8E8Y?=
 =?us-ascii?Q?f2yaOBIzt881LOnqnJwyKuAVUnS7Ja/I3v1wEXo/auAeVWemwSHeZZGQSS7G?=
 =?us-ascii?Q?DKjBheJ/WN+MizKxPs5oo47CNRNbzxOnZnAE7WYnLOO2OCXqYxhEbuYF4/5j?=
 =?us-ascii?Q?WL07P6DNyP1lULMToeeEfZ00/EEA5CtXRLaFYRhgBN+lxOmy0ep1sBSJZnf+?=
 =?us-ascii?Q?6/5oiFgNFoxfiyegiReHSYR/nJCsTOAmmDw4Y9BX1AZoBNlyLQh7LowoaQQS?=
 =?us-ascii?Q?4CFYXXiEcIE7GJdfjTzMGFJpKH63jT1blGtm0qisHOT4OPWJiTlt9GWK/8iO?=
 =?us-ascii?Q?20UxFe3It94IpfDySMVmx4RTkGeSDQdQ4QRgt2dsIdoie5dbp5520msCtmGB?=
 =?us-ascii?Q?kLeFwmohEljfTWXpvX8mA96yMqwgSi2nACUIOp96vfL7I8yh0hBa0++w4aFX?=
 =?us-ascii?Q?ftKD0hUgHZ1+AyBZA4bLcZXea8oQSJaHb763rDZmGQabPd6SzJssP5+7RDiF?=
 =?us-ascii?Q?/3q8LZoQqJDPLpxUT3Uji76OXODEsm0MDissqJkl7vTPxHJGchgZWxkX3bFm?=
 =?us-ascii?Q?zI328jOqjmz/EgvZbnUOmI1Lvl5t2H+3+UOK3/Be?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dd637a-6ff1-458e-f2da-08dab6915852
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:59.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djaRc7OydB+tOczqRIGC9/rK5L+c7B2TmK3Ae5n456BcF3ZNeNEty60gmesSWFYJK/Eb3s3SqaGDCbNDWMJWsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6906
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ulp_offload module parameter to the nvme-tcp module to control
ULP offload at the NVMe-TCP layer.

Turn ULP offload off be default, regardless of the NIC driver support.

In summary, to enable ULP offload:
- nvme-tcp modparam must be set to 1
- the NIC driver must set
  - NETIF_F_HW_ULP_DDP flag in netdev->features
  - ULP_DDP_C_NVME_TCP and/or ULP_DDP_C_NVME_TCP_DDGST_RX
    flags in ulp_limits->offload_capabilities

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 drivers/nvme/host/tcp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8d83faf18321..4baebc475b79 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -34,6 +34,16 @@ static int so_priority;
 module_param(so_priority, int, 0644);
 MODULE_PARM_DESC(so_priority, "nvme tcp socket optimize priority");
 
+#ifdef CONFIG_ULP_DDP
+/* NVMeTCP direct data placement and data digest offload will not
+ * happen if this parameter false (default), regardless of what the
+ * underlying netdev capabilities are.
+ */
+static bool ulp_offload;
+module_param(ulp_offload, bool, 0644);
+MODULE_PARM_DESC(ulp_offload, "Enable or disable NVMeTCP ULP support");
+#endif
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /* lockdep can detect a circular dependency of the form
  *   sk_lock -> mmap_lock (page fault) -> fs locks -> sk_lock
@@ -298,6 +308,9 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
+	if (!ulp_offload)
+		return false;
+
 	if (!netdev || !(netdev->features & NETIF_F_HW_ULP_DDP) ||
 	    !netdev->ulp_ddp_ops || !netdev->ulp_ddp_ops->ulp_ddp_limits)
 		return false;
@@ -497,6 +510,9 @@ static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_dev
 {
 	struct nvme_tcp_ddp_limits limits = {{ULP_DDP_NVME}};
 
+	if (!ulp_offload)
+		return;
+
 	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
 		queue->ctrl->offloading_netdev = NULL;
 		return;
-- 
2.31.1

