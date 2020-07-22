Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75C722A147
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGVVWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:22:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:64474 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVVWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 17:22:51 -0400
IronPort-SDR: XwiuDUyu1TSlxcekRTYX06MgIPWsZ7L1YNuZ2n/hL5YUEHQbuM8iOwXlmGdToq2I9pGENei+P7
 zKCkK812GTAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="130499904"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="130499904"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:22:49 -0700
IronPort-SDR: DJOitOfIZ0lUgxsAGKvF5dgHM1+d0KNV++86fmYQ5T90j+u38bC0FGcChDfi6bpPQgKIFxbk2U
 va67ZgAO95xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="302088593"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 22 Jul 2020 14:22:48 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 14:22:48 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 14:22:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 22 Jul 2020 14:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ0StYE4UK6qpyxO4nWQcY5SkBcadubmj+0QTeKNnvKm6QQ+HZuerHgfYRPcEI2bLrX1SlfuI+W3SrZdspyMZL2eGPCePHWi2N308l/psuwBlTCnxIcsxNp8PB6SquxyhOtbe/XqaPbKHpGCpoEguBjUCYZFsVKTD6LXJsytEzX4eIwff2yjULNM9ZjOzuQwiyHYKLN7ZQ1quBFPEDGjV4kJz+kWV0XYcR8OP4KFjFJUKAu4uxe7pJMkMnxesqoBGH3YYYvBLpDgLk0GloM04CxTdW5Yeu+IN9YL7N6vxpVjQcaCjSAc0CU4y39UeLHDcW10ljFo/LBQKuxTyGTekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFd8km29dFpuffnl4orEfPOe1vmVolB591FbVnKw2fs=;
 b=hqUKiDKZbw9YwVGxreKRqttRCGpvG/cG2WjvwF1gWF28+H4DMh1zPTIXNfXxkyC+mAE9J+ahgSXF6EUVGUjcu6XhoGI+8SBGBOKH02BJsm4KvYYeeA/2c32Lw9CrCYwi7HvNflCIEP+4l36Qx0HZSca/gFMP8buiMRSFlRn5usK8JkFka1gCfnijzdp1nvFcPm3I6uDK8R2Cq+nKoalO2VwgtiyljWkdKcX9I8euVuoTp8r10+2tvJB8dxE54epgjehb75mGZWMyJzrB8A+Eh8qiNxgeYj9gf+ueFn0wk9wnPyZ8tdbKWkw52efc/qmxUNGMct/g5gPG2ckwh384dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFd8km29dFpuffnl4orEfPOe1vmVolB591FbVnKw2fs=;
 b=lUK3l5gcLibp+bZXhoE89Z/poh6md9GecAGJYrU3Bb0HZRhvW0mcnCkaNqMQcM+oa9rsjCpE7wZ+786Ln3I2lkh7wZ8tCBSEQApAW8jvToAELe+T72BBNfd212lOm5kxHyTMuRvgDpalm2zitVyNkfrDHsGlosFzRRy31KVzDI0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3070.namprd11.prod.outlook.com (2603:10b6:805:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Wed, 22 Jul
 2020 21:22:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bda3:d65a:f390:f875]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bda3:d65a:f390:f875%7]) with mapi id 15.20.3216.020; Wed, 22 Jul 2020
 21:22:45 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Topic: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Index: AQHWX8dIqfLMKTfuhkiHDJfcuSiXjqkUHOeA
