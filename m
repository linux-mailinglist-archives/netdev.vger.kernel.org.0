Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F495BA023
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiIOQ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIOQ6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:58:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8498D02;
        Thu, 15 Sep 2022 09:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663261128; x=1694797128;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x9Mn+HpvE0jeSXXjYZwll4DXcBg002OF814G9gDrW5o=;
  b=Uw4K5o5G0nBfUQy2kg9wEHokughc8VbQjRLDeHoClkjj85sTYM/XJ6Fo
   yuZlOhj+sUrF96RJJMcLi6oGgxRQHJiQzWJjxoydgUCLUusC0RakVNwKu
   KCMRtgL+iXvzQXyjJAm4jthbzSRaT0elgXs+HJlGUW2K7+g/XHkPXRHDf
   JWw52XXmJFX0Awthh9p3H94b+gSkcPTRT7dQpOrqHTw2MPReZyxnqcr0J
   V3b6DJTazn8Vf6Ie4n+v3UckNMaBeO7SnRFseDkOH28qubdpe4amjdYIC
   T3IXj/zndsOm5DMAuvA2iRGm6gKMSLwfel7NRR1YpuogzQOmS0JdNmYf/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="385063725"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="385063725"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 09:58:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="792778449"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 15 Sep 2022 09:58:41 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 09:58:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 09:58:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 09:58:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 09:58:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVB0jNRzdjuUZnbocbNvEFSHtYfMawKmokhEOn4MEPiD0jtlr4jusfoM0X4lEQ5ObBbdCJF0QrBvnYQkr5UgxPBH6a638sJFWhLP5USABiVDhzQ818OxjGZcGEY+16VLrOo5/bYbWrH98g7HjtJMo5ke3Fm4pyb5buguvixVlxmY2UpIT085Ed+/5nPELf1deYwpa02YUYt2a7+2jD8Uj9B27Gonv6OYYEZStcxfSPG6+XPwRfP7BsuAkxmORgBJjo0Xl97820NizXGd63MpRlTtK1junc9eRO31Xh3tH8ky+WBViQnmsTn77JrKAuYck8Lh/p2AWydI2+eA20lLPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMoLjvzSrz5iPMXfdoWqzHHV6c2eiW0C+2oRsmTrV9I=;
 b=GXkLCJCEQopFgb04EHfv74c/rHjzi3FRrwSXhTRUAUgnXJdHWb0oyCy2C+3X44taPf05PUoffl+nJLlYMJdGrOxMRulrMsSP533QIccoWjsErhlXVtuOK8tmnBWcHZH67FEJhw6UTCCILNU34FZGFwlNIAOejD0q6gyKzlcKOzALndrEuVWVDatJS3E+bDJuH5nT+yFX8IX3XSXwY6bGcusdb36GYOFsPJb9f1azi1VreOtJ85A+Dweqz94REYXfMr1VQQrIg55iWYLm8CgZkNzIVKLk5yb2pxkv3oZlM9XCuTFZLojH1mGHTqRwcRdv0667sEcCw09x3JhZOxuSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by PH0PR11MB5660.namprd11.prod.outlook.com (2603:10b6:510:d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 16:58:39 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::1967:b7cd:c851:cb91]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::1967:b7cd:c851:cb91%3]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 16:58:39 +0000
Date:   Thu, 15 Sep 2022 09:58:33 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-hwmon@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [RESEND PATCH] ixgbe: Don't call kmap() on page allocated with
 GFP_ATOMIC
Message-ID: <YyNZuTlShCviTKXi@iweiny-desk3>
References: <20220915124012.28811-1-fmdefrancesco@gmail.com>
 <96855b74-5b77-4426-891b-d638ead17cd6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <96855b74-5b77-4426-891b-d638ead17cd6@intel.com>
