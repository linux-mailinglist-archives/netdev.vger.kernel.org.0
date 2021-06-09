Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D65D3A1D3F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhFIS6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:58:21 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:21984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229472AbhFIS6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 14:58:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtbHV/rbQh+Q0QYqVRtCZ+3Y0fugJ3e5M1HU/FbZx8+QgCQtiVfp7iTZQMIoZr11w5lBzwz2Iy/InKYqXVbZcz91tdLFNK3Kyuf+Vo3JoYUVhpW7zq/vh5u5qKZOTE5k8Br7ty/xB8ZISViRTa6b5RkViSlXbEsNfPmu4M/HW02k+cOH+qbTa4N7wl8tLE53awJUKQU26v0+tLR/BFHgG0uIYhXuIn2hRN4i+m9VBp9OET1WYAAYoaSYsJWDfwrfV9XslltdNFdMa/fcERgGikywUKFaSVLpObGGQ4q2vFmFCwwiO+vdNh4ke/dwCBdMN8pXjX5aIBRzMfZFOd/S3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF9USpNCpZ0BKgXpJBwWOB0hmiyymtXHqzHKfUmrGo4=;
 b=LNzoB3CZZkIw2mTijcXQ1IFJnZbCC2M1To4xVE9+PhCYcLifDSKGMRnL4fQFz+S3rZGm5gZbkUX/FIkb9wDQEyevBIMWOIODS4WYdNPWWBm2YEfp4orDx0LJzyFQmYyTLf0JJpvA+47ErYei7I/pmDqRMVE0Hz8G+FEBwT1vARpGf6ptK7ZHxrh5ZJXZ11gTjY8WnQqhEWs36/Y9Bc+lPp6/v3O7Kl61b75PuoejW1luHdW5yI1QX7YfaMGfAftflOLG+1/m4og4KZ14aSkj08lcml6G8MLOmSnp4fz0p/Jd1JlxzW/kWh2aHIO2Kb3z0D3+WeyVtJHkN8Fb1q8bZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF9USpNCpZ0BKgXpJBwWOB0hmiyymtXHqzHKfUmrGo4=;
 b=mfyLPfAP+DQ6o/GJ2feI+xyAnDbOv4lVinWrac8IWSO2jYTEsO56w80ABg/Q9Lii3e+VXcOpGygd5hT+2pvaIoBzOR1t4dkEbyf8uL5DWrNncPkCDZJzurU5I3jP24uMS4WinEv8ygjEtVJ9SJGWZx5+CU12FcM4aH9x9m6ZOG0Z7Yo5pMOg9qzTHsjTL1BT6uwNf10lMPZMIpM2u4GmyNmG0N3VSji9cG8pWa2uEmJ1YCT/g3iBqTX0Nih8hzOl6yqYf9Gs2DznUUWOdvuYNbXBACg+2iZIXLhxCtQw86cYUrbDtImlAwSyURUqynxStvxcE4DqbKWFxmcBk+r/ew==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Wed, 9 Jun 2021 18:56:24 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:56:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     Loic Poulain <loic.poulain@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>
Subject: RE: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on link
 dump
Thread-Topic: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on
 link dump
Thread-Index: AQHXXG5hvlR+yAncTUalCsHKBeaUlasKU3DwgABwK4CAASr8cA==
Date:   Wed, 9 Jun 2021 18:56:23 +0000
Message-ID: <DM8PR12MB548073F28EEC62149EEB502FDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
 <1623161227-29930-3-git-send-email-loic.poulain@linaro.org>
 <PH0PR12MB5481A464F99D1BAD60006AFEDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAHNKnsSuAMK8NEAbeVT7g-Rm1a2yS1JiVwxz-5Y0x_0QxXNQow@mail.gmail.com>
