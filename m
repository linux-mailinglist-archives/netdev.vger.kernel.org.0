Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD855EDBFD
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiI1LrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiI1LrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:47:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE5252471
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664365633; x=1695901633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QvV5tL2kyhCh/GhdDPAJdEbRhwqG0Fe9duErOFGo4+s=;
  b=nqpvqdVFouSbbQ763r+Vfd7EHvsxhKw/PcBCjOqU8eIiwc6hlRcIW82A
   0jzP61T0wTd85HlRXaXybm93T2ibzkicqIYUm0FzFUrKlrRUh0kp3BiqH
   THDHzYlypaeSCdKUeYkAjMiDM7yd9AachtGDADZCsIErLHQIbhCWQ7rPp
   edCdAlZfmMxb/1mpAqUwKFFrVfkl1wTSyl3RUkO+YAurLgg2t1WT0AGgF
   w4/SDwFqHj2o3nm7njgZ1TWmsqhHfjgwf2+f6KmtwDaNRGjhsKbsb02lx
   4vtnLrjfWR1w1cgCh3OCcKMv6sEirv1IrKrFmoVaeAGkgMHVe5JmF7kjy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="365626404"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="365626404"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:47:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="621893978"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="621893978"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 28 Sep 2022 04:47:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 04:47:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 04:47:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 04:47:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 04:47:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPa+/mb/lGLOsRgHWhu+L4JSCxdrUU6QFDhw6yl5CprajxA0GwhbLJMkBL5+FML+eMecTJ/7OSOC/abHWC6dUXwpW+zFMJ/uiIkEB/PMJ0zNncPOOZjrs9IJVraYRVEmpyOOvlcqqLkdJrTBFwLj1WsYRJFYaWFuUJVagaHTXwLWKeCE70a4lqWk3QRgEETyIYz9LdQ1/PUpWR0DpVjjrOXmh0JAttpOrcpxrYiomuP4cOQjAmktcT16+nLMeqJswM/lRfiQQG6SKTn4lw+Vxwz5oGr3v+FwzcL8i8pvO40r6vV6sVsQL3rCfaLoRsrWldzU/NMhBTNqP+txOpVZiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yu3zDk0e6/3tUWxszgKmyAkRKFxz2UAE7/vTnNXdnQ=;
 b=kIngPR4P2fMsJQffVSWiL+9uhXeLYvyB1d55pxEJ9bLZhnBKyjUWkxbup6tkyWpHB4sckDTcqjh8D1gz/KgctKq8MoTxAx+Sv8ma7AS18AT1k0tz369FOwyT1rH2yrL7P+jXJ5wL17E0P0C8st4Kki6kc+nT4lW46QBYE4S2nj9gs2Beu2qJj+SC5CtST+6A9rer6wQDog/SbK7JHYiqfm1aggg68eKMfyDGCmdEG403516607AFQ876UJLee3n6sSoBCM2Bgjd0c99FBWTtZaUnnau1PnmsFU3SCGoyoCE2AyAS4UHeLD1On+gcl7SvB+bi3mBtSHP5pLNFQouxIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 11:47:10 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%5]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 11:47:10 +0000
Message-ID: <0a201dd1-55bb-925f-ee95-75bb9451bb8c@intel.com>
Date:   Wed, 28 Sep 2022 13:47:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <simon.horman@corigine.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <YzGSPMx2yZT/W6Gw@nanopsycho>
Content-Language: en-US
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <YzGSPMx2yZT/W6Gw@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::17) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM4PR11MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a5acbc-2e67-4fe6-149f-08daa1472d40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ua01AD8CNgAkrSrEV55MJ0gv4zk6kAQNk7SzjyMS9GByd3G8eUGd3kNiCZZx5959nq2PqJMKIgjtaxPkj3z7V1oWbXyUEEWj5jn8B88y1Yx+WKLav6LScC3rVRaTY9i9uMrNxnmtemulHGgN7ytyxMLyWE2hkf3ySJHCmC5Jilq44WnTk1XJfmEE10f6nfZoKQwT0xZlpwU9tLeFCOtosaC0nfuxAL4uccex4+Nx/Mhq9B4oyly4eS57s7ZikTaiQPgjOjqgtSTfGE0VJoilqE4bfVvAZa5uIH6DeHVoc2H6LAhW3wch5yZNIyt5wE7FQGQMLkG89lIJhErrRnDuXXe2tgNGkYcmIXYzzmN3vxEZBG9GOb4gXpTM9nuHJ8QTtJp9t3VvAZPtLAMwpDLdWXQzCgJzQKCJ3ZavbGRdDRaf/JKfiQBbSnorhm12GuK55n/z16z7d7A89NcepVJrD2m7Xdtzp5PLNb7wLsakn9WZ7CjtCK4e1Xq8JoNFxOxK8tRWIjvidDwcBK8I60lmb8Os8A2z9QFM7BnqLm3R/Zz+aR1FQT2IXqdkcd/9lyn/gzHnPMVGRSx5Kvxq76yH8uu9QIDe4mm7u5OxmbvrG+HMaAzlvwu8oGK7wrDP6XsgZmW0Zx8RmdK5T219khP80old/q6MphyRApgVJWiFBiShve4zuqhMVQ4xvBpWefQ/fqaEEr1YMVCTM4NRZHOlGsXwG6wzXvqncKDhohnq8azRDkbWZy36wPTPx0wjfjCPVLNHmUXsUK1D3jyTzO2Qijwbohl3K3cITqyTIenkGmn1i4iOzo+y/lyTpt6ZBlVk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(86362001)(6506007)(8676002)(478600001)(186003)(31696002)(41300700001)(8936002)(2616005)(5660300002)(316002)(6666004)(38100700002)(36756003)(6916009)(83380400001)(107886003)(966005)(53546011)(82960400001)(6486002)(66476007)(26005)(6512007)(2906002)(4326008)(31686004)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TklQSlZoUFZ0dUVwdFZZcGx1NkFSdWpOMHNnZ3daZEN1WjBSa1U4WVlMMjc0?=
 =?utf-8?B?by9uQ3NkVUVuK2llZHRKMnBxc1IrUk43MENDWVNDVlMxVHgrNWJGRTdZbU1E?=
 =?utf-8?B?QXNicElzc2ZFTjJldmJVZGVUOE1UVTNKUnpFZzBYNS9oaTg5UkVOdVNCSUs4?=
 =?utf-8?B?SHpxM2FPb01NUUtxc2tiS25KamU0UVJIYXVOV0RsVWNzSHhtdzlYY1RUYTgr?=
 =?utf-8?B?MVB6ZVJJWHl6YVNOOWF5WnpPZ3d1ZDJwMjV4MHMvQzNtaEJaN1hWc0Z3elF3?=
 =?utf-8?B?c3lkaUhUaVRBRGo4T2VDWnUzZ1FoUFVZUkN0MXU1TXd4TXdkc1Bqd2d1aytV?=
 =?utf-8?B?Y2ZHMHRvbkNtbW42RnhzM2JseVFtNWVHWGF4TkpVOW52N25LSnZSbG16V2NT?=
 =?utf-8?B?TkZTTStBRjlWcnR3d21oWUpmczNvQmZUZTV4Mkc1dk1pT1pPK3BBTkRCWkls?=
 =?utf-8?B?M2lsc0kxdFkzSFNrUnEvSEJ2ME9sTWc1U3dYc2JheHZGNEg1L0lNZklZYnZZ?=
 =?utf-8?B?NEVtREhSMzBiNlRDdmFLaTlYV3FOMDcwSnQrdGs2RVpFT0JCbzU3TW5scE9H?=
 =?utf-8?B?YktGZzBnc3RZOUUvZlZnNzQ3ZkJ5M1NyMzhkL1dNTjdINkhWZkwrZUoxbTIy?=
 =?utf-8?B?b2JyY3dlb2tOSzBCdGtORHBLUmtSUCtRVUVhOXdyd2JIa1NTTmlSc0lPbE5k?=
 =?utf-8?B?T3FPZHJwVUxsNTBMYlFvS3lwak1OU1F2UHkzUkZHeGtkZlgzRWlMTTVJZnkw?=
 =?utf-8?B?UjVrZysrbXRsbDdBT0tGQjBzS2pmdmRyTFMvK2Rsb1ZEWTlHcHdpekRXckJW?=
 =?utf-8?B?VjloSjRua1FBWXhNckRFemFnU1dYUVdVUzNTSmJZK2pMUkNuZSt4NHZWR09H?=
 =?utf-8?B?TS9WNWhNNU0vTXhDSWxLQk9FSDlneUNuRFl3Z1pRQ0M0RXI3Q2ZUV0QzVllo?=
 =?utf-8?B?QUloUHhtcE0vVFZUUXJRN1g1bFBMdkNhQndzOTI3RzU5SmdRaGtyNDJRc1Iz?=
 =?utf-8?B?anZQaDFRMGtJbkdjT2cxSllWbllxMDRjMmNEMnVZNWRjWk5ibHAydU8wNFNY?=
 =?utf-8?B?SnJNQkt4YjBNVFVMYlBzaVk1RFV4aWgrUStBcGtnVHlHbjg2TGcwL1lTSVBj?=
 =?utf-8?B?NUlQemxhOGtqNHEyaUR2aThSVktsbXhNMkt6YmU0akRwQ1VaU0gxcHp4eXVT?=
 =?utf-8?B?cFM4QWNYN2crSnVaajJpZFMvRkJoUlhtaVdkZmNNL205S0F3TTd3MituY3VK?=
 =?utf-8?B?NVVzenBxMEI5TUFPSmN5Y01hVTNMdjU1aXovQ1JMZTk1NklLY09JZVJoTGRw?=
 =?utf-8?B?VzBQY0hDdnVqM3R6aVNaQzFYZVpFMEcyS0tFZEdabGtnT0lDdUNVWGtFWFJD?=
 =?utf-8?B?SVhNb0tReXJ6SUpWMXVsb0tycFlVbSt2VWhpeTN3ek9rUmpkRXhRbzFEUWtS?=
 =?utf-8?B?bitjOVRrYitnUlYyZllqRHpaWHdYNG4yS1NrRExPeFRIeWtUSVd5UHJJdWQ3?=
 =?utf-8?B?ejZLZ2VZS0ZsdXdOWWRxRWpod3Q4K2FhQnFjS1UzR01yRVMwd21nQ2s3WHhT?=
 =?utf-8?B?dUdld1E4WWZMZlR2ZnBGWFJpaXRzUERXVjNwZWM0L2hYYXY5dThoWFpJVWRN?=
 =?utf-8?B?WEttTXM3azNIc0gyeXFRYjJtaklMNFNsaWlLaHloSGNITHcreERDaDd2K2ZD?=
 =?utf-8?B?UnBLejFuRnpyVWJabzQraklHSlZTRDlCVU5VZFUvR1ZodU0wWEhvd1BrMjR0?=
 =?utf-8?B?aTdsZ3pvaHRqZy8rc1dyUmtaaFFWNG43R3Y3cnZ3WnZJQXFvcm9jMnoxbWRR?=
 =?utf-8?B?UHE2Z254MjZrSEhRcUhybTFmYlVtUnBTdFA2eWo2TmlKNmQ5dHFSZVFRb3ZE?=
 =?utf-8?B?bnRLNW1FRldPM215K29VT2YrSkRFK1hXWUxXb2xjaitvc050clR4UkhnQ0ZM?=
 =?utf-8?B?NXB2MW9RTWlzUHFzOEk1U05hK3lxRjBtTEpwdjExUWxkckMxZjNibVJuWGIv?=
 =?utf-8?B?QUJGUGE4bjFQdG4zWjBHU3hNa3RBSHl1Zi83TmtiYjZIb2QwdWlzSVFVVHYv?=
 =?utf-8?B?Y2wvVlBXdHBObGN2em5sVitOWGpkNE1wV2ZQZDVlTnp1Q21LQ3ZTQVJHb0ph?=
 =?utf-8?B?Y2JnWHN3YzBJbk1GcXN6TVFoaGFWV0JXSGpwOXNJUnd4d3JqY1JuVHg5aVlE?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a5acbc-2e67-4fe6-149f-08daa1472d40
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 11:47:10.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZMGQjMQ4h2WlTIIcjVHumcpqJ3ABfXBb5Z4tHlq0AfpvzwTLNbxNta+gsNmtezpDaEq69fVQrkw0nDJ6pimW4XYwGKoF2YXzvXeNm5LBhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6311
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/2022 1:51 PM, Jiri Pirko wrote:
> Thu, Sep 15, 2022 at 08:41:52PM CEST, michal.wilczynski@intel.com wrote:
>>
>> On 9/15/2022 5:31 PM, Edward Cree wrote:
>>> On 15/09/2022 14:42, Michal Wilczynski wrote:
>>>> Currently devlink-rate only have two types of objects: nodes and leafs.
>>>> There is a need to extend this interface to account for a third type of
>>>> scheduling elements - queues. In our use case customer is sending
>>>> different types of traffic on each queue, which requires an ability to
>>>> assign rate parameters to individual queues.
>>> Is there a use-case for this queue scheduling in the absence of a netdevice?
>>> If not, then I don't see how this belongs in devlink; the configuration
>>>    should instead be done in two parts: devlink-rate to schedule between
>>>    different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>>>    API) to schedule different queues within each single netdevice.
>>> Please explain why this existing separation does not support your use-case.
>>>
>>> Also I would like to see some documentation as part of this patch.  It looks
>>>    like there's no kernel document for devlink-rate unlike most other devlink
>>>    objects; perhaps you could add one?
>>>
>>> -ed
>> Hi,
>> Previously we discussed adding queues to devlink-rate in this thread:
>> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>> In our use case we are trying to find a way to expose hardware Tx scheduler
>> tree that is defined
>> per port to user. Obviously if the tree is defined per physical port, all the
>> scheduling nodes will reside
>> on the same tree.
>>
>> Our customer is trying to send different types of traffic that require
>> different QoS levels on the same
> Do I understand that correctly, that you are assigning traffic to queues
> in VM, and you rate the queues on hypervisor? Is that the goal?

Yes.

>
>
>> VM, but on a different queues. This requires completely different rate setups
>> for that queue - in the
>> implementation that you're mentioning we wouldn't be able to arbitrarily
>> reassign the queue to any node.
>> Those queues would still need to share a single parent - their netdev. This
> So that replies to Edward's note about having the queues maintained
> within the single netdev/vport, correct?

  Correct ;)

>
>
>> wouldn't allow us to fully take
>> advantage of the HQoS and would introduce arbitrary limitations.
>>
>> Also I would think that since there is only one vendor implementing this
>> particular devlink-rate API, there is
>> some room for flexibility.
>>
>> Regarding the documentation,  sure. I just wanted to get all the feedback
> >from the mailing list and arrive at the final
>> solution before writing the docs.
>>
>> BTW, I'm going to be out of office tomorrow, so will respond in this thread
>> on Monday.
>> BR,
>> Michał
>>
>>

