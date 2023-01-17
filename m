Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90666E27D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjAQPlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjAQPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:35 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2F742DCA
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMo7l/HSJXmx1PJ62+2hcIecQuBjVuLCbB/wI65yuA/COYNMsh9OIo0tnU5rFhe1wBYcBH+h2ex4xuRXOe94FhH3+fEfyxlVAjRj0KDGiV+CiwK8SW3ViWBjX26fuZj7kJsYuUPq48H/5JYPxMk4GZChCe3CCcvtd+cFaEP1ycMLGkAkwjT99Kj9ZEiVuqDHcYUiOYqnS6+laZ1rftSbj4NrpwTLPprLtX0F8DCTC5naZwdjqQrLVs5OB86i0Imm+rcM5T6blnzsKwb44Eb9m+OTNnT9IzptyFJf9BUMlcDGL4tMQZ6URMAQ/UxZl80+tspSoUryWQoUkM/NSBLk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1daA6sCjqodTWMP+sFbzm10BGzIqGtJvvzZOJu5bg0=;
 b=GBArziHE/kNWAxP2xEYqk6jD7F5/UZHIlzPB+fJFBQeYkw+SvH+Gflx20pOtVi1JyXdOhWDBviI/cZclqp41PZDD7P11Snm5/qfOYQDy0TqLUdioFKQPDBSkKixBXmDebwlzUPGaCty7HURwnXFDT7yML/5intlIdOTM4Y/xZzih+EBfZjKC1z7jicwdBO4uzbMGY111h/RFId40rcPGy1Fzb1Qmbxri0rZiZEcY57SXgIH5eRjBA87d5QC+eCB1B93MEV8g3Ko+e/MU7ER/1vAbVaq6c/Sy+s1ZiUE6IN9F44KSVt0/QU5Z8l2vTi3uTqkPMyLsufIbJ9SJPhIWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1daA6sCjqodTWMP+sFbzm10BGzIqGtJvvzZOJu5bg0=;
 b=uIXBXwiUgP1UlXGqbwehAamywrT/uQ/GSveeJ89/e5Vr/06Xa4M7MLZdXRaCkqVCCfHd7aS4Wl91sYrUx7RL/nnzlZEH56RZBmTgSP0xIntB3QlkLxTyS/1Nh/T1owdaPWAdVJt3dzK8W23R5w72GTTAaisFL4As84ocTJAvshIYgF6bv8qdGDKLZcpmigG+jYvZnkprOWTROOEGd1TIq/pbHNT6FAct1TZ5rhkt9SsS+wlH7ySiU5J4To65fMzgiDSAb+TtB31gcQWvK7tukH6kzNPT+TghtJhFFenJjo9ydHbS4ivJK1w9wwKfPBcVH3gqEmvyjgMEsGznsq/KkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:38:17 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:38:17 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 22/25] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Tue, 17 Jan 2023 17:35:32 +0200
