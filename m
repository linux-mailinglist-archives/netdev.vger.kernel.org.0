Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0B4746F8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhLNP6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:58:20 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:22851
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230000AbhLNP6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 10:58:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fo0liOjMLucQbVVaZBdT5s4gVm/+MLUp9yr3dKYfx7Wjb37sVRmmAyBLu5sEDwHHq2C2ZYBAveSfA0mB/lm00W2IOuh+T2T2v2LgmWGnXoKBCVwoWq+3LwG7zYS8w76XD1ZMnZFldwkqN1F3tq9cZ+yWjg4oc0FGu6eqvpUeDQ9DEcYWdkBLKCBTv68txhvpUSV8ODOLWIja1oV6uTOb0VQkmPW4j0MImGwYXtHcCjup4oYlJUUDS3U1wI+1lVaZaWxk137Vf7lz7HpRjmDyycd9tl+9R59+asivg/yhL2pTCPg2zgcjq6oU/LzvfqQAC44c0cyIaUuD59EArpRxag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etuzUwcf9TODyxs2JC0JpFtmXy8A28dTq+0WJe+pP/Q=;
 b=G0tsvqIXuKd+m8jlfNvG1aTScRJiFm3DdNM+JBCZtoG/eEezd+byafwbJUMB0EJsUJrhOG0T7pNyFjtIqOeRlHUcSD/K+oH2VHGxCRt3f/LQm/yXB8bzv3UvDGEILNyQ4hpFgbNLXxG8KQxOrnxD4y/kqEZ2dHce5lLw+52WF5ds55d9CfI+ZYqm7SXdZaShHtXNu0twi8NsUHYxWx1v8nLAS3chIbJ5UhYxAjZLbVdbenvbQxpWDWcopbhlkcjanMzbLLspYiBHFq3ltAWBvVqp7Ye5vkjQ+9OwjG+16v5sCExgjetVYCK7Udx68KfbAlY5dCVoi/6rbO1UO/5UMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etuzUwcf9TODyxs2JC0JpFtmXy8A28dTq+0WJe+pP/Q=;
 b=X1ZJmGH1WU8vddTBm+C4QFhgsiM7wEhrKHOczkgn44AZ1mX5mnhNc2RACVfYWO/oRfI0vUMSEpp/fzy/2+V78F2k3pgbcXfa2ZTNPUeoxWFxW074iowlN/FKMvMqUfI+f8GXRAH2DDqH1kkiBtZ/fnPrF6BtJ5uUhmPGNinEXqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=westermo.com;
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DB6P192MB0216.EURP192.PROD.OUTLOOK.COM (2603:10a6:4:bf::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 14 Dec 2021 15:58:17 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd%5]) with mapi id 15.20.4778.011; Tue, 14 Dec 2021
 15:58:17 +0000
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
From:   Matthias May <matthias.may@westermo.com>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
 <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
