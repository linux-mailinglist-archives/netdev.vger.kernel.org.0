Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D19013C436
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgAON5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:57:15 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:39089
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730381AbgAON4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:56:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVcq6/FWOKWH3vWqYIrzfCl0qTj9N9za55L7v2iHGLrffW4nf9PrrDmo4erFuUEkBHHhZ8OZLpAgsVi5EqN4w9aFudNXs6mYTmJNHCHP3ZQ904pfd1y9GmwbCErhoTP0qFqGtEq6IE7hB8uQecVFIBhk55smEA3FZq2i2lRdS/1sY8v2netC9x/2Cz1i6+Ez0u4cc7J29WJhHEzUi4axlBjOvmPD1Pzv8Cv0bx6HylV0RvnwA16VWYpZNvhqcCzSrHXeHEy1SuOTrcCIiH4G3z+0Ic0KAHpRk+eYGwvWvwEZsM5KFiLcJsukrky1jL7htw0Gbd6l1xkuNOsYV4bjcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3u2E2RuWsPeDBspbS1BYQcNKcjt+UuC5v4vUdV+0qA=;
 b=JRADd+u8Qh097PlV8dwANZ9XNLc1/ikORsUTLCvIw8hgQdBXqVkgLfMQZVopBdRXUajCiR8xfQbVSrXYUQDcnTEG7xDR0sekkpSgiMED2000vjF1HODwiT1QzdYdLgADKJPwRHHXJ4Dk0D5FvDDwZZpa6tlCsLwRmt5hlsyK8bBa4ZXZG+1oSuD+k96RqUJY6fFarW1kB9dQS/I1E64k0X41YH0aV08xgdWEZ5VTCYTFFam9+ededvmotPjsINX+A/t+GujUoKVNoa29FzhZOlTQkTKjpjoMh9pgkxmHVYlgxrbpJDiD/qXPCOFuymCLf1FruImxGtzYvcvrVifDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3u2E2RuWsPeDBspbS1BYQcNKcjt+UuC5v4vUdV+0qA=;
 b=moiUOHFoEf2dWzL78kJVMoyphgpetygZhOtXoJLRTa6CMS5gxpIS3oeq4XXM5S0Me2NvmU+DDQ6LmyuF1SqFIN1sZINLsiR4bkCJQRr8m82jI80ompQrLffWbGVkAVl64uobD6YSv+uFufuyrTnAlDGlYmPedJIrM28IiAXz/yY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:56:05 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:56:05 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:35 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 64/65] staging: wfx: simplify hif_multi_tx_confirm()
Thread-Topic: [PATCH v2 64/65] staging: wfx: simplify hif_multi_tx_confirm()
Thread-Index: AQHVy6t2ZLEHcGkyoU+PxqF9Ez40+g==
Date:   Wed, 15 Jan 2020 13:55:37 +0000
Message-ID: <20200115135338.14374-65-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f8a185d-6cd0-445e-cd38-08d799c29927
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36616B9B9F2783F9B8C8327293370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L2734OgM+GNyb1qKT6bxjV8kH9aD7LIZZNIOxbXZNApSfMBxrbDEnZAbSOdh48rhvg7jpKIhL9uT/eVz4d6BtxM5MtSZ46hcMU0yc5kJWSAeb6UHKgzi+jYrRttaEmQ1g/LLE2/PXG5FKJjrr4tKjp/px7qlXtkNOmMe9DiChcMUXPVE0N+jUE2ciKD1aVthNoCnVKeSX9QEZ1Oyhta4xZ0bzKurzJQrke/il7zM4fRHQ3/Qv8/jRjJDstIzCvm+tGqqP1sgl7opIewiovr17Q6Pbjcdm0t353jSjhOj3BlHjBI5/jUpnLa/usZC+3ITkSc7VkIjBl+1oSeu2Hv+jLfgX5Y2sMd1qTBKA5ddbOqlB/mOw9T5OhDzLqC0TemgCr4wPxJe63iE4fMl6jOqXbGwAoiRo/TuILn6x+3QRpltbXwmmlQQi3VJpflDh6KE
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FCBE9271BF65D4F9FEF3C60FAE94438@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8a185d-6cd0-445e-cd38-08d799c29927
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:37.0530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +mJpJOai+RX8yTDTKFbWanIzxJqxouXwHToj65IGnB4CiYYqhzTcgUpKNePxnq1NcH+9nyC1euCh/9mEV6IWVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXNh
Z2Ugb2YgdGhlICJidWZfbG9jIiB2YXJpYWJsZSBkb2VzIG5vdCBzaW1wbGlmeSB0aGUgZnVuY3Rp
b24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyB8IDExICsrKy0tLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9yeC5jCmluZGV4IGY3OThjZDY5NzNiNi4uMzNjMjJjNWQ2MjlkIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMKQEAgLTc3LDIxICs3NywxNiBAQCBzdGF0aWMgaW50IGhpZl9tdWx0aV90eF9jb25m
aXJtKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCWNvbnN0IHN0cnVjdCBoaWZfbXNnICpoaWYs
IGNvbnN0IHZvaWQgKmJ1ZikKIHsKIAljb25zdCBzdHJ1Y3QgaGlmX2NuZl9tdWx0aV90cmFuc21p
dCAqYm9keSA9IGJ1ZjsKLQljb25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqYnVmX2xvYyA9Ci0JCShj
b25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqKSZib2R5LT50eF9jb25mX3BheWxvYWQ7CiAJc3RydWN0
IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgaGlmLT5pbnRlcmZhY2UpOwotCWlu
dCBjb3VudCA9IGJvZHktPm51bV90eF9jb25mczsKIAlpbnQgaTsKIAotCVdBUk4oY291bnQgPD0g
MCwgImNvcnJ1cHRlZCBtZXNzYWdlIik7CisJV0FSTihib2R5LT5udW1fdHhfY29uZnMgPD0gMCwg
ImNvcnJ1cHRlZCBtZXNzYWdlIik7CiAJV0FSTl9PTighd3ZpZik7CiAJaWYgKCF3dmlmKQogCQly
ZXR1cm4gLUVGQVVMVDsKIAotCWZvciAoaSA9IDA7IGkgPCBjb3VudDsgKytpKSB7Ci0JCXdmeF90
eF9jb25maXJtX2NiKHd2aWYsIGJ1Zl9sb2MpOwotCQlidWZfbG9jKys7Ci0JfQorCWZvciAoaSA9
IDA7IGkgPCBib2R5LT5udW1fdHhfY29uZnM7IGkrKykKKwkJd2Z4X3R4X2NvbmZpcm1fY2Iod3Zp
ZiwgJmJvZHktPnR4X2NvbmZfcGF5bG9hZFtpXSk7CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjIuMjUu
MAoK
