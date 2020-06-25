Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9E2097AC
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 02:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbgFYAfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 20:35:06 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:21856
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388297AbgFYAfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 20:35:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIb3Fl8sQ4Gb7H2KvsjVjLsG0j+Bb4LdkKl/sbM5wG7M9I2jARp24gDXWUL/4Tm3x+NTV5ATYTX2ZDCWM0esNgnmf43ukzioSBAPTymgGEOu2iVt9XWBA1xHtoKhycJwoGLx950+RzE24eDrrr9MvfuYP5ES308gRkX7FYft3ErpruRix8ld5R+xYV83klo5YmKYU0s0g1yu82TnSGrPfAj3LF48GJ5E9EL37ScWnt26lsnW5XmE0CxswG7WQRg29tLMbGQcZpSyYpnCOrFc/aB/m05DtoC59H0olQ0q4cWjaNawyJKSgRUdWsJl2RyGyOCkShPedkiTjEsstdZbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBwFfsWXd31q7nPFGL5EyCXRVF96mY6Eob3s+GYdbXk=;
 b=AENy1OKlE94p1ytrSS3XyhZAKZb6RvKFm+PsMFqbUR374lepNpwhTgiG7u1NlyR/sL31Tkoem51nb3OOhiF0fz1V3PlcECMcLO44KxdGbDsqmpamaf5IF5egAPBPjYvcDhEtIJB37SIit0VOKdjJVTc6yhGoqBnmgwrbAYRYO9R0mZ6s7F2ZQ4exxKShmjdTMG9S0Aqh7n3xBCfLMo6YzSKZz6UAv6RfvvqCLZ59XgL9odIJ7xSpNjaXokrl7W/F14iOjAOIIjXBj296Z6W35IzPYm+x5r6qwj7kisl1CznR8DnGLVkGLvP19ASIu4dTHSdLB5b2yG0UPE5Kit+EFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBwFfsWXd31q7nPFGL5EyCXRVF96mY6Eob3s+GYdbXk=;
 b=S+gRwLHOnSZ72yld9JeXeG3x6w3gIMw4ZEDg3i8zNM/Sf31/xbY2aXyveIPUiAITXqJcuTn3BkAi5rvR4nackaGKWBP4xIVmC7Q9cEBjSkVWhxFegEjYpWXoWaoJU8LmXcv9sHZ5OKm1SBoKlCusVhXX7neaSuEMF4dLxS0A2vI=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Thu, 25 Jun
 2020 00:34:59 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 00:34:59 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
