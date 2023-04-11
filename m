Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC346DE7E8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDKXSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKXSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:18:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870852D63;
        Tue, 11 Apr 2023 16:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681255115; x=1712791115;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9IamRTIeq9HkmpSvxoViCL2LBwnREZtXiHvz6VzONwY=;
  b=MnDpB+3/s21S/LtBBZbhj73calmi2sLEXs+NXXV21ma7VTuQ/y4K7rBP
   mooLnzbOMiwjOFdJArvmLzfncYNFuf0VH0YDNwQ7q2iXCIUssv4Gxls+e
   jLbgKJbpcMW6ZnRTGUKXFInqRHEVG26FUQVbcn5t5iNge6zGFZp/Ckir/
   BpDaWK6qWMKF2XZkqQA5eNGK3SenG4uVkbptDyT70TUGpmqzv8RulxeA5
   mGZF+XStA43oLtoQFX1nXVAOB51TCkbNGLM/oGhu3Uy677Nr+gMkr7pPK
   yVbM53uI4Kbz70nu5Mn9VjSpqBfxyI8Ap3PDLXY9JYxNmhvfIxWuHxcbf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343761648"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343761648"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:18:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753311690"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753311690"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 16:18:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:18:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:18:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:18:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvWuLJ6Xh6k5x6fv6wFQ5NrP6yAI7YSu0n7CJgCxAaiO5f6CkVrxcbRr5BZM9MozZB0t48otI2cJnAHaNL85wlMkBNMGSVqwvEK+17+jul/bjhflNC9p7s+jktCHV/tfJnZmh7jkWpxWC3k0qkKYodhW+DlQkv79NdmRvCdBKwu5Rac76Oq9BUWsJHtDMv3T7Wq5C1rrgzeAo7nYcLopu+prpDA5/eCGq2T4feJboEJ82X1CU1sM/HyUGwhU3B6FvLgc7YIk+vweUG9qqLUDwRND7IjYX5SEqcNnqsMHSW+d4wU5Ma623QCuIK5gEY4eGhe01gDj0tuulRW4Daeg6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8c+sRoPyFkXisP4eAONUWaVuJSnyMZo7nJYEklB9p0M=;
 b=Qbp7M2UNshl+QDnrYR47t/TLNIEvnjjEO7sAa6rm0tRU5iaXH4Teqpz0iN6lXZQdKi9Yv+CWI4LjUCoh2bS51mxqdWufpZPaW0DYK3Dk3N+3YtdHCxjuQVuLoEvvwzJ+jbp8uKR2WfBInZwUGjamOFFbt2m4o0fIrftf3rTYgtAcMXR2T/p0ZJ/D21clsYUKU1DcMEMpjh775vLADoJozov5GZhjT+Y0xCdQqMA+IMpdoEo8anUT5qCD5x9Z29y77oMIu6n/+g0WEwNv7EQqDZFKBBxqx4qz2NZiCsS74ka51oBQAtPYM4y/uliy3DILQJ5KD5qfa5qJUfs6sshRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Tue, 11 Apr 2023 23:18:26 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:18:26 +0000
