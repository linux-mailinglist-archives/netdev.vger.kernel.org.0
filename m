Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2805828FE93
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394481AbgJPGw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:52:29 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:40782
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394471AbgJPGw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 02:52:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1wQrM/9NG4wAqBIW06pCyjvEfucGnFpxgurGoDZa/V3q06UhHkZPsaeez10QfN5pI+L5k8obp6IsYl0Yq/9IN1OQ/oojWXlV4WPdwFU6ByTY793tVXg2X5Dvx81DFjIuv6sbnPLwliu2qktbpUcyK//DippnarevXz1JRZxoQFgst9bw65ED6glgrxisaOFHx0lRX2v+4GGp8QezRr5ptYHh5fjevPP7eZSPwQdBhun/dQIJi4cwRtTWO1p0unGY4vO65KLo31iT8KHP6je7xLh6TfoPFOJJEyE/m/w4irD2X14IxcymEjsqflZWWcNagNsYUvPHVyFwOUXwSeCpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7HbShPoxbh6VO3q8LwH1QHg/+UCnE2v7DOxdHnuAg8=;
 b=hEVWKBqm7pmrRzJ6Zt9cV9cjTyeZJVedUmbXs46BIZARmqLn35+37LHBsHatKOO1yOcMkiOqCLHcxwvmQtpvU/99NG3/E+9zEQdS92YN17Eg8xKkzmCaJzW3AkBK4iOOACW1kNYhireMppJ5JjePS3BRPg5KdjY6sPJclyp4bODIWb+QwM1aDiE+3f3lh4U00M2XUEcUgiIbf0C+ERTuAs8Bv+kqGlT3vAy4o/L2mrFi4HHiPDDrHxdj1J053rsmChL/lr5Fjp1qg7geYPmvSAT+9JSZf/Aq5i4oXlDX79VnfI6OOzeP5ba3nVCW/LjSA3BBWCwfcBf6NS+htytnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7HbShPoxbh6VO3q8LwH1QHg/+UCnE2v7DOxdHnuAg8=;
 b=aO+cPImdTXoO/MqMSlKmga4m8Ybt7R+6sOfxdIiHNkGAFoknfdHgq6Zwrryl3EJ0mVNs6D/WqYGiGVxqY21VgK0LCPsbrxQCj3/AUSfgTGFER8xk4nL6/6X/dD7ovyRTGvxEqGe04RzFw9fm3IsSOlmF1DxQ2dP40GSOoPrI6FY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 06:52:24 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 06:52:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [PATCH 3/6] dt-bindings: can: flexcan: add fsl, can-index
 property to indicate a resource
Thread-Topic: [PATCH 3/6] dt-bindings: can: flexcan: add fsl, can-index
 property to indicate a resource
Thread-Index: AQHWo4Rz4ko8qPzoxE2z1DwWrsN/36mZybwA
Date:   Fri, 16 Oct 2020 06:52:23 +0000
Message-ID: <DB8PR04MB67950ABB888D13416D20784BE6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-4-qiangqing.zhang@nxp.com>
 <604a66f6-83ea-630e-f479-fe62189de42a@pengutronix.de>
