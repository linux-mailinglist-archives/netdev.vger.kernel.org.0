Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9DD442715
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 07:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhKBG1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 02:27:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:29681 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhKBG1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 02:27:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="211246090"
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="211246090"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 23:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="599336172"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 01 Nov 2021 23:24:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 1 Nov 2021 23:24:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 1 Nov 2021 23:24:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 1 Nov 2021 23:24:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6R72oEbl1Jfj2EPkD+HbFKQjBy5NjCo4Jn83bXpJYeKj4pfPyUVFpGnDb/C4SIRCk9gYh1iBhMmlD35dQ3ue+m5tHj/8yB+/ddrJjz6GoLJ9UsoYMLk//YLODT1uijVBX2wBkHw8vkfDRy+Id8U38pWuvE+676RScldagCOANjEjLLAAb/5u5ar8pLc6WnzDjOYlizTJik9ZTq+VTLatIgDTRpoNBWhAz2GerXMxtx8bzeVTXjE6XlUZoS/jg/7Tsbh4meLArlAbPS/8lKCZASGL+I98jE3c4g6/iTn5LyTjbWoma7JK5ERh1585IM3pFcGNu0uAuM/Jvafs9GsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8L3jJwGD/3Lz25TpM8uL+hO2oFUOFqnE5v9d1JFlEPA=;
 b=Npu7toI4juidaDFJGjLxdwQJGbiEtmvYaaCnP05mqHWoVWSJsHOEVRacYf0kQRT0O2d3pSol/CKXngmehG3lRTQAzel6aYniPzYq4rGkt+lflpFOe07bsXxzROEFh17K9xWF8I/HwCxhnFhYQBzR4400CMEOII3Mq2YmGKrapds1twX+sHvpVf1UgAkV+svYMiJeXiOlgi9Ci3Apj5JGrSNbeqSL3MHLIJH4sge5DzWo5sYI2Rk3EPcU5jmuZqFngQmWf8V3XdYGq8al2l97zs7lyxUXFkN0ueVd5C+GJycSGKWISfAYoOrw1/vehyOzVJWd4nkvCe3h9eIggaDxPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8L3jJwGD/3Lz25TpM8uL+hO2oFUOFqnE5v9d1JFlEPA=;
 b=bVTTWyK+D/EWGHScmPoeZX/dYxrD6/6Dowj21PCemwe8NDYTdyYOYBiKanLSuBwb+S48l26+y0JCs8h20sRvkzJ/u0XxwfLy1P5wy04PUVvtZjP+0OAOkKw6wL3X3MuAZ6o3TOPo+gjXuhZjW0jFEQqNDokcCgC+x78tl3JNYvs=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MW3PR11MB4668.namprd11.prod.outlook.com (2603:10b6:303:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 06:24:17 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d%7]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 06:24:17 +0000
Message-ID: <49c5e91a-8e02-2a76-db5d-5f15df3c485f@intel.com>
Date:   Tue, 2 Nov 2021 08:24:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.1
Subject: Re: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when
 DPG_EXIT_DONE is already flagged
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Dima Ruinskiy" <dima.ruinskiy@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
 <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
 <CAAd53p69k-2PVw5RpJOAbe=oBh11U_UqzsyMjxHFbo7xqNBDsQ@mail.gmail.com>
 <f6a4d53a-3ec8-b5cd-9b6c-b14c69d20248@intel.com>
 <CAAd53p67dehgizx1h0ro40YRmKNsbv3Ve=2987kyMUKs7=LOpA@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <CAAd53p67dehgizx1h0ro40YRmKNsbv3Ve=2987kyMUKs7=LOpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR0202CA0072.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::49) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [10.185.169.41] (134.191.232.48) by AM6PR0202CA0072.eurprd02.prod.outlook.com (2603:10a6:20b:3a::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 06:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 504902c6-fab0-4453-f023-08d99dc965c9
X-MS-TrafficTypeDiagnostic: MW3PR11MB4668:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW3PR11MB4668E25549AE20B6DF937AAF978B9@MW3PR11MB4668.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5O6EGTc/wklx9wV+V/vUvSrUqecoDF3ISrmrsFFIYzJSQ1j+vGrbTZEv9Ojy5Rmu8P+74aYD8cMfWEWupt3rCmQCVFB8v7fps918sL49t5tq74Tx33NIBmu1XKFLqKnaaZbyrSKP2VsdAB7g4hLNdbEOo09/4niDAzPSnLrQx2xSlTMXkSYrrw2I00Ff2Yzde8XPKl1TTIqnQWzzCsjKYMl0GeHH1ARPQnPONZ2DvMtGKZrwFhGxVgIOuk/qQWi7p4y79zzZmwkNvlNMNI5VwIFlI0b08YmtqmvlYGCS+/rT28eo16Hgy0xfmKXFq/q3kRhV/hP4cXoK/vItLF/nkOpDOQwJ9Jef5VSznCpSnwieoMHtk0iwzQWl7dvgdfk+3s+JmAouEj+AfnKZxGA03UMdfWDdJbzHoAjs3A5ZQcmzh5aTVCIUj70O6tT1znxj+ycyVKBhQrK9cjxyIXrqQzWft8Et9D4H2xqG2ZnuFLyjHKUmM0l59TKP1c//zHGT9D5FCoI7tcIQwwI2iEObr7tbm1JwbhCHmBr34U5WHLIP2ytQD3eDcCjCiV7Vbu6Ws249olIZOXpeB+dwW07vkXwt/2bApzloSsTG3mVXcP3xjAFZCehpQNf7n1igthqux0d4Fm/lVUVTlKCTzwpbf2JKrdZ0owh7uOIEf/NQ2pO8xhDPY/6+zkyHpvtAZg1g6T5JkZjGtID36Ii7MbirVGGcn6hdDMfORfKGiHKDKjwv3Kntk3v3V+siJ7uDaHPrc1m+nXjjfjiOqd2nRUFAvZ6bj6ixExhOZz1+sBjTssdj0Unxx43ivL5bfcGgeHsLwGS9pkcv3ZgVuaogrKdFj8aBsqQ1fzYPa8jdu0ISOLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(5660300002)(82960400001)(186003)(4326008)(2616005)(956004)(38100700002)(66556008)(66476007)(83380400001)(6916009)(2906002)(6666004)(53546011)(66946007)(36756003)(86362001)(31686004)(16576012)(26005)(31696002)(8676002)(8936002)(54906003)(316002)(966005)(508600001)(6486002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clk2WUZHS1hmK3dVdEg1T0Ftdi93S21qQjZzeVc0S0x3NkZMeXRzdlo0YUtX?=
 =?utf-8?B?S1kzRVF0dUZKQzFlR2QyWEFKbzRYMUZKUTczSG1zSFgyZlVUNDRhQmp3aFR3?=
 =?utf-8?B?c1JmOEtCMVp2R3M5Q2lwV3JuNmlwa2M5eHVSam1zWEdPRVZxTlZDR3lsdFFZ?=
 =?utf-8?B?MGNkU3R1RkNFaFFIb1hlNmlFbTJkUUxtVytWUXpOVXlRQ3RmZllIWlNzR280?=
 =?utf-8?B?dUtQSVlpcTNSUFFZNytCTnpJTHl6RlM2K0xNaFh2L3dFTkI2TzI0b1Y1RnJM?=
 =?utf-8?B?VmdkNUdPNFlVQnpmSzgwVzJITktjYXJXeEY0ekhGcHZxS2huWW1TdUhjL25H?=
 =?utf-8?B?TmVENURxckhCVVNiN01xSWZjU1lxbU1LQ3RiUjl3QW5sK0ZzK0tIUXBPUWJ2?=
 =?utf-8?B?eEJtT09BY2pTeFBwSXdoZnJpbVVaRUVjYzhVdzZqT2dyMlVwR1pWbTUveGZ4?=
 =?utf-8?B?bmVUbVZzVk5NUTlsMnlJcWZYNzBJVVlSMjA0bHMwQmY3eGhrY2ZMUHlWUE00?=
 =?utf-8?B?RVNQUmJHQ0NXdzY3ckhKMnBET2JIYXVwaDBBbDFodmpmblJkdmVjWnBydGdZ?=
 =?utf-8?B?L1h3WmpxaHduM0RTMTEyQ2Z6T2F1RXd5Ry9kK2UwYzczNml6d2RUMVRVNEVl?=
 =?utf-8?B?ODBGeXhZcDJNSWljeGZwSXFRaklQVkxsZzBWZ2dsMlFXMVZzR1c2cUxiaVd3?=
 =?utf-8?B?Nk5FQWdGRzFGNlNXVGZKamExOXRITnhVcTUyTTdFbFJIMTIrUFNSeWRzN3hk?=
 =?utf-8?B?Q0tkMUszZWkxdVpFK2cvdThNK203WkNPWjJTVTFMSTF1WUNEejFYbVJvSjJq?=
 =?utf-8?B?MGJOQUN2QUZBUHd1UWhVNEdIcWY4M045ZHhrQU5sTDRWMWZMSEMreHcyb1N4?=
 =?utf-8?B?b3RSbU1zdk5KcSthanVyTko0S1BGZEZlZGgzWGw0TXdHT0I3TW51NUpuY1E0?=
 =?utf-8?B?Y0VFbXVVWUFrRHpmNElrcFZYT2t5dEZ0KzRFZ1lOczVTNlZzK3JrUVFIN0o5?=
 =?utf-8?B?N284cTRLaGwyeSt2YkUrQTJBMjNUY0h3Yy9NNmVRZGtTbCs1VVBFbU9iUVlv?=
 =?utf-8?B?SnNmdi85QTR1cXNVb1E5S1lsVFpCZk1RT0FRbVVSRU92Vi8yZ2NBYm4zYy9B?=
 =?utf-8?B?ZVlJTGFacWVkdmJsK005bWRUb01jRC91YzVKUTlZUU1neGZIK2ZiMUZWdzFE?=
 =?utf-8?B?QkZXRzBZTk5xZWhnZXk1VkJWbms0bU4zcXRWTWJjZitPZDV3YjZiWjZWc01J?=
 =?utf-8?B?ZW5vRDNCZjFMelU3RFRMRXoycFhCenNOdUNUZ1lsVVZJZHNzbHA3THgyS2VZ?=
 =?utf-8?B?R2hWQVl3aFIxeWwySEVxUzk1aWVmMm9ycjhXaVBxQ3cwZjU0ZjlzWENGSGRE?=
 =?utf-8?B?QVEvTG8xcm1RQ0VuVmxyYjlEQUU4WTk1SHFOUFBmV3c5M1dHU21US2tmWFNI?=
 =?utf-8?B?TllLazJEbFpDUW1adGZwNTR5V2hBK0trdnpwZHE1dWgxV0xqUEo5UFRMYkl4?=
 =?utf-8?B?bWF2R0FhaEtua0pwM3h5RkdMQVRjQlNNVHk2TFlNaUVXVGl0MFBnUXRtMEFV?=
 =?utf-8?B?U3JySi9QMnJsbEhJYm4yWVR6UkZzWWR0c05hRG9nVnpYQ0FuT0hLb0RHdFRp?=
 =?utf-8?B?dlZvNlBIYmEreFlQR3FSbXN4OTZ5WWNRR1lKczdkbDAra3hncytoVDgzSmV4?=
 =?utf-8?B?NTNZbWI3QkFGcEhHQ0hvVU9EdnBLOC9sTE8waWpCRVhwN3hzV0lZWEZVWFNx?=
 =?utf-8?B?dEZuWUxCTzdRa3F2VUN0SGJUMkZlQ0U1M0d6MHcwRms2V1JMWFhRTFhCUlgv?=
 =?utf-8?B?WEhEdEYxNnBQYk90bTM1d0N3Rm82bVgvUEhIeExBb0xIa2gxdTVwbXNGWXdD?=
 =?utf-8?B?N0xWQ1VBYlI5UjlyelBBS1JWZEFBb3pQSk5HZGZHYnM2ektCNEZNL2oxVzBy?=
 =?utf-8?B?SDMzWWtwY2FiOVRzU3hQbmFIbHVUaUdBOTNOVGxVd2taU3lRYThWYVFla29u?=
 =?utf-8?B?Q3ZXcWFpaGtBaWlBTGJMSmxnTTF2eThWVWN2dVNDd0pWbmN3L1hPbXlDaldR?=
 =?utf-8?B?ZW9KVExBTXpzcFZrb0hXRXpyYkZTYW5WSkxKcCsxNk80OC9CRkd3b3B3VW1Y?=
 =?utf-8?B?S1NkQkVaZHIyT0dLSjUyTzlHMjdlM3MvSXpRT1pOSytsV3V2QnB6YkdmZldQ?=
 =?utf-8?Q?IIRJvXlC337dcbQ1mLViG18=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 504902c6-fab0-4453-f023-08d99dc965c9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 06:24:17.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJK+7IL65emrOyhyuHfJr8vEha97usTjwcutLcnfs3ujjpbMPJy2gtkcYoeYmq4IIqWX/1E3abUJW64VDlKCbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4668
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/2021 05:27, Kai-Heng Feng wrote:
> On Fri, Oct 29, 2021 at 5:14 PM Sasha Neftin <sasha.neftin@intel.com> wrote:
>>
>> On 10/27/2021 01:50, Kai-Heng Feng wrote:
>>> On Tue, Oct 26, 2021 at 4:48 PM Sasha Neftin <sasha.neftin@intel.com> wrote:
>>>>
>>>> On 10/26/2021 09:51, Kai-Heng Feng wrote:
>>>>> On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
>>>>> polling logic doesn't wait until ME really unconfigures s0ix.
>>>>>
>>>>> So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
>>>>> flagged, wait for 1 second to let ME unconfigure s0ix.
>>>>>
>>>>> Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
>>>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
>>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>> ---
>>>>> v2:
>>>>>     Add missing "Fixes:" tag
>>>>>
>>>>>     drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
>>>>>     1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> index 44e2dc8328a22..cd81ba00a6bc9 100644
>>>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>> @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>>>>>         u32 mac_data;
>>>>>         u16 phy_data;
>>>>>         u32 i = 0;
>>>>> +     bool dpg_exit_done;
>>>>>
>>>>>         if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
>>>>> +             dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
>>>>>                 /* Request ME unconfigure the device from S0ix */
>>>>>                 mac_data = er32(H2ME);
>>>>>                 mac_data &= ~E1000_H2ME_START_DPG;
>>>>>                 mac_data |= E1000_H2ME_EXIT_DPG;
>>>>>                 ew32(H2ME, mac_data);
>>>>>
>>>>> +             if (dpg_exit_done) {
>>>>> +                     e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");
>>>>> +                     msleep(1000);
>>>>> +             }
>>>> Thanks for working on the enablement.
>>>> The delay approach is fragile. We need to work with CSME folks to
>>>> understand why _DPG_EXIT_DONE indication is wrong on some ADL platforms.
>>>> Could you provide CSME/BIOS version? dmidecode -t 0 and cat
>>>> /sys/class/mei/mei0/fw_ver
>>>
>>> $ sudo dmidecode -t 0
>>> # dmidecode 3.2
>>> Getting SMBIOS data from sysfs.
>>> SMBIOS 3.4 present.
>>> # SMBIOS implementations newer than version 3.2.0 are not
>>> # fully supported by this version of dmidecode.
>>>
>>> Handle 0x0001, DMI type 0, 26 bytes
>>> BIOS Information
>>>           Vendor: Dell Inc.
>>>           Version: 0.12.68
>>>           Release Date: 10/01/2021
>>>           ROM Size: 48 MB
>>>           Characteristics:
>>>                   PCI is supported
>>>                   PNP is supported
>>>                   BIOS is upgradeable
>>>                   BIOS shadowing is allowed
>>>                   Boot from CD is supported
>>>                   Selectable boot is supported
>>>                   EDD is supported
>>>                   Print screen service is supported (int 5h)
>>>                   8042 keyboard services are supported (int 9h)
>>>                   Serial services are supported (int 14h)
>>>                   Printer services are supported (int 17h)
>>>                   ACPI is supported
>>>                   USB legacy is supported
>>>                   BIOS boot specification is supported
>>>                   Function key-initiated network boot is supported
>>>                   Targeted content distribution is supported
>>>                   UEFI is supported
>>>           BIOS Revision: 0.12
>>>
>>> $ cat /sys/class/mei/mei0/fw_ver
>>> 0:16.0.15.1518
>>> 0:16.0.15.1518
>>> 0:16.0.15.1518
>>>
>> Thank you Kai-Heng. The _DPG_EXIT_DONE bit indication comes from the
>> EXFWSM register controlled by the CSME. We have only read access.  I
>> realized that this indication was set to 1 even before our request to
>> unconfigure the s0ix settings from the CSME. I am wondering. Does after
>> a ~ 1s delay (or less, or more) _DPG_EXIT_DONE indication eventually
>> change by CSME to 0? (is it consistently)
> 
> Never. It's consistently being 1.
no. On my TGL platform is cleared by CSME:
[Sun Oct 31 08:54:40 2021] s0ix exit: EXFWSM register: 0x00000000
[Sun Oct 31 08:54:40 2021] s0ix exit (right after sent H2ME): EXFWSM 
register: 0x00000000
[Sun Oct 31 08:54:40 2021] s0ix exit(after polling): EXFWSM register: 
0x00000001
[Sun Oct 31 08:54:40 2021] e1000e 0000:00:1f.6 enp0s31f6: DPG_EXIT_DONE 
cleared after 130 msec
> 
> Right now we are seeing the same issue on TGL, so I wonder if it's
> better to just revert the CSME series?
no. We need to investigate it and understand what is CSME state we hit. 
Meanwhile few options:
1. use privilege flags to disable s0ix flow for problematic system 
(power will increased)
ethtool --set-priv-flags enp0s31f6 s0ix-enabled off
ethtool --show-priv-flags enp0s31f6
Private flags for enp0s31f6:
s0ix-enabled: off
2. delay as you suggested - less preferable I though
3. I would like to suggest (need to check it) in case the DPG_EXIT_DONE 
is 1 (and polling will be exit immediately) - let's perform enforce 
settings to the CSME, before write request to CSME unconfigure the 
device from s0ix :

if (er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE)
	mac_data |= E1000_H2ME_ENFORCE_SETTINGS;

I will update Bugzilla: 
https://bugzilla.kernel.org/show_bug.cgi?id=214821 with this information.

I also will need some another information regards SMB state in this case.
> 
> Kai-Heng
> 
>>>>>                 /* Poll up to 2.5 seconds for ME to unconfigure DPG.
>>>>>                  * If this takes more than 1 second, show a warning indicating a
>>>>>                  * firmware bug
>>>>>
>>