Subject: RE:Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZKQvCAuDQ40XSQTniNnX/Duof+rQ==
Date:   Thu, 25 Jun 2020 00:34:59 +0000
Message-ID: <VE1PR04MB6496E5275AD00A8A65095DD192920@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 39deeeff-6d82-4af0-4158-08d8189f97b7
x-ms-traffictypediagnostic: VE1PR04MB6688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66888F43251A3F64C5EC21A192920@VE1PR04MB6688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RAKRPiX9nYkc5WgRvnZPfBXSq9XKBh3VseXOFQUeWZoD4NKUZgvzjwq+x1hhUgZoe+XqEPoy0eW9qQMTgm5975dNbPpwLA0H9w8/mzq4vQAwERynJYMypbgw/99B1k5K/EY1E2Z8MDO0Qw6mCA4+r/tXG7x56NNL65Vpbc0TD7SfotDC2inBCX3+f2Y57IEbU2RLBPqaTeU5Fw/zgqXeaiJ6kPtb1K3wN9V4yENnzgcn1hM5NHyWg3G4INfuYxgeWPRfmZWOxbLrXVpiBCbbdQHykxTTXmZMzSAAZBIqaI4k9nvzE/WPXa0fU0/3ccrtg+pXBHZj+9yB7cdoVhMm5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(66476007)(64756008)(66556008)(186003)(86362001)(66946007)(7416002)(76116006)(8936002)(53546011)(478600001)(6506007)(110136005)(316002)(66446008)(26005)(52536014)(54906003)(71200400001)(5660300002)(33656002)(8676002)(7696005)(83380400001)(4326008)(55016002)(44832011)(9686003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vjU23AGlVJF8xk1z7dWxP0f6ridLR6Pc4iYVRyRHrDY69fvNaeWpFnFOjQDIeruDl0rw8mcLRfUkSHl+/XXZ7O7BdP9lrHPPqbmuSOx6y0Q5f/jDesXPh26W82miQkx4zpYxJ8DTlFg5S/g6bvKwhy4xGdAbXmvOmkV3ze1qK0eo2Fi9VJnWG9bajNKQhQzh/Hw+FDMADhoX/2kn3rSjirNvytyN1rvXbFC1uCfY8AFVr4eKU76Xpn0fGgWuNEui/zlT7VcEXOLeI5OGd/B+yxN7Z+hBR/yL750K4kyOK9IHgeHSqhb+/f71cGy5xWSmUzqpnBcYJQC+xzYKRMazAvCJMrhQI8VVgvT/A6bMt1ZWfy/iqVzE8HOTWVlFSJYLRcWB46Cr/awNqrSd4cQmXF0cQYZryWTTdLSgbBkTpf5Jf5607oGRtYcCo3yRWl1G20NGHmw4kLKY40xeNQWGb0jGYwLR2LvLLMnHVkbftrs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39deeeff-6d82-4af0-4158-08d8189f97b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 00:34:59.5652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iTEuSUSiT3QtX+oKx9eU09NopHZuePWp5B8fliQglyUrkOrkIqc8Tg5/J7+f16Qe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFtYWwgSGFkaSBTYWxp
bSA8amhzQG1vamF0YXR1LmNvbT4NCj4gU2VudDogMjAyMOW5tDbmnIgyNOaXpSAyMDo0NQ0KPiBU
bzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGxpbnV4LQ0K
PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBpZG9zY2hA
aWRvc2NoLm9yZw0KPiBDYzogamlyaUByZXNudWxsaS51czsgdmluaWNpdXMuZ29tZXNAaW50ZWwu
Y29tOyB2bGFkQGJ1c2xvdi5kZXY7IENsYXVkaXUNCj4gTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBu
eHAuY29tPjsgVmxhZGltaXIgT2x0ZWFuDQo+IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IEFs
ZXhhbmRydSBNYXJnaW5lYW4NCj4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IG1pY2hh
ZWwuY2hhbkBicm9hZGNvbS5jb207DQo+IHZpc2hhbEBjaGVsc2lvLmNvbTsgc2FlZWRtQG1lbGxh
bm94LmNvbTsgbGVvbkBrZXJuZWwub3JnOw0KPiBqaXJpQG1lbGxhbm94LmNvbTsgaWRvc2NoQG1l
bGxhbm94LmNvbTsNCj4gYWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb207IFVOR0xpbnV4RHJp
dmVyQG1pY3JvY2hpcC5jb207DQo+IGt1YmFAa2VybmVsLm9yZzsgeGl5b3Uud2FuZ2NvbmdAZ21h
aWwuY29tOw0KPiBzaW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsgcGFibG9AbmV0ZmlsdGVyLm9y
ZzsNCj4gbW9zaGVAbWVsbGFub3guY29tOyBtLWthcmljaGVyaTJAdGkuY29tOw0KPiBhbmRyZS5n
dWVkZXNAbGludXguaW50ZWwuY29tOyBzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZzsgRWR3YXJk
DQo+IENyZWUgPGVjcmVlQHNvbGFyZmxhcmUuY29tPg0KPiBTdWJqZWN0OiBSZTogW3YxLG5ldC1u
ZXh0IDMvNF0gbmV0OiBxb3M6IHBvbGljZSBhY3Rpb24gYWRkIGluZGV4IGZvciB0Yw0KPiBmbG93
ZXIgb2ZmbG9hZGluZw0KPiA+IA0KPiBPbiAyMDIwLTA2LTIzIDc6NTIgcC5tLiwgUG8gTGl1IHdy
b3RlOg0KPiA+IEhpIEphbWFsLA0KPiA+DQo+ID4NCj4gDQo+ID4+Pj4gTXkgcXVlc3Rpb246IElz
IHRoaXMgYW55IGRpZmZlcmVudCBmcm9tIGhvdyBzdGF0cyBhcmUgc3RydWN0dXJlZD8NCj4gPj4+
DQo+IA0KPiBbLi5dDQo+ID4+IE15IHF1ZXN0aW9uOiBXaHkgY2FudCB5b3UgYXBwbHkgdGhlIHNh
bWUgc2VtYW50aWNzIGZvciB0aGUgY291bnRlcnM/DQo+ID4+IERvZXMgeW91ciBoYXJkd2FyZSBo
YXZlIGFuIGluZGV4ZWQgY291bnRlci9zdGF0cyB0YWJsZT8gSWYgeWVzIHRoZW4NCj4gPj4geW91
DQo+ID4NCj4gPiBZZXMsDQo+IA0KPiBUaGF0IGlzIHRoZSBwb2ludCBpIHdhcyB0cnlpbmcgdG8g
Z2V0IHRvLiBCYXNpY2FsbHk6DQo+IFlvdSBoYXZlIGEgY291bnRlciB0YWJsZSB3aGljaCBpcyBy
ZWZlcmVuY2VkIGJ5ICJpbmRleCINCj4gWW91IGFsc28gaGF2ZSBhIG1ldGVyL3BvbGljZXIgdGFi
bGUgd2hpY2ggaXMgcmVmZXJlbmNlZCBieSAiaW5kZXgiLg0KDQpUaGV5IHNob3VsZCBiZSBvbmUg
c2FtZSBncm91cCBhbmQgc2FtZSBtZWFuaW5nLg0KDQo+IA0KPiBGb3IgcG9saWNlcnMsIHRoZXkg
bWFpbnRhaW4gdGhlaXIgb3duIHN0YXRzLiBTbyB3aGVuIGkgc2F5Og0KPiB0YyAuLi4gZmxvd2Vy
IC4uLiBhY3Rpb24gcG9saWNlIC4uLiBpbmRleCA1IFRoZSBpbmRleCByZWZlcnJlZCB0byBpcyBp
biB0aGUNCj4gcG9saWNlciB0YWJsZQ0KPiANCg0KU3VyZS4gTWVhbnMgcG9saWNlIHdpdGggTm8u
IDUgZW50cnkuIA0KDQo+IEJ1dCBmb3Igb3RoZXIgYWN0aW9ucywgZXhhbXBsZSB3aGVuIGkgc2F5
Og0KPiB0YyAuLi4gZmxvd2VyIC4uLiBhY3Rpb24gZHJvcCBpbmRleCAxMA0KDQpTdGlsbCB0aGUg
cXVlc3Rpb24sIGRvZXMgZ2FjdCBhY3Rpb24gZHJvcCBjb3VsZCBiaW5kIHdpdGggaW5kZXg/IEl0
IGRvZXNuJ3QgbWVhbmZ1bC4NCg0KPiBUaGUgaW5kZXggaXMgaW4gdGhlIGNvdW50ZXIvc3RhdHMg
dGFibGUuDQo+IEl0IGlzIG5vdCBleGFjdGx5ICIxMCIgaW4gaGFyZHdhcmUsIHRoZSBkcml2ZXIg
bWFnaWNhbGx5IGhpZGVzIGl0IGZyb20gdGhlDQo+IHVzZXIgLSBzbyBpdCBjb3VsZCBiZSBodyBj
b3VudGVyIGluZGV4IDEyMzQNCg0KTm90IGV4YWN0bHkuIEN1cnJlbnQgZmxvd2VyIG9mZmxvYWRp
bmcgc3RhdHMgbWVhbnMgZ2V0IHRoZSBjaGFpbiBpbmRleCBmb3IgdGhhdCBmbG93IGZpbHRlci4g
VGhlIG90aGVyIGFjdGlvbnMgc2hvdWxkIGJpbmQgdG8gdGhhdCBjaGFpbiBpbmRleC4gTGlrZSBJ
RUVFODAyLjFRY2ksIHdoYXQgSSBhbSBkb2luZyBpcyBiaW5kIGdhdGUgYWN0aW9uIHRvIGZpbHRl
ciBjaGFpbihtYW5kYXRvcnkpLiBBbmQgYWxzbyBwb2xpY2UgYWN0aW9uIGFzIG9wdGlvbmFsLiBU
aGVyZSBpcyBzdHJlYW0gY291bnRlciB0YWJsZSB3aGljaCBzdW1tYXJ5IHRoZSBjb3VudGVycyBw
YXNzIGdhdGUgYWN0aW9uIGVudHJ5IGFuZCBwb2xpY2UgYWN0aW9uIGVudHJ5IGZvciB0aGF0IGNo
YWluIGluZGV4KHRoZXJlIGlzIGEgYml0IGRpZmZlcmVudCBpZiB0d28gY2hhaW4gc2hhcmluZyBz
YW1lIGFjdGlvbiBsaXN0KS4NCk9uZSBjaGFpbiBjb3VudGVyIHdoaWNoIHRjIHNob3cgc3RhdHMg
Z2V0IGNvdW50ZXIgc291cmNlOg0Kc3RydWN0IHBzZnBfc3RyZWFtZmlsdGVyX2NvdW50ZXJzIHsN
CiAgICAgICAgdTY0IG1hdGNoaW5nX2ZyYW1lc19jb3VudDsNCiAgICAgICAgdTY0IHBhc3Npbmdf
ZnJhbWVzX2NvdW50Ow0KICAgICAgICB1NjQgbm90X3Bhc3NpbmdfZnJhbWVzX2NvdW50Ow0KICAg
ICAgICB1NjQgcGFzc2luZ19zZHVfY291bnQ7DQogICAgICAgIHU2NCBub3RfcGFzc2luZ19zZHVf
Y291bnQ7DQogICAgICAgIHU2NCByZWRfZnJhbWVzX2NvdW50Ow0KfTsNCg0KV2hlbiBwYXNzIHRv
IHRoZSB1c2VyIHNwYWNlLCBzdW1tYXJpemUgYXM6DQogICAgICAgIHN0YXRzLnBrdHMgPSBjb3Vu
dGVycy5tYXRjaGluZ19mcmFtZXNfY291bnQgKyAgY291bnRlcnMubm90X3Bhc3Npbmdfc2R1X2Nv
dW50IC0gZmlsdGVyLT5zdGF0cy5wa3RzOw0KICAgICAgICBzdGF0cy5kcm9wcyA9IGNvdW50ZXJz
Lm5vdF9wYXNzaW5nX2ZyYW1lc19jb3VudCArIGNvdW50ZXJzLm5vdF9wYXNzaW5nX3NkdV9jb3Vu
dCArICAgY291bnRlcnMucmVkX2ZyYW1lc19jb3VudCAtIGZpbHRlci0+c3RhdHMuZHJvcHM7DQoN
CkJ1dCBpbiBzb2Z0d2FyZSBzaWRlLCBpdCBpcyBzaG93aW5nIGluIHRoZSBhY3Rpb24gbGlzdC4g
QW5kIGFjdGlvbiBnYXRlIGFuZCBwb2xpY2UgZXhhY3RseSBzaG93aW5nIHRoZSBjb3VudGVycyB0
aGF0IGNoYWluIGluZGV4LiBOb3QgdGhlIHRydWUgY291bnRlcnMgb2YgaW5kZXggYWN0aW9uIGdh
dGUgb3IgaW5kZXggcG9saWNlLiBUaGlzIGlzIHRoZSBsaW1pdGF0aW9uIG9mIGdldCB0aGUgb2Zm
bG9hZGluZyBzdGF0cy4NCg0KDQo+IA0KPiBUaGUgb2xkIGFwcHJvYWNoIGlzIHRvIGFzc3VtZSB0
aGUgY2xhc3NpZmllciAoZmxvd2VyIGluIHRoaXMNCj4gY2FzZSkgaGFzIGEgY291bnRlci4gVGhl
IHJlYXNvbiBmb3IgdGhpcyBhc3N1bXB0aW9uIGlzIG9sZGVyIGhhcmR3YXJlIHdhcw0KPiBkZXNp
Z25lZCB0byBkZWFsIHdpdGggYSBzaW5nbGUgYWN0aW9uIHBlciBtYXRjaC4NCj4gU28gYSBjb3Vu
dGVyIHRvIHRoZSBmaWx0ZXIgaXMgYWxzbyB0aGUgY291bnRlciB0byB0aGUNCj4gKHNpbmdsZSkg
YWN0aW9uLiBJIGdldCB0aGUgZmVlbGluZyB5b3VyIGhhcmR3YXJlIGZpdHMgaW4gdGhhdCBzcGFj
ZS4NCg0KTm8sIGhhcmR3YXJlIGNvdWxkIGhhdmUgZ2F0ZStwb2xpY2UgYWN0aW9ucyBidXQgYmlu
ZCB0byBvbmUgc3RyZWFtIGZpbHRlciBjb3VudGVyIHRhYmxlIGluIElFRUUgODAyLjFRY2kuDQoN
Cj4gDQo+IE1vZGVybiB1c2UgY2FzZXMgaGF2ZSBldm9sdmVkIGZyb20gdGhlIEFDTCBzaW5nbGUg
bWF0Y2ggYW5kIGFjdGlvbg0KPiBhcHByb2FjaC4gTWFpbnRhaW5pbmcgdGhlIG9sZCB0aG91Z2h0
L2FyY2hpdGVjdHVyZSBicmVha3MgaW4gdHdvIHVzZQ0KPiBjYXNlczoNCj4gMSkgd2hlbiB5b3Ug
aGF2ZSBtdWx0aXBsZSBhY3Rpb25zIHBlciBwb2xpY3kgZmlsdGVyLiBZb3UgbmVlZCBjb3VudGVy
LXBlci0NCj4gYWN0aW9uIGZvciB2YXJpb3VzIHJlYXNvbnMNCg0KQWN0aW9uIGluZGV4IG9ubHkg
Zm9yIHNldCBhbiBhY3Rpb24gZW50cnkgaW4gaGFyZHdhcmUsIGFuZCBub3QgZ2V0IHN0YXRzIGJ5
IHRoYXQgaW5kZXguDQpTbyBJIGRvbid0IHRoaW5rIGl0IGlzIHByb2JsZW0gb2YgIGV4cG9zaW5n
IGFjdGlvbiBpbmRleCB0byB0aGUgZHJpdmVyIGJyZWFrIHRoZSBydWxlLiBUaGlzIGlzIHRoZSBs
aW1pdGF0aW9uIG9mIGdldCB0aGUgb2ZmbG9hZGluZyBzdGF0cywgdGhlcmUgaXMgbm8gY291bnRl
cnMgZ2V0IGJ5IGFjdGlvbiBpbmRleC4gDQoNCj4gMikgU2hhcmluZyBvZiBjb3VudGVycyBhY3Jv
c3MgZmlsdGVycyBhbmQgYWN0aW9uLiBUaGlzIGNhbiBiZSBhY2hpZXZlDQo+IA0KPiB0YyBzdXBw
b3J0cyB0aGUgYWJvdmUgYW5kIGlzIHN1ZmZpY2llbnQgdG8gY292ZXIgdGhlIG9sZCB1c2UgY2Fz
ZXMuDQo+IEkgYW0ganVzdCB3b3JyaWVkLCBhcmNoaXRlY3R1cmFsbHksIHdlIGFyZSByZXN0cmlj
dGluZyBvdXJzZWx2ZXMgdG8gdGhlIG9sZA0KPiBzY2hlbWUuDQo+IA0KPiBBbm90aGVyIHJlYXNv
biB0aGlzIGlzIGltcG9ydGFudCBpcyBmb3IgdGhlIHNha2Ugb2YgYW5hbHl0aWNzLg0KPiBBIHVz
ZXIgc3BhY2UgYXBwIGNhbiBwb2xsIGp1c3QgZm9yIHRoZSBzdGF0cyB0YWJsZSBpbiBoYXJkd2Fy
ZSAob3IgdGhlDQo+IGNhY2hlZCB2ZXJzaW9uIGluIHRoZSBrZXJuZWwpIGFuZCByZWR1Y2UgdGhl
IGFtb3VudCBvZiBkYXRhIGNyb3NzaW5nIHRvDQo+IHVzZXIgc3BhY2UuLg0KPiANCj4gY2hlZXJz
LA0KPiBqYW1hbA0KPiANCj4gDQo+IA0KPiANCg0KDQpCciwNClBvIExpdQ0KDQo=
