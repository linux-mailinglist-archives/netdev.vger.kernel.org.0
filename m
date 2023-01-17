Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B766E13D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjAQOs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjAQOsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:48:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35D134C21
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 06:48:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSIHLY4hSLUQRpVcpRaHBKnTbDvRZeBKrVg/0GeHfacB948e70y85iel7QCbPBq7N0nfHXckgpV/imM6VdnoTeHDyW806TMdqlr615+tMzsF0ZrTShLbDtmUQbUYwKrbHgJpnIjWKErQVUQH1aH2HzQDmW50g8rjpqtIiTVgs98Wff66qYSb92asf07ThingWen/ZipiJbUmDfNADr8/QkkU+Gqr10BE9GyIYoQuDJPrIdnr+VE2mIizF3/jIyUS5MD8KtUXpB15w94vgtJYk3q3fxtK4iwG3xJzcsPR6Vx0GPKdwCc0jPu10HuZ+qMshFv2sQ6tDXrAWWsL5N+zxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Bto4x3ZlfIrqYM1b8fauIc3cM8+y3DuBuHKShg0JhQ=;
 b=bsav9r6und5cdpj70VxyjcA/N6iRQR+A8b8N0OpPz5oiQBLVLHuNNY4ql2skjiu2FfjRKtcwepZuIAc2pDOe9WZYbNl+zHDlr2jl/Zsoh9j2x6LgT88lbEUvaRZox05YIrUV19Qeol3qgcjQKtvHL19uYRKmu7D4zJTueyD5F+SEqp3hqrCpntx1CU/Yka3YY46f8ThqLPv0mmFR6r3/9XEdqi1AZsaZugOa2BD1HqkTBAM/7HKAu3ZyL/8aJGQXt7a3wBd+qD7rtyGV735fq4ndnwV0Ei8cVgyfdx19sPlpHk9riNO8bTuJNxVv2jbxRbgv2HVUVIgST0w0giJmEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Bto4x3ZlfIrqYM1b8fauIc3cM8+y3DuBuHKShg0JhQ=;
 b=k0ChxrTNRzpcZmJH4UBJW59K6vgFGJWW8P+nTtSzvpxKvg5Hp/PR2SPKDCaJlYlNorSXRRn1yfXkRxdKRxEXBRTa5nwcd8LmoKOy7YSsZH7h7LCuMzk7YevzAkYuZtMZBpZc9A0bWvtRTn6uW0R4l1k7jrBQjuv2gz5wvV8N/jKhVdlzbfVzC6HMgxZyYyve7axxg8ot39t6NnN3ACt5E3NROBoBpIH6/q8j728NOOdWnTzkM9jk3c5b7ZpzKGnlpz6bkr7VltehwRTUIr4Lk20mQqu0dd1fitmIk9HuP93lGynP6yV3I2A+QuIH6Oq78NflqKAWJeJgs0zmIX0jRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by SJ2PR12MB7962.namprd12.prod.outlook.com (2603:10b6:a03:4c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 14:48:34 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 14:48:34 +0000
Message-ID: <8f9ca91e-1f3f-c3c1-cbab-4f9af3884b43@nvidia.com>
Date:   Tue, 17 Jan 2023 16:48:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
 <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
 <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::7) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|SJ2PR12MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 847a07e6-e217-42db-b724-08daf899e870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ich8TyRIYG5VuRQ9G0rqugbOW9tBLNmTEkeKa54Dw7MiY6f1JJcALt62dOK//SNxMNQrkSXKXKR/z6EhTEIelSFZ/4JuhSWGuY+h2rkZIIqYEllroDyT3ZonjUZizHkhVfj38P+EMyeOqrYBZ8VwppsHffnSWk0IcuUf/uRTQXZ62vJqeRxx0eGrCrBefBH+V+WGz5uLyqqDqEJTNc9I5DBVox++byrfHklI1dA3PEqWvF4zDOFA0gNavpuZhRlbDQOrPbgkZdecUQW+b3cDUh0L7tsyuxxVu4uCQLLDRb21bhcBCQW4a8dmFyJxcbz0G8SaZOoVXJlCJfwz6098iObRMolE/nLDb+Nofe/bAo1d8fUjdqU7UIiS6J9x0XNoV4gQ2kIkc7cYWUaumNj2sOweN5t/A3QPXl0qyXAl+PLoyw/xlHA/y5meRv32utwtKL+WNyl/w+prsgkBR6rzawCGQyOYIhDsjrmaDwqcxwXIiWNmr/d8grJCGq1fTPSoN2Wli9XdkrORiHs7KIjWt8Rs+iNspmMrDpSTA3jNzDT4NYZu0hmn+Wck3fyfqYm+C8xU0S1D30psGrQI3tyj3wzNZp+lwqxlvgXyZf9LvWMtdew/ETWSmpDKKqhomXoNRzuWa/Mc0Ai96NteIDjHP2ZX/RUqyUJaztn2nHb5Z3vzuTUoyFraPe8NbH23Jx9AcAIVI5vbHIb6V44xqt34PiOr8lzaOGK90Jjv9IJG8jE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(2616005)(186003)(8676002)(26005)(6916009)(66476007)(4326008)(66556008)(66946007)(316002)(54906003)(31686004)(478600001)(41300700001)(8936002)(2906002)(107886003)(5660300002)(6666004)(83380400001)(53546011)(6512007)(6506007)(38100700002)(31696002)(6486002)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWw0LytMQWo0RWFXNWJFMDNEWjVrMk5CeWNsQlNpQUVMbCthZW8zVzY1RnpE?=
 =?utf-8?B?bFIyQWsrS1pLSW5GajZESTZBTnpOUjlFaC9VZFZVOUlHMnRJcEJZVTl6WmZG?=
 =?utf-8?B?akZlSTU2L2k5cDFvTTF4dC95a25QRlF5Z3JBQ3o4V3BaSmJ3N0NYcTNNY3I2?=
 =?utf-8?B?bWUyeUV5RG5IRWM0T3hGcXhuSXY5TG9BNEY3c2M0TDU1dGZPdHpnNTNvRHE1?=
 =?utf-8?B?TG5UV0gzc2Q2ZEYwbWFBaDZUSGd3bW5sNkQ2SGp2aTNrT3MvZUpjRWNTaTFZ?=
 =?utf-8?B?Z01WeWs3WlRXOXE2c2ZNcUxpNEUwZkZMdVBPSGVQVmdIWHFOWGs0WWNxVWtl?=
 =?utf-8?B?OXdreU5FTzQzMlFnek10VzlwdDR3d0R2YWlFZzF3WGcreHhhMFhYZU1OODhy?=
 =?utf-8?B?WjcvSTlLTVFXY01EWDVYOWlGUU1WZmxNL1loaDFNeHc0SzNrVmNRWGdWbmsx?=
 =?utf-8?B?cXpBTyt4bG42Y1JyQ1FONkYrQ2RZL1BGbDhGK1hYSWRYMkJ3VEE0N0Z2cnMx?=
 =?utf-8?B?Rmh5RzZXQ0h0ZTFVWVlYQXJaOU1MWTJwZU0yNmFoRTIrVjRxaG52Ym9ORUdV?=
 =?utf-8?B?MUt1WWlzNFhBZzhKeFdXK1NZdVVtb3RQZXZLc0s3V2xNZHhiTE9tYVQ0UTNO?=
 =?utf-8?B?K09VbFFhY3VwektPKy9qWitTaDR1MnM4QXpCdDVqQ0RBMmEvVXlzRVlKcHV5?=
 =?utf-8?B?ekUrS1ZCbmlLblNkejhVdXZPZkNOSjd1MHdnTTJhaWhOWlYvYkdjWmI3RCs4?=
 =?utf-8?B?UlJZNFpYVzV5WnIwVVpsU0JuTjZEZ3Zicms0SGFYemNFdEt5UW1BY3Y1Nkx2?=
 =?utf-8?B?UlZGSFVZcmQwNTJ5MmtVZlE1QVNEUVB0T3ZvYnVZK3BwbmdoSHhaQXJQdlVM?=
 =?utf-8?B?TWU2aW50alVzMnZLMGI2QU1FbC9rUHMwU0phN2hPeEZ4dmpFS2lxcHlyc1Ix?=
 =?utf-8?B?YzNoNkcxMXIzUHlxaVJicktyZjI2dWM4czhVNk0zbzRoRzRqUk5kQUQ4bUFt?=
 =?utf-8?B?SlNlQ3p2dXJ2Q1gzNHRoLzNuc1JYMVpvZ0xxUjZyQ3VCdkg5dlhyZDRKcWV3?=
 =?utf-8?B?bk81YzMybEVkdHgyeHVpaFN1emZOSFFGUkhCN2tZbkhYMFdyN2hPUTE1YzFx?=
 =?utf-8?B?b2NqMjVrREplcng2UVhqOElYdkVONEE4TkJDZWRsT2luTEZYSEpKRDUxQlBj?=
 =?utf-8?B?UjdiQUlrRmZJWnlsM3NlNThmNnhzZlpDRVRuT09WdVUxMGhqVXZ6S2d6N0kz?=
 =?utf-8?B?SXlOZVVBeFYvUGpwSm1rcXJneHRqVFhsVGwveUpPeVlIaFVVRnhwbXAvM3cv?=
 =?utf-8?B?M0FXNnBDTG11c0tqd283aHJWRUlUaXdrWVBjOVNSMTVvQVhYbWF5TkI3TDAv?=
 =?utf-8?B?eDQzWCtzMXZLL3N1OEkzZXlLdTNaRlM5ZWdmMnRnczVwVXM4cEtiTWFqS0ZD?=
 =?utf-8?B?Y2R6R05kbzZDeTMzK1hiUStzY0p5bC9kZU9lYkdWN3c2eGE0NC9IbE9VOVNk?=
 =?utf-8?B?d0VVZUlGRjdJZjFKOExkL0NMbDdVRk5PM08ycHZmMnlTZlZsRnBwWWgrMDhn?=
 =?utf-8?B?b0lJRzlZNWhTWnVYckZvQWdqVlQyWkRwRGlGc1RxaDRjenh1b1BwY0JENDA0?=
 =?utf-8?B?MkgvTkhLaVM0VFFZbHlqcnJ3OFBZcG1xckFxUFpRSUtyaXlVNm5lY21iUXB5?=
 =?utf-8?B?bGVLajRJNWlmRFRaYkNUcS9VcjArYWtWbEttT2RZaXQ3UStNWmFUL0txOGE3?=
 =?utf-8?B?amdHZ2V1akNHNFFXck96aHgwdm4wcnR5WVByNFRXQWZrZ0YyZG9Bb0llaEVP?=
 =?utf-8?B?WlArVnRFeE5FL3dUdWl0WFRTbDJSYkpHVFlmekZENDBUdEtYdlh6ckdtMCtD?=
 =?utf-8?B?N0JyeTBLa01XUVJtdDBML0lKbTVGN3huMGdYMmZkclZVZkk4dmtmYzRXR2Fq?=
 =?utf-8?B?dm9pNzJQeUFiS3dnaDBmcVE0UUYzczI3c0lpMExiTjNIM0prNS9vWkJkNTFu?=
 =?utf-8?B?enl3SURFb0FlM3paTWVwb05odG15UFIxdUJYMmV1bXFtQjBVU2xCZTg2Ti9Y?=
 =?utf-8?B?MXkvaDg3MHdhUHU2MUJqVDRIY2ZvTnNYTW1JSGxrbFdKRnFvU3JUUXBwcEhz?=
 =?utf-8?Q?E3UIxGXwF1BmZXCQBk5mu3UE1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847a07e6-e217-42db-b724-08daf899e870
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 14:48:34.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKdGPuqh9SBrhREIKubxzf/Y0hm99rvjWqY96qUnFryywxtVocB5tDluT8pEiSSM9eIeC7cA75PPxGo2WaHtNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7962
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/01/2023 15:40, Jamal Hadi Salim wrote:
> On Sun, Jan 15, 2023 at 7:04 AM Paul Blakey <paulb@nvidia.com> wrote:
>>
>>
>>
>> On 12/01/2023 14:24, Jamal Hadi Salim wrote:
>>> On Thu, Jan 12, 2023 at 5:59 AM Paul Blakey <paulb@nvidia.com> wrote:
> 
> [..]
> 
>>>
>>> Having said that: Would this have been equally achieved with using skbmark?
>>> The advantage is removing the need to change the cls sw datapath.
>>> The HW doesnt have to support skb mark setting, just driver transform.
>>> i.e the driver can keep track of the action mapping and set the mark when
>>> it receives the packet from hw.
>>> You rearrange your rules to use cls fw and have action B and C  match
>>> an skb mark.
>>>
>>
>> The user would then need to be familiar with how it works for this
>> specific vendor, of which actions are supported, and do so for all the
>> rules that have such actions. He will also need to add a
>> skb mark action after each such successful execution that the driver
>> should ignore.
>>
> 
> I agree that with your patch it will be operationally simpler. I hope other
> vendors will be able to use this feature (and the only reason i am saying
> this is because you are making core tc changes).
> 
> Question: How does someone adding these rules tell whether some of
> the actions are offloaded and some are not? If i am debugging this because
> something was wrong I would like to know.

