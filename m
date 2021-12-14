Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A364746C7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhLNPru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:47:50 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:4581
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231273AbhLNPrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 10:47:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7c2WRAQJykC7a0bXXMYgU7CPDGWjTpFPZ56N7LKiuXpruLV66QsQCcJEazVCfgk5acdxnstvrO80d+aAy3DNRBNHBvaACeh15K9dhz2zZT4sbYxHdzhMSahJxs9uLtWKp/FtuKmhNKTGukfDFlLO2MMVdkJOYiUXlT9t76CxNdFjv2Xy8EdN6g2RAjBOiif4KvA4OAf58dZ6jQKRYuiSRERJn3lk9Vl5zqKOLvecXo1GRmuyo8dRgg9AEuBfZSwgcKV5bN2hH8N2ne/u5As0aJ67rgGU7vOLUGsHDPA1z3DdypFH866ZWBGpv0DndLQ/C7cK4X0+iXJ6DRMEs911Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GN0XsVMUY28+cXZx09homV6AdlELsmBxKU7sUHsbYuk=;
 b=M2G5IL2SgMGKwvb+NN2EPC401QdUYx/ZhU1WqOLbfh7lUXnaPoIRpvj9EPjZzB6CRm+Dqh3eoZGxjrqheuidrjexWs7thQIWq1syGHwy51yEj82BFKr9L7fs3td641199+REQ5JtrLyKUPwz2jb8xfkyrRbAdSFpylboUb5DaniwA7QialPwsMn50pvVveDkmLYIvnxPUOuUsKdv/j/vSxP8CoUwlcCto1etONJd3XVMSSu58Sodh5MSeSGLrZfi2QexdobXuQHkDYksJfEt9Cz+PIuB+q82U56gQWbcThR2yZWbx08JNM45UMj1H9+9ftPEJ9TjNHMGdW5QVlkhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GN0XsVMUY28+cXZx09homV6AdlELsmBxKU7sUHsbYuk=;
 b=Ez3y7ri/zDFum3Gu8IdEDVXawkJK3Npabq8soYKvt7wJ9jghIVLjIxYmGJTpEIYHXCQlmIRxMQv1JkeezROmeqsN/HSkf3n8m1bxGdtxsooohFRiCnyimdcPXGKpxQGCvct9Q2U+lJTVl9UW8LoOnrTpAaWhw4jVP5m0urK5b84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=westermo.com;
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DB8P192MB0776.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Tue, 14 Dec
 2021 15:47:47 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd%5]) with mapi id 15.20.4778.011; Tue, 14 Dec 2021
 15:47:46 +0000
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
From:   Matthias May <matthias.may@westermo.com>
Message-ID: <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
Date:   Tue, 14 Dec 2021 16:47:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20201124152222.GB28947@linux.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SKuAMJyXCV6mOsnTTH7Rta1QIjXmth41p"
X-ClientProxiedBy: GV3P280CA0069.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::30) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d43b5055-2cc0-4833-394f-08d9bf191340
X-MS-TrafficTypeDiagnostic: DB8P192MB0776:EE_
X-Microsoft-Antispam-PRVS: <DB8P192MB0776FCDB1C58CD1F6C2979EAF1759@DB8P192MB0776.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oKpsLZlooFal6QU2chJcCsp+QbGUR0ylO6E9JjoBiIT3vqTe9dzjYN875/kVtQ35X7AXSK+3y7xzN3GB0UZmctzQq/X0grGV/fOSpDbxxEr1eSRpMGoKWdsV22vsLM7HtDXeCgEYRcG5NxfAFTyAkexBzIyJkerzXL6rN2HcOS7yPK2hkw6xFIJx1GBC3Xfq6lJ++ZqdNASHx3Cv5WjrTqrxAWktscwO3T4MVd69iVuKraM2DNkvIwSkUjhntBKGzBY5jWov5q+z95xfpnT1NM0kST+z23qCdp4GfkatJXXXfAOH9DMVtrnO0LvBzcgVDer8M98icC9ejoirZ4VTQk+dxBZA9YYuGDj1pwrS/nERjyYkHL46YrVfqfTAbRfUD8r9UNB7hWnDUdA3nAQMmDEvhFo4ukeSTTYaWOVI483A/Z9aarq8ENmm7jrRaXWoRX8+5hcfYJMvSwpnmqvKA4oau04PJ0voa8f3lGFXun+aqm1mYY9TC8RqpzW3Ci/GpwsoinXTaSK3XMfucs+hjdZxtDyhThvoKaPfc0DqY1YNxg8s8pFjQ40M5fYUgZu/ZRDA16ErKG91DGUS6u0gGnzLVCpnDfRJ31eBCOy+6UMnxyYWQq1ygkZiAiRbF8ZGlAg8AbfbpgFplX4cZKzaYK1NaLqAH/cqPeRUviiz95AaS1tX9Orru4CbTWkzIvNJ9iFeP8wlxsoVCp8T11v7JWcRLAuEVXriMtSq9zLyvZbYtsstmFifEIdx0HMJGSEllbMS1ziswzFiX/+bCLupMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(66476007)(2616005)(186003)(6506007)(66946007)(4326008)(66556008)(508600001)(33964004)(36756003)(86362001)(21480400003)(6512007)(6666004)(8936002)(38350700002)(53546011)(2906002)(6486002)(31686004)(38100700002)(8676002)(83380400001)(52116002)(235185007)(316002)(6916009)(5660300002)(31696002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b20rcElTblNvMWNRZ05PQkN3NXZSUmVFTy9KNllzbmc3U1lENS9lbkkvM0NK?=
 =?utf-8?B?NVZIYXJFNzA1emJKNFpNMkgwV3M2QWdlb3ZtSlIrSkZxOWJQTUJEWG00YTdV?=
 =?utf-8?B?clFYa0tQanJjQmowTENpNEtrWGVoUEVreldSaWF1ZkUzVU9aV0oyT2NOZ0JC?=
 =?utf-8?B?UFM5K3lsQmZ0VUxaRXo3bnNjM2s2Wi80T0c3NThBSUVHNmI0QU9zYXdMWmp0?=
 =?utf-8?B?QXM1eXlCLzdPLzY1M2FWYmh0TVFWS05UU1pBZ0NaalNWdzB1TVRMY2M0elZR?=
 =?utf-8?B?VzJlVGVDNFBIR1JwcmhwaVFqdlgrWDJuRUExTEpqcitYSEMxcGcyWVdPZFJY?=
 =?utf-8?B?a1dGNmNZTTRCd2pZTU5DeUNycTVJS3V4bkYxbDhtM0tSZ1kwTFdZcGI2RTRo?=
 =?utf-8?B?ZUduNWNxNjF2eFlIbFQyTGorN2F5cEUrWXJ4RW9ia0o3elVzdWd6U2JFSERa?=
 =?utf-8?B?Wjl0cklQaWtCeGtIMDlCQWk1cVJpdklLMUpXSzNXdFI0cFoxTFZ5ajdkKzBZ?=
 =?utf-8?B?d09jYk5iWHBKYWkrSDFIelJkMTV3TFNQbk9lRXBUd1lRWW9JOHBkbGpWcStw?=
 =?utf-8?B?UjQ5WDhHQTlDaGk5WG9CNVoyL2dQVkovS0c4ajJtU1pRVWo5SHlocHJPeUll?=
 =?utf-8?B?VUwwRjJwQ1kxZHlzRHZpRFAwc1Uxdjd1Mm1rRVprcTE2enFVa2ViREFLd1E2?=
 =?utf-8?B?YWsvZEJwa1ZMTVlMRzNYUkRRanM3WldIV0VPZG5pakFNTVFUanJGUUExckFo?=
 =?utf-8?B?T25RQVRack9OdDNhdzFRSnpEVERhMFp1ekVwb1RHS0hxczIwQkN0VFdCUGpD?=
 =?utf-8?B?NFNoYndaTUwyNExVUGhLM0R1cnZsdURjekw1cUhVNTRTNzJ0V3dWVUNSLzBB?=
 =?utf-8?B?bjFnQnc2T3gwaXZaTUZYVnI1SlRqOFpSUDVMVVZKZFBsa21EbGZXeGt0cDBS?=
 =?utf-8?B?VzBtdG0xMndzeWh6K0tOcEZrNEdPeTBPeklrVy80bDBxTmpMeTc2cHFWWTVz?=
 =?utf-8?B?UG5pYmltbWNlN01UbDNLOG9ZQUdMMExYSGVWTlNGTUs1WjJudFlGZFQ1VEFW?=
 =?utf-8?B?Yy9nQnFhOU82RDlDNGVCU1MwZUVOeXRXOVN5NnlhWExzc0xGOW1NRkNLQk1G?=
 =?utf-8?B?cks1aHlTQlFjT1JTWXJNZTFIRVA1cXlaSmdHTWNUUnljMzNESkVXclVqVmZY?=
 =?utf-8?B?TDA1aFV3U3pCRk5uVElVTzVqMThnTGZKOTBUMnh3Z0U4SisyekVQUFZGSUNa?=
 =?utf-8?B?M3RrUlY1bUZtRG5JckRDRHFvSVdBNjR3VVg4ZU5CT08vVFRRNVR5alNnT3dP?=
 =?utf-8?B?OXN0Mk9pUGh1eFlKVTBOUVNYVGpxcUtvcjRsZW1SWkdTM040ekhQQlNvbjF3?=
 =?utf-8?B?a002S3crSGNPQm45WGJFSDZWT1IrUkpMNHlWQUZydGhLcE5Ma2JqdHNGSTcz?=
 =?utf-8?B?OHlVQlpjaHQrdGtZS08wR01QU3pPejFITTM4RUFJYkRSd1F6aTZSWkdJQjBj?=
 =?utf-8?B?T1dhMWFEMHdlL2N3Q2tuK1cwak9wNHlOTnF0L2o4akxLSWVHK05MQjQ4M0dU?=
 =?utf-8?B?aEJEQkZvMWxPVmlZTmZmamkvYkJBcGZuTjU5T1c5b21pcTBwU1I2bjNNcTdw?=
 =?utf-8?B?Q0FRVnNFblUxOXpTcTVza2FlWHg3blNXbFZKb1hYbE5RT3Z5V0kwMTZHN25P?=
 =?utf-8?B?TVVLR0x5c2tYZmJtak9EclpycktCdS9TeHVUcjBoQnVjdFJnclNVNVAycVd1?=
 =?utf-8?B?OHVEdG1hRDR5SmRZQUhlZEVRQnhiSjNyeW5DOHJjeFJPWWhHSGFieTd0RmNW?=
 =?utf-8?B?Y2lKTzJkNURqZ3NzVFFGQ3pKVnVDblh3U0tVMUJVUEQ5TjhvU2R2MUJ5TlI4?=
 =?utf-8?B?NWI3L1dUcU5jRjcxRHNDbVVtVUhJMkJZNk1XclNXZ2tGVjJBWXQzVTRMTlUz?=
 =?utf-8?B?Rmg4UVZRT2dLbnA2dk9tYy9ucjFyQW5TL1JySmJLV2YvSFhxakVXWWkxT1Jw?=
 =?utf-8?B?aWw3VzlMOXorSE1Fcko4WVRPS0VFMmJGQ0I0TUdyOVByd2hzTnlEUnRsUUhy?=
 =?utf-8?B?bGV3VXdJelg1REJCeFEzMU9SYlBaY3pWc21BSzRIdTBSWXkwSzhwSW5jQUxz?=
 =?utf-8?B?aDNGY2trQjlSeWFVYUc2ZHZXSC9vUkpjRXBIQ0pOaDFqNGsvU044NkFVUGZ2?=
 =?utf-8?Q?ozgQkzCXyiK7Ff+Ia0oUHBE=3D?=
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43b5055-2cc0-4833-394f-08d9bf191340
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 15:47:46.9113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsCbfvZRrl2b1fqNIjksiFaX2mVqy4DQS/nPjFPbkLIUslbI4syfddcp2hRsxCr+sykfrm9P5rpGZOt9YKnebQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P192MB0776
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
X-OrganizationHeadersPreserved: DB8P192MB0776.EURP192.PROD.OUTLOOK.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--SKuAMJyXCV6mOsnTTH7Rta1QIjXmth41p
Content-Type: multipart/mixed; boundary="6MsJYcU1wHVAmdHEgU5b1u4NygyNOdPuA";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Russell Strong <russell@strong.id.au>
Cc: netdev@vger.kernel.org
Message-ID: <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
In-Reply-To: <20201124152222.GB28947@linux.home>

--6MsJYcU1wHVAmdHEgU5b1u4NygyNOdPuA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/24/20 4:22 PM, Guillaume Nault wrote:
> On Tue, Nov 24, 2020 at 12:41:49PM +1000, Russell Strong wrote:
>> On Mon, 23 Nov 2020 23:55:05 +0100 Guillaume Nault <gnault@redhat.com>=
 wrote:
>>> On Sat, Nov 21, 2020 at 06:24:46PM +1000, Russell Strong wrote:
>>
>> I was wondering if one patch would be acceptable, or should it be brok=
en
>> up?  If broken up. It would not make sense to apply 1/2 of them.
>=20
> A patch series would be applied in its entirety or not applied at all.
> However, it's not acceptable to temporarily bring regressions in one
> patch and fix it later in the series. The tree has to remain
> bisectable.
>=20
> Anyway, I believe there's no need to replace all the TOS macros in the
> same patch series. DSCP doesn't have to be enabled everywhere at once.
> Small, targeted, patch series are much easier to review.
>=20
>>> RT_TOS didn't clear the second lowest bit, while the new IP_DSCP does=
=2E
>>> Therefore, there's no guarantee that such a blanket replacement isn't=

>>> going to change existing behaviours. Replacements have to be done
>>> step by step and accompanied by an explanation of why they're safe.
>>
>> Original TOS did not use this bit until it was added in RFC1349 as "lo=
wcost".
>> The DSCP change (RFC2474) marked these as currently unused, but worse =
than that,
>> with the introduction of ECN, both of those now "unused" bits are for =
ECN.
>> Other parts of the kernel are using those bits for ECN, so bit 1 proba=
bly
>> shouldn't be used in routing anymore as congestion could create unexpe=
cted
>> routing behaviour, i.e. fib_rules
>=20
> The IETF meaning and history of these bits are well understood. But we
> can't write patches based on assumptions like "bit 1 probably shouldn't=

> be used". The actual code is what matters. That's why, again, changes
> have to be done incrementally and in a reviewable manner.
>=20
>>> For example some of the ip6_make_flowinfo() calls can probably
>>> erroneously mark some packets with ECT(0). Instead of masking the
>>> problem in this patch, I think it'd be better to have an explicit fix=

>>> that'd mask the ECN bits in ip6_make_flowinfo() and drop the buggy
>>> RT_TOS() in the callers.
>>>
>>> Another example is inet_rtm_getroute(). It calls
>>> ip_route_output_key_hash_rcu() without masking the tos field first.
>>
>> Should rtm->tos be checked for validity in inet_rtm_valid_getroute_req=
? Seems
>> like it was missed.
>=20
> Well, I don't think so. inet_rtm_valid_getroute_req() is supposed to
> return an error if a parameter is wrong. Verifying ->tos should have
> been done since day 1, yes. However, in practice, we've been accepting
> any value for years. That's the kind of user space behaviour that we
> can't really change. The only solution I can see is to mask the ECN
> bits silently. That way, users can still pass whatever they like (we
> won't break any script), but the result will be right (that is,
> consistent with what routing does).
>=20
>>> Therefore it can return a different route than what the routing code
>>> would actually use. Like for the ip6_make_flowinfo() case, it might
>>> be better to stop relying on the callers to mask ECN bits and do that=

>>> in ip_route_output_key_hash_rcu() instead.
>>
>> In this context one of the ECN bits is not an ECN bit, as can be seen =
by
>>
>> #define RT_FL_TOS(oldflp4) \
>>         ((oldflp4)->flowi4_tos & (IP_DSCP_MASK | RTO_ONLINK))
>=20
> The RTO_ONLINK flag would have to be passed in a different way. Not a
> trivial task (many places to audit), but that looks feasible.
>=20
>> It's all a bit messy and spread about.  Reducing the distributed natur=
e of
>> the masking would be good.
>=20
> Yes, that's why I'd like to stop sprinkling RT_TOS everywhere and mask
> the bits in central places when possible. Once the RT_TOS situation
> improves, adding DSCP support will be much easier.
>=20
>>> I'll verify that these two problems can actually happen in practice
>>> and will send patches if necessary.
>>
>> Thanks
>>
>=20

Hi Russell

Do you have any plans to continue to work on this?

BR
Matthias


--6MsJYcU1wHVAmdHEgU5b1u4NygyNOdPuA--

--SKuAMJyXCV6mOsnTTH7Rta1QIjXmth41p
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYbi8fwUDAAAAAAAKCRDfdrYEUzwNvnPm
AP0aa68gAE7Ms2XVQP9Y+jnIOtVYXV8CGuHPjaXBG0+TwQD/WYJ/a8ukcYdeWq8HiAa0IzwAVjdo
+hcYp+q0hugFrQg=
=FaM9
-----END PGP SIGNATURE-----

--SKuAMJyXCV6mOsnTTH7Rta1QIjXmth41p--
