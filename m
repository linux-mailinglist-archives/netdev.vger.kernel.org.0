Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684BC660674
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbjAFShy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbjAFShR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:37:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B77DE0B;
        Fri,  6 Jan 2023 10:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673030235; x=1704566235;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mqi3JYcGTGfHBdD1nOAvyKPRBv6S++/glnJfGzeV2dA=;
  b=VCfsdYLJj8qIft4sQgHdWN/9VVNa0hpdp7dopWoVHUlR1obIqxMQP+cP
   ahuoqUX/du+lIqpfFeGiODVvmx0LIV077OLHIXj0m5xl2d9JJ5iZUUmUc
   GMd5nW8ro/j++x8+zX6GJ+jSPRnVwsFXidFBuPUMuua7QmeJ5YlxdJpar
   /sV0TQ0pz0uC5tAbISRmYdlT2aTuA1zR2qpmxBXVqDIARX7g2qkgypYbe
   mmD0WrB2V7EagkyGLOf7jrIjC0oy24AwSYgr4Gk8Ad1z60r9WFKVUIwGI
   ncJWm4dPOR8L7jq5HkUedDIUVZTJFO3oa9tnEcqamYAsw2BosEGE/533H
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="384835735"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="384835735"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="829990240"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="829990240"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 06 Jan 2023 10:37:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:37:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:37:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 10:37:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 10:37:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRcQi9DmNDWJtMC4fRQdyVF0sS0mxQBidBsAPwZrtVf0Dr71+ETquPUoRAnMkrq+WMZMafYfqtRH3huZeNbgcfa6aQw7TaqNTGbPU/axRCW21PtAH1fBYgqu1cLhYhBZp/onE2QimBd2t9+0JnOZ9ncBlzOS2+R3VMZA/cVaQeAPu2mNTIT1sh2GGc8Sld+N7rslfJKEvS239ZDkdHs5+cDhM6nRnKvJ9kWGcLyfRBLVNAqMUtY5Gvr4A6xxB6kT4mBYA9G5YMsVAuQHeKqm4O8tuw948a3NqEJOIvfGK9ShgL1ci1pQPqBLw9CVK4UgdFX53Hd4ED/Uh2oGTTErlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1mrPtlfkCSokmnY5bceck0nhONwOAgeMUIKckCvMew=;
 b=KFyic5SXPXSEc8Qk4VctfjjHJjaI42RsefYq75OL2mzzz4pe/5a5sH/mPaufpgXSONxLlkDgORiJ/ZPZX7fBLMo0OW8V4JZCp7F4gmL/Ju3K44w+iFjpRs5Imr2NjrhIY1gnr0dVxS1CDv1MrzFgFhp7ufW8Rl04XWdv6nhetXurhQTGzqR+kIIovRSXxyO3AIiKciqM6ZkjimaBAYSTo0/FOJerekv3JRPsVpJ3SxxhVBP/99rkz3UjpgV/LZJjsKap36TlRxWDDsH2zarmGRvMh6Xn4g3/eknvEjTJXqBAD//JhslNmyMlvE2G1C264ZAvUqskrvuqpYflROIlCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:37:04 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 18:37:04 +0000
