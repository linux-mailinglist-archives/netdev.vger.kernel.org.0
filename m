Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D138B60CE49
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiJYOEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiJYODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C413196093
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qm376xcsTw4jOT1VkH7ysnMbwAdAigBxoWdWCpeIMNHXiXwiFJRheRz4ML7fe0XaGCgwTr/xzujROLyzm8JhsMwGFY+qSAbbe9BGh7ti9BzzhEtSzZlAB+nJAEcZ3quq+EJCUdloFj3K1qdYvH4X7JQo9Tdz2zBuunUEi4PAuNCrX/sS1QJYcR3c/bf9TlIoSKroB2kcIRwg+ILyDbWiHypzV5L3PsPQSyb0noEVkfe+/1ihtGImwSm2ARONMOYa2uC5KGt3QP9dBPoq5TS0AEWiT3s5LjV+1NGU0jTNWmlsVgv24ZDuTMZBXB/fpKZRZBUM1d3LkPuHiy+y4q/Kpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUrF85077K85QisHg7U2+ADraEEmALtA72ot8DcGNss=;
 b=XJ+aAGL41eDIG+z6JG3dpK8y98veN+k07WEN7MEr0j+zkllwtj0O+SKWXwa+4eVLQRz+M4Ag5iEl+lWCCbFBTc5PcRFWyCdRoHpby4qaUl8GN0Ozcr+3O0Pd9QjwMEVfUYTGO3gyqpEyqwzSmL6lDbL6Ym1NdOwUnXD59J2DZaMNFrI9GSC4a11iYbdehxD324eaS81MX2nrE2BWcjDJ0fyXmcGIuvNCno6RcEyOlcCZmr+N5qGxaPy99DJRtsiwyWcWIbx26O+6tQBFrfiRfe0BFquyNzX6ZsO2WOARNVOReKNHb5ohBWGycrVE3ld72JXa5Cww9yYlLA/IHOUkzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUrF85077K85QisHg7U2+ADraEEmALtA72ot8DcGNss=;
 b=QJKvgd25Up1VZBHxA3HAaeMnGCWzPJm08ejlJPB4WXw7/Z0/6hxKMmJuD64Fdm20ugxkGvBnfBTJx1n7WyiYBb/uE3XrevR5inQsPJvgA3PIswsQ/PtvOe2w78GNSGmtRN7ggdElr7yZieuquatL318ga/DjS6888/D7YrgVsifhSL9ndK8XVXefKGjDrh+JDaqf5j5J8EVX/h/4GPOE9Yctz6X5W8b6tdSU7vhivFnYANZ90bl81YM4xFuWqkEMzVV/AiMsboYZAdQjuiEWOOAQEqZLbbYmu0F/7q1rnndEpfhoKWMg8pTZDYDpse5F/sQSPSy9Bcr1n8KqVRkIqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:47 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:47 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 07/23] nvme-tcp: RX DDGST offload
