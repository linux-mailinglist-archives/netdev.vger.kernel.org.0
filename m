Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35B4F6BE9
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiDFVAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiDFVA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:00:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5D1C6F3E;
        Wed,  6 Apr 2022 12:27:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRrkfd8iGG0RXNf4XloHZ2DzNmB2zjvO6Ita4OfKzmqT9wL3L6K8uA6yznp9S3TNno78gLjvD+cdrLAwI+Ukh7tvC+atnDEtt4kTeXRB5n+wu05wu8gT7Er/7i/APJFi1Xus6JzGpQAojmz5GtYefStP/dZb+Vum7GhCpxR+M5rexx/+vQ7ZrW3mHjZBYR2JrgZl8PNxmLHw5afrJS3i8TqqHfIpuDHPdmdJZbuhX0BJh6XVbeiDa8Bs8BUidao3+Vo7JHc1Thl5z8cY9ZkiZlm1cZDmZ520fEeB4SChrQY1St82nZU6M65oAe6piaeFgXHRj9JcuJyB0mfS1N4GYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYhAgJwrDAyX/RhnRqHzC/rY67mbn4/jmEnKojRfcx4=;
 b=ENDvEmbVrQkEh2TYEalIBSKijNmRg+4YhTq/G+P6UEck/1TrBgJ9LrYqkXkxPkIWEc08ijC3dihdXuqnpKBLGQSSBtj5fOja6EsPCGYPfZg5w9Ky9dIUDXAz677Mm1CHQP1dk57wPu+Fb0QtsyprQbFK2ih7OSf4N8heJq+MfG+CPtrJTZa60UqZG4KsOjfPjhfVyK/xqjLtfLcbqSw7E7jmOZro852j9Pz50M2zqWNsmaX6GQBgoYxOGv88u0blBiDNuA2Tum8il7e+8kZPh4Uz8OX5sXyKgGqs2I5HR4mTEHlOaxD3yqlX9RBq6Cud4Wyq/Wn9n7RoeU1SulkxtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYhAgJwrDAyX/RhnRqHzC/rY67mbn4/jmEnKojRfcx4=;
 b=Wdr9A7Zqvrk5UqUGhMOu8BZD815hBVt4FcLucwDvh03k0RXPuyF09OCM+xUc2ovVAT8K+GLSl7pk22IySa9VDSFt9/tEBoD6t6t5+XdVGK8hGACSsRdE/6cKy9FzPfK+VIVQWy9RiK3ONTiOAHtcD5a4/hh6Ss8Jkk8VB1pnJmTgzjtCuqIR9Nczmxy1SroVny50nlyxOimbLOLCjuu2jG4zxecYefV5I98gtlQYhO7aIiXGhBdGJ2qGCB7xjSnzuj8JLisEChTwLAnK/uqKVldRt10YXYLxkznbuCOZDZgO53i6ohOsH7dLzp4lfjyegSnNftNeNsOnhEK4tU9iug==
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN8PR12MB3396.namprd12.prod.outlook.com (2603:10b6:408:45::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:27:21 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 19:27:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 19:27:20 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH v2] RDMA: Split kernel-only global device caps from uverbs device caps
Date:   Wed,  6 Apr 2022 16:27:18 -0300
Message-Id: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:610:e4::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5be8f0d4-a322-42cc-a6f2-08da180377a0
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN8PR12MB3396:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB586955996DF922EA9B5E192EC2E79@LV2PR12MB5869.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaXJSExduzfL+V4vQEVFr/DcUmbWVMEYhj+1yEuoo/Uf3YzV+HqfGgaHBryyiyNCVI+ALcSBR/F5dOysTzNc98FQYybeP3kB9i0y9LaIUde9v/vjC8Afo10xEX6Te3cEJPhuWb0sBV4NWn0bazfu8pcRWrHKs9P9GmGC3lfL715HTtyG2o1pdqT/cEYOufNreyNKuREGGY5o4M9IXLMnJXpU7lVDyuvgbMEjYXHEcrVqE3he1/RsU4UlG0f8/rzutDZntmeHM7wqAY5b76abcEYT3BCa/ar/U09DPGmDYJGvavPZqMWqGa5aM4KQtzYqgm8w8MF9H0NfQZjubwVW52MfjRK3RriHJLI3ZYYQ/MrOp6ABkzGtaY6zAsgrOgqhuluaRME437yysYz0eiugET00m9jjxm2plEElX/nrwIb8cEc5nmSdBTMBUMK5xJWJPJ7dVMURiwzjRU/SJjaifsZG9ikIu8y23Fn4iyXQXjfo0/GYiXuSFDcDtPQN6bw2Jyop4isvMo/sTbveo8zxvhbqFV6YbGlzSn2Y8pQrsbF7NvQkdLXkdcxRbuMAb5pLIx20f1QM7CEPFW6wraMN1Kn1CSvC7vNGWPESuSgMTfQZAk8sZ+WDvmtybeBlFM/MmubCW32A4+LaVAxkxmD75eVMA/NuAtjEpjMa2ynXlinPRjVFrWyl9EmpquPILhUY9vy0ksMIvL2CZZMKxzIXBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66556008)(38100700002)(110136005)(8676002)(66476007)(6486002)(508600001)(66946007)(921005)(186003)(83380400001)(7406005)(7416002)(6506007)(86362001)(8936002)(26005)(2616005)(5660300002)(2906002)(36756003)(30864003)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/r7X+YpAYdJCqxv+VfIBLI4h1O//HT1fErcGz62uboANqyzhCg2iigSwCMZU?=
 =?us-ascii?Q?6plDyx3qbz5+p7ODtGpl2FLN5tfbbWwcO+IJXR5DAaOXYdu8Ed+uw2X8Q/mI?=
 =?us-ascii?Q?ZwiR1ZFd/uk2wR5DsjLcPq38Wb4GFLc3jLh6+SMJ8KvyjZtNUblC7omknoNX?=
 =?us-ascii?Q?sBitDh9oswv5PpLrsdAhC3eJNyf2n6ETK5Sv5o88WqusUWzVmLAMI2fl2cAe?=
 =?us-ascii?Q?wNtyr4F+h/x9OgLNN/mXzJGUxze+09zKLUqhN8BlFhqcP+nPzzlOqKmRJ112?=
 =?us-ascii?Q?HHjZcqRyJ8T3pH1DiAkcKkXmPl32nlzalJWwBkkZlts1fdE+xtGopTlXiRtM?=
 =?us-ascii?Q?H8Bhy2yzzK8o1PokvCN1H/uKlFV7ahNp3T/15OJgc1V/38+4ZUyDEeqAEgKL?=
 =?us-ascii?Q?coTX8Zlt3qs4dLF0/ewU2ob8cxvZwGfQpa8gUCxV/29gP7WluuXDh8LMRaxC?=
 =?us-ascii?Q?9SwJHlu6+22blrjX90P/vgIHrZfSyI5yLK9T6zbitqaAMr5JmPsJAkMubeD6?=
 =?us-ascii?Q?vIqILS+mJ04cZxW3Olr8xaxhvJ1c7AgIFpK4jQpY8l13tKC4yPJBMk3PAI1x?=
 =?us-ascii?Q?S0wTSzaj072iwLg2i5ydmxGGECQqG+UvWNpdkqLz6MDyPnk8n82xXKThYT1+?=
 =?us-ascii?Q?oaGVQ5XhGJzKHBO9UFlq/ng0XYqO2P0bgT5/5Kxt2a6C1wSnTrj+7bvFKowQ?=
 =?us-ascii?Q?dLlnmC3HJ7mNjeTUWokeDz9pwslgBcdnfr5MzIM0ogg2Y+cpfvQxYENPw/Zc?=
 =?us-ascii?Q?sCNz4EJA4BEPzUv2Fz2NcbwtvmubKhfS9EARvmrSNsX4n134uHZqV+U0N/0H?=
 =?us-ascii?Q?zzlYu+WZBwhB8S7WcfgE7x9NIxr7UVSOjCw0tcO5eSUkwhzbsRB48r7sR9ym?=
 =?us-ascii?Q?UzsYT+3W7+Z4XTE/aLy1JSXULEwSQ4GufnBod+fiqaip7KJ+TjvTDy96XYNc?=
 =?us-ascii?Q?SO1miXW9KJnBcib6NwyF/gIlI32RwFMKzefjyhUF2UhoauAr/sdKaNOZiwpY?=
 =?us-ascii?Q?Tqx1vur9tGWZ+4Ij2efPCD7JiaiIormGme3du4hAH00pY5z6aE0fEzzQiN9j?=
 =?us-ascii?Q?F+/K3d+eRCAxIyULcxP/aC56Cn+2CLojC89i/Fketg6ot2+SFlUw+qzzfL9q?=
 =?us-ascii?Q?qTPH+x5QTowTQFfya4DRs5XYRrEWGF3GjYGB86z/DFs5a4UlF9YS8PuU6KoI?=
 =?us-ascii?Q?1Nj+LsG35w9+FKjOZQBWIBrHyP0DdHe+x5xBiEf44rNmRasY2d/md/Fz/eyo?=
 =?us-ascii?Q?HFDK69tH0W7GvjsA1SYinKSvvKnOPUvkHaZ21Jv3ziRDK421nddvUlpiJU8B?=
 =?us-ascii?Q?zF9ZXIy23cFRveMpELnPpXWS73ruVOJOxI36aEBykzpvuMKGkuiQkhffsh6x?=
 =?us-ascii?Q?tT8+hpwQ8iUlmyFcI5FkWJrWpW8EKq/oXD4XDXfSMeR9LE2zak7yB7R+Mim+?=
 =?us-ascii?Q?O8OxGUsD13ztwdJPVU7qog1oMGXtwPZwzvukpHi51odlDj+qGDnSRd/bxAvX?=
 =?us-ascii?Q?MJ/jxzN5T7kij8NysJWeGqcPOs2VbxHT+yQ6JDwRtIEy7AvHf7JpFRU4ejFm?=
 =?us-ascii?Q?GJZBiZHkVar0x/fh2LpGC8S3lWhR4IqJuoDBpTKY/bzCML4WMBJaEaAlPzxK?=
 =?us-ascii?Q?1lalDWBxcF/4c1lVUUBj7ftM9MEsdV5XqrGAm81WtUNI900X2W/xw0ApbL9A?=
 =?us-ascii?Q?jCCTUZTYbt90BJ7HnEfvEhrOdzzu4f8xZQ7uYNHZ7h2QoFD4+DZqLox5sejS?=
 =?us-ascii?Q?aFj4hmuowA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be8f0d4-a322-42cc-a6f2-08da180377a0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:27:20.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrNm6EhjNU473IGrGaCWem02bCpl9OKD6k6ILq4CHCdlBDwfXglz3os1ewlzuedv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3396
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out flags from ib_device::device_cap_flags that are only used
internally to the kernel into kernel_cap_flags that is not part of the
uapi. This limits the device_cap_flags to being only flags exposed by the
driver toward userspace.

