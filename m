Return-Path: <netdev+bounces-6434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378B871642B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C0472811C9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE80101E4;
	Tue, 30 May 2023 14:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35223C92
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:30:12 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236A6129;
	Tue, 30 May 2023 07:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXqvCrkVZ8Kbgjicqnbu/gaWfyfhtFdSWUFqnvM8m2bmdw5f9pXoeY3MmrikWKiebshNUGyNEV8oPr6LIiZ3XxAPntmBQA+8XYcH5nKRTnsh/sTv2llhgqS+SaTVDt3bz5wjgIhbzvWu/mXbfj5WovWKwXmTe4yMn8W+lK83yVrxacKt5yU+9bFpeoTXrZoeBOKLOO46wsKB5mZTgLbZMaldrYJbir/W+a+xJixDUZBcHSu3MrbgKZG4xjSm7/z3hN2USKLtWmeCTCfQxTg8cjVJt8ruMOlG6D2yl0CAAXf1XfRvSmbtzapGwlf9CYSxKKnOFeRqX5ZEQU3NRa6USg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYd195WRbufnGit5E4LTq15wf3SEZn7Vc/snEt2pD6E=;
 b=SdQ3UqOp8nIKlYAa8B3gcET5HJvlNexnpdzZhw7rU3RhTeEzRqcgNcCgUueprJueBQUlOc+Jr7uedC91puIbgiy2wrXkBtRZJTw0n2Ba6g5Fxnd91lTpaxLbKqEkVv1O0Z5wmFaavml1WGkgoFdrHF0ph1cnTQsvMig7SxKJmzkCJAvZQ5lf5QcCWTcXRg/3zImTiYpDtJuiXR+4fwgURSifw/cVOxqxfJ14Se0YmyNDf3rxuO9x33pW8tEbtlro1tNMQbqisyO0Ur8rX6PDTnRIIbn5wQBWAO6jswZkth6JeV0NEZrKz06ejUpFnNqglOzg1YmcDcLhS7L06ZRyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYd195WRbufnGit5E4LTq15wf3SEZn7Vc/snEt2pD6E=;
 b=o8kI2HAfo93FosL6+1jEV9747aldwx5WjAPFpddDveix6hGaIlnlBHTVY+puPAprCa3bjwYmSSoIugW1nK1d3+9vmXRqW3QnUR5HxNxcavsdtRDDu9eeGRRCa5i/qrK8OHu8K7iQMYmPCfktUWW1INrPdwcz79FO4Q+DC1Mp48I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 CYYPR12MB8732.namprd12.prod.outlook.com (2603:10b6:930:c8::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Tue, 30 May 2023 14:29:15 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 14:29:15 +0000
Message-ID: <4ec4bcb1-fc18-578d-fee5-cad5166f3c2c@amd.com>
Date: Tue, 30 May 2023 15:29:09 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>, Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <ZHXf29es/yh3r6jq@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0251.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::19) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|CYYPR12MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ab5cdf8-193e-43dc-f520-08db611a3ec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+XSjJwWAyzgk19iIKLxPGuGDh3qajX9qbZS8TF2sygNooEPEMp1T/qsy2rAVaJo8Db3Pe43E38jLwG0ggxX8y3vV2VK6PF5ohfrqTM01uaCrGTG0WXfsCLyKVU5qb0Kxfjv9UQ5RE2TjCTKrisn7Vsx2LGZokmMev4ZXmAOPEiorYEH4VUmM+NIKXUoVLwmRzXLY/mRls2cGzrrBAxTogN9RCpMOulQwputKYJVmF9eP3a7sVgtu6vdo89kpoCjMFAxOodBEidk56K0GigpsioTcMHGJJx/yZPORsUmvuooNKqmbBpvh+9oRHgX7lYzZoVNXfg4QMarGzJ9d6KHgEFLTISvHrxqOBm6qJtyzDuN54u8f54a4YgmsRWYh/3jhP8+HB7Zi53gNOBSgWmcvfgHxnezOfqp6smSSPau5nUf4WBrD5fvazo6NHgrtvybBo+rmW52/mXnMe3/3tfXBJQme7jHjxqj+oqOBoIQKa7aecBaXAWwBywvzqD447R1kS499YASTIeHfcanhoxV//WMTw4Qdd7Tq6TyeX4uCeIeAdLaSzzIjexdZBPRbRTcOpyfrSmBp3JKdHcTcD6TbjHHjW0xBcKjWHdAfUY9SN4Z3DaqD1FdIjLPatGDwUYeUddE+liSt/rtRHoKTyXciFQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(478600001)(110136005)(8936002)(8676002)(5660300002)(7416002)(86362001)(36756003)(2906002)(31696002)(4326008)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(53546011)(26005)(6486002)(6666004)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzdMWmVaMFE4Z0d0MUt6dTA3aGU4WWZsbWpJUjhkK1JoNGdsbUE5dDFYQWNr?=
 =?utf-8?B?QXRMQTkzZFdBWHZteXJpQUdFN1dYN1VKV1BNRkI1MFBVVUh2VlVaMXZ1eUR2?=
 =?utf-8?B?cWt1SVZIS2tIWVRSaEEvVTBBVHhsVjhjZ2dmb09Ib2JYbWtLc1BHSEl3ZktF?=
 =?utf-8?B?L2RKYzBzWDZjdjNwYmgzakQzMVl5OURFSU5QdmtFaTVEN2hQQ1JBTE1SYkNa?=
 =?utf-8?B?czFLU3hWMXViSmlhVjl6MXNpZ0RRSHhQTmcxWGtCaDZZMnNpL3pUdUxseEM3?=
 =?utf-8?B?V1hRVmgrOXdSTko5QzhZQzNka3A2b0dIa25UbGJNWXVkN3FmOWs3NHZEbytG?=
 =?utf-8?B?TUdIUm5NaWtWTCtmRGJCL0RXM3puTWFWaWE4clphMXBhMnRNcHk4UExJOUJz?=
 =?utf-8?B?dktaS1Q2VTZyNW13Ujd2RW5iTGNMZThnWFlrbXZWdlZzdUhmeFJGS00zSlIv?=
 =?utf-8?B?cVNaMTI4aGU2c2dBR3k4SmVwbEhaQUJhVmhLU3NJTjhJWkRiWEx5TktuWU5l?=
 =?utf-8?B?bzRKZEIrQUxUQTJCeHFqWXFLaktaSGswNGlOM2JRTzBxZEtXV095aWdYRkFM?=
 =?utf-8?B?elhUR0xXZWFYdExFNjgyWlBOcDUzZElZNE53anFhNDdpMlVQeHBZdXpsZEF0?=
 =?utf-8?B?aTlrcjdvNGtLOGd0c3VyZDdtQjJwa3dxWHBlOURQRld0TnNFWjhuamg0dk5n?=
 =?utf-8?B?ZjBDSWJHYkllb09QS3JMOExEZkE4WDRWOE8ydGQzOStEaUs5ZkdtUHJMQkJ3?=
 =?utf-8?B?bm5wMWlJcTVrMUdKa3lKcjR1NVBLWmdXTjhSeFo4VkFDbGVCazJPZHN5eWw3?=
 =?utf-8?B?NjRvT2Q4VDZYT3pGb3RyYzRqbFcrWk9nTkd6VE9sV0hBTXpqSGRydGQ3UHVP?=
 =?utf-8?B?UHF2eFlvZVVFS3RHV1huS1E4elNGT1BRbWxFdlNrbVZLbml5VitSUVM1QURa?=
 =?utf-8?B?Z1Jxa0NPemp4Ukx5TUc2RGk3a1FCS0gzR005OE5jVWFPSU9IRGJ3MkdwbDBF?=
 =?utf-8?B?SlhJYXJSMFZEUDVEeEIzRFFob2hvMEM2OUc4eHZxZWtYZnZVdDBjcXhqZzRE?=
 =?utf-8?B?NlQ4MXIxOGlxcUpXTkd2blRkQ0oyNTJwOFd6aFpDWTZPdW9la3JqMXhuNUFK?=
 =?utf-8?B?MVFPWlhBZFpja0crUURoM1ZEYzZKWUF5SmJFNXg0M1ZyQUV6M016UldlMzhx?=
 =?utf-8?B?ZWJ6SjlJT014K2FBWDhYYkdEKy9QaFE5eFNxbm13OGtzZjZma0ZJRjFoUm4y?=
 =?utf-8?B?NHBZMTduTnpYeGZiY1B2Mm5UOXZSL3dLekcvbzJydHdSNzl6N09UbkxoQzlM?=
 =?utf-8?B?SW5zRy9WOXNFeEhNcGNGSDV3blh5V1BFUjhUdnhiVEpndW1CSXJmbEVMQ0I1?=
 =?utf-8?B?dTNZTzJoN3IzUitOMkNqZW9nSUN2NlpPV01yNW84WUJtWHVQNXU0bGtqYjI3?=
 =?utf-8?B?eU9vTGFCeTU3aUVmQUxTMG1keEJhaHAvK3NnQ0ovMXl2SE56eU9EbWNQYU1k?=
 =?utf-8?B?cXZvNmhtMlIwSXNmeWJnc1F0eFprdGxNc2lDRlZ3WGtmSEZaUUtxMDFKN1Nl?=
 =?utf-8?B?b0VZYlFPTHJYVXRrUmlSOG16cUxmb0pmZnZad2RsMUZBYTJOcjdqZjdUSWFi?=
 =?utf-8?B?emZoK1NjQ2sxQkladG9OdGplZUdCRFpIVFJJNXppUS9sZzFJbHF1N1VaU1Jt?=
 =?utf-8?B?MWtEekZ1enplTFFnRlBnd1huZGkrNXozSG9zQ2ZsZyt5bGVmVVYrN1N4bEJq?=
 =?utf-8?B?NG5GT0dxV1NlZVAwNTJvMXM1UlJqYk4zMGpmMWhxc1Vjc2FHdTI0QnhNeG9v?=
 =?utf-8?B?MmF1VU9hUUQwOHBUeDY3NnBiWWNud2tLcWZicy8zT0JXOXpkVERTRzExZnh6?=
 =?utf-8?B?UnpaY1VSMkQvdVpjNGNaaHVnbkZYYnozYU9PY1h5N0Z2SmU0c2NSMStyUFNB?=
 =?utf-8?B?Qmh0VjJzc1JLTjNtcGRjZlpJK2ErTHJoTkNGSisyNFE1azA0RDdjZ2w4MmhD?=
 =?utf-8?B?REc1bXM1L1BTTjFZLzNNL0V4Tm1PZi9oMU5kb01uTlFsSnRZeFYyajZaeXE0?=
 =?utf-8?B?UTVkeStLbk43Y2R2dlRlS3R2YkhlL1BLM1RNS2lIYmNaNWNnNTJRc0c4c3VR?=
 =?utf-8?Q?tdhGUSt2WIG/v5V0PqMFBwqUa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab5cdf8-193e-43dc-f520-08db611a3ec4
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:29:15.5066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JsURqNYOYCe3YJhGA3dT80KsjQFT9tEk61fBGrM4iHoV1yfoPTLC/Xe2JOzWBPD7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8732
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 30/05/2023 12:36, Simon Horman wrote:
> [Updated Pieter's email address, dropped old email address of mine]

Thank you Simon.

> 
> On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
>> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
>> size is 252 bytes(key->enc_opts.len = 252) then
>> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
>> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
>> bypasses the next bounds check and results in an out-of-bounds.
>>
>> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> Hi Hangyu Hua,
> 
> Thanks. I think I see the problem too.
> But I do wonder, is this more general than Geneve options?
> That is, can this occur with any sequence of options, that
> consume space in enc_opts (configured in fl_set_key()) that
> in total are more than 256 bytes?
> 

Hi Hangyu Hua,

Thank you for the patch. In addition to Simon's comment; I think the subject
headline should include net, i.e. [PATCH net]. Also could you please provide
an example tc filter add dev... command to replicate the issue? (Just to make
it a bit easier to understand).

>> ---
>>  net/sched/cls_flower.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index e960a46b0520..a326fbfe4339 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -1153,6 +1153,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
>>  	if (option_len > sizeof(struct geneve_opt))
>>  		data_len = option_len - sizeof(struct geneve_opt);
>>  
>> +	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
>> +		return -ERANGE;
>> +
>>  	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
>>  	memset(opt, 0xff, option_len);
>>  	opt->length = data_len / 4;
>> -- 
>> 2.34.1
>>
>>

