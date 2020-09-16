Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A4926C880
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgIPSvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgIPSJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 14:09:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C35C0A8936
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 06:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muGfER8ZXf51E/yCXMdGRX/xDIn6T6qggEl5sMNPViVNlKpagQOHp8bauUW1DNrUyo+1kCFDqxCbg86WKX7lzqXv+3bKT7467ek3C6vavRYCnTJhYKE524+pF7pwOSEiGBU18GJtOLLIi2lNOmH2Q/n0eJS+RffG2r+VPwGs9P6qXwp81Lq0KOjFGvspIXvQHcn0LhOukAxsqPhrU40qtCWaFfgtsHx+DSuyfmBLvAJNyUU6pHSmGfPeOAko4HuwjVym/Vf1OUus5cEGsaUb9Bf8FCoNzl4sCJpHX2LiQNV6HSpIOm2qsfpqj29bAh4VBemMKgUTiBu51X78bda2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c00eVYrE3Aw0Wwm52Mm5aEKAEr5nUkNGrWlakZvVvlQ=;
 b=JRDMTLPC1XY8dz5Jv2ZS/RibAR8fOE1Ajx/d/1ivfXK39Q3KIqMX2nPqDjUBjwMv8AMmzyq95z0ABTrRwKERR4QdCssY8/+CRYG7UduXNzPJoJs7/cDs/uwYFpH8Q20TQ8uN7ORxbKhISXHhGZ/aACuVLKJnwRgY0WeqRcD6ZoWp1sYlmvod6C1Jgn5htSeMe3UVi05y+f3+Zg0Czho4Wr61kZrES4seeqlhRSZcEFZtD6QgAS9xyloXho84GjL/tdT5iRsVSGKGtZCevIDGWRVQ5i6HMieXpLYFtLLCclNZbhb5Ouov7VQaNFTFx5TaxRGKh7WoOCD74R+p4wG7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c00eVYrE3Aw0Wwm52Mm5aEKAEr5nUkNGrWlakZvVvlQ=;
 b=E0SWIxxmf0zHjAP7GWp4m0MkfudimOUoFsEW7/mEhjEWczOBz/I6oNbjrZ7EBKkmc6TSax/JTmOiCP5uNV7UWfOF7hrAKxmHr3aFnS+nrfxwQcHaDViYySeGanycOBjv0Z7Oy4A4T7CWwGYpm08KFijZJcFGTdS0v5NANRO0WQQ=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VE1PR04MB6461.eurprd04.prod.outlook.com (2603:10a6:803:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 10:28:38 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 10:28:38 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWjA46YADFMZ9LUEuuxHMi/AxAAKlrCEcAgAAAYCA=
Date:   Wed, 16 Sep 2020 10:28:38 +0000
Message-ID: <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
 <20200916100024.lqlrqeuefudvgkxt@skbuf>
In-Reply-To: <20200916100024.lqlrqeuefudvgkxt@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02b03721-a7bd-4189-60cd-08d85a2b469a
x-ms-traffictypediagnostic: VE1PR04MB6461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6461BCC26A0317EDF1207FABE1210@VE1PR04MB6461.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DJPPRTe7xJZL90a+eoD0wsrIByUMkv8fM+4sfmkRgQINol8pk1b4aucv4P7Mak+7/j0f6eK2LONi5nLd2SVSFGNE55xNDHmET9X1gA4aqoTZxN1Y66ReCJGuDH9J0DG+HE0uRsG7vZuUp0tBwfi9GUbXWsrcN5Q6qP+FPe46HInCabALaSaTCjn7IBEyGJpNmR0PLp2dA59dlwhKQpKcvodzGlyuf651oCWfY1iLQljazA4bDNQcLfJrkz+lqmfgRTLb3hnHTPrt3vS8A4JxouKs94XGAwUZVtpDzYZrTx+nYSUyz2M26U57PV2B7y7S4+rxEwahx5L/uKQ8iioAAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(346002)(376002)(136003)(2906002)(66556008)(55016002)(9686003)(6916009)(71200400001)(76116006)(66446008)(66946007)(4326008)(66476007)(7416002)(83380400001)(86362001)(6506007)(8936002)(8676002)(33656002)(64756008)(52536014)(5660300002)(186003)(7696005)(316002)(53546011)(26005)(54906003)(478600001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bvycnws5ApF/HUc7Yv5OB0lIRlVffgtw/Kz6E2PYRwrhJEZOtjg/bPgWCny9e1KXxBALau2jBEOU9elPmjAi4R6O2yB669dVN5R8CsQDTg5GuIy4b20f/YLaHRwl48GAKcucmzTQLbIT7Kis4VUJ/S+gSD7OTaxi++9jbiEwzK4AKV9jxXDp9AKhWYlXQHE0D2xOw6XdmtJPoRWFNKt0QXUfSY27k0R052S3gNGW5KSIDZY/Pcd9wXyf9P/vZaoJfqS+Cm9hTzURzAbAv06hwheAuWFpJLwZGAfdbpYMb30GZYLKo/t/b2G9h22KrVSo6N7mAEEF13RcnAPjvWFI+GTvkbBMjoKVoM/Mg+Q59bAYKN5KNecb/v67KX2eppMde+GWjhUJs/6XHTMfANgdo4/8uDZn2/Z2R1ecwPnZSwmp7KuO7X5Kd4CrPXfEqLHglz4HqjztBd2id0398eX0kJQZbtG2hdgTstwQ4UN648Q9qo1Uky+JKgpSaGQ1IZicus9SVpdkqYBkM8scWdfkEGSkGUBIO9Z8WT+ItgQIFGPuxMNt24NQuUx6uupNP1bR1ocV1WKfKRuhymnrKbp7xlthRAIKF0ZXXe3t7IezOZwIfdLFLF9Wstoyr7n20FGlSg6YG/kCgOcWsWKSqdQzew==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b03721-a7bd-4189-60cd-08d85a2b469a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 10:28:38.5002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6t9ea12aBx9ZZDBp2lsmGw4uFl7gDUTgZtfOwYkd3AQ9E5UJUuyWhwOSO68bCykPlwbJvbhCGxeG2KJD8nZvUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmxh
ZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMMTqOdTCMTbI1SAx
ODowMA0KPiBUbzogSG9uZ2JvIFdhbmcgPGhvbmdiby53YW5nQG54cC5jb20+DQo+IENjOiBYaWFv
bGlhbmcgWWFuZyA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUG8gTGl1IDxwby5saXVAbnhw
LmNvbT47DQo+IE1pbmdrYWkgSHUgPG1pbmdrYWkuaHVAbnhwLmNvbT47IGFsbGFuLm5pZWxzZW5A
bWljcm9jaGlwLmNvbTsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+
OyBBbGV4YW5kcnUgTWFyZ2luZWFuDQo+IDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBW
bGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgTGVvIExpIDxsZW95
YW5nLmxpQG54cC5jb20+OyBhbmRyZXdAbHVubi5jaDsNCj4gZi5mYWluZWxsaUBnbWFpbC5jb207
IHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gamlyaUBy
ZXNudWxsaS51czsgaWRvc2NoQGlkb3NjaC5vcmc7IGt1YmFAa2VybmVsLm9yZzsNCj4gdmluaWNp
dXMuZ29tZXNAaW50ZWwuY29tOyBuaWtvbGF5QGN1bXVsdXNuZXR3b3Jrcy5jb207DQo+IHJvb3Bh
QGN1bXVsdXNuZXR3b3Jrcy5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb207DQo+IGFs
ZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29t
Ow0KPiBpdmVjZXJhQHJlZGhhdC5jb20NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2NiAz
LzNdIG5ldDogZHNhOiBvY2Vsb3Q6IEFkZCBzdXBwb3J0IGZvciBRaW5RDQo+IE9wZXJhdGlvbg0K
PiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBIaSBIb25nYm8sDQo+IA0KPiBPbiBXZWQs
IFNlcCAxNiwgMjAyMCBhdCAwNTo0ODo0NVBNICswODAwLCBob25nYm8ud2FuZ0BueHAuY29tIHdy
b3RlOg0KPiA+IEZyb206ICJob25nYm8ud2FuZyIgPGhvbmdiby53YW5nQG54cC5jb20+DQo+ID4N
Cj4gPiBUaGlzIGZlYXR1cmUgY2FuIGJlIHRlc3QgaW4gdGhlIGZvbGxvd2luZyBjYXNlOg0KPiA+
IEN1c3RvbWVyIDwtLS0tLT4gc3dwMCAgPC0tLS0tPiBzd3AxIDwtLS0tLT4gSVNQDQo+ID4NCj4g
PiBDdXN0b21lciB3aWxsIHNlbmQgYW5kIHJlY2VpdmUgcGFja2V0cyB3aXRoIHNpbmdsZSBWTEFO
IHRhZyhDVEFHKSwgSVNQDQo+ID4gd2lsbCBzZW5kIGFuZCByZWNlaXZlIHBhY2tldHMgd2l0aCBk
b3VibGUgVkxBTiB0YWcoU1RBRyBhbmQgQ1RBRykuDQo+ID4gVGhpcyByZWZlcnMgdG8gIjQuMy4z
IFByb3ZpZGVyIEJyaWRnZXMgYW5kIFEtaW4tUSBPcGVyYXRpb24iIGluDQo+ID4gVlNDOTk1OTlf
MV8wMF9UUy5wZGYuDQo+ID4NCj4gPiBUaGUgcmVsYXRlZCB0ZXN0IGNvbW1hbmRzOg0KPiA+IDEu
DQo+ID4gZGV2bGluayBkZXYgcGFyYW0gc2V0IHBjaS8wMDAwOjAwOjAwLjUgbmFtZSBxaW5xX3Bv
cnRfYml0bWFwIFwgdmFsdWUgMg0KPiA+IGNtb2RlIHJ1bnRpbWUgMi4NCj4gPiBpcCBsaW5rIGFk
ZCBkZXYgYnIwIHR5cGUgYnJpZGdlIHZsYW5fcHJvdG9jb2wgODAyLjFhZCBpcCBsaW5rIHNldCBk
ZXYNCj4gPiBzd3AwIG1hc3RlciBicjAgaXAgbGluayBzZXQgZGV2IHN3cDEgbWFzdGVyIGJyMCBp
cCBsaW5rIHNldCBkZXYgYnIwDQo+ID4gdHlwZSBicmlkZ2Ugdmxhbl9maWx0ZXJpbmcgMSAzLg0K
PiA+IGJyaWRnZSB2bGFuIGRlbCBkZXYgc3dwMCB2aWQgMSBwdmlkDQo+ID4gYnJpZGdlIHZsYW4g
YWRkIGRldiBzd3AwIHZpZCAxMDAgcHZpZCB1bnRhZ2dlZCBicmlkZ2UgdmxhbiBhZGQgZGV2DQo+
ID4gc3dwMSB2aWQgMTAwDQo+ID4gUmVzdWx0Og0KPiA+IEN1c3RvbWVyKHRwaWQ6ODEwMCB2aWQ6
MTExKSAtPiBzd3AwIC0+IHN3cDEgLT4gSVNQKFNUQUcgXA0KPiA+ICAgICAgICAgICAgIHRwaWQ6
ODhBOCB2aWQ6MTAwLCBDVEFHIHRwaWQ6ODEwMCB2aWQ6MTExKQ0KPiA+IElTUCh0cGlkOjg4QTgg
dmlkOjEwMCB0cGlkOjgxMDAgdmlkOjIyMikgLT4gc3dwMSAtPiBzd3AwIC0+XA0KPiA+ICAgICAg
ICAgICAgIEN1c3RvbWVyKHRwaWQ6ODEwMCB2aWQ6MjIyKQ0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogaG9uZ2JvLndhbmcgPGhvbmdiby53YW5nQG54cC5jb20+DQo+ID4gLS0tDQo+IA0KPiBDYW4g
eW91IHBsZWFzZSBleHBsYWluIHdoYXQgaXMgdGhlIHB1cnBvc2Ugb2YgdGhlIGRldmxpbmsgcGFy
YW1ldGVyIGNvbW1hbmQ/DQo+IEFzIGZhciBhcyBJIHVuZGVyc3RhbmQsIHRoZSBjb21tYW5kcyBm
cm9tIHN0ZXAgMiBhbmQgMyBzaG91bGQgYmVoYXZlIGxpa2UNCj4gdGhhdCwgZXZlbiB3aXRob3V0
IHJ1bm5pbmcgdGhlIGNvbW1hbmQgYXQgc3RlcCAxLg0KDQppZiBzd3AwIGNvbm5lY3RzIHdpdGgg
Y3VzdG9tZXIsIGFuZCBzd3AxIGNvbm5lY3RzIHdpdGggSVNQLCBBY2NvcmRpbmcgdG8gdGhlIFZT
Qzk5NTk5XzFfMDBfVFMucGRmLA0Kc3dwMCBhbmQgc3dwMSB3aWxsIGhhdmUgZGlmZmVyZW50IFZM
QU5fUE9QX0NOVCAmJiBWTEFOX0FXQVJFX0VOQSwgDQoNCnN3cDAgc2hvdWxkIHNldCBWTEFOX0NG
Ry5WTEFOX1BPUF9DTlQ9MCAmJiBWTEFOX0NGRy5WTEFOX0FXQVJFX0VOQT0wDQpzd3AxIHNob3Vs
ZCBzZXQgVkxBTl9DRkcuVkxBTl9QT1BfQ05UPTEgJiYgVkxBTl9DRkcuVkxBTl9BV0FSRV9FTkE9
MQ0KDQpidXQgd2hlbiBzZXQgdmxhbl9maWx0ZXI9MSwgY3VycmVudCBjb2RlIHdpbGwgc2V0IHNh
bWUgdmFsdWUgZm9yIGJvdGggc3dwMCBhbmQgc3dwMSwgDQpmb3IgY29tcGF0aWJpbGl0eSB3aXRo
IGV4aXN0aW5nIGNvZGUoODAyLjFRIG1vZGUpLCBzbyBhZGQgZGV2bGluayB0byBzZXQgc3dwMCBh
bmQgc3dwMSBpbnRvIGRpZmZlcmVudCBtb2Rlcy4NCg0KVGhhbmtzLA0KaG9uZ2JvDQoNCg==