X-ClientProxiedBy: BY3PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:a03:255::17) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|PH0PR11MB5660:EE_
X-MS-Office365-Filtering-Correlation-Id: d1b3ba09-1594-41b1-d42b-08da973b896d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3DnVmFyW2Yq1UXVfkF4lTdN7DAQJeYDpXW1x7P+SceF0jTo8bPrxf4bxZcGdUrDZZyeR9gX7irmubXT9i03R93a/sO1I5tTSNBrK12HPhG+wYqz3nGgQ7bDULtkUwEqiMKf6n0otSi14V90geUFPHrTfXo7JzlTvccFnQLZlbHNcCqLv4REY+cWKTQVADNOduEmaZd76f1H2O23lcKQpYdtsQtH4g6Q1J6FLJe8ze2dtyn1cDxNxzxWbI9Yf5bQIy674GAwICGN1aRJejhVpZ4gSHB3TGy6ukV5jH0hoeJUWqEeJqx/oPx4UrL1lRcANvb/7l55wQxoL0JrhEkbcBnPk2tlaGmdC6mnsetDQMp3ASfHlcCunyZj9omQACEJDW08mg3RXoqM55KcOL4tfFCLrbQl042SBHnXtDX2Rjfw2vacRndxCiOik0OQwQ648vi/lTkwDJMcir1LbFNPgsNiO8ceXXP3ER0pRRItkhUNR3i9kn6xA6Nxr6IobKA9jPABDHuny/WZKFERqZ2l7fGCsc6k4evpKUnWgcw+UstKKvoL2H9R0VFZ8Wm7Ae1+HOHZr+V+6RnA2T0sZrUSLQ2a2wGqOYcWwXPk7Gws6ssa/D7/Jhfu3KO+4kofswKND3pw+fpoWFPB/iLGbnveEm0KnuqPUsQOChnlmP4ldJamznBtIPHgQCmbSMkZhhFedyQ5gDfx9vcRKCuOeP9kHwmoQ0DJctaeso5T22lmi1k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(8676002)(316002)(38100700002)(82960400001)(54906003)(5660300002)(44832011)(86362001)(4326008)(7416002)(66946007)(66556008)(66476007)(8936002)(6862004)(2906002)(41300700001)(33716001)(186003)(966005)(9686003)(478600001)(6506007)(53546011)(26005)(6512007)(107886003)(6486002)(6666004)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1TGIQPOBLBQ5EO3gwJ1j9NcRI6T6yBUTwtZG53MU20QDOFLxENwF2uRZk0TI?=
 =?us-ascii?Q?AB2P3AlHHoUEBeAz8yZumSGwi8YzQqVCbyPrzoFtbiKEMEPBchS/m1xaJY+A?=
 =?us-ascii?Q?oi4jX3p1kNDDaOcMPcW5oRL9G6p6FnkmQV/B1Zp6zpiycg69+XqI4n9eYJI+?=
 =?us-ascii?Q?QcWuqo/+vjXDkU9Lb5gNGfamzbfLXBTvN+zmVzJQrSiU2h0TDmOkv6DRiAOO?=
 =?us-ascii?Q?ta3adXgadZzaTQUhFx8Ifp3GXtSZhaYizD5RYcOtQjiu5PJ4l8+1WMHSDvK9?=
 =?us-ascii?Q?6nxi/RFMflsDvPus5UQ8erYtQZaETN1m8Ye2v2iI/z2+Bg6BLuE9YaBddMQD?=
 =?us-ascii?Q?8yYS/EaX74OBIrEZQmkjSraB4oH7KKA9I129vyFcQ6GD6NvO+etdjiFKdFir?=
 =?us-ascii?Q?j7B3MqqJ+FMT1gbMYtSd+D6740gNgbpL/8vLEKGD+5hhXF7HxeXR+8hmmz6V?=
 =?us-ascii?Q?mSePJ1/6JZ8iAaRkHIAtyHF7kFN4tNrvgnlh9YXmhOeRu00vFvtSJMtyxjkP?=
 =?us-ascii?Q?QBA5Aar7k1DkQVAIhIZ5xzWnB7/bFSzhBrH7QXiD3Un0ZmFol1loXCcZDI4V?=
 =?us-ascii?Q?oHXVt9YxeFy9LT4k67GzWVnH9IhpsCVZsUNOWajSWZAnQcnQ1yOH4qDiI4+n?=
 =?us-ascii?Q?B5OkROV7f7gokEVqBgeQUfwTAva5rPsLBhvG8MNEFQFu2Tww+woellxQvde/?=
 =?us-ascii?Q?4oFf1D7J2bzR9dlAGf6zndaCIYcTgSUD+MQciUBzFZ4qcGN5ZuI0BHWvaHim?=
 =?us-ascii?Q?MGReMrZ2f5DPQNQ0TSkJ9YqZZ6kgK4f88h/W/76FAvUEo1wi/aVuwzWvbd8J?=
 =?us-ascii?Q?hcL6OcE4Da3+ornvzWm19R5G2ZhOngIhEBjkMDe7lmENc0K8QCQKWylOTZHk?=
 =?us-ascii?Q?geOH6EaKiQ8S04ouAE3EXWOhxOgeKUmIhsPS8sq7DEYq34+yg7ovrYxd1Y6G?=
 =?us-ascii?Q?+JSMwMtugMY6t7W8vBARNl24UCDzfyAhXgTnrcIK0Nrn6TaIVzfCqJUYlZHw?=
 =?us-ascii?Q?K69mdxnqoKugVAr41op34VA1BIMYgefVrFh3lZh5zOweWOU9qqFdv+yx1mN6?=
 =?us-ascii?Q?2HXY2xZECyX7EPBLuFtJojAgnYrgsIFZaZp8S6ERsuIYiCNM0jiBsm0AxbNU?=
 =?us-ascii?Q?7F3Cj8DXLfKAGb1U1uwEwKELBihZmWEfy8QagR5RSfRff++xBh95Zq/HQ/R8?=
 =?us-ascii?Q?WwqcOA7bYnuzheT/iIz2Bp9me4D99XEPkZ3t12iBJZpXILrn9VDR4usHhE4Z?=
 =?us-ascii?Q?stB/qAzRdk+lneikg8RZKKV03S1SCgm7ulrps+DzXlZ+f1mU1edX2wOZ8H0i?=
 =?us-ascii?Q?f8ahvT8ayrmvzrhL5XO/3Nd4TR544pQA4+GIz4tF99kNxvCZs/J773D8Xcwp?=
 =?us-ascii?Q?mGayLLlv0+S5+XGRBZfOU2LT9BBEruvIeZVCo2v9W4/pXfVC4v8Co9j9NRed?=
 =?us-ascii?Q?dBxXSnGgb08lnRk7TzQ2WaxWiijnfLQHr2Xe1a9kH1I/lICQKQDJty9YFpV+?=
 =?us-ascii?Q?kCv7N0tXK+vkIxCaVeMXe5h7yYE6KPeVybYr2hov5RkVii2GCTNnHqtCBTlw?=
 =?us-ascii?Q?HNaH5m567hQtiDWeZPLUS0ySrosW9ur71hMsztbu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b3ba09-1594-41b1-d42b-08da973b896d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 16:58:39.2449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNZc3Bi8Z3WkZdIqmXtYM3P3h4QmMDAStXKdUvFNzELmvSz1cYZesTK5OD9ltwOPMPKG1lS+aNfn36oXCZcreQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5660
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 09:30:50AM -0700, Tony Nguyen wrote:
> 
> 
> On 9/15/2022 5:40 AM, Fabio M. De Francesco wrote:
> > Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
> > there is no need to call kmap() on them.
> > 
> > Therefore, don't call kmap() on rx_buffer->page() and instead use a
> > plain page_address() to get the kernel address.
> > 
> > Suggested-by: Ira Weiny <ira.weiny@intel.com>
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Tested-by: Gurucharan <gurucharanx.g@intel.com>
> > Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> > ---
> > 
> > I send again this patch because it was submitted more than two months ago,
> > Monday 4th July 2022, but for one or more (good?) reasons it has not yet
> > reached Linus' tree. In the meantime I am also forwarding two "Reviewed-by"
> > and one "Tested-by" tags (thanks a lot to Ira, Alexander, Gurucharan).
> > Obviously I have not made any changes to the code.
> 
> Hi Fabio,
> 
> This is accepted into net-next already[1] and will land in the next kernel.

Thanks, sorry just saw this after sending my last.  :-/  :-D

Ira

> 
> Thanks,
> Tony
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=03f51719df032637250af828f9a1ffcc5695982d
