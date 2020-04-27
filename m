Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACC11BA50B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgD0Nln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:43 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:26048
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbgD0Nlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UICqT+9rq4c/5qgq+AqBWi+MK59BcOw490o43dUWW66Dc7bRlT/OE96sx7yoZws5yHRbl5TrfKyP3HQtzec8unZKSjHmhXeC1v2m/HddMO8C9Z3cbgbNg7HQEXN5Qz095UXCEwWFZs/p11K/F3SHvbHXUwwQqirqQMMx39a0pm4kgKUNjnij6qgNI2Y/a4R0pifUEoaxk/jIY/GfOU4n0WvW4yIGh0y3qwwKTft2PA6rhV6oT0fL0c+/mRfkf/FXZjk1RY9gWIs6gYZ/DoIzU5uveYjB7ptpaFJ/MbiVTMKnXvmWZJaQlXzgJYj7odW+KMjPUJpNVtf5GJ/nCyzQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4/GjzrCFiTbCEHiqTUBdkSPriUhMCEf9S0AkojpW7U=;
 b=MBR/wXn6ZyeWv88qERfdGXYCSPU3XL5EOhdIhVfirNQxwZjThxlVrCidTqQ7d7DRNOWYKM9EIqAF5g6mbn08CVPLgGY2lH6Y0YzSwNPJ7TBIGxHwPRCFU5TLzCtxKwgs2bFfUKmYRJH6sAspZd5MLawxC3WH6vmnVLPueqiIKkvpuMONOGsdkusFg0mt2TyNFGUAIrtAxAEbtrL+EP6sFKM4VvHF3m338oe7eEoQW3x2CVGWWCp+dGXXWVsNFz0eD9c49eiOZvJ/hnpi9Soz0Dc1JXO3DGOue/NxcpQLek/rRmqWwwvHE5sMPn48i8KfowAHhilj6bZ7brAtJS9leA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4/GjzrCFiTbCEHiqTUBdkSPriUhMCEf9S0AkojpW7U=;
 b=X4DyRizGBV+fpntuDSsI3I5FnSPtkCRNuPdAB6d6QqNJX4OYvr40ALBurzUxrcaUDvljFEnZSA6vSkkh99Iw8ci0Z5Bbdq2EENLa44gHs1/TeoOPt26YyEjS9XFoTihdgfWanAY1M5z4eR+PTH7z8oeNuwBX4SfEa43xY6FRq1o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:38 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/17] staging: wfx: update list of known messages in tracepoints
