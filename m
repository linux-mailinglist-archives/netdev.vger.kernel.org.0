Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED92B1BF2
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKMNfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 08:35:41 -0500
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:53984
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgKMNfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 08:35:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTh3DSK/vOG44eObHUmrlgQ7Ooi5ap0Qf8P3nZE68RRk9ESekLszAuvCYMvSTjf9Sa8poHVrBTPHQNOX2TOXyjxvXMd/woDgrywVPEyCJNCrDqej+asyMRP8CzifnGo/DQ2couvYqJN0wIGxXiIZaugmAUJMsx/xeGLmMvea31C8y1D+Wk6ydKf5Eadvqu+jPrSRfzAp1WcY1Usj78yrClw0sGMuPedZZq7wwN4hQ3a5rZXeqPNLiEFCfNYNjuMcDTRXfc7cmQquky7k0x02aDq8LZ+Ma2HnxFHqMmbk4FUaHVxyG0UL/JS2N0LEj9ApW/nbpjhvspWPCA35oVEiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DVu+yx1mH8K8G194xW9cKgEhO6LC298FvJ8Y8QMi1U=;
 b=TM5T/26jjPJPtRV3jTemc/897Swag+4U5SM6WbssISxFslYBtPSuu1VTpabW3RHkmPjzd12tIcz7mXwBxs2sRd5sXQL9oawr9nOk5ROlWLMvGHYvPEE967VwbuBMFzRXKzIazyWiasdFAzaaXuRlm3+0I8mP9Uq7WE+LFuFY4RmDS7xQ9yHmXT+CFdyMeAJkmaSndZ8aCjQw00rTFq3mnDUmpeZogFaeWrZpqO2MFqi6oF+MuZeDUzoYGbnediZXP2vUsYNhEYdYrJLNeWsZOgEcwzsSBEuSmvwF5b+9TgaWMixxIUo+tE+/7eBj77/rlFjK0A/+0LdDrmgLNVG/Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DVu+yx1mH8K8G194xW9cKgEhO6LC298FvJ8Y8QMi1U=;
 b=KsSQNHm3gNQUNwEa11sC+UkOOBjTlY4QlKTmuCUMkIrODlmcTChUb5po/23aKqCRLj3IH2ZG7V8uIwScZzQANiHUrSpGM7ui0sSKZS9iEuDtnqW6uuK3HmY0UEM8Th44xcTLczWE3MIwm6wVZZl5p45kM1I2Z4N2G942EAMgXHE=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2653.eurprd04.prod.outlook.com (2603:10a6:800:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Fri, 13 Nov
 2020 13:35:33 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 13:35:33 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/7] dpaa_eth: add basic XDP support
Thread-Topic: [PATCH net-next 2/7] dpaa_eth: add basic XDP support
Thread-Index: AQHWuR8Z+S8gc1yIzE6WLBLz0bJHZqnE9n6AgAEZqnA=
Date:   Fri, 13 Nov 2020 13:35:33 +0000
Message-ID: <VI1PR04MB5807D435060C57A6F12A4493F2E60@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
         <7389fa62d9e311236f2e39c5d5d153cabc59949d.1605181416.git.camelia.groza@nxp.com>
 <8a8e5afd2502a57c9a86f64b30066a467afb3c2f.camel@kernel.org>
