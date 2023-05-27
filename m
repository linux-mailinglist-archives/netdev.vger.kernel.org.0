Return-Path: <netdev+bounces-5901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2237134E4
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E63B6280ECB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBFD11CA7;
	Sat, 27 May 2023 13:07:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F4420EB
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:07:34 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2124.outbound.protection.outlook.com [40.107.244.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37289F3;
	Sat, 27 May 2023 06:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUXmwBy0+zS9r8dPrncpv7PY86BCYh4mC1xXXbBncYW+a7Cr11sFV4aUnnvEmHguoQA4gSLXUlbrZ7jVDhKsxZDuP/zxAY3yq3xj1e837iK6D8WryKR5vcsLkGHzd0YOhSru/Bdocu1GnTjD420FpihNPXNCyzoDgDXW0mCdSk1Tu6VTfZcP5x6DQGoMEwIo+88E+JjYeB90DQK/FLOsiKKg6Ne4WmIuqLjzZAmBnGS/2oJAW5LUfaUCdY4NZVfOobVUQjwHRdNLN5G5+oFa4CzdssK4kJGQK4J5IRnzIJ5xS8wa39V9Ii8QofSxlKrlKpt26H1iNsTp1fx/sINLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLspsEb63WH9WFsaKHPrMjsvF3ZrzIk9uLADg3jrqwI=;
 b=O8Epq1hHoOSt4Nb5A7fUoqcwuPn6lunVijq5MsLbZGy6GLy71LpYirSvnpfDBw5WbQSoaBL7UdYVPdSgflWH3J35P0dMww6YB836/sPsuB3DwoGXFugHjKpZLGHHHvIb3xlPy3VaYZIFvXJrGqnm6XhqfABI3kjWNSxk++9lH5xhxtJgM6gFQ/eTY7w+UPmM1rZJCWdo0lKcvEhlAy3/H83/Ja44ides+Ma+sR3LKGVjaKIu7j2m0mUslyLeX4e+JDsDzQmJ3I4RyPn1a46k2mEJTGZu+9rZSjxlOxfDWXIFrP53npx9zwnmrfrIuIAOL11H82jAPobJvh3aMg4Sfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLspsEb63WH9WFsaKHPrMjsvF3ZrzIk9uLADg3jrqwI=;
 b=rfMDlPUgkgKPe9Yya3kjAVdT3mBU/o4wb+nvcLdm0EgNkllVMtG1f32L9sWTdH0s8NzWdgpQ6w730cN24p9HuNaaECSmEdioQzd4QBMvDDYK63nZzIUBQP+SctLc/FZcCRzgaCO3MmrUhBggVFLnQ9rJLFvJRBxQlPvK27VXC2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4643.namprd13.prod.outlook.com (2603:10b6:208:30e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Sat, 27 May
 2023 13:07:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 13:07:29 +0000
Date: Sat, 27 May 2023 15:07:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [net PATCH] wireguard: allowedips: fix compilation warning for
 stack limit exceeded
Message-ID: <ZHIAibPKikGjLD8+@corigine.com>
References: <20230526204134.29058-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526204134.29058-1-ansuelsmth@gmail.com>
X-ClientProxiedBy: AS4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4643:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a836f3b-c214-4dca-7463-08db5eb3533a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JHHz1X/+EQGaejhaZt+kEgmWB4jN6gxZrrDPyy2JaNGzEr6ANbOdnLIjGin7aL6s4GbUTGIwKe242kiWG+U5YFI8dJZpZuckMj7jGqYa1oWDqdU97OHOwUq0mRIs2VQnNHhHGSVMvlSKSHzCLZISB9qMAJFO5tKa8Q6qdXhbmvtxH76iOBhenXN6eePQjT1sv1ke3ZSsjwtAbjm+aLfXldv4VDtyHcduXAeK+ciTZMTisTCcbB5e1HVrIkIPzrwWrHuplN5K1g6QC6311zRbvmoi4/eNeWURLrbfdgDXe/HYdqsO1Kziwu69engixv9HyMXPBnOxKLNMxcQY8MoUAb4L9t32jY7N7B7EVBfNdZvBDgtZxErXb/a835u8bMdctS1SezaJ8Q6nOVnSG3Cud4u8ZBZKibIBfSzM1EIZJfJqdeIJ96QWlA/5cR0wYt92SetVIhV6FCZZthMz6I5mDUIhxevoIuxtL9qandAF1oxBlayXrWda6hBA51CJsknxcGV3Xa2i7bDrGjmPf5fSv8AVH3jLOZxaJp2efPt5Sg3IirHPpex72Yb9QxabA7XXH6Otuudn1uYSl9zd7fCLlC2VqgM8vaLOac2BUC+VoaI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39830400003)(396003)(136003)(376002)(451199021)(6666004)(316002)(6486002)(41300700001)(2906002)(44832011)(8676002)(6506007)(6512007)(7416002)(38100700002)(8936002)(83380400001)(5660300002)(36756003)(2616005)(86362001)(186003)(6916009)(4326008)(66946007)(66476007)(66556008)(54906003)(478600001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Np4hPBc1+IQ976NY0Fk2DKKpwyuapfeW3qb6/FpSTMG2K6qROZVEAMHYb6pu?=
 =?us-ascii?Q?iFv6g7J4tOIdN+raAjYO2HdxuBJU7D1acNA405sevWcsTmAau/qHKS+IGOgF?=
 =?us-ascii?Q?ZwMRMGUVW8maCKxoLEE/uX97SJUHuDG/GkPxbekB1xJ747kmcudkXnKD/41u?=
 =?us-ascii?Q?r1jK/USyFjdJD5OyXnraV0t+rbVJ4PlNPPB1WbOpLbE1iq25mVBmEc7lPj1/?=
 =?us-ascii?Q?U5t6g41v0chUCxRLZoXR+VxRuZwURsT9SjhwpodARtweVLzMQGoJudnZTj+V?=
 =?us-ascii?Q?WdfBrZXodvBavv4dSeaoTsx82YrY6BtHPxznbxeG6ZZL4o3qF7iZIwYZFZ/X?=
 =?us-ascii?Q?w4kQTIYTzT5iHQZNdzKWPX3fCjqJRzgKKQPO1Q6RAHRhh/NIxcrYD6j44BaF?=
 =?us-ascii?Q?ti8c9JSwB+Dmm2U2UVacbwk+dP8VKPFQZu+t61uZvANqAhTd+UTlpI75TPjC?=
 =?us-ascii?Q?I3xmJWYoB6PascDdyErASROSQ8B/EugsFhlS43+jChZbLeG9Cna2nm8hG0EK?=
 =?us-ascii?Q?m4FCdBPRTCkpKHZLUvTMZr6Mo8A/UUEpf4kHaEks+axaiShEhtb/5zIFl5g1?=
 =?us-ascii?Q?sa2Uu+U2xkPubRi1SWoKIxWhmHQ0PQCnOfts5JUlPcrSvne0skaqjYb4OZHw?=
 =?us-ascii?Q?wQUDvb72y3Jeqj1Hp3dKHgL0r5WpStUuSyj+TKOph6ZsBBjWlYjbJAK2g1I8?=
 =?us-ascii?Q?CA59m52oJDOFRRNaE34D96tuw2CgxAZAy9xsxDZigR98eIwIS/wDhvFm6hQ+?=
 =?us-ascii?Q?0ifV6PIe1iyAGuof6zaMCQ1j5gYET44VQqzpYldUFX19yy48rxWP60vf/Xoe?=
 =?us-ascii?Q?I1JTgCVLcBsfLjZGjbnRYqIr0Vhao7dndb5X+v9WTSNfIxt9A8h63Un6Ykqi?=
 =?us-ascii?Q?0zQC8rLx7P+zLX2Uc7SvnZrW8zd4PWcH8NEIxYapsySBRvtt3lFjUpyR2qK8?=
 =?us-ascii?Q?5ixcSoGERlq04qeBLFJD3uLsgALMCZ2bs14Oyg+/tPeEGJE2OMIrrAmLapPP?=
 =?us-ascii?Q?3OENkTxlx2J7Uw4hHVog2I+k3Z+RcnaPJfx64w1Nce3NgwCYhiDS67Nkhh6Z?=
 =?us-ascii?Q?oLYcMX4KCoswGq3ykjU4vEUAbDtyRoa6dIK+9zqQlqosLGmbTL9Z+yCN84SA?=
 =?us-ascii?Q?68fV6PnEMJVhMIWAaKhBGbeUObQnwjLhbb2bvw20qyWtRUlLOZNSgNLaWq5C?=
 =?us-ascii?Q?R5Cr7gKKfUh9Q6ZwLj7v15er5UtYQhFkTzu8CeGuY8BLcvAn4K0OQvp84QUP?=
 =?us-ascii?Q?cvYfNwgptRFkS9bAnX1LZ4X40r6zKFiBgAu3PVZmoMlOs5TXcAfP3P1XZwud?=
 =?us-ascii?Q?QeuJYUY8XeuoA5QjgPXY4c8LdfQqUzC7a3QTCZsXUfgboE7PEaAABgox76SC?=
 =?us-ascii?Q?CXsk7pbPsCKKWAAfYygKGOoN43gbKKIZL3h48hylLEXcIm+N69K/mXqt7xno?=
 =?us-ascii?Q?C034W/G77Bt+a+IgtzY24tlTINcFhBzFXVxej9ImMZ53yRZ2LmLKiVAWYrH6?=
 =?us-ascii?Q?5xMPDccJYKM0E25sCGNPtKEKfvZApyrDc0S0UzTKeqm0GvVDlqwVMJgRYFVi?=
 =?us-ascii?Q?TlxieLtHyRxc0ExWiJac6LhuNrJ/FV8KdtqgxRlMwcHIqLmHG/v9Pg+OosgH?=
 =?us-ascii?Q?0NC2ZUjWmjk2DkGHjAyz0xYJ4CmNEMT6pbaZOsvIxQ9RgcSRLEWkEva5aqnO?=
 =?us-ascii?Q?uW6TGQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a836f3b-c214-4dca-7463-08db5eb3533a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 13:07:29.2973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXbwCLCdmoV7afS88FTJdovZC4pp3vWQKQhmu4See1W3wmEmKl++WfNgy/tFNTWNhy3pQ5FnJolU6QHHKfZCJUzKDQdfJwd3+tpzTnDbKIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4643
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 10:41:34PM +0200, Christian Marangi wrote:
> On some arch (for example IPQ8074) and other with
> KERNEL_STACKPROTECTOR_STRONG enabled, the following compilation error is
> triggered:
> drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
> drivers/net/wireguard/allowedips.c:80:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>    80 | }
>       | ^
> drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
> drivers/net/wireguard/allowedips.c:67:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>    67 | }
>       | ^
> cc1: all warnings being treated as errors
> 
> Since these are free function and returns void, using function that can
> fail is not ideal since an error would result in data not freed.
> Since the free are under RCU lock, we can allocate the required stack
> array as static outside the function and memset when needed.
> This effectively fix the stack frame warning without changing how the
> function work.
> 
> Fixes: Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

nit: Not sure if this can be fixed-up manually.
     But one instance of 'Fixes: ' is enough.

> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org

