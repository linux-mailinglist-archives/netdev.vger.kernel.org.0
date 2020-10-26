Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F092987E8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771196AbgJZIJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:09:29 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:7767 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391154AbgJZIJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5868; q=dns/txt; s=iport;
  t=1603699767; x=1604909367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=26bM3eVLzEfSujMCnbKAdQHZNI9ioUkwo7rqA7MI1d0=;
  b=WGsKewOtM7Ob+hetBISuP+avUpfEpHSLae1ctTf9Qaqa+s9zSsaKEGg0
   S37Ap+ZTH4KC7c8FLR2/4uptQF+4sgPNq1h4NkCJI/0zMDPn/LpUN7Ke2
   dhSk5+NfOFKGbnbZLDB1AgLUC0nuC0WkEpJ9hvUk/0XX655e51lvK7g33
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3A3ZFG/BwytwMu/1fXCy+N+z0EezQntrPoPwUc9p?=
 =?us-ascii?q?sgjfdUf7+++4j5ZRWDt/pohV7NG47c7qEMh+nXtvXmXmoNqdaEvWsZeZNBHx?=
 =?us-ascii?q?kClY0NngMmDcLEbC+zLPPjYyEgWsgXUlhj8iK0NEFUHID1YFiB6nG35CQZTx?=
 =?us-ascii?q?P4Mwc9L+/pG4nU2sKw0e36+5DabwhSwjSnZrYnJxStpgKXvc4T0oY=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CXEACzg5Zf/4cNJK1gHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIFPgVJRB4FJLyyEPINJA40ZCCaKEI5qglMDVQsBAQENAQEtAgQBAYR?=
 =?us-ascii?q?KAheBcwIlOBMCAwEBCwEBBQEBAQIBBgRthWEMhXMBAQQSEQQNDAEBNwEPAgE?=
 =?us-ascii?q?IGAICJgICAh8RFRACBAEMAQUCAQEegwSCTAMuAaNRAoE7iGh2fzODBAEBBYU?=
 =?us-ascii?q?ODQuCEAmBDiqCcoNwhlcbgUE/gTgMgl0+ghqCIxeDAIJfkC6CagE9o2BUCoJ?=
 =?us-ascii?q?qlWyFAQUHAx+hXpM9jWOSVQIEAgQFAg4BAQWBayOBV3AVgyRQFwINjh83gzq?=
 =?us-ascii?q?KVnQ4AgYKAQEDCXyNTAEB?=
X-IronPort-AV: E=Sophos;i="5.77,417,1596499200"; 
   d="scan'208";a="592817211"
Received: from alln-core-2.cisco.com ([173.36.13.135])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Oct 2020 08:09:26 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id 09Q89Qxk022583
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 26 Oct 2020 08:09:26 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Oct
 2020 03:09:25 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Oct
 2020 04:09:24 -0400
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 26 Oct 2020 04:09:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUttzmf2ySIA0sSDN+CbaARPL8fB4i9iaTcUKA6Jdo/vKI2u4IC1BwQl2wOiN7YFHWPxxp8JHqjKcISzm62HHQN7TBd/y5LSY2vPlX61ZvcJvpn9SI4dEhEnwNpa1QOqDlNMXOYJXJNJFzpS25W8+IWwBzoMF8i9bMH1PTvIp67z6/aA7MtaUChW8T3DW8HhQM+y+i+GlYcIluKCGhTQLNCfLsjX2oNu0ieED/raK+EhY3v7zplGhKNE8B6EPk7pDZ6D41b/V9SBjI8YWcS8s4TsiVX/brRQQF6HXTkL/5cKHhLuMOEd+8bm8xX6qQwEYg1Bd4gGpYjwvORcfE/Ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26bM3eVLzEfSujMCnbKAdQHZNI9ioUkwo7rqA7MI1d0=;
 b=RKiARqGepujiOsd+P885pcGjSpd62zlTP5RdrHWCqa3UEQT8r1qJ1pOY8OBpV0RX7O2nGQnRzcuohOxgSjWI1Ac+F78emeM+wFyo2d6G5ERfJujV9t588Q3HgROSXLxs5cDrws4xCmV9poBq4Dpf5oRV/da8ons0gK2rawepZ3KWBMLXEY1+Gn8kgH1nP0/ZB1hxQ28jvcoUZAnkCUKdRsJZjFnyS8SrZkjJF66+OQbGFe5NcsqfNXCx6HhDd8PZrekmdbyZiu6sYFyvi09q0Dlqju01L6rYVe6bbQnfv9beS428YDwhDJoaUd1UNkRFPRwlgBIFbHbkpWdZGE7Xzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26bM3eVLzEfSujMCnbKAdQHZNI9ioUkwo7rqA7MI1d0=;
 b=lt8BKdPbhUaVjvH8ZppfTbERQuu07RRwnKjvUIT5tCR4TXv50TriBYXTKNHLLdfdZZlTukBiFpNlvYlzXpDBEiUl7nU97Tl1ADDB3DI50zBwFjpSoUorAhjoMYlTCkEXYcgO4chBQSBpbuirz2wUoW7DwQG73chQKp7UX59Z1PM=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4493.namprd11.prod.outlook.com (2603:10b6:208:190::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Mon, 26 Oct
 2020 08:09:21 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba%4]) with mapi id 15.20.3477.029; Mon, 26 Oct 2020
 08:09:21 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Topic: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Index: AQHWq2nfQzoTEclCX0OPTEyd7AzIoamph8kA
