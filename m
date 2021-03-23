Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979F4345A8D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhCWJPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:15:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:31579 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCWJO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 05:14:58 -0400
IronPort-SDR: c6xIxTNav8WjkI6ZeuP1LUv+TLiDeQiBom2Jz6w95O7LcAU6Uvm4RN9VAvXKKz6pE3w7mtcgq/
 J66YVUFqeQJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="188123311"
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="188123311"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 02:14:58 -0700
IronPort-SDR: A1MXVJxYp1QxAHLtFFovrX4xCoBgfM3cdORou4Q7DoLOZu/WoCnrbmpR43oTd0cIHenCvwe1K/
 LqDBOb0Jw77g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="442450664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2021 02:14:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Mar 2021 02:14:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 23 Mar 2021 02:14:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 23 Mar 2021 02:14:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Myo+TyeFHGCiLPiPMfdt9LmGZ45cgisfinMePINiKBmGnTBK7uB2BR6N3trxE3/+m7iGGc4z2cxbEePdVYxY2NnZ9XZBQZe27zYYvGPvEbEdQmcygLQbLl96PfmEULwtPOpbcspGSRhlbc2YZG95YYqhWQMpnqxDhsWBgjE7c21sp5y3eLUm9BzmgHrYMqo0U8r7nuCLndLGR+ftViAjtANkqPWwuBbRUkf6xhBADPEDh1PhvHr5l2WbAxm5x97QewC5UYJpCI3DNht6cYOLoS1Fo+ei6LTkYJ0AFpE++e41Un1rURySYpJwCFtdZIRjG0OQR5WmKEVLEMzI5I8E3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRoVBlSZrY7RMGKDXBGVDBX+H5gC8mtpAx1P9UzDWXU=;
 b=EHH+0ImnLjqwR/KwD3ygj1Ptri/r4uGksyQPc49r1IeKqsnUYORGrpb+MsUpSkRfbMCJoO0wPY/1QesopHDNvIPLj7IsbiSB8+QGdbC2mVMpcRFpocwSLWKP4AcHl1U15E9Q1UUrTn4Z7xBvdaYev1ZI+GdZVTnj62mvUTxTmQOYas6TOxyUwnbuDzE21i3bF3IL6OG5lKdPPUdmM51LUEBYK6DOVn/mJlQqriHKRQsKiIMlBL9U2NnEOxXWVhBIVe1KTDzjCdXbWPZBnR2nRLBP88Zi/CT5JlPa0PIf2Rb7bPUji1+S3iIztLJ6kQ9mwps7apIH0uX92V9w47fkbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRoVBlSZrY7RMGKDXBGVDBX+H5gC8mtpAx1P9UzDWXU=;
 b=XT5w1BiSvbFpxv+fCVwiFhNWxK7ck5f7JVKzT2EXe7O1A1G/BmvAf3jbmLJAxCXKAn13XaOXXGhqO+qoMG5XRGjIhLqk8fvmDDXRLe7eFKm1/zr5gzGguF+NBqI8mcbyHYnyAfpcG4PyXC5O1LwIbMmpNIuX+8BKuVUYX9sb88Q=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB3960.namprd11.prod.outlook.com (2603:10b6:a03:185::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Tue, 23 Mar
 2021 09:14:56 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7%7]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 09:14:56 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "trix@redhat.com" <trix@redhat.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linuxwifi] [PATCH] net: iwlwifi: remove trailing semicolon in
 macro definition
Thread-Topic: [linuxwifi] [PATCH] net: iwlwifi: remove trailing semicolon in
 macro definition
