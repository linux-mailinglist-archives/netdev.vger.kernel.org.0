Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E515A4D130F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345276AbiCHJI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345266AbiCHJI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:08:58 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 962BF1AD88
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:08:00 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-322-5-DKBbHeOH-Pm9CBfx6Rnw-1; Tue, 08 Mar 2022 09:07:58 +0000
X-MC-Unique: 5-DKBbHeOH-Pm9CBfx6Rnw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 8 Mar 2022 09:07:57 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 8 Mar 2022 09:07:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: RE: [RFC net-next] tcp: allow larger TSO to be built under overload
Thread-Topic: [RFC net-next] tcp: allow larger TSO to be built under overload
Thread-Index: AQHYMp+lvVxMhB3eHk2yhoJYjvGf7ay1MbUw
Date:   Tue, 8 Mar 2022 09:07:57 +0000
Message-ID: <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
References: <20220308030348.258934-1-kuba@kernel.org>
 <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
In-Reply-To: <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA4IE1hcmNoIDIwMjIgMDM6NTANCi4uLg0KPiAg
ICAgICAgIC8qIEdvYWwgaXMgdG8gc2VuZCBhdCBsZWFzdCBvbmUgcGFja2V0IHBlciBtcywNCj4g
ICAgICAgICAgKiBub3Qgb25lIGJpZyBUU08gcGFja2V0IGV2ZXJ5IDEwMCBtcy4NCj4gICAgICAg
ICAgKiBUaGlzIHByZXNlcnZlcyBBQ0sgY2xvY2tpbmcgYW5kIGlzIGNvbnNpc3RlbnQNCj4gICAg
ICAgICAgKiB3aXRoIHRjcF90c29fc2hvdWxkX2RlZmVyKCkgaGV1cmlzdGljLg0KPiAgICAgICAg
ICAqLw0KPiAtICAgICAgIHNlZ3MgPSBtYXhfdCh1MzIsIGJ5dGVzIC8gbXNzX25vdywgbWluX3Rz
b19zZWdzKTsNCj4gLQ0KPiAtICAgICAgIHJldHVybiBzZWdzOw0KPiArICAgICAgIHJldHVybiBt
YXhfdCh1MzIsIGJ5dGVzIC8gbXNzX25vdywgbWluX3Rzb19zZWdzKTsNCj4gIH0NCg0KV2hpY2gg
aXMgdGhlIGNvbW1vbiBzaWRlIG9mIHRoYXQgbWF4X3QoKSA/DQpJZiBpdCBpcyBtb25fdHNvX3Nl
Z3MgaXQgbWlnaHQgYmUgd29ydGggYXZvaWRpbmcgdGhlDQpkaXZpZGUgYnkgY29kaW5nIGFzOg0K
DQoJcmV0dXJuIGJ5dGVzID4gbXNzX25vdyAqIG1pbl90c29fc2VncyA/IGJ5dGVzIC8gbXNzX25v
dyA6IG1pbl90c29fc2VnczsNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

