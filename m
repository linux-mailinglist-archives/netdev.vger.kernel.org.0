Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D336316D4
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKTWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 17:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiKTWY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 17:24:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FC6BE13
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 14:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668983065; x=1700519065;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tj/uhJehhMuon4UV0Pns6Hn1HEE3DAi2uBXlUwhsizE=;
  b=YKnEgJaq2ebHy5y77uP0ew7DY68pbttAPy+nrNWvhUT+lxd9ANCWitze
   T3fPZNJDM206SOb8JtB/QeQatVncMF+DkGNY30EFQj0b3nOwsa+E1Ihwp
   0FvUSJOwRMePLeTf6xaR2HRC2jRjI4A4bcPDJao/DdqOUyr8Hyxw/nhFT
   mwS196oEbuzE9KALFmVgpRAnbs4ZgXjAOPFzUVHi+ML1gC3YD8i27UHxF
   saZLWzji4k42WJvkXZuOJN889Bc5yTUeWpQJXWoIJEHTy71pfOC/CKvkB
   HIPYntBodCnP6KTk72z74eNy4UnmM6zO/ojRoTKG/CMxJ9uMAkSxObCRy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399724725"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399724725"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 14:24:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="709604403"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="709604403"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 20 Nov 2022 14:24:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 14:24:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 14:24:24 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 20 Nov 2022 14:24:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 20 Nov 2022 14:24:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSOv7q3Wk4Z4nEJfkw7RWaxKtrKay4ft8IvgeAOl1ev1+t3zbFFtjkHeJl2fRcP1Sjcvko6cZEsIdwElUvEkm3+kBz69jGvliJ4zQWBezz+SCTAp1eovLb4eFyvc58mM+UK8dkqf7bKfzMyYQ0w1fGXdAo39DK2Trw0dYOBMFH0XoYZ67YjkZk0TwlqeCIXa1eVSsPwTWER8AoZo6orRm9NUZZ6KWge8w5bGrPiekMynBXM13i1JFeUr82i815a28GTnUUggjgo4gIRk95R+Ehy8ga9tkbGSGwgWTnmSSX7yoGHpIaOs8wLizbLZ9aTegn3cTp7dxPYhSbQ9k0JZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tj/uhJehhMuon4UV0Pns6Hn1HEE3DAi2uBXlUwhsizE=;
 b=I4R0UquHH/ovYSjCZB1ueUTU7GDCGXdFt8tl6VVoRLy/tC+ctjJyixRpH8CJfo/6H90ZfL4Cq/BVOgwevXw9XFpFGWxXkodmZYvx4ZTc6brGxSo4u4PPwyC1dYmvQQ1sZRiN2oVZ/p0xH8KrOGC2BPUQ8iQ2NUq6kid08YH/O1MTdpc34AeXSQwNSTJKmBYYBYLehT3yzopsA0SgIcvvYD4uXgmllnQ39VGMtCosynbndUwmu1F7WHk8Pk0WDwMnG9Ckv8pEoehcCUm/YFMd7hmJiB/JkK91ULw1xNCh/NwFSfPmx4lbhhZ44XGtE552vWTfaefZnslEe1oGN5Matg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SJ0PR11MB5040.namprd11.prod.outlook.com (2603:10b6:a03:2d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Sun, 20 Nov
 2022 22:24:22 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e%9]) with mapi id 15.20.5834.015; Sun, 20 Nov 2022
 22:24:22 +0000
