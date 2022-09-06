Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6C5AE5EB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiIFKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiIFKtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:49:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626CA7C53E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 03:48:22 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-170--JVNHMPkOBmnvHtxzro39Q-1; Tue, 06 Sep 2022 11:48:17 +0100
X-MC-Unique: -JVNHMPkOBmnvHtxzro39Q-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 6 Sep
 2022 11:48:16 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 6 Sep 2022 11:48:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexey Dobriyan' <adobriyan@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: setns() affecting other threads in 5.10.132 and 6.0
Thread-Topic: setns() affecting other threads in 5.10.132 and 6.0
Thread-Index: AdjAZGr2bm2+BO9aR228APTLkn1hUgApqGgQAA6DpAAAJbwx0A==
Date:   Tue, 6 Sep 2022 10:48:16 +0000
Message-ID: <6204a74ef41a4463a790962d0409d0bc@AcuMS.aculab.com>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
 <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
 <YxYytPTFwYr7vBTo@localhost.localdomain>
In-Reply-To: <YxYytPTFwYr7vBTo@localhost.localdomain>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
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

RnJvbTogQWxleGV5IERvYnJpeWFuDQo+IFNlbnQ6IDA1IFNlcHRlbWJlciAyMDIyIDE4OjMzDQo+
ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogRGF2aWQgTGFpZ2h0
IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT4NCj4gPiA+IFNlbnQ6IDA0IFNlcHRlbWJlciAyMDIy
IDE1OjA1DQo+ID4gPg0KPiA+ID4gU29tZXRpbWUgYWZ0ZXIgNS4xMC4xMDUgKDUuMTAuMTMyIGFu
ZCA2LjApIHRoZXJlIGlzIGEgY2hhbmdlIHRoYXQNCj4gPiA+IG1ha2VzIHNldG5zKG9wZW4oIi9w
cm9jLzEvbnMvbmV0IikpIGluIHRoZSBtYWluIHByb2Nlc3MgY2hhbmdlcw0KPiA+ID4gdGhlIGJl
aGF2aW91ciBvZiBvdGhlciBwcm9jZXNzIHRocmVhZHMuDQo+IA0KPiBOb3QgYWdhaW4uLi4NCg0K
SSd2ZSByZWFsaXNlZCB3aGF0IGlzIGdvaW5nIG9uLg0KSXQgcmVhbGx5IGlzbid0IG9idmlvdXMg
YXQgYWxsLg0KUXVpdGUgcG9zc2libHkgdGhlIGxhc3QgY2hhbmdlIGRpZCBmaXggaXQgLSBldmVu
IHRob3VnaA0KaXQgYnJva2Ugb3VyIGNvZGUuDQoNCi9wcm9jL25ldCBpcyBhIHN5bWxpbmsgdG8g
L3Byb2Mvc2VsZi9uZXQuDQpCdXQgdGhhdCBpc24ndCB3aGF0IHRoZSBjb2RlIHdhbnRzIHRvIG9w
ZW4uDQpXaGF0IGl0IG5lZWRzIGlzIC9wcm9jL3NlbGYvdGFzay9zZWxmL25ldC4NCkJ1dCB0aGVy
ZSBpc24ndCBhICdzZWxmJyBpbiAvcHJvYy9zZWxmL3Rhc2suDQpXaGljaCBtYWtlcyBpdCBhbGwg
YSBiaXQgdGVkaW91cyAoZXNwZWNpYWxseSB3aXRob3V0IGdldHRpZCgpIGluIGdsaWJjKS4NCihU
aGlzIGlzIGEgYnVzeWJveC9idWlsZHJvb3Qgc3lzdGVtLCBtYXliZSBJIGNvdWxkIGFkZCBpdCEp
DQoNCkknZCBwcm9iYWJseSBoYXZlIG5vdGljZWQgZWFybGllciBpZiB0aGUgL3Byb2MvbmV0DQpz
eW1saW5rIGRpZG4ndCBleGlzdC4NCkkgZ3Vlc3MgdGhhdCBpcyBmb3IgY29tcGF0aWJpbGl0eSB3
aXRoIHByZS1uZXRucyBrZXJuZWxzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

