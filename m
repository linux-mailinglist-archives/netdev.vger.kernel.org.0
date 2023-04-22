Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10E56EB798
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 07:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDVF0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 01:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDVF0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 01:26:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51E81BF4
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 22:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682141191; x=1713677191;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1J9oDIJVV4SptTxSnMb3RktT5nWlyQxEeWcHvnJVG8o=;
  b=gx6ftJCvHoQQEVi4eXXDWjrQgaLpCHWdMweqe1a2gAfVF5j1/is3JGih
   hn4cOPumV2oOINS2Dm+e7gyzRc+B+JMBZgcIwEW8+c3hW5pEcbIUSN30n
   u+N1dQJ2XQ3SOTItfLDQ0UrtaJxZ/Z/fmQ6lnbEcVECR5el/MWvG+Ti1E
   lybEvjP9W0afEpb6VvSJ6pCllTlLQWN2I7vmemAsVhl6VA+456uGUUgPz
   W4TKJ6mjCQ/4NoapDi83UrhP3M5/OLJK8VBXCOQeFipEtjYd32gh55sSH
   5SKGGGsnyb1nbBTbx8tetqvX11ZGq2kRUOQK+14T1qOrnkE8BhaRtxIZF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="343615829"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="343615829"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 22:26:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="669920845"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="669920845"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2023 22:26:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 22:26:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 22:26:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 22:26:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 22:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvfN3GLqta02uZ5cBO0s2z06CZHB3XmHB6vf147hAGwgkWbLQXZxu+WJh8SKPWDbNJb29aCJ1cXCdZwQ9bz6lssask5+nc/FsTYUPra1IRuADEjkWzXQQI/dcqD10wk8AjqyIK+gt+cQzuq1lYDpzA6igAZl8ZDjH/q4+GaNfawnGveH/O3njc3Y6ewR/lIwknrn4S0D9PVtROVFioy5jdFDiEIu9tXDn9mUMpSf6Qmw1GP9tLbLnlQjqSyIyMC2wvE1Ht+toyPMkHOjXqBNr/BBGarVI8qMDNTu5+wisi2vqqzjzecdubvAlM+Df0evRj9qqgHt94DG28ztdP44gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpO0eDlQdEcflEKS16Zekq7J6MijbaXoZFN45O5hGqk=;
 b=lNRjyQ/m7tEhU9vDZmt+ExyFQR/2I8sF1+rMjMYgmT2zyzFcMrmzXUCvhKVxlwUXAPnCLifbju8Np6B9Q/6WrdEdVlt8gtRNTkSjOY7rwNAMuoQPUOW498Ra4fvIxRb5fZZb8yofmhWsKEtrmC7PmbqKWc6bAiXXx+ymqTpaW8DgdaLkso1wLAv7zpAgGXWYhPIq/gTb3t/1JUbgbyxc6pzIYP83K73X+Ow86f7hYoMxuKzqZfczz1TlYhq+VHpxtKMPvWuK0e2eSLqWU4+S0m4TZpHVfPMWZzc6k4T8FZe4eYYOsLm8xAhcMeAxPD+I4X3i/eueVCfjQNF2Ne1NiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by PH7PR11MB7499.namprd11.prod.outlook.com (2603:10b6:510:278::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 05:26:28 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%4]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 05:26:28 +0000
Message-ID: <2fdd6fe9-9672-8bf7-f8f9-e9906fa25167@intel.com>
Date:   Fri, 21 Apr 2023 22:26:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 14/15] idpf: add ethtool
 callbacks
Content-Language: en-US
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <willemb@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <jesse.brandeburg@intel.com>,
        <kuba@kernel.org>, <edumazet@google.com>,
        <anthony.l.nguyen@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        Phani Burra <phani.r.burra@intel.com>, <decot@google.com>,
        <davem@davemloft.net>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-15-pavan.kumar.linga@intel.com>
 <ZDUunmuPmM0E3Rx3@corigine.com>
 <bc8457a8-28d7-3c79-9272-314f8be5cc09@intel.com>