In-Reply-To: <CAHNKnsSuAMK8NEAbeVT7g-Rm1a2yS1JiVwxz-5Y0x_0QxXNQow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d3f8895-d1c9-4939-eb27-08d92b784756
x-ms-traffictypediagnostic: DM8PR12MB5413:
x-microsoft-antispam-prvs: <DM8PR12MB5413D6C183F1C4A0F91481C7DC369@DM8PR12MB5413.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ZNugfcWI6yFqelrGxWTWHILTQEo2lKIadtEDEMumKNWFG0pdUhLNrtejlp64HBGGSnYgSIRSUhVoxNz7wgUDUxy8Xf9JD1LUdjzK24zjkmeagC+m+BkKuI2hFoDY2VkJy2spk89/uKBDJVxCWKD2axZhWaPWrL6w/wBY2Cr/oSBRNwt0AEbJsc3EpCdqgDX65whMrmQbMsMyITGA76J+bHR9jWJUFkKCUAtWMzOlA/c5zMGKvNzoawqqy1xqwmvVFlS211DAPQpAhmJbwoW3J6FgjmFg7F+Fth5UUpItTjYl84P6wOQuVMiXRKYORLIHQ00cpF8gnmjjp34QeV0iTcQDTENgkZLpFpb+DbCPoseCy+N3sJt41H5287L+V0QoAroIHMQdBlKAiIDNWuvnisfzdxqpkb7NlV90GoyPdp1LC53DpfQ/CExkcCNMKkyI6y4MgkO4tuQV1xICAkaGKowW9gWBvD3GvVQmx9PjDMfAiLwpiNWRQ4oNBrLj9UDqh96m2EH/ytIFV6eHs7jH/5GaNCGwqC/jr+9A8yfu8oKmBRjM7o1EifzUemjq4y9CvceNRvNlOuvE+bHXPAitajC/mZEAo+LIN5HyNvdUW4aBpJpNtNLsT2yKQBIO8QXLuk2ikVWSq3X5ywKjWVaOrMhzO3nD8i7TOCIhr9p2XRNlgkWVBup5opKQBRWZxkV3Q0+XErCwKpNmpheSHR3rwhLf5atrBc/L7L1RhNy4NN4USMJZpDJqOiYiYyRj5b1QJ+SNpQ5JRF/ZuGtSoMtAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(55016002)(4326008)(8936002)(54906003)(76116006)(9686003)(66946007)(38100700002)(186003)(316002)(122000001)(71200400001)(66476007)(64756008)(33656002)(66446008)(66556008)(8676002)(26005)(6916009)(86362001)(7696005)(2906002)(478600001)(45080400002)(5660300002)(6506007)(83380400001)(966005)(55236004)(52536014)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2wvUlRsOFRSSW1iQmlNUmpGNytvaXB0SEVQTnpvNndSL0hza091LzRzc3pa?=
 =?utf-8?B?cWxqLzcxVjdXcm9xbktTWUpwUFNvVkVNeFloYjZsaklvS2tIMVFZdHFGczlZ?=
 =?utf-8?B?REw2L1RCNk5GMmxLOG5SSURoQjBWa0ZkZitJMVh3blBXbUxBTUpKUTJQcDVV?=
 =?utf-8?B?N0p1RXM4NjY1R0dTZDFMOXA5MmtGNUplbmFEVm9qVmpubHFEeGhzd0V3bHJX?=
 =?utf-8?B?VjVLdmxGTHM1R2l5VUplMlFVUTJ0MGF5M05YYWZZcVZUcDVEenJMR1VjbUxC?=
 =?utf-8?B?emJ5UkJqUk8yVyswbFZ0WVBoLzRubXh2eUxxa0NWWUZJOS9kVDVFeks0dHMx?=
 =?utf-8?B?TUZ5c05BZUVaeWE2QmNkamRDREFYeDU5Ym9jaXp1cUdVUlRGLzl0Y2N2T0NY?=
 =?utf-8?B?UlpEbDJXZ0VCMFhuVktRUWprVlI5OFlZK2Nla2FUZysyQklGa1prK2I0anVx?=
 =?utf-8?B?UW5TbmhuTjg3T0NNSFdscGhkRElxZVROaEtmWlB0N010NkNtSnVNZmJ0T0hU?=
 =?utf-8?B?SXhNM1htZXVhRTR6RFU0eGppaUpoSnhYWitUQ1JnbzEwcm02d1V3NGErZHFk?=
 =?utf-8?B?ZmI0ditVbFgwN3VwNTlIOE1tcFQzeUdsdTN5Sm1MOE1GdnpPRmFhWHV3SDQ5?=
 =?utf-8?B?Vkk4bkh2TzdobHlQRjJxQnhIRDZzWGxrS2lIN2N1MGtsMW85M0t4dEpaSFQ5?=
 =?utf-8?B?VUovLythTDh0ajZFeU1Va3JFYnRtZ3lZT3Q5aWtMbnRhOHFLLzVqS1kvb3JD?=
 =?utf-8?B?WG5RTkd2OFNDSkxSUGUyTi90eUFZNVZpYmRRL3dyYVFhZzRROWFudU12cTRx?=
 =?utf-8?B?Vzl0UTM2N1czZ0FWWTkxZ0FRM2IybzYxbmpZQkZNSjlzYkhMYlFxRncvMXNN?=
 =?utf-8?B?eTJ5Q1JMNFRjeGlNMlZjZjd5SWNTSzdmM1dBRFlpZ21STlYxQjVGelUxb1R4?=
 =?utf-8?B?d3F6ZEx1TzQyWEVZU3cvY1JUc0QxdlZnMHBWL21FMHpxd2k3amFqZFU3bHRX?=
 =?utf-8?B?K3ZETWVIQU8vM1pVZ2NGTG9RTHNSMlJEdm9Ia0VrOElIRUdiU05ySkliUXNU?=
 =?utf-8?B?MEU1U2d2SG1YNFUvb3BrQ2U1bTNVTUZLT2Ric0U5RFBlTXBaMjVwaEZQTHE3?=
 =?utf-8?B?LzgzK2dlaEVkRlpBaGtWL3YzeXJRcG5yL1ptVWp1OEp4K2RuMkNPU1RxVXBZ?=
 =?utf-8?B?cWZQWGNsdm9yL01UZ2NzUkR6OE4veEhlS1hxTHpXUTcvSEUvM1ZTMC9yRExC?=
 =?utf-8?B?ZUQzUXhybGYyRmU4VVpDNnZJelFRUlRlT1FnTG9Nd0cxSm5TZkR1dHlRWDNJ?=
 =?utf-8?B?Ri95ZmMrZExYVDcweDdVb3U5b3F0R2o2QTlkQUtzeVVxVC9IUnkwQURmYkQ3?=
 =?utf-8?B?RzJsbVJzREduYW9VUlIva0NvNENSbXBKM2UvTkE5RHVXeE1DbU1pZ2JXdG5J?=
 =?utf-8?B?VWVpQlQ2VllBYlBnbVE5MVlRUE9ZSm5OVUZ3TkhnVE5RdVlCemJMNzdRZk1z?=
 =?utf-8?B?NVV4RElZZmlNUy9SRUJXRXdvNjR3a0RjMUt6UWFLVkN0WEJtWXZDSUxMZVdl?=
 =?utf-8?B?aUVIY21mZElKNDkwWDBPNnNkKzY0N1YvRThTaHc0cWpHTGhLMWZxeFpNdml3?=
 =?utf-8?B?bC9RTUZVQ0RYVm1oeGVlaGFFazNZUHZweE90aFQyWlB3VnVadlplLzZXOGxM?=
 =?utf-8?B?TUI3TVFlM01GVmVOM3hSa2ROblJVUXo3eEpGM1NhNUVFLzBDZnhTbzNPZjJv?=
 =?utf-8?Q?4PDsOX27h0oNtczJ3cN+a0kMlWs0lvGzoOcMJwC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3f8895-d1c9-4939-eb27-08d92b784756
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 18:56:24.1280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AFRmvO9oDiRFZxWeLmJeU5GTsOR7p+bw5ClgNCbAXCswlTIOeOnEHXnVqrTNVrn+HTJVC0JK7CqYATbYi6uuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IEZyb206IFNlcmdleSBSeWF6YW5vdiA8cnlhemFub3Yucy5hQGdtYWls
LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDksIDIwMjEgNTowMCBBTQ0KPiANCj4gSGVs
bG8gUGFyYXYsDQo+IA0KPiBPbiBUdWUsIEp1biA4LCAyMDIxIGF0IDc6NTQgUE0gUGFyYXYgUGFu
ZGl0IDxwYXJhdkBudmlkaWEuY29tPiB3cm90ZToNCj4gPj4gRnJvbTogTG9pYyBQb3VsYWluIDxs
b2ljLnBvdWxhaW5AbGluYXJvLm9yZz4NCj4gPj4gU2VudDogVHVlc2RheSwgSnVuZSA4LCAyMDIx
IDc6MzcgUE0NCj4gPj4NCj4gPj4gRnJvbTogU2VyZ2V5IFJ5YXphbm92IDxyeWF6YW5vdi5zLmFA
Z21haWwuY29tPg0KPiA+Pg0KPiA+PiBSZXR1cm4gYSBwYXJlbnQgZGV2aWNlIHVzaW5nIHRoZSBG
TEFfUEFSRU5UX0RFVl9OQU1FIGF0dHJpYnV0ZQ0KPiBkdXJpbmcNCj4gPj4gbGlua3MgZHVtcC4g
VGhpcyBzaG91bGQgaGVscCBhIHVzZXIgZmlndXJlIG91dCB3aGljaCBsaW5rcyBiZWxvbmcgdG8N
Cj4gPj4gYSBwYXJ0aWN1bGFyIEhXIGRldmljZS4gRS5nLiB3aGF0IGRhdGEgY2hhbm5lbHMgZXhp
c3RzIG9uIGEgc3BlY2lmaWMNCj4gPj4gV1dBTiBtb2RlbS4NCj4gPj4NCj4gPiBQbGVhc2UgYWRk
IHRoZSBvdXRwdXQgc2FtcGxlIGluIHRoZSBjb21taXQgbWVzc2FnZSwgZm9yIHRoaXMgYWRkaXRp
b25hbA0KPiBmaWVsZCBwb3NzaWJseSBmb3IgYSBtb3JlIGNvbW1vbiBuZXRkZXZpY2Ugb2YgYSBw
Y2kgZGV2aWNlIG9yIHNvbWUgb3RoZXINCj4gb25lLg0KPiA+DQo+ID4+IFNpZ25lZC1vZmYtYnk6
IFNlcmdleSBSeWF6YW5vdiA8cnlhemFub3Yucy5hQGdtYWlsLmNvbT4NCj4gPj4gLS0tDQo+ID4+
ICBuZXQvY29yZS9ydG5ldGxpbmsuYyB8IDUgKysrKysNCj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKykNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL3J0bmV0bGlu
ay5jIGIvbmV0L2NvcmUvcnRuZXRsaW5rLmMgaW5kZXgNCj4gPj4gNTZhYzE2YS4uMTIwODg3Yw0K
PiA+PiAxMDA2NDQNCj4gPj4gLS0tIGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMNCj4gPj4gKysrIGIv
bmV0L2NvcmUvcnRuZXRsaW5rLmMNCj4gPj4gQEAgLTE4MTksNiArMTgxOSwxMSBAQCBzdGF0aWMg
aW50IHJ0bmxfZmlsbF9pZmluZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPj4gICAgICAgaWYg
KHJ0bmxfZmlsbF9wcm9wX2xpc3Qoc2tiLCBkZXYpKQ0KPiA+PiAgICAgICAgICAgICAgIGdvdG8g
bmxhX3B1dF9mYWlsdXJlOw0KPiA+Pg0KPiA+PiArICAgICBpZiAoZGV2LT5kZXYucGFyZW50ICYm
DQo+ID4+ICsgICAgICAgICBubGFfcHV0X3N0cmluZyhza2IsIElGTEFfUEFSRU5UX0RFVl9OQU1F
LA0KPiA+PiArICAgICAgICAgICAgICAgICAgICAgICAgZGV2X25hbWUoZGV2LT5kZXYucGFyZW50
KSkpDQo+ID4+ICsgICAgICAgICAgICAgZ290byBubGFfcHV0X2ZhaWx1cmU7DQo+ID4+ICsNCj4g
PiBBIGRldmljZSBuYW1lIGFsb25nIHdpdGggZGV2aWNlIGJ1cyBlc3RhYmxpc2hlcyBhIHVuaXF1
ZSBpZGVudGl0eSBpbiB0aGUNCj4gc3lzdGVtLg0KPiANCj4gU3VyZS4gVG8gdW5pcXVlbHkgaWRl
bnRpZnkgYW4gYWJzdHJhY3QgZGV2aWNlIHdlIG5lZWQgYSBmdWxsIHBhdGgsIGluY2x1ZGluZyBh
DQo+IGRldmljZSBwYXJlbnQuIEluIHN5c2ZzIGl0IHdpbGwgYmUgYSBkZXZpY2UgYnVzLiBCdXQg
SUZMQV9QQVJFTlRfREVWX05BTUUNCj4gd2FzIGludHJvZHVjZWQgdG8gaWRlbnRpZnkgdGhlIHBh
cmVudCBkZXZpY2Ugd2l0aGluIGEgc2NvcGUgb2YgYSBzcGVjaWZpYw0KPiBzdWJzeXN0ZW0sIHdo
aWNoIGlzIHNwZWNpZmllZCBieSB0aGUgSUZMQV9JTkZPX0tJTkQgYXR0cmlidXRlLg0KDQpJRkxB
X0lORk9fS0lORCBpcyBub3Qgc2V0IGZvciBtYW55IHR5cGVzIG9mIG5ldGRldmljZXMgd2hpY2gg
YXJlIG5vdCBjcmVhdGVkIGJ5IGlwIGxpbmsgYWRkIGNvbW1hbmQuDQpTdWNoIGFzIHBjaSBkZXZp
Y2VzLCBhdXhpbGlhcnkgYnVzIHBjaSBzZiBkZXZpY2VzIGFuZCBwb3NzaWJseSBvdGhlcnMuDQpJ
RkxBX1BBUkVOVF9ERVZfTkFNRSBpcyByZXR1cm5lZCBmb3IgYWxsIG5ldGRldmljZXMgd2hpY2hl
dmVyIGhhcyBpdCB2YWxpZC4NCg0KRm9yIGV4YW1wbGUsIGZvciBhIG5ldGRldmljZSB3aXRoIFBD
SSBwYXJlbnQsIGl0IHdpbGwgcmV0dXJuIGFzIDAwMDA6MDM6MDAuMC4NClRoaXMgbnVtYmVyIHN0
cmluZyBpcyB1c2VsZXNzIHdpdGhvdXQgdGVsbGluZyB0aGF0IGl0IGlzIHBjaSBkZXZpY2UgbmFt
ZS4NClNvIGlmIHlvdSBwcmVmZXIgdG8gYWRkIFBBUkVOVF9ERVZfTkFNRSwgaXQgbmVlZHMgdG8g
YWNjb21wYW55IGFsb25nIHdpdGggaXRzIEJVU19OQU1FIHRvby4NCklGTEFfSU5GX0tJTkQgZm9y
IHBjaSBhbmQgb3RoZXIgZGV2aWNlIGlzIG51bGwuDQpTbyBvbmx5IFBBUkVOVF9ERVYgaXMgbm90
IHN1ZmZpY2llbnQuDQoNCj4gSUZMQV9QQVJFTlRfREVWX05BTUUgc2hvdWxkIGJlY29tZSBhIHNh
bmUgYWx0ZXJuYXRpdmUgZm9yIHRoZQ0KPiBJRkxBX0xJTksgdXNhZ2Ugd2hlbiB0aGUgbGluayBw
YXJlbnQgaXMgbm90IGEgbmV0ZGV2IHRoZW1zZWxmLg0KPg0KT2suIGJ1dCBub3QgZW5vdWdoLiBJ
dCBuZWVkcyB0byBhY2NvbXBhbnkgd2l0aCB0aGUgYnVzIG5hbWUgdG9vLg0KIA0KPiBZb3UgY2Fu
IGZpbmQgbW9yZSBkZXRhaWxzIGluIHRoZSBkZXNjcmlwdGlvbiBvZiBJRkxBX1BBUkVOVF9ERVZf
TkFNRQ0KPiBpbnRyb2R1Y3Rpb24gcGF0Y2ggWzFdLCBteSBleHBsYW5hdGlvbiwgd2h5IHdlIG5l
ZWQgdG8gbWFrZSB0aGUgYXR0cmlidXRlDQo+IGNvbW1vbiBbMl0gYW5kIHNlZSBhIHVzYWdlIGV4
YW1wbGUgaW4gdGhlIHd3YW4gaW50ZXJmYWNlIGNyZWF0aW9uIHBhdGNoDQo+IFszXS4NCj4gDQpJ
IGFtIG5vdCBhZ2FpbnN0IG1ha2luZyBpdCBjb21tb24uIEkganVzdCBzYXkgdGhhdCBpZiB5b3Ug
cHJlZmVyIHRvIGV4cG9zZSB0aGlzIGR1cGxpY2F0ZSAoYW5kIHVzZWZ1bCkgaW5mbywgcGxlYXNl
IGFjY29tcGFueSB3aXRoIGRldmljZSBidXMgbmFtZSB0b28uDQoNCkJ0dzogcGFyZW50IGRldmlj
ZSBpbmZvIGlzIGF2YWlsYWJsZSB2aWEgZXRob29sIHN1Y2ggYXMNCg0KZXRodG9vbCAtaSBlbnAx
czBmMCB8IGdyZXAgYnVzLWluZm8NCmJ1cy1pbmZvOiAwMDAwOjAxOjAwLjANCg0KVGhpcyBpcyBs
ZWZ0IHRvIHRoZSBpbmRpdmlkdWFsIGRyaXZlciB0byBmaWxsIHVwLg0KQ29tcGFyZSB0byB0aGF0
IGdlbmVyaWMgd2F5IGxpa2UgdGhpcyBpbiB0aGlzIHBhdGNoIGlzIGRlc2lyZWQgd2l0aCBidXMg
bmFtZS4NCg0KPiAxLiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMTYyMzE2MTIyNy0y
OTkzMC0yLWdpdC1zZW5kLWVtYWlsLQ0KPiBsb2ljLnBvdWxhaW5AbGluYXJvLm9yZy8NCj4gMi4N
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L0NBSE5LbnNUS2ZGRjlFY2t3U25Mcndh
UGRIX3RranZkQjNQVnJhDQo+IE1ELU9McUZkTG1wX1FAbWFpbC5nbWFpbC5jb20vDQo+IDMuIGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8xNjIzMTYxMjI3LTI5OTMwLTQtZ2l0LXNlbmQt
ZW1haWwtDQo+IGxvaWMucG91bGFpbkBsaW5hcm8ub3JnLw0KPiANCj4gPiBIZW5jZSB5b3Ugc2hv
dWxkIGFkZCBJRkxBX1BBUkVOVF9ERVZfQlVTX05BTUUgYW5kIHJldHVybiBpdA0KPiBvcHRpb25h
bGx5IGlmIHRoZSBkZXZpY2UgaXMgb24gYSBidXMuDQo+ID4gSWYgKGRldi0+ZGV2LnBhcmVudC0+
YnVzKQ0KPiA+ICByZXR1cm4gcGFyZW50LT5idXMtPm5hbWUgc3RyaW5nLg0KPiANCj4gTG9va3Mg
bGlrZSB3ZSBhcmUgYWJsZSB0byBleHBvcnQgdGhlIGRldmljZSBidXMgbmFtZS4gRG8geW91IGhh
dmUgYSB1c2UgY2FzZQ0KPiBmb3IgdGhpcyBhdHRyaWJ1dGU/IA0KVGhlIG9uZSBJIGV4cGxhaW5l
ZCBhYm92ZS4NCg0KPiBBbmQgZXZlbiBzbywgc2hvdWxkIHdlIGJsb2F0IHRoaXMgc2ltcGxlIHBh
dGNoIHdpdGgNCj4gYXV4aWxpYXJ5IGF0dHJpYnV0ZXM/DQo+DQpOb3Qgc3VyZSB3aGljaCBvbmUu
IEkgZG9u4oCZdCBzZWUgYW55IG1vcmUgdG8gYWRkIG90aGVyIHRoYXQgYnVzIG5hbWUgYW5kIHBh
cmVudCBkZXZpY2UgbmFtZS4NCg0KQSBzaW1pbGFyIHBhdGNoIFs0XSB0byBpbmNsdWRlIHBhcmVu
dCBkZXZpY2UgZm9yIHJkbWEgbmV0d29ya2luZyBkZXZpY2VzIGRpZG4ndCBtYWtlIHRocm91Z2gg
YmVjYXVzZSBpdHMgcmVhZGlseSBhdmFpbGFibGUgaW4gc3lzZnMuDQogDQpbNF0gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtcmRtYS9CWTVQUjEyTUI0MzIyNDZGMzE1NUJDMUQ0NDA4NTc2
MjlEQ0VCMEBCWTVQUjEyTUI0MzIyLm5hbXByZDEyLnByb2Qub3V0bG9vay5jb20vDQo=
