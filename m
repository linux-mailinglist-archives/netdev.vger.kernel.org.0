Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F38D49DC37
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbiA0IHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:07:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49438 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiA0IHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:07:51 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20R86Lf94032135, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20R86Lf94032135
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jan 2022 16:06:21 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 16:06:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 16:06:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Thu, 27 Jan 2022 16:06:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Aaron Ma <aaron.ma@canonical.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
Thread-Topic: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Thread-Index: AQHYAkb+XWXmurlfvUCud8k7wjo3mqxUKRoAgABIlgCAAAqXAIAAPjsAgAC9QoCAANKOgIAACHCAgATH5wCAAN82AIAAluGAgADbvICAABjvgIAAAeSAgAAC1gCAAAMVAIAAA1gAgAABIwCAAbbOgIAAAcsAgACE9wCAFfeygIAA2/Vg
Date:   Thu, 27 Jan 2022 08:06:20 +0000
Message-ID: <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
 <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
 <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
In-Reply-To: <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMjcg5LiK5Y2IIDA0OjA1OjAw?=
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

QWFyb24gTWEgPGFhcm9uLm1hQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKYW51
YXJ5IDI3LCAyMDIyIDEwOjUyIEFNDQpbLi4uXQ0KPiBIaSBhbGwsDQo+IA0KPiBSZWFsdGVrIDgx
NTNCTCBjYW4gYmUgaWRlbnRpZmllZCBieSB0aGUgZm9sbG93aW5nIGNvZGUgZnJvbSBSZWFsdGVr
IE91dGJveA0KPiBkcml2ZXI6DQo+IH0gZWxzZSBpZiAodHAtPnZlcnNpb24gPT0gUlRMX1ZFUl8w
OSAmJiAob2NwX2RhdGEgJiBCTF9NQVNLKSkgew0KPiANCj4gSSB3aWxsIHN1Z2dlc3QgUmVhbHRl
ayB0byBzZW5kIG91dCB0aGlzIGNoYW5nZSBmb3IgcmV2aWV3Lg0KDQpJIGRvbid0IHRoaW5rIHRo
ZSBmZWF0dXJlIG9mIE1BQyBwYXNzdGhyb3VnaCBhZGRyZXNzIGlzIG1haW50YWluZWQNCmJ5IFJl
YWx0ZWsuIEVzcGVjaWFsbHksIHRoZXJlIGlzIG5vIHVuaWZvcm0gd2F5IGFib3V0IGl0LiBUaGUN
CmRpZmZlcmVudCBjb21wYW5pZXMgaGF2ZSB0byBtYWludGFpbiB0aGVpciBvd24gd2F5cyBieSB0
aGVtc2VsdmVzLg0KDQpSZWFsdGVrIGNvdWxkIHByb3ZpZGUgdGhlIG1ldGhvZCBvZiBmaW5kaW5n
IG91dCB0aGUgc3BlY2lmaWMgZGV2aWNlDQpmb3IgTGVub3ZvLiBZb3UgY291bGQgY2hlY2sgVVNC
IE9DUCAweEQ4MUYgYml0IDMuIEZvciBleGFtcGxlLA0KDQoJb2NwX2RhdGEgPSBvY3BfcmVhZF9i
eXRlKHRwLCBNQ1VfVFlQRV9VU0IsIFVTQl9NSVNDXzEpOw0KCWlmICh0cC0+dmVyc2lvbiA9PSBS
VExfVkVSXzA5ICYmIChvY3BfZGF0YSAmIEJJVCgzKSkpIHsNCgkJLyogVGhpcyBpcyB0aGUgUlRM
ODE1M0IgZm9yIExlbm92by4gKi8NCgl9DQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg==
