Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B167D136
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjAZQWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjAZQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:22:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5A7B746
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1c6Vi8iJMg9jHNfHZV4v3OG1tIBYWIM8FMiEaPJr88VG+vMsRR1kZ5SL6EtIJg40nsSuc7BJWUbutAGxccMYrqjxBzkxcJjgAXPJfiXseTA0oLbSX6CF8VSuqJOknBsrCHhY9A2156CQIv7mfaPm8DO+q5BjVvnlKCP2UMm1mRn+Casl41ktb4Re6HWDPtKCIwt0jU86G6fjwjxttO7HhpkKkbJ79CKupLymg11ALE8uRpLFdCjBHo+6mDbDTOQZ5f8sj9oonQ4W3bXhGHR/GFsfF5/k6MhRwnRmUwlrA1TclC6UkLAw2WPXLzReFn9mkNuIvzfLvmZ6ib2Uf+0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=Xc6PqryUFGaOpRlo5CpdDVAcqKCtr36kDmObx1hgK+XQpWwE0jw1b7DJur6fPEWn3ZdJ3Fg1kiUfREDgVub5hHoA9I624VkH9/f3yGKlEV0aqFynDof0FFg+EwoTfHakwWxkirIzcg49IbZ5rjW3b+YSP4rWZTzTSDfjNmACunDPouHqKnO8De1tHII7fYBm3ECQ/tYIOBzGRV32dAL8ebzW0ShAJs9F8YX0DbEDEMtbQfPK4hqgT1vk6CVwKKuWaIMNsAqWDnPV/Qc0qjm6KVzZKANbapoMYg9zzFN5v9vpSHdfNUgvFdd1B8o1NTl2hUBHhWN8doscd+GJfDasqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=eMFHlhBDmChqMrwdlWyBceSm1E9E67h5t4hUtFD3kpJjqK346FktHtkV/o23IQUIObbVMIct5ioWf6gWRGdosp2cT8AGJ9uSl7DtyzUbQBkcKVhe7O2lMZypjlCaxl5+EPuoMcNi6npOkzHzGvTSYp3b8jWdylwpkd4VR7Xuy06rLFY1s6cPuGGgicJ+EyFBSgRGVFiL/1xzxC22TWsnfMF54Txiy2cmE2DgPeKRvgRKoMkg1a+nVuBtBbrZol38wgklhzqcFAR4Hy4opOtu/jKTDwH7cyjEDs5GNxR6Dp05FoYIcVUhgmMhbIW6MD8wCtaZrPLHXA0rYh0377VurQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:22:18 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:18 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 05/25] iov_iter: skip copy if src == dst for direct data placement
Date:   Thu, 26 Jan 2023 18:21:16 +0200
Message-Id: <20230126162136.13003-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0215.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::35) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b194b4-7726-45c0-61e2-08daffb97ebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3JuX/j8SOMXP5XgyYMOUOV6rRqPCiAN/bM6EPdt3GPWKi0re3x9hXHFKhYf/AOEp8JIDWjt7QmoDohwR6Ateky59HagNJWT9hm/h/tJ9afboeqNnB2LAZ+nEcFmSg6OrZ819eRRxxMWIxA+EkwUkDSftpHqzgqaaLeGyg9wM4chvRjGeDBMoGzaI3Dl6svzCd8PmmxkFVlXWNGdwMFldu6KjbP/bLtuzVbiBT5tBufUgiUHDw1XK+N/DviZkB+voRvKLKqRARRMnKAIBxFQIIEYiavSu0rMeJI6h8FXNuOVQjs1qDAEGEQTa7CPsHFvt8O9u0K8bzcStFDbCcU/wkO792SZ4xMUkwiRIFJsgImGcYHeHF7oEvQTkYJ9EzW3k/SJeSVsNaW0zCfk9w+OTw7m1UYrGSPI/UpCf91utSW4ggY8uRgsS8MV40jUMyiaapAv0wpjnq3GgR1+MKAKW7szMW7/WmjKU/TEDqWCQphWh21yjLEJQ+sJFFxG4+7+kDNhF8HGmqgOhoqKaw+CKUEx0F4uPEZXtEZJ+BahC57QbcRBGOA/vRT6jE/joWLsHYVAZBXtoYM1lQEOwCLp4OV3GD2IERZp2NYjZW5qKEzbOkpLRPOjlpepWKtCtGD0et6xBliYi3JbIGb+8dQVTGBFmTHtnztqY9VjPiqUmnOFbSSZVqCPnJPINNVO+nr13
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199018)(316002)(38100700002)(41300700001)(8676002)(66556008)(66946007)(66476007)(6916009)(4326008)(5660300002)(7416002)(36756003)(86362001)(8936002)(921005)(2906002)(6506007)(1076003)(26005)(6512007)(186003)(478600001)(6486002)(83380400001)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JfASZeIp8i0yUPk3uREhp1wDI4Nh6DZsGYlkivmJY2Dw8iqB0mOhvkMbB9zB?=
 =?us-ascii?Q?piFTVAU7MJURw7Z2cauU4JJCP7xvi/wgFLr94iivGgVghEQ3XhAYvWboQFpn?=
 =?us-ascii?Q?vR839n1sIB6usyy4DIW9nCjxKcYRoAPKRZ5X+jAhGOoCMbMZi87JKBhdyITe?=
 =?us-ascii?Q?TNOd210A75E7dXV2qvY74w4o00vXTgse7GBju3wZBD0G3UIb6wyNjJTJ9JxL?=
 =?us-ascii?Q?54LEObqmefVHjfDzoI51YNx18/yDwyerS0ssxwkSQsLjxwsO1QU4rO32sgNn?=
 =?us-ascii?Q?Mkag+Muyrcz3EG6Nz7uleOw5mgw5b3UmuiRY0m+rYTcZi5N2HrXsNMky6QP+?=
 =?us-ascii?Q?+6Jcl0kMz1AI98NX5KrqXvoP/79MFWsOqR4e7D+0l5kwGE1r2QYIR0WXGQ10?=
 =?us-ascii?Q?AyhWazaS6hJdz8vqNVR7RWRpy6vH/e4Tl3Yv3Dv0XbbJZd5b+oOTgUuFr93W?=
 =?us-ascii?Q?KfdFbxkKG94RlfvVqxyhk4NrTpmxiqsz/OZd8qTwih1rijcXxW5tH7Z75/Wj?=
 =?us-ascii?Q?ZovEvkjvLpewANytA56M87Jw51Wfu0+AO6SdAD8j1P5gahdpGab4hg0ZYUB6?=
 =?us-ascii?Q?ZoiDWibwd5J2y3FlbJlVUqycG26LK8ypmqqienaNmxXQ6VbbkjB1aBsRd7OO?=
 =?us-ascii?Q?7HqGjj7jCdYzjg6UJhxBZUebqCUe7c1EEvd8r4p8i1hBlK1d+asx/uO9t0+o?=
 =?us-ascii?Q?nt0AuilG9qsFoC44QXTHT/d6BzFST1PGV0lMaUmzpBEQ5j1fMXmx3G3LQppk?=
 =?us-ascii?Q?c4bV5PMmyD1FnMYhsYN+LxKHKGr8ucpEOZbUgJLGhZZsSlHtHiubQKhKYcDP?=
 =?us-ascii?Q?biAhDevdwcPskXD4WRnF3o0uDBn1IUKXwSy5cNM1cLYC5o8xeu2TzdcNQzrT?=
 =?us-ascii?Q?Nzrwzs2X6RUSztaQimiVX2Ng5PLKZiThnWz3DCCS3yNsYw/P0WdmFfz3l6Gx?=
 =?us-ascii?Q?fSvV6Cjy3t4g9VkclHDbaCJ3qQYG/2UCPcJNCMCj2K0wzK4crF3rVlPMQlHE?=
 =?us-ascii?Q?kHu6T7G6XfWRbuc0LROsa1LpF8Br+KkJmF7EjtZVtQJqmuv1Snk3BJkxy8Fi?=
 =?us-ascii?Q?doCb9ur4ey5Tqv0n5jgqwOuJdpyIJ2o0pnBglMtZ3hyk6r6kSe/viWX5nE/S?=
 =?us-ascii?Q?z6CPdcBe2IC+HGIxtNksjNq9DN2hzbo+10i0Z+QtNjgPmmby6nB0vBu8v5LL?=
 =?us-ascii?Q?Udt9qb6GqjcGrMCykek/P35UeoYL9uqoazBeKL8DAoKIWH3JC9uDMXA8ddb1?=
 =?us-ascii?Q?XJORB+i1BW6SHO1leN54N2Iur1NT+vDmSB3ieot6D1OxihjljKq0pCJAKnod?=
 =?us-ascii?Q?L84VFugvRV0fGMw0n2gnVxqZTNrFyZ0RnT+pDqcrqPDlxQWLEgxxIzIzrZRE?=
 =?us-ascii?Q?0k9fs8GSAFmeueymVNvX2Rwo7w4iv/mk1b38SX23sK+BNfVU2XtkF+aifFbx?=
 =?us-ascii?Q?FoNiluFXapFI8pDo5WUjHn01VQ+xMoiTSn/7udBEc+41Vxin9SFvaOSOj1Dz?=
 =?us-ascii?Q?EHXsYGpW3vREvk8q+vJxuPWi5Pz/BKGH2ljjnChG9J/vakRIZ9HmPgGTLRAv?=
 =?us-ascii?Q?MvYpBUj84y74XBQAskNa3d2g+ojMewVGfreYrS5z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b194b4-7726-45c0-61e2-08daffb97ebd
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:18.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o4xmOfN6HQHVSrY9obivuYX72zNDGJ5cz9G9wPgsYjiz1zjEJqwHBS5LJknDF9D602BrXjBSWn6P8re0Do9lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
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

When using direct data placement (DDP) the NIC could write the payload
directly into the destination buffer and constructs SKBs such that
they point to this data. To skip copies when SKB data already resides
in the destination buffer we check if (src == dst), and skip the copy
when it's true.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 lib/iov_iter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f9a3ff37ecd1..2df634bb6d27 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -526,9 +526,15 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		return copy_pipe_to_iter(addr, bytes, i);
 	if (user_backed_iter(i))
 		might_fault();
+	/*
+	 * When using direct data placement (DDP) the hardware writes
+	 * data directly to the destination buffer, and constructs
+	 * IOVs such that they point to this data.
+	 * Thus, when the src == dst we skip the memcpy.
+	 */
 	iterate_and_advance(i, bytes, base, len, off,
 		copyout(base, addr + off, len),
-		memcpy(base, addr + off, len)
+		(base != addr + off) && memcpy(base, addr + off, len)
 	)
 
 	return bytes;
-- 
2.31.1

