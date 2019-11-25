Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019011086A6
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 04:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKYDDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 22:03:45 -0500
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:54985
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbfKYDDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 22:03:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grCDG7WzflCk8IyTTjrZkMMWXEu4iza8Q7R++4Y59QLjL15LEXOJGsaXGYsUsUX/1i5BgYRZXH0JSSZJRkHhIqfzXFrwRIElf8bKp1wFHDrEO9Mk+Ehs4dsQc5tHranCSU52avmcQ04p+RP4qCWwocsI6YpUMrkNZc1S++wBegxIdwt+9Qr46iwg5yJ04IJRxHrB3DOUC0z1qNjfal1I76RvMFYOWxwtSDZ4+l8RbxXOR2RcxEWvvXMuoM4aOeS19cc+1MojdcaFWLG+HJy+f/amelmo6C+iWebkDVd1SYE9oB1k+qjnYbCbgj/DGUpz6Jo9+aNGLoCKgago5I1LwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57YYtK8qx6D/v9YZs88nCbjafr0q5rut2S0EWJFzhsY=;
 b=ab+22QKgyCs+o5uC/vDbI8dDKoQetICdWmt5qqLlkaKREljkwoBJpxmXGIJh2vIgm1nPD5cKpSEIrUc48UqeOADrYG20gnBzhU2WIy+gpFgFmOYW4mLjGy6rnXd5rZ6n6Anp10149CX5q2gyFb9x8g596WtLucINzOzOCXphnYYRbrNTmFCd4SPJCW+vQ9/ZUN5QMnTRPk/amCHj3RqA3S2biwjqARrZq4i/PhBIY0I8t2KVL28ud4rZHvmiXUjP94XQVzORHQVAlL6iEo0pyFjlufbrUeibjXF5jNgjl3gIMrvdcIiVcbtaMrfUEtyJcuZTspFN5YI6q6zBHEVrxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57YYtK8qx6D/v9YZs88nCbjafr0q5rut2S0EWJFzhsY=;
 b=A/dDl4Ba5IU2T9zHc5fbjMbeQSZf+eEN2DKr2p/6h32shpptxdMZMI/L8fnaBEHxujqEi41TTSemJqm0C33r7QdKs2j2VbaZkyANc4/lYtIeidMNAOhdSGW8Mshcy8tNQhDTQiaBU6iKZ9zcQj9Ux9OcC6dmQVy3lf69eBoautc=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6605.eurprd04.prod.outlook.com (20.179.234.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Mon, 25 Nov 2019 03:03:40 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 03:03:40 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next] enetc: add support Credit Based Shaper(CBS)
 for hardware offload
Thread-Topic: [EXT] Re: [net-next] enetc: add support Credit Based Shaper(CBS)
 for hardware offload
Thread-Index: AQHVoQTfZRfPw7RK9Uq/YjFUdit1aqeZpRWAgAFYcgCAADjWYA==
Date:   Mon, 25 Nov 2019 03:03:39 +0000
Message-ID: <VE1PR04MB6496B0088B6D6558CD714A76924A0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191122070321.20915-1-Po.Liu@nxp.com>
        <20191123190209.5ad772fc@cakuba.netronome.com>
 <20191124153458.14015cb2@cakuba.netronome.com>
