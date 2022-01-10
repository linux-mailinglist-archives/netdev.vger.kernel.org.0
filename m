Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9628C48956D
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbiAJJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:38:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:11561 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243041AbiAJJiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 04:38:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641807482; x=1673343482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BPg0iybdleUZxGVQVfT/uv9TYyJhhyoGONA6i7585d4=;
  b=FFLG2uKcf3eTwb+NB+eQrTWbhKfw1mjo136Qlgo1LSmtHPWstfqpR1QV
   nrJKi4GxxwWYA8pIstXMSjkUHA7ZOegnomlh4yJfoeHZQwsD3HW79B14z
   V69lyUB0BiBb1L9CLJlQLLIyyKW4FrkXyAhWmrjq4VkokUr+UAoKj8Lgn
   fzzyKfgGD+tcG81scXqXC90YUlUeH49lz/ADeOlnPDWXV1C0GzHcbxu/+
   g3GfbI2yR8UNrxKymaYiEX/BMjIK6i3QRSScvYpBXzeiCIPieaX0IkUHR
   vxe0CAupEgFopWEDUT1BiOi7xmwkibFlnyHQKSF+f1PWYCUuH3PBT0bce
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="306547124"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="306547124"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 01:37:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="612805006"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jan 2022 01:37:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 01:37:42 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 01:37:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 01:37:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 01:37:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxsa1xjlXat0YK3rs6QngvWGyPmfld/po9+pyydfGfD4ZZzYCXKzrE11+obOi0UqOj5wqOqjJeK+oJS5/FDza/PPBZ7UFbYfviOhQyf0pXDfxsmLaArrcmcHQW3YUF/2K+Teo7q4On6OxMdxxnV0w7KTJvOGPLVmbrxU+sBoZOg/I52okB5h6yD58Xm5Fog5SYeKtOVgRRMFr55A4MjtMCmKuOL0imeS24gh8eSWT5dZlDLrRLXO/5Lv+xPA+Mk6ldjcAAqu884DYrzRZHaCsmveaGf/+HKF5OxmNiaOfFDqf7y9LXDYEvo/M/kEK9ktIQwFqSr6dgmkgsVbjp2YUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPg0iybdleUZxGVQVfT/uv9TYyJhhyoGONA6i7585d4=;
 b=FIOvlhc6z3UELR4xwwVLtYhGI8IeXnnZc82eDEAbNT5hDCMhJo6vDU8a3gCoUAwoRVpWfXHFLay1gpHI5/9KaRQoqXhG0LR4/TAjLxA6kRb0bFNzC0Uy6vnXLUOGR9b15mia1k7UEJjEqGgRAqRANrvHlRwkFXJkyOMLGFc5ph/xs0Z5kRLA+6fcaqDGHkn3wHJVONlPuS+8wnggyPaRqZ/zIHts1xVTYkMOWCvnuwMichc4JPK+LSOzcIf95oEAFqhK/9JS8Ie9bnBtH8C2p8ef3JBhKughFVN5hn/pgQ7XSci5kCZOpfMIf5sNGtbR5RlrtM4k8/fCDFBFKOniXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MW4PR11MB5889.namprd11.prod.outlook.com (2603:10b6:303:168::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 09:36:54 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%9]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 09:36:54 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Topic: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Index: AQHYBepnvfJifzbICkqWD8xlExtYIaxb7dCAgAAPa/A=
Date:   Mon, 10 Jan 2022 09:36:53 +0000
Message-ID: <CO1PR11MB4771E08DD8C8CAE63E7A9A54D5509@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
 <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
 <1be1444c-b1f7-b7d6-adaa-78960c381161@gmail.com>
