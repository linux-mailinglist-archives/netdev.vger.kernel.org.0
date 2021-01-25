Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D026303273
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 04:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbhAYK7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 05:59:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2843 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbhAYK60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:58:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ea4130000>; Mon, 25 Jan 2021 02:57:23 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 10:57:15 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 10:57:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJy3GTnKs6RO7LItbkWe4BkjYYfxDfUAEwBqUZHJZJVNsIwtBGFLqaLqNhgR6631xGDsidfXs339QsbLhuWQ5nDNzE3eeTDwfa08PgMTx6a3DUgK07uM8GZYzrJA5SxOWcPWA8xEixe30RCtq9VHv3/GnXfuzDTBb57j8OOuvg8VPgOPZtm+Omvvix2HaN8QXyMOPPRWIxWFSrNGrB+bq0EstD85aSqwDIj/B7dlPGr3POWXcwzrSrPG0V5yhzwtsEkvvvMXflOyU9QCrNwW01ylzeAbm4HUl5wsU+7W57lrdV3dLBvpbP5VRe60d+xQBHdjGXccbFOeVvlEFmuGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDr50KildjCVVyQ/EMMssXvi78eDlTClhDJlMOL++zw=;
 b=bVBzdoju8CaxoIK56W4U9pRHcLwI87Z1XggWVv5dw3PicAxWgoYSwEblym9y38c0ARU5iR99dLoKZlrpBjdZRhCzDTQeqM3CjZE1mEwYW01cpZ8+lbGWEYsdkm06QhqElIRyx7frxFvobG+wqyGUAf+Nh2w6xgHMujF7IljzHALUeeJc2pQYGoVHKZAKdFn6Opm6/py02f4oTUHPKoW5YNT26qgtdW3g4L4UoA5EfMsqkoRFB1G25WwBylnKPG+NUiVxC/mKwOByF4f/qgC4gumsGZ7raIEou6Cw4bYtvOyOw75pNTROJTRqfRBuhr/aJibSxr2nfiA3R5k+ERkymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3953.namprd12.prod.outlook.com (2603:10b6:a03:194::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Mon, 25 Jan
 2021 10:57:14 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 10:57:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        "Jacob Keller" <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: RE: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Thread-Topic: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Thread-Index: AQHW8RRNInj19u6+tky+dxvR/K+r5Ko3Qf+AgADqQpA=
Date:   Mon, 25 Jan 2021 10:57:14 +0000
Message-ID: <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
In-Reply-To: <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20fdd264-3fb7-4973-499d-08d8c11ff94a
x-ms-traffictypediagnostic: BY5PR12MB3953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3953397C1323A9C6DA5CBCDADCBD9@BY5PR12MB3953.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ywetrmrm0SY6uLhEEPRiqpx6xLyBj381+AIjLA//RlK0XhzldiXszsnALEqR/EOxTHhdcdNiZdayYQ9cJ88F2J6y23dS1lmPUQjFuuHXo/sjxmHaSvAEE/bQRW3emWgSb+UamEemMPJqCmYabc391rL0jNzMkgDWkh3x0dpmF/NZlFtFOM81pkLL/lQ4h64IeJ+Sfjc2q/kcUZoUzej1nfHpVvk4T4Q1JXvVacNiHOfSzvEtAJgVgf746ATnMCuzgjWCrgHn+BNpFeMkK9Mb8XLanI4VPVjYiebIQGvLaWx7qmzvE/yTtRvOk6Q7yf9kMjEawRLUHBgJR2a5CIAfiykXiHyMxWYJtAyr9nUMKd6egUa3n7msyc9KF4uVz1UThKHnIq9uQeRGooEqNZ8c8I2uzPJN5ZmVpwQxbe8piQwqAM3sG93TIipdUrL58rUiyiUftFZIGeyoeWybq7/ISA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(8676002)(9686003)(66476007)(66446008)(110136005)(66946007)(7416002)(64756008)(76116006)(53546011)(66556008)(26005)(6506007)(4326008)(8936002)(4744005)(55016002)(107886003)(316002)(186003)(54906003)(7696005)(2906002)(71200400001)(33656002)(966005)(5660300002)(86362001)(478600001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bHlwaExvYUVKQ1J3UDhTbjNmTHQ3ZHB3SnFnZTNDS0FOZXVhdGhUMktocW5K?=
 =?utf-8?B?bExHRXd5b1Q0N2U0U2I5aFcyNjRtdG5iR2hjRXV1RFh0SnFRQkhudlMzdnFK?=
 =?utf-8?B?UHZWUVJpRVlwSEQvUDBlSlBOY0FZaDN6YmhPQ2pwKzhrdXVkN29VaWVtbVBU?=
 =?utf-8?B?VXgva1RXV3YrWExXMGFkWjVEU0ExTDJscXFqcFFxWjZhclFpT0paR3NzbFFL?=
 =?utf-8?B?R3FiWWt2WHdSZy9KWHBxYlk0NkxlUTJDZ2RXUXdhNk5ua00wTXZWUkNJeXo5?=
 =?utf-8?B?dWhCSThvaDRaSUVPWjFOMGV6anhaMGlWSzNUZ2xpMlg2R0VJeHhaWW94bCtB?=
 =?utf-8?B?RjluZ1d5ODJWS3lHNEFWK0laU2VzZkNmMmIvR29TVXRicTVVOEU0dzRjMUdv?=
 =?utf-8?B?ZTBpZjhpVVczejB0Sm9iS1piZjltT0pWQjhqeERTclI0T1Y5dkdlTVpnVVlr?=
 =?utf-8?B?L29zZGs4ZGcxd3RZbkdTWkgrQjEwVEw0R2VZSTFUM2hXVzcyZ1Z6M3ZUWjdO?=
 =?utf-8?B?dmx0eFpHVW4rb0luNmMrQktuNm5Bd2RWNHlTdG9GOFlFZWtKS2RJSFpLQ0ZZ?=
 =?utf-8?B?OGJXSnFwVWRMSE15L1h3eHYvZkF1QmZBUzJENEVRN0lvYmxCUHVvU2FuazN6?=
 =?utf-8?B?ZGRkUVlVRlJKS09sZzc3K2xZNWNqczRISDJGMDNOMmNtOW0rK2FZSzR0QzhO?=
 =?utf-8?B?Y21TRlE2WVhBYzQ0WGxMeUNSc2NwcDQzdVB2VlJUb2t6eHNuVUhoZHI2TE1n?=
 =?utf-8?B?KzFKajVIQnNqeWhyYm9GQmVRRUdEMUZoYWswa0NyWnp5MzhFcW4vS0h0V2Yx?=
 =?utf-8?B?L3JDZ1E5eTQ4ZTRsZEhnVlQwZU1oQ0hWZWxTcEhyNmlvZ3BVWnF0dDA1YldJ?=
 =?utf-8?B?ajFibUd4bHNXa3NwN3dkbnZwUnpuVzU1RW1JU2lnNWlQclNUSTRjbWJvdysr?=
 =?utf-8?B?OFRMSXkyNWhueFhIY1B6N0xmU0RQbWowN0UydHZzVS85cXUxVzc2V0RrdU85?=
 =?utf-8?B?SklTSGZOK1liT2JsMENCamRJWlBuemI4clN5VlVKUi8ya3pUeUJCWVB1V3ZJ?=
 =?utf-8?B?QjhEbmMyMlJHa2VlZkdIZDdnMmZBd1lhSW1oT0tLblk1QUNhMjk0N3ZSQmc5?=
 =?utf-8?B?UkVOR0c4cUJBRnZxWWNzS04xaFlBblB6NVhRVFF2MW1mYkFnVE1laWoxZ0lB?=
 =?utf-8?B?RXUrZUl6dVRPdzNDL0pzQUVLYkFNUnRJV0VWYjl6MVVoUlNOd2JaZjc2U201?=
 =?utf-8?B?ZEZsWGJBb2d0WFVxTzdPb3lBdE41a1NFd2RpNTVrMnZ3Z3JDU2pyNFQxdG5I?=
 =?utf-8?B?c3ZicWR0K0xtTzFkOGlYMXRLd0tqL05Vd0ZMYUZYbDhxRXdKOUNkWG1nbENz?=
 =?utf-8?B?dFRvOHpXclpJcnNDTE0rRlhUTG13Z1I3TjV2OHRlT2h0VlFrVWRYWFEyckkw?=
 =?utf-8?Q?5FAW2GL8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fdd264-3fb7-4973-499d-08d8c11ff94a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 10:57:14.2899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uIscHaVO/uetQy0ubg8UrLHjrWyDI2124QExLSPr8MyAsoHhmApaC2ADaeFCFDvjP+cvjX1zZeoBA07SG35rbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3953
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611572243; bh=WDr50KildjCVVyQ/EMMssXvi78eDlTClhDJlMOL++zw=;
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
        b=LdznZW0FcVfYZyLZxI0o20kDH5LKDRqOwITGICoo6HXFZRsE8P1y5ajBhJKOUt9kc
         9EaXr7UoMnntI/+mOi83gVuwa9Ugn5+S0GC2wceHpwtbTtwTRw5YOzM38YZkrMdbgi
         pIL+1G4qgwwCjyd68iM1yReJiwF+1FOetxq26/k3s+icFOTCMd0DYxA4GvVuzO4c8T
         1KuB2R4cWa6UDQ70eBK9qcJHLLcspObKlvb90Dxh9U+iXYp/meHO+Ok5mAosasT+PM
         1tNhBjWzndemqmfXFRLr5PAYvzqzT8bL9NQNC4ohY2SHxHmv8pUep1qfxRrAKSGRB2
         anbZzZeJe4kIg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRWR3aW4sDQoNCj4gRnJvbTogRWR3aW4gUGVlciA8ZWR3aW4ucGVlckBicm9hZGNvbS5jb20+
DQo+IFNlbnQ6IE1vbmRheSwgSmFudWFyeSAyNSwgMjAyMSAyOjE3IEFNDQo+IA0KPiBPbiBGcmks
IEphbiAyMiwgMjAyMSBhdCAxMTozNyBBTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9y
Zz4NCj4gd3JvdGU6DQo+IA0KPiA+IEZvciBtb3JlIGRldGFpbGVkIGluZm9ybWF0aW9uIGFib3V0
IHN1YmZ1bmN0aW9ucyBwbGVhc2Ugc2VlIGRldGFpbGVkIHRhZw0KPiA+IGxvZyBiZWxvdy4NCj4g
DQo+IEFwb2xvZ2llcyBmb3IgdGhlIHRhcmR5IHF1ZXN0aW9uIG91dCBvZiBsZWZ0IGZpZWxkLCBi
dXQgSSd2ZSBiZWVuDQo+IHRoaW5raW5nIGFib3V0IHRoaXMgc29tZSBtb3JlLiBJZiBJIHJlY2Fs
bCwgdGhlIHByaW1hcnkgbW90aXZhdGlvbiBmb3INCj4gdGhpcyB3YXMgYSBtZWFucyB0byBlZmZl
Y3RpdmVseSBhZGRyZXNzIG1vcmUgVkZzPyBCdXQsIHdoeSBjYW4ndCB0aGUNCj4gZGV2aWNlIHNp
bXBseSBleHBvc2UgbW9yZSBidXMgbnVtYmVycz8NCg0KU2V2ZXJhbCB3ZWVrcyBiYWNrLCBKYXNv
biBhbHJlYWR5IGFuc3dlcmVkIHRoaXMgVkYgc2NhbGluZyBxdWVzdGlvbiBmcm9tIHlvdSBhdCBk
aXNjdXNzaW9uIFsxXS4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIw
MTIxNjAyMzkyOC5HRzU1MjUwOEBudmlkaWEuY29tLw0K
