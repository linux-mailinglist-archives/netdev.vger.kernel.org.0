Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA100144DEF
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAVIub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:50:31 -0500
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:6135
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbgAVIu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 03:50:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJyxWVQ2QALGvW0h3khaM7s5ELlSje3nkvDHxc0hUigSB9jGIcNkV8eWFFNMcUAfPeVDbZUpOcuR0u+RQ1v/PjnKBGVj2FSjWZllIK92KE65luK+ie6j9SCrigYwOzCvYCVfC/WyMNbMqwuo4WH9KdrfUKaq8ITnIM1ptODI54Xnu9vlu58vyzqdBmK/bC86L2BoFQKgz3K1Z1lI88pPki+MPJGVuNidogr2t4aGmJE+uIyTtgm8x1hqpFMKvs1uO/WdsfwNTyq+BAi9CiIRc60n3p5kbqgsm3DkAsp6TgnCZf6uQmIYNxPe/LbSlIKJYvAK/wk5J9lPLrzCIyHfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWYxUonErKY1qZdmGBFAEADsOJd8fI0sFXXIK3UInZk=;
 b=MlqhvWdQpHhOgLihf+Cuu/q68R8kadCXeHvgQ/mh7RJqki5GA7Na1qK7kF0v6TLZUwcjK4/KYuaiYS4EsqdxRsrWX7jiMb7OpaKCbIMISvS4OqA+OwC1Z7CkNjXvrTEgiQIuH3ETfc+CAh+lVpTVriLNrFC9nNsGb9a39D/TTK9dh5PYYVsz0tDA+hAcGrwuGoG2eab/8Uc9rG8f1D5R+Ph5liZhPONYSIoSVSAKddW1vX+cb3JcplQG22kkI+6DNNd9UPfxNcZajxLAmbWL6qwcfLiHQo7KdVYjwODfkdhaMgxTHyTP5XCX4wZa4i9UPoYNmP3BybvlbN6jHUxYzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWYxUonErKY1qZdmGBFAEADsOJd8fI0sFXXIK3UInZk=;
 b=tiMmYCjNBIbqGRAEU+iSs4JQzcOlRRmDR5AJN46byWHc9WLInJVPI38k0YxlY6vmNkvsW6wGniKRyQnZIFZ7HTL8iZbQ9RxwIHTlez/khORqAv3KmOGDjCDyvTbn6LvDvNw1R2U4U8XszfqjWNE5V3hSMK1yYrjOW65TTTqMYfY=
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) by
 AM4PR05MB3330.eurprd05.prod.outlook.com (10.171.191.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Wed, 22 Jan 2020 08:50:26 +0000
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720]) by AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720%2]) with mapi id 15.20.2644.026; Wed, 22 Jan 2020
 08:50:26 +0000
