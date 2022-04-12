Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757534FCBEB
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343930AbiDLBi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343699AbiDLBi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:38:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C52126C
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:36:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2t1bLDNj3u+zimWMBj7b8L7/gGEI1K5/a7GikMmSVo8VDQgL2vrObXuMR+cEW+hjob6qJTuUnBQ5LRiGYW04RsXEx2Fbp66nODBL3zDK8sLPjDEa2rkxnwBKpTC66HeTgn84oghLASqgIwuPYxAHhg0/Fqs+r23XSOIQo4RNZNTvuSNrPND5gDrUZvqX2J+rbZ3Q7S1MLRtEiK7oMhDkoM6kL/gHm/PwgnTBNkqxqDvLym9CaAVy++gatgUyoOV32fHMK1iQU5GoFYjg8/eQMnHLsU5sry53gTn2wGECaT40cJUQHXdFj+dQ857KNSYHEyHj+xZuqAx1vj996l95Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kde0xU24JzgJ7fE775i8m8bOaVGwL44YQTANT26JNuk=;
 b=b+6SeSPeZ2A1xcn9LKXYXAdQyogNfDKMYZJep0bFybzt10B8TgqbGYJrEAjzB4inr6hoCNaZCCW/5cxvjc87y24uV8SwhnjequwSkU+sPr+E5IR9NZ/LP1I2fHrM6sobt0S53uXz7HSlP9F5es0eYcJj9vDjIpRB+DJYUSyFXuhC5hjVh4s1gnkB+a9iBUvyE9rAlCCctLtFfB2i0Row7RwvbK5OFS1XQVOKkT+LIdSnSxBV1uRsYU482ZAt1WWJfv6VCTOCksQpmnNQuQ2gYUK3e0utkHV4ku7meRKm0xsCHmU6eAfdnLSkBPao1TaNIgE5kxCc9I92oOfFH0bEww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kde0xU24JzgJ7fE775i8m8bOaVGwL44YQTANT26JNuk=;
 b=cX9a3nfCjglomXQY5eNDIx1hncpVr4walWafWAbN+KN4T2ge+vYIM7a0DRtJkUTRGI1itWLLtGbcP0MUjnkbwKvEHtdFOX/PyideAYd40NpXVQmxSNpPgFCt6ohXDobyd3iU7lyhX8jlU+pBf6joql603ueAuSndjOwtd3E1YzfH8eI4m2ZYzMd05pLmqGwwHuXCwxPP8k+kTNBqj/hs+J4RPNGkl3IP9HT8gr1CVFigXRVMTZ00o9nCARpNhrjdP5I9Y963sN2+FFkbmh6+T2RWFyYMC19xU5pEvOixkPLlxRtfneWA6f/ak9Pfoke4+fIT4WsgMlMP3o5w4kIpDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BN6PR12MB1521.namprd12.prod.outlook.com (2603:10b6:405:f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 01:36:39 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 01:36:38 +0000
Message-ID: <18faeafc-d588-49cb-e17c-65ef5fea2bed@nvidia.com>
Date:   Mon, 11 Apr 2022 18:36:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] selftests: net: add support to select a test to run
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com
References: <20220412012012.3818-1-eng.alaamohamedsoliman.am@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220412012012.3818-1-eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9506c14f-f87e-4d3e-459f-08da1c24e34d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1521:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB152124E21506788E279B6DACCBED9@BN6PR12MB1521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcECs/08JqKWJ7qgCZhA7AiIQ2mRI5lHjsr6+AWKK6DmyblGY/mx6VJwQo+jnjx02BShpbRAj0766hQ8WbSy8CnVSyr5JPy+vFma40nBd2WscZ6ewPA+EXf0uFQw39SrQVpilsiOwfPGK1piDAlC+6ZuE3LOOfQHc2S5QNoBN7zUwmMmEejk7QF1JcprktyzbViqzyfpW8B2uF8TEbAPBpm8Hk5mHnERSiOKyinOFs2LEkoFgfRoVGPP2l6EuFS+sL7hpK4Fh2cvDLbKfUahihsEbNTq1kyhBkFic+sCjZWVRvj13BCt02Hfv0t+XEDmMydGoN2VMeTbRq5OCFBtdPaV0me25QSysdYeqq524cG6946Cjl17mj5LBc31CMaYKl5xo+VAK3vU2kb8osKqRPX9fXY6+rY1ryUqaYcu+zolpKm6Szhktmf4fvYIRW7LxbOZyg6air2q56x28X4rVtlGU8Ft/4iG7JzQZuGpZK2+ujeb9Mx+kIuqAne0YbfSfqa85bTOGFJeWTqTA8JqvBiBvlOv409cVrTwxMChlDh54l9qzUr4VADVCV0vUV/DT5WVEQkC7qYL8gtTwX4e8/O0CTsuzGK4PdbGNpOhxuElKj08kKYgUNt3oU+i/wllrFWCw1sVwCdl0XyeqCi07RXZ/eBlaVDZFJn8W6aBgTbaOclTvnzmxCQW3m9k/cwliA3lMyEPOsSBECqD6SMVzU8YrpanBmxOXcapnK8FBrQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(558084003)(53546011)(26005)(6512007)(6506007)(6666004)(2616005)(186003)(38100700002)(31686004)(316002)(31696002)(86362001)(66946007)(66556008)(8676002)(66476007)(4326008)(6486002)(36756003)(508600001)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGNPeWpmQ0NndjJCNkxpQkJBcitONktnZ0g1Vit0azFIdkRSd0NKNll6ZmVr?=
 =?utf-8?B?UHQ4ZVgvWDdQaGRid3NKSFZjUG1sMHI1WEYzV05RRkZKR004eFpUOTVjTVlO?=
 =?utf-8?B?NnR6S1FoYzhIYlcyTGNvR1lyTUppMndYU0RPNE40STJsQU03RHNYMjltdEFp?=
 =?utf-8?B?NFl3d2srbTE1eHVPVGpSZnQzUFRQZjMwQlRtbE5mT1VlcEJmelpNQ0F6NWNV?=
 =?utf-8?B?V2x3SmVQdkVwcWFlRk9oRS9DNlRqck1YQkVHSlpqNTExNHJXTkhPT25tdGpm?=
 =?utf-8?B?d0xZbzV3N20xT0dpQ0pYUVg5cjRxc0ZKM2hERDBWaGxHSkZjMGQwbW11ODZH?=
 =?utf-8?B?NmRwUGJoQU9VbmlEeitIMFpzcmhRamxjTTZpOFg3ay9ZcEpEbTd1MlAya1VZ?=
 =?utf-8?B?aXlyZ2pseXo3Q2o5R0pvRE9pamdZa0lhOEM2RnhkZGIzaDBWM201emdKZnFI?=
 =?utf-8?B?OWxEa1FaSWpKQVpnZzhhTWROZkJud0dnVTB4NDlNUlRJQzZMUGtLMENibDFZ?=
 =?utf-8?B?STBtSWJHZ2Y2dWVldUpGQXU0YjArRUhlT0xJekdtWm5jR0tyZlFvcjJ2Unk3?=
 =?utf-8?B?TCtFdE5DK3NIRTRuZ0xFMU00UkQ4NnU3YVFJT2V2TUhkY2FNVVpwQVcxYlh5?=
 =?utf-8?B?VTNGc0JyNDFibDd4eks1dVJmOThNaWw3eDd2TExjdVVZVmhHUWRQOTF1Nm9R?=
 =?utf-8?B?TzF2bmtseEZtYURjVWJmWkp3cENlV1FpRlZPSG9tOTQrWjdCT3dnY1RjUzFO?=
 =?utf-8?B?SEhhM2dWQUljUEFGSXZBWEpCMlJLNkZHZFlPK2k2YkhhWFZKR3FOVDU3Mndq?=
 =?utf-8?B?TEtEMnovYlMvMFpOUUVYbXVzdWRqamVyMktwbGlRaStkd3hTTkphOVBpU0hU?=
 =?utf-8?B?ZHNKZTFrWXVOUlRENks1N0IvSit1Z21FZDNxQzBPcWtZNkVXYkhMVlcwRzMy?=
 =?utf-8?B?cmZRTk85WW44YkQxN3h3RXFzUTNNT05JZnUzTFhrUm50eFZwMk9rdHY0SmZ6?=
 =?utf-8?B?RlRPd2pMUGx2dW5QM0hqenlzMktOQ3JuelJpODViTmMrM0NZRkx5bFRJMCtS?=
 =?utf-8?B?T0daRDczcXV2WUloZzZHZU1NUkxZbktrME1LdHIzb3hZa3I0YnoveGo3V29Y?=
 =?utf-8?B?Z2Y2cXBiU0NqWDJTLzRkMlVXTDQxT2lhSjZxaDFTRUl3eUtWUW1xSndYRGg5?=
 =?utf-8?B?SFVMTnY4U0x1L1doS1hvNUtKd0FJUFhWUEJxL0ZNSW54ZGhjeDFIVnJkMnpo?=
 =?utf-8?B?bXpteUFONmV0eFo2NWtaeVIwZWVsUXZNbWVnOW5saU85b2o4L2V4a0Y3ekhQ?=
 =?utf-8?B?dmkxQkZrelR6VlRmcE1hU29GWWJ0bW1UQ2k5QkM3VDZmS2lySlJrUE5pcWZO?=
 =?utf-8?B?ZXN2enlUZUEyQVpoOXNRS1JBN2hSMVpNUHdwbkx6WG00VnFuc0lvazRxRXBO?=
 =?utf-8?B?aEUycjNwdzlMa3MyTnZEK2wzb2c5amkxb3ZFK1p2R2h3amltWCtNRHg4a2Vj?=
 =?utf-8?B?Y2ZiVjM5VCtSbVRHTUVBbjcyRGtCYzZ5S05TTzlTd04rNGgxMU5aVy85cW1a?=
 =?utf-8?B?WWxmbjF1eGt0WTVEUUZBQ0htaVJSZUJsZ0lNUWhJNExIbmVTaHNIYVY1YUFJ?=
 =?utf-8?B?NEZTZG9QYzgxVDE3UkZLWk05bE9sUWZOUmZ3bFVwMkg1VEZMN3F4dVBUK0pt?=
 =?utf-8?B?VE5zTlNGeVdIdy9SZHdRTGhyL2dRQnc5SzJKVXBuOXZYUnFwc0VaVFRFVTk3?=
 =?utf-8?B?THppNmcrSWNaU0hhbUlVTExSWGwyZVJ3TGhxVytBRHdXejB2eUJZd1lkTnpR?=
 =?utf-8?B?NmFNbkRnR0k4RWxZV21lUllDS296UGFUZGZiRFhCV1RlUGRndzJkSDVWa21q?=
 =?utf-8?B?d2xGSDd3QmNtdXMySFRFNDkxWW1nMHdUczIrQ25YV2ZDVWZRYkVOZ3VHZkts?=
 =?utf-8?B?byt4WnREaUFWYzJIUEEzUDF0a24vcVVJUHJzU3QxWmRpbHVTUTVhaWZZbXVs?=
 =?utf-8?B?Z2pJbUhUZmwwM0gxN3oxTm1rVHhrNlhWRzRRTktRVmVCakRHS0RJWnRib3gv?=
 =?utf-8?B?dGp3Y3VYS2MyVmxQN0F1ZVlvaWVqUzlZajZWVFo0VTBEcFd0WXdDQ3V0L2VB?=
 =?utf-8?B?ZStoaWlSUGhUZ2wvRTZiRTVqR0h3Y3ZmNE12TTdjM29QcWtXOG1TUk13OGNv?=
 =?utf-8?B?TStUWlhuNG5PdUM1WlNJSjEyVGZEVnQvL0RqSktSRjZ4TkdIOGk5R0ovc3RG?=
 =?utf-8?B?Z0VSRGNuNXFBbk5JR2ZtQTE1T1ozRVQzdTFqa2MwVzFUY2xMZWZ4aEFXd08y?=
 =?utf-8?B?TGN1RVdBa3RralJLajdSbkVUYW9MQzcxaXZFcWt5N3o4YTVva1hndz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9506c14f-f87e-4d3e-459f-08da1c24e34d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 01:36:38.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7So2iYFOdocdWYZ4mb7GhpYaXdd+foiZ6yQHVtmTOzEEHCZBKZr0CU73wvTfteNjedOOqgn54Mqq5lmkZ6jb2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1521
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/11/22 18:20, Alaa Mohamed wrote:
> Add boilerplate test loop in test to run all tests
> in fib_rule_tests.sh
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---

Alaa, can you pls resend with net-next in the patch prefix ?

and include test name in the patch title.


