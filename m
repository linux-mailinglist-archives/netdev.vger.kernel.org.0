Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8416C61F7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjCWIiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCWIiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:38:01 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA412F01;
        Thu, 23 Mar 2023 01:36:47 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32N8aMOr9013097, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32N8aMOr9013097
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 16:36:22 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 23 Mar 2023 16:36:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 23 Mar 2023 16:36:37 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 16:36:37 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Jonas Gorski <jonas.gorski@gmail.com>
CC:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
Thread-Topic: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
Thread-Index: AQHZXNa3MLbDic+okUWUZsB7esnCtq8GfvKAgABBsICAAMlp0P//h0sAgAD4fxA=
Date:   Thu, 23 Mar 2023 08:36:37 +0000
Message-ID: <6d6c51a6e29448eeb5985a59d1875c3a@realtek.com>
References: <ZBskz06HJdLzhFl5@hyeyoo>
 <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
 <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
 <e4f8e55f843041978098f57ecb7e558b@realtek.com>
 <4c841575-1e02-32f2-b63d-52bc0c063c82@lwfinger.net>
In-Reply-To: <4c841575-1e02-32f2-b63d-52bc0c063c82@lwfinger.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGFycnkgRmluZ2VyIDxs
YXJyeS5maW5nZXJAZ21haWwuY29tPiBPbiBCZWhhbGYgT2YgTGFycnkgRmluZ2VyDQo+IFNlbnQ6
IFRodXJzZGF5LCBNYXJjaCAyMywgMjAyMyA5OjQxIEFNDQo+IFRvOiBQaW5nLUtlIFNoaWggPHBr
c2hpaEByZWFsdGVrLmNvbT47IEpvbmFzIEdvcnNraSA8am9uYXMuZ29yc2tpQGdtYWlsLmNvbT4N
Cj4gQ2M6IEh5ZW9uZ2dvbiBZb28gPDQyLmh5ZXlvb0BnbWFpbC5jb20+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtCVUcgdjYuMi43XSBIaXR0aW5nIEJVR19PTigpIG9uIHJ0dzg5IHdpcmVsZXNzIGRyaXZlciBz
dGFydHVwDQo+IA0KPiBQaW5nLUtlLA0KPiANCj4gVGhlIHBhdGNoIHdvcmtzIGZpbmUgaGVyZSwg
YnV0IEkgZGlkIG5vdCBoYXZlIHRoZSBwcm9ibGVtLg0KPiANCj4gV2hlbiB5b3Ugc3VibWl0IGl0
LCBhZGQgYSBUZXN0ZWQtYnk6IExhcnJ5IEZpbmdlcjxMYXJyeS5GaW5nZXJAbHdmaW5nZXIubmV0
PiBhbmQNCj4gYSBSZXZpZXdlZC1ieSBmb3IgdGhlIHNhbWUgYWRkcmVzcy4NCj4gDQoNCkhpIExh
cnJ5LA0KDQpUaGFua3MgZm9yIHlvdXIgdGVzdC4gSSBoYXZlIHN1Ym1pdHRlZCBwYXRjaCBbMV0g
d2l0aCB5b3VyIFRlc3RlZC1ieSBhbmQgUmV2aWV3ZWQtYnkuDQpCdXQsIHRoZSBwYXRjaCBpbmNs
dWRlcyBhZGRpdGlvbmFsIGVycm9yIGhhbmRsaW5nIGFkZHJlc3NlZCBkdXJpbmcgaW50ZXJuYWwN
CnJldmlldywgc28gdGhlcmUgaXMgYSBsaXR0bGUgZGlmZmVyZW50IGZyb20gdGhlIHBhdGNoIEkg
cG9zdGVkIGhlcmUuIElmIHlvdQ0KZG9uJ3QgYWdyZWUgY3VycmVudCB2ZXJzaW9uLCBwbGVhc2Ug
TkFDSyB0aGUgcGF0Y2ggWzFdLiANCg0KVGhhbmsgeW91Lg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMjAyMzAzMjMwODI4MzkuMjA0NzQtMS1wa3NoaWhAcmVh
bHRlay5jb20vVC8jdQ0KDQpQaW5nLUtlDQoNCg==
