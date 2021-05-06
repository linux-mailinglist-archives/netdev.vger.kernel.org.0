Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A44374D1B
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhEFBzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:55:39 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:46722
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhEFBzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 21:55:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc7GezK3edz5q5OjO8xS6xGB46c49U7pi5EJRmm2GrSTlP79YOkCC4HTxmCO1v/eC/lZof42CQQ+b2VVI7WY22jQsvnqWrPvCbnbu0/Yfltq3bgTfqFvC19Wb471a4aeAEq1elMOUFxa2mPGKSYcPlXuXd065raLWdzmceiJFcmJVxP1Rwzi0Y30OVB2RfaC/qECA3CyI4QEVRRLVqMifgUQk99riJOJ5fCarngRRj3d2kX2MQu5dYZzaPi8/+Wk57Wn2jQuir5TF9NDH0F/sI/VAz3JpgPPw4fFbH6b5BtGh0CyvvoGD0y1KsZGQHnQCrAjA7XeLfi2GfXBH52tqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P9KdOtT/UcXqra9YxyLflb7a2sjPFGolxSpWs/vDiE=;
 b=TP3p/0Ta929JJsbnkh6YKXdbJghOh6NxlG3/vUGpm9DJmqXatr4vnDmw+0dT1Fyg+XWTLK7FP5YnlEnfSwS/g91zLuourQgMJS3pxa8Wfm+HuwWyoauFMlSSkMJcvFdMRRzcPg6cd+eRYmbKJB40xTxamv0iV/ZpXLoxQw8mC1RGNx4lnNHyuU1agu/nwbpRZ460NS5qUGcfT/mXDWdj5ucJ4+Nlbnf+LkudF1ZIoAkO4AaO47MFJtX5j83P+m46lyPBYmYaiUkbD910Fz80FnvvBg3m2c4ieCCwWhIzCKuJ7mXWpDUj0VxypEoHc+2AyiPLvDDcz9rLH0Ug/CoGFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P9KdOtT/UcXqra9YxyLflb7a2sjPFGolxSpWs/vDiE=;
 b=dPkxN5kqiwycEvdAQRb9ojUfObwiM9Z2dxDUfX/qBuRndNwgRTQkBup+M2Qjd+qorIA8pQh+nxcPUnVLuXCceCLimhSsp0HRap9nwgdyfc+eZiMVsAevpKLRs34gH608tTgaUf/TzNBtnZsFustpOYwZmseBS6knsFcak5owS6E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB3419.namprd11.prod.outlook.com (2603:10b6:5:6f::32) by
 DM4PR11MB5296.namprd11.prod.outlook.com (2603:10b6:5:393::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.40; Thu, 6 May 2021 01:54:40 +0000
Received: from DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::e436:ec10:350f:578f]) by DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::e436:ec10:350f:578f%5]) with mapi id 15.20.4087.044; Thu, 6 May 2021
 01:54:40 +0000
Subject: Re: [PATCH] ice: set the value of global config lock timeout longer
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210419093106.6487-1-liwei.song@windriver.com>
 <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
 <fca32ba9-ad20-0994-de7c-b3bf8425a07b@windriver.com>
 <8d6eb1116cac38c764fce754a9fa272ac4509bbb.camel@intel.com>
 <fa7cd362645763d382719f8ab0e72f429156444b.camel@intel.com>
