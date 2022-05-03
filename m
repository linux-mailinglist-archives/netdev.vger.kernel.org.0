Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F40517C50
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiECDzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 23:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiECDzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 23:55:54 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399EE2A725
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 20:52:22 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B474A2C01AE
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 03:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651549939;
        bh=EAe7ZoNVIDsZwJZl/ZJoFtTPUJtDHdWwoiytOTSWoIw=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=J2GZxVXX2Dppm/H8dpOtkZI6no3YfyOz2F3rXVyHru9J3B6EI2/wwa5NyfjgPS1oZ
         ZIC+TVb+d3YYtxCm7P1KOJXA/8InhImkuucinzTTnj38kZ4RQctAxfCpsh6uLOH1QH
         9d6rs75hJPprBT5R17IBxLB9/VHkEONjA/BPeecDChsJ3lewiRN8s0NyVHPdqPpcQf
         x9u0M5zRFZ61yJ5UL4eAFEe0HtsFCgYHc+6lkL6m3RR5vCKohQKPl6qPk4+Pf0KsZw
         Ny+mMD3GV9QYaVp1gZND7gtipsx4LjBX0763RE50VOwXiV2Hek8e6se2b9tphGtmyX
         5GfUEu8oeLUDQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6270a6f30000>; Tue, 03 May 2022 15:52:19 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 3 May 2022 15:52:19 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 3 May 2022 15:52:19 +1200
