Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009A2301BFD
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbhAXNEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:04:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:11844 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbhAXNEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 08:04:20 -0500
IronPort-SDR: klLPmI9s35C80VMjzBzu0H+2v7ONDOyNFk+UeQg6YbE1GwvVRhSMewBtZmyn5U7gucqUS9BpAJ
 UmmkACqhG1cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9873"; a="167293347"
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="167293347"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 05:03:32 -0800
IronPort-SDR: I6RzbbqxDnYqF9RbfWRzve0x/s2sooN64tj39+OUEm1Y6f1mHwVqPo7bOwCHqFVOzOhmkBOrw8
 X6uoh0mA24Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="408957272"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jan 2021 05:03:30 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 24 Jan 2021 05:03:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 24 Jan 2021 05:03:30 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 24 Jan 2021 05:03:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlphE1kR3zjjCWItqrbevz50eFWavFsfWrhY3M5bWn6MtCgoc62N8DqXZinyEnmAVpcCRAoObNlKB3OMbgHhi60mbbGaUPtBVwmuvs5dipsbKuWyX1cGfU8m+wOyRq78k2lOesEBIKXhjbrMZ1yYH2rEQVgLMp1cK3QhGGjwO03BGQS3vdqGcNNZ5OAACHaNx8O6oJynvc20iQZSAXJpwIJ8G7426zq3bR06IiUVlRgV5RWH8x7NRtM2a1wfWQZQHn8+cTisU7toKpIOturbT4WlVSHysYEMNrzg7LnqHpTp+pxcriHDSMuFTtdkawMTet1PeFnV5D/feDufJCg5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssVWcgDtSDHi0sktOMckuqROMAOSfRFCdAmBl8tTg3Q=;
 b=dITilvf0MBuR5sovXi6SbPEf+XF1kjg/MUTRRm8MLly5NYCT7ftPM39uUGLdnVlQqJdZmzKFg5rY+fkdp52AN0GF+gFyj0O0mq2wfnSCVKpjGbYs+Yu8H8oWPi2nLdf2aZTOLqcoUB7m4PmfOtQkRdhUAsF/l0uMYIbFCgGCjJvwt0GEi1u6a4Z5tCCfPFKjHAE5EwF1V4TtweDMrLJjvAecAm2Thi5t7b5M0XkZVT/9L+6dfaJZqBT7t3GQgrV6prCk+OZ0QlSVdiaiXjc7IwVkVWddqrupc/eo6Xl+Q6vFCXkUug1rZLAczBoPB6G9Fzaq3L3jnGEWz9fvxkCBPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssVWcgDtSDHi0sktOMckuqROMAOSfRFCdAmBl8tTg3Q=;
 b=YZcuKrE7eDoUk/v2qAalEtEk5x6mdhsFHOlgA/jyEpWH+M/t2mWBEC7Jh9e2ueaks65mxBObpsRoF2cXxBirHFctasIlSke8p4GhmG65FhRHfpSg60CscQxmCD0PIM6wbHrLGh1Mm/ZFr6Qw8l+2rmTw/+PPaNxpQeRim6PSFCE=
Received: from BYAPR11MB2613.namprd11.prod.outlook.com (2603:10b6:a02:cd::13)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sun, 24 Jan
 2021 13:03:28 +0000
Received: from BYAPR11MB2613.namprd11.prod.outlook.com
 ([fe80::50c9:21df:2663:6d10]) by BYAPR11MB2613.namprd11.prod.outlook.com
 ([fe80::50c9:21df:2663:6d10%4]) with mapi id 15.20.3784.016; Sun, 24 Jan 2021
 13:03:28 +0000
From:   "Peer, Ilan" <ilan.peer@intel.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: pull-request: mac80211 2021-01-18.2
Thread-Topic: pull-request: mac80211 2021-01-18.2
Thread-Index: AQHW8c8jkBQz+k7MdUGDMkmFqxx046o1xv4AgAC3TTCAABy2gIAAIuEA
Date:   Sun, 24 Jan 2021 13:03:28 +0000
Message-ID: <BYAPR11MB2613A16DAF4DAC8A21643E4DE9BE9@BYAPR11MB2613.namprd11.prod.outlook.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
 <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
 <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
 <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
 <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
