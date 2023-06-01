Return-Path: <netdev+bounces-7139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3564D71A5DC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E56C228169E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E39440782;
	Thu,  1 Jun 2023 16:09:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1883BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:09:41 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B029EE4;
	Thu,  1 Jun 2023 09:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFjHvW2oxtl46RCSEC4hybbQ8rRfLOKkclVqD8W25g6+ZWXlCnceREd2IPRSRVEwJiwo9Lr6QPDzWIms3tM/HKDZZDKjnmX/YJ5dF7RO4hcFUe5/ukJxX1XEa5oqRTNI5gwMTc/ycpjWQODYmKXgB1UgLrk03M8VhBDJbzyTVYQ8wLYImr/LX7o4Ihg00vLwc6vV0UUDttbn80dKrelNiDpdaGyqG+YQOddN4zEn8n8ZkNK5p3aHLfjMMJ6jFVBcwK+2emripBbyWt+Jc8um2NartH/sP5IO9wsLV/3RPuGECxpr+acUR5gH/HyiQUBGoFW7ffnuQO/yfWaR+u/nAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFT2US2fUZWpWS0YzSw48jA08RZ608+MOvzBvb5Hmbk=;
 b=T6lUaWQu27aR2KCnmlGZI/5OTh1PSpDtq2meGZ6R12+RHHVTPoc0O5PHku5lydUQG0vkMdzhI6vRY0pGQp0ShE0NIBz/4JwnELHwlxL9vfv/pg11xO3OBzZFZ8RnZJtjDSYLbpFhNUQAWGIdF7i25kDyFt9GewPIAfM3d1rZhhLRJHK7b1T+TTvkgLTYgWKzxmec1qN8CE51fmSdZVEtPgljz4UYPCLoXRGXDZA2ASrnbr3yh+RXyisKyY5XeWZ5EPXNOeXEcxh7ObEmc5uqqX1P26ZIwqgIHQbE/InQm+ZW4xcjNtz3r496NrsbluUEYkmmghOICOuxFcsG2joJcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFT2US2fUZWpWS0YzSw48jA08RZ608+MOvzBvb5Hmbk=;
 b=T2+ycsdtdZ0AiK2LG937GfpR5kgb+p2pwbzi6Wd4h4/bTntrnYfu4G7ER3yUHRCFXjNPDVI7eJqFTR2e3XwZJOV4HDGdbI9jT4ektct/M2DrCjz0oSwp38VVSaUAm+n8W+knnHnS+U8sX9zugSqewlThTwriHEV0ksLmLK9SD3vLLcEgtaEO8h2JsZqV28KN81wy8moZn8xoHg+8/71lhchm1WjJZLRQ1P2ETWv0LHym6BFI76ygi4iLFLv5RAR8toOB+zundYFeUbjDP69u0QCd86i6gs+efyKuoqccJtqJMUcEI3zwNA7XZ48CBMlDYZZ2npwwj1v5csUi2RWb6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8176.namprd12.prod.outlook.com (2603:10b6:510:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 16:09:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:09:37 +0000
Date: Thu, 1 Jun 2023 13:09:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: longli@linuxonhyperv.com
Cc: Leon Romanovsky <leon@kernel.org>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Long Li <longli@microsoft.com>
Subject: Re: [PATCH v2] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Message-ID: <ZHjCvuetIMDZgPgQ@nvidia.com>
References: <1684045095-31228-1-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684045095-31228-1-git-send-email-longli@linuxonhyperv.com>
X-ClientProxiedBy: BYAPR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:74::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8176:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c40e9cb-6822-4ddd-37c4-08db62ba98cb
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	letFdpxI8bdAqE/zpBupEwrxamm0BLgrXVn2vtreRvXdChVhFdcQ8PZXu3ZHgDWxkRlujHHCjiCxklLBn5FnC/3ry+uj1MmNFsaE1epoBbZnfUZA8agmA+Am3p5dAdBXZGdzfDE3OCt3n0jiNkfz38adR8ZCAa+4nBl9mtVrTnZS48nF9xFJ/z5qz7xhL8ZRX4L5T8gu5mURYRBGzhvNo5TY7FkvRfrAEAArDo5pz2ALxEGAdrz713o8OFzZ2rDD3lE74J1EkFofx8/EEf+ySkpT6CorRf7v4iX+vCTkKksNOrXrDE7oHJdV/mbry4LUfjYkNyc9vwSSVlIUa8TSDfaWCwWgeFq+tvFUMk+XGCa/rLwmSAxapq849chsQ+mftmA416pjAbedD/V7mhTwnnT3q9zEuTtCBXi90HVWeDdRY1hZeumAcJFO7G/g08SGcz1g7dAQqSQQcIjnNgrSFM1axmh/TIYOHUfD6HX8t4XEVUw+f/o4aWoMEkPtaYTFJadvIAzBz8yAaou7z9xY0TbR3sNn4KnT4GRm7hhxgd1mRoYiBugKaAWftkdk6E2E
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(186003)(41300700001)(26005)(2616005)(83380400001)(6506007)(6666004)(6512007)(6486002)(38100700002)(478600001)(66946007)(45080400002)(54906003)(36756003)(66556008)(4326008)(6916009)(66476007)(86362001)(316002)(7416002)(5660300002)(4744005)(8936002)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S863O/QcevnQEqUuCG7mFDduy1hBeydw0fVw0SAh02fZIBMNYWeLn1zvtvcI?=
 =?us-ascii?Q?GcvUs7B5cKxpgBId9xBPcLpDwuFyjffyWUzxiS9uUxBNmUP2kS/QhvY4E79/?=
 =?us-ascii?Q?oE39dZO8Ql27SGpVJIr+XxWDw5tIqpbLSIxxkFo+8sDpka2WmEQLDO1d42ti?=
 =?us-ascii?Q?eoOvCneylobqJ6HGu9bJ5yrUAOic1l4w5IMRRrKBa9czFDVC5i7gNmV+zCKu?=
 =?us-ascii?Q?5FIpon8LeqDt/j5oro8TN0Xc7/R1DRTtaRVxg6lTnv2ZGICVkPpoAQPmTi1I?=
 =?us-ascii?Q?nZTel9e2lLNEmzBaZ7GtI61EOzQtkvnbr3SCdmmMWtTl9wJ0yM99oVyDnRc/?=
 =?us-ascii?Q?4wMt3S1PsqiaRtYCpRdToUPFDg/lPl6DjTwo738fsp8GO+MtmBI0FvUXFqJL?=
 =?us-ascii?Q?LzfsGWtpUjqsy+X2a4kEc4BsQk5qMZr3TY+hyzfDTK1kAZapM25eHRptJuRL?=
 =?us-ascii?Q?CXD5nv/5B9C6wcv9SEiM2t+diO+A6ZTGbowWP1GzpfTngz4Qu2/LxFi3lN7H?=
 =?us-ascii?Q?EqUFf++NBjnCvCQ27kF/ToeFjYnc1sXKNuA7B7dM9Y7KytOX0i6TqmFaeThh?=
 =?us-ascii?Q?HSUy+Kb0RWX6e7u13RelmwMiNHaI0vC3c8NMyF2t0n4yJbba8+d0jA3p9Tlb?=
 =?us-ascii?Q?TH0K2sa/IRKqX4VyzGm5S7lcEDFUk1rXg5PdD8l2wzaXnaS9fLwu1wiBm043?=
 =?us-ascii?Q?GvTXLz41I/LvAEXn/Iwve4myQo12S/yEAmxDAfsoU2qKBMcw4zIpnYcr0dES?=
 =?us-ascii?Q?CLeyAcdG2ehbL33CeBcjJFToVeUU7TXSdRshOiirDwe3VaZX3YUWzbnjocvV?=
 =?us-ascii?Q?OsmvGxCiL1YxRSdSFKV6+JZ/AzZVrQ2XwS6H17j2CiV2SgbWhNFpMUkR80/g?=
 =?us-ascii?Q?2Oxknfs+M2A/5A8617sNrXA9Ell66k9rJSZx7sPsvYkZ0DBTErQOkEtH0A75?=
 =?us-ascii?Q?Zatn9JYigPjtEsws3CdprttPsEPKyBlyMBOiN/Mx90A09OnriY2y1sg7Tadw?=
 =?us-ascii?Q?ukWRTNE1IEdEs3NX7W2GHR+Vl0d2b87+hDJ9zjD91WD+ycN12S+l0hjeAuQx?=
 =?us-ascii?Q?8e8aP+X9R9xdMiatSNFmkcamqRyEp3roFat6hr1V02b5AjAhd7GwjcuJG0po?=
 =?us-ascii?Q?FyAvdY3k28uWpFN0tl30cN6q0Hf1LlDAJ2vrpLGnJkVJBlFnSbOUAme4Q1Nz?=
 =?us-ascii?Q?8HiP+nshuSM+7qjfRfY9JesokVrSL4C3TJtsQfNIxl2GGvTnQgs5Te7nsXH/?=
 =?us-ascii?Q?i5E6YwhWgw1x7ys38rqqnGNylRV2kPmrEyh7Botn6wO5O5Gh3AVUg2nvPJDz?=
 =?us-ascii?Q?uY9ZSh+ytlQdA4VwKpb7rOGgo5eb1cfQAUOOR3K0b8JYxMmZrgP/T+nv0BX3?=
 =?us-ascii?Q?P+pozWuayQAIfl93Nq8FyAwQCQTh5N/OS4jzcAv3akKKxfWHZGbeEWe+YTt4?=
 =?us-ascii?Q?vakjRNAlAr8tPBR7jZUQ+slSRbf1HxLH2Om3UBvRYJxqq8SrSoe+gz4klswU?=
 =?us-ascii?Q?zIAyx8Mc05cC/oMqzYCrYsNbRBeDuwPlX/Fx++f5jpNK8pagzA9/Xy1pGsFX?=
 =?us-ascii?Q?20I6rb+iNN8ICPb9x8a/2BPvxxwYjov5mfpL6APM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c40e9cb-6822-4ddd-37c4-08db62ba98cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:09:37.1987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6auVrX/HbvJLeClGsFfM8HwdjwrYqgOIAg551OfrVQtds19MNTSTNU7Gpmr9B9UK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8176
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 11:18:15PM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> With RX coalescing, one CQE entry can be used to indicate multiple packets
> on the receive queue. This saves processing time and PCI bandwidth over
> the CQ.
> 
> The MANA Ethernet driver also uses the v2 version of the protocol. It
> doesn't use RX coalescing and its behavior is not changed.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
> 
> Change log
> v2: remove the definition of v1 protocol
> 
>  drivers/infiniband/hw/mana/qp.c               | 5 ++++-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 5 ++++-
>  include/net/mana/mana.h                       | 4 +++-
>  3 files changed, 11 insertions(+), 3 deletions(-)

Applied to for-next

Thanks,
Jason

