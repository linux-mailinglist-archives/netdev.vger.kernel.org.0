Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61905BAEA3
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436692AbfIWHqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 03:46:51 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48745 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436498AbfIWHqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 03:46:50 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8N7kLX5008073;
        Mon, 23 Sep 2019 09:46:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=muFugSp+nMiGuUFM8Ydv4P5jCcLUS1PXGumUiJ9fYxA=;
 b=a7JLNE1wVXNEV8KjtjTTVEVhIL8ZShLmdtT1eMfNxYlNXrMxcSbtgSE0JMrH7s+neC3M
 NAYFOOu7lltRqo5+8/4sL6mchTY6SoKoGWUSNZLBVsMMbd5AGqkEzr4+tWFYr1lcbqpX
 qOcKLyLuTuSNwj58JYOXZB6E5OtZp74MVnemb6rdLY/FnwGH/oqRR0Q+H1mvG2w1wrIi
 eOWjwk0W5s9NhBbinCbQG5Pa7bYP0d8clpwxYJCgPzw7g62OqeVjmd26xcOA2dzdYDUu
 87z5E8WsyhQlhHVEQLHrUAZlXMdZXCvA7+eMqEjKlT06x4tKkbwJJg8lIxRPPVMtu6Mo BQ== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx07-00178001.pphosted.com with ESMTP id 2v59mwsytj-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 23 Sep 2019 09:46:22 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 65A2C4C;
        Mon, 23 Sep 2019 07:46:12 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag4node2.st.com [10.75.127.11])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id BC97E2B13B3;
        Mon, 23 Sep 2019 09:46:11 +0200 (CEST)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG4NODE2.st.com
 (10.75.127.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Sep
 2019 09:46:10 +0200
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1473.003; Mon, 23 Sep 2019 09:46:11 +0200
From:   Christophe ROULLIER <christophe.roullier@st.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "robh@kernel.org" <robh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH 0/5] net: ethernet: stmmac: some fixes and optimization
Thread-Topic: [PATCH 0/5] net: ethernet: stmmac: some fixes and optimization
Thread-Index: AQHVceL3e0a57DJk3UajMeBpRhFzvw==
Date:   Mon, 23 Sep 2019 07:46:11 +0000
Message-ID: <1d5dfc73-73e1-fe47-d1f6-9c24f9e5e532@st.com>
References: <20190920053817.13754-1-christophe.roullier@st.com>
 <20190922151257.51173d89@cakuba.netronome.com>
In-Reply-To: <20190922151257.51173d89@cakuba.netronome.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="utf-8"
Content-ID: <83AB20E31971524C9CCD0202AF363D9C@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-23_02:2019-09-23,2019-09-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsIGFsbCwNCg0KSXQgaXMgbm90IHVyZ2VudCwgbm8gcHJvYmxlbSB0byB3YWl0IG5l
eHQgbWVyZ2Ugd2luZG93IChyZWxlYXNlIDUuNSkNCg0KRm9yIHBhdGNoIDEgYW5kIDMsIGl0IGlz
IGltcHJvdmVtZW50L2NsZWFudXAgYmVjYXVzZSBub3cgc3lzY2ZnIGNsb2NrIGlzIA0Kbm90IG1h
bmRhdG9yeSAoSSBwdXQgY29kZSBiYWNrd2FyZCBjb21wYXRpYmxlKS4NCg0KUmVnYXJkcywNCg0K
Q2hyaXN0b3BoZQ0KDQpPbiA5LzIzLzE5IDEyOjEyIEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyMCBTZXAgMjAxOSAwNzozODoxMiArMDIwMCwgQ2hyaXN0b3BoZSBSb3VsbGll
ciB3cm90ZToNCj4+IFNvbWUgaW1wcm92ZW1lbnRzIChtYW5hZ2Ugc3lzY2ZnIGFzIG9wdGlvbmFs
IGNsb2NrLCB1cGRhdGUgc2xldyByYXRlIG9mDQo+PiBFVEhfTURJTyBwaW4sIEVuYWJsZSBnYXRp
bmcgb2YgdGhlIE1BQyBUWCBjbG9jayBkdXJpbmcgVFggbG93LXBvd2VyIG1vZGUpDQo+PiBGaXgg
d2FybmluZyBidWlsZCBtZXNzYWdlIHdoZW4gVz0xDQo+IFRoZXJlIHNlZW1zIHRvIGJlIHNvbWUg
bmV3IGZlYXR1cmVzL2NsZWFudXBzIChvciBpbXByb3ZlbWVudHMgYXMNCj4geW91IHNheSkgaGVy
ZS4gQ291bGQgeW91IGV4cGxhaW4gdGhlIG5lZ2F0aXZlIGltcGFjdCBub3QgYXBwbHlpbmcNCj4g
dGhlc2UgY2hhbmdlcyB3aWxsIGhhdmU/IFBhdGNoZXMgMSBhbmQgMyBpbiBwYXJ0aWN1bGFyLg0K
Pg0KPiBuZXQtbmV4dCBpcyBub3cgY2xvc2VkIFsxXSwgYW5kIHdpbGwgcmVvcGVuIHNvbWUgdGlt
ZSBhZnRlciB0aGUgbWVyZ2UNCj4gd2luZG93IGlzIG92ZXIuIEZvciBub3cgd2UgYXJlIG9ubHkg
ZXhwZWN0aW5nIGZpeGVzIGZvciB0aGUgbmV0IHRyZWUuDQo+DQo+IENvdWxkIHlvdSAoYSkgcHJv
dmlkZSBzdHJvbmdlciBtb3RpdmF0aW9uIHRoZXNlIGNoYW5nZXMgYXJlIGZpeGVzOyBvcg0KPiAo
Yikgc2VwYXJhdGUgdGhlIGZpeGVzIGZyb20gaW1wcm92ZW1lbnRzPw0KPg0KPiBUaGFuayB5b3Uh
DQo+DQo+IFsxXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9uZXR3b3Jr
aW5nL25ldGRldi1GQVEuaHRtbA==
