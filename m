Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76351EB7A1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgFBIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:50:03 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:19041
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBIuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 04:50:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWKC9PDEGJGHaEm0WrO/VKp1ZQczh7YXRVlFYpvrTkgVaHuw1kVqxPbnMKhBZdA6g2SvO+O7SQ04B63v5yNGfW+siB1yv9Gmnkwav+zV8dvSs/MNC/HcQXT1T7N45b7PTrzogxB5vPqCcIIvxc/QWToUxdMDhACI2Y6c3AWFUdDaVf+2h47mlmqal+ZhV+xYyS3WEnkEwr/A5INlej5JfwDMCUQidNQrE7IAL4gs3SbTAXJ37YhiXo5uD2F+V9w7kyA6sraUc/qSEytDUlEZpzXAEfsXlvsmrWpuBstGvQBNt5eBLaGkRviGWgboe8Yy0uq12UWNgHZMdDur33Ig4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5umUObFYf08UQk3FhK1WDQndXNqX+zJiQRgK+o9X0g=;
 b=IIIRyWYl3Tw38RaDhZt6ECZTOLIEuyUX2IjaicnK0xP4JUp5iQVT7bzWcaus8F9Jmo6N7M/KjvSUzZEwkuDi7Lepqkn3cV81m431uU7GgyBQt1E0k65ZKryyXbmclMov25Dy46dqu37C3TlxnknU0GEuCfkDGUuMMRyPy7mK9KaNidEzW9zXYIB98OYtyTTWcHEXJXfIntzaMRVqCujh15p/A02pyAg6BeLX5/CAqmoPy9ERCmx8YTsziBqX93XxAHzeQtKimzsUmnplMsiJO3XPQfIK/Py9hVPmbiuZCJ+rrwZbCmI8tYmXeThjVKXcf14NWbC00Y6SstaVTw6hEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5umUObFYf08UQk3FhK1WDQndXNqX+zJiQRgK+o9X0g=;
 b=Y9YrWGMgZSBrJiz8CmTZbbtRMJXnIabV/QhCJh7yf1iARQLgqnVg84yMeTDD4hWas7dcSFAm6pGIzi58srk8X+P+XTjETMbcdhCFce5RYrJELC/n8CraSr1ZF2zj3cRf+Et5A2u7RWqU/1K/MarVbCq0a+a5AOZzVSgcyqxl/4U=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5770.eurprd04.prod.outlook.com (2603:10a6:10:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Tue, 2 Jun
 2020 08:49:58 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665%3]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 08:49:58 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 00/10] net: ocelot: VCAP IS1 and ES0
 support
Thread-Topic: [EXT] Re: [PATCH v2 net-next 00/10] net: ocelot: VCAP IS1 and
 ES0 support
