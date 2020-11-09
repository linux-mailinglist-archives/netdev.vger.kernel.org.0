Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E7D2AC80A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgKIWIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:08:53 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:62145 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIWIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:08:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=10276; q=dns/txt;
  s=iport; t=1604959732; x=1606169332;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9rUYIHLSIzHwNNFBPU2leEjlM26hHceu7x4xJxPk3WI=;
  b=FliZcnT83xx5Od4A6Uzs3T+6m4yoeFQm4zQNWbuarkrPYw/Hx/sTcPjW
   uEVPBe7n/tDXRypONgSFQ3UYjygA1+cthk9ysSj3GqUz/NApFPrva7Nqe
   3GI8okPedPkJfLjJvI2oAs4ELICVaJZxzdb9c8wdgGoTPsBWL+dO80rwv
   o=;
X-IPAS-Result: =?us-ascii?q?A0DeAADovKlffY0NJK1iGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQIFPgVJRgVQvLgqEM4NJA40mLoEFl3yCUwNUCwEBAQ0BAS0CB?=
 =?us-ascii?q?AEBhEoCF4F7AiU4EwIDAQEBAwIDAQEBAQUBAQECAQYEFAEBhjwMhXMBAQEDE?=
 =?us-ascii?q?hEEDQwBATcBDwIBCA4KAgImAgICMBUQAgQNAQUCAQEegwSCVgMuAaMsAoE7i?=
 =?us-ascii?q?Gh2fzODBAEBBYUOGIIQCYEOKoJzg3WGVxuBQT+BESeCNjU+hD4XgwCCX5MoP?=
 =?us-ascii?q?YdDnQIKgm2PbYsUBQcDH4MYihKURrQUAgQCBAUCDgEBBYFrIYFZcBWDJFAXA?=
 =?us-ascii?q?g2OHzeDOopYdDgCBgoBAQMJfIsILYEGAYEQAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3A29L/gRLWnH3l6CktHNmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeGvKs/j1LTW4jfrfVehLmev6PhXDkG5pCM+DAHfYdXXh?=
 =?us-ascii?q?AIwcMRg0Q7AcGDBEG6SZyibyEzEMlYElMw+Xa9PBtWFdz4almUpWe9vnYeHx?=
 =?us-ascii?q?zlPl9zIeL4UofZk8Ww0bW0/JveKwVFjTawe/V8NhKz+A7QrcIRx4BlL/U8?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.77,464,1596499200"; 
   d="scan'208";a="606172146"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 09 Nov 2020 22:08:51 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 0A9M8o25026311
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 9 Nov 2020 22:08:51 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 16:08:50 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Nov
 2020 16:08:49 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 9 Nov 2020 16:08:49 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFIWw3YUVQNctjDFnAWOT91Y+JXFomST8WGpKA67H5gHLLtyrtdoyHD1zspjdfiI8W25ZdCPsZw+1Cea9jwpGTE0JeyZvNKkHJOUo4aoaaTKNCghCoRGvJ6LoGk2NK8KQAYXaJXo0YPJu+xBnG/HNDzmifhU7G8g1oMRjZnVE/J6T1cxW8yH3B6apbZlCidgAWsdtoMhsH0/2JdNaZl0hASYZutP0eWG3LR0QZMq0LaO+SSwRGf8ZL/g6qAwqMNCeb1WBuRAFUIG7fxGCtqXd5HZbJp9JhxRUVXoOxV1c4BP406pvgqbKaChMkgwa+ASo6rYzALbP/bv84jpQLhTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rUYIHLSIzHwNNFBPU2leEjlM26hHceu7x4xJxPk3WI=;
 b=jnzk+FMByU4SC+RJG5RhXlYvEi92onGxgWeEBHpdUO/Frx8AfQAjwFuHfdLc9GCnaJVuYinIvcCGhON8WDS+UsNHC039uakLr09C06WUxtaY1ednHuBUChkoKV9zrvcKTLjhiwxJLHxqSjZkup1iWOTNPhTA4j1Egw5AF56PcMWjoKz0QdZNBlqxqvZFNyWholX8Zlgx/qBfRT6Uhe/G/hedNv8e57OnbBau8728CK3eH4Q58oHJgYi1xfd2moUHIBAweEvXXjhIiO1kSIzN8p3VXd/r6UwknI/lE4xIoVl6rfRXhGcbUwlkHvXbXq3vt4Ly4H+qkxqLcKrmgObg+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rUYIHLSIzHwNNFBPU2leEjlM26hHceu7x4xJxPk3WI=;
 b=vtvNLdnpWjYSfF7AfUwc70ugICSRpK317N3KdL0I+S4o0KwE8KqiJX1cH7tyKvAk0bvxTjPIPJ9UuVzSXlo4Rf7pqtg2hOJZN6nJ2MI+TM6yeCZGZ/wrhYPEqbyK0USgrgcKJiOcb10IHwlTee8OKyp6mCMmyo8MBJe08/bT/14=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by BL0PR11MB2962.namprd11.prod.outlook.com (2603:10b6:208:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Mon, 9 Nov
 2020 22:08:48 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2%5]) with mapi id 15.20.3541.024; Mon, 9 Nov 2020
 22:08:48 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net v3] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Topic: [PATCH net v3] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Index: AQHWto7mqgRvhHgkpESfSBlUpJUFkKnARrSAgAAV+IA=
