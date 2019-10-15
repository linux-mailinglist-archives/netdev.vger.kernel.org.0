Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40B4D71CA
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfJOJGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 05:06:44 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:35424
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726564AbfJOJGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 05:06:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+JepE2T80nQk40RSX9C5ruDDq79AYonPbTqt6m51iy4slq7STasWGrJPgakLNk2ZjdlKThUBWfZC6LBSIjcbTAqYe72Ww4smkoNuWhFEUlH+KM92IHoycLQxawP1HKSDFulVLgAHDJQpDgeRfxkCKuIn0+QRm5xWBw66KK74qVRdXGUhgudQFHSOVI6xni7WOaCG+vAhfy2+bh4VZbkVAd1eORxZlBRAQr92o02AcH1/bJz03xVronP3J5DiAMQsniYGkiZrLkKW2h3SEM0TQo7837RNLjw0fcOr1KixMcVXWTGJLSDvi8+uiN1JEEMYKy/6D1cMEBNacuDyxNruQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7dxp9N1qtJHq6WWqpuNOFh2zFwpgerPAicAjWzz+LE=;
 b=e0IzzKXOsZU8A3BhmDMPTks5OYSis3CJeCyEb31Q81W94wenVUN01uDRwRQLzYR59sA9UOeWYsA7Tj6up+ZbovJtMgqc8YAkcVpa64TgpxkOGP89pWxQ/zyZpejtbbud25/aa81Eg3x/tig8mGBbUByvOOqt1wd1kreUsibA8qxTCuukwJBi6P5HpVfYDuruwIFjUrzxY0uJZUHigSdDC5sPiUZ9WTlfDNL+tHTTHH9TbXb1pMM43y+8ZbkY54EqxBt0ZIdCoxQzTrrXYb7vvsn+PPHn+/dBG4VERpNuoDohqQuN579OHY3qsirXwjCNFRzCfLjavIsaIV5o2Bgw/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7dxp9N1qtJHq6WWqpuNOFh2zFwpgerPAicAjWzz+LE=;
 b=H5UDAu+8SJbcQskG4CjKx8Gj2g2MMqFAxaT25urDnnYxGYfbrkJXM3eEx5i/cjWkj3peJXdgdXMC9vDtpDkUVnM6YQxyythq0iHBeEJoR1OeRe+/0uT1agD667igm2tyho+2Ul2XT5Gto176vm1GbDBQsnogYRBn5k/vqAmqlqs=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3747.namprd11.prod.outlook.com (20.178.218.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 09:06:41 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 09:06:41 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 08/12] net: aquantia: add support for ptp
 ioctls
Thread-Topic: [PATCH v2 net-next 08/12] net: aquantia: add support for ptp
 ioctls
Thread-Index: AQHVfccXCcYGqZ7qm0Cnpew/aZ65pqdaW9KAgAEYUIA=
Date:   Tue, 15 Oct 2019 09:06:41 +0000
Message-ID: <3c840d09-8ebc-1f6e-d46e-686056a253c0@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <e5810b73ee7a792d464284069b7dec7f775575b8.1570531332.git.igor.russkikh@aquantia.com>
 <20191014162319.GO21165@lunn.ch>