Message-ID: <55ea51d4-931a-c6a4-8666-8cbf653b4174@intel.com>
Date:   Tue, 11 Apr 2023 16:18:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH mlx5-next 1/4] RDMA/mlx5: Remove
 pcie_relaxed_ordering_enabled() check for RO write
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Avihai Horon <avihaih@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        "Meir Lichtinger" <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <7e8f55e31572c1702d69cae015a395d3a824a38a.1681131553.git.leon@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <7e8f55e31572c1702d69cae015a395d3a824a38a.1681131553.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfbf735-0491-4028-c746-08db3ae30d7e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Br2sBK76wy6uZXwr0tn/xrk+x1a/+DYEMa4newHKQNLkUp/NAjI9cg1P7qXRUEBtehon3GPZJG0Yn3YTPO6MLZEIPrYrYOm80+Ww5DJ2f7xX29K5LzZnjmYkhuS8xlGWZWSCSGTaN9ZsnupCtQI5bn5Bvh3dnJvsr3X9UX6+BFj7rEMYlpD9w8XIC6/wnLyk6AZAgYFLoZh/IMiEa4rSH/hL7diCPwwBH1RNRx1rHknKz65j+Y/ZlU3UNYQAtLIfZFM4J6YxJJt11CjdHDDOXHeu+YKhkGTUngS7S9nqQmSFF5QoQfa8Scui0ZSuyxM9JEchYtsndjO6Zu1va0MgYcRzJ2f2IqM832vy+ewtobuiEfry7IPGZhr11jIDI2/dsNLZXE2tNnKX9moG0v/TUdwaWRfkIy0fVNEgRoGkdcJQ15vec+fe+Caxj4NvY9QjSdG76VNBDqSs+mNUX412AIv9etC/+PKY9c9c3lTVGPqczA3LYxqbEqX01tu2IsUf98rdXKeZ+3xvFLuz6nZtRm5PAmefXIz5GBNCvQUd/U//6wRJhs/zZJN7fVhXjgP/R1gy2EZjKYxN+Howz/ezvWT1l85EVEj78h9UL4pu3PKp7p4/xB170BNv9Vv3CK9zXajDZx0TuKuTD2XwhG4uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(8936002)(2616005)(86362001)(66556008)(66946007)(66476007)(31696002)(4326008)(8676002)(82960400001)(478600001)(38100700002)(6486002)(316002)(54906003)(110136005)(36756003)(41300700001)(83380400001)(186003)(7416002)(31686004)(6512007)(53546011)(6506007)(2906002)(26005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M01vMkFMUmo4U2JiSHowb1hmNHRFOE1BdkE1ZW1tOTdUTHdsTFBiM3lQNXk4?=
 =?utf-8?B?QmRSUlhGcnZQbHF3bWlUdEtSVmtKa0hrZ0NLVXNqMmtGVEJsa1NEc1hwcmZD?=
 =?utf-8?B?c2VQTDJ0NmFZTnQ4WVhyZjhmRkJYcmNiRy90cFFpN0JhbFhGRFl5WEU1dlIv?=
 =?utf-8?B?VXYxUFVmSTFITXZpVVF0VzdSUUJsK25MOE16R3I4OHRWMVJQa3RSaXIyckhC?=
 =?utf-8?B?eW1vVmU1Z0xuSXhHazVackdyUGNicjFaSGpnYzdlWHNnTStjV2d3OUtlL2d5?=
 =?utf-8?B?bE4rKzNGN3NldjFlSmNDRzh6cDZiVzBDN1c5c1VuUnV5cEt2RGRSalhOYWlq?=
 =?utf-8?B?bjF1MnYydjlVRDVmU3Znc0h5OGx4MlIzVzVqR09vV2pKTWFZQWtmZGpZK1ZQ?=
 =?utf-8?B?WjIyRS91VUtoRWc2TWJSeDVqTmF2Q2M4MHgvbFJLbTQ4eHkzS0NZZXhXOEVi?=
 =?utf-8?B?L29wajNlb2dYVy9yWkdSbDN6RmJCVVU0NXlJVUUwNVNRdlRGaHk1blhVYW03?=
 =?utf-8?B?dkF1MzRwbDg1ZWJwWlp2Y0h3RjhLKzNlc2RnMG0ybjl3M096VE8vOWhsZXhU?=
 =?utf-8?B?WVloU2RkUk1wbk1XNklVREQvUUc4MnRta0lMMTdBMjk3YmZqcDg1NEx1M212?=
 =?utf-8?B?UFFoMXF1d3dacHVWL002endYbTVkOWM2VWZCSzFvRGhnRnpyaWNWRldTSnJS?=
 =?utf-8?B?S0RRd3lLeHM3dlpJdi9RaysrQXhIcEozVkwyeDRPZ1A2NWExbDRDVTE5SDhR?=
 =?utf-8?B?ZStNbU9sd1R0VDFZVm9lbDJPMmtaUS9OenMvUy81c2V3aWtHZG5LOFdkUVdH?=
 =?utf-8?B?dzA1TmZGdDAycWlWRG9mT0tBSnBDNExuL0FmeW9jN0VhMEp2M0d2U2I1ek9q?=
 =?utf-8?B?YUM4QTdMNmZOR0NDRURKRUowNG0ybWkzL00xYXlxMWk5eWJKRnlNV3lROUVu?=
 =?utf-8?B?aVFsZEM0d1JpalN6bzdUOCtnbm85MmRMTHhLQWIvSVNLNmx2MUlFeUxBTGlh?=
 =?utf-8?B?Sm14bml6cHMzajdjWHduenpVUmNyR3lxNG9qRndQbzlWN0tKZytseE95WEQ5?=
 =?utf-8?B?MUpJZkNjYXJEUVRFU1JGWFdQU0FKNmRIemVRdnJobjdDNDBLMmVaQWhjSUlO?=
 =?utf-8?B?QUpiVWdRRFkvWktNQlZrUmlKYmpHM3pzenpVWVlUQlJ3a1ovQzg2RnJ2NzBK?=
 =?utf-8?B?eTZZT1RQdE44dVZwcFFKc01ySTdTdUVZYmI1Z055aFRZZjV4a0RpMDlWZS93?=
 =?utf-8?B?VE1DWk94WW9NdE45S25GdHhJU1VyZ1ZFZWtGaTNiTFpzcVFTZVcwOGFKWDFz?=
 =?utf-8?B?bDRCWVA2NHJyMWVkd1hPRnI2YU9BV1JPaGM3VU40NVRHZC81TUl0TE4rU2hk?=
 =?utf-8?B?L1p2TVp6dWtUaDZWNG9BY0dvY3NGNXRmRmlKdmx4U2IrNm9NUUd3Um5TbXZh?=
 =?utf-8?B?NmRLUlovdk5YUUhIS0pBNjRpRVlpMWo5SkJwdk1nc2JNN0w2c1BYd0pGYXhQ?=
 =?utf-8?B?b0syanFPZHZiclRIT1pYekE3cDBYa1ZkaHZDRHJMQ3pMSEl3NXJFdzZRZWdk?=
 =?utf-8?B?RWFxVXZPKzBGbklnMWpPZExXYnBrcWU5OTR0ejlUbnF2b0NtNUFJbU5RblAv?=
 =?utf-8?B?dHE3SUZpanh1bjhaVytmS0VNRXV5OU9VYm56NUVNRHNDcGIrenR1M2JIZGFJ?=
 =?utf-8?B?Q1VrczFGclpKRmFJZTVoejJTRFArMjFORUx6OTF6MDdhMWNlSUthM3hNcDNw?=
 =?utf-8?B?YVF3NUxORXVveVFmRm1XZkZKUFhzOEpGd0xoMG1MeEdJcU5UYmZXUVNNMER0?=
 =?utf-8?B?TGlKa3VQL0hrSWg3ZGJDazdjcFBtSndGUVcveEt1bmdwSG1LOEZmQVVweHJw?=
 =?utf-8?B?SExVd0laUElPRWJQbTJJNzZ6WFhnRE9ROVlGc2Y3aUJuRUQ1QkZuY2ZVSm9H?=
 =?utf-8?B?N3dPUnlxWU5sVDU0MVFCNjN1eEdpK09USHlLcERZeDdFby94RUhUa05Wa0Ex?=
 =?utf-8?B?akxTYlpHcTlUSEJsL05rQ3ZIV20rNWl6L2V0eWtESlNUMkZsdld5Z0c3b3RC?=
 =?utf-8?B?WE8yWjJiSUtDMjljcDB3WmlYdkQzS25hSGNpbncySVpxbzFWOG9WNGdSV0tD?=
 =?utf-8?B?WDNSWFlCYzVTTGNCMG0vbVJCT2dCeWdUN1lFSmdwQmZMenBITGhjTzVRa0Fi?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfbf735-0491-4028-c746-08db3ae30d7e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:18:26.7456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kd3Pf04J9PqbgPaiUmrGXZIFYvYoAAPcWlEvFpFGR/Q0i4LZeZSFA6eIjLvEXxJL+i1M5Nc37jgzK8JoerQ869I9qlLxRT8/2bS75dthKfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
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
> pcie_relaxed_ordering_enabled() check was added to avoid a syndrome when
> creating a MKey with relaxed ordering (RO) enabled when the driver's
> relaxed_ordering_{read,write} HCA capabilities are out of sync with FW.
> 
> While this can happen with relaxed_ordering_read, it can't happen with
> relaxed_ordering_write as it's set if the device supports RO write,
> regardless of RO in PCI config space, and thus can't change during
> runtime.
> 
> Therefore, drop the pcie_relaxed_ordering_enabled() check for
> relaxed_ordering_write while keeping it for relaxed_ordering_read.
> Doing so will also allow the usage of RO write in VFs and VMs (where RO
> in PCI config space is not reported/emulated properly).
> 
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
