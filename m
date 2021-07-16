Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FCD3CBA07
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhGPPpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:45:10 -0400
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:35168
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233204AbhGPPpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 11:45:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPgqL+vD4XZF1G7/Ir+gyITi8qO3jOZozcLXbHY0rCg6vm9afIzEyKrDv/rJ4gf/0CouK0F1BaAIzo897S555Mai8wdbrn6FqlJ/zDXlvWLPt11yS6ym4MOb4Z397/BFJsjyWlR5/T/SG1JFlegkWIc6xAe4SLI1muEXbxQKzSQPEPaXfiPTxLeuq2LLgjwmJqkxk3+79DSW05wU6O7WC+TGdw+haawEt/O4cg1Yay3lDGFz6GlgBd/1HxPM5vddZ7TAF6e1vl9PsVxH5Ls+VGMwM0S+Fgp56ERw8kVloVjA9pkHJCWoR25sEXg6zuFaO3bvb8VAXwz/Pd64fzIDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJYT4NkGfjBl72eJq3RV9yMnIz060bKOviHjAAj/6D0=;
 b=ECyI+2Ri9lYeCtmjpNMCgzE1OhAH4QjXSsI+2S77sONEVqjzoFZEIw29hDm9W79MGd15/SzS8o8NzKw7+KIpLZH+Ub+69CcAvzRB6hYON7OEQKONjJ6Rnll+CXk7Ef77raCg3oPNpD8SsyaxSgDdGA/S0TkWzEu01g9Ka1J8uk/F31dJ813nXkJNjtbLxcqXFHLlvFzlWiPC2lnlCzBNdmKK8LXqmT9QLQ5MQlXpiahUS8RtRzvp90FOyxNEzPqCWgjx+3MKKVI8HOb3rRgBsMqhi8TTT+vjuLvQn/BdAgJkymWGL+7AjH3WWj5q58waWkKvDPsyKTs43c8x7HqDWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJYT4NkGfjBl72eJq3RV9yMnIz060bKOviHjAAj/6D0=;
 b=QUl+87LLQOMj3ZEXGDLh04Wr4rv/+A4J2prxjq8QD6qkPPlMqTTwkHVlkzk3wE0SBawm9riyXQ1akTxSxe6DhYYkXc0JFfsUzuYE1y64JPhKyB+ERdaqsBWfQFaKXh7+uxLpweLx83VXnHh0F3dM03dLfeVsJZEZIRBhLrlcJyc+1+KdjSyD5Q2o21SLpbXyafQGC6z/K1z+XuyJnD9YjFeESR0UMppuPKywCdS8dap2/3z5e9GZOhd9TfnFELkxODRJSthShXp8/mbJY0O9SSoIcg2EmmMJsxU3ov6lW1i0YCWnufWbW5hd/vb8CMbPrpZZDH68F7tT9fROyhTVvw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 15:42:10 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 15:42:10 +0000
