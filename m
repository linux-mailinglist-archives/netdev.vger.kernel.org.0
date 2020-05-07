Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125D11C87F7
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGLXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:23:20 -0400
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:19373
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbgEGLXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:23:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ib9KQQvVMplk4bSqG8uF5F0HsrhB6+xjciJe2ypJIpY+mrLLJHcdwDEDt/CjSj08p3PlvAdRGTPtN/w4BfffbC5UDSenqUr/rGzze5fG6fxATxDGzE0JNh3lqxY1cPqvhFoKgxNvgvOzBC3ghGiZZ0t9loJWGegdBgl2z1A00Tmpsulx4ZPiAYGyF5KqEoRbEExER5RbOoRqWWtyL3TCNrx+qLpmbULhHCPHOQX0h4Hga5Ck2AxbjOK4h1KtPlm20ycPwJ6RKX5UOshmTErPm8BpIHKmTdXvajL3M7v+9okXjE5i17s5hy1pXwmLXz999BEPSwJYoYTGuXit7BxG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/o9OJ8WBS7vJFNaJ6hEWHKqjKmqSnXGx/fJWU5N7ac=;
 b=cvXCU/IFt93pABnvvJmSjwsC7a7No7wuuqZC0Xd0ol0xyJ5TwCBdH0uUsIDmczRpRXRaJWqLRmJHjaxkHxEIzdMCFQSBBZp6HsQtqx6vq2XMCQZyb90mZOA+GO4p+V1GHrBunVz6PBVqwLgzmmd+FySBdv7bnPr4fsl5AAzMxk9OonyLlkUoFdzuWEvWeo//C+ghRPTYYRfy+7qoT7RqNRKOOF+rBR2fC149EZkeBhYuKWE8X9BOAE1mIvPrZ32ALTJ5+i1IeREWj2iOekKeLZP+fSNvnoCe7zEJwKHHS3/3c2NSVSvLMyMeynOkb7oR7LnaZcVpOxlXqosX4tRZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/o9OJ8WBS7vJFNaJ6hEWHKqjKmqSnXGx/fJWU5N7ac=;
 b=qdmcsPZDEfPj4nqNL66tPfjTmrR4A+kb/3QC4eczoXS4h92qm1geNIvSPMhFQ1F7E0n5o+SDiCmmau8QyfLrUZ/YjzUBSr0Pk4cJFsgyIfqh4IDC6VWGvF2ZReOmpayMCPCqr+EndU3S/gczJDlAgKYRJGJ+2QR++XI6WGLuauQ=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB6521.eurprd04.prod.outlook.com (2603:10a6:10:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.21; Thu, 7 May
 2020 11:23:14 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315%7]) with mapi id 15.20.2958.034; Thu, 7 May 2020
 11:23:14 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
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
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1
 support
Thread-Topic: [EXT] Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1
 support
Thread-Index: AQHWI3uAf2gl/EIdB0qZ02Lm2M34p6iazrSAgAATcoCAAK3tgIAA5Nlw
Date:   Thu, 7 May 2020 11:23:14 +0000
Message-ID: <DB8PR04MB5785BE9AC6FAC6F395C8A20DF0A50@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
 <20200506074900.28529-5-xiaoliang.yang_1@nxp.com>
 <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
 <CA+h21hoqJC_CJB=Sg=-JanXw3S_WANgjsfYjU+ffqn6YCDMzrA@mail.gmail.com>
 <20200506211551.cf6mlad7ysmuqfvq@ws.localdomain>