Date:   Mon, 27 Apr 2020 15:40:28 +0200
Message-Id: <20200427134031.323403-15-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:34 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4b9079f-3866-4906-231b-08d7eab0b5a1
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424A897C221CAE21893279D93AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(15650500001)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbShc5w4OgEyQbaWGdk4fr6qih4y8tlox4MGCSqefacAjzlRLTX6h7lWlJyIseNSRUdJyTPg7CScrytSzP99ThWz/3ahbBzHRa63PFukUMX5L2HEPc8J2nmLFrQ7uVmkXZM5JurTHIxMmn9zzeQFoaHqPZoH/zj8kURPAIzH6Mm9U6ntSeXUNlQV+8Q/n9SLzm05m0xLSd787Id1SGcfl6N+FAaYlItdyViQyM6LHkMqKV8uXFA022vY+n7Un0xpVSiyRA2cSAsE+Z6DO/8JKwCDoaOXusuhwakbg5k/FJl8KeBSvUdUP2J/sE8KLDYnn9nbliiFEgz/txX0hqNk2HdH9RTpB7lq30AWtu8DtNYfrre1XAHQL5G9IskbFF3JI1KHuVeFKK/9fc7838iQImVcxpu9NLE0ydCjdB72HX25RSPZBY5CneKAKJ1bVl1d
X-MS-Exchange-AntiSpam-MessageData: 1chnTdK9BOV2MpXqa5F29XRxUwKQDka7YjQRZ9hf8z8+Jwo/WY/ZYirHDC7ZEwJ3S0lZ2D+UdUdMYGBRATp1pHdFnqeK0MxQb6V8Wr4qLYoLpXLeFOsnnOLp8fqXxuNgJ9Roao06CVhVJpzrasmaCcfeZDWThMvg+rwLU3dA/dM5zsEBdHlSjzR38E5MuGlVd/xzBOt8iCwRJO08ICu2cWFfU8SBH3wIB8/UGFmKEmbljDTczCzPzxqdmbyy/Z8JXKDkRlRGKmbYkXjCHD9el9JLhGEYMZNs8pNmXedx4YZJ/Q+VG7vSOn2YsTXd/gL4xFVXjFBdscppS3Qz2sO7/iYFMFdLe1vxJC313z/omfwVVAn+TXDToB6t2WCpA4304SVgXJnxXj1lZTobjMWKy6Na9b5WxoL8pR/ZHxaevnLD1rUsWwbVuUALHH1xxi2T190vc02DHgl34yXmkxEYNxDEWCp76+ns9KGsijU8BRyfPKE66K0QzmAHRH5oMibSfBwRdDFwQhfHFN/dtkK+X3mGGzPS/oI1QYJs9Fv6R8X5YaXRgxW5BcspUdcGAdOISZVwJLgddPOG1e8h9NtOJ4PBIoYD0EneWty/8CmqFTLa8s3g+T9CabnV9kpt5XoIv9fI9zAQvQKxRsxXHj7vI3MtdwialRaEfOoSyhxy6ZiJC5wmX5Uj+ej0Ss9O3V12Vro6gDktUa7Njs2Ky5NxEtR7w44DLrGqvreN/0DpGfvF8ERX5C9E56xxzeqYCLAbBMAhP/fVEkVSU/wtAIfA3pCcEc1+m/2Ljqq9dQwsl6hdi/+U7g7gpzxPBOtaNYs94juvFx3/crqppjVp+vFADj/L4inkVzG7pCUqXsdR280=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b9079f-3866-4906-231b-08d7eab0b5a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:38.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oV16SfmD+AyWG8740O2LV6e3aOvVGusXWfBaDbze3vDGRqegxVeiORfYvJkMdH4is/adh6QCYerN+6Q4GQAng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSBtZXNzYWdlcyBhcmUgbWlzc2luZyBmcm9tIHRoZSBsaXN0IG9mIHN5bWJvbGljIG1lc3NhZ2Vz
IGRlZmluZWQgaW4KdHJhY2VzLmguIEFkZCB0aGVtLgoKQWxzbyBzb3J0IHRoZSBsaXN0IGluIG9y
ZGVyIHRvIHNpbXBsaWZ5IG5leHQgY2hhbmdlcy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3RyYWNlcy5oIHwgMTMgKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3RyYWNlcy5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaAppbmRleCAzMGM2YTEzZjBl
MjIuLjdiMjVlOTUxMWIwMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMu
aAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oCkBAIC0xMDQsOCArMTA0LDEwIEBA
IGhpZl9tc2dfbGlzdF9lbnVtCiAJaGlmX21pYl9uYW1lKEFSUF9LRUVQX0FMSVZFX1BFUklPRCkg
ICAgICAgICAgXAogCWhpZl9taWJfbmFtZShCRUFDT05fRklMVEVSX0VOQUJMRSkgICAgICAgICAg
IFwKIAloaWZfbWliX25hbWUoQkVBQ09OX0ZJTFRFUl9UQUJMRSkgICAgICAgICAgICBcCisJaGlm
X21pYl9uYW1lKEJFQUNPTl9TVEFUUykgICAgICAgICAgICAgICAgICAgXAogCWhpZl9taWJfbmFt
ZShCRUFDT05fV0FLRVVQX1BFUklPRCkgICAgICAgICAgIFwKIAloaWZfbWliX25hbWUoQkxPQ0tf
QUNLX1BPTElDWSkgICAgICAgICAgICAgICBcCisJaGlmX21pYl9uYW1lKENDQV9DT05GSUcpICAg
ICAgICAgICAgICAgICAgICAgXAogCWhpZl9taWJfbmFtZShDT05GSUdfREFUQV9GSUxURVIpICAg
ICAgICAgICAgIFwKIAloaWZfbWliX25hbWUoQ09VTlRFUlNfVEFCTEUpICAgICAgICAgICAgICAg
ICBcCiAJaGlmX21pYl9uYW1lKENVUlJFTlRfVFhfUE9XRVJfTEVWRUwpICAgICAgICAgXApAQCAt
MTE0LDI5ICsxMTYsMzIgQEAgaGlmX21zZ19saXN0X2VudW0KIAloaWZfbWliX25hbWUoRE9UMTFf
TUFYX1RSQU5TTUlUX01TRFVfTElGRVRJTUUpIFwKIAloaWZfbWliX25hbWUoRE9UMTFfUlRTX1RI
UkVTSE9MRCkgICAgICAgICAgICBcCiAJaGlmX21pYl9uYW1lKERPVDExX1dFUF9ERUZBVUxUX0tF
WV9JRCkgICAgICAgXAorCWhpZl9taWJfbmFtZShFVEhFUlRZUEVfREFUQUZSQU1FX0NPTkRJVElP
TikgIFwKKwloaWZfbWliX25hbWUoRVhURU5ERURfQ09VTlRFUlNfVEFCTEUpICAgICAgICBcCiAJ
aGlmX21pYl9uYW1lKEdMX0JMT0NLX0FDS19JTkZPKSAgICAgICAgICAgICAgXAogCWhpZl9taWJf
bmFtZShHTF9PUEVSQVRJT05BTF9QT1dFUl9NT0RFKSAgICAgIFwKIAloaWZfbWliX25hbWUoR0xf
U0VUX01VTFRJX01TRykgICAgICAgICAgICAgICBcCisJaGlmX21pYl9uYW1lKEdSUF9TRVFfQ09V
TlRFUikgICAgICAgICAgICAgICAgXAogCWhpZl9taWJfbmFtZShJTkFDVElWSVRZX1RJTUVSKSAg
ICAgICAgICAgICAgIFwKIAloaWZfbWliX25hbWUoSU5URVJGQUNFX1BST1RFQ1RJT04pICAgICAg
ICAgICBcCiAJaGlmX21pYl9uYW1lKElQVjRfQUREUl9EQVRBRlJBTUVfQ09ORElUSU9OKSAgXAog
CWhpZl9taWJfbmFtZShJUFY2X0FERFJfREFUQUZSQU1FX0NPTkRJVElPTikgIFwKIAloaWZfbWli
X25hbWUoS0VFUF9BTElWRV9QRVJJT0QpICAgICAgICAgICAgICBcCiAJaGlmX21pYl9uYW1lKE1B
Q19BRERSX0RBVEFGUkFNRV9DT05ESVRJT04pICAgXAorCWhpZl9taWJfbmFtZShNQUdJQ19EQVRB
RlJBTUVfQ09ORElUSU9OKSAgICAgIFwKKwloaWZfbWliX25hbWUoTUFYX1RYX1BPV0VSX0xFVkVM
KSAgICAgICAgICAgICBcCiAJaGlmX21pYl9uYW1lKE5PTl9FUlBfUFJPVEVDVElPTikgICAgICAg
ICAgICAgXAogCWhpZl9taWJfbmFtZShOU19JUF9BRERSRVNTRVNfVEFCTEUpICAgICAgICAgIFwK
IAloaWZfbWliX25hbWUoT1ZFUlJJREVfSU5URVJOQUxfVFhfUkFURSkgICAgICBcCisJaGlmX21p
Yl9uYW1lKFBPUlRfREFUQUZSQU1FX0NPTkRJVElPTikgICAgICAgXAogCWhpZl9taWJfbmFtZShQ
Uk9URUNURURfTUdNVF9QT0xJQ1kpICAgICAgICAgIFwKLQloaWZfbWliX25hbWUoUlhfRklMVEVS
KSAgICAgICAgICAgICAgICAgICAgICBcCiAJaGlmX21pYl9uYW1lKFJDUElfUlNTSV9USFJFU0hP
TEQpICAgICAgICAgICAgXAorCWhpZl9taWJfbmFtZShSWF9GSUxURVIpICAgICAgICAgICAgICAg
ICAgICAgIFwKIAloaWZfbWliX25hbWUoU0VUX0FTU09DSUFUSU9OX01PREUpICAgICAgICAgICBc
CiAJaGlmX21pYl9uYW1lKFNFVF9EQVRBX0ZJTFRFUklORykgICAgICAgICAgICAgXAotCWhpZl9t
aWJfbmFtZShFVEhFUlRZUEVfREFUQUZSQU1FX0NPTkRJVElPTikgIFwKIAloaWZfbWliX25hbWUo
U0VUX0hUX1BST1RFQ1RJT04pICAgICAgICAgICAgICBcCi0JaGlmX21pYl9uYW1lKE1BR0lDX0RB
VEFGUkFNRV9DT05ESVRJT04pICAgICAgXAogCWhpZl9taWJfbmFtZShTRVRfVFhfUkFURV9SRVRS
WV9QT0xJQ1kpICAgICAgIFwKIAloaWZfbWliX25hbWUoU0VUX1VBUFNEX0lORk9STUFUSU9OKSAg
ICAgICAgICBcCi0JaGlmX21pYl9uYW1lKFBPUlRfREFUQUZSQU1FX0NPTkRJVElPTikgICAgICAg
XAogCWhpZl9taWJfbmFtZShTTE9UX1RJTUUpICAgICAgICAgICAgICAgICAgICAgIFwKIAloaWZf
bWliX25hbWUoU1RBVElTVElDU19UQUJMRSkgICAgICAgICAgICAgICBcCiAJaGlmX21pYl9uYW1l
KFRFTVBMQVRFX0ZSQU1FKSAgICAgICAgICAgICAgICAgXAotLSAKMi4yNi4xCgo=
