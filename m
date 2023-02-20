Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F280669C453
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 04:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBTDEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 22:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTDEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 22:04:41 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2016.outbound.protection.outlook.com [40.92.98.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E685FEB67;
        Sun, 19 Feb 2023 19:04:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz8EkCg8X4mgcQYbGSAIZd4qTfVwlu7H+Tjhewdv3bCik/F7RddWv2uan6M1nort6bNzBBV4hf7AntXh2FRcowytI9JnEYU6lKIKDKsp7RlLFj9U9ztV0mm8StLuvOzZBcI83N97nPrVFxAOjrZIxgcZ78jy/+599F8cRVqjFOP7E23MERZz2uOBUuHcLLUE8ojPHFoUV/BGDEM4Xv8yuE5n3AEq2YVCRs9oMDmycqla+ip030qOFUOrsyHJZRucHfJHj2kHhg5gViuuotI+uMcWLTgMSYVp4l1pdXLmA04sz31XdjpmZkI1sfc0ufhcSBpVRxOOgKUrg5CJdMTjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/bKKCcSisZWSwNi27LesxpnBBslmfZd+74Si+i4rZU=;
 b=QhKZ/Q49HVinlZclVuS/tJ1y2K+xDqu6E1iVD3afIwjhTEdrmeyF3OKwCU1zt5kN3gfrgzYP7rbidlFWIFqQb3ofvcuzGRJET0bTbKILHJrNQ8Qwj0PJjoQXvUP+5TQV+vBKetxlh9MKUQCyaY3hTG16g1nFsOcsxKDLoAKXaXQWpiWx1eoQmZ29ddjUM2LbZ+0hK/NHMtaWHsbvvL4BC8VtV5rr+OWaeuwpgmejLzRpBUNB2sQztx1uo+gz/yQRUfpnqdLnab1hZ4uZvb4HUi+VpnNPB5tCu74PwVDuToujBQDjh1LwhNY8oLSvPZaFuYWJXRh5ha4yBiVjKk9DmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/bKKCcSisZWSwNi27LesxpnBBslmfZd+74Si+i4rZU=;
 b=hD9Zmk10H6cISiHiJawy3PF7G1Ik7SoWMYW0e3sY0hTPvgDaQxWvLr/X4E5FIY+ORrfActE37GZJOcagSa/HzDcExRTW7T+2OU2S8ZCMX2d4Ceg6vfYK/SMKzCa2+Xp2U+V18X7Co3Kf6cPxSS004Tr54t8zLCxTLnio2pA1EmiOksoYnFYyX7pfYwGF2xvqhMv7ecEpZYak5EcyB9bgYB121lAxvPrkFvH0cqf2f09g+AoOv41bcneiBe2OUHGQj8WYp4pPneIuzGHrrl/UhQLPXEgZXIiy2UTOrpjbKu2ukOIdtdhNQp/CB035Vb7mmyFeVINiW+dMPcsM2ALbFQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYYP286MB1572.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:115::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 03:04:06 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 03:04:06 +0000
Message-ID: <OS3P286MB22957AE85FC76EAB8988745BF5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Mon, 20 Feb 2023 11:04:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y/IqJvWEJ+UNOs6i@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [Qj2vnzJfUi+3FkhR1kkeC3skHkPGFY5A]
X-ClientProxiedBy: TYCPR01CA0134.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::13) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <af3bd8c6-c00e-697a-97dc-f42bcc99778f@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYYP286MB1572:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ab9511-17d7-4f72-af4f-08db12ef20a0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZD63MBsii2W2Zu3f1u2HD+7mR9QT9+ZS7rc8XKE7uC13Of/HQx5mdJLRiRtOpMrO2CkSqyaHvSWnGxgxuGdpFBNFVFoQvyZGHFIaqbWq7xc5bwMkaJ14oca3POwdsc8/rNKtaSgjuDkgM5EXqSTPcarByg8n2VHAy97in0STtt1YXoQG1tSNkLeue9q4jvxXEavwlyzKj/v8ubRMtW7OoOh5phlijbalHyaduuG/YfBtgnMVUjVzlHa42mZhEnGbQiIn6M7dRtjZovJn98O4SHq29PLFRJV8wYE2LmTGPAykchO7yCKBjfYDJh4pB4QUbSUdbowk3mCsb6aBxT+47p81F0nj6XY+Sbp7aciINiH3x8dx4iWXTXakJuKDaHzG8r+9SMPwsx0DvLcKQTlIjzxNh4PnV0YbewjV2v9HWrgxRTrCSpFagVv2u93yMUqfMC2ftjnqXlrlbwpK4gSHzwl6eeV/CaI0qo9aeTAq2VqGFIrf/Y4BKwZJFBwUbNSxJQbNosbp/k/5H3WHjvLVH+dbKTMk8GAtVaZubF2bRNYLFvGSlByIskRPsbZ3/U5U2XQSZC3sDpdmXZYXF4kFutC2W5YF8cr2plNwoC667R0RBgJCt1mzey5PpLI5vyFBDjK7ECVTEyJJDEtwkI/02w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amZ5aHdpamFkTHBkaGJML29qanIrdktOdzJTNjMvT3BScFArVkVBYmVuMVl2?=
 =?utf-8?B?eEFaSERBSWVOTkdMNjdPbTZSMmV1cDlBNkFnQnE1ZXJHV0VHYzQyNzN6QkFx?=
 =?utf-8?B?bVpnNFROK3p2eE9NVUJYTmE0RndtMXhHMElVeUpQNno1bkRYZlRzQVlzMUJt?=
 =?utf-8?B?VjZVenVXS3ZpTFhNOXNpYTBhZjd5S0hqUWZ5UjU3cEhWREJlWUpwazBiYWVx?=
 =?utf-8?B?L3VkYVR3VTh0WDBDTER4Q1lNcFlZb3MreHB1b0syd016dGJoeE5MUG5qWVU2?=
 =?utf-8?B?OVkrN1hyNjVhSE15VkNsTDh4ekZlUWJpdUJXTzFJVGo0SHBkbUFwVWQ3REVz?=
 =?utf-8?B?OXFyblZ5Z01VN0Z3SlZDVXMvR2RIZmpWRVB4S3ltN1dFNUlJbUwzK0NiTmZj?=
 =?utf-8?B?NDZPNk5KWXRwVFlzMSsxWjM1cDBOa3dpQU1IMis5ZmlTVm1CUEJFMXc0bGdL?=
 =?utf-8?B?K2VYdTE2VzgvNVJPWHJSQ3lUU1JMOG9Hc1JWcm8yb1RmRUt0UUd5Z2laRHFB?=
 =?utf-8?B?MSt6cXZwUlU0MkF6djVtQ0w4ZTI1YUFxaUd4aC8vSE5qU3Q1Y1ZTSTh4clBa?=
 =?utf-8?B?a3BjRmx4U2g0YzVDbmFBZDYxczl0amU4YUV0SnY4ckg4YVBuT055b2h2YWNq?=
 =?utf-8?B?b3lKMFRMdHkwbGJNb3o1c25nUXFSQTVrNHlMSVdvSXVlMFhYMWZ1Z1o2RHkz?=
 =?utf-8?B?Wjg5NXE4eDU4eTYwVjN1SWdEU3BjZStqdTJpRnJLa1FacE15em1lbVYvanpj?=
 =?utf-8?B?TUhYV0dLRTJoVUI2UDZMa0ExRmxiOU9mbWZPdFVGdmphU1dFdWEyRUVsbjBt?=
 =?utf-8?B?eXU3MUN2YzJVNGxXbDBSRDZndUliTkxaeXY3RnhVNkZCbDZjdkcrRHVvcjhV?=
 =?utf-8?B?WlcwV2JKYVlBNXJVZEF1NDh6RnlwMXlmYUVNS2pSQXNqbkNQVnhBaG1xY29S?=
 =?utf-8?B?RlB1RWpNdmo1RGFXQTN2SFNFWTV3T08rMDJueVVUT290MmFqWmlhYUhhalVW?=
 =?utf-8?B?YXh6UUhTR2RYT1pUdVJzUGVUbnAzcUwxb3llbGlLdSt3QitnU3pVTU9YWEF6?=
 =?utf-8?B?UTR1SlpNTzhPcTVIeGorSXhEVzVhZU9Yd2lZQ2tLZFMzY1N1TVRwVzFZaHlL?=
 =?utf-8?B?dXpPcjVINGx0dndWVU9nNVVibnh1RitIK2FMdHUvTHJCb2hMUTZtc3dRdlo3?=
 =?utf-8?B?VDJBdk4yeTgwUFZGOWZqaEMzWGZ3aFlMUjNDR2h0eFdkRlBTNkxnUzZzR0hj?=
 =?utf-8?B?UHZERzZvYUU0c2NteExSSVlNY0IzM09IelJkOXlqZVZaQTlIazFqK20zMFJs?=
 =?utf-8?B?bmE2aDQwVEpia0VCOW5LbjQ3UEdyeEx2emRLbXp1V3d2bm85RDRnUnJnNWZ6?=
 =?utf-8?B?d24xcUxGZGliUWI4T0h3VHBJNTR5NjROYkJYUmI4MjNualpxZUQvcE1EdVpr?=
 =?utf-8?B?MnhzMGw2V0VtZ3l0bysrVnJseXgrSTZUZHFSUTYvRlRyMnhnU3ZHK1RLRysy?=
 =?utf-8?B?dFBSNE1yNUdLUjY3ZUVWQUFWeUpidThaTmZKT0lSRStiNUV6RG4vTW9PZ2Rm?=
 =?utf-8?B?VU44NUFBWGJHZDY3eVlmSkVUSmJpUkNiS0Mxd0xRM2JMNlRnQzZMb1haTmdW?=
 =?utf-8?B?d2tLeXc0ZTMraU52Y0JHQnhSSmIzL1pFbFBENVFCampucm5PdndKYXZiNm9Q?=
 =?utf-8?B?MHJVZ3ZUSnZ0bjFuUFJIenZqNnR4eXd4bzhzLzVEN05qRXd0UnNxUVhRPT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ab9511-17d7-4f72-af4f-08db12ef20a0
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 03:04:06.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP286MB1572
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi， Simon:

     To have better visibility of the effect of the patch, i did another 
test below

Disabling data-path flow installation to steer traffic to slow path 
only, thus I can observe the performance on slow path, where 
ovs_packet_cmd_execute is extensively used


Testing topology

             |-----|
       nic1--|     |--nic1
       nic2--|     |--nic2
VM1(16cpus) | ovs |   VM2(16 cpus)
       nic3--|     |--nic3
       nic4--|     |--nic4
             |-----|
2 netperf client threads on each vnic

netperf -H $peer -p $((port+$i)) -t TCP_STREAM  -l 60
netperf -H $peer -p $((port+$i)) -t TCP_RR  -l 60 -- -R 1 -r 120,240
netperf -H $peer -p $((port+$i)) -t TCP_CRR -l 60 -- -R 1 -r 120,240

   Mode Iterations   Variance    Average

TCP_STREAM     10      %3.83       1433 ==> before the change
TCP_STREAM     10      %3.39       1504 ==> after  the change

TCP_RR         10      %2.35      45145 ==> before the change
TCP_RR         10      %1.06      47250 ==> after  the change

TCP_CRR        10      %0.54      11310 ==> before the change
TCP_CRR        10      %2.64      12741 ==> after  the change


Considering the size and simplicity of the patch, i would say the 
performance benefit is decent.

Thanks

eddy


