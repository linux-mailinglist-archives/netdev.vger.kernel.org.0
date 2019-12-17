Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29CB123237
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfLQQOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:38 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbfLQQOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qb+5kMfXiwyrcpHmrcoRWyTc1XiTD7EtTql8LiTZBbb91jRz/jPqW8QJVTmXVo4vyhL+yYCkytGUgRz76OMl7ntBAI+TzcanhTC/+Ky3qMx6sVGzQGrvjyKZDj4VtDnE5fiXP9sK1y7UmNoSVwc8aRzE0k+Z759csPUpZRIqq/khr4y5rQ0VN1EHdkIuCOso+AQ56ECuHNq/mHr+HvNXVvUCUC9M3hWb970RLNJ+Iu0k6xCHYOsF5aQho4qUOrreS9JQZewSWsmt2HdTFa1fiTwP3hYw3NT2xTzUzpka29zbjJcblSymfpBxTLGL2Bl+bxeid7NVEhznaCF+t8zjiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSXW7s0ibXv3OklD13Pt6khLryY4SV0hu+5hMqzb6Gg=;
 b=B1mM5+WSYx3h11zkr5cIXp/58zcq9CaP5kcfH07quwC3Rk34Et6ZKWDwv46ikFoki6Uf4nbmCMQtQN1aDQSNSFFjm5xz59zpKq1gqbZresywmfp9T2OnuIOHkifE5gHQhdDjRoPPX5WPCxpDvfuALJOLwMAXs8QfrADvXEpHdQLXcLWICCbVb/h6L/IptyHTyVPkmd/V9LJvkh7cZ9X0T3TTj0DD9w0suxQCkWJ+1kQzqEREENsYgYD6uac3ev6FvWmekRzozm2t8fN50bx6KlODg1OKDtTRWjOe7EKWE8C5RHmi5lBzmpvkB6oc9OYkLEd1CSnWFQMYxr5WdcpFcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSXW7s0ibXv3OklD13Pt6khLryY4SV0hu+5hMqzb6Gg=;
 b=KxzG39cxBIat/HZirVDosDzhv4ripJRY9dmAgDqtIF919wxttQbJO1ScaLeG35DxJQsYnXwZLmWgGHvLn7FDigWnzVPiqEYQLdkOCl13bHjWXw0T2DGWZm9xFVE8LlJD/zsHO0HQwdq4qekcgSZii6icoqB7w35MbOdaTXUdw0E=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:32 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:32 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 04/55] staging: wfx: use boolean appropriately
Thread-Topic: [PATCH v2 04/55] staging: wfx: use boolean appropriately
Thread-Index: AQHVtPUQlBqhb2ClUU2Iv95AxiPnqA==
Date:   Tue, 17 Dec 2019 16:14:32 +0000
Message-ID: <20191217161318.31402-5-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c655769b-f8c8-425b-a6ec-08d7830c3348
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3791B109DEE364A543C632D093500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hcFn9UbGgy+fBAY1eVXGsaZ0J96i9ODE02gzGm6sXgiOVx6L4NAg0WI+pTB3PJAFV8Vk3eJhlXcSeIGFgCkN/8BhyPQXju2kw96pyhaxITr0ya+M7ycI5h5FTzpiQOvI5KRmIHbQq6DTAmeIViOeNHQmNPXg4ixeWfe66PbSMeBP2OhdLUZ8takhiuMckX0QpPT2ebNKf7NSyAipw/O6FzwOKU7i1AAoGNede3FIXTxJxdUrPlOClmrH1/r9+dr7EVsxDohFkAxHulo/6tjuSF7ItVN7+gzJIecYTfMNAUA/qSP01714CyUEvmurvdR2fI+wxN1ZxI71osTAg4pHkDyNvJPTaCsqjLcJuU7lNuFi8obWwYO1cXbfUi6hRpfbmnLnYUslIceYOet0OZku9j0NlNsNzBNBmLTzRTaoxkgss9PpH+Qn+SD1Q0C5uRWm
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A9773138A343549AC05E7BDCD75999C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c655769b-f8c8-425b-a6ec-08d7830c3348
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:32.1209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SdddfohuK4bfEHJwuTNuq9rKOZO4KRPbEgiRpGjNbucfttzCWqSU1sE+oHoytPX8L77jv254PqRhvHcmJm/zag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICd1cGxvYWRlZCcgaXMgdXNlZCBhcyBhIGJvb2xlYW4sIHNvIGNhbGwgaXQgYSBib29s
ZWFuLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNCArKy0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCB8IDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggZGYz
YWNhMDNiNTBiLi5iNzI2ZGQ1ZTU5ZjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0xODQsNyAr
MTg0LDcgQEAgc3RhdGljIGludCB3ZnhfdHhfcG9saWN5X2dldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKIAkJICovCiAJCWVudHJ5ID0gbGlzdF9lbnRyeShjYWNoZS0+ZnJlZS5wcmV2LCBzdHJ1Y3Qg
dHhfcG9saWN5LCBsaW5rKTsKIAkJbWVtY3B5KGVudHJ5LT5yYXRlcywgd2FudGVkLnJhdGVzLCBz
aXplb2YoZW50cnktPnJhdGVzKSk7Ci0JCWVudHJ5LT51cGxvYWRlZCA9IDA7CisJCWVudHJ5LT51
cGxvYWRlZCA9IGZhbHNlOwogCQllbnRyeS0+dXNhZ2VfY291bnQgPSAwOwogCQlpZHggPSBlbnRy
eSAtIGNhY2hlLT5jYWNoZTsKIAl9CkBAIC0yNDEsNyArMjQxLDcgQEAgc3RhdGljIGludCB3Znhf
dHhfcG9saWN5X3VwbG9hZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJCWRzdC0+dGVybWluYXRl
ID0gMTsKIAkJCWRzdC0+Y291bnRfaW5pdCA9IDE7CiAJCQltZW1jcHkoJmRzdC0+cmF0ZXMsIHNy
Yy0+cmF0ZXMsIHNpemVvZihzcmMtPnJhdGVzKSk7Ci0JCQlzcmMtPnVwbG9hZGVkID0gMTsKKwkJ
CXNyYy0+dXBsb2FkZWQgPSB0cnVlOwogCQkJYXJnLT5udW1fdHhfcmF0ZV9wb2xpY2llcysrOwog
CQl9CiAJfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAppbmRleCBmNjNlNWQ4Y2Y5MjkuLjBmYzM4OGRiNjJl
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKQEAgLTQxLDcgKzQxLDcgQEAgc3RydWN0IHR4X3BvbGlj
eSB7CiAJc3RydWN0IGxpc3RfaGVhZCBsaW5rOwogCWludCB1c2FnZV9jb3VudDsKIAl1OCByYXRl
c1sxMl07Ci0JdTggdXBsb2FkZWQ7CisJYm9vbCB1cGxvYWRlZDsKIH07CiAKIHN0cnVjdCB0eF9w
b2xpY3lfY2FjaGUgewotLSAKMi4yNC4wCgo=
