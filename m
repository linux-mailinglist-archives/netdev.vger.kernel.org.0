Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E76D339F
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDATsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDATsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:48:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8010C6EA9
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:48:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTftjecI+HcxZ1LGfG9UKawbgNZvoCOqZg7qRbuWBYADKYgIaoAeyMDjeaz6ykZPRRLohtBLgH+KGgRfDqpsH2cFV6S/2kWKWlu8ub35QRn0z+FhQr8kMdgzGpubTCpdCrtW26bpVPvqffGHa5EjK8cnW4iqQcU3sBEG1oii+c83JzA1zR7ZB4Lmq/X7roHpitg+CaRXLSOFWc0KFCKsHK6mscxGMJSFhYKyHGi4K7p6SONiD2eGsXlT5NRsCNVD4IjiKsixEeqA8UwXGfx+VlkKdflBcPVbFUW8vFZnu5Rf7gyltl0cdze/f/CusJEDCm1EftwTCWmwqj4uIlAxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPRV1U5bD5MskAboYTQNY0OVHviBZq38v0WSx/ZvyhA=;
 b=LB6NjPT1psNMLR62fbbwBa+9CPg/llnAwP6eQdNzDFro3C8fygGxNLt45qGSTh3wDtly+gj87GjTTRyH7XEOrakz87jMwttYAeo9xdWB3pMWloESuPAZbLxp9n8heaMtenUSbXimbhzRE3yL3yByZxn6Nnmdy52w9j8Rlp52LAW2uLT8H4hxnj5Zg1BvWyGmmrC0ahcYfmeoU3IqFSjHwLG4YTusTT3iQac4ig6JLWjno9xdXRMDiRBbc4Ybe8l2801O2eARTSxJtSosxw9dCgi8RAMy8pmvL0C2kZ2uusBtYY0w2qvqhmVMzuWGexOlU733EkYG7K/XYkFlWzxAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPRV1U5bD5MskAboYTQNY0OVHviBZq38v0WSx/ZvyhA=;
 b=gtO7mZsLKnPDQDQMLh+lL3AqINRhcY7p5u+fVUAXfpT2PnyMr9NxDovsDxfYrOx6WIplGgmcqsG/SmpxZF7LZDRfFOOt1smgvB/3pffWkgSTOFXhrTUOCBIkZ2NGkvUsbdjewsB9L9Fa7gBAaVoKSUhTeth5ax4qQrEYrVTnB9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 19:48:37 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%5]) with mapi id 15.20.6254.022; Sat, 1 Apr 2023
 19:48:37 +0000
