Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9B02AE38B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbgKJWoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:44:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:39110 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732013AbgKJWoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:44:15 -0500
IronPort-SDR: g6GGjshQO9xGxTP6dLVKcthNClERQbakkZoy0sWK8hSiwqm6qvScnvgcHpoPDzBcFRXO8Q4KBs
 TLIz2CaAbOfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="170169155"
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="170169155"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 14:44:15 -0800
IronPort-SDR: Z9dxM6NozppeUlGuKahovvuAtJ1k1GDKnSWH8RRJ/b7T0H/Axo1pl12ek9AT3ASWfkJ1I+0uhN
 vyH2EsQCcfOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="473610763"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 10 Nov 2020 14:44:15 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 14:44:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 14:44:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 14:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJV5qrD7HP9tWSw8V093P3OUEkSTtUFTlCHYNh1c3dQzagMPpD9J0epPZ79FCv6bo5XJyF0fWBIfV+87zLv8aHFmepiVFcD5swh90q4dCQfJgEyKgS9C42/b+vUgUQDG/6sJNk51QX2bMRwj7NFkIAM8hH8tYzGJ8tx1D7nLtzMuSYK7ZREKOTlwtAJFsKBCMGInWPVnYNpZRbKNx6qJZzztpk6Z+HMHdg5MV6iWo1fmZahEfYvj5oWL3ohbdoGHwn1n59zQhm5BftzT+q7eS0k/cOeoLUWDQ9nV49EUXjb/LwtIhVUfxH/im7MnluPIp0D78VlRlCh2CnUq25W21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgrIWyfiXYnOz7f9CWTeKZKApyGaQJh/WW0iBOVDg6k=;
 b=ZwXNH0D2FKDDNaR/l44Q6mUR8Wuq9/vSiMz39I/EgWkkwCbPuDHajxXerfrjfTd5xcJ9W0JKpY0CgkCCpjo4HvmRotehEqEP+n6P0T63sd0evM7ZOTsLRLWI/P87TMIj/pVWdm0csC55F5ohxEJW2N+ziZaSWusOxDKuiJLjPoFaGi2635ZMXiWXmkkJdzMdSHQDL3bi+o74jkgYKr+xgUjdMyTTdABdGrT3oby8eyI2sGf812jflC7AXJhgwaqkqTJqmKxtrDP+DPRy3u4kleiu4c+mAruzyRrfZLg4AsHd2WNx9fxrnusQMDgUT9kzY3B1XJmWQYnOihwEPHk4Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgrIWyfiXYnOz7f9CWTeKZKApyGaQJh/WW0iBOVDg6k=;
 b=X0siOVCo776YuQp9Gf5oZkWO0+Lky+Fp/V9o3zqKy7sTpLiIf4GblrqKDOz54iXJp1Y485N8XrPJabwQ5CZluP7iFM+YZvq5Qw4TDQzNIUmu7hmzxWc+K9WXjVQzt7gFSPc26AWC44ZnJUS8/V4iFvlgzTvik/91n0kiEQBqLvY=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Tue, 10 Nov
 2020 22:44:12 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 22:44:12 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZQ==
