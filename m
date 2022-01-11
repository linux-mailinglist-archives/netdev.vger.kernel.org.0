Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9100448B30F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbiAKRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:14:59 -0500
Received: from mail-mw2nam12on2047.outbound.protection.outlook.com ([40.107.244.47]:43361
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343898AbiAKROz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:14:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1JZLdFHK0Y8MOhY2tb4wLasH8P0ZQ1wH7KAybrBNO0Iddj09IdRDjI6QicUUPhyBw23rDvdSij5JiWPIgdzvRcCSXWOW22Dkr0x2baqtGBoeSPjGiAecTFM3FS4noqAD9K6ziAH4mlvLesem/u1B6QTlFx+TRSSVa6FPGg+WTOJ4iyk++YdaPWmvM0u/PV14uGEgSzvunFcLkVhxjvf2pSwbjKD+SrAGP8nClQyDvH35U9FQB1SINJnE1YphASzjMRY1g9YCZkc3rYxMnvil7o98vJ0K7KDoLJsggZ2/+cT8HvnYTbo8CQ0M+hycXoGV3uud6HnguWOGdhMRX+J0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abtaZqULydm75BNQEh2FhQOh7Ybi60+oVFGjOUDT/i0=;
 b=gMLe40JyrhFD8Xh2fBQNzbBrDOdJwIoYg6Urr+TcwM3UflRzUOMIkatWHC2VPtenrwz/Po6HjV5wA+/ATjTa6sepdbrv79E+yotJ4pC8lGuiRL2xTX5YVCVl+fNi858r+Qyn7H5UWAufKcFv5ooMKewSSo3tnU1flfbFyIhsLU9Jq56lmJdThDXE+5iodIxWczTnC0+TOoD9NByRtHcoNnzA3vdtj2JMQYmxZAA1CGUIK1q+hJoojUjVQd6fIs2Strl8QSwlp3r586lmNtyWpnv1ssS9/wPrP/A9ip2ABhX54h8El6B5vIBj1zK/7rWsbBAoHQR58+XEjI6s3ly4nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abtaZqULydm75BNQEh2FhQOh7Ybi60+oVFGjOUDT/i0=;
 b=d4VbUIgpVX+AofZJXz6JY9r8CyM3dfGDCUyOdt0SBjjPnY2dFhXj3CJx7nWKSLTVpcz6uJJGZRGTKiENAAMvW4LbQiF8MYotN0RqnA9PBUx+cfGYBsspGTOONgzhSefg4oCZh8yZ1AMd9xxDgxR5io+zv8N2VGO+Rnq5pRSWAbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 17:14:54 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:14:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v9 03/24] wfx: add Makefile/Kconfig
