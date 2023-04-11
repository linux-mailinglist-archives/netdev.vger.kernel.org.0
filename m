Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F60A6DE7EC
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDKXTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKXTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:19:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D3F2D63;
        Tue, 11 Apr 2023 16:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681255151; x=1712791151;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O9PiwNzqfgZs+RqfEAOFjuEzgMnmdHcY1NRGlFyMCpM=;
  b=kIk6f4yAIa6Eqvmj5A29EvMbgAW8mWUBhpPyXLaHA5zMm9VriVKchkaS
   6yVC8DelfTghW3sg/C1XEImyM+Jmjl3UylEuDa3HuDkPrcd0v72URP1bg
   PTsh0v1eFbF66XtE+lYXvjRe7ewQvES7wMNlrqQUqn0W5iIsEh1iTlQ/J
   yeEqt3iklNkbCosDZjbdo9Vm8ChvLrmf0C7qb7WLvOPGbKG9kZTtFJ0R2
   H6QNk0L5av3cULhIDUUYFBnqGWuCmTKah0jz1BLG+AZsOr4uFBcDn7LCq
   dshdhjlRpRsoCabeXVPPPiI2YcUxwOGIDP6F1r2QcJXVo9OFS1kJLrtK8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346430942"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="346430942"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:19:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="691338907"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="691338907"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 11 Apr 2023 16:19:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:19:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:19:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:19:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:19:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwzQIGtP/ARVMiUKw5vzeKv8hIVHw1NOfIX+HfZAQoPVHBEyv+f5ISBFfDLDDS1/bJNASxES5FjmlL5XOStV5xr3+gAAXaqvNwh3VnfANDn5Ohs4lkHPna8TpdNMvAcT1v8UN2JFuR/JEJ2k9uyXbw2ZRBA7U3nI7iIv4S48kau5m9vhdZuqBmEk9VgVUF2zGRVM/5oGwbu2sXjitWQecDCs4dfc7L8G5clyeK9zFz3sfbw6QYEwQ/UNjvVRjG9qSHxo5eWV0u/l0cRZnNaxFzC19aUh619NI6kRRgCVcCkJ+/GL6c+Sf5sgPtzZXBNINq/yNZPdHLWdF21cUNKW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fecLEIfB2aIxRoFltavdYZ0Gr8Weshgm/a7mLy2xHw=;
 b=LLIuAuZeZJ9wdHEaWo9DwbFd98d+X9LTN9dSXXKDT6YSgLm9v8aka+EhNMzXpKrMtrWilferIZEVWsONUmKIIeA1DMP1AGmXPp8LFfhUyX/0GQdk5fkxyUfJe/NNY+a3A0hA7/eKOOOqJo18tCWLAI3CcHe8htYj2w5pZ74vLdcOEF1s9E+ExH+h1bwYmEoDQpa26dmkSX1IxIwe27mecFgRevfM9JVIWTKPi5pGifiZyWIf9UfGKlfnurXD5Vli+uMxqAFsDa4054R0+N2DojQPaJCYG+rYv5DFwWvge7h70KduW5vebF2AJ4o2o0TDMc9kIJHvX+2ibnq3wn4kMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Tue, 11 Apr
 2023 23:19:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:19:08 +0000
