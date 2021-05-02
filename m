Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B429C370B6C
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 14:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhEBMBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 08:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhEBMBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 08:01:18 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42F4AC06138B;
        Sun,  2 May 2021 05:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=KAsnou6j1sJDkHZuWG4Uki3dmej1QCRiNgHY
        /YREahQ=; b=caYAVF+T9SGeToYGGsRmIy+/wsjMfHIq4LRMf7nTDPPf3QzgGyNi
        pejpqoeAvVCfQLG4pDOEM80pkBdoZO8zWuye7V9G3A/pEIbVlWehBZaXrGrP1qQJ
        roxSDalXHGwYkWUzuwsHZp2FPh7Hq8aL5FAx2TZZUDVg/+FtppETtDo=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Sun, 2 May
 2021 20:00:20 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Sun, 2 May 2021 20:00:20 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
Cc:     "Christian Benvenuti (benve)" <benve@cisco.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] ethernet:enic: Fix a use after free bug in
 enic_hard_start_xmit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <d3b9cc3a6bdc0dcdd64b4070a120c481b12b79c5.camel@cisco.com>
References: <20210501153140.5885-1-lyl2019@mail.ustc.edu.cn>
 <d3b9cc3a6bdc0dcdd64b4070a120c481b12b79c5.camel@cisco.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <331a2ffb.6db8a.1792cf36ae3.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygAHD0dUlI5gU3Z5AA--.1W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoIBlQhn6nCpAAGsm
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIkdvdmluZGFyYWp1
bHUgVmFyYWRhcmFqYW4gKGd2YXJhZGFyKSIgPGd2YXJhZGFyQGNpc2NvLmNvbT4NCj4g5Y+R6YCB
5pe26Ze0OiAyMDIxLTA1LTAyIDA5OjEyOjQ5ICjmmJ/mnJ/ml6UpDQo+IOaUtuS7tuS6ujogIkNo
cmlzdGlhbiBCZW52ZW51dGkgKGJlbnZlKSIgPGJlbnZlQGNpc2NvLmNvbT4sICJkYXZlbUBkYXZl
bWxvZnQubmV0IiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4sICJrdWJhQGtlcm5lbC5vcmciIDxrdWJh
QGtlcm5lbC5vcmc+LCAibHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuIiA8bHlsMjAxOUBtYWlsLnVz
dGMuZWR1LmNuPg0KPiDmioTpgIE6ICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiA8bmV0ZGV2QHZn
ZXIua2VybmVsLm9yZz4sICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZz4sICJHb3ZpbmRhcmFqdWx1DQo+ICBWYXJhZGFyYWphbiAoZ3Zh
cmFkYXIpIiA8Z3ZhcmFkYXJAY2lzY28uY29tPg0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIGV0aGVy
bmV0OmVuaWM6IEZpeCBhIHVzZSBhZnRlciBmcmVlIGJ1ZyBpbiBlbmljX2hhcmRfc3RhcnRfeG1p
dA0KPiANCj4gT24gU2F0LCAyMDIxLTA1LTAxIGF0IDA4OjMxIC0wNzAwLCBMdiBZdW5sb25nIHdy
b3RlOg0KPiA+IEluIGVuaWNfaGFyZF9zdGFydF94bWl0LCBpdCBjYWxscyBlbmljX3F1ZXVlX3dx
X3NrYigpLiBJbnNpZGUNCj4gPiBlbmljX3F1ZXVlX3dxX3NrYiwgaWYgc29tZSBlcnJvciBoYXBw
ZW5zLCB0aGUgc2tiIHdpbGwgYmUgZnJlZWQNCj4gPiBieSBkZXZfa2ZyZWVfc2tiKHNrYikuIEJ1
dCB0aGUgZnJlZWQgc2tiIGlzIHN0aWxsIHVzZWQgaW4NCj4gPiBza2JfdHhfdGltZXN0YW1wKHNr
YikuDQo+ID4gDQo+ID4gTXkgcGF0Y2ggbWFrZXMgZW5pY19xdWV1ZV93cV9za2IoKSByZXR1cm4g
ZXJyb3IgYW5kIGdvdG8gc3Bpbl91bmxvY2soKQ0KPiA+IGluY2FzZSBvZiBlcnJvci4gVGhlIHNv
bHV0aW9uIGlzIHByb3ZpZGVkIGJ5IEdvdmluZC4NCj4gPiBTZWUgaHR0cHM6Ly9sa21sLm9yZy9s
a21sLzIwMjEvNC8zMC85NjEuDQo+ID4gDQo+ID4gRml4ZXM6IGZiNzUxNmQ0MjQ3OGUgKCJlbmlj
OiBhZGQgc3cgdGltZXN0YW1wIHN1cHBvcnQiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEx2IFl1bmxv
bmcgPGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4NCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvbmV0
L2V0aGVybmV0L2Npc2NvL2VuaWMvZW5pY19tYWluLmMgfCA4ICsrKysrKy0tDQo+ID4gwqAxIGZp
bGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jaXNjby9lbmljL2VuaWNfbWFpbi5jDQo+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jaXNjby9lbmljL2VuaWNfbWFpbi5jDQo+ID4gaW5k
ZXggZjA0ZWM1MzU0NGFlLi40MGFiYzNmZGViYTYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY2lzY28vZW5pYy9lbmljX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2Npc2NvL2VuaWMvZW5pY19tYWluLmMNCj4gPiBAQCAtNzY4LDcgKzc2OCw3IEBA
IHN0YXRpYyBpbmxpbmUgaW50IGVuaWNfcXVldWVfd3Ffc2tiX2VuY2FwKHN0cnVjdCBlbmljDQo+
ID4gKmVuaWMsIHN0cnVjdCB2bmljX3dxICp3cSwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IGVycjsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+IC1zdGF0aWMgaW5saW5lIHZvaWQgZW5pY19xdWV1
ZV93cV9za2Ioc3RydWN0IGVuaWMgKmVuaWMsDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50IGVuaWNf
cXVldWVfd3Ffc2tiKHN0cnVjdCBlbmljICplbmljLA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3Qgdm5pY193cSAqd3EsIHN0cnVjdCBza19idWZmICpza2IpDQo+ID4gwqB7DQo+ID4gwqDCoMKg
wqDCoMKgwqDCoHVuc2lnbmVkIGludCBtc3MgPSBza2Jfc2hpbmZvKHNrYiktPmdzb19zaXplOw0K
PiA+IEBAIC04MTMsNyArODEzLDkgQEAgc3RhdGljIGlubGluZSB2b2lkIGVuaWNfcXVldWVfd3Ff
c2tiKHN0cnVjdCBlbmljICplbmljLA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgfQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgd3EtPnRvX3VzZSA9IGJ1
Zi0+bmV4dDsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl9rZnJlZV9z
a2Ioc2tiKTsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGVycjsN
Cj4gDQo+IHJldHVybiBlcnIgc2VlbXMgdW5uZWNlc3NhcnkgaGVyZS4NCj4gDQo+ID4gwqDCoMKg
wqDCoMKgwqDCoH0NCj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gZXJyOw0KPiA+IMKgfQ0KPiA+
IMKgDQo+ID4gwqAvKiBuZXRpZl90eF9sb2NrIGhlbGQsIHByb2Nlc3MgY29udGV4dCB3aXRoIEJI
cyBkaXNhYmxlZCwgb3IgQkggKi8NCj4gPiBAQCAtODU3LDcgKzg1OSw4IEBAIHN0YXRpYyBuZXRk
ZXZfdHhfdCBlbmljX2hhcmRfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tfYnVmZg0KPiA+ICpza2IsDQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gTkVUREVWX1RYX0JVU1k7
DQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gPiDCoA0KPiA+IC3CoMKgwqDCoMKgwqDCoGVuaWNf
cXVldWVfd3Ffc2tiKGVuaWMsIHdxLCBza2IpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChlbmlj
X3F1ZXVlX3dxX3NrYihlbmljLCB3cSwgc2tiKSA8IDApDQo+IA0KPiAwIGlzIHN1Y2Nlc3MsIGFu
eSBvdGhlciB2YWx1ZSBpcyBlcnJvci4gaWYgKGVuaWNfcXVldWVfd3Ffc2tiKGVuaWMsIHdxLCBz
a2IpKS4NCj4gDQo+IE90aGVyd2lzZSBwYXRjaCBsb29rcyBnb29kLg0KPiANCj4gVGhhbmtzDQo+
IEdvdmluZA0KDQoNClRoYW5rIHlvdS4gSSBoYXZlIGNvcnJlY3RlZCBteSBwYXRjaC4NClNlZSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTQyMDczMS8u
