Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B968BB7A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjBFL1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjBFL1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:27:44 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2055.outbound.protection.outlook.com [40.92.53.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CA783D3;
        Mon,  6 Feb 2023 03:27:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjoyBw5qQeaL+jYBV4glyzJBN3G9Sp0xSo9zGVqjqc8lbYLMNLXkrQ16ZGXc9/sWPsPrD5mhrst55VVgJEX5lx95eQhAN2I3/fSSNr/aVnti8exHbDGlBQ/iy+hzsAoxkGaqrljvBcwI13rbJX60wNJxnwgl9BXpACs5F4bVfhifwqAR25SsLxWCXuwIunAOp2axzVS78vkO9ah5DvdA/xbmEGUwKKT8OXBYweLz9jhshoniHyRORG+rDMlqmr30Cg4DGL0NrqimMEIaHWB4o/ug0EDl/vAx303VzQ/vCLBWZtPvDcpLjlPWVPd6i+TBN+x41z2+BUuJHGw0x26HJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAU1GBzkjnJ28Es2wg6ahiDXMf9OUh+R0jXzuospCH8=;
 b=TSJYrlfis/GMZF/1z9LLAr6kGVuUTx0JpKvFD8YFoUGtgvHmtgVVoIwnqzSmRzHccTimwiWvlKPeU910d8EQmk5/LqeKH36ZDPZkAUk3x8ShF1gh0K/LMk8t/u6cywFSGZUKkXHeWsbKSI0LgBUi07n6p9kQyuRiqn6/QtnA/h+4V6sz6CkpZcoapZ/58TR0SebohkACypHDLRSpioFyJPme5G7Cvjxc6ZHHRqcbDmTh0p6d4XniOgT25LLcmaOzFEDRAaDEVq6yK/D6qGMLbGawNlO74T/IF1NycAl9ZkjFyhbXeUTaFFW2/vNQACy2YpmDqMG3/jTxtpw4zRXHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAU1GBzkjnJ28Es2wg6ahiDXMf9OUh+R0jXzuospCH8=;
 b=UEJh2HkSydeFjSwIR+Gary6uR3U7F2YwtFCCnMCUDDGXnKNAvMOhF3MQs4TCk9EkMS0/v0DDsm+syEk64+4z/8aFQKubzWAErAa8ZbmqGuWRAPQy7bqicOCHuJ9iEdm5aHOzubN8iBeYrwIAMUmctUpylVAF5lyJiGL2PdFj+FdxphUUblV0cQsse9UUdogihEmSuayMDQbUXjDEAvCvE7gB1lrBzDdnWEJMVK55yx6sqMyUxMOqvQ14VrIk6SXT3DdUM6zKVG5IEyhodsuDP9dzarBQ02QUEHBsmtjcQ05uqpNUjh3Mwq6KIKItzuPy5ttFxyd21M8XgBsYG61FAg==
Received: from TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:179::13)
 by TY1P286MB3405.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 11:27:39 +0000
Received: from TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM
 ([fe80::bafc:f38d:b502:9393]) by TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM
 ([fe80::bafc:f38d:b502:9393%2]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 11:27:39 +0000
Message-ID: <TYWP286MB2300E219495E608BEEB9A2F8F5DA9@TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM>
Date:   Mon, 6 Feb 2023 19:27:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [ovs-dev] [PATCH net-next v8 1/1] net: openvswitch: reduce
 cpu_used_mask memory
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <OS3P286MB229570CCED618B20355D227AF5D59@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <BB520D08-D1D3-45DB-A3AE-008E8DF48F81@redhat.com>
Content-Language: en-US
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <BB520D08-D1D3-45DB-A3AE-008E8DF48F81@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [ksTkBtQ+4clEHwxn2WWYnAeAjnFbL9np]
X-ClientProxiedBy: SG2PR03CA0113.apcprd03.prod.outlook.com
 (2603:1096:4:91::17) To TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:179::13)