Message-ID: <d136e9e4-8962-a399-a1e6-dde4ad28fbed@intel.com>
Date:   Sun, 20 Nov 2022 16:24:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <Y3R9iAMtkk8zGyaC@unreal> <Y3TR1At4In5Q98OG@localhost.localdomain>
 <Y3UlD499Yxj77vh3@unreal> <Y3YWkT/lMmYU5T+3@localhost.localdomain>
 <Y3Ye4kwmtPrl33VW@unreal> <Y3Y5phsWzatdnwok@localhost.localdomain>
 <Y3ZxqAq3bR7jYc3H@unreal> <20221117193618.2cd47268@kernel.org>
 <Y3ckRWtAtZU1BdXm@unreal>
 <MWHPR11MB002998FAA385731E21E20868E9099@MWHPR11MB0029.namprd11.prod.outlook.com>
 <Y3fBYXclZbNsiE1J@unreal>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <Y3fBYXclZbNsiE1J@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:254::22) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SJ0PR11MB5040:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a8eec34-fec5-448a-1865-08dacb45f95b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OL3UGciu+E3DioylA/mTj2F/zMJW4P50uzCH7iA3abWgXYTWaPbAzrINgdfk2xwcq9j5Bda0DD3gwbW0vTsjgfdIldfbV+bPTyzdNJ8V8CGGfbvREQbkOdVOaH0CrrGR/DITvDmrprb25RPDlAse2ke8/hs+jdx4lQdQ19m0JaNkIKHhkvzBHaOVPyOR9cKnsh6vThtsbdaEguneiheTGjR9D6+RNC36eYbCL95AtAXhenPb32SKUtUhnnpH/avOGPckPIyu++UVXnYUdOl8CmHx+naY/kyIA//ZIJUhq9fX2q4dcwoxdukG34ZYb8y0qZ5gkTt7DerURajF2Igq+f974tpq9g3973rcVEb2hUVqU+OhqS+Tg/keZh4QYoXZ03MA4XOWFmGFTP+cdgkyHfUjmTCTuQU89I/SLnAhzL3PkzNMLnEDYnyidNDvnvlL2gtv1g+4K6Q0HeyTHnclVqPa1czZHrgNtG3HD6YCn+FAcdQPO6F+QnUKCuFdRSFavR1D8x7o3ZpiBrIgZeTiz9xquJn/TQS1SCa0zXdXr9xo+XlOMYGddnFugl0dwlulWoWyBFg3Fl2BZ+hmOI7iIwJqkdyxVJnE8fSPR/21M9SA+CzotlSLu699EoB1m/PUWNZVIoBNBIHWkp3jVrcUoTvybB08kMpEDz2jAputG6Pik86301+8NOewuxX4hXJ4595dezFM6aULE3Zqd98QRWeJZyJKMSh/+l+AxdJYCds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36756003)(31686004)(86362001)(31696002)(5660300002)(7416002)(2906002)(26005)(53546011)(2616005)(186003)(6512007)(82960400001)(38100700002)(83380400001)(54906003)(6486002)(41300700001)(8936002)(66946007)(110136005)(66476007)(66556008)(316002)(478600001)(8676002)(6666004)(4326008)(6636002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmY5YVppNVdpaWloTTBhS3VVaTl5SllSN2Nvc29teWNhYk53L2x3Uk5LVDZO?=
 =?utf-8?B?dUw4RWtpV2pzMTNqamo4aCtjV0N2d0VUN2J4eTZsY3g0dzNaSkt2RVFXajRx?=
 =?utf-8?B?NUF4YW91WkQ4SDdFSStwS0RyZFArYU50eThRSG9ES1RzaE9qQ2hEK2RkT3BC?=
 =?utf-8?B?WXRNTzdUTmZmNE1WTzJpeDFOa1ZqOS9vOTJ4bDl5aVFVaWNZR081S3dTWDdy?=
 =?utf-8?B?V1paS2RPRnBIeEVMTzBBOUpaN255dzNXYWlGTm1PTHYxTVpTNERQSWlGV2tM?=
 =?utf-8?B?UDlFbE5LUlZSR2NrUHVtS2ZBdkxZS01INGZQUmxselV6d1BlZlBacU1sYkdQ?=
 =?utf-8?B?Zy9yTmdnU3B1cVl6N0dTVUN6ZWFvaTNoVG9KQzdwV2F2TDRxdmhkWEgyTFVB?=
 =?utf-8?B?eTJHTnhCYzl3N1VCd1ZFazdMaWVIM0hRR2U2bUNIK2hFcnVUblpicllXM0JF?=
 =?utf-8?B?dnN5bTVFZXI1SHdsS0pqSVF0bStaOC9ySk52SC9tSGltdDh5NndqWUQvWHVS?=
 =?utf-8?B?ZHlrWUZnbHFxZnNrNGJBeDM5QWl6S295U3ZFMjRsT0kydUlDV1J0V1JzVVhZ?=
 =?utf-8?B?T3BveDlvaURIbDNjNm04ck1nNG5OTWlzUm41YUlnRE13ZGZUZHVjQTdJeVlT?=
 =?utf-8?B?bGZIb2R4VC9TYVN2R2RQemxINmFJZm1NZmU2VmUxUk9HNnZtL1NIaGJlZmRx?=
 =?utf-8?B?cTQ2a1FHamQ3OE95ZEJzUFA2NXgxNGxhYVhiQ01wbDNpNjdvR0k2bzhXcUpu?=
 =?utf-8?B?R0F6RGo1Mkk3K0tYNnhPU0xvK3dCeEk4NGZtTXBCQjRlN1pnRXZ2UFVQcXQ4?=
 =?utf-8?B?dWhMRmdjTm5FZERGY2l0U3RJa09yMGtGREFFTHZVdE9vNzNTMUNRakt5Q010?=
 =?utf-8?B?aW5ud2t6dHhrakw2WEN4dGZ6WWhJNWhSTklObWxYQkZjcEs5ZnBEa216ZWVJ?=
 =?utf-8?B?VmpHUkpRcEZ3cTgrZU93N0tRalBpSTlib1JaclduTjFhWDhLZmxxTTA1SGJ6?=
 =?utf-8?B?MXdYeVFTWWJ2WGlRalZ6OUZNMFhqOEFjLzdnRHRBZ0IrRUNnRXN2NlBmT1Jz?=
 =?utf-8?B?Y2Y1UWw5Z1krV0o4cmJyVnZObGdEZ2oxbHIrWkUzTm13a1E4T0JYOEZCRTZE?=
 =?utf-8?B?aW50VGZTUVdacWNGaC9QZ3NvN2VubDEya041T1JsU2dmTHVkNy8xT2Y0cG90?=
 =?utf-8?B?dHc3aWV6d25DUXVxUXRZUDNRWkJseGMvNTdjdjRscWY5b0VTTFBYN2NiZFlv?=
 =?utf-8?B?N3BIWVl3VFhETGJhczR0b0crMmJhRVgzOGFwVUNXZFBJcUhQRCtPcFFqZUFT?=
 =?utf-8?B?a1VvN3pMQmZ4Z3lWYXBGSUhET0N1Ny9Rd08xQ3Zxclp0NmszZVlTSmZQbWJC?=
 =?utf-8?B?N1F5c05rNHFzejV2S1pWVHk5SlBnM2hzRThtRDVmV20vZ1dhRlhIRkV1Y1lB?=
 =?utf-8?B?NzZRQ0JZUUdTbDEwSzRmWnhSVFNmRUxzUytkYTFQYjhsSjFXM3pDOUR2MkFU?=
 =?utf-8?B?ZEZpSEE0THpZVTltOUQxQmpPYXkwbm5wRkl5VUs5aTJHVmZTQ2FGa0Zzbi8z?=
 =?utf-8?B?Y3haNlcwWnRFMWNnZVh1a3BKdXVaRG95cUF5bEowRUtzZkF6b0VCNWVXRisr?=
 =?utf-8?B?WllYbGlpN0k3bUZkNHMwa0s4TTFUcTBDZGh6T0VydE0yUU83S3djOUV1UWlO?=
 =?utf-8?B?dDFsczM2bnJSdm9YblBxVGI5SEtQSElkc2pxS3M2VndZQjNDUWpOU2VSakN0?=
 =?utf-8?B?cFRrbEI0UXhndzdQUlVqWC9ZTXdDa2J1ZjJ0SkJpZ0FSeXgzNkcyUkw4OFVV?=
 =?utf-8?B?YlY2Rk8xNjRZdkowWlp6am4yWWtndUtJZVhqV1drdmZKL1lCRkNxM3paYVdt?=
 =?utf-8?B?TmZtQVkwdTh4RjRXcVpteHZYWXFlKzArNVROa3QxdUVNQ0NLam1qS0tGa29N?=
 =?utf-8?B?cVA1QVMza0J4SVAzQUEzZVpyNkY0TFVRejBSSGpKb212cURSUnNZOU82K0pS?=
 =?utf-8?B?WW5zcVhiSDZUTUhLWmlvaThKUFpFcmFVWUp4MzlSUTBkUDdxazg5VFFNSXZD?=
 =?utf-8?B?NFJFYWZkMkRTYXhMMTBySFR6Wm1ZMEVrd1VHRUhXaWhOandZUmtibWhsMm8v?=
 =?utf-8?B?Mlg3bTNxRmZSWVJXOXk1NHJLOEZDc09xYmFGSjBHWDc4amZMVzhqL1lOcktG?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8eec34-fec5-448a-1865-08dacb45f95b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 22:24:22.5056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99ti94ZQZJ/GDF1nk/4y1k0w2zTj2sX9Lqqr14evKHRY5w0ZxeC10qnrFXv8zMXitdEi01K/3bkeBkVuA/L+MmNNF0jJcJNjxAilWzI/qVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5040
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2022 11:31 AM, Leon Romanovsky wrote:
> On Fri, Nov 18, 2022 at 02:23:50PM +0000, Saleem, Shiraz wrote:
>>> Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
>>>
>>> On Thu, Nov 17, 2022 at 07:36:18PM -0800, Jakub Kicinski wrote:
>>>> On Thu, 17 Nov 2022 19:38:48 +0200 Leon Romanovsky wrote:
>>>>> I don't think that management of PCI specific parameters in devlink
>>>>> is right idea. PCI has his own subsystem with rules and assumptions,
>>>>> netdev shouldn't mangle them.
>>>> Not netdev, devlink, which covers netdev, RDMA and others.
>>> devlink is located in net/*, it is netdev.
>>> Regarding RDMA, it is not fully accurate. We use devlink to convey information to
>>> FW through pci device located in netdev. Some of such parameters are RDMA
>>> related. However, we don't configure RDMA properties through devlink, there is a
>>> special tool for that (rdmatool).
>> rdmatool though is usable only once the rdma driver probe() completes and the ib_device is registered.
>> And cannot be used for any configurations at driver init time.
> Like I said, we use devlink to configure FW and "core" device to which
> ib_device is connected. We don't configure RDMA specific properties, but
> only device specific ones.

I don't think this patch series is configuring any PCI specific parameters OR per-PCI device parameters.
The FW splits the device level MSI-X vectors across its PFs(1 per port).
Each PF manages its own MSI-X vectors and distributes them across the different functions associated with that PF.
So far the PF driver has been doing this with a hard-coded policy implemented within the driver.

We are exposing that policy via devlink and allowing a host admin to split the MSI-X vectors that are
assigned to a PF by the FW across its different functions (PF, all its VFs, all its SFs and RDMA) based
on the use cases/workload running on the host.




