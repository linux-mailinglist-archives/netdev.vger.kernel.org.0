Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454A36078A7
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJUNkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJUNkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:40:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE36EE093
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNlOYiOXX5rxC6lBac7UftPju/SCfPNNw5uGd/1SYy0OOTNDMe+5lfpRyS7HV3hezWiNxAKM2nb7XGf/yoiTdkw+1/Wt7baoVSgBlk0DW7CZ9ztgvBNOUb9BART1gn/78Dekrms0Qk4efjaXIJQKl3Datvs6pZPpOskUbNTAfD4f+AEWWPZCiUQzVtzXa0/d8As08OWNvOH5mEgt8lA6/NLGGyNnSLei1y3mSh2RDm6zt7sCCPLUePZvS1VNPg7UHnmvN6c8OOEEgvTQhjtjASvpFgfwrih3vYOzq03hYjjtOYgc5duCW54LN30AJlGcokbAmkKid2BbBzR84KsCHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCafY8WJuODMmZJ8zZVllUWa1m14MLI0JH5E2zlY43E=;
 b=P50VGMPXv+JTx4fiyRp1HugP8UgLxzlYiI+L71C/K3aFO+loItnR7To7nvv9EpIxLevu/NwpekCMpTlA86t4C2OQRgvswpKxDD04Y3bTBwuW0yufDVjj4hS7BOw9zWZWffgvi741R60K1S21X+j2QXaGtSPv5jZBBRkGzmpWUanIXwStaqS6cAeKpg5tbi9FjJfV79OEo9E58D/I8qMarbgC36zTMMr4mG2Fl50/zFV6TEhRmuYw/lBdw6SlbILiq06o90m0OFhNuH3tto1mOtdJCBfknzn120CpMPSKtGdkya2dGg9rCRLljvdhzlBywbX8TdIOoZya4slYHReMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCafY8WJuODMmZJ8zZVllUWa1m14MLI0JH5E2zlY43E=;
 b=22JRM1ZOAbMRsm3DkqGrz1XzLOwo7YN/MWLUSQEL9IHTC/8tmG7OP5yVZ7Ya48yrMwCUfFGXnQPojlpE7E5+JvxOAmYDwUkx2hBOzDCSyn/l3e3YFJtNa1KUrolOGG2SK/mRyLcicJXeIVqlAlSRlV8yrDbMhBkPLX6Tg6q272Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.36; Fri, 21 Oct
 2022 13:40:19 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 13:40:19 +0000
Message-ID: <1cdda523-fcab-be4d-42d3-8ea7dd4a2e2a@amd.com>
Date:   Fri, 21 Oct 2022 08:40:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 net 1/5] amd-xgbe: Yellow carp devices do not need rrc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     Shyam-sundar.S-k@amd.com, davem@davemloft.net,
        netdev@vger.kernel.org, Rajesh1.Kumar@amd.com
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
 <20221020064215.2341278-2-Raju.Rangoju@amd.com>
 <20221020214615.767a8c35@kernel.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221020214615.767a8c35@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL1PR12MB5253:EE_
