Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB8E132760
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgAGNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:15:37 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:21128 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727814AbgAGNPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:15:36 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007DDfmE027011;
        Tue, 7 Jan 2020 14:15:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=li6ezDvrHh0BrI2TE1aJR9vEsp/p3KUXcBDfIP/q9gY=;
 b=XFUvFkJPgoC8agOMstZgvClqhGtvbMov/+SHsowk73GSMOfvpCnaeJBFHBDG58koE1PF
 v3i7nPxHlaL4sf73exmzgZPRNE6x/Aj3EGatmOeyIJKuwYEj2XWZYpWDIip/KmQFSp5x
 EUUVIbImc0CvRd0vA58HXZLuA8I7K3J/redcYYIIpDHlbYTUfTMdTmkHptjEr9poXl4r
 nXjti9IOx7VgQRHNej02huOVXeiBSEbTwcen7ui0kIyn7ozQVz4+KEa1kV4tQ+U+oSOA
 1H9SG4sMttH+ioXFs99ykwN6KIB0+FI2eXkK4DP6QOsvSdOdOiK7Ijy+bgbL1OTV5qSu iw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2xakkapf45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 14:15:18 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 49005100038;
        Tue,  7 Jan 2020 14:15:14 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag4node1.st.com [10.75.127.10])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id EE60B2B4534;
        Tue,  7 Jan 2020 14:15:13 +0100 (CET)
Received: from SFHDAG6NODE3.st.com (10.75.127.18) by SFHDAG4NODE1.st.com
 (10.75.127.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 14:15:13 +0100
Received: from SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6]) by
 SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6%20]) with mapi id
 15.00.1473.003; Tue, 7 Jan 2020 14:15:13 +0100
From:   Patrice CHOTARD <patrice.chotard@st.com>
To:     Sriram Dash <sriram.dash@samsung.com>,
        =?utf-8?B?J0hlaWtvIFN0w7xibmVyJw==?= <heiko@sntech.de>,
        'Florian Fainelli' <f.fainelli@gmail.com>,
        'David Miller' <davem@davemloft.net>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "jayati.sahu@samsung.com" <jayati.sahu@samsung.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.rajanbabu@samsung.com" <p.rajanbabu@samsung.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linux-stm32] [PATCH] net: stmmac: platform: Fix MDIO init for
 platforms without PHY
Thread-Topic: [Linux-stm32] [PATCH] net: stmmac: platform: Fix MDIO init for
 platforms without PHY
Thread-Index: AQHVxRwlt8RIEIlxKkCYUiQBp2D2SqffHgAA
Date:   Tue, 7 Jan 2020 13:15:13 +0000
Message-ID: <6c657b5e-b4fb-551c-080a-18f04ac2dba3@st.com>
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com>
 <1700835.tBzmY8zkgn@diego> <c25fbdb3-0e60-6e54-d58a-b05e8b805a58@gmail.com>
 <1599392.7x4dJXGyiB@diego> <011901d5c51c$1f93be30$5ebb3a90$@samsung.com>
