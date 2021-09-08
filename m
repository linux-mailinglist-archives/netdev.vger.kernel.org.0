Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB7403E60
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352492AbhIHRcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:32:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:57554 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhIHRb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 13:31:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220230663"
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="220230663"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 10:30:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,278,1624345200"; 
   d="scan'208";a="431414953"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 08 Sep 2021 10:30:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 10:30:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 8 Sep 2021 10:30:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 8 Sep 2021 10:30:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp3dbBzvfDWHugDsOAyq8N6gL15SMBgvFgQiao98B/PfCvKmXYceHji356iLdFPfR6LcQ+qVpGh7HbgwUy+j605YcRZ+DDVe/AmHfeOMVhFt696YIj3hQramn4sOmAQzCPBKgDh1dvR5Bi/POP2pwiH5859OLdOQ9iryni9X9jPBNgkdniEs4cab4ZIDxAo2ncFeuUwkS2a0LzDuukXzdYPXsaI3Ec8ucJjgLbWNc+7mpZf/ziG7jw2tw7oB36aaf9g3GRI5YeKBD6V/YNi065KvOhIII14WNRt1Ed0GIPh+mpKOaKRfWsqeah1BIX7b0DqX/jl3VDZBEJMoK0wASA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QDFnS9fa3KnVvewuEsfcsGcFsAmfwPG7b7X6BDpmnIk=;
 b=dMzC6hIbclWZeh2t/FDYOJ3lqqPFTxJPBiaK3NUd9TAuyaChDGk2Snahu3wDWIO9s/gjl2EyVDhawMK5UrTz3xytfZlyNPW1UsJpjBVmezKj34oxhPkS4EmqPcTvP+zde5rGUUKzmOERKD3y00waF428mrzbXly80bB6yBz1MfmKd1ueMXg1zpfQSQZ7Bd4ynk/vMxWKDNZnHMubJCAqv2WSXfH5O4O3ZEUm9C1pjicFMMecbkYfdDpGfuZ4h915dQGr6ERPdbcWMZ6zGA3MgEGk6RJm+NCNF+/0zRU6mZTvK3UeaUlAmpXYtUIf0erGZq0PDEAj9pB6vaGuB30ljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDFnS9fa3KnVvewuEsfcsGcFsAmfwPG7b7X6BDpmnIk=;
 b=yQ6Idk/3QHKvfQQlQov7EsaNbjOQIfYvzUf/B5MeqMrUYuby+0du+tVwb4UKO1Y7WtJHB83ZmSf+2qdR78PWtIXw2wB7gn8KFSMn3UNL/iuzRw8RU6a4w14mZByoMb68a7WIvsUPmGvhbf4WVWRzQUTkqVX+PWRX1vgKY9k4KNM=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 17:30:24 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Wed, 8 Sep 2021
 17:30:24 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQgACTXICAAAjlIA==
