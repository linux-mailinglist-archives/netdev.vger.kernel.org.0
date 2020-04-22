Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE381B4B16
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDVQ5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:57:11 -0400
Received: from mail-dm6nam11on2093.outbound.protection.outlook.com ([40.107.223.93]:62816
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbgDVQ5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2NEsX3DBzZmu5i15lLwh3a732R2biHXfk9RXuCYkKpmlDwJ2StYCBuPQ5NaeIGRlzyv7OA4sq4qern3uSIqkLL0kBH0JpgQZg5SGvhLVVNgPVqPbQi4MLmW1rnxQvvk1X9aGTrEiCmCZVeVsYBV574HZY3b48rgp8cMk3RgAC9ILqJ/Fcyx2zltr/Q0FgKY62QRaQ6FMGzEBgtH1JolvAUtVvg/e+B4ZSYY/Lso4ff/NH+pA8dGJlgCh4p/oBlLR+90XAXHPTOhZtDEDgxbLh4+/Y0FhKBHJOKTNpRo+1oMA8vtG5YcBGxBnzvQEVdTl0w4y7QRqddFsyY+GSkAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3BSWOOc8QSMiiEmk47smM2IUEEkgwFg59PqeIOt/NM=;
 b=F8Y2vaJdsjh4FkL14CQCQkehh4OE9Lw0Xh5yHk6UeZUTImY2947LgZcbf4p+BSjgcU/2Wz6/W7lL7pKxDrMD50Os/qnbZpZWOYaI51Eh5EhSGrHzZQsplqzZgzxQRQCvcNKbKxEzf2bCqgdklQSnT7IF5dE7DVLPDprEc4zVgZ/4auow9t68Vi3YtuoOlm3SYHWPR+GJpl3DV+MB157rV5CeMspXoPkptmMjkvFtl2okL8j8Ri3gj2wJB/dYDIuXL/j5R+g2+oZBh1ZfkqnSR4RaoI6nkldxnIHKn/rBTT9fCAjOfcj/q4fBdeaGxITVIZpyTBvtSMVatFBC6iheiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3BSWOOc8QSMiiEmk47smM2IUEEkgwFg59PqeIOt/NM=;
 b=jhWotr9PanojkbrRCyJpqS40cjWj519/UkNTcGBafvFJTuW0t5lPnxcXz6ZF8Yxxjz8PORXHL2skRBcIQ7hz4oxlWPpoaSGkbXOAB8b/VBssUYLZdDVcxVXhuoGLLBieWkZSflZoS36/CCdh9/ntTEZIPF64GYw2uazdYv0QLKU=
Received: from MN2PR21MB1437.namprd21.prod.outlook.com (2603:10b6:208:208::10)
 by MN2PR21MB1214.namprd21.prod.outlook.com (2603:10b6:208:3a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.3; Wed, 22 Apr
 2020 16:57:06 +0000
Received: from MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa]) by MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa%5]) with mapi id 15.20.2958.001; Wed, 22 Apr 2020
 16:57:06 +0000
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
Subject: RE: [PATCH net-next 12/33] hv_netvsc: add XDP frame size to driver
Thread-Topic: [PATCH net-next 12/33] hv_netvsc: add XDP frame size to driver
Thread-Index: AQHWGMBMznN+BGr1VUiMOA89fIP9eqiFWuXQ
Date:   Wed, 22 Apr 2020 16:57:05 +0000
Message-ID: <MN2PR21MB1437D6D23580C11018FE8684CAD20@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757170200.1370371.9930519336386674467.stgit@firesoul>
In-Reply-To: <158757170200.1370371.9930519336386674467.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-22T16:57:04.5451065Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a29b4aac-0279-4c67-9e4c-8bfe90dc2023;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6d659f9-e804-46f3-be22-08d7e6de3020
x-ms-traffictypediagnostic: MN2PR21MB1214:|MN2PR21MB1214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB121431B5093F07B5795C622CCAD20@MN2PR21MB1214.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1437.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(55016002)(5660300002)(71200400001)(82960400001)(54906003)(110136005)(7416002)(82950400001)(4326008)(2906002)(316002)(66946007)(76116006)(33656002)(8936002)(81156014)(64756008)(8676002)(66446008)(66476007)(66556008)(7696005)(26005)(52536014)(53546011)(86362001)(6506007)(9686003)(8990500004)(478600001)(10290500003)(186003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1i/tOrS297RCnP2h+zJ2V6JtswNdqtFE5cADUXaEF9pl/nSkRVcnNvZP3dgMwYWc6cKOz4LtPDEvt0BhctFWSdSYWks8zJsxWp635oAGbCoGiVuqVyJ/YMb278++F8mMbxHZv+FiWT7iAPHhSSbLyWZChUem59qXDNC3F4oXcR6eeq72hXx5lT4YMBSmSyUj9PPHtx9UoJZHHTwfgmeExzQsV1gPyoembMl32BE+G7V8xx4Z62fFBGRPu9hEf5owD/F5AujXeBFNiYX8C6mvsbPYs/2PM/9z1RAwaN6XthY2qyS17oLXA/Y6kdU45kC3ew5oN3lZjzeoIdslAH3+xoeo5h+EvaNhAsc1IaiBExUvezbXIFeHmgcwtRUNt+nBQxS/g0nD4rEzJFeH+PjSUZLebJgSs/EyuWLNGweB69rWKR7DLtIUuYIqnVaCk0CB
x-ms-exchange-antispam-messagedata: WZPZQSYCGYMBFhawp+dFbzLH4o/frEN2ALGy9Hi8Pni/2JPveFEoZg0h92A45FS8THCvjccUlrIZDJ+ZyHllhZQK4UMpmim4oLIdZYhT70ZSwaXN3pQgwFQxueYS8eUj8+H2vsfsRxupDCnNSgbmkEzvWg4s+4BVhdsMjUu2p3W51Rb2Q4r7SuIbcDEP2fKNJkycoo8XA8VBf4G3ij3UKkW5VqLGK+nngQOheCpLoCbrKSH/0jn1/xl2u9PMXNu+ZXlk+BStSM4kvEqOdTw+BT58s1O04RAiWpFcRsB2HeqqxeYD/cluL5i+8vesRNY4S5feMtCs8A7/DBEMaC1933QJB0Dpwb1i8OrPKlRyBU4+uURsZs0enrPV3UST0WnFJ50Do+YQpL/2wKeBdYSOUtuV94aQdUNzbc2KjQAQbhO+oPIO2iq8X5Yi2dcBELBSFHw8IrTGCEcG+t0S4umxchWEfxQU4hCbTcRskfjLZuc1RJHyFjhP3FyyZqONaUsEOsuAv8PR4k5XcbgfSXmZ9QINQduIG9h3Jf2BIs8vd7xYwt3YCI325cWj6jsbpygrdEImqRzT5ENc7iYMdr7rlvbv1Pcys3/d292wuThyo6zMpcyhaq325rXla2VHu2tTu6bM+UcAWUl80FHzW/yM/ODsQbpXm/WcBC7J7oJFJ6Dj/ZT/Hu1/H88BEswzTuflJvtRWxxTdiit66/Gmo1daLRvV7YHnteOU7U+zOR78j6QPBAxqv4/SMV+GQn3hCb75fEMGZ397w7l5nQnGYVN5ke1eZoA5hVEjpnvPlAJNUY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d659f9-e804-46f3-be22-08d7e6de3020
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 16:57:05.8216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWvzKdtNNpfOIMMV9HAkx4NeUwXwePO926R0V3ixnVrQAAoR3WOYJMb80nkpGfKAXbP5O+8SHutCaOtRBFLWKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVzcGVyIERhbmdhYXJk
IEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjIs
IDIwMjAgMTI6MDggUE0NCj4gVG86IHNhbWVlaGpAYW1hem9uLmNvbQ0KPiBDYzogV2VpIExpdSA8
d2VpLmxpdUBrZXJuZWwub3JnPjsgS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+Ow0K
PiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsgU3RlcGhlbiBIZW1taW5n
ZXINCj4gPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+OyBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyDQo+
IDxicm91ZXJAcmVkaGF0LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtl
cm5lbC5vcmc7DQo+IHpvcmlrQGFtYXpvbi5jb207IGFraXlhbm9AYW1hem9uLmNvbTsgZ3R6YWxp
a0BhbWF6b24uY29tOyBUb2tlDQo+IEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNv
bT47IERhbmllbCBCb3JrbWFubg0KPiA8Ym9ya21hbm5AaW9nZWFyYm94Lm5ldD47IEFsZXhlaSBT
dGFyb3ZvaXRvdg0KPiA8YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT47IEpvaG4gRmFzdGFi
ZW5kDQo+IDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBBbGV4YW5kZXIgRHV5Y2sNCj4gPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+OyBKZWZmIEtpcnNoZXIgPGplZmZyZXkudC5raXJzaGVy
QGludGVsLmNvbT47DQo+IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT47IFdpbGxlbSBk
ZSBCcnVpam4NCj4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+OyBJbGlhcyBBcGFs
b2RpbWFzDQo+IDxpbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmc+OyBMb3JlbnpvIEJpYW5jb25p
IDxsb3JlbnpvQGtlcm5lbC5vcmc+Ow0KPiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94
LmNvbT47DQo+IHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20NCj4gU3ViamVjdDogW1BBVENI
IG5ldC1uZXh0IDEyLzMzXSBodl9uZXR2c2M6IGFkZCBYRFAgZnJhbWUgc2l6ZSB0byBkcml2ZXIN
Cj4gDQo+IFRoZSBoeXBlcnYgTklDIGRyaXZlcnMgWERQIGltcGxlbWVudGF0aW9uIGlzIHJhdGhl
ciBkaXNhcHBvaW50aW5nIGFzIGl0IHdpbGwNCj4gYmUgYSBzbG93ZG93biB0byBlbmFibGUgWERQ
IG9uIHRoaXMgZHJpdmVyLCBnaXZlbiBpdCB3aWxsIGFsbG9jYXRlIGEgbmV3IHBhZ2UNCj4gZm9y
IGVhY2ggcGFja2V0IGFuZCBjb3B5IG92ZXIgdGhlIHBheWxvYWQsIGJlZm9yZSBpbnZva2luZyB0
aGUgWERQIEJQRi0NCj4gcHJvZy4NCg0KVGhpcyBzdGF0ZW1lbnQgaXMgbm90IGFjY3VyYXRlIC0t
IFRoZSBkYXRhIHBhdGggb2YgbmV0dnNjIGRyaXZlciBkb2VzIG1lbW9yeSANCmFsbG9jYXRpb24g
YW5kIGNvcHkgZXZlbiB3aXRob3V0IFhEUCwgc28gaXQncyBub3QgImEgc2xvd2Rvd24gdG8gZW5h
YmxlIFhEUCIuDQoNClRoYW5rcywNCi0gSGFpeWFuZw0KDQo=
