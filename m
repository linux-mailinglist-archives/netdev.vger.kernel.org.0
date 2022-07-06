Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C31C567F8F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiGFHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGFHIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:08:17 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E610D5A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:08:15 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2664h7TR010059;
        Wed, 6 Jul 2022 09:07:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=qrsqWpP6IgGml2vBxg4fztkz2QMgY1QVrtu7TNvPjog=;
 b=bX5kSmdMv/Cipxp0Sl23BuVpeqk2Sesht9spsjFx0wuG0Pi+kghN1NDyrRtner8j5T13
 PpGCNTx47aHpI2WZphHwaftu2QNAHw13UJVXo+2bcOyNzfifMWIXFav5CXEgp5caMUrX
 /9nbdezpPZijuk5XS2CyJqHEz3Q8VBeFvcrQscgqxsOhommWHFR4vpGrttHefdM6qSwp
 8CogIevA1JKQ9Y2H1cVVPMq2razFPGsu55mzwuM6r8JXV7Kts3R0ZR3ic07+vNL4EZJM
 q/iyKdHScPaq0qdiEhiZ2S1RYTjDkcvO6sfjf4EmLQgNCgVocsMqaAfh7V3ZBeb+leTj aQ== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h4uc00f5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 09:07:41 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Wed, 6 Jul 2022 09:07:41 +0200
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (104.47.17.106)
 by EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 09:07:41 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtPWXT74Mqg/jel5d9unuxDCn41iuXmgPSJ/jV+lLND6WRihna5lpSpaWE9OxPpVk8P3aL8wvJDupJG/rSO1ElG45gP0uK3dJSwBropP2pSOcBxkP1CwmKBWxvpOFphi9EgNZYsxaMCWu8DQFFjv4BwKJcymtixm0lZfJgGGlCIDy1V842gd1Pq25UbRrFhoiC7KQ+4u+wyszK1dBsri4cOnMVdgWrBOezoIG/+LV3AL5/JvOy59tNy5crPQU9Oc2kjKKQ6IWodx1ommbE5zpidiOtMwaJMxaiY4ogy+rmjZNpZ3cQSJRSFIyzgtu19X3nH4BeaHk3yLBA1lM7+KHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrsqWpP6IgGml2vBxg4fztkz2QMgY1QVrtu7TNvPjog=;
 b=Qw6fQSYuNXCHIgEOHryHHPkejUuWORtZgxhcxM3RusZ0b317+1lKrGbwjnEeXlF6NvaWbRY/2QLYTe7uKl1W0zm5jS027CQsdAlHTJhZB3w24LSXMKslYqtREL6u7qcWiayrV1rIkGe0ynylObJQyzf5Tfasp2FVWBmBy05ue78xEzWQQ8o0TcjRJDBP43+v8YPd1Z5cXKiJ3tiUBaPV+MUV80KEx/1dLM6zMx38nHjwbZgtz/4vgLhHOvUGzs6q7kyZs7gfSMPNwGbLBqXQQ1Et7Pcmhc7wCHRl6Vslmt4Qy69IJmgjva4ihn8uHGINGGvHmM1k8mDGdXM4AkujcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrsqWpP6IgGml2vBxg4fztkz2QMgY1QVrtu7TNvPjog=;
 b=06UXUUQMD+RpVP8J3+ZSUL43RNejDjlDpVAmUyM1iDrhbXsMstZK2mRejnmXeRhdmvdjhnSfcxTBLd7Ju7PKyGJ7lUdkUZELDUw+qcfxtvRfB0LbyPfUPSTQj6lmA7W4YX49G64+jNOHpzLi+F2dT6M6LuI8ZsYAajEeqQBbErI=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by VI1P192MB0192.EURP192.PROD.OUTLOOK.COM (2603:10a6:800:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 07:07:40 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%6]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 07:07:39 +0000
