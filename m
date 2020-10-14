Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E480228DF5D
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgJNKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:50:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4125 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJNKul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:50:41 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f86d7d50000>; Wed, 14 Oct 2020 03:49:58 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 14 Oct
 2020 10:50:40 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 14 Oct 2020 10:50:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuQnmFmf9KTCHRfl6vQh7HPGDYR3cJC94o47ywkRQ8RSqhGz1QoZvU2BRGW/NtsJv4dCD/OAbqvgvCZU5Nd6PRBKL7wZaRxo88TRaH/d68nk2cRZIdrOTDw9TKe5EBeLWHa3GSoswpsGa4mbHwEbgfztAaoPI5jte24THuHZxh6qtxPNseB65Sg/VfYj3h4uWd9Ejo3QR7OGQlsNGkxzfIA30E3GdVF9TUQnR2kUqfNDoA6cKouayafiid3ucwwU26WJNsHDme1s3Kgl6819aTF1YP20judhLr3i/V24OoT4EjqlF0OylHy1H/OuS4Hy3vd1oRzWBywg7ALiSBydfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2F0/9+JMJi2vJGCxiqHYsecFSaVZTKkAHAZW5Ygc24=;
 b=jUwJDtV1WnPT8DnS6pFb5G08ENjO8H12j3oemb3FtIHsfr9ztxDCBPE7lTddNbyJmXEieJSFa6UGMPHfiHVsALGPrtfr+q2oDYeaFg+Fe/XaysTFkGWNQUMJBzk+BK/Uwre4uhrGch0cGr1JdBKEGCp+WPIflznExMhL7fU7bm5q/WQ0ypr0NlWqAdit0PpkdqXP+0MVfV9W5o1EakALk4VXRFFuQf4xfaQN9WbT1vCMqUKj/JwdDqdUS1EqDRhYh1HCPkh2OnYclQpM6/lzPZ1kzDtAulW+gcSkaQsheBR91pMtuUlDAR3NYv4sVZtyeIs96qTmsIL4BiVTmQwPRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.28; Wed, 14 Oct 2020 10:50:38 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a%3]) with mapi id 15.20.3477.021; Wed, 14 Oct 2020
 10:50:38 +0000
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
Subject: Re: [PATCH net-next v5 01/10] net: bridge: extend the process of
 special frames
Thread-Topic: [PATCH net-next v5 01/10] net: bridge: extend the process of
 special frames
Thread-Index: AQHWoKDx/0OIHbWIM0GIWObQ1mrX9amW7m8A
Date:   Wed, 14 Oct 2020 10:50:38 +0000
Message-ID: <8804be4ea95ea61eabd030eff51ca5116512d184.camel@nvidia.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
         <20201012140428.2549163-2-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201012140428.2549163-2-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 7ca2dfb9-3d68-4548-59b0-08d8702efcc0
