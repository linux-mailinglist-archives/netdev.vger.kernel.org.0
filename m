Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724526BE936
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCQMbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQMbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:31:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB9A6C6A4;
        Fri, 17 Mar 2023 05:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679056291; x=1710592291;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WAW+3Itx8pCAIULE7m9GOmBC2Zt96/7Um6lVhHUfETs=;
  b=IeVWSfsIhrmR13vUj+XdSrx4EXxwY6i3nt8BG1/EC7BSZiTbcAYgNu0E
   nfR/PEPLm5lLJA7r1DhSEr9T0Xn5vHoSZzO14XphLDO3a0AhHamePQ2SG
   tz+/hIBcIR95U5EzBlcB1ZA4hys1fWIkYh/lmZ81mYsPWmCEC7xqWtGYn
   Yp6wjRuGCo+NWI/i2uX5VhvpzEsSORnhfnJgjdqvz+vIuuUmR6/Sx4ToZ
   EmeMz74LWBJFiM6mlKVfdW+vM/M8fVF8QfHZVEkQyVAQ2tI7lS44ognMG
   ZcQa9gLlo7iuWqYgWpP9peJf4b7e81jEypvP0sGD4P8bOZyyRnqSmNjwk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="365949654"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="365949654"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:31:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="682664110"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="682664110"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 17 Mar 2023 05:31:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 05:31:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 05:31:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 05:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUT/qF70FJOGDF7osiJEBUUpAxqYYpLeGmZj8HpG6b44rBIXff6rR7JBQsozfYIsDcWTHUTWTmuqxwNqg0I4i3Jlwjft4Ge6rOENwID7HE5nZHL2ulPGpFm6weZK0camf5FUg+CkdBeQn4+nrSG7XWZpW90juNr89Lr9D4bceYQ6tfwjZjzG2KevxwAZApG4HuOfKwjIGtjkFkiio17nl6VmuJ4o/Z+bsNw5dxU5S5zRqbTdNdzHQUy66x1GnpBNmhR4ujKgjpISodohd27n5fEEVXV3zitLvjTy+DfwyCk5OSHd8vjOUsJK6CkqE16mwqTyYkemF0XmYmQc8soXTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNo9jQ6BSJwNVNvgq6JcINynDuqhW8Oyy4ljME6BZKg=;
 b=UQSieMxQ6b+CKmlXgF8adcxZidN9JVFJf2cHMFETJtNg5lj7PZEscT6B9UiJjeGD7a33N/BJnxrmZpAL/VMpbTk7emYSzip7IWdTsuEeTtVT9670hHxmXFLkVqhuctSFjVb0TJAOkgMqyYnRdrYCoJNagMT7ryWcFQ+YkXoeWFG8grcSQ/eMhTJ0E6HkJVxvqCMUtgE+WXOjeU9j3iD+YhxGeUgKygxBI9LiJCVihd39FVyY0fy3oi9NoziLzFUvFbstlzHJguHJcmQdWwzdbiBqEXBYigsmZ3q+EOXQwUI4O/2tSyoqFmwWT23AA+duRjVD/RlrB7W5fBV38ZzBDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA1PR11MB7086.namprd11.prod.outlook.com (2603:10b6:806:2b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 12:31:27 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 12:31:27 +0000
Date:   Fri, 17 Mar 2023 13:31:24 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
CC:     <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong Boon Leong" <boon.leong.ong@intel.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net V2 0/2] net: stmmac: Premature loop termination check
 was ignored
Message-ID: <ZBRdnEGUNySQeqQM@nimitz>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-1-jh@henneberg-systemdesign.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
X-ClientProxiedBy: FRYP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::19)
 To PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA1PR11MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ef28dc-7187-49fd-9632-08db26e3870f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNmZw9MAng5Mk/3Yl9DcDmA44+bAD3dxqGFhxuBL0vzAMqRVwwjExDDRwDatnRYA7qnPyLpN06ARFCeUfCI0WbJy0mRwrF+r/nUcZSIa63PAUQrS39P7k7oGj7osj0NV9sobYYbUzxEaq3qTLEkr0bF7aJ1axzDfBI+KXZVsDWOFymMs7hST0Fs8/7HwJBq39bpa0z7FKzLgE/USWt4hQtk/6zSklBkfKNl/t9yEaUP3nshPIC/7Me9etqPXlN+83y9icYC9npnhfqq5HpBoonseiMEcFEr1eqoA95mV4vxZZIFmP7q/lQiFNfEC2R35mimzIEssjE2uh2/H0DPTowRblUSCe71tC6R2qeT5nLM/KhuBSPv3Q611blo12FuSNjDHsuxcGjZBNfu8IJK4QEPTlyfpVufmJkhH5dcq3dtie0qDyZCJFhnmcLKAlqEDdqgkqZ6U3GQHak1pTrYxTkuj3Yh5Q/27jw/A1Eo3eodK14/kpeocIzpzHEmnDBaSn0rk7nr3N0cT+UxREyD23t/GosqAMs3yrI8K0RPNGaroAy2IQRdkQB02mK0U3A0RFDcBpq6MMPxMLeiTBMoXYSfqOo8HRUWZ90/m+uz4On7fipS0ynTZtfxF2N140l24
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(478600001)(966005)(6486002)(33716001)(54906003)(38100700002)(4326008)(2906002)(66556008)(6916009)(8676002)(66946007)(66476007)(316002)(6506007)(186003)(83380400001)(26005)(82960400001)(9686003)(6512007)(6666004)(4744005)(41300700001)(8936002)(7416002)(44832011)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eO7LhdZdwoECoGv3ljpU4wej4d29OSUPlJClY6u50GVCzieAzsoU4xBJLriA?=
 =?us-ascii?Q?4bOrx/Jql7nE/H8a73xmvGnry150RRQC+xZDxBD4mIeIHeD2u40FJxeBe0wm?=
 =?us-ascii?Q?2ty2ySyS7Qy+5vM7rQp1OqDkcxfHupm/6dTUSyTkmDGMIT1B2TvTRQrSJgpZ?=
 =?us-ascii?Q?jhYiuTfTDFWpRbIAGPpInLFmerasICFgD7gF0BUg4q6vcqEP7hJFU6uyDksI?=
 =?us-ascii?Q?ydUoCC75mnEM4ddPYlpQqG1JWnwHTjUjPM6YvhU/d0G9thq+b7WkEUadeA0A?=
 =?us-ascii?Q?yS7ZGq7+jEnLaxnNYoBObNU6lPfwz0zaB8U6U2OgIyeD5AsaZV0hyYnEyfQ9?=
 =?us-ascii?Q?kUO2i4m2F3zvk8HgwPF3bofQQK92qloGAClFtG4hAUt7RBpsiWxc8Xc4NKDB?=
 =?us-ascii?Q?+I1un+7We7bka3YV+LRcWtaeKQ/x6L75i1bQk+7PR7EFLuqO7iQ4s0NuxXyL?=
 =?us-ascii?Q?CXsr107pujwF5e32tfE+DYCUxkDTt3Ly1C58X5BhGkgxSHulm+z5JKo7dAoG?=
 =?us-ascii?Q?J6WHq4/cC+U6MUvBeUkGQBrH/DTVMFIKbhh+noUlHMnNKsP8Cb0Aabf/zLCO?=
 =?us-ascii?Q?t8aiDcoiqLgJcT2GVbWuhCW/fykZdlDkGLMRcMwR+f909rNcLbwyvSJGIznu?=
 =?us-ascii?Q?rOAvTpR5qG33ZUpCL2/2gGJWifwPw9vIZ0cePzPkWzM/y5u8hIR8/4g9obyR?=
 =?us-ascii?Q?uyFxxuS1TaZ0kp4YAHDeel6AIeIfPpl3VLRRxWGWqCwtnQpGKtqobYVj16xc?=
 =?us-ascii?Q?EWVnbkLhCqHZgZbCSHmRyIfBIW7L1t5B1wf+NB3AHmPriAFT8/ixxYd8GZcE?=
 =?us-ascii?Q?qIldOwPBbdOVaDHpVkXExeyR/ckbsoceTQ+3h3DMOV9EGRBR9jK8Sb17yvdy?=
 =?us-ascii?Q?yBCJbRk7x8sXOLc8TYgA2VFVXEMw6UZIn/vB3554njqN9EZQp9zwmSr20JR0?=
 =?us-ascii?Q?NxKSQkVBBgBAJXn21MioWUKylf7af6605QS7LGWfEQKKtcgkhvTOlGnARgxk?=
 =?us-ascii?Q?1eRngMeq1B0zfPGzo7SbSW15Mf5WBk9qP1ym4wLKXBwK6Mop1th5h71Z0wm7?=
 =?us-ascii?Q?g0/jZ8ky5W5G/HO4eJHDYT4mwyW9m9aJXv7R8dCezT4BLmObxKKdUEdlCyH4?=
 =?us-ascii?Q?5fYhVLxbjZXvH6UyD43hV+X1iAAmnTc3WWO/4Y6IIDMqek73iLGLzoCiSdBf?=
 =?us-ascii?Q?/TntzjNS8LZsTSIsym2XikUah7uGg7agR5IW5aHWOToT2jZSqlf6C9p1cr2j?=
 =?us-ascii?Q?lQ703mkQrZy6EWCGhM8afv/lhzQKaIh3+y3U9fOMFvKXOm0OEaNsL576v8k3?=
 =?us-ascii?Q?FPGS5jECrP64Im6R5uwppvkwB83BTow54Oj1P+ltVnPPPjZsfxoRayyr25Sl?=
 =?us-ascii?Q?Phob2Q5OlKgf7OEER2DVNuCUUxPMFU8ipi77XcI43LFl4XsRQPUo43LsQpc/?=
 =?us-ascii?Q?WB2kXgNZchhFkTMH0yCLv4ZZoE7lsxJtDYC8hZdUw+9lrlM997sJ4JZ2v2mF?=
 =?us-ascii?Q?J6ZGLOjF1f7gXA5FbQcHfd6YwaZPKemJsooPxT0wvSFg586cntfdo+TR6ziE?=
 =?us-ascii?Q?CvfWFwlPBqGETfLn3FdxyykwScrVoyn1pu/5r3yDyh1WgnVGdV0pTWPF3ofZ?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ef28dc-7187-49fd-9632-08db26e3870f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 12:31:27.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MH3Xpr0DNX0C73gSYJbe3rCSgVJf/IDw1eD5Q02YnjUxH7VoHUC7Ifyp1QkQa0uBD+JeBKvEVXjbZKzMJBJak+bH9lZnKw/W2E0HxF1UBuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 08:59:38AM +0100, Jochen Henneberg wrote:
> As proposed in [1] here is are the fixes as a patch series that do the
> premature end-of-loop check within the goto loop.
> 
> The commit messages now tell us which rx path has been fixed.
> 
> Jochen Henneberg (2):
>   net: stmmac: Premature loop termination check was ignored on rx
>   net: stmmac: Premature loop termination check was ignored on ZC rx
Thanks for differentiating commit messages
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> [1] https://lore.kernel.org/all/Y%2FdiTAg2iUopr%2FOy@corigine.com
> -- 
> 2.39.2
> 
