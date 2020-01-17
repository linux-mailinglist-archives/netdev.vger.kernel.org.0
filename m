Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4671410C5
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgAQS20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:28:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5675 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQS20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:28:26 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e21fc8e0000>; Fri, 17 Jan 2020 10:27:26 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 17 Jan 2020 10:28:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 17 Jan 2020 10:28:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 17 Jan
 2020 18:28:23 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 17 Jan 2020 18:28:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtuM+BOdyPmuhKLRnWcxrnmMEEPGuWeAuYwsr3iBWatWFmDxefMA/1PXimMUj7i5AbxWaolsmwGOdelkYK9Z1qpcv1rpx1fu1bv3PW3RAcT70kbuULKfmKIir1gbmI92vy3tInR/Kc5ybcYW28IfpLMLmmn00x1erBfIVhcuGXeKB+Dd715xgaJ50434FgI4kXRrdVQSOVUgtLMn2zLCWaJBQl9TMlVFPVj2EA7dBRKT40gGr+zDbqL6Awjj0O4/jgD3ddw2jReb7sEvB9hWuMPBnKDvCH1xZqDeSSSERfZCWXUSgWwlpxb7jgFNMfRlvJBCs7KaFo1ajbN5iYUD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+JkW3G5sFGINhnKJXgxdm54Fg42x0gRZuthtCEM5Qg=;
 b=OwM8qXzGfMxKrHDbHxtVpN+qEwJWVCmKYUJCcWX3+XnQbRFu8C8/Is+xCFiIpSp7enGn1d6WfcGxng6jKwCOtZGbjh9KL5kHvOaFtAKCIFbNHFQxtwGQFkNyyGRpmgAvKVZUgZc8marACdKaMzFgGUuo8WM0RuHmovp6eg7ClUc19cSkukwyDdXJro2jBrnEsj5JFc2i8SyK2fNer6R+k5APM7QXWcRV6+B0bXA8/MlsvJg2wC8wLclM4VXEAEWPWL+/rkynQn595U8lFhBWlqniF+254HFm9a3/v7rhnFUX/V+erR0R0cSVtab/uR6FL9jGEKa8Dl/RHHeNFhJ60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2727.namprd12.prod.outlook.com (20.176.253.214) by
 BYAPR12MB3591.namprd12.prod.outlook.com (20.178.54.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 17 Jan 2020 18:28:22 +0000
Received: from BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::9c2:6e7d:37ee:5643]) by BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::9c2:6e7d:37ee:5643%7]) with mapi id 15.20.2623.018; Fri, 17 Jan 2020
 18:28:21 +0000
From:   Ajay Gupta <ajayg@nvidia.com>
To:     Chen-Yu Tsai <wens@kernel.org>, Ajay Gupta <ajaykuee@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: RE: [PATCH] net: stmmac: platform: use generic device api
Thread-Topic: [PATCH] net: stmmac: platform: use generic device api
Thread-Index: AQHVzJm5YPylWrXNC0OEL/ItEl/L0afuNJIAgAD2q1A=
Date:   Fri, 17 Jan 2020 18:28:21 +0000
Message-ID: <BYAPR12MB27279A52D52B5DAB84F47BE3DC310@BYAPR12MB2727.namprd12.prod.outlook.com>
References: <20200116005645.14026-1-ajayg@nvidia.com>
 <CAGb2v64hEN5=2FdxzMLfZm7RT68-+YZ70-_3fCPUyZ47C-9m1g@mail.gmail.com>
