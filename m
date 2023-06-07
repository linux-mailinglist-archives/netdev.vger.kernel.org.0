Return-Path: <netdev+bounces-8855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF696726151
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC571C20CA8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5028B35B34;
	Wed,  7 Jun 2023 13:32:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA94139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:32:00 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F241D19BF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krWVefuerxDOIhdS/eJMscvzILsz6CrA59dxxDzDT+kghit+OT5aMR6ohqv7IHpob6+qge635C1Bk20RKBVw4I1KxRBDldnWHUxj0hgF0Ncp8KVV3B+LNOUqps26JipjDgGBsYTNvQsoth1fafU1RVNieKJe8mZYDzn7on5rrjXpoIdnvFiNpkj3rS1wKF8GXxVox2Hs5lHrr1rwnZdmNN6AdHflr7BkfXtOk72IjtlpzPFdlF9QSnjej3v008sfxwLN6FLZzK8m0TaG+OqEy8vTBoxRIsXSs0nR4LoafxhrlLWPfHA9/tuGskU1dZ0S16byg+op3QLk0kbdCDo61w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dc1/yH104/BuDuBH3DZwE/RAhWi93Je/JWnka7SPGqg=;
 b=f01bJsZU4hZoIJV78dgsu3emaQonH3cjBhBR8un0wGMAXePSyBtSXQMN3UYVyfCkWl2/pAwthEaBQdhwl6rxp0uM+aUy5RdhW1DIBq2QzJqOT0FIqnQ0SBglNjscb088tAJ3s6jBXWDMLftbpTxpaA1blkGvphUYI5VNm1/sajGKsdDwkoUeQLiP1f5gFxox2JR+nvNxoHyRXzLYcsvf6/oIqg8bmkptsEzbnDD5U4SQmeKXMsjV+6LrgG88DtYTT8TLWRBVPcXZt0fTIOwFj9CwAxEQ3+vbWG7T9ccZsLaMQyQLcZnIRRRB0Q2sdP2VgSMX0CFnW0vbCy23uomCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dc1/yH104/BuDuBH3DZwE/RAhWi93Je/JWnka7SPGqg=;
 b=PWyslduymmsbEHLAW6qLZFkEyn8qn5NP6LcxNi3AxQ+NQD2GlhLAdL3lCr/IfG/PAGS1mn49PXt8tor++b32WPiKw1tuFGpAjLITxncdASETKtf6DTPKNRlKlsZuSf4OxFPFC9OrJdoQROYZbjehsCIq2BO4qKCZm+cCwRv5qPdjrIIuG8IVPWOJgZRxt1BT1/lsTSTYqtzWmu8ApxJFpoL6yS/MZz50bGaLzpUOHRf61g5JX917tBZrA5iWfIBlJNJ8VRui51a0dBIrPaO9EaesASGgdi2Ebp/hSRBaMJnR6wwCCzr9OMOKeU+dBu+EC4qf50LLinmN7MMaVEND5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM4PR12MB5916.namprd12.prod.outlook.com (2603:10b6:8:69::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Wed, 7 Jun 2023 13:31:55 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:31:55 +0000
Message-ID: <f2a02c4f-a9c0-a586-1bde-ff2779933270@nvidia.com>
Date: Wed, 7 Jun 2023 16:31:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Edwin Peer <espeer@gmail.com>, David Ahern <dsahern@gmail.com>,
 netdev <netdev@vger.kernel.org>,
 Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Stephen Hemminger <stephen@networkplumber.org>,
 Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
 <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
 <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
 <62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
 <CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
 <cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
 <20230605115849.0368b8a7@kernel.org>
 <CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
 <0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
 <20230606091706.47d2544d@kernel.org>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230606091706.47d2544d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::15) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM4PR12MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: f7f37a5a-954c-4604-7c8e-08db675b8f47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tWZN//GjwZHCN/Kl6JADQk0yHYhr4Q9Erjoy83dRysEXak1jpzgGajftIp/z5VsNcD6Tem7cEN/G+y9dpAHEJgH9U8rt5JKb09+QrC3tFE30iS7WbjxZqEhMJVfKpYTP7HJpNnvzXVkW/VgK+PDD1NO4jQWI+OH4qFjjaMWGLrxEv1I55drViQUGEalHpmkhUXOKAJTRp4AT2bJfe8LDopW5+qTFF0w+HkPvLZW2Fjy26kJaPbMR6VEN1To8iGDtqAXGGXFMph7v0Ki+OIWt/S+CioH54+K6PVIJiCd7SJ1dA+a3pBo4OudN0iRw0FM7cw1m6HNdpuds0HLmGL9Nek591PB1h+ZvaPKkzDdOr3eMkFkiDj6Zh4mBLvKx9crMJI6IXGdPkLjWcIbw7LmO85ELsUZZmgfn2nwuRQEY3sLNLYyca4fzebJC/VmZfcgNXlriFctpoW/+VXjimhrE8dauig3yP8N2YQDEHzUNkOM2GRX17I0bgTXoJElpBhCo3rxo5RmSZkVT50pFbzHi/Wcumy9VTQ02ihNNJ2IA7aJLR3OgzQTOgeVGHTdn8BeAaldLrU4wlxNUV2QV5ySbp8jA0Pv7b2fpFxYuD1ojf5S3JolAXl1VzW9luocz4K9J6zp8eUGaYch3Xem5ECNr8w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(451199021)(54906003)(498600001)(6916009)(8936002)(66556008)(8676002)(2906002)(36756003)(31696002)(5660300002)(86362001)(4326008)(66476007)(66946007)(38100700002)(6506007)(2616005)(53546011)(6512007)(26005)(83380400001)(186003)(6486002)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVI5bytnU3p3b0lOSUJlOEZmTkdYbmpVMjBLM2grSkpaYlRWV3pmVjZJUys5?=
 =?utf-8?B?aEYwbXkrNXU2OW9aMitiK2ZXQm1PZnBmSUsxQ1A3OVZOZ1BzNnY5OTFmUTh6?=
 =?utf-8?B?ZWpSbVNOT3hGNzJjLytJa1ZWQndrb1J1WFAxeDNXTHlKa2JXOS9Zdjdzd1h2?=
 =?utf-8?B?anBYVVc4cUxwajNMejVKb3dhcHFSbStJcnRscGxnRGpLRFArdnFmRlNLZ3pX?=
 =?utf-8?B?eDQycXhFNnNqck16OElRTnR3M1U0VkIxbG9BQXB5eEw4Mm9xTGRPay9uUHVG?=
 =?utf-8?B?cm84R2JhUTJkSDJEa3pTVURqWGRINElieUp3akNrM3hnWFhLMVhJZHhzNmMv?=
 =?utf-8?B?aG5NQ0NwRHZrMDRYbXFsMjRJSGFtaWRPSXlxNlYvUmduck10d2tGdjFFUkh3?=
 =?utf-8?B?SDIyV01mSEtmZm91Q2tmMGhqODJDc3FXNDI5eEZlNjhnVG85UTdlenVWTmpa?=
 =?utf-8?B?NFNDV2hvVkp6YmpacjMzN3BmSWU4Q0xuZFlad3MxbTJNVTBUeDhpWUp2RGxV?=
 =?utf-8?B?aGRuaTBPbkpDOHdLeUk1T2xZM2VUVFdpVVg0bjNnN1l0UUwwTmxlWTg4SWp2?=
 =?utf-8?B?UU90NkhKNDlBUWV2Z0tXSUF3TVpkcGJuZ3MzY2hLZ2x4NE52N09qK3VtWTF2?=
 =?utf-8?B?NkFFMjdlRlVmK2k4a3NXTnFITWtpMDFocTJnVlJYdFpHRFR4VkFRc1lBTkRu?=
 =?utf-8?B?UXJhNDhId093ekN6TG1ybE1Camo2SHNjOWxJNDdrVXNJR2s0S3dHYzNQTENW?=
 =?utf-8?B?U1dTMEtVcURtOERZTFNRRTdERXZSNWUvSFc3ZlArOHVJQllDcC82cU5jS1hG?=
 =?utf-8?B?ZDJkblRpeW1OZXhoK1V6NjJ2Nll3aXYrSHFlOG9CK1IrQjNYNk41eTVTaDdN?=
 =?utf-8?B?L3RjaGZaSEJXcmczUTVxOU9CZGZ2UHpBanJmMHNKL0FvWCtqVUxXWjc2WnlC?=
 =?utf-8?B?KzFPNWJzbk0yTnRyYWlvY3VYYjBlcHZWNlRNTGQxNkJOR3ZXRzVjUEhxdG5t?=
 =?utf-8?B?YnF4UTF5R1pGMHdWM0JmelNFRVBXcm90akp3aVdLc2dWQnJsOWdkNHpNNCs5?=
 =?utf-8?B?MDI2cWwzRFVldnowdVE4bm4vRDNrYTR1dFlFYk45YTVxVC8yQ2czT3IxV0pE?=
 =?utf-8?B?ZEJ0ck9pNkJ4b24yd1FPSG9GTWYwdmpDVlRlWlQrS056citYaTVjckYxRHV6?=
 =?utf-8?B?TTlhdUFrano3bTRZdkRMeXJ3cXhDMytSQmpWTVZJQUphUS9aSUxLb2g5eFhH?=
 =?utf-8?B?TU15VlBtTXVDblBpRkhUdTM1S1g4aWNXU2RTOXBwc1p5Yjd3d1pCTkNGYzBE?=
 =?utf-8?B?cERjNy9CZzNGSlRwWEpRWm54NGpzNkhlZDBSUlQwaitvanA2QXdOdHlzaGVx?=
 =?utf-8?B?cHc4bS91YktJeFh0dDA0WkJDTlN3NUdtZGdtaDBjNWh2VVM0S0tudUZNdTRE?=
 =?utf-8?B?d2FGYU4vTTB0VElQQitZNGlyVjFUNVhnNTl3RXlMRUkwMlBPaWkyVmZBM05q?=
 =?utf-8?B?eTlGYnZJbjMvWHI0SmhjRkk2bDVZOTg3UkRnS0I5RERXM0k1NCsvcGtOQURo?=
 =?utf-8?B?citUMXlYRlc2VjBMelRqYzZ6NEtPNDM4YlFBajIrcjlBWnNCM3FIS2dYNHFF?=
 =?utf-8?B?Qm5xNG1MRXdIMzMyUWo4anZXekVxRVJpUUdId3FUZnNGbjJab3MxZjdSWWpy?=
 =?utf-8?B?ZnhtNnBlYWl0c1RxTjV5blVpbWhQTi81NTBjVWJMQ3lRc2VBZXRhN2FoKy9F?=
 =?utf-8?B?QUU3ckwvTUgyY2ZpK1dNQ2cyQ1I0TW05S0FHZXVKelpqU3doOWs3LzhZMFpR?=
 =?utf-8?B?em5OcDVhajcvNVZFZURSRzVJSjlObFdsZzErbW9UYlhvUkNTZ3J2N0srSUJ4?=
 =?utf-8?B?TUVXRURvNEZ2NUhvWkpmai9JMnNOR1BmSG1aOTBQVmdxa1J3T0tvZ0tZcWZZ?=
 =?utf-8?B?eHNqYmFJdklRSllaYUhtLzM0bWNwZkFVekRVaXJGd1lxbHIxSGduc042eWlK?=
 =?utf-8?B?Y1Z3dDNSSllNNU90SE9wVzcvd0V6UmVYOW9KMEVMaEMyNGEvZ3FaMUo3QlB2?=
 =?utf-8?B?SU03YWRYWVdzL1NsUCt2SW9RVExIa0g0bWU2bjZHYmdYcEM2UnR0aDNucVZ4?=
 =?utf-8?Q?1ms23QueXZFX5iBkiFFVjHyou?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f37a5a-954c-4604-7c8e-08db675b8f47
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 13:31:54.9529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGRjY/sVoTYtsjsnra0uCi/bHmdDsAdpMJH1CG1KdRY0cb2dQ6ynPiFWxH4fpUCL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5916
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/06/2023 19:17, Jakub Kicinski wrote:
> On Tue, 6 Jun 2023 11:01:14 +0300 Gal Pressman wrote:
>> On 05/06/2023 22:27, Edwin Peer wrote:
>>> Thanks for the CC, I left Broadcom quite some time ago and am no
>>> longer subscribed to netdev as a result (been living in firmware land
>>> doing work in Rust).
>>>
>>> I have no immediate plans to pick this up, at least not in the short
>>> to medium term. My work in progress was on the laptop I returned and I
>>> cannot immediately recall what solution I had in mind here.
>>
>> Jakub, sorry if this has been discussed already in the past, but can you
>> please clarify what is an accepted (or more importantly, not accepted)
>> solution for this issue? I'm not familiar with the history and don't
>> want to repeat previous mistakes.
> 
> The problem is basically that attributes can only be 64kB and 
> the legacy SR-IOV API wraps all the link info in an attribute.

Isn't that a second order issue? The skb itself is limited to 32kB AFAICT.

>> So far I've seen discussions about increasing the recv buffer size, and
>> this patchset which changes the GETLINK ABI, both of which were nacked.
> 
> Filtering out some of the info, like the stats, is okay, but that just
> increases the limit. A limit still exists.

Any objections to at least take the second patch here?
It doesn't introduce any ABI changes, but will allow 'ip link show' to
work properly (although 'ip -s link show' will remain broken).

>> Having 'ip link show' broken is very unfortunate :\, how should one
>> approach this issue in 2023?
> 
> Sure is, which is why we should be moving away from the legacy SR-IOV
> APIs.

Agreed!
I do not suggest to extend/improve this API, just make sure it's not broken.