In-Reply-To: <8a8e5afd2502a57c9a86f64b30066a467afb3c2f.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4e1484a-8c18-49ad-f76a-08d887d8ff42
x-ms-traffictypediagnostic: VI1PR0401MB2653:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2653707C4624B28DD765223CF2E60@VI1PR0401MB2653.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TonMHA8K6DWIqMok8Zc4x6yDOW3Ldmt1MAITX0jtG9VA/NsD9h793nvVl9fYWpQnOz6n6/1u6AQO7DTBD16MU09TTCNMskOEyrCvY10ucxoypXR9D0I8Ib+u2CKk4yEaURQ9PoDiiC6Q/ZzqMm80RZZ7kBSQkWjD60qd0KhTSnfdGx/03QWREjY1wpscBNf4rn5zH8aPiMUlH1+O2ig5ct1irPxisjMRdbDdHahasalZjLztAg3XJpAM9FMImy6okIBIMVYAaqiuazxMzfIZu2RfdsczMfYdoyQC425GMhm1mGEwtRBF2aagR1yesE0846L2UA6SHCtaM4D3BzAEJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(64756008)(26005)(9686003)(4326008)(5660300002)(55016002)(186003)(33656002)(66946007)(6506007)(53546011)(7696005)(76116006)(66476007)(66556008)(66446008)(83380400001)(52536014)(71200400001)(8936002)(8676002)(2906002)(54906003)(4001150100001)(316002)(86362001)(478600001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P9qqUX+QgbfBDLCMS6m2XvKhXhn7KubYoH3S+WlyOUQ+9ObLCW1PgzQRcXqW5mDExyO3QQ6XtjlWFr6v52QED25AadCiKtGdHJnQ0F6eWBJkNLnedcR7KYlEYwkDsghBx2wuFEvUggdQ4fvOuGQokNahlRdEonpx7EE5Sre1EQMm0pz5onQb6fn7fMLAN6+0sCz9Lz1zjK4WLammRczvkxQbEzGvR/9NQwT+gCQ7SDKSH9Pgq8BtM7ANwhqb/yWeGDgLhX78dPjJfbrtqfgUgZXofPBKSvJ+6Jc9LOJ9de0n85ILSjfIctW2OEX1p9OEo9jgmJ7ZiSJasjdSplPWdbKR0aA4KlMKpgw0HjjujAg5qw+JxwV4qR5gsqFjMs1E/DSMnBc6LrxkMNrLfELt1LlkTUhz2Uytq25xqv5BmT3fCPg1kKhwy+hd/npsTmL3ifm8jynOzUDzdOqniGygY4BIewnI9rtwD3vQ2OpJmtx+dypBODMv9Um01KYB+mFUqdZk4IdXy68QnuKNVcbHHVOlxkzY0fJJEEv2WC2lN2YOWjg5cRZDqjy669NPSl9GZVvqdZpU5xazLHvx/gpQ/kGRCwMwbukNSCG3ITeg0Z4oss8I5hqKlbhARh0GdV3wawheHnKhZjOU2AGiqlPWYOa2UnwizZY+ZVE7ywALMbf7a/yAGheLFzgcpmLFeeHIUlUPRALIL9Pw6qJPt/MMJ8bFmTjenvQw7Fa3McrfN7GxEzOnSMALKc4X9OykXrSN900KHVDBBOy/PwhqeARl/z9hnSt5AnKubcPyYFbJ3SaKWb+QjY5faAn579xsV2LY7hAAvN+jJ34yj8RhM7Ripc4XQo2WWSZtkMzQGZCiDytv/lLC2+KQwE8HsCaAldJpQnC6WHwo+XysgpFpiDPzyQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e1484a-8c18-49ad-f76a-08d887d8ff42
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 13:35:33.7410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0K0vhq8+dxBChVOWb28N/fYZv3YpKsJgk/E9lQNNy+sTHUOxoQv8fg0DStbKIeG/w3pWeBYAkFScw7VD1kQPEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDEyLCAyMDIwIDIyOjQz
DQo+IFRvOiBDYW1lbGlhIEFsZXhhbmRyYSBHcm96YSA8Y2FtZWxpYS5ncm96YUBueHAuY29tPjsg
a3ViYUBrZXJuZWwub3JnOw0KPiBicm91ZXJAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dA0KPiBDYzogTWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT47
IElvYW5hIENpb3JuZWkNCj4gPGlvYW5hLmNpb3JuZWlAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzddIGRwYWFfZXRoOiBh
ZGQgYmFzaWMgWERQIHN1cHBvcnQNCj4gDQo+IE9uIFRodSwgMjAyMC0xMS0xMiBhdCAyMDoxMCAr
MDIwMCwgQ2FtZWxpYSBHcm96YSB3cm90ZToNCj4gPiArICAgICAgIGlmIChsaWtlbHkoZmRfZm9y
bWF0ID09IHFtX2ZkX2NvbnRpZykpIHsNCj4gPg0KPiA+ICsgICAgICAgICAgICAgICB4ZHBfYWN0
ID0gZHBhYV9ydW5feGRwKHByaXYsIChzdHJ1Y3QgcW1fZmQgKilmZCwNCj4gPiB2YWRkciwNCj4g
Pg0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZ4ZHBfbWV0YV9s
ZW4pOw0KPiA+DQo+ID4gKyAgICAgICAgICAgICAgIGlmICh4ZHBfYWN0ICE9IFhEUF9QQVNTKSB7
DQo+ID4NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBwZXJjcHVfc3RhdHMtPnJ4X3BhY2tl
dHMrKzsNCj4gPg0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHBlcmNwdV9zdGF0cy0+cnhf
Ynl0ZXMgKz0NCj4gPiBxbV9mZF9nZXRfbGVuZ3RoKGZkKTsNCj4gPg0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiBxbWFuX2NiX2RxcnJfY29uc3VtZTsNCj4gPg0KPiA+ICsgICAg
ICAgICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgc2tiID0gY29udGlnX2ZkX3Rv
X3NrYihwcml2LCBmZCk7DQo+ID4NCj4gPiAtICAgICAgIGVsc2UNCj4gPg0KPiA+ICsgICAgICAg
fSBlbHNlIHsNCj4gPg0KPiA+ICsgICAgICAgICAgICAgICBXQVJOX09OQ0UocHJpdi0+eGRwX3By
b2csICJTL0cgZnJhbWVzIG5vdCBzdXBwb3J0ZWQNCj4gPiB1bmRlciBYRFBcbiIpOw0KPiA+DQo+
IA0KPiBXaHkgZG8geW91IGV2ZW4gYWxsb3cgeGRwX3NldHVwKCkgaWYgUy9HIGlzIGNvbmZpZ3Vy
ZWQgPw0KPiBqdXN0IGJsb2NrIHRoaXMgb24geGRwX3NldHVwKCkgb3Igb24gUy9HIHNldHVwIG9u
IGRldmljZSBvcGVuKCkNCg0KV2UgZG9uJ3QgaGF2ZSBhIFMvRyBvbi9vZmYgc3dpdGNoLiBUaGUg
Uy9HIHN1cHBvcnQgaXMgYSBjb25zZXF1ZW5jZSBvZiB0aGUgcmF0aW9uIGJldHdlZW4gdGhlIGJ1
ZmZlciBzaXplIGFuZCB0aGUgaGFyZHdhcmUncyBtYXhpbXVtIGZyYW1lIHNpemUsIHRoZSBsYXR0
ZXIgYmVpbmcgY29uZmlndXJlZCBhdCBwcm9iZS4NCg0KPiA+ICAgICAgICAgICAgICAgICBza2Ig
PSBzZ19mZF90b19za2IocHJpdiwgZmQpOw0KPiA+DQo+ID4gKyAgICAgICB9DQoNCg==
