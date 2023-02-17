Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48A269A3FF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 03:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjBQCoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 21:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQCoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 21:44:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C013D37F15;
        Thu, 16 Feb 2023 18:44:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGMeSA8KfFzve/NLAolr8wvd2Hw39PVHOEbtOViKXwbn7B768QyN+nNwfWJuqRQ4n1yBOtRHmXRbFmGzGxbMqYX3elvvevT1qJXzGKJef/k+Sdjjtd42aX7YMumJkWClsH/XZw9M+xjIPU1dU7kl2LadWveMQaIBzugHfz85DJSqOeC+zOM6dvFBD8wCc5MetYUnPM9dTbenrBP3LfsHg2DcRvVugJ2aXdoCh7oDnt0ncY+2JaHKJsOYKNU4FCgmsIuqmvSM7gMWxu7WXsyQwXr6AjDMApXjBtEdsmkd5KWS7Em+04o7Bsfkef63LSMs++SlJo0poG4q0P+Ca+Q+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChJhnXy1I4sHy7SvfWGQhyHcD8fGmL8S8VoUvV4QruI=;
 b=lYUPptMJoTU6E5O415giC5xGtzgRxAhzVbYcDuZslriApj9a/2cU5tRt6TFetMihzfQSZnl8Kg8ZDOxyjXB3HC4NW+L9LzUcJyiE9pe/Nw/lmKfhQqPsizN8oJbNxG9pIqLRRAHRIEEJxzrcrsmduAAuJHSyjB9I3V6XcMjinuBalpxSm/87OoXam8V3EXYptdESsedz1Iob4rrs615nn7ZYK/+rPQHpn53398+ZLzfl0kcObO2cJKDWDA5AeQ1vm3XoHBPqFIXvxzA7NnCjEGWd/bafIjBlz5R0pS+GK/bPkOWQ4XVJjn8/uSfqs8w7qM8jR5M448uNs+8xVAjeXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChJhnXy1I4sHy7SvfWGQhyHcD8fGmL8S8VoUvV4QruI=;
 b=VB1cQukofWF/gHkpEThXGS4d+kapdHEPoMvwcpgCpby4MxbvBC2ooM88tq3QjCvCyHQzN/SZhd3uGfIj+ipYx4T2EV6uBIzgPxjAIhaxEDe0h9veiphe/7SoiIP9VMtt9BAkGNi3lXE/BNNyyo7WKDGwY7amzI2gqsisV9PlrydL/i3FNeuVy5zeT09pbWBXa9WKn0KpsjxXZ0imO2A80iO1AvDomrTF1AH6JHpS6Cbe3Zg+9broHQ/teJXkwfv+OXI+KjH3+kybwfyySXz/rWTF+Fp6gYj+B4LQ5sB2wPOzDJILDUzndppxvabBoRzZkEMH2c2plKbol+wdsPKroQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 02:43:56 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 02:43:56 +0000
