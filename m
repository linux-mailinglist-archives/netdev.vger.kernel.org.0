Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546EE1BFDCD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgD3OUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:20:25 -0400
Received: from mail-bn8nam11on2138.outbound.protection.outlook.com ([40.107.236.138]:27233
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbgD3OUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 10:20:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgkOZ13QIXb6AWSyuMas2gnt7PIdYIaLTwt1w32+9TGfR2EEA0MAJa2LdiIuG9KBshL4ie12nxlb5y4/m0ffIwMtKtbB6y7aev3utvx8q55/LQ36JlwJJqKUMObh/+3byyCZ5jMB3nBUt+qEvIvzx0wm4FCmQD/10RGU3/fE2qV/gmu/3oyxXtuQAcspYxX5Lvh5JiDXIiRHpq+f7rG7Y1cT7i9hW20zqhSMYl319L9VhrQqm6xDqY6CSwUgxpBIfCVwVIfjJEvD1H13g1xs4t67RuO5dHJXamc2IVJDZsCpqBnLb6LmhWDN8NooK+oisedKbyfIoKB7Z9DCMOeHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw2r3gEkjnc4eFINwZyPtQboIssUp/2BhYJKA8opJXk=;
 b=TslimKCFng8NKmQc/mOY7XqEuqJMbiK8UMxNj/U7/Areij0E0A4CLbtVqNfxc2ykj6gW+o3pZjEUN+M9CzxAvqi/4Pe4hAPD6eDMarnFszEMeu033CjpgTdrdPCO5ss3ECCVvylLW/oHy8rX2NJh0TuZTo9ncCGrpX50gOJT9qVMWCsN9jydG/YSia61X4HJp8mduIrCTrdh+GJYsSwARj5JY5fkh+XdMCYH5VmK30n/StzhrieIJnbd+J3XIBtoHuGyyO7qN8Tz2YVXBLchK7h+Mtm63scqqzKGRZ+QCQLJzguCTfC57bXw6wsHP8TqcfgCJfCsXfODupptjabCAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw2r3gEkjnc4eFINwZyPtQboIssUp/2BhYJKA8opJXk=;
 b=fieZEMKv/Hvh1Ut80lh47lftOjGntUuGcAzeUnjcapNlDbpx5/hIKb0JRTQLcPqXjrYasGB3X1G8AP5l+b4g9p0uzzBl06Z4xKWeaaMe5E4VkfTndmFTGt2QlIJKkRxG0HWxrOLjZNv6SdIuXA1pBDLuWpKnW/X+W8LNPT/1eDE=
Received: from MN2PR21MB1437.namprd21.prod.outlook.com (2603:10b6:208:208::10)
 by MN2PR21MB1440.namprd21.prod.outlook.com (2603:10b6:208:205::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.3; Thu, 30 Apr
 2020 14:20:21 +0000
Received: from MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa]) by MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa%6]) with mapi id 15.20.2979.005; Thu, 30 Apr 2020
 14:20:21 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>
CC:     Wei Liu <wei.liu@kernel.org>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
Subject: RE: [PATCH net-next v2 12/33] hv_netvsc: add XDP frame size to driver
Thread-Topic: [PATCH net-next v2 12/33] hv_netvsc: add XDP frame size to
 driver
