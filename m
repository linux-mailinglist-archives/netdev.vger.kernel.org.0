Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B72132C447
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388822AbhCDAMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:16 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16971 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352980AbhCCLzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 06:55:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f4e490001>; Wed, 03 Mar 2021 00:52:25 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 08:52:23 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 08:52:21 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 3 Mar 2021 08:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvqxJukbVFQkjVIIwwlMMtsU7H2SsmO9vAYXdvozYiwiStPwu81QQv8M/5hwRjYe9tg2DCZx9WK36okz7C0ZDoWwCADF8lxPvVG465k2hKyLYaai2AlWMTkchSuw47WF5mWWQ5NFWBb7UUGPtfsB8/L16gS/AmAkhp38F6pI97TQCV/Zm/cnfvEnvoteV69fJsy5v1eTMNegq80e5CVCU7vKjA8yreOSJYfgShKQKCejr35ci8e2/UGVo0z2LydEGwsufk6j/Q6/CUc6AtoCi4BqrUdOpWuF84JbY8C9T9p1RW5DPilSyrw+c3JH0nunsCMMiZQQY1t2QCDNxF3nNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JV4+AXTULQaLV9f154tNx+tIA8HDSTl9RZy7LB6k9qM=;
 b=fsnI1hC6HCNvMXHTv72hBhyiWvRApHfHIl4LPqFiLs/pvhGxUwTnGhDPdKPWbj6eCmkGm6u3K57QvBztF9aWjDvjjjRIq68Ym3Cqc2CFCVNKNAs8Rfk81C9pE9OBO8f+Jd9hJR5p9RQvhKBRFf5VKUXL/gbl+sC+YCL4qx1F2ObtH3/aiQHrlgMdiZd0ZrxnwimElXOo+DVwQmoWoie9dO7RVU9wXQDmSCLPGel+MkJPYmM8OnfQGUm+QISanx04uwCzfZbbsksXOWGfmhY+B0HMwhQXlI3bQLRA6mCSL19oJqTSHjFPAZiuHdr+auv8qx7g5xlFsHnvcWrdP9Bvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20)
 by DM5PR1201MB0042.namprd12.prod.outlook.com (2603:10b6:4:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 3 Mar
 2021 08:52:19 +0000
Received: from DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::f432:454e:1731:2a1d]) by DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::f432:454e:1731:2a1d%5]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 08:52:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/mlx5: remove unneeded semicolon
Thread-Topic: [PATCH] net/mlx5: remove unneeded semicolon
Thread-Index: AQHXCQFdZeK6pe8bzk+WL+Rwiz5bb6pj8VNAgA4RhGA=
Date:   Wed, 3 Mar 2021 08:52:19 +0000
Message-ID: <DM6PR12MB433097A211B6A99DAF690958DC989@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <1613987819-43161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <BY5PR12MB4322C25D61EC6E4549370917DC819@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322C25D61EC6E4549370917DC819@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59a28812-92fc-4712-93a5-08d8de21a779
x-ms-traffictypediagnostic: DM5PR1201MB0042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB0042CB46C849C08D4C0030B6DC989@DM5PR1201MB0042.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sL9zwhiuUBdV6/Xco2oqxGM+Q/LLaBal7iZL0wWWbjsqal/DPfQFjbDG0+IzcNXmBWm4eRLDtKzL6bpeYAPmxEK/bfXpjL7DW9WQ9W8dKvFPJX6++U2Ggxp1SemZKQEpBsT/KIZduGpvwxDNWVsTYetGGom9hKrtziy59ethyu1uN9H7+wpLQ92KYVXO9Q9A9HkjzM8aMcoHDVUn0x3aguZOCI2L6Tt40yDkBtxUY9T+0Pw0EgsMptGA1jUOsncIRgyOY/MrlO/j/I03Orr/L58I9ovhlBh7ePMyK2x4Qcns82iII1YEBtJ8UbWl6ApTElrcIoQ4VSvvDLHKnbegXrvr1vPCTKEBNxpVoMaO3vY+zY9PEYKyRIhoR6sSLEvDLBE6Fd84Gu7JGAPOq+SAXZDtHf80AX4WMAKJf6cY5P7/zWpwtk4NawR03CmPkKiyYvBYzefpUgvT68HAB9Lv6QvPKVyU/EBj7JXilveiWIcC7CLOwxniXvQfEBox7ztrUnW52/YD5d2e1Z5N7lXwXierrP+Ig6HpT3G3tIZxu2eyFULDI+gPwNVtk/F4OYV3gvrhaWdUKq+MgcSsa0oB5aqsHokUUPFNL36fY/2/TA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(55016002)(66476007)(52536014)(6636002)(83380400001)(33656002)(64756008)(4326008)(66946007)(6506007)(66556008)(76116006)(7696005)(71200400001)(966005)(54906003)(110136005)(8676002)(316002)(2906002)(8936002)(66446008)(478600001)(5660300002)(186003)(86362001)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eviRKICMceeOFzOQaCs2S2wdSSkYQVP5woZyaQekQ286ChLIUSfFb+NEQ00l?=
 =?us-ascii?Q?ipGHD+KDiAZGt/0pVPF4PBBFW1EbEhuQNAiOPW25AhkUusBGQ11Hl1KStXZv?=
 =?us-ascii?Q?aXjV9g9wpH2wgvLcT+gJ7LOm4ok+38mytHauEaCoVMizHWMbr+1AMs6i16ZD?=
 =?us-ascii?Q?1z6GYM3+ps4jtBryNU4BYicdq9lELLWLgUG7meC+sl75G95uaIN5pVBd2Opn?=
 =?us-ascii?Q?6T0O5qMkBmnFNwMUXSesnp+Y+i84QvZ77ZEtebU9STLNQuq3G2bkEtuM5kbR?=
 =?us-ascii?Q?v4M5lljBaovfuPJ1PKGamgYlQp62+CUs0nQ17TlZezlWmpFhwTiDvUQydrxr?=
 =?us-ascii?Q?Rw+8psAtWzrQ8ivpl/DYZ8o3VmNMy1HILLd8NRPf17y6bkPsMDUk9111zvv2?=
 =?us-ascii?Q?UpBe8bWkm+0QNvK+k5bOCL33n94LsjCc3TJqyCmwj+Z9K1iUd/4geb6N5Is2?=
 =?us-ascii?Q?2cONy07MfVbKTtQn6z4boOwSWn5ozZZPNIEkKgFkVplquM0I+D6tiHcEQZdS?=
 =?us-ascii?Q?3UZVxgK4tBr6dlmV68VMW7dEZePMGMEcANMBjIb3kyLJ51JsRp8QG7+sWZuy?=
 =?us-ascii?Q?NMseTZGsmlfrgWygX/sWetDhdP8/Qc9Q1pfgYts+6I1Q2g557VH/XXT0VmC1?=
 =?us-ascii?Q?ke0Rj3eCftNZw8/+Zh7JgzES6yXQzpeVXVlW4kEJEGNZgviS79b3IBELZIAk?=
 =?us-ascii?Q?ZsQf8jJSvKwDGldV85DoJ5005CK7XkMh9wIznsnwcJP7ZXJkxTv7NbarvXY2?=
 =?us-ascii?Q?ED1drQaLJ9yYYXnvCQkooGGz7hMVJl42ZqFVTBbsA4j1SMvsqLyaBMhN8fgO?=
 =?us-ascii?Q?0voEp4Cw4uf8q66iY/iauwBU2Wc5mod2lPyjRNrIjEnu5WNp6xSEOgewdelL?=
 =?us-ascii?Q?YL9ysuXGec2khbTN+h31jfJnb8PBFxzMJ60hDkhDK9J3JN/D4nq1gtjOKCKT?=
 =?us-ascii?Q?SXXpADD1ZUuZOtJXdR39960vZmgZZUv9HCeGHW2aaRRQraw3pJzOGuvaaiHl?=
 =?us-ascii?Q?V/AAkdyknUjaiRjvZJt8XCqJpRkK8UffEQ9spPLeJdFNd/hfIWm3Fvay9Fl6?=
 =?us-ascii?Q?arC4N0Zhf4mQNpeLc74SyhMcS765tSze6lvYCEfyhBGeLBOg5TDUP6JzjpW0?=
 =?us-ascii?Q?9AufO95IObdiih7iMGqne9c7pFzoD8q59Cn38MyryP0YiUWCuTiHU2hwXlU3?=
 =?us-ascii?Q?eZQlif+6iTni/PqxjWeiXkQc5+vPzw9r0Y8GdafE6io4mSr+qcrSGUUDJu24?=
 =?us-ascii?Q?GdW5k7GS+sfeBfrH0GNZzN2Ra7smK/3f8KQtviW72wbCUhwAzNc99I98Gmw3?=
 =?us-ascii?Q?ZMGE/GfeiWcgG5hiONtr5+6X?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a28812-92fc-4712-93a5-08d8de21a779
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 08:52:19.6660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vwyUPJmsl9sB9HlgDuKFzNAIuJj/7Vs9OROrKv8SGYd77MqbGz9Q6y9xqKdZDTZJf7GZNcgSgb5RffePqmCgeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0042
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614761545; bh=JV4+AXTULQaLV9f154tNx+tIA8HDSTl9RZy7LB6k9qM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
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
        b=k7qrFrDkG36B5uYNamq8QxKnNCgEqZgiE5ytmSB+mt+JBWGcRcgbIf3g0txJXnHQR
         EBtfWraP0Do05z/WI7Mb6Jcx6MHfdxfIFN1MKRIbxD8zOo6uZIUEu4087Igf3J6K7M
         SeKeLVkiTDyJTEdW95XhoJNbmvjYVYx3Sy9PialA4Y/mUhFJ0xAOahXQETveC821fL
         FNIj3g6Fsmd4YOvzk8thaEcSYgvyPPpgxM41cjIXHxMCd9R049LsfqWOVPV79tA9mv
         QNak/BWaVg8zSaGpDsl8X5MI5V1JJx2+E/GqkOh9WSup6qH8uj9btn6gEPusGn5Fx2
         sB74XusqdrSPg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Monday, February 22, 2021 3:32 PM
>=20
>=20
> > From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > Sent: Monday, February 22, 2021 3:27 PM
> >
> > Fix the following coccicheck warnings:
> >
> > ./drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c:495:2-3:
> > Unneeded semicolon.
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > index c2ba41b..60a6328 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > @@ -492,7 +492,7 @@ static int mlx5_sf_esw_event(struct notifier_block
> > *nb, unsigned long event, voi
> >  		break;
> >  	default:
> >  		break;
> > -	};
> > +	}
> >
> >  	return 0;
> >  }
> > --
> > 1.8.3.1
>=20
> Reviewed-by: Parav Pandit <parav@nvidia.com>

Will you take this patch [1] to your queue?

[1] https://lore.kernel.org/linux-rdma/1613987819-43161-1-git-send-email-ji=
apeng.chong@linux.alibaba.com/
