Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754493F4B9B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbhHWNVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:21:35 -0400
Received: from mail-eopbgr60138.outbound.protection.outlook.com ([40.107.6.138]:9271
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236163AbhHWNVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 09:21:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF7K0OP2bgEyXmzsr8kPexIoosmAs8Lu5o1dE0AzkyvWVkINO1RqOVKFmrZVPND41D47gAoO/V0jpH2DYDDyaZ1eYZFjDqvtoEnpq1T6WOxglK1YXgCChkMi0WfjHD8zwQCArmzIANkJmvzKcADZkAVWP4chE1VvflI3eew0BKIs9Z4I0B63FtiHOQ0FskJKfXAuJAaZ9bsEleZbx5Vd09gIk79s2wXkoM77OS4aT2DDyzIhKc4N/Hn+d1hYoG6ofUkxZWOEBlWAyRJwJ5G2efRT8e/5Ag/xg1Yp5DzOyE+atJXMXAg5h62PXr40+DI3iWxQDB6l3lBbMdWjCUzqDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AKpVIUdz3UUqpCxbXZcnNHIPZh8Sm36TtEhXfEJa2o=;
 b=l0pnfkNKhF/dWmydXEYWviuzi8DkEcmM/0F0Aa7DWZ30Z4HhVAgXNuCdaV6Lg2U+zkDA0ujUh6XmWj6PvLifacC/zNrK0RO54TSOdUpB2r0GtfCm4hRsfDDh68tPVUmGMyH6MYqLamtL9mKAWvvZe1Gxe71T5e7u5oGmwaZpOhzZWjbrrPARY/eN64zhifqZnaPhxJmxMrX3DFczGmOO9yivN7CgQk7s/mDb+M6HDcfAZIssdadIFtX9Ip0ogaE13NIPIsQvuDejFr5xO9TxHLHh+AO/OrZBSPsW/iibZaDAiGR+Y208ed26UFwzT77BHUnCt9UMYE/ysE86rHUqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AKpVIUdz3UUqpCxbXZcnNHIPZh8Sm36TtEhXfEJa2o=;
 b=P/vFdLSK7xQLM0hbsaj9t/x0LNqGSceIb8u7cngvKObOjJ02a1XGiyPLwhfmT/n5Ubjcx4i5rC10wxtAAT/1fPN2l2BGNi7LoQWKz/G5jXTHDJzLD6ah1bvpfdhk5zntl1HiL3krlkzGABE7DX/DFLXP7W0vWPbW5iS8apBctn4=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2170.eurprd03.prod.outlook.com (2603:10a6:3:20::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Mon, 23 Aug 2021 13:20:46 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Mon, 23 Aug 2021
 13:20:46 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXl4yCe3G+ndzNv0qmlobhUV7pTauAIHCAgAAS/oCAAAaogIAAEZuAgAANyICAAISNAIAANCcAgAACFYA=
Date:   Mon, 23 Aug 2021 13:20:46 +0000
Message-ID: <ae343c72-a892-1327-db35-0ff459c9e33a@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
 <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
 <20210823001953.rsss4fvnvkcqtebj@skbuf>
 <75d2820b-9429-5145-c02d-9c5ce8ceb78f@bang-olufsen.dk>
 <20210823021213.tqnnjdquxywhaprq@skbuf>
 <4928f92c-ed7d-9474-8b6b-21a4baa3a610@bang-olufsen.dk>
 <YSOe7nSC9me8dcCf@lunn.ch>
In-Reply-To: <YSOe7nSC9me8dcCf@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3a73dc8-5cb6-4cf4-0332-08d96638d15b
x-ms-traffictypediagnostic: HE1PR0301MB2170:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0301MB2170AD86D3973EEA6D9764F383C49@HE1PR0301MB2170.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s2V+g5kdJ+QNUwrbSQ97FRLOkSc2UagYLu9BH81UQ9yMSU2tqFHfrxtkYdHHdUG7Kh8qHW1WHym2lSY0DkVhJwoXlWRD+NBuq9aSjiINs9QZg8iCod4OuKgXrsSIsCfLNqeRMCKGOHTm2nMQQqHfvR85AnK8B+MrtplDKjKBa7/mMuGuWte3jgThxxwPXbA5IN3s63qXoa+jk9Wf4U3HfSfDAmtpvd8uVQfgsIMm9et1grch5mbzAWX0YmwrwsIsDuOnC3HbPhOsM8lYaYG4vl/Hy0uw8uLP2xv3JOzp48F5kY1QM/J6OM9CpwsQ1CbryNHr5YmTDNJSooskFzGCiCYdC7L3MCRy0ZOFAeklX6bD1erBjYizj2hON2FHo2C1cMHIL5zRuLtYeOEgcoyBbnBXHBfrvFEkZhfv1jcZz9im6va4Mbj38YlxiRhbKLoRx66NNNt3eCcSMWuaLm31Y+z91Hrejuoi0HbhxH00A7GlDW7rjZFE+QVJSgiL78Jn5M3L1EMhbEd3/IDUBl/ortOSB6pvmInDWFv3LK6IQaE6NUnVa5P7cbE7DQv5A7FWio2QExYbqDbkdWg0ZwCFr5FbymOs537dqXL6Hh8/wpe7O6pM5aiN05dTv/bhFWWfO+YXRbh181VZFfPxXUsNwYCGa64XALhnOB7aeBqneuh2itM9QPWohPnWcAH9p26+XOv44L5YY9VmUNDtP/FP2C0Gqs/VBKqqDc2XBX8+/GmfITwCkeYmbzQ3dD/vnEzHavSila2jIxAXGLL7gxj9AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39850400004)(136003)(366004)(478600001)(86362001)(85182001)(2906002)(83380400001)(2616005)(36756003)(5660300002)(85202003)(8676002)(316002)(31686004)(8936002)(8976002)(6506007)(53546011)(31696002)(7416002)(122000001)(54906003)(4326008)(6916009)(6486002)(64756008)(66556008)(66476007)(71200400001)(66946007)(66446008)(4744005)(38100700002)(91956017)(76116006)(26005)(38070700005)(6512007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SSt3MmlmRCtkaFpIQmN1SDdPQmxRVExoNHR1cnBheFhBdG9xL0hPcGdubzhZ?=
 =?utf-8?B?SGNkU1NGYVVXME1JQ3pvMVVQM2pNbUFyckw5VS9od2FKaUx4TEF4b0luWVRD?=
 =?utf-8?B?M0Vrcmc4Zmc5Rkk2VGpJWG1nVXlzUXhpY216RlJHbGhJWXRVWWVrSVYxZmh5?=
 =?utf-8?B?R2pEMnhNR2VvRHpJTmdFM0ZTTTRLWXFvTEdvbS80QWlHTzd1QWNxUFlrbmY3?=
 =?utf-8?B?cW1xdE5xU3AxZHlqT3lMMFl3a1hnRzJOdExPeTRVYVFvVy9FYjVUOS91d0ZX?=
 =?utf-8?B?Z3dTNmNpZkFUZjlLZVZiRjlocDdaQzRyd1lBbitQYlczNVpETnN2MkFIR2xh?=
 =?utf-8?B?WmZmN3U0ZFFEOC9NRUtpb2Q0NFl0SzZaanIwbkJRZ2NGNUJqK2tTb2JHWVJV?=
 =?utf-8?B?MUFEYVpyN3UxazJ6YW5IblNoOVR1OGdPcGZWcnd2SzQyWFZpOXJnU1E5dzZH?=
 =?utf-8?B?U3dQd2tzVkJ5L1FzRXR1clh0RXcweVNoaTM1aUs5RGM5emJkRXlmdklLdmhr?=
 =?utf-8?B?TFVzeGlFVjNSbmc4OENteUtGb1ZJeXJjRUhMOWpHeWh5UjZsZFlSU0FmNTZo?=
 =?utf-8?B?Mkt6b2NrRzVLTW5BdTNPakxDWVN6eU1rYUJiYlVvcHNiV0dYdlFwWlZVOEpk?=
 =?utf-8?B?WFBremo4SUxaREFPOHBuVXR1bVVLVWpvRnVTdmwxSzQ3M2U4MkUxZmpGaTVF?=
 =?utf-8?B?NEIxZFFzOC9ZdXlpdnhWWklaTU45RjlRMkdZTW5pMVl2NjJJY24yaytRREJv?=
 =?utf-8?B?WEN3bVdRMEJuM2RqbCs2L1hZQ2ozNmJSa3Uxd1FTbWZkUXY2TXh0VGR5V2s4?=
 =?utf-8?B?T0xVTTYyU3hwRWtMd2FFcTBmMVBPUjdjdjFXenlVMzVxd3FwLzB0dEhkdHVO?=
 =?utf-8?B?TEgxeGtqaWdqZ21lNDZzMGU2d3NKOS9IRnJ6U1NGVkl3L3ptczZBUUFGUFZV?=
 =?utf-8?B?RFFWM0N4SDhNZFhWejFkYm1JOG9sZVBFVjhQSTBndXVrTXVuaGNCT1gxTWVv?=
 =?utf-8?B?UEJlUVR1RTJ6OVl5UzBaNE1hVGMrLzVLL203RFNsaitCeXNtNkNYVS9LYVJX?=
 =?utf-8?B?eEV2TWpUdXF4dVFHbG05Q1k2bHA0V1NreW8reWJZdHdpdTRDeFdGM0lhZitq?=
 =?utf-8?B?V21WVHpFSGFSbGVZTENGVXY3ekM2aEFRdVFjUTRVNjQvbUxoc01JQzZwekdB?=
 =?utf-8?B?cTd0WVVWNnBibTNIMUorQVJQeGVVdFdWYzhGM2pYd1RWZGdxdE1CcGRweUc3?=
 =?utf-8?B?TEpVU0dlbEdJbUlqWjE5ZjI4VUdVMWgzU1M5dE9teFhtNkIvTFVTY3FKN0pI?=
 =?utf-8?B?ZndzSXd0QWN2eWJ2TzdwMUhHc2dualdHOTZ1K09GY0crQ1Y4RHVTcmpMRWdI?=
 =?utf-8?B?TWYrbDFMcm5RSlp2WXhUVHAwdHJQL3J5VTVER1lUV2VFQlJKRjRydXZ3N2hN?=
 =?utf-8?B?bUNmTm1ydDEyZkdnQ2REM2RGaDdQVXRzRllsVThIN0NVTkFsYlZ3VHBaay82?=
 =?utf-8?B?ZXlFYTU4ZG1mN3lQcWw3OXNBOUVsZjdPWXdkU2RDNUhDVkd2VFBNVmxaSDBS?=
 =?utf-8?B?eFdhaDBlaU9TMmdhS0gzSC8wWHBUajNQZmpWQkVWYm1IZEJaekh0ZDR5R3Ja?=
 =?utf-8?B?OU1ldmhQdkZULzg1ZGVhMWx2enh2bllQdXNuQ2JpQkVNODd0ZVB5d1BFajNk?=
 =?utf-8?B?RHBsemlNR1YwbUZGV1VQR0JadkMxcGJyaENFTjJoT3Yrc2gxOEtvNUJSeXZN?=
 =?utf-8?Q?OC6U+KStBlRot0MEWpjy1uQj/DmEvny69VaUEX7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFAA67099918514C8F1B501DB23E8E0D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a73dc8-5cb6-4cf4-0332-08d96638d15b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 13:20:46.4381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7BxxZVo1LDw0cevqn69tBNO0y6kSHNwxjQjtGXyV5UfKZp7topsZts9CN/oKksoTy9OoScBSheu+9Mx+6CIvFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzIzLzIxIDM6MTMgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4g
SSB0ZXN0ZWQgeW91ciBwYXRjaCB3aXRoIHNvbWUgc21hbGwgbW9kaWZpY2F0aW9ucyB0byBtYWtl
IGl0IGFwcGx5IChJJ20NCj4+IHJ1bm5pbmcgNS4xNC1yYzUgcmlnaHQgbm93IGFuZCBpdCdzIG5v
dCBzbyB0cml2aWFsIHRvIGJ1bXAgcmlnaHQgbm93IC0NCj4+IGxldCBtZSBrbm93IGlmIHlvdSB0
aGluayBpdCdzIGltcG9ydGFudCkuDQo+IA0KPiBQYXRjaGVzIHN1Ym1pdHRlZCB0byBuZXRkZXYg
c2hvdWxkIGJlIGFnYWluc3QgbmV0LW5leHQuIEJlZm9yZSB5b3UNCj4gc3VibWl0IGEgdmVyc2lv
biB3aGljaCBnZXRzIG1lcmdlZCwgeW91IG5lZWQgdG8gdXBkYXRlLiBQbGVhc2UgbWFyaw0KPiBh
bGwgc3VibWlzc2lvbnMgdW50aWwgdGhlbiBhcyBSRkMgaW4gdGhlIFN1YmplY3QgbGluZS4NCg0K
WWVzLCBJJ20gYXdhcmUgb2YgdGhhdCByZXF1aXJlbWVudCAtIGFub3RoZXIgcmVhc29uIGZvciB0
aGUgUkZDIHRhZy4gSWYgDQpJIHN1Ym1pdCB2MiAob3Igdk4pIHNhbnMgUkZDLCB5b3Ugd2lsbCBr
bm93IHRoYXQgaXQncyBiZWVuIGJ1aWx0IGFuZCANCnRlc3RlZCBhZ2FpbnN0IG5ldC1uZXh0LCBz
byBubyB3b3JyaWVzLg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0KDQo+IA0KPiAgICAgIEFuZHJl
dw0KPiANCg==
