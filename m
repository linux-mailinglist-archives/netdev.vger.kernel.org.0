Return-Path: <netdev+bounces-6536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4810716DA5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EF242810DE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA41828C15;
	Tue, 30 May 2023 19:35:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FCD200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:35:59 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD7611A;
	Tue, 30 May 2023 12:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMbHtbq+jVzoZamDzGUoiqgReZXtsvXUftAksKBSO+UmvksJfsRRSMAgFlkKTC7oSHCyWm6smvruqr9t3tVvSEMdnEDDw6FNEZIDeY/kbENG0/lf4cUXCW+qPcV4WCldsGL8MOYggld6WPN5031jCElhKc1rSkRvytQjbvExbmnyfKSo3ZGu5gTq5VqdhCj/FlmsojLDflVzQirzlRLM5exv0mIRsMSTgOj3KZJKeNbFeNj/uYinpFbkoEsYhCIuaHMCGcdVyZ+qLsGnreHIBzNTjW9QkfupsQD4aF1XHFlISTnRcvNQVTRxgCDmXAehbKX1ZPgOUZjV1yZzEKGiYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bywrRULDtWMXbD9q8bK7DujeGHhWUdiLd4bVDtxJ7yw=;
 b=oSxJn1+Q5lJ12BsbNXkh1yjiEBiTYm9mFk+7fp0LJlu4S/r7TmYxtVqPYpn4Gf3357elREnzQrwr1YVzveciC8RULGREOLUga1naqXg/35nkgZlBrvfGGNCYKLkY3D2vIQkt0+1zaHUpC9lwDzSUMCT1fAgzP9BE6Mf16a5Z5gzs4heywKmXWWBGi/r/sjUg2j0k0GFgqNFTrC6IIPMYBHCbhczVKXK5qTEOdcUrHGd2sovBphgeuYETVEsgB30qcHpMo13xs0bEC4vTUFP3tfcfPo489lC+4Au6r5lLnYPh7FRtMVovyM3ne6RWkla2u8U8joXPcK/mKNPc3hOesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bywrRULDtWMXbD9q8bK7DujeGHhWUdiLd4bVDtxJ7yw=;
 b=QXKJCOqVH/3PRPOqUQv2Tco+AWyaacwMilxrs2BNDFCIqSYFhxhtxglVL5vSahK0EkN89nAXqhLt+cHnj6TZr0itTJv4wgCnvqAGQXHZa3ro/54mv4aAE7KwzDpifoLBmGw5qcUz9DHYepUVHeTceXBkZ6uc/OZfvaSJEQP06lI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6352.namprd13.prod.outlook.com (2603:10b6:408:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 19:35:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:35:46 +0000
Date: Tue, 30 May 2023 21:35:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix setting of irq->map.index for static
 IRQ case
Message-ID: <ZHZQC99+0ccZPdvF@corigine.com>
References: <20230530141304.1850195-1-schnelle@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530141304.1850195-1-schnelle@linux.ibm.com>
X-ClientProxiedBy: AM0PR08CA0005.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d38d4d-f3f4-41db-2645-08db614510d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2tPz+IfVRGL6U7ZOw6vLr+9LexUhg7WJbF0AV2k53lvPaeoX9rSixm2sSiiq36YYRHO4CZ5g9qbdrhB3y6hD5UNt7vXpKWgHjoIqhFeru4h8Plo+QFQ8Hrj9hL/cnnMvEAo13eyvNBq4Rpk/9voY2Z3rJzMo+gfvVo8vb/0Jh8xxnrSiwlFBdCl2ro3MZr/0TJVe1YQcD9fGPlVMXkyVruHOLRQB6ZFHPQ4v3Q/uqeEc5CvXM42Boweap5GrOrWRy0vR8drIfmcHi71J1teCvmqkSxiHKJCeBOrjB4lZgdgGHLlwwPno9UHy3XXqLYd7PTWlYD/jtIHnxQBGruUaoCTusRwhm39AsimLM6CerjQuNlk0tq0vmGUY49SWZ1HAYcIleUIoPvSR0lWS9ZDSF0SgFpifFWJDprly2YDRtuDPRquj0HNuh4IwpmGt5ckiZCYRcwWAyP8qs/zc2BxZJ6AI34J8f6ClhZWShKqbMyv7857wnF3neL9MeXnOAfAGv4wGX7+3kKxEOhHZV4mJONzwALbyjtb7hYEfN3VcGr/APp4USPJZDL/l9dBtph4TDe49JTs8j1A2cuw0geXoa+pyo5HgWouFtiSknX2fVBs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(376002)(366004)(451199021)(83380400001)(6666004)(66476007)(5660300002)(36756003)(316002)(66946007)(66556008)(7416002)(4326008)(6916009)(38100700002)(41300700001)(8936002)(8676002)(6486002)(86362001)(6506007)(186003)(2616005)(6512007)(54906003)(44832011)(478600001)(66899021)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XLaOfH1jIsbJI9tdGYIPkbeWhFp9tmrkibMoRypZs8UZIHwhe+w8rDRLuXzm?=
 =?us-ascii?Q?ISGxRBV3fK1GcORCVDfme4iuC4ICuCOf1uVRfLnJD2xhRJ53GGS4xUugh4Z9?=
 =?us-ascii?Q?yj1S9V1MmuceLy36MfbpcU22bQb/S5M9AEPv4Bkuy+d4a1f2wrCwFsVVKt6h?=
 =?us-ascii?Q?Hx0wJ6nTKcu05dDZGQqcxmivmxegINvjF+VZyrdqJ6Hy02iDStDQ2P6+U9up?=
 =?us-ascii?Q?5AlDrF2JscBd27eRDI4rfWFxyeLW0kId9zrLZSLMiRRElKbPNg5VpFIjr+uZ?=
 =?us-ascii?Q?ztMC7SLt5nGVp/t2lazVICvcR5627wVUIZuo/DtrduqjwQUHwe6+BtX9eRUD?=
 =?us-ascii?Q?uiR9OvML+slprQKzIOZ4fAu44t3m+lrKwhcW7XyEOVvaSFl6dpDS09ZB0jt3?=
 =?us-ascii?Q?ZNQWke+qhqmdxAqZIJ9sZbAUjYGcUbYsS8rPzJMPcP0SCQwKmdW3IQkiQ0EA?=
 =?us-ascii?Q?s9jL9m1D013FFxiq/P1ILcvrAMyRjH09zuC3YTtQ6dQkHPW5gVYPj3vuoahi?=
 =?us-ascii?Q?kCLUiWgqXhSxkz0zt0Agz6SaxjtLLNVlQC/j/tQ3K4yJ5WjSOJuUyKTsfpzV?=
 =?us-ascii?Q?jGuqJIsXITNGLHhVkit3rMddxbvLUOKuGaP92mohh678yDFOOeNW9IMtT2no?=
 =?us-ascii?Q?cwD51ikoXQblmroQAiG06ab3c+cYBsaF13iah3LCycXkdow2IIx0c7ulsBVh?=
 =?us-ascii?Q?W1cHGufM7mmdaVyKusUiqqoWmq2UpoM123AJXlPuvHZNFcX/41fu02s6YBSU?=
 =?us-ascii?Q?/C+HGXvLgflNQpHdHI+CqIBXOkB02iEkPuSIdgH2X/0Th3VClrZaF9QSTP3K?=
 =?us-ascii?Q?JRo6P2n8fk1KICHDkXYwWjtipBfExL8XJqvlPyHRllZ/vCN5vFFCv90WeI7q?=
 =?us-ascii?Q?o9Zu3MP3XHWSBccvnRsl6I0rW7obbzPtysVXsFUjb2zBrg+XatGXc7OPbHPb?=
 =?us-ascii?Q?Ibf0CamgYYY083UdTeu+eH0IwK6Pnc1X62kylXgYObOI4yGDFayazEspp/6/?=
 =?us-ascii?Q?xkPixBIKBPN3jHv2AnIlOOuiXzCG+MfPdAGl5N4lQM0CBuk1SggdyJ7zSC0c?=
 =?us-ascii?Q?bTTlcCqI8wSiMLaIUgpR9zWqJcTLcBT//eP2Pt0a6vvIkRTzXhnQqLOJGkIe?=
 =?us-ascii?Q?AMHgfVJBPAtg/gsOn7upICS43SzoBiYWr3wk86zQ1lv8303hQ/vxqQXFwN6M?=
 =?us-ascii?Q?XPF4PmWfskwF3VPOJRbs5d70pZjExU4yFjrQ4XLhJXjmTUzNBtTyyIEWhpo8?=
 =?us-ascii?Q?qUxqSs1U0C5EyFpff0UWZFLLOontSCt0ix8tYR5/Za+UJmixjl20vuXhYex+?=
 =?us-ascii?Q?10rduoTWtMPxYTtbZJeT9Z+vXvKfftaiAJ5AjdMapY5j6V7kzxIMNdommqJ2?=
 =?us-ascii?Q?4B1ZQq12ZUJJZtSo4bX+/MZFs6Fiqkrsdfsvz7EXzu6YXSqu3C50O0GOI+MW?=
 =?us-ascii?Q?t2zqmcfo/iihgDr8+7ZE+6CW2CcrU39QgmqeZgEvEhXy9UJlxQ2CJELdy5p4?=
 =?us-ascii?Q?ngDG8iV7q8UuRhJm41yATaGcsf84ww/YdBcBWVDVeVeg9FAJNSBnzG5YmX4g?=
 =?us-ascii?Q?ddxTo68slQyuBI5j5ZFe7uYKbn1lhjmkebY+21UJVvU3iClz8KvkNyTPOb3A?=
 =?us-ascii?Q?CGoL7/RaDGOb76bWZZZphmuyQeyQxHyZP3o/NADPYaKSBD0JMhaIlU8xVS/8?=
 =?us-ascii?Q?nzMoYg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d38d4d-f3f4-41db-2645-08db614510d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:35:46.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mgr5AAktap9n3Gb3Uz8jy7CArOnbysXSAcvS+AO5gXpYeGSRyNpI7eje+iveAJPKGiTp02yP2zGh7cLKfBn8uFHsJE/3hI/fcZZ92T042X8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6352
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:13:04PM +0200, Niklas Schnelle wrote:
> When dynamic IRQ allocation is not supported all IRQs are allocated up
> front in mlx5_irq_table_create() instead of dynamically as part of
> mlx5_irq_alloc(). In the latter dynamic case irq->map.index is set
> via the mapping returned by pci_msix_alloc_irq_at(). In the static case
> and prior to commit 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
> irq->map.index was set in mlx4_irq_alloc() twice once initially to 0 and
> then to the requested index before storing in the xarray. After this
> commit it is only set to 0 which breaks all other IRQ mappins.
> 
> Fix this by setting irq->map.index to the requested index together with
> irq->map.virq and improve the related comment to make it clearer which
> cases it deals with.
> 
> Fixes: 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