In-Reply-To: <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [147.236.145.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e7f17f-d612-4d20-58e4-08d8c0687172
x-ms-traffictypediagnostic: SJ0PR11MB5133:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB5133ABF8F88F06B157EA5B63E9BE9@SJ0PR11MB5133.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zladO18UJCBfFTFiE7apUIsIBQ5sJtvMa52PDv2YClr+D8kaK59zoe/flOR/WN4JeEx6TT0dMO51j0J45D7KiOo5RbIyAuOUNI6uhRJBmDHgEmlpR/CU1Rm5Ht5+HZ/ta07Gd42+apE+I6euxzPhQeM9LuDoI8KMrOqCBJJBM5EdutpSzG6JVMZxNxYUXZ1OxBvt/4HOuRB7oRq7RSPpMagsrAJiVIPSaomNegJNXX0NLT79JrbtLO6jPi/es7bo7jHXWiYIp8TDZx0kLLuwRR8cQQ8vIY7XLAYk5/xabSR7OovAb2HWLSaHEnxKUtRdCvxqsbz0dEDuXxSIk0kq0pPgxjjSY3Z8pLfpqirHqtsVbGpfr470LZfUCzaxu7vj/sgZyAUHtn39uiKTfkXtgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2613.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(66946007)(64756008)(66556008)(7696005)(66446008)(66476007)(4326008)(110136005)(26005)(8936002)(478600001)(107886003)(2906002)(9686003)(6506007)(76116006)(186003)(71200400001)(8676002)(52536014)(33656002)(55016002)(4744005)(86362001)(83380400001)(316002)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N2pYWlVRdHJNbEdwdWdQSU1pWkEwRjQ3ZGt1dDEwVDVKZUhFMTMrVUh3bUVP?=
 =?utf-8?B?TE45dXM1YXd0NWRrSy9LYkdnNlpPTVBobzEvZEkzbU5HaGoybUl5U2grVXJi?=
 =?utf-8?B?WWJGcllOR092MjlTQ2ZBc1M4dHVyakFvbXBFZmRLYldiMGJhQ2ZBa2ptbHFj?=
 =?utf-8?B?NmhnalhwY25jTkpkR0U2Q0ZjZ0cyZjBtQjhsRUg5S1RtOEw4SEFzMnBlZXNV?=
 =?utf-8?B?OVpPQkluNGdyUFgwREVyM2FnREhFNnJqM3VHSnh3UFdILzJoK2FvQVpVSWJs?=
 =?utf-8?B?MnNiV0FmWE1FS1BsNTlaUFNzWFlKWGQwTjZwbmlZbnRlVGNUYWpHWXgweFNP?=
 =?utf-8?B?Z1J0T1hSeXpQMWcyTUt5V1NnWklXdndtUWllZlZlVjB4S0R3cWFlZDQyQStW?=
 =?utf-8?B?cnJlTVJZaUY5bENUbzBqbnpMMFJNcStaamhneWVVVElGNWVsdnVqa25qWFc3?=
 =?utf-8?B?cmRRZm9yTWNCWjMxblBjOHgwTkxrZUp0c05FTVhlc1NUN0s4WS9VWkI2R0M1?=
 =?utf-8?B?US9qMCtVL3I0ZTZJMitSTkNTbDhnVTV3cG54RENrOEV4RTNJRDlxeEpvT3Fk?=
 =?utf-8?B?OEVMcUtLdVNiQnBUUTVqRllXbkpRbElIUEdqa0xOcGdaQmpYS3BlVFp6SFM5?=
 =?utf-8?B?YUYrNUlhalN2YWRHRlNhQzZQcXBNTGtLdlk0TURFeG5xV2VLTUpOelZCMEN2?=
 =?utf-8?B?N21GaWJCR1IyR2hOUnZ1OTV1QklTeEZrMUpDWlZBS3l4YzluTEhoamUzTjJk?=
 =?utf-8?B?QkxDWUdXZXlzUnd0cG5DQnRtMzFZSTRnZ0JQUTBxV1gwaDBKZDlpU01YK1lw?=
 =?utf-8?B?QTUwanJYSk9XKzFTWFczQW9pRUl3dzZjNjJXeXhaa0FDajFwMmJVVy8rN0RR?=
 =?utf-8?B?dkZ3ZmdKeXlnSjZnMGxNMVAzQ0VMMnBKdVY3Q1lRZmNWOTQ3RDEyZEpIWlVI?=
 =?utf-8?B?Wk44cW1tNGhVKzhRK1ZsazIxajNKUS9wYmZiclFkZnVUeDlvTDhPamJSWDgz?=
 =?utf-8?B?d1hCeHlVRGdiaElibjRBMmdNTjI3MUJFWitockNFQ0ZMeFd4UXBxQy9JYjli?=
 =?utf-8?B?SHZZVFVlOFM4VFNvUW5uZkU2SUJIOTAwQmpGbG16RVlYTUNaS1hTSENMSWhh?=
 =?utf-8?B?SmpBWnczNzhxY3Z5VnlyWkgwWkxJeFA1WmxGbzJQZWV2dlhidlFUaUVEUW00?=
 =?utf-8?B?TzZ2NDltRC9tbHhXRVUrVGUyM28xSGVCQk9LdUVqdUl1TGdSMTBGVFB4bkRB?=
 =?utf-8?B?ci9vaG92dFNsSllNQnJPbStVdldUcTBna0RMdzRiRlZCK0hYTzFMTXVpZ2k1?=
 =?utf-8?Q?KLPYV0a8YZak0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2613.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e7f17f-d612-4d20-58e4-08d8c0687172
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 13:03:28.3857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FhqeWsS5kAhJ5B5du+P5FYxyxav15VQ9gGQFNFGUZ+hJyfrylpS5vlLz2aXeydcAna6sCWBVyowIivEdBRPxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gR3JlYXQsIHRoYW5rIHlvdSBmb3IgbG9va2luZyBpbnRvIHRoaXMuIExldCBtZSBr
bm93IGlmIHlvdSBoYXZlIGEgcGF0Y2ggd2hpY2gNCj4geW91IHdhbnQgbWUgdG8gdGVzdCBvbiBh
IFJUTDg3MjNCUyBhZGFwdGVyLg0KPiANCj4gT25lIHRoaW5nIHdoaWNoIEkgZm9yZ290IHRvIG1l
bnRpb24gZWFybGllciwgaXQgaXMgbm90IGp1c3QgbG9ja2RlcCBjb21wbGFpbmluZw0KPiB0aGlz
IGFwcGVhcnMgdG8gYmUgYSByZWFsIGRlYWRsb2NrLCB0aGUgd2lmaSBubyBsb25nZXIgZnVuY3Rp
b25zLCB3aGVyZSBhcyBpdA0KPiBkb2VzIGZ1bmN0aW9uIHdpdGggdGhlIHBhdGNoIGRyb3BzLg0K
PiANCg0KQWdyZWUuDQoNCkpvaGFubmVzLA0KDQpCYXNlZCBvbiB0aGUgbGF0ZXN0IGNoYW5nZXMg
eW91IGludHJvZHVjZWQgaW4gbWFjODAyMTEtbmV4dCwgdGhlIFJUTkwgbG9jayBpcyBub3QgcmVh
bGx5IHJlcXVpcmVkIGFuZCBjYW4gYmUgcmVtb3ZlZC4gV291bGQgdGhpcyBiZSBzdWZmaWNpZW50
LCBvciB3b3VsZCB5b3UgcHJlZmVyIGEgZml4IHJlZ2FyZGxlc3Mgb2YgdGhlc2UgY2hhbmdlcz8N
Cg0KVGhhbmtzIGluIGFkdmFuY2UsDQoNCklsYW4uDQo=