Date:   Mon, 9 Nov 2020 22:08:47 +0000
Message-ID: <3c81d2ae-ba14-60d8-247d-87fabf407fea@cisco.com>
References: <20201109115249.14491-1-geokohma@cisco.com>
 <20201109125009.5e54ec8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109125009.5e54ec8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [173.38.220.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20ee34aa-fed4-458e-ad4c-08d884fc0872
x-ms-traffictypediagnostic: BL0PR11MB2962:
x-microsoft-antispam-prvs: <BL0PR11MB296291B19ADB2769D38C7858CDEA0@BL0PR11MB2962.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jKP/VgZjjEAUzr1P7V1SKwbGdiDDFN55CRrzgP4i7pmRIHHQI/CRWlSOEfATf0iFjAJQ0LXmGMwGZ+qa5fxszmGK/Lxt9GnHeTzk3+Z3juAomfGbxhUnSrnA1E6UrsVNnRPuQQy0+Jgyz6yBV+mkLI8PySLqN4DKclOtJxOjojkKAby604pwUOy+CCz6gEAt1fUEV8Q3tHrX8aCZNoWxvuyjS//T13jZwpVNMXFYMEELJrizNwcklcKg/TL0zb78gEwR9OSq8+3NIPmHRp4PpKHwN46ZmsN0UZ4Qy51IalWmPew410kRMBIo3GgTkEIT+8DlkIwVDguKkFl/MLkzRUgLDA6go7aQzLxVIxRc5U4CLoBotZM1KaHK51Ys+7wS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(5660300002)(31696002)(2906002)(186003)(53546011)(6506007)(4326008)(2616005)(31686004)(7416002)(316002)(71200400001)(86362001)(36756003)(66556008)(64756008)(66446008)(66946007)(76116006)(54906003)(26005)(91956017)(83380400001)(6916009)(478600001)(8676002)(6486002)(8936002)(6512007)(66476007)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: n5HC1Idtesu2xplbb6Hm3MFjyTMpC52P073bd7HfcL4CxwMud6jmXKTGIvik0N0Q8ifJorMoTAiZLYgpeAPm2ptqddUVTrTOzaq8Pd5Rb1PzIbhmWcfZir80l1L07UqGCVqeWzJ6hBuAfvANC2Ly+d3KEeiy2xqMGW1GCs2PRhsQ3RhGaDyJgUvBV9olt2sarahRjIrpIsU4HfzLO/QQ3aukzQc3V3FXlL7dZfT/bz1lAW3pAExC36j4u0p22Ej4Frnbp9+RqGSX+vE3fSb7OWxhZA/wuWgD6RJDao0Zlyp18Is8GWOkEtc+a5LfnsjGo+ng8j3ql2t8u1mOCTFC0QdEkwHPO42TUQEe/SAWt+3lyabjcoQEYpwk1O8soiaThA+COg/hJS06ea2jU4mYVIr9cvz/c+aQygIgtJJt4fgyGJJYG+S1q3srrgfkQhWhfBYPsxQvAsoT0dBw7qTiZB3AbXCYvhZ9Ij5JKVwWDxZMNitNUHcfeOWPmOxbtZ1kAGUf2i09X6FQv9OdbgGGADa2jWL9zBsy3oszd6Vt4tZTRJMbjZAOc/N62CQOdtPeaiR4b9QN7XmOZ3nFXatEu4+ACQHYiLT/8jocwFCr4i/9MOMSdIKXHLmF033TdYKD8i2hoR/CuN5g+9NGbsDRdA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6223B2A5E3376B4CBC5B834F6FDADD7A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ee34aa-fed4-458e-ad4c-08d884fc0872
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 22:08:47.9934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gtIHUl1K4JrCTr+7Z+z/VaW5Z9IrOAa30uvlikJ7bVLxYHkf3v1zo9H+i5LIMNJwRyc+VHTsBF6zhOkWx2qYyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2962
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMTEuMjAyMCAyMTo1MCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIE1vbiwgIDkg
Tm92IDIwMjAgMTI6NTI6NDkgKzAxMDAgR2VvcmcgS29obWFubiB3cm90ZToNCj4+IFBhY2tldHMg
YXJlIHByb2Nlc3NlZCBldmVuIHRob3VnaCB0aGUgZmlyc3QgZnJhZ21lbnQgZG9uJ3QgaW5jbHVk
ZSBhbGwNCj4+IGhlYWRlcnMgdGhyb3VnaCB0aGUgdXBwZXIgbGF5ZXIgaGVhZGVyLiBUaGlzIGJy
ZWFrcyBUQUhJIElQdjYgQ29yZQ0KPj4gQ29uZm9ybWFuY2UgVGVzdCB2NkxDLjEuMy42Lg0KPj4N
Cj4+IFJlZmVycmluZyB0byBSRkM4MjAwIFNFQ1RJT04gNC41OiAiSWYgdGhlIGZpcnN0IGZyYWdt
ZW50IGRvZXMgbm90IGluY2x1ZGUNCj4+IGFsbCBoZWFkZXJzIHRocm91Z2ggYW4gVXBwZXItTGF5
ZXIgaGVhZGVyLCB0aGVuIHRoYXQgZnJhZ21lbnQgc2hvdWxkIGJlDQo+PiBkaXNjYXJkZWQgYW5k
IGFuIElDTVAgUGFyYW1ldGVyIFByb2JsZW0sIENvZGUgMywgbWVzc2FnZSBzaG91bGQgYmUgc2Vu
dCB0bw0KPj4gdGhlIHNvdXJjZSBvZiB0aGUgZnJhZ21lbnQsIHdpdGggdGhlIFBvaW50ZXIgZmll
bGQgc2V0IHRvIHplcm8uIg0KPj4NCj4+IFRoZSBmcmFnbWVudCBuZWVkcyB0byBiZSB2YWxpZGF0
ZWQgdGhlIHNhbWUgd2F5IGl0IGlzIGRvbmUgaW4NCj4+IGNvbW1pdCAyZWZkYWFhZjg4M2EgKCJJ
UHY2OiByZXBseSBJQ01QIGVycm9yIGlmIHRoZSBmaXJzdCBmcmFnbWVudCBkb24ndA0KPj4gaW5j
bHVkZSBhbGwgaGVhZGVycyIpIGZvciBpcHY2LiBXcmFwIHRoZSB2YWxpZGF0aW9uIGludG8gYSBj
b21tb24gZnVuY3Rpb24sDQo+PiBpcHY2X2ZyYWdfdmFsaWRhdGUoKS4gQSBjbG9zZXIgaW5zcGVj
dGlvbiBvZiB0aGUgZXhpc3RpbmcgdmFsaWRhdGlvbiBzaG93DQo+PiB0aGF0IGl0IGRvZXMgbm90
IGZ1bGxmaWxsIGFsbCBhc3BlY3RzIG9mIFJGQyA4MjAwLCBzZWN0aW9uIDQuNSwgYnV0IGlzIGF0
DQo+PiB0aGUgbW9tZW50IHN1ZmZpY2llbnQgdG8gcGFzcyBtZW50aW9uZWQgVEFISSB0ZXN0Lg0K
Pj4NCj4+IEluIG5ldGZpbHRlciwgdXRpbGl6ZSB0aGUgZnJhZ21lbnQgb2Zmc2V0IHJldHVybmVk
IGJ5IGZpbmRfcHJldl9maGRyKCkgdG8NCj4+IGxldCBpcHY2X2ZyYWdfdmFsaWRhdGUoKSBzdGFy
dCBpdCdzIHRyYXZlcnNlIGZyb20gdGhlIGZyYWdtZW50IGhlYWRlci4NCj4+DQo+PiBSZXR1cm4g
MCB0byBkcm9wIHRoZSBmcmFnbWVudCBpbiB0aGUgbmV0ZmlsdGVyLiBUaGlzIGlzIHRoZSBzYW1l
IGJlaGF2aW91cg0KPj4gYXMgdXNlZCBvbiBvdGhlciBwcm90b2NvbCBlcnJvcnMgaW4gdGhpcyBm
dW5jdGlvbiwgZS5nLiB3aGVuDQo+PiBuZl9jdF9mcmFnNl9xdWV1ZSgpIHJldHVybnMgLUVQUk9U
Ty4gVGhlIEZyYWdtZW50IHdpbGwgbGF0ZXIgYmUgcGlja2VkIHVwDQo+PiBieSBpcHY2X2ZyYWdf
cmN2KCkgaW4gcmVhc3NlbWJseS5jLiBpcHY2X2ZyYWdfcmN2KCkgd2lsbCB0aGVuIHNlbmQgYW4N
Cj4+IGFwcHJvcHJpYXRlIElDTVAgUGFyYW1ldGVyIFByb2JsZW0gbWVzc2FnZSBiYWNrIHRvIHRo
ZSBzb3VyY2UuDQo+Pg0KPj4gUmVmZXJlbmNlcyBjb21taXQgMmVmZGFhYWY4ODNhICgiSVB2Njog
cmVwbHkgSUNNUCBlcnJvciBpZiB0aGUgZmlyc3QNCj4+IGZyYWdtZW50IGRvbid0IGluY2x1ZGUg
YWxsIGhlYWRlcnMiKQ0KPiBuZXcgbGluZSBoZXJlLCBzaW5jZSB0aGUgbGluZSBhYm92ZSBpcyBu
b3QgcmVhbGx5IGEgdGFnLg0KPg0KPj4gU2lnbmVkLW9mZi1ieTogR2VvcmcgS29obWFubiA8Z2Vv
a29obWFAY2lzY28uY29tPg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwdjYuaCBiL2lu
Y2x1ZGUvbmV0L2lwdjYuaA0KPj4gaW5kZXggYmQxZjM5Ni4uNDg5ZjNmOSAxMDA2NDQNCj4+IC0t
LSBhL2luY2x1ZGUvbmV0L2lwdjYuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQvaXB2Ni5oDQo+PiBA
QCAtMTA2NCw2ICsxMDY0LDggQEAgaW50IGlwdjZfc2tpcF9leHRoZHIoY29uc3Qgc3RydWN0IHNr
X2J1ZmYgKiwgaW50IHN0YXJ0LCB1OCAqbmV4dGhkcnAsDQo+PiAgDQo+PiAgYm9vbCBpcHY2X2V4
dF9oZHIodTggbmV4dGhkcik7DQo+PiAgDQo+PiArYm9vbCBpcHY2X2ZyYWdfdmFsaWRhdGUoc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgaW50IHN0YXJ0LCB1OCAqbmV4dGhkcnApOw0KPj4gKw0KPj4gIGVu
dW0gew0KPj4gIAlJUDZfRkhfRl9GUkFHCQk9ICgxIDw8IDApLA0KPj4gIAlJUDZfRkhfRl9BVVRI
CQk9ICgxIDw8IDEpLA0KPj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L2V4dGhkcnNfY29yZS5jIGIv
bmV0L2lwdjYvZXh0aGRyc19jb3JlLmMNCj4+IGluZGV4IGRhNDZjNDIuLjdhOTRmZGYgMTAwNjQ0
DQo+PiAtLS0gYS9uZXQvaXB2Ni9leHRoZHJzX2NvcmUuYw0KPj4gKysrIGIvbmV0L2lwdjYvZXh0
aGRyc19jb3JlLmMNCj4+IEBAIC0yNzgsMyArMjc4LDQ2IEBAIGludCBpcHY2X2ZpbmRfaGRyKGNv
bnN0IHN0cnVjdCBza19idWZmICpza2IsIHVuc2lnbmVkIGludCAqb2Zmc2V0LA0KPj4gIAlyZXR1
cm4gbmV4dGhkcjsNCj4+ICB9DQo+PiAgRVhQT1JUX1NZTUJPTChpcHY2X2ZpbmRfaGRyKTsNCj4+
ICsNCj4+ICsvKiBWYWxpZGF0ZSB0aGF0IHRoZSB1cHBlciBsYXllciBoZWFkZXIgaXMgbm90IHRy
dW5jYXRlZCBpbiBmcmFnbWVudC4NCj4+ICsgKg0KPj4gKyAqIFRoaXMgZnVuY3Rpb24gcmV0dXJu
cyBmYWxzZSBpZiBhIFRDUCwgVURQIG9yIElDTVAgaGVhZGVyIGlzIHRydW5jYXRlZA0KPj4gKyAq
IGp1c3QgYmVmb3JlIG9yIGluIHRoZSBtaWRkbGUgb2YgdGhlIGhlYWRlci4gSXQgYWxzbyByZXR1
cm5zIGZhbHNlIGlmDQo+PiArICogYW55IG90aGVyIHVwcGVyIGxheWVyIGhlYWRlciBpcyB0cnVu
Y2F0ZWQganVzdCBiZWZvcmUgdGhlIGZpcnN0IGJ5dGUuDQo+PiArICoNCj4+ICsgKiBOb3RlczoN
Cj4+ICsgKiAtSXQgZG9lcyBOT1QgcmV0dXJuIGZhbHNlIGlmIHRoZSBmaXJzdCBmcmFnbWVudCB3
aGVyZSB0cnVuY2F0ZWQNCj4gTW9yZSBzcGFjZXMgbmVlZGVkLCBpLmUuDQo+DQo+IE5vdGVzOg0K
PiAgLSBJdC4uLg0KPg0KPj4gKyAqIGVsc2V3aGVyZSwgaS5lLiBiZXR3ZWVuIG9yIGluIHRoZSBt
aWRkbGUgb2Ygb25lIG9mIHRoZSBleHRlbnNpb24NCj4+ICsgKiBoZWFkZXJzIG9yIGluIHRoZSBt
aWRkbGUgb2Ygb25lIG9mIHRoZSB1cHBlciBsYXllciBoZWFkZXJzLCBleGNlcHQgZm9yDQo+PiAr
ICogVENQLCBVRFAgYW5kIElDTVAuDQo+PiArICogLVRoZSBmdW5jdGlvbiBhbHNvIHJldHVybnMg
dHJ1ZSBpZiB0aGUgZnJhZ21lbnQgaXMgbm90IHRoZSBmaXJzdA0KPj4gKyAqIGZyYWdtZW50Lg0K
Pj4gKyAqLw0KPj4gKw0KPiBubyBuZWVkIGZvciBhIG5ldyBsaW5lIGhlcmUNCj4NCj4+ICtib29s
IGlwdjZfZnJhZ192YWxpZGF0ZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBpbnQgc3RhcnQsIHU4ICpu
ZXh0aGRycCkNCj4gKGEpIHdoeSBwbGFjZSB0aGlzIGZ1bmN0aW9uIGluIGV4dGhkcnNfY29yZT8g
SSBkb24ndCBzZWUgYW55IGhlYWRlcg0KPiAgICAgc3BlY2lmaWMgY29kZSBoZXJlLCBJTU8gaXQg
YmVsb25ncyBpbiByZWFzc2VtYmx5LmMuDQoNCmlwdjZfZnJhZ192YWxpZGF0ZSgpIGlzIHVzZWQg
aW4gYm90aCByZWFzc2VtYmx5LmMgYW5kIG5mX2Nvbm50cmFja19yZWFzbS5jDQpXaGVyZSBzaG91
bGQgSSBwdXQgdGhlIHByb3RvdHlwZSBzbyBpdCBjYW4gYmUgdXNlZCBib3RoIHBsYWNlcz8NCg0K
Pg0KPiAoYikgdGhlIG5hbWUgaXMgYSBiaXQgYnJvYWQsIGhvdyBhYm91dCBpcHY2X2ZyYWdfdGhk
cl90dW5jYXRlZCgpIG9yDQo+ICAgICBzb21lIHN1Y2g/DQpZZXMgYWdyZWUsIG11Y2ggYmV0dGVy
Lg0KPj4gK3sNCj4+ICsJaW50IG9mZnNldDsNCj4+ICsJdTggbmV4dGhkciA9ICpuZXh0aGRycDsN
Cj4+ICsJX19iZTE2IGZyYWdfb2ZmOw0KPiBvcmRlciB0aGVzZSBsb25nZXN0IGxpbmUgdG8gc2hv
cnRlc3QgKHJldiB4bWFzIHRyZWUpIHBsZWFzZS4NCj4NCj4+ICsNCj4+ICsJb2Zmc2V0ID0gaXB2
Nl9za2lwX2V4dGhkcihza2IsIHN0YXJ0LCAmbmV4dGhkciwgJmZyYWdfb2ZmKTsNCj4+ICsJaWYg
KG9mZnNldCA+PSAwICYmICEoZnJhZ19vZmYgJiBodG9ucyhJUDZfT0ZGU0VUKSkpIHsNCj4gbml0
OiBzaW5jZSB0aGlzIGlzIGEgZnVuY3Rpb24gbm93IHlvdSBjYW4gcmV2ZXJzZSB0aGUgY29uZGl0
aW9uLCByZXR1cm4NCj4gZWFybHksIGFuZCBzYXZlIHRoZSBpbmRlbnRhdGlvbiBsZXZlbCBpbiBh
bGwgdGhlIGNvZGUgYmVsb3cNCj4NCj4+ICsJCXN3aXRjaCAobmV4dGhkcikgew0KPj4gKwkJY2Fz
ZSBORVhUSERSX1RDUDoNCj4+ICsJCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB0Y3BoZHIpOw0K
Pj4gKwkJCWJyZWFrOw0KPj4gKwkJY2FzZSBORVhUSERSX1VEUDoNCj4+ICsJCQlvZmZzZXQgKz0g
c2l6ZW9mKHN0cnVjdCB1ZHBoZHIpOw0KPj4gKwkJCWJyZWFrOw0KPj4gKwkJY2FzZSBORVhUSERS
X0lDTVA6DQo+PiArCQkJb2Zmc2V0ICs9IHNpemVvZihzdHJ1Y3QgaWNtcDZoZHIpOw0KPj4gKwkJ
CWJyZWFrOw0KPj4gKwkJZGVmYXVsdDoNCj4+ICsJCQlvZmZzZXQgKz0gMTsNCj4+ICsJCX0NCj4+
ICsJCWlmIChvZmZzZXQgPiBza2ItPmxlbikNCj4+ICsJCQlyZXR1cm4gZmFsc2U7DQo+PiArCX0N
Cj4+ICsJcmV0dXJuIHRydWU7DQo+PiArfQ0KPj4gK0VYUE9SVF9TWU1CT0woaXB2Nl9mcmFnX3Zh
bGlkYXRlKTsNCj4+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNr
X3JlYXNtLmMgYi9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMNCj4+IGlu
ZGV4IDA1NGQyODcuLmY2Y2FlMjggMTAwNjQ0DQo+PiAtLS0gYS9uZXQvaXB2Ni9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX3JlYXNtLmMNCj4+ICsrKyBiL25ldC9pcHY2L25ldGZpbHRlci9uZl9jb25u
dHJhY2tfcmVhc20uYw0KPj4gQEAgLTQ0NSw2ICs0NDUsNyBAQCBpbnQgbmZfY3RfZnJhZzZfZ2F0
aGVyKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNrX2J1ZmYgKnNrYiwgdTMyIHVzZXIpDQo+PiAg
CXN0cnVjdCBmcmFnX3F1ZXVlICpmcTsNCj4+ICAJc3RydWN0IGlwdjZoZHIgKmhkcjsNCj4+ICAJ
dTggcHJldmhkcjsNCj4+ICsJdTggbmV4dGhkciA9IE5FWFRIRFJfRlJBR01FTlQ7DQo+IHJldiB4
bWFzIHRyZWUNCj4NCj4+ICAJLyogSnVtYm8gcGF5bG9hZCBpbmhpYml0cyBmcmFnLiBoZWFkZXIg
Ki8NCj4+ICAJaWYgKGlwdjZfaGRyKHNrYiktPnBheWxvYWRfbGVuID09IDApIHsNCj4+IEBAIC00
NTUsNiArNDU2LDE0IEBAIGludCBuZl9jdF9mcmFnNl9nYXRoZXIoc3RydWN0IG5ldCAqbmV0LCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1MzIgdXNlcikNCj4+ICAJaWYgKGZpbmRfcHJldl9maGRyKHNr
YiwgJnByZXZoZHIsICZuaG9mZiwgJmZob2ZmKSA8IDApDQo+PiAgCQlyZXR1cm4gMDsNCj4+ICAN
Cj4+ICsJLyogRGlzY2FyZCB0aGUgZmlyc3QgZnJhZ21lbnQgaWYgaXQgZG9lcyBub3QgaW5jbHVk
ZSBhbGwgaGVhZGVycw0KPj4gKwkgKiBSRkMgODIwMCwgU2VjdGlvbiA0LjUNCj4+ICsJICovDQo+
PiArCWlmICghaXB2Nl9mcmFnX3ZhbGlkYXRlKHNrYiwgZmhvZmYsICZuZXh0aGRyKSkgew0KPj4g
KwkJcHJfZGVidWcoIkRyb3AgaW5jb21wbGV0ZSBmcmFnbWVudFxuIik7DQo+PiArCQlyZXR1cm4g
MDsNCj4+ICsJfQ0KPj4NCj4+ICAJaWYgKCFwc2tiX21heV9wdWxsKHNrYiwgZmhvZmYgKyBzaXpl
b2YoKmZoZHIpKSkNCj4+ICAJCXJldHVybiAtRU5PTUVNOw0KPj4gIA0KPj4gZGlmZiAtLWdpdCBh
L25ldC9pcHY2L3JlYXNzZW1ibHkuYyBiL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KPj4gaW5kZXgg
YzhjZjFiYi4uMDRlMDc4ZSAxMDA2NDQNCj4+IC0tLSBhL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0K
Pj4gKysrIGIvbmV0L2lwdjYvcmVhc3NlbWJseS5jDQo+PiBAQCAtMzI0LDggKzMyNCw3IEBAIHN0
YXRpYyBpbnQgaXB2Nl9mcmFnX3JjdihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4gIAlzdHJ1Y3Qg
ZnJhZ19xdWV1ZSAqZnE7DQo+PiAgCWNvbnN0IHN0cnVjdCBpcHY2aGRyICpoZHIgPSBpcHY2X2hk
cihza2IpOw0KPj4gIAlzdHJ1Y3QgbmV0ICpuZXQgPSBkZXZfbmV0KHNrYl9kc3Qoc2tiKS0+ZGV2
KTsNCj4+IC0JX19iZTE2IGZyYWdfb2ZmOw0KPj4gLQlpbnQgaWlmLCBvZmZzZXQ7DQo+PiArCWlu
dCBpaWY7DQo+IHJldiB4bWFzIHRyZWUNCj4NCj4+ICAJdTggbmV4dGhkcjsNCj4+ICANCj4+ICAJ
aWYgKElQNkNCKHNrYiktPmZsYWdzICYgSVA2U0tCX0ZSQUdNRU5URUQpDQo+PiBAQCAtMzYyLDI0
ICszNjEsMTEgQEAgc3RhdGljIGludCBpcHY2X2ZyYWdfcmN2KHN0cnVjdCBza19idWZmICpza2Ip
DQo+PiAgCSAqIHRoZSBzb3VyY2Ugb2YgdGhlIGZyYWdtZW50LCB3aXRoIHRoZSBQb2ludGVyIGZp
ZWxkIHNldCB0byB6ZXJvLg0KPj4gIAkgKi8NCj4+ICAJbmV4dGhkciA9IGhkci0+bmV4dGhkcjsN
Cj4+IC0Jb2Zmc2V0ID0gaXB2Nl9za2lwX2V4dGhkcihza2IsIHNrYl90cmFuc3BvcnRfb2Zmc2V0
KHNrYiksICZuZXh0aGRyLCAmZnJhZ19vZmYpOw0KPj4gLQlpZiAob2Zmc2V0ID49IDApIHsNCj4+
IC0JCS8qIENoZWNrIHNvbWUgY29tbW9uIHByb3RvY29scycgaGVhZGVyICovDQo+PiAtCQlpZiAo
bmV4dGhkciA9PSBJUFBST1RPX1RDUCkNCj4+IC0JCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB0
Y3BoZHIpOw0KPj4gLQkJZWxzZSBpZiAobmV4dGhkciA9PSBJUFBST1RPX1VEUCkNCj4+IC0JCQlv
ZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB1ZHBoZHIpOw0KPj4gLQkJZWxzZSBpZiAobmV4dGhkciA9
PSBJUFBST1RPX0lDTVBWNikNCj4+IC0JCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCBpY21wNmhk
cik7DQo+PiAtCQllbHNlDQo+PiAtCQkJb2Zmc2V0ICs9IDE7DQo+PiAtDQo+PiAtCQlpZiAoIShm
cmFnX29mZiAmIGh0b25zKElQNl9PRkZTRVQpKSAmJiBvZmZzZXQgPiBza2ItPmxlbikgew0KPj4g
LQkJCV9fSVA2X0lOQ19TVEFUUyhuZXQsIF9faW42X2Rldl9nZXRfc2FmZWx5KHNrYi0+ZGV2KSwN
Cj4+IC0JCQkJCUlQU1RBVFNfTUlCX0lOSERSRVJST1JTKTsNCj4+IC0JCQlpY21wdjZfcGFyYW1f
cHJvYihza2IsIElDTVBWNl9IRFJfSU5DT01QLCAwKTsNCj4+IC0JCQlyZXR1cm4gLTE7DQo+PiAt
CQl9DQo+PiArCWlmICghaXB2Nl9mcmFnX3ZhbGlkYXRlKHNrYiwgc2tiX3RyYW5zcG9ydF9vZmZz
ZXQoc2tiKSwgJm5leHRoZHIpKSB7DQo+PiArCQlfX0lQNl9JTkNfU1RBVFMobmV0LCBfX2luNl9k
ZXZfZ2V0X3NhZmVseShza2ItPmRldiksDQo+PiArCQkJCUlQU1RBVFNfTUlCX0lOSERSRVJST1JT
KTsNCj4+ICsJCWljbXB2Nl9wYXJhbV9wcm9iKHNrYiwgSUNNUFY2X0hEUl9JTkNPTVAsIDApOw0K
Pj4gKwkJcmV0dXJuIC0xOw0KPj4gIAl9DQo+PiAgDQo+PiAgCWlpZiA9IHNrYi0+ZGV2ID8gc2ti
LT5kZXYtPmlmaW5kZXggOiAwOw0KVGhhbmtzIGZvciByZXZpZXdpbmcsIHdpdGggZ29vZCBpbnB1
dC4gUGxlYXNlIHNlZSBxdWVzdGlvbiBhYm92ZS4NCg0KR2VvcmcNCg==