Date:   Fri, 16 Jul 2021 12:42:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/3] Add ConnectX DCS offload support
Message-ID: <20210716154208.GA758521@nvidia.com>
References: <cover.1624258894.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624258894.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0105.namprd13.prod.outlook.com (2603:10b6:208:2b9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Fri, 16 Jul 2021 15:42:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m4Pya-003BTj-Uc; Fri, 16 Jul 2021 12:42:08 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 353a5e63-0c21-4341-4b25-08d94870460f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51276EFD4C2469C75E9B8609C2119@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWCnbM8SY1aAESClay9l3KgDbS7h77LN8z+7Q0JpNudQHsTGoxSIpznAKBW0c1L9UJo2qa+f01orEjnTlJv97lNrkhofz4h3+GGpqCsKac/8WYYFFAd3HYBdNxZ0NRxX3LB0ySgYXf8BuYpC10x9tZ8AowH0tED1ezHOOtK2lKpBdxO8m8NbH3ATKp3rbNVDaiGfdK6gU/k+cXzcrTnVsP14wHgdwQd8IMmlgERmjG8PYfi1hlj9yi/oXtFA1oPN7YWaAXdxIuCfEdYDJRYNDdmO6PboPqq6XCuav/YO59OBGtkPhcfH1EV2AEsgKzlABh46y4hi72TujbymQCTmn2adAkR4/Fcr/osBxyhqwaVLUngKDJKRoO2oDCOAKGlwosYdN/E0F4ldv6Jp0HybFwj/S7ObCR6LzuD1bfqtl8gucPCM49371TH9A35Vtr1bK4O5ZJn1+xyYJa8EeU/cRCFfbujxNLsR/5qEAYwGG4cm1gMvWnbsZhTz5YEKUmtN9gcTe8TLHtEbJddwKKWd0tPeuSu6d2xIdz85E5RstDKTY/rGc0ZinHTzjCRrxu2PemguidWRprmOspirD/A0zLhyuv4tivienAWj3NbIhdiurvdA8pGdlXuK8ltgmIHWC4YfMZDJeSI3u91BzuYfnDfKZHaqW+m8F/y0+CSKdmqBanTPmzBvvHEnQU+IRGQDolDQlaErGtnnLguegOCbUs2xG2QPSRTxPfeT400FU/tHjXVejHCzX8TaNP7iaaYl+GTBm8RQorfEOfH0P9eIghnPV0tflGKEdDMcrlkL3O0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(4744005)(5660300002)(38100700002)(2616005)(1076003)(66476007)(26005)(66946007)(9786002)(186003)(66556008)(426003)(6916009)(107886003)(966005)(83380400001)(2906002)(86362001)(33656002)(8936002)(8676002)(478600001)(36756003)(4326008)(316002)(54906003)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p13SdbcLivsMcdvRu+vJfkg0vhA7MFogWPUl1qK1BUowi8E0Ld188TO2iriK?=
 =?us-ascii?Q?Z3+aH8fkF7TrOHIpQ4k7kGVdo7uuuhvqVG4AKlVLlRFJsAeQwhlgak1ULhY8?=
 =?us-ascii?Q?ebNCMNmNEtljXbyHyAf0/L/KhMWPPKUGbgOjcIllJuOjU3ADt1BQZx1pmZZS?=
 =?us-ascii?Q?fRAdgQUFiIMPf2D+3TA5SaWnPCI+6JVtfNsK3OWM0UdEmPjGVVK7bazH+Klj?=
 =?us-ascii?Q?5z7u2YsMV+wpAxlCU6cpN9JgpFWUV39h30Xd74q5MG36Kh+HY9u7BVHDJfF9?=
 =?us-ascii?Q?0hwb/wZYVZzclZjZjrPPzqh4qihu7bt+npSV2LR3zDMLgMF40A0X/wcM2gVw?=
 =?us-ascii?Q?reb0rDCENJP5tQJErU/N8PmqAN6SGNK6Spa6KZ1jXsq1pZopI2buq7CPTDec?=
 =?us-ascii?Q?jkR4ZDu4x9622u08glU7oIB1QEP0cSVCaSPz6/EP8RotEVC7TWvft4H/z8UM?=
 =?us-ascii?Q?JkAzBhUkHJ7N2ONUmhnA5nZrD3HGoQPxbxxpCFSronLukr3Huuh8/GhNKkRZ?=
 =?us-ascii?Q?QnlYZB6Jw16Fc3Zu4YlmwziEi+Kk99zhqZdZeNifDPjHvIDR1zRDup8VQg1K?=
 =?us-ascii?Q?ZJe3FunCWTcwq7szqieThSAupxAdsHlu5fo+BSiA2HFFQGQTS/etGwVa+9B8?=
 =?us-ascii?Q?Xa/TRyla7c7q8TruCbKQ+M/ZWEURn9nAfvEGV2a7tc6vNgb4DyOS99Rop4JP?=
 =?us-ascii?Q?i0p5MpAqTnHQV4jt+40mOV0XdcdkynSa9lpV0FPKRw2+iEwIKhU+OvXAkWQG?=
 =?us-ascii?Q?HtyKhHxCuQ/SKpmWSe7Ds4+6ICuuh86XkaXLIBj4Xh3uSDFpA169z8eK+BQT?=
 =?us-ascii?Q?tzk1S3lHKDS4xutzNA6rhrkPL/3Ca34u2KuAbl+ZW1hGtN8QHAV2gyfRTE0J?=
 =?us-ascii?Q?j0VOtySooSx3tqgONNSh1lFYmz0WfpzJh8oNx4wsHo0lNoSPGI0jgrYqv2vx?=
 =?us-ascii?Q?nlzwX9SupD5JzTe3i+rsqDdnEydmp6o8no5saMwSZJbR4mg1vAhgRI5t3sLX?=
 =?us-ascii?Q?wHBTuDBFePAxPboCQY/ZwNc9zfCuJDoMQNG4ebPgtRz5r8r0Z19hLboC5ZQD?=
 =?us-ascii?Q?4rLeMYkWpuQAzal8Y/KF9VpNYMXbuqrtKJuXjZVPxDjdzo5hgoMJZc96njS1?=
 =?us-ascii?Q?/YOAYDxfI8pJYtIBovivFwvIjw31xjej7Ek8dLJcgN2p4EBbJ7tCd/WUK6LL?=
 =?us-ascii?Q?oEhTD0XEL++iJpSc9ojLNXbC9LSiaRey8c8V/oVPsHDKtbn/x6E1y5T5WUXl?=
 =?us-ascii?Q?HLxsXnJ10ZzCEsY20jMaRv+RqZQij2NaPSC6AcMzF47pApOFZIbWvoUNk5My?=
 =?us-ascii?Q?roBIRRz/foSERo8kg14q77/z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353a5e63-0c21-4341-4b25-08d94870460f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 15:42:10.1477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBZeQcz2P78J75sibq0C38mge2Saa7AicD2GrolkyEJ+xpnTDluQru/e6DKPhnge
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 10:06:13AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Rephrase commit message of second patch
> v0: https://lore.kernel.org/linux-rdma/cover.1622723815.git.leonro@nvidia.com
> 
> 
> This patchset from Lior adds support of DCI stream channel (DCS) support.
> 
> DCS is an offload to SW load balancing of DC initiator work requests.
> 
> A single DC QP initiator (DCI) can be connected to only one target at the time
> and can't start new connection until the previous work request is completed.
> 
> This limitation causes to delays when the initiator process needs to
> transfer data to multiple targets at the same time.
> 
> Thanks
> 
> Lior Nahmanson (3):
>   net/mlx5: Add DCS caps & fields support
>   RDMA/mlx5: Separate DCI QP creation logic
>   RDMA/mlx5: Add DCS offload support

Okay, can you update the shared branch?

Thanks,
Jason
