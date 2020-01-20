Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2620F1427EC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 11:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgATKLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 05:11:14 -0500
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:41386 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATKLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 05:11:13 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 05:11:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1898; q=dns/txt; s=iport;
  t=1579515072; x=1580724672;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y4PSS1HiLM6yio6Og1r797AADovlk+wvVvhDAXFcleI=;
  b=Euo30rVx5olMAkypOk3SouV9MScye511C3ydIvKlqHXZ7uYWG0Z2QvfB
   +reKBLntclXVVI3E7j2/batkM/iXpBWZlDSfNUuI0C334E8psOprBJbsB
   l/lpGmF+hJ0oQxEfd1eZrD6vGAxLyGKt/NwM4Wlni2DJqBcGJlvOWaUY1
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ag1bHWxD4nPvGUuQQDKGoUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuLPPlczI3ENhqX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AQAgDEeSVe/4YNJK1lGwEBAQEBAQE?=
 =?us-ascii?q?FAQEBEQEBAwMBAQGBe4FUKScFbFggBAsqhBKDRgOKe4I6JZgOglIDVAkBAQE?=
 =?us-ascii?q?MAQEnBgIBAYRAAheBdiQ4EwIDDQEBBAEBAQIBBQRthTcMhV4BAQEBAgESERE?=
 =?us-ascii?q?MAQE3AQ8CAQgYAgImAgICMBUQAgQNAQcBAR6DBAGCSgMOIAECDJ9sAoE5iGF?=
 =?us-ascii?q?1gTKCfwEBBYUCGIIMAwaBDiqFGwyGbRqBQT+BOAyCKwcuPoEEAYFGGQQagV6?=
 =?us-ascii?q?CeYJekFWfAQqCOYc9jm4GG4JHmDCQJ4cYkiUCBAIEBQIOAQEFgWkigVhwFYM?=
 =?us-ascii?q?nUBgNiAEJDwuBBAEIgkOFFIU/dAIBAQeBHowmAQE?=
X-IronPort-AV: E=Sophos;i="5.70,341,1574121600"; 
   d="scan'208";a="698511382"
Received: from alln-core-12.cisco.com ([173.36.13.134])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Jan 2020 10:03:06 +0000
Received: from XCH-RCD-010.cisco.com (xch-rcd-010.cisco.com [173.37.102.20])
        by alln-core-12.cisco.com (8.15.2/8.15.2) with ESMTPS id 00KA35vo026102
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 20 Jan 2020 10:03:06 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-RCD-010.cisco.com
 (173.37.102.20) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 20 Jan
 2020 04:03:05 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 20 Jan
 2020 05:03:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 20 Jan 2020 04:03:04 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XN/rzQ3jlmO570iNnBKGwpaQOMjS1okIZ+ousThYnT4yCLxwDtk6CAbucMhWhgz8vmXZOPaC8qhBi+LA5wEpqZy1EiS+T12YemhgaCZ/oIU4sNM4gdxk5cJ2SlOLG7dwyMubvQ2rNhKjpEhu9+ha9EchWo+0M5ay9LmktgqFanLHMsV9zMpwuZ8xO2mlMHNzSY9LnvNvoAuFD6MMB8S474cePVixNJHAqfS9uXm7WyWCG/2Ld92be48TII48D1H7pnFQFFHsTEfQEsvy8cBGWCtbSHgAHsQp/j9LUw0GwfwsWo3r5kYzrMQX+um6m/i4Zv8gu9oFgKag3jM+OGT2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4PSS1HiLM6yio6Og1r797AADovlk+wvVvhDAXFcleI=;
 b=UFnYu70pU0UOZ0edP2sdOCAwxzAJzE7WMKtOXgdbLkXgPbwpZ2BYk/flCH7pdut/52WpLLCgq7B2JssB/Uj/b6oAwbmuGIIRLXd2HDuRZWywdX8z2PZIwvRaLOWdoywBLTqAyvgzvUj0CtWCkw9mSO99TTIKPjTx2TUBYQRuZoeOV4fPXWx3//KM/KdbQHwkKOM2pyIK+JyAjUpKLZvd6sTU0QWp9wyBNJYzKjSIfc5XQ8Ozp4hEQdbvWCR7KQUDL/OVGX1gVwm9EAmTUwPQMsgq3Ma9voF3GR2EdHT8yjVSeNDx7+uI45CSrYisY20yfO9VpNeTrewTfmaFqyYcmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4PSS1HiLM6yio6Og1r797AADovlk+wvVvhDAXFcleI=;
 b=X16m0EsVmWS2ZK0AqTEVqFl650oTYIl4bh88rAuf2AilCXjooSg7/RFbCg39O2U7ShXBXmQfY8+kZIOIf+sCX86hyHPxcBOuWY/maMtLmaNYiurtMgBO/c1yvgamNePGtAFiKSmp6/s3PQWdigwiQqIR4RALG3O869QWi+VX5Q4=
