Return-Path: <netdev+bounces-7883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D486D721F71
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37CB71C20B09
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2588AD31;
	Mon,  5 Jun 2023 07:24:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD84E53A5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:24:22 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF673F2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:24:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSPepXR+FIPHr5th4S2RiwKtXmhSn2KCXZvpmguM9yfmTBQ7jsg9YCLuc4zVgmVjFa0jQRyAinVbMPDdBdLqrsqKZl+zRrpr9v+9dNNH9DuXNk13Xhag4VBZrnmfmY4ZYridVmp7laSnl0M6RyctmBAPC97zLFxswF56Q501YTHpkiiELSPu1+2wFqhaSucPrpbu33ARf8oQbsmYrK+xLV+UAnOOeyrC5lgFgwoN3Mh/mJLlV6dRuNeNPjjo01VK8mudnBhHrKN/g52BvjlvSHyDlTZGf3LBbSYKpoSmNjU/a+XZtADYAwS/tELpJUjNPbH/yECEpHqqA7vMbhysiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rahZm8B9vifHc7Caab2fQhSwSY1UL0upCkUQLsJp2q8=;
 b=ALFRHwvFh8Tn2eVvRSqGByYB/PdXnI6U8GPbthnYis/zpAdOIcY8w3YXo/kYEpEfqRWik/YTZrAsv7cuNY1ntyplV7mbBp4+6+/d+T226Fxl9VuqJ0iSR78v5yuQowugQ6/1h/xfZsZovjSxnQAIQ5IwCWM8my0UVKi+wsigGilqV89X3Qk00c2T96HRb4b60Q7elsESh+hg5233HYoj4PHHOBHaYqANPnmWpLbJrdoI5YsOWlblIprfeZaxjw3/O9dvLOCc86P6diK1K7MxT/7CsW9rC8ayaXFEuRLo7mE9RxE4ShDe46Fa5WczU/P2MQ4M+sj6FjFAFCSHDT4p3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rahZm8B9vifHc7Caab2fQhSwSY1UL0upCkUQLsJp2q8=;
 b=IAyOfy1t4tVH3Rh0rgsHQ7A3bS9OpoHFaQ/yLoLtXxJHFCZx9N+5D8srdszP/TN2RMLar8c0jz9avoXgNXZIVAIDmdQ1mnVqmfLRWDOEPKsTvZ8nlpaFzI9t3WtuffpB9pmf8xjdeFk21Ltrqd0oDXJXPV1Xaf5jbx7j7FSS9l+ty7dApAdafKaEKF2N65t9cWbEjRzfhbR1k58q9nb1U7LMEPOqGBxcduhDhv+Xus4ICFzT4MvnDxvP1NeW/CqteOkOarkn3f+AHq+ECCzmlHWB8g9QQAHuYg9+GXuKF+4baBrcZNUAWgeJzjLCalaxawnA8MGQusHZfCYHB6DiXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Mon, 5 Jun 2023 07:24:19 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:24:18 +0000
Message-ID: <020bbca0-46d9-205e-0367-b14f4b0cc086@nvidia.com>
Date: Mon, 5 Jun 2023 10:24:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2] lib/libnetlink: ensure a minimum of 32KB for the
 buffer used in rtnl_recvmsg()
To: David Ahern <dsahern@gmail.com>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>,
 Eric Dumazet <eric.dumazet@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>,
 Phil Sutter <phil@nwl.cc>, Jakub Kicinski <kuba@kernel.org>,
 Michal Kubecek <mkubecek@suse.cz>
