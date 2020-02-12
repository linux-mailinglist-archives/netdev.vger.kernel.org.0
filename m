Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040CA15A6A0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBLKjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:39:54 -0500
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:53774
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbgBLKjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 05:39:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAEvDI768vfbEfIPrhei/YhvvaPUhh+fzJ45T4fDfwVdcblFOkwwEbTXecJEr+37N4CXO2ZIgHOF90tJhlOt7+6PCTC6Nrc0X8ByupqbNCPGQwGayEQloEusg+vlPji55uFgT4ETvPX04tUVlGxwVAZ32FIQoXsD0A5fTp2Yov1AMYQVbRpAcRPW+LPjpgtbfaqhfDP4kfvbm+Wf3QtM9L/Gt/30RbNpZRgN9DmQO4ynqpEACBk9LPADxuiroALLrlhQxcC2CXqFShic2lwUbI2JWJd/WGJP8Aacd8H0wE/2KL5JjAY9DOwz+WUBob7G5X4sF54AmP5QJ07Ktj3SKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMo9MBQqTOqLb7/pr1BfvF/+8TlLRTvz1hos61pCyFQ=;
 b=HlLvdn1nC2u8XgSTYIGAVv+UlSRP2DBZVNtfib6yjca3BmRTS3/0spvz9vbBGxaS2GKtwAWn4p2JXVV++KEj79dqzMHLsVdt1PMBNfSuw/dph0HEu8ttXbNp9oYMC3JwcnjJKQCXW87FuMoJuB3U5I/2DemmsOa3o45yhQWpYPXH6puNTCsanPJS0VQ14YdVDHSabvaBtc9kFubD05JrwMY8623fvBguNuNC8XGwv3S+jc9FKJxZTvFvCGMlfchaYeh5WPByEIali5q2E582/oBkisOK+HaYhrR/xRELJYZXWoUfjCA2MyAJphUkR7g8FpacdYndjGnLxaKqqifcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMo9MBQqTOqLb7/pr1BfvF/+8TlLRTvz1hos61pCyFQ=;
 b=mnwvj+UUksG822MQLrOyiHgQMBV06bdrNWND4Q+4pi0C2eYtR+9tTACpFXXr1OVldXTZQYB5scPrcJJhNqg71V8O1Pj+cDbqi8YePwyovRIrrdgeMtp/vQiqRcPGxkidLHXO0QY7vQ8Obr1Or/I/GSEYEuXhqzFebyBpp2Ihrjs=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB6936.eurprd04.prod.outlook.com (10.141.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 10:39:11 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064%7]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 10:39:11 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: RE: [PATCH] ptp_qoriq: add initialization message
Thread-Topic: [PATCH] ptp_qoriq: add initialization message
Thread-Index: AQHV4Jcxgewx58wIn0aNZKEUqjecgagWwCiAgACbX4CAAAM0AIAAAK6A
Date:   Wed, 12 Feb 2020 10:39:11 +0000
Message-ID: <AM7PR04MB688559DED451E057CBFE46E5F81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200211045053.8088-1-yangbo.lu@nxp.com>
 <20200211.170635.1835700541257020515.davem@davemloft.net>
 <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <CA+h21hr+dE1owiF-e81psj3uKgCRdeS+C_LbFdd_ta91TS+CUA@mail.gmail.com>
