Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC068AFE1
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBENNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBENNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:13:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E301E5C5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:13:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPWZ1jXhF1/s2+8qohjnArgz0+5esu97C1YRT972NxuIV2XPZ82i2GsmO1EDpl5qfBuujcMoGTXfDaOAXahEHs1q5oHTxddyqnTp0Jyhqy+RMpjASVKhgpUz1Ozu128jmsYOmXJWmOkxqB4sYOTSPArJ2hZ+7KP2/bmrJtJmH1MtTVruUiFbIikISDpKr16QqOt0edAXlWl0x4SFmpOpII5TAdqB37A0BEr8ngF36+wxPoprYUKmE0gPi8o+75Zxy6dUMaVSL38LnXwC9avysnbOiPNRxY4MVRIkibsbX4OhzTQkDSdNnyD5+59qRsMLBQav8O6efcQ/OnTJYaL8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jby98k4CUpWpiil6XR5GJ60xHiZE3je9N1WHofDsB3w=;
 b=X7+CILTwzjc82QfLTa5V59KOxV2YhHqDZIbL1rJD+gCL0VDBxM/s7t5iXFpfqcC7aFuTFKpUp1dd7ewopA/OiMsG0c8/O/UI3/Md/Ejsz5e5BTYadShU/xsAj+FWulIm88QGdl3H51VBo3qCmedKHdZpJjU5+/CoRKSpclh1w/ZbL4K34hsFZa+Tt/TqrON4kLEHbY/uI2/TuwzhJIvMhYnWquy/bTsvtI3+gGMKvwev619AnFgKUT3UkfBCxl1wNxI/iRT+LPH5gkWVzYstLcl1lwoIGKOuuprANfIv1TzF8nRG7vpOONBwNX1YE6T+qlJSWfs44A5ovrwnOdEPbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jby98k4CUpWpiil6XR5GJ60xHiZE3je9N1WHofDsB3w=;
 b=Pmt/OaEaAI5/hH4wxOscuz16I5Uyvgg3P0T+NPzax/V94c3g8ndFeKQig486ix72/gFT3HuUSamO6r/pYcCSkNTEX4hIf199jizr5kL1/gEM+5Jd+5IZiFkCzO93Gz0l3IreQWt4kB52mAWWBHbhJ96AAE0l2OFijuCibLGCn7dcLdbc+Ls2ExzUu2WXj0+6XvygNx7IsDP+KbZKq4pLfgfnv5zezd0m68jSTdK2uA02EDCWO05xGNV1eu0W8VBZQ2ICQlX2l73L+oGD9p6KKA1cu9fqOtpplwPSFIMtvjYf4JxiN+yg19fF/5CE/KqyCiQ79HQlj+pYC4nKNPGvjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM4PR12MB5120.namprd12.prod.outlook.com (2603:10b6:5:393::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Sun, 5 Feb 2023 13:13:33 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Sun, 5 Feb 2023
 13:13:33 +0000
Message-ID: <607dcb67-40e9-9720-ea22-32cad299b022@nvidia.com>
Date:   Sun, 5 Feb 2023 15:13:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 7/9] net/mlx5e: TC, store tc action cookies per
 attr