Date:   Tue, 25 Oct 2022 16:59:42 +0300
Message-Id: <20221025135958.6242-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 13195ef8-2047-4b60-2da4-08dab6915152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8umGsxXkIAPOjnUupQgqgjyBaNh0SZ3q3dY9pMNDvPsbjWtAPSYszJbpe9A8VFk8J5TCmLa1scR8Bd2OTap4aD0fXRAWpbX6Ie2dFujQH4Pg0PJJxKqKjA/EU3kKaCkye7ptWrECDHViV8uf+0EhbRrZQBIuqV507pJQ0haGzgCDdFy8CsE3g4Ail1veAVCLbwlPRWg1uAJQsWzpUO+UiL5/HI21acQEFoLuCNTDds59MkjPlY85eLSLatyJ4yNt/iJGClvBQ22tOmLxqa9oSRfV/twXfqQ74YHjAw0PpfWe1+qYtalnJm1ywbiWkzDIZMo09V8Il7EFIAy6YwkB6nXTzkDHMGwMX0b3gv0TxYpyT4ZKI/yRlaSi/VqWLEJ2gcNtFyL4Yyut4S/o2Z3J+4uVmWS5ViSby56MS3DSasYPGYu5hMwp6bZGGpYv7GG2IOBWuGcrEsRwu1QpF6h4XLdEwHdTbhkij1lx6sN8bkYJEYfUE0aqFtR3DfDZ4Y6b6IpJOCkUrXCiAow6322HEqd8Al8VL4ozuTB8+y7NsxFvVCdrAnIuM8xx8TMTiUp1Xg8DZiUOib200YLPIfKKUgAraHEAcp6LQ3WZ3O9JmxsCIKf8V2o9Th/A1VqUqViX06hfGP7u1IqUzRqwcsBfagTOs1+W7J3D5jj4GCZROW8/hfLBXa0wLdQV1kd9T0CCb602os1BEC/GWiCUX4vRmte0GRgligRGZ1SC+NAxxqmBpiZsPJCsm5dkfu34Kh+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pljS1Nyufx+Sqst0pXsu+Bt5cIX9Bv8xsdcO2XWokuNhjlB3lWSKSvw2m2OD?=
 =?us-ascii?Q?ttmTPTKdAzzcsK16Z70q1M3v/MqbfVgnf5clSEQo8VVHcbLZzXO4W/nUOWkA?=
 =?us-ascii?Q?AYabtIpCoPJRZohPhikT+HsWjux09+ORYmoNwLySz41jKvdE0DxlcfDTZTd2?=
 =?us-ascii?Q?Ch7ExT9facVbgMD4+1ttIfLGihIrvztJjrW+I/bEGsHoF5c1wQbbWKkU/vNO?=
 =?us-ascii?Q?/TAkZsPwv7+fKu0pPePZj2R/kJYkb5G4KVluSsY01QLXNAKXZiH/1R/tiCv6?=
 =?us-ascii?Q?N/N/DKZxR6WVaZ7JFDOCerU5EvCVZGesNE4E85n0KTIlyRX42GVNDULTrwXD?=
 =?us-ascii?Q?LRApM6U3RBnbxQh5PJ+jWeH3wRFJeIz6vSx1WmE5DuPhNy0yEf+cGM+VA4em?=
 =?us-ascii?Q?hXPao6Rep9hW3ksk/fTQcCn35I8aMuUJ5shEe6uNTfJ3v9bCbHTTlq9lzIWx?=
 =?us-ascii?Q?eahuY/2KA/aMZt74UPdGX64geHvsdrl7hGsgiq/yX0rnwtOUD6CEh6O4HOxB?=
 =?us-ascii?Q?STpn1EvtAJWFyVfWh/joa3r68ZcZEdffpKSYyPoqvyfEeqbQeuV8FoQHuBsc?=
 =?us-ascii?Q?HwyEUvXTqRnNx3LqDs/+pg2xXOAwXPqS+iOymfoWfeSCgR4fnx0HUAP1EUnq?=
 =?us-ascii?Q?spnIvcxQmPqh7eYixSiGGVR0LnlLsZkCnfKSWnOlf8PhtOZ7JaGKGFjtRzaA?=
 =?us-ascii?Q?pgNUs47YtAwEpTqmE3svcN8cB/+5WRaqOEGUfwriM2rYBiSQns1+lj/0hW6S?=
 =?us-ascii?Q?pPnGulDYVrU2Rzsg75E9lVXgFo6XLJ9huMf/11WHH8Jox3c3uJVc3AzR5sD3?=
 =?us-ascii?Q?nsALjKjc4tCX0AlfqBbu+Mj0AB3rUWvBA8Hf2DCtl0rpxw7Fxew97o57G2OL?=
 =?us-ascii?Q?kTc8Na6RJ0797NK63NeWgjxwtWGQVBMen5Yxl0zG9LC6ak6qkLboCQ7pzFlU?=
 =?us-ascii?Q?4bYT8rMyDfg3SxVDwnIgSd8Lui8BWuk/ikcU965ecPoEF/sJ/vRUrEUbU/b5?=
 =?us-ascii?Q?HLLSJc1IMfTnRQAp0YXV6F2F/nZloK5a6fl9pn/kSthWSBNbzT2+IVn4o1fe?=
 =?us-ascii?Q?RL7OOxrQMsxbSXNKVSEJ7YLvbrp7BIShC/RxzVKvrZiBDWiZLsZ3YHNaWsqW?=
 =?us-ascii?Q?iJOzDBc1DqBd/lN6yOZQ38ESKjBFSvq7N/Vvqu0nrOdZh6OgfGYztoabi7Md?=
 =?us-ascii?Q?wIHOmcO3GVAm0gi7jmV5L5zYeomCTtZqSUTs5Z7FwzCmB/KSrs8cfu8aQond?=
 =?us-ascii?Q?Vfy2AqBoa+HwRATkMEGapGp37JWrqZZFhUWvcQseq8pLIdXfOjCe4Mz3BnUp?=
 =?us-ascii?Q?gl/FFtjKl1lG8VA6AiSzo22hhm/pT+ZiFhZzN1d+/phIY/g921DxVbGIcOKl?=
 =?us-ascii?Q?cBg3p3ZqC4BgjRqBusQhc7ATMdVbDO68XqWaxUUf48aT7fdROcGIXFQWgZWQ?=
 =?us-ascii?Q?1ftw4ZpeJtG66fRzVughYfkjIVVC+Xq4tsSghIjViMbBcSFgaPZkp25YbttF?=
 =?us-ascii?Q?gHgsaaEJ+288GQGBVdthuvur1FUUroRF5CksIXa+nDi5tSujcYKeBytBOcfp?=
 =?us-ascii?Q?sfcWwVaAyhTvcBsl/96nKsQ2BwM1avtjb89aqa9v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13195ef8-2047-4b60-2da4-08dab6915152
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:47.8293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdDl/9Lm4zWwfEkpreCME1nsvCj4QmMuRgFILQrMlB8791EnnIrheeWe8G2ivjx2BN6NYBa+vZamAejzjMXVNA==
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

