Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B715421F12
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhJEGwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:52:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:39791 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEGws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:52:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="289177068"
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="289177068"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 23:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,347,1624345200"; 
   d="scan'208";a="713962089"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 04 Oct 2021 23:50:57 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 4 Oct 2021 23:50:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 4 Oct 2021 23:50:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 4 Oct 2021 23:50:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 4 Oct 2021 23:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsH44w+DJqg62TRWb+7f+V2h0xNFdMUKQjqmCIRSqtru6op/6ud8060Yr5RtKRNkkGW8EhxzUEsK//LRwFcEa8qkvRAcnbG8tNcV5Sl3/2tjds7xC6+CLd76/IvWp7V4PKykpp9XyITwLGVAzcJAww9rOQFyofqQIrY5a2GNC40c1HKCkZ5vvreMc+xBIAhGGEa+G5LLDlTwibm7MtC0HaFlAC3ULqNmuLDjnR5ChWaX64QHcRXXPA1g/Jo2Ctzf+qKLfi2xUcunxZz+4Vvk3Q4oJOYxkZxHov1xF+N8w7wt/L7/DdSV7KtNUGPkAdSXOKM+fUifl7QcnxSeXAnEcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKRgPkDhYiscNsm79nedrdtRZP9ZjSQWWqzm2VGW5nk=;
 b=nV1PWvbMX7qclchBfeVsLJuu4Euz1brNByXvapGEmUppZ2YmpFbMkyPNB0GzcrFP3UKwi06zDkv2uBaxFomyFiADAk6F5WJHz7Ir8HgcUTDp0kklYDufjpnIww9ooQ7Onf9rHY1UEKxB2W1BmyiA2ind18esnHOLMYkfpo6kknzL48bvn4kWHt+vDbAZBdNamn8cQsIIGt84liWgFFyQ9IzS7ycRXa5JvUdDdaNKNigUWVYGblOSNe8xM9cHtLwHVynVOa/csR5Bzj/bEI5nMNlEs92NQ6fgce7czy79BE9TjBgstFWR0oe5STYzL939XFu8kriw8/Yv23cjGYdg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKRgPkDhYiscNsm79nedrdtRZP9ZjSQWWqzm2VGW5nk=;
 b=XpDfYGdi0j2UqNYngeeF0zrKXdimTFOPEYoD9QVe9dk8cjvnkGmuSthMKruJT2uz7I/KyPMEUMubVbqO3kOapr3LHLpgMf1FgD//+mSOi+PjngnbAjtVDGz5O7ZXgvg5Jn2f8pv8rI6mtZr6lFcdhbzdnDfEm9rBquNeKSf6HUU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR11MB1728.namprd11.prod.outlook.com (2603:10b6:300:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Tue, 5 Oct
 2021 06:50:55 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 06:50:54 +0000
Subject: Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM
 Checksum Is Not Valid") [8086:1521]
To:     Hisashi T Fujinaka <htodd@twofifty.com>,
        Jakub Kicinski <kubakici@wp.pl>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <1823864.tdWV9SEqCh@kailua>
 <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <4111f2b7-cbac-3451-593f-a154aca65263@intel.com>
