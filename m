Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4410DCFA
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 08:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfK3Hdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 02:33:53 -0500
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:11652
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbfK3Hdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Nov 2019 02:33:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/aBqZJgVcdhYy4NSEGV7hTqqZbRDjWKhcW+bOg/JBjsl1/tuPK68LBz/ZOZM1gc+h9XGvJC/yokslX1qTzeR6PDKaZeNRELeNi6rttYGKISJ33ntYZT3JY1s8S+XFC0AXETkED+hAH7V8aHFCABb7vyC8cuxMF2oRjoLeFThVFxY6r5L5F6Ee3cj5nA0L5jzFnRc7SYbZatHumJS3325KBteVaQfVysM+lJGzALUjipejEEUjiVNXRL/LqOPdDi2VAmfqi2volDquBuQ40JzyiGJmjj+TUEopnzmJZHyvtG/6jAmGNAgAt8A5JieOz1SsqoFVrFnOAyph9K2W3gmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcmHLLV3L/V0bO9myi1YVbOooWIGd5MBbAq4NCnd1Kw=;
 b=Zf+S9MQ3EOfeBKuyx9zHb5yvseNqv4zLmNM2YsQUnBZ+wyUqgCCvLfJOsWvHWur/ojuic+zWIr6UjKjyn4mkQG+EZFPxoi5YcWIdqLuFTQUtDiFG7UQ0REpiYM4UBSwQL6MCcb2PTs+yNaXiD9etN9ACHJdQ82E/Ynhemphvv7nnwuWVFN40+2guZohRlRXG6XWxVzIIrv/EHvOue5a+7aPUc0bH/bTU7iRZWp0TgPQW2r9TgFslEgQYWEIeJ1wTxHu8Ah20rIEg7X0F8/7QyfzpSi2EjRpRimrI22Nxj+Nhz24cJSXqIRd54jcxEQcxUNBA9NtnZmnPESL5/iv3KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcmHLLV3L/V0bO9myi1YVbOooWIGd5MBbAq4NCnd1Kw=;
 b=V2PEkBKNwjrhdBuLV8tmRaM5yOFSlZ1arJNEqSY2z74EUpy9XHXNIFQvgKqOQxqeXN0b5CBE7VRFY9EnYk20mqUlTkO/dxk7IlnSQL5FR75CAm0eRzE0t35n1k8+Z63IZWi0AUiVKIuMH+CrOlIgST1Rb4RTFg/VYvSmXtsPGgU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6493.eurprd05.prod.outlook.com (20.179.25.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Sat, 30 Nov 2019 07:33:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Sat, 30 Nov 2019
 07:33:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Eli Cohen <eli@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH] net/mlx5e: Fix build error without IPV6
Thread-Topic: [PATCH] net/mlx5e: Fix build error without IPV6
Thread-Index: AQHVpSZsTv6MbE28T0uVnnRWLx0w9KefZtyAgAPv1gA=
Date:   Sat, 30 Nov 2019 07:33:48 +0000
Message-ID: <4da78750d80eb7b6099849ac8ffbae528b6d78e8.camel@mellanox.com>
References: <20191127132700.25872-1-yuehaibing@huawei.com>
         <20191127.112635.1621097212312385906.davem@davemloft.net>
