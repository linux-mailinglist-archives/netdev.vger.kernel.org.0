Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6066872F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbjALWoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbjALWox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:44:53 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C5C3DBC2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673563492; x=1705099492;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dTUm6kFhL6O5XIMdkTI6ghsisxCsx8f6Et0cJQ3kpqc=;
  b=eVuBVNoeTh7gDdRz8kmD2AM9mSKbe3U9s8QuuVEz+V2Kl/Vand15SC+P
   okT8KuBnaOaJ9DFaoCkOgYN4PSvh+RkZujhPwHKMdB28ZY/WCNSrAPUtC
   zbL5KaQUyV843CKSGe2aSovH9Jq860X3ZzURg/vAVc3HdbC9ovDe/njEW
   WSep1bN14desoZ1lCKC4msnhW3+HIxBO8taq+iU8ivwVVS/PGQsrJ1lRo
   3XweAx/mafoOSSweUKGBLULCDVtntQ0LwDU5BEisJunrN1lqmajeI6Xk9
   TL2q3RWFe+2PsghA9xX3gk05OkY2biX4zSFLYUdy4YBJzXdT0JSBUy30F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="325110415"
X-IronPort-AV: E=Sophos;i="5.97,212,1669104000"; 
   d="scan'208";a="325110415"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 14:44:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="746714975"
X-IronPort-AV: E=Sophos;i="5.97,212,1669104000"; 
   d="scan'208";a="746714975"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jan 2023 14:44:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 14:44:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 14:44:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 14:44:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfs8WX9uZA/8rk/Y/PYAZtSW0hJqqZWjd2FN/uPKUaqqzu5GnyF03wByxuqiND/ZEt7nwga8m5Iha/tqZ2fiVFV01CH/1savGyjzr0gveBi98mbfOV872WpzO69EkwFApO8meN6a6we4ueFfrqELWbL7NXa/GDFzPmmL/V6DFEsSq2gk/3zi4YZFbYo7737o9ejAH1LPVlMitoQtFAWl2B5P+wAtAfuaWzEvkSD+HAyGbLOdrXBtJmwPmtUhvmVB7DWndhGfJ8G6CzxvxoKJ0TLjhrn0+oXMNTRxNgG18TKKZoHjofhGJm3gSJgwIjoOv5BYQAEj/yOjzMJf9x61IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f46pITcTbJ0w3SV0ZHqKBFpkAescDiZwNS8bf3QQd1k=;
 b=SfWArIT1rc1WZS309ny5hShVW7TDKNkOnyCi/B3JzZXb0GgOItkbVqPUq5sb+Y9uFHw2oPJ5vG1mLRS500qT/EB0MM+NV2A2akC25vgX2ncYc+8qsrU83nl2mNbuIE33SkgBhnp8CmxcTabZajWH8IHYcZexR2pdV8VXYG2YNG747fPPSAAkEZw6mUQj2V9ihRIl1SovK5Xrps5/JXZNUAZJkpfZMEULN209FSz3PWlSDvnSHFkiZmr/skqePSGw+bMMqZZt0tbWuf4ucIYiteIt8BMOh/NGV2IMxOLpzIivMSSzbXPgN2/9zFTK3mNYvry9pncfK12ZVDFIa3wV/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 22:44:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.019; Thu, 12 Jan 2023
 22:44:46 +0000
