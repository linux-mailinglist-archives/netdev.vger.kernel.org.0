Return-Path: <netdev+bounces-318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCE26F70D5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C07BA280DC9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E16CBA35;
	Thu,  4 May 2023 17:26:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CB1A93E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:26:50 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5BD46A3;
	Thu,  4 May 2023 10:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQk3WJ8walmP/st5ACbG1AJx20W89JayLqOBmPGWMOsyG8b8O7ub77q/ptmOb6vPfZDmDtrbQUqmcTx9yciXTrNFAjd19IRYzkxM3Q0L3vcsieqGvsS5E/F7W6YRspT4ycTtIp+IH16lU1iYDS1sL9+LLYe+b3XR+s7Pe4kIRWmfDJHBz2BKrRORq63nbQ6zw8EESvtQaFWLIcJZ9v1vEbk3LoGzzcLEZHRNYUoAoGbSh5zi0Ou5yFqcRMs78TBHBjXe3fMlb61Sr2zAo0TARvAHGplvIbfEq7QMSBMbYeNzELP94Pwnb5grji7w9tT1eTplXaLJw5z/xlz3EITssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9xit8uNlz+4rJLv7AbJDsV+F6P79oOtTKl/snhvAhg=;
 b=BoZCIb9Dilc11xT5P/vTZpwu/jhhHpy7elE5IAboBaB4JnTVnKJPo+ZUYU5e4j267xAbf3LydeBeWczeeR66KX8x52xHKdANRk+H0FTUljxpwKZfwHZpoEX4PlDcMaAm/Y5/djQ7n2q0ZnnVo98OdRs9fJ1ldtJWC9WEFUsRCXnMCJMquEqqOCcqFtKP51n7ISgMLGNQ9vRTS6EpZ+ehlZHtbhxIi3dqeDSNHlQENTAbSH4gaOXULTBgjAeLHjEYE7dwfXreYgycHVMTw0WAj9PbTx/PvQRPslYRxEOCiT8JPs3EEYwYYs67LVsQ1NKfcbS4n1IfFoQpnwEEuuJC1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9xit8uNlz+4rJLv7AbJDsV+F6P79oOtTKl/snhvAhg=;
 b=bspT4ZsZ8BMYvvdue2ZROQPe0yBfbhFde4gIKHv7HPNZAiJz+daiKYyrCARXa5IzYTysTu8KWxB24/N5lRCNMKpgj7P9XifXdE1jiQ81m5mZ7cUyN+ngcLLaoPIGS6GNEK1pFLsKmDi+53Nfo21DzhbgvoeF1Rbfb3mlADZ/cjXoK8dtflMtDlZW9Y5/QwwgcGumimizMK4wYALqY7KdpmeNkMDWnWIDoEe3/VSv/2UaEh2xKFJTsJwVWq9PsS4eSCbxq0jb12e2RdThz4UHY5dAfi56D2hn4qsm+7uW41Z3nTEOXSza2LS+0mKbLAXVNEV+OQdCKp4Hm3b4kJgUkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8182.namprd12.prod.outlook.com (2603:10b6:a03:4fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 17:26:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 17:26:44 +0000
Date: Thu, 4 May 2023 14:26:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <ZFPq0xdDWKYFDcTz@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-3-brett.creeley@amd.com>
X-ClientProxiedBy: MN2PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:208:c0::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8182:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c4a52d-5ef5-4174-9185-08db4cc4bb4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YlwwGf6EpruDgW0sDrAorxB25vw4A23JdrfH1oPlbhU13i489l/vwBHEUWuLbZeAsrtByjNaVYVq28GJZiqE8jwwpFhzRUXCvjSMS1owMzhrQ2VOZpiK1eF+ZjgODpzouVDaOM6xoX2Sj/D4qVL2grQtELGjduMWX2xNidVSoZVY6pru9ppyC5hwMfsfAu7DFERf+1NjZ8C3LSTABKZlWGcAjQVTVpaSpXxCJSPDIOQewY4vtxrwJBtYH6f8Cts7aIWcgN+ARb0nznHygHiHoCBvEhWkGfda9dwWj4F/GuyJ6m13fvVwgabUmRiL20N9h2POzNnbSFxUcRjlXNvka6zx7px2MPCaJu+KkoXh91a1ytwlVkUfu9GLs8S8RP3hHELKrNv5Re5wNmWDcAnaHeY3B2PFe27TeSGpbkKAGt6aR59jNpBAfq0A1buJYIcN8TcX9B2zv90jqXOCMuzpO6f6pbu3RRsJvR6Tj6Hx/SAudBcC/u6lcULzP0NfYYd8+7GRCwHOa4SayLSqT267omacH0jlDP37aflNpeu5DzY1L9+qcgNPI2/936Bdan3U1XFJ0J4dzC0ihvLUE0uWqyKW66aWK/+bb19EVyUR+QI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199021)(6506007)(5660300002)(8936002)(4744005)(8676002)(186003)(2616005)(2906002)(36756003)(26005)(38100700002)(86362001)(6512007)(41300700001)(4326008)(66556008)(66476007)(6916009)(478600001)(66946007)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o/PBE7KIrQRD/YJJMrqsKoY/KXYd5P01Xr0sn47bopZpjBhf9BQfrok1wLIk?=
 =?us-ascii?Q?sYG84nbDxtG60esMkfEgM+i19QUbB/y77VQdVU4que3qFhAfW09+0VqK+Wf6?=
 =?us-ascii?Q?l8powcz0asJg1zTtbB9ve39M56qQ8g5YfcfqnHM0+1nPE+eExokKM1ZcQs0H?=
 =?us-ascii?Q?AbfNnku2PmxTC1OxRENgOA/31CtpWAEbM6Y2Y39BB+4PPgVSo7ZoGpIqjWlB?=
 =?us-ascii?Q?/0RyEAV9m2phyLfs2n7V4N9tGzxAXzlPjEujb7Aci2OGbNaZjUqIZd3Nyh8P?=
 =?us-ascii?Q?hw0CELaXxu41PSNFrpdwth3+/z8XS4bjRoHdVJ0ez18wwQkrUrBwFk9kzSKT?=
 =?us-ascii?Q?wR+SSRqayi3tmY8rCMyrB2EBr+hiqx2T7j3agcp3ftiWJmZUDLhBlFVqTc1N?=
 =?us-ascii?Q?851lYuvl7KkC87WSu9SeMgshJQjdad5pbG+zYgiEDonS8nwqn3l8YuoRJ/Rn?=
 =?us-ascii?Q?gziQEonNosSYqw1sk1BRgK/NWKpaaxKLgR74c7f8k0T28LNzlkoXfNgsfy6n?=
 =?us-ascii?Q?7J+Liat0Juec2pm0gemjlwGYj6kfPStO4PZQXBtFa2ONQN8UmCXDTROfHC7s?=
 =?us-ascii?Q?jKyp51AbfDjZic+wXFir8bLYOHXQvdCrseGaq1CnBYdTLAgkVdMMnnZdFTBe?=
 =?us-ascii?Q?u+fwCSPqhQHGqps8cwZcbuFxBmtC/GdVrxrMDNkayxTByTVdsHMIcLkof9dh?=
 =?us-ascii?Q?mGOmy67o2RX23uW1rIIAG32wLVfereWqHqFGrd+0PzJ3OlG0rJNhkIMu5VSL?=
 =?us-ascii?Q?/togDjF12ERD0B2WPqApAhUVUFcmH+k8nltvhVfjmeyVMYAYef6YUG1Duosl?=
 =?us-ascii?Q?bF2omvBZVB54W+hlgwWBixCZa6PKz9Eqs/fIZueawyR4qVMwCQXC8nZp43X3?=
 =?us-ascii?Q?OJgfhykOp+tJlS2CtUxJnNJZysTnj2Dvro4BHfADjiKG5pYoE9x1GVmRTIWR?=
 =?us-ascii?Q?HnTgXs5t00doO3xxFGUklg1XgsQJS0SQjtv2mC+/BkVWgjJf5ep9RwhCYw/k?=
 =?us-ascii?Q?Tz30fMVtC2K1Ols8Gjw4wWXY6ObBA26khA86reM+839HzB5GLC18xgDvsRup?=
 =?us-ascii?Q?oEp6gmqLmOWUmjZG23wBLwP9Dp7i/4v/T/EdOVxDNNd90dR2Sruy6XkgbiqB?=
 =?us-ascii?Q?SmD1ViSKNGRGjxgvdL1OEx/Te5cNHwitDSf382MjslK4j3S8erszQVz/iO68?=
 =?us-ascii?Q?eCj9eiT05+5V7ubvM+ElMsqSIcOIWLTNTUS9wuso0muBRNLYEGVm02Bu1tTD?=
 =?us-ascii?Q?HUKx9csMny54fazG7qlht+IwXpCWpH2+M1P3esSLC1/4kDCW7zTzYfXLghLl?=
 =?us-ascii?Q?JapltqkCURwvilIEMVPThJRI+HGj//sqjwymLJrBR9nGVVW9jXcoUA+gH87y?=
 =?us-ascii?Q?vnj/ubEZNO0EB9eRKIcVR2W5f/obSVlECCCZfsi1xgWDNED5UwTKSb9zhrfu?=
 =?us-ascii?Q?zSype6ICm2EfpQIWCe835mglt+nIyrqTZ0byAYRqeAX4dcNdGitcWLTX3YNp?=
 =?us-ascii?Q?bRtoJsnUkuX6wZpdkepMx9uGu864iRRZZNR/bJU895F/kg6UtsN4ywhlFtx6?=
 =?us-ascii?Q?wnjfyQeNzcAcVZzXkfPaMKzJsRM37gTuH3Zlwi2y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c4a52d-5ef5-4174-9185-08db4cc4bb4d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 17:26:44.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q33X3qGc+LxuqW/92fu6YIJ+zHz9VH3RdfaDRHqrrqfE4TxNutYMTOWvZjnKinJg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8182
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:37PM -0700, Brett Creeley wrote:

> +static int
> +pds_vfio_pci_probe(struct pci_dev *pdev,
> +		   const struct pci_device_id *id)
> +{

This indenting scheme is not kernel style. I generally suggest people
run their code through clang-format and go through and take most of
the changes. Most of what it sugges for this series is good

This GNU style of left aligning the function name should not be
in the kernel.

Jason

