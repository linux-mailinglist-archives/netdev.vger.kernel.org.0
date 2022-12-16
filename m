Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF44A64F429
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 23:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLPWcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 17:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLPWcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 17:32:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FCCDED1
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 14:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671229926; x=1702765926;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YcNUzIpIdbRkPnTusXHy/RpB3qkdUo7QPkSk/CYfkdk=;
  b=O/E+/IZ2h+PgK2v522MN8a6Du4L19vVGcUn5MZGV3WfKhHTzLci47m6q
   69lmh6+eCti1whVLMchVj3RO32KBcW7cci5AwwOzWcdbqIAWnORJuZger
   fPDNNo3tVlfNol59pdfEIx2OfIY3JBcNl3qgYd7CbbSWfw5QRREgyiJhJ
   hQ5FDod2JiwyWvbJq7SSvqjXB4+BySzZ02tZlB/A4FLe3iOJf+2Ng0adH
   Ep9s16tG7CDbIA1fakHKq11rJO+de8CKQqysdOhITM3GXDz7xeaeRhB/t
   YA87nxYPN/AFFRjDxgYICUjT6zrzGC3TVZ9BFp+rUoKEsTST/v4L7SJ1S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="381289984"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="381289984"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 14:32:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="652081806"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="652081806"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 16 Dec 2022 14:32:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 14:32:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 14:32:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 14:32:04 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 14:32:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWsPZtwFdX0zmLWRFw4Vl/JuelMPVxs/ofJbyHaVksZ1y7CSxgMA0dCj9eRTSUP492FRG7Ad7wkkq5p0iYMhkUUIlyxLw0u3pO+PwomykHLocg3e6ilIWZ5lJwlEgZNU7WZIWJd1RnuRkp/Qb5GU0Q1tZX59jg55zVnHeegv+hz2d9icLJMcx291311flHPBaWKjfcils6m/i5JDSMANp6LM/ogTmhd6O+hxBX4MO/lmgqIRk9OrKNik2rkds7OCThXcUDeNL/srKr1CTKYfI4mZOOn3JkogLcUh71AYuSdQGet56YjIC/BoGkvswJjD2TyHuF5RqzlK8ur/EluqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SblIClfOWe8cXSFKoXp2YVQsX+XO7P344+qPKjlbHMM=;
 b=eWC5/GRFHtOp5d71mr7n+pptWAtOK4vf8ReiwrQav1rF//J1e3FzwyUEw/AAxSSej+o6360b6r/1XknKHTR5mZ+z2urKtXv2POy7q4uhmksrr82WpLWXnFVAL+1fG19pUcePPG/2PNcpSBN4p1jvyTd2i+AvoOrbLF6UYUd1DBenF3FLNFPFRJUnRqs1LXlei1yUv/2zqwlUn5g1ySrrqP8rZ/03fePNuwaCbINKrIufnVYtlydmTALq/dtt0rKaXYluuF4BUokT5PhE9fPKNMv4Ht6hmI4Pq29JH8dhWC/ruZsGj6yLYrNEuuF6Ncb4/ugr3NNPDbPgDPiCKIyOyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6281.namprd11.prod.outlook.com (2603:10b6:930:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Fri, 16 Dec
 2022 22:32:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 22:32:02 +0000
Message-ID: <bb678084-7050-2731-58ee-491a2f49e743@intel.com>
Date:   Fri, 16 Dec 2022 14:32:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] devlink: protect devlink dump by the instance lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@nvidia.com>,
        <moshe@mellanox.com>