X-MS-Office365-Filtering-Correlation-Id: 389459d9-e5ee-422c-e88e-08dab369cb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72Jk1vLynVc+OUNitHwAmzbdwSj8sGIP/2fL06ICZ0Y+tlJxcwW68lvHpwwhOWZ8HStBxWheYIK5wHhrGKiTb0tbLJMFyxRJ1kNY9e9q+MThVQEE/KCToxcDiTeeRQDXs7unjfjBXo/UNM/zuRzUO0hxHEWb0nn2qVcnDHSzLeDP23WriAyTfx7afe04gN/Db+PEvnwO4vcSc+Ab2qgvY4WxPirgjqDNq3TIPsDCsbtWc9TAMfm2eBCr+dp8D7KnMw4DxTK9SqU1oMdwErJRYk4R5aE5NzQoVxHRhNNwnEDQBSNyXKXPV1Iwx89TW8HHYnzdzFNVmg+mwhEfwYmxp3P9kLS2aQ6Iwiicyo61FiT0ec9h/5ikSdSV/p9oZJYFxvICT6dZerFul8gpfl9v/ON9HKE+BonMIdg6sNBKA0IHUJgpHkJbDzLMuuVQs2srQ00ZC8QPKfO9adVLSlYOWJcrDfbcRfvRAnvLU/fCI2cILgTfaAo+u42UeqfsUG2F/kapvwpR1mewDAHHP7b/OBE24pskZD7L305ySUUntMvY8fIfZExywlgcqR259bBEdYXHTFsnz9FKgPfYNjF4l3hKqAC5GIRiMlDrMZd2LL569AnHKam8vXGnnXLgf/Ysb7vS8yTkQaWBc5EPuS3+B2twHedoE3EREm5eS4VI852XgUN1XpNEhduhGu4VJCS4nTJLsqkHXsiDuhn223fvoW/TSQMJaWA0eykKLhRFzPh4ESwgNXj0dqwrNTyn1jGQTFaXbpkwXSOh0rNAlsU9lxeh6e+2Pizsi+14jKysxGHZFy9/c4w8GEsCJ47hk8fqBxugnuKIErEVfRlSLz54cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199015)(26005)(186003)(86362001)(8936002)(5660300002)(2616005)(31696002)(2906002)(4744005)(41300700001)(6512007)(38100700002)(83380400001)(36756003)(110136005)(6636002)(316002)(478600001)(6486002)(966005)(31686004)(6666004)(66556008)(8676002)(4326008)(66946007)(53546011)(66476007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2lnYlkzUUtZQUk2eDR2OEpyWHpwam45cEhZVGszMWRIV0NGN28xbk5EZVo5?=
 =?utf-8?B?VEgwZXlnSm1sRy9lWGVwS01RR0dLZ1hHeERDdkFXa1NRYlp0TS9ENjF0RndH?=
 =?utf-8?B?cEVhRkN6eGRZZHpoajNhOE9kZ1JpWTNRUjdzMXVuelBBdW1jZEJGeVQ4TE1w?=
 =?utf-8?B?VjNXb1FKTnBxQzJaOXY1b282eVlCY2UwckZyU0ZyTWZLQ3JScVhFdjh0NFNr?=
 =?utf-8?B?ZTkvSklKeGlvTllmcDYyVkgyL0dtL1B5Q2ZYaUNKWG5mUEZLL0xQeWpHdkls?=
 =?utf-8?B?S1c2OFF5d2RrczA0bWNqekpBaWwySHRUeVVobGU5TERRQ0hXRDRXTFcrTW9N?=
 =?utf-8?B?WVp0QjJKTXFDenR3eHN1eG9TWWQ1TC9GTFhQSTJLNVVQM3B4UXRhcWVqNnNt?=
 =?utf-8?B?SlpudG1NQU5kQitQbWI3WWJwUTJ5aXV3Zy9zQURlNWkwc2k1eFpmdUluUUlx?=
 =?utf-8?B?OXRNdXpETGVmZnlzb1M1R1pOT1hra0Nwc0w4OTBHUVhxaGdSUlFpdXdabXBk?=
 =?utf-8?B?MzRpanVLZjBNUCtJZjd0dUsxb3VpeDByRHhnVTVJMER5UHE0dlhDYjlFazc0?=
 =?utf-8?B?bFZPTUtmVVU3Q3RFOFRueXZWNjJLeVlYTVNLTlZPYWd3bE1DUVMyN29VN1Jw?=
 =?utf-8?B?dU9hQVpmYmpWNmlvb3g5UlhRS09uK1NJMG4xelZkdDF6Yk5BTHFWUlZrM0Rz?=
 =?utf-8?B?S0RkOHlyVXBEWHQycStZWnJlZisrM2hFb2RPcU9KNkxPdFllUDl1a1hhak1a?=
 =?utf-8?B?bEJhNU9BeEx3S1cycW1VcXFNMEE5QjZOUld4UkVTYmNZbkFkb2ozc3ZMUWhn?=
 =?utf-8?B?NlFIcW4vVko4UDB2UVJaL1dac255YmFBWDZuUjV4Z3NOMDdWY2xiS3lWMTZr?=
 =?utf-8?B?MklNOFRieVFZTkpGd0J2OFJzMDllOTFaQWJLajRiWm9zUDhEVnpCM1FDWjZK?=
 =?utf-8?B?K2E1WXFiRmRWMkF5Zlh0Vkw4bGpwdlg3Zk1yS2xqUFNuU2dGaG1oZlg0bmtC?=
 =?utf-8?B?UDFYYWYyQlVneHZ0S3QyZlI3Q21tMVhJd2M3WmdPVVFVMUllNkFLM0RkRlFK?=
 =?utf-8?B?S3ZKQ0VQQVFySG5OcHpXNnlzTWdtaXZsdmZtMUtTaXlJQXhSVFJpOElYS2Nx?=
 =?utf-8?B?QVZyb2xCdDFreU5JeXBuSWJBTWRmZE80cFhyZ2YwYlcxWTVtZGsxMVN0VVMz?=
 =?utf-8?B?MERkUlk1SE0vYnlNSW5lVHpFOWdEa1U1SUhXVGZUSGFtM2tsTzdTdGxzMm42?=
 =?utf-8?B?andqM0k5dHMyM1pQZno0VEZKYXlZdjNOZENydUZBc1kybWlLdk9VeTBXODkr?=
 =?utf-8?B?cnpKZXpkSnN2Z2ttSUtrZVFWSlB6OGFKeVVlL1ZtYVg3YkR2eGdiTjFZTk1k?=
 =?utf-8?B?QmV0WHhMdWk3dUZMWW5EbEJmMy9ySmFNRDZ4dEowYmFmbWZsSGZSWUljazZ2?=
 =?utf-8?B?UG93NnJzeDNKSjRzUFQ4eDllald6T2IvSnRsVmErVjlRYjcrM3FZM1ZTeHVS?=
 =?utf-8?B?YU9ab2UxM3FNWldIVDRKL2liTnlGc2pWbTlhMmRGcTBIb0NXWlBFNlhDYitp?=
 =?utf-8?B?QlFzTFR3WWY0TnpvcTlLWllCNVhLc2hhald0Q3ZHUmM1d05nUmcyVnZkNXFI?=
 =?utf-8?B?U2VIMHNWeW5BakJBaGRXU2d3KzBmRFAzOWplcGFBbHQzUHpqZ1liUEpIdlZY?=
 =?utf-8?B?MThGSDlxbGVpaC94VzRkSmVkMVZZZ2NyZExwdkdpc3RyTitsWjd4WVRQczBV?=
 =?utf-8?B?emtDa3BTWE5NS0hGUXhsNGpPU25NR3B3R1d4cGpQK1I5R21xaGtFaTdNdGpP?=
 =?utf-8?B?TUhKcm5ESU9GVFc0RWtlYmlYNHgyOWdWUEo4dWlHWE1QQ2w5bVhZczBpUFJN?=
 =?utf-8?B?bGhvOVpIa3ZHcGJycFNBcThsZjhxKzNLZVFCRjdlVGowYXhGN1B3ZElKOThO?=
 =?utf-8?B?Yk5pL3p3M24rTlR6YjkwbStPS3lOeDNMZkJBWUxSdktPTVlYOEgwMnlmMUJo?=
 =?utf-8?B?ZHlhQlFPL1JxMEZkblkxWDFJaWx0eGE2VC9XTTlhOEpMTXovcHFab3VPSElL?=
 =?utf-8?B?SDBkY25jb3lWWHVGV2lveHFGS2dZaXpwbWdPN3QxM1pzTTBkbFdRK21QQlkz?=
 =?utf-8?Q?7XhigR3IFvkiDFSu0dZbm4xBX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389459d9-e5ee-422c-e88e-08dab369cb37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 13:40:18.9817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jM6OuVdjh2SZz/9YpeAMX8cqfdWif+lehpP/ilTCFa3x0BdYM6isZXVYjGEHZDOFXrglY77cbS3iZXuCav+thQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 23:46, Jakub Kicinski wrote:
> On Thu, 20 Oct 2022 12:12:11 +0530 Raju Rangoju wrote:
>> Link stability issues are noticed on Yellow carp platforms when Receiver
>> Reset Cycle is issued. Since the CDR workaround is disabled on these
>> platforms, the Receiver Reset Cycle is not needed.
>>
>> So, avoid issuing rrc on Yellow carp platforms.
> 
> Let me retry [1] the same question:
> 
> These devices are only present on SoCs? Changing global data during
> probe looks odd.

I can answer for Raju, yes, these are only on SoCs.

But it would still probably be worth a series that allocates memory to 
copy the vdata and use that, free to modify without impacting any other 
device that is probed.

Thanks,
Tom

> 
> [1] https://lore.kernel.org/all/20221006172654.45372b3b@kernel.org/
