Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88440EBB5
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhIPUcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:32:02 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35868 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbhIPUcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:32:01 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B0D37806AC;
        Fri, 17 Sep 2021 08:30:38 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1631824238;
        bh=66iNt2SkHg+xAv+ToUG/4eY1bfSUixP6TZ8wTqARImQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=KPha15ikRENdORJf/70cl/PHYFkhsW7Jqh/nI0unsV9xPuEAspRxdrw6JSQDpDhWY
         yi/ikQFLDltaRKkMrcRBrkFryK1YlLyV1YIuI/HWV+2eiuU/OTuBOwAGLz4jYoE8sL
         aIn1+uiwqKZoSie2ShWf3yHRpu1sLPTSIK8NemafOh0n6hfZESh8axaoOKfaXQz2y2
         JFiGaDGQbejAaxi+Pu9BNeWU1/iC2w+kECnbQtqitU7W0baT6/xvei8LYjAB6ao9Z4
         wskH2TVL52AfA/3fUdY53yuNfXFTVws0AkIBqhLXEH4PS3S/3tUyO3aw9rqXyV9wmy
         qqHwm+MRGkvEQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6143a96e0001>; Fri, 17 Sep 2021 08:30:38 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 17 Sep 2021 08:30:38 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.023; Fri, 17 Sep 2021 08:30:38 +1200
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     "fw@strlen.de" <fw@strlen.de>
CC:     "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Anthony Lineham <Anthony.Lineham@alliedtelesis.co.nz>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Blair Steven <Blair.Steven@alliedtelesis.co.nz>,
        Scott Parlane <Scott.Parlane@alliedtelesis.co.nz>
Subject: Re: [PATCH net v4] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Thread-Topic: [PATCH net v4] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Thread-Index: AQHXqrDeSFwWXkxdyEqpMrDByD0Q66ulvOSAgACX+YA=
Date:   Thu, 16 Sep 2021 20:30:37 +0000
Message-ID: <77b0addceb098af07f3bb20fbb708d190ae58b03.camel@alliedtelesis.co.nz>
References: <20210916041057.459-1-Cole.Dishington@alliedtelesis.co.nz>
         <20210916112641.GC20414@breakpoint.cc>
