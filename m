Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABB0374DBF
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 05:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhEFDAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 23:00:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:40657 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhEFDAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 23:00:50 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 6E2F3891AD;
        Thu,  6 May 2021 14:59:50 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1620269990;
        bh=WiX/7t7MT2sDaNzbijFun5ci1fXS9VdtGyyrOgCwJoE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=moALwjU6dzAAOfWD4QD5HmqQQCHnpDjxoTrTo8AkdSk3UQb33mJSqyvl5FpVOSpuF
         nGzPP07BbDLrkvFvZuB+Xl+1tTFKf5FDlIm591xoz3lLrO8OgVqh4H3MfbKniCE+Ip
         sYmpoKBsWDaNwmfPSQCtFfMuM2Sa+BEtReehUY2z7Gw4SSincUjLFsFsXK7OLubc7v
         /syOGn8pusnb27bVeebqkTLuBqcPKrleflLYO7DQaMVRjMxT9GmTkFT3UKUezEeWV8
         BzQcv5k1jrOr2qY4D7YY6anXAFYqwE8I3Na5fOEy+vGTBmETD7sP5kCjEs0JEcY2Zx
         eAtH4bXrc4lAg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60935ba60001>; Thu, 06 May 2021 14:59:50 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 6 May 2021 14:59:50 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.015; Thu, 6 May 2021 14:59:50 +1200
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     "fw@strlen.de" <fw@strlen.de>, "jengelh@inai.de" <jengelh@inai.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Thread-Topic: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
Thread-Index: AQHXMOHFTHFm3Atrx06w+06M5CAoGaqzXgaAgCDIIYCAAPasgA==
Date:   Thu, 6 May 2021 02:59:49 +0000
Message-ID: <82faec0c7d403a76781372b0fd7911c9c08bb87a.camel@alliedtelesis.co.nz>
References: <20210414035327.31018-1-Cole.Dishington@alliedtelesis.co.nz>
         <20210414154021.GE14932@breakpoint.cc>
         <pq161666-47s-p680-552o-58poo05onr86@vanv.qr>
