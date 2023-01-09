Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8966271C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbjAINcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbjAINcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3331EEFD
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Du161CwoMI2Zngk3jXL6rcZbWM6PJkcSarOxqBqNx7tNl3lmk/1HSRRLWUWvz7Qcq+ly1q+cU/rEV9N2LXwUoq7YYgKMlrA4BfU1LLX0GJr1ahXMBF2feX9rJlpyeYqR/bXEM0xYC6eA44J2l+x6cqBPlDdzMbAAyaq/qctLo5fg7OqHsLfMh7+BQeURMeRK6iOWF4XKaR94OiDtdkL125BQqc7ivxZelxcBerMGL+7RBB1WdY/65IF+uobeTDuTjfERdoCmzZedudUBo7UXWnPNPmS+WAb/wjGmjdxoFzGwHXkZDheaN85Y4kPKPbzchR0EKy7Lt+o7gJYQp6A0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=G0p3KiEdOJ8RMYWZACrE3s9kZxg5FSxJZUdWcU4Hh8IPkDkg3Y1k6m+IjTGkL6eFl3fhW0NInPKlDQeETCwvlHL8Q8CY7q7aB/4Fubwh5CF0DCsCRJe/M3eiokMzfNazhS5I386hOzPu1tCH5b1Z6K3dlQWbdsxB5bqlpAbTfJCyZCP+hf4efZWO9m42FnvIUtzjaEZJKiSRrmx+rIhY+UQyCCIGdhsTS2ztqEw7mLXfE9x/3OjGBeQDeYwDIDTkJPteYYlsTQOZcdkavqs1RCe9Lr2DUgsOBlHunrIIVXG5Sw7yVJgFa5jmQyL92xmIGJkmqvMJkH0R4XrH9TPM5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=Ui9bhrsLPXwBv5xegBrB9hmcoCKeQKUKlgmLuWgYlnvWZa5wgOZ95p5ry85J5QWGj36QxA5DDD9NRJJLwnxnVTOQdwXAqJ7mLSk18w5Lxiuml+bb2Zp42dz3XI3/ORw0kBuOE1MLa1i18ls0CCwzk2X9XdgtxpHlvUY0Rq/fBsnvkvqh97/0ya87LuGZ1vuQDT8N6Gb/0tXqrteRtJsfZkNGoWHJj/HF7ex3DCWuhb1nzPV7Mo3tzLJxYi6addiIaUMoiH83qeO5wlIcW4Q/Vqum0aaPzXaF8rxUmJJGMpQ1qHi1smhCEps+ZjCSPJdQwC7VXc3w2tGbsfqdN6Xi/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:00 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:00 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 05/25] iov_iter: skip copy if src == dst for direct data placement
Date:   Mon,  9 Jan 2023 15:30:56 +0200
Message-Id: <20230109133116.20801-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: a62ae4ec-ffb2-45c1-f19a-08daf245e31a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8nbYHkJCoFOY58PmAUYdCt+rEzDIH/tHcQrmS3Jussi+l1hrsX1a6TnGTjo41frlY0kNiWDTD6ZB9frQF4+lCpy1p7L/gDy5+2Il8Z4KWDUUa0S3QUuASwk1URArZ2MjTuuQOXtkM4gIrNC6Nh6+vt8fkgKVxQxd/GChfDrUvFA01OXPgo0r0PHeqijKDCPLL+l18F1s7jtp51vB/ZjcLR+HwyGIL0UpT7G0cJj2omGpWFNh1F+24/mpFcsqQQoQwrUHfCfEb0ysrtqlu/ums9PD/yDNtOX+Sg8aYAb8LNTVeqcznFBEG7KKbI0kl0jLFiyZbUf0uzyfjF6/fIBoBLyEMhiYuwcXP39O7loKdv+YvyqaAD2i3Kjdbx67CHeAzlSNJxc02BTXacYNs9Gi5fVYHI4YRJ528DDhZo/aWF7+JQrC+/B+rwq5diCq8ZvcKO2PGb9TWehqtTSxTfZRyy3D6j2jIa3vQXQ22C1uoFylggdgKLxWnOF1Wewbi5js2k8QCvnjLVqvBoIqqz3bqk7wsBEBkIOR9sfLjESsJghDUeEPwgFnqlWk0dAHmXAvmDjSOpA7zR040eZiP53gxyKMpi0Q0svilpOG3zjUqV6wP2i1XXy8dgzob+uknMWm505Czod+pbRVQCHf0iRPgiN1lmQotHijCR3aE9ATJBnTgwgaWWg4zNDzbpvqLa0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(6916009)(54906003)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(921005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z5qb0eeyrMmIIblwb1+qKXmH0CDL6G6e3pVFwm0AfHFGjDZzANrJdQzKHVQB?=
 =?us-ascii?Q?ALHAk3rYmG2DczyRaFyH35kR5InA+N4g44fZHo5fwXWKPutYOFKz/KRYuvSS?=
 =?us-ascii?Q?UqpucESisg4qxxjsreVzE0UmEH2zHFkohwYf9sebZOFUh9FKG4JhtJOCXqt4?=
 =?us-ascii?Q?AKImIbUe6/SUTrFAQK2eL8f9DC92KZ2CrUvVGBsZSSroNg4sHqo08h0CEcTN?=
 =?us-ascii?Q?ocxCuCqfzm0I02v2DE04IJfWoVGp7Z97xTWxaT0FIyujSY0EW77s5ZCsPavh?=
 =?us-ascii?Q?wZGEl9FV3gltD7h/Wdwmw//nmgLcTzanwl9JbC257d/HvC4LgZCiASf/WXL+?=
 =?us-ascii?Q?gzt4+V3nCdyQBpHyiI9nqbFeveuiq6Z2MFmZDDnoTI3vebgM52G0K+zsqK0O?=
 =?us-ascii?Q?SoyQQ+59x1bap4mFHsH3rzWBLz0wn7EOdAMaP1qlmu3+UUV+4LAWnELMEgmU?=
 =?us-ascii?Q?rwc9NrOmlnpqubnSytcCruURUeiFAxkhhTO/IRP++yLl5W3qqmLMoYmfNaw+?=
 =?us-ascii?Q?quU++/za38M1Z1slm4cle9adabfgdio5hUtKOZcq3bwUTo07GuHA8/DpbAIP?=
 =?us-ascii?Q?o+CjW8aAmyQ4m3mpate93sScdObZvaSxXUmTGDJkcb7HV1m76I0nqUmS2zCh?=
 =?us-ascii?Q?Yhs0UP3sMvYNck8Dy/4h32ihQIqWAzlOt7LaVzXAsZ5f6I++4/5FQ/usrK9n?=
 =?us-ascii?Q?STnnvWzeqrxysSkJ3dJNsD0BeFG0crbz4UzmCrgMUfsKFFQZYrVcdL7XfzXz?=
 =?us-ascii?Q?y9INe+lvg/L+eMA+GEIIwIdyv63Gke0TZ2l47yZKhR/39RAejHiGWEGlRu0Z?=
 =?us-ascii?Q?BsARrDiHW2WT2i/zCAIjTYIJnoo0OxzLAPx6LvPwmgfFLSms9Pm4lEYQyPUU?=
 =?us-ascii?Q?Nh3Vf/MN9/zhLKRYMomSJfnh8VHlYL+gVoJR2FYGWRqPGOXX5tWKol94BZ87?=
 =?us-ascii?Q?e2aDVu/rTIxs/IdGRy2MziXAFGW/AP5UV0PPgThp5y8Orsufmnp3ogNkWFH+?=
 =?us-ascii?Q?4Rfm5UgAV3cpP9F+q35lqB9sKJoqNP2fO+6ibFSJqxuZVkqpPAS4NF8H8l3E?=
 =?us-ascii?Q?azCHBKPp1gBK+H+uxdOICEge0frTR+39J8pEv+jrXX+qfCXXm6c269O27FwW?=
 =?us-ascii?Q?mq/mo0MB/eqFkNfoKbJMhmw9gnwYO0q3DW7H+kv16sayUPP6g4lJ7pxvnd/k?=
 =?us-ascii?Q?0tQcn+XGdJMIx12P0LjS4H4oD/p+hgvfg/ntX9a++43GCwsLErbgGjhBLYB4?=
 =?us-ascii?Q?d4fL2Acg5fvXEFfhgWgagthe5WP6FJ+OHrumgJse3pxuWL8PqSGfqvkZdlIf?=
 =?us-ascii?Q?hoW2O/ZlwiGoIhV6Beq5YRmYdu2FjP28lp92+T88qVRnUmRIY8ZYSDJw47ID?=
 =?us-ascii?Q?MDBm3J/P8Ohm/QApTzq1txKF85maYKllq08loG7kj4d0x42xFwZGuV0tf6yE?=
 =?us-ascii?Q?LW6LU941AbikG8G0JSPhfVYH/0EELJHE6HfTqVp3vpTJt41FVx0IbRVRpbY+?=
 =?us-ascii?Q?3QQjUZKd3sMgeWU7wZV0iAlHj3/C3GFW9sHGpzA3BvWydEZZfULCGIia6SdY?=
 =?us-ascii?Q?OEDt7W+6ES+7wTYqwE8LOXgXqh97qnQCYwJGp1Fz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62ae4ec-ffb2-45c1-f19a-08daf245e31a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:00.4142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Ht4u3bP7Poru4mt27VAbMQc4mEpzutvXev76iZlCqgqeZjGXvSZ+9tfWA9/kzmRoBSQnltIFknND2rSg1nqiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
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

