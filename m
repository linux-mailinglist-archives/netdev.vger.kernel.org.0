Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AF7519C48
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbiEDJwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiEDJwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:52:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21A2F26556
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 02:49:17 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-146-eD8jnljNPLScslwCRwm34w-1; Wed, 04 May 2022 10:49:15 +0100
X-MC-Unique: eD8jnljNPLScslwCRwm34w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 4 May 2022 10:49:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 4 May 2022 10:49:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maxim Mikityanskiy' <maximmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Topic: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Index: AQHYXx+Xq0V3mdE7TkGKm+YxYaezY60OeVSw
Date:   Wed, 4 May 2022 09:49:13 +0000
Message-ID: <3f5f17a11d294781a5e500b3903aa902@AcuMS.aculab.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
 <20220428151142.3f0ccd83@kernel.org>
 <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
 <20220429121117.21bf7490@kernel.org>
 <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
In-Reply-To: <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
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

PiA+IElmIHlvdSBkZWNsYXJlIHRoZSB1bmlvbiBvbiB0aGUgc3RhY2sgaW4gdGhlIGNhbGxlcnMs
IGFuZCBwYXNzIGJ5IHZhbHVlDQo+ID4gLSBpcyB0aGUgY29tcGlsZXIgbm90IGdvaW5nIHRvIGJl
IGNsZXZlciBlbm91Z2ggdG8gc3RpbGwgRERSVD8NCj4gDQo+IEFoLCBPSywgaXQgc2hvdWxkIGRv
IHRoZSB0aGluZy4gSSB0aG91Z2h0IHlvdSB3YW50ZWQgbWUgdG8gZGl0Y2ggdGhlDQo+IHVuaW9u
IGFsdG9nZXRoZXIuDQoNClNvbWUgYXJjaGl0ZWN0dXJlcyBhbHdheXMgcGFzcyBzdHJ1Y3QvdW5p
b24gYnkgYWRkcmVzcy4NCldoaWNoIGlzIHByb2JhYmx5IG5vdCB3aGF0IHlvdSBoYWQgaW4gbWlu
ZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

