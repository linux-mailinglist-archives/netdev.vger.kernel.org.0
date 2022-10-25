Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD5E60CE41
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiJYODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiJYOC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:02:57 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E735418F0FB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dg5jL09HzKtgqQxKoh+UTLemNf2yDXVE47sfFP5+6bfzUWRmK64R/Ih0/Sto2DSkyjdGumOPix0Y+FR2ShqwE7MYJU7MfMcPnHk6IcOiZq66MRTBCJhh0KFQAFM2uV2OXg4Ia41YLQSMtJbewEkxkMxl49T8rp2BlS5Gq78dpJf1vSuhwo8zwkMz1tm/r9ItxAZwDqEu3egiJ4Edinl0uPQ/Z2nlqCHtCZwCarniAaBvX5TK8+LmWYdQ45Y02AyOt4KtTPtVeVh8WQDtusx8y9cDUU4nKa9E34CwM9W8VEYt0JIyroRvB6llaWM8fFJJi5KbpD1egbVrZWvdFO8NxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq4nxhdkdi0kdenlVbgoq6mtI8OUGz8na7GBkH8UT54=;
 b=ienPGlidpuT+eih3QdnMc57iswv8FGZ01/inz/meBJtfk1wnXIsi5xVAo89sS/PHcT09vWlAFYHR3zqbaGTJLKSaAIy/3NQhmiMg9UYQfFbP3l6ArmfLIWOPM20i83Yu6HHf20PLKQ8LIIu5zNlld534ox3JsqDp5Waovqy20RmtoleLkjfAdn1HWt1afe+RZayaB8clfYI5vZvhY9WbW77fgm0J56zfgur53eQ6Usq1iZgvhhom2DdoyLFXdWbaWeA6KZc/2ukZvhNXZ8CnHMHbvHnc8KLu3nKslazM+pZUn1jeCr889i+DWgj/KrRk8B8EbfJMYDmAvBkj0ZuhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bq4nxhdkdi0kdenlVbgoq6mtI8OUGz8na7GBkH8UT54=;
 b=TX027Au48Cfcb1ZPLbZq13VLsaXCh15i4Fgp5PMOCwxnyU1YKczUR4gQ1pxzpbvL+7NekitL3RVoPa+ZP0tVvPIHsIbvYI157TbHmGK30Xyw0t/OzmX/9M1JA036Khetjpqb6RqJ7+rsfvD3dz8GXWcKtJVydiaX5U2tTIVePUA3q+xnC4yctkQFX944yzQaglEbSL5GcIOMnZOtpvSqqbsQsdrxsmRc5d9CoOX2cty0t3MCDnBDUPd+y1YLNK9I2bSIn4bb09CgAIuHK9svrx4WN19hs8UfLMOi8Ym5IaIiYVf29TfHgy16KSAemCmbHruliZVJVOPjuSwdKUyzqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:18 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:18 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 02/23] iov_iter: DDP copy to iter/pages
