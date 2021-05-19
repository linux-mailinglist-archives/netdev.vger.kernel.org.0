Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202383895C7
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhESSu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 14:50:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:7390 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhESSuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 14:50:55 -0400
IronPort-SDR: wXSGMiMEV2DCvIOdcCj1vmtWChY+sdMURYvJf8YZ8AUTuWeYdFLwDQKsvU3AbX2vytkCiG4jFS
 JHmvkUAZ0hOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="199098735"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199098735"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 11:49:35 -0700
IronPort-SDR: jg1LMWK+Pi5uSsPDUSsaNwD0ia90pMeGMVeZF7X7oMrzKhiw8OhpzY7jecRo1cyv9eEyHMyE/H
 CftBsC2sl0XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="542810191"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2021 11:49:35 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 11:49:34 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 11:49:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 19 May 2021 11:49:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 19 May 2021 11:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0I3VTc0Yi5aqUemWj7Zbx1a3wSvSX4ze0nVJk3FQGP21D38JYiieG1Nl8rpTGHDI358KVN/eOzFJRz+DWbU/9V52kB+8bhNUvzhs3cb8BWp4EGAGwEBNmjWRu2YjQOdR33J31D+4vd9xv8nSJIUG6WxhY//XZAKCh25wNh0/8ht+c8+V2ikCLSc6qTumpS2twqKDpnaDlGCQklhWY+b8zEnILf50/h/pRLJ+T7/RkN3KVzEfj1mcCPO6w5sdh5sKzftIY8v/nPetEwzphp2QDoQVHTGn6AIeHnRkBC8nIKSH8TxLrVq1OTuPOZK/XA1vy+OBoTq+Fj9zHEpEoe9Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YQ/gk2YFBaNpZFfsIhCRLOJ1quirsHjJWicCs/7Avc=;
 b=MjSemjmuD+lKM8+iILTXJeiwZJt9JyQO+nprFJMG1DhOALSqu8TUlYljLHGi6SiFWY5DJcRotzJGgH12uLNmQR++p2JiTdI7kvWmFJz7DRB8ZglJh+11GhRakpOcZVM/cqvRHFLDGxvOmjR6oD9m3L8uyqscgftHxld2lfdydM1FqdE9z84nkut18Au2s0Rth84rs/UD9QdLbGUiHRNnjXQvwsnCH9EyBaELeTHiAjOvKlpi1KwLTAfMzXo4DlwFL26pDwnP/rUXnqj3qLhap7BzdiVJoY9yRFKFI7ahBOvHiZi2LoV6M5ekvHcuEG8c54NHiBZfZMQJ3EajqQOxTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YQ/gk2YFBaNpZFfsIhCRLOJ1quirsHjJWicCs/7Avc=;
 b=oaOc14nDVvm7Wuo029S5rBRU1TvSzL8D5TOrpKNsXy/qMd+UXVpjOL3Qwha9UUEOmozK+zy+jfParMT9RZ7D2VIDCRf8Da1kQkTEYieaObQvLmHUSm1IM66VcI205UAu+2U/FrSi+PRdtH1SR7vSrxLOTKLPR565e+bcQ1IVSGM=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2590.namprd11.prod.outlook.com (2603:10b6:805:54::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 19 May
 2021 18:48:51 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 18:48:51 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "huangguangbin2@huawei.com" <huangguangbin2@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>
Subject: Re: [PATCH net-next 0/5] net: intel: some cleanups
Thread-Topic: [PATCH net-next 0/5] net: intel: some cleanups
Thread-Index: AQHXTHa6xSolE87yyE+COWj9FnsC1arrJvIA
Date:   Wed, 19 May 2021 18:48:51 +0000
Message-ID: <194cf154afa7b56b22d4284cad537f1a6b697f61.camel@intel.com>
References: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d22bae6a-b2b2-4bb4-fe9a-08d91af6beee
x-ms-traffictypediagnostic: SN6PR11MB2590:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB25900381C53634EBF9EF7C94C62B9@SN6PR11MB2590.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9bFlTtxBSsutq29X8K+b/1d5duvAt4qidIefU5A3UE0G08ljwF6eknFM+olhoBL0j4uy028dCz4sTfuxXsbbcxbbHjSJd3NP4c4lkDVREvioEgZtnJXB4mEP7yMeICzcc4Q2MkeKACbnw6MdoFn6GwYHkval8H7zaj3bxk8hq9QpK72xXtFE9qxU5F1LEUQnRbYYZNH9osMe8larsLd3larggEYSU0jojJEk7kmqKN+FwHe5GAdTpNgeKVUeQdHAZ1YzMrIxXUY23qitseV7/BdQU8jqG2yp7GWDDgQdFa9J1DtAlQYSXcqfrOb6QBQf7vUkmKreHzB53t3Okc/G8lpka1fT8O4A6Sjh6ldldPYXzVARclfXPJje455EyUdbfptIQHUfBESLspxZyH5EmLwJMeWGf0/UCE+G5YfpfXKh0y1UWmJnjgGRl9W4s81DZICcEOR1jm3F9iTE54KEV3NQnQ1V2PUUAB3q31d0UCCnnR4kF2WX28LJbFGAHzbWkAw4bszF7PenX1m5iTVI0xOJfEAq5infpCbfu+iMvRNIZLGw1/OupWVU4kuvZt1xnnQyrozl/22mNQUXw2iXxm+jR0nY4a0SsOhAILmXm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(136003)(39860400002)(2906002)(36756003)(8936002)(91956017)(110136005)(66946007)(54906003)(86362001)(66556008)(6486002)(66476007)(186003)(4744005)(26005)(76116006)(316002)(4326008)(478600001)(2616005)(8676002)(38100700002)(6506007)(66446008)(71200400001)(6512007)(64756008)(83380400001)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S1NTN0xEYmJnRlNzbmtBUHl0THp6MEM4TkZKSjNTL09LeWc1SjZRNTdaMmUr?=
 =?utf-8?B?Tjk1YVBKejB0VWNlUFg1SjUzeWdCa2NFK241ZFcyWExCb2NWNmJoTEFsUWN6?=
 =?utf-8?B?WlNuV3pnZEZveSt6S2FYQ1RqV2VYTjEwSnBSM1ZScnExaGovVEZNUGxjY0Rl?=
 =?utf-8?B?VFBHTjFuZnV3SjN4QnZ6dXM5UVRnWTg2U2REQmZtb2Yvdk02K0t6a3J4c2dV?=
 =?utf-8?B?ZUd4TjNueWdRRnVKY251THZxRnBiKzdYQ2pHeXRwVnVHakJpT2kvam54MUlN?=
 =?utf-8?B?MDNxMEp4aDlWK1AvK1FJTXRpUi9HV3pzc0RSaEd0Zlcweno5L1QvSk9MQjNF?=
 =?utf-8?B?OUN0QUJZQVdvUk16QXUweUFjZjZNVnZIb2JQMEMza21PQk1EdHNTUlI3OXNJ?=
 =?utf-8?B?THdtRmhNZkphY1ZveTlBZXR3UUFKcTlwTllYVS9kOEpNVXliSXUwZTE2b2ZJ?=
 =?utf-8?B?aVM0TlExQTZ1OTVhZk1tQkFqdTE3cTB0UkgzZjVhRWFjZ2ltL0QwMFdQRHhQ?=
 =?utf-8?B?QmtKd1g5cjdKMDI0LzFqY2lzTUpYQkV0TWgzdlNCaXJQWms4WUltUjBlMi9B?=
 =?utf-8?B?Ykp3RGM0djhEWUNjcVN6N01CNUdseVJaRkFOVkt0dDlaaWF6VzZ5TkhUVmR3?=
 =?utf-8?B?ODJobk5SVlQvTE5RR2N3enN2M3M4VGRYempYelBjNnhqQWtMRlVWOTZEUHNx?=
 =?utf-8?B?akJuWnBsSm52WUx0OG42YWhTOE9sNUNaeitlNXVVeHBVL3N2amJKTklDRDZj?=
 =?utf-8?B?ODBRcWNDa0RyeER1REJTUENES292MzFKZEhaUGowNDREU2tiQll1ZVNKMFBx?=
 =?utf-8?B?RlNCZEZXTTBLZXk4aFdkQWs2ZXd3dy9uVjAzRFpmc015NUwwcnh6dFN3N25F?=
 =?utf-8?B?bG1MMlg0elRNdUdGd2h6YWN3TmFKNjNXNTVIUlFBNmQ4YVJ0MDBwd3NsRDNj?=
 =?utf-8?B?K2JIcTB1dGg4RVRyN1lhZVdNd3FjZW1abzVnNVMyLzg2WkN4YjVWNWVUdDQx?=
 =?utf-8?B?WjZWK3RJM1pkdjM3UHcyNEMrRDJIMURDYnZKQU1KWjgydzUrenJzOStKbVdY?=
 =?utf-8?B?SWdNaUhyTGlSam9qZHlKQUsvU0xGWjJpZTBmNHhDUTArNHBKQnNqUXB5S2ts?=
 =?utf-8?B?Yndod0tqSzFuVCtZbzNhbm9kbDRZK1Job0tkVXVNdjEwUUd5Q3A5OTZpM21w?=
 =?utf-8?B?NWlsYXFwcUpQTFhqcEpRRTh3RUUzRkZwbFRlZ3NhWlhYZzZqdDhNREd4MFRl?=
 =?utf-8?B?SUFySHdCY2xqQjBEZzM4YW05WFM0R3FQMDFXTW5UQVdTZGJFZE45eUVOc2Ir?=
 =?utf-8?B?UWpJWXFYZU9FUG03WTZEc3Rlcnc1WDN5MjZVOFUycHdLbXdsZEJrUU5tTHFU?=
 =?utf-8?B?eGpLQUpWN1Q5Y1Rva1JEci93QXhDaE8wbVFkL3R6MlpJRVI3dHhIL3l2dmhC?=
 =?utf-8?B?RDA0RFNTNG1pR0hnNXhYeFdkZ0ZhSXVoTVZOVDhvTTdSd1BTSStuT0xKSkFO?=
 =?utf-8?B?VkN2OW9RRTFpZHVWWXMzRk9GVWFVQjNWNFlocU9vbHBqOEpoWHBiY05EODdm?=
 =?utf-8?B?ZTJDdEt1MVJoTXdkZy92eDRUYkNNaVh2WEFwN0RsekRuM0dSVjhCUmVSQUs5?=
 =?utf-8?B?U0plQi9vUVlOMGx2U1lGUHU5bllqYk8zQ2s5RmwyVU0rMVFjU1Q3NmxMRWhr?=
 =?utf-8?B?aTZkSVFTVzZKdzV0cUNsckpLUFlzelArTEwzWVhBbEI5YUpwWUZpZnEwRlNM?=
 =?utf-8?B?cHdYeG9QSGwvL3VpS0VJL0lDUWZjcWQ4bzNyR3R6KzBRbVNsWVcyb0JLSHZk?=
 =?utf-8?B?U2xyU3pTZTNxL2ZWRGhaUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F62313720B2964EB731FAC8BBB8542C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22bae6a-b2b2-4bb4-fe9a-08d91af6beee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 18:48:51.6157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MvmEtHaaJRUNco54XbA0Ss3F+vQdYUWy1LO/y+iaqmg8sF8n1jSsjkfqc4+Xn19tpi/bRmvT4x83yhBPzI1cqRDEoM/nX5XUgOkvnEmzd3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2590
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTE5IGF0IDE0OjE0ICswODAwLCBHdWFuZ2JpbiBIdWFuZyB3cm90ZToN
Cj4gVGhpcyBwYXRjaHNldCBhZGRzIHNvbWUgY2xlYW51cHMgZm9yIGludGVsIGUxMDAwL2UxMDAw
ZSBldGhlcm5ldA0KPiBkcml2ZXIuDQo+IA0KPiBIYW8gQ2hlbiAoNSk6DQo+ICAgbmV0OiBlMTAw
MDogcmVtb3ZlIHJlcGVhdGVkIHdvcmQgInNsb3QiIGZvciBlMTAwMF9tYWluLmMNCj4gICBuZXQ6
IGUxMDAwOiByZW1vdmUgcmVwZWF0ZWQgd29yZHMgZm9yIGUxMDAwX2h3LmMNCj4gICBuZXQ6IGUx
MDAwZTogcmVtb3ZlIHJlcGVhdGVkIHdvcmQgInRoZSIgZm9yIGljaDhsYW4uYw0KPiAgIG5ldDog
ZTEwMDBlOiByZW1vdmUgcmVwZWF0ZWQgd29yZCAic2xvdCIgZm9yIG5ldGRldi5jDQo+ICAgbmV0
OiBlMTAwMGU6IGZpeCBtaXNzcGVsbCB3b3JkICJyZXRyZWl2ZWQiDQo+IA0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDAvZTEwMDBfaHcuYyAgIHwgNCArKy0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMC9lMTAwMF9tYWluLmMgfCAyICstDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5jICAgfCAyICstDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvbmV0ZGV2LmMgICAgfCAyICstDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvcGh5LmMgICAgICAgfCAyICstDQo+ICA1IGZpbGVz
IGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQoNClJldmlld2Vk
LWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQoNCkRhdmUvSmFr
dWIgLSBhcyB0aGVzZSBhcmUganVzdCBjb21tZW50IGNoYW5nZXMsIGRpZCB5b3Ugd2FudCB0byBw
aWNrDQp0aGlzIHVwPw0K
