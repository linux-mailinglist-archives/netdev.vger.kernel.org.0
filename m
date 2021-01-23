Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE952301176
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbhAWAO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:14:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:9050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbhAWAN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:13:59 -0500
IronPort-SDR: WuM5fJsx1OXydRutLVE6hwjRA4XkN09BIzJlGjEpDoxWpX6pgx8gnC1QCkRRC20EwZxHdp6jx7
 NMeTdTPejQ6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158708413"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="158708413"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 16:13:12 -0800
IronPort-SDR: zXzV40hZUsW95t2KIOTKdR275qpG2axjJY3xgMYyLB4iaTFGfnu16AcB28NSlUDC1+tRxa89On
 DpNvFkVTm47Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="355412663"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 22 Jan 2021 16:13:12 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 16:13:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 22 Jan 2021 16:13:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 22 Jan 2021 16:13:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrY18A0mQ3abUWqY8HOcHwyot6BFK+jRbI/uyMqsfpEK6shMyC6OHeFvDvkWoIqPWk6NCCrygnQoVwxsMHzVgHCfiH/ZNRaDL7PRAm1wY+7+J/GpVVGBhYlGhBIO/CY1tg5vSw6kH+STrKIL2bS7dm3pIqtubOeCKMIkOjiS88HEmvVLdaX3VyzxBDESybcm+j7nuHW2+2ptOeDKh+UtygruH9ynHU5oX7NtoEH2+u0AeIx6Fxz620P7l22kXJkqOA320jVfbTJixHbAqqSI6vKJZAZN/CDmVzLZiT7oODBQnkMdLHNLKuEnLhZxscWmDG4PQxUkSYk21RntNlPgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOWyPU9tu6OSE8wE1JRWYWxCYSYdc0/BlU8TEBwV0dg=;
 b=VYmBBQl+lC18bNbWN3ouFCyzks94MXEbCO85WuqeWOBG5Iv/2J96+meI7gxBYxPbC0sV0fOPSCiUwrE4L1L5AyGf7ZN14hJJC/USugBOiywRZn3PYLAaKdsSYJQadPtPAK9/6z7IwbWod3nmlXjpg0ivxNfQQ4DRHP/9QDdwLZcrxH4ur90etcABECOjK1nFLhc14Z+M1eZc484uT3B+MYD7moMQwdixUh5kvSTgreP7H7eAlqKo//0EXYvP7SjlZenReZXTlPBrwJ+weJUhmw8s2bTEdnYrkDDPET31EUM2oOGfnr4QTaO0Ucaclb595W3W+cy4M2U+uAFFZ5Qo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOWyPU9tu6OSE8wE1JRWYWxCYSYdc0/BlU8TEBwV0dg=;
 b=NX9w96apGNyk/lZJUzvnm5Iuvn167OMarpAn9hsZ5InpKfnf7OW8JN5rOHripTNS3m+8IGUA4kIEK7skJKiPqOewuTrNESjJttU7eckjIQPpxTNgYmpUwqJqptbeU38ztkwq2PQFQ8QgdFCaD632yPdW94xTFdc+J7EicP8f608=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sat, 23 Jan
 2021 00:13:08 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6%6]) with mapi id 15.20.3784.015; Sat, 23 Jan 2021
 00:13:08 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "wangyunjian@huawei.com" <wangyunjian@huawei.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jerry.lilijun@huawei.com" <jerry.lilijun@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xudingke@huawei.com" <xudingke@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net v2] ixgbe: add NULL pointer check
 before calling xdp_rxq_info_reg
Thread-Topic: [Intel-wired-lan] [PATCH net v2] ixgbe: add NULL pointer check
 before calling xdp_rxq_info_reg
Thread-Index: AQHW8MKy0kqSrmmyy0+0kJqXSpUyNKoz7aEAgABp5oA=
Date:   Sat, 23 Jan 2021 00:13:08 +0000
Message-ID: <b14b76065d51d7a3242231a78f0b41c7166c0882.camel@intel.com>
References: <1611322105-30688-1-git-send-email-wangyunjian@huawei.com>
         <CAKgT0UcpQpGLCdRbaEzyb4Q4gC9gmefg4bMFcgrQoRwy6UJvrQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcpQpGLCdRbaEzyb4Q4gC9gmefg4bMFcgrQoRwy6UJvrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c70c2248-855e-4ab7-6565-08d8bf33a9bb