Date:   Mon, 26 Oct 2020 08:09:21 +0000
Message-ID: <57fe774b-63bb-a270-4271-f1cb632a6423@cisco.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
 <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201026072926.3663480-3-liuhangbin@gmail.com>
In-Reply-To: <20201026072926.3663480-3-liuhangbin@gmail.com>
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
x-ms-office365-filtering-correlation-id: 56e58176-9203-48c3-0f29-08d8798671c8
x-ms-traffictypediagnostic: MN2PR11MB4493:
x-microsoft-antispam-prvs: <MN2PR11MB44938A0271AD7B1AC7608A16CD190@MN2PR11MB4493.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ks0OVGIMGf+9cYnf48fOFZcPmlB6omGdlul3P1g3uxZYPZIzSYjdKYa/SLS6zvGGh74LKacMs/bSB2kyaIYf8CZBgqzsRv7VkwBLTr6YXacI92DwnEyzxcSOz4btzsccWBpnrsi3UBfcaVvWMiIgvenm4IyuWbmyeeDh6DzS/BcTNGbJSd7UccEQCwpXrf/TvHIofoUffVVCOmPoqq3//t8vxa6plTjuAODq2lwr7xPvGrnZ+ukSv5wCjyiya2DWZki5j+SXXai8carZ5bCcONc2vG9xRE/Fn7ukY1oT9pInpzJ2o7nb4uwKEJHzgK1ZMH7KKfneDgOuGvB/DT3mnF4JQZHzwNh1s1r6G6l5/Bpumnkgup5iTjltf6IgIqA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(478600001)(66946007)(54906003)(91956017)(53546011)(316002)(2906002)(6506007)(76116006)(186003)(31696002)(64756008)(71200400001)(66446008)(6486002)(83380400001)(110136005)(4326008)(66476007)(2616005)(86362001)(6512007)(36756003)(8676002)(66556008)(8936002)(31686004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GaTQptSaFE27K8gY3+Mpw0azNE8LG4hzzk//GivvaRGY46fU4MRb59e07O0WJFAMCN6CUZ8XyxQHJ3kUcGaH5BhauCK8zYLWCOd3Qf2UTH2cFgs0E2g5YzeX6FJuU2VTnQNXGpiq3Na5E0Y/gKp5mUlbeBL4GTiQueKPMGAc15gBY6oaJAL/KiiL0taroiOKKM5b4d1iH1AH13GtIChWVDJwaKHnHh+8aZiDUspY0NHhhGuYaynjlddyX5yNwkBU3fyTN/hIorOh3b3B0Fw3ycXTyLuMVDnDPAKSOJL/lNDetqeTq/Uqca6AXqTEKqhgvQS96eYiG1LVBwyXfUE1I3q0eCx7DpRe5dMCJfGysaj3XKHI0Z50sKEREyK2av6rn9QyUYTMVm1mwYpQsih+7S1DZZ2aeLs11RFMTodYfES+HGq/EJAmdg4EEmrMJ6kp0Ei3FGwMXl6brinJPjzjNVLbbkrMVcVucOEyvyvVZQ9yb9xAxRDXs5cV3vq7639R3iYA3FxmspO1Y89l5yipy+HjthCjWgJ+z3MjOr2U49Ge5Wx4Y26UOQV5L1nO5VOQJIDdEQljK1gz8WvTfosM9HAfb3718zCCipnktB5cC1MPP6J/XIU+02Nf7OFP2N7R9ineM/zTyydCS/i8Oyg+j2fRZYIRpoo3wM0DmztZEs4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C0E179B3DC9BC428905D5BCDFE703B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e58176-9203-48c3-0f29-08d8798671c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 08:09:21.3190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKe/NHTP9EqQcxWbFhsc5P7O+c/5WsSCX0CKxAwfNHMBYbLuTFllZtQhOOJe7sU0zCbmFgAksQHYN2Aeyu7hFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4493
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-2.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYuMTAuMjAyMCAwODoyOSwgSGFuZ2JpbiBMaXUgd3JvdGU6DQo+IEJhc2VkIG9uIFJGQyA4
MjAwLCBTZWN0aW9uIDQuNSBGcmFnbWVudCBIZWFkZXI6DQo+DQo+ICAgLSAgSWYgdGhlIGZpcnN0
IGZyYWdtZW50IGRvZXMgbm90IGluY2x1ZGUgYWxsIGhlYWRlcnMgdGhyb3VnaCBhbg0KPiAgICAg
IFVwcGVyLUxheWVyIGhlYWRlciwgdGhlbiB0aGF0IGZyYWdtZW50IHNob3VsZCBiZSBkaXNjYXJk
ZWQgYW5kDQo+ICAgICAgYW4gSUNNUCBQYXJhbWV0ZXIgUHJvYmxlbSwgQ29kZSAzLCBtZXNzYWdl
IHNob3VsZCBiZSBzZW50IHRvDQo+ICAgICAgdGhlIHNvdXJjZSBvZiB0aGUgZnJhZ21lbnQsIHdp
dGggdGhlIFBvaW50ZXIgZmllbGQgc2V0IHRvIHplcm8uDQo+DQo+IEFzIHRoZSBwYWNrZXQgbWF5
IGJlIGFueSBraW5kIG9mIEw0IHByb3RvY29sLCBJIG9ubHkgY2hlY2tlZCBzb21lIGNvbW1vbg0K
PiBwcm90b2NvbHMnIGhlYWRlciBsZW5ndGggYW5kIGhhbmRsZSBvdGhlcnMgYnkgKG9mZnNldCAr
IDEpID4gc2tiLT5sZW4uDQo+IENoZWNraW5nIGVhY2ggcGFja2V0IGhlYWRlciBpbiBJUHY2IGZh
c3QgcGF0aCB3aWxsIGhhdmUgcGVyZm9ybWFuY2UgaW1wYWN0LA0KPiBzbyBJIHB1dCB0aGUgY2hl
Y2tpbmcgaW4gaXB2Nl9mcmFnX3JjdigpLg0KPg0KPiBXaGVuIHNlbmQgSUNNUCBlcnJvciBtZXNz
YWdlLCBpZiB0aGUgMXN0IHRydW5jYXRlZCBmcmFnbWVudCBpcyBJQ01QIG1lc3NhZ2UsDQo+IGlj
bXA2X3NlbmQoKSB3aWxsIGJyZWFrIGFzIGlzX2luZWxpZ2libGUoKSByZXR1cm4gdHJ1ZS4gU28g
SSBhZGRlZCBhIGNoZWNrDQo+IGluIGlzX2luZWxpZ2libGUoKSB0byBsZXQgZnJhZ21lbnQgcGFj
a2V0IHdpdGggbmV4dGhkciBJQ01QIGJ1dCBubyBJQ01QIGhlYWRlcg0KPiByZXR1cm4gZmFsc2Uu
DQo+DQo+IFNpZ25lZC1vZmYtYnk6IEhhbmdiaW4gTGl1IDxsaXVoYW5nYmluQGdtYWlsLmNvbT4N
Cj4gLS0tDQo+IHY0Og0KPiByZW1vdmUgdW51c2VkIHZhcmlhYmxlDQo+DQo+IHYzOg0KPiBhKSB1
c2UgZnJhZ19vZmYgdG8gY2hlY2sgaWYgdGhpcyBpcyBhIGZyYWdtZW50IHBhY2tldA0KPiBiKSBj
aGVjayBzb21lIGNvbW1vbiBwcm90b2NvbHMnIGhlYWRlciBsZW5ndGgNCj4NCj4gdjI6DQo+IGEp
IE1vdmUgaGVhZGVyIGNoZWNrIHRvIGlwdjZfZnJhZ19yY3YoKS4gQWxzbyBjaGVjayB0aGUgaXB2
Nl9za2lwX2V4dGhkcigpDQo+ICAgIHJldHVybiB2YWx1ZQ0KPiBiKSBGaXggaXB2Nl9maW5kX2hk
cigpIHBhcmFtZXRlciB0eXBlIG1pc3MgbWF0Y2ggaW4gaXNfaW5lbGlnaWJsZSgpDQo+DQo+IC0t
LQ0KPiAgbmV0L2lwdjYvaWNtcC5jICAgICAgIHwgIDggKysrKysrKy0NCj4gIG5ldC9pcHY2L3Jl
YXNzZW1ibHkuYyB8IDMzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZm
IC0tZ2l0IGEvbmV0L2lwdjYvaWNtcC5jIGIvbmV0L2lwdjYvaWNtcC5jDQo+IGluZGV4IGVjNDQ4
YjcxYmY5YS4uODk1NjE0NGVhNjVlIDEwMDY0NA0KPiAtLS0gYS9uZXQvaXB2Ni9pY21wLmMNCj4g
KysrIGIvbmV0L2lwdjYvaWNtcC5jDQo+IEBAIC0xNTgsNyArMTU4LDEzIEBAIHN0YXRpYyBib29s
IGlzX2luZWxpZ2libGUoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gIAkJdHAgPSBza2Jf
aGVhZGVyX3BvaW50ZXIoc2tiLA0KPiAgCQkJcHRyK29mZnNldG9mKHN0cnVjdCBpY21wNmhkciwg
aWNtcDZfdHlwZSksDQo+ICAJCQlzaXplb2YoX3R5cGUpLCAmX3R5cGUpOw0KPiAtCQlpZiAoIXRw
IHx8ICEoKnRwICYgSUNNUFY2X0lORk9NU0dfTUFTSykpDQo+ICsNCj4gKwkJLyogQmFzZWQgb24g
UkZDIDgyMDAsIFNlY3Rpb24gNC41IEZyYWdtZW50IEhlYWRlciwgcmV0dXJuDQo+ICsJCSAqIGZh
bHNlIGlmIHRoaXMgaXMgYSBmcmFnbWVudCBwYWNrZXQgd2l0aCBubyBpY21wIGhlYWRlciBpbmZv
Lg0KPiArCQkgKi8NCj4gKwkJaWYgKCF0cCAmJiBmcmFnX29mZiAhPSAwKQ0KPiArCQkJcmV0dXJu
IGZhbHNlOw0KPiArCQllbHNlIGlmICghdHAgfHwgISgqdHAgJiBJQ01QVjZfSU5GT01TR19NQVNL
KSkNCj4gIAkJCXJldHVybiB0cnVlOw0KPiAgCX0NCj4gIAlyZXR1cm4gZmFsc2U7DQo+IGRpZmYg
LS1naXQgYS9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMgYi9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCj4g
aW5kZXggMWY1ZDRkMTk2ZGNjLi5iZjA0MmJjYjVhNDcgMTAwNjQ0DQo+IC0tLSBhL25ldC9pcHY2
L3JlYXNzZW1ibHkuYw0KPiArKysgYi9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCj4gQEAgLTQyLDYg
KzQyLDggQEANCj4gICNpbmNsdWRlIDxsaW51eC9za2J1ZmYuaD4NCj4gICNpbmNsdWRlIDxsaW51
eC9zbGFiLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+DQo+ICsjaW5jbHVkZSA8bGlu
dXgvdGNwLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvdWRwLmg+DQo+ICANCj4gICNpbmNsdWRlIDxu
ZXQvc29jay5oPg0KPiAgI2luY2x1ZGUgPG5ldC9zbm1wLmg+DQo+IEBAIC0zMjIsNyArMzI0LDkg
QEAgc3RhdGljIGludCBpcHY2X2ZyYWdfcmN2KHN0cnVjdCBza19idWZmICpza2IpDQo+ICAJc3Ry
dWN0IGZyYWdfcXVldWUgKmZxOw0KPiAgCWNvbnN0IHN0cnVjdCBpcHY2aGRyICpoZHIgPSBpcHY2
X2hkcihza2IpOw0KPiAgCXN0cnVjdCBuZXQgKm5ldCA9IGRldl9uZXQoc2tiX2RzdChza2IpLT5k
ZXYpOw0KPiAtCWludCBpaWY7DQo+ICsJX19iZTE2IGZyYWdfb2ZmOw0KPiArCWludCBpaWYsIG9m
ZnNldDsNCj4gKwl1OCBuZXh0aGRyOw0KPiAgDQo+ICAJaWYgKElQNkNCKHNrYiktPmZsYWdzICYg
SVA2U0tCX0ZSQUdNRU5URUQpDQo+ICAJCWdvdG8gZmFpbF9oZHI7DQo+IEBAIC0zNTEsNiArMzU1
LDMzIEBAIHN0YXRpYyBpbnQgaXB2Nl9mcmFnX3JjdihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAg
CQlyZXR1cm4gMTsNCj4gIAl9DQo+ICANCj4gKwkvKiBSRkMgODIwMCwgU2VjdGlvbiA0LjUgRnJh
Z21lbnQgSGVhZGVyOg0KPiArCSAqIElmIHRoZSBmaXJzdCBmcmFnbWVudCBkb2VzIG5vdCBpbmNs
dWRlIGFsbCBoZWFkZXJzIHRocm91Z2ggYW4NCj4gKwkgKiBVcHBlci1MYXllciBoZWFkZXIsIHRo
ZW4gdGhhdCBmcmFnbWVudCBzaG91bGQgYmUgZGlzY2FyZGVkIGFuZA0KPiArCSAqIGFuIElDTVAg
UGFyYW1ldGVyIFByb2JsZW0sIENvZGUgMywgbWVzc2FnZSBzaG91bGQgYmUgc2VudCB0bw0KPiAr
CSAqIHRoZSBzb3VyY2Ugb2YgdGhlIGZyYWdtZW50LCB3aXRoIHRoZSBQb2ludGVyIGZpZWxkIHNl
dCB0byB6ZXJvLg0KPiArCSAqLw0KPiArCW5leHRoZHIgPSBoZHItPm5leHRoZHI7DQo+ICsJb2Zm
c2V0ID0gaXB2Nl9za2lwX2V4dGhkcihza2IsIHNrYl90cmFuc3BvcnRfb2Zmc2V0KHNrYiksICZu
ZXh0aGRyLCAmZnJhZ19vZmYpOw0KPiArCWlmIChvZmZzZXQgPCAwKQ0KPiArCQlnb3RvIGZhaWxf
aGRyOw0KPiArDQo+ICsJLyogQ2hlY2sgc29tZSBjb21tb24gcHJvdG9jb2xzJyBoZWFkZXIgKi8N
Cj4gKwlpZiAobmV4dGhkciA9PSBJUFBST1RPX1RDUCkNCj4gKwkJb2Zmc2V0ICs9IHNpemVvZihz
dHJ1Y3QgdGNwaGRyKTsNCj4gKwllbHNlIGlmIChuZXh0aGRyID09IElQUFJPVE9fVURQKQ0KPiAr
CQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB1ZHBoZHIpOw0KPiArCWVsc2UgaWYgKG5leHRoZHIg
PT0gSVBQUk9UT19JQ01QVjYpDQo+ICsJCW9mZnNldCArPSBzaXplb2Yoc3RydWN0IGljbXA2aGRy
KTsNCj4gKwllbHNlDQo+ICsJCW9mZnNldCArPSAxOw0KDQpNYXliZSBhbHNvIGNoZWNrIHRoZSBz
cGVjaWFsIGNhc2UgSVBQUk9UT19OT05FPw0KDQo+ICsNCj4gKwlpZiAoZnJhZ19vZmYgPT0gaHRv
bnMoSVA2X01GKSAmJiBvZmZzZXQgPiBza2ItPmxlbikgew0KPiArCQlfX0lQNl9JTkNfU1RBVFMo
bmV0LCBfX2luNl9kZXZfZ2V0X3NhZmVseShza2ItPmRldiksIElQU1RBVFNfTUlCX0lOSERSRVJS
T1JTKTsNCj4gKwkJaWNtcHY2X3BhcmFtX3Byb2Ioc2tiLCBJQ01QVjZfSERSX0lOQ09NUCwgMCk7
DQo+ICsJCXJldHVybiAtMTsNCj4gKwl9DQo+ICsNCj4gIAlpaWYgPSBza2ItPmRldiA/IHNrYi0+
ZGV2LT5pZmluZGV4IDogMDsNCj4gIAlmcSA9IGZxX2ZpbmQobmV0LCBmaGRyLT5pZGVudGlmaWNh
dGlvbiwgaGRyLCBpaWYpOw0KPiAgCWlmIChmcSkgew0KDQpBcmUgeW91IHBsYW5uaW5nIHRvIGFs
c28gYWRkIHRoaXMgZml4IGZvciB0aGUgZnJhZ21lbnRhdGlvbiBoYW5kbGluZyBpbiB0aGUgbmV0
ZmlsdGVyPw0KDQo=
