Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679DC47A301
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 00:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhLSX2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 18:28:02 -0500
Received: from mail-eopbgr60128.outbound.protection.outlook.com ([40.107.6.128]:31671
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229628AbhLSX2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 18:28:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/DZrUwMfDEPIX8WxZHhiJ827wlY20lJ4+se7hYNhKIdDirS+Qiuow9ouHFHlvWlvYv1XOavug2wGGqyq50iq/ohN4qv6+N0NQ0be+9gVzsiSeQPnhE773DpPQOvmkNKOvDYOv7Ur+QvHCoJKL6uRuLTZTnV4gHLMdglGznZoi161GOy0dwlqp6SqzFplLxMAFWzqRLVyGcwiou8glOqRdJ4j6dW/cZzpfW9b1VKn9XaG1uW0Kfk19runIeMV2EMghzAq/40RIAEmJ+rh5susJlA5RJqgaAdwbQ7WfNKOF5n+plRBqzVtRNnwNi8bw+o4/qU3dm694qj+l9/XSj5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SbB7w5EaUoLmnJATLxqCUAZZ29xEbR5tU0zRk09ltWQ=;
 b=LGPp89Jgt4V4Rbs2UPrKvZolw8wKSYxuSZ4JfcTBIiIepRgwzN6fpVcnSIHj5dVPnYB6B3SFF+OF3MymiBIsPqguvpvpEx6XrcxuVwvSRSU0ShK6wiRGmw+uI6fzznPzuilUHUI0CaPIONE2nwwWYEVxPWGG1RjszQ2n1kLHDmHg9lNdC7OZnkVAK8wsAJVqxe7TTS82n/yxADANTkrFrKA2+T9Xfn/hKKZ/W/M2b4wDTw+YqPS96JmYhr8PZEkOpX8nyw5tHwzRWWkDMEO7JWRV2SQE9a7bxM9r+VQIaQazbehhsA/CgF8DxeQtf2ZbkrVocjeFDbvpPz3q0GME3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbB7w5EaUoLmnJATLxqCUAZZ29xEbR5tU0zRk09ltWQ=;
 b=doYcLAam/Gy5ov6u2fOJ73EiJ3Pr0l0NySJvWHkAqVE/3tVykMoh65OGi38PAZ3egvkmbNjFxLNkvg7G+vlQ+P0G0p30AllBw/JzjEamaEFeoBo+aenDdckq73zeDlh5GlYvtD6LXopotpAxjy/8RodwhfS+GzOJlz0gviyVKXM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3941.eurprd03.prod.outlook.com (2603:10a6:20b:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sun, 19 Dec
 2021 23:28:00 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 23:28:00 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: net: dsa: realtek: MDIO interface and RTL8367S
Thread-Topic: net: dsa: realtek: MDIO interface and RTL8367S
Thread-Index: AQHX8+dbndk7DTjMK0SfAljJ3x0UTaw6eE+A
Date:   Sun, 19 Dec 2021 23:28:00 +0000
Message-ID: <d4947c8b-9cc3-24ef-5843-22960bc4af8c@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f55cacb-488d-40fd-696f-08d9c3473258
x-ms-traffictypediagnostic: AM6PR03MB3941:EE_
x-microsoft-antispam-prvs: <AM6PR03MB3941BB2E817745687AD22EC6837A9@AM6PR03MB3941.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJ3Tqd9OIUVBtOdToQkHSV3deBQ5RcMriZi69tb4XTTcQZoCB7a4jSA3BSWL5VJtno0byfSbAdz5pKPoYHqO9p+gSIyj/x5GtvKwRJNry81OOdd6pl3VjxDyvF/AycJzOiDiVmqmk7iZs4/mM+78X6wlwLz4Wznrno7j7O+qXhGm9l/1S0ZT5ze4xeNeoxF5nqbUoPKTA/sMW+l5ZLzAZIfpfb8oABNh5E5iER05GtwWftA3H+ZS7ap4nDPUraYo2SdKR9Hb0Cjku8IQ7MWJBBoqrrcPZbwWHWPKBFk3BxpsRSHogEWvq20w+vNW9+0aLWP7CIF2KZQr0HWq+zA0138XZn1d92jVFXtolg1dNfdC3l5xNCSmtLMz5a9sKMYLSrwdleeWYwtDxmD5gG15LJcb36EWMNBQvSyW5BDy3+AfeV5IIWcZopVKI1bep5kCtW7KFmfvwZZ0fqNIPFDXU06VwASRPt1K0byzzlPyv5b7KFQOiO4cgeogY9jBOzYENzn8TGlYtEuSQREv5MC7BHXo1UlS0cZf3O6oV/rlzkdEnsphQ5XoZ6IuoXVTqk8wzxL47/8IJnUBOyFdDb3UeZ2woL9yHYBmdswgRr65FMrAKHLIRhuBW11RGtmMoT9u5LStZwjDZp1lHIyTggClaR7NHoGHbuh7jt7m6KLNycS8hZCdxw1wxZIkj1fb7TYe228t7PvtYEKhAywuYHziymVkSyqVFwg9maonFvPKV8lXeMgdSXqs0bJ5dxVBSA8cHAbUhMhHemQwJyG290rvPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(6512007)(91956017)(186003)(66476007)(66446008)(4326008)(36756003)(66946007)(66556008)(64756008)(85182001)(508600001)(8936002)(6506007)(53546011)(8676002)(71200400001)(54906003)(26005)(8976002)(2616005)(5660300002)(38070700005)(110136005)(316002)(122000001)(38100700002)(6486002)(2906002)(85202003)(86362001)(31686004)(4744005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkM0MTgxVlIxcVhENEdSeVo4RWhTSzFkUGh5eVB2blVodWJBdSsvVFE3OHBK?=
 =?utf-8?B?T3RORHhzaWxEZm81d2FoSjViWE1LKzRjY09HZzBaK2Q0RjBoTUs5dWlMMWs1?=
 =?utf-8?B?SndGOXhWQzVjMTJjUk9HcUZJMitCTzI2LzNyTkViS2g1NE42bUlQWUhEbytn?=
 =?utf-8?B?RGQxV3IrNmdmUkpaRTY4bFUzWSszM2xqeUU4UHBrVTh6RE45ZituOFJuK21P?=
 =?utf-8?B?K05ra1pYU3VrZnp0S1pDWTVNWXV0YTBvVGNRTlVXVGM0VHVvQVFsRjB4ZmNy?=
 =?utf-8?B?ck9FMFJxTXg5WTZNdFAwaW5CNUtCY3dTRVBWcHZpZ1VuczlQSG9Ja3F1Nzl3?=
 =?utf-8?B?UFdCajAwUXBseFNlWDhQeVFFanRadUZ0czdBYkc3NXdzbDM4RkZqSHkyZVFi?=
 =?utf-8?B?MnRQajltZE9rbnNjYUVtOW9rQnRaTDJ3VFk3dVJ6TTczVzlxS1FrWlV3Y2dG?=
 =?utf-8?B?Ym5FNklmbFRQanYxOWlkNUxGR00vYXE0amduT1dhdldUemxXSHQwWnBRM1J5?=
 =?utf-8?B?RklWSmUxUCtwT0ljRWFVVytEeXUrRDJMVnJtSnNDYk1DT1NkUThmRFFUc2JZ?=
 =?utf-8?B?RkpSVmlGUVQ1SzlMMm43djA3b2FFTC9nVkp5QnIyY2V1WllGcTFCTmkrQ3dh?=
 =?utf-8?B?c2pQcUp4ellYOStuSDlnc0JCOFlZRnZ2SVRZOUg3cFFrb3U4ZGJOVGR0NzVL?=
 =?utf-8?B?TjcwMEk0dExCVkhzUmhiRU9XOE44SE9PcWROWEdvRENvYzh1b0NVblArRVh5?=
 =?utf-8?B?RFZmVDdDUmwvMDRBczVkcTFicHdqVDVjYVBwd1BQRWREY0hQWk8rOG5TV2Yr?=
 =?utf-8?B?ZTNzWjBiRm10T1NhdnBSbWxXWS94eEpxMVR1alcvVk50Y2xrYkZmMEJqbVVN?=
 =?utf-8?B?a01xM0dJdFF2SEtTTDI5TXdtdDM3NXN1T3FpRlE0cmdCanZWcWNBWk95VmV0?=
 =?utf-8?B?Q1k0TVcrbDhpcUdkODFTa01TR1hNYkMxMXZxWHZiMWRGci9EQnE0dEdXODRC?=
 =?utf-8?B?Q0VDVmZjeEZOeFBzUGw0S2o0Mjh4ZVRTN0N0cGZtN1JVOWRYWFFCM01BbmdI?=
 =?utf-8?B?Q3BFa0ExNjcxdzRkU0xSVlV2U3M0dDBjd1NuQ2xtVWpZNkpFWmpkSU51LzhG?=
 =?utf-8?B?U0VMUk1VS2x5bkFmZ1BsWEhUTElEb292L3R2V05PYUtaeCtJVnFIaVR1OS9C?=
 =?utf-8?B?RnJhYTdNMnhobVl2ZUxvK0o2WUVYL1k3OU9FbENkd1R0bTZ1YnVrTUhEYVNu?=
 =?utf-8?B?QnBrdlFoampQUzhEaC83NVpLMUFiMW5XMnBEM0doU0ZkWmdnM2RFUk5WK0hp?=
 =?utf-8?B?aUt4Ukd5eTN2U0RqVUdHZm54cWl3ckdGRHRXay9Ec3dwM0ZCSlE0TjhYeTV3?=
 =?utf-8?B?VCs4Ty9LV1YvRFpIeW1uL05WK2JOc2dwK3EzVGdROHpUNUtKN2E0UzRybjRv?=
 =?utf-8?B?RGxIL2JJS1hiZEZMUW1TMm0yMWh0RndpMmR1bnpTOFZNWDRMSGhPQnhVdUJM?=
 =?utf-8?B?dzYxQjlPUkpQMlVTZ2YzSlRIeEMwL1RWc2lYbkl6NGdGa3Y5b3J6Y3EzQzFN?=
 =?utf-8?B?MUpvTVE4MXVEUTllM3pIeDRoYUxzWVUwRHpQeVpndVpUSUJnTXdVc1RHblJ5?=
 =?utf-8?B?OWIvc3BjWklyenkrd3dUMU54QWdsa0RaZDV1UndYRW1NeEVnVnBpaitEU3Bq?=
 =?utf-8?B?KzlucWhOdFhVSGtBbUEzVVpHWWxtUHpjeDVNRE4vZjBBbzY5QXNYNUl2dWlz?=
 =?utf-8?B?SDd6QTVGb1pvcnNieEE1Tk1tOEloVEduS0htRVFZL2Z4NWxJRzIvQ3pwYklY?=
 =?utf-8?B?aEluRDBrSUFWLzd3Y25JdHhpR0xUbXZ6Sy9PNnIyOTZWazZwbG02Zlh6Q2hB?=
 =?utf-8?B?R1Jxd0FiZ3JlZ0R1WDNIMWt4bEh3di9xcUE1S1dkOS95UnZXYllMcTlnS0Z6?=
 =?utf-8?B?Rm1LY1VpTFEySU9CMUk2QzdFdkp5dlJnY3dicGU0ZXlBT1kvTnJMU0FWZ25P?=
 =?utf-8?B?WDVadXpycUl5dzMvSUJOMS9wU0ZscEpnUHNoa01NakFrMnJjMzhybXlRSHRC?=
 =?utf-8?B?eXlENjdLY0RYK1NXTGJzWXEzWWNJTCtyeWhyalg0aHNCbTQ2ZWdOT0NiZ1A5?=
 =?utf-8?B?MG1acVFBV2hBQzl4L2NieVdQSmdrWDB4eEhNNFVFT2FuWUdZYXhmSmZQdFZx?=
 =?utf-8?Q?t68kM+q/kc6WhUEbo3lrexV2093hIhRDbjMwu3jUweAs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <978BBF070279284182CD5F13D9782A99@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f55cacb-488d-40fd-696f-08d9c3473258
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 23:28:00.3291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e57zkWXmC2FIxrXpYJttctYJ5enpi1I4eW6+gm1JlJXXBR4Ft9hZWO1zl80vuHQQ5fV32jZDQ3puYGAaACwO7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMjEgMDk6MTQsIEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2Egd3JvdGU6DQo+IFRo
aXMgc2VyaWVzIHJlZmFjdG9ycyB0aGUgY3VycmVudCBSZWFsdGVrIERTQSBkcml2ZXIgdG8gc3Vw
cG9ydCBNRElPDQo+IGNvbm5lY3RlZCBzd2l0Y2hlc2FuZCBSVEw4MzY3Uy4gUlRMODM2N1MgaXMg
YSA1KzIgMTAvMTAwLzEwMDBNIEV0aGVybmV0DQo+IHN3aXRjaCwgd2l0aCBvbmUgb2YgdGhvc2Ug
MiBleHRlcm5hbCBwb3J0cyBzdXBwb3J0aW5nIFNHTUlJL0hpZ2gtU0dNSUkuDQoNCkhpIEx1aXos
DQoNClBsZWFzZSBzZW5kIHYzIGFzIGEgc2VwYXJhdGUgdGhyZWFkIGFuZCBub3QgYSBmb2xsb3ct
dXAuIEkgZG9uJ3Qgc3BlYWsgDQpmb3Igb3RoZXJzLCBidXQgaXQgaXMgZGlzb3JpZW50aW5nIGZv
ciBtZSB0byBuYXZpZ2F0ZSB0aGUgdGhyZWFkIHdoZW4gDQpwb3N0ZWQgYXMgYSBmb2xsb3ctdXAu
DQoNCkl0IGlzIGFsc28gYXBwcmVjaWF0ZWQgaWYgeW91IGdpdmUgYSBicmllZiBjaGFuZ2Vsb2cg
Zm9yIGVhY2ggc2VyaWVzIGluIA0KeW91ciBjb3ZlciBsZXR0ZXIuIEp1c3Qgd2hhdGV2ZXIgY2hh
bmdlZCBiZXR3ZWVuIHYyIGFuZCB2My4NCg0KVGhhbmtzIQ0KDQpLaW5kIHJlZ2FyZHMsDQoJQWx2
aW4NCg==
