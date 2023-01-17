Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAF166E262
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbjAQPhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjAQPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED0241B71
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMy7cikenZzAErXJd8G5+IhugDYUHcplGObY5v6wHBqdcw3pFHIwNvqn3iJ5JprGMHjoDAWgtsh+2x7GqwYSYY/N+TpuCmKPdPDD0g4t6Sfh3eCED7Fx65+l9jV03SN+6P7ZORxFo0uU0/9u/B4LcgWw+JUBbsBptL6l9cyFUj5gjjYoKWXDZNnLwmEFm7L90hiRq7K4rXq4C21pjf25drNHodG6Y/nX03DQuFwfgIkv2YWY6Mj1Qg4anzC/jHqkQRoDx9qo4ilzUNuuT7v/BLa0kLKc+E8yD4zhYnjL8XqaUJC3rx3XGqr1dX+daBSaj5WE7vvk+GcAy/ZhNtUu8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=XBQYlPEwIJrnKCO8IpDXjVYNYB/fNfzxPgMrgHnNp85bqA+qb4VTUkT5Zv1KPPSIrvgAz02gqDrliO/lLnis/8GnErazEP4rOsTaO6IcJCPkVQIt78F1/yvNjoo1igCAyw9Lf15OqV67qXWvL3C909XUTjGVRX+JHx4iC2Nd+da5esOK2pgRJ3VnmMa9N3StfGatIAkdusC1R9z44Wkib/79K07KwrpO8UiVECf9oKRt/djlFUnL0aMoFE4kI1GiiEzgJzB3pF1YrQ8Gngf0WTYus4HtFuvQf9OSezmSGi4vKqRPrV+utzfgOJY6bpozEY6IH8UE52ab4Ews1AQIkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=f/WE+FDy3Z+8RbtvCb3fRStqZwMXTLKJs9oeWmnOnjLOeKgRAKBNOyXqKrOwaRyTFjPDmlMpBNKnWJ+NOfRVHT+q8J2Bcjm5fekZde4MNh3YIZc39f6HaRP5S13PWum6AV+UJrd20qCsD+myujmjPVZ7Kk0tu8vM7kOx4isKRWdmwQE1FkA2ZnV9QslYkzeUPuXXA9Kp7N460Ii9jKe7vqZBa1Q5ykFLf5AV9U2fBGS8oyv5MEAL47oBsiHlXwqhrokDA2KRhnDkAG74SnNRIi2iLAGo2Q4i1BbqAoXQ/HZzEHnuC3BCWzO5vgHxp696TKaY79W5w1AZ4fMK87oRNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:35 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:35 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 05/25] iov_iter: skip copy if src == dst for direct data placement
Date:   Tue, 17 Jan 2023 17:35:15 +0200
Message-Id: <20230117153535.1945554-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0202.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::22) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: e751f152-765c-4265-5c59-08daf8a09dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jd4LJireTVh7DrEZHIT0t+iTWF4cvFnQpUB0R+/IahxSFZTZH2UIloL5Ri4tQZpe94L+9bXx0whzmTvd6JHBZtXqk5RdwZ8PbmdnerTjcS6t9m00jRD0OneT57SpM8r9fZYcIRaVZwJL/SFP3JRHv1Jhh4igebJ/heE4/mWOkoHTkJSp9+vtQS78wjO3E3a7YR0Nn2o70QETd5kpODhPGtc3QKWlYre9Sldw5S4gngpnuOXnEuograTWiFXf1QGJY0kZ3NJIoDxv7VWZG+cR2U/+FDqr59QnvGRk3oW6cGj+iU4h1NGwo3TBQBUrHI9n6PKNxdXfQR9d+tUvCAx7IYsmYrO28VOAoEHNJsE2BbW3doKH2PecNZrmzPm5WMz2MV9iLRIyL+mcCFU4Q43E4JgpydlC1mxXers1iPrIMeY6sAXypE+o6aj8MF7repnG1PH0lIsaF6SLRTWo7BHtNtoiHvADJYNaYWK5M5iCAk0S+hQ1G+7zs919TjoV9maEN1YMXKuzWfQMUxdgFEuvuhmp+r/c8qq6VfiOS4fB+DuVBcqjsmWs/W574Fx9W9660nNeTUUGNlg9bX1vhcTWlHaNzY0yefhMoB/z+IwXyMlCBJ+EmkBfxecZIJNlhC5H4sO1ET+degNH2xBViXZ9KG2+rVjv+6hto40GZmEXTFVZXtc2z33iQ8zVB9ioI9Mm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(6916009)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(54906003)(38100700002)(6486002)(478600001)(921005)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A1ATf/lbur5IRu1Ld0jCfbVPuCeLo6UKZrPJyvsns3FUj51WjcEtubAMt2zP?=
 =?us-ascii?Q?EIKzDGKyEJ8Gxnr49IRialUi98oP0lpqYxh9r20grbQCVLT7kmQ4Pqq4soKN?=
 =?us-ascii?Q?2AE/kRs7+UdrLi6e3ims/bMYi/SgcbTx7ZpUYoMOE1zDoNwizclZf5nJW19g?=
 =?us-ascii?Q?S/KoCPT9D/FoqeJafT9Di7glrF5SwmarMS+wQflr3bjGjpY2bBRl91+IkQt8?=
 =?us-ascii?Q?KU7U2zv3nYsr6yIKXOkX1fIK3AXrneX8HLdhtGd2gIRj9mbXrmq/Y6tPQITr?=
 =?us-ascii?Q?f7CCgW1w+8tP6XRTNoE1uQeFMuXLPhPD8rMQlrhu/KMBJx2Kr4qh1OXuG52E?=
 =?us-ascii?Q?QvzMzxEypQZ9W+ufGx+lXKK94pxu3xO/y286dbTIUO1fiX8Mt3zhvh7U+BTl?=
 =?us-ascii?Q?UX9GUWAbQ2iB8A5MnCtLGUU7593MXazAfZ6m/sk8YrZSySn9z9ee0/abUqHc?=
 =?us-ascii?Q?NqiA2jiWkw3VfB7J8YKwSrRYnzxo4hWdSCfBwykddudDzpBANr7U9J8KCqD+?=
 =?us-ascii?Q?M/SgkjXZlhgWAickuzdcMIOcirSOYzgY4eCMUx2TV2AzItY8KKPeEopd9PM6?=
 =?us-ascii?Q?qFdA8UJpuymEWhVQnWFMsjUHjsbfv1o437aLFxrbIk9cvssGRZUxd2Tvlm6Z?=
 =?us-ascii?Q?++xCGl0HpdduKaEiNzjodbrngihTn4lFnh6U+5k6pHxkAW2eOtrkivNMOCW8?=
 =?us-ascii?Q?Jxr1JLSsL9+uSQXWVGUM700363chSp8gDuah9jvdXGR34h6VipozWeOurwzO?=
 =?us-ascii?Q?56Vwc/18erYV0EmpyxZqOzARpYxSQx55SLW1nl3ccJNu5HXxIqZ28HDD133G?=
 =?us-ascii?Q?aTOZfLIBQXYj5d0DoDRYJ44K32RLPfcNDtzZtQXnBpOx8vWaB6E4852XtkeV?=
 =?us-ascii?Q?DrghFeLCicvgB8miGrgHARoMM05TXwMWNpHaEDyg3DPLvu+NhIlLkAzfB8u/?=
 =?us-ascii?Q?i2aJKrM3UvSrutA1rmOijavTayHYRmevsBdNAYESmPg5iwHftv3rQY1ln4Km?=
 =?us-ascii?Q?TNK0344fWZO2x8nhZsaBuDWLAjhCWgFbkcPoJgGBj4ndrEOXDxanffGGk6oS?=
 =?us-ascii?Q?4zycQbO+ZKlQX5XP9dthdbpMSgG/8U9tOF+DyCvFlGcysQO0gkknalVZVR6e?=
 =?us-ascii?Q?uJ6iwX+Bz8Wpd48OT6lOSvDP93AdbY0GbKaEuj5Aqjsq0lXlNAhKa2N1s42a?=
 =?us-ascii?Q?B1is3Dfffwjb66roB3YByxnACI9MZPb9dn8zEQv4AIg6gKb/I5s/1mwUf0PE?=
 =?us-ascii?Q?uH5A0oODcuZE6SSsz3pthF3HScAh6gHyuO1DAqqxhZl+pba3k+7UeSTrgYhg?=
 =?us-ascii?Q?/RUoR5O38PDfyzt9c1FM+fVQVLxJINYxE2dYM6ydM6gBcylenm8lf7CARgEp?=
 =?us-ascii?Q?R7MCSKzUs0srxEJPOD7ikQy4TqRalC3VKv5dDL3uzjwdN3H3YT5pEBb30hMN?=
 =?us-ascii?Q?efXRypQxvLuHMnysRb/mYfqoLHRDkbLb9tdpkfrANjJNfkXQX4UDhQdoSkeg?=
 =?us-ascii?Q?mD0RthjcbDnwekpBXb0QfeVRP75/+51R0Fa7gOUEh/ciprsx86zC6Oj9Lmun?=
 =?us-ascii?Q?W2M5yQgHi+4RIYEjiEbxcvJCwe8GwSWRTo2YdIpN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e751f152-765c-4265-5c59-08daf8a09dfb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:35.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSXA/avr9ULv6yYTgTvp8GCV9NL4kBYM7CzBWg6Cg2ueChDo6l2XziwrKkb/NaU7McIUce/Msz0bXUZrcqCTiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
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