Currently by looking at the per action hw stats, and if they are 
advancing. This is the same now with filters and the CT action for
new connections (driver reports offload, but it means that only for 
established connections).

> 
>> Also with this patchset we actually support tc action continue, where
>> with cls_fw it wont' be possible.
> 
> It will be an action continue for a scenario where (on ingress) you have
> action A from A,B,C being offloaded and B,C is in s/w - the fw filter
> will have the
> B,C and flower can have A offloaded.
> Yes, someone/thing programming these will have to know that only A can
> be offloaded
> in that graph.

I meant using continue to go to next tc priority "as in "action A action 
continue" but I'm not sure about the actual details of fully supporting 
this as its not the purpose of this patch, but maybe will lead there.



> 
> [..]
> 
>>> Also above text wasnt clear. It sounded like the driver would magically
>>> know that it has to continue action B and C in s/w because it knows the
>>> hardware wont be able to exec them?
>>
>> It means that if MLX5 driver gets "action A, action CT, action B",
>> where action CT is only possible in hardware for offloaded established
>> connections (offloaded via flow table).
>>
>> We reorder the actions and parse it as if the action list was: "action
>> CT, action A, action B" and then if we miss in action CT we didn't do
>> any modifications (actions A/B, and counters) in hardware.
>>
>> We can only do this if the actions are independent, and so to support
>> dependent actions (pedit for src ip followed by action CT), we have this
>> patchset.
> 
> Ok, so would this work for the scenario I described above? i.e A,B, C where
> A is offloaded but not B, C?

You mean the reorder? we reorder the CT action first if all other 
actions are supported, so we do all or nothing.


> 
> I also think the above text needs to go in the cover letter.
> 
> cheers,
> jamal
