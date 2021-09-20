Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6EE41193A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbhITQOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:14:55 -0400
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:4704
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242488AbhITQOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 12:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfisY/rp0PhYT9gOpFjuy9Uk045UHLNEdDKWApYT0wziqgtjmG5Z8+Qcjuslxmv3Y3g9QfHcqBpfY4l5012hG3pyUoClzXVLNX4v/qKx4TNwK6QgXQoDtKAAj6gNb7IaO/J7MAg/yrbNH1eCEfF2VOxHrZppFHhVx/+FhqCskWXhoHX7sYZxnGWE4T0ucG8uBDCEBb7+ZHjtmRkIgSuKeNIy8tAFUbvFToEzXPG3AScZmQ8IggWboeKazCynfuPrawqiS4nZlgyvFmFYJS82OIicaQmgp4ZzI/h6B/tJ0C7M31EBKRquWbAxPUuOXicsVlG54U0zsYYYOgLfAZlgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B060dwVEfeTW4dRn140ZNuQdsL6yUQFgWMlzSPffF14=;
 b=k3XEYUcEa0xsp4UHlp6XIp+URFi0TcTtaKyHSEe0NlUrYuqkCUXGvPVP2CQlewCy42JxbNbh+7yFt/WCE1adR+l9bycBlsUvQYasE9mBCu3eTMQmEFLkhuY4SCtYTnd7+nV4UWWwvlRN++f0IA/G0eq9dHPWuBMif3oUfrJU8N6tig9DGNA8dhndGrB0zqrBreR1Ux+NSZItkFRwhkIWAMcGOy/bPJ8k4OotRoRbHTXpRSiBpbkrE/piBL7H5tSrVKnbm8KjNoJE9wMzpqDuaQyAVzqilxj/rTVCz5r6pM7QU+FLUHkViLTOZK523f8k4k9dRsTDC0vpyl9DdCqYvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B060dwVEfeTW4dRn140ZNuQdsL6yUQFgWMlzSPffF14=;
 b=SPsjqo2sYZd4bNRpR6HnYIRLWBSvKdAQjXeWap5SFA27cVHv/f5Em8ttYqc9fbzTcnxKCuT2SD7ulRwi95yCiX1f/pv3y8d96xZ2mtjAb1zwFCv5iV9meXf48IKMPNbpD3bf3o35hKoRLAkQF7vDy7iTm8OImXaWeQF8JLkeoY0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3168.namprd11.prod.outlook.com (2603:10b6:805:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Mon, 20 Sep
 2021 16:12:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 16:12:33 +0000
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
Subject: [PATCH v7 16/24] wfx: add data_rx.c/data_rx.h
Date:   Mon, 20 Sep 2021 18:11:28 +0200
Message-Id: <20210920161136.2398632-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:806:d2::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA0PR11CA0064.namprd11.prod.outlook.com (2603:10b6:806:d2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 16:12:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ba37bf1-be34-434e-c9a2-08d97c517443
X-MS-TrafficTypeDiagnostic: SN6PR11MB3168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB31680AF6FED47AE6988E160B93A09@SN6PR11MB3168.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMZLNYJbLXeRkBoW1R57FH4pVX+Hd+rxAys2z6z6YKGPERJHEQf9GRNiWRkuUQE2aicstgeBbGlVa1Ts59kIGQJ+/aEznqUcGUqDxj/nCteBG2SK3VCn/ct7JJBVFPydJ2dbRPvUJg94QVlLZm9U5WZc7YsH53nfOJk03WonuV5+spz+94Qk/WymUeHmcosK7d6NuS/PO5cEGFyxJWEGz14zDVeBKi2ZVfq8UkCscmONgMYRwzU0wtqReCaUWEVA+X6HCgxlFgJP98bn7uE414es6GtlZabgzL/K+FOwB8LK0MIP5Sg0Cchrh0zD/uByNmewBlmVBJFwvL/v1oPmBgFGpQCwESdXQctdmZ23EcaYXFGoO6TwckinBxyGeo+IToWh0SMuRtFRhgrCRquhMYR3jPudOPhHaxE3tpEnk0Nu6HqtQwnDIp/Kb7u4vxQjU/KK+udQ3jaJp1QGA60nNlbKcFRIw+fSrCU3202x6kP2yo/zrAZiteDUjPkWPprLDA++2L/f8NKFmnqOg3Y0gfE09V/bdsLWDFsrg3tqTMTX8kLl5kyzqeT/XRZJkbr+9HFZT5r3MGmSkRcg5MpL8AX/ervVJTPHLR1sbZ/xQMz5LtEqWd8d4ZdKR0RYKvuuUBfzIfHmjp9ElzmyRUSJnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(6666004)(54906003)(5660300002)(8676002)(6916009)(2906002)(38100700002)(8936002)(107886003)(52116002)(186003)(66946007)(6486002)(66476007)(4326008)(36756003)(2616005)(508600001)(7416002)(66556008)(7696005)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: y9XphkNrew3dqm8kmObPi4QupnJb8i63DfrzvMPojOf2iDsLAKdOK/Shz6Z4bOB2BpU/QsC+7uY810BEKlOFpCJTbI0P+DSNdS7X70ofIE5mcxi6Kpcx/PC86AGH+2rj0LzuqTLZqxgt3yZAENO+x1QqVoN2biuVGkA4H2ffxAYlq2D/zkOATmItWxETEjLgqSCs2Y926VtG+iF71jtl87cdE4UZzMrNZMi16HPU6hrV/Nx5EOWeskESMjV7FCn68izAUCIUmhME1qIvlbRRslUyWSd4V2/O10qaIcOpml6EnhlsENN1rVM4O5GuO1MK0UyZNZ6LhIkImoedtUDIczlUy8mEsJUrmAjWY+Re1hFoBCFddlBw6wcBJ/pi+4LMoQzlIr9AZGnjyIf1mRnIefk/uXJbO60sK8A/BxYuaxNZI0bPGewfT+dL6fWDdajxua2b3YERtUmuxwUrm5HVNgmKw8M/lAF6yOXNnyd/ZphJAJNgg5OXnHVyIl9c2K7Nq287y96mN3PfhroBM5/0llZYk2GhHCn3iaZVJcKzy3+b7dGJV1zupo3OSrZvnNQSh/IJNOBTWHxvRrTKuZCaGmBdzQQMmb3yn91PveGSAzo8p1zRNZIl+UHN9mWdYBMj4IzR3j/u6/3APT4yU1Y6vooP27P7j2yYUjNlJlZliff3VbNhSQpt6l5/UAvK0iaMu0CGBb9CeXpfT/glNHF4ohE+Pk8L8wCmfsLshFREgW596yMeCRT9BVBfsowOpwslmiV/zTaYg4Bpf/EN57p7WXBlCBJOhndamZtt+grJLLC4ukH5ISGr4T0jKAhOJLvc
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba37bf1-be34-434e-c9a2-08d97c517443
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 16:12:33.7089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRi2RGdZU2KJSnZQQAVxcX70WmxLigozZaQNE0D6fij91QuYMJIRxduDLc04WEzC3Ng/Mt6NVrsaWPaMfRCDcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3168
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTQgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTEyIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmJmYzM5NjFiN2I4OQotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhIHJlY2VpdmluZyBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMp
IDIwMTctMjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykg
MjAxMCwgU1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+Cisj
aW5jbHVkZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVk
ZSAid2Z4LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZv
aWQgd2Z4X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIx
MV9tZ210ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVy
X3RoYW4od3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5h
Y3Rpb24udS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJB
X1JFUToKKwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEu
Y2FwYWIpOworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNL
KSA+PiAyOworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwg
bWdtdC0+c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBh
cmFtcyA9IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlk
ID0gKHBhcmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlp
ZWVlODAyMTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlk
KTsKKwkJYnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKKwkgICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYg
KnNrYikKK3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NL
Ql9SWENCKHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVl
ODAyMTFfaGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChz
dHJ1Y3QgaWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXpl
b2YoKmhkcikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMp
CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVE
OworCWVsc2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4g
PCBzaXplb2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndk
ZXYtPmRldiwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQor
CisJaGRyLT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjEx
X2NoYW5uZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHIt
PmJhbmQpOworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2Rpbmcg
PSBSWF9FTkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0g
ZWxzZSBpZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5y
eGVkX3JhdGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0
ZTsKKwl9CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFH
X05PX1NJR05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZy
YW1lIHdpdGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlf
cnNzaSAvIDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkK
KwkJaGRyLT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLyogQmxvY2sgYWNrIG5lZ290
aWF0aW9uIGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJICogcmUtb3Jk
ZXJpbmcgbXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwkgKi8KKwlpZiAoaWVlZTgwMjEx
X2lzX2FjdGlvbihmcmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24u
Y2F0ZWdvcnkgPT0gV0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgw
MjExX01JTl9BQ1RJT05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOwor
CQlnb3RvIGRyb3A7CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcs
IHNrYik7CisJcmV0dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQK
aW5kZXggMDAwMDAwMDAwMDAwLi44NGQwZTNjMDUwN2IKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisv
KiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YSBy
ZWNlaXZpbmcgaW1wbGVtZW50YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAs
IFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVy
aWNzc29uCisgKi8KKyNpZm5kZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9I
CisKK3N0cnVjdCB3ZnhfdmlmOworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsK
Kwordm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0
cnVjdCBoaWZfaW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYKLS0g
CjIuMzMuMAoK
