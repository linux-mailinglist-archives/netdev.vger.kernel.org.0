Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E609475409
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 09:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhLOID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 03:03:57 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58571 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbhLOIDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 03:03:55 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BF83FXz8030907, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BF83FXz8030907
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Dec 2021 16:03:15 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 16:03:15 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 16:03:14 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Wed, 15 Dec 2021 16:03:14 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Topic: [PATCH v3] rtw88: Disable PCIe ASPM while doing NAPI poll on
 8821CE
Thread-Index: AQHX8YDYOCaEEbbPt02IDewkrgYt1Kwynf2AgACSw8A=
Date:   Wed, 15 Dec 2021 08:03:14 +0000
Message-ID: <1bf16614c29e47d8a57cfd6ee4ee50ae@realtek.com>
References: <20211215065508.313330-1-kai.heng.feng@canonical.com>
 <CAPpJ_eff_NC3w7QjGtYtLjOBtSFBuRkFHojnuPC7neOmd54wcg@mail.gmail.com>
In-Reply-To: <CAPpJ_eff_NC3w7QjGtYtLjOBtSFBuRkFHojnuPC7neOmd54wcg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzE1IOS4iuWNiCAwNzoyNDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppYW4tSG9uZyBQYW4gPGpo
cEBlbmRsZXNzb3Mub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDE1LCAyMDIxIDM6
MTYgUE0NCj4gDQo+IFRyaWVkIHRvIGFwcGx5IHRoaXMgcGF0Y2ggZm9yIHRlc3RpbmcuICBCdXQg
aXQgc2VlbXMgY29uZmxpY3RpbmcgdG8NCj4gY29tbWl0IGM4MWVkYjhkZGRhYSAicnR3ODg6IGFk
ZCBxdWlyayB0byBkaXNhYmxlIHBjaSBjYXBzIG9uIEhQIDI1MCBHNw0KPiBOb3RlYm9vayBQQyIg
aW4gd2lyZWxlc3MtZHJpdmVycy1uZXh0IHJlcG8uDQo+IA0KDQpJIGZpeCB0aGUgY29uZmxpY3Qg
bWFudWFsbHksIGFuZCB0aGUgQVNQTSBzZXR0aW5nIGlzIGV4cGVjdGVkLg0KDQotLQ0KUGluZy1L
ZQ0KDQo=
