Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0794F133B22
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgAHF0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:26:41 -0500
Received: from mail-eopbgr1320085.outbound.protection.outlook.com ([40.107.132.85]:43038
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgAHF0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 00:26:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6uwzobp8HRtdDGga45xAYUFBMDNDjJzAd85ao4qRdPppVOdO/BPgDWce+ydEj2/pP/AhSeZKVNPPsst2qHzfMps8gO6cueSlRg3vzl3ORWZHmslA1A9M6iVC0jDABMy+iJf9ycgKQDATsQA9qJnD4Qagn/xCm9KdPBGoLTK37yK7OKgspX9LpucmCvilb5G6KfevAf/6si7nWyu9s23vL/Po8kY0zrTpidZK2lR8bFPAI8JREnuvcO8BKEquU++4SP5to0KR+xe1WVcdVOZVChZxKBRqH9rJht/2dGhPcwpnNlLWwbLwna7T3J8yiJdhGfjjZLFhAiORz7pe2oPOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXQoVL/S7SaSvlwGd6hgUlFgPaanNGOjOCAtLzV7NzM=;
 b=PHFs8ChoisSogk1kugVe5rL/qCRxsdeZ5Ikc9EtPp99Gt51lU/OGRuo+63jL2lIaQxtskqAVCWK7jDhtnNX76WqhU9/qLsur5ddafVH6tCi/6OVsQCIEl6wfI2A48DrTMwLVjq5cQxm1XYw9Y+rm1YQdHbUAhwulimxHpnhhgCrd8YCqjTcey567VkZnInb+DaNJu40swNOoxAT7jmvuWzgn4wZYTu4DTiLiurmBPoFloROlHLb74dtI1klN6sAUWRkzv8awAiVNJPEtfZNFhthpqCsSwfEnaPP6jX7rOtvbEROEwICPPfyqGVbPB0+Lx2EFrj2rKisYFuZtHrRLpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=moxa.com; dmarc=pass action=none header.from=moxa.com;
 dkim=pass header.d=moxa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Moxa.onmicrosoft.com;
 s=selector2-Moxa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXQoVL/S7SaSvlwGd6hgUlFgPaanNGOjOCAtLzV7NzM=;
 b=RYeUe/rxX/AO1ZLHTTZcO1xoJjj2866WaY972OGuTQqc/8BKmPtfjNk3Q8ED8OMRA+u26cku9R9pZvfQ3XtchGAraGkmeziXwkCEjjM14IVGdr1cZ5PnLNwzj/U1SAC6gIEK/xbbKWch8r5XiB5FZYMFG9VctSuyzlvNI8keJ+I=
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com (52.132.237.22) by
 HK0PR01MB1972.apcprd01.prod.exchangelabs.com (52.133.157.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 05:26:36 +0000
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042]) by HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042%6]) with mapi id 15.20.2602.016; Wed, 8 Jan 2020
 05:26:36 +0000
From:   =?utf-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>
To:     Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Subject: RE: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Topic: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Index: AdXFRAcg+ooT8TPrTsG92JEuKMTbqwAGWQoAAAHzV4AAH6igEA==
Date:   Wed, 8 Jan 2020 05:26:35 +0000
Message-ID: <HK0PR01MB3521CA38E57FA1A5860349DDFA3E0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
 <20200107132150.GB23819@lunn.ch>
 <CAOMZO5AE1eFjfHwh5HQjn3XmA=_tYZ2qjcU-sX63qFuV=f8ccw@mail.gmail.com>
