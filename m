Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F9333B3E3
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCONZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:25:44 -0400
Received: from mail-eopbgr700069.outbound.protection.outlook.com ([40.107.70.69]:1217
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229746AbhCONZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHFc7rqTc//REprj2arqRyNZEydWHmTlVP3b1jd1P4db5n3BT46SGv3TrltNFcW/dMS/+CJqCWU8nEYeJeK9lUQTVMFVscU0fc3HbDvOZEYHr0sBCTokPkhBP198aSRSDjvAnF+mcDVAMLHwIWRkpi3zYEeKqF8MVUFmogYqxbGO2pHQ2j8PiX/vIEsQ/ww2hYkO+lOjpEGjbMD6fynXfoSJzyoqJcakcoYAa/1t/z1js39ocRg1w6EylufO4EkHccOhaWkB+IMGQbcZLGwUIcJ8nk+ZKsZiY2iu6OoOYAgRs+REdRSZPO59ZgD+aVeWJhZhvLmkpcwtpGMGn/PmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ADRqIU5wHdazPyKRxcztrHu28gHVw/I3NqJUDoR3lc=;
 b=XTgwLVsP+mILw3pPy87D6q5vgLPHxLrIWgXT4OxGKtMoGE9k+/VeIeQGcdi3DIvkVX40FbpObH/H0FMPliDovNQ4E7E8PE73Wskzf4dG2rqLBDhtse+saGR24svLv6lV/dQYe9DM858b3BRUcxfEYzaruzumtbp9FL0C9KWuGeMFGblqYy6S27eL6EB1E7HLVZdVu2S1LmK7eimNIsz14Pne8JmH5cR314+Puj3SU3KNQDFDk6Uv9fIyBQtOOidKCXHrhDr22Hr1uGbvt/vlmtM+Qw5h16SQWmvBhekaUe/6LcHpuslrUBBXpTBTgLXL0lTAfrUTjSd3U+w4r1A2jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ADRqIU5wHdazPyKRxcztrHu28gHVw/I3NqJUDoR3lc=;
 b=FEFVVqel8NNuovQkGNRW7s7iVC8Nk8illeAoyn/6APy4t6CXt65A5D6TYaGu8t92yVN/YkAq6eHiLa8CpJvj5E/S8GAhdBoOoFiRI94Eq3dMNzQTgYKXbJ/e4szNdzjkSVfeDpEx6fxPNoDo7cWeQecAYBJE/slCzTcGBi+M9C4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:25:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:25:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 04/24] wfx: add wfx.h