Date:   Tue, 25 Oct 2022 16:59:37 +0300
Message-Id: <20221025135958.6242-3-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0266.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c51284-1b57-48b5-7880-08dab6913ff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khO73EV5oQi2QgMbsq5BhmVgO6vVQ2e7VE9g5T1LG7lDJt0qT8Voi8mnuPijSyd32AQlICuKobLkhXnYENV1blJlm3FxGemRREOCPTM1PH/YinNk0ZPJ9dWKs10F3oJiZXjTQ8ik0+JKmH1Uku8Rms0nB32hI7YNpVpFJSxtZhv21Dyju3qkzaHW3Fx2DZgjOOO9w81VjJBKSKRviQQUBxPRj4QEKXmfI1vO6TVHoL/ag1MkBtKWiDAir/KzIgqR45Y86XMxo7yzYCrNdOULWrOA8aSxtUU3AUNi9nHdWoOqtiTD7RB22Qq1gzCKVipZQWpnfDq2VaaBDp+6Pgm2Aln15VXY2rkkc3UlezOIWxS4Z7hs/qRwv/5trKYkmSywj9MmxO7yJHf7m9iCqFSY+gmC/DPaKsjxZGABZGl3RCNQb2wgOFoJWZNYWFZojmZz197ojTXnK1VEIAMURBEcm2hPgwF0mIDIfIvMlqzbhQwM9qrcDusAipRxYTAmP3/Bgd0JxFzL5JnD3W+XZ9+0KmrAgUZT3sJ42QFx/TX2iuae0P0X9A+E06JNMlTT9jKrdl/7SlPimRQGbM6DokvaKBxe0dqVycZfKOzjSLM+dhhXe7ETqTjcmNZ18LR8xPal2tgvOr6qzlRNQEC6+TNvRvdeikGIOE7VENrK0D6S/6bdsL2pzNbOhl/vrnV1376VWVgmO4HUzB6OmsCblceRzGK+mSGyjFWNV8eCqvODqOI0KbvZMvRfQJiUQPEsGRcq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p5EO3n/LEBkf9cAzFhgZk4oDrHLu33teuz7GjQYwxKPcbUzhJdsgd+nAK8g7?=
 =?us-ascii?Q?jINQEj9yc+zBSNM4PakMpvaG6lnU2kb4GFP21aTJ6avlY0i2G7d/VfhV1eoM?=
 =?us-ascii?Q?58mYNDheY84FOUWVCUVDh1V7wRRKb0+KmQ7rEZEmoSfrK7G42QD7H11XIC0C?=
 =?us-ascii?Q?DIZW0z1XbOF2uIpyiYfnH9bwlcFjFprrIRQwlQTNSaenw/zVFoD0el2dv1Jv?=
 =?us-ascii?Q?easUypEeZ9iXyNx+qr8pGEDry9TF9VWUgUrIQ5VWcMZWNWraOyhhpzGcWtxc?=
 =?us-ascii?Q?SCUEnO7hdh5BaFVogiOk2aRXaqVwqlC7PhEHISr+gQhfQ7RD5stJJMPqA/Td?=
 =?us-ascii?Q?Oyp0AtIBiP5bsRJUZcFVDhH6TsESQqKK4Eg8kI8ZJcEMrAryVhPCh6UNNNbS?=
 =?us-ascii?Q?q+lqG/UjD7IjGo6jSfUnlD7ODjDbs7zUdCrSjAr7jbv7vAb6MeqQ4Wy+wnt9?=
 =?us-ascii?Q?Vsf0D57aGL4cKYmSLQKU0MZSOKi0GNmsk7TCvJtlk1g4ZH2Hma3erbaeezEk?=
 =?us-ascii?Q?fRNTU+OKqUTjfxC7nQryxg/SXLtFeSkjQXer6NpIIlYEV8Ai9zdtsDtgZTKQ?=
 =?us-ascii?Q?W2JXqUhmg3whFLkPMTcU6evMmZIPhwmVrWrXAQb8MqNl1mVZMXqDmHBxJeAa?=
 =?us-ascii?Q?GRPrh9ppUIhgIpBvZyIG3oNwh6cNxYNmo/F7zsbV5sWwkHdMZ/r9pOSD+ZPK?=
 =?us-ascii?Q?k+7+l2ojHkuPu/9by9Rb7IhhPOTF46fZpwnsgAsmOF+tD0Q7/p/fiaa54J7c?=
 =?us-ascii?Q?B+IZeya0DHfHJs7zTxX1VNjk59gloNY4OiqpPYTCAyKoqYCKXy33KXMecegX?=
 =?us-ascii?Q?C/T6Issjh2jPIJI8dC5+7WYvtGoKCEMMToFDYW/LAvtA/T0ZGHP2i/pj/NrT?=
 =?us-ascii?Q?expoaoJ6rDVTNk34VaGiVycuir126fJDBL8riPTmlvHI8CWj9Y/QVQ/0LOj9?=
 =?us-ascii?Q?mOSWREQCyl/VrvuScp+IidU3Crk/wK5450XqsaMyYosJOAfDpXfukAm+hGyB?=
 =?us-ascii?Q?T6LrJ+1jU2LC6lWuPMq2GwkUvTFe6VvfR1lIvNb5PuDHP9grrQFCmrkO9tKZ?=
 =?us-ascii?Q?/Vku44uYTAEVQYis0AMIfv8xPkKE6q6cK4kYHDZnr1zk0sVf4U0Uz0TRPbZ4?=
 =?us-ascii?Q?HYdObsBLzPG6q1BIH/1Lw7+Gbe/GuNgGavkI2pC2ZcPgp/yBsUsf0AKc6eP5?=
 =?us-ascii?Q?8DQqirLWzgf/xz95d2OjTCqk2/AtKBBeULmCV2AHK209+rlyM4q3kn/n6F6J?=
 =?us-ascii?Q?ZaqbTzRHM7eIT1Lsfv9Q1T6N6NJtNPc2cH8LRHOEhSzhhQegbB9wS6Y6BxGK?=
 =?us-ascii?Q?Ur/ydLPwokH5+g/JdPwevZZM1sDVpdSgw2X51ekxmnUokklrvxGgZeXM+1Pc?=
 =?us-ascii?Q?WGvVxj+fSUc/cbwKam0SMytphZVtwHvcWb9T9HSGxGKLku50OnMbYjYoqmMe?=
 =?us-ascii?Q?cr7iP7DjGqE26asnCC2NWU/G1AU+MDjp0gp7DNvji6OnWfybeY7jt3FZ5yKe?=
 =?us-ascii?Q?nUNXaNbSICkLhkP5cgAhCwpcizrLOb5/BxJkeFxwiseHAq87jnF4ZaIzNHMq?=
 =?us-ascii?Q?Ernca9I1Jl+Q2seXLr7/syRbqJuAa2C/4f1wsJ7Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c51284-1b57-48b5-7880-08dab6913ff1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:18.7055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFNBjLunanC8TAfHeU6TUdc/WAn4hKnEjMmZM++HwoBZHXWIGrXzG0urbxgiy55qMv2/IpECdmO/b8V4fIFLqg==
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

When using direct data placement (DDP) the NIC writes some of the payload
directly to the destination buffer, and constructs SKBs such that they
point to this data. To skip copies when SKB data already resides in the
destination we use the newly introduced routines in this commit, which
check if (src == dst), and skip the copy when that's true.

As the current user for these routines is in the block layer (nvme-tcp),
then we only apply the change for bio_vec. Other routines use the normal
methods for copying.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 lib/iov_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c3ca28ca68a6..75470a4b8ab3 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -526,7 +526,7 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		might_fault();
 	iterate_and_advance(i, bytes, base, len, off,
 		copyout(base, addr + off, len),
-		memcpy(base, addr + off, len)
+		(base != addr + off) && memcpy(base, addr + off, len)
 	)
 
 	return bytes;
-- 
2.31.1

