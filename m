Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104BA29BDBA
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812907AbgJ0Qqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:46:42 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:49889
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1794967AbgJ0POj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baafztqt2qFcEKPRQjaW5toD82EYl4qu5Ww04rXXdaWppyVUv+N6PMMXclJ2SlRYm46Tv+9vijXxmy4H/zefnpOeafocCfiJpLpl/+49dCXn3E9ginc1p3RynV+e9pxhOz+RuJkqpQZofxkEw/AND2+yJ3Ay5iQCBAMNT6IYHLL+uTExOT6CZGFGJZhQIW9P12sGtLOegXQTzRKcNusxCSqsUZxA5iePR0VvMZ8dfG8rp1X6kRQMBft1F0Yz0TP1SbCrmop/Mb1E2woWDWpaf7b8KRd1LAv6uyFSpJzo1/20SjGOJhhKQYiznksJ+OOXUC3Mjiv5e64+VsvH+ziFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJt1Opg8UC4yFGvnF57lYhweFhPsBYuRe8Y+LtId190=;
 b=l4ne1PpGht0RqdQ9s4aUDxBbcJdgBsrQO/8wqK0Oz90LqihiunxKAkFnbxVI9QZBK6aDhkGK6YJNhbelSH4p03Se+o53yR9H8kvEdSVakTa+SrT+trdcKhTMmb/9l0l7h7sHY+ne9rWQJwswlk1i6BInErXZlw9BGwvsTUdFWYazj51wNqvrL3WY8LHLqFKBCkxaYefSNzMQ/NL/TYy9A+38KhqDarmEp5WNwuxjfd39PgLjA8lUPzvZj+fiaPYpw8hWlZJDkI8N8V+ygkcxkoKXyWKlkRQ71r7/8SRIn69dcsf/EVFCrxrItyY1UXFPLhFce0VYy/DLNFewLV3Q+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJt1Opg8UC4yFGvnF57lYhweFhPsBYuRe8Y+LtId190=;
 b=pszgZQi+IPsDqzeZh+1g52ZU490t3QILtigoxcBNxcvlMSwCGC2Hz/SbeBG4N4QSc5TlsHJMRiol9s51J2L4/d9meEnQV+C4NhmTyWe9G6e17OCNGh4Op+wv05G+L21FM8eKyZe4wH+y86KCsYWxFXDQHI2z7Wz87eKxQMReMqc=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BYAPR02MB3927.namprd02.prod.outlook.com (2603:10b6:a02:f3::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 15:14:36 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::65d9:9ba5:d17:35db]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::65d9:9ba5:d17:35db%7]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 15:14:36 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY for
 1000BaseX mode
Thread-Topic: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Thread-Index: AQHWq8E+sKa6qx9r90iNR/QS92jA7KmqOwzggAAOXgCAATYucIAADrYAgAAAVtA=
Date:   Tue, 27 Oct 2020 15:14:36 +0000
Message-ID: <BYAPR02MB563874C09FB39147008C236CC7160@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <20201026175535.1332222-1-robert.hancock@calian.com>
         <BYAPR02MB56382BA3CB100008FC02B02BC7190@BYAPR02MB5638.namprd02.prod.outlook.com>
         <afbabf3c247d311e18701b301d32b49919b34017.camel@calian.com>
         <BYAPR02MB5638BE069270D40A3930A4C7C7160@BYAPR02MB5638.namprd02.prod.outlook.com>
 <2375491642cc056d04c2c43fc4d90b8184d86ce1.camel@calian.com>
In-Reply-To: <2375491642cc056d04c2c43fc4d90b8184d86ce1.camel@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: calian.com; dkim=none (message not signed)
 header.d=none;calian.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.50.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b86bdacb-d5ab-4ebf-7dd0-08d87a8b0469
