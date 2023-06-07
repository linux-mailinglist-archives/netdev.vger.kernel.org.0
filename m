Return-Path: <netdev+bounces-8929-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 117DA72651C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC562813B7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02CB370F9;
	Wed,  7 Jun 2023 15:54:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03D34D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:54:52 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB40A1BD5;
	Wed,  7 Jun 2023 08:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrlmAgyU+Ge8sOdIaJjwuPcxAtY/xyU1jUrw0PyMzznHkeW8PpO3XSfV9N7ttbpyOlvOft4GzcCoBSkfIem9hZEkbPpA74HkZN9zlNh5sjPwxEBB7khxvfltWoMz+RubMJoXwZ3XLXs2ECn/gDxy9bS1x9P0jAHqSlCZ/LXweYsGs5xUePyqWBtSGxu37vmeQHZ6TCKAJKPtaaGucTI974iugr4BPemf/n3882U05XOY2NULFjmYnwrO4NqRA6OttfRYcNkWHTUKRvqJF9cpyhgr5i6y6VSw/pJLMUua0vLHZWX02TVZLnwusLbwLsux37WAJMG7piZp+UF8su9lRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlJhJqlSJgVabdi4hisg3LquHujZJnLImo4beYL1naM=;
 b=QBBdeJTKjRItcaUvv3h4rqh+gL1HNGeC0epKEeOIe+pGA9HFBp8a+QbjtsLSG7yc1VtmclWk8Wu24To0fcC7S4r9Xrz83EnLgamB9MmLme5ZzxtYv6KHlAxFU46lEcm1xD0iOmCO5Zf1DROzzoJrIKUwHSmufKTzmVxHrHIxLvPyHZvg6B3ml2A/n0tUbe3HAf/rUBkkCyJH7a3IHIS9dTALdhyToTtLggT8zqmrdFj4BOdcLrAo5l2kGXqm1UHmU1rjIDl1Sc5FJQti7jEX41PM/oLPewm0NW3AxPRGbWmpJRY+HhROFnjji5dOJKVcB89w3Johiv7v1mZnA9Aebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlJhJqlSJgVabdi4hisg3LquHujZJnLImo4beYL1naM=;
 b=uXQqX/AELE/oOuNtnQAIubmD0Yuttkurpza2j6gNc59QP6+OPFBbL4EfEh3IDJh/n+VdGPeN3aYsGXwH4N3/ef5gS42A3I6ZWSKyXjeXl2VO19bLtHtmYW8Yu6linDMUz5A8cflh2nFKsmYmSc9nf0RxOEJ3ckxQ5PtKno0eJoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB5057.namprd13.prod.outlook.com (2603:10b6:a03:366::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:54:45 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 15:54:45 +0000
Date: Wed, 7 Jun 2023 17:54:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Feiyang Chen <chenfeiyang@loongson.cn>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next v4 5/5] net: dwmac_socfpga: initialize local
 data for mdio regmap configuration
Message-ID: <ZICoPMdZEGGEhcx9@corigine.com>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
 <20230607135941.407054-6-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607135941.407054-6-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AS4P189CA0002.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::11) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BY3PR13MB5057:EE_
