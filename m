Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077A5619BB4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiKDPc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiKDPcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:32:55 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C54B2FC24;
        Fri,  4 Nov 2022 08:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkP/2o/9K6OJulzEAqWrxdAbDbWwgJxmjzMXWqwMvLcmRe/WkGMT74AbgjkUzCHDfg32+6CE4tzylzMLfIsqlZilmnWj9KAX8oPM33bHngbUHvB2dp3Unbz0Ik2VyHEazrdlFa5o2cBeBLDRCKoNFpMqutKAn1aSQ+m0dzgjUuP3VOR5ROLWE+ZOyOsgEE/tHOeAzxOqlAlTArdadJ3TFMAlRzhbVdfB4CUtRI0qFkh1dzav/XvtWyzxwZ+HC4wTrX8t6gH0uToQhOiw7hHexQIVrSdTXmdqwKFeW2SQc/qBffkipZOfB3WAM9DtFZtCxEa6wYO9lN+ehrMu0t9ZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dt+w5VayGAmzc9zZQoEhd/zSYX+5c6M2yKpXk3nXABQ=;
 b=Ab/iJx4JvyB5LAnJV0LxpeE08OR1zqoq4Iq3vnLrcgtxa4B/EIocZsPo7ej/OGUJzBQ3hC8HYvcUTQvDPpCild48KNx9lO7lryAYwLP0ZNRhNYbJ7/4OOdNni+29Y3I3AGLliTAYXDOwbkZ/3w5M8Yjb4BL9olYxI2wRj0VwuV1h5DZnd3xpYX5Sqor+xZtvK3/bE/4KQ/E55Lj5phKep+SmTLQn5BEu9nPvlTEhjmmrNCYueCnCB+7BhWuHwncdCnw6MB49PiBDXK31j79E4nKykjI0cZeMov+7zdRKsKVyw4fnRh/WVHdvVqsKEgltzABa4kbYeYMaxyGb9L/PdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dt+w5VayGAmzc9zZQoEhd/zSYX+5c6M2yKpXk3nXABQ=;
 b=y/MFikHdHECwzmaXjdCLcpz3Q6isxLAkR0mHpjMJh91CcpP/5u9PEKcltEJ5Ey/yR90iiqJjiEmU4swFxn0pVIo3eGvpTF5duL/mrwLSv4rhTnLzE5KO6NjkWCAQg6fkiBqghll56K+Ho3jJx0XcgidhnSMylTS7cSEJvUAeYxq5CbW/kbGyXt9Gy3jiOOx6zhgIpOannki1jrN6fAbkin+uFGIFXHTC8TWNR+0pQi/vb/23IJ+rZDpdBzB/0z6pQWme2/27Rbp6nyPSaTxa/QjXfb89xq7G5uDxh4hxvm0DYSDGlB4g1OIksnCTsk+y8RR8wDnsucQblC3JBaJ05w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by PRAPR10MB5324.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:299::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Fri, 4 Nov
 2022 15:32:52 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::5d9b:b9d1:bd69:107b]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::5d9b:b9d1:bd69:107b%3]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 15:32:52 +0000