x-ms-traffictypediagnostic: BYAPR02MB3927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB39277A20D402C513A5737875C7160@BYAPR02MB3927.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fBazAgII63cNRxyqriUSuDGONCJ6ICk6DPgNwK1sgSJ+f7Xj6x3bNcENioQ/yUqpkhvdzp7u8WtWWvKPKi0ycwbCHCCfdhI8nSEsFi768nFHKbhgxWb/HhH5iJqXyE4tXfRhi/LRGHjJbd61FT2VjyE9gjxii+gX8IxraaJJMRCElwiqUCkVP8p+GLDoJfT7A2O1fS+G8QB6CbCfyFM0csczsUpIGqYeJhkNVdNhnL4xMdQ5JNL59itOMFWvtsewmFyMEKaAxL3DmDPdCmv+xNoE/HIWV60VYOXvZeicF8VsSAQ44aaO0r3s63Vac+F0Qj+sBlsetryTCJW904D1OjqABqU5jBpPkbCzjoE5NLVi0pg3Vy7IL7m0lAqwksJPWBGi+i3Oy4NxtO6M3fSMN/AStJY6dc3zAXoajKi2GevZaBMwWe+5E25LFhJ0PoVLbEFg4edd6mOXMbNmZkVmAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(478600001)(316002)(33656002)(54906003)(66946007)(71200400001)(66446008)(5660300002)(53546011)(186003)(26005)(64756008)(9686003)(8936002)(66556008)(110136005)(66476007)(6506007)(8676002)(83380400001)(52536014)(76116006)(7696005)(15974865002)(4326008)(4001150100001)(86362001)(55016002)(2906002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: T8C6XW5fhzGlUS8WStmmb/p6LyKHJ79E5+GTkU7JtfP0ifM68HqV7mLN65UaHXN0T+I3iDE4/MvyO1t9irRwlMC7tfZdanuPS/EdHTq8/GbyFymRcgOFBbNmCx+9kj++JzNdcU+T1PK3u14mHiafful7fZfDWARQXhIkeCuAAM1jGqPmfvf0iMWT1XEz1wcRHBJ/3sbMQT16SO4DPyzWgoFd5vRKkxKvQaXSbL6dVM5ckscjEdlZA/UaY5lQ7F8z39GupKJ3NSIGFgH/Bj7wc5aHxzfuK3Lrii+GwJVEMstd+6S98E9Uyh6wmIZHCQfrt+5DlEpdCTzHPk7Q+wanvE46z8OIzqGfE/Z5wgtMdFi5z8kZQdERRQYDnJ1jgDbVpBWAzK9C71g/XNxB6I4yJSIZIw3X2l7cx2UB9/4FYhmK678sCnVxxa6YjZM4WBLpmL7YgWTjKPVRHv1bw/wzs7ndHJPv12rvZe647oJpEk5j0YlDtIVer29VGoSvl/vTQ1o00G+MBSEIkJF7jqGajFRTmsRnSv/Bz9EQ9mDpqp18nvXdgGoBFFoXgYepA8vozu+LSPRdqHbSsJlyTnq2Dp+wPAD+4NhrsnAclh6N37UVH3wlQJPUfSp0mr8gxYNfOpXFapF/Ffo0dEwJBdbUlQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b86bdacb-d5ab-4ebf-7dd0-08d87a8b0469
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 15:14:36.5210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dg41wgzEb1d61FUbCGbMulzzfdKHwiXlOkjM4lTuSLtIpUq77V1INB0Eou30lpVYhn6GtGPnToAuVpiKoE44RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB3927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2JlcnQgSGFuY29jayA8cm9i
ZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gU2VudDogVHVlc2RheSwgT2N0b2JlciAyNywgMjAy
MCA4OjM4IFBNDQo+IFRvOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4QGFy
bWxpbnV4Lm9yZy51azsgTWljaGFsIFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+Ow0KPiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBhbmRyZXdAbHVubi5jaA0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IHYyXSBuZXQ6IGF4aWVuZXQ6IFByb3Blcmx5IGhhbmRsZSBQQ1MvUE1BIFBIWQ0K
PiBmb3IgMTAwMEJhc2VYIG1vZGUNCj4gDQo+IE9uIFR1ZSwgMjAyMC0xMC0yNyBhdCAxNDoyNSAr
MDAwMCwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2Fs
aWFuLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgMjcsIDIwMjAgMToxNSBBTQ0K
PiA+ID4gVG86IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleXNAeGlsaW54LmNvbT47DQo+IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4gPiBrdWJhQGtlcm5lbC5vcmcNCj4gPiA+IENjOiBsaW51
eEBhcm1saW51eC5vcmcudWs7IE1pY2hhbCBTaW1layA8bWljaGFsc0B4aWxpbnguY29tPjsNCj4g
PiA+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFuZHJld0BsdW5uLmNoDQo+ID4gPiBTdWJqZWN0
OiBSZTogW1BBVENIIG5ldC1uZXh0IHYyXSBuZXQ6IGF4aWVuZXQ6IFByb3Blcmx5IGhhbmRsZQ0K
PiA+ID4gUENTL1BNQSBQSFkgZm9yIDEwMDBCYXNlWCBtb2RlDQo+ID4gPg0KPiA+ID4gT24gTW9u
LCAyMDIwLTEwLTI2IGF0IDE4OjU3ICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdyb3RlOg0K
PiA+ID4gPiBUaGFua3MgZm9yIHRoZSBwYXRjaC4NCj4gPiA+ID4NCj4gPiA+ID4gPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiA+IEZyb206IFJvYmVydCBIYW5jb2NrIDxyb2Jl
cnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+ID4gPiA+IFNlbnQ6IE1vbmRheSwgT2N0b2JlciAy
NiwgMjAyMCAxMToyNiBQTQ0KPiA+ID4gPiA+IFRvOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRo
ZXlzQHhpbGlueC5jb20+Ow0KPiA+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+ID4gPiBr
dWJhQGtlcm5lbC5vcmcNCj4gPiA+ID4gPiBDYzogTWljaGFsIFNpbWVrIDxtaWNoYWxzQHhpbGlu
eC5jb20+OyBsaW51eEBhcm1saW51eC5vcmcudWs7DQo+ID4gPiA+ID4gYW5kcmV3QGx1bm4uY2g7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJvYmVydCBIYW5jb2NrDQo+ID4gPiA+ID4gPHJvYmVy
dC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gPiA+ID4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0
IHYyXSBuZXQ6IGF4aWVuZXQ6IFByb3Blcmx5IGhhbmRsZQ0KPiA+ID4gPiA+IFBDUy9QTUEgUEhZ
IGZvciAxMDAwQmFzZVggbW9kZQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVXBkYXRlIHRoZSBheGll
bmV0IGRyaXZlciB0byBwcm9wZXJseSBzdXBwb3J0IHRoZSBYaWxpbnggUENTL1BNQQ0KPiA+ID4g
PiA+IFBIWSBjb21wb25lbnQgd2hpY2ggaXMgdXNlZCBmb3IgMTAwMEJhc2VYIGFuZCBTR01JSSBt
b2RlcywNCj4gPiA+ID4gPiBpbmNsdWRpbmcgcHJvcGVybHkgY29uZmlndXJpbmcgdGhlIGF1dG8t
bmVnb3RpYXRpb24gbW9kZSBvZiB0aGUNCj4gPiA+ID4gPiBQSFkgYW5kIHJlYWRpbmcgdGhlIG5l
Z290aWF0ZWQgc3RhdGUgZnJvbSB0aGUgUEhZLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU2lnbmVk
LW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4g
PiA+ID4gLS0tDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBSZXN1Ym1pdCBvZiB2MiB0YWdnZWQgZm9y
IG5ldC1uZXh0Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3hp
bGlueC94aWxpbnhfYXhpZW5ldC5oICB8ICAzICsNCj4gPiA+ID4gPiAuLi4vbmV0L2V0aGVybmV0
L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCA5Ng0KPiA+ID4gPiA+ICsrKysrKysrKysr
KysrLQ0KPiA+ID4gPiA+IC0tLS0NCj4gPiA+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3MyBpbnNl
cnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaA0KPiA+ID4g
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0LmgNCj4gPiA+
ID4gPiBpbmRleCBmMzRjNzkwM2ZmNTIuLjczMjZhZDRkNWUxYyAxMDA2NDQNCj4gPiA+ID4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaA0KPiA+ID4g
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldC5oDQo+
ID4gPiA+ID4gQEAgLTQxOSw2ICs0MTksOSBAQCBzdHJ1Y3QgYXhpZW5ldF9sb2NhbCB7DQo+ID4g
PiA+ID4gIAlzdHJ1Y3QgcGh5bGluayAqcGh5bGluazsNCj4gPiA+ID4gPiAgCXN0cnVjdCBwaHls
aW5rX2NvbmZpZyBwaHlsaW5rX2NvbmZpZzsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICsJLyogUmVm
ZXJlbmNlIHRvIFBDUy9QTUEgUEhZIGlmIHVzZWQgKi8NCj4gPiA+ID4gPiArCXN0cnVjdCBtZGlv
X2RldmljZSAqcGNzX3BoeTsNCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gIAkvKiBDbG9jayBmb3Ig
QVhJIGJ1cyAqLw0KPiA+ID4gPiA+ICAJc3RydWN0IGNsayAqY2xrOw0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhp
ZW5ldF9tYWluLmMNCj4gPiA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxp
bnhfYXhpZW5ldF9tYWluLmMNCj4gPiA+ID4gPiBpbmRleCA5YWFmZDNlY2RhYTQuLmY0NjU5NWVm
MjgyMiAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngv
eGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+ID4gPiA+IEBAIC0xNTE3LDEwICsx
NTE3LDI5IEBAIHN0YXRpYyB2b2lkIGF4aWVuZXRfdmFsaWRhdGUoc3RydWN0DQo+ID4gPiA+ID4g
cGh5bGlua19jb25maWcgKmNvbmZpZywNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICAJcGh5bGlua19z
ZXQobWFzaywgQXN5bV9QYXVzZSk7DQo+ID4gPiA+ID4gIAlwaHlsaW5rX3NldChtYXNrLCBQYXVz
ZSk7DQo+ID4gPiA+ID4gLQlwaHlsaW5rX3NldChtYXNrLCAxMDAwYmFzZVhfRnVsbCk7DQo+ID4g
PiA+ID4gLQlwaHlsaW5rX3NldChtYXNrLCAxMGJhc2VUX0Z1bGwpOw0KPiA+ID4gPiA+IC0JcGh5
bGlua19zZXQobWFzaywgMTAwYmFzZVRfRnVsbCk7DQo+ID4gPiA+ID4gLQlwaHlsaW5rX3NldCht
YXNrLCAxMDAwYmFzZVRfRnVsbCk7DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICsJc3dpdGNoIChz
dGF0ZS0+aW50ZXJmYWNlKSB7DQo+ID4gPiA+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9O
QToNCj4gPiA+ID4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNFWDoNCj4gPiA+
ID4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJOg0KPiA+ID4gPiA+ICsJY2FzZSBQ
SFlfSU5URVJGQUNFX01PREVfR01JSToNCj4gPiA+ID4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9N
T0RFX1JHTUlJOg0KPiA+ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfSUQ6
DQo+ID4gPiA+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9SWElEOg0KPiA+ID4g
PiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfVFhJRDoNCj4gPiA+ID4gPiArCQlw
aHlsaW5rX3NldChtYXNrLCAxMDAwYmFzZVhfRnVsbCk7DQo+ID4gPiA+ID4gKwkJcGh5bGlua19z
ZXQobWFzaywgMTAwMGJhc2VUX0Z1bGwpOw0KPiA+ID4gPiA+ICsJCWlmIChzdGF0ZS0+aW50ZXJm
YWNlID09DQo+ID4gPiA+ID4gUEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNFWCkNCj4gPiA+ID4g
PiArCQkJYnJlYWs7DQo+ID4gPiA+DQo+ID4gPiA+IDEwMEJhc2VUIGFuZCAxMEJhc2VUIGNhbiBi
ZSBzZXQgaW4gUEhZX0lOVEVSRkFDRV9NT0RFX01JSSBpZiB3ZQ0KPiA+ID4gPiBhbGxvdyBmYWxs
dGhyb3VnaCBoZXJlLg0KPiA+ID4NCj4gPiA+IE5vdCBxdWl0ZSBzdXJlIHdoYXQgeW91IGFyZSBz
YXlpbmcgaGVyZT8NCj4gPg0KPiA+IEkgd2FzIHNheWluZyB0byBhbGxvdyBzd2l0Y2ggY2FzZSBm
YWxsIHRocm91Z2guDQo+IA0KPiBBaCwgSSBzZWUuIFllcywgdGhhdCB3b3VsZCB3b3JrIHRvIHNh
dmUgYSBjb3VwbGUgZHVwbGljYXRlIGxpbmVzIC0ganVzdCBub3Qgc3VyZQ0KPiBpZiB1c2luZyB0
aGUgc3dpdGNoIGZhbGwtdGhyb3VnaCBpcyBwcmVmZXJhYmxlLiBBbnkgdGhvdWdodHMgZnJvbSBw
ZW9wbGUgb24NCg0KUmlnaHQuIEp1c3QgdG8gYWRkIC0gd2UgYXJlIGFscmVhZHkgdXNpbmcgc3dp
dGNoIGZhbGwtdGhyb3VnaC4gU28gcmV1c2luZyBpdA0KbWlnaHQgYmUgb2suDQoNCisJY2FzZSBQ
SFlfSU5URVJGQUNFX01PREVfTkE6DQorCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNF
WDoNCisJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfU0dNSUk6IA0KDQo+IHdoYXQncyBwcmVmZXJy
ZWQ/DQo+IA0KPiAtLQ0KPiBSb2JlcnQgSGFuY29jaw0KPiBTZW5pb3IgSGFyZHdhcmUgRGVzaWdu
ZXIsIEFkdmFuY2VkIFRlY2hub2xvZ2llcyB3d3cuY2FsaWFuLmNvbQ0K