In-Reply-To: <bc8457a8-28d7-3c79-9272-314f8be5cc09@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:332::8) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|PH7PR11MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c39c645-6ca3-4ca2-7f2d-08db42f21f32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTEtKu6TSB7Ey0/mR+ncwwDvpLDmVfPuaFFtfNqdsdD/v+cc2AdjrohdWLvAWww+k6NDn9qsovhRzX05/Iq3E/6CJGkbsK5ySNr0F7PAt/wtZpowIZpOViKGqPqv9c8pkC+68PlqyfI79OBiU68ETAJ1cBfIglTcC2+p8WMPdE/QBqWB+u3mfDYRQIeuEDLmEhA4+58ehsoau2t391Inz2roYitF2SBU4TTAJ+r29svZuXUHlrRR4iL3UmQs619kC0p2cmMnoNXSPylf8fA5891TZeqfxjVXXRYdEU+z28GvLAZX6GGrMHN9bTn/B5yBvnnT5/az97a1OHZaMTcBv6iDqsht9SRYSbPtO7I62PXAsr6ntvcYbIsbXe19kmuX+xicgMet98cTsNRnvDzFi8+raA1FAlMIerSrYVs4t/mGwOw5PDVBehwA721upaARkAM7ovZXy2gwBKz/QMqETyCUgfBk9I5OHtS2n1seYDUFzWRGyeJ/JmNTDGRVnDzvsv3LHydFIq9Gk8a/UjdGAxUkiF0G1Mr9fUN3XPx3b5kWECk6z/i02y36PkIybEIXg4BVTeLfNetZNjjwuXTtUI3RNVOkTfb6+JCDhl4ELCLQpZYWJ8TALBI2qrzmBGP0pg0jMZ1C6HVbGhulV3N5WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(38100700002)(31696002)(2906002)(86362001)(36756003)(31686004)(6666004)(6486002)(53546011)(186003)(2616005)(6512007)(26005)(6506007)(66556008)(66476007)(66946007)(478600001)(4326008)(41300700001)(110136005)(82960400001)(6636002)(316002)(8676002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTJLaVhoeGV4SzhYQTRXMjFDWlk3S29RSFV0QVpEdk1KRG1vdG1Kb2lVVDVK?=
 =?utf-8?B?LzYycU9EQXJwcURHaUhSZmtXZWlZUWc2NHdrL2paay84VFV0b0JvUHJacWNk?=
 =?utf-8?B?eW9HSjF2UFFxUC8rTzdJVjFLUTFTeTJCUThubHJtOE5qVGhDcHFod2dubWdG?=
 =?utf-8?B?c1h6MG91ck5oY0VSOTdGTDNCSHZvZ1pjWHl4dGtUUXNUTW9VRWU1ZjVTNUc1?=
 =?utf-8?B?clc1RTRrdUZhdGF3L29lTVlSRmZOeG1ERGplQ013eWZ5SVBrR05WcGNsWFZT?=
 =?utf-8?B?Q0JDa3d4b2xUK3lYclFRc0RKZUhlWWVKK1liRU00VzFPSzd1MEIyS2l6blJi?=
 =?utf-8?B?azRKUm00dDZFU254ZjV4eFFCbzFJVzBJNzFhZ0YxbkV0TkpiMk9LQ3hrR3pJ?=
 =?utf-8?B?N2lkVlcvdnU4UXIwdndoN1ltS3NxWGd2ek1ob1I5WkE5VkZpeE0zY2Y5elpG?=
 =?utf-8?B?d0gyOVUweUpFcS9MTnVyclBnY0RhQTJHRGgyNHF2M21YTWlWM3dZOC9xVWhY?=
 =?utf-8?B?cW1GbE1JUVRyWGprWjlaQmExQnZCR2NIWldRQ1YxdXJ5eHY5NVJPaGxmenRJ?=
 =?utf-8?B?bExnOE9Ydzl6RUFTc1ZyM2RWR283ZEZ4RHJrSG1GUVJnai9EZXZmRTBmS3Np?=
 =?utf-8?B?TXAyYWw3WFlQNnpkOFByelBTNnN0ZXFPamsxSHFJbCtmTjN5SGlVVU53Mnlw?=
 =?utf-8?B?R2krSVRMQkhPYjVabGlLN25rZmtFb1NrbVVkbzMxV3RIcmdnby9EWmw3NjBm?=
 =?utf-8?B?aHJwMjBmMVZ2cm9qWlVieGpFSzJTeUVvM1NzWXFpSDRlc1dIQklRK0RjNkRB?=
 =?utf-8?B?eUVjeVlYV0lucGllSmtwTGZaZ0krTFVDQVN6K2cyd0FMa3lIOGN2WkgxT3ZF?=
 =?utf-8?B?R1J2Rmo5eFZ4MlM3VHNJT2tnTHdpOFd1K0E5T0JjeHIyT1hDTjFYY0N2bDJH?=
 =?utf-8?B?VXIzZ1Z6eXppMUp4TDFHUUZUdHNUREhEaGJ5czdPb3haQWdORjArWW9RZUpC?=
 =?utf-8?B?QVVVRTVMeEJSOFBqRmhqRFhFd3l6UTV3aTkrRmpUdEk5bTl4K2pjbUJWMk43?=
 =?utf-8?B?U2kvVXROYkxqcmY4eEZXWlRqQjNudWtEZnZtTTVKbnp4dmtSKy9tL05vdjZ2?=
 =?utf-8?B?eUs0cEI4Q1g0VUtUUDhuVXZJeVpJaDdhWG5URG90eDlJQTdYS3J3bG82Ulc5?=
 =?utf-8?B?WnY0dFFhVElWMzZMdURCUEt3Vk1EeTU0eFEvbXR5bjRnUmlaWEsvNUF3ZFgy?=
 =?utf-8?B?STNPaDlpVnlqNy9BOGpPZHI2dFdtQVNQcUZReVcxWnZQWFEzczRuM2FBaDBY?=
 =?utf-8?B?RzVVNC8xOStReUxZekRweDdFRXhrekxzRGlRMUhuRVNBMWFYWHVrQU9INFNi?=
 =?utf-8?B?Q1dmNGttdkQrMXNRaEo5Q3M5UTRrZEhRdTRmK3VIRWVZQWpGZmt3bWU0OGdt?=
 =?utf-8?B?K1l1OWJTcWpNQW1WNkVraElQUk05RFlZRmxZYkpzbmRoaHJ4TWZKcTIyQkF1?=
 =?utf-8?B?U2tHbUNmVXNwM2RtUUpHWWFEOTZqSFZadUpBdktyMzNaYjBjWlBWNUl1NS82?=
 =?utf-8?B?WWxwdFJaSitaS1pBME51eHpoNDhNYUJFdWYwOU02ekZNUU50RlJURWQvVWZw?=
 =?utf-8?B?ZmxFaWtaSzdNNUErOENrNzBjVit6RkhMcEZWZVpZQUlPRnc2bExFM3k3Z1Z6?=
 =?utf-8?B?MVBFSGxZTUR6blhBWklFRERkalJYckloNzJKeHNjblAzNTNRQVhnWk1wcTRp?=
 =?utf-8?B?SDhvUnNUdk8xelVNRms3RkhyVURIY2NEWmxMQWNyRjBTemdRYmR0eVRvMy9h?=
 =?utf-8?B?TTJHc3Q2RUtUeFI5SzFpV3pKUHBGMVhxRG9VcHRweWN2K0dhMWEyK2NWUzlW?=
 =?utf-8?B?R1pmb0lKbnRoM0ZscFU1UWlFOGlOYlJwQWhtRHh4S21kSHV1UzBHSWRUM0xt?=
 =?utf-8?B?ZlZ4ZWZPQ2Jza0hVRnNvMFhiRHVLR3RsQVR0c2JabDRVbkFJVzFrUWo5N2Yw?=
 =?utf-8?B?dUFCcmtYb2RkMFlWZTU2TlJsL3NzZ0haSWxUUzBQS3BDR2k4ZG1GQzJhSlRZ?=
 =?utf-8?B?UHdzVk5IVWRRTWNyUzRDek1RL3lzc2t6cGN6SHlOUU5PK1Jmd3lPaU1mRWJl?=
 =?utf-8?B?cXJMckh0ZHp5bUF5TGlJUktFVDltczhydzE5c0lwSldCN0RvT1lvaUtwVXIz?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c39c645-6ca3-4ca2-7f2d-08db42f21f32
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 05:26:27.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvMAtH59n395armRNRTFlXUKn/Ma0OuBXxfhPEJzW7kuvef3lgMDWefzQkNauIxiqCEF8ZuPWMu55d5RmzNkTJfddvqvgFkuXFoIzw6dK/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7499
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 12:11 PM, Tantilov, Emil S wrote:
> 
> 
> On 4/11/2023 2:55 AM, Simon Horman wrote:
>> On Mon, Apr 10, 2023 at 06:13:53PM -0700, Pavan Kumar Linga wrote:
>>> From: Alan Brady <alan.brady@intel.com>
>>
>> ...
>>
>>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c 
>>> b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
>>
>> ...
>>
>>> +/**
>>> + * idpf_add_qstat_strings - Copy queue stat strings into ethtool buffer
>>> + * @p: ethtool supplied buffer
>>> + * @stats: stat definitions array
>>> + * @type: stat type
>>> + * @idx: stat idx
>>> + *
>>> + * Format and copy the strings described by the const static stats 
>>> value into
>>> + * the buffer pointed at by p.
>>> + *
>>> + * The parameter @stats is evaluated twice, so parameters with side 
>>> effects
>>> + * should be avoided. Additionally, stats must be an array such that
>>> + * ARRAY_SIZE can be called on it.
>>> + */
>>> +#define idpf_add_qstat_strings(p, stats, type, idx) \
>>> +    __idpf_add_qstat_strings(p, stats, ARRAY_SIZE(stats), type, idx)
>>
>> Hi Pavan, Hi Alan,
>>
>> FWIIW, I think __idpf_add_qstat_strings() could be a function.
>> It would give some type checking. And avoid possible aliasing of inputs.
>> Basically, I think functions should be used unless there is a reason 
>> not to.
>>
>> ...
> 
> Good catch, we'll resolve it in v3.

The reason a macro is used in this case is that it allows 
__idpf_add_qstat_strings() to get the size of the arrays passed by the 
caller. Is there a way to do this if we convert the macro to a function?

Thanks,
Emil
