Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4629A968
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897926AbgJ0KU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:20:26 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:44186 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897922AbgJ0KUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:20:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2218; q=dns/txt; s=iport;
  t=1603794024; x=1605003624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bVVJx6Pqcysx4nJhCELuZvpJzWcG+h39pIFGUaIIDgI=;
  b=nDL0NmRSn1tYN+nqpweRWiu4aLqnEht//LZaXu2QCsARqklq7h7LaK8v
   NkUEePD+aLUGvrq3NpoM7dNg3XM7R3yireEUP5EgLRNTUwXzLPrqNei4I
   VwLdQVhqvmeUWA2JCiupZbrQPv4iY4jW+PIPTa7lpWoRFQBYLaaHIkZkC
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3ABXpqsxYHIze0ugJUfG0xtRr/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QaVD4re4vNAzeHRtvOoVW8B5MOHt3YPONxJWg?=
 =?us-ascii?q?QegMob1wonHIaeCEL9IfKrCk5yHMlLWFJ/uX3uN09TFZXxYlTTpju56jtBUh?=
 =?us-ascii?q?n6PBB+c+LyHIOahs+r1ue0rpvUZQgAhDe0bb5oahusqgCEvcgNiowkIaE0mR?=
 =?us-ascii?q?Y=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AeDQDz85df/5BdJa1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHgUkvLIQ8g0kDjRkIJph6glMDVQsBAQENAQEtAgQ?=
 =?us-ascii?q?BAYRKAheBawIlOBMCAwEBCwEBBQEBAQIBBgRthWEMhXIBAQEBAgESEQQNDAE?=
 =?us-ascii?q?BNwEPAgEIGAICJgICAjAVEAIEDQEHAQEegwSCTAMOIAGbSgKBO4hodn8zgwQ?=
 =?us-ascii?q?BAQWFFRiCEAmBDiqCcoNwhlcbgUE/gTgMgl0+hD0XgwCCX5MYAT2kNAqCa5p?=
 =?us-ascii?q?wBQcDH6Fes3gCBAIEBQIOAQEFgWsjgVdwFYMkUBcCDY4fN4M6ilZ0OAIGCgE?=
 =?us-ascii?q?BAwl8jUwBAQ?=
X-IronPort-AV: E=Sophos;i="5.77,423,1596499200"; 
   d="scan'208";a="609196053"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Oct 2020 10:20:23 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 09RAKJWE007777
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 27 Oct 2020 10:20:22 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 05:20:19 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 06:20:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 27 Oct 2020 05:20:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpPg3x/y5Lk34U3fWlJt1yZ2jfXmeN1NqQaaZHUPfTDA94GiNFJkb2OvezOo9wReXvEw1Q1HNmgTnl2an3b8m6/L3VR7aoKySkHSPAMn7HSUnpf2NwERL6EjhLU5aFHL+5QTNmdxMgcl20qxy8qVigOEaXnXs5WBHqxQF8SxrvfLWpOAirum1q1B3a2RbgKz9Kga9JKd+ZLFha71mgHIsoLm6c5OWJEXkRxF9bCIcVQ5/W/5j7mrzHG/TXDdlFd35Np8ggScaOIQkBiwLgRcx9SwrdUAxlWIG7eEWGea3sVEXlcYCwTPa6ehvBkDNkXNnoDK3SXSyA9gNvpTiXz7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVVJx6Pqcysx4nJhCELuZvpJzWcG+h39pIFGUaIIDgI=;
 b=V2s1AcgzVCp7W/KoHoldAL7DdTZS2Wes3YBiz7WaHab3DkWK8UOs4XrytJAKhdksrwG44wKQbNNTgJT2zWQjjZ5q2qO/LAHF7IHSHakqENr+YEFLqV4KVIR7xEulkfDjZaZ2Pb0Nkw28RAd2jr3lanP7YlaeqvunJ3ckyxXfZbKz/tEPC/thZLDfzs+jY/+TN233YP3J0ZgcxWvESNDsYyupUk3T7p6Hj/sozNPNNQk5UTrv1CrhnxikybDO2J0SyD4PftO0EU31GGRycu41gvRLpSCxJOCHoAVAtAZYZTBV/2ZwIChYR9ucj4xIrhCuFA64YUzHQKk/bK41JHToAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVVJx6Pqcysx4nJhCELuZvpJzWcG+h39pIFGUaIIDgI=;
 b=hnuv2yPGQUGl8Y3lKojNwCNta/+pvv+9jKHPtZI0NPYN17o3IHUZKu+EhhM2UNqGhV0VIuvqdxt8n4P0mh2HD5QHmIxJ2v0KMBBq1t8J1CtCan6pa45wJFGB7MCp622ugaEkmPfXAGmTM+cOKwAzkvgSNBeRNifQixLIz7xtqDQ=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4663.namprd11.prod.outlook.com (2603:10b6:208:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 10:20:17 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba%4]) with mapi id 15.20.3477.029; Tue, 27 Oct 2020
 10:20:17 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Topic: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Index: AQHWrAj2kAw7EGET4EeFNR8yj/wV56mrFXOAgAAhkACAAAYtgA==
