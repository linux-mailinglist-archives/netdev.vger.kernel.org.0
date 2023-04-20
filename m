Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0996E9745
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjDTOgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjDTOgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:36:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2135.outbound.protection.outlook.com [40.107.92.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A07949CA
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baUYaa9s21+xeWaTQE1Zoig0zBpOK9VDPt591R7eUAaOfmJe5dBL2RCv0lZlecpFF1ssdLM3hPibvCZDjoo78h0vKLMNUW84hraJscI2zEw9Y6vRf2Im6oBWyEUWNAshCFBoQ8WphHU6RCliDxSlww3l2R/Sb1E0xntKZudiiPHBTAe9JiUhShHjTpuzUzYwW+WC0R9ys1WYMN9r3KuoEjJ0uNhiu8EDCbbNUWsI8zJAFHek0G2pGBGy0kqZxoAxuRtbzDAH1XL2Qj2lcn9Kel5CL0Sei2PfTnT78A8YeRF0SjkDPfK9LV01ZbhzoL8CtM0XnaDm46EdIMFSyAi4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+FRHC4i2UNY7+1vDRBfVqxQVuApbveljvwBu766QWY=;
 b=a+i4OQCNDoO2clFpKWZp3A/Vsl3WxSjH4dSrKX8HShlfY2P+R+5zqBzxPCq6bjgcd04/jH0tIhgFAMC/V6Zas7d7Dx0jmEXh7npz8Hblp++SJUbUWDDYZfq7vUHoLq5iDgzZTq6d2hb+xWJ9tN97CNc7TA2THk1ovl4WuRCo++ellhTEDis+h4efrgzrxj6mWbJX5QFx6W21wt6tiQkl5fMw8dN8MZ+M2tsYUkO+oIaE2SL6BGT8bCVCSVrnTnZspSo5HBZo4bSr0xPpJIWvuC9roiZWvO4OG+OJvw6WTTNJ6Z6T2M2NjC2ZIIUqi8DoiFzqwtWpIgrIrTiw9DFKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+FRHC4i2UNY7+1vDRBfVqxQVuApbveljvwBu766QWY=;
 b=l9BfHHeS9B4NBW1IvtZFi5F3tpNvb8sL1xF4v6e0HESZNLv5V+RV23Bc3kRtBKU4llPZH7u7/Gf2M5rbeKB9QvJmVDxi4vkI6SiLyT1SMLjGSKsS9d1PkzWRVGUC6849Pcp5tMk30YHJVBjyBjSX78xq6RSUh4YpwvY5XAQAtQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4916.namprd13.prod.outlook.com (2603:10b6:a03:36f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:35:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:35:59 +0000
Date:   Thu, 20 Apr 2023 16:35:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <ZEFNyb4zAA/2rh9s@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
 <ZEEdY+qtAQQaFbZP@corigine.com>
 <20230420115243.GC4423@unreal>
 <ZEEqbUinuteJ148u@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEEqbUinuteJ148u@corigine.com>
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 04da18cd-1a09-4104-865b-08db41ac8f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Lcyzl6Nc0I76lklyGkByWSMlMqHZW6JDM140jmNz+6UPObXpeTOZg01DN1jlh64fP8O2AHIQP1DQ4aejKx8WLGWCC0lxaIj/3tPuHTSTB/Y14c6Mp7XJV3bljmTi+U9MC0TLR03mj7XX4NsXcixM3NVQzm38JD3BIBSjnZ/ztSsKCSUA5+uCl5kHeWxa+NLWWRpO5S/Pcm81/A6+Edmt13ypgMEf9K8ibb7RpM6GNJ3sAj6rC5Zly/YaN2J6KECpRzCWMLMWz/wOtdcXieTJ64viOYp6PkywIIZEo9CIx4v+2vsCqB2yIY+ssuMuRVFwkpiiD6/0qX8v1DW2n3glax0pbTJd2iXBhrRfTTEHk2Y+RewHRKdsAVf2wcb8B1jrnclYzlYrmaBeBg3h8Z/RewPOST4VE1Emxsf7HyrLT8hdDT8CpNQchftoEb6PuITE+mIymOg6V6bOhzttfdR43GM5aO0GALMRSx4/wxdMhfgqnDDC8v8VwdqNFGwtAPD+cGpJQbOHta/pLT5lzys+Tuk/NRvlUmA87OUTjM6LwBv121hIsbfrQvKxN4OKFDm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6666004)(478600001)(54906003)(66556008)(66946007)(38100700002)(66476007)(5660300002)(8936002)(8676002)(41300700001)(6916009)(4326008)(316002)(6512007)(6506007)(2906002)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6OyrL7cYNhKKXLsFFPDE1fPtp2IQrodSzASUEKq4sjqUL00BcmTKgzzASLmw?=
 =?us-ascii?Q?Lh2X3ksikcb9Zb5LSYI5I54V5MDTQ3S34lEuC0qPYUWTEkC54wNtFisbti0m?=
 =?us-ascii?Q?uCM8fG1Qf2xKUJBRzP9NT+UL4jUnmSgeGgFOpCMRmdXlaWVF9WfVIn6n2aLB?=
 =?us-ascii?Q?q1csSQsz5tPLUGThl5RNGAxZSB6FQN9sS5wNCr1VfoUb8R7D3QwR13x8exo5?=
 =?us-ascii?Q?HDRenLVIYb18eFlDrFnhWgIu/sfltosLlSg5jZXAhjsTtkUmvtu4OGeoA1xu?=
 =?us-ascii?Q?fV8Y8UV1Jd6B/gsjmYRI9z2eFe908DjxBuygIHSPbnMKnL41g4sGylG6v9y9?=
 =?us-ascii?Q?MUaVyQblSU7mmyAR+MpUf8SE46hYU8nYHk28COZ2v1DPixawmsUfbhOLVk/G?=
 =?us-ascii?Q?Fp0BrUM/VRWGQ9k/ybMSuQM+rj1CEMtrduz35GnX7ClYTPb9SAD+T5QATVp5?=
 =?us-ascii?Q?K7u0xCE228e9s7Ubx5B5kWR/FaFAXSXEHBIdr/KIgnEgsOR+8K4CgVs8WBPW?=
 =?us-ascii?Q?q0M/kYHio3QYdoS9Rfv5N0mOb08QmSyhwJ5ka8UBLYsB94T9Y1rQHuquno41?=
 =?us-ascii?Q?kgo5iwUE+gaBaU44zuM5iPjSKRqUCfMdoxNRvhaJJRQOZwy0aqy5uqbBjosJ?=
 =?us-ascii?Q?JVzrGcOGc2QneoXoz7/AFCSU4TqpHtVJ8vPBIH/SKDiCPCsSbM7EBIYPz872?=
 =?us-ascii?Q?pjZjHZck+kTUaFUdnOLHygpfaQhRNwUSgbzMYr1NhEfOI3snycDHH8vKOiGN?=
 =?us-ascii?Q?zEwd5fsOFOw3c/uELZ1O11No1V4YRAAHsGV/isXq2SpTQe5jeOJsELQYfICB?=
 =?us-ascii?Q?+Ax/sJO1YXI0b9J+haApFWsXv0w3rt/dOFNKOy9TGhzoJC8HWS0SvgT3PRBF?=
 =?us-ascii?Q?OEcjRTIHomczFeaC8f2IWeD7boGig/YBGbGG9r0mzVMJAIP8c07WOwlVetBl?=
 =?us-ascii?Q?XFGs3V+Lq3v29SCBDpMMtcLUyy4UbnSdcBB6l50gi+jfyo7C6oF5wG+x3neh?=
 =?us-ascii?Q?qAmET+e8LP2zVyWdnLFs427GZo60PLLRGjjlWIFNoLQ/chmLcLtJlUmeI03D?=
 =?us-ascii?Q?ZrMr6fBba1XT2nJutYpjTk4ic7+WwHw411tVFw6/wYmwexkkDdFWs344AuAP?=
 =?us-ascii?Q?k8bvkNsZkRbUBzUGqjouJro5Etu3uDF7NfFwR7Af6BgxEj3xPy6Trtz0+XJ/?=
 =?us-ascii?Q?cmoPt3p+9LLoqInvEakVy+iXjCn87N6w9Wkt5aK3qvb67XMhVJ9a6iwpyeyK?=
 =?us-ascii?Q?5ekJoAwNioDcL7oN3J2YEkTK9AR3zrsZzO64977RqaHPOa5eL3+6HBdL7+dh?=
 =?us-ascii?Q?8fA3ViG3PpQP+NiR2XHewZefbnPxp0tw3/pmYQv1TdNQnjAitRu+Qeoy/zzX?=
 =?us-ascii?Q?md7EPNcndnzYu0kBAHmAD6VH9Z67c1zowkQNdrRytVNYIFg7Zr/J5pvFkNKv?=
 =?us-ascii?Q?U1Ip8V8PQwVBDitIsWQzWdeI/pc33Zg5s9MTlOTc+27qEfqYmmow2xyKv2lN?=
 =?us-ascii?Q?2sGucUwqEaiOkTtaFomNNy8iJk5HjalOu4K+jdrS6/jZwtd122BCtimDIuns?=
 =?us-ascii?Q?mp0B1f/oZi5SyvTotUHE/AzK1dCaOMN4j7jgLiRK01OH513DPevYticd2mAn?=
 =?us-ascii?Q?1PsCFwHFFrmGXSl7WUXOzYxZx9YkObkakBaGTROFutGHbpAG19CSX+Qzvo75?=
 =?us-ascii?Q?nfFUlQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04da18cd-1a09-4104-865b-08db41ac8f1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:35:59.6554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4R/Q68vVtjWXHQmVkFEa+Jvv2wjPIsnJptZpE80wemYmkiNDM76orQpliEuEaj5F3F2H56gNaX+pnZdOUERXhSQEcbukURNK+JFeibqrqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4916
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:05:01PM +0200, Simon Horman wrote:
> On Thu, Apr 20, 2023 at 02:52:43PM +0300, Leon Romanovsky wrote:
> > On Thu, Apr 20, 2023 at 01:09:23PM +0200, Simon Horman wrote:
> > > On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Fix size argument in memcmp to compare whole IPv6 address.
> > > > 
> > > > Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > index f7f7c09d2b32..4e9887171508 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
> > > >  {
> > > >  	static const __be32 zaddr6[4] = {};
> > > >  
> > > > -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> > > > +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
> > > 
> > > 1. Perhaps array_size() is appropriate here?
> > 
> > It is overkill here, sizeof(zaddr6) is constant and can't overflow.
> 
> Maybe, but the original code had a bug because using sizeof()
> directly is error prone.

Sorry, just to clarify.
I now realise that ARRAY_SIZE() is what I meant to suggest earlier.

> >   238 /**
> >   239  * array_size() - Calculate size of 2-dimensional array.
> >   240  * @a: dimension one
> >   241  * @b: dimension two
> >   242  *
> >   243  * Calculates size of 2-dimensional array: @a * @b.
> >   244  *
> >   245  * Returns: number of bytes needed to represent the array or SIZE_MAX on
> >   246  * overflow.
> >   247  */
> >   248 #define array_size(a, b)        size_mul(a, b)
> > 
> > > 2. It's a shame that ipv6_addr_any() or some other common helper
> > >    can't be used.
> > 
> > I didn't use ipv6_addr_any() as it required from me to cast "__be32 *addr6"
> > to be "struct in6_addr *" just to replace one line memcmp to another one
> > line function.
> > 
> > Do you want me to post this code instead?
> 
> No :)
> 
> I don't have a strong desire for churn.
> Just for correct code.
> 
> As your patch is correct, it is fine by me in the current form.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