Message-ID: <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
Date:   Tue, 14 Dec 2021 16:58:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P3L2kWozt8F1PQzjEQ4ekzEUkLVrdoZYu"
X-ClientProxiedBy: GV3P280CA0081.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::21) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 010df107-7d48-44ec-ae01-08d9bf1a8ac0
X-MS-TrafficTypeDiagnostic: DB6P192MB0216:EE_
X-Microsoft-Antispam-PRVS: <DB6P192MB0216D3E9FA1B932076C8A87EF1759@DB6P192MB0216.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfFWSzd7pzgVfywAkMd57Z0yVCeXT1lWPTs5optFY7XCS1yKNVGTRjzg+A1GDdHDB43H85sCNy58v+Hd6PAhiBrMVAFvnyQHgh8OkejrJlAPvL9sTM+8gmZselFoduIkyGjVaf5tqZPOLoRc71a2gDrIx+4R6ZBfBcLx/SMYtU/JP/5PYEruui7RcvRKJIg7Gf2QOZWGiZDFRTCrT/zWwBgNYWZk24ElqoD7jxcmnOc3Gc4ZYcXnJVfrNx7jJoCHZ0hZlng3P71Dl6lSuklJNdSuEAU7u/69gmstInY6Q/SowQ81Iz1i8thGp0lnamCSRVw8lv05tGx2RFEpRNrbwurb5tgVTie29YfiFJ3qkTAaqqXvQXclyZ3bKAgGPH+Juvz8H2drwqoWogTWKyjyLuzvl9hy4yR6uCf2eN45at0tnP1Pgv9vFU/blQIFwGXJIFMkMkZY97Aa2rPHYQHyxUdIxVWd2phR3IThkrFQhsiFpVturVDsff0mBdVNkLU8XbE5bVPDVSbW/AUtB07+J5wLlrSg+zusOInhpatU+T7eEyrOjGagoAbQafIGe4/J/pOeo7JRSlo6LudHF2H8BHpvYsbBTJjTugZ0TwuRs2XUTWJ6UeeUoef45HEbGU5iMj/YI5m6hEtR8YyTngfV9OTLK3p9XQr7WHCN7PLADxv39Zd+spBbVsMoRA3TsHBv1WJYIwIh3mRyilcG8PFi9M57BGGPEjJa9A//XSyj++uP625ltZB/K+sfxwNARVXiIuyOtDGFzkT1QVa21J23KRHdvtKzguBwcGDBakOYk0xVTToA6RlwEDKQz8t7YrnDxj7WEYgzkTvs5VMprOrh9Xvi0s17kccwYV8Vm9ATlU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2906002)(26005)(8676002)(66556008)(21480400003)(316002)(83380400001)(53546011)(8936002)(5660300002)(33964004)(86362001)(66476007)(36756003)(6916009)(15974865002)(6506007)(6512007)(6666004)(66946007)(31696002)(38350700002)(44832011)(508600001)(2616005)(6486002)(38100700002)(52116002)(4326008)(235185007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU0vUkZMcE9USUxBTVNaR1o0VmtZSjNKREdBZ2JaaVMwdXAzOVQwQW9ETkl5?=
 =?utf-8?B?NHFuTUxhdWZjMlpUN2tDZ21seWcvMHUyLzkzVXNoRHpLSll4eEFhNXU5L1Y5?=
 =?utf-8?B?V25KWEpiRThQVDRMYWxuZm13OWdpVkl4UlQ0MUoxcW9DeEpmZHJhNkpMYkhp?=
 =?utf-8?B?SUVTSzhLV3NlcFdzVXlMT0NMaStOMzFUdzVPSDFRR3FFZFkvcWZsT3RlOXdJ?=
 =?utf-8?B?SnpHYlVFY0hHMlM5TzR4YU40b1FJbFR5Qlk4TFVKZnZQK09INmp0QjN2Y3JJ?=
 =?utf-8?B?a3B1V2JIa0xpY1dVRFNoNDlHZG82a05ORUhycDRaeEI2dWRhbm50eFhlcGYz?=
 =?utf-8?B?TEFSdmwwZkY5M28waUh1bE5xcVhoZjZPLzVrOXUwazJqQUhBV1Bjc0NHSXdi?=
 =?utf-8?B?U2FqZWx1ZEZ1YmRPRnRpRjVMYlRoVVFhdTVEaGtxalRoY0lIRHliTDkwWGFn?=
 =?utf-8?B?RnZUN1FpMjJ5UGFoWmIyTmE3UzNtT3R5ZXhIQ1dicmwrOE5uZ2w5bFRnRGV2?=
 =?utf-8?B?aEdSeUxTZjZDVzJqSUlScUVTcmY0Wmx1OVNLMVFzZGxxKzRaUWJoYkpCVkRV?=
 =?utf-8?B?OUJwZXVRc2JVYmsvc2ZVemMwM1RhRXBGM2VHMlUxaEtHYWJ5eWM1eGVzRlpq?=
 =?utf-8?B?UFR5NFNseGxIZ29Xc0JadnZrcytNSmtOeU41emJLdEhFY25kNC9YbXp5OVA0?=
 =?utf-8?B?cE1KcWZWcXhhNERuMUNyZngxaDlaRS93UUYycTdZeFlpbDRWVUVabEdWSjNo?=
 =?utf-8?B?bVBXaElWZ0kwVjZkSU1iWFJTc0l3OVBEdy9ZV2RIaWlwTWMreEk4d3FOUk16?=
 =?utf-8?B?OHpGM1U1N3NjZ0VieDU1ZUZVaENYb3UvemlUUjFSdmd3WmtrQlZ3bkN0c2FN?=
 =?utf-8?B?RGo2QnlSeUZaN0p4V2U2dTEvU3V3dW5oK2JNQkdqS3dLRzZqeUl2NWx3UEN5?=
 =?utf-8?B?WnpEMVdES2h6cnBUNU5BVDJ1dEdNaDlnaGFKWG0wY1dMM1UvWS82ejQzN2lJ?=
 =?utf-8?B?V0RxOUJSR3lVZS9vOWU5SlErNXRiZHZzUWdoK0kxTUVnc2xHNkRsZlo5RVJp?=
 =?utf-8?B?TTRZbmtiTXJSN1VtTmRCKzQ2dThXVld2K3pNNU82dkovcUdaanA1K0VyYWpp?=
 =?utf-8?B?V1QyVXZPR21OMUFadk5KbFJVRW8rWjdqVXowV1h5d01aT2I1ZHhLMWFyU3Jr?=
 =?utf-8?B?RERLTXlYN2hGZTkvZzYxcmRRT3FSWU9qSGlLQzU5S2U5QUJmMEk2ZXdnUUlq?=
 =?utf-8?B?MDVqZTY3b1YzN21IRlAzdzlmKzdSUEhMTWFCc2VWUWtQckp2SDZmeXl6dDZT?=
 =?utf-8?B?NnA5bHZQTVkxLzZabWQ5NTBWaUpWTU1Jc2UyWXlxVDd2VlMycDRJTFZ0OHBP?=
 =?utf-8?B?WFgyY2xZaUZnbmtCTlFnQUF5SlFKeUNSWVlTOHYzdXpSNlJtTks2OHJHVmNn?=
 =?utf-8?B?NDJobVpGYzZNdmtpZ1kvdjU2WjV3U3R5WEZyeUEyV0Y0NTVOVTJ6dzFGcmNB?=
 =?utf-8?B?eXJHT1dDeHVJUGxpZWxXTWk1Y29PdVNyMDd5UFR2dFp0TXIzNlpmb2ZTVHJp?=
 =?utf-8?B?T2FoUG5UNTNNMDFTNDk4Vm1vYWsrUkU3eFFZdWJodUJmNStPdERKcnZQMWVS?=
 =?utf-8?B?NEQ2eUk5dFdZUHhMYmRnUzNiUGFFZklBRVhINmkzZ3ErNEp6eFRKaHBxVlJr?=
 =?utf-8?B?YUw2c1R0aWYvdjFLeWhIQVd4R0xuejNsMXB1eFlrb01LVlR2WnEvazZBSU1j?=
 =?utf-8?B?WU5TaE5tc0hwdm1hYWxObkpHdkpPLzdZZjBEYkRMMjlmNS9Iam8wUUEvSk80?=
 =?utf-8?B?cGtBcGZ0T0U4c1ZRbGQ1SVVnMTVvMmlQem9rcG1DM0hPLy9HK0dKU2FQK2o4?=
 =?utf-8?B?OU9DUnJSTmdieThmbnNhdUlFbmdSUnU5b010ZDZYcFpoQndYRHJVOVpaUnpv?=
 =?utf-8?B?aEhMZjFzY0owZ2tPWllRNVhyS2lxL3BXaWF4SVJhQ0tPNktjUGszYnlOV0lP?=
 =?utf-8?B?WHg3SmZrdlV4WktOWE1wKzJxaUMvN0VNenZYRVRHZE02TlIwMjdNUGJKR0hx?=
 =?utf-8?B?S1BDY1lyM1d2b2lBb01ML0R4V1VtNktnVkllREhvRkkwU0hKcXI2SGFSZzZl?=
 =?utf-8?B?RmxXbXN2SzVnZXE0MEhuS0MrY3NwYXJJdTQ0SHRPVHA4TmsxV2E1Z0R6YXR0?=
 =?utf-8?Q?3xZfVZay3C+S9Y+uPm7Ri+M=3D?=
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 010df107-7d48-44ec-ae01-08d9bf1a8ac0
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 15:58:16.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdUsXF9dKinl2RKCAXBNV+SPIHxQNx6FOzJKgYqYrERcM4v49Xv2dszS0KlRpC/68+mhb7YeFuz+Htm7HpoN6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P192MB0216
X-MS-Exchange-CrossPremises-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 46.140.151.10
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: DB6P192MB0216.EURP192.PROD.OUTLOOK.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--P3L2kWozt8F1PQzjEQ4ekzEUkLVrdoZYu
Content-Type: multipart/mixed; boundary="sEHaZOyYriQBLzwQqkIuoqH2tbXOwGItC";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Russell Strong <russell@strong.id.au>
Cc: netdev@vger.kernel.org
Message-ID: <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
 <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