In-Reply-To: <1be1444c-b1f7-b7d6-adaa-78960c381161@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa818748-c6b5-40bd-f22b-08d9d41cbcc9
x-ms-traffictypediagnostic: MW4PR11MB5889:EE_
x-microsoft-antispam-prvs: <MW4PR11MB588919C057943B25C350DCDAD5509@MW4PR11MB5889.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mxwtQVm3HGl8nPGF2+1YGoFXcVgFtb4MHPauyJTa3BLR+gxrSe0QQKrGbKzJuG5nToNGY5w7HiGNr6hbKnExPmKGxe1IlW0WtAu+2xZWVjRZKcpgjW3wNlCYKhWgbZD6dg1hwBqHl97+wdYsT+cykECjzZIsfLIGUm8mSFrK394+iY25ip9JYeeovMAt+/rw7eCbGp8bPvl5THqnu9aABirT6+a0H5MG4zwEJiidIZ8rU5TVaiv6ZF8vV+Ef2Ayn0m95St4vZKZrmlN9QOT3LYwHOOInMJrAunI9XN0knipxe3ekIKIY2GqfLs1P2dFKZSyBx124D92ULLEEPHs+sQJhuCfqgydV08VgF/KLe2fI/mTlsTBDRQ12AvzZ2U1dIZPBIl1+g3MJeYZJR9ixNWZgkGTezkTnNlmeDkrXYbKjYpTLpzFm5LhB/xV3vQNaGdwi9yrWMJGd6/4o7Q8F4ouXhg8Ac1jJCyR5ve6TnT2qVHoh4/lDJVANHWrpFDDEuu3nJkKFMRS268i/JeUkgIXR9oM8FWUyqg/Pw3qHqOs2LgxSRItEJwJNdOPmTDwsI5oAU/r+Cxj7iOaF9RluvcHADCSBdhJ9u4GTC40nDgW3T+G4vFPZJ/f4/S3mbHJAZKwnZ7tR4uL5qzBMWjfUYPyhwR6krUEoM0+OGqrfUh7+G2ucuWqG9N4GCh4CS7UYaeJF3dBLTAgSfj2NHijvcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(38100700002)(8936002)(110136005)(55236004)(54906003)(53546011)(33656002)(83380400001)(6506007)(9686003)(82960400001)(86362001)(38070700005)(55016003)(8676002)(186003)(2906002)(52536014)(66946007)(316002)(66556008)(66476007)(66446008)(64756008)(76116006)(7696005)(26005)(71200400001)(508600001)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFUvRWdmZWEwQVA5R3hJUnFnTHAybUM2M3pCcjZEQ3FPSGs0VkM3M2czai80?=
 =?utf-8?B?b1pkRmwwQU5HaHEzMVUwaFJtdUJ2Y1ovWXYwTjJEWEVqeDM1L3BDUnhuOXA4?=
 =?utf-8?B?R09mZDVVSkp5ODlFZldZcUZBRkx2NWdWRDZ5TTRvcXRmeVR2ZFZWYThqVjEz?=
 =?utf-8?B?R3hxTzArT2F1TWN4aUZ5MC9OVFAyZFV5ZmxoRWxENiswZEN4YUd6Mk9VblB5?=
 =?utf-8?B?ODVRckdFYWVWenlSbUVUMTJtOVZBUmgrQ3hyNlkxbnljTDhwbHA1aTdrQlJh?=
 =?utf-8?B?RXI3dmdFNUJaOFNMbHl5Y2x2QmlJUDZFU2ozN29rNGxtdEdjYVptQ0doSEM3?=
 =?utf-8?B?K3VsUXZLK0dTUG80S1M4anFNVzVBSlhHK2E0Z25kUW5MRUJnV3dYc3oxSGpI?=
 =?utf-8?B?V1dTd3g5bGkwdTc1WmVqQ0ZaVVNCWjR5VXdaeVdFaTNQTWEwWlJJYWhrdm1m?=
 =?utf-8?B?NGtvQ1NjK2xmNnlsNDR0aGVFeC96YndaZzJycnY0dkJXa0lkK1dxOTFNSXNy?=
 =?utf-8?B?YnJaK0IzazFPazhSanduNUdNdHhpTDFTenU5TUF2d3Nnd0lBU1hHQ3JDOFFT?=
 =?utf-8?B?d1k4M0ZrUEgrME9PQ1JHblBTc3JqYlFSVmozSFRoc3RER0Fwd0hMcyttZzYr?=
 =?utf-8?B?Y3F1QlJGbXY2dVNiZk1vSkJIb2lZMlBWTDU3MFBxaE5IWUJualFKMmR5WUMx?=
 =?utf-8?B?V09wZ3I3YjVDMjdNODdIcmRzbm1uNUJWVWw4b3B5aGVPR1hRQmgzcGplVlpu?=
 =?utf-8?B?YXVOdlBwa1JINGt2bjV4NDZ5c0k0WG10ZUEyYmEwV0d3aUYzc3lhaWRoUlU4?=
 =?utf-8?B?MVlTbkZiR1VNSEFhRzFTclNLN2RCbUttRHlsT3JqNEMyanZrazg1ZnYwT09P?=
 =?utf-8?B?cGJmajArUTJqNlhFbDFuc0ZVZjFKUXYveWxqelNjd0NLUWNaaGRuLy85NXNm?=
 =?utf-8?B?eGNINHg3aXdFYUNUYmNSTVdwVUx3T04vSFZ0TCtLdzlteXIyNEJYaU9MOWZz?=
 =?utf-8?B?SHZtNEsxSkNZMTF6RXJzM1g1UVdMeWp4azZsRUl5ZzlsdHpWUUV1eXd5cW1O?=
 =?utf-8?B?Tm9pMnNkSWU2L3E3T3E3Unl2eWpLZk9DSmpRQTJmVW9QWXNRTTdJdExOSi9R?=
 =?utf-8?B?Yi91dS9DU3luNHBQMmdUSFpkdDI3Q3MvaGpSUHQxRGNkeUFFdjdBNEwvbDMz?=
 =?utf-8?B?M1NyWWg3cDUxNDc2SEtVb0Ewb0FGdE9Bemd0L1plNk94NkMxYVVPc01JZFZn?=
 =?utf-8?B?eHplcXNlNWlJREcyZXh1NzNkczdNZytoaCtLYTNxcm9WNXlScXNhUldhL3NO?=
 =?utf-8?B?QVQwY2twYjNCMDdCSkN0dDFESlMzcTlRcUJ1NXd4S3F2cW9MR3pHWG9xdDEv?=
 =?utf-8?B?RTFlSGEvcEdLeTM4S2Y5TjZhdWI2dUttb2VjU2Juem1nNk5hcWlzd1J5M09W?=
 =?utf-8?B?d1BHMmFvMDZYTlpCOUhWcjNQemg5aXdPOEpTM3U0MUgvSmI2NDNLaUdpTTgr?=
 =?utf-8?B?MGh3NmtFN29vODFsbGNhcGhoejZFc3A3bGlJQTU4Mm1BOVFmY21aZExkTEgx?=
 =?utf-8?B?Y2N6NEkrMkdnQUpsSW5KV2lVNGRldVBpN3VNQ1NPL2YvQWw3VmEySU8rZXVW?=
 =?utf-8?B?dEtRQTc4cEhmMGpYWStXSEc0dUVoS0pYeFh6VktNWXo0OVAxallBWlREci9N?=
 =?utf-8?B?VG8vdUttOEVWaitOQWVyUVRmRDJtVWJTeWhxaTh1TlZ5Q1lWdy9DdDc0OER2?=
 =?utf-8?B?WEZad3NvL3V4LzVkY1NjTTVtOS9xOGJES054ZW93WXE0MGZFVXlYSkJHa0Uv?=
 =?utf-8?B?U3ZOWTZtNjhHMlR1UDU0bUZhb0ZKNHd4U1p3cE13cGZwaVZVS3RoTEJnQ3Yx?=
 =?utf-8?B?ZmVJcklkR3FJRVJsVW5qV2lUc2gxUUw0N0NRTE5YTFlhMkx5RTRIQVBEUmx0?=
 =?utf-8?B?VFllaEs2ZTQ3bkJtV1hiTHZvQ2xaVHVlZHg0d2dna1BkQXJaZDFOQTBhaFR6?=
 =?utf-8?B?VUVkVkVJYkZJL2pCQmJvYk5ueDJaU2RZWXZHTGtwTDdHYWxORVVOMWNNR0FK?=
 =?utf-8?B?Q0RJTC9qZGtFb1c1NzUzM24rak1hcVg2NG9VMkVUb3A3NVZoQUhWZ3N4Si81?=
 =?utf-8?B?WUhIVkNrekZhZmY1b254T0RSYk5jTG9oaGdvVm10TnROVC9ieEJNNFAzK3ZX?=
 =?utf-8?B?ZVFzR3ZocGNwb3FxUzM3aWplYnp3bUgzN1pjaGh4SlZNM0ZHb0lWN0FXNWhO?=
 =?utf-8?B?aW5kS014MGd2eHVYOUVrT0NURHNBeXF3UmxkTHJzVVR6T0t6ZEo0MjIycUJC?=
 =?utf-8?B?QmJVTmlTUTFRUE1mRjY3ODRsVnBEbGxFSitGM0h0SXI2elRaM3NZdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa818748-c6b5-40bd-f22b-08d9d41cbcc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 09:36:53.9726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5bAiE7pQees8U33j6D9kGZJUv1K44NEO5ERt2BZcmA+1EZsTXe2RWuwg6Sf7i+JPAA/KzOkqqjionHL0q3mJPM8PuD52QXDFZYLEMdTNqXmRYBe6mpvVp0Aa1Jot3pM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5889
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDEwLCAyMDIy
IDQ6MzQgUE0NCj4gVG86IElzbWFpbCwgTW9oYW1tYWQgQXRoYXJpIDxtb2hhbW1hZC5hdGhhcmku
aXNtYWlsQGludGVsLmNvbT47DQo+IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IERhdmlk
IFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgT2xla3NpaiBSZW1wZWwgPGxpbnV4QHJlbXBlbC0NCj4gcHJpdmF0LmRl
PjsgUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IENjOiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IDEvMV0gbmV0OiBwaHk6IG1h
cnZlbGw6IGFkZCBNYXJ2ZWxsIHNwZWNpZmljIFBIWQ0KPiBsb29wYmFjaw0KPiANCj4gT24gMTAu
MDEuMjAyMiAwNzoyMSwgTW9oYW1tYWQgQXRoYXJpIEJpbiBJc21haWwgd3JvdGU6DQo+ID4gRXhp
c3RpbmcgZ2VucGh5X2xvb3BiYWNrKCkgaXMgbm90IGFwcGxpY2FibGUgZm9yIE1hcnZlbGwgUEhZ
LiBTbywNCj4gPiBhZGRpbmcgTWFydmVsbCBzcGVjaWZpYyBQSFkgbG9vcGJhY2sgb3BlcmF0aW9u
IGJ5IG9ubHkgc2V0dGluZyhlbmFibGUpDQo+ID4gb3INCj4gPiBjbGVhcmluZyhkaXNhYmxlKSBC
TUNSX0xPT1BCQUNLIGJpdC4NCj4gPg0KPiA+IFRlc3RlZCB3b3JraW5nIG9uIE1hcnZlbGwgODhF
MTUxMC4NCj4gPg0KPiBXaXRoIHRoaXMgY2hhbmdlIHlvdSdkIGJhc2ljYWxseSByZXZlcnQgdGhl
IG9yaWdpbmFsIGNoYW5nZSBhbmQgbG9vc2UgaXRzDQo+IGZ1bmN0aW9uYWxpdHkuIERpZCB5b3Ug
Y2hlY2sgdGhlIE1hcnZlbGwgZGF0YXNoZWV0cz8NCj4gQXQgbGVhc3QgZm9yIGZldyB2ZXJzaW9u
cyBJIGZvdW5kIHRoYXQgeW91IG1heSBoYXZlIHRvIGNvbmZpZ3VyZSBiaXRzIDAuLjIgaW4NCj4g
TUFDIFNwZWNpZmljIENvbnRyb2wgUmVnaXN0ZXIgMiAocGFnZSAyLCByZWdpc3RlciAyMSkgaW5z
dGVhZCBvZiBCTUNSLg0KDQpNYXkgSSBrbm93IHdoYXQgZGF0YXNoZWV0IHZlcnNpb24gdGhhdCBo
YXMgdGhlIGJpdHMgMjowJ3MgZGV0YWlsIGV4cGxhbmF0aW9uPyBUaGUgdmVyc2lvbiB0aGF0IEkg
aGF2ZSwgYml0cyAyOjAgaW4gTUFDIFNwZWNpZmljIENvbnRyb2wgUmVnaXN0ZXIgMiBzaG93cyBh
cyBSZXNlcnZlZC4NClRoZSBkYXRhc2hlZXQgSSBoYXZlIGlzICJNYXJ2ZWxsIEFsYXNrYSA4OEUx
NTEwLzg4RTE1MTgvODhFMTUxMi84OEUxNTE0IEludGVncmF0ZWQgMTAvMTAwLzEwMDAgTWJwcyBF
bmVyZ3kgRWZmaWNpZW50IEV0aGVybmV0IFRyYW5zY2VpdmVyIFJldi4gRyBEZWNlbWJlciAxNywg
MjAyMSINCg0KUmVhbGx5IGFwcHJlY2lhdGUgaWYgeW91IGNvdWxkIGFkdmljZSBvbiBQSFkgbG9v
cGJhY2sgZW5hYmxpbmcgZm9yIE1hcnZlbGwgODhFMTUxMCBiZWNhdXNlIHRoZSBleGlzdGluZyBn
ZW5waHlfbG9vcGJhY2soKSBmdW5jdGlvbiBkb2Vzbid0IHdvcmsgZm9yIHRoZSBQSFkuDQoNClRo
YW5rIHlvdS4NCg0KLUF0aGFyaS0NCg0KPiANCj4gDQo+ID4gRml4ZXM6IDAxNDA2OGRjYjViMSAo
Im5ldDogcGh5OiBnZW5waHlfbG9vcGJhY2s6IGFkZCBsaW5rIHNwZWVkDQo+ID4gY29uZmlndXJh
dGlvbiIpDQo+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDUuMTUueA0KPiA+IFNp
Z25lZC1vZmYtYnk6IE1vaGFtbWFkIEF0aGFyaSBCaW4gSXNtYWlsDQo+ID4gPG1vaGFtbWFkLmF0
aGFyaS5pc21haWxAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9waHkvbWFy
dmVsbC5jIHwgOCArKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L21h
cnZlbGwuYyBiL2RyaXZlcnMvbmV0L3BoeS9tYXJ2ZWxsLmMNCj4gPiBpbmRleCA0ZmNmY2E0ZTE3
MDIuLjJhNzNhOTU5YjQ4YiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvbWFydmVs
bC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21hcnZlbGwuYw0KPiA+IEBAIC0xOTMyLDYg
KzE5MzIsMTIgQEAgc3RhdGljIHZvaWQgbWFydmVsbF9nZXRfc3RhdHMoc3RydWN0IHBoeV9kZXZp
Y2UNCj4gKnBoeWRldiwNCj4gPiAgCQlkYXRhW2ldID0gbWFydmVsbF9nZXRfc3RhdChwaHlkZXYs
IGkpOyAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgbWFydmVsbF9sb29wYmFjayhzdHJ1Y3QgcGh5
X2RldmljZSAqcGh5ZGV2LCBib29sIGVuYWJsZSkgew0KPiA+ICsJcmV0dXJuIHBoeV9tb2RpZnko
cGh5ZGV2LCBNSUlfQk1DUiwgQk1DUl9MT09QQkFDSywNCj4gPiArCQkJICBlbmFibGUgPyBCTUNS
X0xPT1BCQUNLIDogMCk7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgbWFydmVsbF92
Y3Q1X3dhaXRfY29tcGxldGUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikgIHsNCj4gPiAgCWlu
dCBpOw0KPiA+IEBAIC0zMDc4LDcgKzMwODQsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIg
bWFydmVsbF9kcml2ZXJzW10gPSB7DQo+ID4gIAkJLmdldF9zc2V0X2NvdW50ID0gbWFydmVsbF9n
ZXRfc3NldF9jb3VudCwNCj4gPiAgCQkuZ2V0X3N0cmluZ3MgPSBtYXJ2ZWxsX2dldF9zdHJpbmdz
LA0KPiA+ICAJCS5nZXRfc3RhdHMgPSBtYXJ2ZWxsX2dldF9zdGF0cywNCj4gPiAtCQkuc2V0X2xv
b3BiYWNrID0gZ2VucGh5X2xvb3BiYWNrLA0KPiA+ICsJCS5zZXRfbG9vcGJhY2sgPSBtYXJ2ZWxs
X2xvb3BiYWNrLA0KPiA+ICAJCS5nZXRfdHVuYWJsZSA9IG04OGUxMDExX2dldF90dW5hYmxlLA0K
PiA+ICAJCS5zZXRfdHVuYWJsZSA9IG04OGUxMDExX3NldF90dW5hYmxlLA0KPiA+ICAJCS5jYWJs
ZV90ZXN0X3N0YXJ0ID0gbWFydmVsbF92Y3Q3X2NhYmxlX3Rlc3Rfc3RhcnQsDQoNCg==
