Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B59411915
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbhITQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:13:59 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:21537
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242528AbhITQNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 12:13:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iO1chGQmT58B9Jh+R00LK5mcpfIOi7PGaN5ro74Gde3J2xuNDEPN5t4DgvPswTjyrL7sVHC0Nr297ndTjrtVnhZjpiphyvVUz27/oHHLjwsdY+SREE0bp0aoDPH8kg9GdH7+Lr2ILx4JyZ0P6N6fFTP8nxUti9xGNDoJV1OfNJSg8Y0vugKFXtECYBXTdDEBnXQ/N6O2tBZcsCu+jT6fjD6E+4khwW8ubQxtHFGJP03enjQe64v8sapjjkfHOhPGfw0+8gJyqcK2amorq6j8AZl/A6wAdOz80UvNUPo5BfQiZzjlVLv6R0t0dghlWmigaWAotfM3jJVXu2+K9abfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=51XqWHJtByRQLPsnY3wtzpUPOfwDveF+8mA8Bal+JXA=;
 b=J15/oONrpof7TklhtN9Gsg47xvksyl2YPGiy1HcRQuVIUzsIpWl+W2ExminVbt6si7oX4oHYV+EqNMqGnRuUa60q91rS/xOAQ9F3KvyEOvtoWzLNf4BtPgwZG+7OEN6YDtrB7N7EZ5zZ3K+Xk9TIzBnKwsd/UG37jgnvaoyD9riaDYBUjxQYeaUMu2o4rHOAxTz9L2ZnwbnBD0tyERuvK3RBi1KYYI6iJVu3555L2NeaCvwNoISWzqhtwxg/jI4FLEnvGz1cKDesU8GLb3mmTfzDuWLPK+eFiuuVx1bB73UY+QX+BdV5kz3JL4TlhzIolr7OjJwPCmUoRV0ir6T4Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51XqWHJtByRQLPsnY3wtzpUPOfwDveF+8mA8Bal+JXA=;
 b=E+LuKdBVpvgS3FS1jn1Qlts2IM3YImFG3d2OYFq2tTEzwaQqV54ssGh6cRodk7obtBRn9b9SnyB0q/9BEsTWfIocrmPJfwAiMKuEe7P1/fguTsjIc5vsHuNrHV33hYfbX+Y9XtxGZcS4DCjDdMdGF+TvBr2NiDCYJCTuEXTc8k8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2557.namprd11.prod.outlook.com (2603:10b6:805:56::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 16:12:08 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 16:12:08 +0000
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
Subject: [PATCH v7 06/24] wfx: add bus.h
Date:   Mon, 20 Sep 2021 18:11:18 +0200
Message-Id: <20210920161136.2398632-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:806:d2::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA0PR11CA0064.namprd11.prod.outlook.com (2603:10b6:806:d2::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 16:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0e2b772-fe34-43ef-0172-08d97c516517
X-MS-TrafficTypeDiagnostic: SN6PR11MB2557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2557DE38F9CF180B52EA3AB593A09@SN6PR11MB2557.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0r0Iq+B3KsCuXeQMcuB9nxxH6F+dOgvu1kZ9iOJRggGNCgxGOzex4L0Xta5Uas9l0u8I6VlTOWIQVbXljAFQkQ8xUjgI5NvCLVgMAFcOGWYUtS5qntPDihBdcMI5GX5QRjja/DXfoGpM+nBOIcXtBgkf6pxtbh2u1YA0YZCga03//p1sgtlPEnlxZMTEmJqQSlP+b+Z4i4AxfrymCV5Kj4VLLutW00Dm/VQvrHBum4R1/m48WTRRw99GH+4EZo0eh2FYms5wIBt3dBfJDebgezRk6YweR+Z+xJo/LdbCxfHsMGNYtYPyQaIih9ExZp4rkfocfUjAizNdFsH9Jz8Jmyls5fALce+DUn93+u0a5osBY4lPy0YP8YEmvGLPGfMg9EYGzzjHk2LXwESgZn4LhKn2DhPY+amM/hBn+SSVAPqCrxsU7EZRpGGQwo9WA+gWT2nsDJ+B+XWp2Tapcnqk4g7yQ02miThzkr6CtB617gdaJz1bN7FWlremCuj4ayo+m+UtHCaKKW40+zUNU+kJ9c/D/Wc7LZdiHZ6rqPxKGVxNybJ1GqKcxmSWDoDlBBoCbRsE8kQnpJwSIVJsvjJghLbjFEu4jFB9CvULhhAQCBBDdxNL8kxVHi+CWr4eDKF2Ro6VV7d4Jzl0WrfZpSVwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(2906002)(1076003)(8936002)(54906003)(38100700002)(86362001)(6486002)(36756003)(66574015)(478600001)(5660300002)(7416002)(6916009)(186003)(66476007)(2616005)(7696005)(6666004)(8676002)(52116002)(66556008)(66946007)(4326008)(316002)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: Ve9up69E+6hm+MTzWUH/niY37VJ+2PnOOo/aHaxKTVjcibVJErrQDahFIYsSnrSO3jMsIZwoJE9dKNn0HxXjF5xpBUJQgbI9CH+rrnUXljSPgbBV/SlkgvM3WSsj6vZrefmkk7QAKYWbDeWZOXNWOFqDxUXNFG1e9ZgHNy1PZdVvEYeidkaw/XGyLbNIU0psR9vIRiNt/Zj9gATATETdG2Yh0FtFcqpJLcq8sYvYwMJmrFGuCbcD/szaW0POOwxxU/3DbK0He8RkMoKIX9PnJeicF4q52PEU4k/sZvmvXuh23vnp/CQblVFGC9Ur9N/2AqMuVTm01Q01C1EsvK+jA4C/tNBQX9mbF580eJ9CBeSuYXI3Z9KcGnDDa4k0jRn2U+nWHnULakDTrVoJS+Gp5dS6RTyCJanfHIXF6D/A4LRoNEkjggX9m3oHLr7M2cuvyKtJEOXpx7Pj9RGnISRhtgt5kMAVnUh2UPOyFk+gmffxPsBbbTaziEL4lS7FtSMT24m2dNhEunNN7TrFt3DQrqCQwI0mQaMOhiOtD5QeMZmfjwjxrL4usbCCPm/Px3jlc49R2LfbyAT8hiWepdNR2yIUGCaB1S3Nv8XbpKuJO/P/ewAYO176Po3jhRDNOSlqMPm60cSgO4QFUkgSE69E3dLXZculDeEJQufaKC2zysQumM79Y8v4eX3Ic74I0NCGiHDC6n8XiDRP8c2EN2PM4qGBgifuFXpCb+PHf/URNHrGJESV7AQQhl72M2X/ojV3I4MbV3zc3ZBSgczH+nQRDzaSTUE3F8jJQd74VB6Q7bSXTSmPE71LCnrXbrV1sqfh
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e2b772-fe34-43ef-0172-08d97c516517
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 16:12:08.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vl1djcmqEzBA6sSmyTG0WfMehA/ZM3RcLNzIpDiaqo+dsPk+hnUKZb7RSTkkuurewLSKJLt29vR6i2YkPwlL7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2557
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
ZGV4IDAwMDAwMDAwMDAwMC4uY2EwNGIzZGE2MjA0Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
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
aHdidXNfb3BzIHsKKwlpbnQgKCpjb3B5X2Zyb21faW8pKHZvaWQgKmJ1c19wcml2LCB1bnNpZ25l
ZCBpbnQgYWRkciwKKwkJCSAgICB2b2lkICpkc3QsIHNpemVfdCBjb3VudCk7CisJaW50ICgqY29w
eV90b19pbykodm9pZCAqYnVzX3ByaXYsIHVuc2lnbmVkIGludCBhZGRyLAorCQkJICBjb25zdCB2
b2lkICpzcmMsIHNpemVfdCBjb3VudCk7CisJaW50ICgqaXJxX3N1YnNjcmliZSkodm9pZCAqYnVz
X3ByaXYpOworCWludCAoKmlycV91bnN1YnNjcmliZSkodm9pZCAqYnVzX3ByaXYpOworCXZvaWQg
KCpsb2NrKSh2b2lkICpidXNfcHJpdik7CisJdm9pZCAoKnVubG9jaykodm9pZCAqYnVzX3ByaXYp
OworCXNpemVfdCAoKmFsaWduX3NpemUpKHZvaWQgKmJ1c19wcml2LCBzaXplX3Qgc2l6ZSk7Cit9
OworCitleHRlcm4gc3RydWN0IHNkaW9fZHJpdmVyIHdmeF9zZGlvX2RyaXZlcjsKK2V4dGVybiBz
dHJ1Y3Qgc3BpX2RyaXZlciB3Znhfc3BpX2RyaXZlcjsKKworI2VuZGlmCi0tIAoyLjMzLjAKCg==
