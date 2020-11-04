Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B012A6639
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgKDORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:17:42 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:8306 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgKDORl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6454; q=dns/txt; s=iport;
  t=1604499458; x=1605709058;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yqO1m6lVsnAmSh0xba40Z3tsBFuA4NgdVabKPWuq9SA=;
  b=SWTXHjvQ4R7Xm8POXWho2Uec7aPBxdYEwFPUz90jVvtsThqzsBX2LlPe
   2QfxfVUFNMGLm8KJ4+IR3C+kJ1+Y03mWndPStqPDvourVE6sQTjeCpmAH
   VA/caqorxVpSyPI9YeWB0JFsWxxBXxtrHjrtuPZk00bh09iONkUPdmnOL
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3AYvBLXRMfAck+A9MLwisl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEvK833lnEQYva7+5JkazRqa+zEWAD4JPUtncEfdQMUh?=
 =?us-ascii?q?IekswZkkQmB9LNEkz0KvPmLklYVMRPXVNo5Te3ZE5SHsutYVDOrHy28TMIXB?=
 =?us-ascii?q?LlOlk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B2CQCmt6Jf/4cNJK1iHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHgUkvLoQ9g0kDjSEugQSXe4JTA1QLAQEBDQEBLQI?=
 =?us-ascii?q?EAQGESgIXgXUCJTgTAgMBAQsBAQUBAQECAQYEcYVhDIVyAQEBAwESEQQNDAE?=
 =?us-ascii?q?BNwEPAgEIGAICJgICAjAVEAIEDQEFAgEBHoMEgkwDDiABpEgCgTuIaHZ/M4M?=
 =?us-ascii?q?EAQEFhQYYghAJgQ4qgnKDcYZXG4FBP4ERJ4I2NT6EBVCDAIJfkyc9pEEKgm2?=
 =?us-ascii?q?afQUHAx+hbbQRAgQCBAUCDgEBBYFrI4FXcBWDJFAXAg2OHzeDOopYdDgCBgo?=
 =?us-ascii?q?BAQMJfIsGgkYBAQ?=
X-IronPort-AV: E=Sophos;i="5.77,451,1596499200"; 
   d="scan'208";a="601387886"
Received: from alln-core-2.cisco.com ([173.36.13.135])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Nov 2020 14:17:33 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id 0A4EHXsn002833
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Nov 2020 14:17:33 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov
 2020 08:17:32 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Nov
 2020 08:17:32 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 4 Nov 2020 09:17:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2XTizG2zaWAiDXdAiIaQhLiE1/zTTYRK5kSgI8MbOHAE22ySgHVz+o9pV/EZQPmXMWMVsQi6k6O67O5rd7NMjvZSMkpk1awSgsvQFTNJayM07aOCOfSi5FozipCKhr2KdeCvh2hb4KkQYQej4gP/zK9QU8gIsb0mwcRPpZWjSiFRfXafoFFxFpJeCpVPaUfOBWnoEuyGTprN3u3IP2LiWcvzhV2JOHIh1NV5ysxlCiUi3yc7isrZUPv7lYDrFZTBR++Wm5LOFNh0YEv/0qexv2YW2kNKI0IMmNJEc1b73FDnM2mDzlss42BDhuwikV6l3m5a7hZgcTwgNf/wYIsvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqO1m6lVsnAmSh0xba40Z3tsBFuA4NgdVabKPWuq9SA=;
 b=ZbxBbnKWQuiVmZdvZTFHd2Ufz9SsZM2LD+9fLw4obiqURJqTL/Zpd+KXaQl+GZo8h3rBhHCJMfsb4tGw/4lWFi3abg/ctJ0Yz+816tNv6A9tRtuMZMN6ejQuojXvJXE9JI4ttm33ft0Eggiiwx5bCkpEMIEHnEUmfiVbhDGQCaQLhMDwRm3ACOTRCHod0jJ2KTwrUlxEjw50P5zOZJVqS6ROaSKRFO8X3F6mjqKpdlWPBFYWosZs273PtpmlN0S/7dCNTwgRCvTsv8meSPgvyTqO/dcxDsBOJJ0KlYiXfLIuUibpatn900z1ULogB3P446JaUmVPhGLmoVu3LL0apA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqO1m6lVsnAmSh0xba40Z3tsBFuA4NgdVabKPWuq9SA=;
 b=Ys5RhuKifaMfGe46JCz+GT0bhWvrfbocUI0sAwQmKCNdN0SS+WC3fi9oLk6mmUQaMy5pN8NaNPmYE84qkXbZnFQ6Pw9p9cluDMO33Eflw9XGFUHpdbrNTbS2muBkWIV2h0WCeOFq9DJvlny7WgDA8ETwJt5kN90VkzCqN1BlKQ8=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4221.namprd11.prod.outlook.com (2603:10b6:208:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Wed, 4 Nov
 2020 14:17:31 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 14:17:31 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net] ipv6/netfilter: Discard first fragment not including
 all headers
