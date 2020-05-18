Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4481D7816
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgERMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:03:20 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44846 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726557AbgERMDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:03:19 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IC2rku010157;
        Mon, 18 May 2020 14:02:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=tAbl2axdddZlaaXG2CNspEZUt31JN+F0gHWw9tO/rHM=;
 b=ddgt4qxdT4oWVbfbhnLDLAFXbH9hijDV73qOYcZaPn45NL3bumpy8wLhX3mQ5Ty8Rnwe
 Pw/wCLNK1hvokjk4gya24QRhEdq3qzzhUHo2amAWd+SCgiwsuoJWVOdlG/QND/4+sq3N
 5jLqzkCN4R7NsLwsozz2ISXgisXhvDnd/YfoWobYpTTwHGLE44CKN6D575ojATSSd8yh
 bAPNfjZdCpCRfQQrS/5nnimfEQtpfn25tR48a6FX/1nC32MjP6wiP6KgKjuygx7erOLx
 GvKmSrG19BHK8PrE2Aa0sR5sntD9/GrYvVY5vQspxGiw/RTUtF0Y+bIuCsta2yWpbh0n zg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3125n3bm24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 14:02:54 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E74D810002A;
        Mon, 18 May 2020 14:02:47 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag4node3.st.com [10.75.127.12])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CAC522BF9CF;
        Mon, 18 May 2020 14:02:47 +0200 (CEST)
Received: from SFHDAG5NODE1.st.com (10.75.127.13) by SFHDAG4NODE3.st.com
 (10.75.127.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 May
 2020 14:02:47 +0200
Received: from SFHDAG5NODE1.st.com ([fe80::cc53:528c:36c8:95f6]) by
 SFHDAG5NODE1.st.com ([fe80::cc53:528c:36c8:95f6%20]) with mapi id
 15.00.1473.003; Mon, 18 May 2020 14:02:47 +0200
From:   Christophe ROULLIER <christophe.roullier@st.com>
To:     "robh@kernel.org" <robh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>
CC:     "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH v3 0/1] net: ethernet: stmmac: simplify phy modes
 management for stm32
Thread-Topic: [PATCH v3 0/1] net: ethernet: stmmac: simplify phy modes
 management for stm32
Thread-Index: AQHWHHq3aaIPOA/wFEi5Ev+u/GvPiaitvfmA
Date:   Mon, 18 May 2020 12:02:47 +0000
Message-ID: <3aaadf75-5399-4961-248a-c77c719155d4@st.com>
References: <20200427100038.19252-1-christophe.roullier@st.com>
In-Reply-To: <20200427100038.19252-1-christophe.roullier@st.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.47]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD3A060E2D09364A9ED8F23EAD3F016B@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_05:2020-05-15,2020-05-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkp1c3QgYSAiZ2VudGxlbWFuIHBpbmciDQoNClJlZ2FyZHMsDQoNCkNocmlzdG9waGUu
DQoNCk9uIDI3LzA0LzIwMjAgMTI6MDAsIENocmlzdG9waGUgUm91bGxpZXIgd3JvdGU6DQo+IE5v
IG5ldyBmZWF0dXJlLCBqdXN0IHRvIHNpbXBsaWZ5IHN0bTMyIHBhcnQgdG8gYmUgZWFzaWVyIHRv
IHVzZS4NCj4gQWRkIGJ5IGRlZmF1bHQgYWxsIEV0aGVybmV0IGNsb2NrcyBpbiBEVCwgYW5kIGFj
dGl2YXRlIG9yIG5vdCBpbiBmdW5jdGlvbg0KPiBvZiBwaHkgbW9kZSwgY2xvY2sgZnJlcXVlbmN5
LCBpZiBwcm9wZXJ0eSAic3QsZXh0LXBoeWNsayIgaXMgc2V0IG9yIG5vdC4NCj4gS2VlcCBiYWNr
d2FyZCBjb21wYXRpYmlsaXR5DQo+DQo+IHZlcnNpb24gMzoNCj4gQWRkIGFja2VkIGZyb20gQWxl
eGFuZHJlIFRvcmd1ZQ0KPiBSZWJhc2VkIG9uIHRvcCBvZiB2NS43LXJjMg0KPg0KPiBDaHJpc3Rv
cGhlIFJvdWxsaWVyICgxKToNCj4gICAgbmV0OiBldGhlcm5ldDogc3RtbWFjOiBzaW1wbGlmeSBw
aHkgbW9kZXMgbWFuYWdlbWVudCBmb3Igc3RtMzINCj4NCj4gICAuLi4vbmV0L2V0aGVybmV0L3N0
bWljcm8vc3RtbWFjL2R3bWFjLXN0bTMyLmMgfCA3NCArKysrKysrKysrKy0tLS0tLS0tDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMoKyksIDMwIGRlbGV0aW9ucygtKQ0KPg==
