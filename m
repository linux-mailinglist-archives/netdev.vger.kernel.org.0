Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8258742296E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhJEN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:58:52 -0400
Received: from mail-dm3nam07on2066.outbound.protection.outlook.com ([40.107.95.66]:60512
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235108AbhJEN5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:57:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+rdJUyrJsiUjjhrSmCTKABReUTe1TgWI+EsILWGysOrLYxj2O3qOEQe1ZKFDFqabCeaLD/ehOihKezAxi0Rkv71Aak4+ZiGac9IjTSHpqZVlv951yhoPR6joYI+pmri63z7WaQ2r3GAlYegdSwYJuP6hOS/dimF7sYgoRzIdmLiGsd3tRTI4Lg6EJ9ivhA0vlXkcEQMef9/hk4MEjd+AnxkxCYgRAhxHRZS4oR7wdJcnrJXcQ9t9Go3G0xBpRxl49sm5ukPhEztLAPkaP1sqkSFcRU+2BKLgeKqF/pR3M2baoOGoox0s183+w87BHP5aPCcm9h0OxHdYuKZJoxYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIcBw+CXFbHocWcIz5G7RvVUqP94pZAy4g3KTZUqhx8=;
 b=ExolxzSTHK2ID+ReaP7CsFSHubpyvTixJXL1NG1NkNMkI7ksO69zQLAra6LUfB4Q+vJuoME5kUYPvoPm7G+1kS3Qa5Hc3ighii1dONX0lIxys9PTIdTyP9X7rplRh+SDOg4P82Vxi162Am3hKrCNuB6lS5k6kjb0JDpUC9arq/6uj7orQKEmAuDAeqb1E3+T4JuNpVE4EH3Qjb6hrQoxQU/6K77fK6cHEYBhHR3SWoviCcvY+xsXS6rgx/xXqcGReF1dntCR2H73R7QBEo0mdRdj5Xq0q4k0RLakk+tdjmVXfAxGTNs6IOywDhaOE0SxRf5qopxmvjyj6lGWiAV4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIcBw+CXFbHocWcIz5G7RvVUqP94pZAy4g3KTZUqhx8=;
 b=c7CvOsKjPGSy+J6UfQT0OjZVfzi0iHCSiCojvDdt6oNti3KNdECqTM4YQB4R7hmtfLboTxl3ceDGZ7a5pTC0yI1WdtbMF9n3X59+5+vt5l0b62A5oWouVoheuQ43ysD2tXOgTOM0ARpppz3BHXeMMBkaRgWyO6fZmiMihyQvA9w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:54:37 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:54:37 +0000
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
Subject: [PATCH v8 06/24] wfx: add bus.h
Date:   Tue,  5 Oct 2021 15:53:42 +0200
Message-Id: <20211005135400.788058-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:54:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7dfbdc2-178e-43b0-54c7-08d98807ab43
X-MS-TrafficTypeDiagnostic: PH0PR11MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB5643C5F99666A35D1AF8583E93AF9@PH0PR11MB5643.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /bn52ewJUvcBY5F4xBg8so79Lh96fjXboyHblgZO17zd2lm0eXPiknM+Mq1B2ml+V2ljF9rfcu0/u7cHe9ZTeWUWdyRpWIvEmrZnRry0c1n6FaO2ODV4wdU2UITndfjkOXlxNODFx+acC9rT/nRdp+3gzEKNOl4hRKOQ+y/j7U+AU5RNMSTesnAMYijoPPQZasG14mdh8l3ZUT6/cHUFEC9LAkoRmRsmSi1N7jjK7cYCCSKXJ4SYo3+5ljQNnp4gHxaacVkf7FtYd66tGeZrQc+lEH1JH3CSmfhIeCnwfxuUK9IKr69Gj0rztVQkRWR00+93iIBAxJ8xobIIsbW+7Ayw1nX0EiM10sCpZshJWsTot2YDMA5O/L/vgR6tWtdYAhhKgWsGdaOelM5mQwcOGNsFQ2cW1Kb9wuA3IdJTeRNtnTHNGKwoBfJf1ZRbi9jh8zrR/LkxyWsj6PM4NYsOmUdaQnBWs29hvapCKw2ir2RXvwITKT3ypNtvoiXvzIyz4SuaqsbbaB8A4ULQRqLLHxb14/1g66MEpspiut4yXkNlHKkoKvHYsxkVB0twP0ug3VbUEvBNvsSK9lzVUjXkOqT+2Ck0GSYn3r4DExh4FS6azezVI8ZwbxNkdLFvFsD95PRzbVbXSF7zI13TuiHaLGukJ4BIfAD7NhT9BRN7l12mO1PJpo0+tfWd3YcZzZv9SQ48xz+yeRVZOm2oGtpMJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2616005)(956004)(54906003)(8936002)(66574015)(36756003)(1076003)(186003)(38100700002)(86362001)(6486002)(83380400001)(6916009)(5660300002)(38350700002)(66946007)(66476007)(66556008)(52116002)(7696005)(508600001)(6666004)(2906002)(316002)(4326008)(26005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QldkZ0NkRTFiZXdVUzBqbUR6K3lZR2RWdVZxL2h0UUNEMHhrYkdyWXNjejVr?=
 =?utf-8?B?bjg0a243bTV5L0puSDJWQUlOSVZ4NHNZMGJBVmtkMVZBa0hJdElmcm43Nksw?=
 =?utf-8?B?bVVVNkk0aVB3NVhldzFZSHF0bG5JN3piV24vV0U5NHFsaEExN2lTVkFrOWk3?=
 =?utf-8?B?SkFpRFAyYWQ3MGRsRG9TZ0VOb05UQWtJcStTQnR6YnNLTDk3a2lISU1lZERU?=
 =?utf-8?B?WlV1MG5aZWVsNlowMUNkaTQ4MkpSOUdRdUJPSERxZWVvd1Jub3VVL1I5MVQ4?=
 =?utf-8?B?R0lidjE2OGMveERkM1YyVDd1akNuc1prQ05FSTh4U3drUS9OTmlQOEVWQ0cw?=
 =?utf-8?B?dXNkZDQxc1JzUTZFSm1ra0hXcDVIZUVzZlFBYUgxWTdrRVNnUjdzYWJCU3Er?=
 =?utf-8?B?L2ZxSG1GN0hxU3E4bGNlRTJPM0FmQWY4STQ4cjV5YkhHWjh1M3Vpa2ZkVGtU?=
 =?utf-8?B?UFJIK1JWdjJBdkc4MjNyL3c0TUFjUEdyaU8vSUxMOHBzNFU4VUE4aHp5R1do?=
 =?utf-8?B?SE1YQ1drc1VWU2YzVWEyek1GQmVUYlNIKzBpVkFkWUFmN1BVbHAzbzc2MldO?=
 =?utf-8?B?cnUyNWkzNmQvMENMeEJqb2YwKysrSnNqVlBMckh1QmNXNUFHWjgxN1lHSUdF?=
 =?utf-8?B?TjA0TTQ1ZlVHQUc3YS96aDVWRXVRNkhsbHFJand1aFF0Yy8vUTByLzNTQ1M1?=
 =?utf-8?B?WnpqeVVyQTlBKzVqMlllQjFacW8razh4aEZ2NzdPOFVMN1RsOFlJd3VQTTFy?=
 =?utf-8?B?czNLalYrM0szb1JuWGhDN0tOeG14RmhRQUIyT3pldGNlanZmdWxoeUFHbGVD?=
 =?utf-8?B?R2RxNlRGYk9wMCtnajR4VTBCTnJVRlpqOGJoWHFZcDQwR1ZZK204UG92ZlFB?=
 =?utf-8?B?U29WcFV1N204eDJCaU5kMXdubmRsSk8ycTQyeXJJVTdNSnpRc1lubVBlc3Z0?=
 =?utf-8?B?Tk12QnJrR3RUTVRBOWNxUVBYcmwvMjN2ZEJ1YUJ1dW92QkplS0g2Q2tsRFJT?=
 =?utf-8?B?NE9JZURCSnJVWFAwVTF3UWZNK2xPK3hiZGFZSnU0K0xyTFRJUS9MNlVoNjhQ?=
 =?utf-8?B?WEw1YWl3RmJHQVpEVmRzenU1bTZzMkpmaksxR01Cb2FwejMwSk1idnZaWElj?=
 =?utf-8?B?UERXelU1OVV1MXVBcHVJTDE4d2x1ZWZYY3hoMEZvRUpYeDNDOTU1V2twSUJ6?=
 =?utf-8?B?YjlLWUlZTU1TZGp1bS9xTk16NkpuZzBGTE9NcFAvVXR0aGkwUXhpTlhDNEVv?=
 =?utf-8?B?Rk41WXNlQ3dIakN1SzFONnpScHVYZ1lkMnFJbTVVQ0JGVnBKQjVVK2pyYkNP?=
 =?utf-8?B?clFZeE1ueGJIUnVmeDRPUXc1VG10MmdVdktOdGFsaWxtcDNEZGpVZmpTNllw?=
 =?utf-8?B?RUttUGIzV21xOGdwUHRWSXRoT2tBbzNoUXU2U29FQ0d5SS84bHAvQjZtUDcr?=
 =?utf-8?B?Q0QvRnB4aHJvb2VJcHM0QlZOYzE1UG9QQmZtS0ZMMzhUZFVCc01Rd3RqT1ZO?=
 =?utf-8?B?OUN1THQ5Q1dkaHJRUzNETm14Q1NQMFJhUktVR1EwcXkveUpoUjNoTGxaNzM4?=
 =?utf-8?B?QlQ2RnJETEd2cUhLb3NsZjlJZUdlWXg2RHAyb0x1YWNPVEQxd1Fqd05iNm5m?=
 =?utf-8?B?aXpVNUt1RG5FaUdRV0ZaOUlyUDFGbnl0dmExNTVrMG1WWSs4VHVIcnliNTBp?=
 =?utf-8?B?cHEvMWVrQzZXQ0N3RGpYWjRiMzdZaDdaQ0xmUGNYZHYveWlHN1FjbVV1TXpl?=
 =?utf-8?Q?lBOSb8WXxtv0Pu8nF4GUdlbSeRMEQTxHq8W3kG7?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7dfbdc2-178e-43b0-54c7-08d98807ab43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:54:37.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujRb6xkMYm9diwhvgB/j45yLXrdD6Uvf7cbmBua6SSBmE5uictTSAhW7ZzXceFdjluWoQTQ3/aySUZRfRO7gTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggfCAzOCArKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2J1cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAwMDAwMC4uOTFiNWE1NDViOGZmCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaApAQCAtMCwwICsxLDM4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogQ29tbW9uIGJ1cyBh
YnN0cmFjdGlvbiBsYXllci4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNv
biBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24K
KyAqLworI2lmbmRlZiBXRlhfQlVTX0gKKyNkZWZpbmUgV0ZYX0JVU19ICisKKyNpbmNsdWRlIDxs
aW51eC9tbWMvc2Rpb19mdW5jLmg+CisjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgorCisjZGVm
aW5lIFdGWF9SRUdfQ09ORklHICAgICAgICAweDAKKyNkZWZpbmUgV0ZYX1JFR19DT05UUk9MICAg
ICAgIDB4MQorI2RlZmluZSBXRlhfUkVHX0lOX09VVF9RVUVVRSAgMHgyCisjZGVmaW5lIFdGWF9S
RUdfQUhCX0RQT1JUICAgICAweDMKKyNkZWZpbmUgV0ZYX1JFR19CQVNFX0FERFIgICAgIDB4NAor
I2RlZmluZSBXRlhfUkVHX1NSQU1fRFBPUlQgICAgMHg1CisjZGVmaW5lIFdGWF9SRUdfU0VUX0dF
Tl9SX1cgICAweDYKKyNkZWZpbmUgV0ZYX1JFR19GUkFNRV9PVVQgICAgIDB4NworCitzdHJ1Y3Qg
d2Z4X2h3YnVzX29wcyB7CisJaW50ICgqY29weV9mcm9tX2lvKSh2b2lkICpidXNfcHJpdiwgdW5z
aWduZWQgaW50IGFkZHIsCisJCQkgICAgdm9pZCAqZHN0LCBzaXplX3QgY291bnQpOworCWludCAo
KmNvcHlfdG9faW8pKHZvaWQgKmJ1c19wcml2LCB1bnNpZ25lZCBpbnQgYWRkciwKKwkJCSAgY29u
c3Qgdm9pZCAqc3JjLCBzaXplX3QgY291bnQpOworCWludCAoKmlycV9zdWJzY3JpYmUpKHZvaWQg
KmJ1c19wcml2KTsKKwlpbnQgKCppcnFfdW5zdWJzY3JpYmUpKHZvaWQgKmJ1c19wcml2KTsKKwl2
b2lkICgqbG9jaykodm9pZCAqYnVzX3ByaXYpOworCXZvaWQgKCp1bmxvY2spKHZvaWQgKmJ1c19w
cml2KTsKKwlzaXplX3QgKCphbGlnbl9zaXplKSh2b2lkICpidXNfcHJpdiwgc2l6ZV90IHNpemUp
OworfTsKKworZXh0ZXJuIHN0cnVjdCBzZGlvX2RyaXZlciB3Znhfc2Rpb19kcml2ZXI7CitleHRl
cm4gc3RydWN0IHNwaV9kcml2ZXIgd2Z4X3NwaV9kcml2ZXI7CisKKyNlbmRpZgotLSAKMi4zMy4w
Cgo=
