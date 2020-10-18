Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C584E292019
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgJRVQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgJRVP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 17:15:59 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9375BC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 14:15:58 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 82AD1891B0;
        Mon, 19 Oct 2020 10:15:53 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603055753;
        bh=zfJ4/5j6lapeMGaPNyzEHYnbrS7oCdsukYao/Kwslgo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=LUiA3LFGArOjR49DHfalpr5ecMZm/tw70SqtJf8SkOXW7ltgmH5SE/TgxxLwAKMcn
         TyMUPupN1II9KFvWCuT7FM6vHnYZumUskrkPuwnjFnIIsQ4HhE4hXav8ZEbrzYAh/e
         hAuw4p7oSaY7zzzAy4acDQfIcRYScrCZEVPhiBy1PjG9eyGMMAGcJ7JuA8U6cQETMS
         lQAuFFAoSkImXBWwKOLiBH7MIppgFLEuAFSiy3E71g09ysUuoE8szB+OX4kvazok64
         R54e0VMUe6V2lxnfqefdezp3d1eE0NZCN6N5zmKCXeBVLVm2ZF9aWJVZHWI74wN0JZ
         Bm3U6jZAxS9pQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8cb0880001>; Mon, 19 Oct 2020 10:15:52 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 19 Oct 2020 10:15:53 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 19 Oct 2020 10:15:53 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Thread-Topic: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Thread-Index: AQHWoQc4/uQqPxKVFEaOBfkb784lwamcuA8AgABBNACAAARwgIAADggA
Date:   Sun, 18 Oct 2020 21:15:52 +0000
Message-ID: <2e1f1ca4-b5d5-ebc8-99bf-9ad74f461d26@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
 <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
 <20201018202539.GJ456889@lunn.ch>
In-Reply-To: <20201018202539.GJ456889@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E39CB38EC5A36D40960D57470FC512CA@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxOS8xMC8yMCA5OjI1IGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IEkgYXNzdW1lIHlv
dSdyZSB0YWxraW5nIGFib3V0IHRoZSBQSFkgQ29udHJvbCBSZWdpc3RlciAwIGJpdCAxMS4gSWYg
c28NCj4+IHRoYXQncyBmb3IgdGhlIGludGVybmFsIFBIWXMgb24gcG9ydHMgMC03LiBQb3J0cyA4
LCA5IGFuZCAxMCBkb24ndCBoYXZlDQo+PiBQSFlzLg0KPiBIaSBDaHJpcw0KPg0KPiBJIGhhdmUg
YSBkYXRhc2hlZXQgZm9yIHRoZSA2MTIyLzYxMjEsIGZyb20gc29tZSBjb3JuZXIgb2YgdGhlIHdl
YiwNCj4gUGFydCAzIG9mIDMsIEdpZ2FiaXQgUEhZcyBhbmQgU0VSREVTLg0KPg0KPiBodHRwOi8v
d3d3LmltYWdlLm1pY3Jvcy5jb20ucGwvX2RhbmVfdGVjaG5pY3puZV9hdXRvL3VpODhlNjEyMmIy
bGtqMWkwLnBkZg0KPg0KPiBTZWN0aW9uIDUgb2YgdGhpcyBkb2N1bWVudCB0YWxrcw0KPiBhYm91
dCB0aGUgU0VSREVTIHJlZ2lzdGVycy4gUmVnaXN0ZXIgMCBpcyBDb250cm9sLCByZWdpc3RlciAx
IGlzDQo+IFN0YXR1cyAtIEZpYmVyLCByZWdpc3RlciAyIGFuZCAzIGFyZSB0aGUgdXN1YWwgSUQs
IDQgaXMgYXV0by1uZXQNCj4gYWR2ZXJ0aXNlbWVudCBldGMuDQo+DQo+IFdoZXJlIHRoZXNlIHJl
Z2lzdGVycyBhcHBlYXIgaW4gdGhlIGFkZHJlc3Mgc3BhY2UgaXMgbm90IGNsZWFyIGZyb20NCj4g
dGhpcyBkb2N1bWVudC4gSXQgaXMgbm9ybWFsbHkgaW4gZG9jdW1lbnQgcGFydCAyIG9mIDMsIHdo
aWNoIG15DQo+IHNlYXJjaGluZyBvZiB0aGUgd2ViIGRpZCBub3QgZmluZC4NCj4NCj4gCSAgQW5k
cmV3DQoNCkkgaGF2ZSBnb3QgdGhlIDg4RTYxMjIgZGF0YXNoZWV0KHMpIGFuZCBjYW4gc2VlIHRo
ZSBTRVJERVMgcmVnaXN0ZXJzIA0KeW91J3JlIHRhbGtpbmcgYWJvdXQgKEkgdGhpbmsgdGhleSdy
ZSBpbiB0aGUgc2FtZSByZWdpc3RlciBzcGFjZSBhcyB0aGUgDQpidWlsdC1pbiBQSFlzKS4gSXQg
bG9va3MgbGlrZSB0aGUgODhFNjA5NyBpcyBkaWZmZXJlbnQgaW4gdGhhdCB0aGVyZSBhcmUgDQpu
byBTRVJERVMgcmVnaXN0ZXJzIGV4cG9zZWQgKGF0IGxlYXN0IG5vdCBpbiBhIGRvY3VtZW50ZWQg
d2F5KS4gTG9va2luZyANCmF0IHRoZSA4OEU2MTg1IGl0J3MgdGhlIHNhbWUgYXMgdGhlIDg4RTYw
OTcuDQoNClNvIGhvdyBkbyB5b3Ugd2FudCB0byBtb3ZlIHRoaXMgc2VyaWVzIGZvcndhcmQ/IEkg
Y2FuIHRlc3QgaXQgb24gdGhlIA0KODhFNjA5NyAoYW5kIGhhdmUgcmVzdHJpY3RlZCBpdCB0byBq
dXN0IHRoYXQgY2hpcCBmb3Igbm93KSwgSSdtIHByZXR0eSANCnN1cmUgaXQnbGwgd29yayBvbiB0
aGUgODhFNjE4NS4gSSBkb3VidCBpdCdsbCB3b3JrIG9uIHRoZSA4OEU2MTIyIGJ1dCANCm1heWJl
IGl0IHdvdWxkIHdpdGggYSBkaWZmZXJlbnQgc2VyZGVzX3Bvd2VyIGZ1bmN0aW9uIChvciBldmVu
IHRoZSANCm12ODhlNjM1Ml9zZXJkZXNfcG93ZXIoKSBhcyB5b3Ugc3VnZ2VzdGVkKS4NCg==