Message-Id: <20230117153535.1945554-23-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::23) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: c147b010-1b85-4673-e52d-08daf8a0dab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6j9kxCUhIdj+peVZw4TFdBXbEdDVMkDnFOiIpCt4ZCV8IFEPw3ESAzrus1vLNal1hcl3mtPgTdGTC4VJ12mNO1XiWrqraLrrwOynWR/YzqekLJEn0nFEkL/7aoHUCEBBAK1PR8BS77TXfEpoO1IZ6ARTm4uc2F19PfDwr5fqTsBSDE7nVerwL2uSgbjuL/ObyzBFW/OIlbEoHobyM2grrMo/uc0ixM5yiFCBr5cwfPKjkNOPAhFhddTBwcBOQ5koxlMq0Xn++SiEt3hTXdjOC+sNjY3OnJ6ncYm+l09cKPPI07l334hdsukX5GtOui6DIXRYg8Vf7Bl/GGUQf6O4+BQOQ1y8g0VOPULvX2VyU6cwieyiZ5AK+LXpAchAu0px9gHtpasx71MkRcjwU54MqYqwTJ4gmRcqfg0bGh60OsHmx22P1RzYmTjraxSacfQ24+TMJppF3q77y7Cs4lQHnKY+6UbkamRFCLb7B0bw1sYlGAXuEZp1dR8bKzfSPTCXDOJardN9xe4b0VqFZMHcCCkFlHmYabxUbtIV2OVAy3RC+CiD8dPUFsRnFFLEym+isMnNA5w7+N6ShHqM9DenytgYNMT+xrXlk/z/jvALJ7Ti6AG3GvkBP4RGLsZMlWCMqYZTtbscSLvJVyenAli0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(83380400001)(54906003)(6512007)(6486002)(36756003)(478600001)(186003)(38100700002)(2616005)(86362001)(1076003)(41300700001)(2906002)(107886003)(26005)(6506007)(6666004)(66556008)(8936002)(8676002)(66476007)(4326008)(66946007)(7416002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t/jy7QjCwmTTgUzCU6jkv6qWhAJIFgS4wwNQL1ZSf1bpetT1ZeDTk1YlzQqS?=
 =?us-ascii?Q?55QdUmQkVcC8B5tJPcKN3oSR20MQIR6ih29HV41W/1utrEkgwyEr/tGE6bfj?=
 =?us-ascii?Q?bF0H37jfVcfEqM2eQP6J41RaHDM84THxF3lmwWfBZR+HezP6z4tRkoq3sbyT?=
 =?us-ascii?Q?7NOFXHRQ59DEPyYKFjqtkXtdK1Dv+va6MKTjfbKJ8EZ/iVC0VxqaA/61+GtQ?=
 =?us-ascii?Q?ekrxX4CP7/UX4FhAasTRssizjz46GWO3VlgO2bj3Pb2RR5a4zk/IOSfvmEL8?=
 =?us-ascii?Q?lySJKqTnW45TRyaklkWyinDmukN38uIxeZi/ExMPOZQjB0CWsT8v6l6LNCXR?=
 =?us-ascii?Q?mW4Hat64GgfBgPBO2N3KoI3pE4Dv9iawkGoSdujbuYmfjdO2qvHVlzlE57Iw?=
 =?us-ascii?Q?FSUn6Ls0736sGRloJW+ISN6Q+1lC7ezONDrgQ7I2JMw2ejN5zwFsGGOAM2gh?=
 =?us-ascii?Q?44evponMeqqQY/VPA7fNH/O7FxWUMKrYyiezjap2bpoS6nlVfrJNvryTSbu3?=
 =?us-ascii?Q?P10XqnHT3zBs7sqVvJHKs7QJbP2WlpVxPEeSykJEIhotrgCg6sluzaRiItcv?=
 =?us-ascii?Q?oWk9VFt9yya2Qb+ol+W5LllIC2JB667EStSj+pnb4WILe9C4h6cP6pNNaS/D?=
 =?us-ascii?Q?OL8D51TdIwESqhsRouQZmssLGHdCEIE+3GzKS9U9hDF4TWHbuCShlpfe+4vo?=
 =?us-ascii?Q?RiLOsEHvZlWGoYNTxKhEMU9bnkkOR5w+vXTrY53A/R8CIGYMnNHdfPdnkna+?=
 =?us-ascii?Q?/F3A9sV45Aicwys1SLbja0XADev2O4CGLAe/wc/qH+wBixDvUYqt/3X0oR6l?=
 =?us-ascii?Q?WwfYN0GfDMf2ZV+CUNsL3VQldTcF/di5R6wKDlPM6iNc/8vvvqfdagGxUcHV?=
 =?us-ascii?Q?8d6M+R9B0jy5zg/Rk+2VRUG0vOk6LyivSvcsYyWR6Y057Azhfniyq1BO8cgb?=
 =?us-ascii?Q?PmqQsyzxvnnzCOcx5t/jPQL780T9xgBF3QYDQ4JVliv70Q/DZIDssRWQdJSX?=
 =?us-ascii?Q?bo7lAnCJoiN2cNi9pljlFUw84DLEU6Gd3bJ0W0wkQp7MOQW884omXLF9dW18?=
 =?us-ascii?Q?dFxpytu8n3nY2kd5ybrMOQu1HnMWc4GkKbIhLblmL+JDmOIdzwt/3hOJEftm?=
 =?us-ascii?Q?KBg3at3eBUXRsZHi842MEbABzSNbY8+owLSWPHhn68JIfIehZ09/h1GJ/bRL?=
 =?us-ascii?Q?hGBSwAYZwgaYBMzpTsgAJzQK0QYc+6bdHNG4AUK66uI8jWzYDPD4VxGrmM2I?=
 =?us-ascii?Q?t1zBN8EYg/T0ypSsinffUf+FFcDFc+3+/z4IMkKI2Gu9mFjIEKm2kHt2CvqQ?=
 =?us-ascii?Q?ZdOpazGf0HsJlTt+tEBvqkRdZS8C2Rvih9Haxk1CyZFAvKg6uYa4ovOOCH+E?=
 =?us-ascii?Q?tYVyn0VrdxBEhADvqJ8jZVgjO12ywKSu8q+EcrKHPWH3aHVfUKQeFlFzlDpB?=
 =?us-ascii?Q?NLVFf7X30KI8lSLHwplTiWzjo5Ujfg+EkUlW9T0WGbakYF/UqN+p86vaSDgu?=
 =?us-ascii?Q?e6ct/tKIeXYd9ezxLiT05sBPSK5b2RP0NWUriYj07pnD3r8H/12H4lDi7/s0?=
 =?us-ascii?Q?82NZtNdjbWTglcAxvG6Qv1KBe7kWeqxXVLsrYQcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c147b010-1b85-4673-e52d-08daf8a0dab8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:38:17.6071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRYs2IPJzCcjAdq385o/qxIy19TJQGPiGgRDtFZ8NgWFKPnd8eRjJhf1YnJDdr0Puveiok+bJWvOl6Gbp1h0BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for every NVME request to perform
direct data placement. This is achieved by creating a NIC HW mapping
between the CCID (command capsule ID) to the set of buffers that compose
the request. The registration is implemented via MKEY for which we do
fast/async mapping using KLM UMR WQE.

The buffer registration takes place when the ULP calls the ddp_setup op
which is done before they send their corresponding request to the other
side (e.g nvmf target). We don't wait for the completion of the
registration before returning back to the ulp. The reason being that
the HW mapping should be in place fast enough vs the RTT it would take
for the request to be responded. If this doesn't happen, some IO may not
be ddp-offloaded, but that doesn't stop the overall offloading session.

When the offloading HW gets out of sync with the protocol session, a
hardware/software handshake takes place to resync. The ddp_resync op is the
part of the handshake where the SW confirms to the HW that a indeed they
identified correctly a PDU header at a certain TCP sequence number. This
allows the HW to resume the offload.

The 1st part of the handshake is when the HW identifies such sequence
number in an arriving packet. A special mark is made on the completion
(cqe) and then the mlx5 driver invokes the ddp resync_request callback
advertised by the ULP in the ddp context - this is in downstream patch.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 146 +++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 6ab46497e1dc..7c7be7cb9701 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -682,19 +682,156 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	mlx5e_nvmeotcp_put_queue(queue);
 }
 
