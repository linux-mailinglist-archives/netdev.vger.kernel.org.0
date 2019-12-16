Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18D211FFEE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfLPIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:36:06 -0500
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:21228
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbfLPIgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 03:36:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoZscb8NF1/y4PscSXZVyMlAPPO+68CTNstoLrojEzYyO5Tvg/WqUM7232axkQkNBzVcrFhCzJeqF2Y3cLh1Ei200i6tjde433ckDGrIP1wXYMH/UQFG5lpBbdxczAN7TuovVKlF78kWkLFT9EfoQCqeygG/tUsbe5hbh2QpFN+6YqbEY4so+hPC7uFZdg4JuQ4UUzJqcYoTFpLMdNdsJZxfFFL65wmXYVF8L2y2lyRKSQuTfun+mD7errCKSf8pVQQ1o67ZYl1rSAMM73E5aKn3lW7+EgDbRcFE1Xjy/9KYTayXQVT3wk1t01YHUUmrJ7yvLVf/J5UB4nv3TvR+9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gCyLRrDpxKAeKgsJd22U8yIm0/lYTA1qO0jtdcQt3U=;
 b=YE2q9Qg8LOJNqEqhuvdnUvmV/rCq/AOGKAkVWY1qUOziLzevUQ7DGkqwBCwBLAAi3NfyZZKBG6cyTRQWkn4t927AlUtDMAd9L9+EsLYyZBcg6btlhGfPehSWsfdMjyxqbPgPauBA3LnFiqk0uydfCPC8POEInQmV2c351FK2cYu2YpCz8Xi8EGzDuxAljQSTXiwzYobESkYTAlz1gyhX1xFep8FEt8iB+qnOEt1wmFvloSz5Y6/ephdpVCih6tIRcGZ2W6Ik1IjkncpOTfPOQsnoq9TKWMrYsoZbHMYvGUIZoPDw3+wYRaj5IOEMjMzgBOnI4XtpZ4RBSY0opWStoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gCyLRrDpxKAeKgsJd22U8yIm0/lYTA1qO0jtdcQt3U=;
 b=eWe44JGUFCn+nqTax47hKFpDqn3iP+WpBkspcyRPgNbEdVSkmMB6CcSlSE613IGcmjkf4mQK+pcMLCfj2hWDiY5xRiwdDfnKAO1N6+BvVr4frpxbGrAbqNk6raNrgdAx4amrT44JllMp8fvNAJqBBTyNi4DLu14EFJ6hG5VIIm4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5300.eurprd05.prod.outlook.com (20.178.18.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Mon, 16 Dec 2019 08:36:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 08:36:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Topic: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Index: AQHVruL03dhci0tJKEiwh8p1eIZoWaezgmKAgAinFoCAADnbgIAAFpiA
Date:   Mon, 16 Dec 2019 08:36:02 +0000
Message-ID: <b1242f0f-c34d-e6af-1731-fec9c947c478@mellanox.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <4b7ee2ce-1415-7c58-f00e-6fdad08c1e99@mellanox.com>
 <20191216071509.GA916540@kroah.com>
In-Reply-To: <20191216071509.GA916540@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.20.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c42b8388-af57-4936-a1b0-08d78202fbca
x-ms-traffictypediagnostic: AM0PR05MB5300:
x-microsoft-antispam-prvs: <AM0PR05MB53005057B824C386E1E93861D1510@AM0PR05MB5300.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(199004)(189003)(26005)(81156014)(81166006)(8676002)(31696002)(86362001)(4326008)(186003)(71200400001)(6916009)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(76116006)(91956017)(2906002)(36756003)(31686004)(7416002)(6506007)(53546011)(55236004)(478600001)(8936002)(6512007)(54906003)(6486002)(5660300002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5300;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BrbR/VunJMs5AGPUlYJruvKfOs6Y+eNh09GiKiL7/JTTadIdLD0ih5Rx3OsLFrRr0C37oJiXFJSIxjLKx1KLe4wzuRCesMkX4oLj2gdqVhipLQLA7/17QdTtFZQnmaqgcs8sjVyF4ihM4F0liNZSFqDsWSwc0PxQ9MdCXT1XWkkMDO+/bRY0W3uup4FtL8ZqoSf283ziTBkoey+ORlT6+6SET1s3LVtVXINFZTGVvzhqUhInsGc9MPY8O8KSe00/hmq80Xb0Feg8Qc6yoZPZwIXYMa/WUBvllw49ucZTmTAFpSyVsyV8wJd7B/kRhQLwGaAzBjMXEBThsQGyJ4squqYn5FBIyXh/yrUMwpXoXK2QAES/sSK4qJ8lMp9hG0XqPYDsSLm515JdfsZb8RqoxCDe79PTOPDyd2lwwSZOjuUT6SG5vGSlnTbk3o3fA4j7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD3B134A42524E44A3C5F760ABE72B72@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42b8388-af57-4936-a1b0-08d78202fbca
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 08:36:02.0821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ko3+8VaSrncrb9Ul26ZGztaDodTOfduUKMmCIgRCW0aw0tqfwPrvB743VaqasCOeoyf1G6141d/DdFEwCMC1ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTYvMjAxOSAxMjo0NSBQTSwgR3JlZyBLSCB3cm90ZToNCj4gT24gTW9uLCBEZWMgMTYs
IDIwMTkgYXQgMDM6NDg6MDVBTSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KWy4uXQ0KPj4+
IEkgZmVlbCBsaWtlIHRoZSB2aXJ0dWFsIGJ1cyBjb2RlIGlzIGdldHRpbmcgYmV0dGVyLCBidXQg
dGhpcyB1c2Ugb2YgdGhlDQo+Pj4gY29kZSwgdW0sIG5vLCBub3Qgb2suDQo+Pj4NCj4+PiBFaXRo
ZXIgd2F5LCB0aGlzIHNlcmllcyBpcyBOT1QgcmVhZHkgdG8gYmUgbWVyZ2VkIGFueXdoZXJlLCBw
bGVhc2UgZG8NCj4+PiBub3QgdHJ5IHRvIHJ1c2ggdGhpbmdzLg0KPj4+DQo+Pj4gQWxzbywgd2hh
dCBldmVyIGhhcHBlbmVkIHRvIG15ICJZT1UgQUxMIE1VU1QgQUdSRUUgVE8gV09SSyBUT0dFVEhF
UiINCj4+PiByZXF1aXJlbWVudCBiZXR3ZWVuIHRoaXMgZ3JvdXAsIGFuZCB0aGUgb3RoZXIgZ3Jv
dXAgdHJ5aW5nIHRvIGRvIHRoZQ0KPj4+IHNhbWUgdGhpbmc/ICBJIHdhbnQgdG8gc2VlIHNpZ25l
ZC1vZmYtYnkgZnJvbSBFVkVSWU9ORSBpbnZvbHZlZCBiZWZvcmUNCj4+PiB3ZSBhcmUgZ29pbmcg
dG8gY29uc2lkZXIgdGhpcyB0aGluZy4NCj4+DQo+PiBJIGFtIHdvcmtpbmcgb24gUkZDIHdoZXJl
IFBDSSBkZXZpY2UgaXMgc2xpY2VkIHRvIGNyZWF0ZSBzdWItZnVuY3Rpb25zLg0KPj4gRWFjaCBz
dWItZnVuY3Rpb24vc2xpY2UgaXMgY3JlYXRlZCBkeW5hbWljYWxseSBieSB0aGUgdXNlci4NCj4+
IFVzZXIgZ2l2ZXMgc2YtbnVtYmVyIGF0IGNyZWF0aW9uIHRpbWUgd2hpY2ggd2lsbCBiZSB1c2Vk
IGZvciBwbHVtYmluZyBieQ0KPj4gc3lzdGVtZC91ZGV2LCBkZXZsaW5rIHBvcnRzLg0KPiANCj4g
VGhhdCBzb3VuZHMgZXhhY3RseSB3aGF0IGlzIHdhbnRlZCBoZXJlIGFzIHdlbGwsIHJpZ2h0Pw0K
DQpOb3QgZXhhY3RseS4NCkhlcmUsIGluIGk0MCB1c2UgY2FzZSAtIHRoZXJlIGlzIGEgUENJIGZ1
bmN0aW9uLg0KVGhpcyBQQ0kgZnVuY3Rpb24gaXMgdXNlZCBieSB0d28gZHJpdmVyczoNCigxKSB2
ZW5kb3JfZm9vX25ldGRldi5rbyBjcmVhdGluZyBOZXRkZXZpY2UgKGNsYXNzIG5ldCkNCigyKSB2
ZW5kb3JfZm9vX3JkbWEua28gY3JlYXRpbmcgUkRNQSBkZXZpY2UgKGNsYXNzIGluZmluaWJhbmQp
DQoNCkFuZCBib3RoIGRyaXZlcnMgYXJlIG5vdGlmaWVkIHVzaW5nIG1hdGNoaW5nIHNlcnZpY2Ug
dmlydGJ1cywgd2hpY2gNCmF0dGVtcHRzIHRvIGNyZWF0ZSB0byB0d28gdmlydGJ1c19kZXZpY2Vz
IHdpdGggZGlmZmVyZW50IGRyaXZlci1pZCwgb25lDQpmb3IgZWFjaCBjbGFzcyBvZiBkZXZpY2Uu
DQoNCkhvd2V2ZXIsIGRldmljZXMgb2YgYm90aCBjbGFzcyAobmV0LCBpbmZpbmliYW5kKSB3aWxs
IGhhdmUgcGFyZW50IGRldmljZQ0KYXMgUENJIGRldmljZS4NCg0KSW4gY2FzZSBvZiBzdWItZnVu
Y3Rpb25zLCBjcmVhdGVkIHJkbWEgYW5kIG5ldGRldmljZSB3aWxsIGhhdmUgcGFyZW50IGFzDQp0
aGUgc3ViLWZ1bmN0aW9uICdzdHJ1Y3QgZGV2aWNlJy4gVGhpcyB3YXkgdGhvc2UgU0ZzIGdldHMg
dGhlaXINCnN5c3RlbWQvdWRldiBwbHVtYmluZyBkb25lIHJpZ2h0bHkuDQoNCj4gDQo+PiBUaGlz
IHN1Yi1mdW5jdGlvbiB3aWxsIGhhdmUgc3lzZnMgYXR0cmlidXRlcyA9IHNmbnVtYmVyLCBpcnEg
dmVjdG9ycywNCj4+IFBDSSBCQVIgcmVzb3VyY2UgZmlsZXMuDQo+PiBzZm51bWJlciBhcyBzeXNm
cyBmaWxlIHdpbGwgYmUgdXNlZCBieSBzeXN0ZW1kL3VkZXYgdG8gaGF2ZQ0KPj4gZGV0ZXJtaW5p
c3RpYyBuYW1lcyBvZiBuZXRkZXYgYW5kIHJkbWEgZGV2aWNlIGNyZWF0ZWQgb24gdG9wIG9mDQo+
PiBzdWItZnVuY3Rpb24ncyAnc3RydWN0IGRldmljZScuDQo+Pg0KPj4gQXMgb3Bwb3NlZCB0byB0
aGF0LCBtYXRjaGluZyBzZXJ2aWNlIGRldmljZXMgd29uJ3QgaGF2ZSBzdWNoIGF0dHJpYnV0ZXMu
DQo+Pg0KPj4gV2Ugc3RheWVkIGF3YXkgZnJvbSB1c2luZyBtZGV2IGJ1cyBmb3Igc3VjaCBkdWFs
IHB1cnBvc2UgaW4gcGFzdC4NCj4gDQo+IFRoYXQgaXMgZ29vZC4NCj4gDQo+PiBTaG91bGQgd2Ug
aGF2ZSB2aXJ0YnVzIHRoYXQgaG9sZHMgJ3N0cnVjdCBkZXZpY2UnIGNyZWF0ZWQgZm9yIGRpZmZl
cmVudA0KPj4gcHVycG9zZSBhbmQgaGF2ZSBkaWZmZXJlbnQgc3lzZnMgYXR0cmlidXRlcz8gSXMg
aXQgb2s/DQo+IA0KPiBUaGF0J3MgZmluZSB0byBkbywgSSB3YXMgZXhwZWN0aW5nIHRoYXQgdG8g
aGFwcGVuLg0KPiANCm9rLiBUaGFua3MgYSBsb3QuDQpMZXRzIHVuZGVyc3RhbmQgYWJvdmUgYWRk
aXRpb25hbCAobm9uIHN5c2ZzKSBkaWZmZXJlbmNlIGFzIHdlbGwgb24gaG93DQp2aXJ0YnVzIGRl
dmljZSBpcyBnZXR0aW5nIHVzZWQgZGlmZmVyZW50bHkgYmV0d2VlbiBzdWItZnVuY3Rpb25zIGFu
ZA0KbWF0Y2hpbmcgc2VydmljZSBwdXJwb3Nlcy4NCg==