Message-ID: <c712d89c-48ca-920b-627e-93305e281a03@intel.com>
Date:   Thu, 12 Jan 2023 14:44:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <Y7gaWTGHTwL5PIWn@nanopsycho> <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho> <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho> <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com> <Y7+xv6gKaU+Horrk@unreal>
 <20230112112021.0ff88cdb@kernel.org> <Y8Bo7m3zl4WhRBtW@unreal>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y8Bo7m3zl4WhRBtW@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: e0090cff-653b-46ea-894d-08daf4ee9a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6hebR1HJcW2EomDFZrwttcHq49sMeoVqIGN1RiVqcmJj22dClEND9dmWw4tDv/VoZQx5nY3F33GPCXvYudg8ofLpzViu2m70Tu5VPt9Y4tMfnfvh6IV1ypo7jMe6pt4Mpdhj8eekiLma2Qg9mKrSPSWaKm2j0bESe5NIx0rv/S21IHTSCjzU7hyPmmInPAr+k/pAE4EBSzF3VheH5y4ZTJ6/6gmwsfxeVVg6pONbXyR/MZh2o31K0FHobaftijHGvdU2M94JhrifOoaoW0vM0Oow5uIw1vi4c4zWBatVjJ6uDdJrxlpyii8eYa7oiMCDCIenXlAtoIeqGcsf4u6g4IFWaq3pmVSkRntpfbuQ1+Q6sqbBNAJCdG+Ykk1yi3D3MRf7lCA/8Qw/niwnrdpwpOIF50e+37DbdAseygF6SkWSqAFyIIkvSImn73vw1Ud9Rn2dMN26Xf/PpjzSz+BDfNchnzVK4DNg4YK0IjC1eNRNVG8PXDPSPscgSDnf/Ioj9Q5u96hcVNQA/6bE/Cr7EsVMje/P8t5GqTQORzVYuFTcn39QSD9mb7cki1KqplSndSqFMlZoTvpIvkdWgzJvVulVpj4Ufl9PWgvOODvMLNyzBVjum57UwOv2HCt4HJkQmmESp4WMwYKF8kQ3rELa39Dsbzfy/x7P+JDWzLbjZp9j36QGBgFQFRwMsS16A7A70Tbd3MFYkakmFtmiomRpP5Cl0YA4gj5pxCxtL/y+nI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(6506007)(6486002)(26005)(6666004)(53546011)(2616005)(186003)(4326008)(66476007)(66556008)(6512007)(316002)(478600001)(110136005)(86362001)(82960400001)(38100700002)(83380400001)(31696002)(41300700001)(66946007)(8676002)(31686004)(36756003)(5660300002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zm5MRHZTcUFleVZ4Y011b2hEYVltMEdSV2VaclBxQjJJSnlmTlpUNkErVWxJ?=
 =?utf-8?B?Y2NRb0w4ekFFTlNXbDdxbG9vZ29vR1poanQ0cngyeXR3Ynl1TGQvd1JESEdM?=
 =?utf-8?B?UDg4SzgySEJoNFJ5ZUNSWmF3Mi8vYUI0bmxJQ3ZJMXZQcmZraXgyOHMxMnU4?=
 =?utf-8?B?WWFveWRqRkwrQ1pTcWxXOFBQTmpFQlhTWDJIa1ZoQXZGRFpLdVFGYVcvWThI?=
 =?utf-8?B?bGJUWXNKV1N4cFZQR1MvMzdFdFFRWnZ5QlFKQlJIdmprckMzbU4reUl2MHBq?=
 =?utf-8?B?RUkyVjE0alVUaVZMZDdBK0g3aGdzYmhDQkFRK3VxSTNUcmdCRUUvUUlnQ2lv?=
 =?utf-8?B?RTFJaGR4U1VXN0c4QzMyVFJ4YXJ1L1pMdFFTVVJ2b2pGVVM3S2hXNXIxWHR6?=
 =?utf-8?B?Z2lBOEFRQkpqeU4wWUJnL212MVNubDhyc0dnV1NtbjFxUGQycjY5dzZhMmdE?=
 =?utf-8?B?bzNEK0dBVnlKM012WWV1aUVINXozM2tubzNiZ1FKQ2ZselVNbHkxL1VON1M3?=
 =?utf-8?B?cEJoVXMzdXA5dk0zSHR3d29yWE41QTNDN1ZSNFNOYThMc0ZHWmFzQ1ZXUFNq?=
 =?utf-8?B?cEV1aFZXbTgxbmJWa0dKSjJRZVN2NzIxeENTS290TitSVUhJMU5XNzV2VlVj?=
 =?utf-8?B?QmQwQitIZ1NlV2tIWGNBZ25aWjROOW00U2Y2ak9MYklCNjZNWTV2UTNyYkto?=
 =?utf-8?B?OWJraSszYkNIL3BmaTM2bEtKanA4d01QOUgyR29Ma3kvWGlJWkhCcHNsam1m?=
 =?utf-8?B?eE9SaFVKZ3o5d0hIYWZCWFFYWFJNTi9RTGlONXhBU0IyOGREQkVrQmxKVU9x?=
 =?utf-8?B?K2dPUHBnQ01RWFo1TG85eWpLUERrMGM3VHBqRFZWaU0vejVsaG5wV1JMdHFK?=
 =?utf-8?B?T3lhTndJMUlJVHgrUWFhUmM0OW54VG9FMFV1KzNQS3I4TWkzaDUzTTZYaUpD?=
 =?utf-8?B?MmpxQzdKYnlETHpBTlMrSDB4Rng3eGxIWURDOG9NeUc4ckZOYnRnZ210Vlpx?=
 =?utf-8?B?ZnZaZVdxUnNENWRSOGZNNG9QL2JXbW8zbTV5YzNNUmpRUHFNWm85RUtQcVBW?=
 =?utf-8?B?OStxT3Y5cE9xTjNCN1RwYnU4dkRsdEdXdnVUNlBoWXJDci81UWdUUUZPK2Vu?=
 =?utf-8?B?NE9rTEdzZkttZ21lMTQ5S2FOUWxjSFBycTlsMXF3a0FJc3dNOVpoeUdHdE1I?=
 =?utf-8?B?SGE4WEE5ZlZpZGZrRDlnSk9VUGR4R25RaTNsaEFSeDlzdGpMaUZtbVZmaHIv?=
 =?utf-8?B?amRvanJpOFlBdG9vS0ZERGx3a216THhNUmp1UDNRVWlZRGlEUnYwdUtRdzJ3?=
 =?utf-8?B?d0lqaERWOGExWVd3OU9TT1VUbmFHS1NsSVZQdUo3VnM4OWlwWWJJUlFJU05P?=
 =?utf-8?B?NkJaYWhsekpJby9CMUF4Mk9NeWp2WmJrRTRNUWI1YllreDBBUldyS0tuRThF?=
 =?utf-8?B?UTQrMjVZQi93ejhqcXJBbGtaYStUT1UwR0xVQmNsKzVOR0NxRmxQUXdkZEVJ?=
 =?utf-8?B?Y1ZjS3ZQZ2pHVHNQSCs4VVdkbkdTZFNHUWZvSlMxR0U0N214UWFFTjNIT0p1?=
 =?utf-8?B?VHlKU0lFaEVqVE9RWVdMMWozQTN2Z0krS2lKWkxuVmFLM25xWmcveDZ5cEJn?=
 =?utf-8?B?YjVoUkdNOHZvSmNISVZhZlNSUHIxa0tFRUppaTBWT255blIzenFPUDdUczV5?=
 =?utf-8?B?cDA0WExRaG9nZUVhT2xQOGJ5WU1CdjYyWnhBZDBSa2xEOGVlSkN5WXUyL3VC?=
 =?utf-8?B?amVUQlkwQVE2Y3pvRHhTejM2aHVQS0JYREtjWWFFZFpVUUxUN2c2cy9IejNL?=
 =?utf-8?B?Ni9IY2hqeDZ1SkN6L3c0dTZBWTVqUysrTFFMY3FEZTY5SGdUanltY2ljM2hE?=
 =?utf-8?B?dUcrMWNuVmpCYkcxSjluZHd1TEZMQXpWVDlDRmx5RExhRExENldSSkVrZC91?=
 =?utf-8?B?YklGby9QbEZpWFk0RFRYbzRRVVhRNGExRnMyOGI2THNCbXEraUQ2MWE3cHRS?=
 =?utf-8?B?RENCd2NPRlFSZHlhVUFwYWhoVkYzZkViY2NKT1VINkpLTElRcHZQSzNEMC8y?=
 =?utf-8?B?OEtlbTRQanJUZU9zbnZCbW40K1dpTXBJVkd3RVBZOTQ4Q0ZZMmFsTnVEUm84?=
 =?utf-8?B?WWFDcWJSZTRnMHRSd3NFU3huQVQ2Q3BaeHBkUFBBRmw0d1VLbHgxb0hSWU5U?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0090cff-653b-46ea-894d-08daf4ee9a76
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 22:44:46.2993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNV8FhPc9HunkfqmcVq9aa89L89++ht+Ki4sLdi1jiED3DseQO1tQ3NAUqcS1p3NGeUvESgF0Ot14L+EYZYnVTLhBnyw6F+G/K/ybadA7Wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/2023 12:09 PM, Leon Romanovsky wrote:
> On Thu, Jan 12, 2023 at 11:20:21AM -0800, Jakub Kicinski wrote:
>> On Thu, 12 Jan 2023 09:07:43 +0200 Leon Romanovsky wrote:
>>> As a user, I don't want to see any late dynamic object addition which is
>>> not triggered by me explicitly. As it doesn't make any sense to add
>>> various delays per-vendor/kernel in configuration scripts just because
>>> not everything is ready. Users need predictability, lazy addition of
>>> objects adds chaos instead.
>>>
>>> Agree with Jakub, it is anti-pattern.
>>
>> To be clear my preference would be to always construct the three from
>> the root. Register the main instance, then sub-objects. I mean - you
>> tried forcing the opposite order and it only succeeded in 90-something
>> percent of cases. There's always special cases.
>>

Right. I think its easier to simply require devlink to be registered first.

>> I don't understand your concern about user experience here. We have
>> notifications for each sub-object. Plus I think drivers should hold 
>> the instance lock throughout the probe routine. I don't see a scenario
>> in which registering the main instance first would lead to retry/sleep
>> hacks in user space, do you? I'm talking about devlink and the subobjs
>> we have specifically.
> 
> The term "dynamic object addition" means for me what driver authors will
> be able to add objects anytime in lifetime of the driver. I'm pretty sure
> that once you allow that, we will see zoo here. Over time, you will get
> everything from .probe() to workqueues. The latter caused me to write
> about retry/sleep hacks.
> 
> If you success to force everyone to add objects in .probe() only, it
> will be very close to what I tried to achieve.
> 
> Thanks

Yea. I was initially thinking of something like that, but I've convinced
myself that its a bad idea. The only "dynamic" objects (added after the
initialization phase of devlink) should be those which are triggered via
user space request (i.e. "devlink port add").

Thanks,
Jake