X-Microsoft-Original-Message-ID: <ac0cd3f3-fb7f-8606-4cfb-a9a3a3b7d3cc@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYWP286MB2300:EE_|TY1P286MB3405:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3e1b10-77e7-4977-b50e-08db0835273d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/o333VRK5NplpFkrcg4M6esTQSmHVzlUEYkx5k1I+ZXfK4QjuBTn18j7ItIFNd91vrZY+htG6nqjB7P83vUdOf0Zkqxr+Us70poy9FxOMXE1oPNvXGIUIHsddB/MOUshIBbToCQnaKIY08V/ubTFtcO9EXLlcOtMgmXi4sqoTb4xgK5UsjT9M5+c+AvFESUznOguR6An24oNmBxyi2vQ0D275hGY3pJbFqCdqSjZfJ1oBomWsGu7QXGG3mip1Etd/uKtDYnvnOse5kdgDG8MZa/X9hINsF9UTH07Ri665Ve32Kx6GJFFTYPNyyQTJDWTNq6HHtqh8oafdmCZJtTxz4EQwqunhLiivEGQ2susrOmpf06j95a5c+PgoqvgXChm+7NMVjmKnya2VmX3YFWxKkSq9vGxHuRSE7L4Svymhezxikvo06rFYz01EVu6cWMNB6B+HswC7BcE6FcqbzTXjqzqPnzli8kEF6J9pDbkEE8NDmbFz5x1uKonQnbAgVi7d9n1XZTW4fgj1sQQk9xWzl9ooWizBaDcrfmFeqSalSWkxxZKdIu2eBcUbvAciyHUZng0vex3wNmBF81qJpVaUrTe6L/EnQS2oowsj9sjKmjHmy8rlZ+gNgS2meszMzI6lLOY9RZN3QuNaxXYfTxsA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emcvOXFvaHZJTFlTZWVXcWc1Wjk4d1dFMmMzSktuWUtkZ3VaVkpHR2lpVXRY?=
 =?utf-8?B?Ri9IenJQbXlFRm5QbUxjb2NhbWdPeFFtY2w3bUwxKzZsbkVPL3BGbGs4azVC?=
 =?utf-8?B?Sm9VQkgvWlBoL1k2L0M3eHhPMUFXZ1dJaVlxekk1M3A3a3FPN0ZySTdWY2hk?=
 =?utf-8?B?emFIWjRwbTBLQkN4anF1K2o0NmEwQ041a3hBUXNIQzA3MDIzOC9tc0lTZTRy?=
 =?utf-8?B?QjJDMGtaRDgwNmZnc1lYbmhRTUc3c0c1czg3Q3pOS1ZuSUQ5QTluSEc1SEl5?=
 =?utf-8?B?Q1E1UkpHRHlNYW5JR1BPMytUTlJKdTBoMmxiUXk1Nk9yTThBUjNuQW9vRjJQ?=
 =?utf-8?B?UytyZU14N3Z5SnBQdjF5RlEwN1gyeUFzVzE2aW1ibEY2UHBza3FJK2dkUGVz?=
 =?utf-8?B?TUEvYm82UkJuaTFuM0c0N00vMnpuL3lQVzhDRVhQc2dab0xhVnh3SHd6bDE4?=
 =?utf-8?B?Zk40M0pSN1NLb3MxcHI0Znd3clNZcldDY2tBcnNUclJSTFJmRUQxVXhrYjlq?=
 =?utf-8?B?UnNRdkdXWnZ6YXlEajVQOHQ1VWIzZERScUEvVlNRTERrUHB6REtUeS9ueVR0?=
 =?utf-8?B?TG11TE1zcEU0eVdJZXJBN29WSTdncGRoMzgxcjc1V1BSbExjck5QVlhPVEdW?=
 =?utf-8?B?b0QzTnZveEJ2Q2xJOVdzZVJ4aGdBaDYwNVVJVVI1VkhwTGxFV1VEU3dKUEJB?=
 =?utf-8?B?UzZnSmg1cHAvVVIya2o3UVlac0hRek1IREFib2ptaklIcW5CVm85b1JSclhw?=
 =?utf-8?B?OE5EcHZ3UjFZY2Zrc3ZPMWcySnlyKzgzTEFqdGVEVitaZzFFK2RYNGZwRWVQ?=
 =?utf-8?B?bVBLNDdFMmltd09Fekp1RVpQSGwvcmU2Nm5lVTM1dmJoWG1ETnUvdGtGUlZ1?=
 =?utf-8?B?ZC9uWTVCWUI3WVE5T2o1b1J5cE1GOEVNZzRJVkR1VDh0N0s1SGFYTDNPaEpY?=
 =?utf-8?B?ampYcHVqUDhzdUVmNENEMXM4eUZKRlhNWGY1cFBvMC9oT0xNa2xsbzA2dW9K?=
 =?utf-8?B?NmppTHVpNEUzS2t4L3JKUENtQW1kZVVxTUdXQXp2bFlHVFZ1VnJQZ0pKaVJF?=
 =?utf-8?B?RmFLVDQ5aGRtUm83T2xPM1NhNHZsM3NEZG9Mc2hrZE5SVlUxZ0JmNHRjd3VJ?=
 =?utf-8?B?ZXNjZ1dGbEdHc1FPZ0dIek9kK0xFd0tBU2NYTk9mY0FyVXl4WW1pSWxuRmdG?=
 =?utf-8?B?eTdJTXltU0U3M0pzbHYzVXh3S056OTZtamxGMXBzaXB5NVlxdXNHMmhORjFw?=
 =?utf-8?B?TjZhTXorV2VuRk1pOG8vYks3QW9xNDVpbytZakZySWlIU1FBTVhrdGVzVzVV?=
 =?utf-8?B?Uk5qbE9DMmp0SjlhUlE4eDk3K3ZndkFpL1EwTzlDR0dlZm9hcUR4dzA4ZmFi?=
 =?utf-8?B?blhLdkdkSzB3MzBiMHdCOWkreDY1ZTllYUsvYXRxNDdzc0NxcVcxbGJnOGpG?=
 =?utf-8?B?Y09YckQyVnBOVzhOZ28yaXY5cEp5S21xZllUbHFGNDhhRlc3SDVzWDlZdkJQ?=
 =?utf-8?B?SmVpZ0lVYWhHeEM3YTZIbXUrMFR5R1ViVUFDTmVnakxLN0ZFbk90ZHB2WC9R?=
 =?utf-8?B?ZXdSUm9iOXY3eStoSDd1ZUtjNVZRdlllRkI4eXFuNEszQXRQOTZLeTltQ2NK?=
 =?utf-8?B?Q1JiSFg1NGdzMkVEeXQ2ckNzVkFISytqR0ZBeklvZXRoek50YzZLY3JPTi9a?=
 =?utf-8?B?TkJEc1lWREc3dDhSNWZwaFhNMjVnZ1R1a2FrV0ZFRzB1amlOK1R0SFpBPT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3e1b10-77e7-4977-b50e-08db0835273d
X-MS-Exchange-CrossTenant-AuthSource: TYWP286MB2300.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 11:27:39.2388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1P286MB3405
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, Eelco, this is the last revision and no further comments for 
revision came in

eddy

On 2023/2/6 19:21, Eelco Chaudron wrote:
>
> On 5 Feb 2023, at 2:35, Eddy Tao wrote:
>
>> Use actual CPU number instead of hardcoded value to decide the size
>> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
>>
>> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>> 8192 by default, it costs memory and slows down ovs_flow_alloc.
>>
>> To address this:
>>   Redefine cpu_used_mask to pointer.
>>   Append cpumask_size() bytes after 'stat' to hold cpumask.
>>   Initialization cpu_used_mask right after stats_last_writer.
>>
>> APIs like cpumask_next and cpumask_set_cpu never access bits
>> beyond cpu count, cpumask_size() bytes of memory is enough.
>>
>> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
> The changes look good to me. Hopefully this is the last revision ;)
>
> Acked-by: Eelco Chaudron <echaudro@redhat.com>
>
