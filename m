Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2545422CC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbiFHGCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242914AbiFHFyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:54:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2049.outbound.protection.outlook.com [40.107.212.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D456192A9
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 20:49:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2eObMVG++A/ldwACi9YzHHW6jL79i85u0yseMWqxHvvS8b5L0vNt08MCAFCprHggmpLcuMm+S1e3kU6aLr6cD6kVpA3Rm70H/S59oDBNJ/fHh0zlQxlROVQ04oskhIwjNi8ayWNm6Sb8vp1KEkJlsc6SNzeItk3+HpCRiP3cMx/M6aUAN7RIQtHDPMGbiwsiYVI+QZpOM92XjYix/X1OY6YjqkFI+oeRgR1auf4VCnzrt/hTpXU63f9xzVNyo1Tfbry0ZrzLODpYOtUIW9MTp6FPvvKFa2NaIxaj0+G9pHVYI5BtZnLU9N9+X13N+YDKxaiqnEkz1D9/4UoZCmdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=270NW/+E4BQPZt25aqRIsZ8sXDTnkWLEgTn/zuFfNwg=;
 b=FWKnUYLFW+zbyjBb7ckaT9GcVndz7hZkRlkbOWD33V99i6F0oDpFGiEiW5h+Bn+HBzvVKlWG/X4yd0qvUnPrH7AYNOqKUBjDVrk7ijievbNN7bZmmx9t7oRR3MoDgWhUvQkG6+O8+JrwtM7jolrlCkK4lg1y8duVeEhq8hdHHhaYzE4WIjXfWCP4HTLJ+c2xSIjeyClZYhHSZiqR/BLhzBEE0Ex7DxR6XW51eZ4WE7QZHAV24wBVUvXpC8OmAgzlovapnkC6BHDOvMZ/qmqll+8JeOGjDJYpUvuBuOR0IBDb0H8CE1O+JMPzKDOX+CK2GuJ9/8sCBIgavm5RO5Jpyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=270NW/+E4BQPZt25aqRIsZ8sXDTnkWLEgTn/zuFfNwg=;
 b=jFkl5/8yfuVlnacQxbkW1vQa7+r/JXpks6Xsg2Ln5IV/5DZXEYkF4yCfLAjnThglKxwBccGeMDPbBloosJGhayFiO7vDYHP5W2HlU0zqf+9WgIb7eNbQ0Elhttt5w+m1SeqRYqzbQP1klXq5ozbTK6Q/bVXwDnGaGMO1PTNZcV+kM6OxE/fF8NoHcxV6pZyF6wdYP75poucRItPxX2aarkgrTaVgV+TTeJ+UsPnFtkVgQgbdIkNRnrluNQLzaFojWsJUQzdG9aghrfz15ArKgXY7j/VpmrLEU2u2+8nBSof2PDfz6ebKvM3zWhLJslaRpZzYobSMSCRMsm1abZBr/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by PH0PR12MB5630.namprd12.prod.outlook.com (2603:10b6:510:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Wed, 8 Jun
 2022 03:49:42 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 03:49:42 +0000
Message-ID: <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
Date:   Tue, 7 Jun 2022 20:49:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: neighbour netlink notifications delivered in wrong order
Content-Language: en-US
To:     Francesco Ruggeri <fruggeri@arista.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
 <20220606201910.2da95056@hermes.local>
 <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
 <20220607103218.532ff62c@hermes.local>
 <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
From:   Andy Roulin <aroulin@nvidia.com>
In-Reply-To: <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::49) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c115bbae-93c2-4a6b-041b-08da4901ebba
X-MS-TrafficTypeDiagnostic: PH0PR12MB5630:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5630FB834E3F664D5A13F018CAA49@PH0PR12MB5630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHZILrSJMqIACHJE/+AAjQsy8yIDncno6PmpU+TmfTE2pIet02WaMIPKcNxNjHDOk0hW0Kg3ucVP9QOO02oN0WRD/1qUoOZ60cR3lc6/9SLSvoB3ty4rRLKiyGCDsqp9pHwAd/KPURm+CbGtBy99hXucwzRGxkdxEyQMKqPB6ZI0uhxE8YvFRV8FXlPkugk4U6sAUZgLFcyX8yDw3/4Dovx3u5hPmrfr1U1BBkv5ZjMPAQS3ZxtAsNYqGq5cxwmJGfDsez2nnvR3WlEJn6GGYiNQ1uGXMkHUHTKISN3fiBVOpSBybFRAXep0utFHD/vr65JiIfEHfYFeEmrPQ5FvATf/0uTY/6EqB9kW0Caraj3vbUMwQkutdGAWHQ5GzChQHo1AVxgaqnO/aqkWv+fXdwvWUEYuV9Ybne9XdYfUjMI6hLnnClLsbucCV62D/VgWaLRUldUa2U7+9N4LrIlACI8JKnGnk6RcOtyhDpEMka2hdJdO91m1gOgixZkwLcy9orIsJmPdt+JeHx8LQjF64LPFhoz7Kkl+GFaJGskUnJNWFOcUAFKBeZ2IoADUSNyrsy6UqpzH3wVw8LmZ6bSL2idkr/siaEJul1+5DOCptuCXktOo9iOCsCU0CD/SU8irbrfbgLCuLPX9YKyrn18ldYDsPmoUlwNOznAMCmgEISmZsAL/jLKXYoMphWH0zH+wYvQEfiToWFdqIvaPJl90LZlWRy8difkApacNSOYpCGBcw728sbWBfBiTsOpjD7F/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(31696002)(6486002)(31686004)(66946007)(8936002)(66556008)(5660300002)(508600001)(186003)(4326008)(2616005)(8676002)(110136005)(66476007)(38100700002)(15650500001)(53546011)(26005)(2906002)(316002)(36756003)(83380400001)(86362001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTFBa3VXQml5ZVhVdjlVbSttWDBqYTU0TEFEWlcrZE9jZy9LUE5iSDd0WG5p?=
 =?utf-8?B?Ump0N1FuTHVrdmVHbjRheEQ4WUNyY29SRldvYW9SWFVKSVBKeUV2emx2SkI1?=
 =?utf-8?B?eGJ5S29aOGYwdzJMeGpGSC9NMzlEMDIybG02b0MzblBBL0xGVHdUK1J2VlNo?=
 =?utf-8?B?eXpQcCtnalZvakN5N0lMa0sxNElvcWtiR3l1UkIyMFR6b2owaU9LckxoMEs0?=
 =?utf-8?B?andLNnBRcW1NdmxBQTUwVi9zL2tRL0wvQ2owZ0liNnhLS1FQRzZyc2tHdjhv?=
 =?utf-8?B?WHlBdjdWendrNWZrdkx6d25iMDRLaExxU2RzeWF2ZjZtWEkzWHpZdDV2QUtD?=
 =?utf-8?B?b0tuV2owRnZUa0EwemhheDJ1L0ZIV3V4Ulh6T1RwVmJXL0F0bW9CUzNDdkZy?=
 =?utf-8?B?OVYzdnZCSXhWS04rb3VkN253QVJZMGlzSkdwVytRcFkwSlZJNDdkbURZV1k2?=
 =?utf-8?B?SWxEU1FSelJucW0zTkQ2UjRsZVpxMlpNNGhPcXVmZFdyVmd2bEI3UVFlcENW?=
 =?utf-8?B?eTVMUm50Ykw3bU9rTzgrS0lUUk9YaklBY1pWUHJLaWlsMmtrcDMxQ0RWM3lE?=
 =?utf-8?B?OGFlL1dIVExkU1FKdjlxMDhHMnNVSWxnMkYrMmhJRC9CcUFUc1pJTzJGUFhv?=
 =?utf-8?B?aGkvWEMybzJBWi9BUnBqTTQrMStFL0dEdXZaczhVbjQyRjQ5d0lTWXlUczZp?=
 =?utf-8?B?U1RhQjdmV2RxaGJBOEtoSHNEa29EZVhuVWlDU1pXWFN0bXB1aWRpNWVHdEdn?=
 =?utf-8?B?dEM5K3F1NVFON0lQNURma0VRd2N4Z1IrSHltUUpvcENwMm5HUVdiZzZ4UE90?=
 =?utf-8?B?T3I0eVVBYXQ3SFZDVDV2aEh3UzNISHlDV3FJVUJaVWloOVp4bnFGSnVQcEhl?=
 =?utf-8?B?MHBnd3FnMkpudXpmS1ZFWWp0MURGNlhITzI2MXFlQUUwTlJ2N3B2VExNN0xH?=
 =?utf-8?B?a05KbEVZQTN6Y1EvWFdBZTBRbnNsVnViWHF4MUZqM3Q5TkFycENWT283L2RL?=
 =?utf-8?B?ZisvdkdSZ24rN0twTFVBUGtCcmFSdFFycTl4TDlZd3VaZGk5TmswSmMycURz?=
 =?utf-8?B?K0dHYlNTS3FtL1RsWk0wNmx4dmVaQVBycUJsVnJRelhGRzhPdmZoNGVsVkJ1?=
 =?utf-8?B?Y3ZBdkJWZnNnNGxBNFlZNmVUaVoza2hGdUlDMWs5NUtob1pUNE5ncUNvSmoz?=
 =?utf-8?B?WXZoNnFjM1BISU5PeVQ4ZFU5L3U1TFhnTUFEVWJjYXR4aHllK0E2Z1JLNHhU?=
 =?utf-8?B?Y1c0UXdUbHhrV0R5SDZmTU92WElocDBHZWlwSmZvTnI2aFk2VS9DNjFtNXAy?=
 =?utf-8?B?WEgzM2NmSnV0N0dkTHlRWmhNKzA3cUpLRGtaMXN1aXNvdCtoK3k3Q3o3Nkxq?=
 =?utf-8?B?Q3p4THdVQUViTFV4aVRjWDY5aEM0UjhDSnR1YnU4S0pYWDFwNC91NzdENkF0?=
 =?utf-8?B?N21CZythUkRuS1hXOWRhTEs0dXNCNXRnVGtDVkVZZVltb0lJZWRPSFhkbjRH?=
 =?utf-8?B?NkI4dVRleDNXNDJCOGFIUHZWQlV4VXcwZS9rMHFObVp2YldiTHpuTFpIeGpJ?=
 =?utf-8?B?UWQ0WkRCQ3RpUmhXZGtaUms5dUtJc3lFaUpLRGJHVXcyMjRxSFJ5UXFDTENm?=
 =?utf-8?B?NnU4a1BiLy8zVkFjZ3VhTlVzRHo1eEt0REdMcFNNMWdtV0VkYkFrUDlpSEpS?=
 =?utf-8?B?TkRPTk5CWTVuWW9KUy9saVpUSnUyeVNpTW92MEdWcUxSbDNIOCtrQ1g3T2ZH?=
 =?utf-8?B?TFQzVjhDVWdtdjVITUxIOTdBcVZwTnZXQjZVWUh4cFd2MVZBM1FKeTVBTmVN?=
 =?utf-8?B?L0tzWjNMWXRZVkYybTBjakJxei9QL1JlU0dCZUVNaXhhOFBMMGZyYSs4OEM3?=
 =?utf-8?B?bXhaUDl3UnhHWDlseG1nOE5aeTVMc3JNdnJjMk5aMGxZMlV1aTdEekJDSmI0?=
 =?utf-8?B?WXRacDZHUGNLYnh5WTRQdUYxZXFTL3cyc2RCTFZkRXBZYlpUaHNHamRaaTBF?=
 =?utf-8?B?UzNmSVE0YitEVlJhUTBmV2xnUHpmV0xqOTd0dXhVU1ZzQVdRNVdKMFozRzRx?=
 =?utf-8?B?SzgzdURMWWNuQjJWY2ppNEJpZjE3d1doL1dwQnZJTmp6NllGdGU2bVlQQ1kv?=
 =?utf-8?B?bGlEeW9YblBseG0rWjloelJBbWVqM1JhQjJzdWY2MnFsMEd6aldrK083eU81?=
 =?utf-8?B?TWc5anErREdPK2RQNEE5b0t6aHVBbjNCc05GaWNFYUtZM3FieWxycjFRY2JN?=
 =?utf-8?B?bHA3cUVDeDA3cTQ2UGdYVTJXU2c1VUQrclV3TnJCOEdKVlRvL2hMeFluWVk0?=
 =?utf-8?B?MWR2dDVieWtJTHMyaytEZ2R0eE1Kb1JUODVUZFNvVUpHTkE0eEszZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115bbae-93c2-4a6b-041b-08da4901ebba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 03:49:42.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyLrdk4wl1bHbt4Uv8O07WAvbiXSzZAj/3p2ZfeW/Sysrq4HYKyTJWHBLOyUpEedTIeOt2ZxcRraUApT5x44QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/22 1:03 PM, Francesco Ruggeri wrote:
> On Tue, Jun 7, 2022 at 10:32 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
>>
>> On Tue, 7 Jun 2022 09:29:45 -0700
>> Francesco Ruggeri <fruggeri@arista.com> wrote:
>>
>>> On Mon, Jun 6, 2022 at 8:19 PM Stephen Hemminger
>>> <stephen@networkplumber.org> wrote:
>>>>
>>>> On Mon, 6 Jun 2022 19:07:04 -0700
>>>> Andy Roulin <aroulin@nvidia.com> wrote:
>>>>
>>>>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>>>>> index 54625287ee5b..a91dfcbfc01c 100644
>>>>> --- a/net/core/neighbour.c
>>>>> +++ b/net/core/neighbour.c
>>>>> @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb,
>>>>> struct neighbour *neigh,
>>>>>        if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
>>>>>                goto nla_put_failure;
>>>>>
>>>>> -     read_lock_bh(&neigh->lock);
>>>>>        ndm->ndm_state   = neigh->nud_state;
>>>>
>>>> Accessing neighbor state outside of lock is not safe.
>>>>
>>>> But you should be able to use RCU here??
>>>
>>> I think the patch removes the lock from neigh_fill_info but it then uses it
>>> to protect all calls to neigh_fill_info, so the access should still be safe.
>>> In case of __neigh_notify the lock also extends to protect rtnl_notify,
>>> guaranteeing that the state cannot be changed while the notification
>>> is in progress (I assume all state changes are protected by the same lock).
>>> Andy, is that the idea?

Yes correct.

>>
>> Neigh info is already protected by RCU, is per neighbour reader/writer lock
>> still needed at all?
> 
> The goal of the patch seems to be to make changing a neighbour's state and
> delivering the corresponding notification atomic, in order to prevent
> reordering of notifications. It uses the existing lock to do so.
> Can reordering be prevented if the lock is replaced with rcu?

Yes that's the goal of the patch. I'd have to look in more details if 
there's a better solution with RCU.