x-ms-traffictypediagnostic: SA2PR11MB5195:
x-microsoft-antispam-prvs: <SA2PR11MB5195CC662885578AA3DEBA2FC6BF9@SA2PR11MB5195.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6YUSgCiizRyPhaVV+ViWZwuBvrQF4EuChI+1SUqJbbsCEfGwx0B2gKzMbgIYPw2HPo4D1lojADa2m2+0I5wBL/ZOV2PM+knchbI5ZvUE5QpePKMfqpXqhu2Osb81vt4RP+04cecS6znsspLe8eMI9364gJfFlNNlhtiMliQLrnDYGcH0Z6pP9wqxMmLjDSpJITp9ynaVBgXUkBxuCGZ33hGqf0Wa1D6bgLcXmH1l5Ow85/T+j4590lj1bef6gJ7pSXctMZMq9/U6EnwuvVseapiPf7fGsVhTG+kZk6nZGkUctkFiLddXbTUyQJZHbZjCLwFpeKgGBh00WhvXGzRQFTAMsTIZjcFR0eHbemibJUJWCq+5dugLfz7dcX9YuvDFP5lTo0nniAbzPMdlStFNKAjxxgbjAtmsYA7wOvhIXv1m85lfapno8kYcoNBckmT4z4Fozvn9PV7TE28dD56D0J9JTebRkoRJ+/Tw2xmFREA89lYm6hksg81st0a6tWq+CsK8jX9epu6Kc0Q62GEvZKUu4RhZYe2OGfrU6Dg63oEvXfKifQJhvX5fU+dbCIh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(2616005)(8936002)(6486002)(2906002)(54906003)(110136005)(6506007)(86362001)(478600001)(53546011)(8676002)(6512007)(71200400001)(316002)(186003)(26005)(4326008)(36756003)(64756008)(4744005)(66476007)(66946007)(5660300002)(66556008)(76116006)(91956017)(66446008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UENiM2h2QlM0a2J3cG9qYk9lNEdDY09FdzkzcFhWSDViQ0k1TmpEL0Z0Uklr?=
 =?utf-8?B?YlA5TjJJc3kwNlJXdlRmeWg0UlZ5VW9zZHl0bGJLVEdhOTF2L3ZXNU04UmNr?=
 =?utf-8?B?MDNVMFo5TUdOSWVwcCtTa1JqcHFPOFEwZ2NaOW1nWTlXQlZ2WlcyTE9OTXAr?=
 =?utf-8?B?RlhsOXF0WU0yTk1YK1BNRytUVFlXQmRyYkNmT0ZFa1VsZkxnQW5MZWx1UUxZ?=
 =?utf-8?B?Q3AwQklOZlMwNjVOWHIyREtyM1ZEYnM5dEVlMU4vMEJ1bHA1akFmRUhsUVRV?=
 =?utf-8?B?Yy9jM1BsS0YyQWp0WUczWGFEZEZLTGxjMkRoL1B2S1lQSW5WclFyTkpteEpq?=
 =?utf-8?B?NUFWQ0ZIam1jN0p1VWJkNEwydFB1Q3JzY0huM2tiY2I5bVFrajdMaFVYbllL?=
 =?utf-8?B?Mkd2NUxTM21LSnk1K1ZZZEpnbUI1cVhCUElaam96a2xFTVpGVytmOWJoZEhL?=
 =?utf-8?B?ejRLN3VpSmYzNElaenk4TVRCVEg4WGZCTE01ZFh5dmZFT2tpRDhvVjR6OWQ2?=
 =?utf-8?B?UnJFWUpUZTA3YjBGR0E1VTRCK1BkYzNrV0YvSlhEcUg3VmwvZFQ2ckprS3J4?=
 =?utf-8?B?Uzlvb2tnbElPUTBySkZPS2Z5YXNvbythaDBPdWFpUjFBblFiK00zR2xDK2wr?=
 =?utf-8?B?TWdyK3I0SFpaRTNjWFZPLzVOSEk2N2lFSFBDUk80dmFscFc0RmhrYmhyT3B2?=
 =?utf-8?B?RFhmNEI1dkNtdVcrK3ZSUjdXMCs1ZjhHcHdhV0hsVmNGT2hGZmJkZTBZYU1j?=
 =?utf-8?B?YTBTOE5xVEFtNlI0cXFPMUxPWWdNbzJYZzZTM2NFWHhUdDM5ZE9DaGRnNHBH?=
 =?utf-8?B?bndQSEZBdklRK3RQWmVYUGZxWVFGd3J6VjcxbUxWNXgxMTNubE5CaTg0STZ6?=
 =?utf-8?B?Q3BhNmJJZ2w2a040UnIrMGVYZXFVZkh1RE1kWnVQY2syK0JoQWx1YVJRMHov?=
 =?utf-8?B?dVlueVVxdHhwRTI0SXRMVE5lbExDT0gwR29yd2tEMnJJZjY0LzdOeS9oWi9u?=
 =?utf-8?B?VERPVTlYa1Z4a25reHlHdnlBMXpsSFRaSW1BS3NndGZRdTkrc2l0MUJscWxR?=
 =?utf-8?B?eU1Za3lmQlFTZFByUDh4V3BTS0o4ekJEeVRXK243UHJvcWVjREQwMHAwNytK?=
 =?utf-8?B?cVk0emZTdEZkeWVIM3liZ2ZPY00wRHlxS0FUYTVZQlhaR0xrV1pLaXNieE9J?=
 =?utf-8?B?T09xRk1lcEE5bG1JVDFFUUYyK3FoMHVVeWVoZ3pTNEVqNHJSNEhzMnViVU51?=
 =?utf-8?B?aCtHU1RXcEZYQm9kNFBhQmpPcjAvU0c1bExVK2xUUDRXb3p6c2xrSHhoU1Fi?=
 =?utf-8?B?Sk9lc290eTA4Z2pNU3orV0VzYXVkdDhVeTB5bC9jVkYxSlI4MmlwOU5tNFNo?=
 =?utf-8?B?RHBhWmNjYVZ6RUoxQU16VnMxTWhldnhrSW5nS2tzTlgrOEJzSlVtOVNtYVFz?=
 =?utf-8?B?YXRTdmF2SDJma2JZbUk0L3czWGRpa2NENVVSU2FBPT0=?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F384A5C0B14E3248AF7C518E9D33B48B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70c2248-855e-4ab7-6565-08d8bf33a9bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 00:13:08.4043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdrtQfvsX1cMdmOllqd7LZQafiNo2DwCVfIXEcavuY/C1KEo5WQQCsO+rWIh4vpK/u2Sh7yCngRcR4OeRFdT0tMOUjqXgXpoGE3UBvvop0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAxLTIyIGF0IDA5OjU0IC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIEZyaSwgSmFuIDIyLCAyMDIxIGF0IDU6MjkgQU0gd2FuZ3l1bmppYW4gPHdhbmd5dW5q
aWFuQGh1YXdlaS5jb20+DQo+IHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IFl1bmppYW4gV2FuZyA8
d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPiANCj4gPiBUaGUgcnhfcmluZy0+cV92ZWN0b3Ig
Y291bGQgYmUgTlVMTCwgc28gaXQgbmVlZHMgdG8gYmUgY2hlY2tlZA0KPiA+IGJlZm9yZQ0KPiA+
IGNhbGxpbmcgeGRwX3J4cV9pbmZvX3JlZy4NCj4gPiANCj4gPiBGaXhlczogYjAyZTVhMGViYjE3
MiAoInhzazogUHJvcGFnYXRlIG5hcGlfaWQgdG8gWERQIHNvY2tldCBSeA0KPiA+IHBhdGgiKQ0K
PiA+IEFkZHJlc3Nlcy1Db3Zlcml0eTogKCJEZXJlZmVyZW5jZSBhZnRlciBudWxsIGNoZWNrIikN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+
DQo+IA0KPiBUaGlzIGlzIGtpbmQgb2YgYSBiaWcgZXNjYXBlIGZvciB0aGUgZHJpdmVyLiBGcm9t
IHdoYXQgSSBjYW4gdGVsbCBpdA0KPiBsb29rcyBsaWtlIHRoZSAiZXRodG9vbCAtdCIgdGVzdCBu
b3cgY2F1c2VzIGEgTlVMTCBwb2ludGVyDQo+IGRlcmVmZXJlbmNlLg0KPiANCj4gQXMgZmFyIGFz
IHRoZSBwYXRjaCBpdHNlbGYgaXQgbG9va3MgZ29vZCB0byBtZS4gVGhpcyBzaG91bGQgcHJvYmFi
bHkNCj4gYmUgcHVzaGVkIGZvciBhbnkgb2YgdGhlIG90aGVyIEludGVsIGRyaXZlcnMgdGhhdCBm
b2xsb3cgYSBzaW1pbGFyDQo+IG1vZGVsIGFzIEkgc3VzcGVjdCB0aGV5IHdlcmUgZXhoaWJpdCB0
aGUgc2FtZSBzeW1wdG9tIHdpdGggImV0aHRvb2wNCj4gLXQiIHRyaWdnZXJpbmcgYSBOVUxMIHBv
aW50ZXIgZGVyZWZlcmVuY2UuDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyBBbGV4LiBXZSdsbCBs
b29rIGludG8gZml4aW5nIHRoZSBvdGhlciBJbnRlbA0KZHJpdmVycy4NCg0KVGhhbmtzLA0KVG9u
eQ0K
