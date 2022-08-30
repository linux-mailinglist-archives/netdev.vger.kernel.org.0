Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57C5A63BA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiH3MoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiH3MoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:44:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95A3F8F5D;
        Tue, 30 Aug 2022 05:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661863439; x=1693399439;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fvArRQ3WZ4rT4oAGzoBgoBE7A3DRjOfD6PQ2NLZWIM8=;
  b=AvRKqmSbaMc/VGDwkOQaugjLBN2a7CXYky46y3X4In7nLRwggkcb8HlN
   GvtZvjBtvJpVaeYE24zPEADdJayOZ58Ylv50UU8pYMeeGyBDXNvNNRwV0
   nffez6YUpC3RBKP6UXAoxJZ/wDizY86F3Ku43/bM8jYW0ctD1yxgXUEmx
   GzP1UgOZiqeI0JDo0a8nOB3CWcnymHLX5lc6heyW06IhiV3mLgot3Xez3
   eQJ8p8fqccBpidXlsrOuCF+6nfUiF4KdKVjOWp2U7iJQmsDd74iq+GPBN
   gePLztWjpOkoi5x+EUicXRjJ4x9bVmb/ftRajPYumJ5EslgNnvTdxSiOP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="321290658"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="321290658"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:43:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="611690095"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 30 Aug 2022 05:43:59 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:43:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 05:43:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 05:43:58 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 05:43:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr95iw4EAl9TVkENSU4ZDWXN+37qkp3fh6uu4LuthhB2tlbPsGjNvgnIYJnoUpW7btFQiYaPLw+pkZg+IELq+TOkIUdHa+nPF1/jNFllxad0BEocYbqf01zogYc5Y46Qm/SGqOOew34WEq6r+4euaJQpdGs580Y9zoLsssnM/g1NMIcSRdgegJ+kQy0uYO4db8sTbG6If7VPs7ifX6MkQHnYeKy3luTC3BD0tZhnG0gdF0GB0ll6YT1XTmcJOq5Ko9nggIraO/IOQuXce6iXaa+jQbHcrqhs6vqq/bN3XBxfc4IGB85Ue9cYH/ZR1BvuJI3krFFUXt95LGHafp02ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FFAda5ljvLs8DpO8N44vDHvMrubaFh/f+9jftgvHhw=;
 b=WtilDALkBG7KRkPa0pTDyoBBH/UxKnt4Nx//sjAZwo6EQ0ZC/q4tZLHkvXz3OE81JkYQUiNTUrYqY1HZw3tzmavC5HqnsTbmZopkJFdcdenG3cPk2J/QlWCFjihe+LYTlnpHQGONf9aS///2dUbN2R62R5fUL+IIlRXyX0KjBe3xSUlqzpvnhtwe1PWmY5AAKcmaZAdV7fmGB4+jO3kP47WKL/nb8LL8MEl4MJeYJN/eq6MnnBUTlP4M+UTeF0DGgNKFdpHKvOfD1BC5+SSeY+O3dex/oszX6t1V22XIhpbocZOQeg/juEEblfqK+8O+8a+dvZPnIrhwffyqYjbqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6377.namprd11.prod.outlook.com (2603:10b6:510:1fb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Tue, 30 Aug
 2022 12:43:56 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::393a:df83:cb78:1e3c]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::393a:df83:cb78:1e3c%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 12:43:56 +0000
Date:   Tue, 30 Aug 2022 14:43:50 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <anthony.l.nguyen@intel.com>, <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-net 1/2] ice: xsk: change batched Tx descriptor
 cleaning
Message-ID: <Yw4GBmZWfHQNgr75@boxer>
References: <20220830123803.9361-1-maciej.fijalkowski@intel.com>
 <20220830123803.9361-2-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220830123803.9361-2-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM5PR1001CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7868283-555e-460b-9a72-08da8a854d8f