In-Reply-To: <CAGb2v64hEN5=2FdxzMLfZm7RT68-+YZ70-_3fCPUyZ47C-9m1g@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=ajayg@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2020-01-17T18:28:20.4100081Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_ActionId=0f110578-5779-4d2f-9d5a-ab0e83c61111;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ajayg@nvidia.com; 
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcce6b79-5fde-49ee-f421-08d79b7b0850
x-ms-traffictypediagnostic: BYAPR12MB3591:|BYAPR12MB3591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3591B179B400EB318D45AD20DC310@BYAPR12MB3591.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(316002)(4326008)(6506007)(71200400001)(54906003)(110136005)(26005)(53546011)(5660300002)(186003)(7696005)(2906002)(81156014)(81166006)(8676002)(9686003)(478600001)(8936002)(55016002)(33656002)(86362001)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(966005)(52536014)(41533002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR12MB3591;H:BYAPR12MB2727.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xlq/TTXk9cHRrPK65nWaxUMCoV9DiW+x1wk1BK6sgvdi2Gge8YnEj1YYD1fY5WUe2MNOXMdKCZM4G5lUExMYp2G43Pft4AZzJZXKYowyoR96gEor/ejeT/kCffj3khft7T7JtNcTf8gDhXnnAoqsEIzfBHvaHM4d89HBqQ2u8FUR8i0fTjJzaSKpkY0JYVVUWPgoBsjZ7W5IQDvigRAyavoCNDK1B0lu6WnrOPISjvkitFdJDtxX9CNdn/FSYJDdXgLIg2RYq5ONEA2+FQhM7b3hGel/160tJ1cL6hFRb3Qb4CL2RxO+5f0YWQ85dysRyFzMMJ1e580xWuXmtO+yels/Hl/WnyE46CBvEoBTOP2G7m5K5qtOoMSM9N6ZA6Mon1sRtYX6E3SColD9OnojQCjaTojMixpB/Z4VmTgiQmaa+d+BiI3IfC+1z6foDO2ZZCC1v2rw3J3wS3AH/sEn0pLbuYBQ8sR/10ZZLypBhDxtANs3ED6VYkLxkVJ4zqoUzQsItRT4O0UWccQ6rZYL8Nz2yXWQQkWFvIKnihfNenH6OsSolAXHfycwxoXyXA2b
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcce6b79-5fde-49ee-f421-08d79b7b0850
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 18:28:21.7601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0An17i2cGhvrgCdXcRVNDSLHiPLtMH+Ess2gKNIV8oVruXFYtIJJsrVAti78ZEIwV/rrxcDGBhViE/HjJbq/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3591
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579285646; bh=t+JkW3G5sFGINhnKJXgxdm54Fg42x0gRZuthtCEM5Qg=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-forefront-prvs:
         x-forefront-antispam-report:received-spf:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:MIME-Version:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=e0ktjh2J+x/kXwlaWWUI9A14lOUCkTM/tP2VPlfEq0N5zXUOEjl+SVSsqSMc2EKs4
         mbkQUbKxY8oAeTA9ippAkc7bM7m9hctI9lir9Aa1crZcmhFl5iJSXGgMS7WpM0jtUL
         Z/zz+ChAWNqYI1jBPRHyZvBXPJMYcheMJkQbMj2Et8nqJ86y6MMTAZftiEpC+brmOE
         erNP9PPVjrpr9DJ87ryIka/hjMy+Thd5FskrCSWlmM2OcfCw4OjsxtIXD9yzMsSj2l
         NmmsySwq/CmW4gTje/uJe3HoviL+XMs2EnW9B/cbHW1EAU/fmfWSjc30n418+P9GsI
         qBrjVxfL+EUaQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2hlbll1DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hlbi1Z
dSBUc2FpIDx3ZW5zQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDE2LCAy
MDIwIDc6MzQgUE0NCj4gVG86IEFqYXkgR3VwdGEgPGFqYXlrdWVlQGdtYWlsLmNvbT4NCj4gQ2M6
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRldiA8bmV0ZGV2QHZnZXIu
a2VybmVsLm9yZz47DQo+IFRoaWVycnkgUmVkaW5nIDx0cmVkaW5nQG52aWRpYS5jb20+OyBBamF5
IEd1cHRhIDxhamF5Z0BudmlkaWEuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IHN0
bW1hYzogcGxhdGZvcm06IHVzZSBnZW5lcmljIGRldmljZSBhcGkNCj4gDQo+IEV4dGVybmFsIGVt
YWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4g
SGksDQo+IA0KPiBPbiBGcmksIEphbiAxNywgMjAyMCBhdCAyOjIxIEFNIEFqYXkgR3VwdGEgPGFq
YXlrdWVlQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBBamF5IEd1cHRhIDxhamF5
Z0BudmlkaWEuY29tPg0KPiA+DQo+ID4gVXNlIGdlbmVyaWMgZGV2aWNlIGFwaSB0byBhbGxvdyBy
ZWFkaW5nIG1vcmUgY29uZmlndXJhdGlvbiBwYXJhbWV0ZXINCj4gPiBmcm9tIGJvdGggRFQgb3Ig
QUNQSSBiYXNlZCBkZXZpY2VzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQWpheSBHdXB0YSA8
YWpheWdAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiBBQ1BJIHN1cHBvcnQgcmVsYXRlZCBjaGFu
Z2VzIGZvciBkd2Mgd2VyZSByZWVudGx5IHF1ZXVlZCBbMV0gVGhpcw0KPiA+IHBhdGNoIGlzIHJl
cXVpcmVkIHRvIHJlYWQgbW9yZSBjb25maWd1cmF0aW9uIHBhcmFtZXRlciB0aHJvdWdoIEFDUEkN
Cj4gPiB0YWJsZS4NCj4gPg0KPiA+IFsxXSBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1uZXRk
ZXYmbT0xNTc2NjE5NzQzMDUwMjQmdz0yDQo+ID4NCj4gPiAgLi4uL2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL3N0bW1hY19wbGF0Zm9ybS5jIHwgNDkNCj4gPiArKysrKysrKysrKy0tLS0tLS0tDQo+
IA0KPiBFdmVuIGFmdGVyIHlvdXIgY2hhbmdlcywgdGhlcmUncyBzdGlsbCBhIGxvdCBvZiBEVCBz
cGVjaWZpYyBjb2RlIGluIHRoZXJlLCBzdWNoIGFzDQo+IHRoZSBNRElPIGRldmljZSBub2RlIHBh
cnNpbmcuIFBsdXMgdGhlIHdob2xlIHRoaW5nIGlzIHdyYXBwZWQgaW4gIiNpZmRlZg0KPiBDT05G
SUdfT0YiLg0KPiANCj4gTWF5YmUgaXQgd291bGQgbWFrZSBtb3JlIHNlbnNlIHRvIHNwbGl0IG91
dCB0aGUgZ2VuZXJpYyBkZXZpY2UgQVBJIHBhcnRzIGludG8NCj4gYSBzZXBhcmF0ZSBmdW5jdGlv
bj8NCkkgYW0gdGVzdGluZyBBQ1BJIGJhc2VkIGRldmljZSBmb3IgZHdtYWMtZHdjLXFvcy1ldGgg
Y29udHJvbGxlci4gQWxzbyBmb3VuZA0KdGhhdCAiIHBoeV9ub2RlICIgc3RydWN0dXJlIHVzZWQg
YWNyb3NzIG90aGVyIGNvbnRyb2xsZXJzIChkd21hYy1yaywgZHdtYWMtc3VuOGkpDQpwbGF0LT5w
aHlfbm9kZSA9IG9mX3BhcnNlX3BoYW5kbGUobnAsICJwaHktaGFuZGxlIiwgMCk7DQoNCkl0IHdp
bGwgcmVxdWlyZSBjaGFuZ2VzIGluIG90aGVyIGRyaXZlcnMgIGFuZCB0ZXN0aW5nIHRoZW0uIEkg
ZG9uJ3QgaGF2ZSBoYXJkd2FyZQ0KZm9yIG90aGVyIGNvbnRyb2xsZXJzLiANCkkgYW0gdHJ5aW5n
IHRvIGFkZCBtaW5pbWFsIGNoYW5nZSB3aGF0IGNhbiBiZSB0ZXN0ZWQgaW4gY29udGV4dCBvZiBk
d21hYy1kd2MtcW9zLWV0aC4NCg0KVGhhbmtzDQpBamF5DQo+bnZwdWJsaWMNCj4gDQo+IFJlZ2Fy
ZHMNCj4gQ2hlbll1DQo=
