Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD2311876
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhBFCiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:38:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:31058 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhBFCfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 21:35:54 -0500
IronPort-SDR: eMAZMnK16OdClap+cOFxKXbhW4ES5kLqWtOw1uGsDUVtsgbYk480XTTgllsBzQX/2UBgwm/9RC
 pP2ZEQhP97+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169189020"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169189020"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 18:35:12 -0800
IronPort-SDR: aL4iV7vSHOQzmTj1vwZye2u9VhMhLMXqkd0zW2GmuGTiecyd5lpFunQneJQTRI8YHLAHrBQvrK
 a3n7HfZfjwGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="409480882"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2021 18:35:11 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 18:35:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 18:35:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 5 Feb 2021 18:35:10 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 5 Feb 2021 18:35:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkfE71Kuljiy7P9Jnk9fjLmN5jCcYkj4MmIioFpkoRCvKpwdpW3PEEZyZum+FfXQRjG9DpDffNupaBHTtjTc8ByTolrHxavskyHv/shsOfUnYuAad+3r6T/IDcFlSXhyp8EMIU5vGaD02NYjTVcQoLoFP1IC7dgI+TKdoi5cZryCDXV17a0yHmiZK1RoGxeHE6YYyE4isSwjSx14+k+XLHFrgSDuG6q1lzhzeru8IP2toun33bMhTYB7PiiMzQKguQl7l+5jo2RmWFdrvrN5vBlQH1n+mafifgxWO0qHaDo+wYSaMXsB2aWOaYZpAsCQ1FwG3UZQobZqBKNxrOyrsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWIdQ4aaN0MSuIVYy1tVQAWe8FPeTLQ2odfll7LE26c=;
 b=fyAmXiAifT74a7LvL5CIyPW5dC55ogN7T3VoJAVx8RC4Gk8xAvzPktILVMiO/5YpnWArDL4JKFpe/49rr5GvJG726depaVe61H16460noox1+lqXPTkSjl1/194Hz2nP1yVMyrpJABEm6SxAK/45jO0d8pKnbBNNMd0iJE5/B68wOyi91M7wMKoWkQbSbCle6lxr9g3ZDtP4XcOZqVmhLjvj7rZKW3vYi1YIj3iJJHMzdbuQ0I7usi45ZW8IllnLmpSyuI1rzLdb/E8SFFxsQprX0yXtar+iKBra288jA8M8bSF/0g8insaKq3EPOQqtRwc30iIbz2CwKRB/m+5oNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWIdQ4aaN0MSuIVYy1tVQAWe8FPeTLQ2odfll7LE26c=;
 b=lDKme4+3yRhoD7W7Tw6QNwwS2v18sknisdNYwWXAJ12FGtiUY06gljyj/GNG+UFFZxcEsQ7sEZ83jeroYmoIVbt0hht/AhgqN7ccZcr2TOC4IHngLxyfruqsTRtLTlHxfKHOGmakLp4+zxHz5RBABbaToiKmKWdWmqfq8SK7UAk=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by CO1PR11MB5188.namprd11.prod.outlook.com (2603:10b6:303:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Sat, 6 Feb
 2021 02:35:09 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3825.025; Sat, 6 Feb 2021
 02:35:09 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
Thread-Topic: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
Thread-Index: AQHW9de0gr0N8+nJe0yFDLU+531GYKo/uTAAgAQg1oCAAA77AIAACcIAgAaCyXA=
Date:   Sat, 6 Feb 2021 02:35:08 +0000
Message-ID: <CO1PR11MB510583AD7F1B6ABE20DF0D00FAB19@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
 <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <977ae41c-c547-bc44-9857-24c88c228412@intel.com>
 <20210201143404.7e4a093b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1d73560-63d8-846e-e121-00daef7b2c94@intel.com>
In-Reply-To: <d1d73560-63d8-846e-e121-00daef7b2c94@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37d03b9e-7356-43af-f312-08d8ca47d22b
x-ms-traffictypediagnostic: CO1PR11MB5188:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5188B3E9D495B926CFFB758FFAB19@CO1PR11MB5188.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MoRMYKTDXIKK3cYLc2+AavmSLyOvkOIabB+b6UworTYFeH6XGmiXgnBCor8VFB4OZN4XjgfP2IxJI92lZQjgjNay8wlx9f8cyAIAF1Kr0t7klYID4NW1XBoKM7NRKxzg1m3gwTvn1IpdY9kFS+NMnaLhw9Hk9HFYr7wghm4J5eV7QsSpTMfNGZUFpCnI9OXPakAsim/pzsXw/TG3WrunxU2bhU0jhGLe5aKHoUpB2Eass6i5RnnqP3bL7B4ald/fUtqCqOs/x5EzBaRY6MunNmB2Z9XgJnPbV8A+DXL7k1rpTK0qnMl7Dj+YD3o0W8J8IkaCVVpHwXCWU7HaYwVjHZQUBTHJhPuSs2gXlq6Y/54+SR9ZyZt0mC8MvysIuOgRRV/pIpSewdYLsKt6RxqH0USqNLrDP9UX3iscTWFwXZuVQ3wfnYWDu/uJJl6U+SEBZEWUOgEyRXifM/PqgUUqawNBtA9ZfRM4UL5tEqup3f4zg8n1fIpmOyE0GCSHd4pEdbHni8eqe1AXb99VUZSOjKx5IdGa3cbHzynJslvsJ5asWqKOG++/EY30e2cj9/taTGP4vhcPojhHJafYySb6kZGuCgQ8Ft8i1DUr88e0SCQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(2906002)(86362001)(33656002)(83380400001)(53546011)(6506007)(8676002)(8936002)(76116006)(9686003)(55016002)(478600001)(7696005)(966005)(66476007)(66556008)(64756008)(66446008)(66946007)(4326008)(316002)(5660300002)(186003)(110136005)(52536014)(54906003)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TFJhWlEyV2x4bkp1YlE4eGVEUFkzRG1sVElYR0FlRHd1Ti9GVE1qbi8xUHdH?=
 =?utf-8?B?ZTFiUllmRVhDODN1LzIwcWcyakdUazRneGh4ZnIvcHdnUngyUTk3U05kT2pJ?=
 =?utf-8?B?a1hlUnlrclVMMGo2RmN3TDZkcHdYWTdlS1hpbU52OW9IbS9LSUVESVNJRlpx?=
 =?utf-8?B?aWRpdHZhc1IwM2JGQjBzQnN0UENCdjd6MmorY1R4QVVsVmJyU010TUw2Yi9K?=
 =?utf-8?B?dUJoaXhuSTZFcXpJNHQxM1JYR1FkaWIrL1d1NmZySURTdk1iWFdyRm94QnQ4?=
 =?utf-8?B?cjJ4Zmk0TlhkODdJaTY3VjM5cFkzVkNKVWVYUmJTVkpPc1hnb3pSYmlVbENy?=
 =?utf-8?B?L1hMV0gwUjhDNm9TN2dNMm5HYWFrRVhXc083aEtoUmNWUGZmRmdpejkvQzZW?=
 =?utf-8?B?a0RPOHlSckVpOG5ZNXhQakIvNElrL0lQNE5LblhDVUFkSkJNWUtXUDZoTm1i?=
 =?utf-8?B?Umg5eEVOV2JOVEJxSjlnNDh2U0xVb0cxUFprd0dPaUljczZhQ0lQWlBDN1Zy?=
 =?utf-8?B?d3RlVndMajdFS2hsYnhGVmZBekVCT0VpVGp4ejJoZ2V3bVhYWmhaVUpKaS9K?=
 =?utf-8?B?cjdlTjFqVWZid1pKSmRKMXNlRkZVQktHLzdRTlViS0xBYngwQUZMME1ZUGZU?=
 =?utf-8?B?Zlp3NCsyQ3c3aGh5dVV0ZlNNUjFieW5wYkxFUmxHTE4xWkRsVXRrR0NPMDI2?=
 =?utf-8?B?U3hHQzAwdmhwcUFzclQ1NHVtN3dLWmxOUFQyRVlBWVZLdnRSQkhNVzlOY0Ez?=
 =?utf-8?B?UUwwYThKeVpyelJpNTk3VXBuWVNIbjVabVZyREZQb0NZSm41N0J5VEFIZkp2?=
 =?utf-8?B?MGgzVjNwdi9teGREQzczUUF3aWU4WE5sR3kxeUIvRmN4N0x1VXRtcHlpQTV2?=
 =?utf-8?B?bXhwM09FYWdlVXJEY2lYN2EzY3VObWhIYzV5ZTl3VDdPYUdoelo2cnA5cDNy?=
 =?utf-8?B?aUYvcXdhdnVoTlFUS3YyVDlMM3BRSytEcGlFMTZhOWdETFdSRFVFaVhJOEtB?=
 =?utf-8?B?R20zWVFSRmh6Y04rR2w5K2VlWktha3lQUFloUzBjTndEMHVoaGMyMUR4dTFq?=
 =?utf-8?B?TVJ3cEx5aVdWbkZScjhFZWc5VlhSZUhiNDhRTDJkNjl3c3lHNXBMTElNbWxk?=
 =?utf-8?B?MVdzb3NjV0hMckRsQnZHVmZRTFlwbFFkalBVL3pzbWFrNlJITGNGenRjZE9Q?=
 =?utf-8?B?REFyNGMvNTZIOSt1Q1VINUdHLzFlZmNRSytzK0ZKQkJLR2NZUG9XQ21mMURn?=
 =?utf-8?B?eW5jaU4rbnVNeGdqVXJsV0JwTVJJZnA3UnlIWG9xNzMyTHdXM21KOWJUaTdZ?=
 =?utf-8?B?SlJPMXozZkN0SURuUVdVVk0raUFWVlpNaEYxdm1VM1doZVM5dDZNUHdRZEFC?=
 =?utf-8?B?Ly9OSTBzTHpTYmd2VW1IdVljTUpUV1MzVnZHOVBNL2VwVHRDSXBVcnZtaW1X?=
 =?utf-8?B?K3l1U09vQ1FvZGRTaVJRSVdOakNyckR1QVp2K2JZcDV3aEdOSFpPVWI3UStB?=
 =?utf-8?B?T25kTDc0aU9aR25rQlJvaGplQm1hUzZqZzJESmNmZjZkc3ArRm0vdGt1TlFZ?=
 =?utf-8?B?S2RodEVQNjM3WldVTE4wZlp1QkRFckZKNzJtQWVJWnJUeHJiNjBKdWNWQ2Fx?=
 =?utf-8?B?dG1GTlVYc2pzTEZxdUExSGdxZktsREttOXY0ZWVrYU1rWkJvdFF2NUFpejI5?=
 =?utf-8?B?aGFTNFFzNlhleWowY0NQeTdOakdENTlyTkpLbWxkY1dsa1dNY2c0UFB6eG9K?=
 =?utf-8?Q?1F4NnG1VVupSxCtitMGpzGldGdKdIA2PAcpRCLJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d03b9e-7356-43af-f312-08d8ca47d22b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2021 02:35:08.9235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rXiPF0l+ojDKrs+uIv+Cp/Mh/qW56ZqXaDKTxdgVUih2kL3PuHg4sRJftKp48bzwJoLjfGBT7ykayH8wKFGi9rlq3uOY/NVTxnnQM5OpC2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5188
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+IA0KU2VudDogTW9u
ZGF5LCBGZWJydWFyeSAxLCAyMDIxIDM6MDkgUE0NClRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPg0KQ2M6IE5ndXllbiwgQW50aG9ueSBMIDxhbnRob255Lmwubmd1eWVuQGludGVs
LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHNhc3Nt
YW5uQHJlZGhhdC5jb207IEJyZWxpbnNraSwgVG9ueVggPHRvbnl4LmJyZWxpbnNraUBpbnRlbC5j
b20+DQpTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEwLzE1XSBpY2U6IGRpc3BsYXkgc29t
ZSBzdG9yZWQgTlZNIHZlcnNpb25zIHZpYSBkZXZsaW5rIGluZm8NCg0KDQoNCk9uIDIvMS8yMDIx
IDI6MzQgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBNb24sIDEgRmViIDIwMjEgMTM6
NDA6MjcgLTA4MDAgSmFjb2IgS2VsbGVyIHdyb3RlOg0KPj4gT24gMS8yOS8yMDIxIDEwOjM3IFBN
LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBUaHUsIDI4IEphbiAyMDIxIDE2OjQzOjI3
IC0wODAwIFRvbnkgTmd1eWVuIHdyb3RlOiAgDQo+Pj4+IFdoZW4gcmVwb3J0aW5nIHRoZSB2ZXJz
aW9ucyB2aWEgZGV2bGluayBpbmZvLCBmaXJzdCByZWFkIHRoZSBkZXZpY2UgDQo+Pj4+IGNhcGFi
aWxpdGllcy4gSWYgdGhlcmUgaXMgYSBwZW5kaW5nIGZsYXNoIHVwZGF0ZSwgdXNlIHRoaXMgbmV3
IA0KPj4+PiBmdW5jdGlvbiB0byBleHRyYWN0IHRoZSBpbmFjdGl2ZSBmbGFzaCB2ZXJzaW9ucy4g
QWRkIHRoZSBzdG9yZWQgDQo+Pj4+IGZpZWxkcyB0byB0aGUgZmxhc2ggdmVyc2lvbiBtYXAgc3Ry
dWN0dXJlIHNvIHRoYXQgdGhleSB3aWxsIGJlIA0KPj4+PiBkaXNwbGF5ZWQgd2hlbiBhdmFpbGFi
bGUuDQo+Pj4NCj4+PiBXaHkgb25seSByZXBvcnQgdGhlbSB3aGVuIHRoZXJlIGlzIGFuIHVwZGF0
ZSBwZW5kaW5nPw0KPj4+DQo+Pj4gVGhlIGV4cGVjdGF0aW9uIHdhcyB0aGF0IHlvdSdkIGFsd2F5
cyByZXBvcnQgd2hhdCB5b3UgY2FuIGFuZCB1c2VyIA0KPj4+IGNhbiB0ZWxsIHRoZSB1cGRhdGUg
aXMgcGVuZGluZyBieSBjb21wYXJpbmcgdGhlIGZpZWxkcy4NCj4+DQo+PiBJZiB0aGVyZSBpcyBu
byBwZW5kaW5nIHVwZGF0ZSwgd2hhdCBpcyB0aGUgZXhwZWN0ZWQgYmVoYXZpb3I/IFdlIA0KPj4g
cmVwb3J0IHRoZSBjdXJyZW50bHkgYWN0aXZlIGltYWdlIHZlcnNpb24gYXMgYm90aCBzdG9yZWQg
YW5kIHJ1bm5pbmc/DQo+Pg0KPj4gSW4gb3VyIGNhc2UsIHRoZSBkZXZpY2UgaGFzIDIgY29waWVz
IG9mIGVhY2ggb2YgdGhlIDMgbW9kdWxlczogTlZNLCANCj4+IE5ldGxpc3QsIGFuZCBVTkRJL09w
dGlvblJPTS4NCj4+DQo+PiBGb3IgZWFjaCBtb2R1bGUsIHRoZSBkZXZpY2UgaGFzIGEgYml0IHRo
YXQgaW5kaWNhdGVzIHdoZXRoZXIgaXQgd2lsbCANCj4+IGJvb3QgZnJvbSB0aGUgZmlyc3Qgb3Ig
c2Vjb25kIGJhbmsgb2YgdGhlIGltYWdlLiBXaGVuIHdlIHVwZGF0ZSwgDQo+PiB3aGljaGV2ZXIg
YmFuayBpcyBub3QgYWN0aXZlIGlzIGVyYXNlZCwgYW5kIHRoZW4gcG9wdWxhdGVkIHdpdGggdGhl
IA0KPj4gbmV3IGltYWdlIGNvbnRlbnRzLiBUaGUgYml0IGluZGljYXRpbmcgd2hpY2ggYmFuayB0
byBsb2FkIGlzIGZsaXBwZWQuIA0KPj4gT25jZSB0aGUgZGV2aWNlIGlzIHJlYm9vdGVkIChFTVAg
cmVzZXQpLCB0aGVuIHRoZSBuZXcgYmFuayBpcyBsb2FkZWQsIA0KPj4gYW5kIHRoZSBmaXJtd2Fy
ZSBwZXJmb3JtcyBzb21lIG9uZXRpbWUgaW5pdGlhbGl6YXRpb24uDQo+Pg0KPj4gU28gZm9yIHVz
LCBpbiB0aGVvcnkgd2UgaGF2ZSB1cCB0byAyIHZlcnNpb25zIHdpdGhpbiB0aGUgZGV2aWNlIGZv
ciANCj4+IGVhY2gNCj4+IGJhbms6IHRoZSB2ZXJzaW9uIGluIHRoZSBjdXJyZW50bHkgYWN0aXZl
IGJhbmssIGFuZCBhIHZlcnNpb24gaW4gdGhlIA0KPj4gaW5hY3RpdmUgYmFuay4gSW4gdGhlIGlu
YWN0aXZlIGNhc2UsIGl0IG1heSBvciBtYXkgbm90IGJlIHZhbGlkIA0KPj4gZGVwZW5kaW5nIG9u
IGlmIHRoYXQgYmFua3MgY29udGVudHMgd2VyZSBldmVyIGEgdmFsaWQgaW1hZ2UuIE9uIGEgDQo+
PiBmcmVzaCBjYXJkLCB0aGlzIG1pZ2h0IGJlIGVtcHR5IG9yIGZpbGxlZCB3aXRoIGdhcmJhZ2Uu
DQo+Pg0KPj4gUHJlc3VtYWJseSB3ZSBkbyBub3Qgd2FudCB0byByZXBvcnQgdGhhdCB3ZSBoYXZl
ICJzdG9yZWQiIGEgdmVyc2lvbiANCj4+IHdoaWNoIGlzIG5vdCBnb2luZyB0byBiZSBhY3RpdmF0
ZWQgbmV4dCB0aW1lIHRoYXQgd2UgYm9vdD8NCj4+DQo+PiBUaGUgZG9jdW1lbnRhdGlvbiBpbmRp
Y2F0ZWQgdGhhdCBzdG9yZWQgc2hvdWxkIGJlIHRoZSB2ZXJzaW9uIHdoaWNoDQo+PiAqd2lsbCog
YmUgYWN0aXZhdGVkLg0KPj4NCj4+IElmIEkganVzdCBibGluZGx5IGFsd2F5cyByZXBvcnRlZCB3
aGF0IHdhcyBpbmFjdGl2ZSwgdGhlbiB0aGUgDQo+PiBmb2xsb3dpbmcgc2NlbmFyaW9zIGV4aXN0
Og0KPj4NCj4+ICMgQnJhbmQgbmV3IGNhcmQ6DQo+Pg0KPj4gcnVubmluZzoNCj4+ICAgZncuYnVu
ZGxlX2lkOiBWZXJzaW9uDQo+PiBzdG9yZWQNCj4+ICAgZncuYnVuZGxlX2lkOiA8emVybyBvciBn
YXJiYWdlPg0KPj4NCj4+ICMgRG8gYW4gdXBkYXRlOg0KPj4NCj4+IHJ1bm5pbmc6DQo+PiAgIGZ3
LmJ1bmRsZV9pZDogVmVyc2lvbg0KPj4gc3RvcmVkDQo+PiAgIGZ3LmJ1bmRsZV9pZDogTmV3VmVy
c2lvbg0KPj4NCj4+ICMgcmVzZXQvcmVib290DQo+Pg0KPj4gcnVubmluZzoNCj4+ICAgZncuYnVu
ZGxlX2lkOiBOZXdWZXJzaW9uDQo+PiBzdG9yZWQ6DQo+PiAgIGZ3LmJ1bmRsZV9pZDogVmVyc2lv
bg0KPj4NCj4+DQo+PiBJIGNvdWxkIGdldCBiZWhpbmQgdGhhdCBpZiB3ZSBkbyBub3QgaGF2ZSBh
IHBlbmRpbmcgdXBkYXRlIHdlIHJlcG9ydCANCj4+IHRoZSBzdG9yZWQgdmFsdWUgYXMgdGhlIHNh
bWUgYXMgdGhlIHJ1bm5pbmcgdmFsdWUgKGkuZS4gZnJvbSB0aGUgDQo+PiBhY3RpdmUgYmFuayks
IHdoZXJlIGFzIGlmIHdlIGhhdmUgYSBwZW5kaW5nIHVwZGF0ZSB0aGF0IHdpbGwgYmUgDQo+PiB0
cmlnZ2VyZWQgd2Ugd291bGQgcmVwb3J0IHRoZSBpbmFjdGl2ZSBiYW5rLiBJIGRpZG4ndCBzZWUg
dGhlIHZhbHVlIA0KPj4gaW4gdGhhdCBiZWZvcmUgYmVjYXVzZSBpdCBzZWVtZWQgbGlrZSAiaWYg
eW91IGRvbid0IGhhdmUgYSBwZW5kaW5nIA0KPj4gdXBkYXRlLCB5b3UgZG9uJ3QgaGF2ZSBhIHN0
b3JlZCB2YWx1ZSwgc28ganVzdCByZXBvcnQgdGhlIGFjdGl2ZSANCj4+IHZlcnNpb24gaW4gdGhl
IHJ1bm5pbmcNCj4+IGNhdGVnb3J5IikNCj4+DQo+PiBJdCdzIGFsc28gcGxhdXNpYmx5IHVzZWZ1
bCB0byByZXBvcnQgdGhlIHN0b3JlZCBidXQgbm90IHBlbmRpbmcgdmFsdWUgDQo+PiBpbiBzb21l
IGNhc2VzLCBidXQgSSByZWFsbHkgZG9uJ3Qgd2FudCB0byByZXBvcnQgemVyb3Mgb3IgZ2FyYmFn
ZSANCj4+IGRhdGEgb24gYWNjaWRlbnQuIFRoaXMgd291bGQgYWxtb3N0IGNlcnRhaW5seSBsZWFk
IHRvIGNvbmZ1c2luZyANCj4+IHN1cHBvcnQgY29udmVyc2F0aW9ucy4NCj4gDQo+IFZlcnkgZ29v
ZCBwb2ludHMuIFBsZWFzZSBzZWUgdGhlIGRvY3VtZW50YXRpb24gZm9yIGV4YW1wbGUgd29ya2Zs
b3c6DQo+IA0KPiBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9uZXR3b3Jr
aW5nL2RldmxpbmsvZGV2bGluay1mbGFzDQo+IGguaHRtbCNmaXJtd2FyZS12ZXJzaW9uLW1hbmFn
ZW1lbnQNCj4gDQo+IFRoZSBGVyB1cGRhdGUgYWdlbnQgc2hvdWxkIGJlIGFibGUgdG8gcmVseSBv
biAnc3RvcmVkJyBmb3IgY2hlY2tpbmcgaWYgDQo+IGZsYXNoIHVwZGF0ZSBpcyBuZWVkZWQuDQo+
IA0KPiBJZiB0aGUgRlcgdXBkYXRlIGlzIG5vdCBwZW5kaW5nIGp1c3QgcmVwb3J0IHRoZSBzYW1l
IHZhbHVlcyBhcyBydW5uaW5nLg0KPiBZb3Ugc2hvdWxkIG5vdCByZXBvcnQgb2xkIHZlcnNpb24g
YWZ0ZXIgMiBmbGFzaGluZ3MgKDNyZCBvdXRwdXQgaW4gDQo+IHlvdXINCj4gZXhhbXBsZSkgLSB0
aGF0J2QgY29uZnVzZSB0aGUgZmxvdyAtIGFzIHlvdSBzYWlkIC0gdGhlIHN0b3JlZCB2ZXJzaW9u
cyANCj4gd291bGQgbm90IGJlIHdoYXQgd2lsbCBnZXQgYWN0aXZhdGVkLg0KPiANCg0KU3VyZSwg
b2suIEkgY2FuIGFkZCB0aGF0IHdoZW4gaW1wbGVtZW50aW5nIHRoaXMgaW4gdGhlIHYyIHN1Ym1p
c3Npb24gKGFsb25nIHdpdGggZXh0cmFjdGluZyB0aGUgc2VjdXJpdHkgcmV2aXNpb24gcGF0Y2hl
cyB0byBhIHNlcGFyYXRlIHNlcmllcykuDQoNClRoYW5rcywNCkpha2UNCg0KLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpJ
IHRlc3RlZCB0aGlzIHJldmlzaW9uOg0KVGVzdGVkLWJ5OiBUb255IEJyZWxpbnNraSA8dG9ueXgu
YnJlbGluc2tpQGludGVsLmNvbT4gQSBDb250aW5nZW50IFdvcmtlciBhdCBJbnRlbA0K
