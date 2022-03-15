Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB284D9184
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbiCOAaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiCOAaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:30:02 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AD92DD43
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:27:49 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 027732C066E;
        Tue, 15 Mar 2022 00:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647304065;
        bh=TOEaJLcAy9FaXsjjvCEs6i+ujFQu+Um52CZuhm6wy3A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=oeNxndQofXA+F8a+hxjbM7cS017ZjM0SCfMNqjb/wbU7Tx/x9rblCHHihXDXRIbeY
         f2vA/JsPZFp+MWEeHoQo3ZwW/pvNKZXP0dq/FGMNirgqee+wH59WvS6PrxTTyHFXY1
         zXy+bZPbjCd1XJR2L21C+IWdaDSQx3W6m7Y/7jzLphepMrShlddivLADFBuTB3uU4n
         mM40NAKA9nfLR8E2XZ4x4JPPMt7Qmin3DeCcqJrgDbag3A+ulaOMNR75hvFBHXw+O4
         S7+9elIRUPMMiZRgJJ8HAjHaM38/0BAi1yXHqv5bMjbGSlTjqSQjxOtgt4+NbVrBry
         3DXLFfFrfcJXA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fdd800001>; Tue, 15 Mar 2022 13:27:44 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar 2022 13:27:44 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 15 Mar 2022 13:27:44 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "huziji@marvell.com" <huziji@marvell.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "kostap@marvell.com" <kostap@marvell.com>,
        "robert.marko@sartura.hr" <robert.marko@sartura.hr>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 5/8] net: mvneta: Add support for 98DX2530 Ethernet
 port
Thread-Topic: [PATCH v2 5/8] net: mvneta: Add support for 98DX2530 Ethernet
 port
Thread-Index: AQHYN+r1Cm91Yq7jTEywLazWW4w1SKy+uQuAgAAEJ4A=
Date:   Tue, 15 Mar 2022 00:27:44 +0000
Message-ID: <4da378d9-d624-09a1-e261-8973c2670be4@alliedtelesis.co.nz>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-6-chris.packham@alliedtelesis.co.nz>
 <Yi/aAemqY+NBRaov@lunn.ch>
In-Reply-To: <Yi/aAemqY+NBRaov@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F90FA6F3D790F94480647AFD5677ABDD@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=o8Y5sQTvuykA:10 a=ihEotPDQY6E8XHjQGn4A:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxNS8wMy8yMiAxMzoxMiwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFR1ZSwgTWFyIDE1
LCAyMDIyIGF0IDEwOjMxOjQwQU0gKzEzMDAsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+PiBUaGUg
OThEWDI1MzAgU29DIGlzIHNpbWlsYXIgdG8gdGhlIEFybWFkYSAzNzAwIGV4Y2VwdCBpdCBuZWVk
cyBhDQo+PiBkaWZmZXJlbnQgTUJVUyB3aW5kb3cgY29uZmlndXJhdGlvbi4gQWRkIGEgbmV3IGNv
bXBhdGlibGUgc3RyaW5nIHRvDQo+PiBpZGVudGlmeSB0aGlzIGRldmljZSBhbmQgdGhlIHJlcXVp
cmVkIE1CVVMgd2luZG93IGNvbmZpZ3VyYXRpb24uDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56Pg0KPiBJIHN1Z2dl
c3QgeW91IHNlcGFyYXRlIHRoZSB0d28gbXZuZXRhIHBhdGNoZXMgYW5kIHNlbmQgdGhlbSB0byB0
aGUNCj4gbmV0ZGV2IGxpc3QuIFRoZXkgYXJlIGxpa2VseSB0byBnZXQgbWVyZ2VkIGJlZm9yZSB0
aGUgbWVyZ2Ugd2luZG93DQo+IG9wZW5zIG5leHQgd2Vla2VuZC4gVGhlIG90aGVyIHBhdGNoZXMg
YXJlIGxlc3MgbGlrZWx5IHRvIGJlIG1lcmdlZCBzbw0KPiBmYXN0Lg0KDQpUaGFua3MgZm9yIHRo
ZSBzdWdnZXN0aW9uLiBJIGRpZCB3b25kZXIgYWJvdXQgZG9pbmcgdGhhdCBmb3IgdGhpcyBwYXRj
aCANCmFuZCB0aGUgc2RoY2kgb25lLiBJdCdkIGFsc28gY3V0IGRvd24gdGhlIENjIHNwYW0uDQoN
Cj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4NCj4gICAgICBB
bmRyZXc=
