Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093FD6C9F11
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjC0JMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjC0JMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:12:18 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DBC49E8;
        Mon, 27 Mar 2023 02:12:15 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32R9BfaN6021750, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32R9BfaN6021750
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 27 Mar 2023 17:11:41 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Mar 2023 17:11:57 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 27 Mar 2023 17:11:57 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 27 Mar 2023 17:11:57 +0800
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
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZW3PmZA7gPA0kmU6G6BuQjRUl4q8HoQbggAAT5QCAAIJ4AIAGJ0Tw
Date:   Mon, 27 Mar 2023 09:11:56 +0000
Message-ID: <33e7ca4c7ba947d68d451e919837f6b7@realtek.com>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-3-martin.blumenstingl@googlemail.com>
 <f7b9dda9d852456caffc3c0572f88947@realtek.com>
 <CAFBinCCspK=GaCMEiHsXi=0H4Sbp2vg_4EK=8bqQLWR8+qg7Sw@mail.gmail.com>
 <CAFBinCAxuEyNkUxsqJ9wVxXupErcp33JCFsJ2hDupWj9MRMYGA@mail.gmail.com>
In-Reply-To: <CAFBinCAxuEyNkUxsqJ9wVxXupErcp33JCFsJ2hDupWj9MRMYGA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1lbnN0
aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5
LCBNYXJjaCAyNCwgMjAyMyAzOjA0IEFNDQo+IFRvOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgWWFuLUhzdWFu
IENodWFuZyA8dG9ueTA2MjBlbW1hQGdtYWlsLmNvbT47IEthbGxlIFZhbG8NCj4gPGt2YWxvQGtl
cm5lbC5vcmc+OyBVbGYgSGFuc3NvbiA8dWxmLmhhbnNzb25AbGluYXJvLm9yZz47IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1t
Y0B2Z2VyLmtlcm5lbC5vcmc7IENocmlzIE1vcmdhbiA8bWFjcm9hbHBoYTgyQGdtYWlsLmNvbT47
IE5pdGluIEd1cHRhDQo+IDxuaXRpbi5ndXB0YTk4MUBnbWFpbC5jb20+OyBOZW8gSm91IDxuZW9q
b3VAZ21haWwuY29tPjsgSmVybmVqIFNrcmFiZWMgPGplcm5lai5za3JhYmVjQGdtYWlsLmNvbT47
IExhcnJ5DQo+IEZpbmdlciA8TGFycnkuRmluZ2VyQGx3ZmluZ2VyLm5ldD4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MyAyLzldIHdpZmk6IHJ0dzg4OiBzZGlvOiBBZGQgSENJIGltcGxlbWVudGF0
aW9uIGZvciBTRElPIGJhc2VkIGNoaXBzZXRzDQo+IA0KPiBIZWxsbyBQaW5nLUtlLA0KPiANCj4g
T24gVGh1LCBNYXIgMjMsIDIwMjMgYXQgMTI6MTbigK9QTSBNYXJ0aW4gQmx1bWVuc3RpbmdsDQo+
IDxtYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gWy4uLl0NCj4g
PiA+ID4gKyAgICAgICBpZiAoZGlyZWN0KSB7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICBhZGRy
ID0gcnR3X3NkaW9fdG9fYnVzX29mZnNldChydHdkZXYsIGFkZHIpOw0KPiA+ID4gPiArICAgICAg
ICAgICAgICAgdmFsID0gcnR3X3NkaW9fcmVhZGwocnR3ZGV2LCBhZGRyLCAmcmV0KTsNCj4gPiA+
ID4gKyAgICAgICB9IGVsc2UgaWYgKGFkZHIgJiAzKSB7DQo+ID4gPg0KPiA+ID4gZWxzZSBpZiAo
SVNfQUxJR05FRChhZGRyLCA0KSB7DQo+ID4gSSdsbCBhZGQgdGhlc2UgSVNfQUxJR05FRCBpbiB2
NA0KPiA+IEFsc28gSSBmb3VuZCBhbiBpc3N1ZSB3aXRoIFJUV19XQ1BVXzExTiBkZXZpY2VzIHdo
ZXJlIGluZGlyZWN0IHJlYWQNCj4gPiB3b3JrcyBkaWZmZXJlbnRseSAodGhvc2UgY2FuJ3QgdXNl
DQo+ID4gUkVHX1NESU9fSU5ESVJFQ1RfUkVHX0NGRy9SRUdfU0RJT19JTkRJUkVDVF9SRUdfREFU
QSBidXQgbmVlZCB0byBnbw0KPiA+IHRocm91Z2ggdGhlIG5vcm1hbCBwYXRoIHdpdGggV0xBTl9J
T1JFR19PRkZTRVQgaW5zdGVhZCkuIEknbGwgYWxzbw0KPiA+IGluY2x1ZGUgdGhhdCBmaXggaW4g
djQNCj4gSSBoYXZlIGEgcXVlc3Rpb24gYWJvdXQgdGhlICJpbmRpcmVjdCIgaGFuZGxpbmcuDQo+
IExldCBtZSBzdGFydCB3aXRoIHdoYXQgSSBrbm93Og0KPiAtIFJFR19TRElPX0lORElSRUNUX1JF
R19DRkcgYW5kIFJFR19TRElPX0lORElSRUNUX1JFR19EQVRBIGFyZSBvbmx5DQo+IHByZXNlbnQg
b24gUlRXX1dDUFVfMTFBQyBiYXNlZCBjaGlwcyAob2xkZXIgUlRXX1dDUFVfMTFOIGNoaXBzIGRv
bid0DQo+IGhhdmUgdGhlc2UgcmVnaXN0ZXJzKQ0KPiAtIHRoZSBuYW1lIG9mIFJFR19TRElPX0lO
RElSRUNUX1JFR19DRkdbMjBdIGlzIG5vdCBrbm93biBidXQgd2UncmUNCj4gcG9sbGluZyB0aGF0
IGJpdCB0byBjaGVjayBpZiBSRUdfU0RJT19JTkRJUkVDVF9SRUdfREFUQSBpcyByZWFkeSB0byBi
ZQ0KPiByZWFkIG9yIGhhcyBkYXRhIGZyb20gUkVHX1NESU9fSU5ESVJFQ1RfUkVHX0RBVEEgaGFz
IGJlZW4gd3JpdHRlbg0KPiAtIFJFR19TRElPX0lORElSRUNUX1JFR19DRkdbMTldIGNvbmZpZ3Vy
ZXMgYSByZWFkIG9wZXJhdGlvbg0KPiAtIFJFR19TRElPX0lORElSRUNUX1JFR19DRkdbMThdIGNv
bmZpZ3VyZXMgYSB3cml0ZSBvcGVyYXRpb24NCj4gLSBSRUdfU0RJT19JTkRJUkVDVF9SRUdfQ0ZH
WzE3XSBpbmRpY2F0ZXMgdGhhdCBhIERXT1JEICgzMi1iaXQpIGFyZQ0KPiB3cml0dGVuIHRvIFJF
R19TRElPX0lORElSRUNUX1JFR19EQVRBICgrIHRoZSBmb2xsb3dpbmcgMyksIHRoaXMgYml0DQo+
IHNlZW1zIGlycmVsZXZhbnQgZm9yIHJlYWQgbW9kZQ0KPiAtIFJFR19TRElPX0lORElSRUNUX1JF
R19DRkdbMTZdIGluZGljYXRlcyB0aGF0IGEgRFdPUkQgKDE2LWJpdCkgYXJlDQo+IHdyaXR0ZW4g
dG8gUkVHX1NESU9fSU5ESVJFQ1RfUkVHX0RBVEEgKCsgdGhlIGZvbGxvd2luZyAzKSwgdGhpcyBi
aXQNCj4gc2VlbXMgaXJyZWxldmFudCBmb3IgcmVhZCBtb2RlDQo+IC0gUlRXX1dDUFVfMTFOIGNo
aXBzIGFyZSBzaW1wbHkgdXNpbmcgImFkZHIgfCBXTEFOX0lPUkVHX09GRlNFVCIgZm9yDQo+IGFj
Y2Vzc2VzIHRoYXQgd291bGQgdXN1YWxseSBiZSAiaW5kaXJlY3QiIHJlYWRzL3dyaXRlcyBvbg0K
PiBSVFdfV0NQVV8xMUFDIGNoaXBzDQo+IA0KPiBXaGlsZSBmaXhpbmcgdGhlIGlzc3VlIGZvciB0
aGUgUlRXX1dDUFVfMTFOIGNoaXBzIEkgZGlzY292ZXJlZCB0aGF0DQo+IHRoZSAib2xkIiBhcHBy
b2FjaCBmb3IgaW5kaXJlY3QgcmVnaXN0ZXIgYWNjZXNzICh3aXRob3V0DQo+IFJFR19TRElPX0lO
RElSRUNUX1JFR19DRkcgYW5kIFJFR19TRElPX0lORElSRUNUX1JFR19EQVRBKSBhbHNvIHdvcmtz
DQo+IG9uIFJUV19XQ1BVXzExQUMgY2hpcHMuDQo+IChJJ20gY2FsbGluZyBpdCB0aGUgIm9sZCIg
YXBwcm9hY2ggYmVjYXVzZSBpdCdzIHdoYXQgdGhlIFJUTDg3MjNEUyBhbg0KPiBSVEw4NzIzQlMg
dmVuZG9yIGRyaXZlcnMgdXNlKQ0KPiBJbiBmYWN0LCB0aGlzIHNlcmllcyBpcyB1c2luZyB0aGUg
Im9sZCIgYXBwcm9hY2ggZm9yIHdyaXRlcywgYnV0IHRoZQ0KPiBuZXcgKFJFR19TRElPX0lORElS
RUNUX1JFR19DRkcgYW5kIFJFR19TRElPX0lORElSRUNUX1JFR19EQVRBIGJhc2VkKQ0KPiBhcHBy
b2FjaCBmb3IgcmVhZHMuDQo+IE5hdHVyYWxseSBJJ20gY3VyaW91cyBhcyB0byB3aHkgdHdvIGRp
ZmZlcmVudCBhcHByb2FjaGVzIGFjaGlldmUgdGhlDQo+IHNhbWUgZ29hbC4gVXNpbmcgdGhlICJv
bGQiIGFwcHJvYWNoIChhZGRyIHwgV0xBTl9JT1JFR19PRkZTRVQpIG1lYW5zIGENCj4gbG90IG9m
IGNvZGUgY291bGQgYmUgZGVsZXRlZC9zaW1wbGlmaWVkLg0KPiANCj4gTm93IG15IHF1ZXN0aW9u
Og0KPiBEbyB5b3UgaGF2ZSBhbnkgZXhwbGFuYXRpb24gKGVpdGhlciBmcm9tIGludGVybmFsIGRv
Y3VtZW50YXRpb24gb3INCj4gZnJvbSB0aGUgaGFyZHdhcmUvZmlybXdhcmUgdGVhbXMpIGlmIGFu
ZCB3aGVuIHRoZQ0KPiBSRUdfU0RJT19JTkRJUkVDVF9SRUdfQ0ZHIGFuZCBSRUdfU0RJT19JTkRJ
UkVDVF9SRUdfREFUQSByZWdpc3RlcnMNCj4gc2hvdWxkIGJlIHVzZWQgb24gUlRXX1dDUFVfMTFB
QyBjaGlwcz8NCj4gDQoNClVzaW5nIFJFR19TRElPX0lORElSRUNUX1JFR19DRkcgYW5kIFJFR19T
RElPX0lORElSRUNUX1JFR19EQVRBIGlmIHlvdSBhcmUNCnVzaW5nIFNESU8gMy4wOyBvdGhlcndp
c2UsIGl0IGNvdWxkIGNhdXNlcyBJTyBhYm5vcm1hbC4gT3Bwb3NpdGVseSwgdXNpbmcNCiJvbGQi
IGFwcHJvYWNoIChhZGRyIHwgV0xBTl9JT1JFR19PRkZTRVQpIGZvciBTRElPIDIuMC4gDQoNClBp
bmctS2UNCg0K
