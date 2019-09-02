Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6FA539F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbfIBKH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:07:58 -0400
Received: from mail-eopbgr740047.outbound.protection.outlook.com ([40.107.74.47]:53184
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729489AbfIBKH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:07:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4zD7HNpoS0mdCBKaV4wsULG86O7p0I0KyArVszjjQOw4MhqgfUeUmIGwO8sMRx6YqxhQ2mvnvnWszUyieA/GwXa68RC1qip2Em5rYpSU8a1vHDBbp0M6B58wKyLlvDASbSIQa6UOKzx+TdY3vavL2xqAcIPwxV1gkdOV9LRFSbAssybomz9SkhNgeW2dgstodvQuPfQ1IuF1KadsLtI+QhaeKGj3D3phb0rj+i6IozHvRdCz7X9qVfH/2FXnNHyuCLv6LevorQo2jkG2MRSFtjdu8oZe8SBHXzUu2BkfTHK15gF2TsZtWmx+RLvbpQWNFyzfV+jn+Y1ScypnaT5/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj2203PCGaknhJVaFZHHGnCNFShM9MZgCANxO+CCjOA=;
 b=hLf9IKAI+I9N/YkBWu4IqFIIGr36eIBOQEVX5LnNJT/FC3bXWhcB4xHt4qW1GUugxsXq5Y+l2r66q9BkDAngjW+Bbd5BaoOGZ6sDV/qH2VQ2uIfY8Ob/3gjCgPAnwEL8n8tnGS1n1bD+JJWYHG3O65h+bLC0iJO/lHb4dMaZS7o/78BWrfkQbWHnK7RU9qZ8urjxZ48cO/f3K6HLebBg8lnwE2X8yoUSgxS5GItqsG0/S9/0Ed3CrogvIuaz3KkjGxQKaFp/ZyUcnUrteYaRlnfFuVRVkCeBbbmUKhxed6MdcnAH11KoA1OUwQTiEaFeFzh4un/aHd6cfdzDDo0aTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj2203PCGaknhJVaFZHHGnCNFShM9MZgCANxO+CCjOA=;
 b=KSgPX7mULTI4gFnRN/Qr5GQavAey6Js1BHlMVVjJenPopwRhaQSd0mYsSsf8itp94521I+32RfHNP/4QMH23eCGezgCYP94EWXJkSYXow4BT0ECtVuTxNMPca1/YMNPr3hx3vXxxOV/8K12tLINrkS9QlJq2rrtZ17QMqlG4Uek=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB4049.namprd11.prod.outlook.com (10.255.130.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Mon, 2 Sep 2019 10:07:55 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2220.020; Mon, 2 Sep 2019
 10:07:54 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
Thread-Topic: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
Thread-Index: AQHVXyui7AATDwHFhkStapckJw4rMg==
Date:   Mon, 2 Sep 2019 10:07:54 +0000
Message-ID: <859f9522-649b-01f4-f746-14937e9e915f@aquantia.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
 <20190830232856.6200abd2@cakuba.netronome.com>
 <20190831.133618.60802477215444924.davem@davemloft.net>
In-Reply-To: <20190831.133618.60802477215444924.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0072.eurprd07.prod.outlook.com
 (2603:10a6:3:64::16) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 011602d5-52a4-402a-7d8e-08d72f8d6c04
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB4049;
x-ms-traffictypediagnostic: BN6PR11MB4049:
x-microsoft-antispam-prvs: <BN6PR11MB40499ED152F2F1E2483DCF1498BE0@BN6PR11MB4049.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(346002)(39840400004)(396003)(199004)(189003)(14454004)(31686004)(4326008)(6506007)(386003)(102836004)(26005)(186003)(52116002)(476003)(2616005)(486006)(44832011)(86362001)(31696002)(76176011)(446003)(11346002)(2501003)(71190400001)(6246003)(66446008)(64756008)(66556008)(71200400001)(66946007)(2906002)(5660300002)(4744005)(66476007)(8936002)(81156014)(6116002)(66066001)(8676002)(316002)(6512007)(110136005)(6436002)(53936002)(99286004)(478600001)(36756003)(25786009)(305945005)(7736002)(6486002)(256004)(229853002)(3846002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB4049;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bvZAlLEe+YcatvBEPu3zvcBSSR/y51QtJkkHLJe3OtEkDZUZZOj3Y584Kr4GWrBWEwQy5TtmeASzNtuHvoStsJU8P+V9Z4RIwW86SeEfRfrTz5KQFKfqdSmWdHnbPbTn0XNVgeO/ghdLOFxoOCT8ejR9PoJWQrGfZZrZdq7jnZNZqgH/8IxZPiJIOOUVPiivxblaor4kFAO2R/Wl5IQi88vy32/och46wkK5NY77+vorvVk8Da07dOyqvo5LVyscbmKHUecu45PcUS79IQgNokh7STu+m/6D4AuIrDBheKN51Nvyev0HrZF3dgM4mD0V1Y3qHOK6JutV6vadTLkfhSMBGklrW4znVF+o+ueAkTRKpotTlS4bQWW/zHhzXGe4ef6Pqb89m2wn9YqlqxY7mq4UAVnWVc68xNYVqvYo7GE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD7ABAD4434CF647B282BE354A1FF7DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011602d5-52a4-402a-7d8e-08d72f8d6c04
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 10:07:54.7950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4POiLApH1FwxDO4I2sspzKe+uQz9oLqnaLfII2DzT/ddgtTUTlQ1kimsmnj5/wCjt46kHxDs870H84/l4h/A9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+Pg0KPj4gTEdUTSwgRml4ZXMgdGFnIHNob3VsZCBoYWQgYmVlbiBmaXJzdCB0aGVyZSBvbiBw
YXRjaCA0Lg0KPiANCj4gU2VyaWVzIGFwcGxpZWQgd2l0aCBmaXhlcyB0YWcgb3JkZXJpbmcgZml4
ZWQgaW4gcGF0Y2ggNC4NCg0KVGhhbmtzIEpha3ViLCBEYXZpZCwNCg0KPiBZb3Ugc2hvdWxkIGFs
c28gcGVyaGFwcyBjaGVjayB0aGUgcmV0dXJuIHZhbHVlIGZyb20NCj4gbmFwaV9jb21wbGV0ZV9k
b25lKCkgYXMgYW4gb3B0aW1pemF0aW9uIGZvciBuZXQtbmV4dD8NCg0KUmlnaHQsIHRoYW5rcywg
d2lsbCBwdXQgdGhhdCB3aXRoIG5leHQgbmV0LW5leHQgcGF0Y2hzZXQuDQoNClJlZ2FyZHMsDQog
IElnb3INCg==
