Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CBF2BA65E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgKTJjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:39:18 -0500
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:59458
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgKTJjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 04:39:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQeZXe9c+7WV82AkiSa66n9+0s2D6IxKzO7P1xe6w3Lbg3XbC3e60yirlsY5g63ubd1PqyCSqU1GyLVy9u7N0+Rlh3QRxb5c2LQbjUqu0IvQllP4xrngxZzujdZMYfLYZ9ZWQZYrkio+NvbVJyD2PwvuHlNVouy3Se6Qoj3sTTC985nZYy/7hug1rAEGi0G3PYhe3Y8D93qYiaAIR4GlY1IeKlT4FPnvxXCquXFBiSWNTpvJ4tsHlaT770DtALQOSftFx8uR+uBP5F7nY/opTdfZx9qaDrCOq6l3zZzU/BpgHO3MCs6JgrO7hz35N0OpNTpAyvBlngGujJym1+zGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWAFKucxS1Bs3iEA4wwTsEJF7Kca2NKdSNuheJus1nE=;
 b=hxDcYB3Ayv0CoY/CQ466zusR6ZLx4q+vIMjA90kO/F/IWvcxJWO+z2d4vuZMSXj012ypI2YgAaqpl4Rfz+3XA7lDBCHRbFjWcMLgXOq0Ci08PzOoeI6KZmr0i3Ovk5pdvR5LwkDeUkIcbGyR2iYuybwaLF4yox7hmlB6NhucEGXoDOw0WaCm1EvLB2AqELhYMbJtweZvLsO9tZXME7KdBWM2USYs9inLWgjlAxG6XeNihxpk47eovAoUZv6xroj7O47GBIawQWo2RnqOc/VVMODAuObeO65ORJGe5yv3UZZALIbrgqWWEBbYYfKfQZ6ZH47CLzvMzEJAQUUeTj5O8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWAFKucxS1Bs3iEA4wwTsEJF7Kca2NKdSNuheJus1nE=;
 b=UqwGIXmNxOVmo/FCK3MMxa2I08Y3MT9omTBPUvUB+q3yAeXF+IstlhXAI4A4dJNx4P6qBuQa1sePnpe24Z1ZNZ4c510sMa9gu1tGYqBuJV+abEuH+9R37/0Nb5IEtMocfytY685olJeKBgq+xWA2UQZVlbdJI8ZU8sWG6oPOcFw=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 09:39:12 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::d08e:4103:c893:5742]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::d08e:4103:c893:5742%5]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 09:39:12 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: RE: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Index: AQHWvKn0RlwN9xxeW0urW59aAoE16anMro+AgAQI9WA=
Date:   Fri, 20 Nov 2020 09:39:12 +0000
Message-ID: <DB8PR04MB5785D4586B8CB3651F427E69F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
 <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
