Return-Path: <netdev+bounces-11067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 185ED7316BA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00CAC1C20E68
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAB0125AE;
	Thu, 15 Jun 2023 11:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83112B67
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:34:34 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EC81720
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:34:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/N+BURX/qIeloQohEpjDne5z2KeyTjct0BvCwl6nlx+3wmz88vvnA/R4rjpW5aXUNj9WNLbPVZRsBXIniJV6nfIqZxRC5mKnvuXK0rohIPt5bGNXJtls461Bq/nXrQaYJCHO1KHeW0VKd7JAjUR61kTbdyZ6EVT/5nt3fYQSf6KFlMTH7DhdUJtrtfhGqlJWB8zpwla+5pW6mmziRwOWR5Lr2ERsP1jwt+DZym0i8opLo7quWjipFdRwsMruGcHutncBdIjQ5Os3BAEvZegTvLx3XxdFNzq2Du/bB8q/F/Nb1ikqESa51Scwjz4LKfseepSgV7Lk9R749RwgZpetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YV8m6ViB5i+fRVKGcA1nKT3C1Htpgmaa0GSZyEvTXE0=;
 b=VCIP80GuZClL1UegWUZbcNPOWIL3jonUxsxvkXPNS3Z/e78hbD3i1zXbgBxlbygPD/1LLOyarZquya3tVRjGBefiUcuiIuYAOxwfqPfc4UR1inzWie3U7kc/18apkebWzdyTPSaVH8c/FQZg8DMstQrdppkmJ9gxKzQnmaiQAUb9WJwxrJcQw+x1Z1+MfBVpHKHhIZWHHdXdcJZu7GMVcYUDagXlgizddgSVnZo+jhcJyo2cC82ezDdOefnK00S62LFMNWfB8/SiqKzWr3gLB6KtlfphgogUG93DEHq72rKFvXX/sTa875D9jhJQzXh/OXZLTFB7tbMLdIz1OAwlBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YV8m6ViB5i+fRVKGcA1nKT3C1Htpgmaa0GSZyEvTXE0=;
 b=QKvnTzSBAb3Qe5vv0rnzran+d6k0lbXhJx9153IWWwyCrtd7tnZRFMUS6Nfnhr1DBWBP6t39z8m88gDv44hBhOwZ8ZXPcjq2DgDD56ilnjoPMCh5zNX2eQ6cOIB7fYZfN/ICrRmU8POxMgcbRVXY4QP3ZhsvUowVWkJn0WsrKxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6267.namprd13.prod.outlook.com (2603:10b6:510:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Thu, 15 Jun
 2023 11:34:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 11:34:29 +0000
Date: Thu, 15 Jun 2023 13:34:22 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de, kuba@kernel.org,
	maciej.fijalkowski@intel.com, anthony.l.nguyen@intel.com,
	aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v3 1/3] net: add check for current MAC address
 in dev_set_mac_address
