Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883B86D10DB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 23:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjC3Vbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 17:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjC3Vbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 17:31:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9880CC17F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680211890; x=1711747890;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WDxIX3K0j+bHrTLCzs0YxGLw1rvzsV7J9VRo6sZb9W4=;
  b=lzTMqle6Sl7X5tc/NLp2MdA7a3JlCHcCHeo7FIcgcV1HRfrpLsNk1Vtn
   eFOyeJaNKeakgHTrY0/1QaRqVOn0Nm0jQNGma+UjfADvMJKIpOuxJhQ7e
   7LncN1ifXH0VGK8iXYEdEqcXCEWK087RTDg/tFDpyCgebnBO7NxEgPMtQ
   z+kKc7tqc5iqbGFeCME8pFe1kQXHYiOU26a4D0GG2EoAJu+l35oKWdn0v
   hcJeboCayzemrok85EZrQtu0FA4l6jSpc8ipurz3TPl605NSgxj1W/ATm
   v7/fu9gZ+uX64pbRXYJMZysRD9qXQkxTyl/oZZsyo1l+Vx7JuwgKenOuq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="338790850"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="338790850"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 14:31:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="715168099"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="715168099"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2023 14:31:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 14:31:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 14:31:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 14:31:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwJcW75d3j6Fq/PqsDhLdJdFJ4OxToOnl4wWvHxdlCm3kdP34J5AzYqNFzgey0XafmDaOLdvjiQSQ7PK+zI158h8jMh1qPdWipZnaLZSQqZN19/dg7W+1KP6V5juWvM92xHS0EGzLoyzyfSv0W81d4Qmz7/MSnScCmUX0+DBqu9qHSnqgf1hFWFNmynNK9ZddeL7+Kz0NWHs9tSTzrvMS00ZdiaV8NC8dkveoee6pq9trR1qKtnFLhmXjtpn2yYPghN67VNtkmU6w33nYlwK/U6H+DWI4yEiF2f6b/bo2ZmngNhRD8Cjl7sVC9KmXkXz6a7Jx+sUW7YsCHqZBhmsTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krCV3SAunqej8b4bP25wLgyWLZ2btiSlfuVQtLxVUDQ=;
 b=KwJIESQJ37DZVrMiFrLbzkMmGNlXp2rHdPBMwJQ68a79GkfQOUrdvV/e3qhvxtwrY22d1192q6p4IQeyEo39yeoy06r6umlUijYScq4JmDaZ64d5NbEd3KvpXkip8U70KoLEmTPE6Xm1jr9x8wax5y/MtjaVrT1S6Bi5/ViDEbwMrh+XcnVOFiwPLH8EUMWyAYX/WoH6TdgYWlPDzuvHoCo0WToW19FGWiVc8zlDt9Y+dW+Wt+c+nvDxypJfdpKJluhRAxSYlO+d3DtD6+rwbUUq+U4gx1lBR4xHx6KnyXJcYnc07GRrc4R8AnPwZLju7FMtIooPvwFpjjK98jCpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Thu, 30 Mar
 2023 21:31:27 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::c76f:9b76:76c5:5ddc%7]) with mapi id 15.20.6222.032; Thu, 30 Mar 2023
 21:31:27 +0000
Message-ID: <4f927158-3b84-c2e1-77d6-c616139e5766@intel.com>
Date:   Fri, 31 Mar 2023 03:01:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <willemb@google.com>, <netdev@vger.kernel.org>, <decot@google.com>,
        <shiraz.saleem@intel.com>, <intel-wired-lan@lists.osuosl.org>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <72691489-274c-8c3c-c897-08f74f413097@molgen.mpg.de>
