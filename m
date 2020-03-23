Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA4918ED77
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 01:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgCWA2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 20:28:04 -0400
Received: from mx.socionext.com ([202.248.49.38]:56886 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgCWA2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 20:28:03 -0400
Received: from unknown (HELO iyokan-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 23 Mar 2020 09:28:02 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan-ex.css.socionext.com (Postfix) with ESMTP id 6621C60057;
        Mon, 23 Mar 2020 09:28:02 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Mon, 23 Mar 2020 09:28:02 +0900
Received: from SOC-EX01V.e01.socionext.com (10.213.24.21) by
 SOC-EX02V.e01.socionext.com (10.213.24.22) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Mon, 23 Mar 2020 09:28:01 +0900
Received: from SOC-EX01V.e01.socionext.com ([10.213.24.21]) by
 SOC-EX01V.e01.socionext.com ([10.213.24.21]) with mapi id 15.00.0995.028;
 Mon, 23 Mar 2020 09:28:01 +0900
From:   <ye.zh-yuan@socionext.com>
To:     <vinicius.gomes@intel.com>, <netdev@vger.kernel.org>
CC:     <okamoto.satoru@socionext.com>, <kojima.masahisa@socionext.com>
Subject: RE: [PATCH net] net: cbs: Fix software cbs to consider packet
Thread-Topic: [PATCH net] net: cbs: Fix software cbs to consider packet
Thread-Index: AQHV/cPd3HEarPEmcEi6peG0pdJCJ6hPkByAgAXD/YA=
Date:   Mon, 23 Mar 2020 00:28:01 +0000
Message-ID: <3b41013298dd40638e3d0465d8325ff6@SOC-EX01V.e01.socionext.com>
References: <20200319075659.3126-1-ye.zh-yuan@socionext.com>
 <87lfnwfeyw.fsf@intel.com>
In-Reply-To: <87lfnwfeyw.fsf@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.1
x-shieldmailcheckerpolicyversion: POLICY200130
x-originating-ip: [10.213.24.1]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50LCANCkknbGwgcHJvdmlkZSB2
MiBwYXRjaCBhcyBzb29uIGFzIHBvc3NpYmxlLg0KDQpCUg0KLS0NClllDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmluaWNpdXMgQ29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVz
QGludGVsLmNvbT4gDQpTZW50OiBGcmlkYXksIE1hcmNoIDIwLCAyMDIwIDI6MTAgQU0NClRvOiBZ
ZSwgWmgtWXVhbi8bJEJNVRsoQiAbJEJDVzFzGyhCIDx5ZS56aC15dWFuQHNvY2lvbmV4dC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQpDYzogT2thbW90bywgU2F0b3J1LxskQjIsS1wbKEIg
GyRCTSEbKEIgPG9rYW1vdG8uc2F0b3J1QHNvY2lvbmV4dC5jb20+OyBLb2ppbWEsIE1hc2FoaXNh
LxskQj4uRWcbKEIgGyRCMm01VxsoQiA8a29qaW1hLm1hc2FoaXNhQHNvY2lvbmV4dC5jb20+OyBZ
ZSwgWmgtWXVhbi8bJEJNVRsoQiAbJEJDVzFzGyhCIDx5ZS56aC15dWFuQHNvY2lvbmV4dC5jb20+
DQpTdWJqZWN0OiBSZTogW1BBVENIIG5ldF0gbmV0OiBjYnM6IEZpeCBzb2Z0d2FyZSBjYnMgdG8g
Y29uc2lkZXIgcGFja2V0DQoNCkhpLA0KDQpaaC15dWFuIFllIDx5ZS56aC15dWFuQHNvY2lvbmV4
dC5jb20+IHdyaXRlczoNCg0KPiBDdXJyZW50bHkgdGhlIHNvZnR3YXJlIENCUyBkb2VzIG5vdCBj
b25zaWRlciB0aGUgcGFja2V0IHNlbmRpbmcgdGltZSANCj4gd2hlbiBkZXBsZXRpbmcgdGhlIGNy
ZWRpdHMuIEl0IGNhdXNlZCB0aGUgdGhyb3VnaHB1dCB0byBiZSANCj4gSWRsZXNsb3BlW2ticHNd
ICogKFBvcnQgdHJhbnNtaXQgcmF0ZVtrYnBzXSAvIHxTZW5kc2xvcGVba2Jwc118KSB3aGVyZSAN
Cj4gSWRsZXNsb3BlICogKFBvcnQgdHJhbnNtaXQgcmF0ZSAvIChJZGxlc2xvcGUgKyB8U2VuZHNs
b3BlfCkpIGlzIGV4cGVjdGVkLg0KPiBJbiBvcmRlciB0byBmaXggdGhlIGlzc3VlIGFib3ZlLCB0
aGlzIHBhdGNoIHRha2VzIHRoZSB0aW1lIHdoZW4gdGhlIA0KPiBwYWNrZXQgc2VuZGluZyBjb21w
bGV0ZXMgaW50byBhY2NvdW50IGJ5IG1vdmluZyB0aGUgYW5jaG9yIHRpbWUgDQo+IHZhcmlhYmxl
ICJsYXN0IiBhaGVhZCB0byB0aGUgc2VuZCBjb21wbGV0aW9uIHRpbWUgdXBvbiB0cmFuc21pc3Np
b24gDQo+IGFuZCBhZGRpbmcgd2FpdCB3aGVuIHRoZSBuZXh0IGRlcXVldWUgcmVxdWVzdCBjb21l
cyBiZWZvcmUgdGhlIHNlbmQgDQo+IGNvbXBsZXRpb24gdGltZSBvZiB0aGUgcHJldmlvdXMgcGFj
a2V0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBaaC15dWFuIFllIDx5ZS56aC15dWFuQHNvY2lvbmV4
dC5jb20+DQo+IC0tLQ0KDQpZb3UgcmFpc2UgZ29vZCBwb2ludHMgaGVyZS4NCg0KV2hhdCBJIGFt
IHRoaW5raW5nIGlzIHRoYXQgcGVyaGFwcyB3ZSBjb3VsZCByZXBsYWNlICdxLT5sYXN0JyBieSB0
aGlzICdzZW5kX2NvbXBsZXRlZCcgaWRlYSwgdGhlbiB3ZSBjb3VsZCBoYXZlIGEgbW9yZSBwcmVj
aXNlIHNvZnR3YXJlIG1vZGUgd2hlbiB3ZSB0YWtlIGludG8gYWNjb3VudCB3aGVuIHdlIGRlcXVl
dWUgdGhlICJsYXN0IGJ5dGUiIG9mIHRoZSBwYWNrZXQuDQoNCj4gIG5ldC9zY2hlZC9zY2hfY2Jz
LmMgfCAxMCArKysrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL3NjaF9jYnMuYyBiL25l
dC9zY2hlZC9zY2hfY2JzLmMgaW5kZXggDQo+IGIyOTA1YjAzYTQzMi4uYTc4YjhhNzUwYmQ5IDEw
MDY0NA0KPiAtLS0gYS9uZXQvc2NoZWQvc2NoX2Nicy5jDQo+ICsrKyBiL25ldC9zY2hlZC9zY2hf
Y2JzLmMNCj4gQEAgLTcxLDYgKzcxLDcgQEAgc3RydWN0IGNic19zY2hlZF9kYXRhIHsNCj4gIAlp
bnQgcXVldWU7DQo+ICAJYXRvbWljNjRfdCBwb3J0X3JhdGU7IC8qIGluIGJ5dGVzL3MgKi8NCj4g
IAlzNjQgbGFzdDsgLyogdGltZXN0YW1wIGluIG5zICovDQo+ICsJczY0IHNlbmRfY29tcGxldGVk
OyAvKiB0aW1lc3RhbXAgaW4gbnMgKi8NCg0KU28sIG15IHN1Z2dlc3Rpb24gaXMgdG8gcmVwbGFj
ZSAnbGFzdCcgYnkgdGhlICdzZW5kX2NvbXBsZXRlZCcgY29uY2VwdC4NCg0KQW5kIGFzIGFuIG9w
dGlvbmFsIHN1Z2dlc3Rpb24sIEkgdGhpbmsgdGhhdCBjaGFuZ2luZyB0aGUgJ2xhc3QnIG5hbWUg
Ynkgc29tZXRoaW5nIGxpa2UgJ2xhc3RfYnl0ZScgd2l0aCBhIGNvbW1lbnQgc2F5aW5nICJlc3Rp
bWF0ZSBvZiB0aGUgdHJhbnNtaXNzaW9uIG9mIHRoZSBsYXN0IGJ5dGUgb2YgdGhlIHBhY2tldCwg
aW4gbnMiIGNvdWxkIGJlIHdvcnRoIHRoaW5raW5nIGFib3V0Lg0KDQpEbyB5b3Ugc2VlIGFueSBw
cm9ibGVtcz8NCg0KDQpDaGVlcnMsDQotLQ0KVmluaWNpdXMNCg==
