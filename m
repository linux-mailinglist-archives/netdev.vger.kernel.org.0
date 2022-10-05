Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC255F4F8D
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 07:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJEFon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 01:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJEFol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 01:44:41 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7C5CFF9
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 22:44:36 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2955huX03031805, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2955huX03031805
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 5 Oct 2022 13:43:56 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 13:44:23 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 13:44:22 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Wed, 5 Oct 2022 13:44:22 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K3+JisAgAEi+yA=
Date:   Wed, 5 Oct 2022 05:44:22 +0000
Message-ID: <25c7b354dff14ed381f91963f134a87c@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <840eab89-375a-bb28-9937-aeaa17922048@gmail.com>
In-Reply-To: <840eab89-375a-bb28-9937-aeaa17922048@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzUg5LiK5Y2IIDAyOjU5OjAw?=
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

PiBPbiAwNC4xMC4yMDIyIDEwOjEwLCBDaHVuaGFvIExpbiB3cm90ZToNCj4gPiBXaGVuIGNsb3Nl
IGRldmljZSwgcnggd2lsbCBiZSBlbmFibGVkIGlmIHdvbCBpcyBlbmFiZWxkLiBXaGVuIG9wZW4N
Cj4gPiBkZXZpY2UgaXQgd2lsbCBjYXVzZSByeCB0byBkbWEgdG8gd3JvbmcgYWRkcmVzcyBhZnRl
ciBwY2lfc2V0X21hc3RlcigpLg0KPiA+DQo+IEhpIEhhdSwNCj4gDQo+IEkgbmV2ZXIgZXhwZXJp
ZW5jZWQgdGhpcyBwcm9ibGVtLiBJcyBpdCBhbiBlZGdlIGNhc2UgdGhhdCBjYW4gb2NjdXIgdW5k
ZXINCj4gc3BlY2lmaWMgY2lyY3Vtc3RhbmNlcz8NCj4gDQoNClRoaXMgaXNzdWUgaXMgaGFwcGVu
IG9uIGdvb2dsZSBjaHJvbWVib29rIHdpdGggSU9NTVUgZW5hYmxlZC4gQmVjYXVzZSByeCBpcyBl
bmFibGVkIHdoZW4gd29sIGlzIGVuYWJsZWQsIA0Kc28gSSB0aGluayB0aGVyZSBpcyBhIGNoYW5j
ZSB0aGF0IHRoZSBwYWNrZXQgcmVjZWl2ZSBpbiBkZXZpY2UgY2xvc2Ugd2lsbCBiZSBkbWEgdG8g
aW52YWxpZCBtZW1vcnkgYWRkcmVzcyB3aGVuDQpkZXZpY2UgaXMgb3Blbi4NCg0KIC0tLS0tLVBs
ZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWls
Lg0K
