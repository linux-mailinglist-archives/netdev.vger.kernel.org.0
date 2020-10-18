Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A4B291FB5
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgJRUJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgJRUJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 16:09:54 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006CBC061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 13:09:52 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 87F8E891B2;
        Mon, 19 Oct 2020 09:09:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603051787;
        bh=fI3ft5v6GrDCCdIpWZ/v76RcDKLk0hIOLA+3EddrxVg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=DhE4eCMUytcYgCRJuN5laV4+mPVRvNC/6RtctgyuBIGqGfSQKk3AXW1pvJnMnFCoT
         SJeUyQWh67OkkN9Cgow4CEUc06tp+/+znEEMx2ps6A0ioRYa7CPE9fXl3j6PL0qmqV
         vID/QhQPgCUAQnm7cKvnhqJAhi8VoQqK6ZnoghG13GD2gZPbt9u6LclUng6ywSI8s3
         pbZb9viu9F5qKidLQRtlQBC4wfQmCEBFId7+LxXxH3hunJJYtVdaWItKF3WTM4pcQY
         Qr701MEGBP07LzoOu4zYE5zdAhyIjLb/FE1PM4IBQVOgj3Qr21zS+4uwiMZ1VZRtXZ
         zuBfB9OT2aEjw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8ca10a0001>; Mon, 19 Oct 2020 09:09:46 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct 2020 09:09:47 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 19 Oct 2020 09:09:47 +1300
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
Thread-Index: AQHWoQc4/uQqPxKVFEaOBfkb784lwamcuA8AgABBNAA=
Date:   Sun, 18 Oct 2020 20:09:46 +0000
Message-ID: <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
In-Reply-To: <20201018161624.GD456889@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9011C9514E65E74B822C839F3BC4873B@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxOS8xMC8yMCA1OjE2IGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gVHVlLCBPY3Qg
MTMsIDIwMjAgYXQgMDM6MTg6NThQTSArMTMwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IElt
cGxlbWVudCBzZXJkZXNfcG93ZXIsIHNlcmRlc19nZXRfbGFuZSBhbmQgc2VyZGVzX3Bjc19nZXRf
c3RhdGUgb3BzIGZvcg0KPj4gdGhlIE1WODhFNjA5NyBzbyB0aGF0IHBvcnRzIDggJiA5IGNhbiBi
ZSBzdXBwb3J0ZWQgYXMgc2VyZGVzIHBvcnRzIGFuZA0KPj4gZGlyZWN0bHkgY29ubmVjdGVkIHRv
IG90aGVyIG5ldHdvcmsgaW50ZXJmYWNlcyBvciB0byBTRlBzIHdpdGhvdXQgYSBQSFkuDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxl
c2lzLmNvLm56Pg0KPj4gLS0tDQo+Pg0KPj4gVGhpcyBzaG91bGQgYmUgdXNhYmxlIGZvciBhbGwg
dmFyaWFudHMgb2YgdGhlIDg4RTYxODUgdGhhdCBoYXZlDQo+PiB0cmktc3BlZWQgY2FwYWJsZSBw
b3J0cyAod2hpY2ggaXMgd2h5IEkgdXNlZCB0aGUgbXY4OGU2MTg1IHByZWZpeA0KPj4gaW5zdGVh
ZCBvZiBtdjg4ZTYwOTcpLiBCdXQgbXkgaGFyZHdhcmUgb25seSBoYXMgYSA4OGU2MDk3IHNvIEkn
dmUgb25seQ0KPj4gY29ubmVjdGVkIHVwIHRoZSBvcHMgZm9yIHRoYXQgY2hpcC4NCj4+DQo+PiAg
IGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jIHwgNjEgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDYxIGluc2VydGlvbnMoKykNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgYi9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuYw0KPj4gaW5kZXggMWVmMzkyZWU1MmM1Li4xYzZj
ZDVjNDNlYjEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAu
Yw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4+IEBAIC0zNDM2
LDYgKzM0MzYsNjQgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfc2V0X2VlcHJvbShzdHJ1Y3QgZHNh
X3N3aXRjaCAqZHMsDQo+PiAgIAlyZXR1cm4gZXJyOw0KPj4gICB9DQo+PiAgIA0KPj4gK3N0YXRp
YyBpbnQgbXY4OGU2MTg1X3NlcmRlc19wb3dlcihzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
IGludCBwb3J0LCB1OCBsYW5lLA0KPj4gKwkJCQkgIGJvb2wgdXApDQo+PiArew0KPj4gKwkvKiBU
aGUgc2VyZGVzIHBvd2VyIGNhbid0IGJlIGNvbnRyb2xsZWQgb24gdGhpcyBzd2l0Y2ggY2hpcCBi
dXQgd2UgbmVlZA0KPj4gKwkgKiB0byBzdXBwbHkgdGhpcyBmdW5jdGlvbiB0byBhdm9pZCByZXR1
cm5pbmcgLUVPUE5PVFNVUFAgaW4NCj4+ICsJICogbXY4OGU2eHh4X3NlcmRlc19wb3dlcl91cC9t
djg4ZTZ4eHhfc2VyZGVzX3Bvd2VyX2Rvd24NCj4+ICsJICovDQo+IEhpIENocmlzDQo+DQo+IEhv
dyBhYm91dCBiaXQgMTEgb2YgdGhlIGNvbnRyb2wgcmVnaXN0ZXIgMD8gVGhpcyBsb29rcyBhIGxv
dCBsaWtlIGENCj4gQk1DUiwgYW5kIEJNQ1JfUERPV04uDQo+DQo+IFRoaXMgaXMgd2hhdCBtdjg4
ZTYzNTJfc2VyZGVzX3Bvd2VyKCkgZG9lcy4gWW91IG1pZ2h0IGJlIGFibGUgdG8gZXZlbg0KPiBy
ZS11c2UgaXQsIGlmIHlvdSBjYW4gbWFrZSB0aGUgbGFuZSBudW1iZXJzIHdvcmsuDQoNCkkgYXNz
dW1lIHlvdSdyZSB0YWxraW5nIGFib3V0IHRoZSBQSFkgQ29udHJvbCBSZWdpc3RlciAwIGJpdCAx
MS4gSWYgc28gDQp0aGF0J3MgZm9yIHRoZSBpbnRlcm5hbCBQSFlzIG9uIHBvcnRzIDAtNy4gUG9y
dHMgOCwgOSBhbmQgMTAgZG9uJ3QgaGF2ZSANClBIWXMuDQoNCg==