This cleanly splits out the uverbs flags from the kernel flags to avoid
confusion in the flags bitmap.

Add some short comments describing which each of the kernel flags is
connected to. Remove unused kernel flags.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/nldev.c              |  2 +-
 drivers/infiniband/core/uverbs_cmd.c         |  6 +-
 drivers/infiniband/core/verbs.c              |  8 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  1 -
 drivers/infiniband/hw/cxgb4/provider.c       |  8 +-
 drivers/infiniband/hw/hfi1/verbs.c           |  4 +-
 drivers/infiniband/hw/irdma/hw.c             |  4 -
 drivers/infiniband/hw/irdma/main.h           |  1 -
 drivers/infiniband/hw/irdma/verbs.c          |  4 +-
 drivers/infiniband/hw/mlx4/main.c            |  8 +-
 drivers/infiniband/hw/mlx5/main.c            | 15 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/hw/qedr/verbs.c           |  3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 +-
 drivers/infiniband/sw/rxe/rxe.c              |  1 +
 drivers/infiniband/sw/rxe/rxe_param.h        |  1 -
 drivers/infiniband/sw/siw/siw_verbs.c        |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h         |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |  5 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c   |  6 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  8 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |  8 +-
 drivers/nvme/host/rdma.c                     |  4 +-
 drivers/nvme/target/rdma.c                   |  4 +-
 fs/cifs/smbdirect.c                          |  2 +-
 include/rdma/ib_verbs.h                      | 84 ++++++++------------
 include/rdma/opa_vnic.h                      |  3 +-
 include/uapi/rdma/ib_user_verbs.h            |  4 +
 net/rds/ib.c                                 |  4 +-
 net/sunrpc/xprtrdma/frwr_ops.c               |  2 +-
 33 files changed, 100 insertions(+), 116 deletions(-)

