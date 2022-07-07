Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DACA56A4BE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiGGOAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbiGGN74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:59:56 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3B2D1FF
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:59:52 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267AiBYc019589;
        Thu, 7 Jul 2022 15:59:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=IzBN/UZx1EzCDQT8MaVS311kAeQB6jL5xd8x3h8fpk8=;
 b=24UZ9SD7+Y4sd4r3zOccasrmtQTHSIT+Lc2Jsb2UsthsA4P50VujXrUdaQwOyjwE/9jP
 CgMUcWe1O5L2ttQXgfqwsY7qpqzu76QiLUwc425VgIjM6dIz9FHN2R8anH6ALgBNNmKD
 UHRnxBkTF6NUxnM+KmCJo41JnVHPT8fEqywOimJTxc34ln2k4k4xdnWbcxkvPwc/8KCX
 sbYU1nSgNMkhKT9wZ6lDjGZGQQQ5tF7SQqzIlOP1gRuApdKQsAjw16/GCHcx0rjDG5vC
 mZMp1vhh2Cg46PhSIN0LqmEw1GdWkdyfjWoyTApX3YDbzSYGncB1a2OcYygiqENaFV3p Uw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h4uc01ycm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 15:59:15 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 7 Jul 2022 15:59:14 +0200
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (104.47.2.56) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Thu, 7 Jul 2022 15:59:14 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8ujc1z+QhpxIuCEnerPUZApobYgVeq9OKLjN5uz7WxGvj3MCWmL3YGuDLAUNNAS88+TfuQmVjhDNxle2E8E60rOuMnixVaYE4SdOxSBAn5ytdG5WvGrEQ385e0gcpwcodAVkyC27x0AvZKbuzIABnfU/1coAaa+BSBMkqCRkh2hPFRGX20oBG5Fx6Hn+0Q+xXsd9HTC4suBl07yh4qabsnB3RKJeCq4VoBi6EprndjoeuqnVB+X1qn4RBHWVcKz4Hap3jKJbAwze/V9JAsFUxlCiiik95e+tmSg3ykhoYElYzwhTVRvGsphzb4wTYgN/sKPgzUchn+kkzgv0vhxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzBN/UZx1EzCDQT8MaVS311kAeQB6jL5xd8x3h8fpk8=;
 b=QysWTBlIpArPJt/mUeICQrLSCW6/m93wvv+xNpxGj8r/grV1mV8zf+ibR80qNNTCg/pQm9SxJsKv28pJLaNVA12Kh4uCoy5yFZQY5qKbWyGCNQl4gdGugjakrknGdSWI7PLE3gneZngpFBpZqy+lb4vKIciBK5zgP6w5IflshEFXa3CuSnRqxpgL3RC/fMS8T19Pgq8eJeXX7hWZHlK3OFy8mFXtNJATvaH+hZRn9JRiUmwnTrNTmFw4jXVVloblk2Sg7IYCQyEm6z6i843WsmyqiXggI8C0ChaczO3J6qVCLra6UQHIhLLLyji526JsGtZpfWRaCF9hOENje2I/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzBN/UZx1EzCDQT8MaVS311kAeQB6jL5xd8x3h8fpk8=;
 b=uqhcu+4fcJPnF8MGWUYPd7l/8SIycEZe11CF8hJM/XyoYPW3fyxCb9JhfWHE65vWhhaG96Pwo0uh0meb9BU3MVMyRFJ4E+McbYvChOs/J2rct1rHqyWLaPlMe5a0wMFSCO8p3GUeB5P40USpTlAsZ6z4mJg7KZMT5mrzE/Eyvmk=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DB8P192MB0805.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:149::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Thu, 7 Jul
 2022 13:59:13 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%6]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 13:59:13 +0000
