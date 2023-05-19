Return-Path: <netdev+bounces-3888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FEB7096A0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59C301C2127E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C05C8C03;
	Fri, 19 May 2023 11:36:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C008821
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:36:07 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2124.outbound.protection.outlook.com [40.107.244.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55A61B4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 04:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EN66+1nW0qgQL6RenZ1GqBt5qCSfwxVoqqct2IXzJexiKg7f8uEjuYFUSYclrgAEFJAB+AG/y2guezQHKKY2YC7iZkqpewYbd0+oEXygpU9ce48BPZwdoUdY2WSAhuhgTHYACwTXAIpdxf4FI8UEWRW8sQN3n4NbQuHoSa8O1Ejt7Fap2dTbJ1+Vos+zQZE8AZ1MeheJKJhQ00QjMDCJDoNzmjT6Q7heW5fT4aycicDtHKZMWOmShsCnveuFvfO+sR4BdnN5Y6So/tE5mELFuVXGdi9PNfZOFAw5gT8cGFBAzFBOhBXYK32nVAe617f7qwP/E/uXscesm8kCaVXwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oau6lH7G9gbb1rE7B99tsPTGyUdoKkSbNo3BtU/A9+k=;
 b=JVoaDbLu0twyukD91dGuAehrMaWhdztnUQ81mHYBwTOXBhVP/PLh6eTmNvi6sou4m/xd74vqnvOaRdNOStPJm78zWNop+9fisA8Ul7i5TuUY05PINLFWaE4ItSDPq0GPxjlYUGIi99lCvk6YP1tWQABXJ1fG8VKODvzTjcX9mCHGQDMpfIIoC7HtbDVdInUYOZBj0ZDVcZjd8HkJCNynxba4b6jLOo4znAcl7OAW0s5XF3sICn5DlbYvK4oD8s2/ckz6zM76BtCDH3jF8F8CPJJbTu5yXZlNvKNnyR39ljguuW8bKwJ0mn+my/kFsTF7M/mtxqzebT0Y3GoHfk3BEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oau6lH7G9gbb1rE7B99tsPTGyUdoKkSbNo3BtU/A9+k=;
 b=UtECUr4+Cx0+ttrCVYY2F2YlfxoaJFioXN3rMdSwT/NTVKEN1WyJSvH5Um5EhepbsvNSfnQivFiXVC3iTycJu/GwalXQgmYhTAsGKBATgm7K1MuU2gymvY+pyRNRKaD0/HSbEYDoO9LRJeMm6X2o6tCyWuFIBe4aqqTz8AheqfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5424.namprd13.prod.outlook.com (2603:10b6:510:12b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:35:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:35:59 +0000
Date: Fri, 19 May 2023 13:35:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
	taras.chornyi@plvision.eu, saeedm@nvidia.com, leon@kernel.org,
	petrm@nvidia.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
	alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	taspelund@nvidia.com
Subject: Re: [PATCH net-next 4/5] mlxsw: spectrum_flower: Add ability to
 match on layer 2 miss
Message-ID: <ZGdfFuuPpaQs+Z5H@corigine.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-5-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518113328.1952135-5-idosch@nvidia.com>
X-ClientProxiedBy: AM0PR05CA0076.eurprd05.prod.outlook.com
 (2603:10a6:208:136::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: c9adbfef-f42f-424f-fd78-08db585d376c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	e+Aj6ZBq1WWEFq9zPTANmgfvqJQXBNzhmT1Q9PcOjCA1yuVg3aXDeAa0V3OVVsH4bLKNKwnnLwQGE/z/UhnS3Oe0lJq9zoViy9NqGxAnhEh5EmqhPHo3M9NilLBt8WHwwQdDrA463hHiCSoXjk7hxxFV5OTbzvqh+dguLO37HElCo2c7NBlEPIVq8UTNuPWHH4Gj+RAXNmGKgwChqH82Hn58+V3v0ULZqMYtGcautH/CwQwyJFnXeb/LP9OD71lCrvG7WZYu/yHGBx9VcB4QJCEtPtRWFwz4M2PFwOSZGeg2Ewmafb0nwJoANRSq4DA+QlBtQoZi0VtEubbjSlBKofRiTuy3Hz+a1V6/0wLVBsbg/0sd1yHmac/tfsITJzt22YLQJchywX1UaBTEhocEoroQ52SxceDWDnasy9BzW3PFX5zf0YTDL5prHATZ7XhvyubAW/cMW1WDeFYe5yX/7iiw7bXhAuxf3BQMMW1J8gWr+LIf25qJzNddAAD89jvZLCMV8SQxOHIE5idDt9X5DVVdqt8FMZ4IkfLmuu+LvDtfMZDTteBn7DU/ay6kcn25uOOAli/yPxu8+hkT3jlRyDRUmtq1F6NUyTBI9MNH3I8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(478600001)(316002)(5660300002)(44832011)(8936002)(8676002)(41300700001)(7416002)(4326008)(6916009)(2906002)(4744005)(66476007)(66556008)(66946007)(36756003)(6486002)(6512007)(6666004)(186003)(6506007)(38100700002)(2616005)(86362001)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MgC3zok1PIVQbdT8868YPLvzl6tVtJTP5Wktl1AyHLkZoVIH3AkX+A8eWBgc?=
 =?us-ascii?Q?p3ffnosb/9HbFtcnQ62NlvU0+4vs9htCnBLPwIgb67eYSRhoRzAIJj97VTap?=
 =?us-ascii?Q?NFGrHSuP8I+xCPOu6n17ZROE5geutNDVdBC5q6RASe2dXuAXuV28FbcDwdp5?=
 =?us-ascii?Q?qtzPv/WEp+J38grVtY8k5SVYiuJ3TDSwrSjMJE8nduK+M/TNKtr6nP/otC+N?=
 =?us-ascii?Q?jR16dbXpH0I/+kHR89bba6zXailNXpDfIDCgQapWwxjWITEMLIyER0hIMExn?=
 =?us-ascii?Q?6EtNyS4tx1vCwl0z8XX8p1uAklz1kmFpB/n5iZfE7ZAVdH789zHWqH4tynIm?=
 =?us-ascii?Q?jUc1fHrn9aC1aDjOPOUZUOWsK8w+iQnk5mfYLgsB6GsgJtO2Ra3P9urtibkn?=
 =?us-ascii?Q?mPBKNC+0H5fvnbZBIRCDhlrY/Z2Og9MELPiW/eUgkJwvkiISPbve05qHkcLD?=
 =?us-ascii?Q?u65VonD8GgqdPnA6QkmOo9FANs/mFhD5SuzszZ/mhlJQDqO02gjkGeM7b/Mv?=
 =?us-ascii?Q?Mk0KhrDzIvYKqjx7Osm/zQDOVTRAc4tQ3pgmKrJgkbBPLf4ibu03W7+A9dDf?=
 =?us-ascii?Q?z9bYe3fG5XnYZ+hKS2nkIE9JJ4K1sqDbsxnYR03AkWmX2Aipby1vYXqZLn+t?=
 =?us-ascii?Q?I/oReHl0yROFXmG1I76punEVAerJNyQP9eEGObitDzubWWtWd7UixfalmboQ?=
 =?us-ascii?Q?79zb2EWa0ykFiEkuXBAoKUr+MeuSkNdycyIx6Ppbubmr0MVEIQ6JFVYQhKEV?=
 =?us-ascii?Q?g6fLKdc+3xF10eBCKQWN9PtEBQmlqg44SPLn3CjjDc4Fw99r0Xu7C/BWnFwj?=
 =?us-ascii?Q?XhFodD9kvhpgu0CgPbkq9fl2Z7eNXVe3j5hJ8glHZJleq5leb5VrzO6WfLfE?=
 =?us-ascii?Q?8z3g920zrB3SgMJCNHGBDRYG53R7hb1LM8YB8uvc4NUAHpZ+DDaEbS7DZmuZ?=
 =?us-ascii?Q?YtNIt+gI8gRSmaQbp5XFxNXVVH5NVIhnMN0GSnlwIDOA0SEa4gy+yddYCzGU?=
 =?us-ascii?Q?EA222BfVFOTc2eyKkGaoCY2TGM2Nu7WVMg0pacOrV+t/AIIjfRA9tOD2URpL?=
 =?us-ascii?Q?Srubt8Smp0vpYSrXilCKFyT7x3J8gxQs6fmjjVsH955QFmNunxBSl/HlZwd/?=
 =?us-ascii?Q?XLuF4By1fIDhbxwhXmINV+isf3fiqtFLYhEdk8I19b+BjH5NiXXaCLdOYbES?=
 =?us-ascii?Q?KJ+e4fvCKptvVxJE8nzU4E3n1VsrPFHIuMErgy7jd25UbTQCjTURUJFHgu4Q?=
 =?us-ascii?Q?1SlcZDTMR1aXM4Suh6h0rtFAk7rn5eA/OJ/fS+ervln5LusawIXOvvy1155G?=
 =?us-ascii?Q?4TQ0U+Rer9tBYsUs2DLC4MblMsroK2qSK2VijpOCKvJfgVc78cS0uDcgaZul?=
 =?us-ascii?Q?yZLB03EIoEc1fLGMb1VMAZRQ49WuenqthL957QAFvfEmRFHNX5FqX73Ofrdj?=
 =?us-ascii?Q?DVtoHUJjm6EBTSwJnK4O6fhAqFyr8tlgKJXR65IiLS+3MIFojxW/QF3rxHlz?=
 =?us-ascii?Q?g1tG/3e1hEHtO0krQjhMJTeia7MFpIrZoIVX1oK8SiLLKEj0ENMpYEye4N1x?=
 =?us-ascii?Q?IaBI395w5n9PyYK0zauU1660mTankZ2+sXV83krhbjdwBSiTZUPjmOOt4e1f?=
 =?us-ascii?Q?7fyHxPCo1J3JesJq3HGXdUU9CfQJ/DY8/1zF9+RhY+36B7oH1QHXJsIIZU7f?=
 =?us-ascii?Q?UIp3Xw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9adbfef-f42f-424f-fd78-08db585d376c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:35:58.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjQ3luvOm787keOFdpFyHWosUHYUyBWo3b6fZ7vu2AKR/hdIOhCnHUwvFgPz3qwiLwngEbfnDwLqPH9WbSTi5Kp8s1PXvdFvfDqEU9Zj6bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5424
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 02:33:27PM +0300, Ido Schimmel wrote:
> Add the 'dmac_type' key element to supported key blocks and make use of
> it to match on layer 2 miss.
> 
> This is a two bits key in hardware with the following values:
> 00b - Known multicast.
> 01b - Broadcast.
> 10b - Known unicast.
> 11b - Unknown unicast or unregistered multicast.
> 
> When 'l2_miss' is set we need to match on 01b or 11b. Therefore, only
> match on the LSB in order to differentiate between both cases of
> 'l2_miss'.
> 
> Tested on Spectrum-{1,2,3,4}.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