References: <20221216044122.1863550-1-kuba@kernel.org>
 <20221215204447.149b00e6@kernel.org> <Y5w3y1BU8cLAMTny@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5w3y1BU8cLAMTny@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::40) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c33e666-36ed-43ee-7f0a-08dadfb55a75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTOr9uoe06XvvMSfWEjv19Cl+cvccOOLmiGjjUYHPrU5JeyGaGnAjFCUHgR+ViIwbbtwWFv0NatkT+PEkvZdEvUu4NjHaCH7lb0LY/KoaiBJQRFqzI4/0CP5WvaKu7mbuzPEZOEUW2VvzFhAlHLOLyhG0o5eYt924TXyxzCRx24ORBKXfWnE31T8LYXPRgm+AcqhfKvgt9HULYvZZ37mR/JTxvv9sGz00IH9qoppkXTitn9oLdHByevC2+yWQ78Hqe5ApqS6y1ZO5iYEqlnTc1rSFW0Qr9JKmzPLkFrOEJjkfhKfr7QrDVlpmd8+4BFW5Um5r2yXl/x+97nNjMXZAslYyEs0yvy2F/ZvXewbRdb7xie8kOfT7ja3AmoykxwGa6zmcDmFhNCMAOb/fwPzde2HLYHPXQh/qvO3V5YoY+banr9Ygs0iawCqcM3oPdjVPw5IeNSE+ygPQww8xn6Lic+NJxyQ64BNBCFRhpc7S+PHfjcn/ZgFxdCqLtjZLUhXTyGnpwK1XHIYyx8itiEMsgF2U1vxAZ+ikDSrqDYxsgiZRAglk9VLsF/gDaIO5/azf2O7+pmLerQOkGLSMWqTKpvOucjA3S3KPlBE9D2rLfVXEVo6BD6TRANNWsCqRAKn9sa0HboeWi7MHpR/lkTnbmiAuqRApOac82yaO4SJnARNUiCZDKpI8t+dH91SBxB019QAGCQv/+o/krHH26lOzw2RxF/3l+LWRzCPLNofkuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(41300700001)(86362001)(82960400001)(8936002)(6486002)(4744005)(38100700002)(478600001)(31696002)(53546011)(8676002)(66556008)(4326008)(6512007)(6506007)(186003)(2906002)(83380400001)(26005)(5660300002)(31686004)(316002)(66946007)(2616005)(110136005)(66476007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXM1SlY5MTFnMjZGWXJHd2tmMmZuemh6QUhSTnV1Ly9qUGlNbkpqL1pxUys5?=
 =?utf-8?B?Mnp2OXlzVnZ6U1lrSHVPYnJDTjZSV09weEdxRDE3cERka2s3UVd3OVJPMXVV?=
 =?utf-8?B?ZmVRb1ZCN0dxN3FLdmVUdXZrdk1PWmt1Vnp4MmpUMWlxaWg0RStnamI2Q0pS?=
 =?utf-8?B?eWQrL1g4dHFvYXlNMDlITTZEa1pOQzJYSDRvRFpoSWQ5TVdXTVBTREYraE9u?=
 =?utf-8?B?RVFUN2dmT0U4YnpXRFFwcUw2YVhST2ZUOXlnT0RJcWxJOVFDc3BOb2hKaWtE?=
 =?utf-8?B?SGorUFdJdzI2bnN5Rjd2c1lFTlNCbnp2ZFMzVW9RRzg0WHhjcG45bUxGT3gx?=
 =?utf-8?B?OXRFbVA4M3d3dm5TZ2ljenRQNFI4RWhOdEY0czZ2bmRMcEdSMHMwUXRaVkNu?=
 =?utf-8?B?citsVjBJYVA2Nm5HTVJGai84aEE5bUVqUHRzZEtZMXNpaGpvL2pkOGhpNXJJ?=
 =?utf-8?B?TlI4eXRFWXBqeWFtb1dveEMzSUhNVUFsYS9KWUVxSG5tUzUyUU13cHB2Lzk0?=
 =?utf-8?B?NnB6MVVHSkZKNHQwWFpLK3l1UlpHSDNEQWg4QlVLaWRqSyt2OElROVMvbHMy?=
 =?utf-8?B?UHovdXlLdi80dytsTkpxMm5BY3JEbHFYSjk2azg2YUZuMnY2Y3BoejdSeVNF?=
 =?utf-8?B?UU4wRnpEcnc5K0RPSkN6UHhvVWt3bXFzUmt5d2VLYW5jQXF3U2lvMGpDTkRx?=
 =?utf-8?B?VHBmRG1xZU84R2VzeXhrTGQ3dTNnODA2dmNsVTlEN0k1aDVGdGk1Y082Vy9l?=
 =?utf-8?B?RTJpYnNJb2lwUVZreHB0L0d2K2xEUWY1U2toMWdwWENIK1RtbmNBRjRvNUJW?=
 =?utf-8?B?UUxMQjBRbFRRZHVXM0NkU2MrZDZWdzdJUkZ5WkVTa25zbnJuWTc4eHZxVjJX?=
 =?utf-8?B?R2paUCtQbC9zVDZDbXJVT0lZL1c2eVVtNlpzZ3JLcGNmU0cwUzRCcnU5aHRH?=
 =?utf-8?B?V2xPcXJJUnZCbE1WRk84YXV0ZnZHT244Q1hrNHh4eXBVeXFBYkhJV2pKK0sv?=
 =?utf-8?B?VUNUbzF5enJsSndJWDBCVzNsRlhydHVKaVlsTHZJQVRmVHJnZ1o0NVZYOXRC?=
 =?utf-8?B?RHh0emhLNm02OFhxaSszeWdlQi83NCtDTXY0SUd4cFo3OUxBU096VU9PMCtI?=
 =?utf-8?B?cHBtYjVwREszM21BRlJwbGlOOWpYSU5RaUh1U25YUnRjTyt3K3IwNXo5OWly?=
 =?utf-8?B?MlFja2daVFVGQzdObXFKYmV2cVUvMjgrMnd6em9GVGwvZXBQZmFqV1VMSnFu?=
 =?utf-8?B?dEMyOFJSWDhQSVpJemlRbFpFeVRJVTVEQ0NGcjZBNTUyaWFtRlBlN0N2TzBy?=
 =?utf-8?B?eUtTMGVkZk5NWUV3NHQ0U2xPY1RjWHVCdDBWYzRhd2VzN3JFVGRIRmR1OGEv?=
 =?utf-8?B?dU9GOHpvZWZaZkxxVDBWSklRVnRWaWoxcjZwai93WHRxT1ArY2wyaWRwMnU4?=
 =?utf-8?B?VTNUM3BBdDA2RXBVYkhtODBKVnluamdiM1RJSXdzVkhoWFhDM3FJazNNZlFQ?=
 =?utf-8?B?c3dzT3lxS0tZSEdwcVhkdEtGS1NLV1QzNDUzcjc2NWFTOUNSVVpYQkhaTFUy?=
 =?utf-8?B?U21FWUZCWUNCYUUxMEtKTG9ibytpcjhxUmFMMW5ydXp2RUFOenBCUE1xR0hZ?=
 =?utf-8?B?SEdITTZJOWhhVEx0WC9ueDEyVjlKekFvWndQeS9YREtmZ0dERXR3LzRQS3I0?=
 =?utf-8?B?RWZMN3NqcXlIUG9CUEZvYXJKZFIvSU5LcTEvb2hQN2IrM3U0cTNkaUYzMnJ1?=
 =?utf-8?B?ZDVhNjYxNTZtY3gxb2RWdGJTNE9xeWE1SFVGOUI5RTUydFM1VUZzZ3BNd3Mw?=
 =?utf-8?B?VTJoTXE3UzFqR29ZM09nTk9HUDlnTmRsVGFaSm1mU0pTdkZZWExuY3pQOHkr?=
 =?utf-8?B?MXlTZDVGZ3pOTGlvaXNnOEJxa3Mxd1hxVWd4VzcrYTBIRkYxZk5SRGpqN3hG?=
 =?utf-8?B?cS9vdFUxUG9LL3RWb1B2TlYxTVVIaSt3R0VzREovTUlON0NHUnhKWWRjelp6?=
 =?utf-8?B?QnFlelo2REJ5SnlobmlVaTVacmZoaEYvcmJJT3NrMThMTFVHWldTelpyNWdi?=
 =?utf-8?B?cmJ4SWMwQXVIL1RSbXZ1OEQrSnlpMUp5K3FhcTczV1R0VjNkbngrWGlqUmlQ?=
 =?utf-8?B?RWhhSVdablRrZ3ZEM0RoUld0VEJsQk4yNjgvZXlOeWo3emoxM24xdnpqb3Y3?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c33e666-36ed-43ee-7f0a-08dadfb55a75
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 22:32:02.7477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKZM+/3h92fVWkUrgwnUNh9M/MD8FYvE74gqxBlfWSF0MKbQ44dYNnNUVcnZeMY///wsESkU7B7jiG52G/UujLVY2N+y56LcML2ligMZ3rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6281
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



On 12/16/2022 1:18 AM, Jiri Pirko wrote:
> Fri, Dec 16, 2022 at 05:44:47AM CET, kuba@kernel.org wrote:
>> On Thu, 15 Dec 2022 20:41:22 -0800 Jakub Kicinski wrote:
>>> Take the instance lock around devlink_nl_fill() when dumping,
>>> doit takes it already.
>>>
>>> We are only dumping basic info so in the worst case we were risking
>>> data races around the reload statistics. Also note that the reloads
>>> themselves had not been under the instance lock until recently, so
>>> the selection of the Fixes tag is inherently questionable.
>>>
>>> Fixes: a254c264267e ("devlink: Add reload stats")
>>
>> On second thought, the drivers can't call reload, so until we got rid
>> of the big bad mutex there could have been no race. I'll swap the tag
>> for:
>>
>> Fixes: d3efc2a6a6d8 ("net: devlink: remove devlink_mutex")
>>
>> when/if applying.
> 
> You are right.
> 
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> Thanks!

Agreed!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
