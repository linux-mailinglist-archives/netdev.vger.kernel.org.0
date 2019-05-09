Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8389418931
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEILmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:42:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2953 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfEILmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 07:42:49 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id CB2EC76134EE808CBEE2;
        Thu,  9 May 2019 19:42:46 +0800 (CST)
Received: from DGGEML423-HUB.china.huawei.com (10.1.199.40) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 May 2019 19:42:46 +0800
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.161]) by
 dggeml423-hub.china.huawei.com ([10.1.199.40]) with mapi id 14.03.0439.000;
 Thu, 9 May 2019 19:42:37 +0800
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     yuehaibing <yuehaibing@huawei.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: RE: [PATCH net V3 2/2] tuntap: synchronize through tfiles array
 instead of tun->numqueues
Thread-Topic: [PATCH net V3 2/2] tuntap: synchronize through tfiles array
 instead of tun->numqueues
Thread-Index: AQHVBhYoSZ6ZRjg1Y0O4UWjtdsAfSKZirDbg
Date:   Thu, 9 May 2019 11:42:36 +0000
Message-ID: <6AADFAC011213A4C87B956458587ADB40221319A@dggeml532-mbs.china.huawei.com>
References: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
 <1557372018-18544-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1557372018-18544-2-git-send-email-jasowang@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.30.138]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIE1heSAwOSwgMjAxOSAxMToy
MCBBTQ0KPiBUbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogeXVlaGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPjsgeGl5b3Uu
d2FuZ2NvbmdAZ21haWwuY29tOw0KPiB3ZWl5b25nanVuIChBKSA8d2VpeW9uZ2p1bjFAaHVhd2Vp
LmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IEphc29uIFdhbmcgPGphc293YW5nQHJl
ZGhhdC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQgVjMgMi8yXSB0dW50YXA6IHN5bmNocm9u
aXplIHRocm91Z2ggdGZpbGVzIGFycmF5IGluc3RlYWQNCj4gb2YgdHVuLT5udW1xdWV1ZXMNCj4g
DQo+IFdoZW4gYSBxdWV1ZSh0ZmlsZSkgaXMgZGV0YWNoZWQgdGhyb3VnaCBfX3R1bl9kZXRhY2go
KSwgd2UgbW92ZSB0aGUNCj4gbGFzdCBlbmFibGVkIHRmaWxlIHRvIHRoZSBwb3NpdGlvbiB3aGVy
ZSBkZXRhY2hlZCBvbmUgc2l0IGJ1dCBkb24ndA0KPiBOVUxMIG91dCBsYXN0IHBvc2l0aW9uLiBX
ZSBleHBlY3QgdG8gc3luY2hyb25pemUgdGhlIGRhdGFwYXRoIHRocm91Z2gNCj4gdHVuLT5udW1x
dWV1ZXMuIFVuZm9ydHVuYXRlbHksIHRoaXMgd29uJ3Qgd29yayBzaW5jZSB3ZSdyZSBsYWNraW5n
DQo+IHN1ZmZpY2llbnQgbWVjaGFuaXNtIHRvIG9yZGVyIG9yIHN5bmNocm9uaXplIHRoZSBhY2Nl
c3MgdG8NCj4gdHVuLT5udW1xdWV1ZXMuDQo+IA0KPiBUbyBmaXggdGhpcywgTlVMTCBvdXQgdGhl
IGxhc3QgcG9zaXRpb24gZHVyaW5nIGRldGFjaGluZyBhbmQgY2hlY2sNCj4gUkNVIHByb3RlY3Rl
ZCB0ZmlsZSBhZ2FpbnN0IE5VTEwgaW5zdGVhZCBvZiBjaGVja2luZyB0dW4tPm51bXF1ZXVlcyBp
bg0KPiBkYXRhcGF0aC4NCj4gDQo+IENjOiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5j
b20+DQo+IENjOiBDb25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4NCj4gQ2M6IHdl
aXlvbmdqdW4gKEEpIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPg0KPiBDYzogRXJpYyBEdW1hemV0
IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBGaXhlczogYzhkNjhlNmJlMWMzYiAoInR1bnRh
cDogbXVsdGlxdWV1ZSBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogSmFzb24gV2FuZyA8amFz
b3dhbmdAcmVkaGF0LmNvbT4NCj4gLS0tDQo+IENoYW5nZXMgZnJvbSBWMjoNCj4gLSByZXNhbXBs
ZSBkdXJpbmcgZGV0YWNoIGluIHR1bl94ZHBfeG1pdCgpDQo+IENoYW5nZXMgZnJvbSBWMToNCj4g
LSBrZWVwIHRoZSBjaGVjayBpbiB0dW5feGRwX3htaXQoKQ0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6
IFdlaSBZb25nanVuIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPg0KDQpUaGFua3MNCg==