Message-ID: <ca729a48-35a1-ef05-59d3-ef1539003051@nvidia.com>
Date:   Fri, 17 Feb 2023 10:43:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
 <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
 <92d83584-2238-f8e8-3ed6-f292223e4061@nvidia.com>
 <dcc5578e-89d1-589f-3175-eb8bcd58f7ec@intel.com>
 <76b74086-ea65-7bb3-1eb0-391f79d1c615@nvidia.com>
 <aefe00f0-2a15-9a43-2451-6d01e74cc48a@intel.com>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <aefe00f0-2a15-9a43-2451-6d01e74cc48a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0003.apcprd04.prod.outlook.com
 (2603:1096:820:f::8) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|MN2PR12MB4502:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e396b09-6cfe-4a1d-b171-08db1090d06a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sYSbIjSk7KZlAaGjvFGUsDWnOKWzlXWBYxOx87cnca9NfWUCWFt02raF9XS8aXMCXe/H+FzouJSZOsF1nbrinZtfnlNwIpkeCDmtKFkU42uWDlcNNUBltIG6zgQDUUUHchsYdYX0nRjhQcIkJjx60Fb1welmmnjw4tB25zOGSriRBUG5mNeFPlUrP4SD28QneMhAnGHCvp041ZtnzWTykKGvN6FYOa/8sPRhOWRsXOANZJ/xfqSyK69ODnFDUxUpmrfG6gPHkWNM9+nnzWZtKq1gNLyl6xNTQtOLxklw25qcS69aquZ7wIwQXD579CG5f43VcItSrBHWtDw9tqzAU70CsuVpunfxfif5Ls8hwy6eV81bvxyVY8o57YYAaZs+Sz7QT+iPuakWs6J70FGoPgiGbPxBHfhHpGqGtTM8DIE7Yb0x084TFkcKpiqG4OWWZhbvbdQE/JC3ZafP3PQVQBCiOOj7iHWm1151bGMBUYY/3cmOCMlCXoY4dcTJsJtXNDd2V9tTFiuixR0qkIKULbAJ96pohvK3/3oeZgN3hdpNPwJ8xyTEkZ6B7kfbU0/rmpYxXIBNiwV28P9UFmUlDqanrDX6UFOxLr9CUpUmFM5Lx+Sca5jE0rzNKscf+mdSxRlyTS4beAbXGPR2IguPmIRc/l6ohpHcFzL3lpPEXJW0fztj7o3dxSkQ8w/cOazq6YkrSpZDW5UdtdJ72iQ86OdfFxRi7Jh6RW2iiRWFcqxfg9X5UXQ2swnBv/UstEJzEr0x0KR+TjY7858P4JhCdw6zMdOBBqKdddd8wSGvB4xD/khTGhNhrT9wDsaOLiN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199018)(478600001)(6486002)(966005)(83380400001)(86362001)(31696002)(38100700002)(6666004)(6512007)(107886003)(36756003)(6506007)(26005)(2616005)(53546011)(186003)(316002)(66476007)(66556008)(5660300002)(4326008)(8676002)(6916009)(54906003)(31686004)(41300700001)(8936002)(2906002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGNYNjVRcHk3MmdPcGFoYzl1KzU1Q2xOZGpWQ2hiQUZwajU5T3NjaWF0cE5k?=
 =?utf-8?B?NlJrM2NYcnhkU1hYR0Joa0xEbWVSUCtwbnhYVVJERHh1Nk1ma25VVWFwNjZr?=
 =?utf-8?B?TTliSGZ1WU1tYjQyN2xzYUh5OFlBWGwwV21rVEFzUjZsMzdlWGNWWGgrajlt?=
 =?utf-8?B?SUVOMHlqNW9kN3hOdjVQQUxNL0dxSjE5SUJUOTVydVpOWXRZRnV5SUk0cnUy?=
 =?utf-8?B?S2cva2VsTFRlcm9RK2luMFJKSHJ1S2wvUDE1NzJJSjh3dW94YjRKZnAyN0Nx?=
 =?utf-8?B?bklvS0RVcy9VQTJkbXRYamVvQ3JvUHU5Wi92THhSdkF4WElZTEhBbGlBOWZh?=
 =?utf-8?B?dEZRNFpIbkN6NGJXRDNGWWpYaWtqSVM2Ni9CTzRVVXlMbk93UjJPd2x0bXlQ?=
 =?utf-8?B?NEh0QXNFdkZ4UjJpMEpYS1Y5Y1ovM0NlL0ZKbTlxZVFvcnp2MVNFQlJVQyti?=
 =?utf-8?B?TmN2Vkl3MTJ4RnAvSGRoQi9VZzgzNHQ2dDczZjRnVkxibDBRdUNmQlpvV1c4?=
 =?utf-8?B?VExKc01VVjZ5UGY5UXhoZ2UwbW1hQVl5Q1pUVi9pTytyR2FDYTl5NXlzK3hJ?=
 =?utf-8?B?eE90UUorVS8rLzJvZHNmS0d4NlJJRkExYTIyV2JMSFF1WHdoTDZXTnVzV2Zx?=
 =?utf-8?B?eUVCVEhzVWgwRmtEV2UrOWJac2lSdDVqVVR4N25qc1FUTkxGZExQQjNBTGoy?=
 =?utf-8?B?TkhZcnhyNnF0YnlMMDBqK2FtNDQ4TFRZWUxFUWVuQmJ6MnlPamJySVpsdHVp?=
 =?utf-8?B?WHM4WFNMUTB0WWRtK0xtY00vWHMzNDErSklveEdFaGhpYVRvMVJXSmhIaVJ6?=
 =?utf-8?B?VXFsL1FaUXdyVkloL1Fhb2tLZlRESjBmZFJDbUxMdUd6SnBoSkRMU2RHbGRx?=
 =?utf-8?B?bENGbzV5Rms1S1VkYVNuNHVBZVFmdEp6bHVucXdoWkxZdmx1NHNVekdMUUly?=
 =?utf-8?B?Y0NzYkJTOGFNRnF3cVlzeldya3ljOGZ5b3pxQ3ZLeW9VcEFaeVIxWDRHWTZ3?=
 =?utf-8?B?ZzBqREF0UVFHbHRLWlRLUmNIN3NnZmozeG9hV3plVEJpUmNmZUhya1o1U254?=
 =?utf-8?B?UWRYYTV3Q0l3aGhyV1pXdU0wVjV2aTIxSjBZYmFwR1lrS0M2QTUveURxNWll?=
 =?utf-8?B?VjRRTGZEbzNUVHI4WEJFUkFSYXo1NHRaRTFPYktDa3ArSlJOZFcxdlNFL2Jm?=
 =?utf-8?B?RmpGaEtGVmJDaXJNY1NnNGloclIwWGcwSmQreVBNZDlSR3FOYndJOUhEbUpp?=
 =?utf-8?B?UGhYeWRSYmE2UkJrMkF3Smp5bm1tTFMrc09HOXAwZzdWVDlUb2FFWHVKM1d6?=
 =?utf-8?B?NDdRMFJQc1FHQ0tWWnVKSW84NlQ1SThGRS9MYThHODgvbGJWQU8zNHhZTmIx?=
 =?utf-8?B?NVVFa3d6OFhhZjFnZCtQZWNGc3hONC8wcno4WDNUUlVaT0p2aUJjblBPZHZi?=
 =?utf-8?B?K1N4RkJORkh1VnhrcjRsaHNjZ2hLbHhQdFRvS1NKZFBaZ1FOWjUzRERmRlhY?=
 =?utf-8?B?em1nUGxJdmEzcEgzME01d0pDanF3aS9EL3hsNnpZTHc3VE5mYXhqZlF4Y29T?=
 =?utf-8?B?THJ1UndrRUdTT0V3ZjJ5M09zWHZMVFI3L1lGQlhFUCtpMVdKcTlnOVlUY2Q3?=
 =?utf-8?B?THc2bzBkaTRMbERBZW01Z3VHNWpON0hzYXVrZnFYdVBNMkYvdkE5V2ZZbkRD?=
 =?utf-8?B?MjR6a21JR3g5R2wwcEhpZjB2Qktmb0ZlMGFjUHJKTS9TN0dpZTM0Vm1IMkRL?=
 =?utf-8?B?d0d2Um8yTUd5UTRPTUxFK0VtUFFEMStLYmR0K2dPSGhPQitySkxNazBkSkpJ?=
 =?utf-8?B?eDIzSWhmVDhEdHFwNjNkZTl3NXRjYTNRSGlHQ3IvZ3d3bk1yN2tKeVJ6RmlI?=
 =?utf-8?B?UDUyZGk0N0c4Uk9FQ3QvY2xUbFNpNEJ4eC9maklDb045dW5YZVQ0YjNMQS9S?=
 =?utf-8?B?Y1JZK0Rub1g4cmFhK1FIdjA5dmhiVGo0UzY3WEhxT25uNXR6WjB1YlJxdVMz?=
 =?utf-8?B?ZDJHbTY1VFp4c0JoaEc4WUVvQzBFamt4aURSWUdESkJCcnJYRDFYSG8zek5L?=
 =?utf-8?B?L1hMa1ROWi9MLzFYMFJVMTZOWWlic1FmcDloTHRRaDBjUWVQLzdrMEZKakhv?=
 =?utf-8?Q?fHTHtV1t4xMLjJtaS4QAgbeKV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e396b09-6cfe-4a1d-b171-08db1090d06a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 02:43:56.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Os9Y96nAs3ASvxESB9wz34oUpwU66c3TKrqiZzFBgVAismLwadyL+5sVZaUVZf6MjlwWPHjFtwfEBU8dKDIMdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/16/2023 11:19 PM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Thu, 16 Feb 2023 16:40:33 +0800
>
>> On 2/16/2023 1:01 AM, Alexander Lobakin wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> From: Gavin Li <gavinl@nvidia.com>
>>> Date: Wed, 15 Feb 2023 16:30:04 +0800
>>>
>>>> On 2/15/2023 11:36 AM, Gavin Li wrote:
>>>>> External email: Use caution opening links or attachments
>>>>>
>>>>>
>>>>> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>>>>>> External email: Use caution opening links or attachments
>>>>>>
>>>>>>
>>>>>> From: Gavin Li <gavinl@nvidia.com>
>>>>>> Date: Tue, 14 Feb 2023 15:41:37 +0200
>>> [...]
>>>
>>>>>>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char
>>>>>>> buf[],
>>>>>>>          udp->dest = tun_key->tp_dst;
>>>>>>>          vxh->vx_flags = VXLAN_HF_VNI;
>>>>>>>          vxh->vx_vni = vxlan_vni_field(tun_id);
>>>>>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>>>>>>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info
>>>>>>> *)e->tun_info);
>>>>>>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>>>>>>> +                                 (struct vxlan_metadata *)md);
>>>>>> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
>>>>>> arguments instead of working around by casting away?
>>>>> ACK. Sorry for the confusion---I misunderstood the comment.
>>>> This ip_tunnel_info_opts is tricky to use const to annotate the arg
>>>> because it will have to cast from const to non-const again upon
>>>> returning.
>>> It's okay to cast away for the `void *` returned.
>>> Alternatively, use can convert it to a macro and use
>>> __builtin_choose_expr() or _Generic to return const or non-const
>>> depending on whether the argument is constant. That's what was recently
>>> done for container_of() IIRC.
>> I've fixed vxlan_build_gbp_hdr in V2. For ip_tunnel_info_opts, it's
>> confusing to me.
>>
>> It would be as below after constifying the parameter.
>>
>> static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
>> {
>>      return (void *)(info + 1);
>> }
>> Is there any value gained by this change?
> You wouldn't need to W/A it each time in each driver, just do it once in
> the inline itself.
> I did it once in __skb_header_pointer()[0] to be able to pass data
> pointer as const to optimize code a bit and point out explicitly that
> the function doesn't modify the packet anyhow, don't see any reason to
> not do the same here.
> Or, as I said, you can use macros + __builtin_choose_expr() or _Generic.
> container_of_const() uses the latter[1]. A __builtin_choose_expr()
> variant could rely on the __same_type() macro to check whether the
> pointer passed from the driver const or not.
ACK
>
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     return 0;
>>>>>>> +}
>>> [...]
>>>
>>> Thanks,
>>> Olek
> [0]
> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/skbuff.h#L3992
> [1]
> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/container_of.h#L33
>
> Thanks,
> Olek
