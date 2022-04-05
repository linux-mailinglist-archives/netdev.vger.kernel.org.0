Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69C44F317C
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiDEIjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiDEIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:24:43 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DFE19FE2
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 01:20:14 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-272-5SR__z5bPA-muZaIpB3Szg-1; Tue, 05 Apr 2022 09:20:12 +0100
X-MC-Unique: 5SR__z5bPA-muZaIpB3Szg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Tue, 5 Apr 2022 09:20:09 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Tue, 5 Apr 2022 09:20:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guenter Roeck' <linux@roeck-us.net>, Tom Rix <trix@redhat.com>,
        "Michael Walle" <michael@walle.cc>, Xu Yilun <yilun.xu@intel.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] hwmon: introduce hwmon_sanitize_name()
Thread-Topic: [PATCH v3 1/2] hwmon: introduce hwmon_sanitize_name()
Thread-Index: AQHYSHwTg8sgNzQuFUK534Gp+j5NB6zg+ouA
Date:   Tue, 5 Apr 2022 08:20:09 +0000
Message-ID: <dd24d0ecc84e4576bfde16d80d971f88@AcuMS.aculab.com>
References: <20220404184340.3973329-1-michael@walle.cc>
 <20220404184340.3973329-2-michael@walle.cc>
 <428c28e4-87cc-50a4-ef13-41ae36702a84@redhat.com>
 <25517c15-30f6-fbc5-5731-44c41ef904c7@roeck-us.net>
In-Reply-To: <25517c15-30f6-fbc5-5731-44c41ef904c7@roeck-us.net>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3VlbnRlciBSb2Vjaw0KPiBTZW50OiAwNSBBcHJpbCAyMDIyIDAwOjMxDQouLi4NCj4g
Pj4gwqAgLyoqDQo+ID4+IMKgwqAgKiBod21vbl9pc19iYWRfY2hhciAtIElzIHRoZSBjaGFyIGlu
dmFsaWQgaW4gYSBod21vbiBuYW1lDQo+ID4NCj4gPiBUaGlzIHN0aWxsIG5lZWRlZCBpbiAqLmgg
Pw0KPiA+DQo+IA0KPiBZZXMsIGJlY2F1c2UgaXQgaXMgdXNlZCBieSBvdXQtb2YtdHJlZSBkcml2
ZXJzLiBXZSBjYW4gb25seSBtb3ZlDQo+IHRoYXQgaW50byBod21vbi5jIGFmdGVyIGFsbCB1c2Vy
cyBhcmUgZ29uZS4NCg0KQW5kIGRyaXZlcnMgbWlnaHQgd2FudCB0byAnc2FuaXRpemUnIGEgY29w
eSBvZiB0aGUgbmFtZSB3aXRob3V0DQpyZWFsbG9jYXRpbmcgaXQuDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

