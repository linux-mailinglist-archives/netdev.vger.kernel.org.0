Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66986A6228
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjB1WLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1WLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:11:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B0C20577;
        Tue, 28 Feb 2023 14:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677622259; x=1709158259;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B4YJ2sRPKuQ2RUdoFc7K+eKLrbn+g/RgyCsqJvJ+eTQ=;
  b=POvOrZ/i2V+00piE++N6O1r8765J2HdqlDRJKdH1B2IIN7G1Crq69sPg
   fMgTlcxvbtCEgr7aOzgiBwgBocl2GDZ6U2VAFUF4mj1prFtEryqahUdZ8
   18V6gyCS7C+nweVsND6P12+kNukbky4Ad3PJgtukvWUICTIodlyVzHEQB
   B97B0AMthhszbT4/C8YKG/cSChkYVULxr9PsK62xCc3nHJvWSUmXtNDeV
   tpHP3jzJyQVCPeBonPJ7oD2JXjpV9QDxk3J/jpnDFBYEsB6Dg0N3OGCrv
   APN5cljkVARD2VwDnJXDquzeGMCGw/IRTEv4Q/+Ob2AGhxAoCVsOk+e1B
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="322521112"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="322521112"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 14:10:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="798200655"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="798200655"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2023 14:10:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 14:10:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 14:10:58 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 14:10:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgVpzVauVpRetrZqLjJNpQwcuNVmq4e82dumxGl4rDLDZKSUzg5VBbqpVgvXVYxI9QI5a9vM3BK2YJB3fpRT6PL5tMWKqYJCpd1vUYO8qUB8qJEYy7rBzZ3PNfGQjJvjUiuE81WhkqtohddkBpj93t0MzQ0TZ+RLKVvK9QTOFacjytnMdrCEj7iYuyz4/472FyTkzlpwFYf7Wj7KoQJmQBcYJpiV5ZGpzlzMro/yK42pzbIoxE2r+2TrKxGlrrwDbn9S3CaL5grqN/GHpNWfPI+xmSNk8vEk8FmvZ+Ddo0SsGEUKi20dOT2M+G1byaLx3X7YaA9hVoRGwIKa72HFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLje5brSTDXrpFef/D4cgA+ZTUpjgUSp83pooR/gHh4=;
 b=gZDxLzzP3kES+bvX4CqTENdy88pAY3me7ZB0r0+hPl3XHWX3LV4n03JsxNnLyxHVs99ToiWd+zvvTpk0no3cjjIPoues23+8K0RZ2maOQk13RdbB/cbH7tS/rH3HsXSy5GPvNgoEJEG0cyrEcAOpsCMTy7OcWIH43iGXfoLirfeVh1jx95rvBSjsLns29zQ4sINucMxLDncEZsHzrepwJVdrPDUBUd5nBuZlw+YGpJ7rl+npd8F7GAP/Za422r5+5eALfBvn6Ca5XmiA+wnQmh9xjui8omVl9CfH33xWq2iBEwXhFN23ryNvQA159jVB8u4ZQE5+R20WjSoR6kKB7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CH0PR11MB5377.namprd11.prod.outlook.com (2603:10b6:610:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 22:10:55 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 22:10:55 +0000
Message-ID: <f7ab5942-eee2-88e4-ffac-007de0ed06ba@intel.com>
Date:   Tue, 28 Feb 2023 14:10:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Linux regressions mailing list <regressions@lists.linux.dev>
CC:     <kamalheib1@gmail.com>, <shiraz.saleem@intel.com>,
        <leon@kernel.org>, <sashal@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Igor Raits <igor.raits@gooddata.com>
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <68b14b11-d0c7-65c9-4eeb-0487c95e395d@leemhuis.info>
 <675161ac-35c5-ee5d-e96b-8e70d9d11d98@leemhuis.info>
 <CAK8fFZ6jbCYK7FFoYGJpq5oH195t+dBF0sbOr_V6k4Q8pPb_ow@mail.gmail.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CAK8fFZ6jbCYK7FFoYGJpq5oH195t+dBF0sbOr_V6k4Q8pPb_ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::17) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CH0PR11MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e56f7f-87f6-4f04-198d-08db19d8a99e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzeD/Nd2Hdxcbz6FaRYrG2Rb6Mr+VcI7qFxCQ5WHhlM5CDVvmz/UT6uOX2aiYUn/gOCUd/H7bm6ic5E4avcPyZbfv3n5LQayuuNa3FXDastfjwE8IqqMww/QIaRTTEPa81StaVsR6rWruR3FuUsbD1b+95KltcidLzxvt1GoH2cEL56OKXMc4ZLLNjAjZcEKnU/0P37OlfPuFiTFzt3aDVXCyq3vNPWeopkdd7as++ZWwiMFwIZ5ev+73gbUp1cUy+qIdpcgbbdtB2OFpz8673epd6FgyR6kOAx25wehABeJH2fovkv30NcOZ95qHh01n91YR4i/WwjAlkgvdoWr8hiOizyMk5aW41qmLTMifLu0SycG1FbnQlrTthv1uHVTx7fOFRcQpqyaBV+Rzl18Bd/ACIkRAjo0Z2WGN5wWlPFCGfJRJDxVyD4jLo5y4DbqOjA2Sq/alADkhi8jA2KgnsP0ldW2qh/NJxRKI1pPOFVOcHyivPExwjhhIUuXTmKBmDVmoN2U/5VyFCwWC1ZgcAYIm5L+hFYsTuBOsZlzmCme0e8jUiZE1VzuaFWXe50ci20ilXpXxD3mcImmyX1pWlt3z7g4BR2QkX67pDH1WtQ6zSoHPTECCLPDFZQoc0N5YQKw7qL2ys86Ow7+V81l7wn4caKgTZ2Omuju/TMSPnlW8kGlltzelKS2XhcOi6sRZuNR5iuw3n6F8aTfcdnb0vL7i3XGd4czuOoPlDTNmMldaMG1RuL3nrtXHJLv6XUL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199018)(82960400001)(38100700002)(86362001)(36756003)(31696002)(66556008)(2906002)(30864003)(8676002)(5660300002)(66476007)(66946007)(41300700001)(8936002)(4326008)(2616005)(53546011)(26005)(6512007)(83380400001)(110136005)(186003)(6506007)(6666004)(478600001)(45080400002)(316002)(6486002)(966005)(66899018)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2tNbldqcmxSS096azFaWmRLSWwwTndIcnIvWTVxVmFTSHg0cElVRGdvUG43?=
 =?utf-8?B?SjJyN2JZV0labVQ4TXhtTkhGUzZvOExPbkYvT1Z3QjlBUnkvU0RBQXlkWFpM?=
 =?utf-8?B?N1FwejltZ01SM010VDlCYkw1bk9LblpPOEIwd2NjRnhFdk1HakdCbzQrN3dS?=
 =?utf-8?B?NXptY3JNNlJhSkRXaFF5VmV2K1g4TVB4WjZOZ0lrdDNSczhkZWJqOGxwUmFR?=
 =?utf-8?B?NFhsWDFsTXNmenRDMWcyV1V3cUJCNkNDSmJZNTMwU3JnL1d6VVpHem5HUTcv?=
 =?utf-8?B?c095MEZOOEQwSlRZNzE1UlVMNXl3N2pxczIxMml3eU9nZ2pCVTQyQlU5VHZE?=
 =?utf-8?B?MWJYSzZxSGZ2bGJ1THRoVWFtYjFzQXBxUkpGT1ZhTHF1VE1GZERXODU5QU4r?=
 =?utf-8?B?dDRhb2VFWjY5NjVjcktmVHpiQXZsZHJoN3VNK29SaUVBZkpIN1lRb0JheXc4?=
 =?utf-8?B?M2kvSVlkaDN1RlhMSmNCMEYrc1pnY1B4ck1Ucm9UUDdWY29hVkoxZ2R6NXBM?=
 =?utf-8?B?NFVGVXZ2TzFFd29JaGtnKzFPdUNuemR4UFpBLzR1ZGl1YlBXVHhTdXZ1MHVj?=
 =?utf-8?B?MmR3U3hnMWxMTmp2WmdyOHJET08vL2Jmc0xjU040Q3VyU3lqdW10MFBLOTVW?=
 =?utf-8?B?NndJL3hnckJla3Uyak40V05GTU9uRElpSkhRaTU4VXpocEtPbUVEd2huM09t?=
 =?utf-8?B?d2xtUmVTQVlnMlI3NHV0WGozM2p4Vmo4d2xncXZYYTI5N21QV2E1RzNLTnVa?=
 =?utf-8?B?THBWOUNJYytZaUlOd3RQK05BT1daV1RTbjVkQUZkWWRYQ3ZCeGFpV2FDSDFH?=
 =?utf-8?B?L3JQUVo3cGlUZThNb1dxdUsxd05YYUdpT3liRmFJL1BRY3BNUFpZTkVWcWJo?=
 =?utf-8?B?NWtSbUI4bkZiM0lKTVZBMTFSK2MvdmFWQkdhQnFlQmhvM3RmZUpkTUNDSjNH?=
 =?utf-8?B?N3Q5bm5uZzlUSFZWd2M2ODlmb0hFcUF5VTJSMlUzMzd3c0k0NE1MdTZGZjJR?=
 =?utf-8?B?c04yYnZld09DZzhwZTJzSkg2QVlJNkh0c0ZzOVJPYnJJVi9SM3gvTVE2RGlo?=
 =?utf-8?B?NFN3TE50NXplSkVUY1VET3E2YkcrMkdoOTJ4K0hIS1BlbVlZcUZNU0NtMXNZ?=
 =?utf-8?B?Tmx5UUJJVitBbHhUYU9FeDhTWmdBbE4zQ1IrWDRMSEtGMnFtVFd5S0YzNnl1?=
 =?utf-8?B?Zm03VldlbkpXUGNkSWhuaXBHdXArWmV0YzNYVXFLQ0pLRVg1aU9uWElkSFl4?=
 =?utf-8?B?Y1hLMG41aFFCbEZnRENiMDZYZ3BPTG84czM0UEtZSEJWUk5jT2ZncGIwelh3?=
 =?utf-8?B?VEc5djBOYUhobUZHQkxrK1p5NjR0WjlQUXdRYVZFVktPaXkvc0JqT0xEY2hn?=
 =?utf-8?B?cWJscXZ5YUxWeDZYMVYzejZ1NGhwOStCM1dJelRuWmR2Q2JuNVNhakwxWXNV?=
 =?utf-8?B?M0FndHFQUlZOV3oyL1hBaG03LzhLa1NrRVptczR3TUpWejNBaVJmRWw2cVFD?=
 =?utf-8?B?NVdhQzlqcng5YnN5aFhuNlJ3eU14RHMrVWUzMFpsSUtkSVJDU2FrbHVEVnZ3?=
 =?utf-8?B?Mk54ZlZvREtvUXVQUDQ0UUc0ajBqS2RXUDRUZWppNTQ0NDY5Y2lRZndYckRx?=
 =?utf-8?B?dm96cUdhMkxQZXRMaXdld2dBbHJsV2M1SEIvT0h2UCt3OVRyaHYrc3dDZ1c0?=
 =?utf-8?B?bnFOa253WEdLSW5qOTNSbU5jWExlNHVacndrM2g2anp2dTlXNFlrWnRoVW1n?=
 =?utf-8?B?aXRaVUdKSENoN25pSjBHZFRWQVBMVklBV3RTSlA4azNFeEhIVWV6cmlDaEds?=
 =?utf-8?B?ZWVqdUNPbVYyeXkwQkwwU1BtMkYxR0dQM2paNjNPdlEzZE80YUJGYzZCNTVL?=
 =?utf-8?B?TlpsNDhtclp3ZnY4YUZQRUtzZlVPQWNaelFCRXBXMFZWMTdwUFJpLzYzaWc4?=
 =?utf-8?B?TzJqS1I4bnpyY3FQdVNra1dTakZUNjFDbXNTSURrQ21SckNZdUxEVENOS0s1?=
 =?utf-8?B?VGhRdFNNQ3ppUnowRFZJUFgrdm9LdjZsQUo4OG83eUVRVGZQeTNZV1A5dlpH?=
 =?utf-8?B?VEhRZVBBWkRVZkFOT0FHN2t5UVpSZ2RJMjhUbXpVOU9PV3RVTDY1WEdYZUpu?=
 =?utf-8?B?NGtLd1NLV1E0eldkbHBUWlpXRXlLaDA2bzhZL2RaSndlaHhaUzhYS0FZVE5Z?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e56f7f-87f6-4f04-198d-08db19d8a99e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 22:10:55.4585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJmHQCFKjm2lTDNuXFs1EZ1yrG66es2n+Oz3lNA50iHFJOaPb36zKh072UdVCMTS0IUhYFwuL8x5d4Ddovf8+T7bDxin2DDkqbJMh9E9R3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5377
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/2023 4:33 AM, Jaroslav Pulchart wrote:
>>
>> Hi, this is your Linux kernel regression tracker. Top-posting for once,
>> to make this easily accessible to everyone.
>>
>> On 06.01.23 12:11, Linux kernel regression tracking (#adding) wrote:
>>> On 06.01.23 08:55, Jaroslav Pulchart wrote:
>>>> Hello,
>>>>
>>>> I would like to report a >= 6.1.2 some network regression (looks like
>>>> NIC us not UP) on our Dell R7525 servers with E810 NICs. The issue was
>>>> observed after I updated 6.1.0 to 6.1.2 or newer (tested up to newest
>>>> 6.1.4-rc1). The system is not accesible and all services are in D
>>>> state after each reboot.
>>
>> Can anyone please provide a status on this? It seems to take quite a
>> while to get this regression fixed, which is unfortunate. Or was
>> progress made somewhere and I just missed it?
>>
>> I noticed Tony tried to address this in mainline, but the last thing I'm
>> aware of is "Please ignore/drop this. Just saw that this change doesn't
>> solve the issue." here:
>>
> 
> FYI: We are building 6.1.y with the provided patch to fix the
> regression in our environment.

Thanks for the input Jaroslav; just to be clear, are you using the v1 
[1] or v2 [2] of the patch?

We're doing more testing on v2, but I was going to reach out to you 
afterwards to see if you would mind testing the v2 as we haven't heard 
from the other reporter who said v2 didn't work for him.

Thanks,
Tony

[1] 
https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/
[2] 
https://lore.kernel.org/netdev/20230217004201.2895321-1-anthony.l.nguyen@intel.com/

>> https://lore.kernel.org/all/b944d1d4-7f90-dcef-231c-91bb031a4275@intel.com/#t
>>
>> Should the backport to 6.1.y (425c9bd06b7a ) maybe be dropped to at
>> least resolve the issue there until this is fixed in mainline? Or would
>> that cause a regression as well?
>>
>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>> --
>> Everything you wanna know about Linux kernel regression tracking:
>> https://linux-regtracking.leemhuis.info/about/#tldr
>> If I did something stupid, please tell me, as explained on that page.
>>
>> #regzbot poke
>>
>>>> [  257.625207]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
>>>> [  257.631911] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  257.639740] task:kworker/u192:1  state:D stack:0     pid:11
>>>> ppid:2      flags:0x00004000
>>>> [  257.648095] Workqueue: netns cleanup_net
>>>> [  257.652029] Call Trace:
>>>> [  257.654481]  <TASK>
>>>> [  257.656589]  __schedule+0x1eb/0x630
>>>> [  257.660087]  schedule+0x5a/0xd0
>>>> [  257.663233]  schedule_preempt_disabled+0x11/0x20
>>>> [  257.667851]  __mutex_lock.constprop.0+0x372/0x6c0
>>>> [  257.672561]  rdma_dev_change_netns+0x25/0x120 [ib_core]
>>>> [  257.677821]  rdma_dev_exit_net+0x139/0x1e0 [ib_core]
>>>> [  257.682804]  ops_exit_list+0x30/0x70
>>>> [  257.686382]  cleanup_net+0x213/0x3b0
>>>> [  257.689964]  process_one_work+0x1e2/0x3b0
>>>> [  257.693984]  ? rescuer_thread+0x390/0x390
>>>> [  257.697995]  worker_thread+0x50/0x3a0
>>>> [  257.701661]  ? rescuer_thread+0x390/0x390
>>>> [  257.705674]  kthread+0xd6/0x100
>>>> [  257.708819]  ? kthread_complete_and_exit+0x20/0x20
>>>> [  257.713613]  ret_from_fork+0x1f/0x30
>>>> [  257.717192]  </TASK>
>>>> [  257.719496] INFO: task kworker/87:0:470 blocked for more than 122 seconds.
>>>> [  257.726423]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
>>>> [  257.733123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  257.740949] task:kworker/87:0    state:D stack:0     pid:470
>>>> ppid:2      flags:0x00004000
>>>> [  257.749307] Workqueue: events linkwatch_event
>>>> [  257.753672] Call Trace:
>>>> [  257.756124]  <TASK>
>>>> [  257.758228]  __schedule+0x1eb/0x630
>>>> [  257.761723]  schedule+0x5a/0xd0
>>>> [  257.764867]  schedule_preempt_disabled+0x11/0x20
>>>> [  257.769487]  __mutex_lock.constprop.0+0x372/0x6c0
>>>> [  257.774196]  ? pick_next_task+0x57/0x9b0
>>>> [  257.778127]  ? finish_task_switch.isra.0+0x8f/0x2a0
>>>> [  257.783007]  linkwatch_event+0xa/0x30
>>>> [  257.786674]  process_one_work+0x1e2/0x3b0
>>>> [  257.790687]  worker_thread+0x50/0x3a0
>>>> [  257.794352]  ? rescuer_thread+0x390/0x390
>>>> [  257.798365]  kthread+0xd6/0x100
>>>> [  257.801513]  ? kthread_complete_and_exit+0x20/0x20
>>>> [  257.806303]  ret_from_fork+0x1f/0x30
>>>> [  257.809885]  </TASK>
>>>> [  257.812109] INFO: task kworker/39:1:614 blocked for more than 123 seconds.
>>>> [  257.818984]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
>>>> [  257.825686] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  257.833519] task:kworker/39:1    state:D stack:0     pid:614
>>>> ppid:2      flags:0x00004000
>>>> [  257.841869] Workqueue: infiniband ib_cache_event_task [ib_core]
>>>> [  257.847802] Call Trace:
>>>> [  257.850252]  <TASK>
>>>> [  257.852360]  __schedule+0x1eb/0x630
>>>> [  257.855851]  schedule+0x5a/0xd0
>>>> [  257.858998]  schedule_preempt_disabled+0x11/0x20
>>>> [  257.863617]  __mutex_lock.constprop.0+0x372/0x6c0
>>>> [  257.868325]  ib_get_eth_speed+0x65/0x190 [ib_core]
>>>> [  257.873127]  ? ib_cache_update.part.0+0x4b/0x2b0 [ib_core]
>>>> [  257.878619]  ? __kmem_cache_alloc_node+0x18c/0x2b0
>>>> [  257.883417]  irdma_query_port+0xb3/0x110 [irdma]
>>>> [  257.888051]  ib_query_port+0xaa/0x100 [ib_core]
>>>> [  257.892601]  ib_cache_update.part.0+0x65/0x2b0 [ib_core]
>>>> [  257.897924]  ? pick_next_task+0x57/0x9b0
>>>> [  257.901855]  ? dequeue_task_fair+0xb6/0x3c0
>>>> [  257.906043]  ? finish_task_switch.isra.0+0x8f/0x2a0
>>>> [  257.910920]  ib_cache_event_task+0x58/0x80 [ib_core]
>>>> [  257.915906]  process_one_work+0x1e2/0x3b0
>>>> [  257.919918]  ? rescuer_thread+0x390/0x390
>>>> [  257.923931]  worker_thread+0x50/0x3a0
>>>> [  257.927595]  ? rescuer_thread+0x390/0x390
>>>> [  257.931609]  kthread+0xd6/0x100
>>>> [  257.934755]  ? kthread_complete_and_exit+0x20/0x20
>>>> [  257.939549]  ret_from_fork+0x1f/0x30
>>>> [  257.943128]  </TASK>
>>>> [  257.945438] INFO: task NetworkManager:3387 blocked for more than 123 seconds.
>>>> [  257.952577]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
>>>> [  257.959274] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
>>>> ppid:1      flags:0x00004002
>>>> [  257.975446] Call Trace:
>>>> [  257.977901]  <TASK>
>>>> [  257.980004]  __schedule+0x1eb/0x630
>>>> [  257.983498]  schedule+0x5a/0xd0
>>>> [  257.986641]  schedule_timeout+0x11d/0x160
>>>> [  257.990654]  __wait_for_common+0x90/0x1e0
>>>> [  257.994666]  ? usleep_range_state+0x90/0x90
>>>> [  257.998854]  __flush_workqueue+0x13a/0x3f0
>>>> [  258.002955]  ? __kernfs_remove.part.0+0x11e/0x1e0
>>>> [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core]
>>>> [  258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core]
>>>> [  258.017959]  ib_unregister_device+0x22/0x30 [ib_core]
>>>> [  258.023024]  irdma_remove+0x1a/0x60 [irdma]
>>>> [  258.027223]  auxiliary_bus_remove+0x18/0x30
>>>> [  258.031414]  device_release_driver_internal+0x1aa/0x230
>>>> [  258.036643]  bus_remove_device+0xd8/0x150
>>>> [  258.040654]  device_del+0x18b/0x3f0
>>>> [  258.044149]  ice_unplug_aux_dev+0x42/0x60 [ice]
>>>> [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice]
>>>> [  258.054038]  ice_lag_event_handler+0x51/0x130 [ice]
>>>> [  258.058930]  raw_notifier_call_chain+0x41/0x60
>>>> [  258.063381]  __netdev_upper_dev_link+0x1a0/0x370
>>>> [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
>>>> [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding]
>>>> [  258.077517]  ? nla_put+0x28/0x40
>>>> [  258.080756]  do_setlink+0x26c/0xc10
>>>> [  258.084249]  ? avc_alloc_node+0x27/0x180
>>>> [  258.088173]  ? __nla_validate_parse+0x141/0x190
>>>> [  258.092708]  __rtnl_newlink+0x53a/0x620
>>>> [  258.096549]  rtnl_newlink+0x44/0x70
>>>> [  258.100040]  rtnetlink_rcv_msg+0x159/0x3d0
>>>> [  258.104140]  ? rtnl_calcit.isra.0+0x140/0x140
>>>> [  258.108496]  netlink_rcv_skb+0x4e/0x100
>>>> [  258.112338]  netlink_unicast+0x23b/0x360
>>>> [  258.116264]  netlink_sendmsg+0x24e/0x4b0
>>>> [  258.120191]  sock_sendmsg+0x5f/0x70
>>>> [  258.123684]  ____sys_sendmsg+0x241/0x2c0
>>>> [  258.127609]  ? copy_msghdr_from_user+0x6d/0xa0
>>>> [  258.132054]  ___sys_sendmsg+0x88/0xd0
>>>> [  258.135722]  ? ___sys_recvmsg+0x88/0xd0
>>>> [  258.139559]  ? wake_up_q+0x4a/0x90
>>>> [  258.142967]  ? rseq_get_rseq_cs.isra.0+0x16/0x220
>>>> [  258.147673]  ? __fget_light+0xa4/0x130
>>>> [  258.151434]  __sys_sendmsg+0x59/0xa0
>>>> [  258.155012]  do_syscall_64+0x38/0x90
>>>> [  258.158591]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>> [  258.163645] RIP: 0033:0x7ff23714fa7d
>>>> [  258.167226] RSP: 002b:00007ffdddfc8c70 EFLAGS: 00000293 ORIG_RAX:
>>>> 000000000000002e
>>>> [  258.174798] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff23714fa7d
>>>> [  258.181933] RDX: 0000000000000000 RSI: 00007ffdddfc8cb0 RDI: 000000000000000d
>>>> [  258.189063] RBP: 00005572f5d77040 R08: 0000000000000000 R09: 0000000000000000
>>>> [  258.196197] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffdddfc8e1c
>>>> [  258.203332] R13: 00007ffdddfc8e20 R14: 0000000000000000 R15: 00007ffdddfc8e28
>>>> [  258.210464]  </TASK>
>>>> ...
>>>>
>>>> I bisected the issue to a commit
>>>> "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the
>>>> correct link speed). Reverting this commit in my kernel build "fix"
>>>> the issue and the server has a working network again.
>>>
>>> Thanks for the report. To be sure the issue doesn't fall through the
>>> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
>>> tracking bot:
>>>
>>> #regzbot ^introduced 425c9bd06b7a7079
>>> #regzbot title RDMA/irdma: network stopped working
>>> #regzbot ignore-activity
>>>
>>> This isn't a regression? This issue or a fix for it are already
>>> discussed somewhere else? It was fixed already? You want to clarify when
>>> the regression started to happen? Or point out I got the title or
>>> something else totally wrong? Then just reply and tell me -- ideally
>>> while also telling regzbot about it, as explained by the page listed in
>>> the footer of this mail.
>>>
>>> Reminder for developers: When fixing the issue, add 'Link:' tags
>>> pointing to the report (see page linked in footer for details).
>>>
>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>> --
>>> Everything you wanna know about Linux kernel regression tracking:
>>> https://linux-regtracking.leemhuis.info/about/#tldr
>>> That page also explains what to do if mails like this annoy you.
>>>
>>>