From: Yoray Zack <yorayz@nvidia.com>

Enable rx side of DDGST offload when supported.

At the end of the capsule, check if all the skb bits are on, and if not
recalculate the DDGST in SW and check it.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 113 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 104 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index cb25cfbc9ac1..2197f643a071 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -115,6 +115,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
 	NVME_TCP_Q_OFF_DDP	= 3,
+	NVME_TCP_Q_OFF_DDGST_RX = 4,
 };
 
 enum nvme_tcp_recv_state {
@@ -142,6 +143,9 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+#ifdef CONFIG_ULP_DDP
+	bool			ddp_ddgst_valid;
+
 	/*
 	 * HW can request a tcp seq num to continue
 	 * offload in case of resync.
@@ -150,6 +154,7 @@ struct nvme_tcp_queue {
 	 *   is pending (ULP_DDP_RESYNC_PENDING).
 	 */
 	atomic64_t		resync_req;
+#endif
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -308,6 +313,18 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 	return true;
 }
 
+static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return queue->ddp_ddgst_valid;
+}
+
+static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
+					     struct sk_buff *skb)
+{
+	if (queue->ddp_ddgst_valid)
+		queue->ddp_ddgst_valid = skb_is_ulp_crc(skb);
+}
+
 static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 {
 	int ret;
@@ -322,6 +339,38 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 	return 0;
 }
 
+static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
+				      struct request *rq,
+				      __le32 *ddgst)
+{
+	struct nvme_tcp_request *req;
+
+	if (!rq)
+		return;
+
+	req = blk_mq_rq_to_pdu(rq);
+
+	if (!req->offloaded) {
+		/* if we have DDGST_RX offload without DDP the request
+		 * wasn't mapped, so we need to map it here
+		 */
+		if (nvme_tcp_req_map_sg(req, rq))
+			return;
+	}
+
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ahash_request_set_crypt(hash, req->ddp.sg_table.sgl, (u8 *)ddgst,
+				req->data_len);
+	crypto_ahash_digest(hash);
+
+	if (!req->offloaded) {
+		/* without DDP, ddp_teardown() won't be called, so
+		 * free the table here
+		 */
+		sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+	}
+}
+
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
 static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
@@ -389,7 +438,8 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	if (!nvme_tcp_ddp_query_limits(netdev, &limits))
 		return 0;
 
-	if (!(limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP))
+	if (!(limits.lmt.offload_capabilities &
+	      (ULP_DDP_C_NVME_TCP | ULP_DDP_C_NVME_TCP_DDGST_RX)))
 		return 0;
 
 	config.cfg.type		= ULP_DDP_NVME;
@@ -417,7 +467,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP_DDGST_RX)
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	return 0;
 }
 
@@ -431,6 +484,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
@@ -516,6 +570,20 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
+static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return true;
+}
+
+static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
+					     struct sk_buff *skb)
+{}
+
+static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
+				      struct request *rq,
+				      __le32 *ddgst)
+{}
+
 static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
 			      struct request *rq)
 {
@@ -797,6 +865,9 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+#ifdef CONFIG_ULP_DDP
+	queue->ddp_ddgst_valid = true;
+#endif
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -999,7 +1070,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -1062,6 +1134,10 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
+
 	while (true) {
 		int recv_len, ret;
 
@@ -1090,7 +1166,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest &&
+		    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1132,8 +1209,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	char *ddgst = (char *)&queue->recv_ddgst;
 	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
 	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
+	struct request *rq;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
 	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
 	if (unlikely(ret))
 		return ret;
@@ -1144,9 +1224,24 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	if (queue->ddgst_remaining)
 		return 0;
 
+	rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
+			    pdu->command_id);
+
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags)) {
+		/*
+		 * If HW successfully offloaded the digest
+		 * verification, we can skip it
+		 */
+		if (nvme_tcp_ddp_ddgst_ok(queue))
+			goto out;
+		/*
+		 * Otherwise we have to recalculate and verify the
+		 * digest with the software-fallback
+		 */
+		nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq, &queue->exp_ddgst);
+	}
+
 	if (queue->recv_ddgst != queue->exp_ddgst) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		req->status = cpu_to_le16(NVME_SC_DATA_XFER_ERROR);
@@ -1157,9 +1252,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 			le32_to_cpu(queue->exp_ddgst));
 	}
 
+out:
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
@@ -1958,7 +2052,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
-- 
2.31.1

