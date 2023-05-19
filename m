Return-Path: <netdev+bounces-3952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D851709C3E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1AB8281D1C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0935D11C89;
	Fri, 19 May 2023 16:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F0C1118B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:17:16 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C2A13D
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um4nw6DUiUHz9kQKF1CXBjtbA2wcWf2520aVhSD40BLK4V/yVDVEMuNn6g0m7i3tOCgLl1SOS/D+quaMJR7mslQzeN3p70jd5cZLyOjjbYUWnfvkLVWhzm7IEQWpSTIqp0EozBI8P8kG0hUThnOCn9m7xN6o6mRRNC1Bcc0met4ZlRYwX8qlxHIR2BjPZd7y4K5P4ltDkdnDXeMD7hZrbzWMfJSuae5W9z/JJzGzzSPwtYzl8SeGDz03Vr/BnLmeiQnVMeC9+IkhA+pGKGjLZ+gwykGiMblf3pUtZ0DbvtFxjrnsNfKcqH84wb6YBej3GGSQHdsXCUBC2IM+FZn9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxely6fiXpb+yBYMHfhIkm371GUS0R5fwI/2zXXhsyM=;
 b=IbtPbJl8jniYgmhkwxaP0XNcJfbTsLyS+XT9WfuPul4HmTiOPXAxNwAge6maT4KP5WVG2CJzXgsRGuCrohXeNz1mJLdT0Smc98utY3x7jIgyNZGp/bDE0i+NKuxPnIYBHQcHNR+FwOhec5PyUpqTMApZcp9fGDsJGlvx35cnsbhZxFOd72XCsGjvRy8rOgwBW+Ns1i1WCIr9yzDpQP3zZVBfA4G0q3yVtvJxAN440jod/tjBtJRSFJArtIgc0pi+CGXSVjmuJUP3KSm5HuzmCLXh3E2JGNtPf+yYKwpL4Io9ZShEl0pAHvCod92NdMNOVVz0sqm5hXXW0xot0064Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxely6fiXpb+yBYMHfhIkm371GUS0R5fwI/2zXXhsyM=;
 b=rrWvvm/lrOkbck52kT+QxHPyvpjZ6CWFciuZlwJ1vd2+8PoyIcoFZ9GO0rjEx9AAfFfeI3MR4joN1AaT7yt8Vp2y+8s7oDLQBE24nHlB6AJvS9VQTHphhRQw2T2i+0GLzTBTMAWKKpT7IA2T8hS2cii+WHxgUlIKxuSgzkYiW64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.21; Fri, 19 May 2023 16:17:13 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 16:17:13 +0000
