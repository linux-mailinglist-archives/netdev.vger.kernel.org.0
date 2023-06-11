Return-Path: <netdev+bounces-9880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B628372B0A0
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 09:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0179F28126F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 07:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E211FD7;
	Sun, 11 Jun 2023 07:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AC1389
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 07:39:39 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436492D48
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNQIOUA+SUHVQM4Fgd8ifRsXEYgPYnUbq0yDFsINBoBvJhtwfCiOcfV5eNl0g20v5P+tki6q8sNfwSZX0dniFiwxHkrx1HNyC+IIxsxHRWrUMgtLlF9/3y2d/QLTHdClLVbbZbjcf5Ygv4a0XnNyY7PP1I/HMYRQS8CB2qRuXq0LhpZf/haYAXKTE9Q7EwuUP8Py6uHV8suvbg/TgRBn8YbxJOnrU2EQ7KLQ4lsUoQdf7qdJFtnMkUcWlgg8ZznBzyS6wd+tl1OZHx58mI27hfjlhpiu14kH57Ngze4vsXUElUZe79fJKo3i3u28c+3sAT+ZWs4Nnvxz02VWLNypdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7HX79kn60713qLOBrJ7ui3uQalcZQTRRxrJQpdsDLo=;
 b=jMdhM7yBVUpF7sMm5ToNHCDj7Nvi0Uc+GMFo7tBWXA4gH6z/yMUWp5QZmd9kQFr4sg/8lHxo5ScFk1cjMAdxAvqbI/+UbonhunhYPC8Jyg2NPxFP74KrbzJ1uY2TZjvL8meTFKlH7wCeUxWSF9W0mjLkgx0obZN7suEBR3Q92M8sVFVqkwPqd6zRIguVNNgdcZevEJeFXLMi8naEyv+bSqpJUAlKNCeNB2Txi4KMQe91sqzb7rP4ua9OZNgs+mbwW9SxuJeL2jnXWjYYMRPms1SZ2AM7TrKahb9J3GYD+7ahT7wEVxaUMfX7tHYxfWTlyLcsuL1noURB5m+/TcxIEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7HX79kn60713qLOBrJ7ui3uQalcZQTRRxrJQpdsDLo=;
 b=AZB1pNQE1S8IcK/6AzdabadYlOPTlbue0fx520gisbGxXvBUsDqJfyx2IkycI9ZsjgwIgYUf9QxvqiDgkNA+Vd0/vkv73ucrz87ghYAPM+fJmNgGckQw5z2egnNvmad97fPE8ulDB8ENC083K9RQ2dOPtF+/H+Z7MqcQN1/56nxdSQrlC585KPRg1j93XSdQAYhDKxcDZ2HrTBZUL7aJHfPGAJHqYOTIsihIbks7s6zq4RG7TikDA+F0Rxz/hHlEuFs1svQeJFNoa5jLFnRKZnOXi1K8Tnoz7HL76mt/yqQEHBHXvNr7zoUk2GzhyEKiQS9NcyCXX+dZV/ZTtv8OSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH3PR12MB8710.namprd12.prod.outlook.com (2603:10b6:610:173::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Sun, 11 Jun
 2023 07:39:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.030; Sun, 11 Jun 2023
 07:39:33 +0000
Date: Sun, 11 Jun 2023 10:39:27 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
	vladyslavt@nvidia.com, linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <ZIV6L+pIUvZ1tip4@shredder>
References: <20230609004400.1276734-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609004400.1276734-1-kuba@kernel.org>
X-ClientProxiedBy: LO4P302CA0012.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH3PR12MB8710:EE_
X-MS-Office365-Filtering-Correlation-Id: 98550702-cb65-4c29-26b5-08db6a4effdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tdqhKq0zCCEOJF1fRtrQLr0oZBeHuMCNlZRa9GAVnINi/EJYl63cEqgi52+xJvgfRB5oIp80OpkzXQ9i/h+dKQsQChyN+3IIcd/7lJ7diEXuZlypMgBNK1sF83wcNjQOlyUIM5okWAhlQzOs2ViT0DNMdsSi5fI8HnUTuVX/TYpbQmfAG7SOlI3eded1XLx5UZzGeTCAY6ENWt4vcW1AkEH5cEnAcf24WRLBvN5j0XKNJllm+i/H/r9eTrxYLEwbHqYxzr8JSF2SKEkP9KadDKzgK9Ca1q8fQXiJt9zF8KIR/3Pd76FzXwyK1CCAgFT5DM+gDSUpEDcMeTmiZpX9uvZJ186SfltXIZw6sS/ud/G8b29sR/OdYrZtap+G0xA7vmWokofvHVosVemdSVCH43g/c4Lx+zDPYgFoYAc1nvEJLZ/YpAhBRjNsMOVDHR1AHfwx1NIR1q3Tig+wZ+pMR/Y5h0Cbjxsw7L7N84WEawuxt5SlzqYGxeGKnvPXhC23mPG6sMcuO1Kbkw8IrlJfUM4+JK+3P0Jrb9+ToIG1mKuUmvLHuGsxRuEUYCq5P8nl9osTPkhW+3yXocBhXVxCioNa49nBLTXh2RkV4UkRWzk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(316002)(41300700001)(2906002)(38100700002)(33716001)(8676002)(8936002)(5660300002)(6916009)(4326008)(66556008)(66946007)(66476007)(6666004)(6486002)(478600001)(186003)(6506007)(6512007)(9686003)(26005)(83380400001)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LXBkLbeE8rKjZ4vSb/QIk40Z/xITrZr1cC03ZzikZpmy2PpFu/Q0gKzpoDiI?=
 =?us-ascii?Q?nL1q3rNYZToDgw4Zz6AN7GBMF3o4V9ArvurFiv3Ji1VcfdIF2EOpjGnhEXVT?=
 =?us-ascii?Q?PU7XS6allEDsJeA/S+KFiS2RghEoKs+HAxmHduY+iNBsT2as+5XUQ0sbQWgU?=
 =?us-ascii?Q?8fZLcaTN+T9yI+f5Rmc72iINmSzr69zeJdxNaz/umarjO0MVuajudjoQVKep?=
 =?us-ascii?Q?Rv9/PRMSY+sedWPMCKy5gc1avYTFWU+lmdg4cb6i399i3claEyHR5XOUDUgO?=
 =?us-ascii?Q?gVHy+EjQpQjS+uKkjfAMX/7Qof8kOXqoCrRF3VPVhmO4XbLL0LqxE5JCUVk4?=
 =?us-ascii?Q?oCeHmUyCEJeR8gBj+qcUk8KvWW1040X8Z1gey93FUVWq4d7wbiihqigVeeCS?=
 =?us-ascii?Q?Z5si7juZioTCSu0MMkpO2nvPEMuUGgX7iWohbEVc1cdocaDXPnbfopdN/281?=
 =?us-ascii?Q?Lb8xDJ4l/U0DYHiJSxBUpwr0sDgNK1zpTN3yq8UC27UL0rw7CDfqUFmULk+o?=
 =?us-ascii?Q?YgX00n5CRrqs7CK+YslxqP9y78VFuDYSkDGoFc8YXncZeQ89okdpxJ81eQ8K?=
 =?us-ascii?Q?gibmeTPcW5sqCm3J52t+7IFeEyyN89zg4eacXN2N2H/D9CvqBBelmy/8YXpv?=
 =?us-ascii?Q?f3m8AZld4EHXeEdo0LapqLe3gpuswLwUWu1c1lj5ithPPN9+66GElj5SgzXV?=
 =?us-ascii?Q?9E7MXwMuGPui81wxbnwwNpJ20+xZPvGnKBIbkAaPJpFrXlZz1TL+Q76hMzQd?=
 =?us-ascii?Q?3gASYCLuzD4d+ySN8hK/6xxaWoTWpp6tzsti2tdpte8AxPOAYO8SqUmGhFtQ?=
 =?us-ascii?Q?rcsMf2j9iH9PlHeZVOty4XX4FaH50LcRIbv8CJK/BpBxOqzXlbjGUfxyIKg3?=
 =?us-ascii?Q?xAWa6hy2DWuJFqoQQi7gk+bfxJh+fKUoH5nA1yhkQDieIprbnzJttn6nzB17?=
 =?us-ascii?Q?o9Wjy5A6axNGZSeYboBBR4XuE8cznCjY8jS+K6vlaWp4yjBvpz+bmFSs1qTO?=
 =?us-ascii?Q?2gvutQtFxi74+KSV6DRVrfcMsZJlxO12tb/z5Bo8RGOq/Swu5NxATZDhu/yM?=
 =?us-ascii?Q?3L3sqdnCADr7jlXSdyt05JjPNqW392WGbBX4JUsIKPumvH+IgiQAWM0WfeoI?=
 =?us-ascii?Q?4k9Czj6sFfT6FGpEdZZph+7ubNVbW4GOpHPwy2lwDa0KBa/iCsZpih3LSr/N?=
 =?us-ascii?Q?XlmCAjEB4BfQ7HBkpiLiOGktaQEBEupBp2DLRicc4VI/hL+qQ4wF50N+B9ko?=
 =?us-ascii?Q?wMedhmSFoOvSd6j5oComWxJ5bkMa8RpDW9x5jNijEu2qWoxmiuCPFZzURvIY?=
 =?us-ascii?Q?KfXOzkyc5772D7XVs6ZA16R3kf9pxbNXXEsjU6hEoQXoXlti0ONHKvC91HGg?=
 =?us-ascii?Q?+UTKm/HK0DP1fbU2AuWMY1GijlkpqMK+/91UJK8QvIXvFL1Dcmode+WQjv/y?=
 =?us-ascii?Q?incLDdcEwrLRDXcYk3X/dSwPOe+2dHzajeTnzajcuceHg2Tr9tBmmEky9RvE?=
 =?us-ascii?Q?ZtrtClqcMm7yCzikHmIv8TJaQVLvYq108Nv0V6sMe6vKB5Jr1c6wwb2VC3xc?=
 =?us-ascii?Q?pLcZIUQuGU19k7MxAHPZIpCqWxZfyn98Z/A9RS4m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98550702-cb65-4c29-26b5-08db6a4effdb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 07:39:33.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zv50ULiJGBghFIrXK0Rh1iEEPZHMQdOn40W00l78tohWoy+Bh6IKGNVOjCXpixwuKN8tZ3oF+qX86AjpNKplgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8710
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:44:00PM -0700, Jakub Kicinski wrote:
> Report whether Loss of Lock, of Signal and Tx Faults were detected.
> Print "None" in case no lane has the problem, and per-lane "Yes" /
> "No"  if at least one of the lanes reports true.
      ^ double space

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I was asked if "Linux reports" this information.
> I'm not very confident on the merits, I'm going by the spec.
> If it makes sense I'll send a similar patch for CMIS.

I have two AOC connected to each other. When both are up:

# ethtool -m swp13 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : None
        Tx loss of signal                         : None
        Rx loss of lock                           : None
        Tx loss of lock                           : None
        Tx adaptive eq fault                      : None

When I bring the other side down:

# ip link set dev swp14 down
# ethtool -m swp13 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : [ Yes, Yes, Yes, Yes ]
        Tx loss of signal                         : None
        Rx loss of lock                           : [ Yes, Yes, Yes, Yes ]
        Tx loss of lock                           : None
        Tx adaptive eq fault                      : None

When I bring the interface itself down:

# ip link set dev swp13 down
# ethtool -m swp13 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : [ Yes, Yes, Yes, Yes ]
        Tx loss of signal                         : [ Yes, Yes, Yes, Yes ]
        Rx loss of lock                           : [ Yes, Yes, Yes, Yes ]
        Tx loss of lock                           : [ Yes, Yes, Yes, Yes ]
        Tx adaptive eq fault                      : [ Yes, Yes, Yes, Yes ]

And I don't see these fields on PC:

# ethtool -m swp3 | grep "Rx loss of signal" -A 4

See one comment below.

[...]

> diff --git a/qsfp.h b/qsfp.h
> index aabf09fdc623..b4a0ffe06da1 100644
> --- a/qsfp.h
> +++ b/qsfp.h
> @@ -55,6 +55,8 @@
>  #define	 SFF8636_TX2_FAULT_AW	(1 << 1)
>  #define	 SFF8636_TX1_FAULT_AW	(1 << 0)
>  
> +#define	SFF8636_LOL_AW_OFFSET	0x05
> +
>  /* Module Monitor Interrupt Flags - 6-8 */
>  #define	SFF8636_TEMP_AW_OFFSET	0x06
>  #define	 SFF8636_TEMP_HALARM_STATUS		(1 << 7)
> @@ -525,9 +527,15 @@
>  /*  56h-5Fh reserved */
>  
>  #define	 SFF8636_OPTION_2_OFFSET	0xC1
> +/* Tx input equalizers auto-adaptive */
> +#define	  SFF8636_O2_TX_EQ_AUTO		(1 << 3)
>  /* Rx output amplitude */
>  #define	  SFF8636_O2_RX_OUTPUT_AMP	(1 << 0)
>  #define	 SFF8636_OPTION_3_OFFSET	0xC2
> +/* Rx CDR Loss of Lock */
> +#define	  SFF8636_O3_RX_LOL		(1 << 5)
> +/* Tx CDR Loss of Lock */
> +#define	  SFF8636_O3_TX_LOL		(1 << 4)

I'm looking at revision 2.10a and bit 4 is Rx while bit 5 is Tx.