In-Reply-To: <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7949a1d7-a915-409c-bafa-08d88d382354
x-ms-traffictypediagnostic: DBAPR04MB7480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB74805EDD048ED46FD7E9BE87F0FF0@DBAPR04MB7480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rzw54wcuDoAQhDXyMZeuTGBgMiRcyizEP8tyc8l61avZNUFs0XhGbGHcFSxXO26V90PDqaS3x2/MCcpSZSSkLTZmmOdBt/FVEoWWscrbL7pnXU/PGZAILW0LDj2pr0eERsyaPl0o1PamM52JH7SC/roP8+fWUpyDTC+8C3VgFOu00Z2gw9DTuqH0n7JxXTlXuy73+ijpfFivCaygMSJfazd5oNfFbQC/m+ydcWveUfPX/O1b8CExWCF9j0neZyNQFDftCXeVSTYYTZ3YD09Hix3DfVePbsC9jpn+SVydHqPJAtaZBPoU/DZXwuk0cSVT0r5eRpCL9PLGCm8rqVqHEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(52536014)(33656002)(54906003)(316002)(478600001)(4326008)(83380400001)(8936002)(7416002)(8676002)(4001150100001)(7696005)(6916009)(2906002)(53546011)(186003)(76116006)(55016002)(86362001)(6506007)(5660300002)(66446008)(66556008)(9686003)(66476007)(66946007)(64756008)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: w3VmGC1QgRKMkblp6bMC+R9buN4Dxo4GCNJ2us6wtFTSgFTNbB3KBjdtF2XIGpyntzjrGdkMXjLaJz1buiL1kMq6soxkaC2xdN3Uf7tccZivrYtGTwMg6Cw01c/oeyt8WdKrNUN8cMoyW25CjeR2R75Ic6JXbhyiRQ2mydQ44Oguj+L3qC2cQHeELV6sYX9K4uFqT90PqEa5b6/Gkf+o+OR7OP1mGreytrH/ggwcC4Vuk9+rS2X1mFq4At82sMWaL+FUnFzJPQ39MaLTNCT57BDdw3di/xnrOVpR1sOlFoUokp/jNPjU1yOVkWdx0Ykqy70Qc5W4oKBL+eT+Pqr94NXwR+OLGnrpAyHTKmCUX6rfTyUBfYQlYgOJkkgkvSgTUbO4e9CyrsqFHTjrX2t0XOJfjR9U/dXGHcMdp9fA/+dGkYYVSI4NNTZSguqhTrQ7cSLvfIzy7gKB2KFzAKPGyEWGiUVqJ6hVZwr99g3u8dn5fnBDgBPTPvpFDVmKr9FkfGCIVfUNa59lR1bUBoua4/RGTQfmtLXvyJQ0Nkdjspk+B9zdE+2QuqVkRbreZOiienkgGOgFMcbJu1KdruJh5sXsuPathsCFxALnMEEkuXwd9EtwlgZ9htdZKhw9tFE/CWweB1AMpjnGw5wU7GAWlg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7949a1d7-a915-409c-bafa-08d88d382354
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 09:39:12.1926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8Oubc4aUmlZVRnex6XeGzZUbPx7VtPYeyHuGy5Y7kIadOP1GXzlOtJZMjc9fi/rDCV/gtDZgh3hYYsN5zAwZATq2RZyz7AuflvqA+/OnHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMDIwLTExLTE4IDM6MDEgSm9lcmdlbiBBbmRyZWFzZW4gd3JvdGU6DQo+DQo+IEhpIFhp
YW9saWFuZywNCj4NCj4gSSBsaWtlIHlvdXIgaWRlYSBhYm91dCB1c2luZyBmaWx0ZXIgYWN0aW9u
cyBmb3IgRlJFUiBjb25maWd1cmF0aW9uLg0KPg0KPiBJIHRoaW5rIHRoaXMgaXMgYSBnb29kIHN0
YXJ0aW5nIHBvaW50IGJ1dCBJIHRoaW5rIHRoYXQgdGhpcyBhcHByb2FjaCB3aWxsIG9ubHkgYWxs
b3cgdXMgdG8gY29uZmlndXJlIGVuZCBzeXN0ZW1zIGFuZCBub3QgcmVsYXkgc3lzdGVtcyBpbiBi
cmlkZ2VzL3N3aXRjaGVzLg0KPg0KPiBJbiB0aGUgZm9sbG93aW5nIEkgcmVmZXIgdG8gc2VjdGlv
bnMgYW5kIGZpZ3VyZXMgaW4gODAyLjFDQi0yMDE3Lg0KPg0KPiBJIGFtIG1pc3NpbmcgdGhlIGZv
bGxvd2luZyBwb3NzaWJpbGl0aWVzOg0KPiBDb25maWd1cmUgc3BsaXQgd2l0aG91dCBhZGRpbmcg
YW4gci10YWcgKEZpZ3VyZSBDLTQgUmVsYXkgc3lzdGVtIEMpLg0KPiBDb25maWd1cmUgcmVjb3Zl
cnkgd2l0aG91dCBwb3BwaW5nIHRoZSByLXRhZyAoRmlndXJlIEM0IFJlbGF5IHN5c3RlbSBGKS4N
Cj4gRGlzYWJsZSBmbG9vZGluZyBhbmQgbGVhcm5pbmcgcGVyIFZMQU4gKFNlY3Rpb24gQy43KS4N
Cj4gU2VsZWN0IGJldHdlZW4gdmVjdG9yIGFuZCBtYXRjaCByZWNvdmVyeSBhbGdvcml0aG0gKFNl
Y3Rpb24gNy40LjMuNCBhbmQgNy40LjMuNSkuDQo+IENvbmZpZ3VyZSBoaXN0b3J5IGxlbmd0aCBp
ZiB2ZWN0b3IgYWxnb3JpdGhtIGlzIHVzZWQgKFNlY3Rpb24gMTAuNC4xLjYpLg0KPiBDb25maWd1
cmUgcmVzZXQgdGltZW91dCAoU2VjdGlvbiAxMC40LjEuNykuDQo+IEFkZGluZyBhbiBpbmRpdmlk
dWFsIHJlY292ZXJ5IGZ1bmN0aW9uIChTZWN0aW9uIDcuNSkuDQo+IENvdW50ZXJzIHRvIGJlIHVz
ZWQgZm9yIGxhdGVudCBlcnJvciBkZXRlY3Rpb24gKFNlY3Rpb24gNy40LjQpLg0KPg0KPiBJIHdv
dWxkIHByZWZlciB0byB1c2UgdGhlIHRlcm0gJ2ZyZXInIGluc3RlYWQgb2YgJ3JlZCcgb3IgJ3Jl
ZHVuZGFuY3knDQo+IGluIGFsbCBkZWZpbml0aW9ucyBhbmQgZnVuY3Rpb25zIGV4Y2VwdCBmb3Ig
J3JlZHVuZGFuY3ktdGFnJy4NCg0KVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24sIGl0J3MgdmVy
eSB1c2VmdWwgdG8gbWUuIEkgaWdub3JlZCBmcmVyIG9uIHJlbGF5IHN5c3RlbS4gSSB3aWxsIHN0
dWR5IHNlY3Rpb25zIGFuZCBmZWF0dXJlcyB5b3UgbWVudGlvbmVkIG9uIFNwZWMuIElmIHVzaW5n
IGEgbmV3IHRjLWZyZXIgYWN0aW9uIGlzIG9rLCBJIHdpbGwgcGVyZmVjdCBhbmQgdXBkYXRlIGl0
Lg0KDQpSZWdhcmRzLA0KWGlhb2xpYW5nIA0K
