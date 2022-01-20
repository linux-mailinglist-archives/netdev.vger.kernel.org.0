Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC4494D16
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiATLeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:34:07 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:47462
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230037AbiATLeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 06:34:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtBmRnywYld9+ufhpk1c/qDdvuBArLN0SgYWadVgrEg1AH+ADHwLJh08RkY3Ymc9gEqSHd8C3jYpuKfZoI9jgWi8TZdAtVo1eCunckFL16Pmn+2kZcttrnB8XYfZl7NtzillrKtZLyxezwEntbwTpQqNClToSvinye1c/x05MCS2/f5h5Qiogth95HVRTgbIsGanLmyZduQ5eSQpKJpnMLs0x7H2ED2nDpu0rOPre319QdzMY3B3gqrWliIe+l28MhtZloLhNeNHaj/iLKej5Oot5aHwysKReU7PMG9Qx/FmWhzoRXyO5k+9hM66PAxjA0zqghlTDPqpCItJwCIX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRkn0BeAaOh7A96l47ncxWhz6gFA4R7EDkwh2W1f6iA=;
 b=NXh2OjXedRY1MvzFDdh08naZwr1cyD7S47ZP4b36+U31SMz9IPFhiM+PiEHQ/feVkUlqIzPA9Q0C8n9AeQ8nippTZgi+YgjgMTkPj1SGxYoMRaAe7aU91sA6Ch45aS+9ssn5pmiFQEOiceYBRZbhaNwAICecNn07CQbqGXIhBIdE4UOn6PyA7MtwZGalC2e3Wx2or4brazItcsvuMvaiLsDvmGWPosIGiWdocGCUvXFrkXWOJFDCL4rkXbH1Lpb+jbGWkdLXo87uyh4bH7X+RLkgNVEeAqNnK0GbIxM+0TU7/dJmRKeYeNCaNrmG2Uq3gLRu9+n+31eEbMq+21bRDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRkn0BeAaOh7A96l47ncxWhz6gFA4R7EDkwh2W1f6iA=;
 b=rgriWraCKxAy5qSIFqf688cs1O8TSQTlfhG7uafMYlgf8Ghi2O9wQE1bERd7ZBummjYaWn0H9C463snfNC9+4a+8jOBDoEcOwiTXQRpYHZkSy8ksH2pGCm/FQfSfZljk77mpZs9dWwY1Q1J0D8+zFCar+Wu9wNYlouIFaN4dy4VMU+d/ZIm6oTwP2aoXiN8q6NeG+KQbjKVIgqi6TL0iTgEBzMQcrD7bgxgL+oMaZwPFQ2EpIKYkQJhOtsqJ/lFXQnCj/3dKqjloM/vT4LRkUI6iV2wulXxc6j2UCMxX40fQa2WM8EPK7P25MHUWL8p50RzwuLffXRTW5o398LTuWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BYAPR12MB3557.namprd12.prod.outlook.com (2603:10b6:a03:ad::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 11:34:05 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::84ac:492:8d54:da88]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::84ac:492:8d54:da88%5]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 11:34:05 +0000