Message-ID: <270ae807-6842-b5c9-0b14-fbc1b768fa79@intel.com>
Date:   Fri, 6 Jan 2023 10:37:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 5/5] net: wwan: t7xx: Devlink documentation
Content-Language: en-US
To:     <m.chetan.kumar@linux.intel.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <ilpo.jarvinen@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <linuxwwan@intel.com>,
        <linuxwwan_5g@intel.com>, <chandrashekar.devegowda@intel.com>,
        <matthias.bgg@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <jiri@nvidia.com>, <corbet@lwn.net>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::31) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SJ2PR11MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e64101f-1949-4cae-9cd3-08daf01501d5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R4ZBkRi5aC5ITWjz+9wtMb8DXyYipHyonj9kNYoH1N4d4XpdxvudPBveoMsvVCa1orOH9Bz6dEBau7dX/B6bIDMAmLC6jKNSZKWGAKgMdBTfdC3/SIACM8JtPwHQCPYfKfYqQ9tejXlKUk9gDjD+CdtUeoXe4vckSpTDvK1FWKuOG04YW5reiHeUcqxRPvSqEDv2pnlCZDfM5iIm2ekDy7NqvxVahWtwVge2fJCuDm8DzJ58qtCcL5y0gtj11gjfl/0zAUmAApLkPP0o05CdDH32uKMXvP7ZKkQTYeNW8MJKzMDzWR681qLywvixwvsX/kDZsk9k77g3vsTTDb+ErASmkTdybaFT/VxfJ+LmFGqMk/fvnI1pdmqOTmnNxkN9Wy8BnYZa8+JeleRsDoVDC6eP9CrLTzw+VpUa3W0Ui414B1Zp4Zmxy/wU5shEA/86t4QJScwjToC0KaZtxe8+/RJ+LQgfMeFm0VYQ6nHqktoLbMS7gFQ7v7vyG2f09on/N0KzS4t6lDhNzA1b6iP4BMbWaOYH5z/kxBtyAXxMnQVWqEQLLfbeEI48dbVSwkPrzR8Y1lTykabJytBIQXz/uZ/+YGpTAvJVUClsZcNt9YGnxeAtWSBzVNvrFAA7qvzLrI3XqXVMHtVyATB88KyWZLRJ7HZIV7fL7pNJW4gwtcumTFGCjj5v1rpIS2APOu8T3GH9VYqn7bSovTC3tdZkS1nHD8Z6mgWWuFHmf8rpOf9yrosmwjprpYSFJ1D0lsTe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(82960400001)(8676002)(31696002)(41300700001)(66556008)(4326008)(66946007)(38100700002)(66476007)(316002)(6506007)(2616005)(7416002)(2906002)(8936002)(44832011)(83380400001)(5660300002)(6486002)(6512007)(6666004)(53546011)(186003)(26005)(86362001)(478600001)(31686004)(36756003)(45980500001)(43740500002)(473944003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWdmTmJlem5Md2czTCs0eE05WWNjWEtDZ2NpS0FkV0laYmNqT29lQmpJdDU0?=
 =?utf-8?B?bEtIVUpueXNSOXc1RldWTkM3Q2g3WTZQVUUyQnhjL1lJRlZDbnFYcXlqOFJX?=
 =?utf-8?B?STBxbnNuak9nRmxkbmw4ODhDd3cyN083aXlsQUg2MFFXL0YycVZZV3Rnc3Vl?=
 =?utf-8?B?Wm1YMXJya1FHN1pqMmFrbnQxTXdWTmpNU0dhdE9COVlCYmw0dzNaMXg5SEcz?=
 =?utf-8?B?UkdnODN0RzlxaWpaQ3NLTnNZK3NCM040WDh2c1dwN1VLdnU4V0F1SFp5dzZw?=
 =?utf-8?B?VmgvNXp5Ujd5ZnpOci9uYlVJT0FqZzV4QXhDRkMwT0w4d2dVTmplWC9lbjhT?=
 =?utf-8?B?QUpPM2RTanIzOTJ1WlpxWHVKT29KaVNnYjdLVEFHdkhOTHFwWjVwelJLMVFV?=
 =?utf-8?B?R1N2RUtVblJaejRjcjJIU08rdkNtaGYwbzVyTnRhUy85SFRwWmhSZklTWkJh?=
 =?utf-8?B?SDRPbVFKL2VHcE11OU5WV09RMUNtRUFTZTBGcElMQXpKeUUxejlZYVlyNDRP?=
 =?utf-8?B?U1QweXkzK2VUL0thRENSMHVUQmN4K1pXOFR5Ni9DUDNaUnFiTTExTUs3QjYv?=
 =?utf-8?B?QmcxYmJSY1QrdDQyUlM3aldZOU5NbHE2WEFWREcwRnU2cjVpWVJaYTNtOFQv?=
 =?utf-8?B?NDlLdFF1WG5MZk9yNmN6VlVLdkhOekpuR3NLYXpqaDNqRDFnR3pjZXNrZGRx?=
 =?utf-8?B?R1I1MjZFOHVnSk5peTNjL09oQjdoU0JRd3FNMXg5QnpEQ2hYL21sSVA3c05U?=
 =?utf-8?B?UUxUcy9OVndjakUrR2RyOHQvNHRyL2JTZmlmQTBhcDdLbHlEOURkYjNPeGpo?=
 =?utf-8?B?blpOOU9EWUNEUnNZSHEyM3JVWFhuQ3haaXljMjZaYjJES3YxR0JLanBXTmQw?=
 =?utf-8?B?Z2xFOWJJZFhQZW9jZTFraktWY2xyT0s4Nk91WFBGNDBRTW4rWmV1QmROL2R0?=
 =?utf-8?B?RGx1WitCOXdsSDh3eVhMVDZWNjhSUWpHY0g2bytmOUNLSm85dmZ5UWJtb0U1?=
 =?utf-8?B?WHhjeEdqMzhKbU1ycTFxVDdrc2lTK291K3B2V0MxVXQ2VFMwdndrSDJUNzRZ?=
 =?utf-8?B?VkV0SnNVUWZMb3pzanJHWVJPdTJTRlN2eHJoUURqZUtWVnZQMjBDc2pmdGxY?=
 =?utf-8?B?aEhsdkg0T1FCUFl2a3Blc0dlQnRtZ3pDa2hXZ09BVjNZM3o5TkNpT1NybUNj?=
 =?utf-8?B?dHpFOGhvWUNFY3hKY05QejB0Z29VREsxemlnT0ZtU2l2VXpWNFQ1c21xMWE5?=
 =?utf-8?B?K1M3UUk5ekUyZ0FjYlRtUi9ybThnZE43cWU5ZmNndGsvTG9jTEw3ODl4ZzE0?=
 =?utf-8?B?TEZJMGo0aUFNaGxKTTJzR0oxSnIvV1dtTXBQWFJ2RThPK3ZWUGV3SG9EdFZN?=
 =?utf-8?B?VTNzVzBob0gzQmJWN2hoRGI3RTdTb0NlaVRQTmN2NXpwSTFTdkxpOVF4dUZx?=
 =?utf-8?B?U2lPcmFscDJFK0dyTXRCTE1TcGFpRkNGY0RGRmFsWUppczFHNW1ua0dheHhu?=
 =?utf-8?B?ZlQ0Q2RndFlSMGdmc1pYTmJ1dXJqMUNMWG5pT2xPazhiTHhlbVRJQmtvRzhF?=
 =?utf-8?B?Zy9IZ2lQTnJQUE9yOUVQQ1hFZE5PN2dndlNER0VYRGFVSXVsb2tmMEFZa1ZK?=
 =?utf-8?B?QUpWKzJ2SitPRDY3R1hJYzRlVm1FSCtQMW9HS0JnQXprZ3VrMTV4VzliRC9w?=
 =?utf-8?B?cXQvRDlwYk9sLytMSFJ5ZDdiNkZOTG9QZGhmUFlDd0ZUVGIrNG9KYmVIM1VZ?=
 =?utf-8?B?YStyN1dOTlRKa2NJUysvdUlUeEpEaElhekh0RGp6Q2RoenUxUzJZQ3YyRStv?=
 =?utf-8?B?dS84Sm5yVFMwZm1iMmxWVW8yc01EcnhXaSs4VElUTjJGaDlnYTZ3WjVNaXZQ?=
 =?utf-8?B?UG5PekZRS0lBdHB2eWZ2cEQvMWVxMmFlSE13WTM5NlZTRW5sK1BBdHpGY2Ro?=
 =?utf-8?B?Smh6ZVA4UWl6K3JQWXV3RDlqV0JhL1pySW4yekpDenBmdmJySzkvaHNkbnM2?=
 =?utf-8?B?dlUxV1ZoeXVpQ1VRMHdSTUdSWVdNdjV4Z2E3b242NEJNQTVhcWthRzFZYTB0?=
 =?utf-8?B?MnBMd0N3V3hhbHBLZUF2SW1KdTVtQS94eDFVc1ZqZlRlY2ZGdW1UZ200V2JQ?=
 =?utf-8?B?UVlpTDZvQklkbDA1UUQ2US9EaGRFVGIxMjNOQUlKa2NxTWo3T3JBc2dEc2Jl?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e64101f-1949-4cae-9cd3-08daf01501d5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:37:04.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+9ncE/VKfGCzsBOUQrzggpAkYHqd92pRezoHOMXol9LZIqEwFGW+9AgkIcwZk7rrIAcE2ZW8VccTPbo6KKpUANs2Y+Z095XL57gyYhcncM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 8:28 AM, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Document the t7xx devlink commands usage for fw flashing &

it would make the documentation easier and faster to read if you just 
spelled out fw as firmware.

> coredump collection.
> 
> Refer to t7xx.rst file for details.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> --
> v3:
>   * No Change.
> v2:
>   * Documentation correction.
>   * Add param details.
> ---
>   Documentation/networking/devlink/index.rst |   1 +
>   Documentation/networking/devlink/t7xx.rst  | 161 +++++++++++++++++++++
>   2 files changed, 162 insertions(+)
>   create mode 100644 Documentation/networking/devlink/t7xx.rst
> 
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index fee4d3968309..0c4f5961e78f 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -66,3 +66,4 @@ parameters, info versions, and other features it supports.
>      prestera
>      iosm
>      octeontx2
> +   t7xx
> diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
> new file mode 100644
> index 000000000000..de220878ad76
> --- /dev/null
> +++ b/Documentation/networking/devlink/t7xx.rst
> @@ -0,0 +1,161 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================
> +t7xx devlink support
> +====================
> +
> +This document describes the devlink features implemented by the ``t7xx``
> +device driver.
> +
> +Parameters
> +==========
> +The ``t7xx_driver`` driver implements the following driver-specific parameters.
> +
> +.. list-table:: Driver-specific parameters implemented
> +   :widths: 5 5 5 85
> +
> +   * - Name
> +     - Type
> +     - Mode
> +     - Description
> +   * - ``fastboot``
> +     - boolean
> +     - driverinit
> +     - Set this param to enter fastboot mode.
> +
> +Flash Update
> +============
> +
> +The ``t7xx`` driver implements the flash update using the ``devlink-flash``
> +interface.
> +
> +The driver uses DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT to identify the type of
> +firmware image that need to be programmed upon the request by user space application.
> +
> +The supported list of firmware image types is described below.
> +
> +.. list-table:: Firmware Image types
> +    :widths: 15 85
> +
> +    * - Name
> +      - Description
> +    * - ``preloader``
> +      - The first-stage bootloader image
> +    * - ``loader_ext1``
> +      - Preloader extension image
> +    * - ``tee1``
> +      - ARM trusted firmware and TEE (Trusted Execution Environment) image
> +    * - ``lk``
> +      - The second-stage bootloader image
> +    * - ``spmfw``
> +      - MediaTek in-house ASIC for power management image
> +    * - ``sspm_1``
> +      - MediaTek in-house ASIC for power management under secure world image
> +    * - ``mcupm_1``
> +      - MediaTek in-house ASIC for cpu power management image
> +    * - ``dpm_1``
> +      - MediaTek in-house ASIC for dram power management image
> +    * - ``boot``
> +      - The kernel and dtb image
> +    * - ``rootfs``
> +      - Root filesystem image
> +    * - ``md1img``
> +      - Modem image
> +    * - ``md1dsp``
> +      - Modem DSP image
> +    * - ``mcf1``
> +      - Modem OTA image (Modem Configuration Framework) for operators
> +    * - ``mcf2``
> +      - Modem OTA image (Modem Configuration Framework) for OEM vendors
> +    * - ``mcf3``
> +      - Modem OTA image (other usage) for OEM configurations
> +
> +``t7xx`` driver uses fastboot protocol for fw flashing. In the fw flashing

it would make the documentation easier and faster to read if you just 
spelled out fw as firmware.

> +procedure, fastboot command & response are exchanged between driver and wwan
> +device.
> +
> +The wwan device is put into fastboot mode via devlink reload command, by
> +passing "driver_reinit" action.
> +
> +$ devlink dev reload pci/0000:$bdf action driver_reinit
> +
> +Upon completion of fw flashing or coredump collection the wwan device is
> +reset to normal mode using devlink reload command, by passing "fw_activate"
> +action.
> +
> +$ devlink dev reload pci/0000:$bdf action fw_activate
> +
> +Flash Commands:
> +===============
> +
> +$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
> +
> +$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
> +
> +$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
> +
> +$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
> +
> +$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
> +
> +$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
> +
> +$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
> +
> +$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
> +
> +$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
> +
> +$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
> +
> +$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
> +
> +$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
> +
> +$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
> +
> +$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
> +
> +$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
> +
> +Note: Component selects the partition type to be programmed.
> +
> +Regions
> +=======
> +
> +The ``t7xx`` driver supports core dump collection when device encounters
> +an exception. When wwan device encounters an exception, a snapshot of device
> +internal data will be taken by the driver using fastboot commands.
> +
> +Following regions are accessed for device internal data.
> +
> +.. list-table:: Regions implemented
> +    :widths: 15 85
> +
> +    * - Name
> +      - Description
> +    * - ``mr_dump``
> +      - The detailed modem component logs are captured in this region
> +    * - ``lk_dump``
> +      - This region dumps the current snapshot of lk
> +
> +
> +Region commands
> +===============
> +
> +$ devlink region show
> +
> +
> +$ devlink region new mr_dump
> +
> +$ devlink region read mr_dump snapshot 0 address 0 length $len
> +
> +$ devlink region del mr_dump snapshot 0
> +
> +$ devlink region new lk_dump
> +
> +$ devlink region read lk_dump snapshot 0 address 0 length $len
> +
> +$ devlink region del lk_dump snapshot 0
> +
> +Note: $len is actual len to be dumped.

