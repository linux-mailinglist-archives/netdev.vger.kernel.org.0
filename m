Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8333FFF6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCRGyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 02:54:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:63516 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRGyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 02:54:33 -0400
IronPort-SDR: fcEeFtii8eFbjfI1eMrmyDHkCBzAvKwDjH/dVTIzF9c9fsgyCeNKflyepABRLsM28sMJe58jrE
 gVGXuU8ICFwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189707428"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="189707428"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 23:54:32 -0700
IronPort-SDR: 5Jbm6ONFtjMCbM9PZ0EbFKJF/F1HC5mIIWNl7ljmnZyG2x8KdHHWZnCDgPfUHVpaNncdS+QTnA
 herS28IIW/zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="450367631"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2021 23:54:32 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 23:54:32 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 23:54:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 17 Mar 2021 23:54:31 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 17 Mar 2021 23:54:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA3jT4o02LnEfEkbp/RMAzgN4MvpawV/ekYqTCSU9nxmMtg6MZTbNoWCGArm//IWFpdBeRtv2a9Cmi6AKqKAB5mnAopMmTLex4YVxtlOubpE31EopAnvpDaNLbGVbsBrxKD9lkoO9ReyAN+6vYopZjd3jAUbyisLukp1fVKdbvOcEAmKjANxZU0J9EljRZ3oN+04SERsjufRVGowbSP4rGbDmQpm1nWNcaOOKq/BL80m9rfPvQ2QD+bSdI9zcacGiybkNud7q/DIpXaLzRkra+IExsnRmZnbeaSBLi/yikLWpr3De28sKTILo258O9hUe0/REU2yKMMlfFzmd2j2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErP0bzRdfuqg36Q3x7HQjn85ktqDzvLvGSAsOmpCwTA=;
 b=YHztpx4tQTuOZIF6y1RgekASXv9t3QPO13CDbiscZYqSmUl9L/+UAZXhsDFiCrC29JGETQhs1XEfghEDgfii03pRvXjSZsxu03eQNFE+XqolZRt8Zx2OiHkplofiLuD3M2iHNmwegTcFXDmwH8TfuKBej4N0CKFb1dMmwbyJfSNrVsqIxoYF7pxssLShXTuZx4k+D5xUZ0gVzf3AoulVAgFAC7QVXGvSFBBC1kkCPX1x5f0oK18UWRD9zXWTBvPbRhsG6VYjSXsMbhPLFTyjK/fg7LaenZi3Brw9wOZ5jFcPZ8wtJ86J3RxK+3n1TQ1tj5k7BLeefk39zbbvFBj0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErP0bzRdfuqg36Q3x7HQjn85ktqDzvLvGSAsOmpCwTA=;
 b=JCH+0bgZivpNquPaiQLuIAFwjWMoBzx0K7QNHX404VTci5mrWIrMvb/xB6/GZHHD8aTObOrnppmj2G/23YMlnIJtH5k0t24SD8AXIRAM1gOmUOvZ2kmYUz7EWO049WH/ZqNxGSgvgP8VSyIRHimgvKupeLYYKRpqEpCgt6td+nU=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB2774.namprd11.prod.outlook.com (2603:10b6:a02:c1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 06:54:29 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608%5]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 06:54:29 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Voon Weifeng <voon.weifeng@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH net-next 1/1] net: phy: fix invalid phy id when probe
 using C22
Thread-Topic: [PATCH net-next 1/1] net: phy: fix invalid phy id when probe
 using C22
Thread-Index: AQHXGkHiOKV14+tCY06c/oLWfqPUP6qH1r+AgAF6f+A=
Date:   Thu, 18 Mar 2021 06:54:29 +0000
Message-ID: <BYAPR11MB2870F3213AA7690871FB179FAB699@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20210316085748.3017-1-vee.khee.wong@intel.com>
 <eba4f81c-adc0-61d1-8cb9-4c0c5995bc49@gmail.com>