X-MS-Office365-Filtering-Correlation-Id: 81492d35-d83d-4f8d-c01f-08db676f83e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1ZWRMB6CrbbL4lyHUkhViYlKLhnnPm2MI6DkNYT6jbJZSgAYdcHRh4UkJ/HcpjdlJcBntzjvA2ttXY/aTT9e2jDXPVFfM6hSMQTS44LdX0UDTvaIT63EHRHWI6OHvDWoqSnym5Qdel1al4DZBlQCrQrnzJXBBMvusz/9jSPcfs3eiYR6mkRcmAFrPKOTRIsJB4LJ8bTnwc7bGxZ7FSR2pJSNS2NIp96m+wiRPdD4qzQfWvCaJZj5Ou9TztP8ZYaYEblPkNyhg4kVMNElFmfnE2USgBv9mVrJonHDRIiJRkrohSlxqxPiXATFa2IgWycXLwcVDb1kPIPmrOtJNDxD9xlvVfXtrI3E5+D/UjiQHB7MupBc34MBbQ/7VbfAcpeoWwsMEx8FaxhPwnOjLW2BSt6JFmGBptm3PdHTXqDOg3PrmhHvmR6UZwkRTxB4ilpzU28ucl42cNb5hnPCXaeUYEbiF+JSWUCy52AnxMk3hKet+E4Iz1CRrkjgcLj837lON+Ta6XjQg3NiFn2YXAThEuev3a5G1VS9V+pYGgKZXU6W0PkPVNtZYvRO5UD9wTBuKf4ALz4FgxmxMvkUcWLXx3zM7uN6mJhh32jIMd21M6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39840400004)(396003)(136003)(366004)(451199021)(66476007)(66946007)(478600001)(316002)(66556008)(2906002)(6916009)(8676002)(8936002)(4326008)(41300700001)(54906003)(44832011)(6666004)(7416002)(6486002)(5660300002)(6512007)(6506007)(38100700002)(2616005)(186003)(36756003)(558084003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zJzBH3YelPJmbs55R9dlsobospKpKpjhBYkfmCN/0aqMxL+FvpsVBIBoHw6N?=
 =?us-ascii?Q?FxaOQhOJI0HwWJ98cOnvhERCp/B32wMwzy0roZpDtMiokXXHYDtws8+nfNgw?=
 =?us-ascii?Q?Iw6rXTcMBmezhVP2Endddvkvo2IYfY7Zw3QF0e19YNbr71fCE8pKoexGzrG4?=
 =?us-ascii?Q?08bpWI6w47ZQNjKIqxSWlPv0BBMPzS3lq4GABbEIzx4EJKgPRYyP6w5A0ldC?=
 =?us-ascii?Q?lqSnVo+9ckV0aM9+A+4nEgXw0xL19wg4zpcKX6B9vv080tPIR62qnyAAyXlj?=
 =?us-ascii?Q?5d6wJQGo/wL8KJdXOL1SlxEzZA0kHfVLjTi2VLLmgqR/rVvjZFp+7bhscS9z?=
 =?us-ascii?Q?/VmAw7fAficPudJutIY2+XaQ4d6VnU0CgLcDGytpvixGeBctTQ+/PHSz3RUI?=
 =?us-ascii?Q?M0qgJ/C9N0ywEXrKH6AuELRXyH1Uvgjvx+QRZrVMeBZIVda5kus2cw5pwiJV?=
 =?us-ascii?Q?vvzRSs/u6liH8S+KYNBJ3BtXQK5DNQsiOwSMcBz+RDo0t7Nk9Nax+YSmGa9O?=
 =?us-ascii?Q?RTvh4IifEMt/7rhVb27zLTUFyFzop3zys+ghbyv2a1T/zEHrPnQJI++z4w77?=
 =?us-ascii?Q?fb1xb/v2NbcXuZ7uDY4R1kn5VjlnFjCY0E4M6G6MFZ7KFkblwa/oiUNOSokH?=
 =?us-ascii?Q?sv+2zPRItTfXwjo+6SDaF/xuRLieUenr7sG8x4yvA+aslJXTHbsBXNuz3KES?=
 =?us-ascii?Q?hOn+q+aJPfUAKjWBNZkQNe16gbZeloeIWNKm3EMZdRZYTssxSGU0StyFv+il?=
 =?us-ascii?Q?wG9lnv46KHNPVlIzrUl/i2hM0cURvjiKN3bQYWOa2u8oPApMDy7K8wJkkCJ5?=
 =?us-ascii?Q?1zN6fXFJn9Xpao+Kxe+RXZqjA9uNIIiaw6c9wkvXPG78hItodZSBdVCvpMlm?=
 =?us-ascii?Q?vfBq5DiLj5TvxDCUr9lFVWMV974euJbSwvQM7batE5CtSXOKSJsPdg0HNeZs?=
 =?us-ascii?Q?bbqwGZFAxH4K29z1sPhdlwKjLh8/7hUvoRzkoG1kh/TVB91rwEnpZqQG2a0y?=
 =?us-ascii?Q?R1uy34N9GpfpTY6NVlBR1ge3CtTktzPop+LoaeAydXx7xUMcH4p73jP770D/?=
 =?us-ascii?Q?3stsaDxrs4CBDmt59thlDnL0Fy107LINRedXYKKHTlRZH9rCcxKbvpzl8bZI?=
 =?us-ascii?Q?kAtSyHJxjgjlDZKTy4okW9y+rnSbicVuW02BHCUIKTKLakuYLif2A4e7BmzO?=
 =?us-ascii?Q?GCLjVbR6XCh2P3E47e/ws04Qi7aGvzAAwoi1MYnHBlduIu8Vc/avq5ZCrz8D?=
 =?us-ascii?Q?zMC2kQtM8uWWcyIW2ac1E9aMeCrJ6/HNmJz6ttw5ni3gESLTUxpmHn6X1hFd?=
 =?us-ascii?Q?uElAgZERn3OooR3j93DED+sdpZ776lb0e9wjKaf5B2A9JdHT/j4L8SQAIEaI?=
 =?us-ascii?Q?si0520NzrHo0k43Ob3jEBZoab2vLLX5Gyo6qihPP7OhvLnu9UUPxmT98ePqX?=
 =?us-ascii?Q?/moRvU6WbiiIGfeD8SbmyZOOwkPDa5dShB7vqZM00QszxtUSySvEbuTp8b5l?=
 =?us-ascii?Q?iKcVv7L14AL42/sXLCBVtzM26zmfYr/yn4G7L+7t/GwBsTFTDh8wfVdZ5plz?=
 =?us-ascii?Q?G+vp2heACMZbi/7pSdq/1bM4UfDWrez4C9RGdaXeyrf46Je1l8CRUafFyNqp?=
 =?us-ascii?Q?92N+Wb13vqs03DNjHZiqk7wEeij1qP7qEri2nK4LJ/fua8wvXYzwQ9jXBBC/?=
 =?us-ascii?Q?hfR8DA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81492d35-d83d-4f8d-c01f-08db676f83e4
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:54:45.6490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wu/m/t59CQYNLp5yVSGL8MCoUiUzPzA/kyavJYqg3sUZkegwnGe91vVpnp9/AvFtB7PsINoXz1M5gaNEUPPovmohBA+Qq+0PMlqWPz1myWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5057
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 03:59:41PM +0200, Maxime Chevallier wrote:
> Explicitely zero-ize the local mdio_regmap_config data, and explicitely

nit: Explicitely -> explicitly

