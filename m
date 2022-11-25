Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76863894F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKYL6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKYL6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:58:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D862EF6D;
        Fri, 25 Nov 2022 03:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669377520; x=1700913520;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=pybNBXXH6jDUqs9zbqn4dUjyCOAnNbydZddYXbQeOME=;
  b=OWep2gutCmzIXBCAgoKhAR/GDV/lQnwYZwgSgRenTPeOFFc0b4wqAYqp
   Lo1MoHhN5pmHbs+kxZ5xOdZ8Ylcs6dDdqOXzYVIrVi5NuRt7rgf4capid
   ZoxPAxokh65n9Kx2uhYxuI1n+5FHzcs+M45O/uvJTA61RA+tCRKlCW4QI
   FFFJaeNIkzdtsDrVaASsUKxUQ2FceBsnpcgl+3Fr1kdn53xWuJqYfei8Z
   Ge3EJmnJUvJyQ24xMCUznKuxv/yR5UckEm0+eCn8c1aoVJC2cPHG5A4yx
   qMEU1pwJnO13ew/iIWt1ooTb4Za9QlK9qSA4CNm+upcMm62TX4dDL60eF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="302041214"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="302041214"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 03:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="817122639"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="817122639"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 25 Nov 2022 03:58:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 03:58:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 03:58:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 03:58:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XU50gjTqY1a35p8i3VvVXac6b25tBZSXLI2k6lVWdicwl5TDIcSANz84FqUaOqRGsMq4JRI1WGP1cQwdL5EIm5kpU1zgD643ircFeT4LwHIZ+X/fnCzvtvTErrVCwUUAASOK5XXHpm1ejCM54Kcc0iUO29ijWsvamBwt3eQAe6vxkgsTOb51erB8kg53//siXEJiJuwqpDnroK0mAp5hI9dUmYqVHiNlDUp+QvKrBx7/+YxASbe/oN9NdtBbxwNynJxhy6bub9aqJkHk3OliF4QwkW2RZXv1WqMFhy3dzRtO4wGVIA+gNV9YgMorw0gKy0rXNNIhbInr/YlTVfMuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cL6+1L/Hu34pakcDF6W3PEe4RkqwL+TvJYgus6lfV0Y=;
 b=k1MExYdXthabHsA+gvVk/VTPEwacenR331DiL8TptPdzPZZ9Gz7lW5XweR3LELLLaXn6eUphnbeVXZUEIrc4gdL3egoevCs/84dVIad8QaL50Ik0lOnkWaENJTY4/SEPxn+JgRayXYdLZCs98cMQznfBabhIZJLWm3ia4GK85D7mJTOa7TiEIXrS9dJVBX64z792uJb/mnvzsqH3HaxGV5RYpXYGVwMy2DvCsTxehtharffBIWfY3AY6PpLPgKq0PXgFEBnoKAwSk9I+0P+ixDzBfv6RgBvxMkitXlPEIKCelNWyTv072oWpcVRNCCjG05owOLYlDQgd+91skst0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB6776.namprd11.prod.outlook.com (2603:10b6:806:263::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 11:58:37 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 11:58:37 +0000
Date:   Fri, 25 Nov 2022 12:58:23 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Yang Yang <yang.yang29@zte.com>,
        "Xu Panda" <xu.panda@zte.com.cn>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] Revert "net: stmmac: use sysfs_streq() instead
 of strncmp()"