X-MS-TrafficTypeDiagnostic: PH7PR11MB6377:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3fP3IhBGmhRZsh2x1lkQTg5mQl2BI9AKnBxF4W5aSqS2x6mkmsgfvqcJPHuIvXz1kXKIQadf0WL3lwORp7QuNe75oRJQ2cGEJO/7bw4I1Ia8NZbQzedjAbqm9dlIE/Bc/VnsKv78kmEOlzA6xlpuDzH0owuRbsBxhpAhXUzWxwTNiNLuaPDyT2+VxkKdOmjjDVzZLG/K+TpBYqc4wG7otvzxwv+tU3UFe0U2s6aDCNu/pSf2l6wPxGeJ6ZBIlkvm6iJuJCcerzLZBW7OS3FVgKSOsBOY0SJnbKSnAwUy9Eo70OaJwm4EpQvdb5Em+fst9YlNnxOctV8lQA5mBwQlHnnnhpUuhdFPjhIYF4ixVjvlprB8t3abrKeBgEZ4z0DJqZFiBe+nVs5fe3l3SI7eo5jyxyjAnYMm5XTMad7lyxFKHAbp5p2a0+wlfUavfl71Rgn6aDZ5GUGtQzWe2yL+UgmRK80lQn1idEx7V10rcc8kNurkajQ8Uk2LO8JDZBT3pkclh9fWmnrfxqW5zD4mV2jN9sBsDOZZUEFbiSwjWGIk+DgSfaS9gGmRStcxPF69Smq08uvGQ9OtRbCF1VkPb/K4ccdymyVQGAW8V9BcsosR40Ytg9U2hj1oljfjdhrzLjIkVfpPn3LWwbX/OzeYynfmRLX0oAlu40kc0Mip9BayGhkG3FxLCFLE6ARPfP2tWuFVMekxsIBuXGsKNf/epjGzYQC1/xX7z2BrkqRigU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(376002)(346002)(396003)(39860400002)(478600001)(38100700002)(41300700001)(5660300002)(6506007)(2906002)(6666004)(9686003)(86362001)(44832011)(186003)(8936002)(26005)(6512007)(83380400001)(66556008)(82960400001)(6486002)(107886003)(6916009)(316002)(66946007)(8676002)(4326008)(33716001)(966005)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nfmlB4+NmFjugm2rC4Bp1Le//dWkUh70ZpUaBdYE7Ku6311867VuuebkM8L6?=
 =?us-ascii?Q?b1VKD5Aa3gWNskRDb3yKobhLBedFkmjwCeorxuey01bpXCCX8KWu6AUL1+DX?=
 =?us-ascii?Q?vADGMHi04mnokSNyPms6uVU9hfb1pvEe1H0dEks/GUCJR67V8DdR0u1sj0RZ?=
 =?us-ascii?Q?sKYFzCQCgKA4gjhP+RqQqDB/yeLrdKlbePdInAoYfpBg9rMke0WYmNr7xpyC?=
 =?us-ascii?Q?cd0dfUydu/yvUUHzq23GoDgrqtgyZGFgb7uULPbSrBVXphCIWLb0FPiEeJbb?=
 =?us-ascii?Q?hRSZVIWYuxlxY37FFt/y09zqc+XA2UFVvpF13bfqWD6Q2Dq/pX4JagMEP+Da?=
 =?us-ascii?Q?SEUqDUpxJcgR8dRR/tob9VbEUiGUAEf0PGnJfk/3MRZF3SO35O3PuIKQpvJ9?=
 =?us-ascii?Q?rt1Mq7BXud/A0KEj0gHnA+X5PIA7Lxgn4xLUq5AC687HbkJKGCFQDGdG452v?=
 =?us-ascii?Q?4pn9IJwAlrHiCz1Pc16rMgbDnccc8J5EnBq9dufv1OcKpf7pqg8mu10iK5zj?=
 =?us-ascii?Q?/7cVIUjhpkAF39Zqpv5cxydnTSdJVf5WgKxhRqSyYGZrl5lWGNGHUHO58crp?=
 =?us-ascii?Q?e4J+kCS5lbVs7jtRVFkfLHX+ii51xd7gFR451fijUKHJBllCNU3gNYaSgwHT?=
 =?us-ascii?Q?/x0o+ID38i06ZCeFXjEvwc8v8M0wLOsfmniMG6N3M2IQ4o8DSO3DvKxmKlY3?=
 =?us-ascii?Q?o+0RCGlpTvMVq0dY8O48FQRznzIaxLcgLiX69xoYg/OtW3lI03DJkXxMWDl9?=
 =?us-ascii?Q?zUsF6zJ7AsJucENJ7qPC8txReGVPw73y9pcLS1WRzcZUUD9GxDK+s43zTmwe?=
 =?us-ascii?Q?jUBuHGWsVOvyJiSb1w/qg6K3gvtapFoeg315fiiEigcbPbkFdo4ZdZBCKgZd?=
 =?us-ascii?Q?PZpr4KnMHJ8kPLTjSfciUWFvPB9cnJPrcEm5a8dh5+Q+vmcwcCqpVWMU0LJQ?=
 =?us-ascii?Q?+ajpZlJZfppAemnXUpyLsUa3aB9BTTsUgg4pGW4t6/DRGp1YYZbJdrTqrv/x?=
 =?us-ascii?Q?975i2MiKVDnZ0IOCub2HV5J3KDJW9Mh0visnnjhvtTDR3F1zy/l6Dy5ne3i3?=
 =?us-ascii?Q?nM2q0traQCOyVpfT2tSZ1ITqES//O2q27sczH+1pRoQOM3ItZIneWWHLxDAN?=
 =?us-ascii?Q?TCIqgYPly+3YTsKg8w1sIc37uTZ37v4rh3KvjgXTu48fK+jvl2nwLgPP2gVl?=
 =?us-ascii?Q?mGcONxb5G0b+snLj4PmXAi2jlHbelZOF2VIFu9lE52asR8nSDRDdhYHv6vLb?=
 =?us-ascii?Q?ecAk9s538YXBxTiYCoSGpHjrqDEJTtSaXRGOKlZL7kOkZLmvITfvsaMG2ozJ?=
 =?us-ascii?Q?DSk631HHmjq3/74hqWZedFyw8GngFroqgJ5g1F63p5EsvKBkBLtzN7FjCore?=
 =?us-ascii?Q?wmAR4IA02TQGixpKUDlUKWtW+1thgA5bGHzk1OTI62aElhvuKb8iI3ElsFrW?=
 =?us-ascii?Q?vRivXQoJeH4Ne6nMpRsUMsQwPIPJ3RPx4FWxZyDqGw6XUj59eMP4MPhq4vJa?=
 =?us-ascii?Q?RI1cWKOZqEsrR4BpelsPCeFJR8EeTGJzE3Dk+j4/jDUv+oN+LwsvmmIv2FAs?=
 =?us-ascii?Q?JtSnrwAwiiJttEG6sYykXQpa4O0OnQ/tRSxOKfdKCzFWlMhDShrammgSE/46?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7868283-555e-460b-9a72-08da8a854d8f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 12:43:56.4292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHyFFtBBAT9o+CSTt1Qw/lTPzC6xq0Ya8JI/MiqpcYVrgQP1GfRw0XvuOS6XV7jjzYJMG8irkpoZzopM0TTirpeh30PhSVukYpVTYmdNMhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6377
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 02:38:02PM +0200, Maciej Fijalkowski wrote:
> AF_XDP Tx descriptor cleaning in ice driver currently works in a "lazy"
> way - descriptors are not cleaned immediately after send. We rather hold
> on with cleaning until we see that free space in ring drops below
> particular threshold. This was supposed to reduce the amount of
> unnecessary work related to cleaning and instead of keeping the ring
> empty, ring was rather saturated.
> 
> In AF_XDP realm cleaning Tx descriptors implies producing them to CQ.
> This is a way of letting know user space that particular descriptor has
> been sent, as John points out in [0].
> 
> We tried to implement serial descriptor cleaning which would be used in
> conjunction with batched cleaning but it made code base more convoluted
> and probably harder to maintain in future. Therefore we step away from
> batched cleaning in a current form in favor of an approach where we set
> RS bit on every last descriptor from a batch and clean always at the
> beginning of ice_xmit_zc().
> 
> This means that we give up a bit of Tx performance, but this doesn't
> hurt l2fwd scenario due to the fact that Tx side is much faster than Rx
> and Rx is the one that has to catch Tx up. txonly can be treaten as
> AF_XDP based packet generator.
> 
> FWIW Tx descriptors are still produced in a batched way.
> 
> Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
> [0]: https://lore.kernel.org/bpf/62b0a20232920_3573208ab@john.notmuch/
> 
> Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")

Ugh too much of a fixes tag. I'll send a v2.

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 143 +++++++++-------------
>  drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
>  3 files changed, 64 insertions(+), 88 deletions(-)
> 