Date:   Wed, 8 Sep 2021 17:30:24 +0000
Message-ID: <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2abf0363-c56d-417f-d89f-08d972ee5779
x-ms-traffictypediagnostic: PH0PR11MB4981:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4981BBA3718BED8E87EFDC89EAD49@PH0PR11MB4981.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zLNVQrBLx1VAvq4j7fLt+Haidabjr2LWVAfNhictSLSDR5RlB6lq6o4OGIWwxv1V4mXTgKv0c3K4i0lkXtH8P5uEH6DsndCCeawBxamJekKLOtQQvu8HIfx5TdYFe5cQJCiUPqNbZHdE9D5BEjO2ksS3yULUl5UdgJF9r8HoA2juxGRldedDDXuDRlFYdmHQLnEe2RKdqmxq8s2bf1Y6sOfixIt6Q8bKcc2ei+7NXPc1ipjyY6b/Zeez9OVecXCaNEfPqwWrlkLDNiHlgxOpO0rniP0CqInHzLsF4D/PDnsr+iXLqoW1OvZHFMTyjVM0gVTBtZzDJ/0Li739NmwEXEGwAgMSPrDDgGHgmN4VkcmXhPUfIUPXPeOf829WQCqjlbAZQfXS6p40GcB/cfw7RNleZio0P9ME4AFyVzZwocKOO03i5xN/KYZcyoJFOZsBaG9wfebId9IyOLHcKg4HWPK5m0PiQh3InjXAcxHuKYdKPt13RXUhEC7RM5joF86SHnH8oKId9sGLOAXGp48Br15meoOsdd9RANBd+zzwos9Sae9qnZXHH5H47FFJRva5GXulOnZUdp9AFOEWJHjM0ek/7yIuEi7mm43G7YUN0JbZVaJMfIin+D09sgKkKdcb5DJd7WUGhu+Myzy04elyPr81G9SePXVCdWBG/QUVpZDd25Xx/2kvGvUiuFfx7vFCVimnl/iNeOKY7fnv2UFH6i0uo6r/9IOwyGe/uKVIQ/HWaWwEl4GOOauk8gameTCHZTUskO9bi+J+DaNS6hL/dethgD/XstiopCPdVcp1wrg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(53546011)(6506007)(316002)(110136005)(54906003)(7696005)(66574015)(33656002)(5660300002)(15650500001)(52536014)(55016002)(2906002)(9686003)(508600001)(7416002)(66446008)(64756008)(66476007)(66556008)(66946007)(76116006)(186003)(4326008)(26005)(8676002)(86362001)(966005)(38070700005)(38100700002)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUkvdHVYbGVTcHRHZ01Vd3U3c3A0REwwUDlDUkU1ZmI4MVdwZW9wcER1WXlw?=
 =?utf-8?B?NDVER2RwOGR1UDV4QVpVVU43YWFmbzhOdkUxVFRPZCtXeXVHUXNIV2NlOE93?=
 =?utf-8?B?NDhSc1kxZWxTZmVHUFRnVW41eHhYNVdhTHZ0d1Y5MENMa1IxUjlWU2dpZko2?=
 =?utf-8?B?Tm9idE9EcThET01xUDBXUWVqZ1Erd2ZYVkFFQmNiM0pjZDRIdnVmWTdMT0dO?=
 =?utf-8?B?c1dJTTc1TGxMZ2lhekszVng0eEVadmx1cFRwY1VrQmZ2djJBUXpZMjRNV0M4?=
 =?utf-8?B?SSs1RjMzTnZQNFMzdGpFaSt6NmdhNEVsMjJBaGVWNlFsMVZKM3hPazRQeXNS?=
 =?utf-8?B?bXMyenhLcmlUUks1MmJSR2NibjJwY0I3dDErTmxZRTU1aU8rTjd5eE1aTGY0?=
 =?utf-8?B?cFczRlRXdGtiMlRERnNSQUtWQjZvaEdmVk5zellUT1lwam5WS0hudFp6N2xm?=
 =?utf-8?B?ek1PNE5qRmxpMW11TXZOVDBPS3A3a2txVlJJZW5HbFNOc3JvNVkyK3FERi8v?=
 =?utf-8?B?N0lvZ3d3bUpEUzNpQWRVdDdJSkRrbGpQRTJ1U0pnWUxNbWlMOFp4TlR4elcw?=
 =?utf-8?B?QWhJZC82QzBqVytuOCtkOWdOZnRKUVg5S0RGbkpzaGU5eVRFRmI4K2pjTnRF?=
 =?utf-8?B?bDAvVCtZNjJnbG9RZko1aFNKNzVWNkV1djIrV0FsN2Frd1l5ekx0TVkvbkJk?=
 =?utf-8?B?WFFKckpEWkRGYm5TMUord3k1MTdQVmViRmhDcVdxR0pXcnhibzFMVDBDbDdQ?=
 =?utf-8?B?M0kzd1VVcEVYakw1RjdhVGFrR2lDakpUZjYzOUdNTjUzM0V4bFpWaEkyTWRP?=
 =?utf-8?B?dWtrTk9yVnlJYXlMc0FVa2l6YmxRblVvUmpKTlNmeUEyMmo4eFJWZnprUWxH?=
 =?utf-8?B?SVZnVUlrNS9LK1VmNGt0aFg1MUtxbm9pa29peXNBaERlRGpReGdCQVFRTXI1?=
 =?utf-8?B?R1pRRThVcUFadzEyZ3BsWDdXdzRhZzFYNVp4MS9WODQ0ZGpEQzJzOHVhWUZw?=
 =?utf-8?B?Y1cyNXRVVlNhdTlxRUV3UVZNWEJJWmM3TXZxVHM0UUZDLzRzUUlEQnErWVVo?=
 =?utf-8?B?Z2hnb2xlVzYzWmlxUTRvR2JsNnVEa1NXK211SWpXd0F4b2hkR0VwVUVwNzNr?=
 =?utf-8?B?WWwyVTlwQ3RBSzlGdG91bklOb0VMY3lNYldTbURJU2lhdFRPeHh4b2NRaWta?=
 =?utf-8?B?MXI5YlpLMjJjWnFNME5LM0lIWUxVRVZSZld0ZlpKdlZxZEdCUy9xY1F6c1p2?=
 =?utf-8?B?eEc2eUtXeTlyZ2h2NGdETDZKQzVuci9MYS9qZnFwR3FrVE1uUWJrUmlkMmlG?=
 =?utf-8?B?dEh6MFJvejJUUDJPRGxUUkVCNlNFRzZvNitGSTNaYndxWnhyWDFtUmc4NWdk?=
 =?utf-8?B?QjZBWmZVS3lYa1hjdDFZMHExZ0FSYWhwbHFqaEc3TUhLcU1hSnFNdVVKejlM?=
 =?utf-8?B?d3NtdFBxZko5ZGZDZmJlbFV6WlB2ZFRkSmxOMXhVQXVzNmtYam54RzJVWTF1?=
 =?utf-8?B?VU0rREx3TGN2T2xGcXUrMXBUc3V6b2g5S3YzMDRlVDZLWDVVUmNrMkcwbGNs?=
 =?utf-8?B?RkgwbWV5TEpNQThJeUw5Qm1lQmxCWWtCa3EzRkhQTkdZL2dVcmNKOU5XbHV3?=
 =?utf-8?B?eGhGbXBob3RCL3ZEK0pSVDdWQlRjbG9HbjBIY1RWWHE1Rkg1Nit4clo4Y0hP?=
 =?utf-8?B?cFRDU2xJVDl2cCtqK3NhNjhpQXJEendsclZrejg3LzQzWndlWk9DSTVIVGRT?=
 =?utf-8?Q?gOUELQoO9TziIyUTdI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abf0363-c56d-417f-d89f-08d972ee5779
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 17:30:24.4095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tosjsDhwvQKOxwWj7A15LGWW0jbV22h5fTkD8g28Wb2BGu8iKba2m2Zuv1VHDa3YsKienVAV6m26F86lIJUKr0BqnTxw6Xbw/21CgaHTvOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciA4LCAyMDIxIDY6MjEg
UE0NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIHJ0bmV0bGluazogQWRkIG5l
dyBSVE1fR0VURUVDU1RBVEUNCj4gbWVzc2FnZSB0byBnZXQgU3luY0Ugc3RhdHVzDQo+IA0KPiBP
biBXZWQsIDggU2VwIDIwMjEgMDg6MDM6MzUgKzAwMDAgTWFjaG5pa293c2tpLCBNYWNpZWogd3Jv
dGU6DQo+ID4gPiA+IFllcCEgWWV0IGxldCdzIGdvIG9uZSBzdGVwIGF0IGEgdGltZS4gSSBiZWxp
ZXZlIG9uY2Ugd2UgaGF2ZSB0aGUgYmFzaWNzDQo+IChFRUMNCj4gPiA+ID4gbW9uaXRvcmluZyBh
bmQgcmVjb3ZlcmVkIGNsb2NrIGNvbmZpZ3VyYXRpb24pIHdlJ2xsIGJlIGFibGUgdG8NCj4gaW1w
bGVtZW50DQo+ID4gPiA+IGEgYmFzaWMgZnVuY3Rpb25hbGl0eSAtIGFuZCBhZGQgYmVsbHMgYW5k
IHdoaXN0bGVzIGxhdGVyIG9uLCBhcyB0aGVyZSBhcmUNCj4gbW9yZQ0KPiA+ID4gPiBjYXBhYmls
aXRpZXMgdGhhdCB3ZSBjb3VsZCBzdXBwb3J0IGluIFNXLg0KPiA+ID4NCj4gPiA+IFRoZSBzZXQg
QVBJIG1heSBzaGFwZSBob3cgdGhlIGdldCBBUEkgbG9va3MuIFdlIG5lZWQgYSBtaW5pbWFsIHZp
YWJsZQ0KPiA+ID4gQVBJIHdoZXJlIHRoZSB3aG9sZSBjb250cm9sIHBhcnQgb2YgaXQgaXMgbm90
ICJmaXJtd2FyZSBvciBwcm9wcmlldGFyeQ0KPiA+ID4gdG9vbHMgdGFrZSBjYXJlIG9mIHRoYXQi
Lg0KPiA+ID4NCj4gPiA+IERvIHlvdSBoYXZlIHB1YmxpYyBkb2NzIG9uIGhvdyB0aGUgd2hvbGUg
c29sdXRpb24gd29ya3M/DQo+ID4NCj4gPiBUaGUgYmVzdCByZWZlcmVuY2Ugd291bGQgYmUgbXkg
bmV0ZGV2IDB4MTUgdHV0b3JpYWw6DQo+ID4gaHR0cHM6Ly9uZXRkZXZjb25mLmluZm8vMHgxNS9z
ZXNzaW9uLmh0bWw/SW50cm9kdWN0aW9uLXRvLXRpbWUtDQo+IHN5bmNocm9uaXphdGlvbi1vdmVy
LUV0aGVybmV0DQo+ID4gVGhlIFN5bmNFIEFQSSBjb25zaWRlcmF0aW9ucyBzdGFydHMgfjU0OjAw
LCBidXQgYmFzaWNhbGx5IHdlIG5lZWQgQVBJIGZvcjoNCj4gPiAtIENvbnRyb2xsaW5nIHRoZSBs
YW5lIHRvIHBpbiBtYXBwaW5nIGZvciBjbG9jayByZWNvdmVyeQ0KPiA+IC0gQ2hlY2sgdGhlIEVF
Qy9EUExMIHN0YXRlIGFuZCBzZWUgd2hhdCdzIHRoZSBzb3VyY2Ugb2YgcmVmZXJlbmNlDQo+IGZy
ZXF1ZW5jeQ0KPiA+IChpbiBtb3JlIGFkdmFuY2VkIGRlcGxveW1lbnRzKQ0KPiA+IC0gY29udHJv
bCBhZGRpdGlvbmFsIGlucHV0IGFuZCBvdXRwdXQgcGlucyAoR05TUyBpbnB1dCwgZXh0ZXJuYWwg
aW5wdXRzLA0KPiByZWNvdmVyZWQNCj4gPiAgIGZyZXF1ZW5jeSByZWZlcmVuY2UpDQo+IA0KPiBU
aGFua3MsIGdvb2QgcHJlc2VudGF0aW9uISBJIGhhdmVuJ3Qgc2VlbiBtdWNoIGluIHRlcm1zIG9m
IHN5c3RlbQ0KPiBkZXNpZ24sIGF0IHRoZSBsZXZlbCBzaW1pbGFyIHRvIHRoZSBCcm9hZGNvbSB3
aGl0ZXBhcGVyIHlvdSBzaGFyZWQuDQoNClNlZSB0aGUgImRyYXdpbmciIGJlbG93Lg0KIA0KPiA+
ID4gPiBJIGJlbGlldmUgdGhpcyBpcyB0aGUgc3RhdGUtb2YtYXJ0OiBoZXJlJ3MgdGhlIEJyb2Fk
Y29tIHB1YmxpYyBvbmUNCj4gPiA+ID4gaHR0cHM6Ly9kb2NzLmJyb2FkY29tLmNvbS9kb2MvMTIx
MTE2ODU2NzgzMiwgSSBiZWxpZXZlIE1hcnZlbA0KPiA+ID4gPiBoYXMgc2ltaWxhciBzb2x1dGlv
bi4gQnV0IHdvdWxkIGFsc28gYmUgaGFwcHkgdG8gaGVhciBvdGhlcnMuDQo+ID4gPg0KPiA+ID4g
SW50ZXJlc3RpbmcuIFRoYXQgcmV2ZWFscyB0aGUgbmVlZCBmb3IgYWxzbyBtYXJraW5nIHRoZSBi
YWNrdXANCj4gPiA+ICgvc2Vjb25kYXJ5KSBjbG9jay4NCj4gPg0KPiA+IFRoYXQncyBvcHRpb25h
bCwgYnV0IHVzZWZ1bC4gQW5kIGhlcmUncyB3aGVyZSB3ZSBuZWVkIGEgZmVlZGJhY2sNCj4gPiBv
biB3aGljaCBwb3J0L2xhbmUgaXMgY3VycmVudGx5IHVzZWQsIGFzIHRoZSBzd2l0Y2ggbWF5IGJl
IGF1dG9tYXRpYw0KPiANCj4gV2hhdCBkbyB5b3UgbWVhbiBieSBvcHRpb25hbD8gSG93IGRvZXMg
dGhlIHVzZXIga25vdyBpZiB0aGVyZSBpcw0KPiBmYWxsYmFjayBvciBub3Q/IElzIGl0IHRoYXQg
SW50ZWwgaXMgaW50ZW5kaW5nIHRvIHN1cHBvcnQgb25seQ0KPiBkZXZpY2VzIHdpdGggdXAgdG8g
MiBwb3J0cyBhbmQgdGhlIHNlY29uZCBwb3J0IGlzIGFsd2F5cyB0aGUNCj4gYmFja3VwIChhcG9s
b2dpZXMgZm9yIHNwZWN1bGF0aW5nKS4NCg0KVGhhdCB3aWxsIGJlIGEgcGFydCBvZiBwaW4gY29u
ZmlnIEFQSS4gSXQgbmVlZHMgdG8gZ2l2ZSBpbmZvIGFib3V0IHRoZSBudW1iZXINCm9mIHN1cHBv
cnRlZCBwaW5zIHRoYXQgdGhlIFBIWS9NQUMgY2FuIHVzZSBhcyByZWNvdmVyZWQgY2xvY2sgb3V0
cHV0cy4NCk9uY2UgdGhlIHBpbiBpcyBhc3NpZ25lZCB0byB0aGUgbGFuZSB0aGUgcmVjb3ZlcmVk
IGNsb2NrIChkaXZpZGVkIG9yIG5vdCkNCndpbGwgYXBwZWFyIG9uIHRoZSBjb25maWd1cmVkIFBI
WS9NQUMgcGluIGFuZCBFRUMgd2lsbCBiZSBhYmxlIHRvDQp1c2UgaXQuIElmIHRoZXJlIGlzIG1v
cmUgdGhhbiAxIGF2YWlsYWJsZSAtIHRoZXkgd2lsbCBoYXZlIHNvbWUgcHJpb3JpdHkNCmFzc2ln
bmVkIHRvIHRoZW0gdGhhdCB3aWxsIGJlIGtub3duIHRvIHRoZSBFRUMvYm9hcmQgZGVzaWduZXIu
DQoNCkFuZCB3ZSBwbGFuIHRvIHN1cHBvcnQgZGV2aWNlcyB0aGF0IG9ubHkgY29tZXMgd2l0aCAx
IHJlY292ZXJlZCBjbG9jaw0Kb3V0cHV0IGFzIHdlbGwuDQogDQo+ID4gPiBIYXZlIHlvdSBzZWVu
IGFueSBkb2NzIG9uIGhvdyBzeXN0ZW1zIHdpdGggZGlzY3JlZXQgUEhZIEFTSUNzIG11eA0KPiA+
ID4gdGhlIGNsb2Nrcz8NCj4gPg0KPiA+IFllcyAtIHVuZm9ydHVuYXRlbHkgdGhleSBhcmUgbm90
IHB1YmxpYyA6KA0KPiANCj4gTXVtYmxlLCBtdW1ibGUuIElkbywgRmxvcmlhbiAtIGFueSBkZXZp
Y2VzIHdpdGhpbiB5b3VyIHB1cnZpZXcgd2hpY2gNCj4gd291bGQgc3VwcG9ydCBTeW5jRT8NCg0K
T0sgRm91bmQgb25lIHRoYXQncyBwdWJsaWM6IA0KaHR0cHM6Ly93d3cubWFydmVsbC5jb20vY29u
dGVudC9kYW0vbWFydmVsbC9lbi9wdWJsaWMtY29sbGF0ZXJhbC90cmFuc2NlaXZlcnMvbWFydmVs
bC1waHlzLXRyYW5zY2VpdmVycy1hbGFza2EtYy04OHg1MTEzLWRhdGFzaGVldC5wZGYNCnNlZSBG
aWcuIDIzIGFuZCBjaGFwdGVyIDMuMTEgIGZvciBkZXRhaWxzLCBidXQgY29uY2VwdHVhbGx5IGl0
J3Mgc2ltaWxhci4NCiANCj4gPiA+ID4gRXRoZXJuZXQgSVAvUEhZIHVzdWFsbHkgb3V0cHV0cyBh
IGRpdmlkZWQgY2xvY2sgc2lnbmFsIChzaW5jZSBpdCdzDQo+ID4gPiA+IGVhc2llciB0byByb3V0
ZSkgZGVyaXZlZCBmcm9tIHRoZSBSWCBjbG9jay4NCj4gPiA+ID4gVGhlIERQTEwgY29ubmVjdGl2
aXR5IGlzIHZlbmRvci1zcGVjaWZpYywgYXMgeW91IGNhbiB1c2UgaXQgdG8gY29ubmVjdA0KPiA+
ID4gPiBzb21lIGV4dGVybmFsIHNpZ25hbHMsIGJ1dCB5b3UgY2FuIGFzIHdlbGwganVzdCBjYXJl
IGFib3V0IHJlbHlpbmcNCj4gPiA+ID4gdGhlIFN5bmNFIGNsb2NrIGFuZCBvbmx5IGFsbG93IHJl
Y292ZXJpbmcgaXQgYW5kIHBhc3NpbmcgYWxvbmcNCj4gPiA+ID4gdGhlIFFMIGluZm8gd2hlbiB5
b3VyIEVFQyBpcyBsb2NrZWQuIFRoYXQncyB3aHkgSSBiYWNrZWQgdXAgZnJvbQ0KPiA+ID4gPiBh
IGZ1bGwgRFBMTCBpbXBsZW1lbnRhdGlvbiBpbiBmYXZvciBvZiBhIG1vcmUgZ2VuZXJpYyBFRUMg
Y2xvY2suDQo+ID4gPg0KPiA+ID4gV2hhdCBpcyBhbiBFQ0MgY2xvY2s/IFRvIG1lIHRoZSBQTEwg
c3RhdGUgaW4gdGhlIEV0aGVybmV0IHBvcnQgaXMgdGhlDQo+ID4gPiBzdGF0ZSBvZiB0aGUgcmVj
b3ZlcmVkIGNsb2NrLiBlbnVtIGlmX2VlY19zdGF0ZSBoYXMgdmFsdWVzIGxpa2UNCj4gPiA+IGhv
bGRvdmVyIHdoaWNoIHNlZW0gdG8gYmUgbW9yZSBhcHBsaWNhYmxlIHRvIHRoZSAic3lzdGVtIHdp
ZGUiIFBMTC4NCj4gPg0KPiA+IEVFQyBpcyBFdGhlcm5ldCBFcXVpcG1lbnQgQ2xvY2suIEluIG1v
c3QgY2FzZXMgdGhpcyB3aWxsIGJlIGEgRFBMTCwgYnV0IHRoYXQncw0KPiA+IG5vdCBtYW5kYXRv
cnkgYW5kIEkgYmVsaWV2ZSBpdCBtYXkgYmUgZGlmZmVyZW50IGlzIHN3aXRjaGVzIHdoZXJlDQo+
ID4geW91IG9ubHkgbmVlZCB0byBkcml2ZSBhbGwgcG9ydHMgVFggZnJvbSBhIHNpbmdsZSBmcmVx
dWVuY3kgc291cmNlLiBJbiB0aGlzDQo+ID4gY2FzZSB0aGUgRFBMTCBjYW4gYmUgZW1iZWRkZWQg
aW4gdGhlIG11bHRpcG9ydCBQSFksDQo+ID4NCj4gPiA+IExldCBtZSBhc2sgdGhpcyAtIGlmIG9u
ZSBwb3J0IGlzIHRyYWluaW5nIHRoZSBsaW5rIGFuZCB0aGUgb3RoZXIgb25lIGhhcw0KPiA+ID4g
dGhlIGxvY2sgYW5kIGlzIHRoZSBzb3VyY2UgLSB3aGF0IHN0YXRlIHdpbGwgYmUgcmVwb3J0ZWQg
Zm9yIGVhY2ggcG9ydD8NCj4gPg0KPiA+IEluIHRoaXMgY2FzZSB0aGUgcG9ydCB0aGF0IGhhcyB0
aGUgbG9jayBzb3VyY2Ugd2lsbCByZXBvcnQgdGhlIGxvY2sgYW5kDQo+ID4gdGhlIEVFQ19TUkNf
UE9SVCBmbGFnLiBUaGUgcG9ydCB0aGF0IHRyYWlucyB0aGUgbGluayB3aWxsIHNob3cgdGhlDQo+
ID4gbG9jayB3aXRob3V0IHRoZSBmbGFnIGFuZCBvbmNlIGl0IGNvbXBsZXRlcyB0aGUgdHJhaW5p
bmcgc2VxdWVuY2UgaXQgd2lsbA0KPiA+IHVzZSB0aGUgRUVDJ3MgZnJlcXVlbmN5IHRvIHRyYW5z
bWl0IHRoZSBkYXRhIHNvIHRoYXQgdGhlIG5leHQgaG9wIGlzIGFibGUNCj4gPiB0byBzeW5jaHJv
bml6ZSBpdHMgRUVDIHRvIHRoZSBpbmNvbWluZyBSWCBmcmVxdWVuY3kNCj4gDQo+IEFscmlnaHQs
IEkgZG9uJ3QgbGlrZSB0aGF0LiBJdCBmZWVscyBsaWtlIHlvdSdyZSBhdHRhY2hpbmcgb25lIG9i
amVjdCdzDQo+IGluZm9ybWF0aW9uIChFQ0MpIHRvIG90aGVyIG9iamVjdHMgKHBvcnRzKSwgYW5k
IHJlcGVhdGluZyBpdC4gUHJvZg0KPiBHb2N6ecWCYSBhbmQgZHIgTGFuZG93c2thIHdvdWxkIG5v
dCBiZSBwcm91ZC4NCg0KSGFoYWhhIC0gZGlkIG5vdCBleHBlY3QgdGhlbSB0byBwb3AgdXAgaGVy
ZSA6KQ0KSXQncyB0cnVlLCBidXQgdGhlIHByb2JsZW0gaXMgdGhhdCB0aGV5IGRlcGVuZCBvbiBl
YWNoIG90aGVyLiBUaGUgcGF0aCBpczoNCg0KTGFuZTANCi0tLS0tLS0tLS0tLS0gfFwgIFBpbjAg
ICAgIFJlZk4gICBfX19fDQotLS0tLS0tLS0tLS0tIHwgfC0tLS0tLS0tLS0tLS0tLS0tfCAgICAg
ICAgIHwgICAgICBzeW5jZWQgY2xrDQouLi4gICAgICAgICAgICAgICB8IHwtLS0tLS0tLS0tLS0t
LS0tLXwgRUVDICB8LS0tLS0tLS0tLS0tLS0tLS0tDQotLS0tLS0tLS0tLS0tIHwvIFBpbk4gICAg
IFJlZk18X19fXyB8DQpMYW5lIE4gICAgICBNVVgNCg0KVG8gZ2V0IHRoZSBmdWxsIGluZm8gYSBw
b3J0IG5lZWRzIHRvIGtub3cgdGhlIEVFQyBzdGF0ZSBhbmQgd2hpY2ggbGFuZSBpcyB1c2VkDQph
cyBhIHNvdXJjZSAob3IgcmF0aGVyIC0gbXkgbGFuZSBvciBhbnkgb3RoZXIpLg0KVGhlIGxhbmUg
LT4gUGluIG1hcHBpbmcgaXMgYnVyaWVkIGluIHRoZSBQSFkvTUFDLCBidXQgdGhlIHNvdXJjZSBv
ZiBmcmVxdWVuY3kNCmlzIGluIHRoZSBFRUMuDQpXaGF0J3MgZXZlbiBtb3JlIC0gdGhlIFBpbi0+
UmVmIG1hcHBpbmcgaXMgYm9hcmQgc3BlY2lmaWMuDQoNClRoZSB2aWFibGUgc29sdXRpb25zIGFy
ZToNCi0gTGltaXQgdG8gdGhlIHByb3Bvc2VkICJJIGRyaXZlIHRoZSBjbG9jayIgdnMgIlNvbWVv
bmUgZHJpdmVzIGl0IiBhbmQgYXNzdW1lIHRoZQ0KICAgRHJpdmVyIHJldHVybnMgYWxsIGluZm8N
Ci0gcmV0dXJuIHRoZSBFRUMgUmVmIGluZGV4LCBmaWd1cmUgb3V0IHdoaWNoIHBpbiBpcyBjb25u
ZWN0ZWQgdG8gaXQgYW5kIHRoZW4gY2hlY2sNCiAgd2hpY2ggTUFDL1BIWSBsYW5lIHRoYXQgZHJp
dmVzIGl0Lg0KDQpJIGFzc3VtZSBvcHRpb24gb25lIGlzIGVhc3kgdG8gaW1wbGVtZW50IGFuZCBr
ZWVwIGluIHRoZSBmdXR1cmUgZXZlbiBpZiB3ZQ0KZmluYWxseSBtb3ZlIHRvIG9wdGlvbiAyIG9u
Y2Ugd2UgZGVmaW5lIEVFQy9EUExMIHN1YnN5c3RlbS4NCg0KSW4gZnV0dXJlICMxIGNhbiB0YWtl
IHRoZSBsb2NrIGluZm9ybWF0aW9uIGZyb20gdGhlIERQTEwgc3Vic3lzdGVtLCBidXQNCndpbGwg
YWxzbyBlbmFibGUgc2ltcGxlIGRlcGxveW1lbnRzIHRoYXQgd29uJ3QgZXhwb3NlIHRoZSB3aG9s
ZSBEUExMLCANCmxpa2UgYSBmaWx0ZXIgUExMIGVtYmVkZGVkIGluIGEgbXVsdGlwb3J0IFBIWSB0
aGF0IHdpbGwgb25seSB3b3JrIGZvcg0KU3luY0UgaW4gd2hpY2ggY2FzZSB0aGlzIEFQSSB3aWxs
IG9ubHkgdG91Y2ggYSBzaW5nbGUgY29tcG9uZW50Lg0KIA0KPiA+ID4gPiBUaGUgVGltZSBJUCBp
cyBhZ2FpbiByZWxhdGl2ZSBhbmQgdmVuZG9yLXNwZWNpZmljLiBJZiBTeW5jRSBpcyBkZXBsb3ll
ZA0KPiA+ID4gPiBhbG9uZ3NpZGUgUFRQIGl0IHdpbGwgbW9zdCBsaWtlbHkgYmUgdGlnaHRseSBj
b3VwbGVkLCBidXQgaWYgeW91IG9ubHkNCj4gPiA+ID4gY2FyZSBhYm91dCBoYXZpbmcgYSBmcmVx
dWVuY3kgc291cmNlIC0gaXQncyBub3QgbWFuZGF0b3J5IGFuZCBpdCBjYW4gYmUNCj4gPiA+ID4g
YXMgd2VsbCBpbiB0aGUgUEhZIElQLg0KPiA+ID4NCj4gPiA+IEkgd291bGQgbm90IHRoaW5rIGhh
dmluZyBqdXN0IHRoZSBmcmVxIGlzIHZlcnkgdXNlZnVsLg0KPiA+DQo+ID4gVGhpcyBkZXBlbmRz
IG9uIHRoZSBkZXBsb3ltZW50LiBUaGVyZSBhcmUgY291cGxlIHBvcHVsYXIgZnJlcXVlbmNpZXMN
Cj4gPiBNb3N0IHBvcHVsYXIgYXJlIDIsMDQ4IGtIeiwgMTAgTUh6IGFuZCA2NCBrSHouIFRoZXJl
IGFyZSBtYW55DQo+ID4gZGVwbG95bWVudHMgdGhhdCBvbmx5IHJlcXVpcmUgZnJlcXVlbmN5IHN5
bmMgd2l0aG91dCB0aGUgcGhhc2UNCj4gPiBhbmQvb3IgdGltZS4gSS5lLiBpZiB5b3UgZGVwbG95
IGZyZXF1ZW5jeSBkaXZpc2lvbiBkdXBsZXggeW91IG9ubHkgbmVlZCB0aGUNCj4gPiBmcmVxdWVu
Y3kgcmVmZXJlbmNlLCBhbmQgdGhlIGhpZ2hlciBmcmVxdWVuY3kgeW91IGhhdmUgLSB0aGUgZmFz
dGVyIHlvdQ0KPiBjYW4NCj4gPiBsb2NrIHRvIGl0Lg0K
