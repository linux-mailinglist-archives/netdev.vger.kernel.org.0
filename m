Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2CF49469B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358540AbiATEwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:52:31 -0500
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:5440
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233627AbiATEw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 23:52:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+sbQnS0PZJnAHyi0UCACNCXnH4R9yOkOPG2aEcXNLxwsbQQvOJ8wJ9l405VKrRiEzds246tTFHx59MN98fLkpJgdk95pcJAAYoe52Jqp4UHiIGgwbIsrR0h3x9f2zAYYp4IZu5cXbnzy5vuRo+jbddC82XGBaGvd32AIq7DCf7SpdkqycNqE0rvQN6s8CtsEyuQnkKJwPiuJ7ksIFWH9iUOJezydLniYUK1x8wxmANOB6Pj8fo0dbUjYsL9bsbb7wDPNlYrwolKx5XGVF3Vd5FUBPoMhVoN/M7xlcMcza0hob1cZ/JhLEweUoQRXJ5bIo4ddGqbW/B3aptSsVPyyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NiO8RscJdjLeonQI+yBDlI7If/kuvrC46svtxhrJhM=;
 b=h0yOdAIx0CJ7WHpIc+rpDANo68XsBLP0HZezVnOVnZvN6ndPusZjsTaUARN3X/tVMuqmGrLB8rYu71wqQrS4IrwfTMuBoyorHqaicN7Yh2j1IPwjMk9P+BarXYUNFwcIPD3cXdqRDx2gox2PZrCN7LZEY3OvmUETPWBkWM9aS+Npp1DiNy5AcZh8eEAWcRGjmQi7Fw4IsorPAf83xiV46g/1iHkSnaEoAi9jnIZrcjKCLCYLWTDRmYXZp+IO1rOvXyk66f4906moMdv0tggx5zZuk9V4iLaxVW1QDu5YX1kKPxiZAw8Fy7oazapI94kA/Z3bLI+kOzgmbCPhUIXfJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NiO8RscJdjLeonQI+yBDlI7If/kuvrC46svtxhrJhM=;
 b=MYXws1PnuAJ2n3HjdbKpzU9uy2/4BJPVDlfS6Hk589sFHFb4v/uUDRIlelZT8EFw028dA4V1f76qJ6WdU1jrPssxLgOlehWS79J6SeZTfb9sZA33OAdGnSAKaTZTWT1iOcWbSL0fl+2C+zPVabzxzpaf7q/yfgJM1o95mFRR5d+ITu9b+Oa6lhUtFD4nuCwN7H+Pa1klkwZvSWXX4Q2wEvqZl97/d/fK74N4x0zYoePMtkcdaYnQ1jsc62ottq7FituAmGB5WqUr/0MgF6EVzBBc6y5d6117IsocO9lnDNCzuyWwVPn1HFHeSc3B9FykhBpAvWZXCXqir6SgtiDb4Q==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN6PR1201MB0147.namprd12.prod.outlook.com (2603:10b6:405:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 04:52:24 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 04:52:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPAgAE+YoCAAENcIA==
Date:   Thu, 20 Jan 2022 04:52:24 +0000
Message-ID: <PH0PR12MB5481F2B2B98BF7F76220F03DDC5A9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
In-Reply-To: <20220120004039.qriwo4vrvizz7qry@sx1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96d9ee52-a971-4a8b-a3bc-08d9dbd0a6e3
x-ms-traffictypediagnostic: BN6PR1201MB0147:EE_
x-microsoft-antispam-prvs: <BN6PR1201MB0147E42BFA07F53E9C09B973DC5A9@BN6PR1201MB0147.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odbBo5tIls2WbVnl0C0ueoSTyUBqmLTcDfGRXryd+YeGKH8OkA70WRNJJb/CI4gCd7DRETh+XxgZPRzbn5kTW2RcY0ozBVcHJ4eRBTzxG1BUqhstGJpB01O4usn86ThKWsNywBclLII3jMxKJzldZ7Mp88JCeWM4Oeewt5fQtd7vbzkqfKo1cV3Fht0juQXFGTQzHT9aRhQD2Ko0Me+1MgCeSl75B3CHuyTCPcZiJGyWjSx328+JP3WilEIWX77W3s1FeAKJ8zRBtjU3+Ke09ZYxwvoLWHM6CWzuunxHeGGIWZCO8hdJv4ogrAEgLWpCjISGv9QVuF0fA7QJDVnLYyBjwkpW0XImdGiKzhO3z+LAYjovwlu1BoN4Kx0T4PF0lghbAXO3d1NpaDsIhpdDOe8TE3u3Jp2/HrbIVR2t7CFG6GdJvykNx/+01quoMYiv+c6JZRrRctfYf+Y3UhX7Zf4wlOrU3wccAkArESPQLawvOvhPex4VECSp150epV6Gm++ZbbITOzO8CsP1p0OhYeapDk0xXnYYf12BaU8J9HBSi+QHGSd3CtZFwr0QJMiEbNFGEDyme6ooW31j8+F8JEeYnEO8+7tbqEVtqsIS9vmxMHOVnrcDWZ/nos6K/2kwcGYtTMEAm3vGN92JxRmBWo6xm0KhUp5RZL4Jx6r+penllS/cJ6SRypyfGhNTBDEAVmn3+Jt/1LtHRznbtVUc1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(7696005)(4326008)(38070700005)(122000001)(6862004)(54906003)(52536014)(6636002)(55016003)(316002)(2906002)(9686003)(8936002)(8676002)(33656002)(86362001)(83380400001)(71200400001)(107886003)(508600001)(4744005)(6506007)(26005)(5660300002)(66946007)(186003)(76116006)(66476007)(64756008)(66446008)(66556008)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q9HO1hXkkNMWlAFl+k+mSz/OU7/4m41UAZDMU6/GjikpiuJo9ii4+oVX2Uph?=
 =?us-ascii?Q?dSEDgwUco0yCG/7kCKSlUm1j5Li32A/1ddqwnLPuYXEGjk5POJ3miq/PjV4F?=
 =?us-ascii?Q?gwUbPi4fzqVnZIhJt333uBhLlo4LVrZwDadXHDzyfi3I8pcTb878dnNC9vlE?=
 =?us-ascii?Q?ac3MfjAScFU9cWO/aAhM2JT2yhR7+QSzVNhte/0KmfuUHnFY/IfmnV14a5Si?=
 =?us-ascii?Q?x5Pv2gyZ/AOUJGFVYIH5hSiPVu3x21kIl6dy2R0brZ4T9skwqTfEFAAclU+B?=
 =?us-ascii?Q?YGZ694smPKv5+W1g1FdqVRb3YRidgl0gp2/vEDQua3snB0cLsElqio6xekbx?=
 =?us-ascii?Q?3a4BldjKflRN/pQVCUG6AVbUw/TgbHBiwzJIcE3yxXMh53WUhqP5LdtBEiXV?=
 =?us-ascii?Q?UKwhhCAeBLCi1fuTGtHV0O7W+LVedbvzHqOqhMSBK0OwZIr8KkaY3CLgFnTJ?=
 =?us-ascii?Q?XBmQg6fxHtuXOwI/x/De+FkSNTAt28DoNxobNgJr1Cel8z2bFvPwQypem99T?=
 =?us-ascii?Q?iLXoadpPWdDPCiaV/sHfXmkvRNbW3TXyUy1Kqq31PXJV+lPgx60VJEtQitjW?=
 =?us-ascii?Q?1DqedK4z5zC4eYc3uQUPMscyfUQqXwaTvDkc19JFRx7MUxpfO2NZRYmnX9bN?=
 =?us-ascii?Q?F+HJ26OC+9yUEAC3wVwWnOYgTgEmaDDwnphxFSoGvc7OsoWPIeXt3n4ckfhk?=
 =?us-ascii?Q?lQFQi3fiYNnrHzcjPJ2AIgB8P1a/wHK7aa0kR1OKJs+f1+na1Oh8exERxOmV?=
 =?us-ascii?Q?7qkGNcOaCMzFzAH573tjHmlIyaUxqa1NZm2+y+u3Q21z/hY4e47JiGXE2I2o?=
 =?us-ascii?Q?pSPE1K76Iu0dplBq0l2uA4mM+n+Tga5OpnHz2gjwC8YxNFOlqE7PXAcokkl5?=
 =?us-ascii?Q?ku4QH7/o6j2bEN8++0r+r8qTtI7RhiyTb8VhZNNdrz5GhoS3qvFp3A+xLGup?=
 =?us-ascii?Q?kUrAAPavpLNxlQSf5xGHJ1UMgBiry8DJi+eMjWI6bQKjHJNDCa6DJ3bbXjBj?=
 =?us-ascii?Q?1iYwg6Q1MY34iBK75grL5eI4sVGBIsFs++MS3KR3INboBHQsDlPnL2zveRbB?=
 =?us-ascii?Q?W+lP5JliCIKubXHLdN+yMre2Z0N5n0F5ZqOxzuaCrXsXzYZFk4e0HRNEQu0B?=
 =?us-ascii?Q?up3E1PRmN+H62Peq8nOOlUriAo6ofzIJNlfWcHF4GQSdKdruXwqDK1bmf+Hk?=
 =?us-ascii?Q?KXApWBsyyQyk3Efw/Fl9CRwnINTzBoao+kxaNw6sw4zNWN/QmL6d/5rWrnrx?=
 =?us-ascii?Q?s4OHEGc7YhGupQetF2oxVfCeYQO7NUd5hyRwivBmMXitENk29eIOlZXgOjS7?=
 =?us-ascii?Q?rEmso3QXYJI5/bFfeAbGmQPuxlr3g2RB8cXrkJC6NRVJQ9mRphp7l/qmdQLo?=
 =?us-ascii?Q?QXxzkSAZYRKFpZAWCKKHxrQ6wnFEhjGMfKDJu7k7k01Rpr1t46NRXHdBcoVF?=
 =?us-ascii?Q?cwvk8/SuNqVLpcxBHC1NrUq82D5HmdBMuAkoX3z7bm1J9uk0z/qn5py7Fbuf?=
 =?us-ascii?Q?2aMVBqgagg/RvrPFf8V9IBOU2esdBrgSwjQXlmXLM2fUdWfFzPalIEzG+M25?=
 =?us-ascii?Q?RqX1mV5HpzSxqtlM9BiBXdXiR0NoP/y734wzQSslQrrE6QN3ZAvo0B+8rMXp?=
 =?us-ascii?Q?e+nurBB6Z5zkaDwOUgo/DUk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d9ee52-a971-4a8b-a3bc-08d9dbd0a6e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 04:52:24.8159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fts9gZJaQQKbTjCUV+xety2AsJkMfFtF5SX7zinPq6PPXjNbXIAA5XI2Jj04+S40k93C7gVdkwJEKgvPGmPw0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Saeed Mahameed <saeedm@nvidia.com>
> Sent: Thursday, January 20, 2022 6:11 AM

[..]
> >
> >I do agree you and Saeed that instead of port function param, port funct=
ion
> resource is more suitable here even though its bool.
> >
>=20
> I believe flexibility can be achieved with some FW message? Parav can you
> investigate ? To be clear here the knob must be specific to sw_steering
> exposed as memory resource.
>
Sure.
I currently think of user interface something like below,
I will get back with more plumbing of netlink and enum/string.

# to enable
devlink port function resource set pci/0000:03:00.0/port_index device_memor=
y/sw_steering 1

# to disable=20
devlink port function resource set pci/0000:03:00.0/port_index device_memor=
y/sw_steering 0 (current default)

Thanks Jakub, Saeed for the inputs and direction.
