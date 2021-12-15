Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36E24758F9
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhLOMiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:38:07 -0500
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:45710
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234378AbhLOMiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 07:38:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqivGdq98qZ/gpFPV9E9E5qn+t2LdBWgh1TJi+s2ssIvBddiwDvJYl4lq7SrN97YftlUKoAsQwV/Bu/ip/Bbv/IQGhGRYmEAzapX+KGasFpvRlsiw3ufXF3hWGXyCzB7orM8Yu0918Vi4YwvgF98sLbySqfs1EVwPy+x6JJtdXNkj9PmnaK7/2RytI97PCjCTMwzwDWvKLy0vfWurzsIYpkj3FxY6dSKYZMcdGO3ttRA1CG8NW/6iP1yY3wwmIHEaEE0CK4/wSt2zwC6o7/6mSPSn+TF15C4WMYhks4sCLeB+Wx8E/BTKXalqBD+zwvMu+FzfPfoEgi1iVo7ckLphQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KacSBIsWEG7yiaESZrJffV/oYQsXYBSoW8Phtgc/BSE=;
 b=bmnrCc+lIcoJR82Lq0UqaM6Dr+GAgniM5wNm2CWX4YgcPyETCgPvO1o/0yytlWoEr5kvSz8nCaJIv4sMhrzTW4S740ECqsi3Obem2kbVX3KmUfYz0Jdj/HK3u8ezPK3yu06LbwxcxeHnFdpppQ9HgyVPNWI7vkhFp7+RojElk3dii8naNXG22su3wnD+MReTED4lniMLD/x2u0IEJ2FjVXGybc5g2U3t+uyp7Ac+4giLSGxKLpDFhn5vuf8NEEVM9xlbFmpjPlZ+iiVZsEHGCErE2//x31hZZOOiSkCGqFDIEvp/iPVvip33Jf8kMy5PRdfisX+mX/emE9twjMPfSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KacSBIsWEG7yiaESZrJffV/oYQsXYBSoW8Phtgc/BSE=;
 b=AlyjmV6cScZ9+uJwu/kLrvgzpEDuFk9c3LXLWtbCnBsxjJAIDn2Wbk2rETADUxQLnf7RoCeFolTSpnjbYrVDKp+BWBz/0gfjTL2Hbk+Rwf79OSUEBqCKReFAScHCaKpUn7rgy4cZjo4hctROiTZrZudihQtpyKgUhu4/jjwHgoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=westermo.com;
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DB8P192MB0613.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:162::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 12:38:01 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::9ce6:c3de:baae:9fcd%5]) with mapi id 15.20.4778.011; Wed, 15 Dec 2021
 12:38:01 +0000
Message-ID: <52c59be8-f5d5-71c5-5659-92b8fefd719e@westermo.com>
Date:   Wed, 15 Dec 2021 13:37:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
 <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
 <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
 <20211214192405.GA4239@pc-1.home>