In-Reply-To: <20200506211551.cf6mlad7ysmuqfvq@ws.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 408e9864-d3a3-422d-9fce-08d7f27908b2
x-ms-traffictypediagnostic: DB8PR04MB6521:|DB8PR04MB6521:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB652139F06EB9C200D2B79BD5F0A50@DB8PR04MB6521.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O0IkoZaHTVYSw4R0XyCat8xP3wdKWCIsOs9ipJd3uCsv0F5woJzyRVzaFaw8xskYBUT4N0jCB8nLh98dSe8ORIkrbXQ0xBE1XKQua2UQjPcsYXxWM9Oij+HYDcloFIoD8rDdGJ15XtTq6nsl2k2pS4IAa2ko+v+yKOoMXj8noWrpYZzQn5wQMvWraXFEIeuRXo3lVboCPzclGKl5mSmgVqIaSp+hnudj8ORNer2VWXGVmzgdZSjRCwpAcfooy6CIR7jTatVCni9rTIAV78/QQr6ZqzFGB90FVvzxl8vQID2Y6bFpsIJwm5VHaErn6FxxU5MCmhmglxNG4SXQRipM7qziRvdwEH/odX0hEquEKSUbM0C+galVoZ4yEKM6+MKxJKNKR3YjzLX+sQHa/tsXKmItNIFZAOC2iCQZZ7dVM8BU8YIUzgbQof5bsR6X60LyF/73MRP4gPdcMxt4TJ8h8ect/hhInkUXszFk/NRgHYQ3hNbkRivSbOYseck9prKf+fpKa+Ldyhc0+Vfyp7MeNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(33430700001)(7696005)(186003)(26005)(110136005)(478600001)(54906003)(53546011)(6506007)(86362001)(316002)(7416002)(71200400001)(8676002)(5660300002)(66946007)(66476007)(76116006)(33656002)(66446008)(64756008)(66556008)(83290400001)(83280400001)(83300400001)(52536014)(83320400001)(83310400001)(33440700001)(9686003)(2906002)(55016002)(4326008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5tzntwSms/lITLR8Cy77PJl1zxXnA8R+P6FboofUycrlsvGt8noaYN3Y+TwTItE8fy1bRr1aHB8J82wMv1sS0fH9YSeS5H00K2oTyd/pZ0YptGriLnxo6rbiDFrtptiDtGNQjohflt5fG6QCXzN1Bd3fFzYVTeKwXGLY49XiDDm/0wFcCTysv6NNohXj8GYoXjw0zngPQHzTHUTv7oINCY01pisYzd386NVXYdvaZuk18FzcctLOX6c+zijNKsKTH1kWBq+Z8D+4xBHZt0ycQ4l0/RJFEfo+bj3dMpBCu6DuPPDkBta0GWybxIvfiwddWSUG8LtTyTZnwJ1gP8ntAZT2nKPEd7Ov//aqRRn7RmvUxMIdfgQKVpyPi22UoNvOWVQ53hllGBnZ98lNxi5ihwF6g7MSaH6EI/RsipaP4FI5RaXZB4F+LtVJezRcuz98jttZv8plg6amdKCRgMDhY95Jz4M52A1umztP88xNho1UlA2RKRbK4RHy+LY4RNa/ml7HTw88VqmDuk0ED0yb5Lpg4ybZ4xeV/4Az1zqUru7/UuOrcvTkfLZ54iIGNYejJNmfgifGKGsY8LJx0OTsuVvBfVqjgG4/8q/aKi99pcIcST2fPMl64owdXAOoFOoTGZ1f4doSOEKYw89FVb1jNqjzown0uX01eZtjqS7KmEHceuhFqMVXn0em6HJZeny691l/QQ/10ImRYO+T3u0Fs2t6slSm4b6EdipswljpMQI/b0N0GQzueJjnqSjlfhPMgR9tXSfl2u9Wz1ID6X08hRRDPLKypH/1W2eSzFSzZ70=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408e9864-d3a3-422d-9fce-08d7f27908b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 11:23:14.6103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OgkMwUG5JtAilMyQXJL/rcCmjhIZZr+WixrM0w32OqE3MgsKP7XrdQD/cIfIul+6//a4u1QEL8+1P1zNkDB5rACkTf3wQbIdhnYCwNxh07o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6521
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCg0KPiBIaSBWbGFkaW1pciwNCj4gDQo+IE9uIDA2LjA1LjIwMjAgMTM6NTMs
IFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCltzbmlwXQ0KPiA+QXQgdGhlIG1vbWVudCwgdGhlIGRy
aXZlciBkb2VzIG5vdCBzdXBwb3J0IG1vcmUgdGhhbiAxIGFjdGlvbi4gV2UgbWlnaHQgDQo+ID5u
ZWVkIHRvIGNoYW5nZSB0aGF0LCBidXQgd2UgY2FuIHN0aWxsIGluc3RhbGwgbW9yZSBmaWx0ZXJz
IHdpdGggdGhlIA0KPiA+c2FtZSBrZXkgYW5kIHN0aWxsIGJlIGZpbmUgKHNlZSBtb3JlIGJlbG93
KS4gV2hlbiB0aGVyZSBpcyBtb3JlIHRoYW4gMSANCj4gPmFjdGlvbiwgdGhlIElTMSBzdHVmZiB3
aWxsIGJlIGNvbWJpbmVkIGludG8gYSBzaW5nbGUgcnVsZSBwcm9ncmFtbWVkIA0KPiA+aW50byBJ
UzEsIGFuZCB0aGUgSVMyIHN0dWZmIHdpbGwgYmUgY29tYmluZWQgaW50byBhIHNpbmdsZSBuZXcg
cnVsZSANCj4gPndpdGggdGhlIHNhbWUga2V5cyBpbnN0YWxsZWQgaW50byBWQ0FQIElTMi4gV291
bGQgdGhhdCBub3Qgd29yaz8NCj4gPg0KPiA+PiBUaGUgU1cgbW9kZWwgaGF2ZSB0aGVzZSB0d28g
cnVsZXMgaW4gdGhlIHNhbWUgdGFibGUsIGFuZCBjYW4gc3RvcCANCj4gPj4gcHJvY2VzcyBhdCB0
aGUgZmlyc3QgbWF0Y2guIFNXIHdpbGwgZG8gdGhlIGFjdGlvbiBvZiB0aGUgZmlyc3QgZnJhbWUg
DQo+ID4+IG1hdGNoaW5nLg0KPiA+Pg0KPiA+DQo+ID5BY3R1YWxseSBJIHRoaW5rIHRoaXMgaXMg
YW4gaW5jb3JyZWN0IGFzc3VtcHRpb24gLSBzb2Z0d2FyZSBzdG9wcyBhdCANCj4gPnRoZSBmaXJz
dCBhY3Rpb24gb25seSBpZiB0b2xkIHRvIGRvIHNvLiBMZXQgbWUgY29weS1wYXN0ZSBhIHRleHQg
ZnJvbSBhIA0KPiA+ZGlmZmVyZW50IGVtYWlsIHRocmVhZC4NCj4gDQo+IEknbSBzdGlsbCBub3Qg
YWJsZSB0byBzZWUgaG93IHRoaXMgcHJvcG9zYWwgd2lsbCBnaXZlIHVzIHRoZSBzYW1lIGJlaGF2
aW9yYWwgaW4gU1cgYW5kIGluIEhXLg0KPiANCj4gQSBzaW1wbGUgZXhhbXBsZToNCj4gDQo+IHRj
IHFkaXNjIGFkZCBkZXYgZW5wMHMzIGluZ3Jlc3MNCj4gdGMgZmlsdGVyIGFkZCBkZXYgZW5wMHMz
IHByb3RvY29sIDgwMi4xUSBwYXJlbnQgZmZmZjogXA0KPiAgICAgIHByaW8gMTAgZmxvd2VyIHZs
YW5faWQgNSBhY3Rpb24gdmxhbiBtb2RpZnkgaWQgMTAgdGMgZmlsdGVyIGFkZCBkZXYgZW5wMHMz
IHByb3RvY29sIDgwMi4xUSBwYXJlbnQgZmZmZjogXA0KPiAgICAgIHByaW8gMjAgZmxvd2VyIHNy
Y19tYWMgMDA6MDA6MDA6MDA6MDA6MDggYWN0aW9uIGRyb3ANCj4gDQo+IFdlIGNhbiB0aGVuIGlu
amVjdCBhIGZyYW1lIHdpdGggVklEIDUgYW5kIHNtYWMgOjowODoNCj4gJCBlZiB0eCB0YXAwIGV0
aCBzbWFjIDAwOjAwOjAwOjAwOjAwOjA4IGN0YWcgdmlkIDUNCj4gDQo+IFdlIGNhbiB0aGVuIGNo
ZWNrIHRoZSBmaWx0ZXIgYW5kIHNlZSB0aGF0IGl0IG9ubHkgaGl0IHRoZSBmaXJzdCBydWxlOg0K
PiANCj4gJCB0YyAtcyBmaWx0ZXIgc2hvdyBkZXYgZW5wMHMzIGluZ3Jlc3MNCj4gZmlsdGVyIHBy
b3RvY29sIDgwMi4xUSBwcmVmIDEwIGZsb3dlciBjaGFpbiAwIGZpbHRlciBwcm90b2NvbCA4MDIu
MVEgcHJlZiAxMCBmbG93ZXIgY2hhaW4gMCBoYW5kbGUgMHgxDQo+ICAgIHZsYW5faWQgNQ0KPiAg
ICBub3RfaW5faHcNCj4gICAgICAgICAgYWN0aW9uIG9yZGVyIDE6IHZsYW4gIG1vZGlmeSBpZCAx
MCBwcm90b2NvbCA4MDIuMVEgcHJpb3JpdHkgMCBwaXBlDQo+ICAgICAgICAgICBpbmRleCAxIHJl
ZiAxIGJpbmQgMSBpbnN0YWxsZWQgMTkgc2VjIHVzZWQgNiBzZWMNCj4gICAgICAgICAgQWN0aW9u
IHN0YXRpc3RpY3M6DQo+ICAgICAgICAgIFNlbnQgNDIgYnl0ZXMgMSBwa3QgKGRyb3BwZWQgMCwg
b3ZlcmxpbWl0cyAwIHJlcXVldWVzIDApDQo+ICAgICAgICAgIGJhY2tsb2cgMGIgMHAgcmVxdWV1
ZXMgMA0KPg0KPiBmaWx0ZXIgcHJvdG9jb2wgODAyLjFRIHByZWYgMjAgZmxvd2VyIGNoYWluIDAg
ZmlsdGVyIHByb3RvY29sIDgwMi4xUSBwcmVmIDIwIGZsb3dlciBjaGFpbiAwIGhhbmRsZSAweDEN
Cj4gICBzcmNfbWFjIDAwOjAwOjAwOjAwOjAwOjA4DQo+ICAgbm90X2luX2h3DQo+ICAgICAgICAg
YWN0aW9uIG9yZGVyIDE6IGdhY3QgYWN0aW9uIGRyb3ANCj4gICAgICAgICAgcmFuZG9tIHR5cGUg
bm9uZSBwYXNzIHZhbCAwDQo+ICAgICAgICAgIGluZGV4IDEgcmVmIDEgYmluZCAxIGluc3RhbGxl
ZCAxMSBzZWMgdXNlZCAxMSBzZWMNCj4gICAgICAgICBBY3Rpb24gc3RhdGlzdGljczoNCj4gICAg
ICAgICBTZW50IDAgYnl0ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3ZlcmxpbWl0cyAwIHJlcXVldWVz
IDApDQo+ICAgICAgICAgYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQo+DQo+IElmIHRoaXMgd2Fz
IGRvbmUgd2l0aCB0aGUgcHJvcG9zZWQgSFcgb2ZmbG9hZCwgdGhlbiBib3RoIHJ1bGVzIHdvdWxk
IGhhdmUgYmVlbiBoaXQgYW5kIHdlIHdvdWxkIGhhdmUgYSBkaWZmZXJlbnQgYmVoYXZpb3JhbC4N
Cj4NCj4gVGhpcyBjYW4gYmUgZml4ZWQgYnkgYWRkaW5nIHRoZSAiY29udGludWUiIGFjdGlvbiB0
byB0aGUgZmlyc3QgcnVsZToNCg0KPiB0YyBmaWx0ZXIgYWRkIGRldiBlbnAwczMgcHJvdG9jb2wg
ODAyLjFRIHBhcmVudCBmZmZmOiBcDQo+ICAgICAgcHJpbyAxMCBmbG93ZXIgdmxhbl9pZCA1IGFj
dGlvbiB2bGFuIG1vZGlmeSBpZCAxMCBjb250aW51ZSB0YyBmaWx0ZXIgYWRkIGRldiBlbnAwczMg
cHJvdG9jb2wgODAyLjFRIHBhcmVudCBmZmZmOiBcDQo+ICAgICAgcHJpbyAyMCBmbG93ZXIgc3Jj
X21hYyAwMDowMDowMDowMDowMDowOCBhY3Rpb24gZHJvcA0KPg0KPiBCdXQgdGhhdCB3b3VsZCBh
Z2FpbiBicmVhayBpZiB3ZSBhZGQgMiBydWxlcyBtYW5pcHVsYXRpbmcgdGhlIFZMQU4gKGFzIHRo
ZSBIVyBkb2VzIG5vdCBjb250aW51ZSB3aXRoIGluIGEgc2luZ2xlIFRDQU0pLg0KPg0KPiBNeSBw
b2ludCBpczogSSBkbyBub3QgdGhpbmsgd2UgY2FuIGhpZGUgdGhlIGZhY3QgdGhhdCB0aGlzIGlz
IGRvbmUgaW4gaW5kZXBlbmRlbnQgVENBTXMgaW4gdGhlIHNpbGljb24uDQo+IA0KPiBJIHRoaW5r
IGl0IGlzIHBvc3NpYmxlIHRvIGRvIHRoaXMgd2l0aCB0aGUgY2hhaW4gZmVhdHVyZSAoZXZlbiB0
aG91Z2ggaXQgaXMgbm90IGEgcGVyZmVjdCBtYXRjaCksIGJ1dCBpdCB3b3VsZCByZXF1aXJlIG1v
cmUgYW5hbHlzaXMuDQo+IA0KPiAvQWxsYW4NCg0KRG8geW91IG1lYW4gaXQncyBiZXR0ZXIgdG8g
c2V0IHZsYW4gbW9kaWZ5IGZpbHRlcnMgaW4gYSBkaWZmZXJlbnQgY2hhaW4sIGFuZCB3cml0ZSB0
aGUgZmlsdGVyIGVudHJpZXMgd2l0aCBhIHNhbWUgY2hhaW4gaW4gdGhlIHNhbWUgVkNBUCBUQ0FN
Pw0KRm9yIGV4YW1wbGU6DQoJdGMgZmlsdGVyIGFkZCBkZXYgZW5wMHMzIHByb3RvY29sIDgwMi4x
USBjaGFpbiAxMSBwYXJlbnQgZmZmZjogcHJpbyAxMCBmbG93ZXIgc2tpcF9zdyB2bGFuX2lkIDUg
YWN0aW9uIHZsYW4gbW9kaWZ5IGlkIDEwDQoJdGMgZmlsdGVyIGFkZCBkZXYgZW5wMHMzIHByb3Rv
Y29sIDgwMi4xUSBjaGFpbiAyMiBwYXJlbnQgZmZmZjogcHJpbyAyMCBmbG93ZXIgc2tpcF9zdyBz
cmNfbWFjIDAwOjAwOjAwOjAwOjAwOjA4IGFjdGlvbiBkcm9wDQpmb3IgdGhpcyB1c2FnZSwgd2Ug
b25seSBuZWVkIHRvIGVuc3VyZSBhIGNoYWluIGNvcnJlc3BvbmRpbmcgdG8gYSBWQ0FQIGluIG9j
ZWxvdCBhY2UgZHJpdmVyLiBJJ20gbm90IHN1cmUgaXMgbXkgdW5kZXJzdGFuZGluZyByaWdodD8N
Cg0KcmVnYXJkcywNClhpYW9saWFuZw0K