In-Reply-To: <20191127.112635.1621097212312385906.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2c21142-5b05-4455-437b-08d77567a3aa
x-ms-traffictypediagnostic: VI1PR05MB6493:|VI1PR05MB6493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6493FD2C56036AA2F4E4C26EBE410@VI1PR05MB6493.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02379661A3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39850400004)(189003)(199004)(51874003)(6116002)(8936002)(3846002)(6512007)(25786009)(66066001)(14454004)(2906002)(4326008)(66946007)(76116006)(91956017)(66446008)(64756008)(66556008)(66476007)(107886003)(36756003)(6246003)(5660300002)(478600001)(2501003)(446003)(99286004)(11346002)(2616005)(71190400001)(186003)(71200400001)(81156014)(81166006)(102836004)(6506007)(305945005)(26005)(229853002)(4001150100001)(7736002)(76176011)(118296001)(8676002)(86362001)(316002)(6436002)(256004)(110136005)(58126008)(54906003)(14444005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6493;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BEdPWdDJo9B5D6kGQcffefGEn2vFOyc7rNSM0f6JIASI5EgRM+A6PAraFuH//Nr2eTwncJJManhtprZOU83hFOEtWb40DLul2PaW3dE/lHldULbYPzIHSjVPLNmUzz3rLEHorYdnGjP8uayuFm0h8dNwB9OQj5NaEU/nMdAWQRMFYolGL5WqGfZHlFjwzj4GxguksBhUaW9aPayGR9ZM4YbfUgRq3zpfQLgnzp2tN+cjnCK/dQYmjfuLX+Xs8qG1eXmo/sG3LDufrBLMAJs2mslUOKTeL60BZQJ7BTAO53MADculm00Ez62E7BtuhSFlUR0S3R3tsJ5WT3NBir1kRT27HOAWeUK6g1zqGDcdBmxF66arvueEblSaADIf7bSynA0M/Cg088aFUmo6sEyu1q3i310YnvgvkxK5IaFLpxpwdO+k7QSSPFzx5HqanFSR
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BF4F1E7017E2A438762A4956EDF23CE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c21142-5b05-4455-437b-08d77567a3aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2019 07:33:48.2811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HfFK2/GqjklBYudUbOLBVfaZj5cxdr8o/sMcpr9bEusD4QmsZfr8zceUrM1bfQMaTo8bUhs2cVa4yv1FCIuVVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6493
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTI3IGF0IDExOjI2IC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCj4gRGF0ZTogV2VkLCAy
NyBOb3YgMjAxOSAyMToyNzowMCArMDgwMA0KPiANCj4gPiBJZiBJUFY2IGlzIG5vdCBzZXQgYW5k
IENPTkZJR19NTFg1X0VTV0lUQ0ggaXMgeSwNCj4gPiBidWlsZGluZyBmYWlsczoNCj4gPiANCj4g
PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfdHVuLmM6MzIy
OjU6IGVycm9yOg0KPiByZWRlZmluaXRpb24gb2YgbWx4NWVfdGNfdHVuX2NyZWF0ZV9oZWFkZXJf
aXB2Ng0KPiA+ICBpbnQgbWx4NWVfdGNfdHVuX2NyZWF0ZV9oZWFkZXJfaXB2NihzdHJ1Y3QgbWx4
NWVfcHJpdiAqcHJpdiwNCj4gPiAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4N
Cj4gPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuL3RjX3R1bi5jOjc6MDoNCj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfdHVuLmg6Njc6MTogbm90ZToNCj4gcHJldmlvdXMgZGVm
aW5pdGlvbiBvZiBtbHg1ZV90Y190dW5fY3JlYXRlX2hlYWRlcl9pcHY2IHdhcyBoZXJlDQo+ID4g
IG1seDVlX3RjX3R1bl9jcmVhdGVfaGVhZGVyX2lwdjYoc3RydWN0IG1seDVlX3ByaXYgKnByaXYs
DQo+ID4gIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gPiANCj4gPiBVc2UgI2lm
ZGVmIHRvIGd1YXJkIHRoaXMsIGFsc28gbW92ZSBtbHg1ZV9yb3V0ZV9sb29rdXBfaXB2Ng0KPiA+
IHRvIGNsZWFudXAgdW51c2VkIHdhcm5pbmcuDQo+ID4gDQo+ID4gUmVwb3J0ZWQtYnk6IEh1bGsg
Um9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0KPiA+IEZpeGVzOiBlNjg5ZTk5OGUxMDIgKCJuZXQv
bWx4NWU6IFRDLCBTdHViIG91dCBpcHY2IHR1biBjcmVhdGUNCj4gaGVhZGVyIGZ1bmN0aW9uIikN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+
IA0KPiBTYWVlZCBldCBhbC4sIGhvdyBkbyB5b3Ugd2FudCB0byBoYW5kbGUgdGhpcz8NCj4gDQoN
CkxHVE0sIEkgZ3Vlc3MgeW91IGNhbiBwdXNoIHRoaXMgdG8gbmV0IHNpbmNlIHRoaXMgaXMgZGVh
bGluZyB3aXRoIGENCmJ1aWxkIGVycm9yID8NCg0KVGhhbmtzIGluIEFkdmFuY2UsDQpTYWVlZC4N
Cg0K
