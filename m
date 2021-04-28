Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9B36D858
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbhD1NeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:34:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:30538 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhD1NeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 09:34:08 -0400
IronPort-SDR: PFRUahUKPKy+fkTe5SnUR8tDQblPBXE11QvL/XHxBIFhIEX7stVwzkVC6froEoZTpry1iN44gl
 vo4HiTjn6JGg==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="258039070"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="258039070"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 06:33:21 -0700
IronPort-SDR: 47ux1srA04Z/IuzbKCZ4uxROWFr7L2eOzqo7h1WHAa2s/2Sxmy3o4aBJGw2wHes3D6ntxGQoOl
 UKGrDHtyC0nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="430296365"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2021 06:33:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 28 Apr 2021 06:33:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 28 Apr 2021 06:33:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 28 Apr 2021 06:33:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 28 Apr 2021 06:32:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2X0GLwejdWYiOiNMLn3MebSj3TElKDgSSvzFz09KHOZSLWALIM93k/F0bANWrJhTLClDpn87UKYRJfpE/CMNYDEKnQSqNW7SUB5G38SYtg4UDkK8r5IRTd+8nfm8xH9uKNWy8j7/CMaXRmcF6o6x+LR744BgscG0hbyhDc3Wcg129eUJNxgz2huvreWW1cnX3GIZ4xJFE0TNqtWd5kA41AK6hZQFwonL7Q5332h3PUEs60PcO/g8Jq+dz9Rr8KZpcGwrsF6JdF3hsThGntaSaY+g6HY6IvjmqkJolwNsqBBNnOJ2eD4URZX9fdeCuqr8U6sYADixMUf0Znb/rcRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLpHbdjNQ2zFO+ERq74qi7GSa1cx8nqeuqnEIAN9lsQ=;
 b=eqMdHF6dSyR5rcFD8/vzomcPYiVkssjN8GQmU2k6KtwLkWFchBlW5PEYlnfUvcVveI5g/o8DmP1MMQHJ84qhEUxIrVvhkkPlc8PSi8R7SFnSp8t9N5/5knYKv/5LJ5K3RLQE+nvz/dH6QTn70GqiPZqMtMrChDpvvwJrsja55n93m7Z1UVGOm6skFHxEOa/og7v4oMMH7bZv1RxGCXL/0gj9OalxOEz9DAmIRvfsYWmDl5fKeRaoRWndJ/uGNbGfOgUVUEfPhyFWHQ2E6C6exc+Wl3JYi1C7CzXwfnPShDBiDFKO/IpNJU3Mw3Dv3vYlhJnupiSdTHHN2kQCN6jw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLpHbdjNQ2zFO+ERq74qi7GSa1cx8nqeuqnEIAN9lsQ=;
 b=yD/CiWFVzNPGfO3VZZ3NGs4EPkiD9zOkT0H7qHZwK7cs7Y4XrG6Z4l5pFYtAoM1hvhy0yG9o6YB4fXHrelaiMn1F0xDoxYL38FRpJvXbDPmlEENeVcYRzpPzo0ayL5+8LX1vcYWODSTfVlYSZRGrTPQUu6ABtOyoHXcCLffodGs=
Received: from MWHPR1101MB2094.namprd11.prod.outlook.com
 (2603:10b6:301:4e::10) by MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 13:32:12 +0000