From:   "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <72691489-274c-8c3c-c897-08f74f413097@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::33) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|PH0PR11MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: 453a957e-4e8f-4444-32f2-08db31661e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yzpy+s+jX6yJyqhr3du9hEk6dzUnFs+qYe/jY6Iv9IOYX3FJw0Mz8BLypgfRd5LFMKcksIdS75c56PcySULadc/LGn+ogqEK9JNtMlx/q1OY5l5twZKoGVpO3xTXTy3TpKJCcdrBzatd47Tvx8kMFNTi1P9B0ltAmBpfwocn3nwfN3S8b15VQtCsK7V0zofdkg9dzNDvyeOBJ23LnaspJsvfttOk+qYqKPQVQkFL4OwNJ/u/HaT7I5ofqvStDpN5PkmEdUb+DfCegHKqtFnj0zYwQyllgstmg+uANWJFy/jiita88yz4BsQW2Qv0hLAvYxg5cPQfdIqT6EWkrcC82JCU1WNZ6FdojinXS/mEWHrNs1Y5qWY/ABFB10/UfndvylmKqWzPNcYmmUEgCIsqXYKz6TjxJEBkKSwskm72TApblKlCccGiLZYTgTK1kFVoaN9bGUGi4NZzIeD+bqyCyuU/k/gtqxWEzOhuMfcaIlgW3P2VB3BrAxmOMqdNfdHtixP8ZjeBYmukSh2ggu++ME9zZylNW5a7PuADzhcDkAnN55EcLTbh5GiYmxt+TjV6L2hi2onKRwc+0szgmsgJEGO/eFJwP1jDp97odSKlmc+OFuxJalsUOfrUKzrqyoRWp4wV8StAembwbFtRccWDww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199021)(478600001)(6666004)(316002)(5660300002)(36756003)(83380400001)(186003)(38100700002)(31696002)(82960400001)(2616005)(53546011)(6512007)(26005)(55236004)(6506007)(6486002)(8936002)(2906002)(66476007)(41300700001)(66946007)(66556008)(4326008)(6916009)(8676002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEVXQ0p0U3VISGhKNUhJbi8zTVdhWGR5UlBId1phSko3UFF0Um1CRkpZQUZx?=
 =?utf-8?B?ajRjbWZmNUszRmtVcWYrNyswaktWR01KRGJTSHk3SWxLYWI5aldvaURTQVVk?=
 =?utf-8?B?VEFUVHBGQVRlVGh6aS80alhCZ2pwdlozcjhRMkZRdzN6cUF0RjFTRm5hUm91?=
 =?utf-8?B?aXFacGpIb21LcitXNVhjNjRnSTQyaCsxMUFXY0txME5Bc3gxTEVwL1RER2JL?=
 =?utf-8?B?NHd1L3JRS2NBa2JqYzd1OVhYVXZFZlhkMUExNnJwZVk1dksxVkY4UVlEaVE3?=
 =?utf-8?B?dGlERytWZzFsN2x3T3hucXE5c1JtbWV6cnpPT3lObWVpZlBDVFdTTExCTzJL?=
 =?utf-8?B?aHBqSStmU0lVc3kxSDd2Nm42Y0tubzNZbFpvTjZZdlpEOEVLTzd0eDd2ZVJV?=
 =?utf-8?B?OFFscnpsRko2aHFXd2F4dGx1KzR5SVF4Z0ZPUXYwQVUybC92Y1NEZlhPTzJt?=
 =?utf-8?B?SFUwRmRTZ3RqdGRzVEY5bWYvYlJROS9uQklzZjRnSlJrZFBCbFF2Y0t6M2N1?=
 =?utf-8?B?SlF5bm5nTy96bUZOVVVhQ2dRb0QwTllabUxFVmFZYkRBOW94RmpHVFExVEE5?=
 =?utf-8?B?QlhSWk9zYTRtZ3gvNzhlRnVFT3Q1OFZRUlE3R2hsSXpRK1ZQdHVZRnNhc1p3?=
 =?utf-8?B?eVp6ZWx4b2IwVFRlNFp1YTFhbUZRK3c0SUNVSDNoZEV0S2hNL0JIb094S2ls?=
 =?utf-8?B?TFp4QUZ4TlFrdDZvWUtPOXZ3ZlhXSVRNZkpPRTlaZkp6SkhXeDZ0eHE1bisv?=
 =?utf-8?B?M3kzZUxLSk9wNUNpdGRXSG5PRWNiRWppN3hNZjZkS3hTUkhDN05iNHFQNi9Q?=
 =?utf-8?B?SkxKWE83elp0STd1TG9ZVDJSek1ndmxLTDJsWThYTm5Yb2gvRFRpekhXRmpC?=
 =?utf-8?B?QTRmVHBqUnRZazRTcW8zSXRMeHJYdVR3KzBJekx4MzVuOCt4K1VmeUZHRnZj?=
 =?utf-8?B?QVBjR1c5OUhSaDVaMEg5WXY5ZVpTTFJJc3dWZlNWWWhKcHJmWW44OTB3NFRz?=
 =?utf-8?B?c3JadXpHZTdQeGNveUxjS1dXblFRaXBkTXJTcUJucHVIVjJQU3Npa1VreGps?=
 =?utf-8?B?YUFSa2dDeWdSNkdIaTY3Zy9VSGFRQVE5SFlDMlVYbWw2ZEZrNzBKYmFFTW9j?=
 =?utf-8?B?NjR0SFcwVGwwdnpXQ0k3dzBxT24rTElvblU5anlzeUtYblk0cTlNaVVEMUMr?=
 =?utf-8?B?TS8xNnQ0ZTVhWnFJTFVEMnFnUDZBWmR5VFBiUnNHa2t6QlBwNVFJK2hwaW9M?=
 =?utf-8?B?U2F3d2dMYkx5QkUzVElTbk9NS2l1K2ZXNXZ0elNDV3h0eHN1aWttWmljc2E1?=
 =?utf-8?B?VmZmY2tpSXJ0N1pxaDcyOEExWEpmSmZyMlRIRGpRSVhPTUd3UWNtVjNsUkoy?=
 =?utf-8?B?UTdIdis3YkFwbFkzd3BDV21QbUZFRGp3SUtZdUI3VWZuMjA4U0F5ZkRvZEgx?=
 =?utf-8?B?OUxZbTRheUFEdXNyVkZBYU5EbjZvK2NRV3VPZlZoNmJDTm5iKzJnS2ZDN2sr?=
 =?utf-8?B?RnNNdE5WQ0xkVC9CL200MjJ6OVNlZkYrb3ozaG1nYUtIRGtWaFA5UHFIZ2d3?=
 =?utf-8?B?Q2ZvZmZpVHJFay9KeC9malJqM3A2N2Y5dnFYNG9HSWFQUHlHamxGY2FDb082?=
 =?utf-8?B?ZHdsTlFwaE5Sb004blhNcFVyeVJKVGFSR3laVXl2R3lHZGJPb2kwSXIybEFZ?=
 =?utf-8?B?YlRqYUQ4dUxsT0FvK0g0UkFVamFYcDIySTlnUk9GY2RrNStjVU5DYy93UHh6?=
 =?utf-8?B?L21vaG5YOUdqVkJjbnlGQk9WakZ6RTc0L3FkT0Z1Kzg2dzVHak0vNmZzblB4?=
 =?utf-8?B?Z2R4YTduTFlVNHUvK05FTWl3L3NFT2l2dEl3Snc3N3lZbTgvWXZxTjNrb2d6?=
 =?utf-8?B?ZzkvVnJacmlFSkFtSkpMK0VQcmRMbkZIUThxUS9pRTdGd3hMQUJDa0h3bENJ?=
 =?utf-8?B?c3ZVUHM1UlZBY0k3eTU0aDBRR01TTElONnMwSU1oNE1aL0ttN2k5S0NDT0pW?=
 =?utf-8?B?eERCaDRiMUxqamZVZkRJUUllMGVjZi9DTlowYVN0ekRGbzZWMlg1QXNrakUr?=
 =?utf-8?B?ZzlYMlEyajhIUng5Qk9XcDU5MmVFVTBvdTQrRi80YUF6M0YwMDVXSGRpWGYw?=
 =?utf-8?B?aXlTTnVyUmd2bWg5OUs2cVlycjBSVFQxdGF2elVaU0dMbzFXYVB5UTBaT3dw?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 453a957e-4e8f-4444-32f2-08db31661e46
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 21:31:26.9470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb/OduQ2/sWZB6OMCz4qLOhns/wxXdvvNFTsrr2bEZrWHrf9lqi/1E9E15xjmws7j/BI4URjAyg4ViNnPsR8kMVWpJgCOP/F7bd5mZZ3ztQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/2023 9:11 PM, Paul Menzel wrote:
> Dear Pavan,
> 
> 
> Thank you very much for the new driver. It’s a lot of code. ;-)
> 
> Am 29.03.23 um 16:03 schrieb Pavan Kumar Linga:
>> This patch series introduces the Infrastructure Data Path Function (IDPF)
>> driver. It is used for both physical and virtual functions. Except for
>> some of the device operations the rest of the functionality is the same
>> for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
>> defined in the virtchnl2 header file which helps the driver to learn
>> the capabilities and register offsets from the device Control Plane (CP)
>> instead of assuming the default values.
>>
>> The format of the series follows the driver init flow to interface open.
>> To start with, probe gets called and kicks off the driver initialization
>> by spawning the 'vc_event_task' work queue which in turn calls the
>> 'hard reset' function. As part of that, the mailbox is initialized which
>> is used to send/receive the virtchnl messages to/from the CP. Once 
>> that is
>> done, 'core init' kicks in which requests all the required global 
>> resources
>> from the CP and spawns the 'init_task' work queue to create the vports.
>>
>> Based on the capability information received, the driver creates the said
>> number of vports (one or many) where each vport is associated to a 
>> netdev.
>> Also, each vport has its own resources such as queues, vectors etc.
>>  From there, rest of the netdev_ops and data path are added.
>>
>> IDPF implements both single queue which is traditional queueing model
>> as well as split queue model. In split queue model, it uses separate 
>> queue
>> for both completion descriptors and buffers which helps to implement
>> out-of-order completions. It also helps to implement asymmetric queues,
>> for example multiple RX completion queues can be processed by a single
>> RX buffer queue and multiple TX buffer queues can be processed by a
>> single TX completion queue. In single queue model, same queue is used
>> for both descriptor completions as well as buffer completions. It also
>> supports features such as generic checksum offload, generic receive
>> offload (hardware GRO) etc.
> 
> […]
> 
> Can you please elaborate on how the driver can be tested, and if tests 
> are added to automatically test the driver?
> 
> 
Not really sure on what tests are you referring to. Can you please 
elaborate on that part? We are looking into ways to provide remote 
access to the HW but don't have anything currently available. Will 
provide more details once that is sorted.


> Kind regards,
> 
> Paul

Thanks,
Pavan
