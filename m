Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C4B3A1098
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhFIJx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:53:58 -0400
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:28612
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235488AbhFIJx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 05:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZMcpADwj7lNo6H15zRpG0xq9jt7fjoi2+cof5h9bK00IPTWoJ2mLt+9D+wFI+G7r4VhSS7OM/ag1zI7a8E/py+uClFoevDOS2eP2FDwvxKhsumJ5/bpH2ZvzJy7rCtul7iggyrj1v1GjIkjwk9dZye43T77gkm/COvrHIOv90kOYcNL9eZ+c3DWYbMvmmLkKP+2WYBMMGrN+5PMJWrPutR/qAh9bDQB8kg1AsdSMizqfVXqBdyJlc5dQ8vCnwURyd1aMk0XNrlUZDBy4VF/kMmTUYvrOXLtBDBAm6h8KtErpuW4WsqyuKM8bkbTTjFUuxSKDmuib0ECFL2VVIjjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6cdUYsYGM/FFEBNWnmH7JKoO4oT6QKoExOlT4uauQU=;
 b=VIJPX7bUPA4hBd/Zr9Nndq2JyuTTpY4wFR4jZsfsUwLSqvnqsuQS8zCpVzTtMaHQcgaavYPej4uk5XDvlRGRoUeyqrNZEs7z4TH94vpoUgZyQrVQOX6H5RbsNWOzjbWpfnPhtFRrqIhlgq5tIAM7zVn8RXDdZYxveehQZmN/4bFl+QVolNbXOpO+fJfMhlJRd19h2YlCftzI2W8H1y0+Qaf66qxuzJ5KN8qxs8VnzEjmIG7FVfUvf+YN3xrcVhHIaMFTamIzDPfQzmRd+hec1QPORfh8jfX/xLWZ5T/axpBZ3gZexONNJU1rkwwtdV8ZOSK2n9JNqxAsJr/3iznYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6cdUYsYGM/FFEBNWnmH7JKoO4oT6QKoExOlT4uauQU=;
 b=jcEcI4JbHVJbAmToeKEWmtiEmHGxQ/+zlApkE2AuVwuFZHcSBYJLvRxe3/d1xJSpdz9MmTroMdQ41JkleNUZtf4iHYnlKNBjkywoAW+pKbh2pqrrAsBhhHFn4NDt9K9drpL73mr85leJKiUEcuKaV45DshVsbFy0t+p6bCYMrk4s5N5QZ+mACvJssBJabWF9/OQrbsR2uIJGW0i6neHctbUS3FdzmMsMcZgLNPx2y3j9vhdWj5Pa8gQbs5/v1ba7kCGfgq5cUK+a3oG5x5QQkpzyNH2jgzgbLSts9A7nhfNb9bjSeRsIMTDwIjdlF35ovVZ9E7hsQL+zXa2MCJAYBw==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM4PR12MB5152.namprd12.prod.outlook.com (2603:10b6:5:393::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Wed, 9 Jun 2021 09:52:02 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 09:52:02 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Topic: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAWhkoA==
Date:   Wed, 9 Jun 2021 09:52:02 +0000
Message-ID: <DM8PR12MB54801D7B4FA3A44ECAD4DE2BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20190304174551.2300b7bc@cakuba.netronome.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
 <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
In-Reply-To: <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22bf6fb0-a241-4a44-e245-08d92b2c3b96
x-ms-traffictypediagnostic: DM4PR12MB5152:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR12MB5152C44AAD6BF582E0880977DC369@DM4PR12MB5152.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rvi3VYfYXMsS3nzuQxGFmZ6CX19fbtVrRq4qNozbwQBLPaR5qmgBh0zSFnQybPbUyWNnCjytZ8uo+TyPe5qb8mS5LiE5m9N3P3CASgI9XbOrWmobVwyNHBLjHg8d6UQz5b6yGM5nocftwCBhUsirGGuNkq5DlloMyqd6JdX8IhD12rLPSM1WDspLokc6Z48BaB/4qNjgnfVQaLK7tQXbRU/vUFveeA0VGqrS5rT0jyTlH16n7gs59tSMYY+IutzIadORmBX0bALG9vwUTpN3IQbaUl1DftvglQPhzI/BQsHMiQ8w2CyLkcoSrknjRoATRJWJq/rid5zKhd0IYMUg16/RqM3ur3wS5pdLCker1/l/yXYc4C+urARUejfrRZEj1+YXnUUM9rV8X6D/37Bveh6vZldxM0odkJiM1pPcxjpDtkZwF8LAs4RMkJ1p/3zNVBAlxcDYHC8bM+XEV60jVVwIOGv1OQ9UkIYUSccbclog7tejmmeezizF7aHACQ6pFEZUvn4SSkvZdyClH8pbaCklQMOfUO+psZzkHU5aSXtTRenWu2xg5yJL4UiXo4HAK8eCSX8oDl4DbLdoTJ5sP5aUM/G7nKJDd7+OnWICHNM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(4326008)(7416002)(8676002)(86362001)(5660300002)(478600001)(9686003)(316002)(8936002)(71200400001)(38100700002)(122000001)(110136005)(52536014)(55016002)(55236004)(54906003)(6506007)(4744005)(33656002)(2906002)(7696005)(66946007)(186003)(66556008)(64756008)(26005)(66446008)(66476007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3BoSWEyKzNjc2JreFJsU3B5T2NSZ01JYlBaMTgzQjlGZDh4TklKcHBtQ21q?=
 =?utf-8?B?Yk43WXdBQmR2YkMrV3R5Y1dhcDI0bUFkd1dBd01EdVFvTGFjL1dYRjRmNzJR?=
 =?utf-8?B?dERVaTdMd21xZzh4bU9XdzYvMnZQZUduclpTdFFFZGIwYzdlTE95U2ZyR3Vj?=
 =?utf-8?B?YjBMeVpVZHpGZ25idUtScmtoT1NEbjBHU2N0T2IxS3dLelg1QmRhaTFaaG1k?=
 =?utf-8?B?T0VIWE84dnJQNHdFRDR4SzFvQ0FrTkN3d3hJN09sdTVuekVtZUlUdXVFRVZU?=
 =?utf-8?B?ay9XRTVodXJ5aUVTbk1YYlBDS0xlSURjOXJaQlJ0MmhDN0ViTmc4aE1LOWdp?=
 =?utf-8?B?aGg5NnpKRDJqUDl5MkY5V3didzgvWGZPMTVjLzAydHdYUDQ2YjZzdVY2TDl5?=
 =?utf-8?B?WWNjaGVZWURFbU5KaFBjeXgybWVvY2h2TFpHbnhLNXMvSnBTRXliT1dOeGdQ?=
 =?utf-8?B?VnI3M3YvUXllbTUzUVpoU3l5VU1SWnpCRFJtdEhyRFpwZlNTTFUxSmI1cFBz?=
 =?utf-8?B?QzdNMUJ5aUdQOG1oZzhnOVJIMzlwNXFQVm1sbmtKWHZyRFdRd0lFbGMrWk5C?=
 =?utf-8?B?aVN6ZHUwcWNZQ2RwZklxM09ubDAreEduQndKd2QwMlJyM1V5ZXV6dW1XRDkx?=
 =?utf-8?B?ZzJnZmFuSFA4SWgzV1ZUR0lQbjE1SDhzVm5XSzFIT3Q0YWhVZFQyc01HVTBY?=
 =?utf-8?B?TlpWZFh1MmsyQnRRSktyR1lNaU5STWNOMnk3YkJJMXlrQnl4R0c2SzZOWUQ0?=
 =?utf-8?B?dFVvMmxtV2FWNHNoc0N6ekhpMVZTNDRFSXRqODRlem1jVXE2ODdqZWxKRnRn?=
 =?utf-8?B?YmxidFRVeVVlY3RCbnlBZXBKd0FqaU5QVGpaWFdWUzdpVTdtL1NXcUNhZEZx?=
 =?utf-8?B?eGFsYWVDOU13ZUJMdkprNW5neWphV2FLS2UvR2s1UWlaRUxKL3VxRlhOdG1k?=
 =?utf-8?B?aDlPQXh4TFppZ1pKVEZIL0xZT2l4dG00clhUNFg1T2JSc3h1SWNXdFhJUnY2?=
 =?utf-8?B?K3QyTE8yZmJFK3hTU2MxdFpPTWtqajNXSytvRG9vN2MxUm9sODkrZVRSUTJ3?=
 =?utf-8?B?bHBHbjlIQWFqQ0hkVjFRcnJvWGI3ZTlrSVFtbFNWZ0tQbGh5d3cvRVFyZUZs?=
 =?utf-8?B?bnE2VDVkNmwvblhIRElOYlVVN3RMRFVjbWE2eStzK1ZyZm9IUXA3UXRKZnFx?=
 =?utf-8?B?a1VaNmJDSFJ3WmExTFN2TDM5TzBnQS85eFRRMGROd0VoRk5jaDEvVGlwOHVW?=
 =?utf-8?B?ekxNcjhIaVgva2ZhbkVDSldaL0dKRlQzR0s5TStibFhKTjJoa1p5RHUwTkZC?=
 =?utf-8?B?emI1NCs3STVwVndzckZISE00aVd5Y3pGOFNWTTQrUEs2RitHQ0dJUUY5RHgw?=
 =?utf-8?B?eEU0UlE3U2tVU3NxTHFGN1E3aG9EcVJOZjNOZDRFRmt0bkhEVWprZm92MmRk?=
 =?utf-8?B?VTlKVDdkNmxMemhtcWJiUHZUNFd5MGxGeU14c0M5T0Z5NndFSzhYRHNTbGVY?=
 =?utf-8?B?V1RMZExGWStiQWw4cnFGMVZHMXZnZkZFd3h0WVI0N3YxSGxoU2tHb2NZTXds?=
 =?utf-8?B?RXl5UjZUMG9zL2l5TEMyN3FheTJJVlFNVGRrNytLUzcxNFN2b1hRZ3YzZzl1?=
 =?utf-8?B?OGcwbEU3T1ZpWmZNVVpQdStvSkk4UGNMWWY1QWh5cDA1cExiMjZtV011NmJn?=
 =?utf-8?B?ME1OdVhaaGh5VCsxV2M4dEIrUHZsaFY1UDVBbXhxOXhPdFg3SnEwZHZuTmg5?=
 =?utf-8?Q?ZGJbrTEc8NTLPQsNF1tkXHMcfhTkzfza7rPNW3a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bf6fb0-a241-4a44-e245-08d92b2c3b96
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 09:52:02.6113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3kFUUryyXyNPZZ5In+ouSsG88CEe21OI4hFCl8JD1/0fhJ35nv6P+hDWjelORWDzhq5fgM49MgsxqUvhPcrxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5152
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gU2VudDog
VHVlc2RheSwgSnVuZSA4LCAyMDIxIDU6NDEgUE0NCg0KPiANCj4gSXMgdGhlcmUgYW55IHJlYXNv
biB3aHkgVkYgdXNlIGl0cyBvd24gZGV2bGluayBpbnN0YW5jZT8NCkJlY2F1c2UgZGV2bGluayBp
bnN0YW5jZSBnaXZlcyB0aGUgYWJpbGl0eSBmb3IgdGhlIFZGIGFuZCBTRiB0byBjb250cm9sIGl0
c2VsZi4NCihhKSBkZXZpY2UgcGFyYW1ldGVycyAoZGV2bGluayBkZXYgcGFyYW0gc2hvdykNCihi
KSByZXNvdXJjZXMgb2YgdGhlIGRldmljZQ0KKGMpIGhlYWx0aCByZXBvcnRlcnMNCihkKSByZWxv
YWQgaW4gbmV0IG5zDQoNClRoZXJlIGtub2JzIChhKSB0byAoYykgZXRjIGFyZSBub3QgZm9yIHRo
ZSBoeXBlcnZpc29yIHRvIGNvbnRyb2wuIFRoZXNlIGFyZSBtYWlubHkgZm9yIHRoZSBWRi9TRiB1
c2VycyB0byBtYW5hZ2UgaXRzIG93biBkZXZpY2UuDQo=
