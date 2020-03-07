Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBDE17CC60
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgCGGFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:05:36 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:63566
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgCGGFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Mar 2020 01:05:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkS6FxtMZHOswM7UP5bvsfsqC6RiIWQI9PR5pFGIlHldV1hzsWpETCbAcY4UmV/gCleFNFQsFm3hs72hmN8nOooDrsygOWUxu1Sm47zS5gN48++kqX9BCID54dH2G2YGK8c2TtEoSuLNlyESWrQlQLO1Cpa7EBHj2ACpLf5zQl4rhYp7BvchZH6MrjBm8UCMQIICz9VSWT5UVYd/TrKqtuYNjf3i+4u+JG3MgPR7nfJzkAy7g/3j4sGKPfFCRSN43nTOHFUfGgGnJkKvX8Kjt6m32D9TDhRRPCa5IVhUmz/uK4oztA3OobLDNptL4IMGgF8ZrF9ObjMscDmtV0/wJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqLfubg8g1+1Xvz4NmGWjwvRV0hWUeps/SdZy7V9qg0=;
 b=LzGDlk2OT7S/AiO8ok1tsZ4Bjz3dbweXyQeq0WBIeoOaaAL5wUOGyZAxlGlq+jlTRmz8I32E8huPqp9s4kyGcSjXXBezEXNuJQZf1Rx76PRP/xgdnUQsYZpYumK97hyKTnEqnJYfvjgtgtTrtdXr1fx/aomZLLLR0dqn8IB5u6NKrUawaYuvQwKyl7eo2jRkYFwfFes2BIUc85QTJGJR2P16tUloRojQbUHok31nNTpZsw50dhoBDSQBIVDoCMLjZglxy5VXykAsr6TyMMHSSHzY7AhLTHFpzsMY1qVxqs4mQQDTNztO4wY8BirndrOmVWQ1RiOs2JC/6JQ1UXu7Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqLfubg8g1+1Xvz4NmGWjwvRV0hWUeps/SdZy7V9qg0=;
 b=dNOCenXhwAezrIDL9FK/Dfcy705zOWS74rNuxMw9oqrWoR3f3hRiJyYiVD8/HJpEKWjlkLGuzOxqkDftwWlm8dti2sl/+598Q+54na6x8sCmB0fVPhY550U7d8y34jttj0cA3sjWhcp0sH5RPj2GOvDTl/6fw2ma6XJhscUeOj0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6558.eurprd04.prod.outlook.com (20.179.232.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Sat, 7 Mar 2020 06:05:28 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Sat, 7 Mar 2020
 06:05:28 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pieter.jansenvanvuuren@netronome.com" 
        <pieter.jansenvanvuuren@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: RE: [EXT] Re: [RFC,net-next  2/9] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [RFC,net-next  2/9] net: qos: introduce a gate control
 flow action
Thread-Index: AQHV87k3gR0PIY1RlEuDZub3eMl0sKg77oYAgAC1s9A=
Date:   Sat, 7 Mar 2020 06:05:28 +0000
Message-ID: <VE1PR04MB64968E356A5125BD2D899AE992E00@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
        <20200306125608.11717-3-Po.Liu@nxp.com>
 <20200306111106.09416f43@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306111106.09416f43@kicinski-fedora-PC1C0HJN>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25b095e8-c0e4-43fa-be08-08d7c25d88f3
x-ms-traffictypediagnostic: VE1PR04MB6558:|VE1PR04MB6558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6558D179FE999982B2A5034892E00@VE1PR04MB6558.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(199004)(189003)(53546011)(6506007)(8676002)(81166006)(81156014)(7416002)(8936002)(71200400001)(44832011)(316002)(33656002)(54906003)(55016002)(7696005)(9686003)(4326008)(5660300002)(2906002)(64756008)(66446008)(66556008)(76116006)(478600001)(66946007)(186003)(66476007)(52536014)(6916009)(26005)(86362001)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6558;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0AiuBhATZr4F9TpRUarZ1swVYM899VA6NmUsNVz7xl8p/VdcM0gcrTzTl3rOGd4xaFL2p2aTC4t9boq+yxM11LwNv2gqjQMcAEMlS2FdszrxJb9sIKxSuinEn+2o6SOoTNkDUnz6qWmWsYhtnRUi25lMnlduwnesomVWjzdP0lPxvF7H9dq9ETUnXGsAglieS92udj3m7LuuGJDmBjzh7kWcgoNSUcSd2NNDiC79i2f8s0XhG2sr42NmI7kmR2TWulgFLbOu+MCOxvqwg/iype3SR+K8KxalExXzhX6HAiYbHzteTu97O9ASlnDVWg/n/vg1qrWj32p8pLfWRWy4QXGCxW1kLdFu6F55o0/HfTf5EK3i48dULHuImok1oGHvgxgi6nDXJYXja/0INjX0I+FPJzieylWRqcB95RBRILR4Nqgz3zg6jj01IhdUJPgMs1rtEB0sBnvGsaG/zvjJvoo2L6nDU8Slb9ailUEUSpMT5xLIDCEY4LqhtBG7Ml9J
x-ms-exchange-antispam-messagedata: UpMtQIMKdXTeiSUuxevFqo/y4i1d3zaTu43nmvrdBeKIKIf5VF7ysXLysR6bcdzqqbZrORJvZusdqFX9fB/GofouqVr8loGjmV0IOHofCtIua3kB8G7cwByvAx09TgdNJ5kUFIPGoJkCZ5RVXla4/w==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b095e8-c0e4-43fa-be08-08d7c25d88f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2020 06:05:28.0807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g6HSjvPQ17jn0KWvshIMProyvmrOBEzK4y6Ll89vQWFki4NhColdH+IzJe2vTHD2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMMTqM9TCN8jVIDM6MTENCj4g
VG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyB2
aW5pY2l1cy5nb21lc0BpbnRlbC5jb207IENsYXVkaXUgTWFub2lsDQo+IDxjbGF1ZGl1Lm1hbm9p
bEBueHAuY29tPjsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47DQo+
IEFsZXhhbmRydSBNYXJnaW5lYW4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IFhpYW9s
aWFuZyBZYW5nDQo+IDx4aWFvbGlhbmcueWFuZ18xQG54cC5jb20+OyBSb3kgWmFuZyA8cm95Lnph
bmdAbnhwLmNvbT47IE1pbmdrYWkgSHUNCj4gPG1pbmdrYWkuaHVAbnhwLmNvbT47IEplcnJ5IEh1
YW5nIDxqZXJyeS5odWFuZ0BueHAuY29tPjsgTGVvIExpDQo+IDxsZW95YW5nLmxpQG54cC5jb20+
OyBtaWNoYWVsLmNoYW5AYnJvYWRjb20uY29tOyB2aXNoYWxAY2hlbHNpby5jb207DQo+IHNhZWVk
bUBtZWxsYW5veC5jb207IGxlb25Aa2VybmVsLm9yZzsgamlyaUBtZWxsYW5veC5jb207DQo+IGlk
b3NjaEBtZWxsYW5veC5jb207IGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOw0KPiBVTkdM
aW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBqaHNAbW9qYXRhdHUuY29tOw0KPiB4aXlvdS53YW5n
Y29uZ0BnbWFpbC5jb207IGpvaG4uaHVybGV5QG5ldHJvbm9tZS5jb207DQo+IHNpbW9uLmhvcm1h
bkBuZXRyb25vbWUuY29tOw0KPiBwaWV0ZXIuamFuc2VudmFudnV1cmVuQG5ldHJvbm9tZS5jb207
IHBhYmxvQG5ldGZpbHRlci5vcmc7DQo+IG1vc2hlQG1lbGxhbm94LmNvbTsgaXZhbi5raG9yb256
aHVrQGxpbmFyby5vcmc7IG0ta2FyaWNoZXJpMkB0aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51
eC5pbnRlbC5jb207IGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20NCj4gU3ViamVjdDogW0VY
VF0gUmU6IFtSRkMsbmV0LW5leHQgMi85XSBuZXQ6IHFvczogaW50cm9kdWNlIGEgZ2F0ZSBjb250
cm9sIGZsb3cNCj4gYWN0aW9uDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIEZy
aSwgIDYgTWFyIDIwMjAgMjA6NTY6MDAgKzA4MDAgUG8gTGl1IHdyb3RlOg0KPiA+IEludHJvZHVj
ZSBhIGluZ3Jlc3MgZnJhbWUgZ2F0ZSBjb250cm9sIGZsb3cgYWN0aW9uLiB0YyBjcmVhdGUgYSBn
YXRlDQo+ID4gYWN0aW9uIHdvdWxkIHByb3ZpZGUgYSBnYXRlIGxpc3QgdG8gY29udHJvbCB3aGVu
IG9wZW4vY2xvc2Ugc3RhdGUuDQo+ID4gd2hlbiB0aGUgZ2F0ZSBvcGVuIHN0YXRlLCB0aGUgZmxv
dyBjb3VsZCBwYXNzIGJ1dCBub3Qgd2hlbiBnYXRlIHN0YXRlDQo+ID4gaXMgY2xvc2UuIFRoZSBk
cml2ZXIgd291bGQgcmVwZWF0IHRoZSBnYXRlIGxpc3QgY3ljbGljYWxseS4gVXNlciBhbHNvDQo+
ID4gY291bGQgYXNzaWduIGEgdGltZSBwb2ludCB0byBzdGFydCB0aGUgZ2F0ZSBsaXN0IGJ5IHRo
ZSBiYXNldGltZQ0KPiA+IHBhcmFtZXRlci4gaWYgdGhlIGJhc2V0aW1lIGhhcyBwYXNzZWQgY3Vy
cmVudCB0aW1lLCBzdGFydCB0aW1lIHdvdWxkDQo+ID4gY2FsY3VsYXRlIGJ5IHRoZSBjeWNsZXRp
bWUgb2YgdGhlIGdhdGUgbGlzdC4NCj4gPiBUaGUgYWN0aW9uIGdhdGUgYmVoYXZpb3IgdHJ5IHRv
IGtlZXAgYWNjb3JkaW5nIHRvIHRoZSBJRUVFIDgwMi4xUWNpIHNwZWMuDQo+ID4gRm9yIHRoZSBz
b2Z0d2FyZSBzaW11bGF0aW9uLCByZXF1aXJlIHRoZSB1c2VyIGlucHV0IHRoZSBjbG9jayB0eXBl
Lg0KPiA+DQo+ID4gQmVsb3cgaXMgdGhlIHNldHRpbmcgZXhhbXBsZSBpbiB1c2VyIHNwYWNlOg0K
PiA+DQo+ID4gPiB0YyBxZGlzYyBhZGQgZGV2IGV0aDAgaW5ncmVzcw0KPiA+DQo+ID4gPiB0YyBm
aWx0ZXIgYWRkIGRldiBldGgwIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcCBcDQo+ID4gICAgICAg
ICAgZmxvd2VyIHNyY19pcCAxOTIuMTY4LjAuMjAgXA0KPiA+ICAgICAgICAgIGFjdGlvbiBnYXRl
IGluZGV4IDIgXA0KPiA+ICAgICAgICAgIHNjaGVkLWVudHJ5IE9QRU4gMjAwMDAwMDAwIC0xIC0x
IFwNCj4gPiAgICAgICAgICBzY2hlZC1lbnRyeSBDTE9TRSAxMDAwMDAwMDAgLTEgLTENCj4gPg0K
PiA+ID4gdGMgY2hhaW4gZGVsIGRldiBldGgwIGluZ3Jlc3MgY2hhaW4gMA0KPiA+DQo+ID4gInNj
aGVkLWVudHJ5IiBmb2xsb3cgdGhlIG5hbWUgdGFwcmlvIHN0eWxlLiBnYXRlIHN0YXRlIGlzDQo+
ID4gIk9QRU4iLyJDTE9TRSIuIEZvbGxvdyB0aGUgcGVyaW9kIG5hbm9zZWNvbmQuIFRoZW4gbmV4
dCAtMSBpcyBpbnRlcm5hbA0KPiA+IHByaW9yaXR5IHZhbHVlIG1lYW5zIHdoaWNoIGluZ3Jlc3Mg
cXVldWUgc2hvdWxkIHB1dC4gIi0xIiBtZWFucw0KPiA+IHdpbGRjYXJkLiBUaGUgbGFzdCB2YWx1
ZSBvcHRpb25hbCBzcGVjaWZpZXMgdGhlIG1heGltdW0gbnVtYmVyIG9mDQo+IE1TRFUNCj4gPiBv
Y3RldHMgdGhhdCBhcmUgcGVybWl0dGVkIHRvIHBhc3MgdGhlIGdhdGUgZHVyaW5nIHRoZSBzcGVj
aWZpZWQgdGltZQ0KPiA+IGludGVydmFsLg0KPiA+DQo+ID4gTk9URTogVGhpcyBzb2Z0d2FyZSBz
aW11bGF0b3IgdmVyc2lvbiBub3Qgc2VwYXJhdGUgdGhlDQo+IGFkbWluL29wZXJhdGlvbg0KPiA+
IHN0YXRlIG1hY2hpbmUuIFVwZGF0ZSBzZXR0aW5nIHdvdWxkIG92ZXJ3cml0ZSBzdG9wIHRoZSBw
cmV2aW9zIHNldHRpbmcNCj4gPiBhbmQgd2FpdGluZyBuZXcgY3ljbGUgc3RhcnQuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBQbyBMaXUgPFBvLkxpdUBueHAuY29tPg0KPiANCj4gPiBkaWZmIC0t
Z2l0IGEvbmV0L3NjaGVkL2FjdF9nYXRlLmMgYi9uZXQvc2NoZWQvYWN0X2dhdGUuYyBuZXcgZmls
ZSBtb2RlDQo+ID4gMTAwNjQ0IGluZGV4IDAwMDAwMDAwMDAwMC4uYzJjMjQzY2EwMjhjDQo+ID4g
LS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL25ldC9zY2hlZC9hY3RfZ2F0ZS5jDQo+ID4gQEAgLTAs
MCArMSw2NDUgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wKykN
Cj4gDQo+IFdoeSB0aGUgcGFyZW50aGVzaXM/DQoNCldpbGwgY2hhbmdlZCB0byBHUEwtMi4wLW9y
LWxhdGVyLg0KDQo+IA0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kgZW50cnlf
cG9saWN5W1RDQV9HQVRFX0VOVFJZX01BWCArIDFdDQo+ID0gew0KPiA+ICsgICAgIFtUQ0FfR0FU
RV9FTlRSWV9JTkRFWF0gICAgICAgICAgPSB7IC50eXBlID0gTkxBX1UzMiB9LA0KPiA+ICsgICAg
IFtUQ0FfR0FURV9FTlRSWV9HQVRFXSAgICAgICAgICAgPSB7IC50eXBlID0gTkxBX0ZMQUcgfSwN
Cj4gPiArICAgICBbVENBX0dBVEVfRU5UUllfSU5URVJWQUxdICAgICAgID0geyAudHlwZSA9IE5M
QV9VMzIgfSwNCj4gPiArICAgICBbVENBX0dBVEVfRU5UUllfSVBWXSAgICAgICAgICAgID0geyAu
dHlwZSA9IE5MQV9TMzIgfSwNCj4gPiArICAgICBbVENBX0dBVEVfRU5UUllfTUFYX09DVEVUU10g
ICAgID0geyAudHlwZSA9IE5MQV9TMzIgfSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbmxhX3BvbGljeSBnYXRlX3BvbGljeVtUQ0FfR0FURV9NQVggKyAxXSA9IHsN
Cj4gPiArICAgICBbVENBX0dBVEVfUEFSTVNdICAgICAgICAgICAgICAgID0geyAubGVuID0gc2l6
ZW9mKHN0cnVjdCB0Y19nYXRlKSB9LA0KPiA+ICsgICAgIFtUQ0FfR0FURV9QUklPUklUWV0gICAg
ICAgICAgICAgPSB7IC50eXBlID0gTkxBX1MzMiB9LA0KPiA+ICsgICAgIFtUQ0FfR0FURV9FTlRS
WV9MSVNUXSAgICAgICAgICAgPSB7IC50eXBlID0gTkxBX05FU1RFRCB9LA0KPiA+ICsgICAgIFtU
Q0FfR0FURV9CQVNFX1RJTUVdICAgICAgICAgICAgPSB7IC50eXBlID0gTkxBX1U2NCB9LA0KPiA+
ICsgICAgIFtUQ0FfR0FURV9DWUNMRV9USU1FXSAgICAgICAgICAgPSB7IC50eXBlID0gTkxBX1U2
NCB9LA0KPiA+ICsgICAgIFtUQ0FfR0FURV9DWUNMRV9USU1FX0VYVF0gICAgICAgPSB7IC50eXBl
ID0gTkxBX1U2NCB9LA0KPiA+ICsgICAgIFtUQ0FfR0FURV9GTEFHU10gICAgICAgICAgICAgICAg
PSB7IC50eXBlID0gTkxBX1UzMiB9LA0KPiA+ICsgICAgIFtUQ0FfR0FURV9DTE9DS0lEXSAgICAg
ICAgICAgICAgPSB7IC50eXBlID0gTkxBX1MzMiB9LA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3Rh
dGljIGludCBmaWxsX2dhdGVfZW50cnkoc3RydWN0IG5sYXR0ciAqKnRiLCBzdHJ1Y3QgdGNmZ19n
YXRlX2VudHJ5ICplbnRyeSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG5l
dGxpbmtfZXh0X2FjayAqZXh0YWNrKSB7DQo+ID4gKyAgICAgdTMyIGludGVydmFsID0gMDsNCj4g
PiArDQo+ID4gKyAgICAgaWYgKHRiW1RDQV9HQVRFX0VOVFJZX0dBVEVdKQ0KPiA+ICsgICAgICAg
ICAgICAgZW50cnktPmdhdGVfc3RhdGUgPSAxOw0KPiA+ICsgICAgIGVsc2UNCj4gPiArICAgICAg
ICAgICAgIGVudHJ5LT5nYXRlX3N0YXRlID0gMDsNCj4gDQo+IG5sYV9nZXRfZmxhZygpDQoNCk9r
LCAgd2lsbCBwYXJzZSBieSB0aGUgbmxhX2dldF9mbGFnKCkNCg0KPiANCj4gPiArDQo+ID4gKyAg
ICAgaWYgKHRiW1RDQV9HQVRFX0VOVFJZX0lOVEVSVkFMXSkNCj4gPiArICAgICAgICAgICAgIGlu
dGVydmFsID0gbmxhX2dldF91MzIodGJbVENBX0dBVEVfRU5UUllfSU5URVJWQUxdKTsNCj4gPiAr
DQo+ID4gKyAgICAgaWYgKGludGVydmFsID09IDApIHsNCj4gPiArICAgICAgICAgICAgIE5MX1NF
VF9FUlJfTVNHKGV4dGFjaywgIkludmFsaWQgaW50ZXJ2YWwgZm9yIHNjaGVkdWxlIGVudHJ5Iik7
DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArICAgICB9DQo+IA0KPiA+
ICtzdGF0aWMgaW50IHBhcnNlX2dhdGVfbGlzdChzdHJ1Y3QgbmxhdHRyICpsaXN0LA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdGNmX2dhdGVfcGFyYW1zICpzY2hlZCwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNr
KSB7DQo+ID4gKyAgICAgc3RydWN0IG5sYXR0ciAqbjsNCj4gPiArICAgICBpbnQgZXJyLCByZW07
DQo+ID4gKyAgICAgaW50IGkgPSAwOw0KPiA+ICsNCj4gPiArICAgICBpZiAoIWxpc3QpDQo+ID4g
KyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKyAgICAgbmxhX2Zvcl9l
YWNoX25lc3RlZChuLCBsaXN0LCByZW0pIHsNCj4gPiArICAgICAgICAgICAgIHN0cnVjdCB0Y2Zn
X2dhdGVfZW50cnkgKmVudHJ5Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIGlmIChubGFfdHlw
ZShuKSAhPSBUQ0FfR0FURV9PTkVfRU5UUlkpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
TkxfU0VUX0VSUl9NU0coZXh0YWNrLCAiQXR0cmlidXRlIGlzbid0IHR5cGUgJ2VudHJ5JyIpOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gPiArICAgICAgICAgICAgIH0N
Cj4gPiArDQo+ID4gKyAgICAgICAgICAgICBlbnRyeSA9IGt6YWxsb2Moc2l6ZW9mKCplbnRyeSks
IEdGUF9LRVJORUwpOw0KPiA+ICsgICAgICAgICAgICAgaWYgKCFlbnRyeSkgew0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICBOTF9TRVRfRVJSX01TRyhleHRhY2ssICJOb3QgZW5vdWdoIG1lbW9y
eSBmb3IgZW50cnkiKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07
DQo+ID4gKyAgICAgICAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgZXJyID0gcGFy
c2VfZ2F0ZV9lbnRyeShuLCBlbnRyeSwgaSwgZXh0YWNrKTsNCj4gPiArICAgICAgICAgICAgIGlm
IChlcnIgPCAwKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGtmcmVlKGVudHJ5KTsNCj4g
DQo+IGRvZXNuJ3QgdGhpcyBsZWFrIHByZXZpb3VzbHkgYWRkZWQgZW50cmllcz8NCg0KT2ssIHdp
bGwgZml4IGl0Lg0KDQo+IA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZXJyOw0K
PiA+ICsgICAgICAgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIGxpc3RfYWRkX3Rh
aWwoJmVudHJ5LT5saXN0LCAmc2NoZWQtPmVudHJpZXMpOw0KPiA+ICsgICAgICAgICAgICAgaSsr
Ow0KPiA+ICsgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgc2NoZWQtPm51bV9lbnRyaWVzID0gaTsN
Cj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIGk7DQo+ID4gK30NCj4gDQo+IA0KPiA+ICtzdGF0aWMg
aW50IHBhcnNlX2dhdGVfZW50cnkoc3RydWN0IG5sYXR0ciAqbiwgc3RydWN0ICB0Y2ZnX2dhdGVf
ZW50cnkNCj4gKmVudHJ5LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgaW50IGluZGV4
LCBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spIHsNCj4gPiArICAgICBzdHJ1Y3Qgbmxh
dHRyICp0YltUQ0FfR0FURV9FTlRSWV9NQVggKyAxXSA9IHsgfTsNCj4gPiArICAgICBpbnQgZXJy
Ow0KPiA+ICsNCj4gPiArICAgICBlcnIgPSBubGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0ZWQodGIs
IFRDQV9HQVRFX0VOVFJZX01BWCwgbiwNCj4gDQo+IFBsZWFzZSBkb24ndCB1c2UgdGhlIGRlcHJl
Y2F0ZWQgY2FsbHMgaW4gbmV3IGNvZGUuDQoNClVuZGVyc3RhbmQsIHdpbGwgY2hhbmdlIHRvIG5s
YV9wYXJzZV9uZXN0ZWQoKQ0KDQo+IA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBlbnRyeV9wb2xpY3ksIE5VTEwpOw0KPiA+ICsgICAgIGlmIChlcnIgPCAwKSB7
DQo+ID4gKyAgICAgICAgICAgICBOTF9TRVRfRVJSX01TRyhleHRhY2ssICJDb3VsZCBub3QgcGFy
c2UgbmVzdGVkIGVudHJ5Iik7DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4g
PiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAgIGVudHJ5LT5pbmRleCA9IGluZGV4Ow0KPiA+ICsN
Cj4gPiArICAgICByZXR1cm4gZmlsbF9nYXRlX2VudHJ5KHRiLCBlbnRyeSwgZXh0YWNrKTsgfQ0K
DQpUaGFua3MhDQoNClBvIExpdQ0KDQo=