In-Reply-To: <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>

--sEHaZOyYriQBLzwQqkIuoqH2tbXOwGItC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/14/21 4:47 PM, Matthias May wrote:
> On 11/24/20 4:22 PM, Guillaume Nault wrote:
>> On Tue, Nov 24, 2020 at 12:41:49PM +1000, Russell Strong wrote:
>>> On Mon, 23 Nov 2020 23:55:05 +0100 Guillaume Nault <gnault@redhat.com=
> wrote:
>>>> On Sat, Nov 21, 2020 at 06:24:46PM +1000, Russell Strong wrote:
>>>
>>> I was wondering if one patch would be acceptable, or should it be bro=
ken
>>> up?  If broken up. It would not make sense to apply 1/2 of them.
>>
>> A patch series would be applied in its entirety or not applied at all.=

>> However, it's not acceptable to temporarily bring regressions in one
>> patch and fix it later in the series. The tree has to remain
>> bisectable.
>>
>> Anyway, I believe there's no need to replace all the TOS macros in the=

>> same patch series. DSCP doesn't have to be enabled everywhere at once.=

>> Small, targeted, patch series are much easier to review.
>>
>>>> RT_TOS didn't clear the second lowest bit, while the new IP_DSCP doe=
s.
>>>> Therefore, there's no guarantee that such a blanket replacement isn'=
t
>>>> going to change existing behaviours. Replacements have to be done
>>>> step by step and accompanied by an explanation of why they're safe.
>>>
>>> Original TOS did not use this bit until it was added in RFC1349 as "l=
owcost".
>>> The DSCP change (RFC2474) marked these as currently unused, but worse=
 than that,
