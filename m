Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE02D9365
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 07:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438811AbgLNG5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 01:57:24 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2398 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438805AbgLNG5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 01:57:24 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4CvXGf5GBvz54nC;
        Mon, 14 Dec 2020 14:55:54 +0800 (CST)
Received: from DGGEMM421-HUB.china.huawei.com (10.1.198.38) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 14 Dec 2020 14:56:40 +0800
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 dggemm421-hub.china.huawei.com ([10.1.198.38]) with mapi id 14.03.0509.000;
 Mon, 14 Dec 2020 14:56:30 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
Thread-Topic: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
Thread-Index: AQHWziird30mYoLkpUK6A8EHcMEb7qnuUNCAgASAshCAANbLgIABp06AgAAg7ICAAAbUgIAAAIYAgAACxwCAALE6MA==
Date:   Mon, 14 Dec 2020 06:56:30 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB7EB3E@DGGEMM533-MBX.china.huawei.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
 <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
 <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com>
 <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com>
 <CAF=yD-+Hcg8cNo2qMfpGOWRORJskZR3cPPEE61neg7xFWkVh8w@mail.gmail.com>
 <CAF=yD-JHO3SaxaHAZJ8nZ1jy8Zp4hMt1EhP3abutA5zczgTv5g@mail.gmail.com>
 <3cfbcd25-f9ae-ea9b-fc10-80a44a614276@redhat.com>