In-Reply-To: <20191014162319.GO21165@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0019.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::31)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4a5940d-e184-4031-e2f1-08d7514efe89
x-ms-traffictypediagnostic: BN8PR11MB3747:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3747DDF3D4D268B97249190798930@BN8PR11MB3747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(346002)(136003)(376002)(189003)(199004)(81156014)(64756008)(76176011)(6916009)(14454004)(2616005)(66476007)(6506007)(386003)(508600001)(52116002)(66556008)(26005)(486006)(66946007)(66066001)(6246003)(186003)(54906003)(25786009)(316002)(5660300002)(107886003)(476003)(99286004)(4744005)(81166006)(8676002)(31686004)(3846002)(4326008)(36756003)(6116002)(6486002)(6436002)(2906002)(8936002)(305945005)(256004)(44832011)(66446008)(71200400001)(71190400001)(446003)(6512007)(86362001)(7736002)(14444005)(229853002)(102836004)(31696002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3747;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hiVLgPQKUFsfTnTf59FG1nNlrebU3a5h/tY80DlW7R0K683BYDfQJjef0wT2fcbjRL84Lew9FMe0RYWbH8oAIxCyY0ZODDYsF/3dOxig1+OjwspKQ4qFVyA6hR0tNEg0hJ0uDrOOP+v9U9o6TA8JYjTd4YFDcR5ow0ZMYG6wehfxQPQy0kchExIzJXNDeBCtC+rbXiE/3V0opAMvIfguBCLZm4bW66w1ceK/F8VT78aua4oREu5a5RCfjJp1rgIWYUfdXkRlic2qEkhpABZF+6WvhdsQmWYkDWST0dUQyqEgVv3960vpiNT3qnVV35qcIOgz3FQC/XyVsmMd8FxFSSFA0J+BJD5SufW8Ge/AfsRHb1i4pKCpHl2Bc9/PSrA/LiDMap237nRxPpKcaPHuBtFk5PBlmmgfn75ugi40i4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0E03FD4B33EEE4F920F5C3A9FEAAFC1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a5940d-e184-4031-e2f1-08d7514efe89
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 09:06:41.7891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIQ/SjVdFRMix03stEaeOOyY9TAWr97HgrhVuKU640xK6woopNVrDwPkFvHopabxp+O8VfowTJJNtlbBsMhPPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiArDQo+PiArCXN3aXRjaCAoY29uZmlnLT5yeF9maWx0ZXIpIHsNCj4+ICsJY2FzZSBIV1RT
VEFNUF9GSUxURVJfUFRQX1YyX0w0X0VWRU5UOg0KPj4gKwljYXNlIEhXVFNUQU1QX0ZJTFRFUl9Q
VFBfVjJfTDRfU1lOQzoNCj4+ICsJY2FzZSBIV1RTVEFNUF9GSUxURVJfUFRQX1YyX0w0X0RFTEFZ
X1JFUToNCj4+ICsJY2FzZSBIV1RTVEFNUF9GSUxURVJfUFRQX1YyX0wyX0VWRU5UOg0KPj4gKwlj
YXNlIEhXVFNUQU1QX0ZJTFRFUl9QVFBfVjJfTDJfU1lOQzoNCj4+ICsJY2FzZSBIV1RTVEFNUF9G
SUxURVJfUFRQX1YyX0wyX0RFTEFZX1JFUToNCj4+ICsJY2FzZSBIV1RTVEFNUF9GSUxURVJfUFRQ
X1YyX1NZTkM6DQo+PiArCWNhc2UgSFdUU1RBTVBfRklMVEVSX1BUUF9WMl9ERUxBWV9SRVE6DQo+
IA0KPiBQcm9iYWJseSBhIHF1ZXN0aW9uIG9mIFJpY2hhcmQNCj4gDQo+IEkgdGhpbmsgdGhpcyBo
YXJkd2FyZSBvbmx5IHN1cHBvcnRzIElQdjQuIElzIHRoZXJlIHNvbWUgd2F5IHRvDQo+IGluZGlj
YXRlIElQdjYgaXMgbm90IHN1cHBvcnRlZD8NCg0KSSBkb24ndCB0aGluayBpdCBleGlzdHMsDQoN
CmJ1dCB0aGUgaGFyZHdhcmUgZG9lcyBhY3R1YWxseSBzdXBwb3J0cyBJUHY2LiBXZSBub3cgZG9p
bmcgc29tZSB2ZXJpZmljYXRpb24gb24NCml0IGFuZCB0aGVyZSB3aWxsIGJlIGEgZm9sbG93dXAg
cGF0Y2ggZm9yIHRoaXMuDQoNClJlZ2FyZHMsDQogIElnb3INCg==