Message-ID: <2a49f5f7-9779-6e75-3040-b754cf66805f@nvidia.com>
Date:   Thu, 20 Jan 2022 13:33:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: build failure: undef ref to __sk_defer_free_flush
Content-Language: en-US
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     netdev@vger.kernel.org
References: <YelIBI/yG7gzy0Sf@angband.pl>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <YelIBI/yG7gzy0Sf@angband.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0354.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::9) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 138f3aa4-b140-410a-b933-08d9dc08c39f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3557:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB35576A54FE072E4636565A7FC25A9@BYAPR12MB3557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:94;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lyv3QOd7/GW3WWZe3Q69EkMfeyO3d05VrGInuQpslJkAzAckRoo4UlmCGWom1WgePC93lkCWg4mok4RDk2oQM7szS13k/CgwOBtI2OGbtUBfpRrib3eTy4wlXcS9pW1zO9SLIfm+7adyyy2hkSiMFpUK/F5KxCyt9Z4ir1ToT0bvpM3DSvbs+S5O0Lj6ReN3jdY2+f08SF/S7cjq82Qj6NSvThOPtlzgqNihrKMUnRNt9YgkSQBlf2lJfC93z/NLYOBIGvawvDwGc7HI/GC6+jnU19+JGAzJDFY15NDhGG5FRHDptR8jdWuRadIq97H59Oirw+BGu9hdwx2Nvg3peoNA5D4bWcuSt9hAJUHJOVQzTXhs+J8gI0GqWgBkcco734GtsIiMjH0w+pNI3u9HCekaF6gJt0Ui5fTVkxXJbW9DwuooFg5ZnTi6KyACI51aOK2m07wVtgoezn56oSKDMfaAwe1zg2ayTCzpuxZ7yhiHctiUI/3gq+6dvWS/j9/gEClBTO/eksO5xcZlULdiTcnwyv0CkhWJYEN31ZK6BqFHMUAOOeR9wTg4n+jh1q7/uTxol4O1wFYbuyc0QTeqK2jEuZfFVgqsrgI08Cq+OVXhclcLMkTFGDK143AMqMUt2KaQ+tPbeXMHmvnTIATqZxfXIlosf5+YEQkiqoqsdblzB5uTBT//6OAFGmxhz4hx+JZFVLKTgDV4vaFRV1xIlVTSn34yn+JinWj4K/WlVAqv0I0ohNV0/OLiqtYG+p+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(31696002)(316002)(4744005)(36756003)(86362001)(26005)(83380400001)(186003)(38100700002)(8936002)(6512007)(6486002)(4326008)(5660300002)(66476007)(2616005)(2906002)(8676002)(53546011)(66556008)(66946007)(508600001)(6506007)(6666004)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vi9sN1lkRHpHUFBGWEpaZmZGc2pDcUJhT2o2TU1FSmdqeGt4WGJFYVdIWDZN?=
 =?utf-8?B?dm5JSVRGWTFZVWJFVjhKNXFKWjlXOU5BTm9nSG8zS3p0R0kyTjFGQS9sc1RZ?=
 =?utf-8?B?Z2ZRc1Exa3cwckJFY0MzMlQ4TkhhL0JzaFNvaUdZMjJ1UE85UUViaFVjRXhr?=
 =?utf-8?B?MmQxL2o5TytiTGFtbDkwcW9XZHliNkpuZS85VjIvZUtGYlRGay9TWjRVVFNV?=
 =?utf-8?B?TkliTFJvSmJJb0ZTT09GYlVmVjBHSEFwNW5zV2xTR3JPVFRidnRlbGhMUUhO?=
 =?utf-8?B?YVhlS1llSlNXaVg4UnNhY014WkI2OWlhNENMcDYwVGlRT3dzMSs0Y1Iwbys1?=
 =?utf-8?B?TW5Yc3RocmYxTjBISGdkUlVSOTJOUGtYazRKdkEvZXFQVmsvNmd2Y0ZsYVYx?=
 =?utf-8?B?WXE4QUxGbElXeVRkbnVHRW5IeExmSDdkU25nUis0djdhcWpiZmU3aHFSY1hi?=
 =?utf-8?B?aHZjM2poMS9KVysvdDRUdWxtQWVMa2lmSDZqMStiWWdIMnR4Z0E1bTQ5eGh3?=
 =?utf-8?B?T0NGanhiY2lNVkFKa3JGU05Xc3ppam96NTdscWh3WGh5aXNWU1FhemdIN2xY?=
 =?utf-8?B?Q2JhdzJCdUZlVmoyNUZvRmxRUGZVdFY1cDNrcTc3YU5JYXhET3FSZHBPUkJG?=
 =?utf-8?B?bTZMSXZEbnBaZFNoR2lYQk43N3JzRzhQV1RtcFIzV1VpK1VUN3l5alBodGFD?=
 =?utf-8?B?WHhWNVo4OEJuNHM1QU1RRmtlRlNOVVlLcXZ2SjFvamFKZjNCSTlyQVNzdWpz?=
 =?utf-8?B?ZVkyclV3TDA3MGVjMzNkcVRrL0VCRDhDemxnYXhtT25qeFE0Z0x2dWVtUTZz?=
 =?utf-8?B?cG5IUGNpZStieThpUlpkbVluRFRzWVFOYjJGQmQyUllaVHdoUFNRTU9wekgr?=
 =?utf-8?B?dWNaSThFVnZmMnFXcGhrYUxnNnBINmJ4clVkdThra1A2cncya29MeFR0cWZH?=
 =?utf-8?B?ei9iN2taVDIzaDRXbitFRzRpVXZ5aGVBUXRFZ3ZNNWlTQllWN0hDcDJFUzdh?=
 =?utf-8?B?cmJYNFpYQTRSZGxQQ0R4Q3hNUk5yZUV4YXVmUUkxcGhpQm1sQmdJZTUxL003?=
 =?utf-8?B?L0JhbEhKSk9VWFEzSFZPdFozRVdaSHRpcEZuWXhESjUvaWwvaWoxVEJ6Vmto?=
 =?utf-8?B?U0YrOE1DSzFsa3pIT3p2UWJ0WFVJK2VPNWpTbUVwM29TYnowTXh4VzVXQjJl?=
 =?utf-8?B?alM3YTNLb3U4eWRzc3JFZGo0K1Z2U3ZEWnFvNVY5YjR1aVAwODJCUC8rZ1Zi?=
 =?utf-8?B?amtWakg3aERRK2tIeEhTaEk3cllIbzFCeTh3RXlwbXJEaXFyaWt3bU9TTzVn?=
 =?utf-8?B?c3VkT0Q3Z1VCeVlLcm1ramJFS0JxRXNWc2pneERVN3BXWnJuYjAwc1lMT1Br?=
 =?utf-8?B?dFZ1MmVOeW9OVlB4QmdsdlN5MlV0cy96M2F6WnA0ckRURzA5QzdaL1NGRmM5?=
 =?utf-8?B?V0R4RmVhY3pwNnU5WC9IODZYZldBY21tN0laZlYzVlNXSlRtbU9vNjRSMVBo?=
 =?utf-8?B?UU44T3FkWm5wVkFibUtLdFdjMFE0Zkp6SndMc3R1Q3drbGFHZU95N1NURFNM?=
 =?utf-8?B?ZnNSRkdWVHNYUVI2VjJTVkFOaXRWRFhiclNLMDlQNm5NaUdMSmVaSHY2ZzI2?=
 =?utf-8?B?TW9vaHp3T0tJN055QTBEb3JXb0Y2djZPUVVzd0dnQVZFdXdUNFVtOTJqWXp5?=
 =?utf-8?B?YzJmaVBEUEVEaDkvYjYxOGlEM2lHeXFXaGJqUkNBTnFDNHIxNjE5Mms3SVcw?=
 =?utf-8?B?emN0RDNXSnc1QUo0cERYY2RjZ0dDa29rLytOaUN4a3JmSGR1MUk2R1dOZExn?=
 =?utf-8?B?TTN6TEFkTk1MZm14K1QwQkxrSzZPZ1YxUTBxbnZralFUOGk2Nk1YTU50OTNl?=
 =?utf-8?B?anNyZmZodDUrVkRYL25QWForT29FL2pVOHJiSzBwRDJBYWFmbS9yTFZpV3Vl?=
 =?utf-8?B?UmFISk8vRVk2Skc1TWdPSVVTK1pGMkxiRGo0RDA5bjNVRmlHelBUc1FsbXpF?=
 =?utf-8?B?aFhuZUdHQTNuK3IxK3lUSnBwV0NIN2IyeGZLTUFzQXBUaVRtMkpoQXR5OTJ5?=
 =?utf-8?B?Q3RWRXJ5NFpRT2NaTVJrYmZPNE5OZnd2MVpxM01jTjdLVXE0L0VGWWxlT210?=
 =?utf-8?Q?eLQA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138f3aa4-b140-410a-b933-08d9dc08c39f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 11:34:05.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvlyyUDAnb0rKPJgP3d9EV3oVx6mUUioXj1heqwVb8rndRSfnqMJ4k5IbVQbhgy2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3557
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2022 13:31, Adam Borowski wrote:
> Hi!
> Your commit 79074a72d335dbd021a716d8cc65cba3b2f706ab
>      net: Flush deferred skb free on socket destroy
> causes a build failure if NET=y && INET=n
>
>   LD      .tmp_vmlinux.kallsyms1
> ld: net/core/sock.o: in function `sk_defer_free_flush':
> /home/kilobyte/linux/./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'
>
>
> Meow!


Working on a fix, thanks.