From:   Lokesh Dhoundiyal <Lokesh.Dhoundiyal@alliedtelesis.co.nz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Regarding _skb_refdst memory alloc/dealloc
Thread-Topic: Regarding _skb_refdst memory alloc/dealloc
Thread-Index: AQHYXptHGnZS9egJZ0yWppkefboFgq0Lu/0A
Date:   Tue, 3 May 2022 03:52:19 +0000
Message-ID: <e70f459d-10d3-f91c-d087-d62daa1446b7@alliedtelesis.co.nz>
References: <53f2dbc3-3562-6d91-978e-63392010a668@alliedtelesis.co.nz>
In-Reply-To: <53f2dbc3-3562-6d91-978e-63392010a668@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.16.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5649FF897A1384BA4404BEDCB2A7A1A@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=8KpF8ikWtqQA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=9q0LmSY1F0xOyuPSZOcA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClNvcnJ5IGZvciBteSByZXBlYXRlZCBlbWFpbHMuDQoNClRvIGFkZCBzb21lIGJhY2tn
cm91bmQgdG8gbXkgZWFybGllciBtZXNzYWdlIGFuZCBnZXQgc29tZSBhZHZpc2Ugb24gdGhpbmdz
Lg0KDQpXaGlsZSB0ZXN0aW5nIHRoZSBzY2VuYXJpbyBvZiBHUkUgb3ZlciBJUHNlYyB3aXRoIHJv
dXRpbmcgdGFibGUgbGVhcm5lZCANCnZpYSBkeW5hbWljIHByb3RvY29sIChPU1BGKSB3ZSBoYXZl
IG9ic2VydmVkIHRoZSBiZWxvdyBtZW50aW9uZWQgbGVhay4NCg0KS21lbWxlYWsgb3V0cHV0Og0K
dW5yZWZlcmVuY2VkIG9iamVjdCAweDgwMDAwMDAwNDRiZWJiMDAgKHNpemUgMjU2KToNCiDCoCBj
b21tICJzb2Z0aXJxIiwgcGlkIDAsIGppZmZpZXMgNDI5NDk4NTM1NiAoYWdlIDEyNi44MTBzKQ0K
IMKgIGhleCBkdW1wIChmaXJzdCAzMiBieXRlcyk6DQogwqDCoMKgIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDgwIDAwIDAwIDAwIDA1IDEzIDc0IDgwIC4uLi4uLi4uLi4uLi4udC4NCiDCoMKgwqAg
ODAgMDAgMDAgMDAgMDQgOWIgYmYgZjkgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgLi4uLi4uLi4u
Li4uLi4uLg0KIMKgIGJhY2t0cmFjZToNCiDCoMKgwqAgWzwwMDAwMDAwMGY4Mzk0N2UwPl0gX19r
bWFsbG9jKzB4MWU4LzB4MzAwDQogwqDCoMKgIFs8MDAwMDAwMDBiN2VkOGRjYT5dIG1ldGFkYXRh
X2RzdF9hbGxvYysweDI0LzB4NTgNCiDCoMKgwqAgWzwwMDAwMDAwMDgxZDMyYzIwPl0gX19pcGdy
ZV9yY3YrMHgxMDAvMHgyYjgNCiDCoMKgwqAgWzwwMDAwMDAwMDgyNGY2Y2YxPl0gZ3JlX3Jjdisw
eDE3OC8weDU0MA0KIMKgwqDCoCBbPDAwMDAwMDAwY2NkNGUxNjI+XSBncmVfcmN2KzB4N2MvMHhk
OA0KIMKgwqDCoCBbPDAwMDAwMDAwYzAyNGIxNDg+XSBpcF9wcm90b2NvbF9kZWxpdmVyX3JjdSsw
eDEyNC8weDM1MA0KIMKgwqDCoCBbPDAwMDAwMDAwNmE0ODMzNzc+XSBpcF9sb2NhbF9kZWxpdmVy
X2ZpbmlzaCsweDU0LzB4NjgNCiDCoMKgwqAgWzwwMDAwMDAwMGQ5MjcxYjNhPl0gaXBfbG9jYWxf
ZGVsaXZlcisweDEyOC8weDE2OA0KIMKgwqDCoCBbPDAwMDAwMDAwYmQ0OTY4YWU+XSB4ZnJtX3Ry
YW5zX3JlaW5qZWN0KzB4YjgvMHhmOA0KIMKgwqDCoCBbPDAwMDAwMDAwNzE2NzJhMTk+XSB0YXNr
bGV0X2FjdGlvbl9jb21tb24uaXNyYS4xNisweGM0LzB4MWIwDQogwqDCoMKgIFs8MDAwMDAwMDA2
MmU5YzMzNj5dIF9fZG9fc29mdGlycSsweDFmYy8weDNlMA0KIMKgwqDCoCBbPDAwMDAwMDAwMDEz
ZDc5MTQ+XSBpcnFfZXhpdCsweGM0LzB4ZTANCiDCoMKgwqAgWzwwMDAwMDAwMGE0ZDczZTkwPl0g
cGxhdF9pcnFfZGlzcGF0Y2grMHg3Yy8weDEwOA0KIMKgwqDCoCBbPDAwMDAwMDAwMDc1MWViOGU+
XSBoYW5kbGVfaW50KzB4MTZjLzB4MTc4DQogwqDCoMKgIFs8MDAwMDAwMDAxNjY4MDIzYj5dIF9y
YXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDFjLzB4MjgNCg0KSW52ZXN0aWdhdGlvbiBpbmRp
Y2F0ZWQgdGhhdCB0aGUgY2hhbmdlIHRvIHRoZSAiaWYiIHN0YXRlbWVudCBpbiB0aGUgDQpjb21t
aXQgYzBkNTlkYTc5NTM0IHJlc3VsdHMgaW4gdGhlIGFsbG9jYXRpb24gYW5kIGFzc2lnbm1lbnQg
aGFwcGVuaW5nIA0KZm9yIHRoZSB0dW5uZWwgZGVzdGluYXRpb24gd2hpY2ggdGhlbiBsYXRlciBn
ZXRzIG92ZXJ3cml0dGVuIGJ5IA0Kc2tiX2RzdF9zZXQgaW4gaXBfcm91dGVfaW5wdXRfbWMgd2l0
aG91dCBmcmVlaW5nIHRoZSBvcmlnaW5hbCBidWZmZXIuIEkgDQphbSB0cnlpbmcgdG8gZnJlZSB0
aGlzIHNrYi0+X3NrYl9yZWZkc3QgYnVmZmVyIGJlZm9yZSB0aGUgbmV3IGJ1ZmZlciBpcyBzZXQu
DQoNCkNvdWxkIHlvdSBwbGVhc2UgYWR2aXNlIHRoZSBhcGkgdG8gdXNlIGZvciBpdC4gSSBhbSBh
c3N1bWluZyB0aGF0IGl0IGlzIA0Kc2tiX2RzdF9kcm9wLCBJcyB0aGF0IGNvcnJlY3Q/DQoNCkNo
ZWVycywNCg0KTG9rZXNoDQoNCk9uIDMvMDUvMjIgMzoxMCBwbSwgbG9rZXNoZCB3cm90ZToNCj4g
SGksDQo+DQo+IEkgaGF2ZSB0aGUgdHVubmVsIGRlc3RpbmF0aW9uIGVudHJ5IHNldCB2aWEgc2ti
X2RzdF9zZXQgaW5zaWRlIA0KPiBpcF90dW5uZWxfcmN2LiBJIHdpc2ggdG8gcmVsZWFzZSB0aGUg
bWVtb3J5IHJlZmVyZW5jZWQgYnkgDQo+IHNrYi0+X3NrYl9yZWZkc3QgYWZ0ZXIgdXNlLg0KPg0K
PiBDb3VsZCB5b3UgcGxlYXNlIGFkdmlzZSB0aGUgYXBpIHRvIHVzZSBmb3IgaXQuIEkgYW0gYXNz
dW1pbmcgdGhhdCBpdCANCj4gaXMgc2tiX2RzdF9kcm9wLCBJcyB0aGF0IGNvcnJlY3Q/DQo+DQo+
IENoZWVycywNCj4gTG9rZXNo