x-ms-traffictypediagnostic: DM5PR1201MB2490:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB2490A4C9408DD71503DB46AADF050@DM5PR1201MB2490.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BdEyiaoT9XGQj9F0p2rx5ow4CU4YqWf07NU95iCEmpQrqZRXPXVwdgLy9NOsQKdAtOHu2bpM2v4Ve1OiXaZ0Q1Z4dKiZDqP55rMA7DYJ3JkArMeWL9KA5LUPIdz39nvzCekz1kaREtWq5FEWYadlaVBaKNFlcvv/Z0Sx8DJvZMXawNlXjfRcRH40tTUCqqpzH8AVGlENmYyYzzMHeYbp5Hr3MDJnbwa5mPqWV4vZa4Jy/JRoH9REoW35wOoDSdJjXaADDgz5BgsbCbZbXA1acjCN3+a5ohsZBqk8jmhS0lrXocD8N3vumDp1cjP+of9PyH7GODUi6zUS+6L1RLBYhszqYP6b7UJwH74F+PQ9R1eX0CG+GexfP3nEhkCVyqaY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(6512007)(6506007)(186003)(36756003)(2616005)(2906002)(3450700001)(26005)(4326008)(86362001)(8936002)(5660300002)(4001150100001)(6486002)(478600001)(66446008)(91956017)(76116006)(110136005)(66946007)(71200400001)(66476007)(316002)(64756008)(66556008)(83380400001)(8676002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7OVEs3jSeo8XE1E01Z4Xn0ff5LIcXv4wZ/dJ62R9EhS7qYJKlmNEh5dpD+VNl30l/LdrS59FCcUiyNXs5ghZxBqsecuQojprGivVVt/zqj0WSf7+TnFOfrC+vT/8Fiw3Y5O1LEqu7uSLqkr0P1LhWyTd5ttIAKCjtMG5s5fdGEqN/mSkGyNxXGCLc5Ovrp2nvQg7t6hvqFb4EqJElWQ72KrIetumTSKP8EZtd6PrtuXYlBiURZu1l5S5TLIboNna6eIacIvjJhEWUxpuAmvENKfyDAn9LTHVpGwUfjr54FYvY6Ebc23tBcpsCD/iXOdzf9gbgf5A5x81vA+frM/O3VpG1bjKw6goX223kIMSm30wmQ9a3kntGE+Pikd42/oNdoU6tj/XB+PVASCNcqy/E3Pr/BDPWVNtJxKj3MzTfwsK3LJj+VhdRt91KVrEGKTFSvggpD3p0gEz6sUTl40KWf/OjKn9PzQ0ORmBK+UblBIT0DVlOmn1QB1ksW+UH66Zw8EKgOK9ud5j8wEODLHBBRFQZdHMFDfKmecBC+5xH2tn16A1eKGb2GC0QgM5UJxfhUlwDiJalfhJb83kK5O5t79FBlSM+RX2+arGaTvP6S1Ot0Z/HjktXKqii8oLTsS1aJ2ld+TUicHiuWnwflHwPA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B07A3D8BE4C5B045A829AD4B030DAFA0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca2dfb9-3d68-4548-59b0-08d8702efcc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 10:50:38.2326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DaskMrFW+joGu4PYPVdOx8kTFncsMfpSz8eESU+Qe+MSADOj114/Oi5dOSMP7rvPljd6N2wzM2Li5AXXVl3+uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2490
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602672598; bh=x2F0/9+JMJi2vJGCxiqHYsecFSaVZTKkAHAZW5Ygc24=;
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
        b=baJO6lryBoVUXdIURSUox162ScQz0ltOLKqC0koB2+vvXybJ/VLcGqlbnHneqpbEi
         sPr5i13WNgNC8otZZAZEpp9gQSgBAWPJje2wqIxW5HYr9MGUlG1G7MNE/XUDOdOOOz
         IxqVp6xl7aG3K6GjH2asGShnqBzdblw3CsYOX5x3L98R8IP+jHmpLHrjXgf12zb8MZ
         GBdJP1bFUBTH3oGiX6H0akyGuxpcDB6eDUiKBo1bogG4BUJO86cBnevLl2aWnIKZ6x
         W8oTZkJcLjcKfacpv/sddHEA+0/6q4jBP/wLCYwHUKxzkHw6FcLwWwSHHOwrO6nUun
         5N/4kkGTnbmGA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTEyIGF0IDE0OjA0ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBwYXRjaCBleHRlbmRzIHRoZSBwcm9jZXNzaW5nIG9mIGZyYW1lcyBpbiB0aGUg
YnJpZGdlLiBDdXJyZW50bHkgTVJQDQo+IGZyYW1lcyBuZWVkcyBzcGVjaWFsIHByb2Nlc3Npbmcg
YW5kIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGRvZXNuJ3QNCj4gYWxsb3cgYSBuaWNlIHdh
eSB0byBwcm9jZXNzIGRpZmZlcmVudCBmcmFtZSB0eXBlcy4gVGhlcmVmb3JlIHRyeSB0bw0KPiBp
bXByb3ZlIHRoaXMgYnkgYWRkaW5nIGEgbGlzdCB0aGF0IGNvbnRhaW5zIGZyYW1lIHR5cGVzIHRo
YXQgbmVlZA0KPiBzcGVjaWFsIHByb2Nlc3NpbmcuIFRoaXMgbGlzdCBpcyBpdGVyYXRlZCBmb3Ig
ZWFjaCBpbnB1dCBmcmFtZSBhbmQgaWYNCj4gdGhlcmUgaXMgYSBtYXRjaCBiYXNlZCBvbiBmcmFt
ZSB0eXBlIHRoZW4gdGhlc2UgZnVuY3Rpb25zIHdpbGwgYmUgY2FsbGVkDQo+IGFuZCBkZWNpZGUg
d2hhdCB0byBkbyB3aXRoIHRoZSBmcmFtZS4gSXQgY2FuIHByb2Nlc3MgdGhlIGZyYW1lIHRoZW4g
dGhlDQo+IGJyaWRnZSBkb2Vzbid0IG5lZWQgdG8gZG8gYW55dGhpbmcgb3IgZG9uJ3QgcHJvY2Vz
cyBzbyB0aGVuIHRoZSBicmlkZ2UNCj4gd2lsbCBkbyBub3JtYWwgZm9yd2FyZGluZy4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVucmlrLmJqb2Vybmx1bmRAbWlj
cm9jaGlwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEhvcmF0aXUgVnVsdHVyICA8aG9yYXRpdS52dWx0
dXJAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2RldmljZS5jICB8ICAx
ICsNCj4gIG5ldC9icmlkZ2UvYnJfaW5wdXQuYyAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystDQo+ICBuZXQvYnJpZGdlL2JyX21ycC5jICAgICB8IDE5ICsrKysrKysrKysr
KysrKy0tLS0NCj4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZS5oIHwgMTkgKysrKysrKysrKysrLS0t
LS0tLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMo
LSkNCj4gDQoNCkxvb2tzIGdvb2QuDQpBY2tlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlr
b2xheUBudmlkaWEuY29tPg0KDQo=
