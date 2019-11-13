Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B7FA93A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKMEzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:55:18 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:43129
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727196AbfKMEzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 23:55:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9YoRDKAcyy06bEmPIIqj0hg0nTxG1zqxbGzerMvE/or8X4r2zgcwt1aVd9QLdTCS2vTO8to8VlNs4tm1F+oQKvZYfQwC8MqB0CTJstwgkoEWtAxskoHhlHjduss1gwWgCJ0Mzpqr93npHDk3fUcCGRfP1JcFDH/Bs4u4eTgqrXYSRIukVFfcJ1mh+gGd74HSw/iYyC58js/sSLQtjHmrNmDK9rm01qyykw22Qz/9QZTs/on/RDD0XEnsGHk4zAJmWRDeM8sXgnkCt9kP+z7YBZO/HE8A7zDvXfdYda672ofiPzY6zVSTJvtDfYKLbug13LLTalo+Ljbs7svC+H/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vyudf+/X0+cJqhx1P2iGw62ODD2EIgmVldy95EwtcYc=;
 b=OYTyEIBRR+rwM1S85viy9MyHd69jZQklwDIgIp9BRmfXH5c04KZNU7ni6ebZz70Yvtzo90QLKS68btKu4cGBShtR/wu3egYcaudqMzp6Ov6kU+Wlky5PnaxMTRo4getRx7bgBq6L9VA1N0Lf5mthTGXjmB5Hax/KOyc/vj95f/Vp9Q+iIa6D5L/lGS32TgegZFrdHo7VucKzigfbZ0EjV14qm+lZUghShKIIXqBE75Piy9/lSTitf5QSA9VfrS5Ds2aydSBIKYalBVECo21enBK7tWO4W2hrqMKRsYqlqAq/ZmyHXtjt2F05Agy0lqdFLB2IUBCBRSWTaGtZVi/H5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vyudf+/X0+cJqhx1P2iGw62ODD2EIgmVldy95EwtcYc=;
 b=azfX+wG3Yn4dD87dHYMxUYfRkox66nbcrx/nl+ju3QdaXYM6fBCXzv4IMUwMMp79aCoAHG/Gd8at7odPEhXzG3D4bCtLk8rMWOQpUTHjvhSQBdan0g+sLamQHhVJ0Ql/uRtSB78tfi0118gCDRCixdA4E5DjR6zoZCALJA8IRE0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6430.eurprd04.prod.outlook.com (20.179.232.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Wed, 13 Nov 2019 04:55:13 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 04:55:13 +0000
From:   Po Liu <po.liu@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Topic: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Thread-Index: AQHVmEpHUNIqbyQIWEm27TZfncKzVKeHSiOAgACbw4CAAAAvAIAApV1A
Date:   Wed, 13 Nov 2019 04:55:12 +0000
Message-ID: <VE1PR04MB649695013989E34998A285ED92760@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
        <20191112094128.mbfil74gfdnkxigh@netronome.com>
        <20191112.105859.2271759135957958056.davem@davemloft.net>
 <20191112.105938.992505074954061727.davem@davemloft.net>
In-Reply-To: <20191112.105938.992505074954061727.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 152935d5-1f38-45bc-55c3-08d767f5ab19
x-ms-traffictypediagnostic: VE1PR04MB6430:|VE1PR04MB6430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64308E9B64AA6FA12F6A53D192760@VE1PR04MB6430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(13464003)(9686003)(446003)(76176011)(14454004)(86362001)(66066001)(81156014)(55016002)(5660300002)(11346002)(110136005)(81166006)(44832011)(186003)(486006)(316002)(6506007)(53546011)(6436002)(26005)(7696005)(71200400001)(71190400001)(2906002)(102836004)(54906003)(8676002)(52536014)(7736002)(25786009)(66476007)(4326008)(66446008)(64756008)(305945005)(66556008)(478600001)(3846002)(6246003)(76116006)(33656002)(66946007)(14444005)(256004)(476003)(99286004)(2501003)(6116002)(74316002)(8936002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6430;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HvV7J2fbytLVbhi65/V+t/3azsAJf2Et93XNOen+jNB7RHnCL8I+ID6Njm4R0cXutMa8h5622nc21v3K5HVwCtevsk5mtoRqs0JcZK4BHyghX9KG2uipAxqMAQSLXEB+E7ID/9ctDelWLIx5HpkvmeBYIbY4Z0a9tRo+LX1svGeQmiOfmPCXyFvo3WIvPXBRGLrkTAXp25yGtHmREv0hq9VzcaRWgbuin+EgkZ48ytqm23SDcY2DTmuXHa10KV2qgqEaYyyfJIizbXB83NPWIdnlrJIo9t1UusC7md63dKywnafsTYJPGJ62qRpzb3H6oQW8oU/y6Nbqp1fdxF7dSOCV1uQEs2lpzvFndJVl0FSGP2S3YdpCEolHHF0Q4SGNNl2A6aqnjNuo7KMVGTBh7kZ7JAVlDUQXirFAga8kaJjfSDp8f2kxdI0DCFjvLIdY
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152935d5-1f38-45bc-55c3-08d767f5ab19
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 04:55:12.9758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gu916M8e4l3O1hr4CedXWIWjHAM8JxX0lBcFGas692CSVNfYUV0CY7NW+W4Z+K2m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNClRoYW5rcyENCkJyLA0KUG8gTGl1DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBT
ZW50OiAyMDE55bm0MTHmnIgxM+aXpSAzOjAwDQo+IFRvOiBzaW1vbi5ob3JtYW5AbmV0cm9ub21l
LmNvbQ0KPiBDYzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT47IENsYXVkaXUgTWFub2lsIDxjbGF1
ZGl1Lm1hbm9pbEBueHAuY29tPjsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyBWbGFkaW1p
ciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4gQWxleGFuZHJ1IE1hcmdpbmVh
biA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgWGlhb2xpYW5nIFlhbmcNCj4gPHhpYW9s
aWFuZy55YW5nXzFAbnhwLmNvbT47IFJveSBaYW5nIDxyb3kuemFuZ0BueHAuY29tPjsgTWluZ2th
aSBIdQ0KPiA8bWluZ2thaS5odUBueHAuY29tPjsgSmVycnkgSHVhbmcgPGplcnJ5Lmh1YW5nQG54
cC5jb20+OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhwLmNvbT4NCj4gU3ViamVjdDogW0VYVF0g
UmU6IFtuZXQtbmV4dCwgMS8yXSBlbmV0YzogQ29uZmlndXJlIHRoZSBUaW1lLUF3YXJlIFNjaGVk
dWxlciB2aWENCj4gdGMtdGFwcmlvIG9mZmxvYWQNCj4gDQo+IENhdXRpb246IEVYVCBFbWFpbA0K
PiANCj4gRnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBEYXRlOiBU
dWUsIDEyIE5vdiAyMDE5IDEwOjU4OjU5IC0wODAwIChQU1QpDQo+IA0KPiA+DQo+ID4gT29wcywg
SSBkaWRuJ3Qgc2VlIHRoaXMgZmVlZGJhY2sgYmVjYXVzZSB2MiBoYWQgYmVlbiBwb3N0ZWQuDQo+
ID4NCj4gPiBJJ2xsIHJldmVydCB0aGF0IG5vdy4NCj4gPg0KPiA+IFBsZWFzZSBhZGRyZXNzIFNp
bW9uJ3MgZmVlZGJhY2sgb24gdGhlc2UgdHdvIHBhdGNoZXMsIGFuZCB0aGVuIHBvc3QgYQ0KPiA+
IHYzLCB0aGFuayB5b3UuDQo+IA0KPiBBbHNvLCB2MiBkb2Vzbid0IGV2ZW4gY29tcGlsZSA6LSgN
Cj4gDQo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZW5ldGMvZW5ldGMuaDoxNCwNCj4gICAgICAgICAgICAgICAgICBmcm9tIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19xb3MuYzo0Og0KPiBkcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcW9zLmM6IEluIGZ1bmN0aW9uDQo+IMq9ZW5l
dGNfc2V0dXBfdGNfdGFwcmlvyrw6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9l
bmV0Yy9lbmV0Y19ody5oOjMwODozMjogd2FybmluZzogyr10ZW1wyrwgbWF5DQo+IGJlIHVzZWQg
dW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdICAj
ZGVmaW5lDQo+IGVuZXRjX3dyX3JlZyhyZWcsIHZhbCkgaW93cml0ZTMyKCh2YWwpLCAocmVnKSkN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn4NCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3Fvcy5jOjU5OjY6IG5vdGU6IMq9dGVt
cMq8IHdhcw0KPiBkZWNsYXJlZCBoZXJlDQoNCk1vcmUgZGVsZXRlIG9uZSBsaW5lLiBXaWxsIGZp
eCBpbiB2My4NCg0KPiAgIHUzMiB0ZW1wOw0KPiAgICAgICBefn5+DQo+IEVSUk9SOiAiZW5ldGNf
c2NoZWRfc3BlZWRfc2V0IiBbZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2Zz
bC0NCj4gZW5ldGMtdmYua29dIHVuZGVmaW5lZCENCj4gRVJST1I6ICJlbmV0Y19zZXR1cF90Y190
YXByaW8iIFtkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZnNsLQ0KPiBlbmV0
Yy12Zi5rb10gdW5kZWZpbmVkIQ0KPiBtYWtlWzFdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUubW9k
cG9zdDo5NDogX19tb2Rwb3N0XSBFcnJvciAxDQo+IG1ha2U6ICoqKiBbTWFrZWZpbGU6MTI4Mjog
bW9kdWxlc10gRXJyb3IgMg0KDQpJIGdvdCB0aGlzIHNpdHVhdGlvbi4gDQpJdCBoYXBwZW5lZCB3
aGVuIHNldCBtb2R1bGUgbW9kZSwgc2luY2UgdmYgZHJ2aWVyIHNob3VsZCBub3Qgb3duIHRoZSB0
YXByaW8gc2V0Lg0KVGhhbmtzIQ0K
