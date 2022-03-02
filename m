Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB274CA273
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiCBKuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiCBKuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:50:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B77A20F50;
        Wed,  2 Mar 2022 02:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBfIvpue73tAVQeb8DOOozjiMou4QVHnhNgo9Nfao64bHqHYj7AxHv23ywFfj7jr18VxZgXXGrcXzEf4ugpOEZ379Ew3v81LMJnQK6tVDZTITO/CA5FR/eAyuH4xw2I7Uqm0jfuH1l11MKFcohn6CUSf/+nyttg82i+saMYLrWmv10c3pv4cturAN9IOK9TJxMqADQu5gMmg0T22QO0iFPUx84U0nJG1NI5FVKQbxM+OqZCQqT7YyGxgQjt+gwMss5RR7HfHjtlkBRmczJF1ntBhOjMoR/my5++h4abxsc+b47tg44knfH89BfBUlBQpmSY4+Qo8MvaScn4HGpjviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqIyma0ZqC1M9HNTkbwJmRPvRxshqsu10n/Z+BZYjJo=;
 b=DSpLCMlatJryMv9ldc22d6UYbiiyppdcSc5CTxOPjBNoMmMXJ9vqYMynh0ltCTE1BXehXV1lfKLU8TUUwAahF2PYoPx5zo0kTjID8drXYBvX6s0rm/nuuSJ4kCxG6yLLY6ihOnU7UvPk//O9fNh/ETxO1Gdxf8WPC4Kt/xrIXaVOOqUUpZM85s+j5lNJr33JpLpfh9kLHikY4HR0CyJJ2NWaIz6gaKFZvAUGWw007LGHWSbTaG7986vlXdHTPTFezsi/7gr7XaiChgqw1xbstwdDC+DNH1LPYXY/F4aLkzw60paRuVeQ0wIBEy7WrFeLkWWIFJ/vPUjaw8d5k9hbCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqIyma0ZqC1M9HNTkbwJmRPvRxshqsu10n/Z+BZYjJo=;
 b=tSn2A9eiJod0unCXagqCjLymbviCK2eHYz6fCh+Yrn6e/5yUUZJB8hLOlfH6X1wbmw5sgJW44XBn16ckJUK6V5a1P//0/87ihiAyM578YIQ3hYB2OCw4GpHd02zjy9hQXqvxEZvTPPkkHQP8hDEJ0JpOEvZ3xchwWNK7KV1zd7YP16GaRI2sQN/zIt6vLZVEZ7IIBYiiLKKAmWqcUJ2XlNcc4BdNPo0ZkBLnCWeY5HoQ9Comy+L0zF52Im4Tq5Zg7GSXiDCEHO+9KLqv4NUNfLIDYDuR4Aeihif6reIx9XlmZ3J+8TfYR3n+EKNE78EPcEWnF7/PdZRp32m1aOuCSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by BN9PR12MB5227.namprd12.prod.outlook.com (2603:10b6:408:100::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 10:50:06 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 10:50:06 +0000
Message-ID: <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
Date:   Wed, 2 Mar 2022 12:50:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
In-Reply-To: <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::27)
 To CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb19c85e-d8a7-436f-ebfb-08d9fc3a69d6
