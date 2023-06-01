Return-Path: <netdev+bounces-7153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2D771EEBB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82C501C20E7D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F7F42516;
	Thu,  1 Jun 2023 16:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1EA22D6B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:23:55 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017C2138;
	Thu,  1 Jun 2023 09:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hu7dxcyIBqaTfZdZhzixnNeK/VMUGegba/dF1dG1UMOou0Z5C5G2vkqvxCtcUq2FRMAeXGmy0MobyOVDh3PVqdfCNIlMGcptfN6dAxT9JAfheD3wa/WS1nUorJzNSyOZ0E+Ng8knfYCyfJvaMwGOfB9+cLEzuMgEHw0k1CvZAwQkm4S9wyvEI3fC4iu6XS63cNVQYY9SgmhNY2FiCnQrckQUt/oNIg8R9/N95kO9/K2WWKwWCpmpq9ObzmWeAsMOpn3U03iFjqBuerZmXCmprBZ6HICfgXCj8IKou0a8R6O6lAWLWAqkOPjA5H14Jq59xc2plT7ueJHpfVAWl2UT7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmdK3M6w/w1fdQV0mWbB3nZE0h4gWk8vfEvVbrhQ4Xw=;
 b=Vn2qBjKfCjtAXYLm6HjZlww1phV16/H7nA9ZBWi7b2Sd7DhxpIaQ16UvkQXwYmEJU3lUPdRiUYpDkwMLPw0+JSdUGUFN8aMDdLzDhcRnIBtEkzf2O0aCSNtR5wYZm+xKkVjlPQdrdG1aGqBJUAa/lv9gSqvrhnpPkVZgS0h2ZK9FvdVpjzIvXhFO5kCcJgVZq9kBACfNCAPsVYy6Qyo3Yf+4lg/7UdqDOoSw5B/Q6iiy578mTbBC7wPiVeVfD0xvhVreNfoGGM7IL4xVshzvxzgmHc+2Mf6a6KqGK6lMswYeDET+rTr8MlWfFDbErPu5lyGUszY/m0lk9G/+mtnqvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmdK3M6w/w1fdQV0mWbB3nZE0h4gWk8vfEvVbrhQ4Xw=;
 b=TX10BE7ilCBrH4nLNVG+29Z9JROn/IYuBfzze+i4bsMjJYKwRPEc1MY4wJeFGl8Y3Jn+3VRP8BakmRNaIcs7VB9eTvCeUuCl7Kxmw4VSNMuIRIp2K3nwkQpJZu2YCQQLiVQjU/xrnRLObxE/lqXy2sZ9fYMuHBiFTJNlWQ6Fqxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5663.namprd13.prod.outlook.com (2603:10b6:806:21e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 16:23:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:23:51 +0000
Date: Thu, 1 Jun 2023 18:23:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Justin Chen <justin.chen@broadcom.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com,
	bcm-kernel-feedback-list@broadcom.com,
	florian.fainelli@broadcom.com,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <ZHjGEGZW8oK/kfhP@corigine.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
 <ZHi/aT6vxpdOryD8@corigine.com>
 <20230601090310.167e81b2@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601090310.167e81b2@kernel.org>
X-ClientProxiedBy: AM8P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4994d0-9d39-4e91-cc0e-08db62bc95cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VeUOcT+M2ZU74imuWtE0CutT+W5DnCWr4JtjSKE08r0Zunz3RHG2jaudfrDvtv/XeIILnRbBSEvh4QTZdqzkIbwL9iSzq1+zckWNmDvhnU1lBOqoPdXHzcfEi7m2V6dG/W9J7VDoO8qI3q2iRbaqaVJkI3eso3hvLAlRhI5Odb4UOVgddN3pwxsyUs9ZTtAS6T9nXmiPxlJCknr8hz1gX1M/vFX0vpXeS1mVjDD4jv/o5lH78VHOXyQcVjlTg1lADWLfr5aoOYRIMfW7l4c2Q01p9OQeii7LDJCc0zOEtaWn8600SR+r6R9ds7n3V/a/L+mS0gsE4gfsdWkSeft9ylule7pJJ6RwK2w8DZR5nOWrUCQoe/ZVrNb10KPAzx5bBa6Vol1LFcqY9gWBTlyznRjyzBnPJTWYZgDfuG2Dcx4WTyd+5ZRX8sK+bRxzvW9arwHzVsv87WjD6fvoyCdKB1jq2qTVS/4omZC2o5y1Z8neLkzPmnXW10J013gslFdJBqj7UgErR2wuzz0jQZYbSznzisrIxwepXqQBgyHWGponAL+YRhZb2vWFsbRmxw6124P26stENyyPvKnafq1dujt6KcJd09hlaGWyotwOJjs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(136003)(39840400004)(451199021)(4744005)(2906002)(316002)(66946007)(66556008)(6916009)(66476007)(4326008)(44832011)(5660300002)(86362001)(7416002)(8936002)(8676002)(41300700001)(54906003)(38100700002)(6666004)(478600001)(6486002)(186003)(6506007)(26005)(6512007)(36756003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y+fivVzFsFslJm5jyuDm6aTILCnGg+LAXpdV1Ryl25kEpqIJnghhApkUqnW4?=
 =?us-ascii?Q?dttN2pCMRkaU/r4xb3hwnFRiNhZYDCFe7yl0nEz1CHl1P1oQwqYlHe/pcH8e?=
 =?us-ascii?Q?ocTzc7dKv0IONAdE1cfeDtLNPNRfS5Rocktf6t+F/q6MDGRBFUAHw4ClHkf4?=
 =?us-ascii?Q?cFLUMzMZa32BgZys0Cv7bhvn3ZUHnYFltCElrCPAm8EoVntSOMCV9mg5JERj?=
 =?us-ascii?Q?lmuFleDFif0XXmbBeEO/TLCp9eOxhh97Myzt/aWGAcH/N8K9SPphCvdGLm6+?=
 =?us-ascii?Q?kLDhvVNob0HqY/kGLl4wkmkX1SWWBqAhY/5VD6fhxWn6RjXZo93T+sPTvbQ2?=
 =?us-ascii?Q?yvwak3ylXUR1kDxkjgphptRvCWfyTGqaRxiFnyYyk7ZhxYuDasWli4jaWSw7?=
 =?us-ascii?Q?FMffnYDkpyNdr7jbypQuVYhGa1SmBB/x298+P1eUUEMNCMomTgrzc4OYe6tX?=
 =?us-ascii?Q?OTR/FUnwXNfz2YI3FixB5VUGVJjNCkWVIQuIddBgzkG14W3E/RjDbfAGgmH2?=
 =?us-ascii?Q?pjRq18ChLV9mBQzuFSaookWlV01G4ZK1ZBX4e9jzWVFRrxMNjXcaxo2NDoJu?=
 =?us-ascii?Q?/W1hE3ZzKKgcPKi4ASSmy2a5+efOUX4q4bCpvudF6FfGldgIQLQh7Uhf22T6?=
 =?us-ascii?Q?PT6Io2qOsy19b7OXN4hoXVaG2I1tWhXVKOjk2mM9/hHc7a0HEED66ihU4/Zf?=
 =?us-ascii?Q?rE2mkkCzblDN8MLFkPpm5WInlg47oZKEs00lKlV6hiX/sCZ1P7IynH2KkqYz?=
 =?us-ascii?Q?5ff3L63sUpZxDVwEmQ3+Z7ieqNZUx4Cm4EeyG0xGET6lT2tybXGZRSbq6chO?=
 =?us-ascii?Q?qBH+Y5kGAQc9aLl5WE/RPVhX018I/n/cuCu6wczicLNdXwg6O7zEb6SQjA7n?=
 =?us-ascii?Q?DSl5it8QrsvwDbuZiro/ktiVzZJHDl37N6F/YmQJRr2uDfuZ4sm8HpxwveHq?=
 =?us-ascii?Q?TqV2kR6q9kdGMbDK+IwkFEgQ8N3XJS76/RUBQghA6ojOWYKeRYqoS+pM1mB4?=
 =?us-ascii?Q?UznI/SGU8d9zrhOz3v0yhuHKL2OdMEMutlh4onQ0g84w8j0/SHaqONlRr1rk?=
 =?us-ascii?Q?djRcJbMNLrX8KZJb7d5/D1H/Kaq0W7tX4tv9evRVnsRet/+xTDcTfeNaEox9?=
 =?us-ascii?Q?B+96d8FLGczgFdHrRi7uflLcmlvjUlbWtkCKq2ERY6uUGAi3tnwD+0JpBOSv?=
 =?us-ascii?Q?+/gs3KUoNLhlWSA8QItWE5qB4OM6hSP1DzUy/AgNQgTyyp8juvcz7VnEAgS8?=
 =?us-ascii?Q?T6JLLEPCoFad5DmMnSv2mXuDwLCSPUFvsPU0eo+wobXbPjH0QeuX7swTyPbj?=
 =?us-ascii?Q?YvueoRnVGG8iomwP77mKbVUinDnASu2gsK/ycrB2Da5KjOaDfDXQPJ4nXaUg?=
 =?us-ascii?Q?zRcHvu4Bqj1a0bpQuWvAHmLT5C75Qbi5OvGNViDkxWllcNf+16c0sqFJeDuv?=
 =?us-ascii?Q?v4gy4FwdKhFpfrke7EesZVDRTTu1SQDzxCvk4D6M10S1gFeypAHku6Iu2i5A?=
 =?us-ascii?Q?AVKn9Yv6QpAlcPMtKoYAj7U7YRXhhYZpPg3xCZcNIaqkkxj7TqPKpTVB4ABy?=
 =?us-ascii?Q?K/m/vDKgLATe4Uc/5k5omxCz0T+XVWmRVjhEl0XNkLXI/E71xlQlw+IbI0HZ?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4994d0-9d39-4e91-cc0e-08db62bc95cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:23:51.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/G7JMu21dawOtl7S3LW0JcloPmt2mcJN0iAcbxjtnqQoP4ft/Z0lBL5jUzxHmFRfuQE0SOBhP4ZGenIsDy9V/72gOv/xNd3yy5/ieXtP/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5663
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:03:10AM -0700, Jakub Kicinski wrote:
> On Thu, 1 Jun 2023 17:55:21 +0200 Simon Horman wrote:
> > + Daniil Tatianin <d-tatianin@yandex-team.ru>, Andrew Lunn <andrew@lunn.ch>
> >   as per ./scripts/get_maintainer.pl --git-min-percent 25 net/ethtool/ioctl.c
> Sorry to chime in but always prefer running get_maintainer on the patch
> rather than a file path. File path misses stuff like Fixes tags.
> If it was up to me that option would have been removed :(

Yes, sorry about that.

