Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3291BDB3C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgD2L7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 07:59:10 -0400
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO loutcimsva01.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2L7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 07:59:09 -0400
Received: from loutcimsva01.etn.com (loutcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1574A96159;
        Wed, 29 Apr 2020 07:59:08 -0400 (EDT)
Received: from loutcimsva01.etn.com (loutcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11B9896156;
        Wed, 29 Apr 2020 07:59:08 -0400 (EDT)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by loutcimsva01.etn.com (Postfix) with ESMTPS;
        Wed, 29 Apr 2020 07:59:08 -0400 (EDT)
Received: from LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Wed, 29 Apr 2020 07:59:04 -0400
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 07:59:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 29 Apr 2020 07:58:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEuGGgwTzlImiSOphzvfTUHUwbv0+b8ZQgrIG2q2qhNRCiDX5AlA5oTizfljK0umE8aHw48OJ1+ek2sr46z5ABSJK+vGRpBtbRIImTOm9GJEQe5a0jMKYxotue1495FFubb5zrxq97nZbJVSLDuK3GxvXA/mDRqXp7PAuFD7/nOO2O+CV6oxO2ztf6t0w7AmjREAFhf6RYzEewL8UzNagqzc3h6vf+uHFjOf2D7YFfCosUm/rjTaL2Yzit1EBdtzrNrHWQrY7DAoLU0rMcY+W3CLUfOcEPVwjtJmZOkGQj1kGF4Etpwl4Bt10PAODM0ysdUMrjcN99+4NWgsuFl6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzNMenpdfpl/q/z/lmA+Tj8nqptyse1bvfvm0VH/Uds=;
 b=D4++7jno9XE8SruHrSm9FARyVlCXwR8tHZ7zfKR+ATFjDxFouvvb3lzvNhM84KjmB9BSetVEPhVbXu1U+h/x9786N8R5AQ2AwA62UatiyhpTx/F0CXDsR3B06SoyQybVDi599oTdRo+1AzBD87V9xekoJBk2c0S5r1V7s1ypHSg2gqKR6V8s8OX8HK5ZOBe4oEYxHGHF0FTOmCGdYJwValhrRq5OOwuqt79JKddlFR2cFWMj6QxRbaz5wYIgdpfIqTUPKqgWbvZ5TibZFgfUYdD7d3UovzXpKZPieN+n+cZZYVv+G8avwpWziC997pENMklU6Kic3SDbqIySB6bmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzNMenpdfpl/q/z/lmA+Tj8nqptyse1bvfvm0VH/Uds=;
 b=wY/DQh48XdgdbK9TaMDwg8U65eXAEgt3iSkugXFFbvKX7v/PqCo8ukT1pN/iVn6mKceR4i3zjdDWgytK6QoB6YZZjts1ZjcPpXZPo+5ELYF8ekZnhQLgpz5g70RDOuc3LBVrys59poycm3/HfrrWLKl057ynEwgrHa4YLLcgtJ0=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB3831.namprd17.prod.outlook.com (2603:10b6:610:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 11:59:01 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 11:59:01 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Topic: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Index: AdYeHY7rY3M9YncCRBykPeyQlUA9mw==
Date:   Wed, 29 Apr 2020 11:59:00 +0000
Message-ID: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7c9100b-0995-47b7-7085-08d7ec34b4be
x-ms-traffictypediagnostic: CH2PR17MB3831:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB38312E419FD3C28A4D12EBCDDFAD0@CH2PR17MB3831.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(86362001)(8676002)(26005)(8936002)(186003)(107886003)(4326008)(52536014)(66946007)(66476007)(66556008)(64756008)(7696005)(66446008)(55016002)(9686003)(6506007)(53546011)(6916009)(76116006)(478600001)(7416002)(45080400002)(33656002)(2906002)(5660300002)(316002)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hcr3Q1Td3XSerEo0dkYunqGjPQG2+RtiUxDKmm1hUHClSWjRzcLWBnGHfUPLBtEUPFN6hqHmKUykPhLv99bQYtbnbCfA13EO6qikhkexE/k0sBv3E4bJ17zlWDSdY58jNnaVmvTz9+mPkJ7jsNqFUytZKgcDi1Zq2YaxiKlIonvvHeJS4tb+w7eKy7P0scMXZI6QeRTbBtzlXOwWg1V1jyd61USo1FBfAl/T106UgBdhAe402oB736bxNFEdmmMDoVbfSEAkavu+0RInS2M99y8/glgaqxP0aGnFSF5TB0XY1nxBFRPXl5PuDmIghP+7N6wZ6dkPIoJYWiGBoCN/Ba3Td2sj4ui98AMuUTXqy0bU/Tin5M41vZcy74+MvzQJ0EZPFxvgRidQqQO8kurR/DkNOO8osYFdwWmko+ul1pxlDho3bjE6/pm8eVYDq/QH
x-ms-exchange-antispam-messagedata: snjGBnHZh1XXCxg+K6o+yNmJ5AjPgA7XAOP3yV95EWQF3uIpzAahfhBKHzffqnMXpHh0cDHgj5a61iEddd/YL1+CbrSb1ojz/sAC3WoKsEfYMsGnmDuMNV0k1IvjeEKvcffhU87vSG1xFOTq/wTjXmWwOCrm8TEejje0G1CmJwlOk3gya6QyZV4h75J6aKcJuczZSRHaonq4+ppeqpsn/KjO0XBvgaVb7Zvfx2qwsds/zRiKZve4Fp9nvl8E1iJc57yzCwT8LJj76RyjxDwu8hiylwbdcqTprPldTi7PAimgWu4b43RwLX2Nnch+W+1TAp3tnXkqCnBEraGFNNa9J4Tg84d9tGvcW+8gCwLiNN1fXnHJfHDVUhOh0xAgG59uu/nT8LcAwxAp8O2TP3jTK2zxUluQSDJ1H5Lc5xnSKLNvqbZKlUaiTdE3/0XcQ12JUZbUqEgz0fyWe0wpq4pkWS74vd+gzfrElf/YGGHhCsx9/vfXB8bxBA0AY1C7MvfBqdY4X3KFpxuRWSLzP7Xfku97KkEg1jwxvfpAlMTZFugBeo/ofSO1qPU+rkWvoOTE8OqnD5Bj3GAmZij5NALGrAdo47nAdKrGv2+UB+JH73SNTIqtP541IiKGljiqzGjKbZy3uJojJ8xVm09VARQP2TBKncB/ivd1N6fiTnNLjUEiiMzbeN0LmkIHpnP9x56C28BbdOx4awbWC0X+oqh3MoDExQq4Cf17UDrlO9gB6giKaElmEtfofH3fl9xEuC4/3bf3c+x2QEf3TUeBAwZqbQPd29BJ8t90erkjPPUIotE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c9100b-0995-47b7-7085-08d7ec34b4be
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 11:59:00.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b5gJlFW0xzdGj8LlYMIHlFBfN+RsGW8AkK3XghrwdPgB0Ksd3rO3k9ypmrcPO4twhIGuKsHfAu0mK4jDLhiFNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3831
X-TM-SNTS-SMTP: B8020ABA0B405F759B4C086B037BD5053BEADC2DE3050BB6EA779E4E2F04885F2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25384.007
X-TM-AS-Result: No--25.426-10.0-31-10
X-imss-scan-details: No--25.426-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25384.007
X-TMASE-Result: 10--25.426100-10.000000
X-TMASE-MatchedRID: /TfhfDv3EOIpwNTiG5IsEmPGZojyAoFaPbO0S2sWaK0N+F513KGyq0+m
        MtGpzwaWIVCASiY7MEIUjWDd/Oh+4dtLSbjubp9KM71h0SMVl8IGchEhVwJY3ygVbxW7FDOVSLn
        svWkgyVSDNFCP8LDMfqjpyvZE2YzMJIp5MhAnVvOHZXNSWjgdU+qhuTPUDQDtrNVhQyMnnxKVi6
        IEPauVN91CU2L3uA/PXMiY/iAeOO2M2HjKVoOdNIt6hZFSx91AmiIRKybdHSzNWDA/tkxh//7Iy
        0u8pGd3YAuqIPqt7rKxWWzz2LZKB3EwrsQriQqZyZHnIMmQ+DiNY/pqxovzxSrDA1gYfyhv9sX0
        jj6GDgrd79Rj8Xs8jTH23ywzT5a8IeFIFB+CV+wD2WXLXdz+Adi5W7Rf+s6QSMg2Oe/b8ExJaHl
        JC5ezgDj6kLXfljKxBJUFr+LNTcKeSiDxtQORDYKvnFrZK2UhX4aiKNqC2SPfc2Xd6VJ+ypt+dM
        PP5rY5fjHcmoF0kFQneo8mSRf54mLa2mSXQfrb8eSmTJSmEv2pZoxavGZhjpGLMOp0RJ2Gp7uea
        EkDqTNEORyjPs8fp2LrLIm9QmjFLfnzGsjzkkD2b09s2KGDsH4yToAKzDgmtTBPbGIfr4etksCI
        xuVJESXR4+rtSzbn2eXjdXiTHaXn5akZ7P+qqN+G9ND+fWcZD9CGMZVWk50M74Nf6tTB9tkH721
        k1bYD6vWv0JY1WEh5OPD8XJFfpEL9tcyTZdAs7ni+GTUS+xHEQdG7H66TyKsQd9qPXhnJVWgRcr
        SEFLc=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/RGVzY3JpcHRpb246IFRoaXMgcGF0Y2ggcmV2ZXJ0cyBjb21taXQgMWIwYTgzYWMwNGUzIA0K
KCJuZXQ6IGZlYzogYWRkIHBoeV9yZXNldF9hZnRlcl9jbGtfZW5hYmxlKCkgc3VwcG9ydCIpDQp3
aGljaCBwcm9kdWNlcyB1bmRlc2lyYWJsZSBiZWhhdmlvciB3aGVuIFBIWSBpbnRlcnJ1cHRzIGFy
ZSBlbmFibGVkLg0KDQpSYXRpb25hbGU6IHRoZSBTTVNDIExBTjg3MjAgKGFuZCBwb3NzaWJseSBv
dGhlciBjaGlwcykgaXMga25vd24NCnRvIHJlcXVpcmUgYSByZXNldCBhZnRlciB0aGUgZXh0ZXJu
YWwgY2xvY2sgaXMgZW5hYmxlZC4gQ2FsbHMgdG8NCnBoeV9yZXNldF9hZnRlcl9jbGtfZW5hYmxl
KCkgaW4gZmVjX21haW4uYyBoYXZlIGJlZW4gaW50cm9kdWNlZCBpbiANCmNvbW1pdCAxYjBhODNh
YzA0ZTMgKCJuZXQ6IGZlYzogYWRkIHBoeV9yZXNldF9hZnRlcl9jbGtfZW5hYmxlKCkgc3VwcG9y
dCIpDQp0byBoYW5kbGUgdGhlIGNoaXAgcmVzZXQgYWZ0ZXIgZW5hYmxpbmcgdGhlIGNsb2NrLg0K
SG93ZXZlciwgdGhpcyBicmVha3Mgd2hlbiBpbnRlcnJ1cHRzIGFyZSBlbmFibGVkIGJlY2F1c2UN
CnRoZSByZXNldCByZXZlcnRzIHRoZSBjb25maWd1cmF0aW9uIG9mIHRoZSBQSFkgaW50ZXJydXB0
IG1hc2sgdG8gZGVmYXVsdA0KKGluIGFkZGl0aW9uIGl0IGFsc28gcmV2ZXJ0cyB0aGUgImVuZXJn
eSBkZXRlY3QiIG1vZGUgc2V0dGluZykuDQpBcyBhIHJlc3VsdCB0aGUgZHJpdmVyIGRvZXMgbm90
IHJlY2VpdmUgdGhlIGxpbmsgc3RhdHVzIGNoYW5nZQ0KYW5kIG90aGVyIG5vdGlmaWNhdGlvbnMg
cmVzdWx0aW5nIGluIGxvc3Mgb2YgY29ubmVjdGl2aXR5LiANCg0KUHJvcG9zZWQgc29sdXRpb246
IHJldmVydCBjb21taXQgMWIwYTgzYWMwNGUzIGFuZCBicmluZyB0aGUgcmVzZXQgDQpiZWZvcmUg
dGhlIFBIWSBjb25maWd1cmF0aW9uIGJ5IGFkZGluZyBpdCB0byBwaHlfaW5pdF9odygpIFtwaHlf
ZGV2aWNlLmNdLg0KDQpUZXN0IHJlc3VsdHM6IHVzaW5nIGFuIGlNWDI4LUVWSy1iYXNlZCBib2Fy
ZCwgdGhpcyBwYXRjaCBzdWNjZXNzZnVsbHkNCnJlc3RvcmVzIG5ldHdvcmsgaW50ZXJmYWNlIGZ1
bmN0aW9uYWxpdHkgd2hlbiBpbnRlcnJ1cHRzIGFyZSBlbmFibGVkLg0KVGVzdGVkIHVzaW5nIGJv
dGggbGludXgtNS40LjIzIGFuZCBsYXRlc3QgbWFpbmxpbmUgKDUuNi4wKSBrZXJuZWxzLg0KDQpG
aXhlczogMWIwYTgzYWMwNGUzICgibmV0OiBmZWM6IGFkZCBwaHlfcmVzZXRfYWZ0ZXJfY2xrX2Vu
YWJsZSgpIHN1cHBvcnQiKQ0KU2lnbmVkLW9mZi1ieTogTGF1cmVudCBCYWRlbCA8bGF1cmVudGJh
ZGVsQGVhdG9uLmNvbT4NCg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Zl
Y19tYWluLmMgfCAxOSAtLS0tLS0tLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDE5IGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2ZlY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0K
aW5kZXggMjNjNWZlZjJmLi4wMmIwMTQ4MzcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2ZlY19tYWluLmMNCkBAIC0xOTE4LDcgKzE5MTgsNiBAQCBzdGF0aWMgaW50IGZlY19l
bmV0X2Nsa19lbmFibGUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGJvb2wgZW5hYmxlKQ0KIAkJ
aWYgKHJldCkNCiAJCQlnb3RvIGZhaWxlZF9jbGtfcmVmOw0KIA0KLQkJcGh5X3Jlc2V0X2FmdGVy
X2Nsa19lbmFibGUobmRldi0+cGh5ZGV2KTsNCiAJfSBlbHNlIHsNCiAJCWNsa19kaXNhYmxlX3Vu
cHJlcGFyZShmZXAtPmNsa19lbmV0X291dCk7DQogCQlpZiAoZmVwLT5jbGtfcHRwKSB7DQpAQCAt
Mjg5NSw3ICsyODk0LDYgQEAgZmVjX2VuZXRfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikN
CiB7DQogCXN0cnVjdCBmZWNfZW5ldF9wcml2YXRlICpmZXAgPSBuZXRkZXZfcHJpdihuZGV2KTsN
CiAJaW50IHJldDsNCi0JYm9vbCByZXNldF9hZ2FpbjsNCiANCiAJcmV0ID0gcG1fcnVudGltZV9n
ZXRfc3luYygmZmVwLT5wZGV2LT5kZXYpOw0KIAlpZiAocmV0IDwgMCkNCkBAIC0yOTA2LDE3ICsy
OTA0LDYgQEAgZmVjX2VuZXRfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCiAJaWYgKHJl
dCkNCiAJCWdvdG8gY2xrX2VuYWJsZTsNCiANCi0JLyogRHVyaW5nIHRoZSBmaXJzdCBmZWNfZW5l
dF9vcGVuIGNhbGwgdGhlIFBIWSBpc24ndCBwcm9iZWQgYXQgdGhpcw0KLQkgKiBwb2ludC4gVGhl
cmVmb3JlIHRoZSBwaHlfcmVzZXRfYWZ0ZXJfY2xrX2VuYWJsZSgpIGNhbGwgd2l0aGluDQotCSAq
IGZlY19lbmV0X2Nsa19lbmFibGUoKSBmYWlscy4gQXMgd2UgbmVlZCB0aGlzIHJlc2V0IGluIG9y
ZGVyIHRvIGJlDQotCSAqIHN1cmUgdGhlIFBIWSBpcyB3b3JraW5nIGNvcnJlY3RseSB3ZSBjaGVj
ayBpZiB3ZSBuZWVkIHRvIHJlc2V0IGFnYWluDQotCSAqIGxhdGVyIHdoZW4gdGhlIFBIWSBpcyBw
cm9iZWQNCi0JICovDQotCWlmIChuZGV2LT5waHlkZXYgJiYgbmRldi0+cGh5ZGV2LT5kcnYpDQot
CQlyZXNldF9hZ2FpbiA9IGZhbHNlOw0KLQllbHNlDQotCQlyZXNldF9hZ2FpbiA9IHRydWU7DQot
DQogCS8qIEkgc2hvdWxkIHJlc2V0IHRoZSByaW5nIGJ1ZmZlcnMgaGVyZSwgYnV0IEkgZG9uJ3Qg
eWV0IGtub3cNCiAJICogYSBzaW1wbGUgd2F5IHRvIGRvIHRoYXQuDQogCSAqLw0KQEAgLTI5MzMs
MTIgKzI5MjAsNiBAQCBmZWNfZW5ldF9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KIAlp
ZiAocmV0KQ0KIAkJZ290byBlcnJfZW5ldF9taWlfcHJvYmU7DQogDQotCS8qIENhbGwgcGh5X3Jl
c2V0X2FmdGVyX2Nsa19lbmFibGUoKSBhZ2FpbiBpZiBpdCBmYWlsZWQgZHVyaW5nDQotCSAqIHBo
eV9yZXNldF9hZnRlcl9jbGtfZW5hYmxlKCkgYmVmb3JlIGJlY2F1c2UgdGhlIFBIWSB3YXNuJ3Qg
cHJvYmVkLg0KLQkgKi8NCi0JaWYgKHJlc2V0X2FnYWluKQ0KLQkJcGh5X3Jlc2V0X2FmdGVyX2Ns
a19lbmFibGUobmRldi0+cGh5ZGV2KTsNCi0NCiAJaWYgKGZlcC0+cXVpcmtzICYgRkVDX1FVSVJL
X0VSUjAwNjY4NykNCiAJCWlteDZxX2NwdWlkbGVfZmVjX2lycXNfdXNlZCgpOw0KIA0KLS0gDQoy
LjE3LjENCg0KDQo+IA0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KRWF0b24gSW5k
dXN0cmllcyBNYW51ZmFjdHVyaW5nIEdtYkggfiBSZWdpc3RlcmVkIHBsYWNlIG9mIGJ1c2luZXNz
OiBSb3V0ZSBkZSBsYSBMb25nZXJhaWUgNywgMTExMCwgTW9yZ2VzLCBTd2l0emVybGFuZCANCg0K
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gRnJvbTogZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcgPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDI5LCAyMDIwIDE6NTUgUE0NCj4g
VG86IEJhZGVsLCBMYXVyZW50IDxMYXVyZW50QmFkZWxAZWF0b24uY29tPg0KPiBDYzogZnVnYW5n
LmR1YW5AbnhwLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3QGx1bm4uY2g7DQo+
IGYuZmFpbmVsbGlAZ21haWwuY29tOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGlu
dXgub3JnLnVrOw0KPiByaWNoYXJkLmxlaXRuZXJAc2tpZGF0YS5jb207IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7DQo+IGFsZXhhbmRlci5sZXZpbkBtaWNyb3NvZnQuY29tOyBRdWV0dGUsIEFybmF1ZA0K
PiA8QXJuYXVkUXVldHRlQEVhdG9uLmNvbT4NCj4gU3ViamVjdDogUmU6IFtFWFRFUk5BTF0gUmU6
IFtQQVRDSCAxLzJdIFJldmVydCBjb21taXQNCj4gMWIwYTgzYWMwNGUzODNlM2JlZDIxMzMyOTYy
YjkwNzEwZmNmMjgyOA0KPiANCj4gT24gV2VkLCBBcHIgMjksIDIwMjAgYXQgMTE6MjI6NThBTSAr
MDAwMCwgQmFkZWwsIExhdXJlbnQgd3JvdGU6DQo+ID4g77u/RGVhciBHcmVnLA0KPiA+DQo+ID4g
VGhhbmtzIGZvciB5b3VyIHJlcGx5IGFuZCBzb3JyeSBmb3IgbXkgbWlzdGFrZS4NCj4gPiBMb29r
cyB0byBtZSBsaWtlIHRoZSBpc3N1ZSBpcyB0aGUgY29tbWl0IGhhc2ggd2hpY2ggc2hvdWxkIGJl
IDEyIGNoYXJzLg0KPiA+IERvZXMgdGhhdCBtZWFuIEkgbmVlZCB0byBmaXggYW5kIHJlc2VuZCB0
aGUgd2hvbGUgdGhpbmcgdG8gZXZlcnlvbmU/DQo+IA0KPiBZZXMgcGxlYXNlLCBuZXZlciBmb3Jj
ZSBhIG1haW50YWluZXIgdG8gaGFuZC1lZGl0IGEgcGF0Y2gsIHRoZXkgd2lsbCBub3QgZG8NCj4g
c28gOikNCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQo=