Received: from MWHPR1101MB2094.namprd11.prod.outlook.com
 ([fe80::6495:ae54:f0c4:f501]) by MWHPR1101MB2094.namprd11.prod.outlook.com
 ([fe80::6495:ae54:f0c4:f501%9]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 13:32:12 +0000
From:   "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        Arkadiusz Kudan <arkadiusz.kudan@codilime.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jayagopi, Geetha" <geetha.jayagopi@intel.com>
Subject: RE: [PATCH] virtio-net: enable SRIOV
Thread-Topic: [PATCH] virtio-net: enable SRIOV
Thread-Index: AQHXOoXMGQQtFak7WE69WGZddwEhuKrHqU2AgAJAmdA=
Date:   Wed, 28 Apr 2021 13:32:12 +0000
Message-ID: <MWHPR1101MB209476B1939ADB73C57E71AC9E409@MWHPR1101MB2094.namprd11.prod.outlook.com>
References: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
 <625a6618-bb59-8ccc-bf1c-e29ac556b590@redhat.com>
In-Reply-To: <625a6618-bb59-8ccc-bf1c-e29ac556b590@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.232.46.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 072f5b04-cfa0-45ec-321f-08d90a4a07f9
x-ms-traffictypediagnostic: MWHPR11MB1293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB12935BC810DFB4B817B893E49E409@MWHPR11MB1293.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xVWRzy+rAM7qZzUolRvZJnCx5M6/LAJ5auowqcrEo1dFDQuRs3CZ9S+YTYx0t1AtKBiihB/6XVvxuEXl+GHfbpWB6k4pwOlcwCjp67SJ0fhmRvPHwF9v7AGS2HcBXho57esuGTQ3tO7kUVWYLsomWUrmUoxyyFlqfcj2WFohyzJjzmgJ5tRg8sXw9BGjfRCPtVdJpb1GAOCfK0b/ZkJBr0NVZsnI4hoFS5WWHGpuRfjmc6G78WqCLR6/rLAgSetOq/1Kx0yAganS0wbpPSrZlcf0zXhA4I6NGq9MuSUZPANOMygCQEvmdBhWdvgr4JJIZ0ruu0/dtnLYifw10bgIuKzzkKoyLIy4jRxEP/uoz+NqKLHnp5G9ihxR5qfbPcyc1KKrkY6rA9IksvJiHfMavuggJSYHRUVqt+vy97RdQIk0xLh84bMA19DDoBc7dBu8fs5+mFvSozrrZKvrtWPm06H0GL+mHYz/0C9N3PLKTSS12j4QgqGtyQCsb9DIdKTxpbPMzzGBfXrYRD0CJ7Hslyl/jcD3t07eJ2JhNl0+OwI1oFBqN80Cr8Hnc+WYD+We54YwGH454HqZjyQCP9wNs0E9wTTkn7Qv4+5LnE7oD9M6vBN/dfd7l0VqOnkWSK5wwXVA5/DW55+UqNkwtF4MwFgNINWILkELopPhvEGvGsrx3sWnckkLoiS/WXhmk5ui
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2094.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(83380400001)(6506007)(966005)(53546011)(66946007)(478600001)(8676002)(186003)(66446008)(107886003)(66556008)(4326008)(66476007)(55016002)(316002)(9686003)(7696005)(26005)(64756008)(110136005)(86362001)(71200400001)(2906002)(5660300002)(54906003)(38100700002)(122000001)(76116006)(8936002)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TU5UYjUycHVYWjJNVU5NbitCelVCbjVWSnJSRllMRjVkMzNRa1llankvUmpx?=
 =?utf-8?B?T043eVViRmRLUFUvTDI5ZzhpWkhZUWhKeHRPMnZmQXcxajEzVkVlSU1semZt?=
 =?utf-8?B?MVlCMnhleTFjaHg1bllOS3VjbWg5OUxHOUJ3MTdRTXVNbVI3VFdxSGNhdmxJ?=
 =?utf-8?B?K2h2VE4vUUpRU0FpUUtKRXBwejVvdlF5dm4rV3J3bzlWQWcxRjdPZzZEa1gy?=
 =?utf-8?B?OHl4OHFuVFpNc2thanF0Q29rN0l1cUUwOE4yQk93bEtUQUtuSE5SV3J6SGVz?=
 =?utf-8?B?c2J5RnRsYXZpQXRraisyWmRVSm5pVXdNN2VkbnVzSWUyV3JzL3NEY2RWSXd1?=
 =?utf-8?B?S1N5SjY2aU1FZ1hHTGs4K1gvTW9UWkVtWVpPV29veTBabVVOaDBDSzJqMkJQ?=
 =?utf-8?B?OW9VYzQrOGNRSGYvWHFvTHZ6VGh2c2xRNnNuSVE5MWNlMDgvV2swSktXUjVC?=
 =?utf-8?B?L1VybnJiVjZaSFAzTHRqVUVnQ0s1L011MmVJckN5Q0RidzJqekJhZXhaMlRy?=
 =?utf-8?B?SDFUWWZqeGp6OVMzNnEzRVMxTmVLeklYOVZIRFpOd05lZjBHM2NpMXhHeXNK?=
 =?utf-8?B?MGVOSjNvMGUxUkM5TXJ2b0srNTBsM2VtaE9CSDFUZ2NSVldTOFhCdXVMNmdQ?=
 =?utf-8?B?RGdoMWdySERJMUZzY3JHMWR4K1VsV1VtdEI0czQyRGdYOFBZZWVtUThNclhm?=
 =?utf-8?B?WFNUM1NPZDhybEpLOWlFMkJCMzlkSlRRdEdGODFzbnNUWFZUSVY5REQ1L01a?=
 =?utf-8?B?UnNXVVpldUJnWkFRZkYwc2U3cjRMN2NMaUNhNXV4aDhVYWxvRndQUU4zc1FJ?=
 =?utf-8?B?WFNBWDUvNC94SW41UWkwMDZMbmpFcTZ0MHYrZm5kbFE0bTdIOWJPcG5WRUdM?=
 =?utf-8?B?RWFvQm9JV0ZSOHU3eVdrOWFzQTdqSkIzM29sNldXb0dYV0JleUJ6alRLdUo3?=
 =?utf-8?B?RnY2VDZCMEZOTytPMlpsWUFGNE1venFSeTJKTzlzaHh2ZnVvUHYwOTI3SXoz?=
 =?utf-8?B?eDhQaVlMSDYxaG1UVmZWait5VW1xMVdQTmc3L1htZy9BZEZIZ1E5Rms3Z3Fv?=
 =?utf-8?B?RXlyT3Q4RnpUS25OcWo1d0xzNTEyM2VSMEJjT2tsUTdvUkFRaUIwaDA5SXJ2?=
 =?utf-8?B?bjBidHpnVVBhVE1uRGs4a2hxb1ZhUHZTRXQ1VDBjRmlQaDBOenBLQy9vUDZ6?=
 =?utf-8?B?TEg0dHpOQUx6dmtiQm9FblVTWlY1NWxYcFk0UTlpWHVtRjVHYlZDYUd0c2Js?=
 =?utf-8?B?VkQzcWxSZnRxWEppaXVrcW45S0NLK2VvakFkaGhZTi9CMXU5aVR2Y2JvTDFr?=
 =?utf-8?B?TVVaZUZtKzBXVW4xSG5IUHVrdU5RK0lIbEQzT1U2MXNvRVB5ZDNhVlVBVVIv?=
 =?utf-8?B?L3pUMjZrVnVFRVBlQ2l0TVBCclhLYWE5TjBQeDV2ZVB3dXVBQVBLMUp6a2pK?=
 =?utf-8?B?SnM3UnQ0UFIyRE9CUnRXSitHUFFHc3lodGtRcm5aUUo5alBVek8ybHp1Z1B4?=
 =?utf-8?B?YkU1Y3dFVFhaYWNGZnFUd3ZNakFzc0l4OTI0dUxYaFJtT2gvUU9oU2g0RCs3?=
 =?utf-8?B?QjhmNTN4TEpla2JDSE4xdGtOWTF5ci8vNTJXL090Mm1USC8zaXgzVjZCYzQr?=
 =?utf-8?B?MXBGWHBwcktSM3VDSzBiMTVoQktuK2tjQUcyTXhhckJ3WHE0NDMrWDNlUnZm?=
 =?utf-8?B?bXE3UGxYZ1dhQnFHS3pOYkxBRkoyay9JdkpsN3hON3pYejFPdCtGNkxYNldK?=
 =?utf-8?Q?uUNwAehTVY0YLY4k2E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2094.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072f5b04-cfa0-45ec-321f-08d90a4a07f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 13:32:12.5746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vypsTP+IOKXoN0egnyldrn91BFJUojlTAj+KApFVXhmYwNfGtCdSnc3F9hADPNPtlQEtd0B8RH7/1IFTnsLVgUG9WRa7ps2JThKMdblCVnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1293
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgSmFzb24sIA0KDQpZb3UgYXJlIHJpZ2h0IGhlcmUuIFdlIGRpZCBub3QgY2F0Y2ggeW91ciBj
aGFuZ2UgaW4gZHJpdmVyIGFuZCB0aGUgU1JJT1YgZmxhZyBpcyBzZXQgY29ycmVjdGx5IGFzIHlv
dSBzdGF0ZWQuDQoNCldlIHdhbnQgdG8gb3JjaGVzdHJhdGUgdGhlIEhXIGltcGxlbWVudGF0aW9u
IG9mIFZGcyBhbmQgUEZzIGZvciB2aXJ0aW8tbmV0IHVzaW5nIGxpYnZpcnQuIA0KDQpUaGUgaXNz
dWUgdGhhdCB3ZSB3YW50IHRvIHJlc29sdmUgaXMgdGhhdCB0aGVyZSBpcyBubyAubmRvX2dldF92
Zl9jb25maWcgQ2FsbGJhY2sgaW1wbGVtZW50ZWQgaW4gdmlydGlvLW5ldCBkcml2ZXIgYXMgb3Ro
ZXIgTklDJ3MgZHJpdmVycyBoYXZlLCBjYWxsZWQgYnkgbGlidmlydC4gDQpTZWUgaHR0cHM6Ly9n
aXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2Jsb2IvbWFzdGVyL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lnYi9pZ2JfbWFpbi5jI0wyOTk2LCBmb3IgZXhhbXBsZSANClRoaXMgY2FsbGJhY2sg
cmVhbGx5IHNob3VsZCBjcmVhdGUgYSBtaW5pbWFsIGNvbmZpZ3VyYXRpb24gaW5zaWRlIG9mIGRy
aXZlciwgYnV0IHdlIGNhbm5vdCBhdm9pZCBpdC4gDQoNCkFub3RoZXIgaXNzdWUgaXMgbGFjayBv
ZiBzeXNmcyBmcm8gdmlydHVhbCBmdW5jdGlvbnMgL3N5cy9jbGFzcy9uZXQvZW5zODAxZjAvZGV2
aWNlL3ZpcnRmblggKHdoZXJlIFggaXMgVkYgbnVtYmVyIGFuZCBlbnM4MDFmbyBpcyBpdHMgUEYg
bmV0ZGV2KSwgDQoNCkNvdWxkIHlvdSBhZHZpc2UgdXMsIGhvdyB3ZSBjYW4gc29sdmUgb3VyIGlz
c3VlIGFuZCBkcml2ZSB1cyB0byBwcm9wZXIgc29sdXRpb24/DQoNClJlZ2FyZHMsDQoNCk1pcmVr
IA0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+IA0KU2VudDogd3RvcmVrLCAyNyBrd2lldG5pYSAyMDIxIDA0OjQ0DQpUbzog
QXJrYWRpdXN6IEt1ZGFuIDxhcmthZGl1c3oua3VkYW5AY29kaWxpbWUuY29tPjsgdmlydHVhbGl6
YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcNCkNjOiBtc3RAcmVkaGF0LmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgV2FsdWtpZXdpY3osIE1pcm9zbGF3IDxNaXJvc2xhdy5XYWx1
a2lld2ljekBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIXSB2aXJ0aW8tbmV0OiBlbmFi
bGUgU1JJT1YNCg0KDQrlnKggMjAyMS80LzI2IOS4i+WNiDY6MjEsIEFya2FkaXVzeiBLdWRhbiDl
hpnpgZM6DQo+IFdpdGggaW5jcmVhc2luZyBpbnRlcmVzdCBmb3IgdmlydGlvLCBOSUMgaGF2ZSBh
cHBlYXJlZCB0aGF0IHByb3ZpZGUgDQo+IFNSSU9WIHdpdGggUEYgYXBwZWFyaW5nIGluIHRoZSBo
b3N0IGFzIGEgdmlydGlvIG5ldHdvcmsgZGV2aWNlIGFuZCANCj4gcHJvYmFibHkgbW9yZSBzaW1p
bGlhciBOSUNzIHdpbGwgZW1lcmdlLg0KPiBpZ2JfdWlvIG9mIERQREsgb3IgcGNpLXBmLXN0dWIg
Y2FuIGJlIHVzZWQgdG8gcHJvdmlkZSBTUklPViwgaG93ZXZlciANCj4gdGhlcmUgYXJlIGh5cGVy
dmlzb3JzL1ZNTXMgdGhhdCByZXF1aXJlIFZGcywgd2hpY2ggYXJlIHRvIGJlIFBDSSANCj4gcGFz
c3RocnVlZCB0byBhIFZNLCB0byBoYXZlIGl0cyBQRiB3aXRoIG5ldHdvcmsgcmVwcmVzZW50YXRp
b24gaW4gdGhlIA0KPiBrZXJuZWwuIEZvciB2aXJ0aW8tbmV0IGJhc2VkIFBGcywgdmlydGlvLW5l
dCBjb3VsZCBkbyB0aGF0IGJ5IA0KPiBwcm92aWRpbmcgYm90aCBTUklPViBpbnRlcmZhY2UgYW5k
IG5ldGRldiByZXByZXNlbnRhdGlvbi4NCj4NCj4gRW5hYmxlIFNSSU9WIHZpYSBWSVJUSU9fRl9T
Ul9JT1YgZmVhdHVyZSBiaXQgaWYgdGhlIGRldmljZSBzdXBwb3J0cyANCj4gaXQuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IEFya2FkaXVzeiBLdWRhbiA8YXJrYWRpdXN6Lmt1ZGFuQGNvZGlsaW1lLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogTWlyb3NsYXcgV2FsdWtpZXdpY3ogPE1pcm9zbGF3LldhbHVr
aWV3aWN6QGludGVsLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvdmlydGlvX25ldC5jIHwg
MSArDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMgYi9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMgaW5k
ZXggDQo+IDA4MjRlNjk5OWU0OS4uYTAzYWE3ZTk5Njg5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC92aXJ0aW9fbmV0LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQo+IEBA
IC0zMjQ5LDYgKzMyNDksNyBAQCBzdGF0aWMgc3RydWN0IHZpcnRpb19kZXZpY2VfaWQgaWRfdGFi
bGVbXSA9IHsNCj4gICANCj4gICBzdGF0aWMgdW5zaWduZWQgaW50IGZlYXR1cmVzW10gPSB7DQo+
ICAgCVZJUlRORVRfRkVBVFVSRVMsDQo+ICsJVklSVElPX0ZfU1JfSU9WLA0KPiAgIH07DQoNCg0K
U28gSSdtIHN1cHJpc2VkIHRoYXQgaXQgbmVlZHMgdG8gYmUgZW5hYmxlZCBwZXIgZGV2aWNlLiBX
ZSBoYWQ6DQoNCnN0YXRpYyB2b2lkIHZwX3RyYW5zcG9ydF9mZWF0dXJlcyhzdHJ1Y3QgdmlydGlv
X2RldmljZSAqdmRldiwgdTY0IGZlYXR1cmVzKSB7DQogwqDCoMKgwqDCoMKgwqAgc3RydWN0IHZp
cnRpb19wY2lfZGV2aWNlICp2cF9kZXYgPSB0b192cF9kZXZpY2UodmRldik7DQogwqDCoMKgwqDC
oMKgwqAgc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYgPSB2cF9kZXYtPnBjaV9kZXY7DQoNCiDCoMKg
wqDCoMKgwqDCoCBpZiAoKGZlYXR1cmVzICYgQklUX1VMTChWSVJUSU9fRl9TUl9JT1YpKSAmJg0K
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGNpX2ZpbmRf
ZXh0X2NhcGFiaWxpdHkocGNpX2RldiwNClBDSV9FWFRfQ0FQX0lEX1NSSU9WKSkNCiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX192aXJ0aW9fc2V0X2JpdCh2ZGV2LCBWSVJUSU9fRl9T
Ul9JT1YpOyB9DQoNCkFuZCBJIGhhZCB1c2VkIHRoaXMgZHJpdmVyIGZvciBTUklPViB2aXJ0aW8t
cGNpIGhhcmR3YXJlIGZvciBtb3JlIHRoYW4gb25lIHllYXIuDQoNClRoYW5rcw0KDQoNCj4gICAN
Cj4gICBzdGF0aWMgdW5zaWduZWQgaW50IGZlYXR1cmVzX2xlZ2FjeVtdID0gew0KDQo=