Message-ID: <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
Date:   Wed, 6 Jul 2022 09:07:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
From:   Matthias May <matthias.may@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
In-Reply-To: <20220705182512.309f205e@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------a3KGrB50HcnX3Lbeor0oDMi5"
X-ClientProxiedBy: GV3P280CA0006.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:b::6)
 To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde82252-68eb-4f3c-4086-08da5f1e369d
X-MS-TrafficTypeDiagnostic: VI1P192MB0192:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbwXsB8XbuXxv4Pm7hsvSiR5GToxKY9loHJvpIF5sAG5OGY5YjrPM/3i7PWK9YhPVAw/V4Q4WtBbeoCGXgQt3HCCO9QnapaCAhAreexqrdKSKgRH/XWie3dU03qGBOuX9+avGE1a6EwZxUl3W0F9EsB1rYBUsalW6CNw+BqsQw/aVG/ru5a2xsOPzBgPxOtCy0eg/h30+VuSCNYHIhONYUYKdfMpS6YagyXi/6vpdqvd4NWtgXIPD/yQleCV4ick8mlSMmS4v/pkhYrD+UXn4Lm29os7HIe1M4Yx1+5kNRSG7MRw4Ov8Mnk514kD1RVW1MRM/WyoehWvFhJxcANgz8kTbJ9fEzI2S/opCYKRERLL3O9UPXPomB3A/wssWHefVyeGWHagTF9DO0/c+eoIN4EeIcZNC2SpYMii3snslJESDqrd6f7gVPWkpywNTJvOfaEE5TVsRlchvmWcSA0hsiqtQS6DwUP6K42xENbpLpReY2toxVvf7xWsRA92kKB7yjKalC129mwRRCrMSoBcgiB2EHVnlOwJRLaWsQUi6T6d9vM7krpTSL+PFWHtqRlCPmqoxoFqoZxVLzW6TXQakoZXUFL8DcxlqAHquQDVh2MHFUoBja4gtJr36nRHUnp37hJt6+Kwvdp4LbcxXT30u+Zmyq+edbRxpoFmdZ+jKyrNoHt22OSMOLWHNpQsi+npwW2sAIuRb0G3xq4YdPxzYvx9vZNJdyQP4xJGKbfgA48r85dQVUOgzUq1V668OdasMjH3M6roOnkMAGuV/7jwFASsOeQD6WHBGZSiujQ2Ky+gEwi484hzpIXHzN6pmLNDOhL0dpbWfhmBcC0FfGECV2slZWKzNCN7SkwJNEk/LTfXgql2dD9DvvQ1g5znYqDD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(39850400004)(136003)(36756003)(4326008)(5660300002)(41300700001)(235185007)(8676002)(31686004)(44832011)(66556008)(66476007)(66946007)(6666004)(316002)(2906002)(6916009)(6486002)(478600001)(38350700002)(38100700002)(83380400001)(33964004)(6506007)(52116002)(53546011)(31696002)(26005)(6512007)(86362001)(186003)(8936002)(21480400003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEp3WHl6dEErN3E5eDA2aUVtV2hWOUp1OTRxdTRMMk5LelB2WHVjeU9XR2oy?=
 =?utf-8?B?TytGVHlyU1BEMy9NRWt4Vms4YlV5aGJqTWpWaEJqbENIWkp0WjM4anBoUjZl?=
 =?utf-8?B?dGZ2Wk1NUzQ4dmlZcTliYll6WEw4dU9ucU9YclRYUlR6VUZnRHhLMG90dVFI?=
 =?utf-8?B?a0VqaWJYOFBGZGlEdTJvU3Q2cXlFNkpIVUI1b09lNVdoSHN0UitOMDhEdW9F?=
 =?utf-8?B?MmVmTjQrN2JkSll2SStPdHhIMVlBYjQxVlFoVEFOeEZRbW5UTmVnTmVTUE1R?=
 =?utf-8?B?dkxPYnNWTlZIbzk5SmpiaTFJK2R2a2c4dHYrVnhlbHBLMmdhVVJGRzdpWmt3?=
 =?utf-8?B?aUJEV1AzRGZXLzMydFp4QVJxcDlubVozTlExMnkwUFFyK3lZcmdDbG1QTWc0?=
 =?utf-8?B?eTZtWDNwM01TMkcrWWtRZkJ2SkNMWlAvNGZHZXN3blhqNkpSRW5qTlZySUxa?=
 =?utf-8?B?ZFpndTQzN1d1dHJ1NXp5MHBwMllWOWovNitFZitPWXdQdGJVN25tMVJkUUcx?=
 =?utf-8?B?eXhIbHJ3MGJVQURObGZnelM5ZE1qSTlxdk1DM29HeFpyMHB4SGFpdnp6WVBC?=
 =?utf-8?B?L3BqVzdKdS95OHlmcUNoVnJzUnFzRkg2eCt6L3hiNnhJSXFtS0IvUUNkQW8y?=
 =?utf-8?B?V0pSSzJwbHhWY3h3Y0YybkRBeCt2V1NNbHdIbXEwWjBlVm51anVRVU1PMXY2?=
 =?utf-8?B?NzJKVms3ajVZZlR2TE9Cdm1XM1VhK2FqRXM4T1lJSGViWTk1NnBPRExiZEZy?=
 =?utf-8?B?bS9VTm91U1BlUVRiNjNQWWMwQkhmZzFTS1Z5cnU5dDJFUkRtTWtLTE44cCtq?=
 =?utf-8?B?WE16NE95VTN3MTZwVDRrS3ZsTndNMk1WaGlZZFNJNlpjSkdzL0hwaHVVTWVl?=
 =?utf-8?B?V0hNRDFrQWprby9aZEFUUGwwQ08zT0xWc1QvdHRGMitQVyswVnNTUk1yWDQr?=
 =?utf-8?B?bkcxREI0L09hRXJYZDdZdFp4WmVrZXBZSVNuUXBYa1dmUWpES3lJb3lsajFz?=
 =?utf-8?B?N0NZVG5xa1B1QlN5NDFqb0ZiV2NCZTlDTittOUZZS3NXYzdkOTdlbzlGdS96?=
 =?utf-8?B?ZkNvT2NSU0lLWElTdWJnUW4yYnhEQWZDSWdDTjVOUG5vMUJIeXh5K1gyNDNz?=
 =?utf-8?B?M3NOeHlsczJZVDg2dUgxdVNveUc2N2ZDdnhEZ3BHdzJNVTR4dWlTZERJU3cr?=
 =?utf-8?B?dmNhcjNEejhLMUVpUXB1L3NQYm0vOFJnamRaeFR1U0hZMXVUb2xpRXh3VTZG?=
 =?utf-8?B?OWc4QnRBa3luRWI3YnpWUHJwUVhLdmZHdmI0NXRhMjZNZXQ5SlFNMWRrc29B?=
 =?utf-8?B?ZTI2cWYrN1JneXZaZjVFaTFQeGpwZ0hnUnlKb29NZEFER01maVJYS1JtaXVp?=
 =?utf-8?B?dk9rOVRib1dycmVmNk9OL2o1NWtzVk54UmhxSEtTSzdhMC8zamVBREJNa21Y?=
 =?utf-8?B?TnEwaUx1SjRGSlBNR1FBc1Y2bSt0UlV4d0NUWXdnbHVCWTZXOUZvTFEwTlhK?=
 =?utf-8?B?dC9sUlZ0Q1V3MnFwK3VVLytRRDBaWmxnK1NtSXljMFo3VFNDMjFweWE4NE1I?=
 =?utf-8?B?VmNVNFUxaStEUkc1ajArcWtwbE8raVJRQXpMMUU1ZjNwMHBqeEFNbjZxUS9s?=
 =?utf-8?B?bkJ1OVFpbEF6bFAvSnJNSzhHN2doSHpCcUlPUXphWnhrQXR3bWdPZjFIaE1u?=
 =?utf-8?B?SEhVZVZISUtYdWhDRjNyV3UyNTcxWTI5aDNIdjRoRVVoS1Q2L3ViMWhXODR0?=
 =?utf-8?B?SWcyVFkzaFJqY25UVHB2OHpGSVAreXU2SVRMRHlIZThrTW1xR3BmbGdIaWNm?=
 =?utf-8?B?L2h2amIxWTZDazhtZnJzSjVPVzRtWkUwOFJSOTNFRWlidGJzQWFxS2JaemJx?=
 =?utf-8?B?V3o3TnBQaUpZa240cmRjK0VXUHFXenRBaVVUZFN0dGt4alZRdVdFbWQ4Mitz?=
 =?utf-8?B?QjZEaXVoTTZOQmd4TG1NN2lRdngwT00waHRhbGhjeFA2T1V4WVVkRXc2LzNt?=
 =?utf-8?B?QTRCRkZnRHIrc3BKSk96bW5tdmVqWHpOVytZNlRPeWlFZU54M2MrdzVhZWxq?=
 =?utf-8?B?N1laR2pZbXpiUnJSTS9ZRUlrYy81YWliT1I4c0hmZm1KcUhRWUFWci9Dd3Zn?=
 =?utf-8?Q?HTvRt7SQ8Inp9s5BL78yX0SYh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fde82252-68eb-4f3c-4086-08da5f1e369d
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 07:07:39.7872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mORprjUAzcfCc8yGI8fNzBdlLst262fdhEYV+9OHFetRzLEmC3l9l8om4Fbwz8XQAeWVQKAy2+dWjH4kFv7ZGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P192MB0192
X-OrganizationHeadersPreserved: VI1P192MB0192.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: Rr2xIwEGn8bdxU6-Y6WvHN14_9GxRnAY
X-Proofpoint-ORIG-GUID: Rr2xIwEGn8bdxU6-Y6WvHN14_9GxRnAY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------a3KGrB50HcnX3Lbeor0oDMi5
Content-Type: multipart/mixed; boundary="------------k07o8eTuduK8CwKYhG9qSyJY";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com
Message-ID: <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
In-Reply-To: <20220705182512.309f205e@kernel.org>

--------------k07o8eTuduK8CwKYhG9qSyJY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpPbiAwNi8wNy8yMDIyIDAzOjI1LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gUGxlYXNl
IG1ha2Ugc3VyZSB0byBDQyBmb2xrcyBwb2ludGVkIG91dCBieSBzY3JpcHRzL2dldF9tYWlu
dGFpbmVyLnBsDQo+IA0KPiBPbiBUdWUsIDUgSnVsIDIwMjIgMTY6NTQ6NDIgKzAyMDAgTWF0
dGhpYXMgTWF5IHdyb3RlOg0KPj4gU3ViamVjdDogW1BBVENIIG5ldF0gaXBfdHVubmVsOiBh
bGxvdyB0byBpbmhlcml0IGZyb20gVkxBTiBlbmNhcHN1bGF0ZWQgSVAgZnJhbWVzDQo+IA0K
PiBuZXQtbmV4dCBtYXkgYmUgbW9yZSBhcHByb3ByaWF0ZSwgc2luY2UgdGhpcyBuZXZlciB3
b3JrZWQuDQo+IFVubGVzcyBpdCBkaWQsIGluIHdoaWNoIGNhc2Ugd2UgbmVlZCBhIEZpeGVz
IHRhZy4NCj4gDQoNCkknbSBub3QgYXdhcmUgdGhhdCB0aGlzIGV2ZXIgd29ya2VkLiBJIHRl
c3RlZCBiYWNrIHRvIDQuNC4zMDIuDQpXaWxsIHNlbmQgdjIgdG8gbmV0LW5leHQuDQoNCj4+
IFRoZSBjdXJyZW50IGNvZGUgYWxsb3dzIHRvIGluaGVyaXQgdGhlIFRPUywgVFRMLCBERiBm
cm9tIHRoZSBwYXlsb2FkDQo+PiB3aGVuIHNrYi0+cHJvdG9jb2wgaXMgRVRIX1BfSVAgb3Ig
RVRIX1BfSVBWNi4NCj4+IEhvd2V2ZXIgd2hlbiB0aGUgcGF5bG9hZCBpcyBWTEFOIGVuY2Fw
c3VsYXRlZCAoZS5nIGJlY2F1c2UgdGhlIHR1bm5lbA0KPj4gaXMgb2YgdHlwZSBHUkVUQVAp
LCB0aGVuIHRoaXMgaW5oZXJpdGluZyBkb2VzIG5vdCB3b3JrLCBiZWNhdXNlIHRoZQ0KPj4g
dmlzaWJsZSBza2ItPnByb3RvY29sIGlzIG9mIHR5cGUgRVRIX1BfODAyMVEuDQo+Pg0KPj4g
QWRkIGEgY2hlY2sgb24gRVRIX1BfODAyMVEgYW5kIHN1YnNlcXVlbnRseSBjaGVjayB0aGUg
cGF5bG9hZCBwcm90b2NvbC4NCj4gDQo+IERvIHdlIG5lZWQgdG8gY2hlY2sgZm9yIDgwMjFB
RCBhcyB3ZWxsPw0KPiANCg0KWWVhaCB0aGF0IHdvdWxkIG1ha2Ugc2Vuc2UuDQpJIGNhbiBh
ZGQgdGhlIGNoZWNrIGZvciBFVEhfUF84MDIxQUQgaW4gdjIuDQpXaWxsIGhhdmUgdG8gZmlu
ZCBzb21lIGhhcmR3YXJlIHRoYXQgaXMgQUQgY2FwYWJsZSB0byB0ZXN0Lg0KDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBNYXR0aGlhcyBNYXkgPG1hdHRoaWFzLm1heUB3ZXN0ZXJtby5jb20+DQo+
PiAtLS0NCj4+ICAgbmV0L2lwdjQvaXBfdHVubmVsLmMgfCAyMSArKysrKysrKysrKysrLS0t
LS0tLS0NCj4gDQo+IERvZXMgaXB2NiBuZWVkIHRoZSBzYW1lIHRyZWF0bWVudD8NCg0KSSBk
b24ndCB0aGluayBpIGNoYW5nZWQgYW55dGhpbmcgcmVnYXJkaW5nIHRoZSBiZWhhdmlvdXIg
Zm9yIGlwdjYNCmJ5IGFsbG93aW5nIHRvIHNraXAgZnJvbSB0aGUgb3V0ZXIgcHJvdG9jb2wg
dG8gdGhlIHBheWxvYWQgcHJvdG9jb2wuDQpUaGUgcHJldmlvdXMgY29kZSBhbHJlYWR5DQoq
IGdvdCB0aGUgVE9TIHZpYSBpcHY2X2dldF9kc2ZpZWxkLA0KKiB0aGUgVFRMIHdhcyBkZXJp
dmVkIGZyb20gdGhlIGhvcF9saW1pdCwNCiogYW5kIERGIGRvZXMgbm90IGV4aXN0IGZvciBp
cHY2IHNvIGl0IGRvZXNuJ3QgY2hlY2sgZm9yIEVUSF9QX0lQVjYuDQoNCkJSDQpNYXR0aGlh
cw0K

--------------k07o8eTuduK8CwKYhG9qSyJY--

--------------a3KGrB50HcnX3Lbeor0oDMi5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsU0uAUDAAAAAAAKCRDfdrYEUzwNvvdq
AP9Ykt23ZLppk4n0R0IoAldbHBNXdOA0FRIFuM9aYLRByAD+PjjjJyCkWkboU1Wo6i5kSI6nGSfl
IqLc0lU5VGWBHQw=
=Tsuv
-----END PGP SIGNATURE-----

--------------a3KGrB50HcnX3Lbeor0oDMi5--