From:   Liwei Song <liwei.song@windriver.com>
Message-ID: <5504b7a4-643f-642c-a22d-844566fd253d@windriver.com>
Date:   Thu, 6 May 2021 09:54:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <fa7cd362645763d382719f8ab0e72f429156444b.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:203:b0::31) To DM6PR11MB3419.namprd11.prod.outlook.com
 (2603:10b6:5:6f::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.157] (60.247.85.82) by HK0PR03CA0115.apcprd03.prod.outlook.com (2603:1096:203:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 01:54:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee8e0558-5f1c-43ed-69be-08d91031e91b
X-MS-TrafficTypeDiagnostic: DM4PR11MB5296:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5296778AAD6DFFC8D15881BF9E589@DM4PR11MB5296.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnKbEXlJmIevtzKSdHSLE56+EhDleGaNqGcmNuu43NUG7Dg4pfKGZx9MsQ0RgJiOBicJ+w9U7+OvuQRhelkJduHC2WaMDvbeTTgSTNhnjI0O9PygdaFYzdXSaAehXpIanUHhKQycctkud0ey8pUX7fy/AANDsKAXJodazA31iHgTIMxtLgi5wBTVhidB9au3gipQ6m2SPCP7TacAnBKYZMtNXIwKLLJNwko6S44yq5OFK541jw5K2UAhaJYymY3P/vJiwRo9zYcGR3Yi1Cbfm0GzJu1p9BKizXvkLQrPUmotc+6UuUjweeUpqPEqtkjKcWTuKNl3PQIByH20EYxgJ0W8WfCjiWT609f5/XWwqQkm+bBiLBMpYSVGMcPXZ8De9w5G3+jUnpWwKjAcS5Cs2tHJRyXqrdUGo7mKQtg20JAWLHhgMAA7MgvOvlNmsu3/rqLeGJGjeG3ciU4XpDatoCBtdmmQYkadIlxJPwCPhBFuzFlXL1GP69OXFZULi70JsiiJQqYnFVpjrTPT+gsiCOC977rKwmToZc06sT8Hjh8wvj7DPvsiidfXpusklhSTVwbHaoaUOtpThcnehWOYU9oJ5zZQ3o4w7Z3FefWHqL4rqum6WJ4S2kVxEeKW2IKR9IH2L8Js2+nM9coDMAJ/2ub/vzVt3HeCYWB1YcFwUFL10lMyP37fk8G0PNAgKTc11zETVR1B2FhhbLVqX8IE82af29M4t6aMqgujUC35Oilhj0jibpQCI0O8AsoqXSvyXJm/yLgbjO2JCFstEYNPSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(366004)(136003)(2906002)(110136005)(38100700002)(16576012)(38350700002)(5660300002)(316002)(26005)(6706004)(8936002)(66556008)(4326008)(31696002)(54906003)(36756003)(53546011)(6486002)(6666004)(478600001)(86362001)(44832011)(186003)(956004)(2616005)(66476007)(83380400001)(16526019)(66946007)(52116002)(31686004)(8676002)(148743002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3NsYWdjVFBxd0dtVTdIejZRcHhpUThZaE9kUlUxRkdFTWo4bmNMMEM5N3Jh?=
 =?utf-8?B?UExGT011NncwRlR3cG9YODFUNmRaUW1JZXJQR2Y5UmdCZWl4aXR5QXlUOTJG?=
 =?utf-8?B?ZDV0SlgvaytJY2JtNkNwSmd5dlBMSUppSkZ3TFJDZ1FFS3h3TzUzL05oTFBr?=
 =?utf-8?B?SnFHZ29rQ0NFRmJsV1dFUWtLQ1ZkVVRRVW8wZ08zMWN6M1B2bG84aXBKTy84?=
 =?utf-8?B?cGVlNXBmTUw2WVlwWkJraStYSlRjdTgrbjlaNTMwOHhJaklMQ3BvM0JVU0RU?=
 =?utf-8?B?WVlBNzNza2QrcVFsa05wSUxjV2JibUd2Z0R2MXR5aStmVUFsSm8yTllLb2Nm?=
 =?utf-8?B?dHQzWlF2RCt5TWtJWWdYQXBrMHd3WCthaHhLZXFlZlI3VG1QR2tnbmhDN1RS?=
 =?utf-8?B?M0I4S0wzanQvQkRPVW0rMzhEN2VtdXBiRjdHUXZUd3VqN0tLQlRWbXE4Z2o4?=
 =?utf-8?B?RUNMeTFKTUM1QmhFeWhTK3NxSWRiOWhBNGNuQzd6NVg1aGpIYm45cGs4bEEw?=
 =?utf-8?B?N0h6a1RmNkYwVTRGUk1rUmtlK2d0NTMvWnZ3RkQ2UjNKQUREbHgvWStaM292?=
 =?utf-8?B?YWxrWDZ5N3lQdWRsWDg5d0VKVDJaRlRFREVVRkxJVXZ6eW52L2ptNEh6YStM?=
 =?utf-8?B?cHJKQ3ZtWVhxWUNhZ3JKNWJta2dxSFU3UDdqYmpaOFlEajdKMkFzL3N4K3hI?=
 =?utf-8?B?VGp2RVNZZHI2d2VLeTZkU1RUMktHczg0MTBkak1PNkJydThYbVBYK3gwaCtQ?=
 =?utf-8?B?aHRQdnlDVE0wZWhDY2xReHF2dVp6a0pGR1hJRGt1c2hVMjZYRk9PRFQvZ1Bu?=
 =?utf-8?B?SWhtZ001N0tnRjhUOSs2ejZsbm43TXk4Umpjay91WmM2bXZPWXpRUElxaUNq?=
 =?utf-8?B?ZnFYcDRCZVEzeTFUWEpwUE5UUHdrbk5ZOUJmRzlBVFFva3pmaHA5RVN6UUZq?=
 =?utf-8?B?VS9pSjl5TUVQdzZJeHUweDdvVG95dHRINXJ2U1c0M0FtMUVmVlBoa0w1L3dI?=
 =?utf-8?B?elFnVllMeTFGbTRHSVhyOWFFVnZxaVVUQlc1bGYxTFNKQlVJb0dyTkFNM08v?=
 =?utf-8?B?RGJOdldyaVE0aHUyZXIraEZFT1pvWU4xOFMzR2VSWVluL0pqeXdJMHlZWG5t?=
 =?utf-8?B?Vm9qcEpDQWVtZ1ZRSm5VUXFManVmVVU2Ykl4NEFDTkEyU2JjOUkzL1N1VWJs?=
 =?utf-8?B?MDRaTGM4MnFGVEkyT1VhOTlHVnZSTDkrQzN2S0x6SjR2TkM5bVlRRTlGRFVE?=
 =?utf-8?B?L2p4WFNzVDYxL1I5aS8yREcyelQzRTM2d3R5Vk9uZGllMlpkRDdpNkNpejJS?=
 =?utf-8?B?VERBaFVQQXBqMWNxVXZYL3lnRDA3di9xa1Zka0hWeFlwaEFMb0FYTVFBaCtW?=
 =?utf-8?B?QzMrZG94czNYMHFUd3VWSStpeCtmczhPYTBLYXZ5UVFIcXhNYmhxM1h3bUVQ?=
 =?utf-8?B?UUlOR05DOW5qSGQ4ZGFkeGFEdEhVMWx1NGpZNjBidnJmRENxU3B0UlNsa2Fv?=
 =?utf-8?B?cWJBT0ltZFBjV2tBbnpEd1dnam8xRDM5VE5YTi9sek8raGJyV1RPc3p6d3FG?=
 =?utf-8?B?cXluTHZFa0Vhc1ZGTVI4RFdsZFRLSUtaRkE3UlVudzJGOFBpZkhZdExjejMz?=
 =?utf-8?B?cHcxT3ZkdlZrQllqZURXU0RvS1hMQytnb1V0K3JSUkZvL2NGMFVXbHovMnA5?=
 =?utf-8?B?cDNVbmZwQjk3WWZnMHVTRFE2bkFoeHBwSUM5SDBXaHhBUzdreEdWZkw4Zlpq?=
 =?utf-8?Q?Hv4HpwHQG348TG6iTtpd9Qg9otVz39ckj2LOvGn?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8e0558-5f1c-43ed-69be-08d91031e91b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3419.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 01:54:40.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qjf+07cp8kl0xG1Fi5qfC7a7rzf/0E33vHdpQWEHcJ1TuEp33Svm++UgEG87+3Gn73SrndCiuc5TJO/zjGq19/zDob94E+u3PRajBlkGJdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/21 08:44, Nguyen, Anthony L wrote:
> On Thu, 2021-04-22 at 11:16 -0700, Tony Nguyen wrote:
>> On Wed, 2021-04-21 at 10:29 +0800, Liwei Song wrote:
>>>
>>> On 4/21/21 06:48, Nguyen, Anthony L wrote:
>>>> On Mon, 2021-04-19 at 17:31 +0800, Liwei Song wrote:
>>>>> It may need hold Global Config Lock a longer time when download
>>>>> DDP
>>>>> package file, extend the timeout value to 5000ms to ensure that
>>>>> download can be finished before other AQ command got time to
>>>>> run,
>>>>> this will fix the issue below when probe the device, 5000ms is
>>>>> a
>>>>> test
>>>>> value that work with both Backplane and BreakoutCable NVM
>>>>> image:
>>>>>
>>>>> ice 0000:f4:00.0: VSI 12 failed lan queue config, error
>>>>> ICE_ERR_CFG
>>>>> ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error:
>>>>> ICE_ERR_AQ_TIMEOUT
>>>>> ice 0000:f4:00.0: probe failed due to setup PF switch: -12
>>>>> ice: probe of 0000:f4:00.0 failed with error -12
>>>>
>>>> Hi Liwei,
>>>>
>>>> We haven't encountered this issue before. Can you provide some
>>>> more
>>>> info on your setup or how you're coming across this issue?
>>>>
>>>> Perhaps, lspci output and some more of the dmesg log? We'd like
>>>> to
>>>> try
>>>> to reproduce this so we can invesitgate it further.
>>>
>>> Hi Tony,
>>>
>>> My board is Idaville ICE-D platform, it can be reproduced when
>>> there is no QSFP Transceiver Module setup on it, it is not
>>> happened on each "modprobe ice", about 1/8 rate to got that
>>> error message when I loop run "modprobe -r ice && modprobe ice".
>>> the port type is Backplane, and I haven't reproduce
>>> it with Breakout mode. 
>>
>> Hi Liwei, 
>>
>> Thanks for the additional information. I've provided this to our
>> validation team and asked they try to reproduce so we can look into
>> it further.
> 
> Hi Liwei,
> 
> We were able to reproduce the issue. We found that this doesn't occur
> on newer NVMs, however, it will still be awhile until those newer ones
> are available.
> 
> In the interim, I'm going to have this patch tested to ensure it
> doesn't cause any issues. If so, we'll use this value until the new
> NVMs become available.

Hi Tony,

Got it, and thanks for the update.

Liwei.


> 
> Thanks,
> Tony
> 
