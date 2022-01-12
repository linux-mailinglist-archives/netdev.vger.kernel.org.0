Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448D648BDEA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiALEkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:40:04 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:39009
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237114AbiALEkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 23:40:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtMHd+otwbnPZmpNHKoPx+6jD4LWJxIljD+VxnRm1vVdWWtDlLuqX043OgWg206+8PkBSQHcSR6bQJBncdw3YczFnyfO/qJpthOnUofiVEadM92y2yuRQ2sqSdriN63KI3NJWcsskUy90bPZMK0Od4hfw21p19+X0XXFHoIIzXDkTQLssDFZwm1QbCSCwGcb+EnK24bSFBH99KgnCBLtEQzZQQddD6g0K5zRUjIIjBeUbr6AqfTvcZkM7XlNId4IN07iXXojzn4Xtz5D31FPNowrm3QX4qwXporECLFAKZm8WCHpajHmpY/N1e5XHollkji9icKgwKK1o7y3JbO3kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g00JvSlMt4aBgwDNdbM2LiVoY9yo5ENUWHXgpq6vvrs=;
 b=dM/JaMay+9l5E5pu3Z7ZY7hPiJLpW2LqmvE2uAEjfX8P+DDC8+w4e5xT6pL+r56EQ2LukK13yZ0cGoWLgOAXMwENgnkJK2sPhqg6AcTjZpxQ4qb7vmenf/3VToQ5w3dmLqNSGmIjOWqhI6ImrdFvMx+n4hwAAombIECZEnu/8ANRpy70ZriNXMGP/Abac+O5MmfDO3vMINLIYPJmvmp+gCSVcKCOS+zpwuT81JYlz2SZ4m4DWry4FV9fGz3UHFvXeBpk2MDdhTY7pizqYQbUqQ7wqAT9VH162UzQkrrsVXE+fyjU7SYSPv/+JnhkXC4WqVuOOBkXbNX9gAV39nkKTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g00JvSlMt4aBgwDNdbM2LiVoY9yo5ENUWHXgpq6vvrs=;
 b=GiPTr+KF4Vbt6M+65lIIMZGmcSRbLPO/fbapO613Mpjgvx7nUpizjhJJUygiWeh8HADoz3OZG+rYGvovmrEhkLQ2um9StkX8dSghKrIeknHztXlsU5awLtn+/RU89iruqXSvP96WqFNEiziODVmFo0unrAfp8wpznO64njGCWxZfOcVKKqORvyunNkxcHIDrmQh1a8It/+uLBpVgPevEgvzTpY2GhzcEYhJPn2r0TUc53KOf2AkebquMTxunBFY+FFhSoiF49hWkX4F597XySHcktNH1ONIvAdenDYHWofz+LPoKbxHew531MQ5+qXAYgOnm07YeueCYtu0btYNm+Q==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5435.namprd12.prod.outlook.com (2603:10b6:510:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 04:40:02 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 04:40:02 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAA==
Date:   Wed, 12 Jan 2022 04:40:01 +0000
Message-ID: <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8db5a20-d285-4d9e-fe3f-08d9d58598c8
x-ms-traffictypediagnostic: PH0PR12MB5435:EE_
x-microsoft-antispam-prvs: <PH0PR12MB543594A857DE535FE3F98C37DC529@PH0PR12MB5435.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFxbkbI7lZyfkdv/jjuvaTp5rXkZeNfLw5Y2rdgir9WgsvZ87Ci7oNpLD2lmkcLRwR29nCvfA2+YqTgHasF9UcJunKKqM2p7fAy4n0O/JlYykjEU5pHRMNm9OwZOHV+5PhXN8ZWgGIT9CX/+Mxf2I0gNYJ55I0kVtpYrMUyDdySPWIYIcXr32Fjrx4waljDET45tbFPyMsbrxz07KIyXhBldfadnxjeZCJw6OTw6ohHtx5TexulG3bSYJXk6+7SDE4/K5HsBYZCFGqJbAxuSIQ2eoFTrop7Lob4oKE+sYM7bGDuVN9LexH2UGicWa/i/bnFTGeQHeANpqCWnwd0VoZ9GMvVvrY7i1xopAJs+h18tXSldAuKPrjZqp1+BPalOpIt+CG94wryTnZ9lLhboYj5SHoAQqq8/NzXpH6atsDD2xS72E57/CR9ocjlNBGdVQQlDHPusElow7wqIQsmV/oNGi5aAmsIfykUndD42yEI9+ErRrj3mO3/zz0ZUXibo310bLaJ9LZQT/gbR7uLxc8qhLP8eJtxd9x29nS3yoOuqc2dOWzBowDfLHXDvZ+1FkyiiqoZNejFP4Z9lPYfP4pltU2L39fEwJWvWseewizZ+HPqcFduLr76ubACAtJhmocFRoi0saaTN6yHFqMfnN9dyf2LLK66mVjs1/MQIpA8kLX2uaW95gYbHPj/AR8K7howbhjoZOXRkOZ6eHT16XRHPyYXMc+7K9AtNtmmj6bnvSfs3SDm6Dm/r70Cw56belW7M7gU2C8m+M/HVohMFyRhTZ/oWBhzRPJuB+tNgJSU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4326008)(508600001)(33656002)(9686003)(122000001)(8676002)(107886003)(2906002)(6506007)(8936002)(64756008)(66946007)(66446008)(66476007)(316002)(66556008)(76116006)(5660300002)(55016003)(186003)(54906003)(71200400001)(38070700005)(83380400001)(6916009)(7696005)(52536014)(966005)(86362001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7cfBXSGUtB1c3W+Rx2rVTypXRyqY64J1GO/BOKvvReXw9plTapOiBOfREK67?=
 =?us-ascii?Q?aMRlEsX2csroYktIVYzqe9JojXdw+129IeLL/yLZRrSvB+cJ2KZEoSORfHJo?=
 =?us-ascii?Q?XCUIzNCZ4AbbA+WubxdfEY6GRiXCwFxLdXH+W6kBDrKKjfQ7SJQMg0hdBkSq?=
 =?us-ascii?Q?ExQq9wcGysG0NoDvYXWTQWIJD3OQAiAbMveCDkap0e5yqnCilpuHGMngoJ0h?=
 =?us-ascii?Q?+QXH6fxgMu8B0LDqxan9G9k4X6fiTgYVwPkFeFHbjE29pDPjSjbUID9GCX/J?=
 =?us-ascii?Q?XWiY7xx5khciYBBGvgyLVxAfr2aq8Tt7FuCCqFd8MkhDLfhWnZ1Q46comDzG?=
 =?us-ascii?Q?bMCJgHhok3R43ig1aS3cqu7iii3LmK082ndE7Me2ybxFhchGrF/SIqNfoubp?=
 =?us-ascii?Q?OttYqLMZ3YC8WofizzzowgXijE3mW04tg8XDmONjS0Cif4CbB1/YlxGCxQuN?=
 =?us-ascii?Q?J56cnEmHNYF9ALgVafhRtUuALT3wfDG8q9MPI1RSdYwWYunVAeG/z5lngPM1?=
 =?us-ascii?Q?/+DF9tqRD2x0rFmR+YakCLpcGmh37xjuN22MsP1bJ++X1IAj233UFt0bvqFo?=
 =?us-ascii?Q?JZiLxaGdFtULO6hKL0WwftxewRL5BULKWm9E5gaDqrFvpBW6IZ916ECg54qA?=
 =?us-ascii?Q?WDIPoqKSSPGMTVzeZJDvA8iujLr9JEVwhtGK9fH2oOXX39Hv1pSzdtsbFHDg?=
 =?us-ascii?Q?jxi2/Y8qROxB36fNML1RkgKtfHd2J6ITcdDiWrK2SKS5E6mmkXwlH2nQfbyX?=
 =?us-ascii?Q?0MvqLFEwYxs6DPCxoFF2QgdcidbLyGSnV1h5dAQd3RYSyRqjGaDRQatXB8MO?=
 =?us-ascii?Q?E9HgDZ8cvon4bRr4O41sMnsfwWlg7alPyInuI7RNRHpa8TLhXsbhMzzTRHj4?=
 =?us-ascii?Q?CUXdk5Pz7eQB+pOaUrC8xThdTw0XvZ+QLwd1eYxB6NKv772mu21H3J7wMOK2?=
 =?us-ascii?Q?JIUb37YVm1U8Z5JaQU/t1fauVO0uySyupWrhtcZXp31Xb/UCaXHaQ8jL5n4g?=
 =?us-ascii?Q?3Hxv17bjcBAVHFi6YAtu3P8mLoTXuLbPVH0ZldZyDJSs0X9Kf8nPZ+CzFGtW?=
 =?us-ascii?Q?a0UFwWXqCqvwYAkevYy/htyIVb4QznQbhJml4Gfd20IRqZluUzGYJ6QxQNnZ?=
 =?us-ascii?Q?TFOApWJrnCyp+m0ktjqj+TTnQfM6PMRXTxa4kTg2YynyUOAIr8vuLX4dnq49?=
 =?us-ascii?Q?fOcFhN/WkoOWTANxMs4lWjRlLMTrTJI/HblNw4X1fuJ6XntozzDVJZwbbeKQ?=
 =?us-ascii?Q?BMi8gsk6eKDcsSH4v9GVdzJYgWYNmuh5CLun+veR+b8PzlX6b3eFtTgK3zmw?=
 =?us-ascii?Q?aW6SluD9bGwp46Yz+/R03zEC6LPufU3F2zGWyaDdd4V1t6RbvtqCeWP88uMl?=
 =?us-ascii?Q?/+abM82oYCueD566hNjG7YaxXkd/8U90HRcQcFgNoakVkIv5VVx6QJeb/2gQ?=
 =?us-ascii?Q?HfxlSQCRi8rPhRPD3zmlOCofbRBcL9E98AiZ7bAkGkbnb5o5ElSKyRzG6wNf?=
 =?us-ascii?Q?OHWuSQKtzWeZZ7Ge6srGaq34uT9uJ7d4X+Jey1lLAKRzZHSl6BXpbvKCzNLD?=
 =?us-ascii?Q?Ynyi18jkmWVTenhze0eMIqoeQZl6lHJDId2DnRf4h2TgA+vj+7Xe0JnpEiSv?=
 =?us-ascii?Q?4ieWv4e3WqVmwYRCENgBVno=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8db5a20-d285-4d9e-fe3f-08d9d58598c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 04:40:01.8749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nIhf1WtDjIcz/KWpBmTQXZVCaNKTsCZLOAW70vifHRPtfmN1skuXO0SR5GgliUjAtRTxcop7Zo4qOQvTkygWSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 12, 2022 1:27 AM
>=20
> On Tue, 11 Jan 2022 19:39:37 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Wednesday, January 12, 2022 12:54 AM
> > >
> > > On Tue, 11 Jan 2022 18:26:16 +0000 Parav Pandit wrote:
> > > > It isn't trusted feature. The scope in few weeks got expanded from
> > > > trusted to more granular at controlling capabilities. One that
> > > > came up was ipsec or other offloads that consumes more device
> resources.
> > >
> > > That's what I thought. Resource control is different than
> > > privileges, and requires a different API.
> > >
> > It's the capability that is turned on/off.
> > A device is composed based on what is needed. ipsec offload is not alwa=
ys
> needed.
> > Its counter intuitive to expose some low level hardware resource to dis=
able
> ipsec indirectly.
> > So it is better to do as capability/param rather than some resource.
> > It is capability is more than just resource.
>=20
> Wouldn't there be some limitation on the number of SAs or max throughput =
or
> such to limit on VF hogging the entire crypto path?
>
The fairness among VFs is present via the QoS knobs. Hence it doesn't hogg =
the entire crypto path.
=20
> I was expecting such a knob, and then turning it to 0 would effectively r=
emove
> the capability (FW can completely hide it or driver ignore it).
>=20
>=20
>=20
> > > > A prometheous kind of monitoring software wants to monitor the
> > > > physical port counters, running in a container. Such container
> > > > doesn't have direct access to the PF or physical representor. Just
> > > > for sake of monitoring counters, user doesn't want to run the
> > > > monitoring container in root net ns.
> > >
> > > Containerizing monitors seems very counter-intuitive to me.
> > >
> > May be. But it is in use at [1] for a long time now.
> >
> > [1] docker run -p 9090:9090 prom/prometheus
>=20
> How is it "in use" if we haven't merged the patch to enable it? :) What d=
oes it
> monitor? PHYs port does not include east-west traffic, exposing just the =
PHYs
> stats seems like a half measure.
>
Containerized monitors are in use by running in monitor in same net ns of t=
he PF having full access to the PF.
The monitor is interested in physical port counters related to link transit=
ions, link errors, buffer overruns etc.


> > > > For sure we prefer the bona fide Linux uAPI for standard features.
> > > > But internal knobs of how to do steering etc, is something not
> > > > generic enough. May be only those quirks live in the port function
> > > > params and rest in standard uAPIs?
> > >
> > > Something talks to that steering API, and it's not netdev. So please
> > > don't push problems which are not ours onto us.
> > Not sure I follow you.
> > Netdev of a mlx5 function talks to the driver internal steering API in
> > addition to other drivers operating this mlx5 function.
>=20
> But there is no such thing as "steering API" in netdev. We can expose the
> functionality we do have, if say PTP requires some steering then enabling=
 PTP
> implies the required steering is enabled. "steering API"
> as an entity is meaningless to a netdev user.
It is the internal mlx5 implementation of how to do steering, triggered by =
netdev ndo's and other devices callback.
There are multiple options on how steering is done.
Such as sw_steering or dev managed steering.
There is already a control knob to choose sw vs dev steering as devlink par=
am on the PF at [1].
This [1] device specific param is only limited to PF. For VFs, HV need to e=
nable/disable this capability on selected VF.
API wise nothing drastic is getting added here, it's only on different obje=
ct. (instead of device, it is port function).

[1] https://www.kernel.org/doc/html/v5.8/networking/device_drivers/mellanox=
/mlx5.html#devlink-parameters
