Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AECD270AF0
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgISFlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:41:07 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16060 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 01:41:07 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6599980000>; Fri, 18 Sep 2020 22:39:36 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Sep
 2020 05:41:03 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Sep 2020 05:41:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBXFnATDyDuOv6BeY8mm2wiESg1xtYV3J1HNp//03TTkcTXotjpWpyiy87JqRMEGxypeidq9ogxfHg3EVBlLXkBihYqOGI00baD/QNTAkExwNGWQLY0frWDGQ17XUlRWPvSfvblzbHtjk8yetYFlXN1hJVho6wwbNDO1uFpVdCvA0n+GGh7uN30/A9Iu9jRAWuk+IlARwDJSBGFC2GhAyVN0/8RWuKahSC0g5BVs1q20G0UbM3O2HARp8Mlx9F+mqM/DWcG9Om5FHwhFJaYmrokOh4cvm9Xl3Q/3ZYW21orzfGilwbq6rdl/yhIpkt14Ltf1FsRf8UiYkyCeYx5v1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLsX/5U6CPUyrvSsL2qyovfrwaN426tBziN+GTkLERI=;
 b=L+umHoFCydK6Iby7EMacGK5y0EB7qEALTbWLeD26tKPXg5A5psaoNYcDlqF0A+VaocowTC1Rf6lgkUgfkp9PMZDqbpy53evmovcGYYzPWLGn+Ll1z2Hj+R/MFO6qbTKLvfvQ6pPgNdo7dtYVFewOMGXLeWs710Zulqe7U+/KooweaBQqtBCy9Gkr4G6vjFybh6Pbe+prU/Ww3P/yNPdrYoLmtA3H9bjZcsPmA3yGmiMV6owYtnY7EjbbOlEENtx+GqlR5j7BG6k6JthKR5ZBdOkSTW19WDLcdikro9bSsN7d8OsEaLS4cal5JypeAII7R1xeYONbU2qN8tNu7JxNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3080.namprd12.prod.outlook.com (2603:10b6:a03:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Sat, 19 Sep
 2020 05:41:02 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3391.017; Sat, 19 Sep 2020
 05:41:02 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 3/8] devlink: Prepare code to fill multiple
 port function attributes
Thread-Topic: [PATCH net-next v2 3/8] devlink: Prepare code to fill multiple
 port function attributes
Thread-Index: AQHWjRbe0yxrhyimLEag/sA5zdH96KltLvCAgACPt7CAAUREgIAAcWUw
Date:   Sat, 19 Sep 2020 05:41:01 +0000
Message-ID: <BY5PR12MB432230C8148A20627B98A9FADC3C0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-4-parav@nvidia.com>
 <0dc57740-48fb-d77f-dcdf-2607ef2dc545@intel.com>
 <BY5PR12MB4322D4FA0B0ED9E8537C72B3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <7b8cdb46-cb5a-445d-68d2-307a469747d8@intel.com>
