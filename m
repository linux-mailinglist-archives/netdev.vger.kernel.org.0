Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0813323E7
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCILZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:25:11 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3465 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCILYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:24:37 -0500
Received: from nkgeml704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Dvt9M1Kxrz5bBJ;
        Tue,  9 Mar 2021 19:22:47 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 nkgeml704-chm.china.huawei.com (10.98.57.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 19:24:33 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2106.013;
 Tue, 9 Mar 2021 19:24:33 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldC9zY2hlZDogYWN0X3BlZGl0OiBmaXggYSBO?=
 =?utf-8?B?VUxMIHBvaW50ZXIgZGVyZWYgaW4gdGNmX3BlZGl0X2luaXQ=?=
Thread-Topic: [PATCH] net/sched: act_pedit: fix a NULL pointer deref in
 tcf_pedit_init
Thread-Index: AQHXFJb9vwHGuFFSMU2mG2QNfuh8DKp61BiAgACm8dA=
Date:   Tue, 9 Mar 2021 11:24:33 +0000
Message-ID: <672f06766f2d49ecbb573037b3cb445a@huawei.com>
References: <20210309034736.8656-1-zhudi21@huawei.com>
 <07afbd8d9a76f3c0f0a0eb01759118a0c9e966a3.camel@redhat.com>
In-Reply-To: <07afbd8d9a76f3c0f0a0eb01759118a0c9e966a3.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gaGVsbG8sIHRoYW5rcyBmb3IgdGhlIHBhdGNoIQ0KPiANCj4gT24gVHVlLCAyMDIxLTAz
LTA5IGF0IDExOjQ3ICswODAwLCB6aHVkaSB3cm90ZToNCj4gPiBGcm9tOiBEaSBaaHUgPHpodWRp
MjFAaHVhd2VpLmNvbT4NCj4gPg0KPiA+IHdoZW4gd2UgdXNlIHN5emthbGxlciB0byBmdXp6LXRl
c3Qgb3VyIGtlcm5lbCwgb25lIE5VTEwgcG9pbnRlcg0KPiBkZXJlZmVyZW5jZQ0KPiA+IEJVRyBo
YXBwZW5lZDoNCj4gPg0KPiA+IFdyaXRlIG9mIHNpemUgOTYgYXQgYWRkciAwMDAwMDAwMDAwMDAw
MDEwIGJ5IHRhc2sgc3l6LWV4ZWN1dG9yLjAvMjIzNzYNCj4gPg0KPiA9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ID09PT09PT09DQo+ID4g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQN
Cj4gMDAwMDAwMDAwMDAwMDAxMA0KPiA+IFBHRCA4MDAwMDAwMWRjMWE5MDY3IFA0RCA4MDAwMDAw
MWRjMWE5MDY3IFBVRCAxYTMyYjUwNjcgUE1EIDANCj4gPiBbLi4uXQ0KPiA+IENhbGwgVHJhY2UN
Cj4gPiBtZW1jcHkgIGluY2x1ZGUvbGludXgvc3RyaW5nLmg6MzQ1IFtpbmxpbmVdDQo+ID4gdGNm
X3BlZGl0X2luaXQrMHg3YjQvMHhhMTAgbmV0L3NjaGVkL2FjdF9wZWRpdC5jOjIzMg0KPiA+IHRj
Zl9hY3Rpb25faW5pdF8xKzB4NTliLzB4NzMwICBuZXQvc2NoZWQvYWN0X2FwaS5jOjkyMA0KPiA+
IHRjZl9hY3Rpb25faW5pdCsweDFlZi8weDMyMCAgbmV0L3NjaGVkL2FjdF9hcGkuYzo5NzUNCj4g
PiB0Y2ZfYWN0aW9uX2FkZCsweGQyLzB4MjcwICBuZXQvc2NoZWQvYWN0X2FwaS5jOjEzNjANCj4g
PiB0Y19jdGxfYWN0aW9uKzB4MjY3LzB4MjkwICBuZXQvc2NoZWQvYWN0X2FwaS5jOjE0MTINCj4g
PiBbLi4uXQ0KPiA+DQo+ID4gVGhlIHJvb3QgY2F1c2UgaXMgdGhhdCB3ZSB1c2Uga21hbGxvYygp
IHRvIGFsbG9jYXRlIG1lbSBzcGFjZSBmb3INCj4gPiBrZXlzIHdpdGhvdXQgY2hlY2tpbmcgaWYg
dGhlIGtzaXplIGlzIDAuDQo+IA0KPiBhY3R1YWxseSBMaW51eCBkb2VzIHRoaXM6DQo+IA0KPiAx
NzMgICAgICAgICBwYXJtID0gbmxhX2RhdGEocGF0dHIpOw0KPiAxNzQgICAgICAgICBpZiAoIXBh
cm0tPm5rZXlzKSB7DQo+IDE3NSAgICAgICAgICAgICAgICAgTkxfU0VUX0VSUl9NU0dfTU9EKGV4
dGFjaywgIlBlZGl0IHJlcXVpcmVzIGtleXMgdG8gYmUNCj4gcGFzc2VkIik7DQo+IDE3NiAgICAg
ICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+IDE3NyAgICAgICAgIH0NCj4gMTc4ICAgICAg
ICAga3NpemUgPSBwYXJtLT5ua2V5cyAqIHNpemVvZihzdHJ1Y3QgdGNfcGVkaXRfa2V5KTsNCj4g
MTc5ICAgICAgICAgaWYgKG5sYV9sZW4ocGF0dHIpIDwgc2l6ZW9mKCpwYXJtKSArIGtzaXplKSB7
DQo+IDE4MCAgICAgICAgICAgICAgICAgTkxfU0VUX0VSUl9NU0dfQVRUUihleHRhY2ssIHBhdHRy
LCAiTGVuZ3RoIG9mDQo+IFRDQV9QRURJVF9QQVJNUyBvciBUQ0FfUEVESVRfUEFSTVNfRVggcGVk
aXQgYXR0cmlidXRlIGlzIGludmFsaWQiKTsNCj4gMTgxICAgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gMTgyICAgICAgICAgfQ0KPiANCj4gbWF5YmUgaXQncyBub3Qgc3VmZmljaWVu
dD8gSWYgc28sIHdlIGNhbiBhZGQgc29tZXRoaW5nIGhlcmUuIEknZCBwcmVmZXINCj4gdG8gZGlz
YWxsb3cgaW5zZXJ0aW5nIHBlZGl0IGFjdGlvbnMgd2l0aCBwLT50Y2ZwX25rZXlzIGVxdWFsIHRv
IHplcm8sDQo+IGJlY2F1c2UgdGhleSBhcmUgZ29pbmcgdG8gdHJpZ2dlciBhIFdBUk4oMSkgaW4g
dGhlIHRyYWZmaWMgcGF0aCAoc2VlDQo+IHRjZl9wZWRpdF9hY3QoKSBhdCB0aGUgYm90dG9tKS4N
Cg0KWWVzLCB5b3UgYXJlIHJpZ2h0LiAgSSBkaWRuJ3Qgbm90aWNlIHlvdXIgY29kZSBzdWJtaXNz
aW9uKGNvbW1pdC1pZCBpcyBmNjcxNjlmZWY4ZGJjYzFhKSBpbiAyMDE5IA0KYW5kIHRoZSBrZXJu
ZWwgd2UgdGVzdGVkIGlzIGEgYml0IG9sZC4gTm9ybWFsbHksICB5b3VyIGNvZGUgc3VibWlzc2lv
biBjYW4gYXZvaWQgdGhpcyBidWcuDQoNCj4gDQo+IFRoZW4sIHdlIGNhbiBhbHNvIHJlbW92ZSBh
bGwgdGhlIHRlc3RzIG9uIHRoZSBwb3NpdGl2ZW5lc3Mgb2YgdGNmcF9ua2V5cw0KPiBhbmQgdGhl
IG9uZSB5b3UgcmVtb3ZlZCB3aXRoIHlvdXIgcGF0Y2guIFdEWVQ/DQoNClllcywgIHJlbW92ZSB0
ZXN0cyBvbiB0aGUgcG9zaXRpdmVuZXNzIG9mIHRjZnBfbmtleXMgaW4gdGhpcyBjYXNlIGNhbiBh
bHNvIG1ha2UgY29kZSBtb3JlIHJvYnVzdCwNCkluIHBhcnRpY3VsYXIsICBhdCBzb21lIGFibm9y
bWFsIHNpdHVhdGlvbnMuIFNob3VsZCB3ZSBkbyBpdCBub3c/DQoNCiBJIHdpbGwgcmV0ZXN0IHdp
dGggeW91ciBjb2RlIG1lcmdlZCwgIHRoYW5rcy4NCg0KPiANCj4gdGhhbmtzLA0KPiAtLQ0KPiBk
YXZpZGUNCg0K
