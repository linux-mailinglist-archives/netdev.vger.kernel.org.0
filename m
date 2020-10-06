Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980DF284E8B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJFPAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:00:12 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:60334 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJFPAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:00:12 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c86780002>; Tue, 06 Oct 2020 23:00:08 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 15:00:08 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 15:00:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIIQvHhoyCTZceXqQ3V1Z0zsQXsC0GnB7t4DyNtc2Kik49G+HHVJpW+T7RQUfI6XEwm83tmwmlCPMdxdqihFrcyRdq6tVPN5YVJMHs9WfVyvLc34O7BmSzG0rutAftVu8bSeGY19vPpgPo36VQyJj0zTXj9JUeAs8D5JdZ/TYEGXWl68YQWmAe+u98t9+g3sh3ivP65qL5ybnw2GfiyT3IPQ9RhvRMFteDpFlVtPFNiqKmoGAK7jinuMY3n/99PRl5PRyHuPfNZjDz8wmGNCwUBh84RtfIxATUal1hvRL//mPaWnIaBqmbbWwwz/MtZDhcGMErsC9X0HhZXXaLtUoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLqZ8UerVJu0vybRt9nuCySI6hVkYw1WUdSY9EVoyKA=;
 b=duhr+No3wgzcPIq6NjRgsTpQE7IzQ84ZKVE1rmoLBkmKU8/usLZUq4MKsaQo7kpwcjnPw1nopuyqXRbsMjZrL0rZcyH4rlHIfSBRqg2hzy2fv0nmhaWMiR0hY3rhJ9Qrnc326z3tq3+LWaK5FnvnKi9+C5vrIwUdmFRxFWkxDMjqedEDr02sDJDwFHXU76wk/fXIrawIFZejJT009O26B6NOfg8HfU9YD1S9YrwbhH2hVcjKzZJfw+lPcM2WO2Yol3xfSyL8m+qstXaTfv8gdmCWptqgg8kWI765dZyksc83Pb8lKqrA3fw0dqg0SGZ+r8GXMcGG2IOSrG4CfnlJ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB4282.namprd12.prod.outlook.com (2603:10b6:5:223::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Tue, 6 Oct
 2020 15:00:05 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 15:00:05 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [net-next v3 0/9] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Topic: [net-next v3 0/9] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Index: AQHWm/DHIYrwO1BtU0u+ogv0RzlIM6mKqtwA
Date:   Tue, 6 Oct 2020 15:00:05 +0000
Message-ID: <0e6cc78ebf37fcb4e2455cd331d250091e4c9ecc.camel@nvidia.com>
References: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201006145338.1956886-1-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e581457-2f3e-4c17-90c6-08d86a088267
x-ms-traffictypediagnostic: DM6PR12MB4282:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4282CCA3FEC0681FCFB03981DF0D0@DM6PR12MB4282.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+ZOl1kMgHljce9HJVXZupa/CyCGDILumeyx8e+Sx3GWPImP8Eys4I5yRRgot7tVORxPSVFh5fYlPEboMz4fkg0wRfTeWmceKQYAJH0EhkNW/ZjGRlysbiNGPcmLp/eSZQlP/RXFA3l4qUtuFvjH8WKGeG/e9DKkfDOVKBnzw+KRRNdH7e7WAc3cxugH7ki3JF955tH0RWVdf0dcH8W4Vhlj0opqHqS8Y+AX+qevxtkxVIpgW4O8Aap+w2nG9t7giD8DBTtY7RgGiyAEW0fKTu9PYDQQzKsE7EmncrBfLbg5UXZQHftZ2elw2xORY4rYRsu1s/rqGNPfGF1FC+lUc2PEKMXqRNbgCPs8YCjUpRWNnythtgGnCBoDjpi08w8BrSgcpq3dNurzJGCpd6r4V2QkqlB5hsOHUgVhzux0DKZurVOCpGRwrv6z39tCrysK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(91956017)(76116006)(6512007)(66946007)(66446008)(66476007)(66556008)(64756008)(110136005)(316002)(26005)(3450700001)(186003)(6506007)(83380400001)(2906002)(71200400001)(2616005)(8676002)(8936002)(36756003)(6486002)(86362001)(966005)(83080400001)(478600001)(5660300002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Xygja4fxnFwb+Wb8rbPaRDP394Zc/xW4qwa9OIv8gRJ6GcLFHdA/FgH0R+wxowv8fBgvWHy2PO0pA5wjVzuLJ4yTcim2cWiLuh/2z2rULAkD7zPsqUq2l1qc2ixgybRtamkPmHfMbV0Rhfv1C79fK8rFr1SlN4DfU4VeuztAosdfzNlPF6kAzX5GOMf3ZBliXJedsJuoPsFj2TIyIXBUI9c1RXzhxGtEB4UMinOnFcMk6ID3/v03DFz9p6s6xR68o2thOpCFr+YlRMkLLlXEvMNvnEHyNoDODG8EFMtlTeOgihuKU29j/mLdOOXrCMlR7/vbzwVe2AgTJKSdPwYGzoNYsIwzQHn4WZOZb93RhjfYjKHkOJHmUZvDeZVUJV9748VuA662ShTHtlXu6Rc12A8CPFpIALdC2ohpeoiU+Aydju/Tx6LNvakHuAYVDbQXb9JPm/ez+sowLkPXBflScIIE1jCzmd1CcvibNOuAZ/+v1Z/73AY4vqnqkVBW2OOCZtQO8iJQgUG4iQvlZrImHUbdi0B7A0MB9LCfwkjbt/1FaiAsZyzMbYFemenbIjxpjQc5z/dkYLHACmpGj7yTc9KFCP/g51yUcFcfGmJzUnGB8DBXqCtrbiGKwx/yNDtjjLosbJCtcGnAdYxtIeQ3YQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6432D25BADF6A428E763BFC89CF3E78@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e581457-2f3e-4c17-90c6-08d86a088267
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 15:00:05.1533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/wyZr1NMrKYnMtQ0BfvOvi87TfXSJUHBLQJJ19l+kauvdLoXB+axQROrnzEpCGl2pxG+N4WZRpGyYjc/bVLJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4282
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601996408; bh=jLqZ8UerVJu0vybRt9nuCySI6hVkYw1WUdSY9EVoyKA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
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
        b=nleTyEerJLHcDPYW8TxgqzEeZROKc7oTW6WMYSCmXMQewxjDSsySGh2hKUErBc96J
         pVf4bZ7pTHe7tJlALyuxPSLfERsdTTO+YLc7Cy/KjLjR2+wdXkSoQpXzuD0rqbxcR0
         vpLWXkeqAhC6DI/lqgFRIG/NxjCJTsFYKPVE5xyihmlViTuzvyGKh+QIK2lQ9aQeR3
         Xs0PmzdRLylIFBzjJEoiOTYbKiecynAPsWFeq/pSVSfCHrb+wuhi7h7S/bIwegdMEF
         GiHWWK661BSxH1EOyMSwSckP+RPIzOilSH82z+G+v0Eootg6oMj38bB0bzB1Lw77X/
         eI/Jzdso8457w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTA2IGF0IDE0OjUzICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gQ29ubmVjdGl2aXR5IEZhdWx0IE1hbmFnZW1lbnQgKENGTSkgaXMgZGVmaW5lZCBpbiA4
MDIuMVEgc2VjdGlvbiAxMi4xNC4NCj4gDQo+IENvbm5lY3Rpdml0eSBGYXVsdCBNYW5hZ2VtZW50
IChDRk0pIGNvbXByaXNlcyBjYXBhYmlsaXRpZXMgZm9yIGRldGVjdGluZywgdmVyaWZ5aW5nLA0K
PiBhbmQgaXNvbGF0aW5nIGNvbm5lY3Rpdml0eSBmYWlsdXJlcyBpbiBWaXJ0dWFsIEJyaWRnZWQg
TmV0d29ya3MuDQo+IFRoZXNlIGNhcGFiaWxpdGllcyBjYW4gYmUgdXNlZCBpbiBuZXR3b3JrcyBv
cGVyYXRlZCBieSBtdWx0aXBsZSBpbmRlcGVuZGVudCBvcmdhbml6YXRpb25zLA0KPiBlYWNoIHdp
dGggcmVzdHJpY3RlZCBtYW5hZ2VtZW50IGFjY2VzcyB0byBlYWNoIG90aGVy4oCZcyBlcXVpcG1l
bnQuDQo+IA0KPiBDRk0gZnVuY3Rpb25zIGFyZSBwYXJ0aXRpb25lZCBhcyBmb2xsb3dzOg0KPiAg
ICAg4oCUIFBhdGggZGlzY292ZXJ5DQo+ICAgICDigJQgRmF1bHQgZGV0ZWN0aW9uDQo+ICAgICDi
gJQgRmF1bHQgdmVyaWZpY2F0aW9uIGFuZCBpc29sYXRpb24NCj4gICAgIOKAlCBGYXVsdCBub3Rp
ZmljYXRpb24NCj4gICAgIOKAlCBGYXVsdCByZWNvdmVyeQ0KPiANCj4gVGhlIHByaW1hcnkgQ0ZN
IHByb3RvY29sIHNoaW1zIGFyZSBjYWxsZWQgTWFpbnRlbmFuY2UgUG9pbnRzIChNUHMpLg0KPiBB
IE1QIGNhbiBiZSBlaXRoZXIgYSBNRVAgb3IgYSBNSEYuDQo+IFRoZSBNRVA6DQo+ICAgICAtSXQg
aXMgdGhlIE1haW50ZW5hbmNlIGFzc29jaWF0aW9uIEVuZCBQb2ludA0KPiAgICAgIGRlc2NyaWJl
ZCBpbiA4MDIuMVEgc2VjdGlvbiAxOS4yLg0KPiAgICAgLUl0IGlzIGNyZWF0ZWQgb24gYSBzcGVj
aWZpYyBsZXZlbCAoMS03KSBhbmQgaXMgYXNzdXJpbmcNCj4gICAgICB0aGF0IG5vIENGTSBmcmFt
ZXMgYXJlIHBhc3NpbmcgdGhyb3VnaCB0aGlzIE1FUCBvbiBsb3dlciBsZXZlbHMuDQo+ICAgICAt
SXQgaW5pdGlhdGVzIGFuZCB0ZXJtaW5hdGVzL3ZhbGlkYXRlcyBDRk0gZnJhbWVzIG9uIGl0cyBs
ZXZlbC4NCj4gICAgIC1JdCBjYW4gb25seSBleGlzdCBvbiBhIHBvcnQgdGhhdCBpcyByZWxhdGVk
IHRvIGEgYnJpZGdlLg0KPiBUaGUgTUhGOg0KPiAgICAgLUl0IGlzIHRoZSBNYWludGVuYW5jZSBE
b21haW4gSW50ZXJtZWRpYXRlIFBvaW50DQo+ICAgICAgKE1JUCkgSGFsZiBGdW5jdGlvbiAoTUhG
KSBkZXNjcmliZWQgaW4gODAyLjFRIHNlY3Rpb24gMTkuMy4NCj4gICAgIC1JdCBpcyBjcmVhdGVk
IG9uIGEgc3BlY2lmaWMgbGV2ZWwgKDEtNykuDQo+ICAgICAtSXQgaXMgZXh0cmFjdGluZy9pbmpl
Y3RpbmcgY2VydGFpbiBDRk0gZnJhbWUgb24gdGhpcyBsZXZlbC4NCj4gICAgIC1JdCBjYW4gb25s
eSBleGlzdCBvbiBhIHBvcnQgdGhhdCBpcyByZWxhdGVkIHRvIGEgYnJpZGdlLg0KPiAgICAgLUN1
cnJlbnRseSBub3Qgc3VwcG9ydGVkLg0KPiANCj4gVGhlcmUgYXJlIGRlZmluZWQgdGhlIGZvbGxv
d2luZyBDRk0gcHJvdG9jb2wgZnVuY3Rpb25zOg0KPiAgICAgLUNvbnRpbnVpdHkgQ2hlY2sNCj4g
ICAgIC1Mb29wYmFjay4gQ3VycmVudGx5IG5vdCBzdXBwb3J0ZWQuDQo+ICAgICAtTGlua3RyYWNl
LiBDdXJyZW50bHkgbm90IHN1cHBvcnRlZC4NCj4gDQo+IFRoaXMgQ0ZNIGNvbXBvbmVudCBzdXBw
b3J0cyBjcmVhdGUvZGVsZXRlIG9mIE1FUCBpbnN0YW5jZXMgYW5kIGNvbmZpZ3VyYXRpb24gb2YN
Cj4gdGhlIGRpZmZlcmVudCBDRk0gcHJvdG9jb2xzLiBBbHNvIHN0YXR1cyBpbmZvcm1hdGlvbiBj
YW4gYmUgZmV0Y2hlZCBhbmQgZGVsaXZlcmVkDQo+IHRocm91Z2ggbm90aWZpY2F0aW9uIGR1ZSB0
byBkZWZlY3Qgc3RhdHVzIGNoYW5nZS4NCj4gDQo+IFRoZSB1c2VyIGludGVyYWN0cyB3aXRoIENG
TSB1c2luZyB0aGUgJ2NmbScgdXNlciBzcGFjZSBjbGllbnQgcHJvZ3JhbSwNCj4gdGhlIGNsaWVu
dCB0YWxrcyB3aXRoIHRoZSBrZXJuZWwgdXNpbmcgbmV0bGluay4NCj4gDQo+IEFueSBub3RpZmlj
YXRpb24gZW1pdHRlZCBieSBDRk0gZnJvbSB0aGUga2VybmVsIGNhbiBiZSBtb25pdG9yZWQgaW4g
dXNlciBzcGFjZQ0KPiBieSBzdGFydGluZyAnY2ZtX3NlcnZlcicgcHJvZ3JhbS4NCj4gDQo+IEN1
cnJlbnRseSB0aGlzICdjZm0nIGFuZCAnY2ZtX3NlcnZlcicgcHJvZ3JhbXMgYXJlIHN0YW5kYWxv
bmUgcGxhY2VkIGluIGEgY2ZtDQo+IHJlcG9zaXRvcnkgaHR0cHM6Ly9naXRodWIuY29tL21pY3Jv
Y2hpcC11bmcvY2ZtIGJ1dCBpdCBpcyBjb25zaWRlcmVkIHRvIGludGVncmF0ZQ0KPiB0aGlzIGlu
dG8gJ2lwcm91dGUyJy4NCj4gDQo+IHYyIC0+IHYzDQo+ICAgICBUaGUgc3dpdGNoZGV2IGRlZmlu
aXRpb24gYW5kIHV0aWxpemF0aW9uIGhhcyBiZWVuIHJlbW92ZWQgYXMgdGhlcmUgd2FzIG5vDQo+
ICAgICBzd2l0Y2hkZXYgaW1wbGVtZW50YXRpb24uDQo+ICAgICBTb21lIGNvbXBpbGluZyBpc3N1
ZXMgYXJlIGZpeGVkIGFzIFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4uDQo+IA0KDQpXZWxsLCBmdW5ueSB0aW1pbmcuIDopIEkganVzdCBmaW5pc2hlZCByZXZp
ZXdpbmcgdjIgaGFsZiBhbiBob3VyIGFnby4gQWxsIG9mIG15DQpjb21tZW50cyBmb3IgdjIgYXBw
bHkgZm9yIHRoaXMgdjMgc2V0LCBzb3JyeSBidXQgeW91J2xsIGhhdmUgdG8gZml4IGEgZmV3IG1v
cmUNCmlzc3Vlcy4NCg0KVGhhbmtzLA0KIE5paw0KDQo=