From:   Matthias May <matthias.may@westermo.com>
In-Reply-To: <20211214192405.GA4239@pc-1.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vkCctuTQKS9f9qB6tV6Ld30Z"
X-ClientProxiedBy: GV3P280CA0090.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::31) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46343691-f12a-43a0-4a0d-08d9bfc7bb72
X-MS-TrafficTypeDiagnostic: DB8P192MB0613:EE_
X-Microsoft-Antispam-PRVS: <DB8P192MB06137AAED2276B81A5DF899FF1769@DB8P192MB0613.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmnEkj2hK4HUHY9Zsi2P4WmiNFU0fCcrQ1apWmsZxT9xQ22qMjtex9KHtSuYrQ9JFOjjEY2bQuvJajpzrjFgiWLWBG/ZvXe8fcUX+YGp5WyfISOwVEiIQwcDABJPELr1FuGlRyB3RZlbWRov6HLlySChcxhrkTBCGvl55eCfQjlNGzfezrh4QnX2D80s6FfKKzj/49203s26mNG6Tgk/DeFnfJ0JVhas1P+KxyofcP6SCIzy/mu8zmrdA2+DFHLDD3/qp738zlWIQfPXCdbb/tArua+9Ibu5CgumZIK16pXpcEeeYG7XdUi75IBDp41lw4dlW8+mjeaCTy1+fRIUsDwXFz/0yubxlb76FhkEZz3a15lrzu90athycVLL1eA8Cf9BlZt6X+zVv2dGCPfvTH1hEQYMotwaDes1h8mG7mHc3s9DDninF+G7mzfDlR2fE2SvYs9Awi91R7aHQOwSzGuRygIsFjCEOijSMj3LiF2DzOmx5/lNOakDd58UdbbK64+oqP8ZJ+XHHsO3VhfAYz649PdWDjUCKwyDaXLT67a1ek7sDfN6vXkO7MRK37dAG36jBKdCYhZxzF/UZAWB3KF0qXEklA920d7XuQ3hnv8Y9/PEGSYAKBsv1enozQJurB2AGVGlhGx/BxA3sS5BAJwsrpH+PBmyt+6uVZQzOHic/oQ35CD9VEhbfmpCDDzGrUYAKq7E/zKbsrVNiCRUr2XUrABTZMk3ky8SAebX6NiM4kwAJPqJkZ35R8F3thKiXBZaSWYHDJTU6GoqdWG+SGVyesQsGC7KfsdFkJEf1n7jyQfZjiz4n5z4cIuOdSZP+8BA5Eyur0Q4wttqqk/yEbPP+MaVS9V2qWef0bRqUT4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6486002)(36756003)(6512007)(83380400001)(33964004)(53546011)(6506007)(31696002)(52116002)(26005)(235185007)(2906002)(8676002)(21480400003)(508600001)(966005)(6916009)(8936002)(5660300002)(66556008)(2616005)(31686004)(44832011)(38100700002)(38350700002)(316002)(4326008)(86362001)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFRPZ0pJTXlwMVRhdFc5N2pDRzBDZGxEUk1CNzNhZ09wTXJKTEliWE9Udjh4?=
 =?utf-8?B?LzZTQUVGcTA2QVNTQmhCeExwRG45TVFxMnhLWjY0TnZVRzlKdk5MMDRGejY3?=
 =?utf-8?B?eU5mRURGc1VReHphSFBvRy9wVHJTSTRMUEdHZjJ6TXpwWVEyV1RGeFo2TUF4?=
 =?utf-8?B?bjhBQ28xOURhMXhzZno0RS9pL2s4WUJCbFFkRE1mejJMaGI0V1ByMEhCV0JS?=
 =?utf-8?B?Y29sUnNxSkc2Zm9DQjlhUjFRd3o4U2VYcFVYdHpsUWhXNFhXaUtDN1ZlNHFJ?=
 =?utf-8?B?MjVoOUlSL3VlMGpyam5yRVc0WSsvc1ZhRTZEUnMxWDVhZ0huZFhyeVk2dXdZ?=
 =?utf-8?B?b3JQT0F6WVRGeEh4djlpeG5wY25LZ3QxeFNGcDRqY2VnTDFFUHI5Znp2amtt?=
 =?utf-8?B?bnl4OG42STF1NUNrcDAzeU5BUVZrdWhkTG5oK1pvSFg2VnpWY0JoTDNQU0Fy?=
 =?utf-8?B?SitVVXdsUkJ3Wk9QM2wwOGowc2o0c0NkOVJYT0lLNkg3THFzaUdrQlF4RjZV?=
 =?utf-8?B?aTN2Z3Q5UVNVa0FGdXJZUmZySFE0RmJIMlFBNHV3VGJ4T2RkRVZKN3k0dnEw?=
 =?utf-8?B?UGNFUHh2eDZmblJOcWhTdDhIRzlKZi8rVHBpWVdIVC83MFByOWJ2eXZzYS9t?=
 =?utf-8?B?elczbUJQYWFQYVo1VkhkNExONlF4UElSTHV2UjVZVk1PUDV1Q2tUL1N2UWJx?=
 =?utf-8?B?c3NVZWRFZWdzTnhTbFpsQzBUc1BIRHRBRENCT2ljZzZZQ2xMUVp5RmxGaldE?=
 =?utf-8?B?Z3dVWTQzeksxMU1TR2ZXTWdyYm03bTR1N0haazI5dXB5SVZyNWlQTnd5aTFP?=
 =?utf-8?B?UnRVS1dwMVpZOWE5SHNqdTVFaTRWVU1mVmRwbVVWRXJHZ1RpUFBhaXVxY3Bt?=
 =?utf-8?B?Znl2U1BpaEVsRFFwY1RtVUhIUmFWdW10d2YzZHRUODJHaVdUcUErZ21HT0Nq?=
 =?utf-8?B?YU9yckpSaGhVbndPSWt4NE15dmdxMSt2NHhLSlJSSjRtc2MyVUF2UHY5eCts?=
 =?utf-8?B?dC95ZDRoeUZQcklyeEF0MXVNb1BGOUNwRlJSSVZuTlBBMjFrdjBaNzlsRzlz?=
 =?utf-8?B?QnlZdFBmZTFVbGNqVWVScGtKTGVEQmprN09PNEh4WDJkYmg5aUlxN1B0YnpK?=
 =?utf-8?B?U01IVzFWUWZsSW5GcVgzTzd4eHpVYXRkSHZJUGlULzBVc0cvUk9BTWFSQm1h?=
 =?utf-8?B?WEFHZEtZWE1VeTdMZkNMUTJzUE91akt5SkFVeGh0cVQycjR6VGlDYkx0ZjZ2?=
 =?utf-8?B?aUtROFhJQjVRQjZVWStPZjdQS3ErMmFBL2RSQlRLd2tseitjU29xcnpRQ0JW?=
 =?utf-8?B?K1g2MWIzVVJlMnEvTXBBd3dIMVlhK3UxaXQyVTc5OFJmckludFo5TXB5M0p0?=
 =?utf-8?B?QnZkeXA3Si8xOFJFQzVYVUZzQmNnajZCQnE3anNXVVA4YXpmNmxIQU9nUXNh?=
 =?utf-8?B?d2VzKzFMMVZ5Rys4c0JFS1I2QW1IRGZsN2NicEVURXFoZjJhdmIwMDRXeVBO?=
 =?utf-8?B?QmZlUURMRGJKV01pS3VibHJYQnFBb0xSK2x2RG9hL2YyVzlQeXpJN0JiYWFj?=
 =?utf-8?B?YTVBRUVqelBXU21hVFJGbWdKREI0ZVJLUVlCcCtCSzRISVJEK3RqNU1DK1dz?=
 =?utf-8?B?OTBSUzNCbmhEZndxV0lLZERicjd5WjRhaVZxN1ppNGhJRnBwdVYvVkxMTTl0?=
 =?utf-8?B?d29OVWgrWG8weXl5NWEyNmU3dFVzb1lzOUlkb2JVaFFTMjBYcSt4TXYvU0pm?=
 =?utf-8?B?RlpTbDhXQm9tSWlGMUVvd3o3Zms4NVFvUkhjdzJCNDRXS0FyUzZzSlFTZVJP?=
 =?utf-8?B?RVhnMnN1YndBeURZTmFUNXgzaWdqeEhvb2hESEVLWHE4RjJUYmRIdU5QRGo0?=
 =?utf-8?B?bWVtdVJjbm0zeVdqc0FHcVJ1YnRTQzZad0pETjBaWmthaVRVYUFldThhUHgy?=
 =?utf-8?B?VncwWmsrZWRJaUlEaEZGV3JHbjJWTjE2M1lwdkxkdW9DdHoyU0NXZ1VpaG5u?=
 =?utf-8?B?TzBOTnh5T1J5Q1NSMWZrNDExeXdYajg0TzVYclppY0svQnRJSW5mY2s0R0Mv?=
 =?utf-8?B?Nm5uVU1ua2ZpVUxNZ01NTVlqdHo1TU8vWU82NVlrWFNuUEN0aUZHTUZpY3N3?=
 =?utf-8?B?aWhUVjYvTkhVa3UwNlZDaTJXNDdaRkxIK1lTeWRaZGZiL0xSeFBjWmFGT1pq?=
 =?utf-8?Q?ChommZqSAK6wlc4syj2GfL0=3D?=
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46343691-f12a-43a0-4a0d-08d9bfc7bb72
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 12:38:01.7426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1FL0ozQR1cC3UMvoAMUKB3LqN3siSDYeSYD1xM9XKy4ZkPKFcNqwh97b0RawjWXDnPc4ie9MaHtG3N4TfwjjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P192MB0613
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
X-OrganizationHeadersPreserved: DB8P192MB0613.EURP192.PROD.OUTLOOK.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------vkCctuTQKS9f9qB6tV6Ld30Z
Content-Type: multipart/mixed; boundary="------------IbwqS0df3GjNIvFMhXj4ucKe";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org
Message-ID: <52c59be8-f5d5-71c5-5659-92b8fefd719e@westermo.com>
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
 <20201124152222.GB28947@linux.home>
 <704ca246-9ca8-7031-c818-8dfcee77c807@westermo.com>
 <90fbc799-a9b2-beb1-68b0-2b9a9325b29b@westermo.com>
 <20211214192405.GA4239@pc-1.home>