In-Reply-To: <pq161666-47s-p680-552o-58poo05onr86@vanv.qr>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:264b:feff:fe5b:1e9]
Content-Type: text/plain; charset="utf-8"
Content-ID: <53B3744B6A0F2042B417C4F4A3245377@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=5FLXtPjwQuUA:10 a=l_J4rYp_HbzP6ty2xjAA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTA1IGF0IDE0OjE2ICswMjAwLCBKYW4gRW5nZWxoYXJkdCB3cm90ZToN
Cj4gT24gV2VkbmVzZGF5IDIwMjEtMDQtMTQgMTc6NDAsIEZsb3JpYW4gV2VzdHBoYWwgd3JvdGU6
DQo+ID4gDQo+ID4gUHJlZmFjZTogQUZBSVUgdGhpcyB0cmFja2VyIGFpbXMgdG8gJ3NvZnQtc3Bs
aWNlJyB0d28gaW5kZXBlbmRlbnQNCj4gPiBFU1ANCj4gPiBjb25uZWN0aW9ucywgaS5lLjogc2Fk
ZHI6c3BpMSAtPiBkYWRkciwgZGFkZHI6c3BpMiA8LSBzYWRkci4gWy4uLl0NCj4gPiBUaGlzIGNh
bid0DQo+ID4gYmUgZG9uZSBhcy1pcywgYmVjYXVzZSB3ZSBkb24ndCBrbm93IHNwaTIgYXQgdGhl
IHRpbWUgdGhlIGZpcnN0IEVTUA0KPiA+IHBhY2tldCBpcw0KPiA+IHJlY2VpdmVkLiBUaGUgc29s
dXRpb24gaW1wbGVtZW50ZWQgaGVyZSBpcyBpbnRyb2R1Y3Rpb24gb2YgYQ0KPiA+ICd2aXJ0dWFs
IGVzcCBpZCcsDQo+ID4gY29tcHV0ZWQgd2hlbiBmaXJzdCBFU1AgcGFja2V0IGlzIHJlY2VpdmVk
LFsuLi5dDQo+IA0KPiBJIGNhbid0IGltYWdpbmUgdGhpcyB3b3JraW5nIHJlbGlhYmx5Lg0KPiAN
Cj4gMS4gVGhlIElLRSBkYWVtb25zIGNvdWxkIGRvIGFuIGV4Y2hhbmdlIHdoZXJlYnkganVzdCBv
bmUgRVNQIGZsb3cgaXMNCj4gc2V0IHVwIChmcm9tDQo+IGRhZGRyIHRvIHNhZGRyKS4gSXQncyB1
bnVzdWFsIHRvIGRvIGEgb25lLXdheSB0dW5uZWwsIGJ1dCBpdCdzIGENCj4gcG9zc2liaWxpdHku
DQo+IFRoZW4geW91IG9ubHkgZXZlciBoYXZlIEVTUCBwYWNrZXRzIGdvaW5nIGZyb20gZGFkZHIg
dG8gc2FkZHIuDQo+IA0KPiAyLiBFdmVuIGlmIHRoZSBJS0UgZGFlbW9ucyBzZXQgdXAgd2hhdCB3
ZSB3b3VsZCBjb25zaWRlciBhIG5vcm1hbA0KPiB0dW5uZWwsDQo+IGkuZS4gb25lIEVTUCBmbG93
IHBlciBkaXJlY3Rpb24sIHRoZXJlIGlzIG5vIG9ibGlnYXRpb24gdGhhdCBzYWRkcg0KPiBoYXMg
dG8NCj4gc2VuZCBhbnl0aGluZy4gZGFkZHIgY291bGQgYmUgY29udGFjdGluZyBzYWRkciBzb2xl
bHkgd2l0aCBhIHByb3RvY29sDQo+IHRoYXQgaXMgYm90aCBjb25uZWN0aW9ubGVzcyBhdCBMNCBh
bmQgd2hpY2ggZG9lcyBub3QgZGVtYW5kIGFueSBMNw0KPiByZXNwb25zZXMNCj4gZWl0aGVyLiBM
aWtlIC4uLiBzeXNsb2ctb3Zlci11ZHA/DQo+IA0KPiAzLiBFdmVuIHVuZGVyIGJlc3QgY29uZGl0
aW9ucywgd2hhdCBpZiB0d28gY2xpZW50cyBvbiB0aGUgc2FkZHINCj4gbmV0d29yaw0KPiBzaW11
bHRhbmVvdXNseSBpbml0aWF0ZSBhIGNvbm5lY3Rpb24gdG8gZGFkZHIsIGhvdyB3aWxsIHlvdSBk
ZWNpZGUNCj4gd2hpY2ggb2YgdGhlIGRhZGRyIEVTUCBTUElzIGJlbG9uZ3MgdG8gd2hpY2ggc2Fk
ZHI/DQoNCjEgYW5kIDIgYXJlIGxpbWl0YXRpb25zIG9mIHRyZWF0aW5nIHR3byBvbmUtd2F5IEVT
UCBTQXMgYXMgYSBzaW5nbGUNCmNvbm5lY3Rpb24uIEkgdGhpbmsgMSBhbmQgMiB3b3VsZCBiZSBs
ZXNzIG9mIGFuIGlzc3VlIHdpdGggRmxvcmlhbg0KV2VzdHBoYWwncyBsYXRlc3QgY29tbWVudHMg
cmVxdWVzdGluZyBleHBlY3RhdGlvbnMgKGFsdGhvdWdoIGFuDQpleHBlY3RhdGlvbiBmb3IgdGhl
IG90aGVyIHNpZGUgd291bGQgc3RpbGwgYmUgc2V0dXApLiAzIGlzIGhhbmRsZWQgYnkNCmFzc3Vt
aW5nIHRoZSBmaXJzdCBFU1AgcGFja2V0IHdpbGwgZ2V0IHRoZSBmaXJzdCBFU1AgcmVzcG9uc2Uu
IEkgdGhpbmsNCnRoZSBvbmx5IHdheSBwYXN0IDEgKGFuZCBhIG1vcmUgcmVsaWFibGUgYXBwcm9h
Y2ggdG8gMykgd291bGQgYmUgYnkNCnByb2Nlc3NpbmcgSVNBS01QIG1lc3NhZ2VzLg0KDQpIb3dl
dmVyLCBjb25zaWRlcmluZyB0aGF0IHRoZSBFU1AgY29ubmVjdGlvbiB0cmFja2VyJ3MgcHJpbWFy
eSB1c2UgaXMNCnRvIGFsbG93IGNsaWVudHMgYmVoaW5kIGEgTkFUIHRoYXQgZG9lc24ndCBzdXBw
b3J0IChvciB1c2UpIE5BVC1UIGENCm1ldGhvZCBvZiBlc3RhYmxpc2hpbmcgYSBjb25uZWN0aW9u
IHdpaG91dCBtYW51YWxseSBjb25maWd1cmluZw0Kc3BlY2lmaWMgTkFUIHJ1bGVzLCB0aGVzZSBs
aW1pdGF0aW9ucyBtaWdodCBiZSBhY2NlcHRhYmxlLg0KDQpUaGFua3MNCg==