In-Reply-To: <20191124153458.14015cb2@cakuba.netronome.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d0844c6-0cbd-45f5-1a61-08d77154130c
x-ms-traffictypediagnostic: VE1PR04MB6605:|VE1PR04MB6605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6605E78A1DBD17A460BE1D72924A0@VE1PR04MB6605.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(13464003)(189003)(199004)(7696005)(4326008)(44832011)(76116006)(25786009)(186003)(316002)(76176011)(66446008)(99286004)(64756008)(66556008)(66476007)(66946007)(55016002)(6436002)(52536014)(9686003)(54906003)(446003)(14444005)(256004)(11346002)(66066001)(81166006)(81156014)(305945005)(229853002)(8936002)(6916009)(478600001)(74316002)(3846002)(33656002)(6116002)(7736002)(71200400001)(71190400001)(86362001)(53546011)(102836004)(6506007)(6246003)(26005)(2906002)(14454004)(8676002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6605;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 31s9fJjMdZbjwI7vs9I+FPz+NKrQF2u37I04ELUFvRkx17aju5zrmSUhbZGSTLSQFIUYfQjBi2i92gAEEABjBaKNysixtJR6JyI8xx/FHvFTxyCWmsNj5pcOIPm3JI99LHs/uo2abN0PeTlfZBX2xdgY7W6NsvZo3ogaTBY5AFw0boRqo0z9ThvMFyE8PL0QdaW6L9KNvVZbwtMvhPxfM3NoLxrorB7HmqOVxZykb3pQ/jbeqJV0wPQhuVVPOvEJ5+zT95c5tDFGVGvCNa5d+vtAjFbSywBXAOjd84L8THL4wkXYnaKdwzxfumU/MqfuEyuixlZrpyI2ohIpsyM/IHrAE3ljImVMFnLG1Ks6bokTQeDvZfkCyY09/ViPzUeww65Vpz9sXf0IHOsZ+m8JWWyhi3yNMidzSDksEMXtzExGG2+OtxMDkISCnsf7ibXo
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0844c6-0cbd-45f5-1a61-08d77154130c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 03:03:40.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: asB8cBbI2oTD8Z+wtObkhVM7zn95hr3LXM01FZltRm3Husjrsv+3Hes4rdgcGDxn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNClRoYW5rcyENCg0KDQpCciwNClBvIExpdQ0KDQo+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxqYWt1Yi5raWNpbnNraUBuZXRy
b25vbWUuY29tPg0KPiBTZW50OiAyMDE5xOoxMdTCMjXI1SA3OjM1DQo+IFRvOiBQbyBMaXUgPHBv
LmxpdUBueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmluaWNpdXMuZ29tZXNA
aW50ZWwuY29tOyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZs
YWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+Ow0KPiBBbGV4YW5kcnUgTWFy
Z2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBYaWFvbGlhbmcgWWFuZw0KPiA8
eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUm95IFphbmcgPHJveS56YW5nQG54cC5jb20+OyBN
aW5na2FpIEh1DQo+IDxtaW5na2FpLmh1QG54cC5jb20+OyBKZXJyeSBIdWFuZyA8amVycnkuaHVh
bmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8bGVveWFuZy5saUBueHAuY29tPg0KPiBTdWJqZWN0OiBb
RVhUXSBSZTogW25ldC1uZXh0XSBlbmV0YzogYWRkIHN1cHBvcnQgQ3JlZGl0IEJhc2VkIFNoYXBl
cihDQlMpIGZvcg0KPiBoYXJkd2FyZSBvZmZsb2FkDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwN
Cj4gDQo+IE9uIFNhdCwgMjMgTm92IDIwMTkgMTk6MDI6MDkgLTA4MDAsIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPiA+IE9uIEZyaSwgMjIgTm92IDIwMTkgMDc6MTc6MTggKzAwMDAsIFBvIExpdSB3
cm90ZToNCj4gPiA+ICsgICBpZiAodGMgPT0gcHJpb190b3ApIHsNCj4gPiA+ICsgICAgICAgICAg
IG1heF9pbnRlcmZlcmVuY2Vfc2l6ZSA9IHBvcnRfZnJhbWVfbWF4X3NpemUgKiA4Ow0KPiA+ID4g
KyAgIH0gZWxzZSB7DQo+ID4gPiArICAgICAgICAgICB1MzIgbTAsIG1hLCByMCwgcmE7DQo+ID4g
PiArDQo+ID4gPiArICAgICAgICAgICBtMCA9IHBvcnRfZnJhbWVfbWF4X3NpemUgKiA4Ow0KPiA+
ID4gKyAgICAgICAgICAgbWEgPSBlbmV0Y19wb3J0X3JkKCZzaS0+aHcsIEVORVRDX1BUQ01TRFVS
KHByaW9fdG9wKSkgKiA4Ow0KPiA+ID4gKyAgICAgICAgICAgcmEgPSBlbmV0Y19nZXRfY2JzX2J3
KCZzaS0+aHcsIHByaW9fdG9wKSAqDQo+ID4gPiArICAgICAgICAgICAgICAgICAgIHBvcnRfdHJh
bnNtaXRfcmF0ZSAqIDEwMDAwVUxMOw0KPiA+ID4gKyAgICAgICAgICAgcjAgPSBwb3J0X3RyYW5z
bWl0X3JhdGUgKiAxMDAwMDAwVUxMOw0KPiA+ID4gKyAgICAgICAgICAgbWF4X2ludGVyZmVyZW5j
ZV9zaXplID0gbTAgKyBtYSArICh1NjQpcmEgKiBtMCAvIChyMCAtIHJhKTsNCj4gPiA+ICsgICB9
DQo+ID4gPiArDQo+ID4gPiArICAgLyogaGlDcmVkaXQgYml0cyBjYWxjdWxhdGUgYnk6DQo+ID4g
PiArICAgICoNCj4gPiA+ICsgICAgKiBtYXhTaXplZEZyYW1lICogKGlkbGVTbG9wZS9wb3J0VHhS
YXRlKQ0KPiA+ID4gKyAgICAqLw0KPiA+ID4gKyAgIGhpX2NyZWRpdF9iaXQgPSBtYXhfaW50ZXJm
ZXJlbmNlX3NpemUgKiBidyAvIDEwMDsNCj4gPiA+ICsNCj4gPiA+ICsgICAvKiBoaUNyZWRpdCBi
aXRzIHRvIGhpQ3JlZGl0IHJlZ2lzdGVyIG5lZWQgdG8gY2FsY3VsYXRlZCBhczoNCj4gPiA+ICsg
ICAgKg0KPiA+ID4gKyAgICAqIChlbmV0Q2xvY2tGcmVxdWVuY3kgLyBwb3J0VHJhbnNtaXRSYXRl
KSAqIDEwMA0KPiA+ID4gKyAgICAqLw0KPiA+ID4gKyAgIGhpX2NyZWRpdF9yZWcgPSAoRU5FVENf
Q0xLICogMTAwVUxMKSAqIGhpX2NyZWRpdF9iaXQNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
LyAocG9ydF90cmFuc21pdF9yYXRlICogMTAwMDAwMFVMTCk7DQo+ID4NCj4gPiBIaSEgVGhlIHBh
dGNoIGxvb2tzIGdvb2QgdG8gbWUsIGJ1dCBJJ20gY29uY2VybmVkIGFib3V0IHRob3NlIDY0Yml0
DQo+ID4gZGl2aXNpb25zIGhlcmUuIERvbid0IHRoZXNlIG5lZWQgdG8gYmUgZGl2X3U2NCgpICYg
Y28uPyBPdGhlcndpc2Ugd2UNCj4gPiBtYXkgc2VlIG9uZSBvZiB0aGU6DQo+ID4NCj4gPiBFUlJP
UjogIl9fdWRpdmRpMyIgW2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9mc2wt
ZW5ldGMua29dDQo+IHVuZGVmaW5lZCENCj4gPg0KPiA+IG1lc3NhZ2VzIGZyb20gdGhlIGJ1aWxk
IGJvdC4uDQo+ID4NCj4gPiBJIGNvdWxkIGJlIHdyb25nLCBJIGhhdmVuJ3QgYWN0dWFsbHkgdGVz
dGVkLi4NCj4gDQo+IFl1cDoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9l
bmV0Yy9lbmV0Y19xb3MubzogSW4gZnVuY3Rpb24NCj4gYGVuZXRjX3NldHVwX3RjX2Nicyc6DQo+
IGVuZXRjX3Fvcy5jOigudGV4dCsweDViNCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYF9fdWRp
dmRpMycNCj4gZW5ldGNfcW9zLmM6KC50ZXh0KzB4NjA4KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0
byBgX191ZGl2ZGkzJw0KPiAvaG9tZS9qa2ljaW5za2kvZGV2ZWwvbGludXgvTWFrZWZpbGU6MTA3
NzogcmVjaXBlIGZvciB0YXJnZXQgJ3ZtbGludXgnIGZhaWxlZA0KPiBtYWtlWzFdOiAqKiogW3Zt
bGludXhdIEVycm9yIDENCj4gbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgJy9ob21lL2praWNp
bnNraS9kZXZlbC9saW51eC9idWlsZF90bXAyJw0KPiBNYWtlZmlsZToxNzk6IHJlY2lwZSBmb3Ig
dGFyZ2V0ICdzdWItbWFrZScgZmFpbGVkDQo+IG1ha2U6ICoqKiBbc3ViLW1ha2VdIEVycm9yIDIN
Cj4gDQo+IFBsZWFzZSBmaXggYW5kIHJlcG9zdC4NCg0KV2lsbCB1cGRhdGUgdG8gZGl2X3U2NCgp
Lg0K