In-Reply-To: <011901d5c51c$1f93be30$5ebb3a90$@samsung.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B825CB237B931948921570B6797794EC@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-07_03:2020-01-06,2020-01-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsDQoNCk9uIDEvNy8yMCA2OjM0IEFNLCBTcmlyYW0gRGFzaCB3cm90ZToNCj4+IEZyb206
IEhlaWtvIFN0w7xibmVyIDxoZWlrb0BzbnRlY2guZGU+DQo+PiBTdWJqZWN0OiBSZTogW1BBVENI
XSBuZXQ6IHN0bW1hYzogcGxhdGZvcm06IEZpeCBNRElPIGluaXQgZm9yIHBsYXRmb3Jtcw0KPiB3
aXRob3V0DQo+PiBQSFkNCj4+DQo+PiBIaSBGbG9yaWFuLA0KPj4NCj4+IEFtIFNvbm50YWcsIDUu
IEphbnVhciAyMDIwLCAyMzoyMjowMCBDRVQgc2NocmllYiBGbG9yaWFuIEZhaW5lbGxpOg0KPj4+
IE9uIDEvNS8yMDIwIDEyOjQzIFBNLCBIZWlrbyBTdMO8Ym5lciB3cm90ZToNCj4+Pj4gQW0gU2Ft
c3RhZywgMjEuIERlemVtYmVyIDIwMTksIDA2OjI5OjE4IENFVCBzY2hyaWViIERhdmlkIE1pbGxl
cjoNCj4+Pj4+IEZyb206IFBhZG1hbmFiaGFuIFJhamFuYmFidSA8cC5yYWphbmJhYnVAc2Ftc3Vu
Zy5jb20+DQo+Pj4+PiBEYXRlOiBUaHUsIDE5IERlYyAyMDE5IDE1OjQ3OjAxICswNTMwDQo+Pj4+
Pg0KPj4+Pj4+IFRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIG9mICJzdG1tYWNfZHRfcGh5IiBm
dW5jdGlvbiBpbml0aWFsaXplcw0KPj4+Pj4+IHRoZSBNRElPIHBsYXRmb3JtIGJ1cyBkYXRhLCBl
dmVuIGluIHRoZSBhYnNlbmNlIG9mIFBIWS4gVGhpcyBmaXgNCj4+Pj4+PiB3aWxsIHNraXAgTURJ
TyBpbml0aWFsaXphdGlvbiBpZiB0aGVyZSBpcyBubyBQSFkgcHJlc2VudC4NCj4+Pj4+Pg0KPj4+
Pj4+IEZpeGVzOiA3NDM3MTI3ICgibmV0OiBzdG1tYWM6IENvbnZlcnQgdG8gcGh5bGluayBhbmQg
cmVtb3ZlIHBoeWxpYg0KPj4+Pj4+IGxvZ2ljIikNCj4+Pj4+PiBBY2tlZC1ieTogSmF5YXRpIFNh
aHUgPGpheWF0aS5zYWh1QHNhbXN1bmcuY29tPg0KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFNyaXJh
bSBEYXNoIDxzcmlyYW0uZGFzaEBzYW1zdW5nLmNvbT4NCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBQ
YWRtYW5hYmhhbiBSYWphbmJhYnUgPHAucmFqYW5iYWJ1QHNhbXN1bmcuY29tPg0KPj4+Pj4gQXBw
bGllZCBhbmQgcXVldWVkIHVwIGZvciAtc3RhYmxlLCB0aGFua3MuDQo+Pj4+IHdpdGggdGhpcyBw
YXRjaCBhcHBsaWVkIEkgbm93IHJ1biBpbnRvIGlzc3VlcyBvbiBtdWx0aXBsZSByb2NrY2hpcA0K
Pj4+PiBwbGF0Zm9ybXMgdXNpbmcgYSBnbWFjIGludGVyZmFjZS4NCj4+PiBEbyB5b3UgaGF2ZSBh
IGxpc3Qgb2YgRFRTIGZpbGVzIHRoYXQgYXJlIGFmZmVjdGVkIGJ5IGFueSBjaGFuY2U/IEZvcg0K
Pj4+IHRoZSAzMi1iaXQgcGxhdGZvcm1zIHRoYXQgSSBsb29rZWQgaXQsIGl0IHNlZW1zIGxpa2U6
DQo+Pj4NCj4gSGkgRmxvcmlhbiwgDQo+IFdlIGhhdmUgbGlzdGVkIGRvd24gdGhlIHBsYXRmb3Jt
cyB3aGljaCB3aWxsIGJyZWFrIGZvciBhcyB0aGV5IGRvbid0IGhhdmUNCj4gdGhlIG1kaW8gLyBz
bnBzLGR3bWFjLW1kaW8gbm9kZS4NCj4gQXJtMzIgc3BlYXIqICwgQXJtMzIgb3g4MjAqLCBhcm0z
MiBydjExMDgsIGFyYyBhYmlsaXMqICwgYXJjIGF4czEweCosIGFyYw0KPiB2ZGtfYXhzMTB4Kiwg
bWlwcyBwaXN0YWNoaW8sIGFybTY0IHJvY2tjaGlwL3B4MzAqIFRoZXJlIG1pZ2h0IGJlIG1vcmUN
Cj4gcGxhdGZvcm1zLg0KDQpTVGlINDEwLUIyMjYwIGlzIGFmZmVjdGVkIGJ5IHRoaXMgcGF0Y2gs
IGkgcHJvcG9zZWQgYSBmaXggZm9yIHRoaXMgYm9hcmQgOg0KDQpodHRwczovL3BhdGNod29yay5r
ZXJuZWwub3JnL3Byb2plY3QvbGludXgtYXJtLWtlcm5lbC9saXN0Lz9zZXJpZXM9MjI0NjM5DQoN
CkRhdmlkLCB3aWxsIHlvdSBhcHBsaWVkIHRoaXMgRFQgc2VyaWVzIGluIHlvdXIgdHJlZSA/DQoN
ClRoYW5rcw0KDQpQYXRyaWNlDQoNCg0KPg0KPj4+IGFyY2gvYXJtL2Jvb3QvZHRzL3JrMzIyOC1l
dmIuZHRzIGlzIE9LIGJlY2F1c2UgaXQgaGFzIGEgTURJTyBidXMgbm9kZQ0KPj4+IGFyY2gvYXJt
L2Jvb3QvZHRzL3JrMzIyOS14bXM2LmR0cyBpcyBhbHNvIE9LDQo+Pj4NCj4+PiBhcmNoL2FybS9i
b290L2R0cy9yazMyMjktZXZiLmR0cyBpcyBwcm9iYWJseSBicm9rZW4sIHRoZXJlIGlzIG5vDQo+
Pj4gcGh5LWhhbmRsZSBwcm9wZXJ0eSBvciBNRElPIGJ1cyBub2RlLCBzbyBpdCBtdXN0IGJlIHJl
bHlpbmcgb24NCj4+PiBhdXRvLXNjYW5uaW5nIG9mIHRoZSBidXMgc29tZWhvdyB0aGF0IHRoaXMg
cGF0Y2ggYnJva2UuDQo+Pj4NCj4+PiBBbmQgbGlrZXdpc2UgZm9yIG1vc3QgNjQtYml0IHBsYXRm
b3JtcyBleGNlcHQgYTEgYW5kIG5hbm9waTQuDQo+PiBJIHByaW1hcmlseSBub3RpY2VkIHRoYXQg
b24gdGhlIHB4MzAtZXZiLmR0cyBhbmQgdGhlIGludGVybmFsIGJvYXJkIEknbQ0KPiB3b3JraW5n
DQo+PiBvbiByaWdodCBub3cuIEJvdGggZG9uJ3QgaGF2ZSB0aGF0IG1kaW8gYnVzIG5vZGUgcmln
aHQgbm93Lg0KPj4NCj4+DQo+Pj4+IFdoZW4gcHJvYmluZyB0aGUgZHJpdmVyIGFuZCB0cnlpbmcg
dG8gZXN0YWJsaXNoIGEgY29ubmVjdGlvbiBmb3IgYQ0KPj4+PiBuZnNyb290IGl0IGFsd2F5cyBy
dW5zIGludG8gYSBudWxsIHBvaW50ZXIgaW4gbWRpb2J1c19nZXRfcGh5KCk6DQo+Pj4+DQo+Pj4+
IFsgICAyNi44Nzg4MzldIHJrX2dtYWMtZHdtYWMgZmYzNjAwMDAuZXRoZXJuZXQ6IElSUSBldGhf
d2FrZV9pcnEgbm90DQo+PiBmb3VuZA0KPj4+PiBbICAgMjYuODg2MzIyXSBya19nbWFjLWR3bWFj
IGZmMzYwMDAwLmV0aGVybmV0OiBJUlEgZXRoX2xwaSBub3QgZm91bmQNCj4+Pj4gWyAgIDI2Ljg5
NDUwNV0gcmtfZ21hYy1kd21hYyBmZjM2MDAwMC5ldGhlcm5ldDogUFRQIHVzZXMgbWFpbiBjbG9j
aw0KPj4+PiBbICAgMjYuOTA4MjA5XSBya19nbWFjLWR3bWFjIGZmMzYwMDAwLmV0aGVybmV0OiBj
bG9jayBpbnB1dCBvciBvdXRwdXQ/DQo+PiAob3V0cHV0KS4NCj4gLi4uIHNuaXAgLi4uDQo+DQo+
Pj4+DQo+Pj4+IFRoaXMgaXMgdG9ydmFsZHMgZ2l0IGhlYWQgYW5kIGl0IHdhcyBzdGlsbCB3b3Jr
aW5nIGF0IC1yYzEgYW5kIGFsbA0KPj4+PiBrZXJuZWxzIGJlZm9yZSB0aGF0LiBXaGVuIEkganVz
dCByZXZlcnQgdGhpcyBjb21taXQsIHRoaW5ncyBhbHNvDQo+Pj4+IHN0YXJ0IHdvcmtpbmcgYWdh
aW4sIHNvIEkgZ3Vlc3Mgc29tZXRoaW5nIG11c3QgYmUgd3JvbmcgaGVyZT8NCj4+PiBZZXMsIHRo
aXMgd2FzIGFsc28gaWRlbnRpZmllZCB0byBiZSBwcm9ibGVtYXRpYyBieSB0aGUga2VybmVsY2kg
Ym9vdA0KPj4+IGZhcm1zIG9uIGFub3RoZXIgcGxhdGZvcm0sIHNlZSBbMV0uDQo+Pj4NCj4+PiBb
MV06DQo+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC81ZTAzMTRk
YS4xYzY5ZmI4MS5hN2Q2My4yOWMxQA0KPj4+IG14Lmdvb2dsZS5jb20vDQo+Pj4NCj4+PiBEbyB5
b3UgbWluZCB0cnlpbmcgdGhpcyBwYXRjaCBhbmQgbGV0dGluZyBtZSBrbm93IGlmIGl0IHdvcmtz
IGZvciB5b3UuDQo+Pj4gU3JpcmFtLCBwbGVhc2UgYWxzbyB0cnkgaXQgb24geW91ciBwbGF0Zm9y
bXMgYW5kIGxldCBtZSBrbm93IGlmIHNvbHZlcw0KPj4+IHRoZSBwcm9ibGVtIHlvdSB3ZXJlIGFm
dGVyLiBUaGFua3MNCj4+IFdvcmtzIG9uIGJvdGggYm9hcmRzIEkgaGFkIHRoYXQgd2VyZSBhZmZl
Y3RlZCwgc28NCj4+IFRlc3RlZC1ieTogSGVpa28gU3R1ZWJuZXIgPGhlaWtvQHNudGVjaC5kZT4N
Cj4gTmFja2VkLWJ5IDogU3JpcmFtIERhc2ggPFNyaXJhbS5kYXNoQHNhbXN1bmcuY29tPg0KPg0K
Pj4NCj4+IFRoYW5rcw0KPj4gSGVpa28NCj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wbGF0Zm9ybS5jDQo+Pj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfcGxhdGZvcm0uYw0KPj4+IGluZGV4
IGNjOGQ3ZTdiZjlhYy4uZTE5MmI4ZTA4MDllIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wbGF0Zm9ybS5jDQo+Pj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX3BsYXRmb3JtLmMNCj4+PiBA
QCAtMzIwLDcgKzMyMCw3IEBAIHN0YXRpYyBpbnQgc3RtbWFjX210bF9zZXR1cChzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlDQo+Pj4gKnBkZXYsICBzdGF0aWMgaW50IHN0bW1hY19kdF9waHkoc3RydWN0
IHBsYXRfc3RtbWFjZW5ldF9kYXRhICpwbGF0LA0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICBzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLCBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+Pj4gew0KPj4+
IC0gICAgICAgYm9vbCBtZGlvID0gZmFsc2U7DQo+Pj4gKyAgICAgICBib29sIG1kaW8gPSB0cnVl
Ow0KPj4+ICAgICAgICAgc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgbmVlZF9tZGlv
X2lkc1tdID0gew0KPj4+ICAgICAgICAgICAgICAgICB7IC5jb21wYXRpYmxlID0gInNucHMsZHdj
LXFvcy1ldGhlcm5ldC00LjEwIiB9LA0KPj4+ICAgICAgICAgICAgICAgICB7fSwNCj4+PiBAQCAt
MzQxLDggKzM0MSw5IEBAIHN0YXRpYyBpbnQgc3RtbWFjX2R0X3BoeShzdHJ1Y3QNCj4+PiBwbGF0
X3N0bW1hY2VuZXRfZGF0YSAqcGxhdCwNCj4+PiAgICAgICAgIH0NCj4+Pg0KPj4+ICAgICAgICAg
aWYgKHBsYXQtPm1kaW9fbm9kZSkgew0KPiBGb3IgdGhlIHBsYXRmb3JtcyB3aGljaCBuZWl0aGVy
IGhhdmUgbWRpbyBub3Igc25wcyxkd21hYy1tZGlvIHByb3BlcnR5IGluDQo+IGR0LCB0aGV5IHdp
bGwgbm90IGVudGVyIHRoZSBibG9jay4NCj4gcGxhdC0+bWRpb19ub2RlIHdpbGwgYWx3YXlzIGJl
IGZhbHNlIGZvciB0aGVtLiBXaGljaCwgZXNzZW50aWFsbHksIHByZXNlcnZlcw0KPiB0aGUgbWRp
byB2YXJpYWJsZSBCb29sZWFuIHZhbHVlIGRlZmluZWQgYXQgdGhlIHN0YXJ0IG9mIHRoZSBmdW5j
dGlvbi4NCj4NCj4+PiAtICAgICAgICAgICAgICAgZGV2X2RiZyhkZXYsICJGb3VuZCBNRElPIHN1
Ym5vZGVcbiIpOw0KPj4+IC0gICAgICAgICAgICAgICBtZGlvID0gdHJ1ZTsNCj4+PiArICAgICAg
ICAgICAgICAgbWRpbyA9IG9mX2RldmljZV9pc19hdmFpbGFibGUocGxhdC0+bWRpb19ub2RlKTsN
Cj4+PiArICAgICAgICAgICAgICAgZGV2X2RiZyhkZXYsICJGb3VuZCBNRElPIHN1Ym5vZGUsIHN0
YXR1czogJXNhYmxlZFxuIiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICBtZGlvID8gImVu
IiA6ICJkaXMiKTsNCj4+PiAgICAgICAgIH0NCj4+Pg0KPj4+ICAgICAgICAgaWYgKG1kaW8pIHsN
Cj4+Pg0KPj4NCj4+DQo+IFRoZXJlIGlzIGEgcHJvcG9zYWwgZm9yIHRoaXMgcHJvYmxlbSBzb2x1
dGlvbi4gWW91IGNhbiByZWZlciBpdCBhdCA6DQo+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIw
LzEvNy8xNA0KPg0KPg0KPg0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KPiBMaW51eC1zdG0zMiBtYWlsaW5nIGxpc3QNCj4gTGludXgtc3RtMzJAc3Qt
bWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbQ0KPiBodHRwczovL3N0LW1kLW1haWxtYW4uc3Rvcm1y
ZXBseS5jb20vbWFpbG1hbi9saXN0aW5mby9saW51eC1zdG0zMg==
