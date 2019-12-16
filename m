Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54B1210A9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfLPRFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:22 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:49121
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbfLPRD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeTqR5hhTHH1MQD8TTWHBEpgtP23PKBS8Kc8UKLp8uPSXME+el9cK7rM/E+ar0o3T/IhVkqIANixeS9MWWU1FiwSUEo6YGM2ohbSZS47HLL414ZsyyqKBXrQATv2BhhF2iFS7ZMqCT/BGWv0cUyMBtyNx085kOwa3ol5z9jEWJ+TXoO+GLLMEMctAiWMO23ulHCfu0Bix1zcJHhZHpj2guSseyRbhYUZe33QuI2io/0MpWeqxC13x+yi8hz0l8ETZE7j9487PTNJIMo+jmkFcSLvVBDGxseSs+uiKlj606H1+B0U+2NlZWgEgOplwHVJ/4UxlGb+sfmSY8fn/cYVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46Lq4d/+4+R9rW8oC6LzEt5TwK3q+ipcpmcXSIVF130=;
 b=Twx7f0cGxWzHIJQrSargkJGtUuwDzRNqtNHXx9jNka4CmnZZRS4IOAxfFtT00Iv1lAHhA81W2kvlzz4+MVZlJWueoLkEkjzYVrbdGyfbqeN9iLiJFxrcwX1IaIk7l9JkTRjm9vKKxWs1/g5yjxGWfanqh3MFbyuQuCZp642hyIMeyJpnKrlW5KjXe2zKPYZeKVANCv6sLwi32IBcT3+5srEKwtSARlu1hcb38812imUiKh7wi78iJpPCt7la6udqLZLAH7VBSOrMuiJD5rl/cRqvFOpG4t/dY+Ze2Hp+nCTaVPdQ2d7voT2ZzPXlEcwrFBhHbfaUIhNTJdV5i7sLXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46Lq4d/+4+R9rW8oC6LzEt5TwK3q+ipcpmcXSIVF130=;
 b=CD751Gctuby6A8rGAWLjHezVUrawDEgFdF2jPK9NUqkNu6nTjgYay4qdtmecdJlZHZ6JSA0pW16JpGctFwrZHxy2esvwN5G7hkg74iy4DLqsZPzLfsjHGYUsmJrPZSVGwghWqJ8XeYBzvSRX6tYfp2uQudRLlhN4wWNIJrq5xws=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:49 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:49 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 15/55] staging: wfx: take advantage of IS_ERR_OR_NULL()
Thread-Topic: [PATCH 15/55] staging: wfx: take advantage of IS_ERR_OR_NULL()
Thread-Index: AQHVtDLEB8oUZHWi3EKneemV+0H/Yw==
Date:   Mon, 16 Dec 2019 17:03:41 +0000
Message-ID: <20191216170302.29543-16-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57a8d081-e1f7-47c5-2e17-08d78249eb85
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4351465CD9C1247931205AD693510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(4744005)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P8liIig+zHbyRxs08LPIS5RtAMOMKH0MqPC1KhAAxz8MVj0YykLu9EGAxT2O4nsDQDJsvvFnu5vmE8qOz/mjGM/0ZaW7plUyQWtaLK2QeFcafaQ/aW9VjD/3s7cPDbX8uD6qA4aHXDhh3buyjyYt0HK6siIEvDKCkAuoZCpgeu24x5qi116Yhmok0Y0BX+cNPpOqmiC3ue3wJ5+nclYYFvJ7otcqRIjrUziNv4XMxbOapCUy5hQAz4JKcQCzmvq1l44eix67z+coX59P6uhjNdSbugsfiUgbj3tRNkE1xWHSI/ZWwSYNEtw3box3aTyIFAvBmoWfjFGMEbbDX9OHILtJCjPNXZPHPb7BMxF3vI05B8sXQjWLLA1UY+usT6wLRtj/K2ZHMSX+n+nYd6nkZ1W6Q7vVgYsmG2/K32XsFKyBEANoDbTKP0nYRI21CIqA
Content-Type: text/plain; charset="utf-8"
Content-ID: <47595EB88B466E44AB1B9C12019BB9F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a8d081-e1f7-47c5-2e17-08d78249eb85
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:41.3826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qWjSFx1vcKe7y4zrq1faJDCbVdKz4MElyco+EWCRXWxNH9ub3xJNgQZI21ww4fC/1nRZkRhpfEaO/56RB7K5pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpP
YnZpb3VzbHksIGN1cnJlbnQgY29kZSBjYW4gYmUgcmVwbGFjZWQgYnkgSVNfRVJSX09SX05VTEwo
KS4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgfCAyICstDQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5j
DQppbmRleCAzYjQ3YjZjMjFlYTEuLmNmNGJjYjE0YTEyZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvbWFpbi5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYw0KQEAg
LTE4Miw3ICsxODIsNyBAQCBzdHJ1Y3QgZ3Bpb19kZXNjICp3ZnhfZ2V0X2dwaW8oc3RydWN0IGRl
dmljZSAqZGV2LCBpbnQgb3ZlcnJpZGUsDQogCX0gZWxzZSB7DQogCQlyZXQgPSBkZXZtX2dwaW9k
X2dldChkZXYsIGxhYmVsLCBHUElPRF9PVVRfTE9XKTsNCiAJfQ0KLQlpZiAoSVNfRVJSKHJldCkg
fHwgIXJldCkgew0KKwlpZiAoSVNfRVJSX09SX05VTEwocmV0KSkgew0KIAkJaWYgKCFyZXQgfHwg
UFRSX0VSUihyZXQpID09IC1FTk9FTlQpDQogCQkJZGV2X3dhcm4oZGV2LCAiZ3BpbyAlcyBpcyBu
b3QgZGVmaW5lZFxuIiwgbGFiZWwpOw0KIAkJZWxzZQ0KLS0gDQoyLjIwLjENCg==
