Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9A1132793
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgAGN3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:29:20 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:21266 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727559AbgAGN3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:29:20 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007DRZvi010643;
        Tue, 7 Jan 2020 14:29:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=bdES9/KmhaIgbrZZaNjVlZmUAXk1GmM6Qs66jgKffgE=;
 b=YGu2V1ufJVPVo0vDeB04EvYd/rnrblBjyvecLOEY04aOvT9q3se8p+ayUal33RR0VxPC
 Xvj3LxoGj+UW5cxmhkp6VwBn2GJ0hChlcu93zQ8OZrf0BjJ35WspKUlVoQ4FSYHgXtsf
 8eAz8IStpf45f8/fRs52JgJVLh+qCbJBFcG/MyMFHUmkluPvTr+dLx4LYSb8xLU+JFkd
 znSsUs1VXfIqd6j3/6sW5r3fa14PKACaG7LJ8v5bOiJXVrU0FmYVpk0GHFbUvUSNJInD
 ie8oQAYz3mIoYYVT+8AWYONrvlXrXDSwTU8d7iLFNpUFgLdJrIt+6SGUxMNKCFNvjcDw mw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xakm5eepr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 14:29:02 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 6004D10003B;
        Tue,  7 Jan 2020 14:28:58 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag4node2.st.com [10.75.127.11])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 45CF02B4543;
        Tue,  7 Jan 2020 14:28:58 +0100 (CET)
Received: from SFHDAG6NODE3.st.com (10.75.127.18) by SFHDAG4NODE2.st.com
 (10.75.127.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 14:28:57 +0100
Received: from SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6]) by
 SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6%20]) with mapi id
 15.00.1473.003; Tue, 7 Jan 2020 14:28:57 +0100
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
Thread-Index: AQHVxRwlt8RIEIlxKkCYUiQBp2D2SqffHgAAgAAD14A=
Date:   Tue, 7 Jan 2020 13:28:57 +0000
Message-ID: <c1af466d-0870-364f-1bff-0ac015811e60@st.com>
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com>
 <1700835.tBzmY8zkgn@diego> <c25fbdb3-0e60-6e54-d58a-b05e8b805a58@gmail.com>
 <1599392.7x4dJXGyiB@diego> <011901d5c51c$1f93be30$5ebb3a90$@samsung.com>
 <6c657b5e-b4fb-551c-080a-18f04ac2dba3@st.com>
