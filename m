Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99A51B421
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359457AbiEEAEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383408AbiEDX4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:56:53 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72E1522F5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:53:02 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 41EC72C05A0;
        Wed,  4 May 2022 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651708379;
        bh=UCJo4TtFo4sGN/s3kINtgEKrTOixbhQ4uxHpCtWB1cA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=mAJ0ZtscIQ8YDw843MkTX7jYg3Y3fC9x595hFrYNN3MWuENDPPJKkXhUFiZwptRn+
         kWrmCSpa1NNnhLVMRUAMj4wAtEnfhzDZg1lzfSDC2KCVSlR27kXaUQKk+WU36Haoyi
         Q5ZkFlRJfpTPCbgZhav4YwJMObsDnHLGTpA+EWPYruoAAg4L/QlsM6bg/tZibfY+B0
         +qq8eAoNM0ymEpjzK9LpXKLsDZYftlESBYQk8iHmBPJBSYH6epGNZvhFBpsrPTksnO
         l30nf3TNIoEyPvVr35iVMyq9Im0BW0YnuK7wrZvVZJQxFgtioDa6DddqtCnaAOm6iA
         vet8QKA52QqaA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B627311db0001>; Thu, 05 May 2022 11:52:59 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 5 May 2022 11:52:58 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Thu, 5 May 2022 11:52:58 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Anatolij Gustschin" <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Pantelis Antoniou" <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Thread-Topic: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Thread-Index: AQHYX76hvhP3kWHGgUas4wrlaQB7da0Om4EA
Date:   Wed, 4 May 2022 23:52:58 +0000
Message-ID: <70dd1d0d-31c7-854d-f9cb-d7ee23bca814@alliedtelesis.co.nz>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
 <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A344B6F1E498048B98D3E7533628C3D@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=QyXUC8HyAAAA:8 a=Nxf2nqiBf6T3PosxK2cA:9 a=QEXdDO2ut3YA:10
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