Date:   Tue, 11 Jan 2022 18:14:03 +0100
Message-Id: <20220111171424.862764-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 341c80e0-8419-4c5b-47a2-08d9d525e25b
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5595D77D9F93A28D5902B0D293519@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vPyISXC2IlhOI7qzN+7sx+PXdnKP7KnHbc9Pz/skDcb34Qqx73y3BjMMlWXqUWUEm60Ldx9OSJb+MIJ2IIisN6JCcL27ftKhmM3XMOstIKj8oP8QlF65SE6cEqD9uI8xVoFyK8nZ/U0xDT1vRdQtLXQvNV1lpzKuYXx2nTT6kEHPieokzaAerE3AlNqurLg4GI2Mq1wVVmUaRtwwizeFt7FlshnqBWK5fa4Im1gQGTRmGhr0q4Sh/VG5ryKzCOrG+9N2DV2ZQSmBxfiRdV/oEYZJSmHswklxYnH4baaWVfq5eV6KR8YRV2Du20JhEiU6zItucQDNXS367ySI/szWbqrBmHvF4Tc/lAU7OsSMWMi8EK/8tAmbwcN3XFcvFCXG12D4RrOKOPh15yY9z5ULsU/SMl49KYBL/OH9bVAyZSkpn/4iabmUnj2t0UsriZY8/uIIn0O74bVPdyiJygv1uiIi7bdvEBzNVHwd9PthQnxhbz8sJBd4gbFZYV+qQvHsjiBWOD0SLKoVmmPp9rPX/GG3U2Gvy+9dG5B7tsEsF6QhCL58Za1KHh2SSnQQoj8eJFReMphiIrpFvsnFNPPC5yUplthFTkMSm8rDQ246w0lS72G+QFi1vcBAuAFLoEBVLXcbu+dacu698BIT8S3yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(6512007)(2906002)(107886003)(66574015)(8936002)(2616005)(7416002)(6666004)(38100700002)(6506007)(4326008)(66476007)(8676002)(54906003)(6916009)(316002)(66556008)(52116002)(86362001)(186003)(5660300002)(6486002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejZTeTZacmp3YzZTNHVjMnRPdFRwOEVsbzgzNmJOVkRhM1BsMUFzQVBqZ1Jw?=
 =?utf-8?B?V1F4U1ZFY0ZjdnhaelpKZWdCZDRYam5RaUJveE5lQmYxUVQ2WW1nQU1PY0c4?=
 =?utf-8?B?QjE4d0pZczlnQWlUekpQTTZNc0xnUlZpcjgzWElOUmpiL2NCQmYyenRuOG9W?=
 =?utf-8?B?SVNzYWlILzcxRHFtWDVNSTJnUEpJTWxUeVo4UVdYdDA2dVVEN0ltMHp5RGQz?=
 =?utf-8?B?UFRJZjR1dGVlbkRuSXRidi9SWnhuMzgzdTFhRW5zZlptZ3psamFKbkkxcnpY?=
 =?utf-8?B?TDUzZURDVFhCdXF3K0dNSDdZSFNjNjRwaVdoVit3aE9jdXZ2OFVwQjJ1UDJL?=
 =?utf-8?B?UmZpVzVTRUlMVTdTWnhtRmswbEFFTDdxc0pLeVRBVUNLSDZVZzFUelROOWsv?=
 =?utf-8?B?bFNLeGVxQU9ZcWRZRXF0VlkvZWhPWU0yNDljUW5TWXpOMXNTS1JudUVVQU13?=
 =?utf-8?B?OU9QV2pPSm5hVDdLa3cvYkl6dWcyV3hFSDhvamJ0aGprS0pqa3lUZU1zblRl?=
 =?utf-8?B?V3hyN294NHpvQ0toaDJlWDRINDVmQzl1ZkVkeGhVUUJieWhoQ2pscUVkZHVT?=
 =?utf-8?B?VUdRK0ZGUEd1M2NzMXpleWZ5WlIzTnJRYVFIbkZNMEFEalQ3bFZNVTF4WlZ1?=
 =?utf-8?B?QWJ1VysyVnJXUmErT1pjRkRwK0JXUWtlRncrWDJrTlFjU1IxMU5pTjRSbTJ3?=
 =?utf-8?B?dUltOGpmTURKakpXOTJ4MUllRXFjNUk2UEkxTUFscDY2dWRMTjZsa3Z3R0Vo?=
 =?utf-8?B?UUhxNWJSZlFIK1d1elZWbWZmTi9kNXRaMFp0Wi9JV1RWS084eW92QWZVQjVS?=
 =?utf-8?B?WDJ3VjJWT3pUZjVTODFndWM4R2lsYWQ5ZlFneWY3amJDakVBY0x1WnpJZDdH?=
 =?utf-8?B?dFcyNjFZbks5WlIrZ21vM0VETzR1US9YSUlJU1BKQnlNc2Y5R09wanNkSy9D?=
 =?utf-8?B?QWxRV1Ezb0F1eUlIZXhUd0xqSGtQK2JjdGxTblRXNXhPYW9SMEo3bEkvZVRB?=
 =?utf-8?B?MmgwTW8wMmtDOEZqTmF5SklrUno5S0tYOU4xOTRSQnNvQkpUcU1DWVVLQmo1?=
 =?utf-8?B?NU1YWnBiRnZwMW1uS21rYmxzRG12SHhjZnU4ajkzbTNyZ0NFRTNKZ3pBWlBL?=
 =?utf-8?B?cC96Wmt6WkNjN2h6UFhmcnlCWmRwZWJydTlBNFZQRVZwcU1hTG5EdG9aQytK?=
 =?utf-8?B?WUtadjJGS0x6c1lUNUlJdWVLMGQ0b0Q2bWdsZ29FL1U0SGs1RkVrUFZJN1g4?=
 =?utf-8?B?NlRKY3ZDN09PeWhnemdTd29VNFBkd01nbzMwNi95Y0pDOTRONUxVRHFZS0dn?=
 =?utf-8?B?eWJRWHBaUVJQQUdrS0x3UEtpWHF4SWFJVkljRzY3WUNkNGdWZFVnZlFFRFNX?=
 =?utf-8?B?NlBqUndWUisvRXpyS0RZSE9JSERaRE5ua3l5c1JGUjdZdGxPMG1KWDdJdGRC?=
 =?utf-8?B?dTBmVkdqai92dmp2eWZaSjBpVk53UjArOXVPUDdnMEtUZ0U0TnMreGZSbzNH?=
 =?utf-8?B?QWRJQ2RadEFzNnROeTZNckErNnNYb0ZhWWpoQVREL0JKamx0empycVh1NVdp?=
 =?utf-8?B?a3FKSXJXUFJkVGYvdjYxOUdqRVhpVWVzVDU0L2Q2TFh1S3UrMnpiaEd6ZmtF?=
 =?utf-8?B?emthWWlNdGNleGJRRENYQ2gyK09SZGdnTTZmbXdaOCtWTmdkM1dET25DT3hk?=
 =?utf-8?B?QlJ4Q1QyL2U0aWRMdVIxM0hOckpOZDdSQ1lXRTZKcGt4S3c4cElKK3FqNEhS?=
 =?utf-8?B?Q1pnTlN0Q1V6SGJzQzJOem9SSHBRUXkzKzZEeUN5Z0o1RVhCOTVzT3ZETXFG?=
 =?utf-8?B?M3FFdWJoZS93Z0RNWDhPcjEweGZYU3lVU3BCc2tiRSs1WSt5TzhkSjl1aXM3?=
 =?utf-8?B?c0duNGJvbVlhclFsb3JOcHBwMU5aOW1hWDFmT09XSXZwZDVkZ2ZiOVdrbGFU?=
 =?utf-8?B?aGlKMUxiZ3pScytERlNhN0FpWm0zeExaRU16S0FPKzNrVVkwVEE3M09UMHdl?=
 =?utf-8?B?TmU4dXhFUFM3SlJrOHdXWDJDckRBTHorVlREeUthNUlYNHJJRHl1bjB5QUdS?=
 =?utf-8?B?N1RTcWxxcG5EQzBNbDcrUFBUT3J2RVhCZG1ZdjFFSEdvY2F2aWFNVG4zc1cx?=
 =?utf-8?B?cUMyc2ZhZ1ptZ3dzZUF4SmhERnRSQVBFZnEzM1dKZjFlR21YVGlqdmVYZzNL?=
 =?utf-8?B?cmR4c2oxcnh4WGxscVlCSGI3WTNqTmkrZ1pPaEJCdy90Ym1xY0tveXh2NDB2?=
 =?utf-8?Q?f3JYJ5cyIcWIPZaThYkVFk8SXCp15d8ix6prKqLGXU=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341c80e0-8419-4c5b-47a2-08d9d525e25b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:14:53.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74wuiWRYCo4KJdqeGIr0y99dtiLoTS4RajljVP/Zq8kSinUJEdl4fgHV1KUz2O/sdes2NKYMwR+sMA1pZX0mvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZyAgfCAxMyArKysr
KysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvTWFrZWZpbGUgfCAyNiAr
KysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygr
KQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2Nv
bmZpZwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngv
TWFrZWZpbGUKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tj
b25maWcgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tjb25maWcKbmV3IGZpbGUg
bW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi44MzVhODU1NDA5ZDgKLS0tIC9kZXYvbnVs
bAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L0tjb25maWcKQEAgLTAsMCAr
MSwxMyBAQAorIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5Citjb25maWcg
V0ZYCisJdHJpc3RhdGUgIlNpbGljb24gTGFicyB3aXJlbGVzcyBjaGlwcyBXRjIwMCBhbmQgZnVy
dGhlciIKKwlkZXBlbmRzIG9uIE1BQzgwMjExCisJZGVwZW5kcyBvbiBNTUMgfHwgIU1NQyAjIGRv
IG5vdCBhbGxvdyBXRlg9eSBpZiBNTUM9bQorCWRlcGVuZHMgb24gKFNQSSB8fCBNTUMpCisJaGVs
cAorCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgU2lsaWNvbnMgTGFicyBXRnh4eCBzZXJpZXMgKFdG
MjAwIGFuZCBmdXJ0aGVyKQorCSAgY2hpcHNldHMuIFRoaXMgY2hpcCBjYW4gYmUgZm91bmQgb24g
U1BJIG9yIFNESU8gYnVzZXMuCisKKwkgIFNpbGFicyBkb2VzIG5vdCB1c2UgYSByZWxpYWJsZSBT
RElPIHZlbmRvciBJRC4gU28sIHRvIGF2b2lkIGNvbmZsaWN0cywKKwkgIHRoZSBkcml2ZXIgd29u
J3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUKKwkg
IERldmljZSBUcmVlLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dm
eC9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvTWFrZWZpbGUKbmV3
IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5hZTk0YzY1NTJkNzcKLS0tIC9k
ZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L01ha2VmaWxlCkBA
IC0wLDAgKzEsMjYgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQor
CisjIE5lY2Vzc2FyeSBmb3IgQ1JFQVRFX1RSQUNFX1BPSU5UUworQ0ZMQUdTX2RlYnVnLm8gPSAt
SSQoc3JjKQorCit3ZngteSA6PSBcCisJYmgubyBcCisJaHdpby5vIFwKKwlmd2lvLm8gXAorCWhp
Zl90eF9taWIubyBcCisJaGlmX3R4Lm8gXAorCWhpZl9yeC5vIFwKKwlxdWV1ZS5vIFwKKwlkYXRh
X3R4Lm8gXAorCWRhdGFfcngubyBcCisJc2Nhbi5vIFwKKwlzdGEubyBcCisJa2V5Lm8gXAorCW1h
aW4ubyBcCisJc3RhLm8gXAorCWRlYnVnLm8KK3dmeC0kKENPTkZJR19TUEkpICs9IGJ1c19zcGku
bworIyBXaGVuIENPTkZJR19NTUMgPT0gbSwgYXBwZW5kIHRvICd3ZngteScgKGFuZCBub3QgdG8g
J3dmeC1tJykKK3dmeC0kKHN1YnN0IG0seSwkKENPTkZJR19NTUMpKSArPSBidXNfc2Rpby5vCisK
K29iai0kKENPTkZJR19XRlgpICs9IHdmeC5vCi0tIAoyLjM0LjEKCg==