>>> with the introduction of ECN, both of those now "unused" bits are for=
 ECN.
>>> Other parts of the kernel are using those bits for ECN, so bit 1 prob=
ably
>>> shouldn't be used in routing anymore as congestion could create unexp=
ected
>>> routing behaviour, i.e. fib_rules
>>
>> The IETF meaning and history of these bits are well understood. But we=

>> can't write patches based on assumptions like "bit 1 probably shouldn'=
t
>> be used". The actual code is what matters. That's why, again, changes
>> have to be done incrementally and in a reviewable manner.
>>
>>>> For example some of the ip6_make_flowinfo() calls can probably
>>>> erroneously mark some packets with ECT(0). Instead of masking the
>>>> problem in this patch, I think it'd be better to have an explicit fi=
x
>>>> that'd mask the ECN bits in ip6_make_flowinfo() and drop the buggy
>>>> RT_TOS() in the callers.
>>>>
>>>> Another example is inet_rtm_getroute(). It calls
>>>> ip_route_output_key_hash_rcu() without masking the tos field first.
>>>
>>> Should rtm->tos be checked for validity in inet_rtm_valid_getroute_re=
q? Seems
>>> like it was missed.
>>
>> Well, I don't think so. inet_rtm_valid_getroute_req() is supposed to
>> return an error if a parameter is wrong. Verifying ->tos should have
>> been done since day 1, yes. However, in practice, we've been accepting=

>> any value for years. That's the kind of user space behaviour that we
>> can't really change. The only solution I can see is to mask the ECN
>> bits silently. That way, users can still pass whatever they like (we
>> won't break any script), but the result will be right (that is,
>> consistent with what routing does).
>>
>>>> Therefore it can return a different route than what the routing code=

>>>> would actually use. Like for the ip6_make_flowinfo() case, it might
>>>> be better to stop relying on the callers to mask ECN bits and do tha=
t
>>>> in ip_route_output_key_hash_rcu() instead.
>>>
>>> In this context one of the ECN bits is not an ECN bit, as can be seen=
 by
>>>
>>> #define RT_FL_TOS(oldflp4) \
>>>         ((oldflp4)->flowi4_tos & (IP_DSCP_MASK | RTO_ONLINK))
>>
>> The RTO_ONLINK flag would have to be passed in a different way. Not a
>> trivial task (many places to audit), but that looks feasible.
>>
>>> It's all a bit messy and spread about.  Reducing the distributed natu=
re of
>>> the masking would be good.
>>
>> Yes, that's why I'd like to stop sprinkling RT_TOS everywhere and mask=

>> the bits in central places when possible. Once the RT_TOS situation
>> improves, adding DSCP support will be much easier.
>>
>>>> I'll verify that these two problems can actually happen in practice
>>>> and will send patches if necessary.
>>>
>>> Thanks
>>>
>>
>=20
> Hi Russell
>=20
> Do you have any plans to continue to work on this?
>=20
> BR
> Matthias
>=20

Nevermind, i found Guillaumes talk at LPC on this topic and what the plan=
s are to go forward.

BR
Matthias

--=20
Matthias May
Software Engineer

Westermo Neratec AG
p: +41 55 253 2074
e: matthias.may@westermo.com    w: www.westermo.com
a: Rosswiesstrasse 29, CH-8608 Bubikon, Switzerland


--sEHaZOyYriQBLzwQqkIuoqH2tbXOwGItC--

--P3L2kWozt8F1PQzjEQ4ekzEUkLVrdoZYu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYbi/FgUDAAAAAAAKCRDfdrYEUzwNvgwU
AP44wL9dPlGADU+SscLr7MjCm5Rr2Eu/cdpRtJLfiSAxtQEA++Qt2E+LHH0laGWQeVFfZF40I7Hi
WJPZQjRNVaIIRgk=
=JDFf
-----END PGP SIGNATURE-----

--P3L2kWozt8F1PQzjEQ4ekzEUkLVrdoZYu--