Thread-Index: AQHWOJ4Fuv2ph3WWWkedqpufch3pGajE91GAgAAAmhA=
Date:   Tue, 2 Jun 2020 08:49:58 +0000
Message-ID: <DB8PR04MB5785D8DA658A4557973EA233F08B0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <CA+h21hp5K8BvNSuWKuAc_tVYeLpRUqrZtfvFz+3hdLWcAOfMag@mail.gmail.com>
In-Reply-To: <CA+h21hp5K8BvNSuWKuAc_tVYeLpRUqrZtfvFz+3hdLWcAOfMag@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a5d29b3-db86-45aa-c291-08d806d1ee0e
x-ms-traffictypediagnostic: DB8PR04MB5770:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB57701146B244E85A3047E425F08B0@DB8PR04MB5770.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CpT20s6Jky0vigr6h9Ggkir5XVRHgCLzwzR84OLDMxMlRTMkuEpAyUFGzHeTWNGvsDC9tQlkrxUZz9e+5kfEtxWodsWbc6K5Cp45XrIsP0U5THDTfpErPMWAscA9+BlGDvT33KWZEapZdeU3UrC0x/yFbzDlPI/vtcwaMcjb/zcIzc8WkczK8vu/ysZ5yIHZEdl9ebyOnKvPB8i9jhDiY5UfDfvpWefKQtBymA4gR31T+os3/fJswMfM0poLdqe9B35t3IgLdjzDaKSHDfx+KrOm+wNDy9CqZ/FT9nPl9jxIz94LGtSXzgLXAatFQxHzIrvxJoxrz9YphegxP5Dgj4P0KDuJ3BwGEJRPdLVif0Xw//CkI76Dx5xXQFXRVE8moFVfCVgAxd82JZ/jPgsISg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6506007)(966005)(8936002)(86362001)(71200400001)(4326008)(45080400002)(33656002)(7416002)(478600001)(8676002)(7696005)(2906002)(83380400001)(52536014)(9686003)(186003)(66446008)(64756008)(66556008)(66476007)(55016002)(26005)(54906003)(66946007)(316002)(76116006)(5660300002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WI+xr9GZ1waG+10C1WBBzc1Mvu2RG3UtRyeYghHlGuSRQFO48s06IWkvAsMtLY6eA04rtQfE7ct28i5WbItDRtnB7cJbB8XozNv7QLyo6sndQKR0lhCjWTJU8eepyfkZQSCGFF5/02OD1iMtxJDVW4YL0ixPdT+37UrIkpFfNHeHMQJPqtAL6CODhtBnOgCjsBM1yMud1CZQC0mueoFpZEbLLQOV1QCVSCl56okeO1vlVOYbHwZ2oQQ79WvZoBaLecJjJ8ZAE6eH6wwH13wNII4kVEnmhbxGOuSDsJLGD0uhPN/YAUPpmNBbj/SrLP1kfvBEzjbExV1yjPS3+NRXKvz4L+eoIDd48F0xaK8Q15iq5sSU0DB3cKE3cDa7Q1y117yxISNz6VcXMoBSsml70mfTBFFhdE7uHpa1uL378Cjn6IMlc2WQsddz3te/94xJRNmLSrRCPUkfeXI3Tmg0xhitx7Z8HqqLACs8DXIpB28=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5d29b3-db86-45aa-c291-08d806d1ee0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 08:49:58.3782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9SsXwcGgeME8al39z6sBBzgEAcWEA7a9ui6nGQdeqK+Noe0ji7JtmHpVI3ITOyhBzmfPuo6FxdpBX0CexJsw4isjW8j527J5M2lkRj7CIQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFR1cywgMiBKdW4gMjAyMCBhdCAxNjowNCwNCj4gRmlyc3Qgb2Yg
YWxsLCBuZXQtbmV4dCBoYXMganVzdCBjbG9zZWQgeWVzdGVyZGF5IGFuZCB3aWxsIGJlIGNsb3Nl
ZCBmb3IgdGhlIGZvbGxvd2luZyAyIHdlZWtzOg0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5w
cm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cDolMkYlMkZ2Z2VyLmtlcm5lbC5vcmclMkZ+
ZGF2ZW0lMkZuZXQtbmV4dC5odG1sJmFtcDtkYXRhPTAyJTdDMDElIDdDeGlhb2xpYW5nLnlhbmdf
MSU0MG54cC5jb20lN0MyZmFkNDQ5NWRhYmM0ZjRjYTVmZDA4ZDgwNmNiNzBhZiU3QzY4NmVhMWQz
YmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzcyNjY4MTgxMTc2NjYzODYmYW1w
O3NkYXRhPXppVnliV2I0SHpZWGFuZWhGNUt3TnY1UkpMJTJCWno2TmVGdnJaV2c2NTdCOCUzRCZh
bXA7cmVzZXJ2ZWQ9MA0KPg0KPiBTZWNvbmRseSwgY291bGQgeW91IGdpdmUgYW4gZXhhbXBsZSBv
ZiBob3cgZGlmZmVyZW50IGNoYWlucyBjb3VsZCBleHByZXNzIHRoZSBmYWN0IHRoYXQgcnVsZXMg
YXJlIGV4ZWN1dGVkIGluIHBhcmFsbGVsIGJldHdlZW4gdGhlIElTMSwNCj4gSVMyIGFuZCBFUzAg
VENBTXM/DQo+DQoNCkRpZmZlcmVudCBUQ0FNcyBhcmUgbm90IHJ1bm5pbmcgaW4gcGFyYWxsZWws
IHRoZXkgaGF2ZSBmbG93IG9yZGVyOiBJUzEtPklTMi0+RVMwLiBVc2luZyBnb3RvIGNoYWluIHRv
IGV4cHJlc3MgdGhlIGZsb3cgb3JkZXIuIA0KRm9yIGV4YW1wbGU6DQoJdGMgcWRpc2MgYWRkIGRl
diBzd3AwIGluZ3Jlc3MNCgl0YyBmaWx0ZXIgYWRkIGRldiBzd3AwIGNoYWluIDAgcHJvdG9jb2wg
ODAyLjFRIHBhcmVudCBmZmZmOiBmbG93ZXIgc2tpcF9zdyB2bGFuX2lkIDEgdmxhbl9wcmlvIDEg
YWN0aW9uIHZsYW4gbW9kaWZ5IGlkIDIgcHJpb3JpdHkgMiBhY3Rpb24gZ290byBjaGFpbiAxDQoJ
dGMgZmlsdGVyIGFkZCBkZXYgc3dwMCBjaGFpbiAxIHByb3RvY29sIDgwMi4xUSBwYXJlbnQgZmZm
ZjogZmxvd2VyIHNraXBfc3cgdmxhbl9pZCAyIHZsYW5fcHJpbyAyIGFjdGlvbiBkcm9wDQpJbiB0
aGlzIGV4YW1wbGUsIHBhY2thZ2Ugd2l0aCAodmlkPTEscGNwPTEpIHZsYW4gdGFnIHdpbGwgYmUg
bW9kaWZpZWQgdG8gKHZpZD0yLHBjcD0yKSB2bGFuIHRhZyBvbiBJUzEsIHRoZW4gd2lsbCBiZSBk
cm9wcGVkIG9uIElTMi4NCg0KSWYgdGhlcmUgaXMgbm8gcnVsZSBtYXRjaCBvbiBJUzEsIGl0IHdp
bGwgc3RpbGwgbG9va3VwIG9uIElTMi4gV2UgY2FuIHNldCBhIHJ1bGUgb24gY2hhaW4gMCB0byBl
eHByZXNzIHRoaXM6DQoJdGMgZmlsdGVyIGFkZCBkZXYgc3dwMCBjaGFpbiAwIHBhcmVudCBmZmZm
OiBmbG93ZXIgc2tpcF9zdyBhY3Rpb24gZ290byBjaGFpbiAxDQoNCkluIGFkZGl0aW9uLCBWU0M5
OTU5IGNoaXAgaGFzIFBTRlAgYW5kICJTZXF1ZW5jZSBHZW5lcmF0aW9uIHJlY292ZXJ5IiBtb2R1
bGVzIGFyZSBydW5uaW5nIGFmdGVyIElTMiwgdGhlIGZsb3cgb3JkZXIgbGlrZSB0aGlzOiBJUzEt
PklTMi0+UFNGUC0+ICJTZXF1ZW5jZSBHZW5lcmF0aW9uIHJlY292ZXJ5IiAtPkVTMCwgd2UgY2Fu
IGFsc28gYWRkIGNoYWlucyBsaWtlIHRoaXMgdG8gZXhwcmVzcyB0aGVzZSB0d28gbW9kdWxlcyBp
biBmdXR1cmUuDQoNCkJUVywgd2hlcmUgc2hvdWxkIEkgc2VudCBwYXRjaGVzIHRvIGR1ZSB0byBu
ZXQtbmV4dCBjbG9zZWQ/DQoNClRoYW5rcywNClhpYW9saWFuZyBZYW5nDQo=
