Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFCC455174
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbhKRAJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:09:08 -0500
Received: from mga17.intel.com ([192.55.52.151]:47058 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240507AbhKRAJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:09:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="214800352"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="214800352"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 16:06:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="549622022"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 17 Nov 2021 16:06:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 16:06:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 16:06:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 16:06:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkL5GsvEB1Qrd4VWvL1WIE3kdqmNiX+M2TUE5+CRFys1+JiF0s4ENrYvSuCKXwqqD1NH6WzyV9dEwU6oIiVPh2XUmmAos24AtpaAAKRKJttPd+XgDFpHaQNLhgXaccRgurBBHb6FRZdlGS+uvKJ36A86SSFZsdGNZafCiKrIXgE7qYXfuBBy+Wxu3K11BgpGKOG+R3yUviHILkeqHVvPO08wuEAAgCYzTIsjOy1snIDTdmWu3xEpLj/YurEo7Xlw48n/fDk/gZfPDWrXlDQNIEFEo+sWgEtkS385aYT7tXsWgSR0tFIALectq4X13uBbbJO0//gz6zBIWYL6k8pvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh3fNuOMHZ3aWGRSSBmuunkQReg9qOXT/ifEnX7mFm4=;
 b=G4P7JadQfGWVAxZm8PW8ZqgsZuDCGuv0mEnWETJYXAtnvRAuiBuxW0H/d9yky+EC2YblrdM/nL/IiRjFI7LZJyFqkhFFW1s78wOaM9q5hkY1Ty+Son6gko9Llu26KCO2JK9ynfknE5eBvyDXFVGEkuug67LYye18iWGoKF2k5XD0CMr5jhMg+B8U2hPL6de7/zliTuGzeIyJImSLk3OzzFc1IzBqQ+Xd6cZprm9Ej+SrvmQ3D3zp5vEZM+sXF6djCOPj/kGdLaBxtwLK4Kdv3DUgxsrGjzvpnvxIxcHg1m0flaj+biV3f9pqEZ5G+O5WfiGAMKn5iKqdV2gSCGkkjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rh3fNuOMHZ3aWGRSSBmuunkQReg9qOXT/ifEnX7mFm4=;
 b=qc9HHzUlooxzpDw/iC81z7G5HEzcmvzYXctAcIywZMyOu8PyfFrnAMwPOyiSBz9jQySYY4bGcaiUGY5u/ZUy8d9Xk6bBswsBPhMkSQNOcmwcP8DttC24m9oxGYv/N/3ABWEHXKbQvaJKb1LFedHd6kXw1L4B+G4TfgVNhou6wgI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2976.namprd11.prod.outlook.com (2603:10b6:805:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Thu, 18 Nov
 2021 00:06:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 00:06:02 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "luo.penghao@zte.com.cn" <luo.penghao@zte.com.cn>,
        "zealci@zte.com.cn" <zealci@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH linux-next] e1000e: Remove useless variables
Thread-Topic: [PATCH linux-next] e1000e: Remove useless variables
Thread-Index: AQHX1tuNicDLxNLZhkmO4uJO2L7l2awIchEA
Date:   Thu, 18 Nov 2021 00:06:02 +0000
Message-ID: <9278b8115aab6a1a01987ce62dcd390299477bc1.camel@intel.com>
References: <20211111090712.158901-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211111090712.158901-1-luo.penghao@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c36c094d-011c-42fc-c32e-08d9aa273546
x-ms-traffictypediagnostic: SN6PR11MB2976:
x-microsoft-antispam-prvs: <SN6PR11MB297675F89E6ACF6768E17E45C69B9@SN6PR11MB2976.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BnGlMJqpPvL0RhjUl2elxESa/n9GeBCrBFDbEFvMnQr71N3Yi+V4b1QgxtpRUjNSrgxZ04OjuPloHJQl74M4w68YDXKkYVxapL2UpK56mGB9WWK+zLSAHt5ruWvor5B7c0G2XzhzjS6XsuPn7gLARTUb5sj6+XRpvdDla8JdJ4JeCgl8an9Lkkn97IWErLDxJVo5ZU1yf/JOkr3cBfxU8WAjTyIAa+IC2UMK+vSJ7iWo6X645TYuHtMvPPj+TJL3PyqmbOFPrPnnOwqv4CjZZls/qmi9SUP8v6w7+YdZlhjKRaxDIFjn30GRmSZAWyfeAYs7Fot9tud2VA1SqkVventp++KELq3/EJSuZldFiZZ6RZWBmn9wv5n+MapJbI8viqOvRoQDJ7znK9dcahSvUxtXFGlQt7LYTMHqDkJrjHLU9cS/1LR07pbIgdxNCAnsSxRshzchSbwl6ZuKUoo2mdIRSKC5r2/gmENfJVouYy0rCZs1e1lfaPjTWrumUL6st/40pSeDBGXQtUgPJZjGGnlCSPkRBQn1FIdUSrHPpjxOekmLgHCT3ir0sy4laDDCPhJQqqDydKWmSF0KutlbEFmskB9QMTNnRArxVd1vLIjZZ+A5o88edP7hNbSGYsJF3Po/BMhy2IrAuEF4Si2haFwt9PGpks34YlnXaPDCQsui73yPBJWCW5PjFnBtzOJo31ZmaBTD8B+Am4j/Ljq8uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(86362001)(83380400001)(36756003)(8676002)(71200400001)(76116006)(316002)(91956017)(66946007)(5660300002)(508600001)(66556008)(66476007)(64756008)(66446008)(4326008)(6506007)(4001150100001)(6512007)(38100700002)(26005)(2906002)(38070700005)(122000001)(2616005)(82960400001)(6636002)(186003)(8936002)(110136005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTRsaXRoTGZMdXhva3hSaVROZ1cwNGVwTGpIYVpVcW53SVFkQ2FYTGV1NkNq?=
 =?utf-8?B?Unh4a1Zhd2dhTEo2NS8ySWtKbWlZK3BEamFkVEpueUlKUlROOUdET3dWMnU4?=
 =?utf-8?B?S0duYWUrWUYzVW1vZkUreVdTcWUzM2lsOG4wWHVHYU90VThDdTFGT0dGd0NH?=
 =?utf-8?B?TGhZTDZJYTRMTG8wd2ZDTDNGZHFhaEhCSkJYeWpUSElGWGlkVXg0N1B6Vjdw?=
 =?utf-8?B?OVpYdVZ4ci9XVFlnUkRvL2xMenNxQ2d1M3c5SUk2UDdHc3N1c1BleFk5OGln?=
 =?utf-8?B?ZkdOY3lsTk5VYWNiTGtLbXVEOFlyZXVxKzF3MWZpWktNTUcvaDBxMEhpL29G?=
 =?utf-8?B?cnBsZmF1b3V3NjJJSlFKaXVPRDBFNndEVW01T0Z4RHFHRU9wNlB1Uk1OUlAz?=
 =?utf-8?B?cXRkc0tuRk5OV0F3cHZrdDVJSkVrZFExYUJPY25vN1FwbHl4Z1dxTHlFZURB?=
 =?utf-8?B?K0xTaitrMzNiS1RDeFdPYmt0dkNBbVdRY1ZZVEZHTWcrRGxFZmg4NGtrbm5i?=
 =?utf-8?B?MFQ0N21HSXBNd0xNUXQ1SGlvNWNUWWFXTzJEdWZlSVpjaWdTNlJDYVFLTlha?=
 =?utf-8?B?VWZ0bk16dm1lMzI0ZXpsOVJxa1hZVjI0SVJOTTRVSXE4ZTRPZ2hldlJzZ0o1?=
 =?utf-8?B?eEs2d3U5WVRGSlhDN25pMFZYYmZkSmsrcTU3ek1hN01DSk81Mk92R0JVS0cz?=
 =?utf-8?B?bGJoOHRoeHN4aG9UZmJETnF0dzlTU1JsZUJNUGVreUZXbkljVjdpdko5QzQw?=
 =?utf-8?B?TXd1azc1Z05tMzVDUEFTSTFGcDN0LzVHVCsyZHA1MVBYMWVpNkE1MWdmb0tj?=
 =?utf-8?B?ZW9tU0RvWWtQYXpXWmVUdnIvaUZ2aHAxUTZuZjYvVndJVHpRSEZFMWJGWmhv?=
 =?utf-8?B?VmpmNzRaOGo3cVZBb2ZkbjRrU3dLVm9FSW1Bb3djNE5iQ1dlS2ZQenBIL05M?=
 =?utf-8?B?eE1ubmtVZTl2MGJkcWJ0V2pFUFFsZ2tYbVNFcTJLZTVFWnN1eE5XRWZURXZ5?=
 =?utf-8?B?Mi9sWVFTR29KZkRMVmlZTkJmZm1PRURYU3doUlJHRmdsYjQxczRPVW10bGJx?=
 =?utf-8?B?MFZtbkwrb1ZEc1JkNjgwY2dwd0pCZkF6bkJZMnhSTUxlY1JsSWx0bWgrNXEr?=
 =?utf-8?B?OXdmWnZVNHI1dkRJNVZMRUx0c2R1cDF1bURyVnFTNTMvYWFSeU1LOFdpQW9o?=
 =?utf-8?B?cTNRVXF2L0RIdGJZZkROMFgwZVVMTDFSNTNQai8ySDBmN1g1QnpxSTlJSnhu?=
 =?utf-8?B?T2dvSXNrbzZkcXdZMEpMYzhaekNUM1QvU1dDdzhROVJIZXFOaHphbDBDTUNj?=
 =?utf-8?B?SkNVSjlSeitpREE0cDRPR2ZjMlhFU2MrcHlpM3hudEgrYTJobGY3K2NQQlVo?=
 =?utf-8?B?cEhVelZDMlNadW00dFRoajZNQ1VYOUk0dXhQVEp0YmR2SUVvN1VXNmphMUdZ?=
 =?utf-8?B?dUJsOU9OOVE3d3BybTV3ZXFIL0NlY0ErV0dNOXg2bmVDeGdKUWNKbVBKRjhk?=
 =?utf-8?B?OGpNdndweFFtVE9xSmFoWFR5TG5QNFhQRVBvclI0UmQ4bCtqN1h3M2dLNUMz?=
 =?utf-8?B?UlloWTFpNmh0b3dHZDhyd0o4MDkraFlxUFFINFRFcmJRUFhTM2NBWkFpSDJW?=
 =?utf-8?B?Y2pEYXdQQlVuWFBOV0taVXhRK2ZjMEtlMkRFZ2NlN2lzMVhPc3BOOWtVUG1s?=
 =?utf-8?B?OUpwMUJ2ZW9YSS9zVlN0c0JDT05ISGhYT1JJNXpZZkthYmh6VkhKM1BYOGFO?=
 =?utf-8?B?YW9XOFZOVTd0RXE5bGxHR3VNWDhXTmFnTGpOcWZFemgyUGZqbkhEL2FqN2pO?=
 =?utf-8?B?RU1EWFdGaGNoZloyUyt2aGd4Q2tKVjJidFQ5OFZlSkdwbVBBTzBVSm5NMkNk?=
 =?utf-8?B?cFFBaCtJK0xaQTYxQzlKcjdHL2pzWFU2YzlFTlJEb2F6UXBvT2NxSUJUUElu?=
 =?utf-8?B?NU9mSkxTeTFvc2RSbXp3M3hyeW1QL2lXM0ZJNXpzTGhsZUh1OC9WYjE1ZVdW?=
 =?utf-8?B?NWI3NHJPRkt5bkhGMTY2N29hVUlyeTVKMnBXMmlxMkM3ZENEYzJnYUpsM2NH?=
 =?utf-8?B?Z2NoVEYxRFJHVWlaQ3lCUkhaQWZVRm5tdXpRR0FhVVA0MGpEOUI2VnFkYVlB?=
 =?utf-8?B?Q3BwcjEzbFJGSXZoTGlia1V1akxzeVNSMWxpQUl2T0RUcVEzU2cvYnFiNVFZ?=
 =?utf-8?B?U2t1ajg3ZnlPSFk0Ti8zc3FNeDRwU2w2TXlkVDUvQllqMnpXOTdGMGVhMmNF?=
 =?utf-8?Q?3PhgnuJ/OoOhUIITV8FETo+DW4mU8axOUruKtUGeTU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4CC5729076E3F4D8231DB255BB0A139@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36c094d-011c-42fc-c32e-08d9aa273546
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 00:06:02.2712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFFbHlcHOWG1synW1fH8c82cQzLDDbg9jEeKEmSnDyRAMWqamRSUK4QIz2QmPiSf0Ps+v2rM0FqyiQDe2Byu2oGsxX2dao/QP5xRgExUg9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2976
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTExIGF0IDA5OjA3ICswMDAwLCBjZ2VsLnp0ZUBnbWFpbC5jb20gd3Jv
dGU6DQo+IEZyb206IGx1byBwZW5naGFvIDxsdW8ucGVuZ2hhb0B6dGUuY29tLmNuPg0KPiANCj4g
VGhpcyB2YXJpYWJsZSBpcyBub3QgdXNlZCBpbiB0aGUgZnVuY3Rpb24uDQo+IA0KPiBUaGUgY2xh
bmdfYW5hbHl6ZXIgY29tcGxhaW5zIGFzIGZvbGxvd3M6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9lMTAwMGUvbmV0ZGV2LmM6OTE2OjE5IHdhcm5pbmcNCj4gZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jOjEzMTA6MTkgd2FybmluZw0KPiANCj4gVmFs
dWUgc3RvcmVkIHRvICdodycgZHVyaW5nIGl0cyBpbml0aWFsaXphdGlvbiBpcyBuZXZlciByZWFk
DQoNClRoaXMgcGF0Y2ggYWxzbyBkb2Vzbid0IGJ1aWxkOg0KDQpJbiBmaWxlIGluY2x1ZGVkIGZy
b20gLi9pbmNsdWRlL2xpbnV4L3ByaW50ay5oOjU1NSwNCiAgICAgICAgICAgICAgICAgZnJvbSAu
L2luY2x1ZGUvbGludXgva2VybmVsLmg6MjAsDQogICAgICAgICAgICAgICAgIGZyb20gLi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9wZXJjcHUuaDoyNywNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2N1cnJlbnQuaDo2LA0KICAgICAgICAgICAgICAgICBmcm9tIC4v
YXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmg6MTcsDQogICAgICAgICAgICAgICAgIGZy
b20gLi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90aW1leC5oOjUsDQogICAgICAgICAgICAgICAgIGZy
b20gLi9pbmNsdWRlL2xpbnV4L3RpbWV4Lmg6NjUsDQogICAgICAgICAgICAgICAgIGZyb20gLi9p
bmNsdWRlL2xpbnV4L3RpbWUzMi5oOjEzLA0KICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVk
ZS9saW51eC90aW1lLmg6NjAsDQogICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4
L3N0YXQuaDoxOSwNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW9kdWxl
Lmg6MTMsDQogICAgICAgICAgICAgICAgIGZyb20gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
ZTEwMDBlL25ldGRldi5jOjY6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvbmV0
ZGV2LmM6IEluIGZ1bmN0aW9uDQplMTAwMF9jbGVhbl9yeF9pcnE6DQpkcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9lMTAwMGUvZTEwMDAuaDozMToyMDogZXJyb3I6IGh3IHVuZGVjbGFyZWQNCihm
aXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbikNCiAgIDMxIHwgICAgICAgICBuZXRkZXZfZGJnKGh3
LT5hZGFwdGVyLT5uZXRkZXYsIGZvcm1hdCwgIyMgYXJnKQ0KICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgXn4NCi4vaW5jbHVkZS9saW51eC9keW5hbWljX2RlYnVnLmg6MTM0OjI5OiBub3RlOiBp
biBkZWZpbml0aW9uIG9mIG1hY3JvDQpfX2R5bmFtaWNfZnVuY19jYWxsDQogIDEzNCB8ICAgICAg
ICAgICAgICAgICBmdW5jKCZpZCwgIyNfX1ZBX0FSR1NfXyk7ICAgICAgICAgICAgICAgXA0KICAg
ICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4NCi4vaW5jbHVkZS9s
aW51eC9keW5hbWljX2RlYnVnLmg6MTcwOjk6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybw0K
X2R5bmFtaWNfZnVuY19jYWxsDQogIDE3MCB8ICAgICAgICAgX2R5bmFtaWNfZnVuY19jYWxsKGZt
dCwgX19keW5hbWljX25ldGRldl9kYmcsICAgICAgICAgDQpcDQogICAgICB8ICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmg6NDk1MDo5OiBub3Rl
OiBpbiBleHBhbnNpb24gb2YgbWFjcm8NCmR5bmFtaWNfbmV0ZGV2X2RiZw0KIDQ5NTAgfCAgICAg
ICAgIGR5bmFtaWNfbmV0ZGV2X2RiZyhfX2RldiwgZm9ybWF0LCAjI2FyZ3MpOyAgICAgICAgICAg
IA0KXA0KICAgICAgfCAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvZTEwMDBlL2UxMDAwLmg6MzE6OTogbm90ZTogaW4gZXhwYW5zaW9uIG9mDQpt
YWNybyBuZXRkZXZfZGJnDQogICAzMSB8ICAgICAgICAgbmV0ZGV2X2RiZyhody0+YWRhcHRlci0+
bmV0ZGV2LCBmb3JtYXQsICMjIGFyZykNCiAgICAgIHwgICAgICAgICBefn5+fn5+fn5+DQpkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvbmV0ZGV2LmM6OTcwOjI1OiBub3RlOiBpbiBl
eHBhbnNpb24NCm9mIG1hY3JvIGVfZGJnDQogIDk3MCB8ICAgICAgICAgICAgICAgICAgICAgICAg
IGVfZGJnKCJSZWNlaXZlIHBhY2tldCBjb25zdW1lZCBtdWx0aXBsZQ0KYnVmZmVyc1xuIik7DQog
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+DQpkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9lMTAwMGUvZTEwMDAuaDozMToyMDogbm90ZTogZWFjaCB1bmRlY2xhcmVkDQppZGVu
dGlmaWVyIGlzIHJlcG9ydGVkIG9ubHkgb25jZSBmb3IgZWFjaCBmdW5jdGlvbiBpdCBhcHBlYXJz
IGluDQogICAzMSB8ICAgICAgICAgbmV0ZGV2X2RiZyhody0+YWRhcHRlci0+bmV0ZGV2LCBmb3Jt
YXQsICMjIGFyZykNCiAgICAgIHwgICAgICAgICAgICAgICAgICAgIF5+DQouL2luY2x1ZGUvbGlu
dXgvZHluYW1pY19kZWJ1Zy5oOjEzNDoyOTogbm90ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybw0K
X19keW5hbWljX2Z1bmNfY2FsbA0KICAxMzQgfCAgICAgICAgICAgICAgICAgZnVuYygmaWQsICMj
X19WQV9BUkdTX18pOyAgICAgICAgICAgICAgIFwNCiAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgvZHluYW1pY19kZWJ1Zy5oOjE3
MDo5OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8NCl9keW5hbWljX2Z1bmNfY2FsbA0KICAx
NzAgfCAgICAgICAgIF9keW5hbWljX2Z1bmNfY2FsbChmbXQsIF9fZHluYW1pY19uZXRkZXZfZGJn
LCAgICAgICAgIA0KXA0KICAgICAgfCAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fg0KLi9pbmNs
dWRlL2xpbnV4L25ldGRldmljZS5oOjQ5NTA6OTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3Jv
DQpkeW5hbWljX25ldGRldl9kYmcNCiA0OTUwIHwgICAgICAgICBkeW5hbWljX25ldGRldl9kYmco
X19kZXYsIGZvcm1hdCwgIyNhcmdzKTsgICAgICAgICAgICANClwNCiAgICAgIHwgICAgICAgICBe
fn5+fn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9lMTAw
MC5oOjMxOjk6IG5vdGU6IGluIGV4cGFuc2lvbiBvZg0KbWFjcm8gbmV0ZGV2X2RiZw0KICAgMzEg
fCAgICAgICAgIG5ldGRldl9kYmcoaHctPmFkYXB0ZXItPm5ldGRldiwgZm9ybWF0LCAjIyBhcmcp
DQogICAgICB8ICAgICAgICAgXn5+fn5+fn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
ZTEwMDBlL25ldGRldi5jOjk3MDoyNTogbm90ZTogaW4gZXhwYW5zaW9uDQpvZiBtYWNybyBlX2Ri
Zw0KICA5NzAgfCAgICAgICAgICAgICAgICAgICAgICAgICBlX2RiZygiUmVjZWl2ZSBwYWNrZXQg
Y29uc3VtZWQgbXVsdGlwbGUNCmJ1ZmZlcnNcbiIpOw0KICAgICAgfCAgICAgICAgICAgICAgICAg
ICAgICAgICBefn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5j
OiBJbiBmdW5jdGlvbg0KZTEwMDBfY2xlYW5fcnhfaXJxX3BzOg0KZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvZTEwMDBlL2UxMDAwLmg6MzE6MjA6IGVycm9yOiBodyB1bmRlY2xhcmVkDQooZmly
c3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pDQogICAzMSB8ICAgICAgICAgbmV0ZGV2X2RiZyhody0+
YWRhcHRlci0+bmV0ZGV2LCBmb3JtYXQsICMjIGFyZykNCiAgICAgIHwgICAgICAgICAgICAgICAg
ICAgIF5+DQouL2luY2x1ZGUvbGludXgvZHluYW1pY19kZWJ1Zy5oOjEzNDoyOTogbm90ZTogaW4g
ZGVmaW5pdGlvbiBvZiBtYWNybw0KX19keW5hbWljX2Z1bmNfY2FsbA0KICAxMzQgfCAgICAgICAg
ICAgICAgICAgZnVuYygmaWQsICMjX19WQV9BUkdTX18pOyAgICAgICAgICAgICAgIFwNCiAgICAg
IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+DQouL2luY2x1ZGUvbGlu
dXgvZHluYW1pY19kZWJ1Zy5oOjE3MDo5OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8NCl9k
eW5hbWljX2Z1bmNfY2FsbA0KICAxNzAgfCAgICAgICAgIF9keW5hbWljX2Z1bmNfY2FsbChmbXQs
IF9fZHluYW1pY19uZXRkZXZfZGJnLCAgICAgICAgIA0KXA0KICAgICAgfCAgICAgICAgIF5+fn5+
fn5+fn5+fn5+fn5+fg0KLi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oOjQ5NTA6OTogbm90ZTog
aW4gZXhwYW5zaW9uIG9mIG1hY3JvDQpkeW5hbWljX25ldGRldl9kYmcNCiA0OTUwIHwgICAgICAg
ICBkeW5hbWljX25ldGRldl9kYmcoX19kZXYsIGZvcm1hdCwgIyNhcmdzKTsgICAgICAgICAgICAN
ClwNCiAgICAgIHwgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2UxMDAwZS9lMTAwMC5oOjMxOjk6IG5vdGU6IGluIGV4cGFuc2lvbiBvZg0KbWFj
cm8gbmV0ZGV2X2RiZw0KICAgMzEgfCAgICAgICAgIG5ldGRldl9kYmcoaHctPmFkYXB0ZXItPm5l
dGRldiwgZm9ybWF0LCAjIyBhcmcpDQogICAgICB8ICAgICAgICAgXn5+fn5+fn5+fg0KZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jOjEzNTY6MjU6IG5vdGU6IGluIGV4
cGFuc2lvbg0Kb2YgbWFjcm8gZV9kYmcNCiAxMzU2IHwgICAgICAgICAgICAgICAgICAgICAgICAg
ZV9kYmcoIlBhY2tldCBTcGxpdCBidWZmZXJzIGRpZG4ndCBwaWNrDQp1cCB0aGUgZnVsbCBwYWNr
ZXRcbiIpOw0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fg0KDQoNCg==
