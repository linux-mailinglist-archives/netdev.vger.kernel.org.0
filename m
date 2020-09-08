Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57DA261CB6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbgIHTZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:25:28 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1578 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgIHQAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:00:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f57768b0001>; Tue, 08 Sep 2020 05:18:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 05:18:33 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 05:18:33 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 12:18:33 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Sep 2020 12:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXd/XWXr/mBggv1sn8fyBs1aNz5iidvgxMgRLcfNliErEqRiBOxMR+qfZYBckPQwbjsmetaypx2cGt8PAr2U3+92BdD7ije2MKO0Mjit6NInhpEHQ8Z3Sa2Q3YpRxAVA2BpwMg/PV1+8nTVIZn55AoD27qI4zzQAe9vtI7re5IB8uHmkQxkQ+n72fxKdZ2FLUJGJuV+/+WLTsgUEdMaBkX5XMuCIx+H9u7H2BE3jFxKnq6A/y4kMI/e8c5LRK4kVMRwmIPX3f0FZ8iQfKhAZCdOdrzTWsEq0mwYFcc3/b+MmVg93TgyHR9tDeHZmDVh3gy4mcmkd2hwvlmjFwmYPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGsNcIwdPaEJi8jThsV1uqtWfah3BveIJqAAU0lUZNM=;
 b=aTttXlY+Tv/KGJxBAi5lXgNaxsLT/kZInSGMGRD/ah9qinKa0488njunIgHMJe9lhcDi6lDQEXc4WhG/D13ZdCu/FkG1+kT7XvV/1l1AUfsQjdXoaIlTAOYrle1VR923fkhq3njt23lcWo/dtYiQsuz8aqq5u6nxXiU9YwVxu2/qrkVdT5rPPaYKsALgEYntwrgpTIrU+sf4E8P4mFQN1yQIJGcGkY8TXARNnutUelyBhklScUKr5gHTl23AOY1Q67+hZntoyCQ1FlTDmuyfSVDcvAWl1TX5mlMsSnSXBhklg+vWM2x8hH8Yw462Rh5833A+ol3exAvxxJCwlu2CxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB2919.namprd12.prod.outlook.com (2603:10b6:a03:12c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 12:18:31 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 12:18:31 +0000
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
Subject: Re: [PATCH RFC 2/7] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Thread-Topic: [PATCH RFC 2/7] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Thread-Index: AQHWgpx4vaCTm02ulUKOejWt4a0/5KlerxoA
Date:   Tue, 8 Sep 2020 12:18:31 +0000
Message-ID: <e145b130ba56460ecf11318f9a4550d2637aa222.camel@nvidia.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904091527.669109-3-henrik.bjoernlund@microchip.com>
In-Reply-To: <20200904091527.669109-3-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: fff34f1f-cea5-4c23-b150-08d853f14d0d
x-ms-traffictypediagnostic: BYAPR12MB2919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB29192E463CB886ECEEF65991DF290@BYAPR12MB2919.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LEFyC4iE4I3XhaKXg2dYrt+wVbEQ42F8J2ZivdD+OuXGcD/7cU/jfCCy62gJPvv2bAhOq12aeB/B1lHZ691lnPJG41tc2W+Cb1GO+4MvYXbB+H1wcPOzKQJn38gvGUXytJV/1BjVQhxiLtI+nLtHmgqV26NCg8xgCGJV7ryAiN8KlVbGUFmFKcOcsRBsJoJYna9W5S1nVAsWugAYgFJ5MsDcg38/uTLImpNYUGMAzfnVEumcYCX6H2oz/ZbEkSzTV7WdpUX6XThQVyXeXCWXgGdtECwNbJh8d5TwsPv7ZeKAbOdFoMjp8CzCeO3LbMDBBvNN5TVwLy4pZ/5MYCBvKw6jn9R2tHU5QUfmM/eWGVYySO4dZrnCISpnd1Byv0Uj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(2906002)(3450700001)(83380400001)(36756003)(6512007)(5660300002)(186003)(6506007)(2616005)(71200400001)(478600001)(26005)(316002)(4326008)(86362001)(110136005)(66476007)(91956017)(76116006)(66556008)(66446008)(64756008)(6486002)(66946007)(8936002)(8676002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9N5gt9gFwc9fYN4YUVdSBpvRsbk9hWNBKkdr2oqJaqxZhnJ3IUNUy8r6TipVdWDG2TMOn3N1E4qii1QvnK26TLFqdqz5ZL+xP3br2Y1GSkO+RjZPnxc3h+Vl/qcZBJBIEEkrxr7GdVQE21lrk3mOXpQUakse4QJdT9zuUdlGN23dn8rzppHqMf9ld6GB+VvtsFmAirDj1QTFIgN9OKakvbRH4D1tP+t9YsCwBusA7ETyOZ5R/P2v9sBVxgncbE2kWOnfm9cl2pxOSjI7tJUXjXaO7ZB7HZvhDwPMeQVJ/r/5eGffVsOII3z6BmNu8SZhnGFycCk7UMH8Re+6I9r3B8qJrMqC+h6Nyo18g9inKISA5MwRYh4cunN1DlQO1E8tEkqnsHkJtp/Mxe7TbIEsPc/hGlrIbFeF8MN8kyTewp8gxf1ueY3zJpZT2KTPH4A92Hbrmx1zyWBM5Yh26D6AbA9lW9SWURnSBGeM5G1+1lRybsoy4ZGrpCWFIqQxPfl5aJc8aAysPiYykgtTZP4wc0K2jD507ZKd7CjwKiYit/IeHPvKQXd7RXJiLLKIrF6A3KI5qJORTMf0sv2Jj8EggaqUE3EUji7OOQnV9Deq7bvIL0qlEVcxGkg2ue+W8GIlyl7aLtNjlLfPx1kRc9xXhw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9027594D27E84448F9D96A1042E8A31@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff34f1f-cea5-4c23-b150-08d853f14d0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 12:18:31.5483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1JofDo4dbbFfrSMD1x7ncVO0hcE/ggC4ZhbYv+y1mttByQT79FXJ+W2yiQBhy0RdTj2WfyKJcQFFoPTsWOilHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2919
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599567499; bh=CGsNcIwdPaEJi8jThsV1uqtWfah3BveIJqAAU0lUZNM=;
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
        b=CMnJ8NZ5vxNX8NJxJ9dYpmSrif7oWknRklFZWx4/TOVT/8fkMW27uFoGqmBvZAOi6
         z/wOtbLO0PBd1hIyWlGogoeBIWOfddmFi6cDzO5DqCxRg1hqDm1mZsvfUdDwYRLxQN
         EmPEOz++dtpeqStEIsRBv6Vf5xmV3LTfgqv4V095UoxSI/P7dmdNhCYF9M3QAJIlms
         wx9fyZPm6WyLrw5vVzPunSjot39KGLEMD+gmdxtn8ebEfkc3PEDufYZSkciIF2I1os
         3BRmc5PjG+sDM0ew0lxmCpPG/XLA/pL3U5oBznSiQriYsUsvmqdNgqKcaSJtIQTgu7
         aEKe8laa95/Kg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTA0IGF0IDA5OjE1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBtYWtlcyBpdCBwb3NzaWJsZSB0byBpbmNsdWRlIG9yIGV4Y2x1ZGUgdGhlIENG
TQ0KPiBwcm90b2NvbCBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IC0tLQ0KPiAgbmV0L2JyaWRnZS9LY29uZmlnICAgICAgfCAxMSArKysrKysr
KysrKw0KPiAgbmV0L2JyaWRnZS9icl9kZXZpY2UuYyAgfCAgMyArKysNCj4gIG5ldC9icmlkZ2Uv
YnJfcHJpdmF0ZS5oIHwgIDMgKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL0tjb25maWcgYi9uZXQvYnJpZGdlL0tj
b25maWcNCj4gaW5kZXggODA4NzkxOTY1NjBjLi4zYzhkZWQ3ZDNlODQgMTAwNjQ0DQo+IC0tLSBh
L25ldC9icmlkZ2UvS2NvbmZpZw0KPiArKysgYi9uZXQvYnJpZGdlL0tjb25maWcNCj4gQEAgLTcz
LDMgKzczLDE0IEBAIGNvbmZpZyBCUklER0VfTVJQDQo+ICAJICBTYXkgTiB0byBleGNsdWRlIHRo
aXMgc3VwcG9ydCBhbmQgcmVkdWNlIHRoZSBiaW5hcnkgc2l6ZS4NCj4gIA0KPiAgCSAgSWYgdW5z
dXJlLCBzYXkgTi4NCj4gKw0KPiArY29uZmlnIEJSSURHRV9DRk0NCj4gKwlib29sICJDRk0gcHJv
dG9jb2wiDQo+ICsJZGVwZW5kcyBvbiBCUklER0UNCj4gKwloZWxwDQo+ICsJICBJZiB5b3Ugc2F5
IFkgaGVyZSwgdGhlbiB0aGUgRXRoZXJuZXQgYnJpZGdlIHdpbGwgYmUgYWJsZSB0byBydW4gQ0ZN
DQo+ICsJICBwcm90b2NvbCBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQNCj4gKw0K
PiArCSAgU2F5IE4gdG8gZXhjbHVkZSB0aGlzIHN1cHBvcnQgYW5kIHJlZHVjZSB0aGUgYmluYXJ5
IHNpemUuDQo+ICsNCj4gKwkgIElmIHVuc3VyZSwgc2F5IE4uDQo+IGRpZmYgLS1naXQgYS9uZXQv
YnJpZGdlL2JyX2RldmljZS5jIGIvbmV0L2JyaWRnZS9icl9kZXZpY2UuYw0KPiBpbmRleCBhOTIz
MmRiMDMxMDguLmQxMmY1NjI2YTRiMSAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRnZS9icl9kZXZp
Y2UuYw0KPiArKysgYi9uZXQvYnJpZGdlL2JyX2RldmljZS5jDQo+IEBAIC00NzYsNiArNDc2LDkg
QEAgdm9pZCBicl9kZXZfc2V0dXAoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIAlJTklUX0xJ
U1RfSEVBRCgmYnItPmZ0eXBlX2xpc3QpOw0KPiAgI2lmIElTX0VOQUJMRUQoQ09ORklHX0JSSURH
RV9NUlApDQo+ICAJSU5JVF9MSVNUX0hFQUQoJmJyLT5tcnBfbGlzdCk7DQo+ICsjZW5kaWYNCj4g
KyNpZiBJU19FTkFCTEVEKENPTkZJR19CUklER0VfQ0ZNKQ0KPiArCUlOSVRfTElTVF9IRUFEKCZi
ci0+bWVwX2xpc3QpOw0KPiAgI2VuZGlmDQo+ICAJc3Bpbl9sb2NrX2luaXQoJmJyLT5oYXNoX2xv
Y2spOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCBiL25ldC9i
cmlkZ2UvYnJfcHJpdmF0ZS5oDQo+IGluZGV4IGU2N2M2ZDllOGJlYS4uNjI5NGEzZTUxYTMzIDEw
MDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX3ByaXZhdGUuaA0KPiArKysgYi9uZXQvYnJpZGdl
L2JyX3ByaXZhdGUuaA0KPiBAQCAtNDQ1LDYgKzQ0NSw5IEBAIHN0cnVjdCBuZXRfYnJpZGdlIHsN
Cj4gICNpZiBJU19FTkFCTEVEKENPTkZJR19CUklER0VfTVJQKQ0KPiAgCXN0cnVjdCBsaXN0X2hl
YWQJCW1ycF9saXN0Ow0KPiAgI2VuZGlmDQo+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfQlJJREdF
X0NGTSkNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkCQltZXBfbGlzdDsNCj4gKyNlbmRpZg0KPiAgfTsN
Cj4gIA0KPiAgc3RydWN0IGJyX2lucHV0X3NrYl9jYiB7DQoNCkxvb2tzIGdvb2QsIHBlcmhhcHMg
YWxzbyBjYW4gdXNlIGhsaXN0IHRvIHJlZHVjZSB0aGUgaGVhZCBzaXplIGluIG5ldF9icmlkZ2Uu
DQoNCg==
