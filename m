Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A053C697F70
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBOPWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBOPWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:22:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2EB72A4
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676474551; x=1708010551;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4jyCB8zUY8BdbvfW8mBsdLIjiXwoOzOoYLy8TkUsMbA=;
  b=Pq8pKIZdIs7zRJQPdTh00L6CebSMoxDU1Zb5vwAZPV/uXlCXE/BqUB6b
   O2oFiRGnIOpJe/ex7JDH2xLQ7OVAjNVUXjLxYCO3B9YfzJtnAoMYnc/TM
   pnDol0bvI6myzW+B1lHsx5OqH+fzYIhaVBoPD4C4fNtAeOofek/9gi23J
   NBxSBkvkxJgXHQG6bPhRXVVujDwk0mdBgo7U1uYkvAfRyUvMuzU6ux5TC
   najjIVW6yLKhnNA/YkvcV8Y7Oe7FbeMi5yQyExklfgfo2FiUPXVcirn8W
   0QngZrrNqdS9J/5Vo6Cd/T8Eez8VIvyWEvsnvCDKljUfIK3Y4H38n1Kuq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315106701"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="315106701"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:22:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793529963"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="793529963"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 15 Feb 2023 07:22:24 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:22:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:22:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 07:22:22 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 07:22:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFOFOM4PMREONt6uySP2fwlpsVcwuDnPl1gvmtcBAMOSarnSDMcNfEkYD+aKVlqe+FbBSytcDTOW6zZI5qVEkT2S44mhnSy8zQgUzfQEFNoq2XQEwk2DeUZXDgHd9KxcUFGfsS4WOAJ/OPd5bN9hqvyMJld+Y5brOyWKZtGzSMAtXFcX48oL9uA4L+VwVaTYGynYDnGTVeIbrUCI7Xe73VdiEY/ZA9MPCcY/UXdkuOLPWKJFpw0Q2UjvPfNTC997LC0lxk9+OfQ7So4BHG/B9Nt6sF8fIhBF69LYnQE494qGTOxJTuotDiKDP0USsbLZJ0sbidKh+kVssM8JBZlrOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmIYSBrigAmOtyaiiEOYKnu2aeXI/MfCmySXeVK1B6o=;
 b=Bk319/R+y99oYjInUWgckI2V4TiMGxnHaMSu8orbqa2yxP/BdgjrpyjGV6ysqvOK57tfK0l7+y6UlvnO376bFVV5HT3Rv5GUC9wg17EL1uMP8JuE0svBVnhvR/pC0yutC0imzTtVsrP00+evRTSIIb7wuja6opeu6I5KBrEFt31pgwswyERg4YG3fNmyBw4nKntl2ymsoPOBe6igoMquXYYuADelkpEA4yfQgyYyLo9MfURofl/T47YTR6PiWNrXdENDIbws2SsTbAe67FXSUvB0s/EhuBIDSkoh29GiCm+bC+XqC5wTBXrsgUrO1mev5Dt1R5pCWeHDQdXHS2Kj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 15:22:13 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%8]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:22:13 +0000
Date:   Wed, 15 Feb 2023 16:03:59 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] Couple of minor improvements to build_skb
 variants