In-Reply-To: <604a66f6-83ea-630e-f479-fe62189de42a@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 274ea678-0641-40b1-ecc7-08d871a0097b
x-ms-traffictypediagnostic: DB6PR0402MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27258434975A9C0D9228BDEBE6030@DB6PR0402MB2725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dLSQXuTmm6N3oOETTEgyuZNPsCR6oUUHgPmYMQc5qWtTU6Ms+TqgNtBKKQzagsKzQ+f07zJ5QMq4wdTp4hKSJ3zja58BUOBhbT6nE+RVfRkGWlYOQJnSQfhN1QbUUd7moSKlFgGCoGt5H9kRS+pJUVBRbATaNeaeExTT8+DHd9A4okDyWiS3AuK8Yx6NjHlGGhHERwMFgqa4JJFXHdfLEQZWTgSQvSlWkE7TsuJ15Iss14G/JloOpc/mUAdPtmv1yRjMik6MhAJ9uwSmtHJlDUkTC/yPUyMnTbDHkBY+lUYI1rwPejSOGlZ2vZHwLs5aPfTNoBm2m+D5qZjva/4NSWioH/qQfh1NbnWn4Y8FmKpXQLtVHBeyEtAgwCy5OnjX2p6qXk6UgPYwbnVAGKPzlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(186003)(26005)(55016002)(86362001)(8676002)(83380400001)(966005)(66446008)(71200400001)(33656002)(7696005)(478600001)(64756008)(76116006)(8936002)(54906003)(6506007)(53546011)(9686003)(52536014)(316002)(66476007)(2906002)(4326008)(5660300002)(66946007)(110136005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7emisCwKSKW+R5SLqNwCsv3LJ6kD3tFbOipgDWu/2Q1QNJLDt8u9Bdcy38sY5FpZ7pZF3qEc4k29bGFq80YMnLInQbM8cT5jgzZv0uOeuBOMgLBoS+i+caV0jgsjaeTSM3yle9jOA/ud3swUhH3YeDipK2dsVkohR7cu6vVN3WOOtB19hhxUfNikh+TJYVSlPUA4iB5lwOq6pwv0Nkl9W40zeyAx061RbO1DvvL8hRE4en3BAOTmV3sl00aAguXTnLaapfy4ev29a1XZ0niFxCYQ+MDWb14aioG5k7DFKey09NJHrnnmB/FjrnOhB4bLvqL086okHq6YZroNIsaFB3bYyFJYLsX2dVUfi5wXaHk8aC3S5w3fAOBiXC3UsDwAcuit/2zCqV2QaCV7UFMUEDfStxVba2/RJh/RiVHFpe5lA/88btCGfCgyC264mThh1wKCyvlpj7AXIJu46lK2BFtTnDZ6mE5ZEFhb4i1QYJhytNgZv5d20Vq7412hjoMx89Dw4UzaFT71mUXKmVkBtcKTGEB213UE+c8asKrNPm/RqZixP6Jg0g5rw1lKokrsWDG/4CUB8GJnSVWe8W8LJvb8FpxDV49tWrsYR8pTs9B1fKjjqKdPHbYMMYEUZu85xOPgi6zkDYYT9hUke7TVtQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274ea678-0641-40b1-ecc7-08d871a0097b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 06:52:23.9861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ac3YUEx6Kt/wL8anobFZeM/9QHn76YfDDAT+wb3oJwwlR1mag8hArb+MeafdZkvi3jnfE2xIIbwn8+wVfchnmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDE6jEw1MIxNsjV
IDE0OjIwDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgcm9i
aCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJv
bml4LmRlDQo+IENjOiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgUGVuZyBGYW4gPHBlbmcu
ZmFuQG54cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgUGFua2FqIEJhbnNhbA0KPiA8cGFua2FqLmJhbnNhbEBueHAuY29tPjsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9y
ZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IGtlcm5lbEBwZW5ndXRyb25p
eC5kZQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDMvNl0gZHQtYmluZGluZ3M6IGNhbjogZmxleGNh
bjogYWRkIGZzbCwgY2FuLWluZGV4IHByb3BlcnR5DQo+IHRvIGluZGljYXRlIGEgcmVzb3VyY2UN
Cj4gDQo+IE9uIDEwLzE2LzIwIDM6NDMgUE0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBGb3Ig
U29DcyB3aXRoIFNDVSBzdXBwb3J0LCBuZWVkIHNldHVwIHN0b3AgbW9kZSB2aWEgU0NVIGZpcm13
YXJlLCBzbw0KPiA+IHRoaXMgcHJvcGVydHkgY2FuIGhlbHAgaW5kaWNhdGUgYSByZXNvdXJjZS4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54
cC5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvY2FuL2ZzbC1mbGV4Y2FuLnR4dCB8IDUgKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvY2FuL2ZzbC1mbGV4Y2FuLnR4dA0KPiA+IGIvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vZnNsLWZsZXhjYW4udHh0DQo+ID4gaW5kZXgg
NmFmNjdmNWU1ODFjLi44MzljMGMwMDY0YTIgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vZnNsLWZsZXhjYW4udHh0DQo+ID4gKysrIGIv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vZnNsLWZsZXhjYW4udHh0
DQo+ID4gQEAgLTQzLDYgKzQzLDEwIEBAIE9wdGlvbmFsIHByb3BlcnRpZXM6DQo+ID4gIAkJICAw
OiBjbG9jayBzb3VyY2UgMCAob3NjaWxsYXRvciBjbG9jaykNCj4gPiAgCQkgIDE6IGNsb2NrIHNv
dXJjZSAxIChwZXJpcGhlcmFsIGNsb2NrKQ0KPiA+DQo+ID4gKy0gZnNsLGNhbi1pbmRleDogVGhl
IGluZGV4IG9mIENBTiBpbnN0YW5jZS4NCj4gPiArICAgICAgICAgICAgICAgICBGb3IgU29DcyB3
aXRoIFNDVSBzdXBwb3J0LCBuZWVkIHNldHVwIHN0b3AgbW9kZSB2aWENCj4gU0NVIGZpcm13YXJl
LA0KPiA+ICsgICAgICAgICAgICAgICAgIHNvIHRoaXMgcHJvcGVydHkgY2FuIGhlbHAgaW5kaWNh
dGUgYSByZXNvdXJjZS4NCj4gDQo+IFRoaXMgcHJvcGVydHkgaXMgbm90IENBTiBzcGVjaWZpYy4g
U28gdGhlIG5hbWUgY291bGQgYmUgbW9yZSBnZW5lcmFsLg0KDQpIb3cgYWJvdXQgImZzbCxpbmRl
eCI/DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiA+ICsNCj4gPiAgLSB3YWtldXAt
c291cmNlOiBlbmFibGUgQ0FOIHJlbW90ZSB3YWtldXANCj4gPg0KPiA+ICBFeGFtcGxlOg0KPiA+
IEBAIC01NCw0ICs1OCw1IEBAIEV4YW1wbGU6DQo+ID4gIAkJaW50ZXJydXB0LXBhcmVudCA9IDwm
bXBpYz47DQo+ID4gIAkJY2xvY2stZnJlcXVlbmN5ID0gPDIwMDAwMDAwMD47IC8vIGZpbGxlZCBp
biBieSBib290bG9hZGVyDQo+ID4gIAkJZnNsLGNsay1zb3VyY2UgPSAvYml0cy8gOCA8MD47IC8v
IHNlbGVjdCBjbG9jayBzb3VyY2UgMCBmb3IgUEUNCj4gPiArCQlmc2wsY2FuLWluZGV4ID0gL2Jp
dHMvIDggPDE+OyAvLyB0aGUgc2Vjb25kIENBTiBpbnN0YW5jZQ0KPiA+ICAJfTsNCj4gPg0KPiAN
Cj4gTWFyYw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBN
YXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAg
ICAgICAgICB8IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2Vz
dC9Eb3J0bXVuZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10
c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1
NTUgfA0KDQo=