In-Reply-To: <20211214192405.GA4239@pc-1.home>

--------------IbwqS0df3GjNIvFMhXj4ucKe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQvMTIvMjAyMSAyMDoyNCwgR3VpbGxhdW1lIE5hdWx0IHdyb3RlOg0KPiBPbiBUdWUs
IERlYyAxNCwgMjAyMSBhdCAwNDo1ODoxNFBNICswMTAwLCBNYXR0aGlhcyBNYXkgd3JvdGU6
DQo+Pg0KPj4gTmV2ZXJtaW5kLCBpIGZvdW5kIEd1aWxsYXVtZXMgdGFsayBhdCBMUEMgb24g
dGhpcyB0b3BpYyBhbmQgd2hhdCB0aGUgcGxhbnMgYXJlIHRvIGdvIGZvcndhcmQuDQo+IA0K
PiBGWUksIHRoZXJlJ3Mgbm93IHRoaXMgUkZDOg0KPiBodHRwczovL3VybGRlZmVuc2UuY29t
L3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L2NvdmVyLjE2Mzg4MTQ2MTQu
Z2l0LmduYXVsdEByZWRoYXQuY29tL19fOyEhSTlMUHZqM2IhQkZuYU1nUGw0SjR4UFAyVjhY
VWFqRktoaTZja25EamI5dTlfUnJyMlFCYk1iSkdKbllBdTcxNzVTaHNUUWV1cS1vb3JEUDg1
b2tfZElaWmRrSlUkDQo+IA0KPiBOb3RlIHRoYXQgaXQgZG9lc24ndCB5ZXQgYWxsb3cgdGhl
IHVzZSBvZiBoaWdoIG9yZGVyIERTQ1AgYml0cyBpbiBJUHY0DQo+IHJ1bGVzIGFuZCByb3V0
ZXMuDQo+IA0KDQpUaGFuayB5b3UgZm9yIHlvdXIgd29yayBvbiB0aGlzLg0KDQpJJ20gbG9v
a2luZyBmb3J3YXJkIHRvIGhlbHAgdGVzdCB0aGlzLg0KDQpCUg0KTWF0dGhpYXMNCg==

--------------IbwqS0df3GjNIvFMhXj4ucKe--

--------------vkCctuTQKS9f9qB6tV6Ld30Z
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYbnhpwUDAAAAAAAKCRDfdrYEUzwNvjkF
AQCcCVJkWPNF/UblNlHSIMdk+wRt9eklMeXHwjDiJlEjfQEA+Nf3Qp5yHbuYGrLHpFu26L62oizg
YiQViPv4oEbeGQE=
=Ysvt
-----END PGP SIGNATURE-----

--------------vkCctuTQKS9f9qB6tV6Ld30Z--
