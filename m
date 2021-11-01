Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3387E441430
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhKAHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:32:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:15086 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhKAHcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 03:32:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="254566956"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="254566956"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 00:29:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="488532468"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 01 Nov 2021 00:29:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 1 Nov 2021 00:29:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 1 Nov 2021 00:29:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 1 Nov 2021 00:29:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5cTY7fOXopVndAx887DWlCIm2Y2m4h1sr/j7E+Y8xAvDsqOsk80AI2CaHuhNEpT3/l2eChEkf2pQzeFTg1h7WJnr5rpALi9R5cyogdF5g9RqyBggwE8tpXSNiBnTwpo1yMTJtX/Kjnshb196/lmWH1lPdCHZIhhZZ5dfLsYtkXpFvs6FUqUDSUSJMWb0ruoOsy0FYt3j+qqUcNVhoV1FZUtkpuZiouUFJ0rkIYXWEhQgiEM6aTgAg9Q524ElTqp7EgFogVKDw9uNY+Tme1IpKph2CPAOVZrPRkZ9LY01yPvScyy43TuY0EVLFldmAh8aiEWE/SUgZ02JZ5fHb+cbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVSzPmiOTER7yGVp9TUfg8Ntx/84h9ui5PvzzsZtQQw=;
 b=UDnajFZ8hl0Rs1Yt2/aKCBtM7Fjls5fltqKJkRysGVqp5p2k/vz9ZZPRsqU74jH86IagXpgEM9WXQK5E+etQIxys1m27cXmIIq+1s1FizLtoDrWc9ZPeL1kMAgps7PaHiyRiop8yYYpp4pV9gxEmE4wOHQKDZPj0a/4iyycZmE+3QnvS+KsaIQCVGYM/pJ2I6LNWOCVfkiuxxkqg3QJKMlC2LbV9bbgb2W9gKLwIDB5n+kP+eJ/Q4eKjYTajDcjs3DDVlENGXiaiy0Y5HFdTGBFrBjS/fc3z/e/0U+jN1FiV+PrmWhAyN4bqngiPLOot0AipoKRByX7XDy9pKHObWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVSzPmiOTER7yGVp9TUfg8Ntx/84h9ui5PvzzsZtQQw=;
 b=jYAnfhvF9tyLHXLkrJP4Ltu3jnIFmetqNMNpf2w6So3UAw3AGMvepH5aA7tQBT9iuVrdUyWn/sNtG86fGlyTNu3sJJFvba+qSumhNHKOzMZD4NyyYxR3W7Eyh1GUuEANzwzbKw+lCfVvAOyVy51OkFZ/ToXz1XxX3M5B6A7jvRk=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2647.namprd11.prod.outlook.com (2603:10b6:a02:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 07:29:29 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 07:29:29 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "arnd@kernel.org" <arnd@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Baruch, Yaara" <yaara.baruch@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Gottlieb, Matti" <matti.gottlieb@intel.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: pcie: fix constant-conversion warning
Thread-Topic: [PATCH] iwlwifi: pcie: fix constant-conversion warning
Thread-Index: AQHXzNu91lvhoHPzmEaAAhHmpvVRJavssg70gAGYogA=
Date:   Mon, 1 Nov 2021 07:29:29 +0000
Message-ID: <4e1abf0c252ed1f049e1be77247626af369aa5e8.camel@intel.com>
References: <20211029154253.3824677-1-arnd@kernel.org>
         <87tugx3c7f.fsf@codeaurora.org>
In-Reply-To: <87tugx3c7f.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0-2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff49182b-0bb3-42b5-ffd5-08d99d095750
x-ms-traffictypediagnostic: BYAPR11MB2647:
x-microsoft-antispam-prvs: <BYAPR11MB26474DAAF92DE965B6A63059908A9@BYAPR11MB2647.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bTrKCl/185/bMq8AR+xcKRmKI7WcnSW2VzoG1wR9JGvVV2DDapDmCTl+XwQgcMfPWl3dU4Ju6Eq8TpUEJ6h16Lry55IzhWViDjPxdJAPZ4KVIyCk/POmm47bujvCdunvL8ZeiNCV14LVb6AsCx4jKKjcLv6YjhXCHDIIv6361DRm7CBlD2qfWvlalA4LXVdRXzLT/W0kZdKuczNKHNqkAFCCf4/92bZOUHM7Fp9QOP2hIwevLJVSdmfpDGzZK00gFN5YLQ8doyCkDN18FbquROb3PqLj9gzLJriVGB9gPR+OXhMx8e9rPLcxRMXWSKVn0ZD+IQOir6a98ceASRF0VN80sbgwmnpZvRCnr3quoAzVXu6nW2bRRj9oE7lntiEuU4ovc1dxLw/a5cMJ+AD2iSc0Me60WX8wWR5QzGUuAQzda0NiL1ZlrKg2TIrLt9cmYb+yfgKfZpDsLmfX2A2JtherRoyns00WSmrummEA0p9kcoDgvIZsNup9zQLeZRDnjCYZcuuZXzFCHY3WCb0nRxft26r/wK14d3HILrz4bBkh+FjAH9ez0SfU/62riRqaR8IxAl4+W9EZXDYJ4hUob3PV0mWVGP1JkXvbrXOi5GbJ+g+ILNUxYACn6hML/dv29EfbxoOsotYY2vke/T8HCapgR5OtuuvCXLAd42XAkQLHQ7ZumXxLUpSAhcZbHoLCjHWMip3K/ZXXMIUBi1B3GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(54906003)(316002)(110136005)(66476007)(91956017)(4326008)(8936002)(7416002)(36756003)(6486002)(8676002)(66556008)(38070700005)(66946007)(2906002)(76116006)(66446008)(64756008)(82960400001)(6506007)(122000001)(26005)(4001150100001)(71200400001)(6512007)(38100700002)(86362001)(2616005)(508600001)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFpBb29YRDFJVDBickhlc05UeCs4QWx6endDcWh2ZytmNUd2clpxSU94dkRZ?=
 =?utf-8?B?aGZwcjM5ZHlqRDdMN1VoSXlYem8wdXlabUFCQU1RdW85bHllS0FwUnZjMDBN?=
 =?utf-8?B?MDg4d0hUMUQvMFAwVDBSR2hHNkhtaWZBS2tncDhFRmZmY1czV09xZlRLaFpq?=
 =?utf-8?B?QWhGSnZsVmN4NDJvcDFMT0RoK0dXYmo2K21waHdKVWk2VWJ1Y1kvUFM4bjFT?=
 =?utf-8?B?TDJQSUc5NEM0WEVOWmlxWGRvM0pBbDdpYlVYOEdpUFpwSit4RkkxU0UxYklQ?=
 =?utf-8?B?bGYxVTBoUUxONDFNZ2kyZHhDZXc3aDJydDBLeGw4WW1RL0ZFb1lsTEd6SkpZ?=
 =?utf-8?B?TmxRZUFva1ZpTEVYUlI2YTU0VzRaMStWb2ZYSDc5M25DZ0lRempITTRKN2py?=
 =?utf-8?B?NUpVQ1N6MmV4QWQ4ZU5qMFVaaXFhU1I4MmlJVTByWkNMU0R5YUo4N0tYekJR?=
 =?utf-8?B?OVdxOGV4Yjg2MUUwa051MldXOGlwaEpVYjlIQVlPaWxESnBSZzY4YmZSWUUv?=
 =?utf-8?B?NjRDYmtrV2FoMUZ5SlZtZFhTNHVPR3NhQitacEVSdytqMmFQNmxhdzBQdUg3?=
 =?utf-8?B?eDFKVXRpOEdLLzVPOE9jUmdjK2t3czczcFpVclZEWVIvdUg3eGhqRjFKSzFh?=
 =?utf-8?B?dkVqTDJKSkdVMFp3UmtmcnBYUy8vUW1uOWtmTHo0ODV2RWZSRUc0emFOSkRB?=
 =?utf-8?B?bTVIZHFTbUM1VzFaZXpISldPNW5pS2RNa1JBUzNmZVd5aWJEZS9qcFlFUFFw?=
 =?utf-8?B?UmpheTYyTWNKTmNHeHQ1cUFtY0VNNXhUaU9naitOUTFkUW0rMmlvdG8rMzJ3?=
 =?utf-8?B?TWR6bm0yanREcm1JWFN1YVdiNXNvd1I1OEE5SytKQW93REFqWUw4Nzl2bHpI?=
 =?utf-8?B?SXE1cFdlUkwrZDBSbEY2Z2w4bE9hU1R3STloYnc4RWFyUG1oSUJJalNZNE1T?=
 =?utf-8?B?bTMxdTBhZjdNWEZSUDNhSDlCZlFrNjVjMWlxUWk0Q3JRWTBrMmg0cTVYands?=
 =?utf-8?B?UkozUkduTXBmYTFtV2w2V1A1WHdmaFhKUWpFTHJyY0toclNiS0lBZGcxT2g0?=
 =?utf-8?B?VXF1d3E1dUJ4RGp6NFVsMSt1eXV5MmJTc1pWTkNMbTF1cmxPZllyQjA2QzhX?=
 =?utf-8?B?b082ZFNvRTNDc0JxSk1lQlhtRVV3OVdqN3lBSG5oR21iam5PS2V3RWtiaXBX?=
 =?utf-8?B?YkdWS28wTU44bXQyN0Ywd0Nab3N5VjFqSDlkUHdSaVlsMUU5Z0x3U1FmcmY5?=
 =?utf-8?B?TDVXZXZaelNzM0JFZ2JVdDRMS0UzbVQ4V3dIS09aVUdrS0JFakRNYXE0U2w2?=
 =?utf-8?B?bTlEWXNEQlpSejI5T3dwRzdmVnYwOFhSbWdybHU0Q0poQ3MxK1ovUWN6OTB4?=
 =?utf-8?B?TFBadWt6ZW5WRU13TEx3c0wxRkJpV1ZreWZSQ09PQ0hQWFE4S1g5ckNvWStt?=
 =?utf-8?B?cGVhT285d0pUZWF1YmZlWjFPZXd2ZHhYM2tkU2JxRU1GS0ZFbE9KZHJ3c2Ev?=
 =?utf-8?B?dnJvcWJDWG9ZZlR5anhsOXFuMklNclRKb20xejdZa0F2MllXTDQrVFJ1dXdD?=
 =?utf-8?B?U2ZwUkJsaXBlQU5WZk82Tk1pZC8vTTdaQVVEdnVxbzhrQWhCaVFyL3pRZXk3?=
 =?utf-8?B?Smo3ekJMcWNVQy81eUxmTGFkS2lHZHdhUHo3SmF6ZVhQeHpXL3owZ3BHdkpw?=
 =?utf-8?B?VVZyMGZ4Y1lYZTdESHFVeXdCOE9KY0xKYnRIeXo3aVhnaFpScUdjc2RTcFRp?=
 =?utf-8?B?WHE3UzhXL29INnN0Q2ZOL1gxQjYrMEtaMEhkMlgyTHRodlk5MUlkVnd1ZTNT?=
 =?utf-8?B?NEppdW9UdEo2NkdDZE02eFNSaFJrWHQ0d1Q3ZEJKcVltUzJtQWxhTHlqNmRG?=
 =?utf-8?B?ZS9CTXcvMm9Id2VoYkp6RHl6SmVJMmZOaTladVhTR3p4Ykt1S1VJUzAvZU9C?=
 =?utf-8?B?Zy80aGRaY25ubUYvTVljNm1SWHRET24xVmp2SXJVV3pUR212OVJUWG1sRjBC?=
 =?utf-8?B?cGhmcXlUUmRRa0pnQnpMaC9sUzNLZU9yUDJOMkZabXQ4ZkZ6NnhDUWRKbEx4?=
 =?utf-8?B?N1B6dUIwa1pOTkNsWm0wQU5jekQzSnYrOEhEcXUvcDNqRDFVNXJ1N3pOT1gx?=
 =?utf-8?B?emUwTmdVNEZ4MFpTc0JLRVFZVVZPZUxwZllhb0d3WThMZjh6aVlLampaRGdv?=
 =?utf-8?B?ck45RUJ5a3BIaFpJY3N5N3YwZldjMVhuL3FyNGNyTFNxMkdoQnFSa2hwTUth?=
 =?utf-8?Q?42nCb18tXzVoQTOE0KYX+LXyYs4zB5zb7IxPjjg9C0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5437A219551C444A83CB03058B02A8CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff49182b-0bb3-42b5-ffd5-08d99d095750
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 07:29:29.3929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +lSoPQqNBVA0hsYH+04Y4saWUr6z6hBOLXyeplNUgzu9/lclN8iet1HVM7siPbdHopxTnlftI4IGUdaFq29LREPfAQ36LAk386ewjeCa+qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2647
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTEwLTMxIGF0IDA5OjA2ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBB
cm5kIEJlcmdtYW5uIDxhcm5kQGtlcm5lbC5vcmc+IHdyaXRlczoNCj4gDQo+ID4gRnJvbTogQXJu
ZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPiANCj4gPiBjbGFuZyBwb2ludHMgb3V0IGEg
cG90ZW50aWFsIGlzc3VlIHdpdGggaW50ZWdlciBvdmVyZmxvdyB3aGVuDQo+ID4gdGhlIGl3bF9k
ZXZfaW5mb190YWJsZVtdIGFycmF5IGlzIGVtcHR5Og0KPiA+IA0KPiA+IGRyaXZlcnMvbmV0L3dp
cmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS9kcnYuYzoxMzQ0OjQyOiBlcnJvcjogaW1wbGljaXQg
Y29udmVyc2lvbiBmcm9tICd1bnNpZ25lZCBsb25nJyB0byAnaW50JyBjaGFuZ2VzIHZhbHVlIGZy
b20gMTg0NDY3NDQwNzM3MDk1NTE2MTUgdG8gLTEgWy1XZXJyb3IsLVdjb25zdGFudC1jb252ZXJz
aW9uXQ0KPiA+ICAgICAgICAgZm9yIChpID0gQVJSQVlfU0laRShpd2xfZGV2X2luZm9fdGFibGUp
IC0gMTsgaSA+PSAwOyBpLS0pIHsNCj4gPiAgICAgICAgICAgICAgICB+IH5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5efn4NCj4gPiANCj4gPiBUaGlzIGlzIHN0aWxsIGhhcm1sZXNzLCBh
cyB0aGUgbG9vcCBjb3JyZWN0bHkgdGVybWluYXRlcywgYnV0IGFkZGluZw0KPiA+IGFuIChpbnQp
IGNhc3QgbWFrZXMgdGhhdCBjbGVhcmVyIHRvIHRoZSBjb21waWxlci4NCj4gPiANCj4gPiBGaXhl
czogM2Y3MzIwNDI4ZmE0ICgiaXdsd2lmaTogcGNpZTogc2ltcGxpZnkgaXdsX3BjaV9maW5kX2Rl
dl9pbmZvKCkiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIu
ZGU+DQo+IA0KPiBMdWNhLCBjYW4gSSB0YWtlIHRoaXMgdG8gd2lyZWxlc3MtZHJpdmVycz8gQWNr
Pw0KDQpZZXMsIHBsZWFzZSBkby4NCg0KVGhhbmtzLg0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8g
PGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
