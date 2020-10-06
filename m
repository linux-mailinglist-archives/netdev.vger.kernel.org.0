Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F864284DAB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJFO3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:29:40 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2727 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFO3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:29:40 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c7f1d0000>; Tue, 06 Oct 2020 07:28:45 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 14:29:39 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 14:29:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFL/eUP0EogF+aajwn7F78+Ogm9eN+V9xbBfrPgZxD1bMmgDGkP+P7H97fBc9uITJuIgCjF4j3ZMIchAAPFYi/oKlr0H8nXqSae8fb82veY+ZzxoYnjpe8+Wm8+/vFeMKp4oFLfF9hW9lh0X21NUOGGzpT8IxBMZoAE0w03J9V/uIikCyvPrez9by5/JaAhSu+t1y5dhoiSHSs7jYkw4t7z/TKGAlfcED/dsK5tR51ILlYz0besIPEr94hd+/0BiZujVjogCkpS7zbt3oCcOnfH6JAfn4pbefPiaFm9qnbzCttA9+0f8Ys9Jky+N7fPmWkx93GV2oRXhDsRHYEDfUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kz6aOBBIIQTOjL8bAi6bVp7sYXO11BpZat9qbRoBmCk=;
 b=LtaMxLVgbG0ndI4rTl4it4+VeTb/RuEKVIi+Cetc7X2f2X2YPO4SXSE+X8a6wRMB57vod3oyHmlSEVhZFLr0oqjZYIerKk5aJJqleC/qOgkZKawZgBeLC9Mm2WkgS0vUP2dY3ANuiQqhg0cXNM+mU6l/5jnKY6/bFjNixoR8OiR+NVtGl+OAwrj8DUPf/wG8Uw3FHvcvcmt60QA2FwsPbr3M3KTX64pNa8Qv36PhbBRhR+95fH92k0BR6LzLwFcVryqyBnT2nQvlR7AVr9IORwJtDCuVe7KTutBwzpTUG/gT4jUIAKNukhe4YBHjCyCo4t3nsVJqP5zeYHnt6r88HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM5PR1201MB0043.namprd12.prod.outlook.com (2603:10b6:4:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Tue, 6 Oct
 2020 14:29:38 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 14:29:38 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [net-next v2 04/11] bridge: cfm: Kernel space implementation of
 CFM.
Thread-Topic: [net-next v2 04/11] bridge: cfm: Kernel space implementation of
 CFM.
Thread-Index: AQHWl9432iLK82Bl1UOLPLS3Dj0fVamKqn+A
Date:   Tue, 6 Oct 2020 14:29:37 +0000
Message-ID: <719888fec794af74b375f589bc2d185fea8fc2e1.camel@nvidia.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
         <20201001103019.1342470-5-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201001103019.1342470-5-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: a57b6a7f-5ac7-4e3a-91f9-08d86a044158
x-ms-traffictypediagnostic: DM5PR1201MB0043:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB004345C23AFF6FE1C5A71538DF0D0@DM5PR1201MB0043.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wC+ORD2dfGGKU/6HWT54Ppu9C6tDzdYfWWrvgIBkaJJZ+PBzntymN0Sc0s/Zl+in5FjWmxGjX3F9ZcjOYDm7KNRz/fx8Zxj9XgXoBkN6oB7kJmPSppsrjB12Zny6g9I4wlLCi8BEgH411urerBd+PRJRA3N7O17UFwb6K6SAHokD7kOnct1c+aNW5lAqobYliGpXIGoh+UOzvr6yoOCipQduQ1vMtZZRQ+R45lrBPMytpkHv9DQ6L6WI2bnu6g20qwIubinkakizq51NoJJ6AEL/d6itBj4G2RKggpG/16Y1OU8NtSKtW1fSX2ts429a7Y1bfuip4RA/bPOYGYdN7Cvme60gqliiyV0u/N0LrfZ4JKb5PZoS9bJOBsMNTiGI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(6506007)(66556008)(478600001)(26005)(6486002)(186003)(2616005)(83380400001)(66946007)(71200400001)(4326008)(316002)(8936002)(110136005)(64756008)(66446008)(66476007)(36756003)(8676002)(76116006)(2906002)(3450700001)(6512007)(91956017)(5660300002)(86362001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9l2G90g1stxNVH1fyD0ndZ1YAso6K8Kw5AKRhKLuvazxXhJf/PA2ooKjILDcVmmL0J5Tr4X1egg54ZPgzqH6vw8B3mEUj9F+TkUsl0jPvBPncfQVAL90HsvR9mU9mXyLG930a5EcLwZj6mOhd5Tu1JG7DKMOwCJLUsJiScvFiNQZsbIVTSBkcknYWas02N9ksqDasKWMaRd6wFSzkPkeJhC/tDvzzMwBJNOT0qObhpZh3+7bHK/7OnisfiZbICkfxLP36XhMhCPUa4/7h+18VGTZElnKdaifXfzgpuRBQ0/7Tvj1oTiJAGQDpmoo3BOHWILi0hFfBf3agrO93+a3RxjbJMQ3A6yXJjLnvsDO/o5Q57azcCd1KvuSo9d0i6Plt6zYrxlmIZpYTl4tz159AOZCry7NqacuVxtWPb28deOUykIQM/d8jd/S8vLwAkTUY8RHElOxRr+KrvGuaejJL8lyFyMCKOEe9JyHwcQcokJT+wPmX4nZ3MgWC38KY8LdGdH33/xAq1vzUUBoFYDKqp4iDgqRlVdqGTv+pNLaoY2GsxpLJ+Y8KA1xnnpOJYwi6meHrsuRaSFitQ5uFzVBJR45LFyyYUC90+PkWGRTYXXlS0NAvTPLEhT8qxJBiV5yhfLYm4zJX0BvGOOova5NYg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <32389BFF12E3A047BB5A6E0C4E996E58@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57b6a7f-5ac7-4e3a-91f9-08d86a044158
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 14:29:37.9673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWqJJXOd8jhOLm+6vZwdAuIyz3I35XemdOMLq7qQgiHG8iWGVy7FRwX6K/+ZYeujmdOrPR4ckzPxMpKEigd47A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0043
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601994525; bh=kz6aOBBIIQTOjL8bAi6bVp7sYXO11BpZat9qbRoBmCk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
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
        b=OdwPf0V5QyUrmtHPwqwVKc/UYDWgoffkRh/F8qDinOPSYW98pwtFcDMZd/ogx8+Mv
         THaOSkKGjD9Eekfr6MKKNZ+s0U1Lb8dvIQYURtxJGtpgv6biC+Nufhqj6jdAJmIPDa
         l36Y0CWNOgnpLLvgBF//ha1rBcgbVkCe5wnFfvCP6EpLxZL9Gre90bXcZNJAztLH89
         Wx6bzVzeZmkZoRSrM/PXJAPCaWlhTMcMK18vqZ4EvL1GUYecOLQC2wtYghV57yY9y+
         nnT0kTI7vXvQH4l7n09NWcAjyhT3RjRgZOog+bZTYZm3AILhnz5Bq535ipWsfjSrQf
         wEEunkCpSeGQQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTAxIGF0IDEwOjMwICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgZmlyc3QgY29tbWl0IG9mIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0
aGUgQ0ZNIHByb3RvY29sDQo+IGFjY29yZGluZyB0byA4MDIuMVEgc2VjdGlvbiAxMi4xNC4NCj4g
DQo+IENvbm5lY3Rpdml0eSBGYXVsdCBNYW5hZ2VtZW50IChDRk0pIGNvbXByaXNlcyBjYXBhYmls
aXRpZXMgZm9yDQo+IGRldGVjdGluZywgdmVyaWZ5aW5nLCBhbmQgaXNvbGF0aW5nIGNvbm5lY3Rp
dml0eSBmYWlsdXJlcyBpbg0KPiBWaXJ0dWFsIEJyaWRnZWQgTmV0d29ya3MuIFRoZXNlIGNhcGFi
aWxpdGllcyBjYW4gYmUgdXNlZCBpbg0KPiBuZXR3b3JrcyBvcGVyYXRlZCBieSBtdWx0aXBsZSBp
bmRlcGVuZGVudCBvcmdhbml6YXRpb25zLCBlYWNoDQo+IHdpdGggcmVzdHJpY3RlZCBtYW5hZ2Vt
ZW50IGFjY2VzcyB0byBlYWNoIG90aGVyPEUyPjw4MD48OTk+cyBlcXVpcG1lbnQuDQo+IA0KPiBD
Rk0gZnVuY3Rpb25zIGFyZSBwYXJ0aXRpb25lZCBhcyBmb2xsb3dzOg0KPiAgICAgLSBQYXRoIGRp
c2NvdmVyeQ0KPiAgICAgLSBGYXVsdCBkZXRlY3Rpb24NCj4gICAgIC0gRmF1bHQgdmVyaWZpY2F0
aW9uIGFuZCBpc29sYXRpb24NCj4gICAgIC0gRmF1bHQgbm90aWZpY2F0aW9uDQo+ICAgICAtIEZh
dWx0IHJlY292ZXJ5DQo+IA0KPiBJbnRlcmZhY2UgY29uc2lzdHMgb2YgdGhlc2UgZnVuY3Rpb25z
Og0KPiBicl9jZm1fbWVwX2NyZWF0ZSgpDQo+IGJyX2NmbV9tZXBfZGVsZXRlKCkNCj4gYnJfY2Zt
X21lcF9jb25maWdfc2V0KCkNCj4gYnJfY2ZtX2NjX2NvbmZpZ19zZXQoKQ0KPiBicl9jZm1fY2Nf
cGVlcl9tZXBfYWRkKCkNCj4gYnJfY2ZtX2NjX3BlZXJfbWVwX3JlbW92ZSgpDQo+IA0KPiBBIE1F
UCBpbnN0YW5jZSBpcyBjcmVhdGVkIGJ5IGJyX2NmbV9tZXBfY3JlYXRlKCkNCj4gICAgIC1JdCBp
cyB0aGUgTWFpbnRlbmFuY2UgYXNzb2NpYXRpb24gRW5kIFBvaW50DQo+ICAgICAgZGVzY3JpYmVk
IGluIDgwMi4xUSBzZWN0aW9uIDE5LjIuDQo+ICAgICAtSXQgaXMgY3JlYXRlZCBvbiBhIHNwZWNp
ZmljIGxldmVsICgxLTcpIGFuZCBpcyBhc3N1cmluZw0KPiAgICAgIHRoYXQgbm8gQ0ZNIGZyYW1l
cyBhcmUgcGFzc2luZyB0aHJvdWdoIHRoaXMgTUVQIG9uIGxvd2VyIGxldmVscy4NCj4gICAgIC1J
dCBpbml0aWF0ZXMgYW5kIHZhbGlkYXRlcyBDRk0gZnJhbWVzIG9uIGl0cyBsZXZlbC4NCj4gICAg
IC1JdCBjYW4gb25seSBleGlzdCBvbiBhIHBvcnQgdGhhdCBpcyByZWxhdGVkIHRvIGEgYnJpZGdl
Lg0KPiAgICAgLUF0dHJpYnV0ZXMgZ2l2ZW4gY2Fubm90IGJlIGNoYW5nZWQgdW50aWwgdGhlIGlu
c3RhbmNlIGlzDQo+ICAgICAgZGVsZXRlZC4NCj4gDQo+IEEgTUVQIGluc3RhbmNlIGNhbiBiZSBk
ZWxldGVkIGJ5IGJyX2NmbV9tZXBfZGVsZXRlKCkuDQo+IA0KPiBBIGNyZWF0ZWQgTUVQIGluc3Rh
bmNlIGhhcyBhdHRyaWJ1dGVzIHRoYXQgY2FuIGJlDQo+IGNvbmZpZ3VyZWQgYnkgYnJfY2ZtX21l
cF9jb25maWdfc2V0KCkuDQo+IA0KPiBBIE1FUCBDb250aW51aXR5IENoZWNrIGZlYXR1cmUgY2Fu
IGJlIGNvbmZpZ3VyZWQgYnkNCj4gYnJfY2ZtX2NjX2NvbmZpZ19zZXQoKQ0KPiAgICAgVGhlIENv
bnRpbnVpdHkgQ2hlY2sgUmVjZWl2ZXIgc3RhdGUgbWFjaGluZSBjYW4gYmUNCj4gICAgIGVuYWJs
ZWQgYW5kIGRpc2FibGVkLg0KPiAgICAgQWNjb3JkaW5nIHRvIDgwMi4xUSBzZWN0aW9uIDE5LjIu
OA0KPiANCj4gQSBNRVAgY2FuIGhhdmUgUGVlciBNRVBzIGFkZGVkIGFuZCByZW1vdmVkIGJ5DQo+
IGJyX2NmbV9jY19wZWVyX21lcF9hZGQoKSBhbmQgYnJfY2ZtX2NjX3BlZXJfbWVwX3JlbW92ZSgp
DQo+ICAgICBUaGUgQ29udGludWl0eSBDaGVjayBmZWF0dXJlIGNhbiBtYWludGFpbiBjb25uZWN0
aXZpdHkNCj4gICAgIHN0YXR1cyBvbiBlYWNoIGFkZGVkIFBlZXIgTUVQLg0KPiANCj4gUmV2aWV3
ZWQtYnk6IEhvcmF0aXUgVnVsdHVyICA8aG9yYXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogSGVucmlrIEJqb2Vybmx1bmQgIDxoZW5yaWsuYmpvZXJubHVuZEBtaWNy
b2NoaXAuY29tPg0KPiAtLS0NCg0KVGhhbmsgeW91IGZvciBicmVha2luZyB0aGUgYmlnIHBhdGNo
IGludG8gMyBzbWFsbGVyIHBpZWNlcywgYnV0IGNvdWxkIHlvdSBwbGVhc2UNCm5hbWUgdGhlbSBh
cHByb3ByaWF0ZWx5PyBJJ20gc3VyZSB0aGV5IGFkZCBkaWZmZXJlbnQgdGhpbmdzLCBzbyBqdXN0
IGdpdmUgdGhlbQ0Kc29tZXRoaW5nIG1vcmUgZGVzY3JpcHRpdmUuIEhhdmluZyB0aGUgc2FtZSBz
dWJqZWN0IGZvciAzIHBhdGNoZXMgbG9va3Mgb2RkLg0KDQo+ICBpbmNsdWRlL3VhcGkvbGludXgv
Y2ZtX2JyaWRnZS5oIHwgIDIzICsrKw0KPiAgbmV0L2JyaWRnZS9NYWtlZmlsZSAgICAgICAgICAg
ICB8ICAgMiArDQo+ICBuZXQvYnJpZGdlL2JyX2NmbS5jICAgICAgICAgICAgIHwgMjYzICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBuZXQvYnJpZGdlL2JyX3ByaXZhdGVfY2Zt
LmggICAgIHwgIDYxICsrKysrKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDM0OSBpbnNlcnRpb25z
KCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS91YXBpL2xpbnV4L2NmbV9icmlkZ2Uu
aA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IG5ldC9icmlkZ2UvYnJfY2ZtLmMNCj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBuZXQvYnJpZGdlL2JyX3ByaXZhdGVfY2ZtLmgNCj4gDQpbc25pcF0NCj4gKw0K
PiArCW1lcCA9IGt6YWxsb2Moc2l6ZW9mKCptZXApLCBHRlBfS0VSTkVMKTsNCj4gKwlpZiAoIW1l
cCkNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICsNCj4gKwltZXAtPmNyZWF0ZSA9ICpjcmVhdGU7
DQo+ICsJbWVwLT5pbnN0YW5jZSA9IGluc3RhbmNlOw0KPiArCXJjdV9hc3NpZ25fcG9pbnRlciht
ZXAtPmJfcG9ydCwgcCk7DQo+ICsNCj4gKwlJTklUX0hMSVNUX0hFQUQoJm1lcC0+cGVlcl9tZXBf
bGlzdCk7DQo+ICsNCj4gKwlobGlzdF9hZGRfdGFpbF9yY3UoJm1lcC0+aGVhZCwgJmJyLT5tZXBf
bGlzdCk7DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArc3RhdGljIHZvaWQgbWVw
X2RlbGV0ZV9pbXBsZW1lbnRhdGlvbihzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsDQo+ICsJCQkJICAg
ICAgc3RydWN0IGJyX2NmbV9tZXAgKm1lcCkNCj4gK3sNCj4gKwlzdHJ1Y3QgYnJfY2ZtX3BlZXJf
bWVwICpwZWVyX21lcDsNCj4gKw0KPiArCUFTU0VSVF9SVE5MKCk7DQo+ICsNCj4gKwkvKiBFbXB0
eSBhbmQgZnJlZSBwZWVyIE1FUCBsaXN0ICovDQo+ICsJaGxpc3RfZm9yX2VhY2hfZW50cnkocGVl
cl9tZXAsICZtZXAtPnBlZXJfbWVwX2xpc3QsIGhlYWQpIHsNCg0KaGxpc3RfZm9yX2VhY2hfZW50
cnlfc2FmZSgpDQoNCj4gKwkJaGxpc3RfZGVsX3JjdSgmcGVlcl9tZXAtPmhlYWQpOw0KPiArCQlr
ZnJlZV9yY3UocGVlcl9tZXAsIHJjdSk7DQo+ICsJfQ0KPiArDQo+ICsJUkNVX0lOSVRfUE9JTlRF
UihtZXAtPmJfcG9ydCwgTlVMTCk7DQo+ICsJaGxpc3RfZGVsX3JjdSgmbWVwLT5oZWFkKTsNCj4g
KwlrZnJlZV9yY3UobWVwLCByY3UpOw0KPiArfQ0KDQo=
