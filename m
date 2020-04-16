Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869381ABD18
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504013AbgDPJly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:41:54 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:5892
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503869AbgDPJlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 05:41:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7ZHiIk03PTOcuwXwCk+MjOLMZKMqPaHrmTqg1ksrCzIg2FvJNTBLkKe4j93Dqh5gugAPHXs5xh0tf9EqivwSLmEFO2K7jXNwf63ATzB3ffKuaryMtdJrZkJEyAL2CMN9624/z/govse6OaTf2YerkafJ7AlKivuOdxZ303eoF7Ua5sNOFfl9v0sDwfSftkDU0NEdd+PsJFr1ACwrnLyS010IKuWxfuTHibe6WwyF7WLqf7aWDvlUarTRLPDrw9oMUlfNoqJaZvHf/88JSymARJmG3fRdrAQdpXn/N+CbNIqzTvxjWiFkIB27vun77rtZoiB3LASJ/ocodgokBko9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHsX7wHYtStr1iOTezMx2augeRHOcO7SWO1jzJbNdgM=;
 b=KEZ7h+CuWgPm95IR1iVht58G2KweFUSwt0BipxX71JVgbb6Di70ooKEEn8ZbQCYAvqJSh7OGrrHVrRqDn4Py8jTcjFvvX10QsV7Tc5ZhcjnPEfEsaPa36e+jPzc3jCdXepvJndwOIp3Og5gjrDPB/AaL3GnEG8aCIm8CyyHeKVYJiccwN7QVUOKnSOvqT1bUioJdaQ069fiAL27rWSzgjyugBdwLXROvP8q8fOkhU4dv1pJxJifR5039pRDccIY433DEaxCU/MEhvTIa400i93SyY3iZfUncFIqLlUPGIHGeaqXCqBJdBgAUP0Pk4ZXlBFuEeyGaIVm0SSprxEsB1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHsX7wHYtStr1iOTezMx2augeRHOcO7SWO1jzJbNdgM=;
 b=NBbS6UCYHH0BHjssciSv8EzObCRo6FJnSgd25HzftfJTW8wVddhmslNCEg5n1qWXYsKfcWwUQtrNU2+hXg0m9IcWjSSEiUX0i/ZTk1p7WNDMQNxfcXJuhGMcCSA4Ti1y/IGTbobl5GC3epGzzNGumXCId0K2dQBSiddKIkvwgB4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7146.eurprd04.prod.outlook.com (2603:10a6:10:127::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 16 Apr
 2020 09:41:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e%8]) with mapi id 15.20.2921.027; Thu, 16 Apr 2020
 09:41:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: RE: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Topic: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Index: AQHWE9It45mk5G6f2ES/KFIAprd1aah7fVCA
