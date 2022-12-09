Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC448648819
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiLIR7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLIR7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:59:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1171A934F4
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670608744; x=1702144744;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Loc5lr+E4dF2ysuYff7g1G59VbZDJQst0ZJqbZ6ZMwo=;
  b=biiaavFKGEhWWnCesjQQW7bbv+aDfy0ircqb+OP4XTEwnUPuK3RpvcV9
   Gh8vPwQTm88vYnp6u1NTq6e1lUlMZBlSxmrDP6Dn63YYNS1YqXt5suOih
   jQ797luewfz7R9LeY5Vlg8TmvhDZNkqNqA0Qj/jseNVKXySFq5Bk5popW
   +JveFpsQZ2wPWhTcURIV8quSeqcwEVZSPg3UlxQQDJEpSDugsBWehFIAD
   wSLsT4WtbtZtJVaf0DQuhGsUSpwZrCL5CzW3T+NlJVrk5Hn9zRkPZpFXN
   NVDOWb7GcnJkjcgz7rIiHq/HLCQP/TT7vLzf37LOKKYZph0VrKL8V8vAg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="297867422"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="297867422"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="649626520"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="649626520"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2022 09:57:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:57:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:57:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:57:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpYEqZd7Q2PkuL/di3EXr+Jhi8As06nqL09IBLcxJLyzPmDrQmOSOfj4AArSad9nwi/XmvQhQpWY3Olz9SpienZLVrEp347iDbOaagghcX0JlbYQmGhy9ZtD9zq2bomKfYURU5S1IVTlRelYGwi+3g8yFu6vx6gyt2MALuIuJUISyEP4gXPJxcMA/gdUOJ9wCYQ0agkmFgaon2YD1oDMNtvIKWKcEN5MWNECb8wm76G55t1p3Bt874vKLHNIcpT5PLGLdFiU8dPRWCeEib7JuIQAl8EEziJEBY3XbTCmII/4Iv47BQFZvJlMEPa5V3f4fSoWInUFWeKgd/ge8wcYSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+lSlgVeC1hUac/jqBg+kLk6w7KXyWwp3zfImBqZyDI=;
 b=kCxk7jCUvjM2NLt0WIeNIiL5eapkgWm1LZZTzy37Z1maosl9TQ4bv6/Vz9QPl0idSpv04VBR6W03Gr1HytVdHqh0M/Sy2oIaZKkTwoY6iwxS1h7yPn8MINQGNX1vN3VYjYfQ+si2Vl5quxFgb0LO4cXYCambXLToAA6qqDa+PTLfxTFj9nKFX6kz6+P+ZCf82rPLl4IcUF3nkufIPG75HsgqjxG85mM+XDSpmmQdqaKj+Ya6PQP9p7KRMAQWQ0nbC5svzhvCO3urxQGVoBgcIb1fXKv9z7PiQMHCfVP3VdoyA1xzCJyH6TnA+ZircgF/L21PDaLEgPtUdxMnWMBOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CO1PR11MB5060.namprd11.prod.outlook.com (2603:10b6:303:93::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 17:57:15 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5857.023; Fri, 9 Dec 2022
 17:57:15 +0000
Message-ID: <b0514e8c-5216-adf5-cf15-b120eaee8863@intel.com>
Date:   Fri, 9 Dec 2022 09:57:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [Intel-wired-lan] [PATCH intel-next v4] i40e: allow toggling
 loopback mode via ndo_set_features callback
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Rout, ChandanX" <chandanx.rout@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
CC:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "tirtha@gmail.com" <tirtha@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
References: <20221118090306.48022-1-tirthendu.sarkar@intel.com>
 <Y3ytcGM2c52lzukO@unreal>
 <20221122155759.426568-1-alexandr.lobakin@intel.com>
 <MN2PR11MB404540A828EDDE82F00E8E2BEA1A9@MN2PR11MB4045.namprd11.prod.outlook.com>
 <CAJ8uoz1RjaGv=HEwmaZw1hKH_GpHA9u-sBvz-Cxb0W_wdYjDZg@mail.gmail.com>
 <CAJ8uoz2_s_hyYZaPt15a9c274UXC-8Ejc2nPAmqMN9437fcciQ@mail.gmail.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CAJ8uoz2_s_hyYZaPt15a9c274UXC-8Ejc2nPAmqMN9437fcciQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::35) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CO1PR11MB5060:EE_
