Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9C42BC6B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbhJMKHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:07:30 -0400
Received: from mail-eopbgr50109.outbound.protection.outlook.com ([40.107.5.109]:60807
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237434AbhJMKH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 06:07:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvy3n+rrCNptkkdmKE6J1RMraRCJSvuzcVaSozzMzk7eus9VVn18nbrftFBzUHN/TUUc5pMFaA9BLDhChBxJApz1A+O1i/ERsSWSqNW/lWTWkiCE32k4kgJTHoDTG5ESuhPBLqZx1DQ60/b99LNNOy6/bf42ZnW16BSYnZ36SJSH4VrXi47b9hMvWsfR9LbzPDGEIFGBH2Ju9xJ7SsaAHxJiUqS2C9uMluXUHXqswJQ2M9XZjeNbE0T3fRNsqvtNJr05syGli3pLnkibN8zUD5GFrrmnMk3GCgXN+V2Zo/Zs1jdVljesre/gXCVW5j/nQJWYXLOdQt/jVi7H2Hg5jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDIdAyXXdGpvi+5TU4BJpVaRkUN+fgy6hZYMsY1p5m8=;
 b=GJW5havl8ftMQHCiwm1nU8N/mfT8MRQ8uSZoJT6CJps/wvp18ybDtztFPGvld6LHCKhJ//cD9/fkNiMFfg1eFR5kg8/3h+tA8AtLkJXBJQmSaZrnsyWtaybUR5xw+5h0GBEpDJw+oIVgXcyCL6MZw2CJUaz6iyXZURz+3QkIHIgz/e1VEz+bzGXq5w4ZX6dgWYQRkz7WXGmr45oLibRQJ8ZiuTcKgCF6V6eH+awG2rSN8k6u/cEpxbTBxHPYoTbfm5tTzxo+vFB87T9psssCTU/w0SrPqvuziLGpIE4PLYyi1suvXua8QV6sagt9C47XkIOnVVwqtC95WvAkb3oTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDIdAyXXdGpvi+5TU4BJpVaRkUN+fgy6hZYMsY1p5m8=;
 b=eplXHcKlp5VQybZ9CtDQTkhNRCtNG+prRdFqTAw7uRdLuMHASxfaUlbpwtwj0VasQKNwvL6lDUfXoDOTKYoCHFxpGnr78gs4chk6sevwtY0+Ju5r3Da/nQNx1ViWex+iGuOfD6Ov6otGDNp2+BkV5dC6psz7RpM42CYHW/L2imY=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2395.eurprd03.prod.outlook.com (2603:10a6:3:6d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.19; Wed, 13 Oct 2021 10:05:21 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 10:05:21 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXv2Xnxc/wFCiERUe0xn+KS7nXfavQsf+AgAAC3QA=
Date:   Wed, 13 Oct 2021 10:05:21 +0000
Message-ID: <32ffccb4-ff8b-5e60-ad29-e32bcb22969f@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <20211013095505.55966-1-dqfext@gmail.com>
In-Reply-To: <20211013095505.55966-1-dqfext@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6123b661-70d8-49f4-4d07-08d98e30f7c3
x-ms-traffictypediagnostic: HE1PR0301MB2395:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0301MB23951A55D96B60D78E1A0CE283B79@HE1PR0301MB2395.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RiA3vps0zwhT6FixE80vw+YA385CKqAMdV8ZEdYxG89j4AzqBz0FgGBDtdCVU3I8ZoHkU3EY017ue6dS7B2WR6TifnJe5BLEVNWxgzEytujvMDkKpudzyz50x4ueCxXDo8CEAU2qbmE6FSzWigwObxAjoRL1KsKg+UNmKMRujwTTcivwiQt66eWH2Wu1f0QOpZhwNT95VRs9ftPaNHq79tfdAlG/bxzbQt15WZ0j4uoxEaSYl18u/PFm9Jb+SLUHTM1dRYjwQXaWJWEEhUIPYNCsQJ8PN+bMqU00OQ2hKFfMvopL2KIwWsYooTz96WaPi8K/IbD3wiRonhMMrbN1d/G66bbUJlNUaBpAYI4ls8laKQmflfChwP954NlWi1lpB2U7HCnUSgW93z4rXO7gM8z1qBA0C0eRvdF/5H4fCJMrtZpvwbHGogyrBkNypzc9TtOBQgFVYOh6NauIZBhTrvPaemnL6n6WlvPNAu7HJBfS2a4WosatniR2+uA/3nC7Z+bE7kAsXFntDHXh/+KO4OH0Jyb4Bd4wk8KvHPwDB8RsCZjjnWvMdAHahlw4cleaUVxwlDLMUPEaYp8ZWovVkwRfje3ihclCDTgwV8XtijYc15CKtcyJ2CCRdPSDHMgRhcsFpkRMS56gqiEFg3gQrkpNiGbPXNYHvTsR/0gFnshraBBRF1ILbrQkWIh867iNFeF4v3gRTtmEEhIf5sph+AeOaMEjli/AsM/9nKr+YsdtgTVZDYblKLvMJknqgolyP4HsLeNgAaez55v6E/8Ujw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38070700005)(31696002)(71200400001)(6506007)(110136005)(7416002)(508600001)(8676002)(316002)(2906002)(8936002)(86362001)(2616005)(53546011)(54906003)(5660300002)(122000001)(31686004)(64756008)(66946007)(8976002)(66574015)(6512007)(85202003)(26005)(76116006)(85182001)(186003)(36756003)(83380400001)(38100700002)(6486002)(66556008)(66446008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVFPVTlSbTQ1cnhjQmZaRFM0Wnh2Zmx0d3N1eDJoNm4rUkZzQjhvMlVnN0ov?=
 =?utf-8?B?UWR0MDBNUS9XRlBOS1RRa1hIbGZHNVFwaGtvcmNBMDBZZmUyVm5GZ3ZtcWFr?=
 =?utf-8?B?ZWtsOUJKRldwbkJ2MjU5T1VRMGtSRFFXN2wwOXFkVFE4YUZoNy9ZblVSL1NY?=
 =?utf-8?B?U3Z0V25Kckd3TWdCTGJtTFRCVVBnQ25YZEloZHBqS0tVL1N6b2plUjhXYUUz?=
 =?utf-8?B?UkRZOTRNV2ZvNmJrdVRvUGcxNnB0aGhlYjU3TmxvYnk4M0pwRmZzRXVaTlp4?=
 =?utf-8?B?ZWxZK2NVMnl6KzA4NGZQUENIcnlkRWtxeVB5bmw2d3dXRG5TYXlzMmY1RmhZ?=
 =?utf-8?B?MXVLcWo5TEN3V0JUbHlZaDVVczVnYjg1b24xZ1ozQmRiMlVSM3FuWGJzMUMr?=
 =?utf-8?B?Y3VRM255NU5DZVlmYzRONm5DSzd1aTd0eiswNkR3MWFlRVFOVE4vejFkb2t1?=
 =?utf-8?B?QmpMN0xsWEhSMVRYdmFpTWFudWNoQzFKTzBMaDY3REEvRXNRL1lXU3ZuVjVy?=
 =?utf-8?B?bW9HeTN6VXhOOXhrMW9oeHh5ZEFKb2tackRWekdtRG5LdGpxZVN1eEtzem1z?=
 =?utf-8?B?Q3JZVVExZ0hQQ3BlWE1qWTBvUm5jTmZ1SFdMWVA0SVRPc0FIaVY5UkpCWm1R?=
 =?utf-8?B?WFVyTmtmMVJqZkN3djloWXp6MFRvK05yNW1jenMwdnRpaUdBMHYyR213SEhC?=
 =?utf-8?B?SkhDVC9pSHM3Umc5YnFlWi92UFdaV3BYdVRQU2xnM0tIZzNtcWZyOTVkb0Qx?=
 =?utf-8?B?b2J0MzFEMys3NWlJVno3aXZtNDRsbnhTUldLYVFZdVZMc3BBN1ZrVWFraGRD?=
 =?utf-8?B?amFyZHpOMmd3d3NuUTJZMXczdXVYNFlIaXo4S2xCYkt0bVJRaVl5ei94YWFw?=
 =?utf-8?B?R2wyMXJtNHY2Vy83ak50V1BaclBJanJHdWh6NXRBLzVKWmlieWxWMGY5ZXF5?=
 =?utf-8?B?ZTQwNzRtQmVMWlFXQUM3TmlSTnMyWnp2L1ozMFExbzRjSjNkR0owRVo1QXhv?=
 =?utf-8?B?Nk8xOUVXUWhoN1VkL3JXOXNPUk9aS05zYytiTFl0dUJ2SUNPQTdzYmhBdnBs?=
 =?utf-8?B?NlVLUHBqRWV4SEd1Z3c2S1RQSVkyQk5PbjJ0QVZQZml4QUU4L1VCekI4UitV?=
 =?utf-8?B?YzAyK2R1QUIvaTZiOC93WGZtK2VadjlLUkh5V0YyRGJMUTBqaVA3eHdGOVEx?=
 =?utf-8?B?cmpocUIxcWZoT2Jmd0NmLzVwaTduYy8wOGtNbnVDTm1VMFdreE1nM3FOdjZm?=
 =?utf-8?B?SlRzVVVIaGlLM1A5OWVndWFQZjlDMmNqRlFFU3gzcm9LcEZEL0QwMkNxaHFI?=
 =?utf-8?B?MnF0M3oweERLdVdMWiszSmRRYTNEdDJ5OFhMMXgvRFpTTzdTTW1lbzhqblZB?=
 =?utf-8?B?ZWVpTndIZjlEaXlEWUtnZVM4Z1NBKzVrdFhrREtob1RDRjNaTURHR1lpTVRh?=
 =?utf-8?B?cnFzbjhjOElrVGtCamVmdjhPRE9XNHF3UW50QkNWeFNPOEExeGltRzlaVVFp?=
 =?utf-8?B?bmpIbk5wcm96d0xrQlRYMFlXdGpmMDBvRS9PYnU5UkpMejFTSDNzajFlWS84?=
 =?utf-8?B?RHoxMkxmaDE0K1FDcDBSNmNzTTQvbVk2cFQ1elVxVHFlWnVqN0NneHoyc3ZH?=
 =?utf-8?B?dEFYdDVGWENJMTU3ZThsWVIvdnpLbG9uU3JWN2dmUmlvTjFaUjU0SEFvaSsr?=
 =?utf-8?B?TWJCZGhDYW00Q0ZtQzY3eVhZZEJ5WFo0WXpUcytKZ0RwV0VSZVdxaldCUWcv?=
 =?utf-8?Q?+eCEJaUcHS/K4BzyRdZhIYp77bWb2OahYgcB8f4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61C2A39F8FF7E2428980B0B7C9E6FF12@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6123b661-70d8-49f4-4d07-08d98e30f7c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 10:05:21.5122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BG+11fu8JVvlyCu/2Zj+DWklctd85jCDELoOj98VC3TrUcl/CX7iFBLZk4GeLDcKhicJPXwxwVAW0wmVieaPfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2395
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTMvMjEgMTE6NTUgQU0sIERFTkcgUWluZ2Zhbmcgd3JvdGU6DQo+IE9uIFR1ZSwgT2N0
IDEyLCAyMDIxIGF0IDAyOjM1OjU0UE0gKzAyMDAsIEFsdmluIMWgaXByYWdhIHdyb3RlOg0KPj4g
Ky8qIFBvcnQgbWFwcGluZyBtYWNyb3MNCj4+ICsgKg0KPj4gKyAqIFBPUlRfTlVNX3gyeTogbWFw
IGEgcG9ydCBudW1iZXIgZnJvbSBkb21haW4geCB0byBkb21haW4geQ0KPj4gKyAqIFBPUlRfTUFT
S194Mnk6IG1hcCBhIHBvcnQgbWFzayBmcm9tIGRvbWFpbiB4IHRvIGRvbWFpbiB5DQo+PiArICoN
Cj4+ICsgKiBMID0gbG9naWNhbCBwb3J0IGRvbWFpbiwgaS5lLiBkc2FfcG9ydC5pbmRleA0KPj4g
KyAqIFAgPSBwaHlzaWNhbCBwb3J0IGRvbWFpbiwgdXNlZCBieSB0aGUgUmVhbHRlayBBU0lDIGZv
ciBwb3J0IGluZGV4aW5nOw0KPj4gKyAqICAgICBmb3IgcG9ydHMgd2l0aCBpbnRlcm5hbCBQSFlz
LCB0aGlzIGlzIGFsc28gdGhlIFBIWSBpbmRleA0KPj4gKyAqIEUgPSBleHRlbnNpb24gcG9ydCBk
b21haW4sIHVzZWQgYnkgdGhlIFJlYWx0ZWsgQVNJQyBmb3IgbWFuYWdpbmcgRVhUIHBvcnRzDQo+
PiArICoNCj4+ICsgKiBUaGUgdGVybWlub2xvZ3kgaXMgYm9ycm93ZWQgZnJvbSB0aGUgdmVuZG9y
IGRyaXZlci4gVGhlIGV4dGVuc2lvbiBwb3J0IGRvbWFpbg0KPj4gKyAqIGlzIG1vc3RseSB1c2Vk
IHRvIG5hdmlnYXRlIHRoZSBsYWJ5cmludGhpbmUgbGF5b3V0IG9mIEVYVCBwb3J0IGNvbmZpZ3Vy
YXRpb24NCj4+ICsgKiByZWdpc3RlcnMgYW5kIGlzIG5vdCBjb25zaWRlcmVkIGludHVpdGl2ZSBi
eSB0aGUgYXV0aG9yLg0KPj4gKyAqDQo+PiArICogVW5sZXNzIGEgZnVuY3Rpb24gaXMgYWNjZXNz
aW5nIGNoaXAgcmVnaXN0ZXJzLCBpdCBzaG91bGQgYmUgdXNpbmcgdGhlIGxvZ2ljYWwNCj4+ICsg
KiBwb3J0IGRvbWFpbi4gTW9yZW92ZXIsIGZ1bmN0aW9uIGFyZ3VtZW50cyBmb3IgcG9ydCBudW1i
ZXJzIGFuZCBwb3J0IG1hc2tzDQo+PiArICogbXVzdCBhbHdheXMgYmUgaW4gdGhlIGxvZ2ljYWwg
ZG9tYWluLiBUaGUgY29udmVyc2lvbiBtdXN0IGJlIGRvbmUgYXMgY2xvc2UgYXMNCj4+ICsgKiBw
b3NzaWJsZSB0byB0aGUgcmVnaXN0ZXIgYWNjZXNzIHRvIGF2b2lkIGNoYW9zLg0KPj4gKyAqDQo+
PiArICogVGhlIG1hcHBpbmdzIHZhcnkgYmV0d2VlbiBjaGlwcyBpbiB0aGUgZmFtaWx5IHN1cHBv
cnRlZCBieSB0aGlzIGRyaXZlci4gSGVyZQ0KPj4gKyAqIGlzIGFuIGV4YW1wbGUgb2YgdGhlIG1h
cHBpbmcgZm9yIHRoZSBSVEw4MzY1TUItVkM6DQo+PiArICoNCj4+ICsgKiAgICBMIHwgUCB8IEUg
fCByZW1hcmsNCj4+ICsgKiAgIC0tLSstLS0rLS0tKy0tLS0tLS0tDQo+PiArICogICAgMCB8IDAg
fCAgIHwgdXNlciBwb3J0DQo+PiArICogICAgMSB8IDEgfCAgIHwgdXNlciBwb3J0DQo+PiArICog
ICAgMiB8IDIgfCAgIHwgdXNlciBwb3J0DQo+PiArICogICAgMyB8IDMgfCAgIHwgdXNlciBwb3J0
DQo+PiArICogICAgNCB8IDYgfCAxIHwgZXh0ZW5zaW9uIChDUFUpIHBvcnQNCj4+ICsgKg0KPj4g
KyAqIE5PVEU6IEN1cnJlbnRseSB0aGlzIGlzIGhhcmRjb2RlZCBmb3IgdGhlIFJUTDgzNjVNQi1W
Qy4gVGhpcyB3aWxsIHByb2JhYmx5DQo+PiArICogcmVxdWlyZSBhIHJld29yayB3aGVuIGFkZGlu
ZyBzdXBwb3J0IGZvciBvdGhlciBjaGlwcy4NCj4+ICsgKi8NCj4+ICsjZGVmaW5lIENQVV9QT1JU
X0xPR0lDQUxfTlVNCTQNCj4+ICsjZGVmaW5lIENQVV9QT1JUX0xPR0lDQUxfTUFTSwlCSVQoQ1BV
X1BPUlRfTE9HSUNBTF9OVU0pDQo+PiArI2RlZmluZSBDUFVfUE9SVF9QSFlTSUNBTF9OVU0JNg0K
Pj4gKyNkZWZpbmUgQ1BVX1BPUlRfUEhZU0lDQUxfTUFTSwlCSVQoQ1BVX1BPUlRfUEhZU0lDQUxf
TlVNKQ0KPj4gKyNkZWZpbmUgQ1BVX1BPUlRfRVhURU5TSU9OX05VTQkxDQo+PiArDQo+PiArc3Rh
dGljIHUzMiBydGw4MzY1bWJfcG9ydF9udW1fbDJwKHUzMiBwb3J0KQ0KPj4gK3sNCj4+ICsJcmV0
dXJuIHBvcnQgPT0gQ1BVX1BPUlRfTE9HSUNBTF9OVU0gPyBDUFVfUE9SVF9QSFlTSUNBTF9OVU0g
OiBwb3J0Ow0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgdTMyIHJ0bDgzNjVtYl9wb3J0X21hc2tf
bDJwKHUzMiBtYXNrKQ0KPj4gK3sNCj4+ICsJdTMyIHBoeXNfbWFzayA9IG1hc2sgJiB+Q1BVX1BP
UlRfTE9HSUNBTF9NQVNLOw0KPj4gKw0KPj4gKwlpZiAobWFzayAmIENQVV9QT1JUX0xPR0lDQUxf
TUFTSykNCj4+ICsJCXBoeXNfbWFzayB8PSBDUFVfUE9SVF9QSFlTSUNBTF9NQVNLOw0KPj4gKw0K
Pj4gKwlyZXR1cm4gcGh5c19tYXNrOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgdTMyIHJ0bDgz
NjVtYl9wb3J0X21hc2tfcDJsKHUzMiBwaHlzX21hc2spDQo+PiArew0KPj4gKwl1MzIgbWFzayA9
IHBoeXNfbWFzayAmIH5DUFVfUE9SVF9QSFlTSUNBTF9NQVNLOw0KPj4gKw0KPj4gKwlpZiAocGh5
c19tYXNrICYgQ1BVX1BPUlRfUEhZU0lDQUxfTUFTSykNCj4+ICsJCW1hc2sgfD0gQ1BVX1BPUlRf
TE9HSUNBTF9NQVNLOw0KPj4gKw0KPj4gKwlyZXR1cm4gbWFzazsNCj4+ICt9DQo+PiArDQo+PiAr
I2RlZmluZSBQT1JUX05VTV9MMlAoX3ApIChydGw4MzY1bWJfcG9ydF9udW1fbDJwKF9wKSkNCj4+
ICsjZGVmaW5lIFBPUlRfTlVNX0wyRShfcCkgKENQVV9QT1JUX0VYVEVOU0lPTl9OVU0pDQo+PiAr
I2RlZmluZSBQT1JUX01BU0tfTDJQKF9tKSAocnRsODM2NW1iX3BvcnRfbWFza19sMnAoX20pKQ0K
Pj4gKyNkZWZpbmUgUE9SVF9NQVNLX1AyTChfbSkgKHJ0bDgzNjVtYl9wb3J0X21hc2tfcDJsKF9t
KSkNCj4gDQo+IFRoZSB3aG9sZSBwb3J0IG1hcHBpbmcgdGhpbmcgY2FuIGJlIGF2b2lkZWQgaWYg
eW91IGp1c3QgdXNlIHBvcnQgNiBhcyB0aGUgQ1BVDQo+IHBvcnQuDQoNCkFuZHJldyBhbHNvIHN1
Z2dlc3RlZCB0aGlzLCBidXQgdGhlIGRpc2NvbnRpbnVpdHkgaW4gcG9ydCBJRHMgc2VlbXMgdG8g
DQpiZSBhbiBpbnZpdGF0aW9uIGZvciB0cm91YmxlLiBIZXJlIGlzIGFuIGV4YW1wbGUgb2YgYSBz
ZXJpZXMgb2YgDQpmdW5jdGlvbnMgZnJvbSBkc2EuaDoNCg0Kc3RhdGljIGlubGluZSBzdHJ1Y3Qg
ZHNhX3BvcnQgKmRzYV90b19wb3J0KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHApDQp7DQoJ
c3RydWN0IGRzYV9zd2l0Y2hfdHJlZSAqZHN0ID0gZHMtPmRzdDsNCglzdHJ1Y3QgZHNhX3BvcnQg
KmRwOw0KDQoJbGlzdF9mb3JfZWFjaF9lbnRyeShkcCwgJmRzdC0+cG9ydHMsIGxpc3QpDQoJCWlm
IChkcC0+ZHMgPT0gZHMgJiYgZHAtPmluZGV4ID09IHApDQoJCQlyZXR1cm4gZHA7DQoNCglyZXR1
cm4gTlVMTDsNCn0NCg0Kc3RhdGljIGlubGluZSBib29sIGRzYV9pc191c2VyX3BvcnQoc3RydWN0
IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcCkNCnsNCglyZXR1cm4gZHNhX3RvX3BvcnQoZHMsIHApLT50
eXBlID09IERTQV9QT1JUX1RZUEVfVVNFUjsNCn0NCg0Kc3RhdGljIGlubGluZSB1MzIgZHNhX3Vz
ZXJfcG9ydHMoc3RydWN0IGRzYV9zd2l0Y2ggKmRzKQ0Kew0KCXUzMiBtYXNrID0gMDsNCglpbnQg
cDsNCg0KCWZvciAocCA9IDA7IHAgPCBkcy0+bnVtX3BvcnRzOyBwKyspDQoJCWlmIChkc2FfaXNf
dXNlcl9wb3J0KGRzLCBwKSkNCgkJCW1hc2sgfD0gQklUKHApOw0KDQoJcmV0dXJuIG1hc2s7DQp9
DQoNCk15IHJlYWRpbmcgb2YgZHNhX3VzZXJfcG9ydHMoKSBpcyB0aGF0IHRoZSBwb3J0IElEcyBy
dW4gZnJvbSAwIHRvIA0KKGRzLT5udW1fcG9ydHMgLSAxKS4gSWYgbnVtX3BvcnRzIGlzIDUgKDQg
dXNlciBwb3J0cyBhbmQgMSBDUFUgcG9ydCwgYXMgDQppbiBteSBjYXNlKSwgYnV0IHRoZSBDUFUg
aXMgcG9ydCA2LCB3aWxsIHdlIG5vdCBkZXJlZmVyZW5jZSBOVUxMIHdoZW4gDQpjYWxsaW5nIGRz
YV9pc191c2VyX3BvcnQoZHMsIDQpPw0KDQo+IA0KPj4gKw0KPj4gKy8qIENoaXAtc3BlY2lmaWMg
ZGF0YSBhbmQgbGltaXRzICovDQoNCg==
