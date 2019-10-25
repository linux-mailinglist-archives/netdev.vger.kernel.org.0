Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1058DE46EE
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438406AbfJYJSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:18:22 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:9978 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438249AbfJYJSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:18:22 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9P96A3g017758;
        Fri, 25 Oct 2019 11:17:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=ogtXbD8YCbZhHddxE/GGtQWxu+Zf+FrFAhHcJX4a6z8=;
 b=bcliYt9Y1Z8yuL67LQhR1TgH4QQuJmb34pX1v/qi2WMthk5GZMwTdLdbSEY+RVTltzGj
 Z419O6nfaAR1pUDBm/feTmXo33peLMfb6fXxAffP8Jyfd1x74HBD0eJvTVcdoiIiu2DV
 XsSg4HcybnZMS8oHQCpp4/UZRmHl4tm38+BVBIS1KfAOJa6r6pBQFyNT1FSyRVyFEHJI
 B6wSWP1sj1n4zYiI0HDzkBSne1nZGwFfjNQKX9brH3aw7uM3X6OtsJyBROpMU2qiBz8V
 bdvXrzPpj4PzM6iuSeDLlPUJyTQM0SqncLbHW4IAoRupiGw4f+EB2fqLme8WmPl9T2tc ng== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vt9s1xsw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 11:17:55 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C513310002A;
        Fri, 25 Oct 2019 11:17:52 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag4node3.st.com [10.75.127.12])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id A67972BE24C;
        Fri, 25 Oct 2019 11:17:52 +0200 (CEST)
Received: from SFHDAG5NODE3.st.com (10.75.127.15) by SFHDAG4NODE3.st.com
 (10.75.127.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 25 Oct
 2019 11:17:52 +0200
Received: from SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47]) by
 SFHDAG5NODE3.st.com ([fe80::7c09:5d6b:d2c7:5f47%20]) with mapi id
 15.00.1473.003; Fri, 25 Oct 2019 11:17:52 +0200
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
Thread-Index: AQHVceL3e0a57DJk3UajMeBpRhFzv6drJNMA
Date:   Fri, 25 Oct 2019 09:17:52 +0000
Message-ID: <085bdbc4-4845-a3ae-d8f3-bf4f2d753226@st.com>
References: <20190920053817.13754-1-christophe.roullier@st.com>
 <20190922151257.51173d89@cakuba.netronome.com>
 <1d5dfc73-73e1-fe47-d1f6-9c24f9e5e532@st.com>
In-Reply-To: <1d5dfc73-73e1-fe47-d1f6-9c24f9e5e532@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A62F2998CAC83B42B39FF92B83102F7D@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_05:2019-10-23,2019-10-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQpKdXN0IGEgImdlbnRsZW1hbiBwaW5nIiBhYm91dCB0aGlzIHNlcmllcw0KDQpS
ZWdhcmRzLA0KDQpDaHJpc3RvcGhlLg0KDQpPbiA5LzIzLzE5IDk6NDYgQU0sIENocmlzdG9waGUg
Uk9VTExJRVIgd3JvdGU6DQo+IEhpIEpha3ViLCBhbGwsDQo+DQo+IEl0IGlzIG5vdCB1cmdlbnQs
IG5vIHByb2JsZW0gdG8gd2FpdCBuZXh0IG1lcmdlIHdpbmRvdyAocmVsZWFzZSA1LjUpDQo+DQo+
IEZvciBwYXRjaCAxIGFuZCAzLCBpdCBpcyBpbXByb3ZlbWVudC9jbGVhbnVwIGJlY2F1c2Ugbm93
IHN5c2NmZyBjbG9jayANCj4gaXMgbm90IG1hbmRhdG9yeSAoSSBwdXQgY29kZSBiYWNrd2FyZCBj
b21wYXRpYmxlKS4NCj4NCj4gUmVnYXJkcywNCj4NCj4gQ2hyaXN0b3BoZQ0KPg0KPiBPbiA5LzIz
LzE5IDEyOjEyIEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+IE9uIEZyaSwgMjAgU2VwIDIw
MTkgMDc6Mzg6MTIgKzAyMDAsIENocmlzdG9waGUgUm91bGxpZXIgd3JvdGU6DQo+Pj4gU29tZSBp
bXByb3ZlbWVudHMgKG1hbmFnZSBzeXNjZmcgYXMgb3B0aW9uYWwgY2xvY2ssIHVwZGF0ZSBzbGV3
IHJhdGUgb2YNCj4+PiBFVEhfTURJTyBwaW4sIEVuYWJsZSBnYXRpbmcgb2YgdGhlIE1BQyBUWCBj
bG9jayBkdXJpbmcgVFggbG93LXBvd2VyIA0KPj4+IG1vZGUpDQo+Pj4gRml4IHdhcm5pbmcgYnVp
bGQgbWVzc2FnZSB3aGVuIFc9MQ0KPj4gVGhlcmUgc2VlbXMgdG8gYmUgc29tZSBuZXcgZmVhdHVy
ZXMvY2xlYW51cHMgKG9yIGltcHJvdmVtZW50cyBhcw0KPj4geW91IHNheSkgaGVyZS4gQ291bGQg
eW91IGV4cGxhaW4gdGhlIG5lZ2F0aXZlIGltcGFjdCBub3QgYXBwbHlpbmcNCj4+IHRoZXNlIGNo
YW5nZXMgd2lsbCBoYXZlPyBQYXRjaGVzIDEgYW5kIDMgaW4gcGFydGljdWxhci4NCj4+DQo+PiBu
ZXQtbmV4dCBpcyBub3cgY2xvc2VkIFsxXSwgYW5kIHdpbGwgcmVvcGVuIHNvbWUgdGltZSBhZnRl
ciB0aGUgbWVyZ2UNCj4+IHdpbmRvdyBpcyBvdmVyLiBGb3Igbm93IHdlIGFyZSBvbmx5IGV4cGVj
dGluZyBmaXhlcyBmb3IgdGhlIG5ldCB0cmVlLg0KPj4NCj4+IENvdWxkIHlvdSAoYSkgcHJvdmlk
ZSBzdHJvbmdlciBtb3RpdmF0aW9uIHRoZXNlIGNoYW5nZXMgYXJlIGZpeGVzOyBvcg0KPj4gKGIp
IHNlcGFyYXRlIHRoZSBmaXhlcyBmcm9tIGltcHJvdmVtZW50cz8NCj4+DQo+PiBUaGFuayB5b3Uh
DQo+Pg0KPj4gWzFdIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L25ldHdv
cmtpbmcvbmV0ZGV2LUZBUS5odG1s