Message-ID: <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
Date:   Fri, 4 Nov 2022 16:32:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [virtio-dev] Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
Content-Language: en-US
To:     Harald Mommer <hmo@opensynergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
 <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::13) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|PRAPR10MB5324:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d476306-fa4b-4fe5-d2f7-08dabe79d63f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6k6jaIVNAuaD9bdoIPgaqiUPyQQxfGEG/nwCEkfgRvwjsmUv9GEWdfvRXE/HlLgVQM2sxcLDsLvU/9ekBwCDYAxFOjdMv5IOLaT4KgKNjpXrVen7kiiAh9O8rMrkzNL/iTc995c6w+szuQwH4hTicFrS6bX5pWxOV7jVkzB0ix4F05C4YefwCazAdr2tExSPF7kVNpKLeiFQo93VyIUSdaYd/N7t6Ghf06kUGcdRo0DfoLDImcO2PaVgu8X8WEk2STHO77wrp4sQxhkk+mXvnnaxLXbSJWo70tV0DiNijWv5Vhy6mebEQzbn0arnYYaAmhfHdvOxC8A5pTYXrtXLzuyvC8iBsADm7xxLYRmh7cK/+DJo9oBR0HPVwBIuiRyxPf2noPr8VlLvJDF3ToAIPJScQp98BXko+34567RMNZOJ8ljJk9nrRfskMKrXtJscCXA0JTc3irwbwc3rFiGogQDTumag3anO0aQ+e1p8GGIMeY0VkEkyBE97kyY3RDjWipqurctUKNZILUNAwbtY8b9ACY816phF3MPD4aIvSDBGXHH3KOCyMSop/Yitj34KiJetDjnxCxRp9rxIP8CPKMUVFUziqksuSSqTmpS5U6gEKv3SKjaefmlJ2N+F3/1E2l9TaCMmek4DbSGAk39AePCwq1irTx/7vg4M4Mj3yDHQJwbW+heUXXrEREZik28K1/OniqN9nUN3mNQZ6+wjo4FqM0p96ho8hQwK2k7EKwLB7skcI8CQwp99ay6k8VwH03XyqdN9lgYkAv2r9VEWuUe61/z07vxKO5PBhM9uF4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(83380400001)(2616005)(26005)(53546011)(110136005)(6506007)(6666004)(316002)(6486002)(82960400001)(186003)(6512007)(54906003)(38100700002)(8936002)(7416002)(4744005)(8676002)(31686004)(66556008)(66476007)(44832011)(4326008)(41300700001)(2906002)(478600001)(5660300002)(36756003)(66946007)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1BBK0tFNWJySlV4YnE5cjVEbEtLMlB3b09sRzkyT2lUNkIzRjZYM01MMnpO?=
 =?utf-8?B?czBFWVo1YUN4c0ZvZGhYVFpBeVd0Vm9ldkRObXhyU2cvUVBqRUt6U3l5bGZ4?=
 =?utf-8?B?M09jRjgrZy9icm9nenpoRk5KeWdpaVNCZ3BDQ1VhNUM1RW4wN2QwSUwwdG9V?=
 =?utf-8?B?YTdUOTlxVHlwbmVJRzkwSnBuVnl6cm93THlXZU5nU01pTmVTZlRKTGhIN1dy?=
 =?utf-8?B?T3pLaHY5WlV3M2pqYWo3bG5KdCthaW5vbkE0VC9yWUl5ZmNpQ3FTbVNPdEdz?=
 =?utf-8?B?NGtVOVpnT1QwZlVYTzNLdEtNS3BVMzd4VHZqOVVNcURuMjdOMEpCMWJJWGUv?=
 =?utf-8?B?dG9lekZtQkRlTlVJQk04azB0MHhEZGh1cnh3eWloWHhNbS9Rbmc4YlpLakxP?=
 =?utf-8?B?VTFCWTBFdUlTT2F6UE9sT2FOOTBwMWxhQXF5N2hsS0FZMklVelV4UEVUdjZP?=
 =?utf-8?B?THNEbjZrZmlGVzYyNTJXSG0yQjR6ZDNpVWdwK3ltWUFWdStCbVVRSnovKzRV?=
 =?utf-8?B?SGhkUkVwY2VnZ0RRb2pmZ2hsemczSnZyVXl6TDlFVDU3WTdqL1BRdzB5K0U2?=
 =?utf-8?B?U2lmZW5KcGM1elZJWHMzR3FTOFVhN3czTERhNXdmV2N3MWdIc2Q2bEhXRko2?=
 =?utf-8?B?Z2R4NHV1ZzFxMS9TL1hZSVplYlFaV2pNTHVGV0RpdER4QnBJbldJdi8yT2t4?=
 =?utf-8?B?ZU9KOGtKVFY5bXkrSWlvOU84ajcyTmdKZzN0eE5WaHdOQ1dWTUpDOWc1TWZR?=
 =?utf-8?B?K2d4bjZoT20zRGdpSGRpclVxVlUxL2grclpJTW5ncmNaSVRJME9pZXh5ckoy?=
 =?utf-8?B?VTMvb2llWTBabDBVZjc5MDcyRWpLRWVhSFZKdFJOd2o1QnhTMC9qSGlKZXZl?=
 =?utf-8?B?WnVZMm81dFZhRVpzQ05pNDhHazd1T0RQRzdmNlA4NkNGUWYxaUxabHZTNDRS?=
 =?utf-8?B?bjNzVWp0OFQ4Q3FZTDVRSVFPdUVjUEdQdks3ZkxBY05WZGkzRWNLQ3JiKy8x?=
 =?utf-8?B?WlRCUDAyT1hVUHJJZHRzcktudGtaYmRWUHRnbU41c0NwaDJHVWxaQ3luTW0v?=
 =?utf-8?B?c0gvck1qd21USXNnVElOMmNoOXBYbVNteUtTRVZDMzUrVEE4dzFROGJUQnJR?=
 =?utf-8?B?WEFwYUxONWt1SitJaXhmYzZBWXYraGhqN2VKZU5SUExIenFiaEY1QmRxdFYw?=
 =?utf-8?B?bnhhWGc5WDBUWEpTT0o5Q1pKK3RkMGRRVTRCTXBJdzVQZFByc2tPOVV2VERi?=
 =?utf-8?B?Z2RMTHNENm92c00xNk5mNUhWa251anRKblA3aTdFRnBJeFNocjM1QmIxK1FO?=
 =?utf-8?B?ZGlLSVRHTUxIUjNEZUh3RVp4eTU0UW15ZWwyNVovMEZlWXlYbTl2ZzE4YWtX?=
 =?utf-8?B?YnN4d0krZ3V6TVhiSlprZDF4c05zSy94d3hGa0VJNGJkeEc1QWdGbUxpb0tt?=
 =?utf-8?B?bFVpRzk2M3h1TmlldHI5UmlkTGtnemwrSXBuM2ExYjB2UzhaODJvVGxIKzI3?=
 =?utf-8?B?d2pOYjQ0cTZndzdCZlBNOW42ZEllbkxOQzE1QnJhYzRSUzB2N3A0TjZMWVI4?=
 =?utf-8?B?MkVTMk5EU0NYbXIrY2tTL3o2YlhpQVVpTmxaRW1WVi9HdnkxcWhXR1g1WG9K?=
 =?utf-8?B?aHU4dnlhREUyT3lvbUwvb3NvblNrbkptVHlLRzlZdHREK2VxcTVGVm85bkVL?=
 =?utf-8?B?V25hV0I0dFAzNG45R3FLR2l1aDRKT2l6RU4wVWVmNytNa3JuUUNjN2FYOHU1?=
 =?utf-8?B?YzNjaGdrVVduOTJGaEcwbmh3aGd5VDFWUEl2VENvRXVRZkNYNjVFdS9Qdmt3?=
 =?utf-8?B?Uy9GdHkyUmFCaTRNU0hOWGdRMW9lNG90cWhONFhJVHQvcFZMZkVIcmx3WERT?=
 =?utf-8?B?MEkvK1BTRjBTSHRXMlpkcVcvSWhnSjIwUU9Cd0Y5Q2JCVFNrOHl5VmVIYWlp?=
 =?utf-8?B?L1hzdkZsS0srZUFiYnFaMjVob253alQ2cW9jVWhUSklqZkowZys2ZUY5dUNt?=
 =?utf-8?B?eUpRQU9lVnl5SDE5U1c1UjQzQ211aWwzQ1RBYm9DeGNqREl2ZXFxZ0RzZE42?=
 =?utf-8?B?RXdTY2hldFBxK010YzA2SUpSVkJhd1lTaU00N3hlcHg0bzhUWThDWDZJNUgv?=
 =?utf-8?B?UlBCRWFoU1ZpcHRaTjRyaUN2TjN6RWN3R0N5K2FlYzBqSWVmSUFobjNjQUdi?=
 =?utf-8?B?Smc9PQ==?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d476306-fa4b-4fe5-d2f7-08dabe79d63f
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 15:32:52.2111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxxGJEslQOze+Y7fhF1fRhbK9ZadxfWW6gAoQTo7MC5uDkXSSpg3gUQ4ux3xYbe8TMlQqgHMk5bNhj9AdLIecA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PRAPR10MB5324
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.11.22 14:55, Harald Mommer wrote:
> Hello,
> 
> On 27.08.22 11:39, Marc Kleine-Budde wrote:
>> Is there an Open Source implementation of the host side of this
>> interface?
> there is neither an open source device nor is it currently planned. The
> device I'm developing is closed source.

Likely not helpful long-term /wrt kernel QA - how should kernelci or
others even have a chance to test the driver? Keep in mind that you are
not proposing a specific driver for an Opensynergy hypervisor, rather
for the open and vendor-agnostic virtio spec.

But QEMU already supports both CAN and virtio, thus should be relatively
easy to augment with this new device.

Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux

