Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E1125F808
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgIGKZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:25:36 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728525AbgIGKQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdQ9cqAuhEU2aMH1Unl/khBDoy0AKApg/qCjSZowXOGk1M9tgrf5o+4BKExpVf1Or5ay0PCkxb+kzI0P6ZdxcF//St1vddZHvHGrM79rJc2lQzsNoOuMud9wcEySpw8zU2UVPbYE+zvmvGEyblt4UBrnrOdQRm2/6RQmJJzaMI043hcy+Rb7i4L2dL9twLuiUJ1JIGUWFSQHPTEBOm2D8/JvflzHcf0p3Ya8TqPq1g7fKEQzLLdErVZkh0RDYMkQCZ1/+4qp309e61C78dbtqet2SO2vqHXPyvamsqUI0a7tiC0PRe0AeESISz+agwog+bRreu/0nFB0/LqbKmZc4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/rLImZdR+5ufn6LoNn8ygLK+eYAQzrdfMxmL7GsftI=;
 b=jMKoiOUDoqo/LkkiL7igd/yvKglDcrT5B2kt216TptJ/OR6H61LMwnjAVQWH4Vw9DQ2zSAiYPH3tvIFzHW5QeE+m9WCoPA/lx6eJRjn3tQ0P1OU2X/qybSDTWClAU3J6GJ2Yk43CGieaDLpxZnznnQVeMrnu9TbJ1Lc8VoC1kCUHVO+rInGm+pZH42Uxn8nes+q1YoCYArbgNdFknGf4FNu9Alo/JFzXBaBsh1KMlbdVz7P9ncS/Kw0uFiBJWwx/km9/vD6fQ9uMEiWM7ewpyRfdGLIWmwfdKSF8WfTP+DqTIQnWgnyxjO2vj5cF+XobgSHr/AR7rrxBpe5swu1kqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/rLImZdR+5ufn6LoNn8ygLK+eYAQzrdfMxmL7GsftI=;
 b=U0VZIatDeDkc5UmNc93bQgYQK8eJXgq9zEEuIAkgGkmKATrksmUzN4lWlKUSiPbnGw+s9j29+KV72+ahHI21w56bh7ylDB+WZ9QtGJIyyrbG5zp51Gvsb2F4DLQ/hN7diWWdwyLOfg7UnNlRb9kUpoyP3m/v+bL8Yp0+1xkQRgg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:11 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/31] staging: wfx: drop useless struct hif_pm_mode
