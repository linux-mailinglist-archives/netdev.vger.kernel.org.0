Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0441C8AC8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgEGMbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:31:14 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:8054
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgEGMbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 08:31:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzZWH77awuVF6SQ3/90ykz5dDRbj9W94Vaex0AZS/VPGJX174+0SEIDIjPzHnPu49bXoQ/QgIMd8F2kdXZUXDw97v2YiJWkiydnx+24jIzzAOrpS8OaUrebMiLSwR88eNe8bdBHngYmP0m/9FdISKUETMmue4ulfXI+jpfbR83/n4czoT6LFJKp/gTQ5cgEe1JO3aMUhEfwWQ3/9TicjI4fqLOSEBQEAKht5R5soUH44/j50QGiI5pEBoqiw1t3ckSjBBTBFC2XBADTpPuo9gsUV/u+s5npO91XfKKs5b14QVXiAVCI7roO6SfAPxUXALcxFEdn5ngCEVb5gv9GiQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B58YjQ9kc8CqaFtbGgeCStNXvqNpvpY1ssz74Aw8PIY=;
 b=HDtbI4xm37KFHWdQHc5XcROIsX/YbFMJgizrBN5BIxKIkDCK0hd3MZM8gwmwdHzDi21KTiWrLTqC7H8+umnBFYikPS8rsG5PO8VZq34KOf1GU7NgdbHanh4JedA7AiCpzSQ/WohjdvGAZFwH7hDlJIrMv9rrZsfEijlLLGSn0Szru9/jgv0L1RbsmQK2NulsOBp9kreOkZiLuDMy/9dZKfN41GIcF1Bct3yXb66vdsKCkVqOz6Vymbyo02V4Hy2cZsdZglv9FCfH2GEUNhonugOVKp/WMgPGaqPWKd8DbKwKpcG6DcBQsMZdXxRTCB8deviTRnLZIDFNO20efGSXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B58YjQ9kc8CqaFtbGgeCStNXvqNpvpY1ssz74Aw8PIY=;
 b=Dn94Rci1Vj0vCXhlptGIDZ57K5OHJZh5hFmrqWWaFALOAlbtnxzXM9egn/OgTbs2VFOKlvAbPiS4g6I3wv3Tr0r1zyRex9RT4DQvIwLl/NDzfz/hKljx0a2CIXwk9IdLJdU7/r5dwUaCk2Bf4762yeXJ5xt+iCtNSOo/2zyupz0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6623.eurprd04.prod.outlook.com (2603:10a6:803:125::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Thu, 7 May
 2020 12:31:09 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.034; Thu, 7 May 2020
 12:31:09 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: RE: Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
Thread-Topic: Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
Thread-Index: AdYkGP/813CTQ3HyQZuckXvjuAsisQAUBulw
Date:   Thu, 7 May 2020 12:31:09 +0000
Message-ID: <VE1PR04MB6496B92955CD21BC70A7CFAC92A50@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <VE1PR04MB64969AC550AE3A762DADEF5292A50@VE1PR04MB6496.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB64969AC550AE3A762DADEF5292A50@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04893759-e321-4c45-0c33-08d7f282858b
x-ms-traffictypediagnostic: VE1PR04MB6623:|VE1PR04MB6623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6623BB4C679768A7F607F98C92A50@VE1PR04MB6623.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mqqE55z0E38u+ZBYxQ7W1DT8qIUe89FPc07r4A3DSU+4vVTWdfcnIacrUUKNsDeuOFuzWRo8XLMUTJcKLeUDhLfQh3PPziAxGWSoyaWsB6za/aIwGKB0zFUThAQD62zi6Y6Oftffr2nxz5TMXXHYcQKqPzgP3A7iaeSs1wmeVi6S0epP/Zy1m0H85jCjzaiwCJfsg/9n/1LP9nNXiIzwKlky2Ce5KuixlGAxHp2EzN0Rm/PDOhN6015Ul/mIg4By6tXzh378roERvy1I5Mw8Gor7iLnXaln/SBtSWuLDJlctLnMQ4b6SigQYWvSGxikRyMP6K9o7Pn850hbJckdO1Zlub30kKhtA+f/IZqXv/M/nIjOpreGxK/Q2BT9Gp4n+jgXCPUae9ACfaN1/UGaIVAtZyDMEN6B2GnMZHVPY+SvcIxbRCoVw0U/iB+owMUAm2pl2QSr+NMlGa9TExAgv4+wdSaOIghmsGqWQNPcAC7iswttD+C+ie5YpX1BGoupq4OYn+S1mO92yOgACHv+M2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(33430700001)(5660300002)(478600001)(4326008)(2906002)(55016002)(53546011)(33440700001)(66946007)(52536014)(66446008)(6506007)(66476007)(76116006)(64756008)(54906003)(66556008)(83300400001)(6916009)(83320400001)(83280400001)(83310400001)(83290400001)(9686003)(86362001)(33656002)(7696005)(71200400001)(8936002)(186003)(2940100002)(44832011)(316002)(8676002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UKkrcyhs9o5oqjs3gw3mZaGOgvWpHZyDtod8xMrKcuqu/waLdlX2wlj+dhybo0+YIuawxidB4bHBy0RvJYGcCUB/UWTpHDsEKxY4HEZ07Vkm05/qJ/bKlZGrmHifdN2enUZZMc+EkZbmEitB4IiRVz+BI1ohXSbbG1n9U3GZMqTD8T2sn1yAgeEjRitBPHdqXI7Wl7IsK/NvkvZjhNmbJ6/fgutkIMYKguqm2O1YzgsnDRxAHw4F7tzNywMnUJ3QZ4PEhrn+1ToyMOWIKWz17N4/zHf5+vtYV6TrHAlpcz1s+eCc3gpxzMYfR/r8GSdDzIsxZQGkl6ctFQ+gGhtH9688LnovyNfFsKdUp//1EHJpcw/84wl3CpbUdxDWZzySD3Xl8UfkZtNDYwSkqJ4MhXAeC/E5vpCCqsZSRg0cB8cDnPZNgqMznfXD6ELCzGrM84Qnw6Fv7IjwUJ2tIo0+CcvaCkGm6fG2hVZ/1C9xrcbWBuOsyNk+1WPsv0ewUazkG0ScV7eALhoacO4e6GjlI5uYJwEZVxoJHZYhx55aiE777Ty/3yEVqoundIKFTmDVwnRTXNBt03yOg6ot5cPj77wW1G+BAzP2x+S4T0Z+xcIy9tLl5hSSGfzA1qP0KZcT0hRkHtVKlNyCvcfAjbhTH1iwioHsXJtUv3gB1x9CGrMLc7ak0quDqsbNZ/nxhnmiUbVghpu0VXcVWSFCbGX2MeCUMSMEC3Hdvm7OPCUVAbJIpxnlVKWzsVBew+rPuIHZOEhEMyTktVXFTHvs6PqQaR7Jwr46N8byya/8W/9NBzI=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04893759-e321-4c45-0c33-08d7f282858b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 12:31:09.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RmtP+OE6g2KxjBzTU4i+dL9JqqAyxfNYZo1Y/afZGGrY5xkepjIG8WXr54tt33o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQbyBM
aXUNCj4gU2VudDogMjAyMMTqNdTCN8jVIDEwOjUzDQo+IFRvOiBTdGVwaGVuIEhlbW1pbmdlciA8
c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+DQo+IENjOiBkc2FoZXJuQGdtYWlsLmNvbTsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmlu
aWNpdXMuZ29tZXNAaW50ZWwuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyB2bGFkQGJ1c2xv
di5kZXY7IENsYXVkaXUgTWFub2lsDQo+IDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgVmxhZGlt
aXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47DQo+IEFsZXhhbmRydSBNYXJnaW5l
YW4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT4NCj4gU3ViamVjdDogUkU6IFJlOiBbdjQs
aXByb3V0ZTItbmV4dCAxLzJdIGlwcm91dGUyLW5leHQ6dGM6YWN0aW9uOiBhZGQgYSBnYXRlDQo+
IGNvbnRyb2wgYWN0aW9uDQo+IA0KPiBIaSBTdGVwaGVuLA0KPiANCj4gDQo+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBu
ZXR3b3JrcGx1bWJlci5vcmc+DQo+ID4gU2VudDogMjAyMMTqNdTCNsjVIDIzOjIyDQo+ID4gVG86
IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQo+ID4gQ2M6IGRzYWhlcm5AZ21haWwuY29tOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHZp
bmljaXVzLmdvbWVzQGludGVsLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiB2bGFk
QGJ1c2xvdi5kZXY7IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgVmxh
ZGltaXINCj4gPiBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgQWxleGFuZHJ1IE1h
cmdpbmVhbg0KPiA+IDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+DQo+ID4gU3ViamVjdDog
UmU6IFt2NCxpcHJvdXRlMi1uZXh0IDEvMl0gaXByb3V0ZTItbmV4dDp0YzphY3Rpb246IGFkZCBh
DQo+ID4gZ2F0ZSBjb250cm9sIGFjdGlvbiBPbiBXZWQsICA2IE1heSAyMDIwIDE2OjQwOjE5ICsw
ODAwIFBvIExpdQ0KPiA+IDxQby5MaXVAbnhwLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+ICAgICAg
ICAgICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCphcmd2LCAiYmFzZS10aW1lIikgPT0gMCkgew0K
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIE5FWFRfQVJHKCk7DQo+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgaWYgKGdldF91NjQoJmJhc2VfdGltZSwgKmFyZ3YsIDEwKSkgew0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW52YWxpZGFyZyA9ICJiYXNlLXRpbWUiOw0K
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnJfYXJnOw0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmICht
YXRjaGVzKCphcmd2LCAiY3ljbGUtdGltZSIpID09IDApIHsNCj4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBORVhUX0FSRygpOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIGlmIChnZXRf
dTY0KCZjeWNsZV90aW1lLCAqYXJndiwgMTApKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBpbnZhbGlkYXJnID0gImN5Y2xlLXRpbWUiOw0KPiA+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZ290byBlcnJfYXJnOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIH0NCj4gPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCphcmd2LCAiY3lj
bGUtdGltZS1leHQiKSA9PSAwKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgTkVYVF9B
UkcoKTsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAoZ2V0X3U2NCgmY3ljbGVfdGlt
ZV9leHQsICphcmd2LCAxMCkpIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGludmFsaWRhcmcgPSAiY3ljbGUtdGltZS1leHQiOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgZ290byBlcnJfYXJnOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIH0N
Cj4gPg0KPiA+IENvdWxkIGFsbCB0aGVzZSB0aW1lIHZhbHVlcyB1c2UgZXhpc3RpbmcgVEMgaGVs
cGVyIHJvdXRpbmVzPw0KPiANCj4gSSBhZ3JlZSB0byBrZWVwIHRoZSB0YyByb3V0aW5lcyBpbnB1
dC4NCj4gVGhlIG5hbWVzIG9mIHRpbWVyIGlucHV0IGFuZCB0eXBlIGlzIG1vcmUgcmVmZXJlbmNl
IHRoZSB0YXByaW8gaW5wdXQuDQo+IA0KDQpTaGFsbCBJIHN1cHBvcnQgYm90aCBpbnB1dCBtZXRo
b2QuIFRoZSBkZWZhdWx0IGRlY2ltYWwgaW5wdXQgbGlrZSAxMjAwMDAgZGVmYXVsdCB0byBuYW5v
LXNlY29uZCBhbmQgZm9ybWFsIHRpbWUgcm91dGluZXMgbGlrZSAxMjB1cy4NClRoZW4gdGhlIHRj
IHNob3cgY29tbWFuZCBzaG93cyBmb3JtYWwgdGltZSByb3V0aW5lcyBsaWtlIDEyMHVzIHdoYXRl
dmVyIGluIG5vbi1qc29uIGZvcm1hdC4gSnNvbiBmb3JtYXQgc2hvd3MgYSBkZWNpbWFsIG51bWJl
ciBvbmx5IHdoaWNoIGlzIGFsd2F5cyBkb25lIGJ5IG90aGVyIHRjIGNvbW1hbmQuDQoNClNvIHRo
aXMgd291bGQgY29tcGF0aWJsZSB3aXRoIGtlcm5lbCBjb21taXQgY29tbWFuZHMgZXhhbXBsZXMu
IEJ1dCBJIHdvdWxkIG1lbnRpb24gaW4gdGhlIG1hbiBwYWdlcyBzdXBwb3J0aW5nIHRoZSB0aW1l
ciByb3V0aW5lcyBpbnB1dC4NCg0KPiA+IFNlZSBnZXRfdGltZSgpLiAgVGhlIHdheSB5b3UgaGF2
ZSBpdCBtYWtlcyBzZW5zZSBmb3IgaGFyZHdhcmUgYnV0DQo+ID4gc3RhbmRzIG91dCB2ZXJzdXMg
dGhlIHJlc3Qgb2YgdGMuDQo+ID4NCj4gPiBJdCBtYXliZSB0aGF0IHRoZSBrZXJuZWwgVUFQSSBp
cyB3cm9uZywgYW5kIHNob3VsZCBiZSB1c2luZyBzYW1lIHRpbWUNCj4gPiB1bml0cyBhcyByZXN0
IG9mIHRjLiBGb3Jnb3QgdG8gcmV2aWV3IHRoYXQgcGFydCBvZiB0aGUgcGF0Y2guDQo+IA0KPiBJ
IHdvdWxkIGFsc28gc3luYyB3aXRoIGtlcm5lbCBVQVBJIGlmIG5lZWRlZC4NCg0KSSBjaGVja2Vk
IHRoZSBnYXRlIFVBUEkgZmlsZSwgdGhlcmUgaXMgbm90aGluZyBuZWVkIHRvIGNoYW5nZWQgZm9y
IHRpbWUgZm9ybWF0Lg0KDQo+IA0KPiANCj4gQnIsDQo+IFBvIExpdQ0KDQoNCg0KQnIsDQpQbyBM
aXUNCg==