Message-ID: <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
Date:   Thu, 7 Jul 2022 15:59:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
From:   Matthias May <matthias.may@westermo.com>
Autocrypt: addr=matthias.may@westermo.com; keydata=
 xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSgRcI4rgLN
 KE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7ClgQTFggAPhYhBHfj
 Ao2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJCAcCBhUKCQgLAgQWAgMBAh4B
 AheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaIOmnxP9FimzEpsHorYNQfe8fp4cjPAP9v
 Ccg5Qd3odmd0orodCB6qXqLwOHexh+N60F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CU
 u0gESJr6GFA6GopcHFxtL/WH7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv
 7h0n/d92tgRTPA2+BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOI
 PWGsf80E9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh CA==
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
In-Reply-To: <20220706131735.4d9f4562@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------RJWErPySSSns46rIakgMiJCo"
X-ClientProxiedBy: GV3P280CA0042.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::34) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95a94630-b779-4f99-9f2e-08da6020df7e
X-MS-TrafficTypeDiagnostic: DB8P192MB0805:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PfFh1NHhrDRDD5yct4hgCLPlwvFt0/MEzjQbm/5syczAXk2BiOeOqEQipuXz5ja/j7Cn+vz2WUf5zh2jWI5Gn9zEW/Dt19raLMUmFcYzk3E9l2hI8HIym+Rm1iok8WnntDJsHcWOBWuaWeiTOJFDkrP7xeW9miMyZAACN8hFobQS0LiSD4d+y5wFdjKxChGj3wmTf6aYvUDD/mjD+rQoYUB0Du1xc9U8oN+lfgzqT8MneDUAzdUzGg/0FKDZi3uLlp208Mrc/Q5bZRWREqNfmXrJPUBiNs7qgUgAX4LNBOvKe4G4178FpNGmd6XmXteqBu5WeVN+B/W2aHlfgD1MAOep+13Eu8HFtNX8/ejIrzkqurZDXmlfDg6TI3vXBOGnO+hNrokHvKToidrBVmyqjk0fOWW3tNbJ+rwlH7cMSfP3IqKFHl76roKSPXPtC0Cd8old+1333V2r4nj306FAHdUR+oU2rYrJ9EKftA0QV5IuKQXGGyQKL4xDCoK1msjLqTZ1POgGtkkb4C8IheAiNsxQ7+T8y0ds5xlFq5yOu9jvOq+ZK+72tXH8HFqvfULbkUD51R9TFqyu1jX1P5p2C1iESwRczQ7wnNuxFtDmcT53lTjd1jM3ob7Eb3n5k2+VlcQW1P/TaDlj/Rr8LwEybzxOZpEyrqkOst82gQd0UCGSL80aexSg2AmxBVHPgIQGinPGljZFjZJcLLzinD5asz0a596cLxizFb5Nna/LcSNs0FeICizwGnANcccnEOkMa7qZm+0rAlpLZ/U0HEQoODIpclNuJBym2FjX2KkREOPVntW5uR2S0gsBdomWenWSIrOUGV4Cc5EwkKu4Yq1LxZ0zLDQxAFB3Msnu/h6df5Xtk2hXNPvP5aSvPSw1oK6j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(376002)(366004)(136003)(396003)(346002)(38350700002)(38100700002)(478600001)(6486002)(2616005)(4326008)(186003)(2906002)(31686004)(41300700001)(66556008)(33964004)(53546011)(52116002)(36756003)(6506007)(6916009)(31696002)(235185007)(21480400003)(8936002)(5660300002)(8676002)(26005)(86362001)(316002)(44832011)(66946007)(83380400001)(66476007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3pOaWgybzZaSG9DRUs5QiswRFRrZ2NMTkljY1pIYWNDREUxTmFwMVJQc2dn?=
 =?utf-8?B?WTczVDhnYzMzTStXUFVmbE9NQXhhRlZ2TFh1WlFFTDRYTnF1OGp0V3hqWDhh?=
 =?utf-8?B?a1pVMHBydUlLYUgzdkxNUmVWYkxvMmwxcC9aVjFYTTZYOS90YzRxTmVwemNm?=
 =?utf-8?B?M1Q1d1hueEIxWjlsZlIyUUV0Myt0TnFnSmx0RGFIS05Rc3l5WHdsb2tzVGN5?=
 =?utf-8?B?bUJCRTErWkFQc0JKdzUza1NTUjhwTDZnejZHK0lkbnQ4NFdoZDNDU0lWRDdF?=
 =?utf-8?B?MWczcVR6enF3cE13TUtnQkY3TTRCdHJKMGg1cWw5UUF4T0J0MWlOSUsvYnhG?=
 =?utf-8?B?UE9VektIQnZHVlJ2cXprRlpuMnQ1RmVtRUtwRW0yOWJjZVB6Zm10cUE0dTdJ?=
 =?utf-8?B?R2FSL21NZkV3VlNreElkZjV5ckFGSlhSeXZIVjFoYjJCbGdQQmc1TzIzdkpU?=
 =?utf-8?B?SjM2TzV0T3dVQ25pbmpXbDJnRm5WTks2bXJzMFBuYjVrZUp5eFFheGZhVmpl?=
 =?utf-8?B?T2NvNDgySStycDVPN1h0K29RVnJDMEFnM1cyZ1c3NjZxRTF4ZEJiQ2U2YlBw?=
 =?utf-8?B?VmtaeVFwdWp1M1loWmpJSHc0Ny9QYTZaaVNXTjBINzZCSFkrNUFWMkxSUWZW?=
 =?utf-8?B?b09zUldlUlpsbVZsdWJPV2FxZUpCblJDd0N5VDZla280OVR2VDdqK0tMc0FY?=
 =?utf-8?B?M1o3ZW4zR3RXU3NOU3ZKcXBSa1JieVY0YXo4TWNvS1NZTG1sTTFCQ3VmK0wz?=
 =?utf-8?B?cEpYcCtuK3BjODZZSGowOHpRbG00azJ2UDRCckpTT2JaTTNjTmswTjhZemFw?=
 =?utf-8?B?QmhJTTlmSTRkTEp3dDZpK2szNDlPV1g5RUJNNzQ0MnRuWVE0V1IvMDhVK0p1?=
 =?utf-8?B?WldaVmFiUnVnc0ZISWFoS2IvQW1yYTd4RVlBME9lU2xTK1AzbjhWQ3JTT2Rp?=
 =?utf-8?B?R3ZsdjY3ckxQOEdtcU9pMEhzZTU5ZnViV1J3REdFWmJqdHdmb2h1cWZveE5P?=
 =?utf-8?B?SVg1RjNlVWVxM1k5SVVRYXhiSFdTc2Z2S0F6OEhGWjBiWG5EekhUL3ZPRUsy?=
 =?utf-8?B?SHhjOVdEb043ZXo4Vmw2cjM4UjFTYVlUWUlmcWowWUJZbVhPcmM5Z1B0amZL?=
 =?utf-8?B?YjFxZG9XZjBrTmxRZ3l3ZGhEZGU5dmpIZ1d4dEJHNmlETWM5OGs1RXRhbFVa?=
 =?utf-8?B?Z1ZuVTNwczRybU9oK3FDcll4UlN3dGxwUGc2YTYrV3NXaWhuQ3B2NzZZNzVn?=
 =?utf-8?B?c0hOOXZDeWwvSU5QSCtEZi94RlV0MjY4NW8wVTRLZjNiYkxsWUdpWXV6blVN?=
 =?utf-8?B?OUU0WUVIR05peGZLUFFTODlFa2IySDAvTTYwaGhXcy95MDdwMFZsdUIxSzFK?=
 =?utf-8?B?eGpia3F1Q2hjWk5aVU1hSnl4amI0K2txejRSRjhVckp6K1ZIV0dZWFlVTVJ1?=
 =?utf-8?B?TlRlSU1wOWd2SGVoNWp3OVFkcFRxV1hHSk9ic0ZNYWZWNDFXTDBpdXUrL2hi?=
 =?utf-8?B?NlNzUzZDZ2JOQjNXeUlsT3R3bWI4eFdrdEJWUm9qM01wWHh5c1pNbDUwb0Nv?=
 =?utf-8?B?akx0bFAySmZjcU1abUs4bVc1TFlYU1RKdkxzeFEzaUtDTVFBRW5nOGQyeGJ4?=
 =?utf-8?B?UVQwVmxVWjZDblFtLzJONG12VU96d2RPc01xVjczL2VJN2tqNFR3L0FGMFpv?=
 =?utf-8?B?Tzk1UGE1SkxtK0N5NFJhVWRIWXU2NjZJNFdxenFtY241TmljUFRyeGlrZ3dv?=
 =?utf-8?B?YzJ1R1A2SnFFWWxBaUZ5SGs3M1RiUU9uN29GR0ZUSnhCSzVxaVZ4RjhoR1g0?=
 =?utf-8?B?VHEreGEzS1FZY3FDN1EwMk51S0pCQzY0TG9jZDV1UDh2T1FjU0EyR3ZxaE1m?=
 =?utf-8?B?Q1N3RlZMc1FpNXBrdUVzWEhoVnBGU2ExeWx3dnkxQ09CdTVSazBvS1BjWUJk?=
 =?utf-8?B?VkkzRTltcUxadGVsZEcraWQ1VWk4dURKb0RMZk5QUHo5V2VvZTBtc1dxdGNr?=
 =?utf-8?B?TVJDekduMW94ZnFsMTJZRUQzSWowRFZFZ3lray9VbURaZmo1MSsyN1pHdjF6?=
 =?utf-8?B?WmlFRHM3ditvKy9lTEVVZXRGWUtlYlIxcHR5R2tNYWZFaVhhdnBWaEpuYWs5?=
 =?utf-8?Q?Ksrd3dtaSLjo+UxuG/sHz7wX2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a94630-b779-4f99-9f2e-08da6020df7e
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 13:59:13.2277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSUN11pP1nQ9/q0z0FxUqxRwiqoDjeMmxnIb+DfVIUgnkG75e+tUoM0saIxO1LbMKpXsvaBa3rSd/Kn6xES95A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P192MB0805
X-OrganizationHeadersPreserved: DB8P192MB0805.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: SvW13Xyjd5pgf5owZSCC7-qXhV6PDnAB
X-Proofpoint-ORIG-GUID: SvW13Xyjd5pgf5owZSCC7-qXhV6PDnAB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------RJWErPySSSns46rIakgMiJCo
Content-Type: multipart/mixed; boundary="------------9sdCS5II9nsgpFfVPshHqG8N";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com
Message-ID: <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
In-Reply-To: <20220706131735.4d9f4562@kernel.org>

--------------9sdCS5II9nsgpFfVPshHqG8N
Content-Type: multipart/mixed; boundary="------------HSUjFdwhHYOLl1afEHx82JmB"

--------------HSUjFdwhHYOLl1afEHx82JmB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy82LzIyIDIyOjE3LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gV2VkLCA2IEp1
bCAyMDIyIDA5OjA3OjM2ICswMjAwIE1hdHRoaWFzIE1heSB3cm90ZToNCj4+Pj4gVGhlIGN1
cnJlbnQgY29kZSBhbGxvd3MgdG8gaW5oZXJpdCB0aGUgVE9TLCBUVEwsIERGIGZyb20gdGhl
IHBheWxvYWQNCj4+Pj4gd2hlbiBza2ItPnByb3RvY29sIGlzIEVUSF9QX0lQIG9yIEVUSF9Q
X0lQVjYuDQo+Pj4+IEhvd2V2ZXIgd2hlbiB0aGUgcGF5bG9hZCBpcyBWTEFOIGVuY2Fwc3Vs
YXRlZCAoZS5nIGJlY2F1c2UgdGhlIHR1bm5lbA0KPj4+PiBpcyBvZiB0eXBlIEdSRVRBUCks
IHRoZW4gdGhpcyBpbmhlcml0aW5nIGRvZXMgbm90IHdvcmssIGJlY2F1c2UgdGhlDQo+Pj4+
IHZpc2libGUgc2tiLT5wcm90b2NvbCBpcyBvZiB0eXBlIEVUSF9QXzgwMjFRLg0KPj4+Pg0K
Pj4+PiBBZGQgYSBjaGVjayBvbiBFVEhfUF84MDIxUSBhbmQgc3Vic2VxdWVudGx5IGNoZWNr
IHRoZSBwYXlsb2FkIHByb3RvY29sLg0KPj4+DQo+Pj4gRG8gd2UgbmVlZCB0byBjaGVjayBm
b3IgODAyMUFEIGFzIHdlbGw/DQo+Pg0KPj4gWWVhaCB0aGF0IHdvdWxkIG1ha2Ugc2Vuc2Uu
DQo+PiBJIGNhbiBhZGQgdGhlIGNoZWNrIGZvciBFVEhfUF84MDIxQUQgaW4gdjIuDQo+PiBX
aWxsIGhhdmUgdG8gZmluZCBzb21lIGhhcmR3YXJlIHRoYXQgaXMgQUQgY2FwYWJsZSB0byB0
ZXN0Lg0KPiANCj4gV2h5IEhXLCB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gdGVzdCB3aXRoIHR3
byBMaW51eCBlbmRwb2ludHMsIG5vPw0KPiANCj4+Pj4gU2lnbmVkLW9mZi1ieTogTWF0dGhp
YXMgTWF5IDxtYXR0aGlhcy5tYXlAd2VzdGVybW8uY29tPg0KPj4+PiAtLS0NCj4+Pj4gICAg
bmV0L2lwdjQvaXBfdHVubmVsLmMgfCAyMSArKysrKysrKysrKysrLS0tLS0tLS0NCj4+Pg0K
Pj4+IERvZXMgaXB2NiBuZWVkIHRoZSBzYW1lIHRyZWF0bWVudD8NCj4+DQo+PiBJIGRvbid0
IHRoaW5rIGkgY2hhbmdlZCBhbnl0aGluZyByZWdhcmRpbmcgdGhlIGJlaGF2aW91ciBmb3Ig
aXB2Ng0KPj4gYnkgYWxsb3dpbmcgdG8gc2tpcCBmcm9tIHRoZSBvdXRlciBwcm90b2NvbCB0
byB0aGUgcGF5bG9hZCBwcm90b2NvbC4NCj4gDQo+IFNvcnJ5LCB0byBiZSBjbGVhciB3aGF0
IEkgbWVhbnQgLSB3ZSB0cnkgdG8gZW5mb3JjZSBmZWF0dXJlIHBhcml0eSBmb3INCj4gSVB2
NiB0aGVzZSBkYXlzIGluIExpbnV4LiBTbyBJIHdhcyBhc2tpbmcgaWYgaXB2NiBuZWVkcyBj
aGFuZ2VzIHRvIGJlDQo+IGFibGUgdG8gZGVhbCB3aXRoIFZMQU5zLiBJIHRoaW5rIHlvdSBn
b3QgdGhhdCBidXQganVzdCBpbiBjYXNlLg0KPiANCj4+IFRoZSBwcmV2aW91cyBjb2RlIGFs
cmVhZHkNCj4+ICogZ290IHRoZSBUT1MgdmlhIGlwdjZfZ2V0X2RzZmllbGQsDQo+PiAqIHRo
ZSBUVEwgd2FzIGRlcml2ZWQgZnJvbSB0aGUgaG9wX2xpbWl0LA0KPj4gKiBhbmQgREYgZG9l
cyBub3QgZXhpc3QgZm9yIGlwdjYgc28gaXQgZG9lc24ndCBjaGVjayBmb3IgRVRIX1BfSVBW
Ni4NCj4gDQo+IFB1cmVseSBieSBsb29raW5nIGF0IHRoZSBjb2RlIEkgdGhvdWdodCB0aGF0
IFZMQU4tZW5hYmxlZCBHUkVUQVAgZnJhbWVzDQo+IHdvdWxkIGZhbGwgaW50byBpcDZncmVf
eG1pdF9vdGhlcigpIHdoaWNoIHBhc3NlcyBkc2ZpZWxkPTAgaW50bw0KPiBfX2dyZTZfeG1p
dCgpLiBrZXktPnRvcyBvbmx5IG92ZXJyaWRlcyB0aGUgZmllbGQgZm9yICJleHRlcm5hbCIg
dHVubmVscywNCj4gbm90IG5vcm1hbCB0dW5uZWxzIHdpdGggYSBkZWRpY2F0ZWQgbmV0ZGV2
IHBlciB0dW5uZWwuDQo+IA0KPiBBIHNlbGZ0ZXN0IHRvIGNoZWNrIGJvdGggaXB2NCBhbmQg
aXB2NiB3b3VsZCBiZSB0aGUgdWx0aW1hdGUgd2luIHRoZXJlLg0KDQpJIHdyb3RlIHRoZSBz
bWFsbCB0ZXN0LXNjcmlwdCBiZWxvdy4NCldpdGhvdXQgbG9va2luZyBhdCB0aGUgY29kZSwg
dG8gbWUgaXQgc2VlbXMgbGlrZSBzZXR0aW5nIHRoZSBUT1Mgd2hlbiB0aGUgb3V0ZXINCnRy
YW5zcG9ydCBpcyBJUHY2IGRvZXMgbm90IHdvcmsuDQpUaGlzIGlzIG9uIDUuMTktcmM1DQoN
CldoZW4gaSBjcmVhdGUgdGhlIHR1bm5lbCB3aXRoIHRoZSBzY3JpcHQgYmVsb3c6DQpvdXRl
cj02DQppbm5lcj00DQphbmQgaGFyZGNvZGUgdGhlIFRPUyBmb3IgdGhlIHR1bm5lbCB0byAw
eGEwDQppcCBsaW5rIGFkZCBuYW1lIHRlcDAgdHlwZSBpcDZncmV0YXAgbG9jYWwgZmRkMTpj
ZWQwOjVkODg6M2ZjZTo6MSByZW1vdGUgZmRkMTpjZWQwOjVkODg6M2ZjZTo6MiB0b3MgMHhh
MA0KdGhlbiBpIHdvdWxkIGV4cGVjdCB0aGUgY2xhc3Mgb2YgdGhlIHJlc3VsdGluZyBHUkUg
ZnJhbWVzIHRvIGJlIDB4YTANCmhvd2V2ZXIgYSBwaW5nIHRocm91Z2ggdGhlIHR1bm5lbCBz
aG93cyBtZQ0KDQokIHRjcGR1bXAgLWkgdmV0aDAgLW4gLXYgLWUNCjE1OjI0OjAxLjM5NTIz
NiBhMjpmODpiYjoxZjpkMzpiMSA+IDA2Ojk0OmRhOjI5OmUwOjBiLCBldGhlcnR5cGUgSVB2
NiAoMHg4NmRkKSwgbGVuZ3RoIDE2ODogKGZsb3dsYWJlbCAweGI0Yzg0LCBobGltIDY0LCAN
Cm5leHQtaGVhZGVyIHVua25vd24gKDYwKSBwYXlsb2FkIGxlbmd0aDogMTE0KSBmZGQxOmNl
ZDA6NWQ4ODozZmNlOjoxID4gZmRkMTpjZWQwOjVkODg6M2ZjZTo6MjogRFNUT1BUIChvcHRf
dHlwZSAweDA0OiANCmxlbj0xKShwYWRuKSBHUkV2MCwgRmxhZ3MgW25vbmVdLCBwcm90byBU
RUIgKDB4NjU1OCksIGxlbmd0aCAxMDYNCgliMjpkODo1OTo5ZDpjZTpjYSA+IGI2OjllOmEz
OmFhOmY3OmFlLCBldGhlcnR5cGUgODAyLjFRICgweDgxMDApLCBsZW5ndGggMTAyOiB2bGFu
IDk5LCBwIDAsIGV0aGVydHlwZSBJUHY0ICgweDA4MDApLCANCih0b3MgMHgwLCB0dGwgNjQs
IGlkIDcwNTYsIG9mZnNldCAwLCBmbGFncyBbREZdLCBwcm90byBJQ01QICgxKSwgbGVuZ3Ro
IDg0KQ0KICAgICAxOTguMTkuMC4xID4gMTk4LjE5LjAuMjogSUNNUCBlY2hvIHJlcXVlc3Qs
IGlkIDU5MTAxLCBzZXEgNSwgbGVuZ3RoIDY0DQoNCndoZXJlYXMgd2hlbiBpIGRvIGEgcGlu
ZyBkaXJlY3RseSAobm90IHRocm91Z2ggdGhlIHR1bm5lbCkgd2l0aA0KcGluZyBmZGQxOmNl
ZDA6NWQ4ODozZmNlOjoyIC1RIDB4YTANCnRoZW4gaSBzZWUgdGhlIGNsYXNzIGNvcnJlY3Rs
eQ0KDQokIHRjcGR1bXAgLWkgdmV0aDAgLW4gLXYgLWUNCjE1OjI1OjAwLjc1NTE4OCBhMjpm
ODpiYjoxZjpkMzpiMSA+IDA2Ojk0OmRhOjI5OmUwOjBiLCBldGhlcnR5cGUgSVB2NiAoMHg4
NmRkKSwgbGVuZ3RoIDExODogKGNsYXNzIDB4YTAsIGZsb3dsYWJlbCANCjB4NWY4YzcsIGhs
aW0gNjQsIG5leHQtaGVhZGVyIElDTVB2NiAoNTgpIHBheWxvYWQgbGVuZ3RoOiA2NCkgZmRk
MTpjZWQwOjVkODg6M2ZjZTo6MSA+IGZkZDE6Y2VkMDo1ZDg4OjNmY2U6OjI6IFtpY21wNiAN
CnN1bSBva10gSUNNUDYsIGVjaG8gcmVxdWVzdCwgaWQgNDY4NjYsIHNlcSAyDQoNCg0KSGFz
IHNldHRpbmcgdGhlIFRPUyBmb3IgaXA2Z3JldGFwIGV2ZXIgd29ya2VkPw0KSG93IHNob3Vs
ZCBpIGdvIGZvcndhcmQgd2l0aCB0aGlzPw0KWW91IHN0YXRlIHRoYXQgeW91ciByZXF1aXJl
IGZlYXR1cmUgcGFyaXR5IGJldHdlZW4gdjQgYW5kIHY2LCBidXQgaSBhbSBub3Qgc3VyZSBp
IGNhbiBwcm92aWRlIHRoYXQgd2hlbg0KdGhlIHVuZGVybHlpbmcgYnVpbGRpbmcgYmxvY2tz
IGFyZSBtaXNzaW5nLg0KDQpCUg0KTWF0dGhpYXMNCg0KLS0tDQojIS9iaW4vc2gNCg0Kc2V0
dXAoKSB7DQoJbG9jYWwgb3V0ZXIgaW5uZXIgdGVzdF9uYW1lc3BhY2UgbnNleGVjDQoJb3V0
ZXI9IiQxIg0KCWlubmVyPSIkMiINCgl0ZXN0X25hbWVzcGFjZT0idGVzdGluZyINCgluc2V4
ZWM9ImlwIG5ldG5zIGV4ZWMgJHRlc3RfbmFtZXNwYWNlIg0KDQoJIyBDcmVhdGUgJ3Rlc3Rp
bmcnIG5ldG5zLCB2ZXRoIHBhaXIgYW5kIGNvbm5lY3QgbWFpbiBucyB3aXRoIHRlc3Rpbmcg
bnMNCglpcCBuZXRucyBhZGQgJHRlc3RfbmFtZXNwYWNlDQoJaXAgbGluayBhZGQgdHlwZSB2
ZXRoDQoJaXAgbGluayBzZXQgdmV0aDEgbmV0bnMgdGVzdGluZw0KCWlwIGxpbmsgc2V0IHZl
dGgwIHVwDQoJJG5zZXhlYyBpcCBsaW5rIHNldCB2ZXRoMSB1cA0KCWlwIGFkZHIgZmx1c2gg
ZGV2IHZldGgwDQoJJG5zZXhlYyBpcCBhZGRyIGZsdXNoIGRldiB2ZXRoMQ0KDQoJIyBDcmVh
dGUgKGlwNilncmV0YXAgYW5kIGFzc2lnbiBvdXRlciBJUHY0L0lQdjYgYWRkcmVzc2VzDQoJ
aWYgWyAiJG91dGVyIiA9ICI0IiBdOyB0aGVuDQoJCWlwIGFkZHIgYWRkIDE5OC4xOC4wLjEv
MjQgZGV2IHZldGgwDQoJCSRuc2V4ZWMgaXAgYWRkciBhZGQgMTk4LjE4LjAuMi8yNCBkZXYg
dmV0aDENCgkJaXAgbGluayBhZGQgbmFtZSB0ZXAwIHR5cGUgZ3JldGFwIGxvY2FsIDE5OC4x
OC4wLjEgcmVtb3RlIDE5OC4xOC4wLjIgdG9zIGluaGVyaXQNCgkJJG5zZXhlYyBpcCBsaW5r
IGFkZCBuYW1lIHRlcDEgdHlwZSBncmV0YXAgbG9jYWwgMTk4LjE4LjAuMiByZW1vdGUgMTk4
LjE4LjAuMSB0b3MgaW5oZXJpdA0KCWVsaWYgWyAiJG91dGVyIiA9ICI2IiBdOyB0aGVuDQoJ
CWlwIGFkZHIgYWRkIGZkZDE6Y2VkMDo1ZDg4OjNmY2U6OjEvNjQgZGV2IHZldGgwDQoJCSRu
c2V4ZWMgaXAgYWRkciBhZGQgZmRkMTpjZWQwOjVkODg6M2ZjZTo6Mi82NCBkZXYgdmV0aDEN
CgkJaXAgbGluayBhZGQgbmFtZSB0ZXAwIHR5cGUgaXA2Z3JldGFwIGxvY2FsIGZkZDE6Y2Vk
MDo1ZDg4OjNmY2U6OjEgcmVtb3RlIGZkZDE6Y2VkMDo1ZDg4OjNmY2U6OjIgdG9zIGluaGVy
aXQNCgkJJG5zZXhlYyBpcCBsaW5rIGFkZCBuYW1lIHRlcDEgdHlwZSBpcDZncmV0YXAgbG9j
YWwgZmRkMTpjZWQwOjVkODg6M2ZjZTo6MiByZW1vdGUgZmRkMTpjZWQwOjVkODg6M2ZjZTo6
MSB0b3MgaW5oZXJpdA0KCWVsc2UNCgkJcmV0dXJuIC0xDQoJZmkNCg0KCSMgQnJpbmcgKElQ
NilHUkVUQVAgbGluayB1cCBhbmQgY3JlYXRlIFZMQU4gb24gdG9wDQoJaXAgbGluayBzZXQg
dGVwMCB1cA0KCSRuc2V4ZWMgaXAgbGluayBzZXQgdGVwMSB1cA0KCWlwIGFkZHIgZmx1c2gg
ZGV2IHRlcDANCgkkbnNleGVjICRuc2V4ZWMgaXAgYWRkciBmbHVzaCBkZXYgdGVwMQ0KCWlw
IGxpbmsgYWRkIGxpbmsgdGVwMCBuYW1lIHZsYW45OS0wIHR5cGUgdmxhbiBpZCA5OQ0KCSRu
c2V4ZWMgaXAgbGluayBhZGQgbGluayB0ZXAxIG5hbWUgdmxhbjk5LTEgdHlwZSB2bGFuIGlk
IDk5DQoJaXAgbGluayBzZXQgdmxhbjk5LTAgdXANCgkkbnNleGVjIGlwIGxpbmsgc2V0IHZs
YW45OS0xIHVwDQoJaXAgYWRkciBmbHVzaCBkZXYgdmxhbjk5LTANCgkkbnNleGVjIGlwIGFk
ZHIgZmx1c2ggZGV2IHZsYW45OS0xDQoNCgkjIEFzc2lnbiBpbm5lciBJUHY0L0lQdjYgYWRk
cmVzc2VzDQoJaWYgWyAiJGlubmVyIiA9ICI0IiBdOyB0aGVuDQoJCWlwIGFkZHIgYWRkIDE5
OC4xOS4wLjEvMjQgYnJkICsgZGV2IHZsYW45OS0wDQoJCSRuc2V4ZWMgaXAgYWRkciBhZGQg
MTk4LjE5LjAuMi8yNCBicmQgKyBkZXYgdmxhbjk5LTENCgllbGlmIFsgIiRpbm5lciIgPSAi
NiIgXTsgdGhlbg0KCQlpcCBhZGRyIGFkZCBmZGQ0Ojk2Y2Y6NGVhZTo0NDNiOjoxLzY0IGRl
diB2bGFuOTktMA0KCQkkbnNleGVjIGlwIGFkZHIgYWRkIGZkZDQ6OTZjZjo0ZWFlOjQ0M2I6
OjIvNjQgZGV2IHZsYW45OS0xDQoJZWxzZQ0KCQlyZXR1cm4gLTENCglmaQ0KfQ0KDQpjbGVh
bnVwKCkgew0KCWlwIGxpbmsgZGVsIHZldGgwDQoJaXAgbmV0bnMgZGVsIHRlc3RpbmcNCglp
cCBsaW5rIGRlbCB0ZXAwDQp9DQppZiBbICIkMSIgIT0gInN0YXJ0IiBdICYmIFsgIiQxIiAh
PSAic3RvcCIgXTsgdGhlbg0KCWVjaG8gImludmFsaWQgZmlyc3QgYXJndW1lbnQsIHZhbGlk
IGlzICdzdGFydCcgb3IgJ3N0b3AnIg0KCWV4aXQgMQ0KZmkNCmlmIFsgIiQxIiA9ICJzdGFy
dCIgXSAmJiBbICIkMiIgIT0gIjQiIF0gJiYgWyAiJDIiICE9ICI2IiBdOyB0aGVuDQoJZWNo
byAiaW52YWxpZCBzZWNvbmQgYXJndW1lbnQgKG91dGVyIHByb3RvY29sKSwgdmFsaWQgaXMg
JzQnIG9yICc2JyINCglleGl0IDENCmZpDQppZiBbICIkMSIgPSAic3RhcnQiIF0gJiYgWyAi
JDMiICE9ICI0IiBdICYmIFsgIiQzIiAhPSAiNiIgXTsgdGhlbg0KCWVjaG8gImludmFsaWQg
dGhpcmQgYXJndW1lbnQgKGlubmVyIHByb3RvY29sKSwgdmFsaWQgaXMgJzQnIG9yICc2JyIN
CglleGl0IDENCmZpDQppZiBbICIkMSIgPSAic3RhcnQiIF07IHRoZW4NCglzZXR1cCAiJDIi
ICIkMyINCmVsaWYgWyAiJDEiID0gInN0b3AiIF07IHRoZW4NCgljbGVhbnVwDQpmaQ0KDQo=

--------------HSUjFdwhHYOLl1afEHx82JmB
Content-Type: application/pgp-keys; name="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSg
RcI4rgLNKE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7C
lgQTFggAPhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaI
OmnxP9FimzEpsHorYNQfe8fp4cjPAP9vCcg5Qd3odmd0orodCB6qXqLwOHexh+N6
0F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CUu0gESJr6GFA6GopcHFxtL/WH
7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+
BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOIPWGsf80E
9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh
CA=3D=3D
=3DtbX5
-----END PGP PUBLIC KEY BLOCK-----

--------------HSUjFdwhHYOLl1afEHx82JmB--

--------------9sdCS5II9nsgpFfVPshHqG8N--

--------------RJWErPySSSns46rIakgMiJCo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsbmrgUDAAAAAAAKCRDfdrYEUzwNviRE
AQC261zdqBCM3kdWXWt0VR+vHp54Iv8Ka4U+tNgmQI/HPgD+LXN3g+cFa79m2PdTluKq7T7N6JhL
MVsXcdOq0zQMpQE=
=JhMm
-----END PGP SIGNATURE-----

--------------RJWErPySSSns46rIakgMiJCo--