Date:   Thu, 16 Apr 2020 09:41:45 +0000
Message-ID: <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
In-Reply-To: <20200416093126.15242-2-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e3c2ba6-b989-443c-f729-08d7e1ea606e
x-ms-traffictypediagnostic: DB8PR04MB7146:|DB8PR04MB7146:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7146EFC6239B9C0CD9A76C43E6D80@DB8PR04MB7146.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(54906003)(26005)(5660300002)(110136005)(53546011)(316002)(33656002)(52536014)(71200400001)(55016002)(6506007)(2906002)(9686003)(64756008)(66556008)(7696005)(86362001)(66446008)(8936002)(66476007)(76116006)(66946007)(478600001)(186003)(81156014)(4326008)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0+SH0qlrdhjbsL0DGVF1MrrXanbBJuYiINJOo+Hdgnd/BcFBDIPXajjP6O4TtRInnchJaNK73Y1Bf8etoffLLqWpwayk5DGiNeRvnw/ThE1UTYxwtSnqhZ8a0orlIr90LRy9eKIweM4kdul27TOnC+Ft6GH2sQWvbhTnLEw55v9uRYw7DEfEHKk9H0Chgs83LPSCXVSTcHVBl6an7SlEvv5AvGM5ac+msype0J3UZVBHm2/LAKwmxxG4yjOSkkj8vZ/TElxXmIfEWv47bORk40v1LnvMuLSVe1/LKUIJlIVkH0ZBwHHYKhFVkg845vIV7Wf5OcUQgOabEZdFdyZOhhZM/nz1q0/yoo6wnl9xbp1wGahKXH1pQLkw0l1OwmyBEpFJigawILYmnsSx+vhkzNIDU57z3NiELGl/ytXYbsPv7+rwx1EC715izFdPyeNi
x-ms-exchange-antispam-messagedata: Lyv7AvXAIG8410WDKxGnXuzl2ciGIRyX7s3PIH47OuYXhffX5dykut0E1ub47Q5Qq7i/H0nKzAZSzwshrBR5fIK5qhlQtSEg3nTZWDAQpNjWVWHP2fSrZKVr5HAlvIQ4Kvdk2Nj3ttDsoqh43AfHcQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3c2ba6-b989-443c-f729-08d7e1ea606e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 09:41:45.1845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYKt8l2yyVKCJqyMxzL14lwTxMFxqfPuhb5QbxmuycqsYOTE1js69rX/50ssrXdVVDI6oau6/FDndZGXeGOb2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQpIb3cgYWJvdXQgRmxleENBTiBGRCBwYXRjaCBzZXQsIGl0IGlzIHBlbmRp
bmcgZm9yIGEgbG9uZyB0aW1lLiBNYW55IHdvcmsgd291bGQgYmFzZSBvbiBpdCwgd2UgYXJlIGhh
cHB5IHRvIHNlZSBpdCBpbiB1cHN0cmVhbSBtYWlubGluZSBBU0FQLg0KDQpNaWNoYWVsIFdhbGxl
IGFsc28gZ2l2ZXMgb3V0IHRoZSB0ZXN0LWJ5IHRhZzoNCglUZXN0ZWQtYnk6IE1pY2hhZWwgV2Fs
bGUgPG1pY2hhZWxAd2FsbGUuY2M+DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlhbmdx
aW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjDE6jTUwjE2yNUgMTc6MzENCj4gVG86IG1r
bEBwZW5ndXRyb25peC5kZTsgbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogZGwtbGlu
dXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogW1BBVENIIGxpbnV4LWNhbi1uZXh0L2ZsZXhjYW5dIGNhbjogZmxleGNhbjogZml4IFRE
QyBmZWF0dXJlDQo+IA0KPiBXZSBlbmFibGUgVERDIGZlYXR1cmUgaW4gZmxleGNhbl9zZXRfYml0
dGltaW5nIHdoZW4gbG9vcGJhY2sgb2ZmLCBidXQgZGlzYWJsZQ0KPiBpdCBieSBtaXN0YWtlIGFm
dGVyIGNhbGxpbmcgZmxleGNhbl9zZXRfYml0dGltaW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Sm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jIHwgMyArKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4v
ZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBpbmRleA0KPiBiMTZiOGFiYzFj
MmMuLjI3ZjQ1NDFkOTQwMCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+IEBAIC0xMjAyLDYgKzEyMDIs
OCBAQCBzdGF0aWMgdm9pZCBmbGV4Y2FuX3NldF9iaXR0aW1pbmcoc3RydWN0IG5ldF9kZXZpY2UN
Cj4gKmRldikNCj4gIAkJCQkvKiBmb3IgdGhlIFREQyB0byB3b3JrIHJlbGlhYmx5LCB0aGUgb2Zm
c2V0IGhhcyB0byB1c2UNCj4gb3B0aW1hbCBzZXR0aW5ncyAqLw0KPiAgCQkJCXJlZ19mZGN0cmwg
fD0NCj4gRkxFWENBTl9GRENUUkxfVERDT0ZGKCgoZGJ0LT5waGFzZV9zZWcxIC0gMSkgKyBkYnQt
PnByb3Bfc2VnICsgMikgKg0KPiAgCQkJCQkJCQkgICAgKChkYnQtPmJycCAtMSkgKyAxKSk7DQo+
ICsJCQl9IGVsc2Ugew0KPiArCQkJCXJlZ19mZGN0cmwgJj0gfkZMRVhDQU5fRkRDVFJMX1REQ0VO
Ow0KPiAgCQkJfQ0KPiAgCQkJcHJpdi0+d3JpdGUocmVnX2ZkY3RybCwgJnJlZ3MtPmZkY3RybCk7
DQo+IA0KPiBAQCAtMTM1NCw3ICsxMzU2LDYgQEAgc3RhdGljIGludCBmbGV4Y2FuX2NoaXBfc3Rh
cnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIAkvKiBGRENUUkwgKi8NCj4gIAlpZiAocHJp
di0+Y2FuLmN0cmxtb2RlX3N1cHBvcnRlZCAmIENBTl9DVFJMTU9ERV9GRCkgew0KPiAgCQlyZWdf
ZmRjdHJsID0gcHJpdi0+cmVhZCgmcmVncy0+ZmRjdHJsKSAmIH5GTEVYQ0FOX0ZEQ1RSTF9GRFJB
VEU7DQo+IC0JCXJlZ19mZGN0cmwgJj0gfkZMRVhDQU5fRkRDVFJMX1REQ0VOOw0KPiAgCQlyZWdf
ZmRjdHJsICY9IH4oRkxFWENBTl9GRENUUkxfTUJEU1IxKDB4MykgfA0KPiBGTEVYQ0FOX0ZEQ1RS
TF9NQkRTUjAoMHgzKSk7DQo+ICAJCXJlZ19tY3IgPSBwcml2LT5yZWFkKCZyZWdzLT5tY3IpICYg
fkZMRVhDQU5fTUNSX0ZERU47DQo+ICAJCXJlZ19jdHJsMiA9IHByaXYtPnJlYWQoJnJlZ3MtPmN0
cmwyKSAmDQo+IH5GTEVYQ0FOX0NUUkwyX0lTT0NBTkZERU47DQo+IC0tDQo+IDIuMTcuMQ0KDQo=