References: <20190213015841.140383-1-edumazet@google.com>
 <b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
 <7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
 <20230531145148.2cb3cbe8@hermes.local>
 <99d127c4-d6cc-4f68-8b73-3ba4f4e6b864@nvidia.com>
 <a34a8392-9c9a-7ce6-1289-ec3a0b6e2e0d@gmail.com>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <a34a8392-9c9a-7ce6-1289-ec3a0b6e2e0d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0231.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::11) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dffbc6e-cd3a-4822-3392-08db6595dfd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6BvUUwOEE9HJOlTyTL7zmx0otCmX43NqEn6GyOcs6IkiBEjOfIi34TFF2E0x2LeUm5aQbUL82+5j5rdocJkctaUJHwt1eXMO2wN+3vCzUmHItXbzaGww0o6TqroHCV8MLE3rY+ncxd3EMHFRksgIU8/seZFGAmyXewgNQkEP6Tcz0wdJSIK7w5MM2q8yZ31mQUz5osIftfaOgEcF4SJUd/KWa4RGxHyxiBIJuunZJE83i0SxSrFNzFtbUE7NgMD3AqjGJ4Aho6UYUja1E+vjDHvFonds8GDNtVO2pFVIJ584/mghLUE/7nE59Ovt921PKGHHvEcrqjZ4kkuPdA8IE1+SDQisZVDOhnVhhO0g2Kj8RL6RqivFaAPW1Vu8i7idOgPk4E1PZXdJkI0XfDmUx4zzfCO2GX1aTQsLZlTOCF6bRt8lvPkwwbKAjezqiFItY12rIBWYYVz1YvJlxPnhBW6eCbgDtubdMGuukdIreIi9Gv896FED8G0W+5YcqXzX4RF/I3dpBB+0ZxAR4QmGim9nZnfShZtLqKFj2UFerOCEweg2ceQhKd1KyVIVbXicoD8XY1qcmikThjPGx/8LDTGiPud6G3/l3AbQYENVjwHJiPgCQrLAg7pZuF1qj3dJrvearqdwK8jJK/vLX1n8/IJxQqdAwnfIeBrCnmsFq08aK2jkGSHXgla0BwXaXR4O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(8936002)(8676002)(478600001)(54906003)(110136005)(966005)(41300700001)(5660300002)(6666004)(316002)(6486002)(26005)(186003)(31686004)(4326008)(66556008)(66946007)(66476007)(6512007)(53546011)(6506007)(2616005)(83380400001)(2906002)(4744005)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTNRbXNqZ3lhczVmNlRNUnJqaUpQSzlOSWZQODA4elhqajYrdjcrbzV6VVI5?=
 =?utf-8?B?enJEOHlOcWtqT3A3RGpmVU1wMjBDU05hT2pPM3RrQ3hCSlc2Sy9WSmpnSmE3?=
 =?utf-8?B?OVEwY1o5dXBwc1hleDNWbTRJZExrUjc5UDY2ZElwaXlBZ0hQM0JWQUkvTUo5?=
 =?utf-8?B?eWFZUi9kWkk2bUxIbHZDajNWVU13UUdKdjRmdG4xbHlUeTI2ejZJVGtZUUJz?=
 =?utf-8?B?Vm1Da1J3Sll6UG8wN2s1aGplTUgrN3dwczNVM0RVNUtZaDBGL0ZDNG5oanor?=
 =?utf-8?B?MUE0TWppWjJYSGNLODJ1RjBiNTB5eGVXTFRtMStzekkvQ0Y3eWZEamI3YVNV?=
 =?utf-8?B?aURJMlZNdWdsbEtkb0FoTlJYMFZhdFhLcjRqZmw5cjh5QTdnSi9sbGZYTHRV?=
 =?utf-8?B?bXlRT015bVlKQkluREtyTTFEQ1pwQnFyTDJHRnA5RXg4cVdzdXRaU3d5ckZr?=
 =?utf-8?B?cnVtRmg3NS9zUnZub1VtUmFoczcvSWE5ejBoeXd3bW1BSnFHM1F0TkFiRlRP?=
 =?utf-8?B?QUJQbXhYOElNKy9pV3ZOMUJSL3RaQW9QTzh3c1E2TDVpYjFQdDhPczRvM2VX?=
 =?utf-8?B?UnZLU25qUklrM2NVbDlCaVFqRmUxdW1meXJUWnByWllYOUdLUWdVTjBodUdo?=
 =?utf-8?B?Q3RPRml6SW9IN290UkFMTkRHVk0zN0tiVnFJSWVSZndTeFpMamwvZ3R5Uncw?=
 =?utf-8?B?Ulg5RFhFRXpuQVZFRG8xS1hiUm5QMVAxRHk2WkdMcW5TdXYwSDQwVmtjd250?=
 =?utf-8?B?NHVyeGkyU1JOakdMbVpQeTZTWmxyZXlwY043S3dGWUpydlZUSTBoS0hQd0Ev?=
 =?utf-8?B?MGZuZ05mVGtzVVhpNWo1TmJzQ0h3Uy9RbmNrUW9sNW1OT3JPdURhU2l4NTFR?=
 =?utf-8?B?alVKL3h6d0Eramp0ZWpobkg4YmRoUnBvN2FoUEdsU0xMaDQ4dkFvVUdVd3pM?=
 =?utf-8?B?SzM2WHhEUW1xRnAyU2ovSGE5N2loUDRUbDhwQmR4ZzA1ZEtaT3JFeXFMeTVN?=
 =?utf-8?B?SE1FQ0luOTRSelhyYjRKQk5wTVBTcnNlUEVzVUgrbDNtbHA1eHdQQnpnbGdJ?=
 =?utf-8?B?NGtEUUJCek9CYVZhQzE4THBVVThqd21VS2N6dVYyazhqVjFEUnBpUENnOW83?=
 =?utf-8?B?clNkeks0dStFN0F1MThHNW9pUUhDMlR3VkhVL0pBblFGbnpneGZtT0lhc3Uy?=
 =?utf-8?B?ams5SEJqSEttd3YwTEsydlk2MVZzOER5SWZZVFpzamhSWDNPeHRBeUkwT0kw?=
 =?utf-8?B?VXZwcGJrWVE4cGFRTXVQQzZDQWJXdnV0a05XUUNya1U2c0diTk5zN3BkZkg1?=
 =?utf-8?B?T3Z5SkFrZUw5dW8zK0tSTXQ4dkd0bzNkZldFcGdtWXlleERJaUtTREw2RTZI?=
 =?utf-8?B?M28yNW04SkJaT2dMc2RKaGZoTWd3N01yQUt0ZExjMzhNeGFIVlRHcExBOW1N?=
 =?utf-8?B?SDQwVGROSnMrYm5TdXhVbUJlM3l2ZmJIZko1VEtmRVdDOVdncGlZaG1SRVdM?=
 =?utf-8?B?RWZZS09Vd0VidXVkOGs2cmxIaDYzaGJqbnBBdDdwaFdiWTN2SGFBd05PYUt6?=
 =?utf-8?B?cTZkWElqY0djcWhQSndNMTdRNHlQa2hzcjhLSzVuelpSdHR6Tk54eldnK0Zr?=
 =?utf-8?B?Z2p0N1h6dmtTRGowTjlWVm84bmNoYllZUWR1NCs4TzNvNDlEamN2Z2JvamdW?=
 =?utf-8?B?amhMRU5XU3YyNDQxTzZrOEhLdU5pSThwV29FeHM2SzZURDJZMlJQaGVvaHNC?=
 =?utf-8?B?cU5BS25acFpSb01FdmFpRy9tdnBEN3JqdlhteHlKQ25VNzM4VWhNSllMYUNS?=
 =?utf-8?B?bkF4b0NJYXFFNHFVVEhibytjTm16TVVNU3gvN1ZVckJ3MEFjcCtRaE9CSHkr?=
 =?utf-8?B?Z3NsbyswK1cyUWtYUjIxTHMrL1FCb2lCclQwM0NLNXB1TUlqb3lhc05DSFg4?=
 =?utf-8?B?YlQxRHBRTk01OFZNQTZGK21NblI3cUhXeFdjOVphT1ZmNU9BRzJCNThxSlRX?=
 =?utf-8?B?SDJGbzg4dlh6YjQ4clVhbUQwMHp0Y29sQkQ5MFJOUER5RzhzaWhpcmJtS0NE?=
 =?utf-8?B?LzJSYXgxVWcxc2c3TEdoUXczVVcrS0xldHFpbEtIZVYwWktZWkFtVU8rd3Bp?=
 =?utf-8?Q?fKJIgh6TWp0rq6wjpPxAvLLAp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dffbc6e-cd3a-4822-3392-08db6595dfd3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 07:24:18.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWykxG5tUoOC55p3FkoahtkUDfHMBa3RoJ+d50/oNtYypT1VPqQ9kvB5MZ8LlohB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 04/06/2023 19:03, David Ahern wrote:
> On 6/4/23 7:33 AM, Gal Pressman wrote:
>>> It is possible to dump millions of routes, so it is not directly a netlink
>>> issue more that the current API is slamming all the VF's as info blocks
>>> under a single message response.
>>>
>>> That would mean replacing IFLA_VFINFO_LIST with a separate query
>>
>> Thanks Stephen!
>> How would you imagine it? Changing the userspace to split each (PF, VF)
>> to a separate netlink call instead of a single call for each PF?
> 
> 
> This is the last attempt that I recall to address this issue:
> 
> https://lore.kernel.org/netdev/20210123045321.2797360-1-edwin.peer@broadcom.com/

Thanks for the pointer David, this is helpful.