In-Reply-To: <3cfbcd25-f9ae-ea9b-fc10-80a44a614276@redhat.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgRGVjZW1iZXIgMTQsIDIw
MjAgMTI6MDcgUE0NCj4gVG86IFdpbGxlbSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5l
bEBnbWFpbC5jb20+DQo+IENjOiB3YW5neXVuamlhbiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT47
IE1pY2hhZWwgUy4gVHNpcmtpbg0KPiA8bXN0QHJlZGhhdC5jb20+OyB2aXJ0dWFsaXphdGlvbkBs
aXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgTmV0d29yaw0KPiBEZXZlbG9wbWVudCA8bmV0ZGV2
QHZnZXIua2VybmVsLm9yZz47IExpbGlqdW4gKEplcnJ5KQ0KPiA8amVycnkubGlsaWp1bkBodWF3
ZWkuY29tPjsgY2hlbmNoYW5naHUgPGNoZW5jaGFuZ2h1QGh1YXdlaS5jb20+Ow0KPiB4dWRpbmdr
ZSA8eHVkaW5na2VAaHVhd2VpLmNvbT47IGh1YW5nYmluIChKKQ0KPiA8YnJpYW4uaHVhbmdiaW5A
aHVhd2VpLmNvbT47IFdpbGxlbSBkZSBCcnVpam4gPHdpbGxlbWJAZ29vZ2xlLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQgdjJdIHR1bjogZml4IHVidWYgcmVmY291bnQgaW5jb3JyZWN0
bHkgb24gZXJyb3IgcGF0aA0KPiANCj4gDQo+IE9uIDIwMjAvMTIvMTQg5LiK5Y2IMTE6NTYsIFdp
bGxlbSBkZSBCcnVpam4gd3JvdGU6DQo+ID4gT24gU3VuLCBEZWMgMTMsIDIwMjAgYXQgMTA6NTQg
UE0gV2lsbGVtIGRlIEJydWlqbg0KPiA+IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29t
PiB3cm90ZToNCj4gPj4gT24gU3VuLCBEZWMgMTMsIDIwMjAgYXQgMTA6MzAgUE0gSmFzb24gV2Fu
ZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gT24gMjAyMC8x
Mi8xNCDkuIrljYg5OjMyLCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3RlOg0KPiA+Pj4+IE9uIFNhdCwg
RGVjIDEyLCAyMDIwIGF0IDc6MTggUE0gV2lsbGVtIGRlIEJydWlqbg0KPiA+Pj4+IDx3aWxsZW1k
ZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPiB3cm90ZToNCj4gPj4+Pj4+Pj4gYWZ0ZXJ3YXJkcywg
dGhlIGVycm9yIGhhbmRsaW5nIGluIHZob3N0IGhhbmRsZV90eCgpIHdpbGwgdHJ5IHRvDQo+ID4+
Pj4+Pj4+IGRlY3JlYXNlIHRoZSBzYW1lIHJlZmNvdW50IGFnYWluLiBUaGlzIGlzIHdyb25nIGFu
ZCBmaXggdGhpcyBieQ0KPiA+Pj4+Pj4+PiBkZWxheSBjb3B5aW5nIHVidWZfaW5mbyB1bnRpbCB3
ZSdyZSBzdXJlIHRoZXJlJ3Mgbm8gZXJyb3JzLg0KPiA+Pj4+Pj4+IEkgdGhpbmsgdGhlIHJpZ2h0
IGFwcHJvYWNoIGlzIHRvIGFkZHJlc3MgdGhpcyBpbiB0aGUgZXJyb3INCj4gPj4+Pj4+PiBwYXRo
cywgcmF0aGVyIHRoYW4gY29tcGxpY2F0ZSB0aGUgbm9ybWFsIGRhdGFwYXRoLg0KPiA+Pj4+Pj4+
DQo+ID4+Pj4+Pj4gSXMgaXQgc3VmZmljaWVudCB0byBzdXBwcmVzcyB0aGUgY2FsbCB0byB2aG9z
dF9uZXRfdWJ1Zl9wdXQgaW4NCj4gPj4+Pj4+PiB0aGUgaGFuZGxlX3R4IHNlbmRtc2cgZXJyb3Ig
cGF0aCwgZ2l2ZW4gdGhhdA0KPiA+Pj4+Pj4+IHZob3N0X3plcm9jb3B5X2NhbGxiYWNrIHdpbGwg
YmUgY2FsbGVkIG9uIGtmcmVlX3NrYj8NCj4gPj4+Pj4+IFdlIGNhbiBub3QgY2FsbCBrZnJlZV9z
a2IoKSB1bnRpbCB0aGUgc2tiIHdhcyBjcmVhdGVkLg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+PiBPciBh
bHRlcm5hdGl2ZWx5IGNsZWFyIHRoZSBkZXN0cnVjdG9yIGluIGRyb3A6DQo+ID4+Pj4+PiBUaGUg
dWFyZy0+Y2FsbGJhY2soKSBpcyBjYWxsZWQgaW1tZWRpYXRlbHkgYWZ0ZXIgd2UgZGVjaWRlIGRv
DQo+ID4+Pj4+PiBkYXRhY29weSBldmVuIGlmIGNhbGxlciB3YW50IHRvIGRvIHplcm9jb3B5LiBJ
ZiBhbm90aGVyIGVycm9yDQo+ID4+Pj4+PiBvY2N1cnMgbGF0ZXIsIHRoZSB2aG9zdA0KPiA+Pj4+
Pj4gaGFuZGxlX3R4KCkgd2lsbCB0cnkgdG8gZGVjcmVhc2UgaXQgYWdhaW4uDQo+ID4+Pj4+IE9o
IHJpZ2h0LCBJIG1pc3NlZCB0aGUgZWxzZSBicmFuY2ggaW4gdGhpcyBwYXRoOg0KPiA+Pj4+Pg0K
PiA+Pj4+PiAgICAgICAgICAgLyogY29weSBza2JfdWJ1Zl9pbmZvIGZvciBjYWxsYmFjayB3aGVu
IHNrYiBoYXMgbm8gZXJyb3IgKi8NCj4gPj4+Pj4gICAgICAgICAgIGlmICh6ZXJvY29weSkgew0K
PiA+Pj4+PiAgICAgICAgICAgICAgICAgICBza2Jfc2hpbmZvKHNrYiktPmRlc3RydWN0b3JfYXJn
ID0gbXNnX2NvbnRyb2w7DQo+ID4+Pj4+ICAgICAgICAgICAgICAgICAgIHNrYl9zaGluZm8oc2ti
KS0+dHhfZmxhZ3MgfD0NCj4gU0tCVFhfREVWX1pFUk9DT1BZOw0KPiA+Pj4+PiAgICAgICAgICAg
ICAgICAgICBza2Jfc2hpbmZvKHNrYiktPnR4X2ZsYWdzIHw9DQo+IFNLQlRYX1NIQVJFRF9GUkFH
Ow0KPiA+Pj4+PiAgICAgICAgICAgfSBlbHNlIGlmIChtc2dfY29udHJvbCkgew0KPiA+Pj4+PiAg
ICAgICAgICAgICAgICAgICBzdHJ1Y3QgdWJ1Zl9pbmZvICp1YXJnID0gbXNnX2NvbnRyb2w7DQo+
ID4+Pj4+ICAgICAgICAgICAgICAgICAgIHVhcmctPmNhbGxiYWNrKHVhcmcsIGZhbHNlKTsNCj4g
Pj4+Pj4gICAgICAgICAgIH0NCj4gPj4+Pj4NCj4gPj4+Pj4gU28gaWYgaGFuZGxlX3R4X3plcm9j
b3B5IGNhbGxzIHR1bl9zZW5kbXNnIHdpdGggdWJ1Zl9pbmZvIChhbmQNCj4gPj4+Pj4gdGh1cyBh
IHJlZmVyZW5jZSB0byByZWxlYXNlKSwgdGhlcmUgYXJlIHRoZXNlIGZpdmUgb3B0aW9uczoNCj4g
Pj4+Pj4NCj4gPj4+Pj4gMS4gdHVuX3NlbmRtc2cgc3VjY2VlZHMsIHVidWZfaW5mbyBpcyBhc3Nv
Y2lhdGVkIHdpdGggc2tiLg0KPiA+Pj4+PiAgICAgICAgcmVmZXJlbmNlIHJlbGVhc2VkIGZyb20g
a2ZyZWVfc2tiIGNhbGxpbmcNCj4gPj4+Pj4gdmhvc3RfemVyb2NvcHlfY2FsbGJhY2sgbGF0ZXIN
Cj4gPj4+Pj4NCj4gPj4+Pj4gMi4gdHVuX3NlbmRtc2cgc3VjY2VlZHMsIHVidWZfaW5mbyBpcyBy
ZWxlYXNlZCBpbW1lZGlhdGVseSwgYXMgc2tiDQo+ID4+Pj4+IGlzIG5vdCB6ZXJvY29weS4NCj4g
Pj4+Pj4NCj4gPj4+Pj4gMy4gdHVuX3NlbmRtc2cgZmFpbHMgYmVmb3JlIGNyZWF0aW5nIHNrYiwg
aGFuZGxlX3R4X3plcm9jb3B5DQo+ID4+Pj4+IGNvcnJlY3RseSBjbGVhbnMgdXAgb24gcmVjZWl2
aW5nIGVycm9yIGZyb20gdHVuX3NlbmRtc2cuDQo+ID4+Pj4+DQo+ID4+Pj4+IDQuIHR1bl9zZW5k
bXNnIGZhaWxzIGFmdGVyIGNyZWF0aW5nIHNrYiwgYnV0IHdpdGggY29weWluZzoNCj4gPj4+Pj4g
ZGVjcmVtZW50ZWQgYXQgYnJhbmNoIHNob3duIGFib3ZlICsgYWdhaW4gaW4gaGFuZGxlX3R4X3pl
cm9jb3B5DQo+ID4+Pj4+DQo+ID4+Pj4+IDUuIHR1bl9zZW5kbXNnIGZhaWxzIGFmdGVyIGNyZWF0
aW5nIHNrYiwgd2l0aCB6ZXJvY29weToNCj4gPj4+Pj4gZGVjcmVtZW50ZWQgYXQga2ZyZWVfc2ti
IGluIGRyb3A6ICsgYWdhaW4gaW4gaGFuZGxlX3R4X3plcm9jb3B5DQo+ID4+Pj4+DQo+ID4+Pj4+
IFNpbmNlIGhhbmRsZV90eF96ZXJvY29weSBoYXMgbm8gaWRlYSB3aGV0aGVyIG9uIGVycm9yIDMs
IDQgb3IgNQ0KPiA+Pj4+PiBvY2N1cnJlZCwNCj4gPj4+PiBBY3R1YWxseSwgaXQgZG9lcy4gSWYg
c2VuZG1zZyByZXR1cm5zIGFuIGVycm9yLCBpdCBjYW4gdGVzdCB3aGV0aGVyDQo+ID4+Pj4gdnEt
PmhlYWRzW252cS0+dXBlbmRfaWR4XS5sZW4gIT0gVkhPU1RfRE1BX0lOX1BST0dSRVNTLg0KPiA+
Pj4NCj4gPj4+IEp1c3QgdG8gbWFrZSBzdXJlIEkgdW5kZXJzdGFuZCB0aGlzLiBBbnkgcmVhc29u
IGZvciBpdCBjYW4ndCBiZQ0KPiA+Pj4gVkhPU1RfRE1BX0lOX1BST0dSRVNTIGhlcmU/DQo+ID4+
IEl0IGNhbiBiZSwgYW5kIGl0IHdpbGwgYmUgaWYgdHVuX3NlbmRtc2cgcmV0dXJucyBFSU5WQUwg
YmVmb3JlDQo+ID4+IGFzc2lnbmluZyB0aGUgc2tiIGRlc3RydWN0b3IuDQo+ID4gSSBtZWFudCBy
ZXR1cm5zIGFuIGVycm9yLCBub3QgbmVjZXNzYXJpbHkgb25seSBFSU5WQUwuDQo+ID4NCj4gPj4g
T25seSBpZiB0dW5fc2VuZG1zZyByZWxlYXNlZCB0aGUgemVyb2NvcHkgc3RhdGUgdGhyb3VnaA0K
PiA+PiBrZnJlZV9za2ItPnZob3N0X3plcm9jb3B5X2NhbGxiYWNrIHdpbGwgaXQgaGF2ZSBiZWVu
IHVwZGF0ZWQgdG8NCj4gPj4gVkhPU1RfRE1BX0RPTkVfTEVOLiBBbmQgb25seSB0aGVuIG11c3Qg
dGhlIGNhbGxlciBub3QgdHJ5IHRvIHJlbGVhc2UNCj4gPj4gdGhlIHN0YXRlIGFnYWluLg0KPiA+
DQo+IA0KPiANCj4gSSBzZWUuIFNvIEkgdGVuZCB0byBmaXggdGhpcyBpbiB2aG9zdCBpbnN0ZWFk
IG9mIHR1biB0byBiZSBjb25zaXN0ZW50IHdpdGggdGhlDQo+IGN1cnJlbnQgZXJyb3IgaGFuZGxp
bmcgaW4gaGFuZGxlX3R4X3plcm9jb3B5KCkuDQoNCkFncmVlLCB0aGFua3MgZm9yIHRoZSBzdWdn
ZXN0aW9uLiANCkknbGwgc2VuZCB2MyBwYXRjaCBhY2NvcmRpbmcgdG8geW91ciBjb21tZW50cy4N
Cg0KPiANCj4gVGhhbmtzDQoNCg==