Thread-Index: AQHWHuGGxXK6SlAFTkOuB//iHWVjW6iRtcfg
Date:   Thu, 30 Apr 2020 14:20:20 +0000
Message-ID: <MN2PR21MB1437A4F44AC313E5DF962B35CAAA0@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824568241.2172139.9308631605958332864.stgit@firesoul>
In-Reply-To: <158824568241.2172139.9308631605958332864.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-30T14:20:18.3172932Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7cfc276d-1320-467e-b44b-94b6b3de1475;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eda5568e-4a7b-436d-b50f-08d7ed119da3
x-ms-traffictypediagnostic: MN2PR21MB1440:|MN2PR21MB1440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1440F093B1B1D7A61EF67567CAAA0@MN2PR21MB1440.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I3unNTxtRJhnqKNGDM+nKr0cKEYJqXPe4h5a/qSJE4N1D8FbpLWNJ3huZyD/5wWQOCSqLAYcqNrWCO4q7ezByd9DhI8azee86xU8Rw7oX08Jk/pqSOXX/nYQ27Qxfnozh0YkLgEk2fMMMH7Pbz8jri6M4djToZAFiM9lmqfrriG5PXo6MM3LrNlyRZBQDFjT/UOkKDYGvvdChQXhg1SRlqgmJ7n4mYEju4TDq9OP0pheB71/YKYnHkYFqsBbf8EnfD30IOje8mrOXB1vePiRNVTTuQkFN2bPYNb3VKz84Fp09s2UkV70q2QNosS+MPvwF9p18ZtJRcxlP/GznB0vcUXrQJPUhdsGOoJ6XDW5gzOeYq/89+nkfxH1u3CttoCMp3FXaNVEcAvkJ/NVL9dWlXDPeqWgf/uxHnWbGdpLjk448vmvPETTBD7np6b9C6ya
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1437.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(82950400001)(66446008)(10290500003)(66476007)(64756008)(8676002)(66946007)(33656002)(26005)(82960400001)(316002)(54906003)(86362001)(8936002)(110136005)(52536014)(66556008)(9686003)(8990500004)(55016002)(4326008)(7416002)(478600001)(5660300002)(2906002)(7696005)(186003)(76116006)(53546011)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: R0hpG+4WWIFNvUEM+xar2F2RPvKdxsrxOXWZ5HEDLApazQ5ZZu3b8TOrVnV86Q9m5hvU+zhZl6cc72ONK5tUC8Bg2OhppYYJNmtLGoenWIQ7zMgqOdP6g9KtOekyrPNFuci55SSCuhkULNYInLrN8JG/9HlF+3eNwTLoHCKKCdaaqrPM8rJwpkz1XE04hanGkosNYyG7nOQY2ocodmipi5/kAUXKKfcjwJ+UIFBT7aDR8D6oFljtLYgamE+nVUswJe7ziZd802bgXSG+ZyzOIu/T1mWdRAK6p4WNQaPsm/mpYBZrzXDG+UHnkspFvUu0wzyQGnCh+0OPHZj7dT7EeH63ZN5c87o+Xp0bUtKt1N1EiiBCxf5eH4xhPnmrRBhtFYRHVf6bPwZxlkiiUFCkOkoG7ABG9vNDMYm7+BqrO6fS2y7JNXajB22M7NmbKWO7Xb857qV3C8pkiQJrkrl2dB5cv3lj5elirMTJLxNy7mlyuTTH+tuU+MeDiur8RRlPOC9Bt8g+X6EABn2ddojNe0So6R3Wm4nYFfDm4nHrF1T4myh1Nj0lE6lZ6CbEn8JSV9ogk1C6ftDYMNx3XvKjMyeXu20/n391DkcFMHi5sAJypa8o/y568KyKVb+VHxuKt0n9r7r6tH2SIYjrFC+PxQIC1wcLRPB9HUrX41tnwU4oUBiX3TSPYTq0adTmU1YiDCMDVYcjfnJiqKrGjLWVuuXJJWSga9M+XnLyNctNHfENjqtjy51ziGKkR3yub0TX5mx0/CRpW2wYyKpHboauVHShLfIKBAMWiO5RDWrnCWg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda5568e-4a7b-436d-b50f-08d7ed119da3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 14:20:20.7997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B07p7jbiOZ1bqDXhlrxvt1qt6TZFSAWLzXuSuBhAjhuDM/DJqyBgnC5Edf9tZg9qyblf0uIzKM8U79/IsIuTiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVzcGVyIERhbmdhYXJk
IEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAzMCwg
MjAyMCA3OjIxIEFNDQo+IFRvOiBzYW1lZWhqQGFtYXpvbi5jb20NCj4gQ2M6IFdlaSBMaXUgPHdl
aS5saXVAa2VybmVsLm9yZz47IEtZIFNyaW5pdmFzYW4gPGt5c0BtaWNyb3NvZnQuY29tPjsNCj4g
SGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT47IFN0ZXBoZW4gSGVtbWluZ2Vy
DQo+IDxzdGhlbW1pbkBtaWNyb3NvZnQuY29tPjsgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA8
YnJvdWVyQHJlZGhhdC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5rZXJu
ZWwub3JnOw0KPiB6b3Jpa0BhbWF6b24uY29tOyBha2l5YW5vQGFtYXpvbi5jb207IGd0emFsaWtA
YW1hem9uLmNvbTsgVG9rZQ0KPiBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+
OyBEYW5pZWwgQm9ya21hbm4NCj4gPGJvcmttYW5uQGlvZ2VhcmJveC5uZXQ+OyBBbGV4ZWkgU3Rh
cm92b2l0b3YNCj4gPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+OyBKb2huIEZhc3RhYmVu
ZA0KPiA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPjsgQWxleGFuZGVyIER1eWNrDQo+IDxhbGV4
YW5kZXIuZHV5Y2tAZ21haWwuY29tPjsgSmVmZiBLaXJzaGVyIDxqZWZmcmV5LnQua2lyc2hlckBp
bnRlbC5jb20+Ow0KPiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+OyBXaWxsZW0gZGUg
QnJ1aWpuDQo+IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPjsgSWxpYXMgQXBhbG9k
aW1hcw0KPiA8aWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnPjsgTG9yZW56byBCaWFuY29uaSA8
bG9yZW56b0BrZXJuZWwub3JnPjsNCj4gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5j
b20+Ow0KPiBzdGVmZmVuLmtsYXNzZXJ0QHNlY3VuZXQuY29tDQo+IFN1YmplY3Q6IFtQQVRDSCBu
ZXQtbmV4dCB2MiAxMi8zM10gaHZfbmV0dnNjOiBhZGQgWERQIGZyYW1lIHNpemUgdG8gZHJpdmVy
DQo+IA0KPiBUaGUgaHlwZXJ2IE5JQyBkcml2ZXJzIFhEUCBpbXBsZW1lbnRhdGlvbiBpcyByYXRo
ZXIgZGlzYXBwb2ludGluZyBhcyBpdCB3aWxsDQo+IGJlIGEgc2xvd2Rvd24gdG8gZW5hYmxlIFhE
UCBvbiB0aGlzIGRyaXZlciwgZ2l2ZW4gaXQgd2lsbCBhbGxvY2F0ZSBhIG5ldyBwYWdlDQo+IGZv
ciBlYWNoIHBhY2tldCBhbmQgY29weSBvdmVyIHRoZSBwYXlsb2FkLCBiZWZvcmUgaW52b2tpbmcg
dGhlIFhEUCBCUEYtDQo+IHByb2cuDQpUaGlzIG5lZWRzIGNvcnJlY3Rpb24uIEFzIEkgc2FpZCBw
cmV2aW91c2x5IC0tIA0KVGhpcyBzdGF0ZW1lbnQgaXMgbm90IGFjY3VyYXRlIC0tIFRoZSBkYXRh
IHBhdGggb2YgbmV0dnNjIGRyaXZlciBkb2VzIG1lbW9yeSANCmFsbG9jYXRpb24gYW5kIGNvcHkg
ZXZlbiB3aXRob3V0IFhEUCwgc28gaXQncyBub3QgImEgc2xvd2Rvd24gdG8gZW5hYmxlIFhEUCIu
DQoNClRoYW5rcywNCi0gSGFpeWFuZw0K