X-MS-TrafficTypeDiagnostic: BN9PR12MB5227:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52276D8109B8E16A00F05787B8039@BN9PR12MB5227.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9FgCqp+9qslPQY9kCmMm5SC1zF9iJxhmfkVgmBNTAuw5ZdNDVJ3Dl7lJHPpgY1T6x9QiiGVBYX3p95y/2ko4OXTe31QweKMWFU7AghMKdh3QQbHWKcZ3n9C8jQyvQdVVtA0ESkGu4IcD2mZH/sm2HeffiwARyU7orGjWLPfAgdCGrMTzWuByrsqVz2KfIADcIsrL4OBKArl9K+x2MQDlNm2KJXO+COpEa4DaQYtE7EeIIBu/kpirN87UcJtHA0t5DzW4HSExlrcUAZIheZ5CLx9kyOZ6jhfLCAw3XKqhxzHiWv33kLZXqRDm/oyF7h80obVhXApKoBQ4HSLeUJ1x2gpFA3FiE1t61QQQXrLx2Wm1JyKf93HIIBAZfnjGWdyPrs1hLSbtuOuwvYW/YtsHtdF0uQ3B9eLQ8299OaKhOW6XusjZMFb7wGvfxkoS69cAEVQo07O54xP1ULEzKmzwsqEQDx8bnV0HrmmNKI+OIYQJZMEa7RB2MnnPu/gpJz82TvlZdbKhiB8ntaWjdcS4D2UNvg1XKBCUJv03x/g8u4yuLVr2flPHphRR3RQI3B5QB2j7D34OrjSlbuoNgpunyGPWylu2t2i7cBRl3KQFGGAXmuSafN8Z1mwMPPD45SwpmNuakiqYRNcEG4sSssR99JZ2BSbAPi5kLiOopmcu8rfj9D//MMSmx+wBX4wmqREp7n69KExe3JAZXYsEtzQJWqA4PFlmCfDr26ibd6zHQVRFQBu56IhdfVuDhyWMHUatJMxgge4FLh3f7KYeVlJ4B9V0zu/56nJlcEr+okC17mrUu/UrhZV7weevRhEKn7Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(86362001)(8676002)(4326008)(8936002)(66476007)(66556008)(66946007)(31686004)(2906002)(966005)(6486002)(508600001)(5660300002)(31696002)(38100700002)(6916009)(316002)(6666004)(53546011)(6506007)(83380400001)(6512007)(26005)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ci9XaGlnbmx2MHNUZE03MU5FQUx5SDZaZ20ycjJEVHlSV1FqSWlpdnBKVlBa?=
 =?utf-8?B?emNLZUlOTG9SQkRVblhCbmJtYzdhazYwNDYyMlEvVnloVW13eDNZM3U2VWJo?=
 =?utf-8?B?OC9ORm42MFBWaWdDemIvandFamhKdVRpY1Q1OXVza0syaG1DK1BuYWkzK3py?=
 =?utf-8?B?K096eU1YeFRqdEEwTUZjOUJ1UGE3c2F6SmJaWEN5UGNKSXJqMDl3NVB1L29N?=
 =?utf-8?B?NkV0NWdLS0FZYUo5TTMyVDV6VnBtQitxU3JYU2NvRnBNNDBsVnd3cEJEWUkv?=
 =?utf-8?B?Q1E0QWNZYnltZmJlWUFuZXllNG1ra0grKzVvNVhLWWRSbkR1aFcrbm5MQXlp?=
 =?utf-8?B?djVMTGQ3akE0eXBWMnBvL2pDYS90SUxuQWVXYzNIcThLeERqNGpQZUQzOGVC?=
 =?utf-8?B?eURmaVQzWmFuTlN1d1BMOTZ6MkFmY0cyOFE0dnA3NkpzZ2JpMWZoTnBkVngv?=
 =?utf-8?B?LzhNNnowNGY4NUl6OW1ad0xXQzdCSWdzTVg2TmxFTGNnTFJuZkZ2R09KSGhx?=
 =?utf-8?B?QU5ZdXhuaEQ1TXloU0gxQjU0L2VqREhiQlJMbUE5VGtJVTdETHpiazNLVGhT?=
 =?utf-8?B?WlBzQWdPeWJaL0VtYU5yZGlYWC9VeTNqSmFoTG5NenYvSGM0Nk9Ba1Z4bUlF?=
 =?utf-8?B?QTdDaEYya3R5N0d4NHR1eGpJNHFkUTBBcFl2ZmlVVExvTWJrZG9LdjVzMUJR?=
 =?utf-8?B?c2ZMV1paZkx1bDAxMXdEVWtWQzRUV3N4Mm5FekxZa2l6VVhoYTdhUjZBMHVl?=
 =?utf-8?B?N3pKcWVlaFVic3RYWWtCZVhMVmVnVW1yVTFXRTRYcFFBRVd5cFRnZG9PSnpj?=
 =?utf-8?B?U0xaaElFUGNIZDVHcm41WWZ3a3NiSjY4UTgzT1l5OGZwY2I1QkF2MmdYT2ZH?=
 =?utf-8?B?NzR4MDc3YWdlcDlTODZmcnVNSjlHbXBVakprNWxLYkZmQTQ0KzFMSFJqc0lM?=
 =?utf-8?B?MjNyUm1QeDVPVHhsNER6NndscHBuSlBYcjFSbTNBQWhGTEQ5a1pYbmZiekFT?=
 =?utf-8?B?UFZRYnhEdFg5V1Bxc1lwSFJOZVpiT2JwMTV4cHl6NThYYld5RDErOHlUVFFQ?=
 =?utf-8?B?b1M2Q2RUYXJkSUgrOG5xeGxoaW1oS2lSd2R5d01SVFZzK1FXeENVUTdnNDhh?=
 =?utf-8?B?cmdwTkhPb09SWFhWZ0ZWSGlESGJQeEhIRGpnVDI0Ni84RFFUZkFTLzRreUh5?=
 =?utf-8?B?TlNPWXRKbWw2Wmtmb0t1L1E4SVMzK0RuMWdlcEIrOHJ5REdtZnIzOVV0cWx1?=
 =?utf-8?B?bXBLbHVIL1pVS3ZZWFlJWDFmN2JDR1FFYzlyUTB5d0tRSjRabFFKNzhPRDBW?=
 =?utf-8?B?eVg0THhnTUNDQmpYTXNFTW80TUVMK0ZmSkNpdmtEOWZrK0NTcHlZampwT1lW?=
 =?utf-8?B?RFR4dHZ1dWRPQktqcEhkSXhTQnlrY0ZPQW9odEJ4S0U2clRHYXdvMmx0M3po?=
 =?utf-8?B?NllWc1k5NDNXME9LbTZ2ZWY5cVB4Y0NWUnhVWjlqd0d1R3lsYW50dlRTeml1?=
 =?utf-8?B?aFRWQVJQU0NVbk13R3VtcEY1VjdxN2o3YzFrVENKMVpHRzhFQjBMVHBqang2?=
 =?utf-8?B?MFp6UG5HdS9Ma01EbGs3TjJUR0F4Z2VoU0pXeUpDbkxkRmtVdGR3NFhoL1V5?=
 =?utf-8?B?b3FOOUFQTDVmekNSS1lKOEFZWU1wNVNJN0o5clJtbnZNczl4Vm5NUnFBYVli?=
 =?utf-8?B?YVNLVHE5VHQ1aEN1d3ZDU0JoZ2JoQ0hacm9GVEtLdUNJZmNsdFhDeTJGTHRK?=
 =?utf-8?B?L0x3Z3BCYTJhT2duSDBCcjcvZGZaV1I3VTdkMmJmKzBJYTFhS0ovUzQzb2Z2?=
 =?utf-8?B?UW1wdHR4cWlRSkFyQjRVYit3MTBQY1poamRVY204TnN6UkZEelRlWUFXcnBl?=
 =?utf-8?B?clFFNzF5UGlsR245S2dESmJzNXJnOUxrUEhlWUNDNnRFMGxOSXdFd0tRZ3Z6?=
 =?utf-8?B?bDhENm5aQlR0dFhTTncya1JwczM1eDFadDFWVnRnU3R2anBMekxpeTVSZVdM?=
 =?utf-8?B?dk9Dak1MeHFQK29WZElvdWpQWXlsbHIxMkEza0UzRWlFZmc0YlQvbHJlYmRP?=
 =?utf-8?B?RUIvUlFjNStHUkRzbEwvTTNGdTZOOC9tOUdIb3pISWhwVDRxbGRtaFRlOWVI?=
 =?utf-8?Q?fAQw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19c85e-d8a7-436f-ebfb-08d9fc3a69d6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 10:50:06.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGx8KLtGcTHft1ezcN+oFZoNrIzE26VOU2Uw5RFjTGAjar/595sKeJlL4Atqmfm7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5227
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-02 12:03 PM, Roi Dayan wrote:
> 
> 
> On 2022-02-25 12:40 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net-next.git (master)
>> by David S. Miller <davem@davemloft.net>:
>>
>> On Wed, 23 Feb 2022 16:54:09 -0800 you wrote:
>>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>>> packets can be filtered using ipv6_ext flag.
>>>
>>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>>> ---
>>>   include/uapi/linux/openvswitch.h |   6 ++
>>>   net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>>>   net/openvswitch/flow.h           |  14 ++++
>>>   net/openvswitch/flow_netlink.c   |  26 +++++-
>>>   4 files changed, 184 insertions(+), 2 deletions(-)
>>
>> Here is the summary with links:
>>    - [net-next,v8] net: openvswitch: IPv6: Add IPv6 extension header 
>> support
>>      https://git.kernel.org/netdev/net-next/c/28a3f0601727
>>
>> You are awesome, thank you!
> 
> Hi,
> 
> After the merge of this patch I fail to do ipv6 traffic in ovs.
> Am I missing something?
> 
> ovs-vswitchd.log has this msg
> 
> 2022-03-02T09:52:26.604Z|00013|odp_util(handler1)|WARN|attribute 
> packet_type has length 2 but should have length 4
> 
> Thanks,
> Roi


I think there is a missing userspace fix. didnt verify yet.
but in ovs userspace odp-netlink.h created from 
datapath/linux/compat/include/linux/openvswitch.h
and that file is not synced the change here.
So the new enum OVS_KEY_ATTR_IPV6_EXTHDRS is missing and also struct
ovs_key_ipv6_exthdrs which is needed in lib/udp-util.c
in struct ovs_flow_key_attr_lens to add expected len for
OVS_KEY_ATTR_IPV6_EXTHDR.