In-Reply-To: <20210916112641.GC20414@breakpoint.cc>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C824B831C71BA44CAAB716A4B4320756@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FtN7AFjq c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=7QKq2e-ADPsA:10 a=YLWG8bL5PLmL-_Wxm7EA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDEzOjI2ICswMjAwLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3Rl
Og0KPiBDb2xlIERpc2hpbmd0b24gPENvbGUuRGlzaGluZ3RvbkBhbGxpZWR0ZWxlc2lzLmNvLm56
PiB3cm90ZToNCj4gPiArCS8qIEF2b2lkIGFwcGx5aW5nIG5hdC0+cmFuZ2UgdG8gdGhlIHJlcGx5
IGRpcmVjdGlvbiAqLw0KPiA+ICsJaWYgKCFleHAtPmRpciB8fCAhbmF0LT5yYW5nZV9pbmZvLm1p
bl9wcm90by5hbGwgfHwgIW5hdC0NCj4gPiA+cmFuZ2VfaW5mby5tYXhfcHJvdG8uYWxsKSB7DQo+
ID4gKwkJbWluID0gbnRvaHMoZXhwLT5zYXZlZF9wcm90by50Y3AucG9ydCk7DQo+ID4gKwkJcmFu
Z2Vfc2l6ZSA9IDY1NTM1IC0gbWluICsgMTsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJbWluID0g
bnRvaHMobmF0LT5yYW5nZV9pbmZvLm1pbl9wcm90by5hbGwpOw0KPiA+ICsJCXJhbmdlX3NpemUg
PSBudG9ocyhuYXQtPnJhbmdlX2luZm8ubWF4X3Byb3RvLmFsbCkgLSBtaW4NCj4gPiArIDE7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICAJLyogVHJ5IHRvIGdldCBzYW1lIHBvcnQ6IGlmIG5vdCwgdHJ5
IHRvIGNoYW5nZSBpdC4gKi8NCj4gPiAtCWZvciAocG9ydCA9IG50b2hzKGV4cC0+c2F2ZWRfcHJv
dG8udGNwLnBvcnQpOyBwb3J0ICE9IDA7DQo+ID4gcG9ydCsrKSB7DQo+ID4gLQkJaW50IHJldDsN
Cj4gPiArCWZpcnN0X3BvcnQgPSBudG9ocyhleHAtPnNhdmVkX3Byb3RvLnRjcC5wb3J0KTsNCj4g
PiArCWlmIChtaW4gPiBmaXJzdF9wb3J0IHx8IGZpcnN0X3BvcnQgPiAobWluICsgcmFuZ2Vfc2l6
ZSAtIDEpKQ0KPiA+ICsJCWZpcnN0X3BvcnQgPSBtaW47DQo+ID4gIA0KPiA+ICsJZm9yIChpID0g
MCwgcG9ydCA9IGZpcnN0X3BvcnQ7IGkgPCByYW5nZV9zaXplOyBpKyssIHBvcnQgPQ0KPiA+IChw
b3J0IC0gZmlyc3RfcG9ydCArIGkpICUgcmFuZ2Vfc2l6ZSkgew0KPiANCj4gVGhpcyBsb29rcyBj
b21wbGljYXRlZC4gIEFzIGZhciBhcyBJIHVuZGVyc3RhbmQsIHRoaXMgY291bGQgaW5zdGVhZA0K
PiBiZQ0KPiB3cml0dGVuIGxpa2UgdGhpcyAobm90IGV2ZW4gY29tcGlsZSB0ZXN0ZWQpOg0KPiAN
Cj4gCS8qIEF2b2lkIGFwcGx5aW5nIG5hdC0+cmFuZ2UgdG8gdGhlIHJlcGx5IGRpcmVjdGlvbiAq
Lw0KPiAJaWYgKCFleHAtPmRpciB8fCAhbmF0LT5yYW5nZV9pbmZvLm1pbl9wcm90by5hbGwgfHwg
IW5hdC0NCj4gPnJhbmdlX2luZm8ubWF4X3Byb3RvLmFsbCkgew0KPiAJCW1pbiA9IDE7DQo+IAkJ
bWF4ID0gNjU1MzU7DQo+IAkJcmFuZ2Vfc2l6ZSA9IDY1NTM1Ow0KPiAJfSBlbHNlIHsNCj4gCQlt
aW4gPSBudG9ocyhuYXQtPnJhbmdlX2luZm8ubWluX3Byb3RvLmFsbCk7DQo+IAkJbWF4ID0gbnRv
aHMobmF0LT5yYW5nZV9pbmZvLm1heF9wcm90by5hbGwpOw0KPiAJCXJhbmdlX3NpemUgPSBtYXgg
LSBtaW4gKyAxOw0KPiAJfQ0KDQpUaGUgb3JpZ2luYWwgY29kZSBkZWZpbmVkIHRoZSByYW5nZSBh
cyBbbnRvaHMoZXhwLT5zYXZlZF9wcm90by50Y3AucG9ydCksIDY1NTM1XS4gVGhlIGFib3ZlIHdv
dWxkDQpjYXVzZSBhIGNoYW5nZSBpbiBiZWhhdmlvdXIsIHNob3VsZCB3ZSB0cnkgdG8gYXZvaWQg
aXQ/DQoNCj4gDQo+ICAgCS8qIFRyeSB0byBnZXQgc2FtZSBwb3J0OiBpZiBub3QsIHRyeSB0byBj
aGFuZ2UgaXQuICovDQo+IAlwb3J0ID0gbnRvaHMoZXhwLT5zYXZlZF9wcm90by50Y3AucG9ydCk7
DQo+IA0KPiAJaWYgKHBvcnQgPCBtaW4gfHwgcG9ydCA+IG1heCkNCj4gCQlwb3J0ID0gbWluOw0K
PiANCj4gCWZvciAoaSA9IDA7IGkgPCByYW5nZV9zaXplOyBpKyspIHsNCj4gICAJCWV4cC0+dHVw
bGUuZHN0LnUudGNwLnBvcnQgPSBodG9ucyhwb3J0KTsNCj4gICAJCXJldCA9IG5mX2N0X2V4cGVj
dF9yZWxhdGVkKGV4cCwgMCk7DQo+IAkJaWYgKHJldCAhPSAtRUJVU1kpDQo+ICAJCQlicmVhazsN
Cj4gCQlwb3J0Kys7DQo+IAkJaWYgKHBvcnQgPiBtYXgpDQo+IAkJCXBvcnQgPSBtaW47DQo+ICAg
CX0NCj4gDQo+IAlpZiAocmV0ICE9IDApIHsNCj4gCS4uLg0KPiANCj4gQUZBSUNTIHRoaXMgaXMg
dGhlIHNhbWUsIHdlIGxvb3AgYXQgbW9zdCByYW5nZV9zaXplIHRpbWVzLA0KPiBpbiBjYXNlIHJh
bmdlX3NpemUgaXMgNjRrLCB3ZSB3aWxsIGxvb3AgdGhyb3VnaCBhbGwgKGhtbW0sDQo+IG5vdCBn
b29kIGFjdHVhbGx5LCBidXQgYmV0dGVyIG1ha2UgdGhhdCBhIGRpZmZlcmVudCBjaGFuZ2UpDQo+
IGVsc2UgdGhyb3VnaCBnaXZlbiBtaW4gLSBtYXggcmFuZ2UuDQo+IA0KPiBJZiBvcmlnIHBvcnQg
d2FzIGluLXJhbmdlLCB3ZSB0cnkgaXQgZmlyc3QsIHRoZW4gaW5jcmVtZW50Lg0KPiBJZiBwb3J0
IGV4Y2VlZHMgdXBwZXIgYm91bmQsIGN5Y2xlIGJhY2sgdG8gbWluLg0KPiANCj4gV2hhdCBkbyB5
b3UgdGhpbms/DQpMb29rcyBnb29kLCBqdXN0IHRoZSBvbmUgcXVlc3Rpb24gYWJvdmUuDQoNClRo
YW5rcyBmb3IgeW91ciB0aW1lIHJldmlld2luZyENCg==