In-Reply-To: <CA+h21hr+dE1owiF-e81psj3uKgCRdeS+C_LbFdd_ta91TS+CUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [223.72.61.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b797affa-d3d7-47aa-2640-08d7afa7cbfa
x-ms-traffictypediagnostic: AM7PR04MB6936:
x-microsoft-antispam-prvs: <AM7PR04MB693656EC24E2DB3B920512DCF81B0@AM7PR04MB6936.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(189003)(199004)(64756008)(66476007)(71200400001)(66446008)(66556008)(52536014)(76116006)(66946007)(2906002)(9686003)(55016002)(53546011)(54906003)(4326008)(26005)(7696005)(33656002)(186003)(86362001)(6506007)(478600001)(316002)(5660300002)(15650500001)(8936002)(6916009)(8676002)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB6936;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o5bVeyXItS96MKiEYC87ILbx0kE0L8zNz9aeeSU0UsxsVp6fJa6Wr4QLAP2ROmT4gDslunpdQbiAk4ujCowlyAy5EDhjjH5WBtGEWLzFV+utEr11wV/4DU3sKUFG2tQzqxcmyXZzu9XvIp37td8KZvQnLIWq/Mo9jCoDZKQdPuIOeSq9LYZmJFHPhd8oN65iRfch1pNJ9mW5BkgjacCr7GVrivk5xQKXOPxLUoBwM+p3HADtKmp+Q0JKN9OYg/kxQwnzV6/nqxy8EQEfADtKFi4yyUMCnLqBQ6ZsdUQAb3k4miNFocjOx97bG7YU43uESov3CJbe2n4jk7QQyTbW+S9Tqq6YpKEVZT+YQtaZqdHM/W29lmFlQ24CQCfurRpDFQc9MYNNZ3oEbIIhAQ0567H/i2Xkwfzxph88DIlRvlExIWmKh1cbwBzq6pcbZypo
x-ms-exchange-antispam-messagedata: R0Vx3H+u40cofvZxRiGOvQsInIBwGKU5OjTtrWjq8qPnrh9XHkXYOO7OduOEBeLIrOHwne4a+XYCFdtH14+T219SXPEdb7Lu8n7wD6jipzwnoyTdYi3P9yFxHVXng0bbXPV9LxzZuiGFOjsMElsD0g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b797affa-d3d7-47aa-2640-08d7afa7cbfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 10:39:11.1388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLXHDS9M6xmkNWQrtJfDLslcyxgFek9DMpPNYmxIYh6KT4QgxgZKgVWvzyhJ/mzIYlinBj1Y9k3D5GbBoKi2nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6936
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDEyLCAyMDIwIDY6
MzQgUE0NCj4gVG86IFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPg0KPiBDYzogRGF2aWQgTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gcmlj
aGFyZGNvY2hyYW5AZ21haWwuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHB0cF9xb3JpcTog
YWRkIGluaXRpYWxpemF0aW9uIG1lc3NhZ2UNCj4gDQo+IEhpIFlhbmdibywNCj4gDQo+IE9uIFdl
ZCwgMTIgRmViIDIwMjAgYXQgMTI6MjUsIFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPiB3cm90
ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IG5l
dGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+
IE9uDQo+ID4gPiBCZWhhbGYgT2YgRGF2aWQgTWlsbGVyDQo+ID4gPiBTZW50OiBXZWRuZXNkYXks
IEZlYnJ1YXJ5IDEyLCAyMDIwIDk6MDcgQU0NCj4gPiA+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVA
bnhwLmNvbT4NCj4gPiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyByaWNoYXJkY29jaHJh
bkBnbWFpbC5jb20NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHB0cF9xb3JpcTogYWRkIGlu
aXRpYWxpemF0aW9uIG1lc3NhZ2UNCj4gPiA+DQo+ID4gPiBGcm9tOiBZYW5nYm8gTHUgPHlhbmdi
by5sdUBueHAuY29tPg0KPiA+ID4gRGF0ZTogVHVlLCAxMSBGZWIgMjAyMCAxMjo1MDo1MyArMDgw
MA0KPiA+ID4NCj4gPiA+ID4gSXQgaXMgbmVjZXNzYXJ5IHRvIHByaW50IHRoZSBpbml0aWFsaXph
dGlvbiByZXN1bHQuDQo+ID4gPg0KPiA+ID4gTm8sIGl0IGlzIG5vdC4NCj4gPg0KPiA+IFNvcnJ5
LCBJIHNob3VsZCBoYXZlIGFkZGVkIG15IHJlYXNvbnMgaW50byBjb21taXQgbWVzc2FnZS4NCj4g
PiBJIHNlbnQgb3V0IHYyLiBEbyB5b3UgdGhpbmsgaWYgaXQgbWFrZXMgc2Vuc2U/DQo+ID4NCj4g
PiAiIEN1cnJlbnQgcHRwX3FvcmlxIGRyaXZlciBwcmludHMgb25seSB3YXJuaW5nIG9yIGVycm9y
IG1lc3NhZ2VzLg0KPiA+IEl0IG1heSBiZSBsb2FkZWQgc3VjY2Vzc2Z1bGx5IHdpdGhvdXQgYW55
IG1lc3NhZ2VzLg0KPiA+IEFsdGhvdWdoIHRoaXMgaXMgZmluZSwgaXQgd291bGQgYmUgY29udmVu
aWVudCB0byBoYXZlIGFuIG9uZWxpbmUNCj4gPiBpbml0aWFsaXphdGlvbiBsb2cgc2hvd2luZyBz
dWNjZXNzIGFuZCBQVFAgY2xvY2sgaW5kZXguDQo+ID4gVGhlIGdvb2RzIGFyZSwNCj4gPiAtIFRo
ZSBwdHBfcW9yaXEgZHJpdmVyIHVzZXJzIG1heSBrbm93IHdoZXRoZXIgdGhpcyBkcml2ZXIgaXMg
bG9hZGVkDQo+ID4gICBzdWNjZXNzZnVsbHksIG9yIG5vdCwgb3Igbm90IGxvYWRlZCBmcm9tIHRo
ZSBib290aW5nIGxvZy4NCj4gPiAtIFRoZSBwdHBfcW9yaXEgZHJpdmVyIHVzZXJzIGRvbid0IGhh
dmUgdG8gaW5zdGFsbCBhbiBldGh0b29sIHRvDQo+ID4gICBjaGVjayB0aGUgUFRQIGNsb2NrIGlu
ZGV4IGZvciB1c2luZy4gT3IgZG9uJ3QgaGF2ZSB0byBjaGVjayB3aGljaA0KPiA+ICAgL3N5cy9j
bGFzcy9wdHAvcHRwWCBpcyBQVFAgUW9ySVEgY2xvY2suIg0KPiA+DQo+ID4gVGhhbmtzLg0KPiAN
Cj4gSG93IGFib3V0IHRoaXMgbWVzc2FnZSB3aGljaCBpcyBhbHJlYWR5IHRoZXJlPw0KPiBbICAg
IDIuNjAzMTYzXSBwcHMgcHBzMDogbmV3IFBQUyBzb3VyY2UgcHRwMA0KDQpUaGlzIG1lc3NhZ2Ug
aXMgZnJvbSBwcHMgc3Vic3lzdGVtLiBXZSBkb24ndCBrbm93IHdoYXQgUFRQIGNsb2NrIGlzIHJl
Z2lzdGVyZWQgYXMgcHRwMC4NCkFuZCBpZiB0aGUgUFRQIGNsb2NrIGRvZXNuJ3Qgc3VwcG9ydCBw
cHMgY2FwYWJpbGl0eSwgZXZlbiB0aGlzIGxvZyB3b24ndCBiZSBzaG93ZWQuDQoNClRoYW5rcy4N
Cg0KPiANCj4gVGhhbmtzLA0KPiAtVmxhZGltaXINCg==