Message-ID: <Y4Ct37sV+/y9rcly@boxer>
References: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: CWLP123CA0212.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:19d::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b16850f-7090-4b47-ca27-08dacedc62e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jezgkd3VKaBeq7QGrg5Ov/Tn6+Zj7s1/88Lw5SWQiGKODD3kvf7dM5OR1uVZBWHqilvDAIRghtOIVzU8k8LThafZ6J5Bl44Wh/ukJ3PixtZQ9jVLk4qhKrBJWl1ExHvGxGA9s+IJSbhz0tlmTELkJPEPJG2DuUJVVFq8M6TCMcNmsWVcziZgJqq3y5xSw3S7c0iPRdKcIjuImTQdphgIvBmlTh+P6l8pSVZsN6xHK6xlQEDRznHBVfssRawe8g0AhlED+6SIHmv5X5vWGc+2XrThpe7DulzGe+UJyzn39AN3Ll3+atPtJf7Nl9X4gFkoevQYiAzYfemr27c/I44Olgdi85LlpnJgLNMvOJOv0aOHfsfmoiCW8Z8Tdp4NB0RLgkjiybTHmhgyelA2LxQHajwkyHYpEMskspARSYpeSyiKerZjvU9V/shCE8gFZesYcO40UM9NAvv//DRJiVlzKHaKTRWG+RlD1D93xhqarg+J2yVciMdnTZQ+C1Pgbaj2qjYbdQdF7wePXBpLcAD2PrrAdDhThQNvEAQyPEG/uNSENBb+VH6dMGWmvmIzuxzDths3GO7FtSU/9tSyWhOFt/nTtNfgQ6X6kqOrJyEOcz2Q0DeMzvrtt5E5S3CigTso85/Sq+EYvrNyajnh6ogr69DNcigiFOWpcUaiLcUhcre5ufoS3x2MtaWxhmwi9Sjc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(82960400001)(83380400001)(8676002)(4326008)(66556008)(33716001)(66946007)(66476007)(38100700002)(316002)(6486002)(478600001)(2906002)(86362001)(54906003)(6916009)(6506007)(5660300002)(9686003)(26005)(6512007)(7416002)(44832011)(6666004)(8936002)(186003)(41300700001)(133343001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0lzbEFDdUwzUk5tY3B2RmkzbXFQL2RqUGlLdmpjVkd6UDkxNnJrSjVQMmNu?=
 =?utf-8?B?QzlCL3huczNXWDczUXY5cEVnbzlOWFBZNElsSk9kamZ2NXEvUlVZbG1WemM0?=
 =?utf-8?B?OTdSZUVMT1gvZXlUS1FsV0lqUi9Md0QvSGVWYkJPRkJkN3NnWXlpZ1g3a1Rw?=
 =?utf-8?B?cGhWbXZLVjJMTlUyN2VuQlFXc3Fsd2x0OW1yeDJKSTZuMXRWblMvTGJRRHYr?=
 =?utf-8?B?V1EycFpiZTdUT0FSbkFVQ1NTY3crZDRGd01IaENPZHZtVGxvdE8xYmN5bXRR?=
 =?utf-8?B?NUJSMWJWck1lRjIxNUh3L0E4UVBJT3BwVGE0SEQzYTZsSEkrT29MUGI4dy9K?=
 =?utf-8?B?bVlQQTM1eFNYeTh3L1B0WW5mVVBtR1U2b2I4c0RNM1JUYnpiVElCdURSNE84?=
 =?utf-8?B?Ty82MnQ5eWZIb09ZNjduMU9ra3dhYUplcHdQcWMwdUtNcUhoZlp5S2gxclBs?=
 =?utf-8?B?dGg1SW5HblFmY1IvSTFjRkk4WDZMVkx6VU5EaG1adERBdHZROTE0SjhyV1h2?=
 =?utf-8?B?S3l0N0pLK2U2Y0hmZTJ3cXl4c243RC93RHZiWTRlaXJySHBDSzYwNXFLckFr?=
 =?utf-8?B?UmVZNlJOVGNEVWtuMGpsenM3M1g2SG1JKytSbG9oLzJjMVFWU25GUmJGbG04?=
 =?utf-8?B?a1g1ZFV5cG9TYW1STlpJd2RJbVVGRnpOWkJrNkRES0ZLb3RUVWQzNS9uT2Jq?=
 =?utf-8?B?TytBVCs4WUdxeE9KR01tWVFwMEhRZDRaZlJ1b09qU2svWWw4YW8rS1AvZlFD?=
 =?utf-8?B?aWcveG9EQUc5WUxNNjdQRVRBQmZ4T3VHUlJMbVRrQmZaeFF0RUFVRkRrdGgr?=
 =?utf-8?B?K2lFNE56USt5ZlBJOGdKREJ3YVJ1UFhURHd2NEg3MmM4aGVDVk5XUE1Nald1?=
 =?utf-8?B?UUQ0eEhIeU5jUHI4RVFXRjBpVnJCY0dnd0lWc0hvdEg4WDlVOEtyVzFoT0Ir?=
 =?utf-8?B?RmZ2ZUFWbFdGUHUrZWkzRVF4bGMwOFBlL1U2Q2N2cFZnUVpGUFh3V2NBOG9x?=
 =?utf-8?B?R1VZR21PSmZWaHFVOFJvZVUyL0RCTkNkTW5Ea29xNzg5NWZPeDBFNW5hTHph?=
 =?utf-8?B?ODlJUyt1cmZvazFWTU5Hc0ZKMU4waWxtTDRMb1BHKzF6R1VtOGU3aHJvSEpu?=
 =?utf-8?B?Y1NDcnd6Mno5SVc1THRMTmxZeWxhcWdkOWxYdm9GbmJiNFlzaDBrdnlONnc3?=
 =?utf-8?B?SjhJMnVhQ1YzeWhyeEMyUkhaUzBkODZFOHNlUm5DUzRXbGQvVmlObngyWk82?=
 =?utf-8?B?ZnZVTGN1amdzODJNamh6Z1hPQTg3QXVHdEhodHlaSmZkTVhpYVZoNWdUVzND?=
 =?utf-8?B?ckN1cXFxektsamF5VEFtaXdyTVRXcStOVTVpWHJKZlgvTzI2dVlxSXRSM1U0?=
 =?utf-8?B?SHlQclZ3dUY1d09PMzZUcFFZdFB0WVp2NVFDTmtyNE56VXFWeWlubVpLTURq?=
 =?utf-8?B?ZytnOHVvdis2QWtITHFiR2xtZk5zNzM3OTVDOHpiWHp3TjRlcHdsaUxTTmNI?=
 =?utf-8?B?dlB0MmVUNkpCc3JrQmlDU3pFc0hEWlZqcmhmNmcyQXVEZnd1YUJodm0zQlR3?=
 =?utf-8?B?Z05mMHJJQTViNUFudU5DSUVDSTgza25nM2xoNHhIb3dGY0lwMDl4cVVHOWJE?=
 =?utf-8?B?emxneXJhSkhGV21DTFZ3RWl0dkRrdEdIZ2RoZHNYb0hHSW04YTh6Rm9ENEZn?=
 =?utf-8?B?QU5lbnhXTTlmY2FPa1R2N3c2QldOTlBaM3JqMGNqbm5Sem1GeHpKODRxcWk3?=
 =?utf-8?B?K0twMUduTVR4dXpxOHlnbGpFNDcwUG1oUkZZSDRmZ0dubnowZWtwaVFDalp2?=
 =?utf-8?B?YXVsZHJhZ0NiQjM2bW54Z2E0QmNHWUQxUUxqR1F1OXlXQjdvc1lKZG9Qd0Vv?=
 =?utf-8?B?TVVvaFBSOVRWbENKd3JyUEZEZGhpNzVTdTZkOWptaFA5Q1Z0d0lGVEtGaTQ3?=
 =?utf-8?B?dUpXTmdnU1hJampWY3d6YXpNL1lPelFlaFJPeDZyR2R3R0VUZ0VDZ2g5VjZV?=
 =?utf-8?B?QllCeDBqMHBoeThpa2FsTkdLQnZ3dEwxcTlvU0phaVZPQThmUE1ocDdCMElT?=
 =?utf-8?B?MmVDYTRHUjFqeUsyNUJOK1NFTEV2L2VZaEZzNXFib3J6dG8xM0UrYXRObUNG?=
 =?utf-8?B?aDhkNnVyc0xoaHR2MitkTXRnT3R0QTkrMmVxQjJvcFEreWd0RU1wT2p6dy9N?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b16850f-7090-4b47-ca27-08dacedc62e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 11:58:37.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7r1p4WYIBbpE7zBDN4o6w9sTNYPINHxPqjya0fzmanp3BMjNXq2SVquGX7YcySDU2gH0c4UA4//pCgAnEY7VntMyFRu54Z44YvirN19YKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 12:53:04PM +0200, Vladimir Oltean wrote:
