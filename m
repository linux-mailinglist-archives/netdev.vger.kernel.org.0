Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52735D348
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbhDLWl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:41:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:10244 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238901AbhDLWl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 18:41:27 -0400
IronPort-SDR: 4YCMjZoAGA1AnrWw0Q5hKQjGcNhZYD/wH8Km5s/RNm4DwPtdsBgMjdcfhHxPTcHluULmorRTbm
 fvbIjgf/6FSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="194323696"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="194323696"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 15:40:49 -0700
IronPort-SDR: rpVvm8pl1n687e3n2Om+ARbJ7ZiwBHP9vs75dPIwmsbArxrIBP7PYPR3Gh5oDzNsLWg1KkQNiY
 jf3mMI2SyM5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="450158851"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2021 15:40:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 15:40:48 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 15:40:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 12 Apr 2021 15:40:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 12 Apr 2021 15:40:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcUwg9MMO4RtUN2C2kL4jJWPYTAC0tlk8H7TBTm1g+2aEnEp7Uq6ApOjGeE0IIgGuzUzEcuL1a0ZgbGjUNzWKqjmvTrEKDKvPXdbHuYznEa+RM9BR+2ZHbmm1N9BOKpVVvyBchpZktrk4CYkeT/dKdvBIII7JCdpLEtU4Uc8jE7iUyVH0mr8aExW0dTqRkOmWKHXI6VLVrhti+1dwaakLyTePHVWBTE1iFo/SbrCYZk0KNHvio8GoDZWrqbBWlwTKw1LTQyPT6VWIcZCg2AalMwH+X6tgPK3FKf51AgHh+VAdSKfhyrU1teqoUdnWvBjWjgTe9aGuroppnJOm0C1mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njjWRFfFP4zv4CJXL4dsBTfGjIKeYkvcM2N1XYz4WRM=;
 b=JrEFE0E2E8wrhGEvx/28uczaqAKykNBPYZfz4QgNVjwXov6q+RDfIrw75LVDPwG9KGmp1SCbmuk+E9J4nTlN9bQOzwHQWcqJA9QPYYftvGRUB5hrcEzzRsXPZTWs5SwOKyZEwmdQ23OxuRm9fQi04HbcenqW39oIX5nAOYe6H7trXXCEhIr3ydPhahJrT+SUxqBxVTAZUK8P9cg0bzSjE5kAtyhCx5meg6qXZZk4NrjIomCwYBbLuMnQUHRCztkKN2wsbGVkb/OI6MvED+U6PcN7WmlGnpg6LBXxWP81m8sk7QV5MhGHpVq5A+wWnh3ZeerdNQAjFZ+hMy5mrSgIqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njjWRFfFP4zv4CJXL4dsBTfGjIKeYkvcM2N1XYz4WRM=;
 b=p9/w9mCDDVJJxKOyDKsFu8V/mtpsIWShmbRnWMUmoqzO8LQfGXAD5f8xcIGC2x7sppljq31wZ7+ud/EgGAd3EkpHCcVQeRoUkecAuIQcGwossOywDR/ec18FZRHh0AxZADs5ITZ9sNq4Mq64nxH/IJprnuKSlOPBrnCeIQU9pvI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3517.namprd11.prod.outlook.com (2603:10b6:805:dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:40:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:40:44 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: Re: [PATCH net] ice: Re-organizes reqstd/avail {R,T}XQ check/code for
 efficiency+readability
Thread-Topic: [PATCH net] ice: Re-organizes reqstd/avail {R,T}XQ check/code
 for efficiency+readability
Thread-Index: AQHXLnSeiIMVJSuDbkSvQ6mZ3KayqaqxfNUA
Date:   Mon, 12 Apr 2021 22:40:44 +0000
Message-ID: <03655fb6faa595a20a1143fb3b01561042cd317f.camel@intel.com>
References: <20210411014530.25060-1-salil.mehta@huawei.com>
In-Reply-To: <20210411014530.25060-1-salil.mehta@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99e9326b-c622-43f3-c1de-08d8fe040293
x-ms-traffictypediagnostic: SN6PR11MB3517:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3517001805FBF155E17ED7F5C6709@SN6PR11MB3517.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zmaK1nsu1nPoEWu456pl49C/FGLyg372hhRmJ2BFH6ATNeT40YnGQx+RX9t7Y+tLEbw+hIZpoL8zM8dcuOuD9+T5AlTjTopJlUxIR/EMBVVwO3x4nPlADPE2RrKiAOJsgeSR3mjKouAbLYtf1zr4ATSQiZb/hK/gw98Vvy6E9HQe3UgsCrl+PVECbdDs5WZXqCaYI8GNTD3k+iXjJNaFmOiLBjQzb+ApacIoZWNj6mQ2Y4ArqSxaBK9XrZosQplT1FQmQuV1LUMGGUGGS1DSj+PtRQ82Sn7lSqNp57V7Vks87L7e15kRP1NhAp3lnFi1WfOuaH5bCkqyrB14UUJtVZlyru1Bdg0oTZFDRys71yqXX7G+cwa03JJ65DPmapoow5U0aaEcnXLez76dQNYEa+V9+a7aRx7u7QgFvHRnrv8NtzKm/qx06X//hcr6md8PMVkQpBIUmbdtiSbuCuDKaMxJnf15ndiYd65Sh4/T8jETyHwx8xJeaE1UQr2t/u2nrjsrY0h0sGworMbwb8JlrgSfzzjClDRCJypiUWxx4Dj4UF+w8lwcr92U4zQjR6iI1zwsydOPQqU41j4RSfW+T4ZSqZBRO7Y6CRdddmYZzNlfzMM3+kaMGdTMqqbSBW17aeHZCybjdxvDldb/QQYR/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(6486002)(64756008)(66946007)(8676002)(66556008)(66446008)(66476007)(2906002)(6512007)(76116006)(478600001)(91956017)(2616005)(4326008)(186003)(36756003)(6506007)(86362001)(5660300002)(26005)(38100700002)(83380400001)(110136005)(316002)(71200400001)(8936002)(54906003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MjFqZjVsK25wQmppNTEzNlA0bzlPWXVzRnEwOXI1Y1A5T0gvYkF2ZXlNN21y?=
 =?utf-8?B?V2lrckg2MFV1Um1PWlNMSG5NRGtYd2hKQ3JZMkJSRkcrTmlDNlhla3BDblM3?=
 =?utf-8?B?UGoyWHdacU05aFNaOGNHUW9zRVNvbnFsNStYT01qUklQTlkvRWVTd3Fqa0xE?=
 =?utf-8?B?bnZ0aTdpNVFDOE9STG52VjNuUVBQU1lDVndiOEUyQWtEOHc1UE5oWCtyRkh5?=
 =?utf-8?B?clRuNUdqaE9lS1R1bXJxNkFoN294MHFSZXBmYXBmNWpXdkFYKzViWjJFck5P?=
 =?utf-8?B?elRjVTdVaEpEZGt0a0JPUzBIcDE2NlhmQW13VElLbUljSWMzbmRRV1lmZlAy?=
 =?utf-8?B?SnFzZ1pMSk9wZVFFbUttcm1yalg1RWtPdlM3d1dXUzNCamRrWDdLZytmQTRI?=
 =?utf-8?B?MlZpNWZIdUFWcW83Z1dsdHFNTGYyN1NzN1FhQ0NEVUVPcktBK2lvM0dYSjlR?=
 =?utf-8?B?SW9JS3ZXY2s2Zi9RK0xwTlhReFMxRDJPaFI2c1ZrditSaVI5aDdDTC9ia0wy?=
 =?utf-8?B?TmlIeGNTVGxrejE5WmJHRDVvWnFrUkRybnZHUjMxSnZUUFFBelovaXBPRlpy?=
 =?utf-8?B?RFlydGZLVnlPdnBtR3FwTTMrV0crSkQzZnVVV0VIS282WVc3Q1RaWG1NSGZW?=
 =?utf-8?B?L3NhS3kwVE5HVngvTVBxZFV6eWVoc0hQWUc3YWQ4Y2RDSGluZGd4dDNxbzNV?=
 =?utf-8?B?aTJxU1crUnJOQ09NWExOVmZVRHFBV3RseGhsMnd3RnpSanI2Uk5kazhTOGpq?=
 =?utf-8?B?d2ZFb1pyY3BSOWxxN0tBSm1JN0hQVk5RZXpFWXBNcmdFWm1taVNxdXZuKytn?=
 =?utf-8?B?Z0VHSEUwOFVMdk1YZU0rOHBtVXdsbjhlL2I3Tml1WUp0Tlh5TFJiOUlFNHV1?=
 =?utf-8?B?Ri9lZ2JGRFZGejdkM2Qwcllybk9TT21DQkYrYVZVMCt5NFlqN0xYVWZOb1hE?=
 =?utf-8?B?RWtSYmsrOWt6WjRXeWlhdzZiVG9yK00zaTI0OHczSHF6bVhWc3gxUTFCRjRh?=
 =?utf-8?B?dUlwS21UTGdhVEhwZXk2eklOOVg0RmFnbFVmb1p3RlVyREZwNnE5d0tpM3JT?=
 =?utf-8?B?Rk0wUUFZOTlXUGhRbjdMcFhMTGNzSlVXN2VYYWhIYXFsQnk0ZkZobjF3RUVj?=
 =?utf-8?B?UzhObEhmblZyTjUwQ1p6b1F3SmFSeG1GLytJaE9kL2ZhTDJ4STNQNHlZRHNx?=
 =?utf-8?B?anFvUVYrdkphbHZqa0RVdWlsYVNudlZ2YjVKQlAvaGNaM3NKSlNMRnJTTzBP?=
 =?utf-8?B?R2dsRkVJZ3ErZER0eW1TNDRBaDY0d0RWVnhsR2o4YjdTdnN6RGhvTWJyZTd2?=
 =?utf-8?B?MlJPajhHTjJ4dVZxU3pIajIxWDhpbnFVQ0draG1UcDJXUnpzZ3FMVExwNVdR?=
 =?utf-8?B?ZW1ab0FiRHVJdWQrMFZha2twWjFERW9LWS81WFlqOEJINE9LUWlvU25TT0sy?=
 =?utf-8?B?ektVY1Vyd09RVEdWZXBXVjhTZlJXTHpnYWp4R1JHaWlCdGROZmFhMUZrdnpw?=
 =?utf-8?B?b2VhZi94bXA3b2tLRG9TaGNuNnFVWCthNm04OW93UkpsWGJTY2lWQnYybEk3?=
 =?utf-8?B?TlFkS1B5N0F0eTg0MEZCL2N6TEtTU21PMjR3N0haOTE1dlpGTmZJMXdvVVBJ?=
 =?utf-8?B?ZW1zU1dpUFNRbnlzVEZHVjhhQjBJblpFeDh0NDVyZmE1SHBJTG9TTnRvaXZ6?=
 =?utf-8?B?MHF3cmZrNUNiZGZzUFNtYmtEakFPRXdaVUhZU0JWYTBDaEZPSTh0dW1hcFc3?=
 =?utf-8?Q?IedX5ZZv1OXVSLKje1qeoc7ZAQ7LAhG938zIK/Y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <046B77DF1233EB469BDD2FA4007366B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e9326b-c622-43f3-c1de-08d8fe040293
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 22:40:44.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p79vJtTqApegx3ImDQ83Ykq11Ib1tuNCB0AkeKOUPahL9Rku/UIh229RhOGl1eR95ZHqRhQUTuVd7mq8qVN+dn32knce7fxAJKKSztkPgRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3517
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTA0LTExIGF0IDAyOjQ1ICswMTAwLCBTYWxpbCBNZWh0YSB3cm90ZToNCj4g
SWYgdXNlciBoYXMgZXhwbGljaXRseSByZXF1ZXN0ZWQgdGhlIG51bWJlciBvZiB7UixUfVhRcywg
dGhlbiBpdCBpcw0KPiB1bm5lY2Vzc2FyeQ0KPiB0byBnZXQgdGhlIGNvdW50IG9mIGFscmVhZHkg
YXZhaWxhYmxlIHtSLFR9WFFzIGZyb20gdGhlIFBGDQo+IGF2YWlsX3tyLHR9eHFzDQo+IGJpdG1h
cC4gVGhpcyB2YWx1ZSB3aWxsIGdldCBvdmVycmlkZW4gYnkgdXNlciBzcGVjaWZpZWQgdmFsdWUg
aW4gYW55IA0KDQpzL292ZXJyaWRlbi9vdmVycmlkZGVuDQoNCj4gY2FzZS4NCj4gDQo+IFRoaXMg
cGF0Y2ggZG9lcyBtaW5vciByZS1vcmdhbml6YXRpb24gb2YgdGhlIGNvZGUgZm9yIGltcHJvdmlu
ZyB0aGUNCj4gZmxvdyBhbmQNCj4gcmVhZGFiaWx0aXkuIFRoaXMgc2NvcGUgb2YgaW1wcm92ZW1l
bnQgd2FzIGZvdW5kIGR1cmluZyB0aGUgcmV2aWV3IG9mDQo+IHRoZSBJQ0UNCj4gZHJpdmVyIGNv
ZGUuDQoNClRoZSBjaGFuZ2VzIHRoZW1zZWx2ZXMgbG9vayBvaywgYnV0IHRoZXJlIGFyZSBzb21l
IGNoZWNrcGF0Y2ggaXNzdWVzLg0KQWxzbywgY291bGQgeW91IGluY2x1ZGUgaW50ZWwtd2lyZWQt
bGFuQGxpc3RzLm9zdW9zbC5vcmcNCg0KPiBGWUksIEkgY291bGQgbm90IHRlc3QgdGhpcyBjaGFu
Z2UgZHVlIHRvIHVuYXZhaWxhYmlsaXR5IG9mIHRoZQ0KPiBoYXJkd2FyZS4gSXQNCj4gd291bGQg
aGVscGZ1bCBpZiBzb21lYm9keSBjYW4gdGVzdCB0aGlzIGFuZCBwcm92aWRlIFRlc3RlZC1ieSBU
YWcuDQo+IE1hbnkgdGhhbmtzIQ0KPiANCj4gRml4ZXM6IDExYjc1NTFlMDk2ZCAoImljZTogSW1w
bGVtZW50IGV0aHRvb2wgb3BzIGZvciBjaGFubmVscyIpDQoNClRoaXMgY29tbWl0IGlkIGRvZXNu
J3QgZXhpc3QuDQoNCj4gU2lnbmVkLW9mZi1ieTogU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1
YXdlaS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9s
aWIuYyB8IDE0ICsrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfbGliLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
Y2UvaWNlX2xpYi5jDQo+IGluZGV4IGQxM2M3ZmM4ZmIwYS4uMTYxZThkZmU1NDhjIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xpYi5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGliLmMNCj4gQEAgLTE2MSwxMiAr
MTYxLDEzIEBAIHN0YXRpYyB2b2lkIGljZV92c2lfc2V0X251bV9xcyhzdHJ1Y3QgaWNlX3ZzaQ0K
PiAqdnNpLCB1MTYgdmZfaWQpDQo+ICANCj4gIAlzd2l0Y2ggKHZzaS0+dHlwZSkgew0KPiAgCWNh
c2UgSUNFX1ZTSV9QRjoNCj4gLQkJdnNpLT5hbGxvY190eHEgPSBtaW4zKHBmLT5udW1fbGFuX21z
aXgsDQo+IC0JCQkJICAgICAgaWNlX2dldF9hdmFpbF90eHFfY291bnQocGYpLA0KPiAtCQkJCSAg
ICAgICh1MTYpbnVtX29ubGluZV9jcHVzKCkpOw0KPiAgCQlpZiAodnNpLT5yZXFfdHhxKSB7DQo+
ICAJCQl2c2ktPmFsbG9jX3R4cSA9IHZzaS0+cmVxX3R4cTsNCj4gIAkJCXZzaS0+bnVtX3R4cSA9
IHZzaS0+cmVxX3R4cTsNCj4gKwkJfSBlbHNlIHsNCj4gKwkJCXZzaS0+YWxsb2NfdHhxID0gbWlu
MyhwZi0+bnVtX2xhbl9tc2l4LA0KPiArCQkJCQkgaWNlX2dldF9hdmFpbF90eHFfY291bnQocGYp
LA0KPiArCQkJCQkgKHUxNiludW1fb25saW5lX2NwdXMoKSk7DQoNCkFsaWdubWVudCBpcyBpbmNv
cnJlY3QuDQoNCj4gIAkJfQ0KPiAgDQo+ICAJCXBmLT5udW1fbGFuX3R4ID0gdnNpLT5hbGxvY190
eHE7DQo+IEBAIC0xNzUsMTIgKzE3NiwxMyBAQCBzdGF0aWMgdm9pZCBpY2VfdnNpX3NldF9udW1f
cXMoc3RydWN0IGljZV92c2kNCj4gKnZzaSwgdTE2IHZmX2lkKQ0KPiAgCQlpZiAoIXRlc3RfYml0
KElDRV9GTEFHX1JTU19FTkEsIHBmLT5mbGFncykpIHsNCj4gIAkJCXZzaS0+YWxsb2NfcnhxID0g
MTsNCj4gIAkJfSBlbHNlIHsNCj4gLQkJCXZzaS0+YWxsb2NfcnhxID0gbWluMyhwZi0+bnVtX2xh
bl9tc2l4LA0KPiAtCQkJCQkgICAgICBpY2VfZ2V0X2F2YWlsX3J4cV9jb3VudChwDQo+IGYpLA0K
PiAtCQkJCQkgICAgICAodTE2KW51bV9vbmxpbmVfY3B1cygpKTsNCj4gIAkJCWlmICh2c2ktPnJl
cV9yeHEpIHsNCj4gIAkJCQl2c2ktPmFsbG9jX3J4cSA9IHZzaS0+cmVxX3J4cTsNCj4gIAkJCQl2
c2ktPm51bV9yeHEgPSB2c2ktPnJlcV9yeHE7DQo+ICsJCQl9IGVsc2Ugew0KPiArCQkJCXZzaS0+
YWxsb2NfcnhxID0gbWluMyhwZi0+bnVtX2xhbl9tc2l4LA0KPiArCQkJCQkJIGljZV9nZXRfYXZh
aWxfcnhxX2NvdW4NCj4gdChwZiksDQo+ICsJCQkJCQkgKHUxNiludW1fb25saW5lX2NwdXMoKQ0K
DQpTYW1lLCBhbGlnbm1lbnQgaXMgaW5jb3JyZWN0Lg0KDQo+ICk7DQo+ICAJCQl9DQo+ICAJCX0N
Cj4gIA0K