In-Reply-To: <6c657b5e-b4fb-551c-080a-18f04ac2dba3@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D8B826B9567CB41B0951BA6303C7702@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-07_03:2020-01-06,2020-01-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzcvMjAgMjoxNSBQTSwgUGF0cmljZSBDSE9UQVJEIHdyb3RlOg0KPiBIaSBBbGwNCj4N
Cj4gT24gMS83LzIwIDY6MzQgQU0sIFNyaXJhbSBEYXNoIHdyb3RlOg0KPj4+IEZyb206IEhlaWtv
IFN0w7xibmVyIDxoZWlrb0BzbnRlY2guZGU+DQo+Pj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0
OiBzdG1tYWM6IHBsYXRmb3JtOiBGaXggTURJTyBpbml0IGZvciBwbGF0Zm9ybXMNCj4+IHdpdGhv
dXQNCj4+PiBQSFkNCj4+Pg0KPj4+IEhpIEZsb3JpYW4sDQo+Pj4NCj4+PiBBbSBTb25udGFnLCA1
LiBKYW51YXIgMjAyMCwgMjM6MjI6MDAgQ0VUIHNjaHJpZWIgRmxvcmlhbiBGYWluZWxsaToNCj4+
Pj4gT24gMS81LzIwMjAgMTI6NDMgUE0sIEhlaWtvIFN0w7xibmVyIHdyb3RlOg0KPj4+Pj4gQW0g
U2Ftc3RhZywgMjEuIERlemVtYmVyIDIwMTksIDA2OjI5OjE4IENFVCBzY2hyaWViIERhdmlkIE1p
bGxlcjoNCj4+Pj4+PiBGcm9tOiBQYWRtYW5hYmhhbiBSYWphbmJhYnUgPHAucmFqYW5iYWJ1QHNh
bXN1bmcuY29tPg0KPj4+Pj4+IERhdGU6IFRodSwgMTkgRGVjIDIwMTkgMTU6NDc6MDEgKzA1MzAN
Cj4+Pj4+Pg0KPj4+Pj4+PiBUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBvZiAic3RtbWFjX2R0
X3BoeSIgZnVuY3Rpb24gaW5pdGlhbGl6ZXMNCj4+Pj4+Pj4gdGhlIE1ESU8gcGxhdGZvcm0gYnVz
IGRhdGEsIGV2ZW4gaW4gdGhlIGFic2VuY2Ugb2YgUEhZLiBUaGlzIGZpeA0KPj4+Pj4+PiB3aWxs
IHNraXAgTURJTyBpbml0aWFsaXphdGlvbiBpZiB0aGVyZSBpcyBubyBQSFkgcHJlc2VudC4NCj4+
Pj4+Pj4NCj4+Pj4+Pj4gRml4ZXM6IDc0MzcxMjcgKCJuZXQ6IHN0bW1hYzogQ29udmVydCB0byBw
aHlsaW5rIGFuZCByZW1vdmUgcGh5bGliDQo+Pj4+Pj4+IGxvZ2ljIikNCj4+Pj4+Pj4gQWNrZWQt
Ynk6IEpheWF0aSBTYWh1IDxqYXlhdGkuc2FodUBzYW1zdW5nLmNvbT4NCj4+Pj4+Pj4gU2lnbmVk
LW9mZi1ieTogU3JpcmFtIERhc2ggPHNyaXJhbS5kYXNoQHNhbXN1bmcuY29tPg0KPj4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBQYWRtYW5hYmhhbiBSYWphbmJhYnUgPHAucmFqYW5iYWJ1QHNhbXN1bmcu
Y29tPg0KPj4+Pj4+IEFwcGxpZWQgYW5kIHF1ZXVlZCB1cCBmb3IgLXN0YWJsZSwgdGhhbmtzLg0K
Pj4+Pj4gd2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQgSSBub3cgcnVuIGludG8gaXNzdWVzIG9uIG11
bHRpcGxlIHJvY2tjaGlwDQo+Pj4+PiBwbGF0Zm9ybXMgdXNpbmcgYSBnbWFjIGludGVyZmFjZS4N
Cj4+Pj4gRG8geW91IGhhdmUgYSBsaXN0IG9mIERUUyBmaWxlcyB0aGF0IGFyZSBhZmZlY3RlZCBi
eSBhbnkgY2hhbmNlPyBGb3INCj4+Pj4gdGhlIDMyLWJpdCBwbGF0Zm9ybXMgdGhhdCBJIGxvb2tl
ZCBpdCwgaXQgc2VlbXMgbGlrZToNCj4+Pj4NCj4+IEhpIEZsb3JpYW4sIA0KPj4gV2UgaGF2ZSBs
aXN0ZWQgZG93biB0aGUgcGxhdGZvcm1zIHdoaWNoIHdpbGwgYnJlYWsgZm9yIGFzIHRoZXkgZG9u
J3QgaGF2ZQ0KPj4gdGhlIG1kaW8gLyBzbnBzLGR3bWFjLW1kaW8gbm9kZS4NCj4+IEFybTMyIHNw
ZWFyKiAsIEFybTMyIG94ODIwKiwgYXJtMzIgcnYxMTA4LCBhcmMgYWJpbGlzKiAsIGFyYyBheHMx
MHgqLCBhcmMNCj4+IHZka19heHMxMHgqLCBtaXBzIHBpc3RhY2hpbywgYXJtNjQgcm9ja2NoaXAv
cHgzMCogVGhlcmUgbWlnaHQgYmUgbW9yZQ0KPj4gcGxhdGZvcm1zLg0KPiBTVGlINDEwLUIyMjYw
IGlzIGFmZmVjdGVkIGJ5IHRoaXMgcGF0Y2gsIGkgcHJvcG9zZWQgYSBmaXggZm9yIHRoaXMgYm9h
cmQgOg0KPg0KPiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtYXJt
LWtlcm5lbC9saXN0Lz9zZXJpZXM9MjI0NjM5DQo+DQo+IERhdmlkLCB3aWxsIHlvdSBhcHBsaWVk
IHRoaXMgRFQgc2VyaWVzIGluIHlvdXIgdHJlZSA/DQoNCkkganVzdCBub3RpY2VkIHRoYXQgYSBm
aXggaGFzIGJlZW4gcHJvcG9zZWRbMV0gYW5kIGZpeGVzIHRoZSBpc3N1ZSBvbiBTVGlINDEwLUIy
MjYwDQoNCndpdGhvdXQgdGhlIERUIHNlcmllcyBpIGp1c3QgcHJvcG9zZWQgYWJvdmUuDQoNClNv
IGRvbid0IHRha2UgY2FyZSBvZiBteSBwcmV2aW91cyBlbWFpbC4NCg0KVGhhbmtzDQoNClBhdHJp
Y2UNCg0KWzFdIGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzEvNy80MDUNCg0KPg0KPiBUaGFu
a3MNCj4NCj4gUGF0cmljZQ0KPg0KPg0KPj4+PiBhcmNoL2FybS9ib290L2R0cy9yazMyMjgtZXZi
LmR0cyBpcyBPSyBiZWNhdXNlIGl0IGhhcyBhIE1ESU8gYnVzIG5vZGUNCj4+Pj4gYXJjaC9hcm0v
Ym9vdC9kdHMvcmszMjI5LXhtczYuZHRzIGlzIGFsc28gT0sNCj4+Pj4NCj4+Pj4gYXJjaC9hcm0v
Ym9vdC9kdHMvcmszMjI5LWV2Yi5kdHMgaXMgcHJvYmFibHkgYnJva2VuLCB0aGVyZSBpcyBubw0K
Pj4+PiBwaHktaGFuZGxlIHByb3BlcnR5IG9yIE1ESU8gYnVzIG5vZGUsIHNvIGl0IG11c3QgYmUg
cmVseWluZyBvbg0KPj4+PiBhdXRvLXNjYW5uaW5nIG9mIHRoZSBidXMgc29tZWhvdyB0aGF0IHRo
aXMgcGF0Y2ggYnJva2UuDQo+Pj4+DQo+Pj4+IEFuZCBsaWtld2lzZSBmb3IgbW9zdCA2NC1iaXQg
cGxhdGZvcm1zIGV4Y2VwdCBhMSBhbmQgbmFub3BpNC4NCj4+PiBJIHByaW1hcmlseSBub3RpY2Vk
IHRoYXQgb24gdGhlIHB4MzAtZXZiLmR0cyBhbmQgdGhlIGludGVybmFsIGJvYXJkIEknbQ0KPj4g
d29ya2luZw0KPj4+IG9uIHJpZ2h0IG5vdy4gQm90aCBkb24ndCBoYXZlIHRoYXQgbWRpbyBidXMg
bm9kZSByaWdodCBub3cuDQo+Pj4NCj4+Pg0KPj4+Pj4gV2hlbiBwcm9iaW5nIHRoZSBkcml2ZXIg
YW5kIHRyeWluZyB0byBlc3RhYmxpc2ggYSBjb25uZWN0aW9uIGZvciBhDQo+Pj4+PiBuZnNyb290
IGl0IGFsd2F5cyBydW5zIGludG8gYSBudWxsIHBvaW50ZXIgaW4gbWRpb2J1c19nZXRfcGh5KCk6
DQo+Pj4+Pg0KPj4+Pj4gWyAgIDI2Ljg3ODgzOV0gcmtfZ21hYy1kd21hYyBmZjM2MDAwMC5ldGhl
cm5ldDogSVJRIGV0aF93YWtlX2lycSBub3QNCj4+PiBmb3VuZA0KPj4+Pj4gWyAgIDI2Ljg4NjMy
Ml0gcmtfZ21hYy1kd21hYyBmZjM2MDAwMC5ldGhlcm5ldDogSVJRIGV0aF9scGkgbm90IGZvdW5k
DQo+Pj4+PiBbICAgMjYuODk0NTA1XSBya19nbWFjLWR3bWFjIGZmMzYwMDAwLmV0aGVybmV0OiBQ
VFAgdXNlcyBtYWluIGNsb2NrDQo+Pj4+PiBbICAgMjYuOTA4MjA5XSBya19nbWFjLWR3bWFjIGZm
MzYwMDAwLmV0aGVybmV0OiBjbG9jayBpbnB1dCBvciBvdXRwdXQ/DQo+Pj4gKG91dHB1dCkuDQo+
PiAuLi4gc25pcCAuLi4NCj4+DQo+Pj4+PiBUaGlzIGlzIHRvcnZhbGRzIGdpdCBoZWFkIGFuZCBp
dCB3YXMgc3RpbGwgd29ya2luZyBhdCAtcmMxIGFuZCBhbGwNCj4+Pj4+IGtlcm5lbHMgYmVmb3Jl
IHRoYXQuIFdoZW4gSSBqdXN0IHJldmVydCB0aGlzIGNvbW1pdCwgdGhpbmdzIGFsc28NCj4+Pj4+
IHN0YXJ0IHdvcmtpbmcgYWdhaW4sIHNvIEkgZ3Vlc3Mgc29tZXRoaW5nIG11c3QgYmUgd3Jvbmcg
aGVyZT8NCj4+Pj4gWWVzLCB0aGlzIHdhcyBhbHNvIGlkZW50aWZpZWQgdG8gYmUgcHJvYmxlbWF0
aWMgYnkgdGhlIGtlcm5lbGNpIGJvb3QNCj4+Pj4gZmFybXMgb24gYW5vdGhlciBwbGF0Zm9ybSwg
c2VlIFsxXS4NCj4+Pj4NCj4+Pj4gWzFdOg0KPj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC1hcm0ta2VybmVsLzVlMDMxNGRhLjFjNjlmYjgxLmE3ZDYzLjI5YzFADQo+Pj4+IG14Lmdv
b2dsZS5jb20vDQo+Pj4+DQo+Pj4+IERvIHlvdSBtaW5kIHRyeWluZyB0aGlzIHBhdGNoIGFuZCBs
ZXR0aW5nIG1lIGtub3cgaWYgaXQgd29ya3MgZm9yIHlvdS4NCj4+Pj4gU3JpcmFtLCBwbGVhc2Ug
YWxzbyB0cnkgaXQgb24geW91ciBwbGF0Zm9ybXMgYW5kIGxldCBtZSBrbm93IGlmIHNvbHZlcw0K
Pj4+PiB0aGUgcHJvYmxlbSB5b3Ugd2VyZSBhZnRlci4gVGhhbmtzDQo+Pj4gV29ya3Mgb24gYm90
aCBib2FyZHMgSSBoYWQgdGhhdCB3ZXJlIGFmZmVjdGVkLCBzbw0KPj4+IFRlc3RlZC1ieTogSGVp
a28gU3R1ZWJuZXIgPGhlaWtvQHNudGVjaC5kZT4NCj4+IE5hY2tlZC1ieSA6IFNyaXJhbSBEYXNo
IDxTcmlyYW0uZGFzaEBzYW1zdW5nLmNvbT4NCj4+DQo+Pj4gVGhhbmtzDQo+Pj4gSGVpa28NCj4+
Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX3BsYXRmb3JtLmMNCj4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9zdG1tYWNfcGxhdGZvcm0uYw0KPj4+PiBpbmRleCBjYzhkN2U3YmY5YWMuLmUxOTJiOGUw
ODA5ZSAxMDA2NDQNCj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1t
YWMvc3RtbWFjX3BsYXRmb3JtLmMNCj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvc3RtbWFjX3BsYXRmb3JtLmMNCj4+Pj4gQEAgLTMyMCw3ICszMjAsNyBAQCBz
dGF0aWMgaW50IHN0bW1hY19tdGxfc2V0dXAoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPj4+PiAq
cGRldiwgIHN0YXRpYyBpbnQgc3RtbWFjX2R0X3BoeShzdHJ1Y3QgcGxhdF9zdG1tYWNlbmV0X2Rh
dGEgKnBsYXQsDQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZGV2aWNlX25v
ZGUgKm5wLCBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+Pj4+IHsNCj4+Pj4gLSAgICAgICBib29sIG1k
aW8gPSBmYWxzZTsNCj4+Pj4gKyAgICAgICBib29sIG1kaW8gPSB0cnVlOw0KPj4+PiAgICAgICAg
IHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIG5lZWRfbWRpb19pZHNbXSA9IHsNCj4+
Pj4gICAgICAgICAgICAgICAgIHsgLmNvbXBhdGlibGUgPSAic25wcyxkd2MtcW9zLWV0aGVybmV0
LTQuMTAiIH0sDQo+Pj4+ICAgICAgICAgICAgICAgICB7fSwNCj4+Pj4gQEAgLTM0MSw4ICszNDEs
OSBAQCBzdGF0aWMgaW50IHN0bW1hY19kdF9waHkoc3RydWN0DQo+Pj4+IHBsYXRfc3RtbWFjZW5l
dF9kYXRhICpwbGF0LA0KPj4+PiAgICAgICAgIH0NCj4+Pj4NCj4+Pj4gICAgICAgICBpZiAocGxh
dC0+bWRpb19ub2RlKSB7DQo+PiBGb3IgdGhlIHBsYXRmb3JtcyB3aGljaCBuZWl0aGVyIGhhdmUg
bWRpbyBub3Igc25wcyxkd21hYy1tZGlvIHByb3BlcnR5IGluDQo+PiBkdCwgdGhleSB3aWxsIG5v
dCBlbnRlciB0aGUgYmxvY2suDQo+PiBwbGF0LT5tZGlvX25vZGUgd2lsbCBhbHdheXMgYmUgZmFs
c2UgZm9yIHRoZW0uIFdoaWNoLCBlc3NlbnRpYWxseSwgcHJlc2VydmVzDQo+PiB0aGUgbWRpbyB2
YXJpYWJsZSBCb29sZWFuIHZhbHVlIGRlZmluZWQgYXQgdGhlIHN0YXJ0IG9mIHRoZSBmdW5jdGlv
bi4NCj4+DQo+Pj4+IC0gICAgICAgICAgICAgICBkZXZfZGJnKGRldiwgIkZvdW5kIE1ESU8gc3Vi
bm9kZVxuIik7DQo+Pj4+IC0gICAgICAgICAgICAgICBtZGlvID0gdHJ1ZTsNCj4+Pj4gKyAgICAg
ICAgICAgICAgIG1kaW8gPSBvZl9kZXZpY2VfaXNfYXZhaWxhYmxlKHBsYXQtPm1kaW9fbm9kZSk7
DQo+Pj4+ICsgICAgICAgICAgICAgICBkZXZfZGJnKGRldiwgIkZvdW5kIE1ESU8gc3Vibm9kZSwg
c3RhdHVzOiAlc2FibGVkXG4iLA0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgICBtZGlvID8g
ImVuIiA6ICJkaXMiKTsNCj4+Pj4gICAgICAgICB9DQo+Pj4+DQo+Pj4+ICAgICAgICAgaWYgKG1k
aW8pIHsNCj4+Pj4NCj4+Pg0KPj4gVGhlcmUgaXMgYSBwcm9wb3NhbCBmb3IgdGhpcyBwcm9ibGVt
IHNvbHV0aW9uLiBZb3UgY2FuIHJlZmVyIGl0IGF0IDoNCj4+IGh0dHBzOi8vbGttbC5vcmcvbGtt
bC8yMDIwLzEvNy8xNA0KPj4NCj4+DQo+Pg0KPj4gX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18NCj4+IExpbnV4LXN0bTMyIG1haWxpbmcgbGlzdA0KPj4gTGlu
dXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbQ0KPj4gaHR0cHM6Ly9zdC1tZC1t
YWlsbWFuLnN0b3JtcmVwbHkuY29tL21haWxtYW4vbGlzdGluZm8vbGludXgtc3RtMzI=