Thread-Index: AQHWxOhI161q2x8a8EqoB1TbK8IRuqqSACgA
Date:   Tue, 23 Mar 2021 09:14:55 +0000
Message-ID: <2d9f1585011f4a8bedaa60cf8d3bda8bf49577f5.camel@intel.com>
References: <20201127180709.2766925-1-trix@redhat.com>
In-Reply-To: <20201127180709.2766925-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 208c39da-726b-4522-60a9-08d8eddc2024
x-ms-traffictypediagnostic: BY5PR11MB3960:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB3960550F30C533944B99C4EB90649@BY5PR11MB3960.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l/csxXN2nOBcJIAo4lD4hO2W0GM672rBRZ3H0+w0Mo8FcfOWinO2DgMh1V6ZW/y/gH5H1UcndJ3gkPgAxCn0EBqq2qrWa1QJhMaN2dBuxnJZcVjGfprU24xCTWTD5PVLgA48NtaD4Vyr79MvEXmwMcLN26aRDK/TlwL+M/UNKxqaFadmbl8qgY7xvTR8crpiW4DCpkiyFE4o2YQaMF+s/Zsszdco+4h7FGN2JiNlNcFkPUa/77SvH/l0784Qwo28ud4Q1M5ugPteHbcW4JbepF2fQ2OrRiAn93nhKEWbpNT9WnULjh6cfO4I0ODUqdGo4F/9iEMLstKw+zTWPxcFxS99CDoe88lzfZg9xqdu8cJphlxiFw+V6275EsnTe6HKlDIsGI9+EoPbC4JSMLZvEcCbmersv4UEsfdM3z7dRzZsqlSo/lPjsxnaraYbfMn9Djm93mNS89A/Qfvb/rGvIjqCHcChfQ/YWam5mc3xz8mG29/F+vzbzMHlMoqFFBec3qGQGhqMq1tUcud2LIwDPt+oWqcbzOpfTfDg2lC+etAQM+HsWdqONKA+sWN6w0ipJgdVmuesCIt6xRgq8yVPmaibrQWWDPZfBxDHcK+fONby/UseqjS6ZW6xuYlUn2JCPdHwLqY/InP4K7qLnRbNCrzojPpggxgjAtS1Vqg5M1HMMxn3hNSbY19V5C21v2pN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39860400002)(346002)(5660300002)(6512007)(4326008)(38100700001)(2616005)(4001150100001)(6486002)(36756003)(2906002)(54906003)(558084003)(66446008)(86362001)(66476007)(91956017)(110136005)(478600001)(6636002)(26005)(921005)(64756008)(186003)(76116006)(66946007)(8936002)(66556008)(6506007)(8676002)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MXdpNFpzQTk5L0FHOTd1VnlRbWlPczNFck5ZZVZ1akRxOXY0eUxiaDhpTTBY?=
 =?utf-8?B?UjFMNllvKzZJOTExQ0RLQkI1MVhIQ3NSMzNSZ28yZXcxNStQSndLSzlBenNw?=
 =?utf-8?B?VGw4MmQ3WWpMQm5tVytUaGZkTytHZHNmTkpwZzFmd0ZuVjY0VkxLMFA5V25O?=
 =?utf-8?B?S2F1REw5N0NnSGdEalUxS0tNZHV6clZwQXYzOGRjWkNBTE01V1JzNkNwMlJq?=
 =?utf-8?B?Sk5QbnJyMUFNWUlHNkNBVU1oa2RnVnhibzd3TEZORkVZV2tMb3lmcytDR204?=
 =?utf-8?B?czFXNmFNcEg2S3VHbFU0NGdqWTZxZTJ6ZHU1aElzbGxZWm5GZEdsQjlyRE1N?=
 =?utf-8?B?WHlXQUh0Nms4ZS96VVdTNjlYTmYxeTdiUEtFTkV0SFZJbHQ4aDJ1amNHU1ZZ?=
 =?utf-8?B?RmlPanpkT1dQSU5KTmk1RHhZUFBBcHphTkhSOS9hYldLd0IwR0NyQ1cvWVEw?=
 =?utf-8?B?WUdpeU1kZDd1VVZobmxmTTE2RGRobUhVYXM3SXVFUnYxZk5aZzV0T0NFUExL?=
 =?utf-8?B?OW5TalFrNENPdVAxY1Q5TWtVNDg2bEprODhNTXRjRjNpOHpmeUZTQWpGd3Yz?=
 =?utf-8?B?MmI3WGdFbUNrKytoK2lEMmh1RU94dnV2eTk4TkdPeEZ0M2hKS0dNU0dmUlVy?=
 =?utf-8?B?czRRc2orVEhxVkJiN0dWc2JIRW1aS2E1TkQzM2t0UDB2SmRPeDJTRUJadXdX?=
 =?utf-8?B?MStha3hNbG02N2FRWm0rZGRUUVEzT2hMNnlVYzRib21KWnIrWjUzMyt1Q3NZ?=
 =?utf-8?B?VkZFQ25GYmZZaVRrWEM0WmRQbDk2bkZuS09UV1BaWkU4TnpaWFM2ZXVFT0NP?=
 =?utf-8?B?UzRUaks1dkN2aFBzYzE1aDJkY3dMNzVML0dRcDFwbllhUFhMOTQ5ZnFsZ2g4?=
 =?utf-8?B?SXBnaFJpb2xheVVGQnZodWpjOWlxKzZIMVF5TFhOaDZTancrQ3lHK21OeEZW?=
 =?utf-8?B?V1hUczFrWHNJKzluR2NYT2hkbEZsSTlpeUpIT2lGZUp0dnRjR3hFdXFlZjNE?=
 =?utf-8?B?UzdmRUIvc0l1c2FEWnhwVXRUdEQ4OTR1R1d4S3hoenFWdnlSR1BhNmFKQzVw?=
 =?utf-8?B?TmVNdjNoYy9Pdm9veTlmbTdQTjlkRHZDZWdiRW40OFZiVXc1YjNRZzRFNThh?=
 =?utf-8?B?TnV0ZTF1MUpFMXJmTWI3alJBODVxNHJCMFpJaWlMRzltYThzOUJVeUNxTTlY?=
 =?utf-8?B?OVBNTXBMYXFmUVFXVTQ5WnhvUVI2QWQ2eTV3MHBnT0VrcEo4L24wUnFjUU9o?=
 =?utf-8?B?bG9zT1dCcTRGSHprTzNJVkJuWVh0UGFOOGRNakZFNGFnYUpYdUZ0L1lKY0xp?=
 =?utf-8?B?akNwTE0xKzNDZk1ZUEI4N2toL0VhaXVkUWRDS2ZrVEpOcG40UXhKS0VMWTNX?=
 =?utf-8?B?eU9TdHc3T1laQ3Fyc1Y1MmU4VEh5NVZ5S1VicHI3NnRVM0oxQW1IdmRHTENE?=
 =?utf-8?B?T00xZjgxNkdZYWxmd1Z4Z1NwU1pMUC8zUFUyUnlORlZKQ0J5L0RxM3JwR0k3?=
 =?utf-8?B?NWNabThhdnZzU2F6U2VINk13MjNhTDdQbXZjcXBHQ1RnSloxZ1VGNExmeEFM?=
 =?utf-8?B?Z25QMWxKeDYxT2NIaUJYL3hXZHhtU0g2aWg3ZEJZeURWSzNqTW5uT0E1cTZq?=
 =?utf-8?B?TnQ1a2lQZXY2SXUxb1E4VmVYdEpQVEpHcm5iNGlBVTdBNk5qRE1CNk1YRGIx?=
 =?utf-8?B?Wnp1bUlYbFBJL3FVSm5pQUNMY0NkRXFTUkt2QzVaNVBDMmgxNU1hQnJLMzE5?=
 =?utf-8?B?K1FOcGtaazVIWkpTZ0lBcGcyTWNSbFFoZVhZR09wWFZEbWQ0emMwclhOVDkr?=
 =?utf-8?B?UXk2bWNNWW9lUkJmakYvdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCA126D9054B23438CBCCDE685C4A565@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208c39da-726b-4522-60a9-08d8eddc2024
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 09:14:55.9219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYfbyphl4dCYvjGwS8CLDyr79mqIVAyQnOY1kuI8xuZBj444q/U+2qGhyBH8Wb2ZHyE2jZg7owKv/CJ8rT2Vm1nr3wMnYuJyWQ7ys8NWFtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3960
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTI3IGF0IDEwOjA3IC0wODAwLCB0cml4QHJlZGhhdC5jb20gd3JvdGU6
DQo+IEZyb206IFRvbSBSaXggPHRyaXhAcmVkaGF0LmNvbT4NCj4gDQo+IFRoZSBtYWNybyB1c2Ug
d2lsbCBhbHJlYWR5IGhhdmUgYSBzZW1pY29sb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUb20g
Uml4IDx0cml4QHJlZGhhdC5jb20+DQo+IC0tLQ0KDQpUaGFuayB5b3UuICBJIGFwcGxpZWQgdGhp
cyBub3cgdG8gb3VyIGludGVybmFsIHRyZWUgYW5kIHRoaXMgd2lsbCByZWFjaA0KdGhlIG1haW5s
aW5lIGZvbGxvd2luZyBvdXIgdXN1YWwgcHJvY2Vzcy4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
