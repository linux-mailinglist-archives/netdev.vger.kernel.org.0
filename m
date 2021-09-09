Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA2404DE7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbhIIMHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:07:18 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:54880
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345234AbhIIMCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMW4Xaw618acVL837lL+9tmZP1MBJzB/et/mqm7u3ryfCO8GGTCI/E6L8Iz6NJFBnvxe1oJNrEQXofpzfRD8OyymSGXNd8ip7bpTcklrfVf8qkSm9eGhnt9OHrKYAvciiO4MIvo1z8i5OwaQE6QXEd1C/zF95gnn31uZ1Q5KtbElKexORWzR6xV3sMebXPaXUS/5Q8CVHmTHjILHzRJEnm53xeTtrOazL2KBzsCwZJaWs5V8a0ta3pUS7HSVPYUk+PK3hB7p9qyrVdg+SVm6bXR1kO0H/NBuWiVTvr/6BKPh1xe2K13ML9UC6vcNvbC9tz8gtY0ojcTnejaxpdub7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ivqQiqd0EP9ZJ4HsQgWlTfSR9rvdw+5g4nJRfyZWK1k=;
 b=MziZX8sxvcA6P1W3Hx/xPhh91IrgcweVpwuRopbMwhCA9UdKSKSRDHkO88tHc2xU7MSHuGto8ExX/SITh7gHAqnA2SG7hQf3Dvrgrl2SiGkr9hcLIYFUbYwL2FNq3bAT0DEsTc3apf+SsN8dE7Q5cy8VK1z3Huqoria6vhYhI+cWgrOs7jPW1bmfMRKfph1LwH1WdBCncLHa92DeEK/xOdJ0LMpWFW2wqJPI/KIxsBFuDR8uxVPgAfoTSMSXzu/UjXAdJxB5gdlPCzJOmS2lXTUnpeL3VyFpruTdOQz9H1obZ+OMixIvPDFjXGVnKdJAmDZwhISlnHMJ8c1ICOCqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivqQiqd0EP9ZJ4HsQgWlTfSR9rvdw+5g4nJRfyZWK1k=;
 b=JoGpPI0rZlJYBgGEWJrWgsvEvWKX5K8W63cJ3UjBcOEsmTqVMstX5tlC2RV3H1NtbTT+Td1mXZ5EK82SKT5Eh2C+EqDTXttq1fiCxFAP7Igz0x57vTKAwBAzvl5sfchZVQ0WwrhqKW2onWhhCZagWldA1XyPxi/AMxMz21MtVms=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5344.eurprd04.prod.outlook.com (2603:10a6:803:4b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 9 Sep
 2021 12:01:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4478.026; Thu, 9 Sep 2021
 12:01:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAIAAA9qAgAACOACAAALRgIAAC4OAgAAN+4CADjF7gIAAB6cA
Date:   Thu, 9 Sep 2021 12:01:21 +0000
Message-ID: <20210909120120.zrizaaheaanyl7dq@skbuf>
References: <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
 <20210831091759.dacg377d7jsiuylp@skbuf>
 <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831104913.g3n6dov6gwflc3pm@skbuf>
 <9619848400baaa0d0d12cc6a2d799934323e2657.camel@microchip.com>
In-Reply-To: <9619848400baaa0d0d12cc6a2d799934323e2657.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1decb378-0315-43d8-d340-08d973898a2f
x-ms-traffictypediagnostic: VI1PR04MB5344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB53449E42B417AEEC23CA04A0E0D59@VI1PR04MB5344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NGPZ5D++Qo9UExXwk1u3Qa5arN7qTs2xaXAo9PFBritKR5Gho5w66+7c5va/KYsLfknvXwotujLxcXQsiIF7rMuYMLFTrbBRGGOVpxPCvf09EFRgwFzcj2p0pLJaL7xoqAqV/87/cqUSHLxdOU3z+vXtykA9JNBdW9bXy0A2i+UShYzYetYcnWTf/nw7RvHqd9Gdm7nbnTRQQXdByrI+Llq47VsmGgMwCIz+LNDpBz2zjGcR1hdcWNEgYZ/1lAMcdLhp0NkiQn5xYF3pU7lBBk0LR8NeX0uAmIX/whCes8rPbx8nRAN36JTTxPiC+seVzPt3STCkQ21uf86doGd+bUO6Uh9a+iqCMNV94nayZ9gfoDIwkx5rDYcLE7ShVPX7afdTd1rCHxEJLh6VARCo7IIx+yaruRI6gGLzW1hiqsUVmQAya9UDXvygoPHHIx8L6NiODL6keELPItlxiBQt1ozaL5UcvmHXejXZ3blok4bIfZbU86qMFDAL2s8oIpfmpCoaDeKS5ADuInTbiNoKyrQQAgrghprXzqe38wqiJt5ySqipbnXkfbOXhll51N1HlsgXYtYJSGUgtiMegja52XWBg22r60TTpMYZj7O7gLBykCT9aTmBIpz8tB0tD38TOQmbG1wiZFR7JnXUHB1kHZojJ5V1bWU0ba1VW2wFg0IOv/Va2J9WxydsRqnzObftYa8uP+eZbsazlTtQOw/7P0QgA3jj4GwpZ73qvUYWfCCkrFr/L3FfIWph4T4APkC2ZmwjYqeSih7qjh4V4U/Oy60zg7rw1OzEqLQbcWrNESU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(376002)(346002)(366004)(136003)(39860400002)(186003)(6916009)(38070700005)(1076003)(71200400001)(2906002)(4326008)(33716001)(478600001)(83380400001)(8936002)(86362001)(6486002)(44832011)(122000001)(5660300002)(8676002)(7416002)(38100700002)(54906003)(9686003)(64756008)(66446008)(26005)(76116006)(316002)(66946007)(6506007)(966005)(6512007)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVVvU3AwYlY5OWtZa2pSM0ZzMzlkTnFXVnREelRnbHNYMHFSYVVlS2E0Q0dZ?=
 =?utf-8?B?M2NraERkYmJIUlRyRnhacy9qNW9ObVRmTmdzZ2VEbzlJaXNrdENJSTdQV0h2?=
 =?utf-8?B?Q1FwTTRZMzlrUDVtMHFud2Z4d3dMR3dwMWJ5Q1NRYXhubVA1bUM2Sk1Ha3FF?=
 =?utf-8?B?R01FSkorZkYvS0NMZkI5blhoNW9OcnpLaFZyM0prMGdFekVja1U2NWJkaDN3?=
 =?utf-8?B?QWRQbnpZdWVNSjR0b0x3TjV2aHFLVHRDUWpVdDJWdkZDSVVUZC9YVTZtUFp0?=
 =?utf-8?B?ZnBxRnhuWDMwTXZxOGJRbk1waTlvSSsvdDE5NllUM0JlcWt0cEhJNk02U0k2?=
 =?utf-8?B?SzBUblpqdGMwOUtZbStOazR0ZjhqTGhPVzdmOERHYmtvcnR3RjR6d0NDbTBx?=
 =?utf-8?B?Nk53NlVJNk5RMms4WW1OZk9tWm9MeHVUTUFhOEZQTmJ2c2o5amhWM0JsMnZi?=
 =?utf-8?B?Q25ubG95NkNMS1lKbUs5RWJLQ0Ztb3d1dm9sbmUrRjFrcUwzS1NsZ2xSM0xG?=
 =?utf-8?B?cG5hNFFpdjRtMjRmdzdwS2lBV3B5VHdoZ2hPbWNwNGRtUW55UkZuS0tLc2t1?=
 =?utf-8?B?Z1Fnb1FvSHhCcmIxMmlQUzVHaHdmai9CZ2FsanRNQ0s1V1hOMlRWb2llMGdi?=
 =?utf-8?B?WnVXdy9Jck5KVE4yOXAzV0R3cWlpRnRNV2pnTlAvWk1VV2p5dGk5NFVrVkh3?=
 =?utf-8?B?N2JLS1o0bU5Yb2ZMMG5lRTZvNUI2QlY1alZYTlk4Rk5lQ2hEZVRiU3FmTklF?=
 =?utf-8?B?K0RZUjJRK1ZLUnpiTTRlVlE4U01DZEMrMlRGb1l2UXdrOTF1MlNOanRVK1NE?=
 =?utf-8?B?WEk4Z28vOUFmL1RvckM3ZncrRXhiVUxpWmJkbml4NDdFZVNQZUlOREpzNlhD?=
 =?utf-8?B?dm9ibi9vNG5JL0hOTytDcUxHb3ZBN3JCd0V0UkJ5bXZWbW94QnUxZ1doK0ZZ?=
 =?utf-8?B?L0wxOWNiTVk4eDA2K2V0VGJUMVpMWWo0eXVPYXFFaEJUMGxPZFAyZGF4akR6?=
 =?utf-8?B?dWR3UFNrUWFxd2JZeS9qMDd6OCtobFhlWmZsTk5tNlhjRisvY0ZLSkwvc2Y5?=
 =?utf-8?B?Q2xPWllySStZWFlTU2lUWGVubEFDdjMxVmZjbk85VThPSXIwaDQ4UUs3SDZI?=
 =?utf-8?B?SktpMFo1eUJrbFIxcHVMZS9kcng4NHhwb3dlUk1Sd0s3aDVkWTJLRW1UcitY?=
 =?utf-8?B?eFVEbjdKTnNlUDJqR3BJbmJFL0F6MHZzVGxJYkNPb1Q2M1gzOVI1SE5sQ3J3?=
 =?utf-8?B?N3crMm1Zc3Q1dVNnQUxQZ1NwMjgwRWR4WGwvVGtzbS9lQ0lWTzB6Mk9JaDlN?=
 =?utf-8?B?ZmpnMUFBdkVIWEEvbWJsby9JaVFTMjhQQUFQbUFWYUw5V1VrTE1xT29qQjNx?=
 =?utf-8?B?TXdFQmR0M2JDQlJMWWZyazREL2tCT0xrT0hvUnlQRHEzWUM2c2F5SDAra0Fk?=
 =?utf-8?B?RWdLRmlrOEFMbE1uRm5sOUxXeEtkNXNjL0RTREVZVWdLZW1HdE9oWnp2R2J4?=
 =?utf-8?B?SGcrekNZRkpDNXhLVnRjcmpOMjd0RVV4Mnp1MFl1d0RzbEd4dWxJaFJLcEdv?=
 =?utf-8?B?V3FIV2lPcGEvK3RTWTZUTVZVRE42TDYvQk1JNEY2U1dtV0pvdjhpVStrN1hn?=
 =?utf-8?B?OVFROFF6Rmx0NlNyRGM0YmZEZlJ0WUxhSE14QWt5cnJaK29KbFJrWnhRM1Va?=
 =?utf-8?B?YkRFRkd2S0Jmb2JyaEtia1JMKzZTL2VrdzBuNlZpQkt4UjZYWU9qTHF1S0RD?=
 =?utf-8?Q?ewIGdLZcec4mglONwa73H9LViE1RDrTP8d114X0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <786C2A05A3837D47ABF3F91FB952E27C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1decb378-0315-43d8-d340-08d973898a2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 12:01:21.3481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PYWuu3h3S/77KOeg6/2iTtnyR95kLfx6SGEL67EImxpat/A3UmiOl+qM3ZmIgTK90S7tN8hBoex+1lNQiOzo5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMDksIDIwMjEgYXQgMDE6MzM6NTdQTSArMDIwMCwgSm9lcmdlbiBBbmRyZWFz
ZW4gd3JvdGU6DQo+ID4gPiBZZXMsIFVzaW5nIHJlZGlyZWN0IGFjdGlvbiBjYW4gZ2l2ZSBQU0ZQ
IGZpbHRlciBhIGZvcndhcmQgcG9ydCB0bw0KPiA+ID4gYWRkDQo+ID4gPiBNQUMgdGFibGUgZW50
cnkuIEJ1dCBpdCBhbHNvIGhhcyB0aGUgaXNzdWUgdGhhdCB3aGVuIHVzaW5nICJicmlkZ2UNCj4g
PiA+IGZkYg0KPiA+ID4gZGVsIiB0byBkZWxldGUgdGhlIE1BQyBlbnRyeSB3aWxsIGNhdXNlIHRo
ZSB0Yy1maWx0ZXIgcnVsZSBub3QNCj4gPiA+IHdvcmtpbmcuDQo+ID4NCj4gPiBXZSBuZWVkIHRv
IGRlZmluZSB0aGUgZXhwZWN0ZWQgYmVoYXZpb3IuDQo+ID4NCj4gPiBBcyBmYXIgYXMgdGhlIDgw
Mi4xUS0yMDE4IHNwZWMgaXMgY29uY2VybmVkLCB0aGVyZSBpcyBubyBsb2dpY2FsDQo+ID4gZGVw
ZW5kZW5jeSBiZXR3ZWVuIHRoZSBGREIgbG9va3VwIGFuZCB0aGUgUFNGUCBzdHJlYW1zLiBCdXQg
dGhlcmUNCj4gPiBzZWVtcw0KPiA+IHRvIGJlIG5vIGV4cGxpY2l0IHRleHQgdGhhdCBmb3JiaWRz
IGl0IGVpdGhlciwgdGhvdWdoLg0KPiA+DQo+ID4gSWYgeW91IGluc3RhbGwgYSB0Yy1yZWRpcmVj
dCBydWxlIGFuZCBvZmZsb2FkIGl0IGFzIGEgYnJpZGdlIEZEQg0KPiA+IGVudHJ5LA0KPiA+IGl0
IG5lZWRzIHRvIGJlaGF2ZSBsaWtlIGEgdGMtcmVkaXJlY3QgcnVsZSBhbmQgbm90IGEgYnJpZGdl
IEZEQg0KPiA+IGVudHJ5Lg0KPiA+IFNvIGl0IG9ubHkgbmVlZHMgdG8gbWF0Y2ggb24gdGhlIGlu
dGVuZGVkIHNvdXJjZSBwb3J0LiBJIGRvbid0DQo+ID4gYmVsaWV2ZQ0KPiA+IHRoYXQgaXMgcG9z
c2libGUuIElmIGl0IGlzLCBsZXQncyBkbyB0aGF0Lg0KPiA+DQo+ID4gVG8gbWUsIHB1dHRpbmcg
UFNGUCBpbnNpZGUgdGhlIGJyaWRnZSBkcml2ZXIgaXMgY29tcGxldGVseSBvdXRzaWRlIG9mDQo+
ID4gdGhlIHF1ZXN0aW9uLiBUaGVyZSBpcyBubyBldmlkZW5jZSB0aGF0IGl0IGJlbG9uZ3MgdGhl
cmUsIGFuZCB0aGVyZQ0KPiA+IGFyZQ0KPiA+IHN3aXRjaCBpbXBsZW1lbnRhdGlvbnMgZnJvbSBv
dGhlciB2ZW5kb3JzIHdoZXJlIHRoZSBGREIgbG9va3VwDQo+ID4gcHJvY2Vzcw0KPiA+IGlzIGNv
bXBsZXRlbHkgaW5kZXBlbmRlbnQgZnJvbSB0aGUgUWNpIHN0cmVhbSBpZGVudGlmaWNhdGlvbiBw
cm9jZXNzLg0KPiA+IEFueXdheSwgdGhpcyBzdHJhdGVneSBvZiBjb21iaW5pbmcgdGhlIHR3byBj
b3VsZCBvbmx5IHdvcmsgZm9yIHRoZQ0KPiA+IE5VTEwNCj4gPiBzdHJlYW0gaWRlbnRpZmllcnMg
aW4gdGhlIGZpcnN0IHBsYWNlIChNQUMgREEgKyBWTEFOIElEKSwgbm90IGZvciB0aGUNCj4gPiBv
dGhlcnMgKElQIFN0cmVhbSBpZGVudGlmaWNhdGlvbiBldGMgZXRjKS4NCj4gPg0KPiA+IFNvIHdo
YXQgcmVtYWlucywgaWYgbm90aGluZyBlbHNlIGlzIHBvc3NpYmxlLCBpcyB0byByZXF1aXJlIHRo
ZSB1c2VyDQo+ID4gdG8NCj4gPiBtYW5hZ2UgdGhlIGJyaWRnZSBGREIgZW50cmllcywgYW5kIG1h
a2Ugc3VyZSB0aGF0IHRoZSBrZXJuZWwgc2lkZSBpcw0KPiA+IHNhbmUsIGFuZCBkb2VzIG5vdCBy
ZW1haW4gd2l0aCBicm9rZW4gZGF0YSBzdHJ1Y3R1cmVzLiBUaGF0IGlzIGdvaW5nDQo+ID4gdG8N
Cj4gPiBiZSBhIFBJVEEgYm90aCBmb3IgdGhlIHVzZXIgYW5kIGZvciB0aGUga2VybmVsIHNpZGUs
IGJlY2F1c2Ugd2UgYXJlDQo+ID4gZ29pbmcgdG8gbWFrZSB0aGUgdGMtZmxvd2VyIGZpbHRlcnMg
ZWZmZWN0aXZlbHkgZGVwZW5kIHVwb24gdGhlDQo+ID4gYnJpZGdlDQo+ID4gc3RhdGUuDQo+ID4N
Cj4gPiBMZXQncyB3YWl0IGZvciBzb21lIGZlZWRiYWNrIGZyb20gTWljcm9jaGlwIGVuZ2luZWVy
cywgaG93IHRoZXkNCj4gPiBlbnZpc2lvbmVkIHRoaXMgdG8gYmUgaW50ZWdyYXRlZCB3aXRoIG9w
ZXJhdGluZyBzeXN0ZW1zLg0KPg0KPiBXZSBhdCBNaWNyb2NoaXAgYWdyZWVzIHRoYXQgaXQgaXMg
YSBkaWZmaWN1bHQgdGFzayB0byBtYXAgdGhlIFBTRlANCj4gaW1wbGVtZW50YXRpb24gaW4gRmVs
aXggdG8gdGhlIOKAnHRjIGZsb3dlcuKAnSBmaWx0ZXIgY29tbWFuZCwgYnV0IHBsZWFzZQ0KPiBy
ZW1lbWJlciB0aGF0IE9jZWxvdCBhbmQgaXRzIGRlcml2YXRpdmVzIHdlcmUgZGVzaWduZWQgbG9u
ZyBiZWZvcmUNCj4gdGhlIDgwMi4xUWNpIHN0YW5kYXJkIHdhcyByYXRpZmllZCBhbmQgYWxzbyBi
ZWZvcmUgYW55b25lIGhhcw0KPiBjb25zaWRlcmVkIGhvdyB0byBjb250cm9sIGl0IGluIExpbnV4
Lg0KPg0KPiBXZSB0aGluayB0aGF0IHRoZSBiZXN0IGFwcHJvYWNoIGlzIHRvIHJlcXVpcmUgdGhl
IHVzZXIgdG8gbWFuYWdlDQo+IGJyaWRnZSBGREIgZW50cmllcyBtYW51YWxseSBhcyBzdWdnZXN0
ZWQgYnkgWGlhb2xpYW5nLg0KPg0KPiBPdXIgbmV3ZXIgUFNGUCBkZXNpZ25zIHVzZXMgdGhlIFRD
QU0gaW5zdGVhZCBvZiB0aGUgTUFDIHRhYmxlDQo+IHdoaWNoIG1hcHMgYSBsb3QgYmV0dGVyIHRv
IHRoZSDigJx0YyBmbG93ZXLigJ0gZmlsdGVyIGNvbW1hbmQuDQoNCldlbGwsIHRoYXQncyBldmVu
IG1vcmUgdW5mb3J0dW5hdGUsIGJlY2F1c2UgYXMgZXhwbGFpbmVkIGJ5IElkbyBoZXJlOg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L1lTSHpMS3BpeGhDcnJnSjBAc2hyZWRkZXIvDQoN
CnRoZSByZXR1cm4gY29kZSBmcm9tIFNXSVRDSERFVl9GREJfe0FERCxERUx9X1RPX0RFVklDRSBl
dmVudCBoYW5kbGVycyBpcw0Kbm90IHByb3BhZ2F0ZWQgdG8gYnJfc3dpdGNoZGV2X2ZkYl9ub3Rp
ZnkuIFNvIGluIGVmZmVjdCwgdGhlIGRldmljZSBkcml2ZXINCmNhbm5vdCBzdG9wIHRoZSBicmlk
Z2UgZnJvbSByZW1vdmluZyBhbiBGREIgZW50cnkgd2hpY2ggd291bGQgbGVhZCBpdCB0bw0KaGF2
aW5nIGEgYnJva2VuIHRjIGZpbHRlci4NCg0KTm93LCB0aGUgb2NlbG90IHN3aXRjaGRldiBkcml2
ZXIgdXNlcyB0aGUgYnJpZGdlIGJ5cGFzcyAubmRvX2ZkYl9hZGQgYW5kDQoubmRvX2ZkYl9kZWws
IHdoaWxlIERTQSBhY3R1YWxseSBsaXN0ZW5zIGZvciBzd2l0Y2hkZXYgZXZlbnRzIG9uIHRoZQ0K
YXRvbWljIGNhbGwgY2hhaW4uIFNvIGFueSBzb2x1dGlvbiBuZWVkcyB0byB3b3JrIHdpdGggc3dp
dGNoZGV2LCBub3QNCmp1c3Qgd2l0aCB0aGUgYnJpZGdlIGJ5cGFzcyBvcHMu
