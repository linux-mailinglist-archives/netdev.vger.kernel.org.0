Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA939A721
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392140AbfHWF3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:29:53 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:29377
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387557AbfHWF3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 01:29:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBE5p1zcaoMfqOpytfPTvF5LbUXbNLxY8xARTLyqMV7WKYLNMw/AJwKpkwo9Ib0ycZHHZjfDQmcPKfz93oL3E7v7ijp/U6HW2Nkd9m2e5xuW5wdKGj1RFtjshJplqGwWZ55HONsWDyv12m7XTn5EJEEkpHS/D2/7DeadKkSrkrKIvNI11NLLYxGa9k/iFrJYema3oKDbLEzeU+hqes5yJH9rMhaiTLBIX8n+cl2A2XCnxpdvWRggXILNwfAZA6JwqAYxa/LM7TcgCuJkpWckwkcJ0QuyS/qxKC0aaMSZ98bjIBDVk/6PPlN75H8yMxZL4wy2dTJseWKM/4oesbN6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+WEjn2svcEvToFpi9uCRGeqlOIG+8XQwktFO0mlFgc=;
 b=k1L1eU8BaDU06oEk7YnOZ0UAytCUDYWPyrcYMEXasOjUXRwCkVzH77/xZYSmOryU7MpwDWu7e2w2OdybG5j3KcC+4fT8Ul9YY5J+O8TzW46EtQa638whMiCvC9J24qXFCWLKvazmTCOqzV2Ex26y8pgFsjw8Ak9IEp8ETtj68pxoIJVMkY8BcpcsDL8GSpdurdyzSIp+nnfCZGSdqqCc6kAShlpEKjyiGAyjkpm2qIpVJQT6n/otc2sRdP4V1WvdMubaMCz3uBYlfDpCWVzTDUTUVNltzeRVxKOAIsfQzcIAjAOO6+SF4W/GFw0FCZRrRmBD6W7qCO/cpVvxxd+DMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+WEjn2svcEvToFpi9uCRGeqlOIG+8XQwktFO0mlFgc=;
 b=gb6J0mlRexthQ+xp7kW1tx4K9KoMr/LQLq3HbA84IVkG1vb7u1m76/QO6HLBuh4+FWuCgPLcY7uo0/fiHAUWF6DCHwgIq1+wNJ+Pm15+SxhbM7RQ4SE9BYc8+Oitn1VDmDS5DM9Y265GyT+I8NNavxojucTLZJVw7xegko+tdl0=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2739.eurprd05.prod.outlook.com (10.172.222.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 05:29:48 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 05:29:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        haiyangz <haiyangz@microsoft.com>
CC:     kys <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Topic: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWTieJNg4lNlPokigzqQxpEz7DacHwLuAgAAAK6CAAAF/AIAAcrYA
Date:   Fri, 23 Aug 2019 05:29:48 +0000
Message-ID: <f7a0ce8822e197ace496a348a14ac6939313d8f6.camel@mellanox.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
         <20190822.153315.1245817410062415025.davem@davemloft.net>
         <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
         <20190822.153912.2269276523787180347.davem@davemloft.net>
In-Reply-To: <20190822.153912.2269276523787180347.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae7633af-695e-4195-516c-08d7278aea53
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2739;
x-ms-traffictypediagnostic: AM4PR0501MB2739:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB27398D27ACEC59B020FB535ABEA40@AM4PR0501MB2739.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39850400004)(396003)(199004)(189003)(256004)(81156014)(305945005)(4326008)(14444005)(25786009)(7416002)(6246003)(7736002)(53936002)(478600001)(14454004)(36756003)(6486002)(229853002)(76116006)(66556008)(91956017)(486006)(66476007)(64756008)(66446008)(66946007)(6512007)(6436002)(86362001)(5660300002)(476003)(2616005)(11346002)(76176011)(2501003)(1511001)(4744005)(446003)(66066001)(3846002)(6116002)(26005)(186003)(58126008)(8936002)(102836004)(71200400001)(71190400001)(316002)(6506007)(118296001)(54906003)(110136005)(81166006)(99286004)(8676002)(2906002)(42413003)(142933001)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2739;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CBscFu4hTD+sjgHAkb5WHD5WRX4kaYwITGFqMj7FiXM5kreqqJ6MvqsAClvqJP9P021DQNPL1AGO2fJWSq23zX5U/bh6laObeOezZWlOJ1ZBoHniinNFk7mbCktwfbHNweM9yloQVm5xPAgC9FgyQ9kD4I7S9mFsd1sg/rMT7N1wSbdR48BxJ8N8p1bgCTu9spsWWQWp334m62tJG9xN7bK0rpbxmu2vX8PqC7LEsjMbHYIXrSkvwM8fjHtJhQuLrEkaQVz95LVadDCsuNv6TUtw/UWglIlX/0e1nEOcUd1PBmxVTZfAGbI+pGJSGFeChvRVyqWqtshZjwTalXN5x+IdzwKuzqw41B11//UbzR12/SeIB7+z5p45d8OzTrsGMk+mSU0Cp/5+rZGk4lcVRffzGECbQd78sTOV/UpFylM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A38AD13F917E245912CB4DF7CC053CB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7633af-695e-4195-516c-08d7278aea53
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 05:29:48.5224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T6oRx5+8UZwQ1sKHaFKUhjXHgWirgAu82wAAKo/2yY07Lx8Tqdjv9raqR2coAxrO4mNWFLcECcmLqNy7lTtymg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTIyIGF0IDE1OjM5IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQo+IERhdGU6IFRo
dSwgMjIgQXVnIDIwMTkgMjI6Mzc6MTMgKzAwMDANCj4gDQo+ID4gVGhlIHY1IGlzIHByZXR0eSBt
dWNoIHRoZSBzYW1lIGFzIHY0LCBleGNlcHQgRXJhbiBoYWQgYSBmaXggdG8NCj4gcGF0Y2ggIzMg
aW4gcmVzcG9uc2UgdG8NCj4gPiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4uDQo+
IA0KPiBXZWxsIHlvdSBub3cgaGF2ZSB0byBzZW5kIG1lIGEgcGF0Y2ggcmVsYXRpdmUgdG8gdjQg
aW4gb3JkZXIgdG8gZml4DQo+IHRoYXQuDQo+IA0KPiBXaGVuIEkgc2F5ICJhcHBsaWVkIiwgdGhl
IHNlcmllcyBpcyBpbiBteSB0cmVlIGFuZCBpcyB0aGVyZWZvcmUNCj4gcGVybWFuZW50Lg0KPiBJ
dCBpcyB0aGVyZWZvcmUgbmV2ZXIgYXBwcm9wcmlhdGUgdG8gdGhlbiBwb3N0IGEgbmV3IHZlcnNp
b24gb2YgdGhlDQo+IHNlcmllcy4NCg0KRGF2ZSwgSSB0aGluayB5b3UgZGlkbid0IHJlcGx5IGJh
Y2sgdG8gdjQgdGhhdCB0aGUgc2VyaWVzIHdhcyBhcHBsaWVkLg0KU28gdGhhdCBtaWdodCBoYXZl
IGNyZWF0ZWQgc29tZSBjb25mdXNpb24gZm9yIEhhaXlhbmcuDQoNCg0K
