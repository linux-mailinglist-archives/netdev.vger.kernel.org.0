Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214C96B86E7
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCNA3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCNA3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:29:01 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B56580D7;
        Mon, 13 Mar 2023 17:28:57 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32E0ST5V0002432, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32E0ST5V0002432
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 14 Mar 2023 08:28:29 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Mar 2023 08:28:41 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 14 Mar 2023 08:28:40 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Tue, 14 Mar 2023 08:28:40 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Thread-Topic: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in
 rtw_mac_power_switch()
Thread-Index: AQHZU48RHUVrRx5DKki3zO3RS/BQyK73/dpQgACj0ICAAM7DoA==
Date:   Tue, 14 Mar 2023 00:28:40 +0000
Message-ID: <0f7b543f6f1d4856af3519a5c108c202@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-2-martin.blumenstingl@googlemail.com>
 <14619a051589472292f8270c2c291204@realtek.com>
 <CAFBinCBpeOH4tzrqHxPQ475=HLOWDKfJYLEEigfTmTJwQbGAAw@mail.gmail.com>
In-Reply-To: <CAFBinCBpeOH4tzrqHxPQ475=HLOWDKfJYLEEigfTmTJwQbGAAw@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1lbnN0
aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogVHVlc2Rh
eSwgTWFyY2ggMTQsIDIwMjMgNDowOCBBTQ0KPiBUbzogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVh
bHRlay5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IFlhbi1Ic3Vh
biBDaHVhbmcgPHRvbnkwNjIwZW1tYUBnbWFpbC5jb20+OyBLYWxsZSBWYWxvDQo+IDxrdmFsb0Br
ZXJuZWwub3JnPjsgVWxmIEhhbnNzb24gPHVsZi5oYW5zc29uQGxpbmFyby5vcmc+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1t
bWNAdmdlci5rZXJuZWwub3JnOyBDaHJpcyBNb3JnYW4gPG1hY3JvYWxwaGE4MkBnbWFpbC5jb20+
OyBOaXRpbiBHdXB0YQ0KPiA8bml0aW4uZ3VwdGE5ODFAZ21haWwuY29tPjsgTmVvIEpvdSA8bmVv
am91QGdtYWlsLmNvbT47IEplcm5laiBTa3JhYmVjIDxqZXJuZWouc2tyYWJlY0BnbWFpbC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgUkZDIDEvOV0gd2lmaTogcnR3ODg6IENsZWFyIFJU
V19GTEFHX1BPV0VST04gZWFybHkgaW4gcnR3X21hY19wb3dlcl9zd2l0Y2goKQ0KPiANCj4gSGVs
bG8gUGluZy1LZSwNCj4gDQo+IE9uIE1vbiwgTWFyIDEzLCAyMDIzIGF0IDM6MjnigK9BTSBQaW5n
LUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+ID4gPiArICAg
ICAgIGlmICghcHdyX29uKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIGNsZWFyX2JpdChSVFdfRkxB
R19QT1dFUk9OLCBydHdkZXYtPmZsYWdzKTsNCj4gPiA+ICsNCj4gPiA+ICAgICAgICAgcHdyX3Nl
cSA9IHB3cl9vbiA/IGNoaXAtPnB3cl9vbl9zZXEgOiBjaGlwLT5wd3Jfb2ZmX3NlcTsNCj4gPiA+
ICAgICAgICAgcmV0ID0gcnR3X3B3cl9zZXFfcGFyc2VyKHJ0d2RldiwgcHdyX3NlcSk7DQo+ID4g
PiAgICAgICAgIGlmIChyZXQpDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGNoYW5nZXMgdGhlIGJlaGF2
aW9yIGlmIHJ0d19wd3Jfc2VxX3BhcnNlcigpIHJldHVybnMgZXJyb3Igd2hpbGUNCj4gPiBkb2lu
ZyBwb3dlci1vZmYsIGJ1dCBJIGRpZyBhbmQgdGhpbmsgZnVydGhlciBhYm91dCB0aGlzIGNhc2Ug
aGFyZHdhcmUgc3RheXMgaW4NCj4gPiBhYm5vcm1hbCBzdGF0ZS4gSSB0aGluayBpdCB3b3VsZCBi
ZSBmaW5lIHRvIHNlZSB0aGlzIHN0YXRlIGFzIFBPV0VSX09GRi4NCj4gPiBEbyB5b3UgYWdyZWUg
dGhpcyBhcyB3ZWxsPw0KPiBJIGFncmVlIHdpdGggeW91LiBBbHNvIEkgdGhpbmsgSSBzaG91bGQg
aGF2ZSBtYWRlIGl0IGNsZWFyZXIgaW4gdGhlDQo+IGRlc2NyaXB0aW9uIG9mIHRoZSBwYXRjaCB0
aGF0IEknbSBwb3RlbnRpYWxseSBjaGFuZ2luZyB0aGUgYmVoYXZpb3INCj4gKGFuZCB0aGF0IHRo
aXMgaXMgbm90IGFuIGlzc3VlIGluIG15IG9waW5pb24pLg0KPiBJZiB0aGVyZSdzIGFueSBwcm9i
bGVtIGR1cmluZyB0aGUgcG93ZXIgb24vb2ZmIHNlcXVlbmNlIHRoZW4gd2UgY2FuJ3QNCj4gYmUg
ZnVsbHkgc3VyZSBhYm91dCB0aGUgcG93ZXIgc3RhdGUuDQo+IElmIHlvdSBoYXZlIGFueSBzdWdn
ZXN0aW9ucyBob3cgdG8gaW1wcm92ZSB0aGlzIHRoZW4gcGxlYXNlIGxldCBtZSBrbm93Lg0KPiAN
Cg0KTm8gbW9yZSBzdWdnZXN0aW9uIGZvciBub3cuIEp1c3QgYXBwbHkgeW91ciB0aG91Z2h0LiAN
Cg0KUGluZy1LZQ0KDQo=
