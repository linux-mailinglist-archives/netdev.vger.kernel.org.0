Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B952A0D9C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgJ3Sji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:39:38 -0400
Received: from alln-iport-7.cisco.com ([173.37.142.94]:58919 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgJ3Sji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2908; q=dns/txt; s=iport;
  t=1604083177; x=1605292777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XTtSV6G7qmnTQmBCKiOKaIHB/GGlTuQ9puPIGZ/s8ek=;
  b=AWXnqnp40HQvGx4oaQ8eDLKQV4GyTpZcXXij6Sv9a4dxgivN2oJDFWDe
   a+dTx9J8jjFfuFvbKiwpYz5L6ekGZeUE+LGUqP942kTQWaLzVpI/AIjXe
   YfUyg89KGU1Tbt7bwouzl+Gmj8tAX+sN11krnSD6558AhoTBfQDBZfRfU
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3A2T0b1hDS6iv6NA20m8RFUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qw00A3GWIza77RPjO+F+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGF8P3ZlmUqXq3vnYeHx?=
 =?us-ascii?q?zlPl9zIeL4UofZk8Ww0bW0/JveKwVFjTawe/V8NhKz+A7QrcIRx4BlL/U8?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CrCQBNXZxf/5tdJa1iHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHgUkvLoQ9g0kDjRwuihKObIJTA1QLAQEBDQEBLQI?=
 =?us-ascii?q?EAQGESgIXgXACJTgTAgMBAQsBAQUBAQECAQYEcYVhDIVzAQEBAxIRBA0MAQE?=
 =?us-ascii?q?3AQ8CAQgYAgImAgICHxEVEAIEAQwBBQIBAR6DBIJMAy4BpVUCgTuIaHZ/M4M?=
 =?us-ascii?q?EAQEFhRMNC4IQCYEOKoJyg3GGVxuBQT+BOIJrPoIbgjqDAIJfkDiCbAE9o2t?=
 =?us-ascii?q?UCoJslXKFBwUHAx+hZpNHjWWSWgIEAgQFAg4BAQWBayOBV3AVgyRQFwINjh8?=
 =?us-ascii?q?MFxSDOopYdDgCBgoBAQMJfI1MAQE?=
X-IronPort-AV: E=Sophos;i="5.77,434,1596499200"; 
   d="scan'208";a="576900775"
Received: from rcdn-core-4.cisco.com ([173.37.93.155])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Oct 2020 18:39:37 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by rcdn-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 09UIdan0028470
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 30 Oct 2020 18:39:36 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 13:39:36 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Oct
 2020 13:39:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 30 Oct 2020 13:39:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n95U8oW7IQgbs3oD+zbARZkelgV/fTSo5D10hR+FJLXARnkhlSVDELFUUk7OhIxsmz+cbrhWkVb+RlNtjXosUWoJnJfj7s1IKQ8zn3G9BfPkL0lTjMSmvKqrHeHexM/NXoAl+I0A8+3QGGAwzKIaFelrFCIHmWDc8mnrpQfBYEbfk+bfAEyNxqE9tDdzT/WxvOos3qMRP50whRyXT7e/TWl2u23IFhhSFMGdsYgfjKUoDJhd9DYZyn+grH1xgr6xZrgxnbAnwezMjTviXoKSxCHsFYqrX8OXHWBghdo+qxGRc/4m832XhPgJydGHVNKw92zClOI9D+BDWIavqTNhrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTtSV6G7qmnTQmBCKiOKaIHB/GGlTuQ9puPIGZ/s8ek=;
 b=EXvDSvBQpKlWf6QJNyOLRR0/QJSthe1AT1nmbdM9sgTclf7tAt6pghjem6Cx77QBDUPjiYZ91Ug9rVc92+JmkuqGUpGdt3FxzW2yCdBwde0KseaPQZhhqSWDC8LLFSpEGDBc4Ux73nambTdeaKQJa9frcAT2kcghiv+aF4eLhPuA7j9hKBrdWWiYYvdhCIjbXhJErejdGZKTinxBiMGLduW2K48RzH/j+9v/5/Vo/OmL7+Qmouox/afERVi06ouz02Am9jVz2Ar8VfDu8+CNDlmdNHTrywMq7S7v4ZqkL3kg9b6airVaC1GwO+ZH83E/bhBLPxKiL0cf6YbV3X79zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTtSV6G7qmnTQmBCKiOKaIHB/GGlTuQ9puPIGZ/s8ek=;
 b=znf2bmLQCWakq4NFJALZvotKfbnLvnZFh7SaOFCRSl70RBNXuEZnY/je5Z6tDOqaRSSXUx/FkHXw9adzMbKd06YcoGj7/wjdDgPwW4GCxX9odXR+Tj2oX7WNDj+/QMf34nwkpoDoAekDSQG0b0cG2GwH8tkvE/wis+zwL7Tq8PU=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Fri, 30 Oct
 2020 18:39:35 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2%5]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 18:39:35 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>
