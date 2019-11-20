Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C56103210
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTDiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:38:24 -0500
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:41184
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727262AbfKTDiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 22:38:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjS4ByRE7t+BYpJ5+zVeVZo1no8s4AFx9xpZasNcr8t54VUwXYIuBOgJDs9ypbgW1/ZczVS2VP1590vFoAKUFTiFRAIPxta9mlykldx7xxZ7Q2DBMpZPHU9n45qGY7Qp3bF5tJ4BfQAi90ryom8L9LPjmHhByXe2BndmsdWT5uaU6KuCLJp8RUXFde5O3HTEQbvJacbwoxfCDl07WtODKY4nDMn/6rpp4Ej6+y9f0cRqqv9zdF7xNnp+L51udmXCCWIXC9YXNxkU2MwKL45QMUIT/23ihjw0TstEsoYyXpI2k8Q3LuTEXSq5fzgpV52jSzvGvqEwUxhnbjEMfZUpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GM7yP400xVVufhsm69K+RE08hU1qNpi5ol4xeVtvCM=;
 b=ng/bwDcRtK4j4sOYCAFDPFm/Qd9uVasKAqgU4hCKgPPinXlOafHzq/xA2Oh4MpyOyNpaF8L4qSqiwVK2vbo37lEJORJsFDKqmedyUtvem0zZcbReh11DW2s3xFuMd5/Szsk2wL1fA5rFa1bU3ECTsjXay51+YPA1VXUli8AYc7gpQMfdLZHio7I56B9iYvyTzoYF6w5LoFj4ceAROE54BCiX+cvd8KlEU41oMatqcnXVKUO0PHfgA7cTv8JbBs28GSqHBUHrDpux8q3/VppyaN9PadWvcv3aSEwuo/+EVpNd41X4BPV+6f1W+gR4xQFpuR23kBU0l0QO+zjeoF43QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GM7yP400xVVufhsm69K+RE08hU1qNpi5ol4xeVtvCM=;
 b=IF8KsxqFU5gwgPrXGKDUmte3C5v3IPgG0f5J7xdCCr9sS7MQ3gxefeRfHtSMarnKmzk/TOwhEoSll/geXMaaJQ3q1DZUcmvhtq17nh+NimTzX3A8F1nBOZvcWSMFtSsHAMYRupa7Vw+p2RsqDkrPwcM64iW834R1iCYzriFPz3M=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6609.eurprd05.prod.outlook.com (20.178.117.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Wed, 20 Nov 2019 03:38:18 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 03:38:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0IAAJnyAgAAC1aCAAAnmgIAAf31QXxyMZiP9B+YeIA==
Date:   Wed, 20 Nov 2019 03:38:18 +0000
Message-ID: <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
In-Reply-To: <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0454dd17-11d2-4ddb-93a9-08d76d6b159b
x-ms-traffictypediagnostic: AM0PR05MB6609:
x-microsoft-antispam-prvs: <AM0PR05MB6609C1B77EF2C2DD6C760388D14F0@AM0PR05MB6609.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(13464003)(189003)(199004)(66946007)(33656002)(478600001)(99286004)(256004)(54906003)(7696005)(86362001)(66476007)(5660300002)(26005)(446003)(55016002)(25786009)(7736002)(66066001)(305945005)(7416002)(11346002)(229853002)(476003)(6916009)(74316002)(14454004)(6436002)(81166006)(8936002)(81156014)(9686003)(4326008)(6246003)(486006)(71190400001)(71200400001)(6116002)(8676002)(6506007)(186003)(3846002)(76176011)(52536014)(102836004)(66446008)(2906002)(64756008)(66556008)(76116006)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6609;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0aT8vgkFb/O4lG1aQ1TGQUV5VgBmzRC+6ABCzie3VefSDtyVsIg9iMTcf3wJ8HLA1ja6sXxuu07/3yYVV/D9RE2oJ8GXTsGLHVtb67mJMaKidALtElLUHl1D9TZYmIQt/zd6CXFHY3DTZ4oghb+sPbj30hvk6zmXcV+eG3E+ARWxjTs2pr9eYksJr3VKS6QmrFL5vGJjFCzphc6dYZtSAeNTkLmCuTtID7qFGGzDrPzh88ofhOoBJY/8dQ3PPhJxni9O2hzSAaacFw3PZ+unbF2nanjGxPyeu7DrSAKpKW6CdLuTZMsk6oo8sg9GnBiY/WnldbrwDtFgya9bQYZ/mpTsNSxTBb6mF2G6x6iYFNOtqIvwz6+6MrhRps9F+ygU7ah806wCKX3mWvIDl9YcikYlQt1ey0LC18+r3Nsb83h8nx6MKEz4CY6TvKTCYpeX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0454dd17-11d2-4ddb-93a9-08d76d6b159b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 03:38:18.6151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzBLP60z2GMZZPmtS6HvxwjU5efmcxxEkfAUHO/wXcwVwuFvAa9iLbJzk3UjFp0rG08S4HMVrQs2tYJxwbmjqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVl
c2RheSwgTm92ZW1iZXIgMTksIDIwMTkgOToxNSBQTQ0KPiANCj4gLS0tLS0gT3JpZ2luYWwgTWVz
c2FnZSAtLS0tLQ0KPiA+DQo+ID4NCj4gPiA+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJl
ZGhhdC5jb20+DQo+ID4gPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxOSwgMjAxOSAxOjM3IEFN
DQo+ID4gPg0KPiA+DQo+ID4gTm9wLiBEZXZsaW5rIGlzIE5PVCBuZXQgc3BlY2lmaWMuIEl0IHdv
cmtzIGF0IHRoZSBidXMvZGV2aWNlIGxldmVsLg0KPiA+IEFueSBibG9jay9zY3NpL2NyeXB0byBj
YW4gcmVnaXN0ZXIgZGV2bGluayBpbnN0YW5jZSBhbmQgaW1wbGVtZW50IHRoZQ0KPiA+IG5lY2Vz
c2FyeSBvcHMgYXMgbG9uZyBhcyBkZXZpY2UgaGFzIGJ1cy4NCj4gPg0KPiANCj4gV2VsbCwgdWFw
aS9saW51eC9kZXZsaW5rLmggdG9sZCBtZToNCj4gDQo+ICINCj4gICogaW5jbHVkZS91YXBpL2xp
bnV4L2RldmxpbmsuaCAtIE5ldHdvcmsgcGh5c2ljYWwgZGV2aWNlIE5ldGxpbmsgaW50ZXJmYWNl
ICINCj4gDQo+IEFuZCB0aGUgdXNlcnNwYWNlIHRvb2wgd2FzIHBhY2thZ2VkIGludG8gaXByb3V0
ZTIsIHRoZSBjb21tYW5kIHdhcyBuYW1lZA0KPiBhcyAiVEMiLCAiUE9SVCIsICJFU1dJVENIIi4g
QWxsIG9mIHRob3NlIHdlcmUgc3Ryb25nIGhpbnRzIHRoYXQgaXQgd2FzIG5ldHdvcmsNCj4gc3Bl
Y2lmaWMuIEV2ZW4gZm9yIG5ldHdvcmtpbmcsIG9ubHkgZmV3IHZlbmRvcnMgY2hvb3NlIHRvIGlt
cGxlbWVudCB0aGlzLg0KPiANCkl0IGlzIHVuZGVyIGlwcm91dGUyIHRvb2wgYnV0IGl0IGlzIG5v
dCBsaW1pdGVkIHRvIG5ldHdvcmtpbmcuDQpUaG91Z2ggdG9kYXkgbW9zdCB1c2VycyBhcmUgbmV0
d29ya2luZyBkcml2ZXJzLg0KDQpJIGRvIG5vdCBrbm93IGhvdyBvdnMgb2ZmbG9hZHMgYXJlIGRv
bmUgd2l0aG91dCBkZXZsaW5rIGJ5IG90aGVyIHZlbmRvcnMgZG9pbmcgaW4ta2VybmVsIGRyaXZl
cnMuDQoNCj4gU28gdGVjaG5pY2FsbHkgaXQgY291bGQgYmUgZXh0ZW5kZWQgYnV0IGhvdyBoYXJk
IGl0IGNhbiBiZSBhY2hpZXZlZCBpbiByZWFsaXR5Pw0KPiANCldoYXQgYXJlIHRoZSBtaXNzaW5n
IHRoaW5ncz8NCkkgYW0gZXh0ZW5kaW5nIGl0IGZvciBzdWJmdW5jdGlvbnMgbGlmZWN5Y2xlLiBJ
IHNlZSB2aXJ0aW8gYXMgeWV0IGFub3RoZXIgZmxhdm91ci90eXBlIG9mIHN1YmZ1bmN0aW9uLg0K
DQo+IEkgc3RpbGwgZG9uJ3Qgc2VlIHdoeSBkZXZsaW5rIGlzIGNvbmZsaWN0ZWQgd2l0aCBHVUlE
L3N5c2ZzLCB5b3UgY2FuIGhvb2sgc3lzZnMNCkl0IGlzIG5vdCBjb25mbGljdGluZy4gSWYgeW91
IGxvb2sgYXQgd2hhdCBhbGwgZGV2bGluayBpbmZyYXN0cnVjdHVyZSBwcm92aWRlcywgeW91IHdp
bGwgZW5kIHVwIHJlcGxpY2F0aW5nIGFsbCBvZiBpdCB2aWEgc3lzZnMuLg0KSXQgZ290IHN5c2Nh
bGxlciBzdXBwb3J0IHRvbywgd2hpY2ggaXMgZ3JlYXQgZm9yIHZhbGlkYXRpb24uDQpJIGhhdmUg
cG9zdGVkIHN1YmZ1bmN0aW9uIHNlcmllcyB3aXRoIG1kZXYgYW5kIHVzZWQgZGV2bGluayBmb3Ig
YWxsIHJlc3Qgb2YgdGhlIGVzdyBhbmQgbWdtdC4gaW50ZXJmYWNlIHRvIHV0aWxpemUgaXQuDQoN
CnNyaW92IHZpYSBzeXNmcyBhbmQgZGV2bGluayBzcmlvdi9lc3cgaGFuZGxpbmcgaGFzIHNvbWUg
c2V2ZXJlIGxvY2tpbmcgaXNzdWVzLCBtYWlubHkgYmVjYXVzZSB0aGV5IGFyZSBmcm9tIHR3byBk
aWZmZXJlbnQgaW50ZXJmYWNlcy4NCg0KPiBldmVudHMgdG8gZGV2bGluayBvciBkbyBwb3N0IG9y
IHByZSBjb25maWd1cmF0aW9uIHRocm91Z2ggZGV2bGluay4gVGhpcyBpcyBtdWNoDQo+IG1vcmUg
ZWFzaWVyIHRoYW4gZm9yY2luZyBhbGwgdmVuZG9ycyB0byB1c2UgZGV2bGluay4NCj4NCkl0IGlz
IG5vdCBhYm91dCBmb3JjaW5nLiBJdCBpcyBhYm91dCBsZXZlcmFnaW5nIGV4aXN0aW5nIGtlcm5l
bCBmcmFtZXdvcmsgYXZhaWxhYmxlIHdpdGhvdXQgcmVpbnZlbnRpbmcgdGhlIHdoZWVsLg0KSSBh
bSAxMDAlIHN1cmUsIGltcGxlbWVudGluZyBoZWFsdGgsIGR1bXBzLCB0cmFjZXMsIHJlcG9ydGVy
cywgc3lzY2FsbGVyLCBtb25pdG9ycywgaW50ZXJydXB0IGNvbmZpZ3MsIGV4dGVuZGluZyBwYXJh
bXMgdmlhIHN5c2ZzIHdpbGwgYmUgbm8tZ28uDQpzeXNmcyBpcyBub3QgbWVhbnQgZm9yIHN1Y2gg
dGhpbmdzIGFueW1vcmUuIEFueSBtb2Rlcm4gZGV2aWNlIG1hbmFnZW1lbnQgd2lsbCBuZWVkIGFs
bCBvZiBpdC4NCg==