Message-ID: <cf47c976-2714-62b7-3e5e-436fcfc788d4@amd.com>
Date:   Sat, 1 Apr 2023 12:48:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v8 net-next 05/14] pds_core: set up device and adminq
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-6-shannon.nelson@amd.com>
 <20230331220719.60bb08f3@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230331220719.60bb08f3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::28) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: becbff21-e5b1-48b6-0802-08db32ea15b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZZP2q4YLJLoWWZXMQMNgKow9EAucmBswiq/0irOPtIxJtJZp9PpM4XgH9/wRkHIlU2gtmGSiLWBtlm9yv5mKmGIIC2UQtMgWtG81+ieg1Yo/FySzUDptcSLvK1KY9v9oq2d+pbqZDSon5Ou5vTkRkuTPB0Sr40NzqVjQsHGfZiP+jAs5vM6+EE03vnBeVE2cj0etzAgULWMiiO0JLXOLCOypwCf6WXQaxGpoQIbsO//ZOkGTjW1Vhj5yLereGPz8O0QevGFNxQucwja4A/+iOQlODu3e6sP65drE1eMlmWBQ65pLialbpqIyk5gD7WbXB9Z+WjLTYCCygt02n+jD+RWoYfdWPP1gKVYjHhPcLIFpGsIaRugalWh4QDCqmzTXZnqiJPDspM2WXwoD3X2XM8wIgSjbaiwcbjgM/4Igs/XilIaSNtqNUT4mPUiE5IRNAnbc2VbESQaaFaslodA8IFZbsLiM754dMENTizNY4tCpRlkDwNunJtCY8BUPAH9Qgk9SdZqp0Id4ymTeGA1Xw2TrVoTRVi8iwtVJS2GqzPCStsB+rfQ2NeiJUpqQ2KiHx97SMOz57ULIQxPnQyijvPGylEzcHM0fSECMaG14O9q2LuDUvjYZAbUzR/XARfqdVVYLQ7IMghgRNI1Ea4+KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(478600001)(66556008)(4744005)(44832011)(41300700001)(66476007)(66946007)(6916009)(4326008)(316002)(36756003)(2906002)(8676002)(8936002)(38100700002)(86362001)(186003)(5660300002)(2616005)(53546011)(31686004)(6486002)(26005)(31696002)(6512007)(6506007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amEvNVhyREM2bStyWDJ2UmFuRStSTm1pbytKSGpMQXdUYWpFSUxCbER5b3p1?=
 =?utf-8?B?dXlzNDNSQzB1cjZLc1hyZEppbWNnbUNHQmxERjVWRXZ6Wmxud3JkamR3aU9L?=
 =?utf-8?B?QmlQdDd2aHVDalFQZDFCTGxvSjVXT3pRV0xCVjJYSkU1SFZ5dkM1YkVwbWdv?=
 =?utf-8?B?azhpSVdIeFBtbkNKSEFibm5pUXZORGh4c3dNMk9jMjV5RWtRMGpzdUFXZ0Zq?=
 =?utf-8?B?UXhVRkZHVjV6ZWlMbGI4emhqZkNGK3BJTEtBNHJ1M3FsZzBnbXphSmpjV0NF?=
 =?utf-8?B?bG1oNWdNMmg5RllnVUwvSHNIK2tBc3ZzRW9oWTRFakhkVEgzTytsaVN5aDdI?=
 =?utf-8?B?dVpvcE5UbWZzVXRBa3NWTWdNbFd3UXFQNzlrQVVVeWJIaERGaW95VlFuZzhQ?=
 =?utf-8?B?djJXdU5sdWRhMXNyODdIZ0RLTjI0dUFFY29vK1pqeTNtNmdZM1NOWlc2SjJ5?=
 =?utf-8?B?QWZMTlQzUGk2aUx3YlV5am1ncmxYRXJ0WkFKblpUdXJaK1lKeklnbFgvVitx?=
 =?utf-8?B?OUJMMmd4OUNqSlFBaTF3c3RqNzd4clNROXZvYUZOeVQ2ZHhZbjJma1ZLTk0y?=
 =?utf-8?B?TCtxUkJLd01IMm5kM2lOY01MYW5FaHlZQTdQM3RHTW5FQlVnQjMrS2Y0TjRU?=
 =?utf-8?B?QTdXK3doOUFpWVRPanZHS3F1dlVGM0d6UU9paGxPeTBaVjFJU0l0UXZwN1pK?=
 =?utf-8?B?VE44QllwMzN0Y29YNC8zUmpKNVQrSFlPTUF3NndYc0I0NjljVjZ3QldYbXVJ?=
 =?utf-8?B?c29RbDRhZVRRR2NwWitEazVNMEdrKytuVEhiSk1ZU01XZ2ZsSXR1Z3AxT2pV?=
 =?utf-8?B?eDg4ZGVUMVcrRks1WXVuUjBwdU41eTYzZXRzQTVqMXZqMlNmL1E5NzdnbzBK?=
 =?utf-8?B?Q3FVSVNhZjdIZ0Q3NmhXWFBHUlp3UXQ4ZzB4RFdMQmhiOFhGVmJmN2VKdUFO?=
 =?utf-8?B?RnhLMnFEUXUvUUxmR1AyWExoYWhaUnN5MnVwanhLTmNJOW4vaEFKYmdMTHli?=
 =?utf-8?B?aWZlQWVEM3FVZ2s1VW1ER0dqWWFFc0l0ZEtnTHErTzYzbWNKL0dsd3g2VDV4?=
 =?utf-8?B?V0MyeStzbzB4TTMvVUhzeFhtTUNkeGRGR3BEVmF1WC9QQ25xSlpDT1h5enVz?=
 =?utf-8?B?bU9CKzVDMDl4VzVvK2Ftd01MUVo4anRWUDNyK0x0Z1BMN3M2elpTWDhHaUxq?=
 =?utf-8?B?T3F4cWFkUHcraStXVFNjUkZGaDhJS3BzcDBRY3BFUWEySFIrWS9oT2xuUUVy?=
 =?utf-8?B?WGZ3ZmNkSENLUnpmY2VQc056U0daMDFGOE8yNVQ2WGwyMHVaaUxwUXRCQzZm?=
 =?utf-8?B?c0pPRXVkbkw4UThzKzBSM2hOd1hINm91alc0dEh3Z3JIdGY4M1k5U3FpR0dH?=
 =?utf-8?B?VWRzYUZFaStlYVdZZVpQVEl1bGJYbFlmakI5ZUo0dlhBS0NoQ2QydzFtKzY2?=
 =?utf-8?B?bllLcnhTRDFNMG9UcEdTaXQ2QlNKOE5KZHpCT2NvWlhUVlZuRDNFemxqZk1i?=
 =?utf-8?B?Q0dqTnhuVmN6cDBaMk1FMmNJZEtRd2N4QjZ5MCtoTHZzbzZibndveE5qc3ZN?=
 =?utf-8?B?cCttQVNJOVU2ZkowMmRQNHdQZW5qWElwNVZ3Qkt4VEZ0K2w3Z0hlMUtWTTZF?=
 =?utf-8?B?c1hNeFJSTW1CZ2ViS2NJMndEWVc1a3NSMmZ4Q0VBTzRydlZubGZPYWNUT2Yy?=
 =?utf-8?B?WnRVZVl0eGZCc0U5TllrekljdjliUlBPUWM2cTBSRTI1OURGb1NEV2wxUy9J?=
 =?utf-8?B?a2J1ZE1idHFKVzhaczluK1dVdlZEUHd3TFRVeER4TUNPMk1mR3VBKzh2cnhG?=
 =?utf-8?B?NHFpc1pRaDQ2eXhpVW1XcmpnTEdrU3IrYkxITGtlQUFyd3FrcjczU2hvUG1u?=
 =?utf-8?B?bWRIOGhwYWNYWm1Sc0MxVEVCS0JsczkrWnlmc3lMWEs0NnB3RDEvRXlwb2dl?=
 =?utf-8?B?S0FPUlp1cmZRcnJsUmtCUk50dHB3bnZaTmMyaW1SVkpTS2Rwekk2TVh4Q2FL?=
 =?utf-8?B?ajlEQVlUNFA4czE2bWJRVmJtQ1YyZ2Y2UDhVWnZjTXRQV3dvSmtaVVRkZ29q?=
 =?utf-8?B?eEZWMThLUU1OcnZDNmhIM29kQzVqUS9DOStsVVZxQkVtZjAxTjVFMWxRdmI4?=
 =?utf-8?Q?CmjXyqzjVDBQk/3BfQFSPbOhn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: becbff21-e5b1-48b6-0802-08db32ea15b1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 19:48:37.2884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTMjtUwJrQsQe0E3ziXO/LuOrp4z6DbZkmhYxlpe+iNDe5cVVtl0CAwqOtIIgoQ8w19vQIgb6KBzii6SU4HMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/23 10:07 PM, Jakub Kicinski wrote:
> 
> On Thu, 30 Mar 2023 16:46:19 -0700 Shannon Nelson wrote:
>> +     listlen = fw_list.num_fw_slots;
>> +     for (i = 0; i < listlen; i++) {
>> +             snprintf(buf, sizeof(buf), "fw.%s",
>> +                      fw_list.fw_names[i].slotname);
>> +             err = devlink_info_version_stored_put(req, buf,
>> +                                                   fw_list.fw_names[i].fw_version);
>> +     }
> 
> Keys must be enumerated in the kernel, no copying directly from
> the FW please.

Sure - I can stick the name strings here as I see in a couple other drivers.

> 
> Also it'd be a little easier to review if the documentation was part
> of the same patch as code :(

Well, at least there is a doc file at the end of the patchset :-). 
Shall I build up the pds_core.rst file little by little throughout the 
patchset?

sln