Received: from DM6PR11MB3866.namprd11.prod.outlook.com (20.176.126.161) by
 DM6PR11MB2793.namprd11.prod.outlook.com (20.176.96.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 10:03:03 +0000
Received: from DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::b1da:e7e1:c072:c9cf]) by DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::b1da:e7e1:c072:c9cf%5]) with mapi id 15.20.2644.026; Mon, 20 Jan 2020
 10:03:03 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Regression in macvlan driver in stable release 4.4.209
Thread-Topic: Regression in macvlan driver in stable release 4.4.209
Thread-Index: AQHVz3JzO8uHcCgc5kms+UsvKqCsC6fzURYAgAABnwA=
Date:   Mon, 20 Jan 2020 10:03:03 +0000
Message-ID: <2b7ca482-2eb1-212e-5118-42a672509400@cisco.com>
References: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
 <20200120095714.GA3421303@splinter>
In-Reply-To: <20200120095714.GA3421303@splinter>
Accept-Language: en-DK, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hegtvedt@cisco.com; 
x-originating-ip: [2001:420:44c1:2578:965c:d737:527:20d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c10add5d-ec3a-4cdc-e883-08d79d8ff07f
x-ms-traffictypediagnostic: DM6PR11MB2793:
x-microsoft-antispam-prvs: <DM6PR11MB2793FB1F6DE0CC5891B96728DD320@DM6PR11MB2793.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(189003)(199004)(66946007)(64756008)(66476007)(66556008)(66446008)(2616005)(478600001)(76116006)(91956017)(36756003)(966005)(2906002)(81166006)(4326008)(8676002)(81156014)(71200400001)(6916009)(54906003)(86362001)(5660300002)(186003)(31696002)(31686004)(316002)(8936002)(6486002)(6512007)(53546011)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2793;H:DM6PR11MB3866.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uYjrifb2NjQIPNUJsy11bvS2e3G1QSpjlQwEKiv8EouPmOET7JGLqcUG5jD48xOXBGA5srMlRthnDj07E2NuC6R9gxzereskN6zLySLdSgHoA9RqsP9PCck81Ry3P4LMd3RbNGt4aBWU7qHTcJ/STzCCZoFDzguHIWqvj6+kjQ6EvYZEQ8t0CJoddytYoNL4gEZIQ+HDBmaN2suHtO0zRDeTF/qRBNPzVpHKpSochBQNzjjBMRpbxySJ9nRlD63yi+Hdc9RzmtMSJJS4xFhVDK52Ew51/kIVN3nFD9hjxVqaGFM7HD/A93j8edRpVcD8Ib3OZl9xLq48zkd6BVsXIqOSqAY/k6Cq8Z7xV6Nd/xP6f80OrAAcNqXfk+cCJpfuHZF50/93MWswGu3SlQ7QVCOmparsnqy/g6GYcxX9xS4DiJUymR9OLfXD/E4XlBDmlOar275oTDg8DigiO2Tl7iPTWO0b72vSAQoNvnCtQwfEqn/bydPC0KW49+gdK7w0gmX104OaGEQGEJVu4bep3g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1C20F235229264EA6A517522B4BE740@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c10add5d-ec3a-4cdc-e883-08d79d8ff07f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 10:03:03.5374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUiF6hvC4xVsdNAb7n+fWsqutXByOmQqmnS2EXcZkAXqxvavXlM2OlvMjz+ncqAafFkmMRJzCLKaO1F4GPP/Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2793
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.20, xch-rcd-010.cisco.com
X-Outbound-Node: alln-core-12.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMDEuMjAyMCAxMDo1NywgSWRvIFNjaGltbWVsIHdyb3RlOg0KPiBPbiBNb24sIEphbiAy
MCwgMjAyMCBhdCAwOToxNzozNUFNICswMDAwLCBIYW5zLUNocmlzdGlhbiBFZ3R2ZWR0IChoZWd0
dmVkdCkgd3JvdGU6DQo+PiBIZWxsbywNCj4+DQo+PiBJIGFtIHNlZWluZyBhIHJlZ3Jlc3Npb24g
aW4gdGhlIG1hY3ZsYW4ga2VybmVsIGRyaXZlciBhZnRlciBMaW51eCBzdGFibGUNCj4+IHJlbGVh
c2UgNC40LjIwOSwgYmlzZWN0aW5nIGlkZW50aWZpZXMgY29tbWl0DQo+PiBodHRwczovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2NvbW1p
dC8/aD1saW51eC00LjQueSZpZD04ZDI4ZDdlODg4NTFiMTA4MWIwNWRjMjY5YTI3ZGYxYzhhOTAz
ZjNlDQo+IA0KPiBOb3RpY2VkIGl0IHRvbyBsYXN0IHdlZWsgKG9uIG5ldC1uZXh0KSwgYnV0IEVy
aWMgYWxyZWFkeSBmaXhlZCBpdDoNCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9MTcxMmIyZmZmOGM2
ODJkMTQ1Yzc4ODlkMjI5MDY5NjY0N2Q4MmRhYg0KPiANCj4gSSBhc3N1bWUgdGhlIHBhdGNoIHdp
bGwgZmluZCBpdHMgd2F5IHRvIDQuNC55IHNvb24gbm93IHRoYXQgaXQgaXMgaW4NCj4gbWFpbmxp
bmUuDQoNCkV4Y2VsbGVudCwgdGhhbmsgeW91IGZvciB0aGUgcXVpY2sgdXBkYXRlLg0KDQpJIHdp
bGwga25vdyB3aGF0IHRvIGxvb2sgZm9yIGluIHVwY29taW5nIDQuNC55IHJlbGVhc2VzLg0KDQo+
PiBUaGVyZSBzZWVtcyB0byBiZSBhIGhpc3RvcnkgYmVoaW5kIHRoaXMsIGFuZCBJIGRvIG5vdCBo
YXZlIHRoZSBmdWxsDQo+PiBvdmVydmlldyBvZiB0aGUgaW50ZW50aW9uIGJlaGluZCB0aGUgY2hh
bmdlLg0KPj4NCj4+IFdoYXQgSSBzZWUgb24gbXkgdGFyZ2V0LCBBYXJjaDY0IENQVSwgaXMgdGhh
dCB0aGlzIHBhdGNoIG1vdmVzIHRoZSBldGgNCj4+IHBvaW50ZXIgaW4gbWFjdmxhbl9icm9hZGNh
c3QoKSBmdW5jdGlvbiBzb21lIGJ5dGVzLiBUaGlzIHdpbGwgY2F1c2UNCj4+IGV2ZXJ5dGhpbmcg
d2l0aGluIHRoZSBldGhoZHIgc3RydWN0IHRvIGJlIHdyb25nIEFGQUlDVC4NCj4+DQo+PiBBbiBl
eGFtcGxlOg0KPj4gT3JpZ2luYWwgY29kZSAiZXRoID0gZXRoX2hkcihza2IpIg0KPj4gICAgICBl
dGggPSBmZmZmZmZjMDA3YTFiMDAyDQo+PiBOZXcgY29kZSAiZXRoID0gc2tiX2V0aF9oZHIoc2ti
KSINCj4+ICAgICAgZXRoID0gZmZmZmZmYzAwN2ExYjAxMA0KPj4NCj4+IExldCBtZSBrbm93IGlm
IEkgY2FuIGFzc2lzdCBpbiBhbnkgd2F5Li0tIA0KQmVzdCByZWdhcmRzLA0KSGFucy1DaHJpc3Rp
YW4gTm9yZW4gRWd0dmVkdA0K
