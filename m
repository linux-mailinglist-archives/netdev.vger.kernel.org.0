Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7726978E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgINVQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:16:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2516 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgINVQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:16:30 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5fdda00000>; Mon, 14 Sep 2020 14:16:16 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 14:16:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 14 Sep 2020 14:16:29 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 21:16:26 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 21:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ/1HCpxNRgsLIsK/gfVJq8WPaaOMn3eMVn6QfVVXDPk2bJ2P+czL6dcjQHI9f7SyMlj+NUmmXKK3wq/b6WeSqn9h8nhdG8bVQ0HXCFM5BKHGRZ9PkGzM82p7/jSe1iET8gf5g+9K7RxCyhxtX8NwgOuTMpWMbDykzkTsGMg/h0fEq6v2Jb1jrxBTOKgjUyiw1XfS8jRkQxFd2gBi+V+gFLfYSkYOYL9HSuUPxESLcfUwUU+Ko4rUiYLbRVuDDzywUn7CxJN2493LQ9WT+hmVm1dEIoz0t/mwR4ZsWd5VC3GM4EEsBU94GZ36AwqBhzb/VvliZXnyTjFLdjzhJAzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=resOXQaLhlEyHmWdjj3CNGmizpDDA6eyMaTr+DyO/WA=;
 b=kPdlFqCzkBG9DQmTqvpLOFmdCTNB/I69IPTA7G9foEWbdwtiiERCjU1ej+c86/KoN15zR4T4i/joR/7ljDc8i4xNdnmSfZ1ekzjzooGeifDI/cOABMPF3XvF1ldIITeL9dAzbS4wLfjfE8DFNewWe2fRLjldgFQVmtdJiT+auldfNbOHCwc+sdDY7j/3FKva1RJvFwUD7D6+4nwjr25T7hb8vS/TuUdeEZUVKZ6RQqpe4nteD1N102pD/t5uFuG2sxy8BzUNTzOSOIS49MdrZeXVci+w1hIpBoHR1q7S/iD6q4SdyCyTh/v1C2xjTJ6zAslGauJStpuLWgzrOSvVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3304.namprd12.prod.outlook.com (2603:10b6:a03:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Mon, 14 Sep
 2020 21:16:25 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 21:16:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>
CC:     "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "petkan@nucleusys.com" <petkan@nucleusys.com>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "apais@linux.microsoft.com" <apais@linux.microsoft.com>
Subject: Re: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use
 new tasklet_setup() API
Thread-Topic: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use
 new tasklet_setup() API
Thread-Index: AQHWimk5SmafUBxlxU23WRnz8uztzqloo8cA
Date:   Mon, 14 Sep 2020 21:16:25 +0000
Message-ID: <5ab44bd27936325201e8f71a30e74d8b9d6b34ee.camel@nvidia.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e51e71c-fd40-4109-a623-08d858f37011
x-ms-traffictypediagnostic: BYAPR12MB3304:
x-microsoft-antispam-prvs: <BYAPR12MB3304642F4A4033BB0F0489F4B3230@BYAPR12MB3304.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mdLrJASm0iJMAmX0VlGLCAW0CZy/vcG/MkOq2q16pDWL4jlrsokVHOc923pVAh+aZ2T48If+mRi1FCNuwsLjiv+ap1XmR1UzPfNBsmKPU7h88XGiIUmRrWf62L98oFi6zCcIh7hzIebp/CFzOeHvMJk3kO1m+tzK8vprJPDITgbd4ks4AaQqytPEehCt833KPnfOeATue3kRW0K04lVJuov0z7QT/KJc2ZWqruOWII5PNjZhatyiIyrgBDMGIFYK2rzEnDUsshZvBHYZ0tCeeNC1IWBV4yn5Hzuy7u8QLlk5r3A74I1lp9hI87BstwtK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(4326008)(86362001)(186003)(8936002)(36756003)(7416002)(8676002)(2616005)(6486002)(76116006)(110136005)(316002)(71200400001)(54906003)(6506007)(478600001)(26005)(66476007)(5660300002)(64756008)(6512007)(2906002)(66946007)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YC36hPkhfgq6YQwFuLk1HfVgsiWFPSOdxyZYC5D9y16jCPQz1NGxVTJn+hs/zF7LmnCbkiVUbDZNzHWYNVam+B2L5sRXRsdEZyTo/PnI6WCVpq0ZA2JhiVU+8m7gGkYMIkFjpSSbnagtkHEI1HvFO7usgsPG+nxLIdwZdsgO+bIcqsk/zuGggVY3CqLdwkQ/5QyxmIizzE4iWGBd9iv6BDIgYXVxWG/6kC5NHPAxxGq7aeotoGg3Mn14Y0FhE665+nFf4ICIbJCdFQkz1Q/B1qoQ9eoUuLmlq+9hbHxKgBsDrrOwxadProDaEbjRvGeiZp1Pyi+rNWC13gKmONLZQbtsb6kFpu4UiY9J3W3Bnrqx63wSWk3Ly4AXXNukS70JOO6K2KDIEsho8Px1XGWzEgtjK9krVoxPZXLBgfXyiXoTOuftaxMNE+cppCIDhuvL62nMQOsL/BExoKrzvPkr7SjNW1V3L0tSbLOVUfP4X6dEUdUnJNoU7oB+cmC3dJhbIgi6Jqk7d1IAPUEkb/dgSGk1LoHvQdBi01jKA2+0bl5FGqyZT2MSi3x3IcSMLqb+Nq6sibUDspAAVYli0h5yjzaQOGzhE7h54oX/RqxDhFxtEHy2qalgQEDPvhWqqqA1phse51ih4G/qAPIa888E5Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC5A6F58D85B43439427B9D8EE6C4655@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e51e71c-fd40-4109-a623-08d858f37011
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 21:16:25.1515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buiqmP6fFIypX7gxpmG/rFm4/rZji8WdbGkrPO7PRKx/hzM/5hJK8uFzwLiRZ7+r6PclHmS1WqhsOdiC/cU0+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3304
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600118176; bh=resOXQaLhlEyHmWdjj3CNGmizpDDA6eyMaTr+DyO/WA=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=q3ixaW5GDyxWTb0jSiCue9AllP6z0Rlw+ghwN/JaBjLJBBLX1bXazKA1Mr7Rasz/e
         5HPm9JS7cySt/6Gp9BmkZBLo1/MEInTdGc+EEMm6jcJY2x5m7CAAcOTd4t9HvTMJkz
         E+0EgHWb9vbMSrEpfm5FpuXjKAG+whb/oek1N56qSJ+hfpfma6X3HHcGpXw4NbCgYV
         0jM+dJyrTEpmurW1s45X+yru0tTzBQ3l+LmicrS7OsZAVIM5q/Vz/tGDgwJqtioZuu
         qb0krCcRcCWWLu5tWDuA9fkkiKhjlzt5ASWLmeA8X530GffbbpzXE7inrs4r5E1ZYX
         ImrwnA29Nq/TQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDEzOjAxICswNTMwLCBBbGxlbiBQYWlzIHdyb3RlOg0KPiBG
cm9tOiBBbGxlbiBQYWlzIDxhcGFpc0BsaW51eC5taWNyb3NvZnQuY29tPg0KPiANCj4gb21taXQg
MTJjYzkyM2YxY2NjICgidGFza2xldDogSW50cm9kdWNlIG5ldyBpbml0aWFsaXphdGlvbiBBUEki
KScNCj4gaW50cm9kdWNlZCBhIG5ldyB0YXNrbGV0IGluaXRpYWxpemF0aW9uIEFQSS4gVGhpcyBz
ZXJpZXMgY29udmVydHMNCj4gYWxsIHRoZSBuZXQvKiBkcml2ZXJzIHRvIHVzZSB0aGUgbmV3IHRh
c2tsZXRfc2V0dXAoKSBBUEkNCj4gDQo+IFRoaXMgc2VyaWVzIGlzIGJhc2VkIG9uIHY1LjktcmM1
DQo+IA0KPiBBbGxlbiBQYWlzICgxMik6DQo+ICAgbmV0OiBtdnBwMjogUHJlcGFyZSB0byB1c2Ug
dGhlIG5ldyB0YXNrbGV0IEFQSQ0KPiAgIG5ldDogYXJjbmV0OiBjb252ZXJ0IHRhc2tsZXRzIHRv
IHVzZSBuZXcgdGFza2xldF9zZXR1cCgpIEFQSQ0KPiAgIG5ldDogY2FpZjogY29udmVydCB0YXNr
bGV0cyB0byB1c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4gICBuZXQ6IGlmYjogY29udmVy
dCB0YXNrbGV0cyB0byB1c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4gICBuZXQ6IHBwcDog
Y29udmVydCB0YXNrbGV0cyB0byB1c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4gICBuZXQ6
IGNkY19uY206IGNvbnZlcnQgdGFza2xldHMgdG8gdXNlIG5ldyB0YXNrbGV0X3NldHVwKCkgQVBJ
DQo+ICAgbmV0OiBoc286IGNvbnZlcnQgdGFza2xldHMgdG8gdXNlIG5ldyB0YXNrbGV0X3NldHVw
KCkgQVBJDQo+ICAgbmV0OiBsYW43OHh4OiBjb252ZXJ0IHRhc2tsZXRzIHRvIHVzZSBuZXcgdGFz
a2xldF9zZXR1cCgpIEFQSQ0KPiAgIG5ldDogcGVnYXN1czogY29udmVydCB0YXNrbGV0cyB0byB1
c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4gICBuZXQ6IHI4MTUyOiBjb252ZXJ0IHRhc2ts
ZXRzIHRvIHVzZSBuZXcgdGFza2xldF9zZXR1cCgpIEFQSQ0KPiAgIG5ldDogcnRsODE1MDogY29u
dmVydCB0YXNrbGV0cyB0byB1c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4gICBuZXQ6IHVz
Ym5ldDogY29udmVydCB0YXNrbGV0cyB0byB1c2UgbmV3IHRhc2tsZXRfc2V0dXAoKSBBUEkNCj4g
DQo+IA0KDQpZb3UgYXJlIG9ubHkgY29udmVydGluZyBkcml2ZXJzIHdoaWNoIGFyZSBwYXNzaW5n
IHRoZSB0YXNrZWx0IHN0cnVjdCBhcw0KZGF0YSBwdHIsIG1vc3Qgb2Ygb3RoZXIgZHJpdmVycyBh
cmUgcGFzc2luZyB0aGUgY29udGFpbmVyIG9mIHRoZQ0KdGFza2xldCBhcyBkYXRhLCB3aHkgbm90
IGNvbnZlcnQgdGhlbSBhcyB3ZWxsLCBhbmQgbGV0IHRoZW0gdXNlDQpjb250YWluZXJfb2YgdG8g
ZmluZCB0aGVpciBkYXRhID8gaXQgaXMgcmVhbGx5IHN0cmFpZ2h0IGZvcndhcmQgYW5kDQp3aWxs
IGhlbHAgY29udmVydCBtb3N0IG9mIG5ldCBkcml2ZXIgaWYgbm90IGFsbC4NCg0K