DQpPbiA1LzA1LzIyIDAxOjQ0LCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+IFN3aXRjaCBtcGM1
eHh4X2dldF9idXNfZnJlcXVlbmN5KCkgdG8gdXNlIGZ3bm9kZSBpbiBvcmRlciB0byBoZWxwDQo+
IGNsZWFuaW5nIHVwIG90aGVyIHBhcnRzIG9mIHRoZSBrZXJuZWwgZnJvbSBPRiBzcGVjaWZpYyBj
b2RlLg0KPg0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4NCj4gU2lnbmVkLW9m
Zi1ieTogQW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+
DQo+IC0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9tcGM1eHh4LmggICAgICAgICAg
ICB8ICA5ICsrKy0NCj4gICBhcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzUyeHgvbXBjNTJ4eF9ncHQu
YyAgICAgfCAgMiArLQ0KPiAgIGFyY2gvcG93ZXJwYy9zeXNkZXYvbXBjNXh4eF9jbG9ja3MuYyAg
ICAgICAgICB8IDQxICsrKysrKysrKystLS0tLS0tLS0NCj4gICBkcml2ZXJzL2F0YS9wYXRhX21w
YzUyeHguYyAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRyaXZlcnMvaTJjL2J1c3Nl
cy9pMmMtbXBjLmMgICAgICAgICAgICAgICAgICB8ICA3ICsrLS0NCj4gICBkcml2ZXJzL25ldC9j
YW4vbXNjYW4vbXBjNXh4eF9jYW4uYyAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbXBjNTJ4eC5jICB8ICAyICstDQo+ICAgLi4uL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZmVjX21wYzUyeHhfcGh5LmMgIHwgIDMgKy0NCj4gICAuLi4vbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mc19lbmV0L21paS1mZWMuYyAgfCAgNCArLQ0KPiAgIGRyaXZl
cnMvc3BpL3NwaS1tcGM1Mnh4LmMgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgZHJp
dmVycy90dHkvc2VyaWFsL21wYzUyeHhfdWFydC5jICAgICAgICAgICAgIHwgIDQgKy0NCj4gICAx
MSBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkNCjxzbmlw
Pg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pMmMvYnVzc2VzL2kyYy1tcGMuYyBiL2RyaXZlcnMv
aTJjL2J1c3Nlcy9pMmMtbXBjLmMNCj4gaW5kZXggNmM2OThjMTBkM2NkLi4yMDMwNjY4ZWNkZTUg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtbXBjLmMNCj4gKysrIGIvZHJp
dmVycy9pMmMvYnVzc2VzL2kyYy1tcGMuYw0KPiBAQCAtMjM5LDYgKzIzOSw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbXBjX2kyY19kaXZpZGVyIG1wY19pMmNfZGl2aWRlcnNfNTJ4eFtdID0gew0K
PiAgIHN0YXRpYyBpbnQgbXBjX2kyY19nZXRfZmRyXzUyeHgoc3RydWN0IGRldmljZV9ub2RlICpu
b2RlLCB1MzIgY2xvY2ssDQo+ICAgCQkJCQkgIHUzMiAqcmVhbF9jbGspDQo+ICAgew0KPiArCXN0
cnVjdCBmd25vZGVfaGFuZGxlID0gb2ZfZndub2RlX2hhbmRsZShub2RlKTsNCg0KSSB0aGluayB5
b3UgbWVhbg0KDQorwqDCoMKgwqDCoMKgIHN0cnVjdCBmd25vZGVfaGFuZGxlICpmd25vZGUgPSBv
Zl9md25vZGVfaGFuZGxlKG5vZGUpOw0KDQo+ICAgCWNvbnN0IHN0cnVjdCBtcGNfaTJjX2Rpdmlk
ZXIgKmRpdiA9IE5VTEw7DQo+ICAgCXVuc2lnbmVkIGludCBwdnIgPSBtZnNwcihTUFJOX1BWUik7
DQo+ICAgCXUzMiBkaXZpZGVyOw0KPiBAQCAtMjQ2LDEyICsyNDcsMTIgQEAgc3RhdGljIGludCBt
cGNfaTJjX2dldF9mZHJfNTJ4eChzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUsIHUzMiBjbG9jaywN
Cj4gICANCj4gICAJaWYgKGNsb2NrID09IE1QQ19JMkNfQ0xPQ0tfTEVHQUNZKSB7DQo+ICAgCQkv
KiBzZWUgYmVsb3cgLSBkZWZhdWx0IGZkciA9IDB4M2YgLT4gZGl2ID0gMjA0OCAqLw0KPiAtCQkq
cmVhbF9jbGsgPSBtcGM1eHh4X2dldF9idXNfZnJlcXVlbmN5KG5vZGUpIC8gMjA0ODsNCj4gKwkJ
KnJlYWxfY2xrID0gbXBjNXh4eF9md25vZGVfZ2V0X2J1c19mcmVxdWVuY3koZndub2RlKSAvIDIw
NDg7DQo+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gICAJfQ0KPiAgIA0KPiAgIAkvKiBEZXRlcm1p
bmUgZGl2aWRlciB2YWx1ZSAqLw0KPiAtCWRpdmlkZXIgPSBtcGM1eHh4X2dldF9idXNfZnJlcXVl
bmN5KG5vZGUpIC8gY2xvY2s7DQo+ICsJZGl2aWRlciA9IG1wYzV4eHhfZndub2RlX2dldF9idXNf
ZnJlcXVlbmN5KGZ3bm9kZSkgLyBjbG9jazsNCj4gICANCj4gICAJLyoNCj4gICAJICogV2Ugd2Fu
dCB0byBjaG9vc2UgYW4gRkRSL0RGU1IgdGhhdCBnZW5lcmF0ZXMgYW4gSTJDIGJ1cyBzcGVlZCB0
aGF0DQo+IEBAIC0yNjYsNyArMjY3LDcgQEAgc3RhdGljIGludCBtcGNfaTJjX2dldF9mZHJfNTJ4
eChzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUsIHUzMiBjbG9jaywNCj4gICAJCQlicmVhazsNCj4g
ICAJfQ0KPiAgIA0KPiAtCSpyZWFsX2NsayA9IG1wYzV4eHhfZ2V0X2J1c19mcmVxdWVuY3kobm9k
ZSkgLyBkaXYtPmRpdmlkZXI7DQo+ICsJKnJlYWxfY2xrID0gbXBjNXh4eF9md25vZGVfZ2V0X2J1
c19mcmVxdWVuY3koZndub2RlKSAvIGRpdi0+ZGl2aWRlcjsNCj4gICAJcmV0dXJuIChpbnQpZGl2
LT5mZHI7DQo+ICAgfQ0KPiAgIA==