In-Reply-To: <7b8cdb46-cb5a-445d-68d2-307a469747d8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 425290f2-e9bf-4697-da55-08d85c5e9810
x-ms-traffictypediagnostic: BYAPR12MB3080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3080012C93059F3836D551ABDC3C0@BYAPR12MB3080.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yljrUKcrJp/Eqq/hJFuNt3scRDYlVfZWnVS+dZoMXzGUBRd5t7w5PII246uK0/eRdkXKzcUOxo7jmsaszkwkMPK4SRLHbwdB/AmUzZ6WpujBJNWRS9kAag+z/GuujhcgT+c+wwCqj2CniJZgH3CJlT47Y3SVrhukjba469iOjEvExxYMZnzxDqS2QCBf9su9BMKpkgwyy/USU23g0N0OtNauuWB3pgTCzZtYTtrsw5T233eFC+/CUcqPI3g1ONRQn3ZYYOjuOBKIfySsWfJZFo65CC+jm18U7Uf9x8VdzvedM5bFK8cDYd2YET1bK7pIIvjMkQMXiAiobCXxNxAKkXJNDttHEeiRLEiHJ402jexPAWYM9MPdgY7a+wCL4Fa/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(107886003)(478600001)(26005)(110136005)(8936002)(316002)(4326008)(33656002)(66946007)(86362001)(7696005)(66556008)(66476007)(186003)(64756008)(76116006)(5660300002)(52536014)(8676002)(2906002)(55016002)(9686003)(6506007)(4744005)(53546011)(55236004)(71200400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wsy0YEAnDtgrIKYv8+TVFc9Cl89xR1qQLhC14j5Fvvnr2xKKtr0qjA9UDBLIp9SOCvMvB3cCHiDwnwHyK/OW/DQVJr+dBHmxct6CfkBO58IDKieEZG4emMC42ur1CIBpWjpzE4mQm7qbs6kGcdm2wOgya8TcD+kZX649VrOXPP6Ti8ADdr44wOi7tTFNS3swDgoIWnXp7VVvFwY3R7IK1ZOtTC3VQ1zNJ+rMjoA16uUGXcwFekCFhgFA4yvRNdksJAguLivQcDZpylo7kXFNBkxRXxro5LNGLOfRJ4tFwJi9EeiC0D2PxJ0GjQUUpwOUouq88GD5VeRPGVkaD2fH6bvuI492LZu9yPTsEdNQl2oHwawnNNd+Jlv21C8nOe2QFPIVBSuS8CMYxLwKuRsbmEw4NEoMrzRFKcGZWkvKlUiLt/nAzjzY8hPsbvCZihRu0QWwgY2hvv+rZ6z75UGZhCN5uHCmh8iArj4/toZJ/MyFLlAj6YOHT90hfrgw+pZoI834BnH0hU5WmKqkOH4UlW/H6dWGqZ+MFfR9JU88T/97UumfpnJrxG+MkpG2qGYDAARWEUsi+JfsqX3QYXybHhSfaQ/MwKzy5/p4TVEc3s1kEoXmH0qhFngavuibXLJymrJMWq0uG9S+YHjhb6fOlQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425290f2-e9bf-4697-da55-08d85c5e9810
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 05:41:01.9871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JErUwsnHZiKDf+7u0nYjWzq/iPcBHUl6jIpIuvKvY/OIbkkz9IshwHwdbGkKfKHBpc3xXzGv5lw3e+qyVI1skg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3080
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600493976; bh=VLsX/5U6CPUyrvSsL2qyovfrwaN426tBziN+GTkLERI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ckTr0BN6I0VPf2FyPogt2Szt1B/gIPstvH6jqb4+bYPTOhGmYY9oP7FE1IWaJvN6y
         R5VyV5fXQwvRhoYseEWJEdlA4JUqz073CZEqZetWFu2RXXXl8zJaMEc+A1LsTU6OWF
         g/PBM91SPrTRnWd3ifXG1V7WkBpHIvIW1/pJtOkamzkEh54mqFCs+fAZS2Mf3tj2O+
         RiOL2WTFUaD+DyYNziHQaeu6Iw/CTwGv7nEMEl1ypZD22kY9Ahsevbg2hctuyEBt2E
         SxFBoKDDgDElV/8jPWHEC3jUr4lNn+QAdcsKFsKd1DLWIUBqoxK4SM70ktpCmyZFdE
         PczUqH9c+IDwA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNl
bnQ6IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMTksIDIwMjAgNDoyNCBBTQ0KPiANCj4gDQo+IE9uIDkv
MTcvMjAyMCA4OjM1IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gSGkgSmFjb2IsDQo+ID4N
Cj4gPj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+ID4+
IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE4LCAyMDIwIDEyOjI5IEFNDQo+ID4+DQo+ID4+DQo+
ID4+IFdlIGxvc3QgdGhpcyBjb21tZW50IGluIHRoZSBtb3ZlIGl0IGxvb2tzIGxpa2UuIEkgdGhp
bmsgaXQncyBzdGlsbA0KPiA+PiB1c2VmdWwgdG8ga2VlcCBmb3IgY2xhcml0eSBvZiB3aHkgd2Un
cmUgY29udmVydGluZyAtRU9QTk9UU1VQUCBpbiB0aGUNCj4gcmV0dXJuLg0KPiA+IFlvdSBhcmUg
cmlnaHQuIEl0IGlzIGEgdXNlZnVsIGNvbW1lbnQuDQo+ID4gSG93ZXZlciwgaXQgaXMgYWxyZWFk
eSBjb3ZlcmVkIGluIGluY2x1ZGUvbmV0L2RldmxpbmsuaCBpbiB0aGUgc3RhbmRhcmQNCj4gY29t
bWVudCBvZiB0aGUgY2FsbGJhY2sgZnVuY3Rpb24uDQo+ID4gRm9yIG5ldyBkcml2ZXIgaW1wbGVt
ZW50YXRpb24sIGxvb2tpbmcgdGhlcmUgd2lsbCBiZSBtb3JlIHVzZWZ1bC4NCj4gPiBTbyBJIGd1
ZXNzIGl0cyBvayB0byBkcm9wIGZyb20gaGVyZS4NCj4gPg0KPiANCj4gWWVhIGlmIGl0J3Mgc3Rp
bGwgaW4gdGhlIGhlYWRlciBJIGRvbid0IHRoaW5rIGl0J3MgdG9vIGltcG9ydGFudCB0byBrZWVw
IGhlcmUuDQo+DQpBbHJpZ2h0LiBXaWxsIGtlZXAgaW4gdGhlIGhlYWRlci4NClRoYW5rcy4NCiAN
Cj4gVGhhbmtzIQ0KPiAtSmFrZQ0K