Date:   Mon, 15 Mar 2021 14:24:41 +0100
Message-Id: <20210315132501.441681-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d03887-c193-470b-fc99-08d8e7b5cf8d
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099F2C58C4505C486D9988B936C9@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HydE3vzJVWrmmskyd+IZ5PTeTPsQsJbPX7zGnYSPnXmf0U+Nirw84q6xbIoL+qFNcWkeu7u3fYQmc3qKEpl9ty/YIAb8ZMadcE7gwzoTiILQhsuCX1WUi9KetXIsWo4xUaiDbOGPmFj98hsBlip0gdHYyEAkjykQRUXa+gVcMBCyDlvRZ6HuLY4uM0xS+t5M+fk6YG/O/V2BJ1sGXf0uSJ5iKO51V7Rnxu90GmeO/vwKujGeASjy/hOpPWnTcvvKUzX2Z1vdFOBtW1sMzO2O7Xe728A8+6g7NuJWfjXUiFqzfGwIx7uy1chkeLyHg02oCCxrgPQ8oYiZGhnxwdDcT/urbo/GUdK6q0oQ4qr94XED9Yb0+OrllckHFtbXpNBZD5paPawzngydI33OG9dc4ao5hCstopcpOX79wYuQHKwFArHNqUwJfR2mrInSuQwVact55vfWSAg/Swer+6javzM4M28S7F1z/jdkHVComQuphbsMgsB4rEkbtD/kUiO35ce6jKU65E/XWPuD8dTWdVHSMIif+rrAvTjZYLkeFxZbW5UEqzMp5zrYzIMkm4/J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39850400004)(376002)(366004)(186003)(7416002)(2616005)(107886003)(4326008)(478600001)(83380400001)(16526019)(66476007)(86362001)(66946007)(54906003)(66556008)(8936002)(316002)(5660300002)(66574015)(8676002)(1076003)(52116002)(7696005)(6666004)(36756003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WlZ4MTFRY204MEtrcHpNRzErcmd1T05Ld0llYTIyeVRCZHRPVGtBWlI4dHJx?=
 =?utf-8?B?S3ZBNkV4VFI2STZhYnlvU1pjVVhIOGZKUEtMeTJZVzZ2Y3lSZitPMVE0R1J2?=
 =?utf-8?B?bmhrVDRpT0dQOEVEY0JSUGIyWVRWQnJDR29NZDVzSUVKUTU1Z0JYcWxhdmVs?=
 =?utf-8?B?OURBNE1BWHhYUWVaTTdtRjg2dmhUSWdjSlZwdGhhdHZOOHc1QVptaEoySEhE?=
 =?utf-8?B?Wlp1ZlhBRzdYYUpwRjZXYTJVOGo0cm1admZGZ01nNUJQbEdaSnVYWkVFamNK?=
 =?utf-8?B?Qlg4dG16LzBOVWNZY1VtTFFFTDJRYkFmMGdEM2J4eFp4Mzg0dnlFMXhITTZ2?=
 =?utf-8?B?a1dQSHVrWGwrRk1jeWM1VEJDRUNNSlpoOUZ2a3BxeDdIWTZBNzRSUkhUSnVn?=
 =?utf-8?B?bmhWUVlwMytNejBjTHg0Wnh6Zmt3VGVGQ2Nyd3BYZDQ5cnhIYldHZWxoZm5r?=
 =?utf-8?B?YXFmTHd3NEEzaWpyOHcrZzlYTlpxRVhtc3NqM2ZKTW91Z1Jkd2dnRVdpTXc3?=
 =?utf-8?B?OUZjcC9YdTdJMTlCMVBEWTlZMkRzdDhMcTFZMW16ZUlNa2tINGRSa1pkRjNt?=
 =?utf-8?B?a0YyMlZoS3Q4dzYyY3hQRXRBUTd5NnIyN0N0QXRCeTh4dWtwQXc3ZDgwM1BH?=
 =?utf-8?B?UTA1dzhWTVZUV1J0VERyQ3pST0ZTN0dqTkN2bURWQW1aODZBL0Q0NEM1ZWk2?=
 =?utf-8?B?ZW5RS3I5aXMwcExEMk9IcFNEZ1h1dU5mUlRpbE8xTzBZUUpqUk1VRTRvSk5r?=
 =?utf-8?B?K3lKZjEzT2RRNlp5NUV6RzZ1bitHU2dzejFOMk01SkFLZytyWkozWm9uL29a?=
 =?utf-8?B?cHlMbTJMM29iOC9NNXBGYzR4Qmp6TU10Z0VhVHdoenZKWW8rZFNNV0dEMlNo?=
 =?utf-8?B?enFuY0k1SkFmU1lvYlN6Q0NFenM1ek5Xa012N3o4WFZPbGJkeU1XZFdGRUQr?=
 =?utf-8?B?OENMOW1ycEE5WER4NFQvd09keDhsWUNFdnZqUlY3UjMrUUhyR2o5MUxJMUpK?=
 =?utf-8?B?b0dRdnBlcTVoKzM2NmVnc1M2Ry9oU3BLMTRNdFdlVEppc2pxYnlGYmJIYjJl?=
 =?utf-8?B?ektlcVBlbzVrb1UwdjFVQk13Y0JJZXRBUGQzYitoTW5sdTZKYTVXNmpnVnBq?=
 =?utf-8?B?NXY2SDJrcGRBQ2pVVVA2Y0hjMW1GZzdUb0RGWEwzMFM5MlBEMXFMSjMwdnNR?=
 =?utf-8?B?b0ZFcFdPWXVUcGYzKy9QY0tlSTRhM1MyWTdybDFXNDlxU1ZTVkFqSEJjVitC?=
 =?utf-8?B?alFRUnkxWUhvbVFHOGxIOXdmQnlPTFBJdHVrQTNtNEpzWWI3ODBTQkdNenhU?=
 =?utf-8?B?Sk9STzE0UDNMSWlhbjhqVGhMTXNNd2c1VGk4KzQvVjlxcDdKQWhySENuMWJ1?=
 =?utf-8?B?czM4dUx3RUdmbEYrekQzTDZ2WjI5VjB5LzkxcnVCTm9hTFhnZ0NISGJwbWh4?=
 =?utf-8?B?emJnYi80VGtPUjduS3FZTkJvSkFOSDR1enpaUmRNd0dXcFVBM2lvVFYrTmdL?=
 =?utf-8?B?N002WmJrM2dHbWp2TS9uMzBWakdtNkJveHFUVldnWUdua0ZpLzhrTUFJRjBQ?=
 =?utf-8?B?VlNSbWFMd1lINFlJT3JNM3ZJKzJTQU11RVpRZzFqTllYQis3bm12NjRQSnVl?=
 =?utf-8?B?bTc4VjBTWXQ4NlpqRVpsZ3B2Mmd5QXZwSEVDWVkyUzBJTHRCcGE3eUJZanN4?=
 =?utf-8?B?eGpoeHJnR3QrcDFZTUpoTUhlZ2NIMmxkQ0tOb3lrQ3E1YUgwQ2NBNU5tMWJW?=
 =?utf-8?B?TWdLTC8vS1NNQXdsanJWOXFWeGh1alV2NzhVMUkrR2hnVXBFUXpjREhCSUkv?=
 =?utf-8?B?cWkxMC9zTWttYlJ3cHBMbkd5MmdVSUc0UFltbUErTGNlbFNVdTdMTlBJK3NJ?=
 =?utf-8?Q?LQ1L2TT/FTCND?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d03887-c193-470b-fc99-08d8e7b5cf8d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:25:33.2659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UomSnkgcdqLr+fW4ewqzkTDuUA7FZ0V50FzGh9py2wLY+r2VDU08o2IaUknXMgEPmtzhcaD0fyFWSSAxj4qQWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLmJhMThiYmZhY2QyYgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjYgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhIGZvciBTaWxpY29uIExhYnMgV0Z4IGNoaXBzLgorICoKKyAqIENvcHlyaWdodCAo
YykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29weXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxm
bGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAqIENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0
aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29tPiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gK
KyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRl
IDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUg
PGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAi
YmguaCIKKyNpbmNsdWRlICJkYXRhX3R4LmgiCisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUg
InF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAz
MiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNF
Q19QRVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdidXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJ
c3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJ
c3RydWN0IGllZWU4MDIxMV9odwkqaHc7CisJc3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsK
KwlzdHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19v
cHMJKmh3YnVzX29wczsKKwl2b2lkCQkJKmh3YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlz
dHJ1Y3QgY29tcGxldGlvbglmaXJtd2FyZV9yZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVw
CWh3X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNv
b2xpbmdfdGltZW91dF93b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96
ZW47CisJc3RydWN0IG11dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhp
Zl9jbWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVh
ZF90CXR4X2RlcXVldWU7CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0
X2lkOworCXUzMgkJCWtleV9tYXA7CisKKwlzdHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOwor
CXN0cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3Bf
aW5mbyB0eF9wb3dlcl9sb29wX2luZm87CisJc3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2lu
Zm9fbG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYg
eworCXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOwor
CXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJ
CWxpbmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJ
am9pbl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29y
azsKKworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9j
YWNoZQl0eF9wb2xpY3lfY2FjaGU7CisJc3RydWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxv
YWRfd29yazsKKworCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNp
Z25lZCBsb25nCQl1YXBzZF9tYXNrOworCisJLyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBh
cmFsbGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3
b3JrX3N0cnVjdAlzY2FuX3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsK
Kwlib29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nh
bl9yZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisK
K3N0YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+
dmlmKSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZp
ZjogJWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9p
bmRleF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+
dmlmW3ZpZl9pZF0pIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1hbGxv
Y2F0ZWQgdmlmOiAlZFxuIiwKKwkJCXZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1
cm4gKHN0cnVjdCB3ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKK30KKwor
c3RhdGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZl9pdGVyYXRlKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LAorCQkJCQkgICBzdHJ1Y3Qgd2Z4X3ZpZiAqY3VyKQoreworCWludCBpOworCWludCBt
YXJrID0gMDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqdG1wOworCisJaWYgKCFjdXIpCisJCW1hcmsgPSAx
OworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQl0bXAg
PSB3ZGV2X3RvX3d2aWYod2RldiwgaSk7CisJCWlmIChtYXJrICYmIHRtcCkKKwkJCXJldHVybiB0
bXA7CisJCWlmICh0bXAgPT0gY3VyKQorCQkJbWFyayA9IDE7CisJfQorCXJldHVybiBOVUxMOwor
fQorCitzdGF0aWMgaW5saW5lIGludCB3dmlmX2NvdW50KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQor
eworCWludCBpOworCWludCByZXQgPSAwOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmOworCisJZm9y
IChpID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXd2aWYgPSB3ZGV2
X3RvX3d2aWYod2RldiwgaSk7CisJCWlmICh3dmlmKQorCQkJcmV0Kys7CisJfQorCXJldHVybiBy
ZXQ7Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBtZW1yZXZlcnNlKHU4ICpzcmMsIHU4IGxlbmd0
aCkKK3sKKwl1OCAqbG8gPSBzcmM7CisJdTggKmhpID0gc3JjICsgbGVuZ3RoIC0gMTsKKwl1OCBz
d2FwOworCisJd2hpbGUgKGxvIDwgaGkpIHsKKwkJc3dhcCA9ICpsbzsKKwkJKmxvKysgPSAqaGk7
CisJCSpoaS0tID0gc3dhcDsKKwl9Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9p
ZCAqc3JjLCB1bnNpZ25lZCBpbnQgc2l6ZSkKK3sKKwl1OCAqYnVmID0gc3JjOworCisJaWYgKCFz
aXplKQorCQlyZXR1cm4gMDsKKwlpZiAoKmJ1ZikKKwkJcmV0dXJuIDE7CisJcmV0dXJuIG1lbWNt
cChidWYsIGJ1ZiArIDEsIHNpemUgLSAxKTsKK30KKworI2VuZGlmCi0tIAoyLjMwLjIKCg==