Thread-Topic: [PATCH net] ipv6/netfilter: Discard first fragment not including
 all headers
Thread-Index: AQHWsqrAoNuGOFGP40iuwHlgn8LXwKm3+wIAgAAKHgA=
Date:   Wed, 4 Nov 2020 14:17:31 +0000
Message-ID: <1c9d2225-de09-0eb1-9d5f-20331458d9a0@cisco.com>
References: <20201104130128.14619-1-geokohma@cisco.com>
 <20201104134118.GA28789@salvia>
In-Reply-To: <20201104134118.GA28789@salvia>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
authentication-results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1003::20a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc845c3a-b431-4ded-a1dd-08d880cc5e29
x-ms-traffictypediagnostic: MN2PR11MB4221:
x-microsoft-antispam-prvs: <MN2PR11MB42218F7A2B7EF7F21FE24FA1CDEF0@MN2PR11MB4221.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XyTxM18UhNJbAKc/7MdtKUC+ZIboq6DKShESfDrpnLu4DvLZhngNQB5G4AD6ZlFvgsybzdk4Qy15i5sgG8PEgHgfD/koD8+LUHRP8srkGIZLfGSVQ4iEN2SvZmGeZ2QBd4wEgXD6R6QX56zKeLulbLazMH15trOicZvkdoZtQmv17GZuBezjVIImFOVwC14P5ecCDnYuayII70rfGRwYlnTdbZGTxhKX3EyrNn55qkRupeFcYU88jBTDLeQEBxKdZyrMBnqwpS4jbYdOmr6WWgWfn50F0KsiiPvHCijpUsJWCKO9CP5n03AuqzsFUefWdCjx0hBUEJd4Sf2RjVnWlXJxiwHUM4O1caTQI5UrGFOswWOjoqskFGMC/2urZtf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(5660300002)(8936002)(71200400001)(83380400001)(91956017)(66476007)(2906002)(66556008)(31686004)(64756008)(8676002)(66446008)(36756003)(66946007)(76116006)(4326008)(86362001)(7416002)(31696002)(6506007)(2616005)(6512007)(6486002)(186003)(478600001)(6916009)(54906003)(316002)(53546011)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Vqoykl6LvhcT7kSD5RiqIaNmyYdv9osCA/1ZiL1JgDicGjZul4fjBlHO5h+8VisTcU0/4VM6RnzQMQ2kAuGF8YjFl9C70VEHSvvK+y4zmwW0o5tM8cJykvgy7O6MrD1A/YQs2me/mpbYNkepeXvgni/CyjaFitvkx7mic6SL+WKp0oPyZGfBJ7+ySaPufn8P4x5GnKG2EH3cvoWO65zHLfsdXFwUYmsEb4q0DzOAujVwLzvoAlDtWIuUr5737WdnoXiXNRTLXrFrOtl33t1QYnfdvDdr1gqzc5J+gkaoOJW32uG8tNNjRCsJTLP5BueeDimiUvoMbASS8mipT/ZB59qqPqiG0zh2C3BcL+kDdnNXzh6lRUIZ3mItyJ+8h9T2shpgrMHrOaBnTTrwpESoFGBSaqRX/BfMjPQ11xvU+vS1h++NEpp4PCH5vK+G2F+a7w+aWv5UZviWP60znmmqxbX4Imh266Clho2gaOfsNhi5znS92mD+MSL4YJSq+qYQv94qxuHKqxDiIXwDJMOB40DHhOrGmpn+p5jBsXNZI8gv/82hSXEU1CNHhHQqsskvH54g5K8XbPurWthrLok502Il+wDUnE3UHHu9mjRz6vJrjXznfLAAvNmL3TpHHaMwYwJ8o0v9ZmMHtQAHOOZTphK4VMxhFIMfOCGYKG7LudE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C562AC7D864C9488B291DB103260172@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc845c3a-b431-4ded-a1dd-08d880cc5e29
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 14:17:31.1277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKOyCKa+xTMpy0YvqUMqZ4s9Fhc14iLJ8qFl0ixMaRf87lRZNNLO6bpZCTYQ9TE4YI4FCLLhAsiKSFCmUZk96Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4221
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-2.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQuMTEuMjAyMCAxNDo0MSwgUGFibG8gTmVpcmEgQXl1c28gd3JvdGU6DQo+IEhpLA0KPg0K
PiBPbiBXZWQsIE5vdiAwNCwgMjAyMCBhdCAwMjowMToyOFBNICswMTAwLCBHZW9yZyBLb2htYW5u
IHdyb3RlOg0KPj4gUGFja2V0cyBhcmUgcHJvY2Vzc2VkIGV2ZW4gdGhvdWdoIHRoZSBmaXJzdCBm
cmFnbWVudCBkb24ndCBpbmNsdWRlIGFsbA0KPj4gaGVhZGVycyB0aHJvdWdoIHRoZSB1cHBlciBs
YXllciBoZWFkZXIuIFRoaXMgYnJlYWtzIFRBSEkgSVB2NiBDb3JlDQo+PiBDb25mb3JtYW5jZSBU
ZXN0IHY2TEMuMS4zLjYuDQo+Pg0KPj4gUmVmZXJyaW5nIHRvIFJGQzgyMDAgU0VDVElPTiA0LjU6
ICJJZiB0aGUgZmlyc3QgZnJhZ21lbnQgZG9lcyBub3QgaW5jbHVkZQ0KPj4gYWxsIGhlYWRlcnMg
dGhyb3VnaCBhbiBVcHBlci1MYXllciBoZWFkZXIsIHRoZW4gdGhhdCBmcmFnbWVudCBzaG91bGQg
YmUNCj4+IGRpc2NhcmRlZCBhbmQgYW4gSUNNUCBQYXJhbWV0ZXIgUHJvYmxlbSwgQ29kZSAzLCBt
ZXNzYWdlIHNob3VsZCBiZSBzZW50IHRvDQo+PiB0aGUgc291cmNlIG9mIHRoZSBmcmFnbWVudCwg
d2l0aCB0aGUgUG9pbnRlciBmaWVsZCBzZXQgdG8gemVyby4iDQo+Pg0KPj4gVXRpbGl6ZSB0aGUg
ZnJhZ21lbnQgb2Zmc2V0IHJldHVybmVkIGJ5IGZpbmRfcHJldl9maGRyKCkgdG8gbGV0DQo+PiBp
cHY2X3NraXBfZXh0aGRyKCkgc3RhcnQgaXQncyB0cmF2ZXJzZSBmcm9tIHRoZSBmcmFnbWVudCBo
ZWFkZXIuDQo+PiBBcHBseSB0aGUgc2FtZSBsb2dpYyBmb3IgY2hlY2tpbmcgdGhhdCBhbGwgaGVh
ZGVycyBhcmUgaW5jbHVkZWQgYXMgdXNlZA0KPj4gaW4gY29tbWl0IDJlZmRhYWFmODgzYSAoIklQ
djY6IHJlcGx5IElDTVAgZXJyb3IgaWYgdGhlIGZpcnN0IGZyYWdtZW50IGRvbid0DQo+PiBpbmNs
dWRlIGFsbCBoZWFkZXJzIikuIENoZWNrIHRoYXQgVENQLCBVRFAgYW5kIElDTVAgaGVhZGVycyBh
cmUgY29tcGxldGVseQ0KPj4gaW5jbHVkZWQgaW4gdGhlIGZyYWdtZW50IGFuZCBhbGwgb3RoZXIg
aGVhZGVycyBhcmUgaW5jbHVkZWQgd2l0aCBhdCBsZWFzdA0KPj4gb25lIGJ5dGUuDQo+Pg0KPj4g
UmV0dXJuIDAgdG8gZHJvcCB0aGUgZnJhZ21lbnQuIFRoaXMgaXMgdGhlIHNhbWUgYmVoYXZpb3Vy
IGFzIHVzZWQgb24gb3RoZXINCj4+IHByb3RvY29sIGVycm9ycyBpbiB0aGlzIGZ1bmN0aW9uLCBl
LmcuIHdoZW4gbmZfY3RfZnJhZzZfcXVldWUoKSByZXR1cm5zDQo+PiAtRVBST1RPLiBUaGUgRnJh
Z21lbnQgd2lsbCBsYXRlciBiZSBwaWNrZWQgdXAgYnkgaXB2Nl9mcmFnX3JjdigpIGluDQo+PiBy
ZWFzc2VtYmx5LmMuIGlwdjZfZnJhZ19yY3YoKSB3aWxsIHRoZW4gc2VuZCBhbiBhcHByb3ByaWF0
ZSBJQ01QIFBhcmFtZXRlcg0KPj4gUHJvYmxlbSBtZXNzYWdlIGJhY2sgdG8gdGhlIHNvdXJjZS4N
Cj4+DQo+PiBSZWZlcmVuY2VzIGNvbW1pdCAyZWZkYWFhZjg4M2EgKCJJUHY2OiByZXBseSBJQ01Q
IGVycm9yIGlmIHRoZSBmaXJzdA0KPj4gZnJhZ21lbnQgZG9uJ3QgaW5jbHVkZSBhbGwgaGVhZGVy
cyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBHZW9yZyBLb2htYW5uIDxnZW9rb2htYUBjaXNjby5jb20+
DQo+PiAtLS0NCj4+ICBuZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMgfCAy
OCArKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDI3IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjYv
bmV0ZmlsdGVyL25mX2Nvbm50cmFja19yZWFzbS5jIGIvbmV0L2lwdjYvbmV0ZmlsdGVyL25mX2Nv
bm50cmFja19yZWFzbS5jDQo+PiBpbmRleCAwNTRkMjg3Li5kZmZhM2E4IDEwMDY0NA0KPj4gLS0t
IGEvbmV0L2lwdjYvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19yZWFzbS5jDQo+PiArKysgYi9uZXQv
aXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMNCj4+IEBAIC00NDAsMTEgKzQ0MCwx
MyBAQCBmaW5kX3ByZXZfZmhkcihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1OCAqcHJldmhkcnAsIGlu
dCAqcHJldmhvZmYsIGludCAqZmhvZmYpDQo+PiAgaW50IG5mX2N0X2ZyYWc2X2dhdGhlcihzdHJ1
Y3QgbmV0ICpuZXQsIHN0cnVjdCBza19idWZmICpza2IsIHUzMiB1c2VyKQ0KPj4gIHsNCj4+ICAJ
dTE2IHNhdmV0aGRyID0gc2tiLT50cmFuc3BvcnRfaGVhZGVyOw0KPj4gLQlpbnQgZmhvZmYsIG5o
b2ZmLCByZXQ7DQo+PiArCWludCBmaG9mZiwgbmhvZmYsIHJldCwgb2Zmc2V0Ow0KPj4gIAlzdHJ1
Y3QgZnJhZ19oZHIgKmZoZHI7DQo+PiAgCXN0cnVjdCBmcmFnX3F1ZXVlICpmcTsNCj4+ICAJc3Ry
dWN0IGlwdjZoZHIgKmhkcjsNCj4+ICAJdTggcHJldmhkcjsNCj4+ICsJdTggbmV4dGhkciA9IE5F
WFRIRFJfRlJBR01FTlQ7DQo+PiArCV9fYmUxNiBmcmFnX29mZjsNCj4+ICANCj4+ICAJLyogSnVt
Ym8gcGF5bG9hZCBpbmhpYml0cyBmcmFnLiBoZWFkZXIgKi8NCj4+ICAJaWYgKGlwdjZfaGRyKHNr
YiktPnBheWxvYWRfbGVuID09IDApIHsNCj4+IEBAIC00NTUsNiArNDU3LDMwIEBAIGludCBuZl9j
dF9mcmFnNl9nYXRoZXIoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1MzIg
dXNlcikNCj4+ICAJaWYgKGZpbmRfcHJldl9maGRyKHNrYiwgJnByZXZoZHIsICZuaG9mZiwgJmZo
b2ZmKSA8IDApDQo+PiAgCQlyZXR1cm4gMDsNCj4+ICANCj4+ICsJLyogRGlzY2FyZCB0aGUgZmly
c3QgZnJhZ21lbnQgaWYgaXQgZG9lcyBub3QgaW5jbHVkZSBhbGwgaGVhZGVycw0KPj4gKwkgKiBS
RkMgODIwMCwgU2VjdGlvbiA0LjUNCj4+ICsJICovDQo+PiArCW9mZnNldCA9IGlwdjZfc2tpcF9l
eHRoZHIoc2tiLCBmaG9mZiwgJm5leHRoZHIsICZmcmFnX29mZik7DQo+PiArCWlmIChvZmZzZXQg
Pj0gMCAmJiAhKGZyYWdfb2ZmICYgaHRvbnMoSVA2X09GRlNFVCkpKSB7DQo+PiArCQlzd2l0Y2gg
KG5leHRoZHIpIHsNCj4+ICsJCWNhc2UgTkVYVEhEUl9UQ1A6DQo+PiArCQkJb2Zmc2V0ICs9IHNp
emVvZihzdHJ1Y3QgdGNwaGRyKTsNCj4+ICsJCQlicmVhazsNCj4+ICsJCWNhc2UgTkVYVEhEUl9V
RFA6DQo+PiArCQkJb2Zmc2V0ICs9IHNpemVvZihzdHJ1Y3QgdWRwaGRyKTsNCj4+ICsJCQlicmVh
azsNCj4+ICsJCWNhc2UgTkVYVEhEUl9JQ01QOg0KPj4gKwkJCW9mZnNldCArPSBzaXplb2Yoc3Ry
dWN0IGljbXA2aGRyKTsNCj4+ICsJCQlicmVhazsNCj4+ICsJCWRlZmF1bHQ6DQo+PiArCQkJb2Zm
c2V0ICs9IDE7DQo+PiArCQl9DQo+PiArCQlpZiAob2Zmc2V0ID4gc2tiLT5sZW4pIHsNCj4+ICsJ
CQlwcl9kZWJ1ZygiRHJvcCBpbmNvbXBsZXRlIGZyYWdtZW50XG4iKTsNCj4+ICsJCQlyZXR1cm4g
MDsNCj4+ICsJCX0NCj4+ICsJfQ0KPiBUaGlzIGNvZGUgbG9va3MgdmVyeSBzaW1pbGFyIHRvIDJl
ZmRhYWFmODgzYS4NCj4NCj4gV291bGQgeW91IHdyYXAgaXQgaW4gYSBmdW5jdGlvbiBhcyBjYWxs
IGl0IHVzZSB0byByZXVzZSBpdD8gU29tZXRoaW5nDQo+IGxpa2UgdGhpcyBza2V0Y2g/DQo+DQo+
IHN0YXRpYyBib29sIGlwdjZfZnJhZ192YWxpZGF0ZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCAuLi4p
DQo+IHsNCj4gICAgICAgICAuLi4NCj4NCj4gCW9mZnNldCA9IGlwdjZfc2tpcF9leHRoZHIoc2ti
LCBmaG9mZiwgJm5leHRoZHIsICZmcmFnX29mZik7DQo+IAlpZiAob2Zmc2V0ID49IDAgJiYgIShm
cmFnX29mZiAmIGh0b25zKElQNl9PRkZTRVQpKSkgew0KPiAJCXN3aXRjaCAobmV4dGhkcikgew0K
PiAJCWNhc2UgTkVYVEhEUl9UQ1A6DQo+IAkJCW9mZnNldCArPSBzaXplb2Yoc3RydWN0IHRjcGhk
cik7DQo+IAkJCWJyZWFrOw0KPiAJCWNhc2UgTkVYVEhEUl9VRFA6DQo+IAkJCW9mZnNldCArPSBz
aXplb2Yoc3RydWN0IHVkcGhkcik7DQo+IAkJCWJyZWFrOw0KPiAJCWNhc2UgTkVYVEhEUl9JQ01Q
Og0KPiAJCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCBpY21wNmhkcik7DQo+IAkJCWJyZWFrOw0K
PiAJCWRlZmF1bHQ6DQo+IAkJCW9mZnNldCArPSAxOw0KPiAJCX0NCj4gCQlpZiAob2Zmc2V0ID4g
c2tiLT5sZW4pDQo+IAkJCXJldHVybiBmYWxzZTsNCj4gCX0NCj4NCj4gICAgICAgICByZXR1cm4g
dHJ1ZTsNCj4gfQ0KPg0KPiB0aGVuLCBmcm9tIGlwdjY6DQo+DQo+ICAgICAgICAgaWYgKCFpcHY2
X2ZyYWdfdmFsaWRhdGUoc2tiLCAuLi4pKSB7DQo+ICAgICAgICAgICAgICAgICBfX0lQNl9JTkNf
U1RBVFMobmV0LCBfX2luNl9kZXZfZ2V0X3NhZmVseShza2ItPmRldiksDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJUFNUQVRTX01JQl9JTkhEUkVSUk9SUyk7DQo+
ICAgICAgICAgICAgICAgICBpY21wdjZfcGFyYW1fcHJvYihza2IsIElDTVBWNl9IRFJfSU5DT01Q
LCAwKTsNCj4gICAgICAgICAgICAgICAgIHJldXJuIC0xOw0KPiAgICAgICAgIH0NCj4NCj4gYW5k
IGZyb20gbmV0ZmlsdGVyOg0KPg0KPiAgICAgICAgIGlmICghaXB2Nl9mcmFnX3ZhbGlkYXRlKHNr
YiwgLi4uKSkNCj4gICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4NCj4gVGhhbmtzLg0KPg0K
VGhhbmtzIGZvciBmZWVkYmFjaywgSSB3aWxsIGRvIGFzIHN1Z2dlc3RlZC4NCg0KPj4gIAlpZiAo
IXBza2JfbWF5X3B1bGwoc2tiLCBmaG9mZiArIHNpemVvZigqZmhkcikpKQ0KPj4gIAkJcmV0dXJu
IC1FTk9NRU07DQo+PiAgDQo+PiAtLSANCj4+IDIuMTAuMg0KPj4NCg0K
