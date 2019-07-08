Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F37F61C4D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfGHJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:18:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:27536 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728557AbfGHJSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:18:33 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-103-2xhe-QRYPc6LXjWhlktUtw-1; Mon, 08 Jul 2019 10:18:30 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 8 Jul 2019 10:18:29 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Jul 2019 10:18:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tony Chuang' <yhchuang@realtek.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Topic: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Index: AQHVNVeEF2VH1aWcW0SX/aCCs+qgc6bAR+xA//+PoICAAIn6kIAADM1A
Date:   Mon, 8 Jul 2019 09:18:28 +0000
Message-ID: <85e3b48ee6694aa491c7caa73c027e0f@AcuMS.aculab.com>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
 <F7CD281DE3E379468C6D07993EA72F84D1861A6D@RTITMBSVM04.realtek.com.tw>
 <CAPpJ_eebQtL0y_j98J2T7m9g77A61SVtvD8qnNN42bV0dm4MLA@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D1861B71@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1861B71@RTITMBSVM04.realtek.com.tw>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 2xhe-QRYPc6LXjWhlktUtw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9ueSBDaHVhbmcNCj4gU2VudDogMDggSnVseSAyMDE5IDEwOjAwDQo+ID4gPiA+IEBA
IC04MDMsMjUgKzgxMiwxNCBAQCBzdGF0aWMgdm9pZCBydHdfcGNpX3J4X2lzcihzdHJ1Y3QgcnR3
X2Rldg0KPiA+ICpydHdkZXYsDQo+ID4gPiA+IHN0cnVjdCBydHdfcGNpICpydHdwY2ksDQo+ID4g
PiA+ICAgICAgICAgICAgICAgICAgICAgICBza2JfcHV0KHNrYiwgcGt0X3N0YXQucGt0X2xlbik7
DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBza2JfcmVzZXJ2ZShza2IsIHBrdF9vZmZz
ZXQpOw0KPiA+ID4gPg0KPiA+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgLyogYWxsb2MgYSBz
bWFsbGVyIHNrYiB0byBtYWM4MDIxMSAqLw0KPiA+ID4gPiAtICAgICAgICAgICAgICAgICAgICAg
bmV3ID0gZGV2X2FsbG9jX3NrYihwa3Rfc3RhdC5wa3RfbGVuKTsNCj4gPiA+ID4gLSAgICAgICAg
ICAgICAgICAgICAgIGlmICghbmV3KSB7DQo+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIG5ldyA9IHNrYjsNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7
DQo+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYl9wdXRfZGF0YShuZXcs
IHNrYi0+ZGF0YSwNCj4gPiBza2ItPmxlbik7DQo+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGRldl9rZnJlZV9za2JfYW55KHNrYik7DQo+ID4gPiA+IC0gICAgICAgICAgICAg
ICAgICAgICB9DQo+ID4gPg0KPiA+ID4gSSBhbSBub3Qgc3VyZSBpZiBpdCdzIGZpbmUgdG8gZGVs
aXZlciBldmVyeSBodWdlIFNLQiB0byBtYWM4MDIxMS4NCj4gPiA+IEJlY2F1c2UgaXQgd2lsbCB0
aGVuIGJlIGRlbGl2ZXJlZCB0byBUQ1AvSVAgc3RhY2suDQo+ID4gPiBIZW5jZSBJIHRoaW5rIGVp
dGhlciBpdCBzaG91bGQgYmUgdGVzdGVkIHRvIGtub3cgaWYgdGhlIHBlcmZvcm1hbmNlDQo+ID4g
PiB3b3VsZCBiZSBpbXBhY3RlZCBvciBmaW5kIG91dCBhIG1vcmUgZWZmaWNpZW50IHdheSB0byBz
ZW5kDQo+ID4gPiBzbWFsbGVyIFNLQiB0byBtYWM4MDIxMSBzdGFjay4NCj4gPg0KPiA+IEkgcmVt
ZW1iZXIgbmV0d29yayBzdGFjayBvbmx5IHByb2Nlc3NlcyB0aGUgc2tiIHdpdGgoaW4pIHBvaW50
ZXJzDQo+ID4gKHNrYi0+ZGF0YSkgYW5kIHRoZSBza2ItPmxlbiBmb3IgZGF0YSBwYXJ0LiAgSXQg
YWxzbyBjaGVja3MgcmVhbA0KPiA+IGJ1ZmZlciBib3VuZGFyeSAoaGVhZCBhbmQgZW5kKSBvZiB0
aGUgc2tiIHRvIHByZXZlbnQgbWVtb3J5IG92ZXJmbG93Lg0KPiA+IFRoZXJlZm9yZSwgSSB0aGlu
ayB1c2luZyB0aGUgb3JpZ2luYWwgc2tiIGlzIHRoZSBtb3N0IGVmZmljaWVudCB3YXkuDQo+ID4N
Cj4gPiBJZiBJIG1pc3VuZGVyc3RhbmQgc29tZXRoaW5nLCBwbGVhc2UgcG9pbnQgb3V0Lg0KPiA+
DQo+IA0KPiBJdCBtZWFucyBpZiB3ZSBzdGlsbCB1c2UgYSBodWdlIFNLQiAofjhLKSBmb3IgZXZl
cnkgUlggcGFja2V0ICh+MS41SykuDQo+IFRoZXJlIGlzIGFib3V0IDYuNUsgbm90IHVzZWQuIEFu
ZCBldmVuIG1vcmUgaWYgd2UgcGluZyB3aXRoIGxhcmdlIHBhY2tldA0KPiBzaXplICJlZy4gJCBw
aW5nIC1zIDY1NTM2IiwgSSBhbSBub3Qgc3VyZSBpZiB0aG9zZSBodWdlIFNLQnMgd2lsbCBlYXQg
YWxsIG9mDQo+IHRoZSBTS0IgbWVtIHBvb2wsIGFuZCB0aGVuIHBpbmcgZmFpbHMuDQo+IA0KPiBC
VFcsIHRoZSBvcmlnaW5hbCBkZXNpZ24gb2YgUlRLX1BDSV9SWF9CVUZfU0laRSB0byBiZSAoODE5
MiArIDI0KSBpcyB0bw0KPiByZWNlaXZlIEFNU0RVIHBhY2tldCBpbiBvbmUgU0tCLg0KPiAoQ291
bGQgcHJvYmFibHkgZW5sYXJnZSBpdCB0byBSWCBWSFQgQU1TRFUgfjExSykNCg0KSWYgeW91IGFs
bG9jYXRlIDgxOTIrMjQgdGhlIG1lbW9yeSBhbGxvY2F0ZWQgd2lsbCBiZSBlaXRoZXIgMTJrIG9y
IDE2aw0KYW5kIHRoZSBza2IgdHJ1ZXNpemUgc2V0IGFwcHJvcHJpYXRlbHkuDQooUHJvYmFibHkg
MTZrIGlmIGRtYSBtZW1vcnkuKQ0KSWYgdGhpcyBpcyBmZWQgaW50byBJUCBpdCBpcyBxdWl0ZSBs
aWtlbHkgdGhhdCBhIHNpbmdsZSBieXRlIG9mIGRhdGENCndpbGwgZW5kIHVwIHF1ZXVlZCBvbiB0
aGUgc29ja2V0IGluIDE2ayBvZiBkbWEtYWJsZSBtZW1vcnkuDQpUaGUgJ3RydWVzaXplJyBzdG9w
cyB0aGlzIHVzaW5nIGFsbCB0aGUgc3lzdGVtIG1lbW9yeSwgYnV0IGl0IGlzbid0DQpnb29kIGZv
ciBtZW1vcnkgdXNhZ2UuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