v2:
 - Use IBK_ as the flag prefix for brevity
 - Remove unneeded ULLs
 - Spelling
 - Short documentation for each of the kernel flags

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index ca24ce34da7661..b92358f606d007 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1739,7 +1739,7 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!device)
 		return -EINVAL;
 
-	if (!(device->attrs.device_cap_flags & IB_DEVICE_ALLOW_USER_UNREG)) {
+	if (!(device->attrs.kernel_cap_flags & IBK_ALLOW_USER_UNREG)) {
 		ib_device_put(device);
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a1978a6f8e0c28..046376bd68e27d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -337,8 +337,7 @@ static void copy_query_dev_fields(struct ib_ucontext *ucontext,
 	resp->hw_ver		= attr->hw_ver;
 	resp->max_qp		= attr->max_qp;
 	resp->max_qp_wr		= attr->max_qp_wr;
-	resp->device_cap_flags	= lower_32_bits(attr->device_cap_flags &
-		IB_UVERBS_DEVICE_CAP_FLAGS_MASK);
+	resp->device_cap_flags  = lower_32_bits(attr->device_cap_flags);
 	resp->max_sge		= min(attr->max_send_sge, attr->max_recv_sge);
 	resp->max_sge_rd	= attr->max_sge_rd;
 	resp->max_cq		= attr->max_cq;
@@ -3619,8 +3618,7 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
 
 	resp.timestamp_mask = attr.timestamp_mask;
 	resp.hca_core_clock = attr.hca_core_clock;
-	resp.device_cap_flags_ex = attr.device_cap_flags &
-		IB_UVERBS_DEVICE_CAP_FLAGS_MASK;
+	resp.device_cap_flags_ex = attr.device_cap_flags;
 	resp.rss_caps.supported_qpts = attr.rss_caps.supported_qpts;
 	resp.rss_caps.max_rwq_indirection_tables =
 		attr.rss_caps.max_rwq_indirection_tables;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a9819c40a14067..e54b3f1b730e00 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -281,7 +281,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	}
 	rdma_restrack_add(&pd->res);
 
-	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
+	if (device->attrs.kernel_cap_flags & IBK_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
 	else
 		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
@@ -308,7 +308,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 
 		pd->__internal_mr = mr;
 
-		if (!(device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY))
+		if (!(device->attrs.kernel_cap_flags & IBK_LOCAL_DMA_LKEY))
 			pd->local_dma_lkey = pd->__internal_mr->lkey;
 
 		if (flags & IB_PD_UNSAFE_GLOBAL_RKEY)
@@ -2131,8 +2131,8 @@ struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	struct ib_mr *mr;
 
 	if (access_flags & IB_ACCESS_ON_DEMAND) {
-		if (!(pd->device->attrs.device_cap_flags &
-		      IB_DEVICE_ON_DEMAND_PAGING)) {
+		if (!(pd->device->attrs.kernel_cap_flags &
+		      IBK_ON_DEMAND_PAGING)) {
 			pr_debug("ODP support not available\n");
 			return ERR_PTR(-EINVAL);
 		}
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 3224f18a66e575..989edc78963381 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -146,13 +146,13 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 				    | IB_DEVICE_RC_RNR_NAK_GEN
 				    | IB_DEVICE_SHUTDOWN_PORT
 				    | IB_DEVICE_SYS_IMAGE_GUID
-				    | IB_DEVICE_LOCAL_DMA_LKEY
 				    | IB_DEVICE_RESIZE_MAX_WR
 				    | IB_DEVICE_PORT_ACTIVE_EVENT
 				    | IB_DEVICE_N_NOTIFY_CQ
 				    | IB_DEVICE_MEM_WINDOW
 				    | IB_DEVICE_MEM_WINDOW_TYPE_2B
 				    | IB_DEVICE_MEM_MGT_EXTENSIONS;
+	ib_attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
 	ib_attr->max_send_sge = dev_attr->max_qp_sges;
 	ib_attr->max_recv_sge = dev_attr->max_qp_sges;
 	ib_attr->max_sge_rd = dev_attr->max_qp_sges;
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 12f33467c6728f..50cb2259bf8743 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -314,7 +314,6 @@ enum db_state {
 struct c4iw_dev {
 	struct ib_device ibdev;
 	struct c4iw_rdev rdev;
-	u32 device_cap_flags;
 	struct xarray cqs;
 	struct xarray qps;
 	struct xarray mrs;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 89f36a3a9af00d..246b739ddb2b21 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -269,7 +269,10 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 			    dev->rdev.lldi.ports[0]->dev_addr);
 	props->hw_ver = CHELSIO_CHIP_RELEASE(dev->rdev.lldi.adapter_type);
 	props->fw_ver = dev->rdev.lldi.fw_vers;
-	props->device_cap_flags = dev->device_cap_flags;
+	props->device_cap_flags = IB_DEVICE_MEM_WINDOW;
+	props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
+	if (fastreg_support)
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	props->page_size_cap = T4_PAGESIZE_MASK;
 	props->vendor_id = (u32)dev->rdev.lldi.pdev->vendor;
 	props->vendor_part_id = (u32)dev->rdev.lldi.pdev->device;
@@ -529,9 +532,6 @@ void c4iw_register_device(struct work_struct *work)
 	pr_debug("c4iw_dev %p\n", dev);
 	addrconf_addr_eui48((u8 *)&dev->ibdev.node_guid,
 			    dev->rdev.lldi.ports[0]->dev_addr);
-	dev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_WINDOW;
-	if (fastreg_support)
-		dev->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	dev->ibdev.local_dma_lkey = 0;
 	dev->ibdev.node_type = RDMA_NODE_RNIC;
 	BUILD_BUG_ON(sizeof(C4IW_NODE_DESC) > IB_DEVICE_NODE_DESC_MAX);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 99d0743133cac7..6988f6f21bdebb 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1300,8 +1300,8 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
 			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
 			IB_DEVICE_PORT_ACTIVE_EVENT | IB_DEVICE_SRQ_RESIZE |
-			IB_DEVICE_MEM_MGT_EXTENSIONS |
-			IB_DEVICE_RDMA_NETDEV_OPA;
+			IB_DEVICE_MEM_MGT_EXTENSIONS;
+	rdi->dparms.props.kernel_cap_flags = IBK_RDMA_NETDEV_OPA;
 	rdi->dparms.props.page_size_cap = PAGE_SIZE;
 	rdi->dparms.props.vendor_id = dd->oui1 << 16 | dd->oui2 << 8 | dd->oui3;
 	rdi->dparms.props.vendor_part_id = dd->pcidev->device;
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 3dc9b5801da153..ec477c4474cf51 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1827,10 +1827,6 @@ int irdma_rt_init_hw(struct irdma_device *iwdev,
 			rf->rsrc_created = true;
 		}
 
-		iwdev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY |
-					  IB_DEVICE_MEM_WINDOW |
-					  IB_DEVICE_MEM_MGT_EXTENSIONS;
-
 		if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.hw_rev == IRDMA_GEN_1)
 			irdma_alloc_set_mac(iwdev);
 		irdma_add_ip(iwdev);
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 5123f5feaa2fcb..ef862bced20f31 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -338,7 +338,6 @@ struct irdma_device {
 	u32 roce_ackcreds;
 	u32 vendor_id;
 	u32 vendor_part_id;
-	u32 device_cap_flags;
 	u32 push_mode;
 	u32 rcv_wnd;
 	u16 mac_ip_table_idx;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 46f475394af5f5..f70ddf9b45bf9a 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -25,7 +25,9 @@ static int irdma_query_device(struct ib_device *ibdev,
 			    iwdev->netdev->dev_addr);
 	props->fw_ver = (u64)irdma_fw_major_ver(&rf->sc_dev) << 32 |
 			irdma_fw_minor_ver(&rf->sc_dev);
-	props->device_cap_flags = iwdev->device_cap_flags;
+	props->device_cap_flags = IB_DEVICE_MEM_WINDOW |
+				  IB_DEVICE_MEM_MGT_EXTENSIONS;
+	props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
 	props->vendor_id = pcidev->vendor;
 	props->vendor_part_id = pcidev->device;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 93b1650eacfab0..c448168375db12 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -479,8 +479,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->device_cap_flags    = IB_DEVICE_CHANGE_PHY_PORT |
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
 		IB_DEVICE_SYS_IMAGE_GUID		|
-		IB_DEVICE_RC_RNR_NAK_GEN		|
-		IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+		IB_DEVICE_RC_RNR_NAK_GEN;
+	props->kernel_cap_flags = IBK_BLOCK_MULTICAST_LOOPBACK;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR)
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR)
@@ -494,9 +494,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	if (dev->dev->caps.max_gso_sz &&
 	    (dev->dev->rev_id != MLX4_IB_CARD_REV_A0) &&
 	    (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH))
-		props->device_cap_flags |= IB_DEVICE_UD_TSO;
+		props->kernel_cap_flags |= IBK_UD_TSO;
 	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
-		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
+		props->kernel_cap_flags |= IBK_LOCAL_DMA_LKEY;
 	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 32a0ea82057342..203950b4eec85e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -855,13 +855,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
 		/* We support 'Gappy' memory registration too */
-		props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
+		props->kernel_cap_flags |= IBK_SG_GAPS_REG;
 	}
 	/* IB_WR_REG_MR always requires changing the entity size with UMR */
 	if (!MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
 		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	if (MLX5_CAP_GEN(mdev, sho)) {
-		props->device_cap_flags |= IB_DEVICE_INTEGRITY_HANDOVER;
+		props->kernel_cap_flags |= IBK_INTEGRITY_HANDOVER;
 		/* At this stage no support for signature handover */
 		props->sig_prot_cap = IB_PROT_T10DIF_TYPE_1 |
 				      IB_PROT_T10DIF_TYPE_2 |
@@ -870,7 +870,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				       IB_GUARD_T10DIF_CSUM;
 	}
 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
-		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+		props->kernel_cap_flags |= IBK_BLOCK_MULTICAST_LOOPBACK;
 
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) && raw_support) {
 		if (MLX5_CAP_ETH(mdev, csum_cap)) {
@@ -921,7 +921,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
-		props->device_cap_flags |= IB_DEVICE_UD_TSO;
+		props->kernel_cap_flags |= IBK_UD_TSO;
 	}
 
 	if (MLX5_CAP_GEN(dev->mdev, rq_delay_drop) &&
@@ -997,7 +997,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
 		if (dev->odp_caps.general_caps & IB_ODP_SUPPORT)
-			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
+			props->kernel_cap_flags |= IBK_ON_DEMAND_PAGING;
 		props->odp_caps = dev->odp_caps;
 		if (!uhw) {
 			/* ODP for kernel QPs is not implemented for receive
@@ -1018,11 +1018,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
-	if (MLX5_CAP_GEN(mdev, cd))
-		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
-
 	if (mlx5_core_is_vf(mdev))
-		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
+		props->kernel_cap_flags |= IBK_VIRTUAL_FUNCTION;
 
 	if (mlx5_ib_port_link_layer(ibdev, 1) ==
 	    IB_LINK_LAYER_ETHERNET && raw_support) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index acf9970ec245fa..dd4021b1196300 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -90,8 +90,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 					IB_DEVICE_RC_RNR_NAK_GEN |
 					IB_DEVICE_SHUTDOWN_PORT |
 					IB_DEVICE_SYS_IMAGE_GUID |
-					IB_DEVICE_LOCAL_DMA_LKEY |
 					IB_DEVICE_MEM_MGT_EXTENSIONS;
+	attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
 	attr->max_send_sge = dev->attr.max_send_sge;
 	attr->max_recv_sge = dev->attr.max_recv_sge;
 	attr->max_sge_rd = dev->attr.max_rdma_sge;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a53476653b0d9b..f0f43b6db89ee9 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -134,7 +134,8 @@ int qedr_query_device(struct ib_device *ibdev,
 	attr->max_qp_wr = max_t(u32, qattr->max_sqe, qattr->max_rqe);
 	attr->device_cap_flags = IB_DEVICE_CURR_QP_STATE_MOD |
 	    IB_DEVICE_RC_RNR_NAK_GEN |
-	    IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_MGT_EXTENSIONS;
+	    IB_DEVICE_MEM_MGT_EXTENSIONS;
+	attr->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
 
 	if (!rdma_protocol_iwarp(&dev->ibdev, 1))
 		attr->device_cap_flags |= IB_DEVICE_XRC;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index d3a9670bf9719a..71fa7dc3cc6acc 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -305,7 +305,8 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	props->max_qp = qp_per_vf *
 		kref_read(&us_ibdev->vf_cnt);
 	props->device_cap_flags = IB_DEVICE_PORT_ACTIVE_EVENT |
-		IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
+		IB_DEVICE_SYS_IMAGE_GUID;
+	props->kernel_cap_flags = IBK_BLOCK_MULTICAST_LOOPBACK;
 	props->max_cq = us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ] *
 		kref_read(&us_ibdev->vf_cnt);
 	props->max_pd = USNIC_UIOM_MAX_PD_CNT;
diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 2dae7538a2ea95..51daac5c4feb75 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -46,6 +46,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_qp			= RXE_MAX_QP;
 	rxe->attr.max_qp_wr			= RXE_MAX_QP_WR;
 	rxe->attr.device_cap_flags		= RXE_DEVICE_CAP_FLAGS;
+	rxe->attr.kernel_cap_flags		= IBK_ALLOW_USER_UNREG;
 	rxe->attr.max_send_sge			= RXE_MAX_SGE;
 	rxe->attr.max_recv_sge			= RXE_MAX_SGE;
 	rxe->attr.max_sge_rd			= RXE_MAX_SGE_RD;
diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 918270e34a35cf..a717125f8cf5a5 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -50,7 +50,6 @@ enum rxe_device_param {
 					| IB_DEVICE_RC_RNR_NAK_GEN
 					| IB_DEVICE_SRQ_RESIZE
 					| IB_DEVICE_MEM_MGT_EXTENSIONS
-					| IB_DEVICE_ALLOW_USER_UNREG
 					| IB_DEVICE_MEM_WINDOW
 					| IB_DEVICE_MEM_WINDOW_TYPE_2A
 					| IB_DEVICE_MEM_WINDOW_TYPE_2B,
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 54ef367b074aba..09316072b7890e 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -132,8 +132,8 @@ int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
 
 	/* Revisit atomic caps if RFC 7306 gets supported */
 	attr->atomic_cap = 0;
-	attr->device_cap_flags =
-		IB_DEVICE_MEM_MGT_EXTENSIONS | IB_DEVICE_ALLOW_USER_UNREG;
+	attr->device_cap_flags = IB_DEVICE_MEM_MGT_EXTENSIONS;
+	attr->kernel_cap_flags = IBK_ALLOW_USER_UNREG;
 	attr->max_cq = sdev->attrs.max_cq;
 	attr->max_cqe = sdev->attrs.max_cqe;
 	attr->max_fast_reg_page_list_len = SIW_MAX_SGE_PBL;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 44d8d151ff9041..35e9c8a330e257 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -411,6 +411,7 @@ struct ipoib_dev_priv {
 	struct dentry *path_dentry;
 #endif
 	u64	hca_caps;
+	u64	kernel_caps;
 	struct ipoib_ethtool_st ethtool;
 	unsigned int max_send_sge;
 	const struct net_device_ops	*rn_ops;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9934b8bd7f56cf..2a8961b685c2da 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1850,11 +1850,12 @@ static void ipoib_parent_unregister_pre(struct net_device *ndev)
 static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 {
 	priv->hca_caps = priv->ca->attrs.device_cap_flags;
+	priv->kernel_caps = priv->ca->attrs.kernel_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
 		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 
-		if (priv->hca_caps & IB_DEVICE_UD_TSO)
+		if (priv->kernel_caps & IBK_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
 
 		priv->dev->features |= priv->dev->hw_features;
@@ -2201,7 +2202,7 @@ int ipoib_intf_init(struct ib_device *hca, u32 port, const char *name,
 
 	priv->rn_ops = dev->netdev_ops;
 
-	if (hca->attrs.device_cap_flags & IB_DEVICE_VIRTUAL_FUNCTION)
+	if (hca->attrs.kernel_cap_flags & IBK_VIRTUAL_FUNCTION)
 		dev->netdev_ops	= &ipoib_netdev_ops_vf;
 	else
 		dev->netdev_ops	= &ipoib_netdev_ops_pf;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 5a150a080ac217..368e5d77416de9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -197,16 +197,16 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	init_attr.send_cq = priv->send_cq;
 	init_attr.recv_cq = priv->recv_cq;
 
-	if (priv->hca_caps & IB_DEVICE_UD_TSO)
+	if (priv->kernel_caps & IBK_UD_TSO)
 		init_attr.create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
 
-	if (priv->hca_caps & IB_DEVICE_BLOCK_MULTICAST_LOOPBACK)
+	if (priv->kernel_caps & IBK_BLOCK_MULTICAST_LOOPBACK)
 		init_attr.create_flags |= IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK;
 
 	if (priv->hca_caps & IB_DEVICE_MANAGED_FLOW_STEERING)
 		init_attr.create_flags |= IB_QP_CREATE_NETIF_QP;
 
-	if (priv->hca_caps & IB_DEVICE_RDMA_NETDEV_OPA)
+	if (priv->kernel_caps & IBK_RDMA_NETDEV_OPA)
 		init_attr.create_flags |= IB_QP_CREATE_NETDEV_USE;
 
 	priv->qp = ib_create_qp(priv->pd, &init_attr);
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f8d0bab4424cf3..321949a570ed6f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -650,7 +650,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 						   SHOST_DIX_GUARD_CRC);
 		}
 
-		if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+		if (!(ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
 			shost->virt_boundary_mask = SZ_4K - 1;
 
 		if (iscsi_host_add(shost, ib_dev->dev.parent)) {
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5dbad68c739032..c08f2d9133b69b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -115,7 +115,7 @@ iser_create_fastreg_desc(struct iser_device *device,
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
 
-	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+	if (ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
 		mr_type = IB_MR_TYPE_SG_GAPS;
 	else
 		mr_type = IB_MR_TYPE_MEM_REG;
@@ -517,7 +517,7 @@ static void iser_calc_scsi_params(struct iser_conn *iser_conn,
 	 * (head and tail) for a single page worth data, so one additional
 	 * entry is required.
 	 */
-	if (attr->device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+	if (attr->kernel_cap_flags & IBK_SG_GAPS_REG)
 		reserved_mr_pages = 0;
 	else
 		reserved_mr_pages = 1;
@@ -562,8 +562,8 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 
 	/* connection T10-PI support */
 	if (iser_pi_enable) {
-		if (!(device->ib_device->attrs.device_cap_flags &
-		      IB_DEVICE_INTEGRITY_HANDOVER)) {
+		if (!(device->ib_device->attrs.kernel_cap_flags &
+		      IBK_INTEGRITY_HANDOVER)) {
 			iser_warn("T10-PI requested but not supported on %s, "
 				  "continue without T10-PI\n",
 				  dev_name(&ib_conn->device->ib_device->dev));
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 636d590765f957..181e39e2a67311 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -230,7 +230,7 @@ isert_create_device_ib_res(struct isert_device *device)
 	}
 
 	/* Check signature cap */
-	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_INTEGRITY_HANDOVER)
+	if (ib_dev->attrs.kernel_cap_flags & IBK_INTEGRITY_HANDOVER)
 		device->pi_capable = true;
 	else
 		device->pi_capable = false;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 285b766e4e7049..6058abf42ba74d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -430,7 +430,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 	spin_lock_init(&pool->lock);
 	INIT_LIST_HEAD(&pool->free_list);
 
-	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+	if (device->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
 		mr_type = IB_MR_TYPE_SG_GAPS;
 	else
 		mr_type = IB_MR_TYPE_MEM_REG;
@@ -3650,7 +3650,7 @@ static ssize_t add_target_store(struct device *dev,
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 	target_host->max_segment_size = ib_dma_max_seg_size(ibdev);
 
-	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+	if (!(ibdev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
 		target_host->virt_boundary_mask = ~srp_dev->mr_page_mask;
 
 	target = host_to_target(target_host);
@@ -3706,8 +3706,8 @@ static ssize_t add_target_store(struct device *dev,
 	}
 
 	if (srp_dev->use_fast_reg) {
-		bool gaps_reg = (ibdev->attrs.device_cap_flags &
-				 IB_DEVICE_SG_GAPS_REG);
+		bool gaps_reg = ibdev->attrs.kernel_cap_flags &
+				 IBK_SG_GAPS_REG;
 
 		max_sectors_per_mr = srp_dev->max_pages_per_mr <<
 				  (ilog2(srp_dev->mr_page_size) - 9);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index d9f19d90131398..5a69a45c5bd689 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -867,8 +867,8 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	ctrl->ctrl.numa_node = ibdev_to_node(ctrl->device->dev);
 
 	/* T10-PI support */
-	if (ctrl->device->dev->attrs.device_cap_flags &
-	    IB_DEVICE_INTEGRITY_HANDOVER)
+	if (ctrl->device->dev->attrs.kernel_cap_flags &
+	    IBK_INTEGRITY_HANDOVER)
 		pi_capable = true;
 
 	ctrl->max_fr_pages = nvme_rdma_get_max_fr_pages(ctrl->device->dev,
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 2fab0b219b255d..09fdcac87d1770 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1221,8 +1221,8 @@ nvmet_rdma_find_get_device(struct rdma_cm_id *cm_id)
 	ndev->inline_data_size = nport->inline_data_size;
 	ndev->inline_page_count = inline_page_count;
 
-	if (nport->pi_enable && !(cm_id->device->attrs.device_cap_flags &
-				  IB_DEVICE_INTEGRITY_HANDOVER)) {
+	if (nport->pi_enable && !(cm_id->device->attrs.kernel_cap_flags &
+				  IBK_INTEGRITY_HANDOVER)) {
 		pr_warn("T10-PI is not supported by device %s. Disabling it\n",
 			cm_id->device->name);
 		nport->pi_enable = false;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 31ef64eb7fbb98..b3a1265711cc7d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -649,7 +649,7 @@ static int smbd_ia_open(
 		smbd_max_frmr_depth,
 		info->id->device->attrs.max_fast_reg_page_list_len);
 	info->mr_type = IB_MR_TYPE_MEM_REG;
-	if (info->id->device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+	if (info->id->device->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
 		info->mr_type = IB_MR_TYPE_SG_GAPS;
 
 	info->pd = ib_alloc_pd(info->id->device, 0);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ada4a5226dbd91..b3bb4dd068b6f3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -236,14 +236,6 @@ enum ib_device_cap_flags {
 	IB_DEVICE_SRQ_RESIZE = IB_UVERBS_DEVICE_SRQ_RESIZE,
 	IB_DEVICE_N_NOTIFY_CQ = IB_UVERBS_DEVICE_N_NOTIFY_CQ,
 
-	/*
-	 * This device supports a per-device lkey or stag that can be
-	 * used without performing a memory registration for the local
-	 * memory.  Note that ULPs should never check this flag, but
-	 * instead of use the local_dma_lkey flag in the ib_pd structure,
-	 * which will always contain a usable lkey.
-	 */
-	IB_DEVICE_LOCAL_DMA_LKEY = 1 << 15,
 	/* Reserved, old SEND_W_INV = 1 << 16,*/
 	IB_DEVICE_MEM_WINDOW = IB_UVERBS_DEVICE_MEM_WINDOW,
 	/*
@@ -254,7 +246,6 @@ enum ib_device_cap_flags {
 	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
 	 */
 	IB_DEVICE_UD_IP_CSUM = IB_UVERBS_DEVICE_UD_IP_CSUM,
-	IB_DEVICE_UD_TSO = 1 << 19,
 	IB_DEVICE_XRC = IB_UVERBS_DEVICE_XRC,
 
 	/*
@@ -267,59 +258,53 @@ enum ib_device_cap_flags {
 	 * stag.
 	 */
 	IB_DEVICE_MEM_MGT_EXTENSIONS = IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,
-	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = 1 << 22,
 	IB_DEVICE_MEM_WINDOW_TYPE_2A = IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A,
 	IB_DEVICE_MEM_WINDOW_TYPE_2B = IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B,
 	IB_DEVICE_RC_IP_CSUM = IB_UVERBS_DEVICE_RC_IP_CSUM,
 	/* Deprecated. Please use IB_RAW_PACKET_CAP_IP_CSUM. */
 	IB_DEVICE_RAW_IP_CSUM = IB_UVERBS_DEVICE_RAW_IP_CSUM,
-	/*
-	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
-	 * support execution of WQEs that involve synchronization
-	 * of I/O operations with single completion queue managed
-	 * by hardware.
-	 */
-	IB_DEVICE_CROSS_CHANNEL = 1 << 27,
 	IB_DEVICE_MANAGED_FLOW_STEERING =
 		IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING,
-	IB_DEVICE_INTEGRITY_HANDOVER = 1 << 30,
-	IB_DEVICE_ON_DEMAND_PAGING = 1ULL << 31,
-	IB_DEVICE_SG_GAPS_REG = 1ULL << 32,
-	IB_DEVICE_VIRTUAL_FUNCTION = 1ULL << 33,
 	/* Deprecated. Please use IB_RAW_PACKET_CAP_SCATTER_FCS. */
 	IB_DEVICE_RAW_SCATTER_FCS = IB_UVERBS_DEVICE_RAW_SCATTER_FCS,
-	IB_DEVICE_RDMA_NETDEV_OPA = 1ULL << 35,
 	/* The device supports padding incoming writes to cacheline. */
 	IB_DEVICE_PCI_WRITE_END_PADDING =
 		IB_UVERBS_DEVICE_PCI_WRITE_END_PADDING,
-	IB_DEVICE_ALLOW_USER_UNREG = 1ULL << 37,
 };
 
-#define IB_UVERBS_DEVICE_CAP_FLAGS_MASK	(IB_UVERBS_DEVICE_RESIZE_MAX_WR | \
-		IB_UVERBS_DEVICE_BAD_PKEY_CNTR | \
-		IB_UVERBS_DEVICE_BAD_QKEY_CNTR | \
-		IB_UVERBS_DEVICE_RAW_MULTI | \
-		IB_UVERBS_DEVICE_AUTO_PATH_MIG | \
-		IB_UVERBS_DEVICE_CHANGE_PHY_PORT | \
-		IB_UVERBS_DEVICE_UD_AV_PORT_ENFORCE | \
-		IB_UVERBS_DEVICE_CURR_QP_STATE_MOD | \
-		IB_UVERBS_DEVICE_SHUTDOWN_PORT | \
-		IB_UVERBS_DEVICE_PORT_ACTIVE_EVENT | \
-		IB_UVERBS_DEVICE_SYS_IMAGE_GUID | \
-		IB_UVERBS_DEVICE_RC_RNR_NAK_GEN | \
-		IB_UVERBS_DEVICE_SRQ_RESIZE | \
-		IB_UVERBS_DEVICE_N_NOTIFY_CQ | \
-		IB_UVERBS_DEVICE_MEM_WINDOW | \
-		IB_UVERBS_DEVICE_UD_IP_CSUM | \
-		IB_UVERBS_DEVICE_XRC | \
-		IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS | \
-		IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A | \
-		IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B | \
-		IB_UVERBS_DEVICE_RC_IP_CSUM | \
-		IB_UVERBS_DEVICE_RAW_IP_CSUM | \
-		IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING | \
-		IB_UVERBS_DEVICE_RAW_SCATTER_FCS | \
-		IB_UVERBS_DEVICE_PCI_WRITE_END_PADDING)
+enum ib_kernel_cap_flags {
+	/*
+	 * This device supports a per-device lkey or stag that can be
+	 * used without performing a memory registration for the local
+	 * memory.  Note that ULPs should never check this flag, but
+	 * instead of use the local_dma_lkey flag in the ib_pd structure,
+	 * which will always contain a usable lkey.
+	 */
+	IBK_LOCAL_DMA_LKEY = 1 << 0,
+	/* IB_QP_CREATE_INTEGRITY_EN is supported to implement T10-PI */
+	IBK_INTEGRITY_HANDOVER = 1 << 1,
+	/* IB_ACCESS_ON_DEMAND is supported during reg_user_mr() */
+	IBK_ON_DEMAND_PAGING = 1 << 2,
+	/* IB_MR_TYPE_SG_GAPS is supported */
+	IBK_SG_GAPS_REG = 1 << 3,
+	/* Driver supports RDMA_NLDEV_CMD_DELLINK */
+	IBK_ALLOW_USER_UNREG = 1 << 4,
+
+	/* ipoib will use IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK */
+	IBK_BLOCK_MULTICAST_LOOPBACK = 1 << 5,
+	/* iopib will use IB_QP_CREATE_IPOIB_UD_LSO for its QPs */
+	IBK_UD_TSO = 1 << 6,
+	/* iopib will use the device ops:
+	 *   get_vf_config
+	 *   get_vf_guid
+	 *   get_vf_stats
+	 *   set_vf_guid
+	 *   set_vf_link_state
+	 */
+	IBK_VIRTUAL_FUNCTION = 1 << 7,
+	/* ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
+	IBK_RDMA_NETDEV_OPA = 1 << 8,
+};
 
 enum ib_atomic_cap {
 	IB_ATOMIC_NONE,
@@ -417,6 +402,7 @@ struct ib_device_attr {
 	int			max_qp;
 	int			max_qp_wr;
 	u64			device_cap_flags;
+	u64			kernel_cap_flags;
 	int			max_send_sge;
 	int			max_recv_sge;
 	int			max_sge_rd;
@@ -4344,7 +4330,7 @@ static inline int ib_check_mr_access(struct ib_device *ib_dev,
 		return -EINVAL;
 
 	if (flags & IB_ACCESS_ON_DEMAND &&
-	    !(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
+	    !(ib_dev->attrs.kernel_cap_flags & IBK_ON_DEMAND_PAGING))
 		return -EINVAL;
 	return 0;
 }
diff --git a/include/rdma/opa_vnic.h b/include/rdma/opa_vnic.h
index cbe3c281145501..f3d5377b217a68 100644
--- a/include/rdma/opa_vnic.h
+++ b/include/rdma/opa_vnic.h
@@ -90,8 +90,7 @@ struct opa_vnic_stats {
 
 static inline bool rdma_cap_opa_vnic(struct ib_device *device)
 {
-	return !!(device->attrs.device_cap_flags &
-		  IB_DEVICE_RDMA_NETDEV_OPA);
+	return !!(device->attrs.kernel_cap_flags & IBK_RDMA_NETDEV_OPA);
 }
 
 #endif /* _OPA_VNIC_H */
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 06a4897c4958a5..7dd903d932e54f 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -1298,6 +1298,10 @@ struct ib_uverbs_ex_modify_cq {
 
 #define IB_DEVICE_NAME_MAX 64
 
+/*
+ * bits 9, 15, 16, 19, 22, 27, 30, 31, 32, 33, 35 and 37 may be set by old
+ * kernels and should not be used.
+ */
 enum ib_uverbs_device_cap_flags {
 	IB_UVERBS_DEVICE_RESIZE_MAX_WR = 1 << 0,
 	IB_UVERBS_DEVICE_BAD_PKEY_CNTR = 1 << 1,
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 24c9a9005a6fba..9826fe7f9d0086 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -154,8 +154,8 @@ static int rds_ib_add_one(struct ib_device *device)
 	rds_ibdev->max_sge = min(device->attrs.max_send_sge, RDS_IB_MAX_SGE);
 
 	rds_ibdev->odp_capable =
-		!!(device->attrs.device_cap_flags &
-		   IB_DEVICE_ON_DEMAND_PAGING) &&
+		!!(device->attrs.kernel_cap_flags &
+		   IBK_ON_DEMAND_PAGING) &&
 		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
 		   IB_ODP_SUPPORT_WRITE) &&
 		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 3fcd8e1b255088..de0bdb6b729f89 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -195,7 +195,7 @@ int frwr_query_device(struct rpcrdma_ep *ep, const struct ib_device *device)
 	ep->re_attr.cap.max_recv_sge = 1;
 
 	ep->re_mrtype = IB_MR_TYPE_MEM_REG;
-	if (attrs->device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+	if (attrs->kernel_cap_flags & IBK_SG_GAPS_REG)
 		ep->re_mrtype = IB_MR_TYPE_SG_GAPS;
 
 	/* Quirk: Some devices advertise a large max_fast_reg_page_list_len

base-commit: 22cbc6c2681a0a4fe76150270426e763d52353a4
-- 
2.35.1