In-Reply-To: <eba4f81c-adc0-61d1-8cb9-4c0c5995bc49@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [210.195.17.79]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81366802-f7f3-4591-18df-08d8e9daad60
x-ms-traffictypediagnostic: BYAPR11MB2774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2774929CF2929687306868B5AB699@BYAPR11MB2774.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EuTPjPRFE1n3/P/MyU9OxxzNTuOnleUQdLPeq+VSeWOlLUAYXoLMsiTmTltDG8BIN+zKRkrbZNpp+axArOyQzfWFNk1O8CDkxE41ZBzxtUu2YboP2UHq+lB3Chu0KaWXdgcgwfll+VZKRmSWaworE1kbw5wATkDx6ZE2lOjU9wgymklE13W/JugClZMuJRzm8Qq8JRMDVRXC+kZJQNMPIdAtqf3Ubt7XynSKg3ftIk7dVS12jSO/IHNBLpkO1F2Ex0c5oKkMqKNAc/5hPuiHNZ/C1AAK+rgcqVw0mhsUfq13mwZc5nrEluhY8rr7SaMn5PvBQVqz3MiHLLKWbyemi2uar2lk6AJaUQY/migzCl6Q0jUBGmoCkZD5df1wX4L6SnTwR9h68dsoDoL2IyZu9QCU5C8Tue+b5F+r4vpDy3CZ5SfT6Ztczm826bwHufpJpDntVsBJ+bQzeXjqARP6jHvA9sWT5+F2uBA+Mwinsx/IcObmBn1BeB8wmTA0NWvSUg6tggnu1OUWl6nHgcG+zbAHgs+7N9D48b8dYnf/Wbw8DV/p+wywuVS78HcgJvlVQ3TWuGBc/orESwHd90Dbp+mWL89e3Uoaza5MCfKMnz0ymnzJSdbgnFMYs9K6bs+i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(9686003)(66446008)(2906002)(66476007)(55016002)(66556008)(8936002)(66946007)(54906003)(52536014)(478600001)(8676002)(76116006)(64756008)(316002)(4326008)(33656002)(26005)(53546011)(6506007)(110136005)(5660300002)(86362001)(83380400001)(107886003)(186003)(55236004)(7696005)(38100700001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z2R3ZE9MWnhIMnpmbjlPbGJGQnp4VVVXSGE4d2k5a0dxL1lidjRGZ1NZbkFY?=
 =?utf-8?B?ZnNOampVYkxDTTNWbi9tV09SRlM5K1QvTHhLdjlYd3h6eW9QTWg3SnRKQ210?=
 =?utf-8?B?T3B1b3Z6UW83TVlQdEpzSFlCdThsQWRQVHgvQkxIOG5lMm43ZFFLa2J0TlJJ?=
 =?utf-8?B?YnZ3eTI4bnVrdzYvelB2R1F3SzJYMUtZbDF5WGtQZTM2dUhzTENUVnFEWWg5?=
 =?utf-8?B?RjBHY2ZDbUwzZkRZL1AzV1kza2hsTzNMUkpnVlMzNGpKRUNJbmRQQVV6T2Qy?=
 =?utf-8?B?N2JnS1NRUzdxS2ZmaXFsTTVkd0wxcmVOdXhkSnpnSHlxMVZtcG5PdDdHQU5Q?=
 =?utf-8?B?bXFUaDl5ZnByb3VsZmVSd0R2SkFUcnJoT2ZHQUxVSDdRSzRSc2F4aFp0eTR3?=
 =?utf-8?B?WUI4cElHZ2xzeS9FV3NhblljaVdZejdSMjRGVXNOMWZzL3Y5THBnTjlNTjQ2?=
 =?utf-8?B?V2tnYlVVazg2c3dJbndvU2FNQmVIQ3FENlRUOUJwZVd0dDRMeVpmNXFSbzE5?=
 =?utf-8?B?U2luOWNqWm5Bak14T1pORjljZE1QQWVyYlpPNFdXMTM0ekJnUzJRclJqa3VO?=
 =?utf-8?B?YjBNdVRMRXNoSklYbUZGVmhveDNKZXdxSjF2Y0M2TUkxWVhoakIvek96M3J3?=
 =?utf-8?B?Wlc4Y01QdXMrMnJwVFV3dFNiaCtvdlVLQS9DVC8wMGpvWE42b2Mxd3pzOFBN?=
 =?utf-8?B?bktMeVBCY2JvZnJrSmdkd1UxSld6T0pBazcyS2NUdFBJOE03ck53dG8xZDhk?=
 =?utf-8?B?UVNibXNmVE5TRS9oTTMxYTRVMjdsOEVBcDl5TENQeHpDMDNaMXdrQzh5c1dp?=
 =?utf-8?B?bDJmMFlQSGwzbnd2UjhnbklBTzdjazNYdVNFRXJOWFNZTkRLNllhNjgxcVFY?=
 =?utf-8?B?eWl6d1dub0hkODM5RU9BZlgyZ1lybFRBY0RiczFZMjN6MXFjUE9idlZ5aWtq?=
 =?utf-8?B?dkl3Z2RneEI4ck9oUTh1Z2hpQkY0VEF2NWpSS1BuMDZ4TGxwTHE0QjU3cFA5?=
 =?utf-8?B?KzUxbTgxRU5Sck0xK0VKSDZpd2l2RXkxdHc1eGdsaFNSZ2kyNnFrQ3MyKzdl?=
 =?utf-8?B?SnRXelIwNGZQREs4RjFobVVxQlhybElVVlQxb0NrU3F5T1E5K0JPMzIwZ01X?=
 =?utf-8?B?Vk04WUc5OFRIQklDbTQzNGFNclNiRjhTY3F3cVB2d0IwMHpleW9GZkQ1bVlQ?=
 =?utf-8?B?d08xSXd2cDE0aFR6NGd0UzhyVGtyRDlHMVpPMmltbzJXMmpWVGV0cFIvb240?=
 =?utf-8?B?ak9HRmRWOHFsT2pMZVJ3cncyMndkL1I1bHo1V3B1ckMreTgzTlhCcjZsNWk4?=
 =?utf-8?B?bXRtNGRsNVY1WnpxcHNMeWN3aHJLeEVVaXgwU3NmYVdlOTVodEpDK2tmUml6?=
 =?utf-8?B?VU41bkhSUkVPNWlSZVY0NVVDM05sM0dtVzdNTUcwU3RhY1I2aUVnV1B0aXR1?=
 =?utf-8?B?SVJkRW41a3E1Wk5lTkd3eXQ5WGU5MktZdnVod1VYSU80VUVIQldab1VWaG51?=
 =?utf-8?B?RktuYzRWMkNOYTFrNWU0VHN6b3RRSXlETUlhZUJJOUU4aUl4cENmZVo3V1VR?=
 =?utf-8?B?Q25meFVGQk9OY3kxQWpGS2VMeVhReEp2ellZYmRjY2YzZDdrR0Y0TjJkVFA5?=
 =?utf-8?B?RUlYTkRKT3loSGU4cTdrSkYvb3M4YVFZcjFQQWxpUWxERlIwWWxIZ24ycGJn?=
 =?utf-8?B?YTBWOHF5TTRQeU9hNTFSWkhYY1RqSGFZUU9JRFNrVmxiNDVuRmg4OUxYMUZp?=
 =?utf-8?Q?ummIebJQr90MMGbbeCHXwGlP+1IVE92uG5CVnpV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81366802-f7f3-4591-18df-08d8e9daad60
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 06:54:29.2964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QdxKwzWhy08ziCoQTsJmdhgd3zZ8UODG2WABc55PcZ+JsB7cG0DpPy03MFI/9VJe3YFcETvbiZXJMCcn2n+xVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2774
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhr
YWxsd2VpdDFAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE3LCAyMDIxIDQ6
MTUgUE0NCj4gVG86IFdvbmcsIFZlZSBLaGVlIDx2ZWUua2hlZS53b25nQGludGVsLmNvbT47IEFu
ZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD47IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGlu
dXgub3JnLnVrPjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnOyBWb29uIFdlaWZlbmcgPHZvb24ud2VpZmVuZ0BpbnRlbC5jb20+OyBPbmcsDQo+IEJvb24g
TGVvbmcgPGJvb24ubGVvbmcub25nQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBu
ZXQtbmV4dCAxLzFdIG5ldDogcGh5OiBmaXggaW52YWxpZCBwaHkgaWQgd2hlbiBwcm9iZQ0KPiB1
c2luZyBDMjINCj4gDQo+IE9uIDE2LjAzLjIwMjEgMDk6NTcsIFdvbmcgVmVlIEtoZWUgd3JvdGU6
DQo+ID4gV2hlbiB1c2luZyBDbGF1c2UtMjIgdG8gcHJvYmUgZm9yIFBIWSBkZXZpY2VzIHN1Y2gg
YXMgdGhlIE1hcnZlbGwNCj4gPiA4OEUyMTEwLCBQSFkgSUQgd2l0aCB2YWx1ZSAwIGlzIHJlYWQg
ZnJvbSB0aGUgTUlJIFBIWUlEIHJlZ2lzdGVycw0KPiA+IHdoaWNoIGNhdXNlZCB0aGUgUEhZIGZy
YW1ld29yayBmYWlsZWQgdG8gYXR0YWNoIHRoZSBNYXJ2ZWxsIFBIWQ0KPiA+IGRyaXZlci4NCj4g
Pg0KPiANCj4gVGhlIGlzc3VlIG9jY3VycyB3aXRoIGEgTUFDIGRyaXZlciB0aGF0IHNldHMgTURJ
TyBidXMgY2FwYWJpbGl0eQ0KPiBmbGFnIE1ESU9CVVNfQzIyX0M0NSwgbGlrZSBzdG1tYWM/IE9y
IHdoYXQgaXMgdGhlIGFmZmVjdGVkIE1BQw0KPiBkcml2ZXI/DQo+IA0KDQpZZXMsIHlvdSBhcmUg
cmlnaHQuIFRoaXMgaXNzdWUgaXMgc2VlbiB3aGVuIE1hcnZlbGxFMjExMCBpcyB1c2VkIHdpdGgN
CnRoZSBTVE1NQUMuDQoNCj4gQW5kIGlmIHlvdSBzdGF0ZSBpdCdzIGEgZml4LCBhIEZpeGVzIHRh
ZyB3b3VsZCBiZSBuZWVkZWQuDQo+IA0KDQpOb3RlZC4gV2lsbCBzZW5kIGEgdjIgYW5kIG1hcmtl
ZCBmb3IgbmV0Lg0KDQo+ID4gRml4ZWQgdGhpcyBieSBhZGRpbmcgYSBjaGVjayBvZiBQSFkgSUQg
ZXF1YWxzIHRvIGFsbCB6ZXJvZXMuDQo+ID4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiA+IFJldmlld2VkLWJ5OiBWb29uIFdlaWZlbmcgPHZvb24ud2VpZmVuZ0BpbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogV29uZyBWZWUgS2hlZSA8dmVlLmtoZWUud29uZ0BpbnRlbC5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgfCA0ICsrLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jIGIvZHJpdmVy
cy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiA+IGluZGV4IGEwMDlkMTc2OWIwOC4uZjFhZmMwMGZj
YmEyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jDQo+ID4gQEAgLTgyMCw4ICs4MjAsOCBA
QCBzdGF0aWMgaW50IGdldF9waHlfYzIyX2lkKHN0cnVjdCBtaWlfYnVzICpidXMsIGludA0KPiBh
ZGRyLCB1MzIgKnBoeV9pZCkNCj4gPg0KPiA+ICAJKnBoeV9pZCB8PSBwaHlfcmVnOw0KPiA+DQo+
ID4gLQkvKiBJZiB0aGUgcGh5X2lkIGlzIG1vc3RseSBGcywgdGhlcmUgaXMgbm8gZGV2aWNlIHRo
ZXJlICovDQo+ID4gLQlpZiAoKCpwaHlfaWQgJiAweDFmZmZmZmZmKSA9PSAweDFmZmZmZmZmKQ0K
PiA+ICsJLyogSWYgdGhlIHBoeV9pZCBpcyBtb3N0bHkgRnMgb3IgYWxsIHplcm9lcywgdGhlcmUg
aXMgbm8gZGV2aWNlIHRoZXJlICovDQo+ID4gKwlpZiAoKCgqcGh5X2lkICYgMHgxZmZmZmZmZikg
PT0gMHgxZmZmZmZmZikgfHwgKCpwaHlfaWQgPT0gMCkpDQo+ID4gIAkJcmV0dXJuIC1FTk9ERVY7
DQo+ID4NCj4gPiAgCXJldHVybiAwOw0KPiA+DQoNCg==