> This reverts commit f72cd76b05ea1ce9258484e8127932d0ea928f22.
> This patch is so broken, it hurts. Apparently no one reviewed it and it
> passed the build testing (because the code was compiled out), but it was
> obviously never compile-tested, since it produces the following build
> error, due to an incomplete conversion where an extra argument was left,
> although the function being called was left:
> 
> stmmac_main.c: In function ‘stmmac_cmdline_opt’:
> stmmac_main.c:7586:28: error: too many arguments to function ‘sysfs_streq’
>  7586 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
>       |                            ^~~~~~~~~~~
> In file included from ../include/linux/bitmap.h:11,
>                  from ../include/linux/cpumask.h:12,
>                  from ../include/linux/smp.h:13,
>                  from ../include/linux/lockdep.h:14,
>                  from ../include/linux/mutex.h:17,
>                  from ../include/linux/notifier.h:14,
>                  from ../include/linux/clk.h:14,
>                  from ../drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:17:
> ../include/linux/string.h:185:13: note: declared here
>   185 | extern bool sysfs_streq(const char *s1, const char *s2);
>       |             ^~~~~~~~~~~
> 
> What's even worse is that the patch is flat out wrong. The stmmac_cmdline_opt()
> function does not parse sysfs input, but cmdline input such as
> "stmmaceth=tc:1,pause:1". The pattern of using strsep() followed by
> strncmp() for such strings is not unique to stmmac, it can also be found
> mainly in drivers under drivers/video/fbdev/.
> 
> With strncmp("tc:", 3), the code matches on the "tc:1" token properly.
> With sysfs_streq("tc:"), it doesn't.
> 
> Fixes: f72cd76b05ea ("net: stmmac: use sysfs_streq() instead of strncmp()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Ah the infamous string handling in C...

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Even when there would be no build error I agree that we should have kept
the code as it was.

> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1a86e66e4560..3affb7d3a005 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7565,31 +7565,31 @@ static int __init stmmac_cmdline_opt(char *str)
>  	if (!str || !*str)
>  		return 1;
>  	while ((opt = strsep(&str, ",")) != NULL) {
> -		if (sysfs_streq(opt, "debug:")) {
> +		if (!strncmp(opt, "debug:", 6)) {
>  			if (kstrtoint(opt + 6, 0, &debug))
>  				goto err;
> -		} else if (sysfs_streq(opt, "phyaddr:")) {
> +		} else if (!strncmp(opt, "phyaddr:", 8)) {
>  			if (kstrtoint(opt + 8, 0, &phyaddr))
>  				goto err;
> -		} else if (sysfs_streq(opt, "buf_sz:")) {
> +		} else if (!strncmp(opt, "buf_sz:", 7)) {
>  			if (kstrtoint(opt + 7, 0, &buf_sz))
>  				goto err;
> -		} else if (sysfs_streq(opt, "tc:")) {
> +		} else if (!strncmp(opt, "tc:", 3)) {
>  			if (kstrtoint(opt + 3, 0, &tc))
>  				goto err;
> -		} else if (sysfs_streq(opt, "watchdog:")) {
> +		} else if (!strncmp(opt, "watchdog:", 9)) {
>  			if (kstrtoint(opt + 9, 0, &watchdog))
>  				goto err;
> -		} else if (sysfs_streq(opt, "flow_ctrl:")) {
> +		} else if (!strncmp(opt, "flow_ctrl:", 10)) {
>  			if (kstrtoint(opt + 10, 0, &flow_ctrl))
>  				goto err;
> -		} else if (sysfs_streq(opt, "pause:", 6)) {
> +		} else if (!strncmp(opt, "pause:", 6)) {
>  			if (kstrtoint(opt + 6, 0, &pause))
>  				goto err;
> -		} else if (sysfs_streq(opt, "eee_timer:")) {
> +		} else if (!strncmp(opt, "eee_timer:", 10)) {
>  			if (kstrtoint(opt + 10, 0, &eee_timer))
>  				goto err;
> -		} else if (sysfs_streq(opt, "chain_mode:")) {
> +		} else if (!strncmp(opt, "chain_mode:", 11)) {
>  			if (kstrtoint(opt + 11, 0, &chain_mode))
>  				goto err;
>  		}
> -- 
> 2.34.1
> 
