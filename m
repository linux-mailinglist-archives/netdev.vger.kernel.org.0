Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E926548D0FD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 04:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiAMDhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 22:37:50 -0500
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:20193
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232208AbiAMDhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 22:37:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQjp0U7293VxYidvZKBvhj9YzTZpzUhclsuAA/i1D+VGk+0B27sY2AaBoaxbr8ONA+4kbWOnsk8vSu2iBDihZQW6vrnBcdXUP75hi+xUcO1BdAAG8doDFwXT7MLZ2DXAMSg0h1XjHIis+1z8l5m2Vj2xYlNOwwSTk4u/aetTZBhClb+tM6S+62g2j3h0/cITS8I6kyO2OiLfzPkw5vTDazwnXCwJJHtiG4wHUuH8Kc4qA5ScNWYcVu2wB2B/ukBRzZX2ynQr7krb5SaBIH6Iypls102etmMidKDnbImuJE6D8mf/jGl7+BuXy6R5tY4JgX+QfXhI1Vz6wIUT/6SFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cKNdWN0Z6LWviTbr9DEDg8d8K7xp5xXjaMaeYPwz8E=;
 b=D4/pHkHt6vKOFnfMIysXfpqyGy+hFMmNoD9qsqHOOzzNIAnp6Mk+c2OVS27nEUfY2Rhet2v4vvWoT7ySQ+O/jg/arWqV+ZEe7ME52EIZEP7XqvHmN75SfWnbeozrW6+F2H1R0lvPgHx/mX/mSSszFLzkg4okjW63T8vVGznpfpgcF2d6EUUvbEmjJAD8JTOrwAnsQzeS4AnEx8iJ2XJpnwGygg68XRZNAmgxSubSDnDNblNBg7orL+ukl+1eHscPcDfvV23+qWHiPSZ0ZcedQ/LWuL0bC21X5HaueNSZVSSkVFhF/H8bqBVHKQsiGvlBWbZaqxTB/nj4SNAecg70Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cKNdWN0Z6LWviTbr9DEDg8d8K7xp5xXjaMaeYPwz8E=;
 b=OehDNJPZJzVOvRvQbNwTGrVPD1hgjK3hAE1R2Qy0UlAK6L44nj80HFcwuWLmk0/Nalp5mkCnK/FEBbNPNbD2GHM4w7Q0Nme3gNkBeT16mQAHNf7a7nCAcN7k/niOcf0B8QSFArxQrZOrpHaO/r7y9BzfYhnksQI1a7a6sORIPETABmax8Dc0P+9BKRwC12w+u5I1lm/eSAKrdtfrCnTS0LxPh8HqLJleQZhtnoW/dmQosGbvgQ4b6rD3JknvaCy5qSxoQ9q8TizVHzBbnNxC2kHarkEL5vsyqLfJaERrl9ZgcRXIYHizwkX9rFdTyuv/IDJTnCJ0tu6pj5HEMa/zjw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN8PR12MB4625.namprd12.prod.outlook.com (2603:10b6:408:71::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 03:37:48 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 03:37:48 +0000
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
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHA=
Date:   Thu, 13 Jan 2022 03:37:47 +0000
Message-ID: <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
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
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4508144e-e379-4043-1a28-08d9d646118c
x-ms-traffictypediagnostic: BN8PR12MB4625:EE_
x-microsoft-antispam-prvs: <BN8PR12MB4625C13F8F2DCD53CB787FF2DC539@BN8PR12MB4625.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZG3QQCFsj+737e+sTFCbhKhogNiZXjB9DEtHvowP96xlwc8aTMKwApgFtoo9dqpNatd/JEJC1kOhEL0PIi4cosKxFaRDmDbIXIg7KcRFN5znMlh5C/S+ERP3nXvqNCtywqzq9XBP4LWMO1V/nLgPZH19kf8kzcQwIAjFULR2hkWxwH43HBYq2TBEiEOK+uIUpvHfqHJeWXbYxUefv1UlCQy/b+qjMmusvbxwLUzpRvsGS34HtWZ5aYqWVOJ2XSde9mYat/ZcMMPCQ4UdwlAJhFkTYFLYFHAWhgwGOjlmZM99rSicaCAYdbBS6a4rbbbcFviiQxrcD5PD0m+j9OiXt0HC7e+2ZQtEDS/Znwhls5KuHhCPasRV02Xd1ymt9cvvt14y1X7KxUlUMx9tqxn7BdPdEtd3nsMhsUjTQWyhKZ6m2vyUcHoKctGYaqVoe4wXZ1jSfrqVvqtswuw3ugxagHnOjll4+s7MXNYuwB9mQ4NAjAbJ/aPir3EgN4RPhPYITx2J+CvjYlmxnZhP+hFj+Y5rC2/dxK0IvpQhuSWqiXHUn7HaesARXr0GZP3qFvS7vh2NqkjPRZmzfGTkdSkdPzQoHdNRejiVlcqA9PdYO3yVF8G4Omfthm7Cosma0lqelWCuJoz7vMBdl5tNIkhxh8MyVSWeDWp4FG11Ws9f6vWDd53FPjVhdAtdQziqhsMXrclVU7IFH5Qz7YVvvXPRhD/Uh8JFVRd69b0c3wmrOHmYccHjv2bqyns34U6n6AllhMGqRBQNmXjSBLlr19uhexpsqjCzNlCkEvoMAUCTrw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6916009)(107886003)(26005)(33656002)(8676002)(4326008)(8936002)(9686003)(966005)(55016003)(7696005)(508600001)(2906002)(6506007)(71200400001)(186003)(38070700005)(5660300002)(52536014)(54906003)(316002)(83380400001)(66556008)(66476007)(64756008)(66446008)(38100700002)(66946007)(122000001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uvjZF15NuWBkHWudpRqJeBuzr+np0/3vTFBhjqOqwqJurTd1+NQeXsHUK/bz?=
 =?us-ascii?Q?LtqyZ73UYa3uNJcDisLKiXasmy7s7YPhFrApWhZRD+JO5noUmjhmOH1HGR0q?=
 =?us-ascii?Q?3SglhlkyXYQCV1Jf7+hlpkapdWQGANNBAVG7V4TAIj347gOBJBOEFiCiXUkc?=
 =?us-ascii?Q?51orSoGgV3yjUOjq/apmN1ircWABnD2EtY2dziP3++jAOzuQFCFXQPSlsaIM?=
 =?us-ascii?Q?/ElzTDBwUePoRc2Je50v+r8azjjHtlnnhLeQesz8qRvKzXPutozLvBYYa+q8?=
 =?us-ascii?Q?e/FkcfhgcToKgJldnMegldnwIUcE77me5rmGTGha5h/7U/p9WT/c1sphdtww?=
 =?us-ascii?Q?lJg0V3a0ciTMM05VVFFAbiol6IIWzOfOfP++Rb/P91IF3kjHvRVyR4biPB06?=
 =?us-ascii?Q?XO0y/DmKLiqsKhZHPhag8OAZ7OvnLFE8oEPNGOcOYufBozUWwqAojX4g1t0h?=
 =?us-ascii?Q?QPD8D190AvV9fqlBH0Uuqe+bUDRDrhNapxtGDHxYMiXTCjm7JV4U+FNj92iO?=
 =?us-ascii?Q?nUH9P5YurCV5DX2tzmr/0zwjHyeACPhhchLqDdOaJcqdp4ErVmdG4tgb+bmt?=
 =?us-ascii?Q?x2n7ukEs2Pat+MXBNhOgAso53eCCQHyk+8zRQ7XlvUiolgyXSo7Fy86iSFVo?=
 =?us-ascii?Q?JawQcSoGvPRy5jaa+qd7PnoubQvMxS//JpIvzwTkdjWFgd4iY5WD96f50mfa?=
 =?us-ascii?Q?ajkAq0beE1oKNKWmgbyNJXwIn39p5xkfxd2lmh1yXvDbPWTxoXrxGuXNm+fn?=
 =?us-ascii?Q?yAJ0juuQ9HZwnFDaEYZLHr8qu6UvCm73bcXEQtg1AYepMztlBYUdOHb4YdUk?=
 =?us-ascii?Q?8cvVhV80HM7EQdVrF5IKyMLt+gzcWIMwg2u5j77PxlMFS9CjKv/xdjOAe2aL?=
 =?us-ascii?Q?tv0W5FRZfU597jtY6i35WNT0/HfpK6/AvUCNSY0Ckv1tbe7m6Vuom7/DwejX?=
 =?us-ascii?Q?cGHK52awjrR3u6pgi4C+zo7LZNd+UB9Ph3Kyx4vQoWw1o/Q6kuO+/REVbZwU?=
 =?us-ascii?Q?CVnTg4n9WPMKmKI3xV3CIyMrhORojkCfjN/K0HUZUZ0eMSnnZWPbYWh4mkq+?=
 =?us-ascii?Q?Z8B6oWOQwOCE9qwVav/kaP0zbWjOczS/CvLQASbQXYzeCZdO+kbF4WiBepYy?=
 =?us-ascii?Q?wOAElxhpMFzBWvUhOGy0Lf3gutR9A87t8iLR+WzHv0lkiiYhEowfOMmQjKrp?=
 =?us-ascii?Q?Wi44MzinsdB9SWe6NUAdbPfDbIsAu5UXB1Wsim83tVyXCSzHf5+zwdHGTFc7?=
 =?us-ascii?Q?GzFNCdntUrFsQvFMdIT05yiK6sAyXfRtzLr+D/p8blO5fWy9gYJ6QIgMVwf+?=
 =?us-ascii?Q?MfmUph41vanAuKqLmUoi6tfaAPecjPALXEDTyU3mGviVLGyl8CY9VdylNroU?=
 =?us-ascii?Q?RofvxB14GulVVhVXMuDf5YOD48sWmulU8qZK1T6fyZ9IyvjHf2qOpTAxr69i?=
 =?us-ascii?Q?eVdoXlgt0KIYtYavcJxuPxiHXWBLSiAIiltDjc7K6dzBkvBD42tgYa04mztT?=
 =?us-ascii?Q?uz7/+I2XAgAlNuPwBrl7Dg5Es2pel86RRSN/lAhmnAoCUSAyVLbMMhGFsXy1?=
 =?us-ascii?Q?OUadVU7uqLlVX05rSwmGLOh5ACjNvCNl/ZOIEEAemvpOH0gvTX/mplG07mD0?=
 =?us-ascii?Q?Ds5eu6jqbwBuLWJYzDC+5fA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4508144e-e379-4043-1a28-08d9d646118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 03:37:47.9147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2etGngjWu8aDkxifonuGkgrylHP+xEl/NbTBMCs98PIgYXJTVNfbhr0nf8MFTwkcLTe6i3E83B+mXb411fWMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4625
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 13, 2022 6:06 AM
>=20
> On Wed, 12 Jan 2022 04:40:01 +0000 Parav Pandit wrote:
> > > > It's the capability that is turned on/off.
> > > > A device is composed based on what is needed. ipsec offload is not
> always needed.
> > > > Its counter intuitive to expose some low level hardware resource to
> disable ipsec indirectly.
> > > > So it is better to do as capability/param rather than some resource=
.
> > > > It is capability is more than just resource.
> > >
> > > Wouldn't there be some limitation on the number of SAs or max
> > > throughput or such to limit on VF hogging the entire crypto path?
> >
> > The fairness among VFs is present via the QoS knobs. Hence it doesn't h=
ogg
> the entire crypto path.
>=20
> Why do you want to disable it, then?
Each enabled feature consumes=20
(a) driver level memory resource such as querying ip sec capabilities and m=
ore later,
(b) time in querying those capabilities,=20
(c) device level initialization in supporting this capability

So for light weight devices which doesn't need it we want to keep it disabl=
ed.

>=20
> > > I was expecting such a knob, and then turning it to 0 would
> > > effectively remove the capability (FW can completely hide it or drive=
r
> ignore it).
> > >
> > > > May be. But it is in use at [1] for a long time now.
> > > >
> > > > [1] docker run -p 9090:9090 prom/prometheus
> > >
> > > How is it "in use" if we haven't merged the patch to enable it? :)
> > > What does it monitor? PHYs port does not include east-west traffic,
> > > exposing just the PHYs stats seems like a half measure.
> >
> > Containerized monitors are in use by running in monitor in same net ns =
of
> the PF having full access to the PF.
> > The monitor is interested in physical port counters related to link tra=
nsitions,
> link errors, buffer overruns etc.
>=20
> I don't think we should support this use case. VFs and PFs are not the sa=
me
> thing.
>=20
> > > > Not sure I follow you.
> > > > Netdev of a mlx5 function talks to the driver internal steering
> > > > API in addition to other drivers operating this mlx5 function.
> > >
> > > But there is no such thing as "steering API" in netdev. We can
> > > expose the functionality we do have, if say PTP requires some
> > > steering then enabling PTP implies the required steering is enabled.
> "steering API"
> > > as an entity is meaningless to a netdev user.
> > It is the internal mlx5 implementation of how to do steering, triggered=
 by
> netdev ndo's and other devices callback.
> > There are multiple options on how steering is done.
> > Such as sw_steering or dev managed steering.
> > There is already a control knob to choose sw vs dev steering as devlink
> param on the PF at [1].
> > This [1] device specific param is only limited to PF. For VFs, HV need =
to
> enable/disable this capability on selected VF.
> > API wise nothing drastic is getting added here, it's only on different =
object.
> (instead of device, it is port function).
> >
> > [1]
> > https://www.kernel.org/doc/html/v5.8/networking/device_drivers/mellano
> > x/mlx5.html#devlink-parameters
>=20
> Ah, that thing. IIRC this was added for TC offloads, VFs don't own the es=
witch
> so what rules are they inserting to require "high insertion rate"? My sus=
picion
> is that since it's not TC it'd be mostly for the "DR" feature you have he=
nce my
> comment on it not being netdev.
No it is limited to tc offloads.
A VF netdev inserts flow steering rss rules on nic rx table.
This also uses the same smfs/dmfs when a VF is capable to do so.