In-Reply-To: <CAOMZO5AE1eFjfHwh5HQjn3XmA=_tYZ2qjcU-sX63qFuV=f8ccw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=JohnsonCH.Chen@moxa.com; 
x-originating-ip: [122.146.92.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 856f3a51-4518-4232-19fd-08d793fb548b
x-ms-traffictypediagnostic: HK0PR01MB1972:
x-microsoft-antispam-prvs: <HK0PR01MB1972F3F65E11DAE7CC67E1C1FA3E0@HK0PR01MB1972.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39850400004)(346002)(396003)(366004)(199004)(189003)(43544003)(478600001)(66446008)(6506007)(76116006)(64756008)(66556008)(8936002)(33656002)(55016002)(5660300002)(7696005)(110136005)(54906003)(9686003)(71200400001)(2906002)(53546011)(4326008)(86362001)(26005)(52536014)(66476007)(81166006)(8676002)(81156014)(66946007)(316002)(186003)(85182001);DIR:OUT;SFP:1101;SCL:1;SRVR:HK0PR01MB1972;H:HK0PR01MB3521.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: moxa.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vwCGII9QfVxfEbMvVr2dnFs0+/VpFc1Gj9TC/qTf+DHzXNNTsOTdv2j31jNUUJp2GH/4Pr0ytDlNaQhd4l6yw6HwyeVQgBa+CCSNB2maIiIdQvamHlDL2FHxrQQ2HFb9Zk36Hw/JWqt4SQjzkh56gGqa3ORydDatI8rN66WgZAgOanzp6VarJx8MfwBAPuuZ0TPc4wHbhfnCzkpy0YDo5TBJ7aYYIRCHy29vsduGqdWk+idWcKVy2XyNAkRdNSrjtFizfbv8kNPMUmOY014/Mki+RTc7xdmAt+SB3xV29FsQXvE8KqXwlFVzcj6eMHlM8LL+DO0GsGnnflA7m6TyXGW9ZZQMjK5qvxRXyY4IVDyuH4dvfg08xnrpTg/9o57RUnLGN+6yZlCb3rOF1f1vj9pM+sTdXF290VIz99mghTt7D1i1RLP7sg6thXKJcZgkBeRMti9EPLpzva8179unFktaJikls7f5QgoBQLsa936mS8NdMBMt3wJIeHXtS1iM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: moxa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856f3a51-4518-4232-19fd-08d793fb548b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 05:26:35.8572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5571c7d4-286b-47f6-9dd5-0aa688773c8e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1FAUhKGyl8ORk88fLMSZMAMvclYFKQTjU9RatYWGO8FvOp5xhgdpECkwg/XI2B/SU1OpLwr6f0Vr8q79NAqayQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR01MB1972
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkZhYmlvIEVzdGV2YW0gPGZlc3RldmFtQGdtYWlsLmNvbT4g5pa8IDIwMjDlubQx5pyI
N+aXpSDpgLHkuowg5LiL5Y2IMTA6MTflr6vpgZPvvJoNCj4NCj4gT24gVHVlLCBKYW4gNywgMjAy
MCBhdCAxMToxMyBBTSBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+IHdyb3RlOg0KPiA+DQo+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIu
YyANCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KPiA+
ID4gaW5kZXggNzI4NjhhMjhiNjIxLi5hYjRlNDUxOTlkZjkgMTAwNjQ0DQo+ID4gPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5jDQo+ID4gPiBAQCAtODMzLDYgKzgz
Myw3IEBAIHN0YXRpYyBpbnQgZ2Zhcl9vZl9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgDQo+
ID4gPiAqb2ZkZXYsIHN0cnVjdCBuZXRfZGV2aWNlICoqcGRldikNCj4gPiA+DQo+ID4gPiAgICAg
ICAvKiBGaW5kIHRoZSBUQkkgUEhZLiAgSWYgaXQncyBub3QgdGhlcmUsIHdlIGRvbid0IHN1cHBv
cnQgU0dNSUkgKi8NCj4gPiA+ICAgICAgIHByaXYtPnRiaV9ub2RlID0gb2ZfcGFyc2VfcGhhbmRs
ZShucCwgInRiaS1oYW5kbGUiLCAwKTsNCj4gPiA+ICsgICAgIHByaXYtPmRtYV9lbmRpYW5fbGUg
PSBvZl9wcm9wZXJ0eV9yZWFkX2Jvb2wobnAsIA0KPiA+ID4gKyAiZnNsLGRtYS1lbmRpYW4tbGUi
KTsNCj4gPg0KPiA+IEhpIEpvaG5zb24NCj4gPg0KPiA+IFlvdSBuZWVkIHRvIGRvY3VtZW50IHRo
aXMgbmV3IHByb3BlcnR5IGluIHRoZSBiaW5kaW5nLg0KDQpUaGFua3MgeXVvciByZW1pbmQsIEkn
bGwgdGFrZSBjYXJlIG9mIGl0IGxhdGVyDQo+DQo+IFllcywgYnV0IHdoYXQgYWJvdXQgY2FsbGlu
ZyBpdCAnbGl0dGxlLWVuZGlhbicgd2hpY2ggaXMgY29tbW9ubHkgdXNlZCANCj4gaW4gYXJjaC9h
cm02NC9ib290L2R0cy9mcmVlc2NhbGUvZnNsLWxzeHh4IGRldmljZSB0cmVlcz8NCkl0IHNvdW5k
cyBnb29kLCB1c2UgImRtYS1lbmRpYW4tbGUiIGJlY2F1c2UgaXQncyBmcm9tIGZyZWVzY2FsZSdz
IFNESyBmb3IgYXJtICgzMmJpdCkuDQoNClRoYW5rcyB5b3VyIHN1Z2dlc3Rpb25zIQ0KDQpCZXN0
IHJlZ2FyZHMsDQpKb2huc29uDQo=
