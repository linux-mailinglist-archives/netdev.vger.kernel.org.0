Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53A29A32D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394100AbfHVWnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:43:04 -0400
Received: from mail-eopbgr730126.outbound.protection.outlook.com ([40.107.73.126]:29465
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389463AbfHVWnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:43:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsXJoDBeWi61ubWN+nSuS2upZhJW4v6Y9VHJ+9ZMHTnN58gj0sTZXkCYGezZhrDHGpEbXvIz+/IEyffIteFIao5vn4kgR+d7Bsz7app+fkS0T1qe20v6PHA4VgnO6Z7C6Rxt19RUi8tAw+boz8YzIKRWAbTXJXDU+cUa35N8bKhx5Tv0tIeXQsEe9Q8HCol/WUDrASHwgqyqaIukG7gwLY9jaxJmvGi/LkJAGNNQEvrpyTYfiuimVasOWsQY4DtHS+8JRMS7BqjNpymHK91ZUB43RkDptSAKKNFpU24yfxjV4L5eXwQfmO4RNab3GmyODv/sbbO8WJ+YdhBsOlwUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ft0D9/v+yLmqvRFe3i7kR82MWKErTpKeN7v1iRTmY4=;
 b=kQ+AiyuRQq/PbwnIL5aOj1318T1O/flDIkce4JNxYBlqOPb4TDSNYVNMf7A9k6+E726eMpKk0xpEAVqOt24mPlSozOwaP5rH3AfP8rX0JaUZAVCcXmLX5GKv6eQXvUU2sh7wPm2WCzqSJGvHLIXoROopuAcO9ojqxBB0P46JHHSLVXoYA4Zdy4oBbBZXUaLBeSr/9loFyLz3DYaHKTs4b2lsRtnLpAIp7lgVALBk6NU5a8b0X5laHjtPiHv9zUF1o2Z5fyDaEvxqDG/kFZP/sWKp6mEdHiqyP2MeVgClZxjcxD9otKa9A7zltMGWgv2JOQRjA8O2h/lkaJ48mN+ddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ft0D9/v+yLmqvRFe3i7kR82MWKErTpKeN7v1iRTmY4=;
 b=byzWav2R/94s+dZsoEVvkXAEFgtKnrmbA6BvJtnje1qFqrC6XXkwBnl/Vi9txkfelityV3hFoWJ8sn3UzG3uZCAgZzmK5DZK1WdHuOci+w7a+UJ6k93zWe9crjevZtiNuaH7rRq2Eee7bZAYrqM+BSUdEOna4Hmw6iOVv58PAYM=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.13; Thu, 22 Aug 2019 22:43:00 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Thu, 22 Aug 2019
 22:43:00 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Topic: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWTieJNg4lNlPokigzqQxpEz7DacHwLuAgAAAK6CAAAF/AIAAAF1g
Date:   Thu, 22 Aug 2019 22:43:00 +0000
Message-ID: <DM6PR21MB133778F0890449A5D58DD9D5CAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
        <20190822.153315.1245817410062415025.davem@davemloft.net>
        <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
 <20190822.153912.2269276523787180347.davem@davemloft.net>
In-Reply-To: <20190822.153912.2269276523787180347.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-22T22:42:59.1653077Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=46f059b5-9da1-454b-99a6-7c2f601f0635;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [12.235.16.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 844e052d-4485-4212-7106-08d7275215ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1338D03B0E1E7F6F6037741ACAA50@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(189003)(199004)(13464003)(446003)(76116006)(229853002)(71190400001)(186003)(305945005)(7736002)(26005)(53936002)(6506007)(74316002)(54906003)(11346002)(102836004)(110136005)(66066001)(14444005)(22452003)(316002)(2501003)(10090500001)(6246003)(66476007)(76176011)(8676002)(99286004)(2906002)(9686003)(53546011)(476003)(86362001)(25786009)(5660300002)(4744005)(14454004)(4326008)(81166006)(6116002)(3846002)(66946007)(52536014)(66446008)(66556008)(33656002)(10290500003)(81156014)(7416002)(7696005)(256004)(6436002)(486006)(478600001)(8936002)(55016002)(64756008)(8990500004)(71200400001)(42413003)(32563001)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nxSXT+IgdcBK18knABFj66hXY+9VdqOBS8A4Emp8CyQeffwwo3N6JsbmLZBcpGOfF8UnU3sfWXS2LGTXcvQvLGtk6obUUchVJY9RsyiNPVK8e4RMT9ku80ISudEL7/COt0lwkWpx75tENNwDVUHokS4QP4OcoTpKiNJeKtQvhL1ccvqYiO+Liz/ydulwvWU6D1ejwL1aOQSvR2vXNLQVZwd3m77KNJv/TvSI/ov3o3ja5Rz0BOW+uLdK/Kkp/HNkSkNZRJ/j0ZO7FkTc8jyzUgYlAZgtrfqtqKfa869w++9Br5Kb5BmzbAW1sHM+zrC1bwxYn/aHsQ98/Cn9Bw93KbtWDYXaw4VBKygcqlqeb3RoCnY2EqJn0MfqgzoIbM/yrGSXr8dxV0DhlUvhz91MwOACoJkJBBKMwaNihEG9X8Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844e052d-4485-4212-7106-08d7275215ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:43:00.2971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iBDIZdVy4ELBu9jwYCZWfDW1O4D4aizRyAgcEV1fwzzoSytsqfxy0TsvnsJOcUQ41KIJ+GRyFKRGMrOAg42jiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, August 22, 2019 3:39 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; saeedm@mellanox.com; leon@kernel.org;
> eranbe@mellanox.com; lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-pci@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e
> HV VHCA stats
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Thu, 22 Aug 2019 22:37:13 +0000
>=20
> > The v5 is pretty much the same as v4, except Eran had a fix to patch #3=
 in
> response to
> > Leon Romanovsky <leon@kernel.org>.
>=20
> Well you now have to send me a patch relative to v4 in order to fix that.
>=20
> When I say "applied", the series is in my tree and is therefore permanent=
.
> It is therefore never appropriate to then post a new version of the serie=
s.

Thanks.

Eran, could you submit another patch for the fix to patch #3?=20

- Haiyang

