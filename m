Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94C5584B44
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiG2FpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiG2FpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:45:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E201D0FE;
        Thu, 28 Jul 2022 22:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659073519; x=1690609519;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cOw/1I8hdpHG5yNduPttkH/vkQCakyoB8DYPrD2av+U=;
  b=hn2JDV22PQ/AcRjAZGTR5x+Y84KtG80WX3JHxXAgciNXACNm1cmDcnvv
   UpRMNZzUS1DhAbbapGSoGSZeBNASzGH8np4y+KuBvQv13hYpiTNZX4+Fy
   wUV/XpKLHeJJdfrTL/GPHoVGGi282ivY+pLhwvPaaMDWZgctcJkpTspwf
   t4yfU8KkuA0oRqi7A+VWvP54dOf+9IHOdhRGx46AE7e5S2C87WlCvZmU6
   94oqlOx+va6u/NWqXCD5OcBl2kM/WnA/w48GvGmaPksAK7UzPcbfTzUC8
   niaT6uZzwHBMKJY7Oulk06+Cps4sgnvr86J/jS+NdWV7vMfxcfR51FAdN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="374999041"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="374999041"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 22:45:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="928619823"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2022 22:45:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 22:45:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 22:45:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 22:45:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=co70ZO4zXnXVzdvavYZgLDZAkfAQjyfyFrBCIubEYKgpZ3L8hKOBglP1RxCN8plbRjdEcRm2l7xm8go8Aiuxa2X4Vjau8TJBy9NBiGZvkjdw76oGWKiipKjVo7qAoY57+4MriXcUPo7X7QrbgOgpogFdTSeHXM4fuRRiAGW4Glnf5wyXHx16+0DBaW6HILAwbdvpC5TyloKDIyJ4d/mzzPGNo84fAlNo7KOaUZ05XmgBm+Gq0N4KXfROGEqE+lNWg4I7m/mLUy2o6Wtv7O3SjMPvhbUy32+MZ8NoXS9+9MpEZC2fni9QmHYBgGjLBLHjl/8FSOmDUypq7Hrerku8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RK67rgnfW/NjKbBGxkEl0czqOBumkTJu7XKaAHNeP9A=;
 b=G7VMORNkaffyHOQUT5r/dcFYFOPxSDX6UCi6z36HIrfcXvX6sS8eeVfpxsTQ8AnqTynMN3NMbvzG5q/VAJ2LyBSrnTxZzbULDEmC2TC1w/hkFDnqZ2RcUvQEoljdP1/wH9QkxXZfWz1fkTTbXdZvuLO22mOa6Zg2c9aterdJu2XdVUDUJzFsyQnKLaSw5YHeJjr9IYBg64WXQbrQg40WJumIJxUl/iPTSMN0R8p6P9CX9juIlzzWYB6xYQPprSjy74cbAlKb2GYI9/meB3iTQpZovf7Amd8f8S0ViXHupfSS0Q8KXfz9BTShTfL3XBNzwY5n9Qv5yIG/P14hYOA2EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Fri, 29 Jul
 2022 05:45:16 +0000
Received: from SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::35b8:ff0a:4f99:419c]) by SJ1PR11MB6297.namprd11.prod.outlook.com
 ([fe80::35b8:ff0a:4f99:419c%6]) with mapi id 15.20.5458.024; Fri, 29 Jul 2022
 05:45:16 +0000
Date:   Fri, 29 Jul 2022 13:45:04 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>
CC:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, <dccp@vger.kernel.org>,
        <lkp@lists.01.org>, "Paolo Abeni" <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>, <yujie.liu@intel.com>,
        <fengwei.yin@intel.com>
Subject: Re: [net] 03d56978dd: BUG:Bad_page_map_in_process
Message-ID: <YuNz4FTXA1MshsjK@xsang-OptiPlex-9020>
References: <20220722195406.1304948-2-joannelkoong@gmail.com>
 <Yt1RXVnI27iLwxr0@xsang-OptiPlex-9020>
 <CAJnrk1aX6x79AzFPVk1QwU4ivd5AeYwz6Fe2z6HLunBSBA20yg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJnrk1aX6x79AzFPVk1QwU4ivd5AeYwz6Fe2z6HLunBSBA20yg@mail.gmail.com>
