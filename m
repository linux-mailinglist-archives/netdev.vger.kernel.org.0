Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38414D0632
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfJIEBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:01:51 -0400
Received: from mail-eopbgr760045.outbound.protection.outlook.com ([40.107.76.45]:6185
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726634AbfJIEBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 00:01:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xz9BOPl6Ew177J9PQnLn8hyH7R3x8gbb9TSBTkLiXoPn1b0YOfve5C8RxAFBTcwXkOVVrk7AiMxs6lafeyG+AoeTrdXGLnIqH0xwjgCBIrTHhtfrelvwm/2rfVoyORQxwoPJiPPIm8wogQ5w5b2uien9QcfeizKBN+Vf9idlbGs3/XBGmAuptkd/raraKX5AcPx4FCOolDjOHo1GakUj11tuMkUU7d+xcQcYmkrTNoBSHIlwvIWOHewYiwo05FNGYVRHqr2ikd5xpEP5++GNnR44iwBfcHz8Og0672CUQSr92cIHPp9sWuKPlC0rpTlABSTmNELTTioiFhy2LNXb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly8G9LcrcvsETdjgjuFC5NZAcfqXX/l7tuhYYBMFK5s=;
 b=CmOMpWhP2QYAIVXXPsY0aLP79VcMhjehqI9fkFwiDXwA7TEl7RauF1uPX+mnSz9ULR/qs4OyAUO+814uF/HZSk+ZZSqZfyP8oPU6c6weYN15pnmBsc2TPnnPxFJOLKHp8CpTktJP6XQI/maB654Vvn+h4AaWvgcbkxssB6F3fub41aH6ybluYdOibuXSAEsoybqlm8RqgognVr6Logexcv92Xwq1Y62DenfxBcsVG2O1cSxHz1Rg9dm9Hp3xp2WpVaQSRrrJki+L8om5vMonXm+4lC1VCVAekDlS3dG1lOVXgXpqZ8GUriOo+yUvSJ2CVBHpzkqjLdLxeX7MZ49DIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly8G9LcrcvsETdjgjuFC5NZAcfqXX/l7tuhYYBMFK5s=;
 b=EKnmGtZ0FILycPL4gQmBVBWeaaP1t+WSsH2vV38kCJ/cE8StFp6LCDQo+QDJuiu8E8gvCsrP8T47FiDPHbVqp9mSjtwyWVwhbq3SC4/w887Es90e9eQCyIf/rCxQarcdEu5gFtc/OGynH5HThXgz8FoMaBehRN2iVlfYWpmlSuc=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.173.155) by
 MN2PR02MB6237.namprd02.prod.outlook.com (52.132.175.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Wed, 9 Oct 2019 04:01:47 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::2490:5890:f2e7:14b3]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::2490:5890:f2e7:14b3%7]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 04:01:46 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Anssi Hannula <anssi.hannula@bitwise.fi>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: RE: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
Thread-Topic: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
Thread-Index: AQHVesCfvo8HLFt+ZUeAzSH0lYp+g6dRtjlA
Date:   Wed, 9 Oct 2019 04:01:46 +0000
Message-ID: <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
 <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