Date:   Mon,  7 Sep 2020 12:15:06 +0200
Message-Id: <20200907101521.66082-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:09 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff3092e2-330b-4566-cfa7-08d853170af9
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606338FF62BA27A74DE9E4493280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gzlIPPkQW4AMzXIBFhuMlF9McR1k+kj2O64NqU2pGHlOw+v3bc+/Z0TE9wam/Dnxf2jEg1milfVFalHSqvQXbMsf/iXGMTsBwu3M8kQvXP6lTar0tbDYHiB1cemLTADGbTHa+mSVGBO6SQpxllOze1YisHYLeaBURGkjoqNsGsCYMZSxUhtgISWHLYQDm4AKQNsx5JaYXghkooJYKV2n2o2OlopfjX9YBHAqOWW9Zti+2vYhYgoI7iMy/XCuLa1mHoihqxyrnCFwEUZJq4Be0qwg6TJ9tFzHoXy+6b+ZJ93R+UqGullfsqUWkbo2sZPvibqa5af3eXK5gZRWYGo5pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: exxEdnn1alfKLwbnCfMp1VJM5Vs5KKLQ+ReWvM/KQQuhMiO5RS+JmtkHJKKZcE/+zndNDUnUFeFHCmejvIpGGgFdn93ip2EpKIjWTFg5CXTAdpplKFjAghz2SyMZw0/fSbrQs9sjktFdShLz1lw0jJHOOVlUG/sgbD3c/mom777OlN2/r1/FFhw9dP9kRbZXSrrmc9x7CEbC5il+tfCho5KEcWOOlHfh9/yuh9cGhgDp8ofus8PJsStMb+6cFR9H7ujhy8mfgQfK6mY9GKfhuNo2smViGL5kOKbL+RqI0j/Fog1WlCADKnUPa5kkEcnpalDu4UsBaPDLmbEOkmZI/gRcxgx2+8Z4zKE4gw3DiiivtduEwl6WgCag9KlRjoXpJ1aOvFRO+zb6AM825ez50lQnoR1CwBJkz/pDUkzTRq4wBpmLhnieHjAq4XEceYgGvO3T3PupTgGfbHiPROy+Kr7sVTaVIhE3o9yHzH70yfpWTEqwmVYT+wizHlGJvTeJkfIpHGistrkQ6/k2Y5ng8LbMnHxvHMEoHvUhjb7bZAomH4meDlMvpVO7HEtZubLzXo03N4ibQAHzVPmlRZ4zqqMfqzVoq6fV695wzPD7KSCa8CN8TnnbuC9oZoU+kkMDeGkL3I+6T/hnXxzdwP5oBA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3092e2-330b-4566-cfa7-08d853170af9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:10.8261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1irotb5hhDkMgw/J/hAnL/UZ35TUVAckLY776DtroWg8J6H2tVLS5RgGb5TjLb+XCTwIQu8yKEz8AqaSAGquMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9wbV9tb2RlIGhhcyBubyByZWFzb24gdG8gZXhpc3QuIERyb3AgaXQgYW5kIHNpbXBs
aWZ5IGFjY2Vzcwp0byBzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZS4KClNpZ25lZC1vZmYtYnk6
IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCA2ICstLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguYyAgICAgIHwgNCArKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggNGIw
MWJlNjc3ZTA4Li42ZWNiMjNjZWFmOGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAg
LTM3OCwxNCArMzc4LDEwIEBAIHN0cnVjdCBoaWZfY25mX3NldF9ic3NfcGFyYW1zIHsKIAlfX2xl
MzIgc3RhdHVzOwogfSBfX3BhY2tlZDsKIAotc3RydWN0IGhpZl9wbV9tb2RlIHsKK3N0cnVjdCBo
aWZfcmVxX3NldF9wbV9tb2RlIHsKIAl1OCAgICAgZW50ZXJfcHNtOjE7CiAJdTggICAgIHJlc2Vy
dmVkOjY7CiAJdTggICAgIGZhc3RfcHNtOjE7Ci19IF9fcGFja2VkOwotCi1zdHJ1Y3QgaGlmX3Jl
cV9zZXRfcG1fbW9kZSB7Ci0Jc3RydWN0IGhpZl9wbV9tb2RlIHBtX21vZGU7CiAJdTggICAgIGZh
c3RfcHNtX2lkbGVfcGVyaW9kOwogCXU4ICAgICBhcF9wc21fY2hhbmdlX3BlcmlvZDsKIAl1OCAg
ICAgbWluX2F1dG9fcHNfcG9sbF9wZXJpb2Q7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCBlZGRiNjBk
ZWMwNjkuLjEzNGFmNGRhZWU5NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00MzksMTEgKzQzOSwx
MSBAQCBpbnQgaGlmX3NldF9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBwcywgaW50IGR5
bmFtaWNfcHNfdGltZW91dCkKIAlpZiAoIWhpZikKIAkJcmV0dXJuIC1FTk9NRU07CiAJaWYgKHBz
KSB7Ci0JCWJvZHktPnBtX21vZGUuZW50ZXJfcHNtID0gMTsKKwkJYm9keS0+ZW50ZXJfcHNtID0g
MTsKIAkJLy8gRmlybXdhcmUgZG9lcyBub3Qgc3VwcG9ydCBtb3JlIHRoYW4gMTI4bXMKIAkJYm9k
eS0+ZmFzdF9wc21faWRsZV9wZXJpb2QgPSBtaW4oZHluYW1pY19wc190aW1lb3V0ICogMiwgMjU1
KTsKIAkJaWYgKGJvZHktPmZhc3RfcHNtX2lkbGVfcGVyaW9kKQotCQkJYm9keS0+cG1fbW9kZS5m
YXN0X3BzbSA9IDE7CisJCQlib2R5LT5mYXN0X3BzbSA9IDE7CiAJfQogCXdmeF9maWxsX2hlYWRl
cihoaWYsIHd2aWYtPmlkLCBISUZfUkVRX0lEX1NFVF9QTV9NT0RFLCBzaXplb2YoKmJvZHkpKTsK
IAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7Ci0t
IAoyLjI4LjAKCg==
