Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC63E598F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240316AbhHJL76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:59:58 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:47905
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240286AbhHJL75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:59:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLrzmbLJ8RNRC0HwafF+lLdjQg18Hc/tXRvc/tqu673SFODYohNZ6PVqd4WuSJ6ICIts7Vqr9uQuaJ8EyqyLqVds53ipyNOhczC3Zgj2APu0mzPzG3N5KEqI9NvR6Si8ULEqSdXcac168GOO1eTwwI85UOsLndk7iuU87+5ezshu7zDqv93L0dolFdFuz2xcPS6lvx5yjyBSkQZg+D7RkgR3aV7kpWbiBt+4qwOplaiJqQexZ0WrWF2Lx9B/gfuWZ6TckbPHC00ua0AUTiqeGvji/NZ5zZwy007qeAZ+azusgFSaGhFEId0L5NeLd5goS9PUaXGwkZq2yH8sjtSnDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB/lsUZ8w2lqnmWr2jpZDzN8dDGRxXF3j1g5yJgEG5M=;
 b=idrFvdTOW2tQ0dt6Aiwn7E8dvi6mPC6+2m80l8/kvqNFPbOIjyRHXZ2VkRAfxlYoHyCy/BgjtzpxIO9cn0xP/6jXdOlnxJnfI2olTXzL0aQxbMI17k4Gl+EwWR5Z5vwgcULMKT7MCumkifN7XOCWjNAmTcqcMH3AH8fLCFkz2hRfqLHuigHifdoTaXoKG/lSxbgNc89H1yLcztgLkKCows48N7lRnrh523pYYWyFtCPCF27xbN5dyfFy5hhu4NEJMfN/25XiLFuxo8PPPc9ARbKd2l0wvnMgL599DokDhy4lKw4YCQVjkz0MEN5t9GvtzKfZlDjE4TpgLHQBL8362g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB/lsUZ8w2lqnmWr2jpZDzN8dDGRxXF3j1g5yJgEG5M=;
 b=gZ9Rk7sYvJKVJYh2FYmwV6doCxOpZS+o+SQ7KlHBQTC0jojyjVE8ztW8tkgjv5j2Fy5KD+bJhybFFN19buwmJbLCcieeYnDPWyPadqxM+a82kN+atabn8845Xmbiuw//MqGV4HyEUpVvsgh50hLvgauIJ8O8YdFjx1vlqTRtN8hoS4QnxuoYyqzLUEylXquceRTrKD4l/KFl8fHuCNOmPVdlQAFtYdvLj4F2TvriP79EtP78+7hTrllLU+008Dwch8ePDuvDYMMiILsWd0bD8y5+927Fkfz/twsUC+IrvxNYezz0NdXbTp9L8pn1egUG95vtdzy1g/Sh8UsusxJJmg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 11:59:32 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:59:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 00/10] devlink: Control auxiliary devices