Date:   Wed, 22 Jul 2020 21:22:45 +0000
Message-ID: <1af4aea7869bdb9f3991536b6449521b214ed103.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
In-Reply-To: <20200722012716.2814777-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfc5e5bc-da65-445c-2ab5-08d82e85609c
x-ms-traffictypediagnostic: SN6PR11MB3070:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB307077B119F554E839D81752C6790@SN6PR11MB3070.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykPK3xTsljes1hWUG8+1ezRwZ2OCO/EScfZC7DZaChnjCgb+9t4UiCBz9mH86kV3WAyNCMKGcTqNfdEtzB6o7ZLLc3KOAHaPuEJ7CliMJTCbSzuODWMIn4uHcBd5wUtPr+405oUN9iXywK/6Wnf6WTmBh2Kc/fn/p7cQhgkdjH8nah/cgi3+e/u/eoEO//sS78tWS4bYkSk8N2xd3QGJ7g139HJsssMkE3HCuJ76wpbH4Zr9FEgRYsOtocqptrzgxnd1+GFioePr4BEifvsHMnVTKvDwK/zBHWUULcKZQmrdbPTfSlg7aiWJnpZWNJjt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(6506007)(6486002)(83380400001)(2616005)(54906003)(5660300002)(8936002)(110136005)(71200400001)(8676002)(4326008)(6512007)(316002)(4744005)(36756003)(86362001)(66946007)(64756008)(186003)(66556008)(91956017)(76116006)(66476007)(2906002)(26005)(478600001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dO0VKRljsZzEZRLUiZr6Sn0ZN2028nS3O+NtJ62gF47a8gYrjc+eBXss6+fR+U7Dg8/0so7RymMkS57aswup/ieZO/1Od5yceuhYBqxyX2+Ep49HMwdi9TrT+oUEnZLifKqhuTkazgjOfvCa2sKQ6XbbXZWIBAp9yuHHh/PEtLfdYEs0ZPMgUCk5k6DIebMdVbeZxs0TUQVvGB7wp2kd6ycu/OAZqE8NygTV/p2VCCDDDqs7CUjlYbefSHAPkTSTcfgeezMrbIFHtAQgdHM00nkDFfBaMzsC7soakAXMeAxkt3WqW8mi4XNQXwfqQH/4yi7h4xS5NvyydaB7g1L7WPoJWARJx+8BjWqaNP4/AuxQwXs9L2G0GJgh5MaYJJfn6+JWVrkHiTvXy+te8b7ONCVWZ/aMyh2yX3b+riJxJN5BJF1NKM0mDTJAfu5SliMZ7vDa8uwuycrQqHHmL/Vq1P2Sd3rLGshM1BCTYNH0pyV5GcH/u2UZYWvxq7RQMZHx
Content-Type: text/plain; charset="utf-8"
Content-ID: <85BBE4CAC62F3E40B4806786C96D63C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc5e5bc-da65-445c-2ab5-08d82e85609c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 21:22:45.7051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gCmFHed8e20HIWRkL/pxDGbJ1flLCEABBGUVTY/yfuY6ToNfKlrtdHXQYeRS+LGEIuOhZWCtGBCoiu/Rz0WFz/JnVY9PERDNLvmQhjJcmFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3070
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTIxIGF0IDE4OjI3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGhpcyBzZXQgY29udmVydHMgSW50ZWwgZHJpdmVycyB3aGljaCBoYXZlIHRoZSBhYmlsaXR5
IHRvIHNwYXduDQo+IG11bHRpcGxlIG5ldGRldnMsIGJ1dCBoYXZlIG9ubHkgb25lIFVEUCB0dW5u
ZWwgcG9ydCB0YWJsZS4NCj4gDQo+IEFwcHJvcHJpYXRlIHN1cHBvcnQgaXMgYWRkZWQgdG8gdGhl
IGNvcmUgaW5mcmEgaW4gcGF0Y2ggMSwNCj4gZm9sbG93ZWQgYnkgbmV0ZGV2c2ltIHN1cHBvcnQg
YW5kIGEgc2VsZnRlc3QuDQo+IA0KPiBUaGUgdGFibGUgc2hhcmluZyB3b3JrcyBieSBjb3JlIGF0
dGFjaGluZyB0aGUgc2FtZSB0YWJsZQ0KPiBzdHJ1Y3R1cmUgdG8gYWxsIGRldmljZXMgc2hhcmlu
ZyB0aGUgdGFibGUuIFRoaXMgbWVhbnMgdGhlDQo+IHJlZmVyZW5jZSBjb3VudCBoYXMgdG8gYWNj
b21tb2RhdGUgcG90ZW50aWFsbHkgbGFyZ2UgdmFsdWVzLg0KPiANCj4gT25jZSBjb3JlIGlzIHJl
YWR5IGk0MGUgYW5kIGljZSBhcmUgY29udmVydGVkLiBUaGVzZSBhcmUNCj4gY29tcGxleCBkcml2
ZXJzLCBhbmQgSSBkb24ndCBoYXZlIEhXIHRvIHRlc3Qgc28gcGxlYXNlDQo+IHJldmlldy4uDQoN
CkknbSByZXF1ZXN0aW5nIG91ciBkZXZlbG9wZXJzIHRvIHRha2UgYSBsb29rIG92ZXIgYW5kIHZh
bGlkYXRpb24gdG8NCnRlc3QgdGhlIGljZSBhbmQgaTQwZSBwYXRjaGVzLiBJIHdpbGwgcmVwb3J0
IGJhY2sgd2hlbiBJIGdldCByZXN1bHRzLg0KDQpUaGFua3MsDQpUb255DQo=
