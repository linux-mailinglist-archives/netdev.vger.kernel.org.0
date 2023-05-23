Return-Path: <netdev+bounces-4803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BF670E6EA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F05A0281192
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD99FBA31;
	Tue, 23 May 2023 20:55:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B517A931
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:18 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E68DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGala80z8cAMfUAncHqIp2N1LCwH/rMWisqArQUeufqgbfGPyXQgxdKteTS7Parvdyak4ehWK9pz83rzluFGw/guinWjntQAoQKO1rS7safam2hWZOhZdiNOvHWrbTDzwZ+awxAfVlluSJAeIkPiwJp59YgTKJYIUcz4F0yiSjEUsTMMYR9gwaNhUaCjkMtiQ3uqQQERRYtEaiXKqDjMvymrDO93w1Nsx3Yzzf7OBI0BZnEbKCmSPpqZL3cSFfuBK8cvyH22YutIxeStRp0Yjq3GsXFGJSwuXOdKNGlxKx5OucViOVpf6v7MEVzr+oKUx3jL5r/QwPDe138E6WIn6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ty9mkvvjFKBmgWKPfp3rJr22NgV7k2uezaoTKNF0Y2U=;
 b=kMsYU6hvRV/CVCc4ErflyioIFAKWZQxLs/RBTACwyvnFr9XiDjPtdF55gbpfSZK723Hzhd6A4CBB2xTeso+s9R4KzyHwerDxTiL12kQQXLVTfqM2fbHVxzDPNi73teNvkuqyiDraJ1JDNzJ1lo0KNwsdtgyrKXhmjcFIPbDJksi/mLilN21WVWFRfK+UZgvRgsDWeH33FtWdRtKEgzxLInfnvgl8ED0IcxKRLQhrilozkTVRerXf6rjZaLzFtwfmiZb9PgJl1L0LyXrReJLoH4jwyo+k39euOubK5tmZ0YkwIYMOMQNXTi6B4En+rIXOygFUY6nxlVoWfmzAcbWNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty9mkvvjFKBmgWKPfp3rJr22NgV7k2uezaoTKNF0Y2U=;
 b=G9o+3RAIBJ9+TS5VDGRwfAff20h5n0KMm7zAPFsZfmejJotRH+71CmE4IK6m7WxgbwRS31czbnqxr91y6AhhmheG7AQbx5pNFjuktxbxwQLXSmQg73CEhMtVkQPsJHIzVk5fHUfXmZvJyzdKk4ZGf8FFoAFOZHTKGZMngX47Z15jKETsTMecHlAsVwgiYjTJ949LLR9it6/vjsU+S4cCSpCOKx1kdBWG41Z0WXueNs1OweSi8wpp+Y6sJX3n/UnwPq8k0u+Bl4KfZ5dAzpWXD8Zb5tHy41QlYiiRb9oVLEC9QQ6EXUVOTGgvkw5UygVwGW072zP47qgy7m+kmYzvxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:15 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:15 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v2 2/9] docs: ptp.rst: Add information about NVIDIA Mellanox devices
