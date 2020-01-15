Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC013CAFD
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgAOR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:29:05 -0500
Received: from mail-eopbgr680058.outbound.protection.outlook.com ([40.107.68.58]:9856
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbgAOR3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 12:29:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dU46RyNWjt8jfxCqyCO/Nm+96T9vTgUmWhHVbbTPrznFfetT2SgpnlekwB5OJAi9fatR2rdQu4YMwryQvZ8bsABDX7ZjFmM0vLOa7CVxk6B91xQm7p1JoOxjM2eX4XrEvG6LFRJdP6y/iZzj8BcjJEWM0XfFkhsfpDjQrT2Is83GaX37ylh3s7Xay8k6lDwHrPetyBZIRPtFW2JzJOljOo7jWvBFUZT0ruecKeMxs+GazGhfUhW2CzaWzNYHia/GU3B+L/UDkmYB0dcJJDEUZcl/XHdqZf+s0BbNX2sPUSdRRkyJ5wFWk8iKQI0y2Zw/NLfJu5K+z1v4gqmEdIsTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTMn5GmK8iGbDlrzMGenSJgu5IdIBtIm9N/vKVIp+YU=;
 b=C0u0zSY84E6KIYIAzQXD4Cb1j6MBgcmZVidcgAvs9tWyR/pvqPi0g/milBcDJek/ePCTAkHo1qmaCCD8XgPWsIIKXQh2y7f1Qa+lmo9MZw2xD2QBpf/SilTKeXgahJrMc4ejdIIvmHF26X7OOlt+TSacyKoR738+VSKSHTo09GighXenZMdjNarCSzZZJ8z/ZSQQ2sCmkpOsC9JIoVGsVzLorm6ONxQso+klGubMY8t0WnpCiXOyhh+wwoulMV1gSr51ZFUYG6Gp3gn+to32DxvPbqHsJcMoGblaGzao7uUjHhOaB0FhplaDW/UtqVDiCjA6ArGspfG1S72LldlM4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTMn5GmK8iGbDlrzMGenSJgu5IdIBtIm9N/vKVIp+YU=;
 b=ClfO5+Kv+o0QSrHC1oOVXCCHqJWxOQYiI6s8mfJjoETjZlKqnbHFz1ETDY71uRpKn3fDcNDni0tS+JVCdViXbGoRooy7yzAPgcvvRXERbjTMFd+Sdp1rx273L6CK/J5YG3+KQ+kct4NaDk0Ygq8NKgoZqQBigCo5i9rZBgyPM+8=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3107.namprd10.prod.outlook.com (20.179.136.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 17:29:03 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef%7]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 17:29:02 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "qiang.zhao@nxp.com" <qiang.zhao@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/wan/fsl_ucc_hdlc: fix out of bounds write on array
 utdm_info
Thread-Topic: [PATCH] net/wan/fsl_ucc_hdlc: fix out of bounds write on array
 utdm_info
Thread-Index: AQHVyur09HukpX03t0SJoKItzNiieqfr/LeA
Date:   Wed, 15 Jan 2020 17:29:02 +0000
Message-ID: <335a44aa9bfbec197385c1e0a9cc35cc29fb307d.camel@infinera.com>
References: <20200114145448.361888-1-colin.king@canonical.com>
In-Reply-To: <20200114145448.361888-1-colin.king@canonical.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ea309fc-cecf-4e29-ddaf-08d799e06a37
x-ms-traffictypediagnostic: BN8PR10MB3107:
x-microsoft-antispam-prvs: <BN8PR10MB3107EE434F0598FE87DCFE28F4370@BN8PR10MB3107.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(199004)(189003)(478600001)(2616005)(76116006)(66946007)(66476007)(66446008)(64756008)(66556008)(6506007)(71200400001)(91956017)(6512007)(5660300002)(8676002)(81166006)(36756003)(8936002)(110136005)(81156014)(54906003)(4326008)(6486002)(26005)(186003)(86362001)(316002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3107;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rd7YS82zsbHAVNYWqWNxGZX4HjJZIicVHIrlMTY/YKWl20qOUY6NZ7om5At3m1WmWIgsqEpyU4g0JCQEHyboUTzPeqP7kwAil4oiujCpmkzAX0aH6xGl10FcqFMj3+irotzfPDebwGE5/lRMSPAW4O9V4y/8ll11z341HFiy8eyJBlJl+WgvywxqFFSbV8qoH4dsEXc6f8mSAht5eJKO5/Iipgv46qrXD4rh79X4RWg49jWS2Tt84aB9Aq+8nMQw3n3hdMndnZlgjkKGEn9szHggaKMy1MF82YFeG7Kz/vIT1GlAROO/zR1nntCDujc9VVfVPcvhcs2WWVUcW4aw1GexsQz8w76+WgKHGJLduf4QpE0oRpU1nP8YR1rtODmIpM4oeKj72BP9Rv4cg3BaHpC5DMSsJu0MER6Qt1wRVCwge1Pbr+f4ej06JfEZyXmQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4248A3C9FF1CF4B9C46F7E935C6075E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea309fc-cecf-4e29-ddaf-08d799e06a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 17:29:02.8935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gLfNMAaj0cyAiZnJx5M3+qiS5UYDCDxG0FT4wFz4Su6K7OeLm4CyjXyaobV1ZyVhdmsjQ9HTSwymmVIdMc7A4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAxLTE0IGF0IDE0OjU0ICswMDAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiAN
Cj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gDQo+
IEFycmF5IHV0ZG1faW5mbyBpcyBkZWNsYXJlZCBhcyBhbiBhcnJheSBvZiBNQVhfSERMQ19OVU0g
KDQpIGVsZW1lbnRzDQo+IGhvd2V2ZXIgdXAgdG8gVUNDX01BWF9OVU0gKDgpIGVsZW1lbnRzIGFy
ZSBwb3RlbnRpYWxseSBiZWluZyB3cml0dGVuDQo+IHRvIGl0LiAgQ3VycmVudGx5IHdlIGhhdmUg
YW4gYXJyYXkgb3V0LW9mLWJvdW5kcyB3cml0ZSBlcnJvciBvbiB0aGUNCj4gbGFzdCA0IGVsZW1l
bnRzLiBGaXggdGhpcyBieSBtYWtpbmcgdXRkbV9pbmZvIFVDQ19NQVhfTlVNIGVsZW1lbnRzIGlu
DQo+IHNpemUuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiT3V0LW9mLWJvdW5kcyB3cml0
ZSIpDQo+IEZpeGVzOiBjMTliNmQyNDZhMzUgKCJkcml2ZXJzL25ldDogc3VwcG9ydCBoZGxjIGZ1
bmN0aW9uIGZvciBRRS1VQ0MiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KDQpUaGlzIHNob3VsZCBiZSBzZW50IHRvIHN0YWJsZSBh
cyB3ZWxsDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNC4xOS54Kw0KDQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvd2FuL2ZzbF91Y2NfaGRsYy5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2FuL2ZzbF91Y2NfaGRsYy5jIGIvZHJpdmVycy9uZXQvd2FuL2ZzbF91Y2NfaGRs
Yy5jDQo+IGluZGV4IDk0ZTg3MGY0OGUyMS4uOWVkZDk0Njc5MjgzIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC93YW4vZnNsX3VjY19oZGxjLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2FuL2Zz
bF91Y2NfaGRsYy5jDQo+IEBAIC03Myw3ICs3Myw3IEBAIHN0YXRpYyBzdHJ1Y3QgdWNjX3RkbV9p
bmZvIHV0ZG1fcHJpbWFyeV9pbmZvID0gew0KPiAgICAgICAgIH0sDQo+ICB9Ow0KPiANCj4gLXN0
YXRpYyBzdHJ1Y3QgdWNjX3RkbV9pbmZvIHV0ZG1faW5mb1tNQVhfSERMQ19OVU1dOw0KPiArc3Rh
dGljIHN0cnVjdCB1Y2NfdGRtX2luZm8gdXRkbV9pbmZvW1VDQ19NQVhfTlVNXTsNCj4gDQo+ICBz
dGF0aWMgaW50IHVoZGxjX2luaXQoc3RydWN0IHVjY19oZGxjX3ByaXZhdGUgKnByaXYpDQo+ICB7
DQo+IC0tDQo+IDIuMjQuMA0KPiANCg0K