In-Reply-To: <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f817d37c-2925-4ae3-d3b8-08d74c6d678d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR02MB6237:|MN2PR02MB6237:
x-ms-exchange-purlcount: 1
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6237CCE23E1B30DDF6C19AD0DC950@MN2PR02MB6237.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(316002)(33656002)(3846002)(25786009)(99286004)(66476007)(64756008)(71200400001)(66066001)(66556008)(71190400001)(66446008)(14454004)(76176011)(66946007)(6916009)(7696005)(478600001)(256004)(186003)(9686003)(54906003)(966005)(6116002)(486006)(305945005)(74316002)(2906002)(26005)(6306002)(6436002)(55016002)(229853002)(8936002)(8676002)(5660300002)(11346002)(476003)(7736002)(446003)(86362001)(52536014)(6506007)(81156014)(102836004)(4326008)(6246003)(81166006)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6237;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tdet2NC6j08bD+Ac/zD69NxVPx8IqaOLGYRtifzcbihgiS7znq4vc+6i3A2+K1rZr3Zdy9lbAblMeNS2dJrrh3NxQWeR1ZkSrbh07qAME5iXLTSYVxbnZLzBengxDnSAwp5LR1yjtV/iEPX4HMz35L5iSVASrNMx1Pmd41NrkoGWsWQSOjA50bKIUst+7j9edjW/5v1KjZmU9VPWtR17mnWsPcAIoxa78f8ChFIarUNt0Bgby8S7vQmg5ONHngdTgKY2js3GKy8AkIOFSXI5j2MJHr8RQQCDZ3VXwXNL9VSumY6MxNkoSnq24jTQgT6eG05nGIUQ0MKCUjeMLIV3/klzfCWo+hHjTyTN5IFvsNlQQa9Xkh/VWChjXVR/SRyR4PO0d8w9L7WCHsCFBwTNOsw4eBNWtZ5trSCWurNLBF9K3bGKQTf83pQLJhIot4oWyLPeLuNaDYuxh0DVuwHC4A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f817d37c-2925-4ae3-d3b8-08d74c6d678d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 04:01:46.6080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKLUxWvQmXHFpP/HCAaqg+lGtMUYnKmvsBQXpX5MY3mvAOUGBDjXSdcRCWlv2OJQ3rLFpP5ZhpYpEmYQagG1Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCjxTbmlwPg0KPiBPbiAxOC4zLjIwMTkgMTMuMzIsIEFwcGFuYSBEdXJnYSBLZWRhcmVz
d2FyYSByYW8gd3JvdGU6DQo+ID4gQVhJIENBTiBJUCBhbmQgQ0FOUFMgSVAgc3VwcG9ydHMgdHgg
ZmlmbyBlbXB0eSBmZWF0dXJlLCB0aGlzIHBhdGNoDQo+ID4gdXBkYXRlcyB0aGUgZmxhZ3MgZmll
bGQgZm9yIHRoZSBzYW1lLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQXBwYW5hIER1cmdhIEtl
ZGFyZXN3YXJhIHJhbw0KPiA+IDxhcHBhbmEuZHVyZ2EucmFvQHhpbGlueC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi94aWxpbnhfY2FuLmMgfCAyICsrDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9jYW4veGlsaW54X2Nhbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9jYW4veGlsaW54X2Nhbi5jIGlu
ZGV4IDJkZTUxYWMuLjIyNTY5ZWYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3hp
bGlueF9jYW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi94aWxpbnhfY2FuLmMNCj4gPiBA
QCAtMTQyOCw2ICsxNDI4LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZfcG1fb3BzIHhjYW5f
ZGV2X3BtX29wcw0KPiA9DQo+ID4geyAgfTsNCj4gPg0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0
IHhjYW5fZGV2dHlwZV9kYXRhIHhjYW5fenlucV9kYXRhID0gew0KPiA+ICsJLmZsYWdzID0gWENB
Tl9GTEFHX1RYRkVNUCwNCj4gPiAgCS5iaXR0aW1pbmdfY29uc3QgPSAmeGNhbl9iaXR0aW1pbmdf
Y29uc3QsDQo+ID4gIAkuYnRyX3RzMl9zaGlmdCA9IFhDQU5fQlRSX1RTMl9TSElGVCwNCj4gPiAg
CS5idHJfc2p3X3NoaWZ0ID0gWENBTl9CVFJfU0pXX1NISUZULA0KPiANCj4gVGhhbmtzIGZvciBj
YXRjaGluZyB0aGlzLCB0aGlzIGxpbmUgc2VlbWVkIHRvIGhhdmUgYmVlbiBpbmNvcnJlY3RseSBy
ZW1vdmVkIGJ5DQo+IG15IDllNWYxYjI3M2UgKCJjYW46IHhpbGlueF9jYW46IGFkZCBzdXBwb3J0
IGZvciBYaWxpbnggQ0FOIEZEIGNvcmUiKS4NCj4gDQo+IEJ1dDoNCj4gDQo+ID4gQEAgLTE0MzUs
NiArMTQzNiw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgeGNhbl9kZXZ0eXBlX2RhdGENCj4gPiB4
Y2FuX3p5bnFfZGF0YSA9IHsgIH07DQo+ID4NCj4gPiAgc3RhdGljIGNvbnN0IHN0cnVjdCB4Y2Fu
X2RldnR5cGVfZGF0YSB4Y2FuX2F4aV9kYXRhID0gew0KPiA+ICsJLmZsYWdzID0gWENBTl9GTEFH
X1RYRkVNUCwNCj4gPiAgCS5iaXR0aW1pbmdfY29uc3QgPSAmeGNhbl9iaXR0aW1pbmdfY29uc3Qs
DQo+ID4gIAkuYnRyX3RzMl9zaGlmdCA9IFhDQU5fQlRSX1RTMl9TSElGVCwNCj4gPiAgCS5idHJf
c2p3X3NoaWZ0ID0gWENBTl9CVFJfU0pXX1NISUZULA0KPiANCj4gDQo+IEFyZSB5b3Ugc3VyZSB0
aGlzIGlzIHJpZ2h0Pw0KPiBJbiB0aGUgZG9jdW1lbnRhdGlvbiBbMV0gdGhlcmUgZG9lcyBub3Qg
c2VlbSB0byBiZSBhbnkgVFhGRU1QIGludGVycnVwdCwgaXQNCj4gd291bGQgYmUgaW50ZXJydXB0
IGJpdCAxNCBidXQgQVhJIENBTiA1LjAgc2VlbXMgdG8gb25seSBnbyB1cCB0byAxMS4NCj4gDQo+
IE9yIG1heWJlIGl0IGlzIHVuZG9jdW1lbnRlZCBvciB0aGVyZSBpcyBhIG5ld2VyIHZlcnNpb24g
c29tZXdoZXJlPw0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5IGluIHRoZSByZXBseS4gDQpBZ3JlZSBU
WEZFTVAgaW50ZXJydXB0IGZlYXR1cmUgaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgU29mdCBJUCBD
QU4uDQpTaW5jZSB0aGlzIHBhdGNoIGFscmVhZHkgZ290IGFwcGxpZWQgd2lsbCBzZW5kIGEgc2Vw
YXJhdGUgcGF0Y2ggdG8gZml4IHRoaXMuDQoNClJlZ2FyZHMsDQpLZWRhci4NCg0KPiANCj4gWzFd
DQo+IGh0dHBzOi8vd3d3LnhpbGlueC5jb20vc3VwcG9ydC9kb2N1bWVudGF0aW9uL2lwX2RvY3Vt
ZW50YXRpb24vY2FuL3Y1XzANCj4gL3BnMDk2LWNhbi5wZGYNCj4gDQo+IC0tDQo+IEFuc3NpIEhh
bm51bGEgLyBCaXR3aXNlIE95DQo+ICszNTggNTAzODAzOTk3DQoNCg==