X-MS-Office365-Filtering-Correlation-Id: 11478a95-3968-454b-49af-08dada0ece46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZmqDiodu6F74l3YyyfGLMP2cl4kFUg5j56GP69rfs4iH4Qx7Mv0u47fBQqzCpLNclD7UcNqqOgMEVpbz3JEfQDAE//1uimh1ynzz340/cv1kIP/NpdARHr3DrvL+TeHp5E1dtMZCtmkP5Npx9hdNqhn9FeuBEWuWDxgbNjtOYZQdLlqIMyxPor6As5oOuwxhPv+lIGpj4oNUSxs753KJ2EXfWZ0BbUx+jmfUg9PEXF7YiedOWXJmR+cfPc28LtL9ARhTHOVjjaI/f9jBeIHfWmTl0txgjcxhJuocABx8PR+WTkrF7j93vsjIRtRPRNYGVHn3Ho9e0bsa/vfNbcgzslvMzrssuak/bWpYGDrVaRX9PbzohUNC/pwoWE0tw1/7zSK4OZbWVK263udW15cdkvndDUBNGxIBMPUbrq/t7Ivy3qhpY1BcwzPVEsQfpkJH58wiw1q6WBj8Bu1I1aiwyOX2pGwBiCeZnAMnYEe8mnZEiANhD5tiD6vYan9Oo0cO/KFbU+hXHFLSaqsQmK9axl15e14XPmlEaGFDUuwaLexmPCRDIZxyfZILxPnhBIDgJlq7FzyAtDm+FxCb/dkUK3tcDOJFpozPPE4o1tSpMUpJaEIIzK4jO82hHqCm/6dKCgs4qrzZRo2QPMSr3rbONJaRwTnP7UduYGTaKaf5YbBD87H85YJr6Wza5eh1r2RWelVtdV9rvak45Sw2awDBzWEzheDCVz2W8kHaGxHr/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199015)(66556008)(86362001)(8936002)(4744005)(36756003)(31696002)(2616005)(41300700001)(54906003)(107886003)(83380400001)(6512007)(186003)(6666004)(478600001)(6506007)(26005)(82960400001)(6486002)(53546011)(5660300002)(110136005)(38100700002)(4326008)(316002)(66946007)(31686004)(66476007)(2906002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkpVQitOSjRZZ2pYS1dnRnhKMzZQQ0ZMZldGaHQ1cUtFTlBLOS9zVjVMNGRV?=
 =?utf-8?B?VFd1WnNhQkhRelBQM2tNbzhEQzVGcjliQXA1VGkwTzh3QUF2QjYyZDZlM1l4?=
 =?utf-8?B?YmFXYXNRNnhYRnI4eWZ5MGhWeG81NWhzK1VJbmkzdk9XaDZiQ0YwdEZ6ZWxE?=
 =?utf-8?B?ZU52T1ZQTEpqRDNSUFQ1T2N3M0liVG54VnhSeHVRUjNHYm5NT1FiSlo0Y3gx?=
 =?utf-8?B?VDFIZmh1M1pmV3RFTUZqeG1CQXE2TkVaMWhxRzIrTzcvNGpGZzAyb3NOb1ZD?=
 =?utf-8?B?S2VEWVZoUUFpS2x3SjRCY0RaYTJhK3dJTHZIcUhscU9ob1VGN0I2eGo3S2JO?=
 =?utf-8?B?ei9mMWVsZGR5MWtnWktTY1djMGZZZzUxNnVPeVpaZUpHVzgrTytFcGJSWTN1?=
 =?utf-8?B?UStMUWRPbGxxV091WlUwT2tFSEV2T0RCamxyYTBSNmNsSzIxbkdCWStuakYv?=
 =?utf-8?B?OXh5aWRzQ1oxL1ljL2QwZ0hmWFVsVGZuRklWU2djd2JxWjBRcSs3MmoxTnFx?=
 =?utf-8?B?bkx1UHpQUlZWMmhkTUx2SzBoTGlvUjF1WWRFOFJMYk9IVkpuUWR2bjhyNjdJ?=
 =?utf-8?B?ZjVvQ1dpMGtFLzd0c0lYNjlIb3pCS2V4MkN0ZVFSNGFNUWVhS2Q5OWduY214?=
 =?utf-8?B?Y05XZUJ0Z2lSMUZQMERZQ1V6bjBNTkJTZVl4NzBOeVhhSHZPT2RsSktqL0Qz?=
 =?utf-8?B?bU9CSlVxekZEcjVkeXF3TENQUjROSjFBYytRcWtHTUFmSVdUUlNYRDJTS3VS?=
 =?utf-8?B?TlVWYXRCRFgrUWtCdUtsY1gyN0NjMmFuRUlRZWdoNVhlQ1owV3czc3JhbTdO?=
 =?utf-8?B?OHFodmdMcEsyK25jMCtwZTluWW41N3lIOUZSdkdYK1Fqc0hydHRoT0Fnc0dm?=
 =?utf-8?B?WnZmNnlRY2tsdWFVVEpBYTB3WWpKRWI2N2U0bnVISkdxcEhxejFZZTZNeU1D?=
 =?utf-8?B?OElpWGF6UFlFdzYvbno4c3pvbDhZN1pNQkVIaDdEZy81aWQ2U0JJQVRQMGJM?=
 =?utf-8?B?T1NGVVJaNXhmSEZlZU5qNHBtT2NqVGo0SUZFcURoc3NmdkpNTGljOVROWUQy?=
 =?utf-8?B?MzliZGVNenFvb2ZzaFRkOThEK29DNEN3ZGRPTFZESEJxOExpelAyc0FLWC9F?=
 =?utf-8?B?VkFUUmV4bXJBUVNDS0ptQnVER2RzaHJzVzlIeHR1cEkzU3gvSGRxdVhwTU5S?=
 =?utf-8?B?V2w0NHVnNldsTFFjS0oyWWRiOEoxTm1aWUZJK0xXRkRGZkE2cmt1ekFXckln?=
 =?utf-8?B?bFVacUN1bHlrTTJUbVd5bk5sMUp3SC9WRXJQT0Nvekk2Wk9kOUdVc1U3TndP?=
 =?utf-8?B?b1NVQzZvZFV3SGV0dmFBUmxZK1prSmM5NHM4VndlSEZvbUlQK2pSL3kvQkts?=
 =?utf-8?B?eTlIWnJRMGYxTDJwRUsxZWU5TUhPd0kxRDdHdjBZNEVIK3NkTEVVekpoVndj?=
 =?utf-8?B?c2hhdWllZW5EdDhVQTgwSEdkSTcvanJRYTNjVm45OXZNdkt4cVczTm45dDRi?=
 =?utf-8?B?MW1YM1FTMStqdEFQUFM2YWxGbVZDV0Q4NDYyL2pGTk9vZGdaNjE1Uk1jVWNN?=
 =?utf-8?B?T3ZYcmIxOHNuRjdhdlJRMUo4czRoNnhDYWo3RGJONVFXcENJaEQ2M3dxT1BC?=
 =?utf-8?B?TE5XbWFNUzJaVkdTT2R1Z016VXhVT3MyUElkU3AybGRxc2hJRVczYVVISHgw?=
 =?utf-8?B?ZlFBSmJBMFdDd3IyMWZ0Ymd3WURiWkRESWptZnFJYUNkWDJBbDZiK082WGdm?=
 =?utf-8?B?RXhyUmZHV21JQkdKWXJQSWJpSmVGZjE0YUtkRHFSQmFhMkZVbDloaU05d1lW?=
 =?utf-8?B?TmFTV3Z5NlhQbGFLb1BuR3N5RyswTGtzMURFQlJua0RUbG5Falk2NTI0Tnp1?=
 =?utf-8?B?SHNaV0d1Y0k0cDRZR2pSQ3BXamtCMzBUMHU5cFp4MURGYm5Fa01oT1VRbGVq?=
 =?utf-8?B?WHd1Rzd6d3hBUVlvY0xoYkh5eCs0ejA0QzlzU2ZYV2JTRjBEdkp3bkJYTlRW?=
 =?utf-8?B?anF0cEFSTXZwTVFicUhyRUlYMHIvLzR2K3RTSWViVDd6eWxDV0l1SGw5bmVw?=
 =?utf-8?B?UHZUZFVkMGthaW1QTFdlYzFjSGZ4SEorMFF1SlZ4UjVQMzdUM1VlN1cvWFBC?=
 =?utf-8?B?elIrdFR0ZTZkNVBoOGZ0SW81TDMvTDFPZlczUnNDanJrd1NrOFJsc0UvVUFk?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11478a95-3968-454b-49af-08dada0ece46
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:57:15.3487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53GnGGAgBBX+a+3WYSLUqWFeaZLTTdlfCZdLp1gCq/hg/NOIQ9LmdQKtFMcPwxXKOWmichYZeXxx7OI4TmEq9rT3DzWz8h0RNtJzWDtg3FA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5060
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/2022 1:09 AM, Magnus Karlsson wrote:
> On Wed, Dec 7, 2022 at 4:37 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
>
> I have now tested the patch and it passes all the tests executed by
> tools/testing/selftests/bpf/test_xsk.sh. The script launches over 100
> tests that send 1000s of different packets through the loopback
> interface and verifies that the packet content is the same as what was
> sent and that they are received in order.
> 
> Tested-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Tony, please pick this up for your next i40e pull request / release.

Sure. Besides this, I don't have any i40e for net-next currently, but 
I'll send this one out later today to try and make it in before net-next 
closes.

Thanks,
Tony
