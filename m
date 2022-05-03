Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19E551868D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbiECO3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiECO3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:29:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 050FC2E6B6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:25:32 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-51-1yPzug1hOiqsDKwfLiu2zw-1; Tue, 03 May 2022 15:25:27 +0100
X-MC-Unique: 1yPzug1hOiqsDKwfLiu2zw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Tue, 3 May 2022 15:25:25 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Tue, 3 May 2022 15:25:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Topic: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Index: AQHYXsyW1iInROXA4UOMkVmM8/hvqK0NI0Qg///154CAABfrAA==
Date:   Tue, 3 May 2022 14:25:25 +0000
Message-ID: <5209f017148647719c5a5a2c8d6bb51d@AcuMS.aculab.com>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
 <8783dad64b0d41af9624f923cb4e4f03@AcuMS.aculab.com>
 <CANn89iJE5anTbyLJ0TdGAqGsE+GichY3YzQECjNUVMz=G3bcQg@mail.gmail.com>
In-Reply-To: <CANn89iJE5anTbyLJ0TdGAqGsE+GichY3YzQECjNUVMz=G3bcQg@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDAzIE1heSAyMDIyIDE0OjQzDQo+IA0KPiBPbiBU
dWUsIE1heSAzLCAyMDIyIGF0IDY6MjcgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1
bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBQYW9sbyBBYmVuaQ0KPiA+ID4gU2VudDog
MDMgTWF5IDIwMjIgMTA6MDMNCj4gPiA+DQo+ID4gPiBIZWxsbywNCj4gPiA+DQo+ID4gPiBPbiBN
b24sIDIwMjItMDUtMDIgYXQgMTA6NDAgKzA5MDAsIFRldHN1byBIYW5kYSB3cm90ZToNCj4gPiA+
ID4gc3l6Ym90IGlzIHJlcG9ydGluZyB1c2UtYWZ0ZXItZnJlZSByZWFkIGluIHRjcF9yZXRyYW5z
bWl0X3RpbWVyKCkgWzFdLA0KPiA+ID4gPiBmb3IgVENQIHNvY2tldCB1c2VkIGJ5IFJEUyBpcyBh
Y2Nlc3Npbmcgc29ja19uZXQoKSB3aXRob3V0IGFjcXVpcmluZyBhDQo+ID4gPiA+IHJlZmNvdW50
IG9uIG5ldCBuYW1lc3BhY2UuIFNpbmNlIFRDUCdzIHJldHJhbnNtaXNzaW9uIGNhbiBoYXBwZW4g
YWZ0ZXINCj4gPiA+ID4gYSBwcm9jZXNzIHdoaWNoIGNyZWF0ZWQgbmV0IG5hbWVzcGFjZSB0ZXJt
aW5hdGVkLCB3ZSBuZWVkIHRvIGV4cGxpY2l0bHkNCj4gPiA+ID4gYWNxdWlyZSBhIHJlZmNvdW50
Lg0KPiA+ID4gPg0KPiA+ID4gPiBMaW5rOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9i
dWc/ZXh0aWQ9Njk0MTIwZTEwMDJjMTE3NzQ3ZWQgWzFdDQo+ID4gPiA+IFJlcG9ydGVkLWJ5OiBz
eXpib3QgPHN5emJvdCs2OTQxMjBlMTAwMmMxMTc3NDdlZEBzeXprYWxsZXIuYXBwc3BvdG1haWwu
Y29tPg0KPiA+ID4gPiBGaXhlczogMjZhYmUxNDM3OWY4ZTJmYSAoIm5ldDogTW9kaWZ5IHNrX2Fs
bG9jIHRvIG5vdCByZWZlcmVuY2UgY291bnQgdGhlIG5ldG5zIG9mIGtlcm5lbA0KPiBzb2NrZXRz
LiIpDQo+ID4gPiA+IEZpeGVzOiA4YTY4MTczNjkxZjAzNjYxICgibmV0OiBza19jbG9uZV9sb2Nr
KCkgc2hvdWxkIG9ubHkgZG8gZ2V0X25ldCgpIGlmIHRoZSBwYXJlbnQgaXMgbm90IGENCj4gPiA+
IGtlcm5lbCBzb2NrZXQiKQ0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBUZXRzdW8gSGFuZGEgPHBl
bmd1aW4ta2VybmVsQEktbG92ZS5TQUtVUkEubmUuanA+DQo+ID4gPiA+IFRlc3RlZC1ieTogc3l6
Ym90IDxzeXpib3QrNjk0MTIwZTEwMDJjMTE3NzQ3ZWRAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNv
bT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+IENoYW5nZXMgaW4gdjI6DQo+ID4gPiA+ICAgQWRkIEZp
eGVzOiB0YWcuDQo+ID4gPiA+ICAgTW92ZSB0byBpbnNpZGUgbG9ja19zb2NrKCkgc2VjdGlvbi4N
Cj4gPiA+ID4NCj4gPiA+ID4gSSBjaG9zZSAyNmFiZTE0Mzc5ZjhlMmZhIGFuZCA4YTY4MTczNjkx
ZjAzNjYxIHdoaWNoIHdlbnQgdG8gNC4yIGZvciBGaXhlczogdGFnLA0KPiA+ID4gPiBmb3IgcmVm
Y291bnQgd2FzIGltcGxpY2l0bHkgdGFrZW4gd2hlbiA3MDA0MTA4OGUzYjk3NjYyICgiUkRTOiBB
ZGQgVENQIHRyYW5zcG9ydA0KPiA+ID4gPiB0byBSRFMiKSB3YXMgYWRkZWQgdG8gMi42LjMyLg0K
PiA+ID4gPg0KPiA+ID4gPiAgbmV0L3Jkcy90Y3AuYyB8IDggKysrKysrKysNCj4gPiA+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdp
dCBhL25ldC9yZHMvdGNwLmMgYi9uZXQvcmRzL3RjcC5jDQo+ID4gPiA+IGluZGV4IDUzMjdkMTMw
YzRiNS4uMmY2MzhmOGI3YjFlIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9uZXQvcmRzL3RjcC5jDQo+
ID4gPiA+ICsrKyBiL25ldC9yZHMvdGNwLmMNCj4gPiA+ID4gQEAgLTQ5NSw2ICs0OTUsMTQgQEAg
dm9pZCByZHNfdGNwX3R1bmUoc3RydWN0IHNvY2tldCAqc29jaykNCj4gPiA+ID4NCj4gPiA+ID4g
ICAgIHRjcF9zb2NrX3NldF9ub2RlbGF5KHNvY2stPnNrKTsNCj4gPiA+ID4gICAgIGxvY2tfc29j
ayhzayk7DQo+ID4gPiA+ICsgICAvKiBUQ1AgdGltZXIgZnVuY3Rpb25zIG1pZ2h0IGFjY2VzcyBu
ZXQgbmFtZXNwYWNlIGV2ZW4gYWZ0ZXINCj4gPiA+ID4gKyAgICAqIGEgcHJvY2VzcyB3aGljaCBj
cmVhdGVkIHRoaXMgbmV0IG5hbWVzcGFjZSB0ZXJtaW5hdGVkLg0KPiA+ID4gPiArICAgICovDQo+
ID4gPiA+ICsgICBpZiAoIXNrLT5za19uZXRfcmVmY250KSB7DQo+ID4gPiA+ICsgICAgICAgICAg
IHNrLT5za19uZXRfcmVmY250ID0gMTsNCj4gPiA+ID4gKyAgICAgICAgICAgZ2V0X25ldF90cmFj
ayhuZXQsICZzay0+bnNfdHJhY2tlciwgR0ZQX0tFUk5FTCk7DQo+ID4gPiA+ICsgICAgICAgICAg
IHNvY2tfaW51c2VfYWRkKG5ldCwgMSk7DQo+ID4gPiA+ICsgICB9DQo+ID4gPiA+ICAgICBpZiAo
cnRuLT5zbmRidWZfc2l6ZSA+IDApIHsNCj4gPiA+ID4gICAgICAgICAgICAgc2stPnNrX3NuZGJ1
ZiA9IHJ0bi0+c25kYnVmX3NpemU7DQo+ID4gPiA+ICAgICAgICAgICAgIHNrLT5za191c2VybG9j
a3MgfD0gU09DS19TTkRCVUZfTE9DSzsNCj4gPiA+DQo+ID4gPiBUaGlzIGxvb2tzIGVxdWl2YWxl
bnQgdG8gdGhlIGZpeCBwcmVzZW50ZWQgaGVyZToNCj4gPiA+DQo+ID4gPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9hbGwvQ0FObjg5aSs0ODRmZnFiOTNhUW0xTi10anh4dmIzV0RLWDBFYkQ3MzE4
UndSZ3NhdGp3QG1haWwuZ21haWwuY29tLw0KPiA+ID4NCj4gPiA+IGJ1dCB0aGUgbGF0dGVyIGxv
b2tzIGEgbW9yZSBnZW5lcmljIHNvbHV0aW9uLiBAVGV0c3VvIGNvdWxkIHlvdSBwbGVhc2UNCj4g
PiA+IHRlc3QgdGhlIGFib3ZlIGluIHlvdXIgc2V0dXA/DQo+ID4NCj4gPiBXb3VsZG4ndCBhIG1v
cmUgZ2VuZXJpYyBzb2x1dGlvbiBiZSB0byBhZGQgYSBmbGFnIHRvIHNvY2tfY3JlYXRlX2tlcm4o
KQ0KPiA+IHNvIHRoYXQgaXQgYWNxdWlyZXMgYSByZWZlcmVuY2UgdG8gdGhlIG5hbWVzcGFjZT8N
Cj4gPiBUaGlzIGNvdWxkIGJlIGEgYml0IG9uIG9uZSBvZiB0aGUgZXhpc3RpbmcgcGFyYW1ldGVy
cyAtIGxpa2UgU09DS19OT05CTE9DSy4NCj4gPg0KPiA+IEkndmUgYSBkcml2ZXIgdGhhdCB1c2Vz
IF9fc29ja19jcmVhdGUoKSBpbiBvcmRlciB0byBnZXQgdGhhdCByZWZlcmVuY2UuDQo+ID4gSSdt
IHByZXR0eSBzdXJlIHRoZSBleHRyYSAnc2VjdXJpdHknIGNoZWNrIHdpbGwgbmV2ZXIgZmFpbC4N
Cj4gPg0KPiANCj4gVGhpcyB3b3VsZCBiZSBzaWxseSByZWFsbHkuDQo+IA0KPiBEZWZpbml0aW9u
IG9mIGEgJ2tlcm5lbCBzb2NrZXQnIGlzIHRoYXQgaXQgZG9lcyBub3QgaG9sZCBhIHJlZmVyZW5j
ZQ0KPiB0byB0aGUgbmFtZXNwYWNlLg0KPiAob3RoZXJ3aXNlIGEgbmV0bnMgY291bGQgbm90IGJl
IGRlc3Ryb3llZCBieSB1c2VyIHNwYWNlKQ0KPiANCj4gQSBrZXJuZWwgbGF5ZXIgdXNpbmcga2Vy
bmVsIHNvY2tldHMgbmVlZHMgdG8gcHJvcGVybHkgZGlzbWFudGxlIHRoZW0NCj4gd2hlbiBhIG5h
bWVzcGFjZSBpcyBkZXN0cm95ZWQuDQoNCkkgdGhpbmsgaXQgZGVwZW5kcyBvbiB3aHkgdGhlIGRy
aXZlciBpcyB1c2luZyBhIHNvY2tldC4NCg0KSWYgdGhlIGRyaXZlciBpcyBhICd1c2VyJyBvZiBh
IFRDUCBjb25uZWN0aW9uIHRoYXQgaGFwcGVucyB0bw0KYmUgaXMgYSBrZXJuZWwgZHJpdmVyIHRo
ZW4gaG9sZGluZyB0aGUgYSByZWZlcmVuY2UgdG8gdGhlIG5hbWVzcGFjZQ0KaXMgbm8gZGlmZmVy
ZW50IHRvIGFuIGFwcGxpY2F0aW9uIHNvY2tldCBob2xkaW5nIGEgcmVmZXJlbmNlLg0KQW4gZXhh
bXBsZSBtaWdodCBiZSBuZnMvdGNwIC0geW91IG5lZWQgdG8gdW5tb3VudCB0aGUgZmlsZXN5c3Rl
bQ0KYmVmb3JlIHlvdSBjYW4gZGVsZXRlIHRoZSBuYW1lc3BhY2UuDQoNCk9UT0ggaWYgcGFydCBv
ZiBhIHByb3RvY29sIHN0YWNrIGlzIHVzaW5nIGEgc29ja2V0IGZvciBpbnRlcm5hbA0KY2FsbHMg
KEkgdGhpbmsgSSd2ZSBzZWVuIHJvdXRpbmcgc29ja2V0cyB1c2VkIHRoYXQgd2F5KSB0aGVuIHRo
ZQ0KcHJlc2VuY2Ugb2YgdGhlIHNvY2tldCBwcm9iYWJseSBzaG91bGRuJ3Qgc3RvcCB0aGUgbmFt
ZXNwYWNlDQpiZWluZyBkZWxldGVkLg0KDQpMaXN0ZW5pbmcgc29ja2V0cyBhcmUgYSBzbGlnaHQg
cHJvYmxlbSAtIHByb2JhYmx5IGZvciB1c2Vyc3BhY2UgYXMgd2VsbC4NCkl0IHdvdWxkIGJlIG5p
Y2VyIHRvIGJlIGFibGUgdG8gZ2V0IFRDUCAoZXRjKSB0byBlcnJvciBvdXQgbGlzdGVuaW5nDQpz
b2NrZXRzIGlmIHRoZXkgYXJlIHRoZSBvbmx5IHRoaW5nIHN0b3BwaW5nIGEgbmFtZXNwYWNlIGJl
aW5nIGRlbGV0ZWQuDQoNCj4gSW4gdGhlIFJEUyBjYXNlLCB0aGUgc29ja2V0IHdhcyBhIHVzZXIg
c29ja2V0LCBvciBSRFMgbGFja2VkIHByb3Blcg0KPiB0cmFja2luZyBvZiBhbGwgdGhlIHNvY2tl
dHMNCj4gc28gdGhhdCB0aGV5IGNhbiBiZSBkaXNtYW50bGVkIHByb3Blcmx5Lg0KDQpJIHRoaW5r
IHRoZXkgcHJvYmFibHkgYXJlIHNvY2tldHMgY3JlYXRlZCBpbiBvcmRlciBhY3Qgb24gcmVxdWVz
dHMNCmZyb20gYXBwbGljYXRpb25zLg0KSSB0aGluayB0aGV5IHNob3VsZCBoYXZlIHRoZSBzYW1l
IGVmZmVjdCBvbiBuYW1lc3BhY2VzIGFzIGEgZGlyZWN0DQp1c2VyIHNvY2tldCAtIHlvdSBjYW4n
dCBkZWxldGUgdGhlIHNvY2tldCB3aGlsZSB0aGUgY29ubmVjdGlvbiBpcw0KYWN0aXZlLg0KS2ls
bCBhbGwgdGhlIHJlbGV2YW50IHByb2Nlc3NlcywgdGVsbCB0aGUgZHJpdmVyIHRvIHN0b3AsIGFu
ZCB5b3UNCmNhbiBkZWxldGUgdGhlIG5hbWVzcGFjZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

