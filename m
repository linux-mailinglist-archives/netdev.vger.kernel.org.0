Return-Path: <netdev+bounces-3318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49EE706684
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 814A8281016
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7A82721E;
	Wed, 17 May 2023 11:19:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887602721B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:19:40 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36406A5F;
	Wed, 17 May 2023 04:19:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8x3R0FoCLFtEy8RaYKKPKoS8XJnyNIsa0WqZXBuL3v9WZacKvUsZqQEVgXg/EEIlMzQi/GG5gZ0D3y+3uItA3/L+gh2KWP1fBqnr+zIE7hCv7TavI3pjvmusofr+VHRj3m9qyFGStztCkyQ/oC1lh3xNuJy4n9pIdk3Wz1OmsIu+AMbDrSLu6QrcRaKTRpxppAIV3J9J4/Ycs+NcwoQkqw01fBPHAB3w2Iu5kF+MKI1ZFsnz2TkjlZFBvS1diecGZp5HTBzA/I39FvQXYrRo4pHxMCjjn5o8h1Fbyg1azlDFssmCucpnxujbcwvnahtryIlZBBI3CJvtY8m9KQCOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBxHf0emmQZ36V+QC7bQotzwRtZRNv7M04UQiQqsOwI=;
 b=BHcbowDY4SsB+HFcSx7rLgHXtn9JLNSH+Pn9qmo8Ojr/2AIU01vyLBln3DLhmZNK41J9hUCLU+6ahBmHYlRx1Oh5fL9I2aWBosoWkilajVg55JMMlJ/lfG2ZuKFZYehyuVo+Bv0PNp3pMvUrD/4VU7ThQ1YZnjLY+WucpfItWpUz+G6BqpVKG3ktEr80bXaUw88P3h2EsOkF2JrN6CW8o4vfPCJgqufBaW3aWlSOBz1mXXuHbaL4EJjAz6yFOCwIXZMucCmcDnWWEy4kKkI4U8cFRQPtRWXgoBQQLYf3dLyj6xyOvv3SAzBvaGEbCKkoV0Obbfgs921WkiVCMifj3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBxHf0emmQZ36V+QC7bQotzwRtZRNv7M04UQiQqsOwI=;
 b=RH/pLQ8l0MTeO9tsSe5KhMi6Rql8m+/qAkvjihXiHIGn21YA4rw0jVt7+3c/9f48dtrMJs5YxD5DLUDxv44vGzVjgNsQ6SVgE9glLpriZbyQmEcxXEi2weyPRZiFjlbC+Rat4L4h4JWOBqFIomK0Wxh17ijpuN1GEPVUSiaV0HTa+Ej7kALIZXcdaDZA2XOObs4FJkKFLz5DH9BflPvGaoAFCluvxz3JLSjMvb8W8tfinGCrUzGoj0p5GrZe+cqOP1W2kCC33AZ/ZRUgR5pQBUZh7fdsUKX2+njMClPAN10e2e9+0ByBc6CEADBRoCu0CQrP8C/z26ANDJ/jzD5ipQ==
Received: from BN9PR03CA0877.namprd03.prod.outlook.com (2603:10b6:408:13c::12)
 by BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 11:19:21 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::24) by BN9PR03CA0877.outlook.office365.com
 (2603:10b6:408:13c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17 via Frontend
 Transport; Wed, 17 May 2023 11:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 11:19:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 17 May 2023
 04:19:05 -0700
Received: from [10.223.0.108] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 17 May
 2023 04:19:00 -0700
Message-ID: <fdd518db-a759-b520-fb1e-d697d6f08682@nvidia.com>
Date: Wed, 17 May 2023 14:18:58 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 6/9] net/mlx5: Use RMW accessors for changing LNKCTL
Content-Language: en-US
To: =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	<linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Lorenzo
 Pieralisi" <lorenzo.pieralisi@arm.com>, Rob Herring <robh@kernel.org>,
	=?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>, Emmanuel Grumbach
	<emmanuel.grumbach@intel.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>, Lukas Wunner <lukas@wunner.de>,
	"Saeed Mahameed" <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	"Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Moshe
 Shemesh <moshe@mellanox.com>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dean Luick <dean.luick@cornelisnetworks.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, <stable@vger.kernel.org>
References: <20230517105235.29176-1-ilpo.jarvinen@linux.intel.com>
 <20230517105235.29176-7-ilpo.jarvinen@linux.intel.com>
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20230517105235.29176-7-ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: ee7f9d5b-87be-4d59-863e-08db56c88fa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lS40t/O1vlY0kC6QxygEcx9RLW/UKZ2RidSEfs+UtYNCzpdazQUHPEzC31zpDZUyXc6/wNZZDnZz1nvjRYczpJLuPlSO2jBbkLTeAIS5pRPhWSEZJEuzMXHMm2mnTkhkxAy0eQQd479WZMTZtm1p2BrRmxEKN2NItQjlLnQM0gbRM0AJgn0dSgtDOKebIg5CqPXs5syw+7hVE3c35Is1GVn4186O59gpN+7Y16pez0yBnou8nFH0EsdGjZCArQKnke3wwsvgI5s15exZkbBuAN8gLweKmzGmaIyZ3k262I/BeRLG6iATLrdOCygH73yTLyY76mXZLVI3miwQ11XgFnVlOKGyECiLne2itdg3FjU1QCh/nEeEZoQlg6Wi2M+o2sM7319u1FSVVPiVcZwRMTyHsoJ3/B9OpIxrJwVrbJoKjO3yuqj4XDTA57eEqI3Trf3PX2dmRWZ2qukBrvyXDFihlkxAYwWIPAXA5suG45vLryJVJKv1P9AVbeY3N6+E4gK7ahp1bvv2+dlR7V5RTo49O0n8xgbdWsUvi6Hk0bhzTD7NxKosPxdnb/f3UWV8TuXUShUFoO9Jur16vTCcyIEFzV//48suYMfd7TuUDf0qtcX1651Sx9w8dVGzC6riPphkc6fE1J9Sk8Xu3bEH550SfeuzB/nv0sxaung6x9kkG2BavR/ER3pIM0H1oBnW94yH++HM/vLshzcAbaYKCEes4AHhcG0976UYVAcNd/Jus3uzliUUdpv2S0eTictC97/Bx+ATNxH7O2YrYqs70Mc7LeBZhfwZR280sLJMb9o=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(47076005)(426003)(336012)(478600001)(16576012)(110136005)(54906003)(2616005)(53546011)(26005)(186003)(16526019)(2906002)(4744005)(8936002)(8676002)(7416002)(5660300002)(36756003)(40460700003)(41300700001)(7636003)(921005)(356005)(82740400003)(4326008)(40480700001)(70206006)(70586007)(82310400005)(86362001)(316002)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 11:19:20.4554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7f9d5b-87be-4d59-863e-08db56c88fa4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/17/2023 1:52 PM, Ilpo Järvinen wrote:
> Don't assume that only the driver would be accessing LNKCTL of the
> upstream bridge. ASPM policy changes can trigger write to LNKCTL
> outside of driver's control.
>
> Use RMW capability accessors which do proper locking to avoid losing
> concurrent updates to the register value.
>
> Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
> Suggested-by: Lukas Wunner<lukas@wunner.de>
> Signed-off-by: Ilpo Järvinen<ilpo.jarvinen@linux.intel.com>
> Cc:stable@vger.kernel.org
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Thanks!