+static bool
+mlx5e_nvmeotcp_validate_small_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, chunk_size = 0;
+
+	for (i = 1; i < sg_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size - 1;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (sg_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_big_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, j, last_elem, window_idx, window_size = MAX_SKB_FRAGS - 1;
+	int chunk_size = 0;
+
+	last_elem = sg_len - window_size;
+	window_idx = window_size;
+
+	for (j = 1; j < window_size; j++)
+		chunk_size += sg_dma_len(&sg[j]);
+
+	for (i = 1; i <= last_elem; i++, window_idx++) {
+		chunk_size += sg_dma_len(&sg[window_idx]);
+		if (chunk_size < mtu - 1)
+			return false;
+
+		chunk_size -= sg_dma_len(&sg[i]);
+	}
+
+	return true;
+}
+
+/* This function makes sure that the middle/suffix of a PDU SGL meets the
+ * restriction of MAX_SKB_FRAGS. There are two cases here:
+ * 1. sg_len < MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from the first SG element + the rest of the SGL and the remaining
+ * space of the packet will be scattered to the WQE and will be pointed by
+ * SKB frags.
+ * 2. sg_len => MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from middle SG element + 15 continuous SG elements + one byte
+ * from a sequential SG element or the rest of the packet.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int ret;
+
+	if (sg_len < MAX_SKB_FRAGS)
+		ret = mlx5e_nvmeotcp_validate_small_sgl_suffix(sg, sg_len, mtu);
+	else
+		ret = mlx5e_nvmeotcp_validate_big_sgl_suffix(sg, sg_len, mtu);
+
+	return ret;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_sgl_prefix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, tmp_len, chunk_size = 0;
+
+	tmp_len = min_t(int, sg_len, MAX_SKB_FRAGS);
+
+	for (i = 0; i < tmp_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (tmp_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+/* This function is responsible to ensure that a PDU could be offloaded.
+ * PDU is offloaded by building a non-linear SKB such that each SGL element is
+ * placed in frag, thus this function should ensure that all packets that
+ * represent part of the PDU won't exaggerate from MAX_SKB_FRAGS SGL.
+ * In addition NVMEoTCP offload has one PDU offload for packet restriction.
+ * Packet could start with a new PDU and then we should check that the prefix
+ * of the PDU meets the requirement or a packet can start in the middle of SG
+ * element and then we should check that the suffix of PDU meets the requirement.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int max_hole_frags;
+
+	max_hole_frags = DIV_ROUND_UP(mtu, PAGE_SIZE);
+	if (sg_len + max_hole_frags <= MAX_SKB_FRAGS)
+		return true;
+
+	if (!mlx5e_nvmeotcp_validate_sgl_prefix(sg, sg_len, mtu) ||
+	    !mlx5e_nvmeotcp_validate_sgl_suffix(sg, sg_len, mtu))
+		return false;
+
+	return true;
+}
+
 static int
 mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_queue_entry *nvqt;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5_core_dev *mdev;
+	int i, size = 0, count = 0;
 
 	queue = container_of(ulp_ddp_get_ctx(sk),
 			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	mdev = queue->priv->mdev;
+	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
+			   DMA_FROM_DEVICE);
+
+	if (count <= 0)
+		return -EINVAL;
 
-	/* Placeholder - map_sg and initializing the count */
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
+		return -ENOSPC;
+
+	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu)))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < count; i++)
+		size += sg_dma_len(&sg[i]);
+
+	nvqt = &queue->ccid_table[ddp->command_id];
+	nvqt->size = size;
+	nvqt->ddp = ddp;
+	nvqt->sgl = sg;
+	nvqt->ccid_gen++;
+	nvqt->sgl_length = count;
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
 
-	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
@@ -717,6 +854,11 @@ static void
 mlx5e_nvmeotcp_ddp_resync(struct net_device *netdev,
 			  struct sock *sk, u32 seq)
 {
+	struct mlx5e_nvmeotcp_queue *queue =
+		container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	queue->after_resync_cqe = 1;
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
 const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
-- 
2.31.1