X-ClientProxiedBy: SGAP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::26)
 To SJ1PR11MB6297.namprd11.prod.outlook.com (2603:10b6:a03:458::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 335a1f25-5f5a-4e91-4fe4-08da71258373
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9S6M/5PlLoHvQfZUvz+68VHcJZv5CYVi9ETExO+ba/V01G22lrhQupFf0FbUZDdIEYoWucCfb8e1+ugXsFeYFbbAav1pPRFGrbkII5/SzjOEaBO7A2URgvKhz6t4OvYZQ4ZR/tCOtYtxRYcNNtqD7txOx56cQIL9Z8p/LF88dSqhZ1oLZVHWUqHoGSORNpTwPDmmZOiRNyK36gmj3hvPo5/TwmiMMu1OYQCq93ViuxojJpJD2WS5iBjhpzjqMDQ3LRaRhtPsVH9GRMFYczkY0DV8P3TUr6zXZe3riGzdpW8UG2A6roqXoEtGgkRMneAAzXIhjRTQAQrpnqfucolVOTVpmBG6ma/263tT4hSr/IgfXnCvY2e3zNEGXapddUWYXfu23RAAfu3xEMgtuNEZ5gdmXe4RjHNMTAdG+hUo0I4rlTEuz7zEaQdfHFoHJ/zkGGLvam4DoSG0ZN4ykzg85KDNmo+oElv+pPDGkYiwFtp2cS10OnzTX77k4Y8N4CUb4PQGJC7LJ7Bs+m8MjuMlz0UFOF+HoNI5UO7YE0mBJdma2e0jc65sytwZ1XvyN/l6yIpyu8jNc/X5bECQh8f07n8KorpEaHR458LDhjBWpzWc6AsCBG2yfBtJ6zNiKsanBDDgy4jww2sNRrpgVZZtGUEy55oBDrNqJzIXlxNSBae1j4T0wg8bbqPEsmYrDy73j6hAMw4UAIxdGAcxGpt2JsGF+iT2JjNvmEI1rVsVwFPYkNrlFX5JGDU5EftlDxPn+hHQgRbcckU3C5lQ5Egdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6297.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(376002)(136003)(396003)(346002)(366004)(4744005)(2906002)(7416002)(5660300002)(8676002)(4326008)(54906003)(8936002)(316002)(6666004)(44832011)(86362001)(6506007)(66946007)(33716001)(966005)(478600001)(66476007)(6486002)(26005)(6916009)(66556008)(41300700001)(107886003)(9686003)(6512007)(186003)(83380400001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SIQ6EgB9+mDsNESOAfFJZQ8s9e6Zcbmv+QF5W1ZiMP1Fik5qNbUVlu0dzGwN?=
 =?us-ascii?Q?uQQUhr24SckJgjZKBI8GblNMfVuAaRmSZ2p0bNUSolHpuz6FTbQSTfEShcc+?=
 =?us-ascii?Q?j9BFDZ5K+EfGBM4YftsWmwUlrO41Wx8n82g+K7q8fiuegRM9df2H/z2TRj1M?=
 =?us-ascii?Q?T1bRPvwBPbZ6BC0szBj51tsKKrzz4gayXTLQOFFb0l8Vqq8VExmz3rXHQQjL?=
 =?us-ascii?Q?ECf1pE6twQDTiWDNWf0dF5KhclgrcFHQiP3yHHfetpqQ2QOJtT0sOPbPdm7f?=
 =?us-ascii?Q?ZfMtlH7Ig8lhm+/zLE5/DdzztTRFVUG5+p04ugeEJOleoczAWLggkEgeijPy?=
 =?us-ascii?Q?isl//NzQViFNRU302LsF91MJyKTE6YMbKydeP9RI3lzMJLpyFb1VsmPzUg/w?=
 =?us-ascii?Q?XBD7Fmw+WIaW3l0Yw0BPqEoqhpzuUZNXOjHIXO+Xf9yv/R9DtGiWbT8FPYLy?=
 =?us-ascii?Q?oJgR6YGUH2cyrbCpTgtQ5h7wqbnGlVmGBKaOLW3uoS3dQLYfaSNCWx10FzgX?=
 =?us-ascii?Q?JlmVUCSk1o6FFQUunpx4h2ievfgwD5WYjFpFj3u7TwkgZ+i/LTe2sUG1Fb9y?=
 =?us-ascii?Q?xMjNgm9ngFStsI9Uu6W/ndMY7EPwG8cRRLy+cuglC4onKE6v7q2ScPNemytD?=
 =?us-ascii?Q?YS1k0kJ32a29zwjsgkSNPlsoSf2JI9Gz6/6TFrOQ5JC0djRctyY7seRh4ld2?=
 =?us-ascii?Q?ZNibUuZQPi880XXvHGFLljkiBMt12k7zGw/4f2go1Nb/Rko0y/Qvldy6F940?=
 =?us-ascii?Q?alXLVyldMsR+ylsbeBeWN0AOsp7gtePrn1FTV7VljnLTh1ntg2ElFE+/UhtU?=
 =?us-ascii?Q?H3ddLopbLqSd0x3bXHRpae7buIkCX8QpkVBrHILUNnIkmHIPn6fuAtnsgvlq?=
 =?us-ascii?Q?yOkcCnqXK89GyyMstDd2WUeLTVKNxBPUNgWOZKRsAaQ0q9Uf+MeVyi1OWxBW?=
 =?us-ascii?Q?qhCf+HZ9Sr3+wvoOSclarWd3on2l1jm4+VA0Amy0JBbXRUmkoD70fuW3IFk9?=
 =?us-ascii?Q?AXbsDcVW6y7xTecb6m8X+RJLm2DUZf+pvnvIQHdKNJixz0pSzyIgzbdgSRV7?=
 =?us-ascii?Q?aDo6SLVd2Lcxxp40av3qV9JtWGioRgfnZCwW31KZuqFn/oqR4Uz3+ehsTh7y?=
 =?us-ascii?Q?qXsUqKk7Mlmq67Y1ZXe7NRZAFwbWP62ImH3hzA+0K1kVom9bI9dLMGvDROuO?=
 =?us-ascii?Q?ggDd9IGCZLMjbmFyjzRnEaHLBvpYHriqQkvYm8Vw9ZzkpyNcdN/jpD1PIJn0?=
 =?us-ascii?Q?eV/jd/ZpMfNxu2oPsaeFW72QnbkC7LFluUp7EwwFWKIpftKlt8VjAmDBZX8R?=
 =?us-ascii?Q?lk3vgLkV1vmwpYNf0/F9zxW3zB/m5EUdAVCvkwoMiKGhJiz/Eg1oGxqRdM9s?=
 =?us-ascii?Q?d9v3wQZ/Gx3QfSdpgUyoMC7dGdiCafmPrfZcG10r09QG1Q5pXamfNtG8ojG3?=
 =?us-ascii?Q?/R4+OgbUiFURw397TgfpEqq5+5cn/pQxcQeEAgp8nko7kUy2Tr9Gl8u3RMHC?=
 =?us-ascii?Q?FAqVT26lCireiKqJzA+PWZR0VXgh9Z2xIndfFrbithC745i4BdxH4Tod3Unv?=
 =?us-ascii?Q?yhqgKqMR+k/imtbGWV48vL37YSGzRNLuZnPFsEJIGaB11K+rX17kF/YvIdc3?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 335a1f25-5f5a-4e91-4fe4-08da71258373
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6297.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 05:45:16.0697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qLvxL/jO1c/XEL3mNlShlnANSHR7mY6imC9NSlmqz1ue8JKE0ybvlfIoT3bUn2gmXQvB2s6mAG/U4eFcU4oMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi, Joanne,
 
On Wed, Jul 27, 2022 at 04:41:04PM -0700, Joanne Koong wrote:
> 
> I examined more closely the changes between v2 and v3 and I don't see
> anything that would lead to this error either (I'm assuming  v2 is
> okay because this report wasn't generated for it). Looking at the
> stack trace too, I'm not seeing anything that sticks out (eg this
> looks like a memory mapping failure and bhash2 didn't modify mapping
> or paging code).
> 
> I don't think this bug report is related to the bhash2 changes. But
> please let me know if you disagree.

thanks for detail information. we are running more tests to confirm now.
will update you later.

> 
> Thanks,
> Joanne
> 
> >
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://01.org/lkp
> >
> >