Date:   Tue, 5 Oct 2021 09:50:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::17) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [10.185.169.76] (134.191.232.34) by FR3P281CA0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 06:50:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb69a347-bfa9-4e8b-5f17-08d987cc7a59
X-MS-TrafficTypeDiagnostic: MWHPR11MB1728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1728DB8415B07F8BA2A9698E97AF9@MWHPR11MB1728.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eD+kiAWjFhfnRUv/ArZjoxNwFlxDGCnqwy2w4TYLD2vlV7qf2v1XiRmKcbMHk4CNiDUzYeMBkEdj7m43LQtKs+ef1HXwlehFs/Irx6c7KlFjPNq1qeMzrE88A2p34tY9C0tdmIuzSw493vvZRf2akNRNpcQSvxgv+BAzVJT4vHm+azNdIGWUv83UNZtkgB/kJD9/SSKHHdqLuPby6fmjJeqhZKykSeRdT8opWOaTOzbV+IRJRnqO1G1mktvyKTOiVDMFVKvqiA8CidtxErZTRmfdNKSXaVXI3hoSBXwaj+LCv6jRwA4TkifWpOwdgDnt1/2vceRTEVR2a+e8kRUVxiAxp1UdcADWOcHDRzMdHcPk48a8sCXlRZLM5y/6/f3bUTWYlejNtYqYYpgCmVNNXt5/UkvAwruDogXeuTgfk6j9bV5t1RKBTyl9ym1HJGuiY6YI6hvL4Q+c4eJ3uZwNX+IwT/V+WXJY9CyKcJIEScwwxmgVpq3aGsomWlkSOp+ez5m4GE2j46xFv5pKSa5NbX2eUevYU5Bi9kALUl1lTkA35oX6gIbCjrdMlus5x0mU93Hdf0dwmgumPgygWP+XL9fu6mtGNelJDMC8c/kxZctctLJFPQq/wC1+rDo5d78HPk5+cJcgG3hnb8WCk8PYqhRMYx6l+tJbVRZnAZodATh6PCPdgE16Wr8z9R8YP+n8EY8IDcINU/lET/gc/cX41ctcql+4Ql0iVpMvSt+//T9vxCOO1LvVnfxxcmmvCxLpPQQFjZkTgMNLVb/i9uSvHfkWoeyQjwrphHhXaJGtUCcBTgq7y13gkhDwhb5aVAcAZaX17OIQIyMlaRjvUs9RWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(31686004)(86362001)(186003)(8676002)(36756003)(107886003)(26005)(966005)(16576012)(83380400001)(38100700002)(8936002)(508600001)(54906003)(956004)(66946007)(6486002)(5660300002)(2906002)(110136005)(2616005)(44832011)(6666004)(31696002)(53546011)(4326008)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWt5dmJ2YjB3VkowdXVvOGtzeEtJYVlweElCWjNSUWp0U0dsWnA1TDNCNHZn?=
 =?utf-8?B?R0J1d2pEaGxWRHVkNlo3eVNoTnB6b2hpMC9BLy9SbjkzUk42RXJ2UWdXY1p5?=
 =?utf-8?B?SkFsZXdXV2ZuN2lvUTV6aWl5eXVJYXZrcm5yaGZLNlliV0gyN1R3WEJ6aHcz?=
 =?utf-8?B?Z29LeEhOOXF5WGtkZWRpN3h6ZnRMRyt3elF6SjFjcHZnYXYrelpUTVVENEpF?=
 =?utf-8?B?L2g5dUtCdzQvckVzMGhGSUxqdVBxbTRtSGg2elpNd2xSOWxmYnYraHdzYk9v?=
 =?utf-8?B?MHcwYzYwM3ZYVTc0cG9CUEJxa2czSUdTZ2FuY0ZaMU9BWG5IdXZweXAxazZm?=
 =?utf-8?B?UHEzeVduQzJIczh3UjQwYWVaZ1l4Z2M1a2RyRjRMQWZ4Q3MrYVYwTTVuYlVX?=
 =?utf-8?B?YXFXZGc1SnRDanZsT2ZkelEvWnoyVTVuMjBSb0kza2dwYUozN1c1RUZ3aDIy?=
 =?utf-8?B?ZU0wYmtLaWFiTUFhU25TaC9KSDRnUVR4VGRveHlFK2o4OWlkUkpaYkgxL2Fw?=
 =?utf-8?B?b1h6ZUdPRWpvV2RLRU9HdkRNaTdxazU0ZmNjdlhCM21rQmM4UXYraTB2NEt3?=
 =?utf-8?B?TGU2cU5uandqZ1hZYmJvdENvSlJZWGdGN2pRSW9EUHFkR1B5QWdpV2FudEhU?=
 =?utf-8?B?ejU2T3NMVVUwNU5Mck9DTmRiWXVUSEVhZXhqb1BaOFdGVEVrR094N3JNQjZK?=
 =?utf-8?B?UHNOand6dmFueGZ2ZjVvZUxPMFNzVXlJaDJQa2wyU2FwY2N4emtROUJTbU5w?=
 =?utf-8?B?RmgzMzROR3o1RDl4Wk1TRFo4cU9jYVNYTWhhN2xPSmtGK1ZiMEZISTVtSHEv?=
 =?utf-8?B?NDlyYll5V3llKzU1NkVXSCtiL2gzMTAyM0hiLzBNVXR1aVJ1SVdiakpBb21R?=
 =?utf-8?B?ZUxGQmVLeGU3cWtKVi9FcEkxY1F2aTVPcXhiL3BTVkh6QmYybHJSZVFncVdI?=
 =?utf-8?B?bWxxR2RFQWV2N2wrdGIxeWVlbmZuU1p3RlZyemwzQ2Jha1JEOGJ6OHpXSjB4?=
 =?utf-8?B?SGZSVjUyd1VnelU0VmZKcHAwSU90Um50cEkvbzkvNXpHcUVxdWRWNDRIbVZt?=
 =?utf-8?B?YkZMNmt3RTRNQXpUUXltREQ1MnhLVGRPZlp2VHN0S0VvU1A4TGJHWXdleE1h?=
 =?utf-8?B?dWFRcDJhaURDRG96M2d2QWNNRTkwOGp4c1ZGaHd6Q2JMaytIdkdzVUZWL3A0?=
 =?utf-8?B?d1VOTnFUcnlFWTNqNytMRjhreDNQUlpQV0Z1RU9jb0JLcXFEbHBUTjgxaGFw?=
 =?utf-8?B?OU1Ma0JRaTV6aGd4REpJakhzTHAzUTh2L0Y0dlFFQW42WkZtWVh6eDl0cXFL?=
 =?utf-8?B?YlJIZ2JoWlNZNVYyTk4xRXpzaE56QzRleG52elNHQ20yak94OE80T3grV2N1?=
 =?utf-8?B?R2phTVlNQ2FYaEV1TXBBMkt1STN1T0FNSUFEVERib2d0MW1kODdWT2RLTGJw?=
 =?utf-8?B?VU8ra1RnUzN6QlQzemdja1l1VWN5N09aejVxQ1RLQStJbjlnSDFxU2lSQmpQ?=
 =?utf-8?B?bTBzTmJOT01PZDR3SXhoL3BLZFZ0MU1ubkVhVEt5U1JNYkpCbHRaZ3U0MjN3?=
 =?utf-8?B?NVd5ZGoxUC9FMlQxV1JHWnBSNElDSXVHMjVTTVJrSk5mMHFaRWt1SGV0Yytj?=
 =?utf-8?B?ckJMR1dBZVAzTTF5VWJxdWF6d2Q0WGNxWnkyMU5YeHdFekdVTzhSamwxVlpm?=
 =?utf-8?B?eFFENHRqMGhkYU45MHpyZVhOYmU4WmxCelV4RnJsUGdNdjlSWDVNdVdORUNC?=
 =?utf-8?Q?Ke4It06oi+V0Z1CkBP97jcW34ULNxreS0C0De8K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb69a347-bfa9-4e8b-5f17-08d987cc7a59
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 06:50:54.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8w8GknkVzgseBkQYajQORb9HnSKOqXw0AzjdPCbLdD54zNDBoC3rMzhc1+uwloiiLTR/D+H9b6ZmREZJFIQfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1728
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/2021 02:39, Hisashi T Fujinaka wrote:
> On Mon, 4 Oct 2021, Jakub Kicinski wrote:
> 
>> On Mon, 04 Oct 2021 15:06:31 +0200 Andreas K. Huettel wrote:
>>> Dear all,
>>>
>>> I hope this is the right place to ask, if not please advise me where 
>>> to go.
>>
>> Adding intel-wired-lan@lists.osuosl.org and Sasha as well.
>>
>>> I have a new Dell machine with both an Intel on-board ethernet 
>>> controller
>>> ([8086:15f9]) and an additional 2-port extension card ([8086:1521]).
>>>
>>> The second adaptor, a "DeLock PCIe 2xGBit", worked fine as far as I 
>>> could
>>> see with Linux 5.10.59, but fails to initialize with Linux 5.14.9.
>>>
>>> dilfridge ~ # lspci -nn
>>> [...]
>>> 01:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit 
>>> Network Connection [8086:1521] (rev ff)
>>> 01:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit 
>>> Network Connection [8086:1521] (rev ff)
>>> [...]
>>>
>>> dilfridge ~ # dmesg|grep igb
>>> [    2.069286] igb: Intel(R) Gigabit Ethernet Network Driver
>>> [    2.069288] igb: Copyright (c) 2007-2014 Intel Corporation.
>>> [    2.069305] igb 0000:01:00.0: can't change power state from D3cold 
>>> to D0 (config space inaccessible)
>>> [    2.069624] igb 0000:01:00.0 0000:01:00.0 (uninitialized): PCIe 
>>> link lost
>>> [    2.386659] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER 
>>> session.
>>> [    4.115500] igb 0000:01:00.0: The NVM Checksum Is Not Valid
>>> [    4.133807] igb: probe of 0000:01:00.0 failed with error -5
>>> [    4.133820] igb 0000:01:00.1: can't change power state from D3cold 
>>> to D0 (config space inaccessible)
>>> [    4.134072] igb 0000:01:00.1 0000:01:00.1 (uninitialized): PCIe 
>>> link lost
>>> [    4.451602] igb 0000:01:00.1: PHY reset is blocked due to SOL/IDER 
>>> session.
>>> [    6.180123] igb 0000:01:00.1: The NVM Checksum Is Not Valid
>>> [    6.188631] igb: probe of 0000:01:00.1 failed with error -5
>>>
>>> Any advice on how to proceed? Willing to test patches and provide 
>>> additional debug info.
> 
> Sorry to reply from a non-Intel account. I would suggest first
> contacting Dell, and then contacting DeLock. This sounds like an issue
> with motherboard firmware and most of what I can help with would be with
> the driver. I think the issues are probably before things get to the
> driver.
> 
Agree. The driver starts work when the PCIe link in L0. Please, check 
with Dell/DeLock what is PCIe link status and enumeration process 
finished as properly.(probably you will need PCIe sniffer)

> Todd Fujinaka <todd.fujinaka@intel.com>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

