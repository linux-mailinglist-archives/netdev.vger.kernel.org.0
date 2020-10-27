Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2029A5F0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508499AbgJ0H5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:57:17 -0400
Received: from alln-iport-8.cisco.com ([173.37.142.95]:51716 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508492AbgJ0H5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6282; q=dns/txt; s=iport;
  t=1603785433; x=1604995033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OCuMpNi5zepSpCYL790VjKQ13LtAG7w/tVfoKSbF/c0=;
  b=GbTmpHaFe55KWjlFmx9VJlmmnImh8TeCLb72s545d7x8LcXHAdYsgWVf
   skDYjOZ1XRyJsVX2nP7yuGeL9CSw9S7bJWxvCQ0mvJNfpR05bYIW1eViD
   AbJNRsgIvKX96ZUN7SUfLI5Y5cbSO2xoiiDlAGslAYSWotANmvIliMoXB
   0=;
IronPort-PHdr: =?us-ascii?q?9a23=3AxGt9sxerStH5oZwPKosyIejDlGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwaQAdfU7vtFj6zdtKWzEWAD4JPUtncEfdQMUh?=
 =?us-ascii?q?IekswZkkQmB9LNEkz0KvPmLklYVMRPXVNo5Te3ZE5SHsutaFjbo3n05jkXSV?=
 =?us-ascii?q?3zMANvLbHzHYjfx828y+G1/cjVZANFzDqwaL9/NlO4twLU48IXmoBlbK02z0?=
 =?us-ascii?q?jE?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CwEgBr0pdf/5hdJa1gHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIFPgVJRB4FJLyyEPINJA40ZCCaKEI5qglMDVQsBAQENAQEtAgQBAYR?=
 =?us-ascii?q?KAheBdAIlOBMCAwEBCwEBBQEBAQIBBgRthWEMhXMBAQEDEhEEDQwBATcBDwI?=
 =?us-ascii?q?BCBgCAiYCAgIfERUQAgQBDAEFAgEBHoMEgkwDLgGbBQKBO4hodn8zgwQBAQW?=
 =?us-ascii?q?FGw0LghAJgQ4qgnKDcIZXG4FBP4E4DIJdPoIagiMXgwCCX5AugmoBPaNgVAq?=
 =?us-ascii?q?Ca5VvhQEFBwMfoV6TP41jklYCBAIEBQIOAQEFgWsjgVdwFYMkUBcCDY4fN4M?=
 =?us-ascii?q?6ilZ0OAIGCgEBAwl8jUwBAQ?=
X-IronPort-AV: E=Sophos;i="5.77,423,1596499200"; 
   d="scan'208";a="591177961"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Oct 2020 07:57:10 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id 09R7v4wj003217
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 27 Oct 2020 07:57:09 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 02:57:07 -0500
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Oct
 2020 02:57:07 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 27 Oct 2020 03:57:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMUb5UX2ccWjOVuXAGy7JFgWPtmmrU/DZZDRhdmoMmMyA/0nQ8C0GFeeYrHAXIKx4GSZacQJPV/L3OO6rsK6NjMb/kCKZZr6mFMLANW7o+oWFK3pgfOY+KgxU+MaseoWvCSKGDkfnFXhxwc7rAAyQbP0ju4LMRxvlruu53ppQH8vKIDRyznT0GueTCOZrCETl3zIEDXvbKfUBYv+FWkIS8R6XACZRGo7AoKEeai+L1b+gSv9P2SruN0Wwy0qvglj+y74HEa1myQaL1lSne4Y7PiKu8/o5LUN6nBYaNJxzAnC1AwuIZTieA9P8Kkdi6hdZzTyx6U2MPcDcmZgHe0Kbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCuMpNi5zepSpCYL790VjKQ13LtAG7w/tVfoKSbF/c0=;
 b=Lp11EsFgcONgUniBej6FTFo74sEUl84ElAz3KlVCfvyRtXUtNoinhBUCKYXjoOG8pux8BZASvymzCIvhfpnbC+y1+cFRO43FAx65nABUhDNx1IKF7zE3pOJ8AFikEMIMu6/w0oPx/aR95rpjCMcqPN9e7rYc/zAsbomwPGux6N/TqkiUOnpEvw7AhvP381Yt5cx3Xada+mMI0cBlPkHWwc55h0W9hDjfZHH8kNcUQMbtypFYonRCIjnn1OJ92lDbD42z38HxedJ9z1eVwp17DwNhEIh7ndnnv5wsH7Wu3nxGQ3bormfgvUpSD2zTNdiCSim0FH4wRLIWqOVzhPcGBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCuMpNi5zepSpCYL790VjKQ13LtAG7w/tVfoKSbF/c0=;
 b=QJ6w/Jv8pZvjwRnMdfiNJd0C6P6EPDUgt8i5/EBQh9T7zUkfJIyhUrWxpQQGZdlLicTD9mGWWVvMgQivYKcFJRBXsjAW0QjG4t+pKzfvUx0E8HBsK6lRDwBTpBBYegSd+gGX2P79/Cr70nVW10PRgoh1p562VInRLaLeRqTmAhc=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4661.namprd11.prod.outlook.com (2603:10b6:208:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 07:57:06 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba%4]) with mapi id 15.20.3477.029; Tue, 27 Oct 2020
 07:57:06 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Topic: [PATCHv5 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Index: AQHWrAj2kAw7EGET4EeFNR8yj/wV56mrFXOA
Date:   Tue, 27 Oct 2020 07:57:06 +0000
Message-ID: <c86199a0-9fbc-9360-bbd6-8fc518a85245@cisco.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201027022833.3697522-1-liuhangbin@gmail.com>
 <20201027022833.3697522-3-liuhangbin@gmail.com>
In-Reply-To: <20201027022833.3697522-3-liuhangbin@gmail.com>
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
x-ms-office365-filtering-correlation-id: 14e566ff-a792-4c98-c8e4-08d87a4de5fd
x-ms-traffictypediagnostic: MN2PR11MB4661:
x-microsoft-antispam-prvs: <MN2PR11MB466199198BE8360B2A9CC124CD160@MN2PR11MB4661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: olPzEj5P8NBJcMjgRHjP2OMdrHBr63HH7kzBAXGCpIWYhNhRSnFQHalx3ZvQ44OYhXo6hSgH3G/nBN9aAhH9CEjb/sNls+//J+sTTGv6mhBrj89ZcVJTQSKfYv9d2/Cz/7E2P4z7KYn3hBffG+nBEMUVTLt1JMx5v6ThUBzpECkr6GWP7sY7lgUggD/g2sB4ri+QdQ7fKLh1FaZjih0AMrPE0oyKjSMVgySkDFjZf7Jjf6aZ/OLuiKzpBd2JZdUnfORngkZB8NzQCwklGDe5gZw9eL0zB5APxqldTSrOi5OKRCynge/1DKaG/x8vibWxWrewB1uPhJM0bilEseBwhj8wqDMmkr4DTKllHaLW/nwXHE2qdFH59wAMospWBmTt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(2616005)(8676002)(6512007)(6486002)(36756003)(478600001)(4326008)(2906002)(53546011)(8936002)(6506007)(186003)(66476007)(64756008)(66946007)(316002)(91956017)(66556008)(76116006)(31696002)(110136005)(71200400001)(83380400001)(54906003)(5660300002)(86362001)(66446008)(31686004)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: czBdPXI41gfja9r31bxcKgpSJJo1y0mMhU1yB6NXYcOXyFqpF6s6XKsUL3BNR7TrhGrzKtDQ6ZOByN6s1pMaAEB1XrbTjqNpp1HKNZJnW2nlG7Xszl26ohW+zWow/wVfypjgyyK4/a54fLjLyiHUeLXFtr/uzeyoDOr2Mhv/7XJAE6cKjxitnbsvqQgs/aMPc+7F7+uIGZJeu9K1TaTsBEGQc4GhmLRPB3EJn9ECUc8GLzsFi2WynlaaNd9bD0eplys6j9hBFKqJgeyxKPGiqd0u8H0blCOYA5JZH+VGt8AWGotg0N4HJh5PgX3bCWlKB5IGwU6KK4wOTRYiQVgv6uikAcAmnUUzr/l08QgqXl6uoeiHLmD4I3hTEc1+SdLB+3XqN7Q3ND7q6Bf3+2WH0naDikzQNh9fDsgHomYtnDo4jh0y9B+aGvqdLPxpXVtJD+T/XY6CO/fAjI33v/pTxFzdIxjJqSlte4DLKDG09R+POYPhEkHRKeLV5guu6m82fSP4zhTo7JXl4pLw4gnyNgrvLg90A+nmgSCzQDchAKlxbpixBkcTgwFnka9PEPjTFk2vpSzKHNMz2DprNmsO5qRu40/lhWfGu1ZEl7MY+pvN133g+Yyv6Lq55CGxXEn/8X6iay3fDdcOn7o3U1L9lcTFL/4CuPiihQDoJAKGwIs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A8E9C2AA99B4F408BF9489A2636E542@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e566ff-a792-4c98-c8e4-08d87a4de5fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 07:57:06.1500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MU0uVp+ACJDL//tpjTMDhpPe4OnWAGcaqYyucpxznh4O6cP14WOjfSWqXz3wovKzpTmZ3/5KxxaONz1cgbGW8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4661
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: rcdn-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMTAuMjAyMCAwMzoyOCwgSGFuZ2JpbiBMaXUgd3JvdGU6DQo+IEJhc2VkIG9uIFJGQyA4
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
Cj4gLS0tDQo+IHY1Og0KPiBPbmx5IGNoZWNrIG5leHRoZHIgaWYgaXB2Nl9za2lwX2V4dGhkcigp
IGRvZXMgbm90IHJldHVybiAtMS4gRm9yDQo+IElQUFJPVE9fTk9ORS9ORVhUSERSX05PTkUsIGxh
dGVyIGNvZGUgd2lsbCBoYW5kbGUgYW5kIGlnbm9yZSBpdC4NCj4NCj4gdjQ6DQo+IHJlbW92ZSB1
bnVzZWQgdmFyaWFibGUNCj4NCj4gdjM6DQo+IGEpIHVzZSBmcmFnX29mZiB0byBjaGVjayBpZiB0
aGlzIGlzIGEgZnJhZ21lbnQgcGFja2V0DQo+IGIpIGNoZWNrIHNvbWUgY29tbW9uIHByb3RvY29s
cycgaGVhZGVyIGxlbmd0aA0KPg0KPiB2MjoNCj4gYSkgTW92ZSBoZWFkZXIgY2hlY2sgdG8gaXB2
Nl9mcmFnX3JjdigpLiBBbHNvIGNoZWNrIHRoZSBpcHY2X3NraXBfZXh0aGRyKCkNCj4gICAgcmV0
dXJuIHZhbHVlDQo+IGIpIEZpeCBpcHY2X2ZpbmRfaGRyKCkgcGFyYW1ldGVyIHR5cGUgbWlzcyBt
YXRjaCBpbiBpc19pbmVsaWdpYmxlKCkNCj4NCj4gLS0tDQo+ICBuZXQvaXB2Ni9pY21wLmMgICAg
ICAgfCAgOCArKysrKysrLQ0KPiAgbmV0L2lwdjYvcmVhc3NlbWJseS5jIHwgMzMgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pY21wLmMg
Yi9uZXQvaXB2Ni9pY21wLmMNCj4gaW5kZXggZWM0NDhiNzFiZjlhLi44OTU2MTQ0ZWE2NWUgMTAw
NjQ0DQo+IC0tLSBhL25ldC9pcHY2L2ljbXAuYw0KPiArKysgYi9uZXQvaXB2Ni9pY21wLmMNCj4g
QEAgLTE1OCw3ICsxNTgsMTMgQEAgc3RhdGljIGJvb2wgaXNfaW5lbGlnaWJsZShjb25zdCBzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAgCQl0cCA9IHNrYl9oZWFkZXJfcG9pbnRlcihza2IsDQo+ICAJ
CQlwdHIrb2Zmc2V0b2Yoc3RydWN0IGljbXA2aGRyLCBpY21wNl90eXBlKSwNCj4gIAkJCXNpemVv
ZihfdHlwZSksICZfdHlwZSk7DQo+IC0JCWlmICghdHAgfHwgISgqdHAgJiBJQ01QVjZfSU5GT01T
R19NQVNLKSkNCj4gKw0KPiArCQkvKiBCYXNlZCBvbiBSRkMgODIwMCwgU2VjdGlvbiA0LjUgRnJh
Z21lbnQgSGVhZGVyLCByZXR1cm4NCj4gKwkJICogZmFsc2UgaWYgdGhpcyBpcyBhIGZyYWdtZW50
IHBhY2tldCB3aXRoIG5vIGljbXAgaGVhZGVyIGluZm8uDQo+ICsJCSAqLw0KPiArCQlpZiAoIXRw
ICYmIGZyYWdfb2ZmICE9IDApDQo+ICsJCQlyZXR1cm4gZmFsc2U7DQo+ICsJCWVsc2UgaWYgKCF0
cCB8fCAhKCp0cCAmIElDTVBWNl9JTkZPTVNHX01BU0spKQ0KPiAgCQkJcmV0dXJuIHRydWU7DQo+
ICAJfQ0KPiAgCXJldHVybiBmYWxzZTsNCj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L3JlYXNzZW1i
bHkuYyBiL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KPiBpbmRleCAxZjVkNGQxOTZkY2MuLmVmZmUx
ZDA4NmU1ZCAxMDA2NDQNCj4gLS0tIGEvbmV0L2lwdjYvcmVhc3NlbWJseS5jDQo+ICsrKyBiL25l
dC9pcHY2L3JlYXNzZW1ibHkuYw0KPiBAQCAtNDIsNiArNDIsOCBAQA0KPiAgI2luY2x1ZGUgPGxp
bnV4L3NrYnVmZi5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCj4gICNpbmNsdWRlIDxs
aW51eC9leHBvcnQuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC90Y3AuaD4NCj4gKyNpbmNsdWRlIDxs
aW51eC91ZHAuaD4NCj4gIA0KPiAgI2luY2x1ZGUgPG5ldC9zb2NrLmg+DQo+ICAjaW5jbHVkZSA8
bmV0L3NubXAuaD4NCj4gQEAgLTMyMiw3ICszMjQsOSBAQCBzdGF0aWMgaW50IGlwdjZfZnJhZ19y
Y3Yoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gIAlzdHJ1Y3QgZnJhZ19xdWV1ZSAqZnE7DQo+ICAJ
Y29uc3Qgc3RydWN0IGlwdjZoZHIgKmhkciA9IGlwdjZfaGRyKHNrYik7DQo+ICAJc3RydWN0IG5l
dCAqbmV0ID0gZGV2X25ldChza2JfZHN0KHNrYiktPmRldik7DQo+IC0JaW50IGlpZjsNCj4gKwlf
X2JlMTYgZnJhZ19vZmY7DQo+ICsJaW50IGlpZiwgb2Zmc2V0Ow0KPiArCXU4IG5leHRoZHI7DQo+
ICANCj4gIAlpZiAoSVA2Q0Ioc2tiKS0+ZmxhZ3MgJiBJUDZTS0JfRlJBR01FTlRFRCkNCj4gIAkJ
Z290byBmYWlsX2hkcjsNCj4gQEAgLTM1MSw2ICszNTUsMzMgQEAgc3RhdGljIGludCBpcHY2X2Zy
YWdfcmN2KHN0cnVjdCBza19idWZmICpza2IpDQo+ICAJCXJldHVybiAxOw0KPiAgCX0NCj4gIA0K
PiArCS8qIFJGQyA4MjAwLCBTZWN0aW9uIDQuNSBGcmFnbWVudCBIZWFkZXI6DQo+ICsJICogSWYg
dGhlIGZpcnN0IGZyYWdtZW50IGRvZXMgbm90IGluY2x1ZGUgYWxsIGhlYWRlcnMgdGhyb3VnaCBh
bg0KPiArCSAqIFVwcGVyLUxheWVyIGhlYWRlciwgdGhlbiB0aGF0IGZyYWdtZW50IHNob3VsZCBi
ZSBkaXNjYXJkZWQgYW5kDQo+ICsJICogYW4gSUNNUCBQYXJhbWV0ZXIgUHJvYmxlbSwgQ29kZSAz
LCBtZXNzYWdlIHNob3VsZCBiZSBzZW50IHRvDQo+ICsJICogdGhlIHNvdXJjZSBvZiB0aGUgZnJh
Z21lbnQsIHdpdGggdGhlIFBvaW50ZXIgZmllbGQgc2V0IHRvIHplcm8uDQo+ICsJICovDQo+ICsJ
bmV4dGhkciA9IGhkci0+bmV4dGhkcjsNCj4gKwlvZmZzZXQgPSBpcHY2X3NraXBfZXh0aGRyKHNr
Yiwgc2tiX3RyYW5zcG9ydF9vZmZzZXQoc2tiKSwgJm5leHRoZHIsICZmcmFnX29mZik7DQo+ICsJ
aWYgKG9mZnNldCA+PSAwKSB7DQo+ICsJCS8qIENoZWNrIHNvbWUgY29tbW9uIHByb3RvY29scycg
aGVhZGVyICovDQo+ICsJCWlmIChuZXh0aGRyID09IElQUFJPVE9fVENQKQ0KPiArCQkJb2Zmc2V0
ICs9IHNpemVvZihzdHJ1Y3QgdGNwaGRyKTsNCj4gKwkJZWxzZSBpZiAobmV4dGhkciA9PSBJUFBS
T1RPX1VEUCkNCj4gKwkJCW9mZnNldCArPSBzaXplb2Yoc3RydWN0IHVkcGhkcik7DQo+ICsJCWVs
c2UgaWYgKG5leHRoZHIgPT0gSVBQUk9UT19JQ01QVjYpDQo+ICsJCQlvZmZzZXQgKz0gc2l6ZW9m
KHN0cnVjdCBpY21wNmhkcik7DQo+ICsJCWVsc2UNCj4gKwkJCW9mZnNldCArPSAxOw0KPiArDQo+
ICsJCWlmIChmcmFnX29mZiA9PSBodG9ucyhJUDZfTUYpICYmIG9mZnNldCA+IHNrYi0+bGVuKSB7
DQoNClRoaXMgZG8gbm90IGNhdGNoIGF0b21pYyBmcmFnbWVudHMgKGZyYWdtZW50ZWQgcGFja2V0
IHdpdGggb25seSBvbmUgZnJhZ21lbnQpLiBmcmFnX29mZiBhbHNvIGNvbnRhaW5zIHR3byByZXNl
cnZlZCBiaXRzIChib3RoIDApIHRoYXQgbWlnaHQgY2hhbmdlIGluIHRoZSBmdXR1cmUuIEkgc3Vn
Z2VzdCB5b3Ugb25seSBjaGVjayB0aGF0IHRoZSBvZmZzZXQgaXMgMDoNCg0KZnJhZ19vZmYgJiBo
dG9ucyhJUDZfT0ZGU0VUKQ0KDQpTb3JyeSBmb3Igbm90IGNvbW1lbnRpbmcgb24gdGhpcyBlYXJs
aWVyLg0KDQo+ICsJCQlfX0lQNl9JTkNfU1RBVFMobmV0LCBfX2luNl9kZXZfZ2V0X3NhZmVseShz
a2ItPmRldiksDQo+ICsJCQkJCUlQU1RBVFNfTUlCX0lOSERSRVJST1JTKTsNCj4gKwkJCWljbXB2
Nl9wYXJhbV9wcm9iKHNrYiwgSUNNUFY2X0hEUl9JTkNPTVAsIDApOw0KPiArCQkJcmV0dXJuIC0x
Ow0KPiArCQl9DQo+ICsJfQ0KPiArDQo+ICAJaWlmID0gc2tiLT5kZXYgPyBza2ItPmRldi0+aWZp
bmRleCA6IDA7DQo+ICAJZnEgPSBmcV9maW5kKG5ldCwgZmhkci0+aWRlbnRpZmljYXRpb24sIGhk
ciwgaWlmKTsNCj4gIAlpZiAoZnEpIHsNCg0KDQo=