Received: from [10.223.0.122] (193.47.165.251) by AM0PR06CA0085.eurprd06.prod.outlook.com (2603:10a6:208:fa::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Wed, 22 Jan 2020 08:50:25 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Topic: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Index: AQHVxTsdBu3bf++RUEKRiOEG0pF5HafqrNAAgAA1zoCAAJTLAIAKOJIAgADHhoA=
Date:   Wed, 22 Jan 2020 08:50:26 +0000
Message-ID: <cf04db18-a989-91a1-7a37-35b17dbe36ef@mellanox.com>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
 <c4d6fe12986bd2b21faf831eb76f0f472ef903d1.camel@mellanox.com>
 <c6d4c563-f173-9ff6-83e5-95b246d90526@ucloud.cn>
 <09401ab5-1888-a19b-9e27-bd9c0cf408fe@mellanox.com>
 <fac29985c39902b1cb50426da02615285824dd6b.camel@mellanox.com>
In-Reply-To: <fac29985c39902b1cb50426da02615285824dd6b.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
x-clientproxiedby: AM0PR06CA0085.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::26) To AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d6b8e4cd-36ab-46ab-3c2e-08d79f182008
x-ms-traffictypediagnostic: AM4PR05MB3330:|AM4PR05MB3330:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB333002F8EE72B4BEA56133A1B50C0@AM4PR05MB3330.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(956004)(2616005)(66946007)(26005)(53546011)(4326008)(16526019)(186003)(52116002)(71200400001)(5660300002)(6486002)(478600001)(86362001)(36756003)(110136005)(66476007)(8936002)(66446008)(66556008)(2906002)(31686004)(31696002)(8676002)(81156014)(64756008)(81166006)(16576012)(316002)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3330;H:AM4PR05MB3396.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XM51RWEaP4ThrNeA1Y7DV8T5h+2XNZhe+Jnz4VSwKUb2STHAJHqDaICPFovvq6YTThMNWdSfFCMudOoK5qpnklzoZ8m3zJZ38zi4/oHTwfqo6nNUasovBk6LxuiK1s/f1vUC/O6NkrqScB6JT7TZbh4Gg6GSvvMBmWmUAf4d6pZwwit+lsh/dB6tO1PLR5BqLKepTzsRQ+KDAGithEpcE8HJoKixlRM2zXUrINr2zsr2NRJ9dQM6n94Tsv2H4QpOhVHxgB2L54tLV7b7RI92uMSIti8QRwRL/Bg4DwF0r8U8CVeRF73cEFzDcEnrmUEkBE1RAkNY/Owf7mJ/VlkiDWTpf7CkyrFYn9EHKMgg7dxq3NaI1pEr/B3NeSV77ENLTpcVsksY+qrHV39mP3RQTQMywidyTDkFvGkz14WIZDtx+4IpQHK798Yge48SLqfi
Content-Type: text/plain; charset="utf-8"
Content-ID: <75ECD356C9F43D49A61B0CE9CB729132@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b8e4cd-36ab-46ab-3c2e-08d79f182008
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 08:50:26.3785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JxJZwq4Nke/AIYZkZClnofetlwecQzn8lJl8mb8Tfp9WT6fv27bLWjdftLN3BPPX1sVKyvadOpxZgJ2epNmOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjAtMDEtMjEgMTA6NTYgUE0sIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiBPbiBX
ZWQsIDIwMjAtMDEtMTUgYXQgMDg6NTEgKzAwMDAsIFJvaSBEYXlhbiB3cm90ZToNCj4+DQo+PiBP
biAyMDIwLTAxLTE1IDE6NTggQU0sIHdlbnh1IHdyb3RlOg0KPj4+ICAyMDIwLzEvMTUgNDo0Niwg
U2FlZWQgTWFoYW1lZWQgOg0KPj4+PiBIaSBXZW54dSwNCj4+Pj4NCj4+Pj4gQWNjb3JkaW5nIHRv
IG91ciByZWdyZXNzaW9uIFRlYW0sIFRoaXMgY29tbWl0IGlzIGJyZWFraW5nIHZ4bGFuDQo+Pj4+
IG9mZmxvYWQNCj4+Pj4gQ0MnZWQgUGF1bCwgUm9pIGFuZCBWbGFkLCB0aGV5IHdpbGwgYXNzaXN0
IHlvdSBpZiB5b3UgbmVlZCBhbnkNCj4+Pj4gaGVscC4NCj4+Pj4NCj4+Pj4gY2FuIHlvdSBwbGVh
c2UgaW52ZXN0aWdhdGUgdGhlIGZvbGxvd2luZyBjYWxsIHRyYWNlID8NCj4+Pg0KPj4+IEhpIFNh
ZWVkICYgUGF1bCwNCj4+Pg0KPj4+DQo+Pj4gVGhpcyBwYXRjaCBqdXN0IGNoZWNrIHRoZSBtZXRh
IGtleSBtYXRjaCB3aXRoIHRoZSBmaWx0ZXJfZGV2LiAgSWYNCj4+PiB0aGlzIG1hdGNoIGZhaWxl
ZCwNCj4+Pg0KPj4+IFRoZSBuZXcgZmxvd2VyIGluc3RhbGwgd2lsbCBmYWlsZWQgYW5kIG5ldmVy
IGFsbG9jYXRlIG5ldw0KPj4+IG1seDVfZnNfZnRlcy4NCj4+Pg0KPj4+IEhvdyBjYW4gSSByZXBy
b2R1Y2UgdGhpcyBjYXNlPyBDYW4geW91IHByb3ZpZGUgdGhlIHRlc3QgY2FzZQ0KPj4+IHNjcmlw
dD8NCj4+Pg0KPj4+DQo+Pj4gQlINCj4+Pg0KPj4+IHdlbnh1DQo+Pg0KPj4gSGkgU2FlZWQsIFdl
bnh1LA0KPj4NCj4+IEkgcmV2aWV3ZWQgdGhlIHBhdGNoIGFuZCB2ZXJpZmllZCBtYW51YWxseSBq
dXN0IGluIGNhc2UuIFN1Y2ggaXNzdWUNCj4+IHNob3VsZA0KPj4gbm90IGJlIHJlcHJvZHVjZWQg
ZnJvbSB0aGlzIHBhdGNoIGFuZCBpbmRlZWQgSSBkaWQgbm90IHJlcHJvZHVjZSBpdC4NCj4+IEkn
bGwgdGFrZSB0aGUgaXNzdWUgd2l0aCBvdXIgcmVncmVzc2lvbiB0ZWFtLg0KPj4gSSBhY2tlZCB0
aGUgcGF0Y2guIGxvb2tzIGdvb2QgdG8gbWUuDQo+Pg0KPj4gVGhhbmtzLA0KPj4gUm9pDQo+Pg0K
Pj4NCj4gDQo+IA0KPiBUaGFua3MgUm9pLCANCj4gDQo+IElmIHRoZSBkaXNjdXNzaW9uIGlzIG92
ZXIgYW5kIHlvdSBhY2sgdGhlIHBhdGNoLCBwbGVhc2UgcHJvdmlkZSBhDQo+IGZvcm1hbCAiQWNr
ZWQtYnkiIHRhZyBzbyBpIHdpbGwgcHVsbCB0aGlzIHBhdGNoIGludG8gbmV0LW5leHQtbWx4NS4N
Cj4gDQo+IFRoYW5rcywNCj4gU2FlZWQuDQo+IA0KDQpJIHRob3VnaHQgSSBkaWQuIHNvcnJ5Lg0K
DQpBY2tlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4NCg==