Thread-Topic: [PATCH net-next 00/10] devlink: Control auxiliary devices
Thread-Index: AQHXjd1lKznr+ZFtgUSbw3NSbdERH6tsoikA
Date:   Tue, 10 Aug 2021 11:59:32 +0000
Message-ID: <PH0PR12MB54819BFE1033C88504D5B256DCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210810114620.8397-1-parav@nvidia.com>
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d9ff132-5327-4b95-d0e6-08d95bf650db
x-ms-traffictypediagnostic: PH0PR12MB5466:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB54668884C79D8EEBE704D412DCF79@PH0PR12MB5466.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BjPHNJdCGVaFPQsvSM8owACaVGv8KJLGvVkpc264I6NQBOjYqbBkLxRiME6+I0b89ds/Z1F2JLdQKfSDlpZwI/RH82b7aOPCgWAsBzzfBP/uua9fhRfzpmDvFTUsO0gX5NvEoBW3azyGRntRoKPSexvdUva66VktHh7pG5BYXrQNw47D27XOQPXkOOodweiEOAKqHzValzIkQWzZL5NgTamdn5RKfy88tibAMAbUz3v7pwZ8fcy+f2wZfkY1H7198qKbVaPvAHTb7nMCOB6BYdcC1qjqEVRHNpLtp0NWgPSuqJ8tTFctKNS2YRalC+3OZQtTlP1OOGsskAsk6K9uKKPZUzTJG5SUHEwh5hWiAEhn+ivQRoQ6pH75N9Y6X3ZOpa6PH9DrkMlVewdEDD/+LuPu1X24Hq3O6pCyebBPzDGAgQZ49UBzoVau6MiF80tUpk+10YDg2JhpjROf/rIbgTbjde/ifbp/CxXxNh9CfZCxyYL3aEM/CF9JMTs7i6vGYYtsi+y1cJANKPt5j1x8JWK9B/o4wKvIcB3bsadLAg3LrYLGjoNtWh5IA3CFcyarta9bTtyD4Ep8jfC5P3u1jvisnNkvuln5cQ3BzvPTj2+kP6CtrOKnJXrgKMrZh+5QLH8t2BuGybSYqNAk6g6PagcVgd9t9q0cNAyG0+FJ4aolv6Rim9XENbPHaDCTGPGa49reYv/ao7IdycCfg68TVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(66946007)(52536014)(66476007)(64756008)(66446008)(66556008)(26005)(5660300002)(7696005)(2906002)(6506007)(55236004)(9686003)(4744005)(76116006)(33656002)(8676002)(86362001)(478600001)(55016002)(186003)(110136005)(122000001)(38070700005)(316002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vIXBhAVsuhJzhz9O+C/lNd7nQieBW3PMcYpLFWQaVPu6H7OCWs/x+X96ockV?=
 =?us-ascii?Q?PLseAApWG/q9rLI9WNHAgft+gB6QxQM9m3OD3u68bXzgTfv/civzNR+EZaGK?=
 =?us-ascii?Q?Tlo1rkEjUjB6X9WVpttuIX3MBuO4lXom9KX0/iPaD4MiUFthqTEsozX802Lc?=
 =?us-ascii?Q?FeX0PzeloGO6dXx0kynkCc3wjUhL9qOOrsmmajcTGpxMBR4esD+nskUAr42a?=
 =?us-ascii?Q?m2vC205pb7qM2BKaNWwpIsioif8l+OV0MpIkrk7uxutopP7jAeibGxRFDkMW?=
 =?us-ascii?Q?morMnOyLeoRxPUlRxA0ltgf0Z8WEeja3/jXS+JBU8umVE9D1IWxDnH9cNdkS?=
 =?us-ascii?Q?Jz4LBw2jIgZps6hUWZyyKwWkYodbHxaBSPvdjml53l8TqP51appMeIm/unGe?=
 =?us-ascii?Q?vxrVL/93n/Dt6GjRUMjuT9vxlHP2eS4SQkiIyBAQUbf2fkuA5xx5IB1KAyIz?=
 =?us-ascii?Q?5iZQqnWcm1ihbcv+ZzZhxLVI302dTj7NC8/M4hoppAKamGxTtnCJSG0/+fE5?=
 =?us-ascii?Q?edpjFbR8yH3AnJcugtJ294myi1vzrzkoYG0y+Lkeuw1V04eLU1rvbJLDsObR?=
 =?us-ascii?Q?JRkxorgD0YeEl2iZsW7uCJbLd5vHc9125mfIFU/BvlsKbC9RTS4N1KqkYMxX?=
 =?us-ascii?Q?RjT8Hq7+Fmc1IPa9tpgte2h2N1+EKQqZPMJxWnr/2tL5hsGzMmmbz6GhVsMT?=
 =?us-ascii?Q?uwEjTMaCtkshk38EyW7t4L+m/y4hFSqb7q5KBTrwcQJjLpjkV9aCOd6xrn8X?=
 =?us-ascii?Q?VKoVSGziPa/dVQt7EhgyE+1uwo54wVWi2nQKiRLv/rm6ofDp9T0VkuBWPPfZ?=
 =?us-ascii?Q?keDZQC3AqkZ66Srn1ZQhBQpaU+1sZsBlIeEsea/UddD6dicf9MuJ0WkqCmOn?=
 =?us-ascii?Q?55VVCfRdq8Xrd9/wtPQMD5W4BE9NIBrF5e1XUgmQeXj9qkyV41vlBaushcAV?=
 =?us-ascii?Q?nmYMW/yFcURCFDmt6ddI9pQs4BzQgvQx7W6e0reyYzReIQgfuM/hGt9ObJsC?=
 =?us-ascii?Q?w9l7Lv1FHfy0+P5H0AQ6L0KXFfh5JwmpqHz98Og9A1BgfPXsQa7hlsiwEscF?=
 =?us-ascii?Q?4rztOC6OCVKNrzDDf34BVU3SaZH17a2qjoMd5ltWRJr29Lar/2w7a6RlWhWE?=
 =?us-ascii?Q?FwgenM2L5O4mgeH6vzbqCZqL94cKl1/Z2t6jfsWDdl6jNUExMmu47jD9CkDX?=
 =?us-ascii?Q?FNBhuE9ZhyMUHQE0O0YaxwPimDKcgW44lqDWiBSHivDRWXa4FNKZ+XdXbdfI?=
 =?us-ascii?Q?R6pMukunMTC6Labu32kP35CeCaYiz44jub0C5bbc3stK1QQpiTXczk6kjH52?=
 =?us-ascii?Q?smJiPKauT/4pLjKHGpAszCCa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9ff132-5327-4b95-d0e6-08d95bf650db
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 11:59:32.4758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+F7uZnNg+HrD79GhhIjRIFXDKo/Fb15bpCaOVbVLFm84nmrnf8sbq6A0uzlZn/vQUMu99U49xu1xRA3hjN9og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Parav Pandit <parav@nvidia.com>
> Sent: Tuesday, August 10, 2021 5:16 PM


> Hi Dave, Jakub,
>=20
> Currently, for mlx5 multi-function device, a user is not able to control =
which
> functionality to enable/disable. For example, each PCI PF, VF, SF functio=
n by
> default has netdevice, RDMA and vdpa-net devices always enabled.
>=20
> Hence, enable user to control which device functionality to enable/disabl=
e.
>=20
> This is achieved by using existing devlink params [1] to enable/disable e=
th,
> rdma and vdpa net functionality control knob.
>=20
> For example user interested in only vdpa device function: performs,
>=20
> $ devlink dev param set pci/0000:06:00.0 name enable_rdma value false \
>                    cmode driverinit
> $ devlink dev param set pci/0000:06:00.0 name enable_eth value false \
>                    cmode driverinit
> $ devlink dev param set pci/0000:06:00.0 name enable_vnet value true \
>                    cmode driverinit

I missed to CC rdma and virt mailing list.
I am resending the series to CC them.
