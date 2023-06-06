Return-Path: <netdev+bounces-8325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D948B723B2C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A93E281521
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A281B28C1F;
	Tue,  6 Jun 2023 08:18:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9011D5660
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:18:27 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EECE1B8;
	Tue,  6 Jun 2023 01:18:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TiSg+B3aChGu5YY7pERyInogQVjXPKo4p8AQELKfNK2C3OWvE8/Kk3L2T4OOLWVrQfL1rlCldmkOzbCIDPTBjjbHHBxYnZWNPa1+VfTL+YP3OsN1PwC85QJsYf33GANs8DDgid0hSp7NliaM3A7bOivWwy80ww3QhC5MTMo/FeKGPmxrzzV3zBHoZY2f/xSSfsEJKppD4N0zYuaBmAEJbQhMwttfbLpd6btOCCKjmEUnjyEnNDTH7/bUQin36tzndaHQ1Gl9tjUPF04T5jqJph8u13xlzkoINYXhkYxNaH511XLHGaNJkVksmsUQjEH5bq31IMaNWSLT7TJDyvhzaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+idufC7u7kZi5d5r3JYDORgmasDjRpZDzUlGRcYQv0=;
 b=Ve+aSEfN1RRCuMz60+fxip9I8QE3HbrvYoS7KaCCS91y0UtNX4y2OcDhP7Qn1keqw3OYqxRH4sdDDiKAJTVR4vinFKJjpTQc6LtB029wLePaCqjTJhnnrtU4t/JvK4UOOKyWOes0SRcbEr1JAHDWbbFkrWLJ2Gp9EmFKxm2CFARLijCa5YlXw0nCl/gvC81NQ8kIU7/EFX/RnVIleXaLn9NR7Th1JnuWaT/KukOqS+XV00rGx6DUB1h/iNNN0ZRKfXy8Mo9Ojy2CBjJ507t8lxRQHbtryNgFh/lXiuZQ1vcG//ALYnh4RstneYjdvB/Q+OC45E3D36dy/jxAS+6Bqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+idufC7u7kZi5d5r3JYDORgmasDjRpZDzUlGRcYQv0=;
 b=c9upKmEQT3mOOHyl7+4cl4dMKR6XsfKfYHEzWmDibZmw9wv+qPJvVDwo1tqW8N6S99moQiMWosQQahpj0yOiOkGNBaXM9HRFR1tmpcgxeLduuWumFkn1VG/SYCpga5E5A3dUZ5a5z9CfQmksE5Zuk0viYUiBfj09/mtHfvvjU0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3720.namprd13.prod.outlook.com (2603:10b6:610:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Tue, 6 Jun
 2023 08:18:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:18:22 +0000
Date: Tue, 6 Jun 2023 10:18:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>
Subject: Re: [PATCH net] lib: cpu_rmap: Fix potential use-after-free in
 irq_cpu_rmap_release()
Message-ID: <ZH7ryEA+5WlSRW4m@corigine.com>
References: <ZHo0vwquhOy3FaXc@decadent.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHo0vwquhOy3FaXc@decadent.org.uk>
X-ClientProxiedBy: AM9P193CA0010.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3720:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f7cd05f-81ed-4a84-c1b1-08db666697bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xs1O4abpL6dccjng26+xirFctgOyc/HqIZduYvQlpIJKV3h1YQHbDgI5UvkBgvhbRubJiYzOhplE4JG/x0aKxyDZmeVxFZ3P8XvMBhAEOzM53ylTbKPCbRgMtx4JHpbDwrXrHwT+FHz4yLD+yk2xrUEHJM+t21/QOd6c0NBN2WkuqoeEjBrRoB6ofjM6/rGHsq/KDaE2/1ABzpepMW+dFVP8ArKC+js1FU1dQPhVZWjdALYTfCm4W0R2eo9oO57iFEijhamNTqT1Fo9CffBbySx2SA8F6KHMgZXyObWYcKUq0Cz1csbv6ikelbmqu5ExdXnXVBamLH5Y7Bds/DcvXUdY40jNKjU0QVh2daCHNGMYYgrjD6B+XR/1OtbR4mlt2mHrmt1WmU625ZjYnBgSXT4zqHSbJTGCuFXrmfAKGIOpy/3/mcfJqvcpYkfZPsFOIybuhdeewzz7hH68J5GblH6+ulJZHd/Gu4dxuI9NKsrMJUYs0jU1VR9Rvkfdp8xGt38VSPZIqpjP69QitDfTetYfceBqzicAx8gyHDTZkDgf1dnlC33rmtti1Rk5NHhmXvNYxevDgCLzf5Cj1uJ8/FAx7Fy+M9Ko4Mg4FTqZvU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(376002)(366004)(396003)(451199021)(6512007)(478600001)(36756003)(6486002)(2616005)(6506007)(186003)(6666004)(316002)(41300700001)(66946007)(66556008)(66476007)(4326008)(44832011)(86362001)(6916009)(2906002)(4744005)(5660300002)(8936002)(8676002)(54906003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VvuNOsACbgO3UUBnNGarxYxgGwmSaEnTaAC7ap4qRwD3v4uvsGu34O0M7GU1?=
 =?us-ascii?Q?OIbnHdGkRTsp1IpeBtqkXyG5DWY05rdCpaMbXTbuI8+cJa7NvDLgicMICjp+?=
 =?us-ascii?Q?cSBAKVOpEMCNlVz1u8ep6tGJATJl3zBYGpPA5MwF/rtZk+M8c0xBYgFvKqgK?=
 =?us-ascii?Q?XwcBmJJrBsTrjvvpOpBtZK4/ceWm47iPvzn5OfX17VWulwiRgCcE5JI6luhC?=
 =?us-ascii?Q?YPyBMVOdWwSgM8dhEHQIB2qOPTqUHwSMIgB4YBykvVZvDOwhfgX7hF83/fj/?=
 =?us-ascii?Q?D8lbmM1YwZaRtcdVk0ZnjTW2GxC+soil8qkpdJJDTaaNzxT29QRbwJlb9rHk?=
 =?us-ascii?Q?ImnKKqd+sXAT/X2q1as393XyzIxiIiyHx28f3RjtYqRovOHp52fXswzRXj0p?=
 =?us-ascii?Q?T4DMdlZjvDQqBjMHMD/4wrzaM7e20eloI0syD5gVE+LeoMwlesvin7KhvFlb?=
 =?us-ascii?Q?LL4yL2zNFN+yUnT2O2h1pLYcQV3ahvNp9U8cQJB1UciAh9HNtKocbCCw/K7U?=
 =?us-ascii?Q?B3SbuOYvo0npD+gQAZHnxYDx16y0j1Bpe4ZbuA1rgW5y8lCSuLuFA4pnpxlJ?=
 =?us-ascii?Q?BE/cCe9R3nvo3Ig0s83bw0IhGMoEauFkr4twmzvWDEDRJC8diMcZQ0Ndmd3H?=
 =?us-ascii?Q?q721bIyEUCkSpHTa3RCvgA9ueQgJNa0uN+CJE+hJfJSXW1DPSbalf63PlP3k?=
 =?us-ascii?Q?eVdL6+B4d82XxDQNX8mmc0NW3dfMWKyul3BwIACyIbkrzAN4n6FBrUT+19j0?=
 =?us-ascii?Q?r2ypHk5DKASYoNBjR/OmtSVprswemq7g8UCWzcbvEfJ0iqIlqgDEeSCmkn6j?=
 =?us-ascii?Q?ECJTvSRo2gC5kJA1MoKxRI1hRn1suSDdMDoVWlIBhrDfzJNtuFW1HNps4bpF?=
 =?us-ascii?Q?jtDHQ7TQ+9+AB6KADGu5YgPvvEgQH0UWEXJPEMyW+BuE4fIhbx3GmThLknBT?=
 =?us-ascii?Q?qwaVTd4Z4IO0+8hflCX/xykDToaR+nvuEP4KbdPxdpN7aL8eBg3iIYdrTRpw?=
 =?us-ascii?Q?Z0BZQgZE5RQ4c8Pt9ksPWkELHuzivWj5J4C98I2PhFx5YihBvI11vi9x5x2V?=
 =?us-ascii?Q?0Eg06PnM/P6QoxFPnaNcorP8X+21A0UikNh0wPLAHj5PWIrcQVsGUpQ1ReqG?=
 =?us-ascii?Q?ZyEfGC+We8a/eFh5/1zjwfA2dEfjvYD299ETTHHzfVwpigu2T1JGSunAlaAJ?=
 =?us-ascii?Q?XmwSylKZcIVmXGn/wQAgrYFrfXchErHGIn+A+5ZI3a1T0S7r6fcMidoV7bdH?=
 =?us-ascii?Q?+8NrSWZre1ipDK2QrAoh+Qz6jYW7y8CaMKWDXvUYLprfm7POrehvNXebDu3J?=
 =?us-ascii?Q?EwAISlbnTyua4Bo+l7rUkhb5be4Qmnk5eJyRhHR7QFlsAIxulYRhYfPVOpJU?=
 =?us-ascii?Q?VZlET+97tCjGoHRhKLhj4pnfX2/w+hLTUiTtQMrwwtbEMnwQZ6Qfc2WTSHzj?=
 =?us-ascii?Q?ngRo+sr/NaNws3aBfHVTZeFrzxHxdfgwtKhqHr0zzyFlIwHnA70L/2Np3dd5?=
 =?us-ascii?Q?ClB0FU+3DqMiqjQqskdOTkPLM+KdIWMM4KVPyFoKJKCA6xQDFxGcBIYucMtY?=
 =?us-ascii?Q?EgwBz4Jap6EzzZoKpq/hvegxwRMTrWv/n0GdpKX2RFTzCVfwmpTRiqPyqNOA?=
 =?us-ascii?Q?KvyBtfZHjejkSULvEktE7v8HEH08MxKYDEBL/+PpFRBM2vgLQylUgUwBDSfM?=
 =?us-ascii?Q?l6eGIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7cd05f-81ed-4a84-c1b1-08db666697bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:18:22.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XebKMLaC6/zziPxQKheWabjodvYwfQrXdCy1HTmN/B5O4EIDbZf8xy1+an11OnKpqnU9roHRVQR4QpA/GF+9RIKyT1tmIC7VRyEL1oBxNzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3720
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 08:28:15PM +0200, Ben Hutchings wrote:
> irq_cpu_rmap_release() calls cpu_rmap_put(), which may free the rmap.
> So we need to clear the pointer to our glue structure in rmap before
> doing that, not after.
> 
> Fixes: 4e0473f1060a ("lib: cpu_rmap: Avoid use after free on rmap->obj ...")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