Message-ID: <ffc5b2ad-20ba-f6db-610f-f02d788eee0f@intel.com>
Date:   Tue, 11 Apr 2023 16:19:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH mlx5-next 4/4] RDMA/mlx5: Allow relaxed ordering read in
 VFs and VMs
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Meir Lichtinger <meirl@mellanox.com>,
        "Michael Guralnik" <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <e7048640d66c341a8fa0465e099926e7989184bc.1681131553.git.leon@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <e7048640d66c341a8fa0465e099926e7989184bc.1681131553.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 412e5789-a51a-43dd-1184-08db3ae32655
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5U2uw3P6Clt7g44ivBGP+V/8om+BVIydhsedB0C8tUYbqcUqzN4QtVyP+6GU58q85QNtvI/LjtoyvSmc4kyVjgRoS47kdyFdJJEOL+JhSyLdlUktapuaaH/2Ye6/gX9fpp2ljYjgZj5+4rmqauiTcB/t3hlWZJV+M3eWK+w2iibcHxh6DtdQVwsRERX9bLslyNx54ax1gslTpNyHVRzZ5HFEpZb77qXjflukKBMUSn14XBfxDu81UpuOePstLyhyNwYIiOG6yZbbw8XuQ8/GzBc1WCBMXBmXKwLGwDqUZbjD5rf82z9avy+q2jKQXfFi483Wb5GH9AITnQdlwJpb4XQpEcTbka986FBvhseQVOy3uAd56SYnbUjXxXIl/gSuNdWTJlfnVMQR31DFkzIH6pBBIDWyhRlzWP/BO4OQHBqc+82t70quveiSgq8pKOHsyMVNn5zyqbtolYDqOsyl5/aTxKkzycYJqSQZW+HA7gz7kbfJnAvuAEyQjIZUT1EwWCWryZvXJz3tBKb2isx2u0d2MiemTBdtQX9l3mfOBErhKrNB/q3GpmgxE/MNjZeNRe+6dAnn25SeJY2YwenOjeLxrpV7vp2eXQmsnBVgjGZ4WX8eEtbX9tauEm/4ORZEuzPHKBawgLUvq67nxIVUnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(478600001)(6486002)(6666004)(2616005)(6506007)(26005)(53546011)(8676002)(6512007)(2906002)(110136005)(54906003)(186003)(66946007)(66556008)(66476007)(41300700001)(4326008)(5660300002)(7416002)(8936002)(82960400001)(83380400001)(36756003)(31696002)(86362001)(38100700002)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S09SS3FlRmZMMllkQmlmbDlGZnptNkJUR0kzVVlGWU1FSVJjeFE0UEpOKzMy?=
 =?utf-8?B?cU15T1h5dS9aU0t5ZmR3aU1sdFRnSWN2MmJsSVhTYUFPNm1BYmRrc0J6MXZv?=
 =?utf-8?B?T1RQOWpHWHhFOTZBb1VsaTU4dnVOY20zZHFxdWRkek9tM29mWGRHZUgrTWNm?=
 =?utf-8?B?L1Jqc3drRjMyOHh3WGVrcjN3ZlRoQ1BHeDl2ZEF3UjFuaE1yZ3pGcmRGZzdR?=
 =?utf-8?B?V1ZjdERBb3NpdUdkaEU0aWxRVVZLbXdBNm50cHg4TnAvenFQeGY2MGpzVzc0?=
 =?utf-8?B?RDR2bkJpV3pGdWVWUjNaSVFUM3JYL2lZQ1pSeGFrRnh6bFoyNkdFdUVnaWhQ?=
 =?utf-8?B?TXEyUktYbXpCNndwb0tVTmVGdngrSEdNOUNTQW9SQVFnNlNQT2ZFbGZjbG13?=
 =?utf-8?B?SnFBL3U2MGo5d0dCckRlZFJNWTJxTmxReGVmc0Z1SHlkV0FpSTNVNFlwdWxF?=
 =?utf-8?B?M21kVEVPZXB2VG1ZdzF1MyszOStUL09zd0gxMVRBa09BQWVtSnNnSVk4Kzc3?=
 =?utf-8?B?VnFrMklzNlRtOGoyT1Ntck40S3hQNEpQSzVlNXlNNDl1b0Z1YTBUWDlzNlZE?=
 =?utf-8?B?Y1BtK2Y0dmlOZVpXK3pyOGNleFhkOWNHVEQ2Ujk0eU5WN3kydERsczRNT3Fq?=
 =?utf-8?B?dmVSLy9RbG1tbzZBNnlSTjhYblA0S3IxdE5LdTdYRFovaEdCMklUMUd2bTdI?=
 =?utf-8?B?RVA4MGMydFFvTXpiY0lZazlEODM5OFBhbUFZREkxaGZ2cTFxUGxld2ZhYmMx?=
 =?utf-8?B?QUhYSy9tTkVQQnZCWjNKQXI0eGdLKzBsM094bExEd0p1Y0lRQmZRRFZhTXNs?=
 =?utf-8?B?cHA0eW5JempaVFFxYnVOUzM3bG1zVGpYZjA4dWlTZ2dFTXNRaHdxM0ZaSW4r?=
 =?utf-8?B?b0g3V1JTYVczVmJ5RnB1QlBzOTc0cWJkdGd0TU1meGpZS0Z0eTg1bE52WDRm?=
 =?utf-8?B?TlVEbCtmYTJham9aNTEwWUg0aC9jQUxGYWJuckNxUDR1YlY4eFpkaUFMS3BB?=
 =?utf-8?B?VEVGVnJVUDhUK1BTTm5YT1cxNWlaZGFPZmJHb2owbm9uL25jTllsOE4zakdO?=
 =?utf-8?B?Q3dTUitFdFVFcldldGE2VzEwWHArT1NKOEZwTHYrS1FUR2FzS2VXVXZsbnkx?=
 =?utf-8?B?SDZNajdET3pTRS9jaC9PY2dhQjJOSThzUHNBeW5VZ1Jkc0V1K3JzSlVhTm9B?=
 =?utf-8?B?eWIzMW95VnlnVU9uVVNVdzF4WVRIeFZBZVh0d0pwV3V1KysxTGQyT0RuWlZ5?=
 =?utf-8?B?Sk83ak9rd2Y2Q1EvNVdnSnZmeUhtWGFwMlVuS2ZnVUh3WVIrQ3pnbjZtUHN4?=
 =?utf-8?B?Q0JVYVZJL3QrcmhQN1B5V2o2SUdZZ0tyMXhoS1BzN013eGlXSG5SdDRaSHF1?=
 =?utf-8?B?QWwramFLam9NelNjdG5kZGFuTXlqbWk1T2ozVlZzZzdTWWxlTDBNcGlWSGNP?=
 =?utf-8?B?di9KUFQvVER6Y2F0c2RpNE81TVRuUUhhUWI0M2FOS3Q1SUtiUW1OY0cvTUx6?=
 =?utf-8?B?OUpLRWIrcStyTWFHWlhaaHNaOVdaWk1USWxEbWtnTzZXRnRmRnF6RVV0MUJr?=
 =?utf-8?B?RGhSOTdST04rZTRRQVVZUlNwbk1QLytxT0tZazNkWnVJb3FGV0p6bUtReWJG?=
 =?utf-8?B?ek9laTNpZTNBbzJqY0J2OWhueFl3UVhoY2MvMVFETG15ME5KSklUQytxYndE?=
 =?utf-8?B?YXhwQTNBTm80dEd0ak9zUW5oNllYV3FJM2pTMUZUdlJ1MTZHeHZvVnc1MVR0?=
 =?utf-8?B?ZlUwRVFGOHNSSENjZWZOaTI0RjRzSkF2RytRRG5HRVllUm5tZDZuMWtvdFVL?=
 =?utf-8?B?QjM2Mk5VdXZyZUN4Umw0bmlCQm5wRDlkOERQNitndmNaTVdwTHk1YlB5QU1U?=
 =?utf-8?B?b3VaUS9ObjRWc3pNc0tWZ0ZyRzA0Q09UaGJvMUVCbFE3UHl4VDQza3BxQm5F?=
 =?utf-8?B?RmpkUWlhU0EveHkzNm9ZQkxsUGl6N1Brb2hvWHVYaGI3VzE1ME5OUTd1T3Vp?=
 =?utf-8?B?dVhWZnNSRTNubElIdWlySnA5S2gyWk1sYTBuVDkwT1RzZVNTTnJGbjZzTng5?=
 =?utf-8?B?OWx2RDhkcFltYnlnOGM3eGpzdFRxcXFYRkJlQ0FsOTlWZEY0RmNEcFRVQ3Ew?=
 =?utf-8?B?TkxsMzBqcFM5dytWazg2Zlo3S3BCYmkwR0hmOEV6SThLZjkwL1dOK3JsU1k1?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 412e5789-a51a-43dd-1184-08db3ae32655
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:19:08.1916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfU9f4d30/pD+W0MI7xiuXWpLDmMfl7Ew8pQVlH+f1HBndmiSWnIY7c/LK5RkyFpcg7/AMvxrNwQQjU+XX7GRJ7c6VFhhzI4G7VdG7ELUao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 6:07 AM, Leon Romanovsky wrote:
> From: Avihai Horon <avihaih@nvidia.com>
> 
> According to PCIe spec, Enable Relaxed Ordering value in the VF's PCI
> config space is wired to 0 and PF relaxed ordering (RO) setting should
> be applied to the VF. In QEMU (and maybe others), when assigning VFs,
> the RO bit in PCI config space is not emulated properly and is always
> set to 0.
> 
> Therefore, pcie_relaxed_ordering_enabled() always returns 0 for VFs and
> VMs and thus MKeys can't be created with RO read even if the PF supports
> it.
> 
> pcie_relaxed_ordering_enabled() check was added to avoid a syndrome when
> creating a MKey with relaxed ordering (RO) enabled when the driver's
> relaxed_ordering_read_pci_enabled HCA capability is out of sync with FW.
> With the new relaxed_ordering_read capability this can't happen, as it's
> set regardless of RO value in PCI config space and thus can't change
> during runtime.
> 
> Hence, to allow RO read in VFs and VMs, use the new HCA capability
> relaxed_ordering_read without checking pcie_relaxed_ordering_enabled().
> The old capability checks are kept for backward compatibility with older
> FWs.
> 
> Allowing RO in VFs and VMs is valuable since it can greatly improve
> performance on some setups. For example, testing throughput of a VF on
> an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
> improvement.
> 
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Aya Levin <ayal@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