Date:   Tue, 27 Oct 2020 10:20:17 +0000
Message-ID: <97172a34-4f71-985f-9691-f00154a6ebfd@cisco.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027022833.3697522-3-liuhangbin@gmail.com>
 <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com>
 <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20201027095712.GP2531@dhcp-12-153.nay.redhat.com>
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
x-ms-office365-filtering-correlation-id: 2e850144-bca6-4f13-15d8-08d87a61e6f9
x-ms-traffictypediagnostic: MN2PR11MB4663:
x-microsoft-antispam-prvs: <MN2PR11MB46634C0B47E78EF9686BA03ACD160@MN2PR11MB4663.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Loj7+hSPBj77uhdEtrIOswwjmeyJLv58bWuXcW+05C2MlyfgGdTMxidEUP8F3GbbyxMAFABODGOUrzX4HUmOxFeaJQW1uk+N7KJ1IYNEQRwABLiyMiqKIDgY3vuMJ4QvMU83SIK3sOl+MC3NJPX/ybCkyROkP34iACWIagUC68Q4BNSshpIIne9TbRSHyL2a73QVCsx8S6D50wo2lGnYwYlTF637Pebubj34+sTSzbFwQ2+xEHXO2QYAdMHkJBRmw6qWB2b2V8SSsVfgeVSAD3W1ZWV5g7xKm4/2I8bjvLKMMtJ8GJNP4aDqKqW2xQhRrR68yZ/9USJDJrkMnrN70gwTMvkDBKdCdDvlTBDW88vnvKq7oi51aRMxsVK9Jyfo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(346002)(376002)(8676002)(2616005)(6486002)(6512007)(66476007)(76116006)(36756003)(6916009)(83380400001)(66446008)(91956017)(66946007)(71200400001)(5660300002)(64756008)(66556008)(2906002)(186003)(31686004)(478600001)(54906003)(86362001)(6506007)(53546011)(8936002)(316002)(31696002)(4326008)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wVW9oMCDSkplDwjUtYhfO/tOJKmwZ+yNvRZNspZut3iMYxnnDEPyrdkA5qVJD94jHFseyV1/8WDn3BvpVQM21vN85IK0l2huBCnGGOqSQrhyhJgdE7Aen0irDXQbeHhhUH6Ao55tPm1RVG0h0LJ+Yb4lzAqfE3e8yAjjCToSGOr2ADoXVZBeDaIdVD6ql1CDBzLmfWZhQVy01sOxaoTds7jhXHPj/souLs1WxuTnqhYj3VO0lFYL6uqHckmQ0HcNv/Ps56H+MfhDf4EFqEU/hGp3XwWdVqHMzV53NLWKQagMCCe3dG4j0F+E1k8WkZHJaS7Pmbr13Bip2gqHg7+wrykYF2BClqIrlcWrYdPkOJh6pGp1pDGK5hpYP8K2SMcxRU9xoTxuLvbd4z0lEE5H/3fMn1cFbsTXR3H27xgM0jP1ppBWLVxKOoVCAMLe93xPhCWeYw+b0z5pGx9idsPocIEijhz8GHLThcLGNG00Z0OFLuqFcBm0iq34bRHi1J6MkdhoEJcbUFTu67MXkkds0VPJaX5mgYAFjk/BsDo3kZqzfTDiViQuPZsrJEaCKEU3KjnkQ2ZLV7DHPC1Q8lCaeyrPBF3pGP5BvoQELpcq9S/MJUh6jiHYh8nLZ58g6tUnN/A1vbfVGs6Q/pWMUzUSPE+9jNTg3jUpqtL7M4+JRPU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACA4DC0231E7144E86CFC289BA07EBB2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e850144-bca6-4f13-15d8-08d87a61e6f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 10:20:17.7076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5I8YXVwGYbSwgzWxIjYeNmwT+GTrUa+eYAU4i8KW2KEMb0UxAYNXd++JgzbZtfKxBNF7X/X/bHdiFWC06ECxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4663
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMTAuMjAyMCAxMDo1NywgSGFuZ2JpbiBMaXUgd3JvdGU6DQo+IE9uIFR1ZSwgT2N0IDI3
LCAyMDIwIGF0IDA3OjU3OjA2QU0gKzAwMDAsIEdlb3JnIEtvaG1hbm4gKGdlb2tvaG1hKSB3cm90
ZToNCj4+PiArCS8qIFJGQyA4MjAwLCBTZWN0aW9uIDQuNSBGcmFnbWVudCBIZWFkZXI6DQo+Pj4g
KwkgKiBJZiB0aGUgZmlyc3QgZnJhZ21lbnQgZG9lcyBub3QgaW5jbHVkZSBhbGwgaGVhZGVycyB0
aHJvdWdoIGFuDQo+Pj4gKwkgKiBVcHBlci1MYXllciBoZWFkZXIsIHRoZW4gdGhhdCBmcmFnbWVu
dCBzaG91bGQgYmUgZGlzY2FyZGVkIGFuZA0KPj4+ICsJICogYW4gSUNNUCBQYXJhbWV0ZXIgUHJv
YmxlbSwgQ29kZSAzLCBtZXNzYWdlIHNob3VsZCBiZSBzZW50IHRvDQo+Pj4gKwkgKiB0aGUgc291
cmNlIG9mIHRoZSBmcmFnbWVudCwgd2l0aCB0aGUgUG9pbnRlciBmaWVsZCBzZXQgdG8gemVyby4N
Cj4+PiArCSAqLw0KPj4+ICsJbmV4dGhkciA9IGhkci0+bmV4dGhkcjsNCj4+PiArCW9mZnNldCA9
IGlwdjZfc2tpcF9leHRoZHIoc2tiLCBza2JfdHJhbnNwb3J0X29mZnNldChza2IpLCAmbmV4dGhk
ciwgJmZyYWdfb2ZmKTsNCj4+PiArCWlmIChvZmZzZXQgPj0gMCkgew0KPj4+ICsJCS8qIENoZWNr
IHNvbWUgY29tbW9uIHByb3RvY29scycgaGVhZGVyICovDQo+Pj4gKwkJaWYgKG5leHRoZHIgPT0g
SVBQUk9UT19UQ1ApDQo+Pj4gKwkJCW9mZnNldCArPSBzaXplb2Yoc3RydWN0IHRjcGhkcik7DQo+
Pj4gKwkJZWxzZSBpZiAobmV4dGhkciA9PSBJUFBST1RPX1VEUCkNCj4+PiArCQkJb2Zmc2V0ICs9
IHNpemVvZihzdHJ1Y3QgdWRwaGRyKTsNCj4+PiArCQllbHNlIGlmIChuZXh0aGRyID09IElQUFJP
VE9fSUNNUFY2KQ0KPj4+ICsJCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCBpY21wNmhkcik7DQo+
Pj4gKwkJZWxzZQ0KPj4+ICsJCQlvZmZzZXQgKz0gMTsNCj4+PiArDQo+Pj4gKwkJaWYgKGZyYWdf
b2ZmID09IGh0b25zKGlwNl9tZikgJiYgb2Zmc2V0ID4gc2tiLT5sZW4pIHsNCj4+IFRoaXMgZG8g
bm90IGNhdGNoIGF0b21pYyBmcmFnbWVudHMgKGZyYWdtZW50ZWQgcGFja2V0IHdpdGggb25seSBv
bmUgZnJhZ21lbnQpLiBmcmFnX29mZiBhbHNvIGNvbnRhaW5zIHR3byByZXNlcnZlZCBiaXRzIChi
b3RoIDApIHRoYXQgbWlnaHQgY2hhbmdlIGluIHRoZSBmdXR1cmUuDQo+IFRoYW5rcywgSSBhbHNv
IGRpZG4ndCBhd2FyZSB0aGlzIHNjZW5hcmlvLg0KPg0KPj4gSSBzdWdnZXN0IHlvdSBvbmx5IGNo
ZWNrIHRoYXQgdGhlIG9mZnNldCBpcyAwOg0KPj4gZnJhZ19vZmYgJiBodG9ucyhJUDZfT0ZGU0VU
KQ0KPiBUaGlzIHdpbGwgbWF0Y2ggYWxsIG90aGVyIGZyYWdtZW50IHBhY2tldHMuIFJGQyByZXF1
ZXN0IHdlIHJlcGx5IElDTVAgZm9yIHRoZQ0KPiBmaXJzdCBmcmFnbWVudCBwYWNrZXQsIERvIHlv
dSBtZWFuDQo+DQo+IGlmICghZnJhZ19vZmYgJiBodG9ucyhJUDZfT0ZGU0VUKSAmJiBvZmZzZXQg
PiBza2ItPmxlbikNCg0KQWxtb3N0LCBhZGQgc29tZSBwYXJlbnRoZXNlczoNCg0KaWYgKCEoZnJh
Z19vZmYgJiBodG9ucyhJUDZfT0ZGU0VUKSkgJiYgb2Zmc2V0ID4gc2tiLT5sZW4pDQoNCj4NCj4g
VGhhbmtzDQo+IEhhbmdiaW4NCg0KDQo=