Subject: Re: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Topic: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Index: AQHWrAj2kAw7EGET4EeFNR8yj/wV56mrFXOAgAAhkACABRSDgIAANG4A
Date:   Fri, 30 Oct 2020 18:39:35 +0000
Message-ID: <f8b18eb4-3b2f-7fc9-a020-b8e6451fd884@cisco.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027022833.3697522-3-liuhangbin@gmail.com>
 <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com>
 <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
 <CA+FuTSfSUE8M+TuKkBQbEL7L5Bfd=wrZHEqQ67nWZy8oex1JCw@mail.gmail.com>
In-Reply-To: <CA+FuTSfSUE8M+TuKkBQbEL7L5Bfd=wrZHEqQ67nWZy8oex1JCw@mail.gmail.com>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1006::1a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7395915-2fde-4652-b3a4-08d87d032641
x-ms-traffictypediagnostic: MN2PR11MB4581:
x-microsoft-antispam-prvs: <MN2PR11MB45816473FA10B6AA01729669CD150@MN2PR11MB4581.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NfOW0fYB0yL9mT7/jgW0f2Vc8v6nYHltfnT/yyoG+f110k84+d3kAr/mTPEMbcNChwwof/orAKvCTcOOoBQEEY1Aa3JUqQX6/sgpVUFY3Ma3AzKl3Jv7krrSRe661nq0b3MNGjn0Sa7THV8OMcNNzzQUoGfQ4bse/jWa+R27svDSVR+oTS2ZBT0JhRXHuJIbg72yo2nBM/Q4M2QFOiZTBy0ex4dto1wbGAM9/GZHDvv4XaBaxHjK2wbjMJVs2z8kf+ai+bbkcJcgTN+q78yn9n/w2/RVbLgvVcKIZmiYyi4ks0Mb5ZAj5LwwS6qObfZkfnCBJi3g4mDUz9ixgg3/Tx82aIWUR/FfKHVF33xOMOeUEnFzAEECdA32P7NUG9MR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(4326008)(86362001)(110136005)(6512007)(66446008)(66556008)(64756008)(76116006)(5660300002)(186003)(54906003)(66476007)(91956017)(478600001)(83380400001)(316002)(31686004)(36756003)(66946007)(53546011)(6506007)(8936002)(2616005)(6486002)(2906002)(31696002)(8676002)(71200400001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1LrwkGmC7wCtQ1ZWg4tH8iWxh2cHdmnk989ECjCSGYND4OUqff3y+Sm4eG85cLU2SSC6HCPSUpoT2UU+HCBDIFADOPHiT8solg9Fg4d6jnTQ5AEbNuFgIE3/fA7dzcOGksy42fnQZdQwmttDN5nU+j+rpVTuTmnQbFQtw5lo06wLROsBIbMC3KCc0Ts4fC45zTAqt51bej19XfxKbxi4OcgfzkKcKNHSfoQeTcinV25citvFhCblq1+eo+GzGC6yA5+ixCmu28K4PXfHX6Of+jT/NXKAQDc+7k+K81Yz3UAf3qtAsJKn8+TXVR5+yeQp+sTMmUqjkmInR+NgjRmBL1fXo+75kxCzYmr7iZ0QcttXMtwd4Gs5rctShm3xo3LOz9UuRqeFOuIpuvpoL0RNG1yCQypzWpTDitcRdr5Kiq5e3WrZiIaREHsp2W+O/xFN9S475WQsE7uQYo1wL2izB6LuMHq7q164c0NWbQp9Ig/wcMG+EqsvoeLjKasS7Zr2cghtuioNi7e/dmXy8XbtExLRSW7HKrosOPpKst1V72YUgtz3MEAyoXXvck6vQvjWuCfhxBUf7HnH96VuhM/g39Z+erTxRBIp2XTv1YIUC24cPcTGqnlDcZ35J10YS448PDVy7t8qeisdvr2V6BQb/zLZHBDGF3UYntutL+8JsIM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <75890D0578E18C4A8514221DB88AD7F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7395915-2fde-4652-b3a4-08d87d032641
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 18:39:35.2089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtZqkw6cEg/VpMGEpaRwk2j37tm8SLbe4rNz5pAa2HeK/7eb2+ZuYrAUqOtTgGe+we3daMVBdwpk3lrsmPV99g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: rcdn-core-4.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAuMTAuMjAyMCAxNjozMSwgV2lsbGVtIGRlIEJydWlqbiB3cm90ZToNCj4gT24gVHVlLCBP
Y3QgMjcsIDIwMjAgYXQgNTo1NyBBTSBIYW5nYmluIExpdSA8bGl1aGFuZ2JpbkBnbWFpbC5jb20+
IHdyb3RlOg0KPj4gT24gVHVlLCBPY3QgMjcsIDIwMjAgYXQgMDc6NTc6MDZBTSArMDAwMCwgR2Vv
cmcgS29obWFubiAoZ2Vva29obWEpIHdyb3RlOg0KPj4+PiArICAgLyogUkZDIDgyMDAsIFNlY3Rp
b24gNC41IEZyYWdtZW50IEhlYWRlcjoNCj4+Pj4gKyAgICAqIElmIHRoZSBmaXJzdCBmcmFnbWVu
dCBkb2VzIG5vdCBpbmNsdWRlIGFsbCBoZWFkZXJzIHRocm91Z2ggYW4NCj4+Pj4gKyAgICAqIFVw
cGVyLUxheWVyIGhlYWRlciwgdGhlbiB0aGF0IGZyYWdtZW50IHNob3VsZCBiZSBkaXNjYXJkZWQg
YW5kDQo+Pj4+ICsgICAgKiBhbiBJQ01QIFBhcmFtZXRlciBQcm9ibGVtLCBDb2RlIDMsIG1lc3Nh
Z2Ugc2hvdWxkIGJlIHNlbnQgdG8NCj4+Pj4gKyAgICAqIHRoZSBzb3VyY2Ugb2YgdGhlIGZyYWdt
ZW50LCB3aXRoIHRoZSBQb2ludGVyIGZpZWxkIHNldCB0byB6ZXJvLg0KPj4+PiArICAgICovDQo+
Pj4+ICsgICBuZXh0aGRyID0gaGRyLT5uZXh0aGRyOw0KPj4+PiArICAgb2Zmc2V0ID0gaXB2Nl9z
a2lwX2V4dGhkcihza2IsIHNrYl90cmFuc3BvcnRfb2Zmc2V0KHNrYiksICZuZXh0aGRyLCAmZnJh
Z19vZmYpOw0KPj4+PiArICAgaWYgKG9mZnNldCA+PSAwKSB7DQo+Pj4+ICsgICAgICAgICAgIC8q
IENoZWNrIHNvbWUgY29tbW9uIHByb3RvY29scycgaGVhZGVyICovDQo+Pj4+ICsgICAgICAgICAg
IGlmIChuZXh0aGRyID09IElQUFJPVE9fVENQKQ0KPj4+PiArICAgICAgICAgICAgICAgICAgIG9m
ZnNldCArPSBzaXplb2Yoc3RydWN0IHRjcGhkcik7DQo+Pj4+ICsgICAgICAgICAgIGVsc2UgaWYg
KG5leHRoZHIgPT0gSVBQUk9UT19VRFApDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgb2Zmc2V0
ICs9IHNpemVvZihzdHJ1Y3QgdWRwaGRyKTsNCj4+Pj4gKyAgICAgICAgICAgZWxzZSBpZiAobmV4
dGhkciA9PSBJUFBST1RPX0lDTVBWNikNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICBvZmZzZXQg
Kz0gc2l6ZW9mKHN0cnVjdCBpY21wNmhkcik7DQo+Pj4+ICsgICAgICAgICAgIGVsc2UNCj4+Pj4g
KyAgICAgICAgICAgICAgICAgICBvZmZzZXQgKz0gMTsNCj4+Pj4gKw0KPj4+PiArICAgICAgICAg
ICBpZiAoZnJhZ19vZmYgPT0gaHRvbnMoaXA2X21mKSAmJiBvZmZzZXQgPiBza2ItPmxlbikgew0K
Pj4+IFRoaXMgZG8gbm90IGNhdGNoIGF0b21pYyBmcmFnbWVudHMgKGZyYWdtZW50ZWQgcGFja2V0
IHdpdGggb25seSBvbmUgZnJhZ21lbnQpLiBmcmFnX29mZiBhbHNvIGNvbnRhaW5zIHR3byByZXNl
cnZlZCBiaXRzIChib3RoIDApIHRoYXQgbWlnaHQgY2hhbmdlIGluIHRoZSBmdXR1cmUuDQo+PiBU
aGFua3MsIEkgYWxzbyBkaWRuJ3QgYXdhcmUgdGhpcyBzY2VuYXJpby4NCj4gU29ycnksIHdoYXQg
YXJlIGF0b21pYyBmcmFnbWVudHM/DQo+DQo+IERvIHlvdSBtZWFuIHBhY2tldHMgd2l0aCBhIGZy
YWdtZW50IGhlYWRlciB0aGF0IGVuY2Fwc3VsYXRlcyB0aGUNCj4gZW50aXJlIHBhY2tldD8gSWYg
c28sIGlzbid0IHRoYXQgaGFuZGxlZCBpbiB0aGUgYnJhbmNoIHJpZ2h0IGFib3ZlPw0KPiAoIi8q
IEl0IGlzIG5vdCBhIGZyYWdtZW50ZWQgZnJhbWUgKi8iKS4gVGhhdCBzYWlkLCB0aGUgdGVzdCBi
YXNlZCBvbg0KPiBJUDZfT0ZGU0VUIExHVE0uDQpZZXMsIGFuIGF0b21pYyBmcmFnbWVudCBpcyBh
IHBhY2tldCBjb250YWluaW5nIGEgZnJhZ21lbnQgaGVhZGVyDQp3aXRob3V0IGFjdHVhbGx5IGJl
ZWluZyBmcmFnbWVudGVkIChzZWUgUkZDNjk0NiBhbmQgUkZDODAyMSkuDQoNCkFuZCB5b3UgYXJl
IHJpZ2h0LCBpdCBpcyBoYW5kbGVkIGluIHRoZSBicmFuY2ggcmlnaHQgYWJvdmUsIHNvcnJ5IGZv
cg0Kbm90IHNlZWluZyB0aGF0LiBCdXQgc3RpbGwsIHRoZSB0ZXN0IGJhc2VkIG9uIElQNl9PRkZT
RVQgaXMgbW9yZQ0KYWNjdXJhdGUgYXMgSVA2X01GIGlzIHNldCBmb3IgYWxsIGJ1dCB0aGUgdmVy
eSBsYXN0IGZyYWdtZW50Lg0KSG93ZXZlciwgaXQgcHJvYmFibHkgZG9lc24ndCBtYXR0ZXIgaW4g
dGhpcyBjb250ZXh0Lg0K