Message-ID: <Y+z0Xxrj6HXl7djG@lincoln>
References: <20230215121707.1936762-1-gal@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230215121707.1936762-1-gal@nvidia.com>
X-ClientProxiedBy: FR2P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::17) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|DS0PR11MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: b6eaf542-38a3-4adf-c1e4-08db0f686a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRmh189DCj+5ywh7tne1fzceHIRMJ/d0Wt8HqwaoazUiW32XSuVRe+QwgtSL1jBTyeUfhd0uZ8tE1vfruNZxD3qXM2KmSRnWf92SfmhSezOmH+BrrgG9S8qv9669k8fDYLgy85bh+rwBNszz+omAVzIFR0k4ZcvyoOFoptVBJbUCIdcDYKpvXZ6BpoMrAc5MkBBMCoFy98T11s0AI+RouzTl/NZvYjWtQ+AYQdfNKYssmqHDvsbfbKdgk2iMtJ/oer2Q+KYp9CbBYcW5gQXBlPmYHoTnteJ1nkCoNWekoNFUBYOsMDXKVJB8EMOCp1dr5z47EJ9wcJJndzKz1twQTJ51UwOVvRlFRfghqC4mZ0wE4ZsC2wYaMzBbpJZKnKUgVVfEjbicXrKXHOg0Ls+YQIpx7IZNPEupcCOGEUY3YtpoL/qMe+Yg7K4o1xD7+V5cMoGxROCmFADGK/5ew6+ReOZHOllpdL07NFAxEINoZU6HHYhMqpMPHjH1V6qpdfQCK1Vayz5t7/ID/SfoIlsBlyLzHfjbo43JvNtGBgB1MJRNE67J+OvhNT6tEd4DPYEX1s6EGOlMq+b4asv6vF6CZHVTdBY8s5GNTO5ItYKp7J7/CGpt+7UqWmWIWoMfri5ppNMI1PVV1qAxQCxavd2QhkN1+VLqlE82H8Gsox01NOOnUphNeFrhDKEncM+LvD0j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199018)(2906002)(6666004)(6506007)(38100700002)(26005)(6512007)(66946007)(186003)(66476007)(66556008)(9686003)(8676002)(4326008)(44832011)(316002)(5660300002)(8936002)(41300700001)(6916009)(4744005)(6486002)(54906003)(86362001)(33716001)(83380400001)(478600001)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KiIpd+3uEk8hbyISkZuoqPf5gKJRk37M/PHPU0beCcpnAfcA5GmJCB+efLLW?=
 =?us-ascii?Q?m8w2MzCn3qEjdSwKbZpoPhWpBoxI2TNIy75hgiYf6u+9ftzKe3l+I0/kOi5e?=
 =?us-ascii?Q?0+/E3iPBR0TWbJU/GSlm/fp7M19ewdmle+pgTiXvXONRucjMOoQiVqIfVNqV?=
 =?us-ascii?Q?xo+fwtinjhEYG8eGkp1PHQS17Qg+uJ13ukC5qNYhkyRv6mISxyXV/uZr6aN/?=
 =?us-ascii?Q?v3tl4594Nqlv/x7+4gPDBdGRacLeErBmFRppM+b34PKXNBZt7Z69Sl06smpm?=
 =?us-ascii?Q?FpTkNeWQ9Dm+jTruvbL+2atHkZ6HeEUCgzwAcYWeCVE8fxHDzj4auRvLOdPp?=
 =?us-ascii?Q?/fzxStGgARXA4WtETg5hh+oBMYgflrFdjAr36HpZzq/8awyB4PTmLAEoIYlz?=
 =?us-ascii?Q?s2ZOx0ZlCv7lhZbcIMlrC0FEYOYJTcYABDJjgoxYRTzj6fAE5P/T+vBFE5lI?=
 =?us-ascii?Q?vB2lT6TO60G/+dWoNomYi7KyrFle/FTKbSiIrFWKSTm529dEokR61VWmSJpQ?=
 =?us-ascii?Q?4Ek7L3t9qss2o1sMJJwp6buUg0IrgIFpNkAVoFIXzmaYJfcjrppbp9IKZfAN?=
 =?us-ascii?Q?+qeWfBq4/DUYt0/g8ZDBNA9lnJhal/6c5ssgEJHfv/tJvuCMFw4ciGxDWjxI?=
 =?us-ascii?Q?yuP1oJZE5wc8iOiDgj5Ehvf4WTgqBvT6ydheafmuLgmLfT1fFn+m2LHjNrx5?=
 =?us-ascii?Q?vX7YBEwd172WPH8jZakRP86YI0kkvuC0Mt2sQYu1GvfHm2GGDrv+9z4Krgts?=
 =?us-ascii?Q?nGhOez50OQiNCeSJyyA8QD9CetHtmnydbl7gHLyXxpJK/ZuhQ5fEwzuU60NL?=
 =?us-ascii?Q?eXp6TaD518r+emdtjFcTofYwqCPIZkF4x3NyPMy74WNaqa45MJaQE8TuO3zL?=
 =?us-ascii?Q?weE61UaDcUNQe/ZbpiKQ2X9D0NOtrb1Zu64aDuWQ5mwYgp2zvx6rCGx4gdSE?=
 =?us-ascii?Q?VwX+aQlJg8ef7dHWr48bdJ9pw5O4YD8dIoP4HpxMQuTzpqB/w4V4/2ZX3R5I?=
 =?us-ascii?Q?fKR9joL41XAY6wkGGG9wXrWJF61HBCi5EgaqjRtwunClD7kbnriM2F9m9y/j?=
 =?us-ascii?Q?/WB8THdrtNqy9tlgKKNQGOOp8nbntbIGMR2+kjVucmmcaR3qeD0wD1FKVNyn?=
 =?us-ascii?Q?aqH0Fa1r73NFUPNiitOL1Zlv6ZICKPNeQLgwkwj2+Z06+HxAh2fBFuFWj6qp?=
 =?us-ascii?Q?n1jkwLS2IpYM95t6/FBgwzQ+iXDRcKIsENV/vwH4g48FZWF18xNlZi1Iv6LA?=
 =?us-ascii?Q?rLS72B0o1FGvlcn0xlVvhpfu+wWBSkNAYuMPN5F2rECUwMrpQJJcw1e4QdF8?=
 =?us-ascii?Q?val8YXi4E7bKTTDzFHwvWVg7N4MBwKy5Ae9lr8emEVLVkOYVUDKIiamVdI4j?=
 =?us-ascii?Q?xffX1hP04Qnt4E2etHkELCmdGtRMhkBn/kW3RSQEr4dtc3SNP1psEQIZIwGx?=
 =?us-ascii?Q?wFNBz0MR6hNvdNnAc4CPKabWQcHrBoiAQUEbITyAC/7BFpf/JDPcH7YHbkF+?=
 =?us-ascii?Q?oElvTDjo49I5ekrvwCL6YlAc6J3wUcM4gaT3qgzi/WKN0ZvtJnf+B8ji9VKe?=
 =?us-ascii?Q?jbKq+KRG7TnP0bXQ8rQvLpTtXM5OljOimFN4COXHvowlXl0YXrbM/GoD7szg?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6eaf542-38a3-4adf-c1e4-08db0f686a33
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:22:13.7424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzt/d3V27lB7k2uWnqw/wdbavABQHw3DdjYou88s/rmpqcs8puibrVEJ2ObpHWhiRpj9isR86lhwdes3t7fi4/YlKGwLA8BRTLFCbGaLwkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 02:17:05PM +0200, Gal Pressman wrote:
> First patch replaces open-coded occurrences of
> skb_propagate_pfmemalloc() in build_skb() and build_skb_around().
> The secnod patch adds a likely() to the skb allocation in build_skb().
> 
> Thanks
> 
> Gal Pressman (2):
>   skbuff: Replace open-coded skb_propagate_pfmemalloc()s
>   skbuff: Add likely to skb pointer in build_skb()
> 
>  net/core/skbuff.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
 
> -- 
> 2.39.0
> 