Date:   Tue, 10 Nov 2020 22:44:12 +0000
Message-ID: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.21.0.200113
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c262d2d1-c2a6-4fb4-1195-08d885ca2519
x-ms-traffictypediagnostic: MW3PR11MB4746:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47464FA7C2DDE8E5EE687BF392E90@MW3PR11MB4746.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BlkXxEL2/oXHyrXuLsnvZJrwB8fBOsWDCgejKS8J8aprvkcoJcDSTRCTRJjXpX6rjmoiJnGn+ZAcp7HHuJUbdPs8IY85Lfw2K/gTrDjpcq6MQZOrPW+4bPG9FPWl1l+JCm4z8Hs7VvUgCLXShkd5DSHMbBU7VNY51n5Sozk2opoTaZv4x0EbLiGBxRpCi5jNFxuBh1Y5R1uQJWHqAYIV91CwLauT6WUAyYjPkEdyTpQNVvOsUhvTFtvwfFopLP1c/Y5NYZYSqKYk7ibcPD7i8sYqYRDfL6jZnUHR7KNCZeVV5W1cABHYGE+DlQaXZ9L27PDr1DGCpve4duosycslNZzpkqXOeWDgZkzfOt9FneXLgICtEuMDs8eLr5oo86ciOWjaZ593RmnhSgp233tHirvIgQAmdPfFYcFVZNyZ28hyCZ723+vewhhmd1wBrBz+b1wtjaqVIhAqfSihD2uf5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(8676002)(66446008)(64756008)(33656002)(71200400001)(316002)(966005)(66556008)(66476007)(6512007)(107886003)(5660300002)(86362001)(478600001)(54906003)(110136005)(26005)(186003)(8936002)(6506007)(36756003)(6486002)(76116006)(4326008)(66946007)(2616005)(83380400001)(2906002)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7CmB68RbYr38IhDdZSJl27vNFKqUraIrwSX7cmyeUQrQuMlEXBSMXTj+jLW0TJlcfAXewLx5MnnVN2P1fOBc9hTOMq4OHKlgWav6/gbWAFDGySSAic37kBuckzVsD0kmvjeYKaMbqDT7HJWDVQ2uDFZlChShSnNalYOLdWiz0WBybbSdAAUEqinDzjPtxkbKgxvH3sD9B/1eCjcm0WVvxtVq9iGQUq3RfGhr/CPJtvP3oUZ43nk1KnWLEDQUm5bw7YZ7ZNm4ICwAAEEBIe6mRCZP0T7Bb1RJKMSh/UM28RF6T1n0BDwddBCDYm9PYlVU3Un2vo4icBwVvJ5SPUbGjgI99OIz9/YTv4Xjf4x9yQoPV26m0oaKrZ1FovArigv8jbsu61E7BVb+AtFot7/FeUX7FwUtJmfS2X0ieDvd3yLzgBBNWyrSnZN5MrwFduD1xMWOVJ4DRct/6+kugPvHvUHBbSRzk7KRvvigiNtBJQvT+kLCaUXBRfAcYUeqr4twq1NE6rcLumGk4Q5pJf3QfuMSf/4lAhDC0k/bhxsxuzf+B9KBifTP9vXzDeAbACq/4+ecoCnEOtN8jdlm63MuXDXly5R8r1L1aolTc7tNwZJgTQWkta66WUB3Zv10ZQMD0yqkRtYvZM0y9DXpEutMdw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9631C7DB9CA6084885271323CDCEC024@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c262d2d1-c2a6-4fb4-1195-08d885ca2519
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 22:44:12.4213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4r/uYo+sqDDGONDXQpl5IgAZBtess7qacoa675nOiorRztVlgXfFzuBT4iWiDu/anrSv6FS6LewDUYMuRYQMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W1NvcnJ5IGlmIHlvdSBnb3QgdGhlIGVtYWlsIHR3aWNlLiBSZXNlbmRpbmcgYmVjYXVzZSBpdCB3
YXMgcmVqZWN0ZWQgYnkgbmV0ZGV2IGZvciBjb250YWluaW5nIEhUTUxdDQoNCkhpIFNhZWVkL0pl
c3BlcizCoA0KwqANCkkgYW0gd29ya2luZyBpbiB0aGUgVGltZSBTZW5zaXRpdmUgTmV0d29ya2lu
ZyB0ZWFtIGF0IEludGVsLiBXZSB3b3JrIG9uIGltcGxlbWVudGluZyBhbmQgdXBzdHJlYW1pbmcg
c3VwcG9ydCBmb3IgVFNOIHJlbGF0ZWQgZmVhdHVyZXMgZm9yIGludGVsIGJhc2VkIE5JQ3MuIFJl
Y2VudGx5IHdlIGhhdmUgYmVlbiBhZGRpbmcgc3VwcG9ydCBmb3IgWERQIGluIGkyMjUuIE9uZSBv
ZiB0aGUgZmVhdHVyZXMgd2hpY2ggd2Ugd2FudCB0byBhZGQgc3VwcG9ydCBmb3IgaXMgcGFzc2lu
ZyB0aGUgaGFyZHdhcmUgdGltZXN0YW1wIGluZm9ybWF0aW9uIHRvIHRoZSB1c2Vyc3BhY2UgYXBw
bGljYXRpb24gcnVubmluZyBBRl9YRFAgc29ja2V0cyAoZm9yIGJvdGggVHggYW5kIFJ4KS4gSSBj
YW1lIGFjcm9zcyB0aGUgWERQIFdvcmtzaG9wWzFdIGNvbmR1Y3RlZCBpbiBKdWx5IDIwMjAgYW5k
IHRoZXJlIHlvdSBzdGF0ZWQgdGhhdCB5b3UgYXJlIGFscmVhZHkgd29ya2luZyBvbiBhZGRpbmcg
c3VwcG9ydCBmb3IgQlRGIGJhc2VkIG1ldGFkYXRhIHRvIHBhc3MgaGFyZHdhcmUgaGludHMgZm9y
IFhEUCBQcm9ncmFtcy4gTXkgdW5kZXJzdGFuZGluZyAoYWxvbmcgd2l0aCBhIGZldyBxdWVzdGlv
bnMpIG9mIHRoZSBjdXJyZW50IHN0YXRlIGlzOsKgDQoqIFRoaXMgZmVhdHVyZSBpcyBjdXJyZW50
bHkgYmVpbmcgbWFpbnRhaW5lZCBvdXQgb2YgdHJlZS4gSSBmb3VuZCB0aGF0IGFuIFJGQyBTZXJp
ZXNbMl0gd2FzIHBvc3RlZCBpbiBKdW5lIDIwMTguIEFyZSB5b3UgcGxhbm5pbmcgdG8gcG9zdCBh
biB1cGRhdGVkIHZlcnNpb24gdG8gYmUgbWVyZ2VkIGluIHRoZSBtYWlubGluZSBhbnl0aW1lIHNv
b24/wqANCiogSSBhbSBndWVzc2luZyBoYXJkd2FyZSB0aW1lc3RhbXAgaXMgb25lIG9mIHRoZSBt
ZXRhZGF0YSBmaWVsZHMgd2hpY2ggd2lsbCBiZSBldmVudHVhbGx5IHN1cHBvcnRlZD8gWzNdDQoq
IFRoZSBNZXRhZGF0YSBzdXBwb3J0IHdpbGwgYmUgZXh0ZW5kZWQgdG8gcGFzcyBvbiB0aGUgaGFy
ZHdhcmUgaGludHMgdG8gQUZfWERQIHNvY2tldHMuIEFyZSB0aGVyZSBhbnkgcm91Z2ggcGxhbnMg
b24gd2hhdCBtZXRhZGF0YSB3aWxsIGJlIHRyYW5zZmVycmVkPw0KKiBUaGUgY3VycmVudCBwbGFu
IGZvciBUeCBzaWRlIG9ubHkgaW5jbHVkZXMgcGFzc2luZyBkYXRhIGZyb20gdGhlIGFwcGxpY2F0
aW9uIHRvIHRoZSBkcml2ZXIuIEFyZSB0aGVyZSBhbnkgcGxhbnMgdG8gc3VwcG9ydCBwYXNzaW5n
IGluZm9ybWF0aW9uIChsaWtlIEhXIFRYIHRpbWVzdGFtcCkgZnJvbSBkcml2ZXIgdG8gdGhlIEFw
cGxpY2F0aW9uPw0KwqANCkZpbmFsbHksIGlzIHRoZXJlIGFueSB3YXkgSSBjYW4gaGVscCBpbiBl
eHBlZGl0aW5nIHRoZSBkZXZlbG9wbWVudCBhbmQgdXBzdHJlYW1pbmcgb2YgdGhpcyBmZWF0dXJl
PyBJIGhhdmUgYmVlbiB3b3JraW5nIG9uIHN0dWR5aW5nIGhvdyBYRFAgd29ya3MgYW5kIGNhbiB3
b3JrIG9uIGltcGxlbWVudGluZyBzb21lIHBhcnQgb2YgdGhpcyBmZWF0dXJlIGlmIHlvdSB3b3Vs
ZCBsaWtlLg0KwqANClRoYW5rcywNClZlZGFuZyBQYXRlbA0KU29mdHdhcmUgRW5naW5lZXINCklu
dGVsIENvcnBvcmF0aW9uDQrCoA0KWzFdIC3CoGh0dHBzOi8vbmV0ZGV2Y29uZi5pbmZvLzB4MTQv
c2Vzc2lvbi5odG1sP3dvcmtzaG9wLVhEUA0KWzJdIC3CoGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFi
cy5vcmcvcHJvamVjdC9uZXRkZXYvY292ZXIvMjAxODA2MjcwMjQ2MTUuMTc4NTYtMS1zYWVlZG1A
bWVsbGFub3guY29tLw0KWzNdIC3CoGh0dHBzOi8veGRwLXByb2plY3QubmV0LyNvdXRsaW5lLWNv
bnRhaW5lci1JbXBvcnRhbnQtbWVkaXVtLXRlcm0tdGFza3MNCg0KDQo=
