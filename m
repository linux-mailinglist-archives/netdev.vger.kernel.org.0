Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C875FC18C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJLH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJLH7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:59:33 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7455AB1BA7
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 00:59:30 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29C7wi8X3028637, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29C7wi8X3028637
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 12 Oct 2022 15:58:44 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 15:59:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 12 Oct 2022 15:59:13 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Wed, 12 Oct 2022 15:59:13 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K4FMJuAgAU+f1A=
Date:   Wed, 12 Oct 2022 07:59:12 +0000
Message-ID: <6781f98dd232471791be8b0168f0153a@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
In-Reply-To: <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzEyIOS4iuWNiCAwNjowMDowMA==?=
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

PiANCj4gT24gMDQuMTAuMjAyMiAxMDoxMCwgQ2h1bmhhbyBMaW4gd3JvdGU6DQo+ID4gV2hlbiBj
bG9zZSBkZXZpY2UsIHJ4IHdpbGwgYmUgZW5hYmxlZCBpZiB3b2wgaXMgZW5hYmVsZC4gV2hlbiBv
cGVuDQo+ID4gZGV2aWNlIGl0IHdpbGwgY2F1c2UgcnggdG8gZG1hIHRvIHdyb25nIGFkZHJlc3Mg
YWZ0ZXIgcGNpX3NldF9tYXN0ZXIoKS4NCj4gPg0KPiA+IEluIHRoaXMgcGF0Y2gsIGRyaXZlciB3
aWxsIGRpc2FibGUgdHgvcnggd2hlbiBjbG9zZSBkZXZpY2UuIElmIHdvbCBpcw0KPiA+IGVhbmJs
ZWQgb25seSBlbmFibGUgcnggZmlsdGVyIGFuZCBkaXNhYmxlIHJ4ZHZfZ2F0ZSB0byBsZXQgaGFy
ZHdhcmUNCj4gPiBjYW4gcmVjZWl2ZSBwYWNrZXQgdG8gZmlmbyBidXQgbm90IHRvIGRtYSBpdC4N
Cj4gPg0KPiA+IEZpeGVzOiAxMjAwNjg0ODE0MDUgKCJyODE2OTogZml4IGZhaWxpbmcgV29MIikN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHVuaGFvIExpbiA8aGF1QHJlYWx0ZWsuY29tPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYyB8IDE0ICsr
KysrKystLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVh
bHRlay9yODE2OV9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgx
NjlfbWFpbi5jDQo+ID4gaW5kZXggMWI3ZmRiNGYwNTZiLi5jMDljZmJlMWQzZjAgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiA+IEBAIC0y
MjM5LDYgKzIyMzksOSBAQCBzdGF0aWMgdm9pZCBydGxfd29sX2VuYWJsZV9yeChzdHJ1Y3QNCj4g
cnRsODE2OV9wcml2YXRlICp0cCkNCj4gPiAgCWlmICh0cC0+bWFjX3ZlcnNpb24gPj0gUlRMX0dJ
R0FfTUFDX1ZFUl8yNSkNCj4gPiAgCQlSVExfVzMyKHRwLCBSeENvbmZpZywgUlRMX1IzMih0cCwg
UnhDb25maWcpIHwNCj4gPiAgCQkJQWNjZXB0QnJvYWRjYXN0IHwgQWNjZXB0TXVsdGljYXN0IHwg
QWNjZXB0TXlQaHlzKTsNCj4gPiArDQo+ID4gKwlpZiAodHAtPm1hY192ZXJzaW9uID49IFJUTF9H
SUdBX01BQ19WRVJfNDApDQo+ID4gKwkJUlRMX1czMih0cCwgTUlTQywgUlRMX1IzMih0cCwgTUlT
QykgJiB+UlhEVl9HQVRFRF9FTik7DQo+IA0KPiBJcyB0aGlzIGNvcnJlY3QgYW55d2F5PyBTdXBw
b3NlZGx5IHlvdSB3YW50IHRvIHNldCB0aGlzIGJpdCB0byBkaXNhYmxlIERNQS4NCj4gDQpJZiB3
b2wgaXMgZW5hYmxlZCwgZHJpdmVyIG5lZWQgdG8gZGlzYWJsZSBoYXJkd2FyZSByeGR2X2dhdGUg
Zm9yIHJlY2VpdmluZyBwYWNrZXRzLg0KDQotLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmly
b25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
