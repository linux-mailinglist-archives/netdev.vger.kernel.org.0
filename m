Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B60690F11
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBIRUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBIRUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:20:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC166EEC
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675963235; x=1707499235;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pcrcZbLsp3yLMPGyZEW1q2ob8YNfPmt4IEUBypxtH9E=;
  b=gFVWmihdZDavq7XyJd1wmQzHTVyaJq+XpyRhTrQhu/rHDY1VNa7CBCXf
   JAMcEtb1XDg8/uQugqw5O50CYZRg6Ndkj+VtmY7SiLf5YbU/xJWDsbdFw
   D0VCUSUr4bRlpJnm5fUW66tQ1gXtVXzyyvnXzWHjWwMEY3JLmwm1zyAfq
   zQNzQjyUniIj+X7wLZuqH/KfYnv1B35FyhZhyuJTmltY2O97ZHWwTHjrJ
   YVn57RbpLZTvZVYH3Mm3+hir4vR5/KYz6r3MX7s01xakKNE62xrM6lj2o
   nhJJSLZ4qZP0FmCzVhF28mxll2FQddXZD7tKFmLdaN6Ud8GpX2yq0U++i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328813764"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="328813764"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:19:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810456076"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="810456076"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 09 Feb 2023 09:19:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 09:19:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 09:19:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 09:19:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 09:19:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C30dLQ/5RMNMwdkojj9VWur3znc8t3jNZBt9n5YhEP/m8lqqdeP5CSZAY7QrsOIxK3X4AybxAl3G3/nOGpzqj0riTuQkGfFAIoJtSYlrgpi+81J9fG/SQAWvQP8dL5dhZCPan9uLa0353FZ3L9UvkyveSQIo5zLcrgG/DYv/edVwcgd0lIG2fN4aQR1tD+XXWGFEeWOs3T2msbyGgBtRaXVGnPZG7Ahe4H6PWjHlRn/Kbn6+oGwykyRkchbGgusCWGl/ds5Qedi16ZLFJWYfFB5KVS/PpSherdQYSS+Xd45fxMUA2DWWQ0d9hV3SLdYvrY0kR32VU+dUDX/5hvD+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjhI+NIpz5Oiy6/MErJh44o80GXpiFlE2ctbWegRplo=;
 b=OVkHZsMB0Pn5jwnm31ldR8K/PXg/32auG5WLIeK/rJyH2de7di9A60PbxoWkgLqKICWgWEiHQYr48He7U9hWBfX4t1fTYcjWxav260oECdimSCD0SZobnLxaPS3i53Htyl0RMSP1iJ4Q+TRhugx/zpWICJLpFUV6KzeIHq9bSbyIxsyaWBJ9ZcCtJmr/6XB3UptJhCpdkG/9mkx10KbmpRxKPdu8Gkk0ylJKgXDk6094ftIr5MCCMVxhO4S9ARJBmDqQQTwFcjh2hyraYJSpHXFCae0dZqjY44HonJyveNCw/vqIZhA+8HecbZYBGKxgVf3H5UwxGYwYFj3xsEUSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY8PR11MB7393.namprd11.prod.outlook.com (2603:10b6:930:84::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 9 Feb
 2023 17:19:48 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6064.032; Thu, 9 Feb 2023
 17:19:48 +0000
Message-ID: <a9be5ccc-d57d-8a87-41bb-5b0a44fa3924@intel.com>
Date:   Thu, 9 Feb 2023 09:19:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/6] i40e: Add flag for disabling VF source
 pruning
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        Sebastian Czapla <sebastianx.czapla@intel.com>,
        <netdev@vger.kernel.org>,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
