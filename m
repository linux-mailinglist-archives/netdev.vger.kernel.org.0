Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71344227E51
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgGULJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:09:35 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729717AbgGULJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:09:29 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id AF9A0B9D360B772BA0FF;
        Tue, 21 Jul 2020 19:09:24 +0800 (CST)
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.193]) by
 DGGEMM404-HUB.china.huawei.com ([10.3.20.212]) with mapi id 14.03.0487.000;
 Tue, 21 Jul 2020 19:09:16 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "h.morris@cascoda.com" <h.morris@cascoda.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "marcel@holtmann.or" <marcel@holtmann.or>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] ieee802154: fix one possible memleak in
 ca8210_dev_com_init
Thread-Topic: [PATCH net] ieee802154: fix one possible memleak in
 ca8210_dev_com_init
Thread-Index: AQHWXznhxvgebMKzz0SsJPINv25EA6kR3/eQ
Date:   Tue, 21 Jul 2020 11:09:16 +0000
Message-ID: <4F88C5DDA1E80143B232E89585ACE27D129AA4FA@dggemm508-mbx.china.huawei.com>
References: <20200720143315.40523-1-liujian56@huawei.com>
 <23cf1224-5335-7a00-6f9d-d83e5e91df3d@datenfreihafen.org>
In-Reply-To: <23cf1224-5335-7a00-6f9d-d83e5e91df3d@datenfreihafen.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RlZmFuIFNjaG1pZHQg
W21haWx0bzpzdGVmYW5AZGF0ZW5mcmVpaGFmZW4ub3JnXQ0KPiBTZW50OiBUdWVzZGF5LCBKdWx5
IDIxLCAyMDIwIDQ6MzUgUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5j
b20+OyBoLm1vcnJpc0BjYXNjb2RhLmNvbTsNCj4gYWxleC5hcmluZ0BnbWFpbC5jb207IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gbWFyY2VsQGhvbHRtYW5uLm9yOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSBpZWVlODAy
MTU0OiBmaXggb25lIHBvc3NpYmxlIG1lbWxlYWsgaW4NCj4gY2E4MjEwX2Rldl9jb21faW5pdA0K
PiANCj4gSGVsbG8uDQo+IA0KPiBPbiAyMC4wNy4yMCAxNjozMywgTGl1IEppYW4gd3JvdGU6DQo+
ID4gV2Ugc2hvdWxkIGNhbGwgZGVzdHJveV93b3JrcXVldWUgdG8gZGVzdHJveSBtbG1lX3dvcmtx
dWV1ZSBpbiBlcnJvcg0KPiBicmFuY2guDQo+ID4NCj4gPiBGaXhlczogZGVkODQ1YTc4MWE1ICgi
aWVlZTgwMjE1NDogQWRkIENBODIxMCBJRUVFIDgwMi4xNS40IGRldmljZQ0KPiA+IGRyaXZlciIp
DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiA+
IC0tLQ0KPiA+ICAgZHJpdmVycy9uZXQvaWVlZTgwMjE1NC9jYTgyMTAuYyB8IDEgKw0KPiA+ICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvaWVlZTgwMjE1NC9jYTgyMTAuYw0KPiA+IGIvZHJpdmVycy9uZXQvaWVlZTgwMjE1
NC9jYTgyMTAuYyBpbmRleCBlMDRjM2I2MGNhZTcuLjRlYjY0NzA5ZDQ0Yw0KPiA+IDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2llZWU4MDIxNTQvY2E4MjEwLmMNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9pZWVlODAyMTU0L2NhODIxMC5jDQo+ID4gQEAgLTI5MjUsNiArMjkyNSw3IEBAIHN0
YXRpYyBpbnQgY2E4MjEwX2Rldl9jb21faW5pdChzdHJ1Y3QgY2E4MjEwX3ByaXYNCj4gKnByaXYp
DQo+ID4gICAJKTsNCj4gPiAgIAlpZiAoIXByaXYtPmlycV93b3JrcXVldWUpIHsNCj4gPiAgIAkJ
ZGV2X2NyaXQoJnByaXYtPnNwaS0+ZGV2LCAiYWxsb2Mgb2YgaXJxX3dvcmtxdWV1ZQ0KPiBmYWls
ZWQhXG4iKTsNCj4gPiArCQlkZXN0cm95X3dvcmtxdWV1ZShwcml2LT5tbG1lX3dvcmtxdWV1ZSk7
DQo+ID4gICAJCXJldHVybiAtRU5PTUVNOw0KPiA+ICAgCX0NCj4gDQo+IEZvciBpZWVlODAyMTU0
IHBhdGNoZXMgcGxlYXNlIGtlZXAgdGhlIGxpbnV4LXdwYW4gbGlzdCBpbiBDQy4gVGhpcyBhbGxv
d3MgbWUNCj4gdG8gdHJhY2sgcGF0Y2hlcyB3aXRoIHBhdGNod29yay4gQXBwbGllZCB0aGlzIG9u
ZSBtYW51YWxseS4NCkdvdCBpdCwgdGhhbmsgeW91fg0KPiBUaGlzIHBhdGNoIGhhcyBiZWVuIGFw
cGxpZWQgdG8gdGhlIHdwYW4gdHJlZSBhbmQgd2lsbCBiZSBwYXJ0IG9mIHRoZSBuZXh0IHB1bGwN
Cj4gcmVxdWVzdCB0byBuZXQuIFRoYW5rcyENCj4gDQo+IHJlZ2FyZHMNCj4gU3RlZmFuIFNjaG1p
ZHQNCg==