Date: Tue, 23 May 2023 13:54:33 -0700
Message-Id: <20230523205440.326934-3-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: f505317a-6c62-49b0-b40b-08db5bd00237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9N0Mi20fKOKPPaXhcKM6ONDZqi3p3hnIpOmBzqj3C8YW/iLN7q6SZiaDsinPqumd5hXNBme6by2rx5p3qfIzEhPXzNJ0RGqIg8GZ/eB2AkfIKWMpjTHY0zIFt2Ur1KvG/CBStzw5AmreWTV4I6iDNRK2+vfYTg6r5PPQcvtBkgYB0ltpnDW1jWrlHMnCw/cSK7Z4nKxkqArbj3zKx201Bdr8Q9ZexspQI5VLKb2XDDvKmrW83hiNSRay6zWLm8MKvPT4+kJSXsrDI/bsqXLfhKLrqgxfWi82IOpjkCXDHddoVLOCs3c+pBGktnfF1ZU13y9s+MYEWzGr1BxLm9p3s41eCBI01nFsJWH8z1HbP1DRmTK1FXlhFvoRD1qu4FXjN3dMS2AaDt+crAAcKLigptRKnfqovjMwmHShagpwEj/KPRj6obCP6uTBhi27J19DNUY0deH4H8xoh2TfcEU5Sacvqe1YLdW03zA8ddHgtA4Un7TzdlNs1zbZJFC9VGYgxfiIWbfbg3Mcokkm8egaSOOIJvrM+hg6Unwu5PFQr8tHJubIIkifRjzANNPLLR4B
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(6666004)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OLjtwRClZ+D4DSHhPKKuDn+MEhai/KJJZj4VY2Sgemxwh82REGLiLGCQ1Z0/?=
 =?us-ascii?Q?56NnjOuOC8nPsxLJzRLvg+9qYDQX6qogd4QbrPw/fppBDHDE1YZxfyzms8ls?=
 =?us-ascii?Q?r8MKny8FKYMYUJHTqC8kFiRJQhug13ipzPy4c2/lS2wxd7l1mYyC7i43xbC1?=
 =?us-ascii?Q?qxtKmhIKuADzt6yEbjH4dvsi20QxHOYij74nz+2+i7llwl/7HTSAy9812MKK?=
 =?us-ascii?Q?Bvn8Ol2HpHktJ27KmQfylQ3zNp8na1SUBkvRTibfRpwAET0fTDV10xr1tJQ4?=
 =?us-ascii?Q?sQR1AH4w1FFyBmy+1hLdTLfnWjwxKAGN51wLkzKjQIHvw/xfLIiYBdbq8MZ2?=
 =?us-ascii?Q?kiiC2vQzsU4Z+NOmAJoWOAWQn1jIeBcb8BVo42xjr8tKXgT5mbaeyLI07h71?=
 =?us-ascii?Q?j0DaNS7GpaqIIsSEiXFTdQduHIfXkIjYNTFRNSfrBvAK9PaX3oTtEfcUdD3r?=
 =?us-ascii?Q?Lz+Uai5+A82QA58V60uEgRnQ+qj77B94tRRrwDGTm8HURUBoetja0xQLzkUk?=
 =?us-ascii?Q?+Y4BECQUrZpzDcScW4cNv9SotwX2CMMZbMCeJ3yj+MzT61R6Y3NcnffTEMcj?=
 =?us-ascii?Q?v1fQWnBuwGF871nNv+XbXTWP8YbIU/msu2zPsUGPce1bX6zvn+o7I6MRT9lT?=
 =?us-ascii?Q?myneRTQ1oE7uC7Uk+o8QbsJlyE0SJT5JtG0STB1Z1FibpGyNUhg7daZ0COYd?=
 =?us-ascii?Q?MBKPmtrf1HlG7DTOwLke0c6IwL4YQrU/C0mL7c7juSOg7gYOE8vEwGQLqYVU?=
 =?us-ascii?Q?p029dwYtStXzOUZ8B/AfrAS18IdH/FMBuH2+TakZyvReyun4mvNPQwH7Rdj/?=
 =?us-ascii?Q?6of7NNO2yCGCNnS/xekJTO+IsSvvA62oH77fPY0c/qku8H2aFwBv8ahs9Kxo?=
 =?us-ascii?Q?pudeSahh73wPAXSQwLuTQl1aD83hcBB8EC8D/cJvDtxKoUb8nd9B65rEflul?=
 =?us-ascii?Q?cCuuJ+JSTcZpbQI0E7gh3MG7l1afuSm69CNVA6iKoYFDJPg0FM9W0j0eTW8+?=
 =?us-ascii?Q?MXchOM3Aj8xH2ZfLh9TW8+p5Ql8DMABTuUnqkW6a+CecdJ6GNyIXt7X9QIii?=
 =?us-ascii?Q?wjQyKfFCafstvWLqz2CIkhfVsvwI2JZ9uoD9vJQ4GLOk0RLq980XMDzCro7Q?=
 =?us-ascii?Q?D5teTgebmRgJPfFt4/1AVbAw8Xy4NwMk3APa7xWd1de5us0ftAaJWsJ8nkdC?=
 =?us-ascii?Q?nKBpdqkl/d1rDIYaxnyvWOJ+qaeeBdm8agBLaL+aJu6xLTtJLIBZ1DXlCQ2p?=
 =?us-ascii?Q?C8xya8m6UmnBW1z4a3L/QXTyfhF38BjPQ/pfP4C/SNaGL8Xj6LELn44jRyJr?=
 =?us-ascii?Q?4z2DwhUZj000ThCeC0PfKRCVvceNnliJy7T7CAolVE+aie8jD5MS2ipHD07d?=
 =?us-ascii?Q?fgzrMrbWmkwHVU0dciOSWOZFEDqrKlsq+e+TuSbodkwdOhlxM71n/BoFiKfL?=
 =?us-ascii?Q?ZjkwsfkUbgw1HhTg3fizh2hK4pcglGeFZ2LTsvOclHsiT5yh3voAWeH674wc?=
 =?us-ascii?Q?NFNNeP9wDNOMO9GLj32AZ8YSnPQDM8dnF7NX2UyM58ADGEQnd5GP/eUPC7ow?=
 =?us-ascii?Q?Omd5FLlWKKWhUAyiNkUUb36hbd6aNMT9vPUaDgc5f3isK/l7UqVeC73KPXt3?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f505317a-6c62-49b0-b40b-08db5bd00237
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:15.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKfQArkt5C5DGFlaRqE4TO3v+HmGoz+gCQtQnSzJCkxO3Xl8pAScNNSRkZX1Ht/INs+3dfQVsCjNN6f36iZc+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlx5_core driver has implemented ptp clock driver functionality but
lacked documentation about the PTP devices. This patch adds information
about the Mellanox device family.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 Documentation/driver-api/ptp.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index 4552a1f20488..5e033c3b11b3 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -122,3 +122,16 @@ Supported hardware
           - LPF settings (bandwidth, phase limiting, automatic holdover, physical layer assist (per ITU-T G.8273.2))
           - Programmable output PTP clocks, any frequency up to 1GHz (to other PHY/MAC time stampers, refclk to ASSPs/SoCs/FPGAs)
           - Lock to GNSS input, automatic switching between GNSS and user-space PHC control (optional)
+
+   * NVIDIA Mellanox
+
+     - GPIO
+          - Certain variants of ConnectX-6 Dx and later products support one
+            GPIO which can time stamp external triggers and one GPIO to produce
+            periodic signals.
+          - Certain variants of ConnectX-5 and older products support one GPIO,
+            configured to either time stamp external triggers or produce
+            periodic signals.
+     - PHC instances
+          - All ConnectX devices have a free-running counter
+          - ConnectX-6 Dx and later devices have a UTC format counter
-- 
2.38.4


