Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4B227945
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgGUHJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:09:59 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:25871 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGUHJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 03:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2190; q=dns/txt; s=iport;
  t=1595315397; x=1596524997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kUGlyvApDQEKYUQtpIub8Hixt9gDeldJmjRproehhNQ=;
  b=k3xMVdWvmOyEta8TivGJyDwJtrv6Qu0wb88SuGKiGsxbD4DztSten3g1
   PBNMeZWQdvcCtPmxQdAP0bmU3fI5uPQUlQCTVnDyb0nun5kxTGXZqxZQa
   Y2bRYTWTcd/gsk1W+P4WPbYSHGi4urshblmO1FEzJmI3tTTQYd3Ryql9T
   Y=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ay/W4RhNb2ZnNqchRYjEl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEvK833lPAQ4je7/VKl6zQvryzEWAD4JPUtncEfdQMUh?=
 =?us-ascii?q?IekswZkkQmB9LNEkz0KvPmLklYVMRPXVNo5Te3ZE5SHsuta1TMr3i26jAOXB?=
 =?us-ascii?q?PyKVk9KuH8AIWHicOx2qi78IHSZAMdgj27bPtyIRy6oB+XuNMRhN5pK706zV?=
 =?us-ascii?q?3CpX4bdg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AeCADdkxZf/5hdJa1gHQEBAQEJARI?=
 =?us-ascii?q?BBQUBQIFKgVJRB4FHLywKhCmDRgONJiWYXoJTA1ULAQEBDAEBLQIEAQGETAI?=
 =?us-ascii?q?XggoCJDgTAgMBAQsBAQUBAQECAQYEbYVcDIVxAQEBAwESEQQNDAEBNwEECwI?=
 =?us-ascii?q?BCA4GAQUCJgICAjAVEAIEDgUigwSCTAMOHwEBoQkCgTmIYXZ/M4MBAQEFhRk?=
 =?us-ascii?q?Ygg4JFHoqgmqDVYYzghqBOAwQgk0+hD0Xgn8zgi2BRwGQUjyidQYEgl2ZYwM?=
 =?us-ascii?q?egnqJPpMQsQACBAIEBQIOAQEFgWojgVdwUCoBc4FLUBcCDY4eg3GKVnQ3AgY?=
 =?us-ascii?q?BBwEBAwl8jigBgRABAQ?=
X-IronPort-AV: E=Sophos;i="5.75,377,1589241600"; 
   d="scan'208";a="546534888"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Jul 2020 07:09:57 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id 06L79uqO029154
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 21 Jul 2020 07:09:56 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 02:09:56 -0500
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jul
 2020 03:09:55 -0400
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 21 Jul 2020 02:09:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtdQTZyPrxKcagp0dKV/LdUUoX8H9SQTxRh9h75lf1+wwZDMZ9KjppqlHSCq7r1rSRd/QkWx1OBIVK41BDNwG77uN6xEKnJOKgtQyknMH/OhqU9Yy56mJxDX2oPYsE8bp7L5v/SRcWQKTRPAybEBvhbA3sdp0rq1JkQJLC21iNaM1/vcNmGZiBELADCvNECbw/IvXu+jviJK4kHhcXt7AQjL6jV4MalI4hwhpGP/+9xm1WBFGamC5kPzRBuaNk+q+1t2ejgg9R44CDFdyIGFVsXL3qkU8yyFDe0hLVkheqSpcf5nZG9onHQqDy+s7DISclQQl43MLl4GmwCW7Le1SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUGlyvApDQEKYUQtpIub8Hixt9gDeldJmjRproehhNQ=;
 b=DwFVD4QL5yw3aTVTZAff4/K+X1iZnkq044SZeKgoXJMJPXexY4ddtPqSBe2IpzItqmg7U/GQ8V37hTYb6t0gr4TxRGFjepCXkwjDuMAQh8urZK9mBa4EehdSyutaoEn6R7AFkt3C7Og2HLuHR2gupo3/NHsA04t2+TiEXTGMbAqo4sTc51D4mmaRvFBBL3oIQ0t+EBseAijRNN6F3RnuR3LOBSKW+4k/sDFYp9zdqlkSKlo8BOFzbvrZtjOG++aPqVVPDODbtyK+AeotXBJSuilwQVo+kHR+RKXTgaa8knEPLzdoMCRHSY/ct242rOsUCgNDvRbROPzEp6wPNGx8BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUGlyvApDQEKYUQtpIub8Hixt9gDeldJmjRproehhNQ=;
 b=bGH8E0icW4W9R3rlTs3qnyo9wnHZEBBMqaETpGaQRzgK+/ZPc45Jx8UQ6rs7oxjotf0zLCwc2Z3gruiUR05SB97sAjIwamcH8WACAKCiYSvPovxadudOGqeopqbyOFDPw/afjZrfnE5MsBFKnFh/0tAPCWWAYNRfrkwb35wkDSw=
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by CY4PR11MB1351.namprd11.prod.outlook.com
 (2603:10b6:903:26::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 07:09:54 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766%11]) with mapi id 15.20.3195.025; Tue, 21 Jul
 2020 07:09:54 +0000