References: <20230206235635.662263-1-anthony.l.nguyen@intel.com>
 <20230206235635.662263-2-anthony.l.nguyen@intel.com>
 <20230207215643.43f76bdd@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230207215643.43f76bdd@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:a03:255::15) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY8PR11MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e92c6b-5629-4bc6-d17d-08db0ac1d855
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEbZ9khLpS7DBRfc9RJalL8qR8J5xDBHw0tSQpi2AsBsqKZ3sUkW62t2GraQT0gOQoba5g6Taz0VPusA6UdqcF5slm5uuh7aD3V9k6jE7FNJ+KBZRUQjAcuSdmZ7UCTW8JsneUhafx88oVcAnOaOeifnXlNMpW/r/JQi1wGlgWQel8I/JougWlGmYB8LWL/0dr8F9Bcodz5sKtWeQFfNzRmsiSp+u9Fo+fa1nqS24RIDnAS2CJJWDm2sHLCThTUG/invz/TwYj24Yrh2Lr+95lRFLBqs4ohpf+fHRHe+2iKwFbWo8nFGfU0iaiqJxcePbF/NsnuaGPD9N/r7T5rPPzEYkkm2+LVpDAa7oY11W8meO+MRhDSoRFEoQ2FDK5e5n8Wk7v7yAAxMilduIMN0jG616IX3zZ+xiTgwYgQ9dYn3Oxt6Mr2g7QOFtZxR8OTuiRXWT2Nojumwv15LAlsCmJIGDkroiVR4JDUkvTNscWiqE+tQBy53SmIC39AYIbTUPV3Q4L7UUFZtAbj1xlfFrjTEG5D1vLzM+Zfzt6bFn7KY8rElm60iRtsDLUUdxm6bihwxbvTFBAkMRS9/vJNCyV2z8hnvZPkwscnr6pD0qbaQlzjm0/IryLQVUrEWK2sxN9bfByyjDzAL6ZI7Uk7eqJBJB3xhTJfQP/6TuB+DxL2SjxvoPtI1KE2I68wcemO9gFkxqCg3JfeZ90l1tHmWQKJgtnYtoBhnZ0GOAsJpkJM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199018)(31696002)(66476007)(66556008)(8676002)(4326008)(86362001)(66946007)(31686004)(8936002)(316002)(41300700001)(6916009)(54906003)(4744005)(5660300002)(82960400001)(38100700002)(186003)(6506007)(53546011)(6512007)(26005)(478600001)(6486002)(2906002)(107886003)(6666004)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWFPemYxQUZDeTR2WFRtTGt3bE5CTnFqMlJ6RktHTjhrUW5icFBlY0VrVTFQ?=
 =?utf-8?B?UkhQbE4xVjIzMXlBVWFsN203Nkp5UTMxbDJ6YTdYQTdKRjZCWnN2c1BpQVRy?=
 =?utf-8?B?TWszVDA0YnZrQzI3dHVGRldvb0h6ZTJQSlNDTHpqY0RZU21MdGhyL1kvdTht?=
 =?utf-8?B?MVFjREN4S241RkdVMjBnMk9sYVU3MFRZVlZIRmdhTnlMSFdyeEFraElnRmty?=
 =?utf-8?B?K1RBTVpJdVd6SWl3TG96Wks0ZGFxZ1pxdTZnUUErTDcwY0MyNXlhSW8rQ3Bm?=
 =?utf-8?B?OGRMQUh4OFJGeE5iZ1NJM1RlUmVPUlBiWXJRWWZNbmNzWVJoclBMTW9YZEJ1?=
 =?utf-8?B?TVVvdjlTSGtjTUEyU3FSK1JQWFBpOU4rMkZHcUZYaWpZNE9qdDJKQ2lOUmRH?=
 =?utf-8?B?Y2hTZFhaSHV3UlVxUkxDdmFoSE4vTFdqV1kweUo0RFZCUXBPWGpXak1jNWgv?=
 =?utf-8?B?ai90QmttN1VIVys1VDFpb3VvUUlpOWU3SC9kOWhhZ0dtMmU0L3p4V21OMDZq?=
 =?utf-8?B?ZmdKbFFwMmd1amE5SDVJVzdoV3F0U1JvMzZ1TFpId1BpZGxtYXIxdjFyaUpl?=
 =?utf-8?B?eDZpQmx2TnVhVkdQQnpEekQ1Z2V3OXFrZlR6QS9Wbko3cWFCZTB6V01nZmUr?=
 =?utf-8?B?UzI4ZlZvN0pYa1FHT3V5cHk4cld4SlZVRWc1TUh1akp2UVY0M2J0WVJwVXh2?=
 =?utf-8?B?dzdRWVdDWDNlMjRUTjNLNTFVQzhtUlN3Ny8zOGF6eS93YlVUdDE0bEVPVExE?=
 =?utf-8?B?TnM0M0VLT1hENWN1eEplSFpJalVSa1Vja3ZyS25WeDhsWmcxcURWQlYxYm4w?=
 =?utf-8?B?VWEyZ0RPN3JhbWN2a2xMWVluSmoycGo3K0FTZ2V3RlBHcG8zbjdUYjR4bG1N?=
 =?utf-8?B?UjFtUDBSVUdlcCs2NnU4OFZlelU1TDBZNnd6WGZPVWl0bVBHU3lFMUxFMmhM?=
 =?utf-8?B?ZXhyNjVoRVg1Z01QQ2oxenF0Y1loQmRyL2YvWUwvdUJaZ0dxWS9jenJtZm15?=
 =?utf-8?B?RjJsTyt4Y0NuWU1rdVl2bWFQOFhPZXVYVDYwbWd4M0hvNTV2RmtpWTVEUy9F?=
 =?utf-8?B?UXEwTC9aT01kTkZ6eStiMTRSWWtDY2paa3N4cXd1RlB6MjYyQjAraUE3Y3Vq?=
 =?utf-8?B?cDEzYnBEUkNGNWdoSlNUS0sydFZTN2d6ZCt0a0FoWnhHZGcvbCsrdVcycGVk?=
 =?utf-8?B?WkVEMHBMNjVXYzhXVlVUUTB1V3BuRXpyNExyNERmNm56cjI5WkZxdmhXMFhN?=
 =?utf-8?B?bTNxYWdOU3FpeE1XQ1AzQlVmSFU0dmkzSUhYZmV0ai8zTmRQVUNCNURLT3c4?=
 =?utf-8?B?L2o2OWRFRHVWOFd2RC8zTjJuUTR2QW44RWc1V0srYlEya2hWcnNZYWFrRHU1?=
 =?utf-8?B?YWlreS9iZnhJZEhjUzFYc29ubnhLY0VGYk1VaVBuQ0R2UXhWbm5taTBrQXd2?=
 =?utf-8?B?TGVCODNmRThXSnlYUEw5VGIyem5uUHZhVmpoWmhKeUhBL3o0bEVvVzRuREkv?=
 =?utf-8?B?bFVEZlRVeW9nTnlJWmV1OGtzVmVJR3AwZlByb3M1c2c4clQrR2ZOTE94ZE9z?=
 =?utf-8?B?bXFuRFhjKzBlV1dMY1UzWWFwUzd2MXdubTR0UUNNbGM4RVEzMnF5UEEycXUw?=
 =?utf-8?B?WjVXUHY2Ky81MGFtQmhDOUQxdXFFM2tHMnVOZUlxRldUZEFyb1hPS2ViU3Yy?=
 =?utf-8?B?a1VraTRPNUxLNE1BS0xWTmxJWjlKNEFRUWFTWExoek1icUlyRm1keVFIdjN4?=
 =?utf-8?B?aWtQTWI4VWROQkR5SXJVZHFLUDVrb1BuaWgyam0vVG0vT2d1dUhkUXFpVDJI?=
 =?utf-8?B?Y1ZuMkROTnV2ZWd1RWllS2tmVkdhQll5bFdVRlRBaWY3a3FLVWZSOFB1c0hV?=
 =?utf-8?B?ajBMMW1GRnl5aExkeTE2aUxmbWJCMVhxM3N4NmoxL093U21LS1BKVmtSYTlx?=
 =?utf-8?B?bHd6T2NEVWVmUmRhR2R1YUZCRWdaN1dTZnBOWThwbGtzdFkyZVFoYTc3QzBl?=
 =?utf-8?B?d1QrU0xYU2VPWnhiYVh4S1h4WCtJRmNualc4RDc0dzZienEzOHBsVDZ3YmlD?=
 =?utf-8?B?a1REbFlYc1FsQ2E2RmFSNTdYK0Jma2J4N2g3Y2ZxZnd4QTk3bjF2cG14cW9t?=
 =?utf-8?B?OGluaGw0MFZ3eHNmd2lkemQrZE4rTlFFSkoyVncxMHcxZFF6N1h3QU4vQmlp?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e92c6b-5629-4bc6-d17d-08db0ac1d855
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 17:19:47.9556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIprfYZrxG9uEPx6CUWwqMafmgO0UyeNN9eHqLcZo43b5bBOI30rRu9tUdo4r9TUWyGL9ftaUBMDGRx3/2EbEGoue0gKifg+zUjR9BLE3j8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7393
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/2023 9:56 PM, Jakub Kicinski wrote:
> On Mon,  6 Feb 2023 15:56:30 -0800 Tony Nguyen wrote:
>> Allow user to change source pruning for VF VSIs. This allows VFs to
>> receive packets with MAC_SRC and MAC_DST equal to VFs mac.
>>
>> Added priv flag vf-source-pruning to allow user to change
>> source pruning setting. Reset all VSIs to commit the setting.
>> If vf-source-pruning is off and VF is trusted on with spoofchk off
>> then disable source pruning on specific VF takes effect.
>>
>> Without this patch it is not possible to change source pruning
>> setting on VF VSIs.
> 
> Intel keeps trickling in private flags to adjust the behavior of legacy
> SR-IOV NDOs. No documentation, no well understood semantics.
> This does not seem defensible upstream when we already started rejecting
> any use of legacy SR-IOV NDOs in new drivers.

Will drop this patch.

Thanks,
Tony
