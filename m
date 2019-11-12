Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8CF88B8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfKLGtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:01 -0500
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:38624
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbfKLGtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:49:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8L1wo/qMbs/Dsy7kH0ZcG8hHDK4IlvB1p+v3w3LFdWNkyqE70tN2pajYjCbnzC/1JVW5ckwQLk8TrLvImk6OpWqOSEGQJhPaOg1Q5FePaYSfGhGcMq2vNZFDoiKJxE0F5VB0r+pVHQkn13upO1xhFZKTOF60BroDxQQkzIYVBQVUXa019d5W/RrbJtzY41fSvXwISduwm9CdwKIB3xaDsGcDuXmOHz4598IrOA2x2ZB+6cjJ3GeCF1NV/1oL4tZy5TImxfosqREGfJsdQ0k6EaL7QCSnnsCXsvwPrkfL5D1pJW5xhEb5z7EusPRVNCfOXfrU69O5iAHit7ZUCWwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6ib3BL8bSQgKXLo/YcZ6ntOyWEjhmm/wxe8aoKuXiI=;
 b=fdwvPFCJv2SzOIfxHWUHBM4hDbzkIpdmzVmM0ljTHjI2gNd9coMoLVmflqNGkoeCILJpGJcxjXGy63wVIcAPgBncC6Z+U+g/eojxM0EoEgmagn+6vI6csrklE3HpwLSXPdRKlO+Z7STl0O5iTX6zfYS1IcU9QqzgdXYo09jLtUPKk+Z5J/gcnojuzDiluc9HwSe99TOhMyiF/S9c+VKuD3EgdZ/16cg9tf22xQnYVpFm5xHRu9QJDPyo9idJ1LV2Nwko6yN1suNZE6Q4/gXRd7unFbiSpn9/+rst4TulV0lGoILZKJfX7HwrGPujSTAMV4v+S5ndcbNvTab5O/XoAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6ib3BL8bSQgKXLo/YcZ6ntOyWEjhmm/wxe8aoKuXiI=;
 b=BP/wFSygPpbaMWjcCb9DZNp3Ct5z2erDzfsXsbtR2ebkb9VkUBi+ZF9wc4DC0ewW76QRYT0ZUcqbe5Djb9i8pjihN3f/RMh58ZKtsG7bFF1KpTv1y/3qlDD5Hh9wKVJJS/1uTYbDVqaCg8Z4grsuSjF0xA+iDff7ZxmhWnRN7JU=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6751.eurprd04.prod.outlook.com (20.179.235.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 06:48:55 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 06:48:55 +0000
From:   Po Liu <po.liu@nxp.com>
To:     David Miller <davem@redhat.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Topic: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Index: AQHVmEpHUNIqbyQIWEm27TZfncKzVKeHCa6AgAAP+tA=
Date:   Tue, 12 Nov 2019 06:48:54 +0000
Message-ID: <VE1PR04MB6496D524B017403835DA467492770@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
 <20191111.215047.316217567209805516.davem@redhat.com>
In-Reply-To: <20191111.215047.316217567209805516.davem@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e40dc9cd-1386-4b10-1bee-08d7673c62d6
x-ms-traffictypediagnostic: VE1PR04MB6751:|VE1PR04MB6751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6751939570E1B2B22D1F49C192770@VE1PR04MB6751.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(13464003)(76116006)(229853002)(102836004)(26005)(7696005)(6916009)(76176011)(256004)(478600001)(316002)(52536014)(55016002)(66556008)(99286004)(6246003)(9686003)(6436002)(2906002)(66446008)(53546011)(6506007)(66946007)(66476007)(6116002)(5660300002)(4326008)(64756008)(3846002)(66066001)(44832011)(33656002)(186003)(8676002)(8936002)(476003)(486006)(81156014)(81166006)(446003)(11346002)(74316002)(25786009)(71190400001)(71200400001)(14454004)(7736002)(86362001)(54906003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6751;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXPqcQhqq7I/BJM9/lNDhzzaHcGOVi0aW+TIeVK+ZBUTsv8GWWMVBBAIRUswg1kuFwPWSNuuYFvPCFlJAtFikDhmEt+mExLdXEFBiR0C/S97OeFDr3oKJ3SOdD+OtuUsfpYOPRQUiedgZhzd7WHEoaiP0V7Ut9K0Q7F5T2WP1Asea0I6raLRzZced0oAk521HbVNFacZ8JFJz3QzWMpQCUIugyomVX6IQnII+U0+A0ozN2dVbvjijObul72Olzl8QOotbUYx237TZ6qBNkaSYqJJFnapIOyAFmGuZ/iyR/cRfmpYc8jC/V/EABFXx5X0md4R23t7sXk2WnHua4fYzv94yZxmUsPdFLB01BtXwmucatkVIuzgCi3iOesbxewfzMkIt724dOYlUCfNvMeJtJSchIlZBZaggLnltjUF60H/NZmsOgQqpoh/Ipt4kpZq
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40dc9cd-1386-4b10-1bee-08d7673c62d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 06:48:54.8063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OyL2A11j5FdjAZeBA5lXH6Z0PYF9WIeCCe+Smp1vrbG6j9n95ytjlBd3pzmXxDhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiBGcm9tOiBEYXZpZCBNaWxsZXIgPGRhdmVtQHJlZGhhdC5jb20+DQo+IFNlbnQ6IDIwMTnE
6jEx1MIxMsjVIDEzOjUxDQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogQ2xh
dWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyB2aW5pY2l1cy5nb21lc0BpbnRl
bC5jb207IFZsYWRpbWlyIE9sdGVhbg0KPiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+OyBBbGV4
YW5kcnUgTWFyZ2luZWFuDQo+IDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBYaWFvbGlh
bmcgWWFuZw0KPiA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUm95IFphbmcgPHJveS56YW5n
QG54cC5jb20+OyBNaW5na2FpIEh1DQo+IDxtaW5na2FpLmh1QG54cC5jb20+OyBKZXJyeSBIdWFu
ZyA8amVycnkuaHVhbmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8bGVveWFuZy5saUBueHAuY29tPg0K
PiBTdWJqZWN0OiBbRVhUXSBSZTogW25ldC1uZXh0LCAxLzJdIGVuZXRjOiBDb25maWd1cmUgdGhl
IFRpbWUtQXdhcmUgU2NoZWR1bGVyIHZpYQ0KPiB0Yy10YXByaW8gb2ZmbG9hZA0KPiANCj4gQ2F1
dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBGcm9tOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBE
YXRlOiBNb24sIDExIE5vdiAyMDE5IDA0OjQxOjI2ICswMDAwDQo+IA0KPiA+ICtmc2wtZW5ldGMt
JChDT05GSUdfTkVUX1NDSF9UQVBSSU8pICs9IGVuZXRjX3Fvcy5vDQo+IA0KPiBDb2RlIGlzIEtj
b25maWcgZ3VhcmRlZC4NCj4gPiArICAgICBjYXNlIFRDX1NFVFVQX1FESVNDX1RBUFJJTzoNCj4g
PiArICAgICAgICAgICAgIHJldHVybiBlbmV0Y19zZXR1cF90Y190YXByaW8obmRldiwgdHlwZV9k
YXRhKTsNCj4gDQo+IFlldCBpbnZva2VkIHVuY29uZGl0aW9uYWxseS4NCj4gDQo+IEkgY2FuIHNl
ZSBqdXN0IGJ5IHJlYWRpbmcgeW91ciBjb2RlIHRoYXQgdmFyaW91cyBjb25maWd1cmF0aW9ucyB3
aWxsIHJlc3VsdCBpbiBsaW5rDQo+IGVycm9ycy4NCg0KSSBnZXQgaXQuIFRoYW5rcyENCg0KPiAN
Cj4gIC4uLg0KPiA+ICtpbnQgZW5ldGNfc2V0dXBfdGNfdGFwcmlvKHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2LCB2b2lkICp0eXBlX2RhdGEpIHsNCj4gPiArICAgICBzdHJ1Y3QgdGNfdGFwcmlvX3Fv
cHRfb2ZmbG9hZCAqdGFwcmlvID0gdHlwZV9kYXRhOw0KPiA+ICsgICAgIHN0cnVjdCBlbmV0Y19u
ZGV2X3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiArICAgICBpbnQgaTsNCj4g
PiArDQo+ID4gKyAgICAgZm9yIChpID0gMDsgaSA8IHByaXYtPm51bV90eF9yaW5nczsgaSsrKQ0K
PiA+ICsgICAgICAgICAgICAgZW5ldGNfc2V0X2Jkcl9wcmlvKCZwcml2LT5zaS0+aHcsDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJpdi0+dHhfcmluZ1tpXS0+aW5kZXgs
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGFwcmlvLT5lbmFibGUgPyBp
IDogMCk7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiBlbmV0Y19zZXR1cF90YXByaW8obmRldiwg
dGFwcmlvKTsgfQ0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+ID4NCg0K
