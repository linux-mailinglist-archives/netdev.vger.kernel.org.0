Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D637108D
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 04:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhECCjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 22:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhECCjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 22:39:11 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA332C06174A
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 19:38:18 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2F972891B0
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 14:38:15 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1620009495;
        bh=jxyY/ahO6C6bxs6B0pTr/nYSGdn1GiGkuhJUE9pGjbU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=zUeceVuARYTJNMHZnaXDrrV3vs83Sex1VgxF/ir4bUjl34EHo25D6VoSWQVqOpRWm
         VlkwqG+B84m6+737SgqFv/VfrDgDBYh9PkH3uEOSc7fod9fY3PNkT3g+IeAgIXIFZq
         t16rF66cIovIklAyCfbW/Qw/RR0dqaDljPTQKkEOT9y+jMIKrO86kXm/7SYCLr44Dk
         y5/SXZ0/e+xvjGbxzdK638BCgCeyFOtbgikCjVAE8y2zYEPrxqcbg6S1Umzfx54A9W
         HTRYEcXPFjKZ5lFZgepFaIPMyc8qEMicB8IiZXaJ2EziQesfTXNl6lZXKuKfUTgiAN
         0IGmROjkKifww==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B608f62170001>; Mon, 03 May 2021 14:38:15 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 May 2021 14:38:14 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.015; Mon, 3 May 2021 14:38:14 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Thread-Topic: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Thread-Index: AQHXOvTTprAnDTv0fEi7fRfdmTVx+KrMU6QAgAP4AgA=
Date:   Mon, 3 May 2021 02:38:14 +0000
Message-ID: <86d42c49-27a7-734a-2ca8-b6e6ba826dc1@alliedtelesis.co.nz>
References: <20210426233441.302414-1-andrew@lunn.ch>
 <YIwNzKZbiuLZRnoR@lunn.ch>
In-Reply-To: <YIwNzKZbiuLZRnoR@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <866DA4D354DB0E43B9DCE9F056F6B032@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=5FLXtPjwQuUA:10 a=pGLkceISAAAA:8 a=u1pRuSl7wRTtAqQQLCcA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzA1LzIxIDI6MDEgYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUdWUsIEFwciAy
NywgMjAyMSBhdCAwMTozNDo0MUFNICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IFRoZSBk
YXRhc2hlZXRzIHN1Z2dlc3RzIHRoZSA2MTYxIHVzZXMgYSBwZXIgcG9ydCBzZXR0aW5nIGZvciBq
dW1ibw0KPj4gZnJhbWVzLiBUZXN0aW5nIGhhcyBob3dldmVyIHNob3duIHRoaXMgaXMgbm90IGNv
cnJlY3QsIGl0IHVzZXMgdGhlIG9sZA0KPj4gc3R5bGUgY2hpcCB3aWRlIE1UVSBjb250cm9sLiBD
aGFuZ2UgdGhlIG9wcyBpbiB0aGUgNjE2MSBzdHJ1Y3R1cmUgdG8NCj4+IHJlZmxlY3QgdGhpcy4N
Cj4+DQo+PiBGaXhlczogMWJhZjBmYWMxMGZiICgibmV0OiBkc2E6IG12ODhlNnh4eDogVXNlIGNo
aXAtd2lkZSBtYXggZnJhbWUgc2l6ZSBmb3IgTVRVIikNCj4+IFJlcG9ydGVkIGJ5OiDmm7nnhZwg
PGNhbzg4eXVAZ21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEx1bm4gPGFuZHJl
d0BsdW5uLmNoPg0KPiBzZWxmIE5BQ0suDQo+DQo+IFdlIGR1ZyBkZWVwZXIgYW5kIGZvdW5kIGEg
ZGlmZmVyZW50IHJlYWwgcHJvYmxlbS4gUGF0Y2hlcyB0byBmb2xsb3cuDQoNCkhpIEFuZHJldywN
Cg0KSSdtIGJhY2sgb24tbGluZSBub3cuIEFueXRoaW5nIEkgY2FuIGhlbHAgbG9vayBhdD8NCg==