Message-ID: <ZIr3PibwAkAVLrIU@corigine.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <20230614145302.902301-2-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614145302.902301-2-piotrx.gardocki@intel.com>
X-ClientProxiedBy: AM8P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eaae4fe-a134-4aff-03bc-08db6d947af8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ByriWfRr57oI4b7H4AYB2aj9ef/s1X+k5+RBb7SOb6mCvsXXyeS+tFO6doCbdGZW4vRyF6Vylo3IpK7fJDgKfPTWZDT4z2y8RaKIG0+UdM8HKgl1soqtnLfA9sUNlq2BnJgxfohOod8ny3OLP2/oWfVkaHG+uqrwuHMr+MxDDvhV8qZnyX7VCUTPi0ySTSWmyLDEX0JHQHKtbVgqGfHSSmeUHsHnfcYjOoyqYaUnEIUW5OxNhJMQ857kTLDDBfYN33ENFfYu4UDn/JDwCIVHDFEItZEpbY8ewdYi1jz5o0CDT/k+29HENmi6y3o53oIp5SjsIQO6oaiKm9NAhdgGd8KHxb0Ak4vy882WkQjndP955pJTflfkbCrfLRiXYw3CwJTE9XZINd+a0tLY38eBBka4iGag096r6WawOsBeJ+re1TCut2e/lTEm7dr+hq8IqJOp0NuJzMlfZAoWb6bJi4iABEAVdQ1lG6oCvliFfmb8cS19U7pM9UUvbfRN1hslO5gIkiJedu2zYB+krNAB9hvdpu72AYQRtGTmMYDkGVb4475v3Vq9T0ZNCYLuk8vNuca4G+1EIYMf1ru4so7QNwJjyE2WsMOyBV+gglT8Dng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(366004)(376002)(451199021)(66476007)(478600001)(66556008)(6916009)(316002)(66946007)(4326008)(2616005)(86362001)(6666004)(36756003)(83380400001)(6512007)(186003)(6506007)(6486002)(5660300002)(44832011)(7416002)(8676002)(8936002)(4744005)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2xfln7C89d1GpQ/Sr3RVduUk0pr7XmpT17Mt8oG/mtqyo3dyRJbXoNtMT8e4?=
 =?us-ascii?Q?PyiGnyLsTB34ccLVXh5Isx8/q7mfptDWxKz+ENLED2L1HGwRbxpVWbiTkBpu?=
 =?us-ascii?Q?MYbcewT6fUqF+ppPPa2Ffhf331NtQ0bH5SSDj7mpJDZ7+pO6x/feHKWdmplR?=
 =?us-ascii?Q?99Dng2ezMM7oRVv7LzcmjE+QbYANSmK/RA21X+WccsI0DAQEa9JNnv7+BE16?=
 =?us-ascii?Q?E+XftYu8wDHnqBtlouOPDIKw/0clNhR9SDVLov90vtfmtw+6uAPPdakvZdGh?=
 =?us-ascii?Q?HjYeEaZyFp3U0fb57urB+LmFsHPFxPVWMdlp57v/ywneoTltIrboElOEqg3X?=
 =?us-ascii?Q?l2++6/XagaxjbEjeJMx2ycs1FFTfxuCdqvyQ1tNg6wfRsoT/tkkr69JuGvtB?=
 =?us-ascii?Q?EcOUYv+pTlqpgnuxDXKoHXxF3zO51veCRQiAnMT0THp1YpApPa/6KzjZqXkS?=
 =?us-ascii?Q?CLq0iINp+Ll2LPhhYtPjzLMnPR5xwJZ/1qg2bCSmsnCq7CSLYWh7sB7TyKWH?=
 =?us-ascii?Q?ERgVp1tEPAoj9+eiPhaRrGVfay1R7DVCiLBLIybd5RIxsQuhjM/H1UzzkG3b?=
 =?us-ascii?Q?2/X5xYKAs318nTb6F05Y6DrMU65AEOL/Jmbq1rex94SRvGmy46vJE3mjvMPQ?=
 =?us-ascii?Q?cDG5uJ/Da3vHzBlskqHkUlol4KPeGniWzoawlKyGK7X6+3NY5KJfk++C2ujB?=
 =?us-ascii?Q?0pRfUsg3IU/ouQcTXH0X6vXoNYqUIruO0BKuaxqvyvRxa1r6KatAD4fIFtY8?=
 =?us-ascii?Q?00XrW8kuchCaiqcLsHD2FBrW/g72iOiM4n0zZG3sI2Cf2zJpQtFBBQZUFzbT?=
 =?us-ascii?Q?fYvbU0K6J+y3l7NDcM/fNSh6hdG7aKzZ7gBA3HxVmuyqT6j/5gjVSl0u5wOM?=
 =?us-ascii?Q?3RzMFuvosbKkPKFnCM5yRAZrCVgbcLD096YtvK4R28fmDcbFALMOycIMa1dB?=
 =?us-ascii?Q?BDiprD/OA86KH+AyvvJTyJ/ylYLe4jqjWLQGufBduZ6jFn42roAzVkQxvtWD?=
 =?us-ascii?Q?umzIwVw9so2NUkTpgRsssz+KK3b58mp9QuvcMOOo98AoZ1aqrn30uzvBkslR?=
 =?us-ascii?Q?INWLw6SQMCNHttE6gaLwPi4RUvFVIAGZmYLc/f5fhVhYCk9LTQpAb7hk8Wip?=
 =?us-ascii?Q?68QeDCd0txFf34w9RlH3+ta6UsY37iGBf28hARHeMnv0BWy4iO/l8kciaDO1?=
 =?us-ascii?Q?zpABCAsLZyetbosnDUoiqOxzF/7O6DulHEBAVzWyZuIO17Rj3pbtf8NHgDdX?=
 =?us-ascii?Q?T2UKRoeJQ0kieMXWeI9euvWg2rZw5JATEpai7/sai5IB4orMz1rQUkX1zIuy?=
 =?us-ascii?Q?l1p00tq8ZAxub+1Qw1usUIysnyUyGdzmeOyl2TcJwWya0/s9IyvgvSi3aF5F?=
 =?us-ascii?Q?uL4pvnK16+z0SFicU6M/sUGXTVxv4oBFXex3PAmF55BwsR5UszcOntq+TYN5?=
 =?us-ascii?Q?qkSSbM5UucbHyBR564gfU7f3jkTMLWgMROHVCRaX8PkyEmyXZqciRRAAGjoJ?=
 =?us-ascii?Q?9xOVSZqUvzarn1iXFZMv2Rk2+o8NJPOjYOVCb3KWlHUOXqhi3HWxvIwmH4w8?=
 =?us-ascii?Q?/wE2gVAyRbs2ONsAoVyTouBJ1KKIs85V5ClAsiwcXP3cOuRjzWJ5WDjrZLBv?=
 =?us-ascii?Q?TLVzVeegU86s8KYTLAM/4GTUqI6VUSYTDpAHv4jFSIQjIRgdCwJrjyWtFDe+?=
 =?us-ascii?Q?liSAmA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eaae4fe-a134-4aff-03bc-08db6d947af8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:34:29.0086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdFu0hzXZYi4Fd3MtWC+TDY2pcdRhv3vm1x441iMYXRw9+xeKokLE7IaSFY2gtH9KIu/biqlnC+HE7b8beXjYvX2vQ20FVXdfFakLX8ZVHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:53:00PM +0200, Piotr Gardocki wrote:
> In some cases it is possible for kernel to come with request
> to change primary MAC address to the address that is already
> set on the given interface.
> 
> Add proper check to return fast from the function in these cases.
> 
> An example of such case is adding an interface to bonding
> channel in balance-alb mode:
> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> ip link set bond0 up
> ifenslave bond0 <eth>
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