Content-Language: en-US
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-8-ozsh@nvidia.com>
 <CALnP8ZY_QUf2euy5aGGSHZjcZrsWuQ3eTO2kryw80vaAFvaJGQ@mail.gmail.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <CALnP8ZY_QUf2euy5aGGSHZjcZrsWuQ3eTO2kryw80vaAFvaJGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::10) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|DM4PR12MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 0223053f-3184-4074-1781-08db077ac824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpTMW8VUKzam0W7R5fJEFo02kFRH4EEa3SnMMDN7PJzPUXKEMbF8Ph2DS7rNUy+bNHotiZXmcM8LNYYfT1t7kW6Z+KmZPgA5Wz8e/dCkT5BVzOd3oUvD09VzjNDAuDO3XNlAi1VpSzf3x4lPXxi9PHnTpPaaSXjphtrt4pvJ2zUrfVQ6HA5PxOhWR+XVw7OdFDjLNW8YrLtXjW9rXj1Bs2UyvLhzW1VRHmcvU6PX0oLajDofHebJmUIb9EEDAyiLbSsbBm4/KNjlJxMCOvCt0RpwoZCz5zj3paS9M7hxW9tsEHclWFupB+loG1PW0Im4xZ13Uy32U0osr3ZC94UlZgPlI0cfJ4pYvjfwo7ekjK9oRWLopxTuiuEPhEqcnMRcMtTuGmhM/+uzJ0qczxWFBclB5lsvtYyePCBT0FXRllvxLJKs7rLVMDd4goUv9XzUOxCHhSUKHCKcTuFKqH391qO7sQX8no0UtnmPg5TvfLYet799QhZWz/hOXOsZJZ4WX73umCWSsk4odgOkOOHR0Rpj6/dq2+NjOE8OneAcyaRiRYqlJOykTAbE39lfRH8LHS48MaguB4UneZoFV0u0kalCanJv6d7PxaJKrDy6yTGaELBOHh84S3EZg7otaKbGAyzFHRNJ2C0bRBjtqJ+qngyZw59xet6TLOhNGMchKg4HU0sKa1xlqEVPnuPxqKnKtRTZF01xLZJPbG6JY2AhVXLFlHll/r8bY66wuAnVwOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(478600001)(316002)(54906003)(53546011)(6506007)(5660300002)(6666004)(2616005)(6512007)(26005)(186003)(31686004)(31696002)(36756003)(6486002)(86362001)(38100700002)(83380400001)(66946007)(4326008)(8676002)(6916009)(2906002)(8936002)(41300700001)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW1vVmZiOEE5ZGIzZmsyNVBrYy9yUXJEZXpOMS9JUVpOTTZXbzJwSUFFeHNZ?=
 =?utf-8?B?K0YvM1ZsbVBLREluck45VVhBQnc5U3haaGp6QzhPVEpTNzkwSzBPOEN2cEpW?=
 =?utf-8?B?N29CSnlTZVVvTDhiZFZLN2g1Vm5CM0xvOUw1cURydDdNRm1acEwrdU8zZ25L?=
 =?utf-8?B?M25qWE9JV0dNRG9IbUQvS2lUUXVrei9mblhkR3JLdFZZc3BZaUYvMUZsZFk1?=
 =?utf-8?B?MVcraEJwTTJ3Q1NtZyt2NEZ1ZVRPbEtDL1owU1UrdkVNcG9LWFB4RERzcEk5?=
 =?utf-8?B?N1h2Z3JMRVpvRDNrWmlKZTJJbS96WlJNS3c4ektMYTlLRW9UQmRyOWpDdllD?=
 =?utf-8?B?UVg0bFdnYjdXMTZROTNTeXVGL3I5OVd0TU0yR0tRQTFzM0ZxckR0OE1uY1JL?=
 =?utf-8?B?enZFQ3ZPNWpNMU1oSWpVTEp6Tlh4SkVXTzd4V0p5VkVNc0ZzZXJPek1wNnRI?=
 =?utf-8?B?R2RJbmtjMExneElJZFUzVkJndmJkWnl5dVpyZEk1a0dtOW94L1pWVndGdy9G?=
 =?utf-8?B?NkVzNytwK1FRcFJWblRwRmFEdWZaK3ZDN3lEditVQTlVUk12WWlKZCtJbElh?=
 =?utf-8?B?d2xWaVhqNGExWS9LTzJtRkNaQ3l5dm1lOTA4QUtYSXNTTTdjZkp2d1N3ZzA0?=
 =?utf-8?B?SFBZWE4wTlF2dzUzNVgzSnNtRmI4MTRFaGVvdkJwOGEzM3FOSTZ4T1RWWUR2?=
 =?utf-8?B?WTByejF2RDE0cUVkSWNlYkZQS3pxQ2paS09aTHJiVThHazlibDZDaW9sbWta?=
 =?utf-8?B?b21hbUhpSGhJYzVFc1JsQTlJYjAyWXRRSDRiOXlZeEh2TkFlbk1yeEF1OHJJ?=
 =?utf-8?B?T1djOXJXc0N6RWQ2UEliczZJY1J1a09MM2MyTVRxVVJZb0phQVhGQkFVYkZt?=
 =?utf-8?B?d1BSTy9heEJUa2pqMkJuczFwbGNVYUVpUU9ORUpXNGQwYzQyQi9rRDVwajlB?=
 =?utf-8?B?b0ZrczhEQXgvTVYyV0JwdUo1OHJYMWhWS0VJNkl2b0lGa3ozbmUvQWwxZjJu?=
 =?utf-8?B?MmM3aFZJcVIzaGFnNUR3NHgyM1ZtaXV5RkIwTnVrS0tSMHFsRnpjYUhHWmxy?=
 =?utf-8?B?VkxTY05JS2t3OGpOZkh6RVJ6UWxxeXhDeitySkZ2bmpGWDY3YW9EUExZTkdy?=
 =?utf-8?B?WUVZQks3SCtLNlAxRFJDa05xU0dQRUJpSjJrUVdIbFJnNDk0dzN5U2I0UWxK?=
 =?utf-8?B?ditQamlVb1lqZzgyTDFodVlnbTJNdzdYWGNWSk5sNTAwZk1SaWtzNHBMa1hs?=
 =?utf-8?B?UVdOYXJhMk5COGZlUi9zM2FFWDhFQ2N0MEpSOHdldytlWjhTUkh3bFVnQ2Fn?=
 =?utf-8?B?N2hXdkoydUxPL1d6ekJlT1JMaHhQaUN3UEZmQ2dTejJCY21EY0l5YXBGY2pa?=
 =?utf-8?B?ckwvWUo5M3owQ3k3K0tKZGhlczJWZTZ0LzRIcm52cnJrb2ZZeU5MVERkUk1J?=
 =?utf-8?B?SXA5OEF5QldPeEtHd2JDZCtHQkVEclE4Zk9kQVIzWTBlQlN2S1dBQUp5MHVy?=
 =?utf-8?B?anBkM2dlM21ZR01WTm5QTHNmUElaM0Q1Q2JIYUlxeFBWQXNpUnVnMXhnWXpI?=
 =?utf-8?B?MDNldmpwNlpacDFQV0ZnNlY1bjNRc1RkM3B1M01EK0pGVUJDVkZhNkRLQUJn?=
 =?utf-8?B?TDY2SlN2eUcvUTFoenNOd01YeHRnS1llc01pWWVOeVBkMllqYlFkbVYwOEVY?=
 =?utf-8?B?Q0RjcVo5QUM1Y0YwYng3Z000UWVQeExsay94VXFlR0paSlUwSzFOZjNjbnVT?=
 =?utf-8?B?b2JIWVV4MDVNK1JDeFczWm85V2kzaHkwb2xyemVOMmRRdTVUZGlrSHl5MitK?=
 =?utf-8?B?bXRDejEwbGlra2Y2MkVXV0tybG0rTWdaZFRvRjN3VHEzWVdaQ2lwUGFKa05Q?=
 =?utf-8?B?amVza0kvV1JZcW1QZWF6RDdMWUhYdEhPT3hGbmVNOXdGY2ROK3FFcmRibTcx?=
 =?utf-8?B?OGNKRFhmeERlc05NR0UxeUx2aTNhL1ZpcGRTQ3ZLQ0VHMVc0NEhZWXFOMlRM?=
 =?utf-8?B?LzJGMlBzVHpMTm5WVHBiaC9Dc1RHeGR6MUI5YWsyNXBzaWlGVTRLK2tHWE9z?=
 =?utf-8?B?YXRkTEFyZHpaeVh2NXpEdjBIUlkwUzhYeHJ6S2hpTktFRGt3Q2p2aUZaeWtj?=
 =?utf-8?Q?Gqsvel7xcBW/AMw9b71XRGxWA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0223053f-3184-4074-1781-08db077ac824
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:13:33.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZSfCZiUlb338gKX1HNL6PcoKEW4VDZeco3wzmuOguKxP8NOHfg69O1lqx+JoEBp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5120
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/02/2023 18:11, Marcelo Ricardo Leitner wrote:
> On Wed, Feb 01, 2023 at 06:10:36PM +0200, Oz Shlomo wrote:
>> The tc parse action phase translates the tc actions to mlx5 flow
>> attributes data structure that is used during the flow offload phase.
>> Currently, the flow offload stage instantiates hw counters while
>> associating them to flow cookie. However, flows with branching
>> actions are required to associate a hardware counter with its action
>> cookies.
>>
>> Store the parsed tc action cookies on the flow attribute.
>> Use the list of cookies in the next patch to associate a tc action cookie
>> with its allocated hw counter.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 2 ++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 39f75f7d5c8b..a5118da3ed6c 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -3797,6 +3797,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
>>   	parse_attr->filter_dev = attr->parse_attr->filter_dev;
>>   	attr2->action = 0;
>>   	attr2->counter = NULL;
>> +	attr->tc_act_cookies_count = 0;
>>   	attr2->flags = 0;
>>   	attr2->parse_attr = parse_attr;
>>   	attr2->dest_chain = 0;
>> @@ -4160,6 +4161,8 @@ struct mlx5_flow_attr *
>>   			goto out_free;
>>
>>   		parse_state->actions |= attr->action;
>> +		if (!tc_act->stats_action)
>> +			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
>>
>>   		/* Split attr for multi table act if not the last act. */
>>   		if (jump_state.jump_target ||
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
>> index ce516dc7f3fd..8aa25d8bac86 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
>> @@ -70,6 +70,8 @@ struct mlx5_nic_flow_attr {
>>   struct mlx5_flow_attr {
>>   	u32 action;
>>   	struct mlx5_fc *counter;
>> +	unsigned long tc_act_cookies[TCA_ACT_MAX_PRIO];
>> +	int tc_act_cookies_count;
> This one won't count much, as it is limited by TCA_ACT_MAX_PRIO above
> andi which is 32.
> Maybe this can be an u8 or u16 instead and be added together with 'prio'?
> To save 2 bytes, yes, but with a 1M flows, that's 2Mbytes.
> Or below 'action' above, to keep it on the same cache line.
I agree
>>   	struct mlx5_modify_hdr *modify_hdr;
>>   	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
>>   	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
>> --
>> 1.8.3.1
>>
