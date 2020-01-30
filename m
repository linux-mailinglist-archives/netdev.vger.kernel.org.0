Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6658814DBE8
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgA3Nad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 08:30:33 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:28646 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgA3Nac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 08:30:32 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UDNhRE005759;
        Thu, 30 Jan 2020 14:30:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=DDE7wRVrKC8L3nY1nmBlLG8DjibQ4CfnKv8w7/2QhPU=;
 b=T2ffEgEjN/DMXOY2HgMx42+9Qeuasz4Zl5qAECuKJeXBe0JiI+Z5YfCa6AouqnQm5mcv
 ZlHUuDE/xzlUlF/DiZhmpY1vNaS9E7RbPuNIFaJCYKkjeJtpXt/OvtaDohE362vHhGKJ
 40fribYB498l3vlZFqz/qoTfwcnfgFffuuOdUWnwm0DPOO+NPunxz41cKYRroq3qbiVD
 4x8DLE4Ji32iPI2wG7F6I319uTcRJD7Xqc+4oQWEoUA6hllvmW8T6IYged0JrXW72AAv
 S9izNaMquA24kcdPLuuLXzgw8c9RRaoauvVBwpyKL/Yba1LdVLzi+8EkQGV5YqMA+4Oo Dg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xrbpb8sp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jan 2020 14:30:10 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 21FCE10002A;
        Thu, 30 Jan 2020 14:30:05 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CA4BF2D5CFA;
        Thu, 30 Jan 2020 14:30:05 +0100 (CET)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG3NODE3.st.com
 (10.75.127.9) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu, 30 Jan
 2020 14:30:05 +0100
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1473.003; Thu, 30 Jan 2020 14:30:05 +0100
From:   Christophe ROULLIER <christophe.roullier@st.com>
To:     David Miller <davem@davemloft.net>
CC:     "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: ethernet: stmmac: simplify phy modes management
 for stm32
Thread-Topic: [PATCH 1/1] net: ethernet: stmmac: simplify phy modes management
 for stm32
Thread-Index: AQHV1pIW1y791lwjMUusjpFyRZvewKgDJNKA
Date:   Thu, 30 Jan 2020 13:30:05 +0000
Message-ID: <05adc7cc-19cb-7e6e-f6df-07ec8f5e841f@st.com>
References: <20200128083942.17823-1-christophe.roullier@st.com>
 <20200129.115131.1101786807458791369.davem@davemloft.net>
In-Reply-To: <20200129.115131.1101786807458791369.davem@davemloft.net>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6EE503FF153424FB0ED17B9583F7CA4@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yOS8yMCAxMTo1MSBBTSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBDaHJpc3Rv
cGhlIFJvdWxsaWVyIDxjaHJpc3RvcGhlLnJvdWxsaWVyQHN0LmNvbT4NCj4gRGF0ZTogVHVlLCAy
OCBKYW4gMjAyMCAwOTozOTo0MiArMDEwMA0KPg0KPj4gTm8gbmV3IGZlYXR1cmUsIGp1c3QgdG8g
c2ltcGxpZnkgc3RtMzIgcGFydCB0byBiZSBlYXNpZXIgdG8gdXNlLg0KPj4gQWRkIGJ5IGRlZmF1
bHQgYWxsIEV0aGVybmV0IGNsb2NrcyBpbiBEVCwgYW5kIGFjdGl2YXRlIG9yIG5vdCBpbiBmdW5j
dGlvbg0KPj4gb2YgcGh5IG1vZGUsIGNsb2NrIGZyZXF1ZW5jeSwgaWYgcHJvcGVydHkgInN0LGV4
dC1waHljbGsiIGlzIHNldCBvciBub3QuDQo+PiBLZWVwIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkN
Cj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+PiB8UEhZX01PREUgfCBOb3JtYWwgfCBQSFkgd28gY3J5c3Rh
bHwgICBQSFkgd28gY3J5c3RhbCAgIHwgIE5vIDEyNU1oeiAgfA0KPj4gfCAgICAgICAgIHwgICAg
ICAgIHwgICAgICAyNU1IeiAgICB8ICAgICAgICA1ME1IeiAgICAgICB8ICBmcm9tIFBIWSAgIHwN
Cj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+PiB8ICBNSUkgICAgfAkgLSAgICB8ICAgICBldGgtY2sgICAg
fCAgICAgICBuL2EgICAgICAgICAgfAkgICAgbi9hICB8DQo+PiB8ICAgICAgICAgfCAgICAgICAg
fCBzdCxleHQtcGh5Y2xrIHwgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgfA0KPj4g
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4+IHwgIEdNSUkgICB8CSAtICAgIHwgICAgIGV0aC1jayAgICB8ICAg
ICAgIG4vYSAgICAgICAgICB8CSAgICBuL2EgIHwNCj4+IHwgICAgICAgICB8ICAgICAgICB8IHN0
LGV4dC1waHljbGsgfCAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICB8DQo+PiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPj4gfCBSR01JSSAgIHwJIC0gICAgfCAgICAgZXRoLWNrICAgIHwgICAgICAg
bi9hICAgICAgICAgIHwgICAgICBldGgtY2sgIHwNCj4+IHwgICAgICAgICB8ICAgICAgICB8IHN0
LGV4dC1waHljbGsgfCAgICAgICAgICAgICAgICAgICAgfHN0LGV0aC1jbGstc2VsfA0KPj4gfCAg
ICAgICAgIHwgICAgICAgIHwgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICB8ICAg
ICAgIG9yICAgICB8DQo+PiB8ICAgICAgICAgfCAgICAgICAgfCAgICAgICAgICAgICAgIHwgICAg
ICAgICAgICAgICAgICAgIHwgc3QsZXh0LXBoeWNsa3wNCj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4g
fCBSTUlJICAgIHwJIC0gICAgfCAgICAgZXRoLWNrICAgIHwgICAgICBldGgtY2sgICAgICAgIHwJ
ICAgICBuL2EgIHwNCj4+IHwgICAgICAgICB8ICAgICAgICB8IHN0LGV4dC1waHljbGsgfCBzdCxl
dGgtcmVmLWNsay1zZWwgfCAgICAgICAgICAgICAgfA0KPj4gfCAgICAgICAgIHwgICAgICAgIHwg
ICAgICAgICAgICAgICB8IG9yIHN0LGV4dC1waHljbGsgICB8ICAgICAgICAgICAgICB8DQo+PiAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGhlIFJvdWxsaWVy
IDxjaHJpc3RvcGhlLnJvdWxsaWVyQHN0LmNvbT4NCj4gSWYgYW55dGhpbmcsIHRoaXMgaXMgbW9y
ZSBvZiBhIGNsZWFudXAsIGFuZCB0aGVyZWZvcmUgb25seSBhcHByb3ByaWF0ZSBmb3INCj4gbmV0
LW5leHQgd2hlbiBpdCBvcGVucyBiYWNrIHVwLg0KVGhhbmtzIERhdmlkLCBJdCBpcyBub3QgdXJn
ZW50LCBkbyB5b3Ugd2FudCB0aGF0IEkgcmUtcHVzaCBpdCB3aXRoIA0KIlBBVENIIG5ldCBuZXh0
IiA/
