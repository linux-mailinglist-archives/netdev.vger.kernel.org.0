Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E520927E3
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfHSPEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:04:10 -0400
Received: from mail-eopbgr820119.outbound.protection.outlook.com ([40.107.82.119]:60704
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbfHSPEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 11:04:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MA19eBlg32HxaMNJNlDWgUX2A02NF1kU6yrYf1Qv6boMriR8M64KJvKKirnfcvNDoFoYAx8mQyVtCMM7uaGBFujk/EObnmDBvcAxF+cOCzq80iK0yvQJqC8ZK6JEEBOPVi/gyE7UtG2FLOVJUK03qdF5sqSXRqc2fIkAqnxBRdJVQsPNSKteg/7HlWBhGLuBSqtQS1ChtnZDBJipE9BdX3XUiryP7S8m6mTInyZeJ6S5dodBtieh+jESqHam+XrQ2o7+avyTxqaFcRG5XehQEmXJYwof6SdSF3mgWl9q3X0HedyQLK+1KWn2YOJn2sZWvf5q8pXYG4WwEq1Cd0vzMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qp8BQYbxkq8OF2+Fp+YT+MpJwFudhYj889OE0KoSDiM=;
 b=GpalwRJ8JELxzGNpAG52gCACpfJQ/401pwAYiEnIS4xyodllOa338nu5C1M91S/vUKXuq97XhKOs90cduBZsjlvVsd0nPbIY1XiuucYHXzVWwFN+sBT3NaDHo99kjSgJUspxy5YCe+vG/gBZNBdhUMOLFqPHh9zFRQeLJTdJME1sFm+1JXzxBXu3bCQ9POC4fqatub6W7ox5XgLei9SlZWf4lvWL6TAgZlYi5SYEXwq4IS+KvQ1B3wUB9ep2kMpTGYIQcEqakKC5SHbcQOi9G1Hc06NoJFwceZj0hT4INVZS7J1HmSsAQKJkgTs2291d7dIoCfFTVQak/tQpG1j+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qp8BQYbxkq8OF2+Fp+YT+MpJwFudhYj889OE0KoSDiM=;
 b=mMKZ0S1kRmN5JGpuwoEscc0vHjwkrozc19IV4G0WFfppClgmPzSjnVeRKHijSLzLptzrYTXr61zhGR2KVwH331UomnWw3Xkox575TZ5zaItHrm8S4tanJG5+Ky+W10i90VeaaZOeJqqoDCVtWI4tOlc2IKcr+TW2dYjNUlj9hbo=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1339.namprd21.prod.outlook.com (20.179.53.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.8; Mon, 19 Aug 2019 15:04:07 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Mon, 19 Aug 2019
 15:04:07 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Eran Ben Elisha <eranbe@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVUtO5KJU1jrlJIEqKp6cLIUfFOqb7G4QAgAD5qQCABoObIA==
Date:   Mon, 19 Aug 2019 15:04:07 +0000
Message-ID: <DM6PR21MB1337A38016EBF8D5C1AA1782CAA80@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-4-git-send-email-haiyangz@microsoft.com>
 <e2a38f24-5a63-ef89-9d69-6a0f2770a9e4@mellanox.com>
 <f81d2a27-cedc-40ca-daf6-8f3053cc2d38@mellanox.com>
In-Reply-To: <f81d2a27-cedc-40ca-daf6-8f3053cc2d38@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-19T15:04:06.1808272Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2e8fcbd4-123f-432c-a143-0d064d6794f6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ab9b884-1084-4de2-a3f2-08d724b67bc9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1339;
x-ms-traffictypediagnostic: DM6PR21MB1339:|DM6PR21MB1339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1339BE025B855154BCC619C0CAA80@DM6PR21MB1339.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(13464003)(189003)(8936002)(10090500001)(86362001)(7736002)(102836004)(8990500004)(2501003)(64756008)(305945005)(81166006)(256004)(229853002)(14454004)(99286004)(52536014)(33656002)(6506007)(26005)(66446008)(76176011)(7696005)(4326008)(5660300002)(8676002)(478600001)(6246003)(3846002)(9686003)(6436002)(316002)(186003)(81156014)(54906003)(53546011)(71200400001)(2201001)(25786009)(71190400001)(2906002)(6116002)(476003)(74316002)(66066001)(53936002)(486006)(7416002)(11346002)(446003)(76116006)(10290500003)(55016002)(66946007)(66476007)(66556008)(110136005)(22452003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1339;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bNifkam89HWFhOvjAYLyLho8Emt0Ln9Gnm7UKtNpAdYaHdmekTvi5Bo2XwBsEDL2OLxr210wDXp3RwLYA7MWxQ7n6j6CB7ktX9vq07zTF8JIThO3/aMehEfE8mPnlG0fguwDxH6aFFso5V+mF677iyEF6pZtqaJxo98ZVuhs/ipDRcwWOMDE248redsyNChoPnzjmDRxpIENkLQf4Sj/LXke2yzwyacibfdzDfA8mQGTdu+PyOfAr9Nsbq2XXNsY9SCplnlg9tQqrK7YESvb1dNXETj21Ve46657+i839t8oUmQChzTQeJ8qmiClcPD68oMwWENq/dOqMt8eWpnPIFbWnOFsydfMXcl+Dp4MqWwZ6OPIRXdSUvGAYW6sO2Lx/lkAhlQRe7Mb5Rycg2EYS8w+0alX62vgfmUDgNuL1Uc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab9b884-1084-4de2-a3f2-08d724b67bc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 15:04:07.3394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hIGNgWc5xPUF0LC5l7DRx20WOyuHVBDbSzgeLr72rKIzJy35e9xNjX11zpbN9XP3wMz+FO+kNTBSGIeb7O6LIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJhbiBCZW4gRWxpc2hh
IDxlcmFuYmVAbWVsbGFub3guY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDE1LCAyMDE5
IDc6MzUgQU0NCj4gVG86IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT47IEhhaXlhbmcg
WmhhbmcNCj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBzYXNoYWxAa2VybmVsLm9yZzsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+
OyBsZW9uQGtlcm5lbC5vcmc7DQo+IGxvcmVuem8ucGllcmFsaXNpQGFybS5jb207IGJoZWxnYWFz
QGdvb2dsZS5jb207IGxpbnV4LQ0KPiBwY2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC1oeXBlcnZA
dmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBLWSBTcmluaXZh
c2FuIDxreXNAbWljcm9zb2Z0LmNvbT47IFN0ZXBoZW4gSGVtbWluZ2VyDQo+IDxzdGhlbW1pbkBt
aWNyb3NvZnQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIG5ldC1uZXh0LCAzLzZdIG5ldC9tbHg1OiBBZGQgd3JhcHBlcnMgZm9yIEh5cGVy
ViBQQ0llDQo+IG9wZXJhdGlvbnMNCj4gDQo+IA0KPiANCj4gT24gOC8xNC8yMDE5IDExOjQxIFBN
LCBNYXJrIEJsb2NoIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiA4LzE0LzE5IDEyOjA4IFBNLCBI
YWl5YW5nIFpoYW5nIHdyb3RlOg0KPiA+PiBGcm9tOiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBt
ZWxsYW5veC5jb20+DQo+ID4+DQo+ID4+IEFkZCB3cmFwcGVyIGZ1bmN0aW9ucyBmb3IgSHlwZXJW
IFBDSWUgcmVhZCAvIHdyaXRlIC8NCj4gPj4gYmxvY2tfaW52YWxpZGF0ZV9yZWdpc3RlciBvcGVy
YXRpb25zLiAgVGhpcyB3aWxsIGJlIHVzZWQgYXMgYW4NCj4gPj4gaW5mcmFzdHJ1Y3R1cmUgaW4g
dGhlIGRvd25zdHJlYW0gcGF0Y2ggZm9yIHNvZnR3YXJlIGNvbW11bmljYXRpb24uDQo+ID4+DQo+
ID4+IFRoaXMgd2lsbCBiZSBlbmFibGVkIGJ5IGRlZmF1bHQgaWYgQ09ORklHX1BDSV9IWVBFUlZf
TUlOSSBpcyBzZXQuDQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IEVyYW4gQmVuIEVsaXNoYSA8
ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gPj4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZSB8ICAxICsNCj4gPj4gICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMgfCA2NA0KPiArKysrKysrKysr
KysrKysrKysrKysrKysNCj4gPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvbGliL2h2LmggfCAyMiArKysrKysrKw0KPiA+PiAgIDMgZmlsZXMgY2hhbmdlZCwgODcg
aW5zZXJ0aW9ucygrKQ0KPiA+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMNCj4gPj4gICBjcmVhdGUgbW9kZSAxMDA2
NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9odi5oDQo+ID4+
DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvTWFrZWZpbGUNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
TWFrZWZpbGUNCj4gPj4gaW5kZXggOGI3ZWRhYS4uYTg5NTBiMSAxMDA2NDQNCj4gPj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlDQo+ID4+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZQ0KPiA+
PiBAQCAtNDUsNiArNDUsNyBAQCBtbHg1X2NvcmUtJChDT05GSUdfTUxYNV9FU1dJVENIKSAgICs9
DQo+IGVzd2l0Y2gubyBlc3dpdGNoX29mZmxvYWRzLm8gZXN3aXRjaF9vZmZsbw0KPiA+PiAgIG1s
eDVfY29yZS0kKENPTkZJR19NTFg1X01QRlMpICAgICAgKz0gbGliL21wZnMubw0KPiA+PiAgIG1s
eDVfY29yZS0kKENPTkZJR19WWExBTikgICAgICAgICAgKz0gbGliL3Z4bGFuLm8NCj4gPj4gICBt
bHg1X2NvcmUtJChDT05GSUdfUFRQXzE1ODhfQ0xPQ0spICs9IGxpYi9jbG9jay5vDQo+ID4+ICtt
bHg1X2NvcmUtJChDT05GSUdfUENJX0hZUEVSVl9NSU5JKSAgICAgKz0gbGliL2h2Lm8NCj4gPj4N
Cj4gPj4gICAjDQo+ID4+ICAgIyBJcG9pYiBuZXRkZXYNCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYuYw0KPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYuYw0KPiA+PiBuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KPiA+PiBpbmRleCAwMDAwMDAwLi5jZjA4ZDAyDQo+ID4+IC0tLSAvZGV2L251
bGwNCj4gPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xp
Yi9odi5jDQo+ID4+IEBAIC0wLDAgKzEsNjQgQEANCj4gPj4gKy8vIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wIE9SIExpbnV4LU9wZW5JQg0KPiA+PiArLy8gQ29weXJpZ2h0IChjKSAy
MDE4IE1lbGxhbm94IFRlY2hub2xvZ2llcw0KPiA+PiArDQo+ID4+ICsjaW5jbHVkZSA8bGludXgv
aHlwZXJ2Lmg+DQo+ID4+ICsjaW5jbHVkZSAibWx4NV9jb3JlLmgiDQo+ID4+ICsjaW5jbHVkZSAi
bGliL2h2LmgiDQo+ID4+ICsNCj4gPj4gK3N0YXRpYyBpbnQgbWx4NV9odl9jb25maWdfY29tbW9u
KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHZvaWQNCj4gKmJ1ZiwgaW50IGxlbiwNCj4gPj4g
KwkJCQkgaW50IG9mZnNldCwgYm9vbCByZWFkKQ0KPiA+PiArew0KPiA+PiArCWludCByYyA9IC1F
T1BOT1RTVVBQOw0KPiA+PiArCWludCBieXRlc19yZXR1cm5lZDsNCj4gPj4gKwlpbnQgYmxvY2tf
aWQ7DQo+ID4+ICsNCj4gPj4gKwlpZiAob2Zmc2V0ICUgSFZfQ09ORklHX0JMT0NLX1NJWkVfTUFY
IHx8IGxlbiAlDQo+IEhWX0NPTkZJR19CTE9DS19TSVpFX01BWCkNCj4gPj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQo+ID4+ICsNCj4gPj4gKwlibG9ja19pZCA9IG9mZnNldCAvIEhWX0NPTkZJR19CTE9D
S19TSVpFX01BWDsNCj4gPj4gKw0KPiA+PiArCXJjID0gcmVhZCA/DQo+ID4+ICsJICAgICBoeXBl
cnZfcmVhZF9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPiA+PiArCQkJCSBIVl9DT05GSUdfQkxP
Q0tfU0laRV9NQVgsIGJsb2NrX2lkLA0KPiA+PiArCQkJCSAmYnl0ZXNfcmV0dXJuZWQpIDoNCj4g
Pj4gKwkgICAgIGh5cGVydl93cml0ZV9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPiA+PiArCQkJ
CSAgSFZfQ09ORklHX0JMT0NLX1NJWkVfTUFYLCBibG9ja19pZCk7DQo+ID4+ICsNCj4gPj4gKwkv
KiBNYWtlIHN1cmUgbGVuIGJ5dGVzIHdlcmUgcmVhZCBzdWNjZXNzZnVsbHkgICovDQo+ID4+ICsJ
aWYgKHJlYWQpDQo+ID4+ICsJCXJjIHw9ICEobGVuID09IGJ5dGVzX3JldHVybmVkKTsNCj4gPj4g
Kw0KPiA+PiArCWlmIChyYykgew0KPiA+PiArCQltbHg1X2NvcmVfZXJyKGRldiwgIkZhaWxlZCB0
byAlcyBodiBjb25maWcsIGVyciA9ICVkLCBsZW4NCj4gPSAlZCwgb2Zmc2V0ID0gJWRcbiIsDQo+
ID4+ICsJCQkgICAgICByZWFkID8gInJlYWQiIDogIndyaXRlIiwgcmMsIGxlbiwNCj4gPj4gKwkJ
CSAgICAgIG9mZnNldCk7DQo+ID4+ICsJCXJldHVybiByYzsNCj4gPj4gKwl9DQo+ID4+ICsNCj4g
Pj4gKwlyZXR1cm4gMDsNCj4gPj4gK30NCj4gPg0KPiA+IFRoaXMgc2VlbXMgb3V0IG9mIHBsYWNl
IHdoeSBub3QgZXhwb3NlIHRoaXMgZnVuY3Rpb24gYXMgcGFydCBvZiBoeXBlcnYgYW5kDQo+IG1s
eDUNCj4gPiB3aWxsIGp1c3QgcGFzcyB0aGUgcGRldi4NCj4gPg0KPiBUaGUgSFYgZHJpdmVyIHdv
cmtzIHdpdGggYmxvY2sgY2h1bmtzLiBJIGZvdW5kIGl0IGxlc3MgY29udmVuaWVuY2UgdG8gZG8N
Cj4gc28gZGlyZWN0bHksIHNvIEkgYWRkIGEgc21hbGwgd3JhcHBlciBmb3IgbWx4NSBjb3JlLg0K
PiANCj4gSGFpeWFuZ3osDQo+IERvIHlvdSBzZWUgYSByZWFzb24gdG8gZXhwb3J0IHRoaXMgY2Fs
bGJhY2sgc3R5bGUgZnJvbSB0aGUgSFlQRVJWIGxldmVsDQo+IGluc3RlYWQ/DQpJIGRvbuKAmXQg
dGhpbmsgdGhlIHdyYXBwZXIgaGFzIHRvIGJlIGluIHRoZSBodiBpbnRlcmZhY2UuIA0KT25lIGZ1
bmN0aW9uIGZvciByZWFkLCBhbm90aGVyIGZvciB3cml0ZSwgYXJlIHByZXR0eSBzdHJhaWdodCBm
b3J3YXJkLiANClVzZXJzIChvdGhlciBkcml2ZXJzKSBtYXkgdXNlIG9yIHdyYXAgdGhlbSBpbiB0
aGUgd2F5IHRoZXkgbGlrZSB0by4NCg0KVGhhbmtzLA0KLSBIYWl5YW5nDQo=
