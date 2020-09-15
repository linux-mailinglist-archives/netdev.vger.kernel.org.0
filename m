Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB0269F85
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgIOHUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 03:20:25 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:8353 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgIOHUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 03:20:20 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f606b300000>; Tue, 15 Sep 2020 15:20:16 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 00:20:16 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 15 Sep 2020 00:20:16 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 07:20:16 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 07:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVyFpNHomAcdACbHcr6tt9MTFY2qkq/mG2tKmutR6NS6+1lwIdw4n6UA7OMCuo0NtZCn++/EzuEkNkaE2MP6tUhJloMAo+L2tGW/YLP1PqhtbJTLTORl2T584PfNJ9/IOVHGCYYXx+YYqXeCcpfY+cEpQN+YMjBri/qP/d7reIWDqPX+hz9Ic1VHwJaSq++/97Sq3yJrkNMdQ6YNDMCtDZYW7DW8sqkXgPyVdaYbuj02vQUeDH5EaPjvLNmLX48uI4ryr5UGGTerCw3r/Kq0RD3grMFlsVMwA5WDmx0Gqb7ndssnqFm/DRdVMGx7Cw7YTjoHSbqurnTUG6dCWm7+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Df4FkxAInluNfl0N/+LRBa20ue45EjKExa+3bJBJ7Cc=;
 b=AWb9t4eAN4JbRWPPJJ8r6EHqPebBgRqNhmJSwYgRsA5ZqMZGAxgS72WirrzProC/b5PumR4DCvi5L/tjWzwADJ4AwLq8d3HO/impHwhfGAKd0xhg9Xidcn+do+oJECz+oQQchcBB71A5vRhJjPg+OssuqP31DRE6j6JvpFqxDsjwlioQkIsH/JzNYFfjPMlsHUzm8Ad+RDBrvvEo+EDITCyJwcQUU8B2b2jj+qiAYLwc17e8GZPAiM2h2zze1qyZ5K7R0bYgzU5K+QRl89QcXkHpSthaj02ASqI+MWUn6CCaZ2awxM0qGDFxeoBmPpqToo54L8DGbLS7RuCkomXwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB3462.namprd12.prod.outlook.com (2603:10b6:a03:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 07:20:14 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Tue, 15 Sep 2020
 07:20:14 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "jwi@linux.ibm.com" <jwi@linux.ibm.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "wintera@linux.ibm.com" <wintera@linux.ibm.com>,
        "ubraun@linux.ibm.com" <ubraun@linux.ibm.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: Re: [PATCH net-next 5/8] bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE
 notifier
Thread-Topic: [PATCH net-next 5/8] bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE
 notifier
Thread-Index: AQHWh5c8QoMZzIn0Pk+gAO3JQd5tg6lpUh+A
Date:   Tue, 15 Sep 2020 07:20:14 +0000
Message-ID: <ea877ec26ab6d552b8e54966446a7cf4d8698d86.camel@nvidia.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
         <20200910172351.5622-6-jwi@linux.ibm.com>
In-Reply-To: <20200910172351.5622-6-jwi@linux.ibm.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f93e36d7-399d-452f-bae7-08d85947ca21
x-ms-traffictypediagnostic: BYAPR12MB3462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3462C1A1AFD88F74C24FA36ADF200@BYAPR12MB3462.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eF1XHxDNZhL29LimcccK4R6GLAifHHxRpLU/FRql7Gp1RdseDxQQwqAwBIb6QhF79qxwjNEnqUngGV1h8rS9t/N/bycYv56kMOVx6Uo6RBhBea+Y0o9pQURHX/5EQ/xbH1iDGLQ979eLp0N+bY9OQI7R8rpK/5DhooJPXUXhms8to+YZzLlwh928GSdoR4ByFkypwpkWmQDVDOB8Kq4HKejsbYMICVph/ioyKBCa/hxWsPLS0saZcN2QwHCo0hB+StGaU9j9uQTZSH67mibWnTBuad60NPXaczkSyg+A06r0tkC4wdx4BQuSSKvtHjdwnrJuYHozI6Ff8gj1welEHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(316002)(2616005)(86362001)(36756003)(5660300002)(71200400001)(66946007)(91956017)(66446008)(64756008)(66556008)(66476007)(76116006)(4326008)(8676002)(54906003)(110136005)(6512007)(478600001)(6486002)(7416002)(8936002)(6506007)(3450700001)(186003)(26005)(2906002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Hw/UB99AD6RudT9yRfGNSpjhDCWUQecJOhCAOs3r2W4UP9FsdXO9H8qo9biCy7GKvUPrSsBCxEIJfOsgvAAlBPf4i5PrbGRNybacg2AYbKuNiaMqF6qJDG0JQXWmerz9IAL/6NXTSSGjnuH5wGcJo3RLNuvEWg54EkN+MPn7OvIsEFcPgvCFrEKbL1PrND9qMVUnqZgY00Cg/QcvTm1AjNIaCc4zJb5cETTLdXflu51agBJMH5CydVqfB8cbt3z0Irwc+5eCJYNi8xnQRdBzb0vprcPFRIfdDWcBRnSYn5OqDbA/OvcOypIiE2YQZdK24mDjpCEJtw5mrh5NFffvwc1eV1DMSjk18HIGf11YjLO/e7clUQJtO4mWRjkTFgp83uxk9u+G91yn88cPAzcv2W/rdqn279d5lcNxUxMa8LbsD1EN1kOBouCh+pu9mQDHctxt056swE/4saBIwFQSkbAYNtxmZQ5t7S5XnWh25muxSYRwL8TXeMVPswFRKbEUWaYy/TOey9l5cW4yZ9iuk+q7M19Wz+5qt8SZ4hBMxjpRMC32+ZdYm1bc8eNf6SHnbg4VCSL/ttwc9m5D/7HvaNz6uQBsjhrUfhWvIKof5KaH8mA0Va/VKSHx6MKT3gvdds9u5WqrpKTKL0BmxCiTtA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <375E128B5005FD4D9799D1A89194BE06@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93e36d7-399d-452f-bae7-08d85947ca21
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 07:20:14.1253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M7oQR6HWJwolllvh7D6Bq101oP1qh8OlyglP+CWWIgFdYD1soiNwCYia1p7t6MRXU+6kCxD90nfwrbc+jbHy2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3462
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600154416; bh=Df4FkxAInluNfl0N/+LRBa20ue45EjKExa+3bJBJ7Cc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Cb5gcRl/UNFxNvcjqyF2EmtK315lGV2J1rac8Hj2VC03tcFAYzA6Ratti0j6x9blo
         q41LPZLq0yTYXqIYeys0ylPX4c/KWrPnJTPRMQPcu84ev7hEElcfSs9NL1KO5XjW+R
         xKCB79v7RuREvT8cYqqrTbhY0JjgpjO1QVC/311eeqOdrzVpOIequ1VCjO5oQAhCqf
         4Y5e5Ui0QA2qKnXZsTo/QsZTfF34lI5cbhf1/5cBtlSxNzPmSlmgpsFc7kiqzyRqqX
         oIWpgzOP8WOTvh1ER174SKBCcvgQqaR9FfJNBD+DXllJtDkC8gIyrW3pHtu3uTTEwY
         Xj8/rrjo9Kz9w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA5LTEwIGF0IDE5OjIzICswMjAwLCBKdWxpYW4gV2llZG1hbm4gd3JvdGU6
DQo+IEZyb206IEFsZXhhbmRyYSBXaW50ZXIgPHdpbnRlcmFAbGludXguaWJtLmNvbT4NCj4gDQo+
IHNvIHRoZSBzd2l0Y2hkZXYgY2FuIG5vdGlmaXkgdGhlIGJyaWRnZSB0byBmbHVzaCBub24tcGVy
bWFuZW50IGZkYiBlbnRyaWVzDQo+IGZvciB0aGlzIHBvcnQuIFRoaXMgaXMgdXNlZnVsIHdoZW5l
dmVyIHRoZSBoYXJkd2FyZSBmZGIgb2YgdGhlIHN3aXRjaGRldg0KPiBpcyByZXNldCwgYnV0IHRo
ZSBuZXRkZXYgYW5kIHRoZSBicmlkZ2Vwb3J0IGFyZSBub3QgZGVsZXRlZC4NCj4gDQo+IE5vdGUg
dGhhdCB0aGlzIGhhcyB0aGUgc2FtZSBlZmZlY3QgYXMgdGhlIElGTEFfQlJQT1JUX0ZMVVNIIGF0
dHJpYnV0ZS4NCj4gDQo+IENDOiBKaXJpIFBpcmtvIDxqaXJpQHJlc251bGxpLnVzPg0KPiBDQzog
SXZhbiBWZWNlcmEgPGl2ZWNlcmFAcmVkaGF0LmNvbT4NCj4gQ0M6IFJvb3BhIFByYWJodSA8cm9v
cGFAbnZpZGlhLmNvbT4NCj4gQ0M6IE5pa29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlh
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJhIFdpbnRlciA8d2ludGVyYUBsaW51eC5p
Ym0uY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKdWxpYW4gV2llZG1hbm4gPGp3aUBsaW51eC5pYm0u
Y29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvbmV0L3N3aXRjaGRldi5oIHwgMSArDQo+ICBuZXQvYnJp
ZGdlL2JyLmMgICAgICAgICB8IDUgKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvc3dpdGNoZGV2LmggYi9pbmNs
dWRlL25ldC9zd2l0Y2hkZXYuaA0KPiBpbmRleCBmZjIyNDY5MTQzMDEuLjUzZThiNDk5NDI5NiAx
MDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9uZXQvc3dpdGNoZGV2LmgNCj4gKysrIGIvaW5jbHVkZS9u
ZXQvc3dpdGNoZGV2LmgNCj4gQEAgLTIwMyw2ICsyMDMsNyBAQCBlbnVtIHN3aXRjaGRldl9ub3Rp
Zmllcl90eXBlIHsNCj4gIAlTV0lUQ0hERVZfRkRCX0FERF9UT19ERVZJQ0UsDQo+ICAJU1dJVENI
REVWX0ZEQl9ERUxfVE9fREVWSUNFLA0KPiAgCVNXSVRDSERFVl9GREJfT0ZGTE9BREVELA0KPiAr
CVNXSVRDSERFVl9GREJfRkxVU0hfVE9fQlJJREdFLA0KPiAgDQo+ICAJU1dJVENIREVWX1BPUlRf
T0JKX0FERCwgLyogQmxvY2tpbmcuICovDQo+ICAJU1dJVENIREVWX1BPUlRfT0JKX0RFTCwgLyog
QmxvY2tpbmcuICovDQo+IGRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyLmMgYi9uZXQvYnJpZGdl
L2JyLmMNCj4gaW5kZXggYjZmZTMwZTM3NjhmLi40MDFlZWI5MTQyZWIgMTAwNjQ0DQo+IC0tLSBh
L25ldC9icmlkZ2UvYnIuYw0KPiArKysgYi9uZXQvYnJpZGdlL2JyLmMNCj4gQEAgLTE4Myw2ICsx
ODMsMTEgQEAgc3RhdGljIGludCBicl9zd2l0Y2hkZXZfZXZlbnQoc3RydWN0IG5vdGlmaWVyX2Js
b2NrICp1bnVzZWQsDQo+ICAJCWJyX2ZkYl9vZmZsb2FkZWRfc2V0KGJyLCBwLCBmZGJfaW5mby0+
YWRkciwNCj4gIAkJCQkgICAgIGZkYl9pbmZvLT52aWQsIGZkYl9pbmZvLT5vZmZsb2FkZWQpOw0K
PiAgCQlicmVhazsNCj4gKwljYXNlIFNXSVRDSERFVl9GREJfRkxVU0hfVE9fQlJJREdFOg0KPiAr
CQlmZGJfaW5mbyA9IHB0cjsNCj4gKwkJLyogRG9uJ3QgZGVsZXRlIHN0YXRpYyBlbnRyaWVzICov
DQo+ICsJCWJyX2ZkYl9kZWxldGVfYnlfcG9ydChiciwgcCwgZmRiX2luZm8tPnZpZCwgMCk7DQo+
ICsJCWJyZWFrOw0KPiAgCX0NCj4gIA0KPiAgb3V0Og0KDQpBY2tlZC1ieTogTmlrb2xheSBBbGVr
c2FuZHJvdiA8bmlrb2xheUBudmlkaWEuY29tPg0K