From:   "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Topic: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Index: AQHWXu1TxveMQ7VN0USTIMVfIXoTpqkR+jQA
Date:   Tue, 21 Jul 2020 07:09:53 +0000
Message-ID: <292C3F77-60F5-4D24-8541-BCAE88C836AF@cisco.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
 <20200720.162726.1756372964350832473.davem@davemloft.net>
In-Reply-To: <20200720.162726.1756372964350832473.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.39.20071300
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [106.51.23.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3e058ca-65f0-4bb1-44a3-08d82d451180
x-ms-traffictypediagnostic: CY4PR11MB1351:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB1351E2B730D0D53664E9560D90780@CY4PR11MB1351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1jk8vZGow5O8lACrg4G6AkZPUdRc8+AcaohIKme4r6CQLzaPxqUCAJ+4WIlGfy3bKTxszoudF7Kf9uEn8YFHJ0m2hxiEAePoUndOM2iQi7hohT6PEN6E24aQCi9Qu/idMlbOlwRp66h+NKDjuYYuqQy157QysFlRXqHirAahlfDe07yun7jnH4lC9P8EJSBtZZSM9h/8j1i51yJ6fpYyvkC/G3rRr6SzkCrlSZtrmfZRBkuhhWAHiUeJ0D9+GWCfT5SaCZBGaRoz0W7LMsHY+nVnktoSzuNiv/94lkeS9E3W9y086L4PV3OxfgBfB8bV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(316002)(2616005)(5660300002)(64756008)(8676002)(8936002)(186003)(66446008)(6506007)(66556008)(55236004)(86362001)(66476007)(66946007)(26005)(76116006)(91956017)(54906003)(36756003)(71200400001)(6486002)(6916009)(478600001)(4326008)(2906002)(6512007)(83380400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ubxxnkAGmmwKrI0SnLWi25qgfrb6Nmfyr/Y9w2opRek3fgZkcbYp+dpKaBZmBKaTlU5V3eVeEKQu55mK2aoaLmn2ajER8b1CYB9l5j8lm5bQ4ltANqe/NsCexwndV6+nc0TykGCOyOdgpxHzu530QGZifaYcHx+kzV5OvK7GDPqWz/NeLsurD7BdcSowHIKotB5+9igVr8GSiZRRnNSZOgFmYcAhNTOHbcMUw0WCg+LiAd0zfEqJwzM5udMBlzd7qh8187I1c1Tw8Xm2A1CpzpGy5jZW04DS3Lbbe3sPxH4QnCOk24VWjjwIGGuGvnm1fImvg+dDoEQxFo7Q2zPKhmsbpdn/vO0ybfTed6/Z/hchzZ1JZiJ1TEhCNzf1AtPo6h/5lwcJgydyBJaFxJ/iuU8Qa/TX1xxwfAY2Av8HR/ZApkzqaA66JxD5s7LXP1yJLsAQiVZ1nh0K+ep5mQ9IE3wOoQqd6NQrvxn/4FcXZHM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4F6D9CC85B4674E8D0C28254345B78E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e058ca-65f0-4bb1-44a3-08d82d451180
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 07:09:53.8419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOHZxciRK0lak69hBp8yGJKnyodrY9eHqwFoUqfPVdXNqLxzwu9d+jqCEp5CQT03Ldehh8dZFSlUzYjcOIR+ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1351
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-1.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDIxLzA3LzIwLCA0OjU3IEFNLCAiRGF2aWQgTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD4gd3JvdGU6DQoNCiAgICBGcm9tOiBTcmlyYW0gS3Jpc2huYW4gPHNyaXJha3IyQGNp
c2NvLmNvbT4NCiAgICBEYXRlOiBNb24sIDIwIEp1bCAyMDIwIDIyOjE1OjUxICswNTMwDQoNCiAg
ICA+ICsJaWYgKHNrYi0+cHJvdG9jb2wgPT0gaHRvbnMoRVRIX1BfODAyMVEpKSB7DQogICAgPiAr
CQl1MTYgdmxhbl90Y2kgPSAwOw0KICAgID4gKwkJc2tiX3Jlc2V0X21hY19oZWFkZXIoc2tiKTsN
Cg0KICAgPiBQbGVhc2UgcGxhY2UgYW4gZW1wdHkgbGluZSBiZXR3ZWVuIGJhc2ljIGJsb2NrIGxv
Y2FsIHZhcmlhYmxlIGRlY2xhcmF0aW9ucw0KICAgPiBhbmQgYWN0dWFsIGNvZGUuDQoNCiAgICA+
ICsJCQkJbmV0ZGV2X2VycihuZXQsIlBvcCB2bGFuIGVyciAleFxuIixwb3BfZXJyKTsNCg0KICAg
ID4gQSBzcGFjZSBpcyBuZWNlc3NhcnkgYmVmb3JlICJwb3BfZXJyIi4NCg0KQ29uc29saWRhdGVk
IGxpc3Qgb2YgY29tbWVudHMgYWRkcmVzc2VkOg0KPiAxLiBCbGFuayBsaW5lIGJldHdlZW4gZGVj
bGFyYXRpb24gYW5kIGNvZGUuDQpEb25lDQoNCj4gMi4gRXJyb3IgaGFuZGxpbmcgaXMgZGlmZmVy
ZW50IHRoYW4gb3RoZXIgcGFydHMgb2YgdGhpcyBjb2RlLg0KPsKgwqAgcHJvYmFibHkganVzdCBu
ZWVkIGEgZ290byBkcm9wIG9uIGVycm9yLg0KRG9uZQ0KDQo+IEl0IHNlZW1zIGxpa2UgeW91IGFy
ZSBwdXR0aW5nIGludG8gbWVzc2FnZSwgdGhlbiBkcml2ZXIgaXMgcHV0dGluZw0KPiBpdCBpbnRv
IG1ldGEtZGF0YSBpbiBuZXh0IGNvZGUgYmxvY2suIE1heWJlIGl0IHNob3VsZCBiZSBjb21iaW5l
ZD8NCk5vdCBkb25lDQpUaGlzIHdhcyBvbiBwdXJwb3NlLiBNZXJnaW5nIHRoZSB0d28gY29kZSBi
bG9ja3MgbWlnaHQgYnJlYWsgZXhpc3RpbmcgZnVuY3Rpb25hbGl0eS4NClRoZXJlIGNvdWxkIGJl
IG90aGVyIG1vZGVzIHdoZXJlIHRoZSBwYWNrZXQgYXJyaXZlcyB3aXRoIDgwMi4xcSBhbHJlYWR5
IGluIHRoZQ0KU2tiIGFuZCB0aGUgc2tiLT5wcm90b2NvbCBuZWVkbuKAmXQgYmUgODAyLjFxLg0K
DQo+IHBhY2tldC0+dG90YWxfYnl0ZXMgc2hvdWxkIGJlIHVwZGF0ZWQgdG9vLg0KTm90IGRvbmUu
DQpUaGUgdG90YWxfYnl0ZXMgbmVlZHMgYmUgdGhlIHRvdGFsIGxlbmd0aCBvZiBwYWNrZXQgYWZ0
ZXIgdGhlIGhvc3QgT1MgYWRkcyB0aGUgODAyLjFxIGhlYWRlciBiYWNrIGluDQpiZWZvcmUgdHgu
IFVwZGF0aW5nIHRoZSB0b3RhbF9ieXRlcyB0byAtPSBWTEFOX0hFQURFUiB3aWxsIGxlYWQgdG8g
cGFja2V0IGRyb3AgaW4gdGhlIEhvc3QgT1MgZHJpdmVyLg0KDQo+IEFsc28gbmV0dnNjIGFscmVh
ZHkgc3VwcG9ydHMgdmxhbiBpbiAicmVndWxhciIgY2FzZXMuIFBsZWFzZSBiZSBtb3JlIHNwZWNp
ZmljIGluIHRoZSBzdWJqZWN0Lg0KPiBTdWdnZXN0ZWQgc3ViamVjdDogaHZfbmV0dnNjOiBhZGQg
c3VwcG9ydCBmb3IgdmxhbnMgaW4gQUZfUEFDS0VUIG1vZGUNCkRvbmUNCg0KPiBBIHNwYWNlIGlz
IG5lY2Vzc2FyeSBiZWZvcmUgInBvcF9lcnIiLg0KRG9uZQ0KDQpVcGxvYWRlZCBwYXRjaCB2NA0K
DQo=
