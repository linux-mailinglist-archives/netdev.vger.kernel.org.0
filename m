Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B254B6452C1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiLGDzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGDzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:55:39 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6936C4E686;
        Tue,  6 Dec 2022 19:55:38 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B73sTNF1004563, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B73sTNF1004563
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 7 Dec 2022 11:54:29 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 7 Dec 2022 11:55:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 7 Dec 2022 11:55:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 7 Dec 2022 11:55:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Topic: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Index: AQHZCe2b+2Cm8cdsR0GFzEgG7Xr+X65hx/Zw//98QoCAAIbk4A==
Date:   Wed, 7 Dec 2022 03:55:16 +0000
Message-ID: <159ac3a296164b05b319bfb254a7901b@realtek.com>
References: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
 <2ac07b1d6e06443b95befb79d27549d2@realtek.com>
 <b4b65c74-792f-4df1-18bf-5c6f80845814@zzy040330.moe>
In-Reply-To: <b4b65c74-792f-4df1-18bf-5c6f80845814@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzcg5LiK5Y2IIDAxOjI4OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSnVuIEFTQUtBIDxKdW5B
U0FLQUB6enkwNDAzMzAubW9lPg0KPiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDcsIDIwMjIg
MTE6NTEgQU0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgSmVzLlNv
cmVuc2VuQGdtYWlsLmNvbQ0KPiBDYzoga3ZhbG9Aa2VybmVsLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0
LmNvbTsNCj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjVdIHdpZmk6IHJ0bDh4eHh1OiBmaXhpbmcgSVFLIGZhaWx1cmVzIGZvciBydGw4MTkyZXUN
Cj4gDQo+IE9uIDA3LzEyLzIwMjIgMTE6NDMsIFBpbmctS2UgU2hpaCB3cm90ZToNCj4gPg0KPiA+
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBKdW4gQVNBS0EgPEp1bkFT
QUtBQHp6eTA0MDMzMC5tb2U+DQo+ID4+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgNywgMjAy
MiAxMTozOSBBTQ0KPiA+PiBUbzogSmVzLlNvcmVuc2VuQGdtYWlsLmNvbQ0KPiA+PiBDYzoga3Zh
bG9Aa2VybmVsLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsg
a3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPj4gbGludXgtd2lyZWxlc3NA
dmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBKdW4gQVNBS0ENCj4gPj4gPEp1bkFTQUtBQHp6eTA0MDMzMC5tb2U+OyBQ
aW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPj4gU3ViamVjdDogW1BBVENIIHY1
XSB3aWZpOiBydGw4eHh4dTogZml4aW5nIElRSyBmYWlsdXJlcyBmb3IgcnRsODE5MmV1DQo+ID4+
DQo+ID4+IEZpeGluZyAiUGF0aCBBIFJYIElRSyBmYWlsZWQiIGFuZCAiUGF0aCBCIFJYIElRSyBm
YWlsZWQiDQo+ID4+IGlzc3VlcyBmb3IgcnRsODE5MmV1IGNoaXBzIGJ5IHJlcGxhY2luZyB0aGUg
YXJndW1lbnRzIHdpdGgNCj4gPj4gdGhlIG9uZXMgaW4gdGhlIHVwZGF0ZWQgb2ZmaWNpYWwgZHJp
dmVyIGFzIHNob3duIGJlbG93Lg0KPiA+PiAxLiBodHRwczovL2dpdGh1Yi5jb20vTWFuZ2UvcnRs
ODE5MmV1LWxpbnV4LWRyaXZlcg0KPiA+PiAyLiB2ZW5kb3IgZHJpdmVyIHZlcnNpb246IDUuNi40
DQo+ID4+DQo+ID4+IFRlc3RlZC1ieTogSnVuIEFTQUtBIDxKdW5BU0FLQUB6enkwNDAzMzAubW9l
Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBKdW4gQVNBS0EgPEp1bkFTQUtBQHp6eTA0MDMzMC5tb2U+
DQo+ID4+IFJldmlld2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4g
Pj4gLS0tDQo+ID4+IHY1Og0KPiA+PiAgIC0gbm8gbW9kaWZpY2F0aW9uLg0KPiA+IFRoZW4sIHdo
eSBkbyB5b3UgbmVlZCB2NT8NCj4gV2VsbCzCoCBJIGp1c3Qgd2FudCB0byBhZGQgdGhlICJSZXZp
ZXdlZC1CeSIgbGluZSB0byB0aGUgY29tbWl0IG1lc3NhZ2UuDQo+IFNvcnJ5IGZvciB0aGUgbm9p
c2UgaWYgdGhlcmUgaXMgbm8gbmVlZCB0byBkbyB0aGF0Lg0KPiANCg0KTm8gbmVlZCB0byBhZGQg
IlJldmlld2VkLUJ5Ii4gS2FsbGUgd2lsbCBhZGQgaXQgd2hlbiB0aGlzIHBhdGNoIGdldHMgbWVy
Z2VkLg0KDQpQaW5nLUtlDQoNCg==