Message-ID: <7969d09e-2b77-c1a7-0e38-f10d61c83638@amd.com>
Date: Fri, 19 May 2023 09:17:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Content-Language: en-US
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Emil Tantilov <emil.s.tantilov@intel.com>,
 intel-wired-lan@lists.osuosl.org, simon.horman@corigine.com,
 leon@kernel.org, decot@google.com, willemb@google.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, "Singhai, Anjali" <anjali.singhai@intel.com>,
 "Orr, Michael" <michael.orr@intel.com>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::8) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 93ce0865-8ed9-47e1-4245-08db58848102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AYx2UwT7LW10W5SKX+O2iye6Zg3SpbBI8jcsDmxdnBR5mKIXbOD5yiRtt7pF2ra8A8LZy8a3kruAjxICz9XG5C29nWORUylRtXPn1B8oS5pjCA2YqMWnP/P4e+kadh0czliMFwLZcEmHtJvEjk5rTflKQVx1kIEoBBfPLWw4zjuJ8Jyp3nmjfnqUUb4jW4cN2M6cO+Du/XRfKVD4XzTHgYz/4FMkAyCGX+ayhKeOxrr0SJindO1oOtiUw9srl4PZDVPcFRalo9rTVgIyBPzveJb7lYk7+5xP32QI/xVC+QzCLFchdAZQ1gZnKPuAjC+7wNnRuplRtuELOl3KVgdzgcxfAiiLR9oxNKewd/jjTyUQVU6+TKmqIB+qUYyY5ZP8rGRMkGvCxubzOQyxSm8BxXq/tsqCtErsnL0iza8eY2pL5poEf1Im2tj4zZnW2PlNZDSDvLzR4toynQ90lmt6VHUILBejhAeH8isyAAvB/DMOFKv979SH1b3uTaQO+cja/ZdrdxcrBnMg1lt/TDbWzcRHALiSk2ce9NFMF7UKOYZlf9AkFTFQFu7afN/CugHUpGhdEBNncuHUTpK11hN/hlputqpZo7CAqdUgSWnYmJEf5jGwo5/D8xh0/PyOoTg5R3EoDg83Z5fllMXQYZfHiZoxa4ANccAjie+a8lGCaf92dubQB85uhMK/tqiudY79
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199021)(478600001)(31686004)(316002)(5660300002)(44832011)(8676002)(8936002)(41300700001)(7416002)(4326008)(110136005)(2906002)(66476007)(66556008)(66946007)(54906003)(36756003)(6486002)(6666004)(6512007)(186003)(6506007)(26005)(53546011)(38100700002)(2616005)(86362001)(83380400001)(966005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qlk3TDdpNTlpM29iMDRQdXJsMTgxSVRieTMyU3VSckVHZ3czT1hsUzJTMGpF?=
 =?utf-8?B?bmt6cHd2OTQ4cDJETEt1d0xnYVYvYkpSZXlsV2gzTDYzeTI5dmdCYk53ZnJU?=
 =?utf-8?B?d0RVVHpBdUtyTWVCYUo4eGR2NFhsZGJ3OVdhV1pnRTh3WTJScHpNTUp0N1RX?=
 =?utf-8?B?NSs2a3lRcDNxUStTMnhsWVZoNlQ1YmJrVU0zQ3Vucjh0NlRSUk5lQlBoY05n?=
 =?utf-8?B?d0lwU3VOMzNhTUFrTittYzZabzkyb1BHc1N0TC9iK1UzbGhmaUNQZzFaRFVp?=
 =?utf-8?B?VEM5YUZmKzNIaXJDRzg1N2w0MUVjWTBXVUhaeFQxMkh3ekswNjR0dlVUOUJi?=
 =?utf-8?B?YzhEL25LSDZLTllTS0hFMUpRaGpjZUN6S1ZXVzFFMTk5S2h5U3lMeHlEYzZK?=
 =?utf-8?B?b1BxRUMzcU5FS29GLytXZlVwaDlwejVJMlp3VERsWWlLdGczdmxHc083MGFk?=
 =?utf-8?B?WlJ1SlpJYlg1dmJaaHpBZE9DY3p1L1NtVk01U1RSRmhLc2RKKzkzbUg5ckZ4?=
 =?utf-8?B?ZFE0OUFNN3hBL2RNNmI0Q2hvVGhaY1lKaVRWNFo4TzBYcTFTNlNqNnpPUy9T?=
 =?utf-8?B?a3JldjZLZnpCQmIxM2dCd0M2UmpSak1SSC9KK3J5QzNHMiszN1BHNXZoemFT?=
 =?utf-8?B?ZUx2bVJKb0xBbEx3R0M4RHoyMHZJUGZ5QXhTdmJHc0RwR2JoMnVpdEtkWkdU?=
 =?utf-8?B?dC9BeGR6ZVV0S1BqNTBKSWgzTW9NRzJpYjNYUUhZTGdwNnl0MnA1cXNCN0dz?=
 =?utf-8?B?dlFoL0lHWTNGUVltSzZMNVBZZzBzZ1hROGkvWGxsK1ZhaDZ2RjZ0cXFFcTFO?=
 =?utf-8?B?SDdDbXZjNUVjZlRTZktCeU9zeFpXSTh3aEkramcrbUxrbHRCYXk1aE04NkNU?=
 =?utf-8?B?UU5RaFE5MGN1Qk9VNm5SQWFwSTBiT2NWdVhJbmY4dHhRSUhzeUg5SVgwVERI?=
 =?utf-8?B?TXlBaUF0RHNuZlFnNlEycXNSbXlnaWNQd2hJcGdqZktKcjQ0enU4cVRhMS90?=
 =?utf-8?B?eUJ6MmRNcW9MWGpIb3JuWnFHeG1oQWFZNnpCckYvSW90a05lOHBmYU1DZHlJ?=
 =?utf-8?B?eTZVbjQ1VGdZZWJVaG1yM2FGdit4YjdhR0VSWVFjV1ZQb3J4SThQTXVHYmdY?=
 =?utf-8?B?MFhydUFLMUhMdGtSSFFsVFUyZ3JEV2k3MndDWkpmM1ZESFN3ZER5UVVZYmNo?=
 =?utf-8?B?a1pjbUFXZHZueSsrWng2R0ZZY0V1TExxb3JyQnE0ODJ5WE9zSGRScG4yN2VT?=
 =?utf-8?B?TExhWlZtRmN2RnJ2U3VVZy9MQzdFUTZWMXFtTnJ2VFRZOGhKd2NnMUI3S1Qz?=
 =?utf-8?B?Sk9FUEgxSFBLeUpMWWh3RC9GSVFXcWpMUHlnb01hcm9ETHFDd1JqVlZZUE1R?=
 =?utf-8?B?WEsySFFBMlVNWTk0aFZPRkgzenBIb1RaOEpkcEwyMk9iaUxhcU56b1RoMElI?=
 =?utf-8?B?ME4rMWt2Ry9mcXVjTmVSN0oxU2tuc2JCWTR3RnhZK3FldHBHY21VRzN5bkEz?=
 =?utf-8?B?TnliZC9vR2tQbUZJRlVjRjBneldSK3ZoNGhTOEJaekR2MzFMaHowemtJZFFI?=
 =?utf-8?B?N0RDVGF4V0xwWFh2ZmFnRXBsREVIYXlHVUF6a2VzcU1qMjJMTWc1cW5meWxR?=
 =?utf-8?B?THVCNjI5elMyb1ljR3VjQ3grYUd2NlNrMTFTWHdUS2w3ZnIwRnBBL2dpQ2VM?=
 =?utf-8?B?Yk5aRzFheXdKejJkUFRpbTJjandmMUF4S2Nram1leXI5TytjcC8wNDNSYVN5?=
 =?utf-8?B?UEFuYng4RXowalVNc0d2MmlPa0kwZ3hWdGlwS3RHNHBCekpLbDdGd2NneUQy?=
 =?utf-8?B?TC9POWcwajBwaEV1UHZtOEZ1SDNDZnJTUGY4TUZmMUYwRUNodGUyZUxqOWNx?=
 =?utf-8?B?Q3BUbVQxeCtKN1hwMW1wbDRQdElLZ25la2xrdmRMK3hoaDQ3TmdDRy9oRmxn?=
 =?utf-8?B?eTBQVHo2Ty9TQ09mdEVoZ1p2UGJQVnk1dm4xcEt5di82VUhUdWExWWMzVnJZ?=
 =?utf-8?B?SStGeStQbXJwd2FSUkU2OEpURjk5dnlFbWNaMjVxdElvWDdFamExdUEzRnhh?=
 =?utf-8?B?MG0xS1h4VVpaWHkveTRwQXc3cERKeXN0NTdwT2NjUjkwQkszNWNnRHpiVXRr?=
 =?utf-8?Q?sGLQfc9oKnTuYI/QwHGiYQVlT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ce0865-8ed9-47e1-4245-08db58848102
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 16:17:12.9500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6s/C2EKoV9GS/S8WOjPqLpvv8KuGa/s78rvFxjOzAl05qEZgYRYXWpqpuSTivJVj/ZdXTh17WNVpIfQfOBtCmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 4:26 PM, Samudrala, Sridhar wrote:
> On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
>> On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
>>>
>>>
>>> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
>>>> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
>>>>> This patch series introduces the Intel Infrastructure Data Path 
>>>>> Function
>>>>> (IDPF) driver. It is used for both physical and virtual functions. 
>>>>> Except
>>>>> for some of the device operations the rest of the functionality is the
>>>>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
>>>>> structures defined in the virtchnl2 header file which helps the driver
>>>>> to learn the capabilities and register offsets from the device
>>>>> Control Plane (CP) instead of assuming the default values.
>>>>
>>>> So, is this for merge in the next cycle?  Should this be an RFC rather?
>>>> It seems unlikely that the IDPF specification will be finalized by that
>>>> time - how are you going to handle any specification changes?
>>>
>>> Yes. we would like this driver to be merged in the next cycle(6.5).
>>> Based on the community feedback on v1 version of the driver, we 
>>> removed all
>>> references to OASIS standard and at this time this is an intel vendor
>>> driver.
>>>
>>> Links to v1 and v2 discussion threads
>>> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
>>> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
>>>
>>> The v1->v2 change log reflects this update.
>>> v1 --> v2: link [1]
>>>   * removed the OASIS reference in the commit message to make it clear
>>>     that this is an Intel vendor specific driver
>>
>> Yes this makes sense.
>>
>>
>>> Any IDPF specification updates would be handled as part of the 
>>> changes that
>>> would be required to make this a common standards driver.
>>
>>
>> So my question is, would it make sense to update Kconfig and module name
>> to be "ipu" or if you prefer "intel-idpf" to make it clear this is
>> currently an Intel vendor specific driver?  And then when you make it a
>> common standards driver rename it to idpf?  The point being to help make
>> sure users are not confused about whether they got a driver with
>> or without IDPF updates. It's not critical I guess but seems like a good
>> idea. WDYT?
> 
> It would be more disruptive to change the name of the driver. We can
> update the pci device table, module description and possibly driver
> version when we are ready to make this a standard driver.
> So we would prefer not changing the driver name.

More disruptive for who?

I think it would be better to change the name of the one driver now 
before a problem is created in the tree than to leave a point of 
confusion for the rest of the drivers to contend with in the future.

sln

