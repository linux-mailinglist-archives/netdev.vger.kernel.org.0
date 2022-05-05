Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D991351C138
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345299AbiEENwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380157AbiEENwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:52:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA940580D2
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:48:13 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-41-1put9XVNPQW46Ot1ysVRxg-1; Thu, 05 May 2022 14:48:11 +0100
X-MC-Unique: 1put9XVNPQW46Ot1ysVRxg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 5 May 2022 14:48:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 5 May 2022 14:48:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maxim Mikityanskiy' <maximmi@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Topic: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Index: AQHYXx+Xq0V3mdE7TkGKm+YxYaezY60OeVSwgAGyMICAACK8UA==
Date:   Thu, 5 May 2022 13:48:10 +0000
Message-ID: <5dba0c54c647491a85366834c8c1c7d1@AcuMS.aculab.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
 <20220428151142.3f0ccd83@kernel.org>
 <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
 <20220429121117.21bf7490@kernel.org>
 <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
 <3f5f17a11d294781a5e500b3903aa902@AcuMS.aculab.com>
 <41abbf9f-8719-f2a7-36b5-fd6835bb133d@nvidia.com>
In-Reply-To: <41abbf9f-8719-f2a7-36b5-fd6835bb133d@nvidia.com>
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

RnJvbTogTWF4aW0gTWlraXR5YW5za2l5DQo+IFNlbnQ6IDA1IE1heSAyMDIyIDEzOjQwDQo+IA0K
PiBPbiAyMDIyLTA1LTA0IDEyOjQ5LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4+PiBJZiB5b3Ug
ZGVjbGFyZSB0aGUgdW5pb24gb24gdGhlIHN0YWNrIGluIHRoZSBjYWxsZXJzLCBhbmQgcGFzcyBi
eSB2YWx1ZQ0KPiA+Pj4gLSBpcyB0aGUgY29tcGlsZXIgbm90IGdvaW5nIHRvIGJlIGNsZXZlciBl
bm91Z2ggdG8gc3RpbGwgRERSVD8NCj4gPj4NCj4gPj4gQWgsIE9LLCBpdCBzaG91bGQgZG8gdGhl
IHRoaW5nLiBJIHRob3VnaHQgeW91IHdhbnRlZCBtZSB0byBkaXRjaCB0aGUNCj4gPj4gdW5pb24g
YWx0b2dldGhlci4NCj4gPg0KPiA+IFNvbWUgYXJjaGl0ZWN0dXJlcyBhbHdheXMgcGFzcyBzdHJ1
Y3QvdW5pb24gYnkgYWRkcmVzcy4NCj4gPiBXaGljaCBpcyBwcm9iYWJseSBub3Qgd2hhdCB5b3Ug
aGFkIGluIG1pbmQuDQo+IA0KPiBEbyB5b3UgaGF2ZSBhbnkgc3BlY2lmaWMgYXJjaGl0ZWN0dXJl
IGluIG1pbmQ/IEkgY291bGRuJ3QgZmluZCBhbnkNCj4gaW5mb3JtYXRpb24gdGhhdCBpdCBoYXBw
ZW5zIGFueXdoZXJlLCB4ODZfNjQgQUJJIFsxXSAocGFnZXMgMjAtMjEpDQo+IGFsaWducyB3aXRo
IG15IGV4cGVjdGF0aW9ucywgYW5kIG15IGNvbW1vbiBzZW5zZSBjYW4ndCBleHBsYWluIHdoeSB3
b3VsZA0KPiBzb21lIGFyY2hpdGVjdHVyZXMgZG8gd2hhdCB5b3Ugc2F5Lg0KPiANCj4gSW4gQywg
d2hlbiB0aGUgY2FsbGVyIHBhc3NlcyBhIHN0cnVjdCBhcyBhIHBhcmFtZXRlciwgdGhlIGNhbGxl
ZSBjYW4NCj4gZnJlZWx5IG1vZGlmeSBpdC4gSWYgdGhlIGNvbXBpbGVyIHNpbGVudGx5IHJlcGxh
Y2VkIGl0IHdpdGggYSBwb2ludGVyLA0KPiB0aGUgY2FsbGVlIHdvdWxkIGNvcnJ1cHQgdGhlIGNh
bGxlcidzIGxvY2FsIHZhcmlhYmxlLCBzbyBzdWNoIGFwcHJvYWNoDQo+IHJlcXVpcmVzIHRoZSBj
YWxsZXIgdG8gbWFrZSBhbiBleHRyYSBjb3B5Lg0KDQpZZXMsIHRoYXQgaXMgd2hhdCBoYXBwZW5z
Lg0KDQo+IE1ha2luZyBhbiBleHRyYSBjb3B5IG9uIHRoZQ0KPiBzdGFjayBhbmQgcGFzc2luZyBh
IHBvaW50ZXIgZG9lc24ndCBtYWtlIGFueSBzZW5zZSB0byBtZSBpZiB5b3UgY2FuIGp1c3QNCj4g
bWFrZSBhIGNvcHkgb24gdGhlIHN0YWNrIChvciB0byBhIHJlZ2lzdGVyKSBhbmQgY2FsbCBpdCBh
IHBhcmFtZXRlci4NCj4gDQo+IElmIHlvdSBrbm93IGFueSBzcGVjaWZpYyBhcmNoaXRlY3R1cmUg
c3VwcG9ydGVkIGJ5IExpbnV4IHRoYXQgcGFzc2VzIGFsbA0KPiB1bmlvbnMgYnkgYSBwb2ludGVy
LCBjb3VsZCB5b3UgcGxlYXNlIHBvaW50IG1lIHRvIGl0PyBNYXliZSBJJ20gbWlzc2luZw0KPiBz
b21ldGhpbmcgaW4gbXkgbG9naWMsIGFuZCBhIHJlYWwtd29ybGQgZXhhbXBsZSB3aWxsIGV4cGxh
aW4gdGhpbmdzLCBidXQNCj4gYXQgdGhlIG1vbWVudCBpdCBzb3VuZHMgdW5yZWFsaXN0aWMgdG8g
bWUuDQoNCkxvb2sgYXQgYW55IG9sZCBhcmNoaXRlY3R1cmUsIG02OGsgYWxtb3N0IGNlcnRhaW5s
eSBwYXNzZXMgYWxsIHN0cnVjdHVyZXMNCmJ5IGFkZHJlc3MuDQppMzg2IHdvdWxkIC0gYnV0IEkg
dGhpbmsgdGhlICdyZWdwYXJtJyBvcHRpb24gaW5jbHVkZXMgcGFzc2luZyBzbWFsbA0Kc3RydWN0
dXJlcyBieSB2YWx1ZS4NCkkgdGhpbmsgc3BhcmMzMiB1c2VkIHRvLCBidXQgdGhhdCBtaWdodCBo
YXZlIGNoYW5nZWQgaW4gdGhlIGxhc3QgMzAgeWVhcnMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3Rl
cmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtl
eW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

