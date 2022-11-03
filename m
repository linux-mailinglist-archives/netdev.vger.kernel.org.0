Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F07618614
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiKCRX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKCRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:23:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C061055C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X08cTrl2sp3wFXGxvRcmwqZJ6QyBfnggDbLIYYkMXt0++M66Ze7T3L/kaMYhfHwDxN3CFRUzcAswLzG4ahC8zOjaPLMNzDMVxdiIjhlV6DuaeQMKnGwQKHhkfqGyEcr1PWwyxXXdSRcnC8sjdLUW6v7WY0LsYsPvnik4fnx7E2Sc4f7C1bYEf2OlYyOKX/IKfVlMQtyIPdqz2mddQnwIWz0jlva2L+A/S/Nhh/Bmp+8vUP0y8V5mMFmtV4WL1hVvg1ZVqaDWekAG00BaOhixTyG1Tc3RJ4E/OaWWO62BGj8RSlwz+gqRX2J0WHgyYiRfNkai1Trvn5pcycvnWJsPkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTkLeTFb5je7cep74HpGcb7XSH1gOxNFrugZFt5Qfxc=;
 b=HC5YSZbClpQq0yPwQuDlODTAE2K9nF2DXEjK0rC5UhII8++Q/rSL4Pbdh0cWWLBHng+1OQwCFm42zsbXDMtlU4cjlT3/MYqo8HNeV7pkVRA9KJf5ZUdlfy4gLbkOygQm88yGxtGMXUX5oMxeUWFKojjHcThQ2jxM7Ddf1FAUmMm5IxOa349zJ+OyBRjYSt8g5sCh+g7B6K9tMDGJH6gbnfs0z+xljBr3FQBnOMfVdVaJKsWsQXLQmHR6MrNsSl5QeBAIMqG/ZZncA36ekFQ6raEGZA+yCVwBCMY62pClDzki+jKEN0kgK4peVn9fZkQ+hrUKqFxd5nbnYYv0S9OqzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTkLeTFb5je7cep74HpGcb7XSH1gOxNFrugZFt5Qfxc=;
 b=ESWSU9aEUWZUN+ZaYy6uimEl03L8sFSLFmL+SZdJa6RJ5eiTxV0nL2JH4wyYeTunHAngsp79nMFAhcNIFFZh4lCyjzVeGeC3d00JasMDymyYkFejZR4djjSMXIPMBI8Kgf72GYVI+zKntAxkC2dh4AOuZ89Fy4dQlaVtad01DvTWWxQ5aE9uH701qAoUUD4978h1QGfgM5Arky+cvxseIG2G2lMQYPbxcAVNzdh5WprlvjvbUq0IwQ9dFrSRSprvsSGAAFelpbo5HCGg/ZRsT5Viy5S1Fi5httN1QN8U0SsMQNf5VOsufKRpGI74D+7TBmKNHSGp1a3sGYckOdr6og==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by MN2PR12MB4408.namprd12.prod.outlook.com (2603:10b6:208:26c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Thu, 3 Nov
 2022 17:23:52 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 17:23:52 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHY6HobywKcS3CUh0e9rdSVQmztBq4ftFCAgAENjtCAABwdgIACt6KAgABgg4CABN6FkIAAYL4AgARJumA=
Date:   Thu, 3 Nov 2022 17:23:52 +0000
Message-ID: <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221028084001.447a7c05@kernel.org>
        <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221031164744.43f8e83f@kernel.org>
In-Reply-To: <20221031164744.43f8e83f@kernel.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|MN2PR12MB4408:EE_
x-ms-office365-filtering-correlation-id: 2de33f68-2319-4c02-4177-08dabdc02df3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JMb0slXVmcqaqhamza6NauE+UNPk174sVbaK0DMYfYEmcRr3gHDGt3l4g3b+WyrvjRkkTuA+f1BQS1eIxOlVNNxiM9wTedPav3Ji4Y9Yh2WVWPe9geRy55ylVHemnbv5n2nDmVV6z1bP1fQUS+R7RWOHiitBhF6Pjy18buplcEiSHkw1BOBb16Xg7z2mEwrohyRDmIDm5a8FeBRjf9QURnskf8m+NSjgDMU1JVaBTuDrFTUPDK08w6PCXvJCpRwhPcSHslK2dwM4k+vJPkpXDuJ1aLEuiZWjYRdNxIcMF37/PC9C4MLLhJSwK44O2tJfMm2+Pv7pLwgJI0iEMpxSSKfSCGWCHh+Dgy9eVQc2v6nSGBZO8iI+4VR790qccJoegD/oGa/URmOWL5BHbku+R7auBAUCwSbYhtSWfIGylo2PC3zbltbRvmEXOm5Da6wnv6wYsoar4zU3qjTNnbgAzkuwTT24GxlSWsxMvoTzjN49JAXd4NQTl2GlOLeB9wVgzSq/ZColX+taakFGt/TzRmBfFDdsasPZUKSDPv3o/0cq5OxAoP64OS75mGbi7BrrHI2KtqX7Uvp8JDDFD8xK+u4WDsHU2pYAx/UpcbN/Ekyl3y0PLok4i2LWU+3iyPKwPYI02zXxuG/yOb9zJw8dJIlRM1BPdgTg5cO64PJbxHKKWc2pppCyPh2OUjX9yNB+M4fBUpGjVvSjQ+ag2Jz9eBvgHk6ZM6ISVa07MmyuML3bwVIhp68K1jMjlEySDlhIgZu9WfNQft++5Y+75FWnDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(4326008)(66556008)(76116006)(66946007)(64756008)(41300700001)(66476007)(66446008)(4744005)(5660300002)(8936002)(52536014)(7416002)(8676002)(6506007)(38100700002)(9686003)(478600001)(2906002)(26005)(122000001)(54906003)(6916009)(316002)(7696005)(71200400001)(86362001)(55016003)(38070700005)(33656002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nAFC2OA1bua9q/Bd5MWy7mTsKbEQXPNef6k7ofN9rUe/gRWlvfdyMIFGSM2c?=
 =?us-ascii?Q?E3ockGxbdjcdq5fLZrdT44UzEc7l4h2XOp9FkS0lgVpdNlHtfNjpf6M+KlCD?=
 =?us-ascii?Q?YXO+Qos/AuaL86k0Z/UQLer5HDMmm/QbKKqwlflwEAEXDOZ1fd+Rf6+xqDRG?=
 =?us-ascii?Q?K4iJAMg2MLW0eDJ0zfWP6fmWry9K2Qknes9VDCMhOM7lsK4s2mQQWxQxOoW2?=
 =?us-ascii?Q?3+OK4zQgEV1L8Nzig2U3Dm0JFQH4RCiYT2DPXSctnXtOdsvlesARqmfcaBo0?=
 =?us-ascii?Q?UtfgON/PffVBF/Tljc4QO7wGDZ82A6r8+IYBTB8Nr/FVyQ4rkTJA9WavAngs?=
 =?us-ascii?Q?LFoJ5miNaM3eaL8tXj4mLGdd6xDXt5iazhF1uY0UxQfQfVY6jIj32on6SCbZ?=
 =?us-ascii?Q?fpv4EYVmKY5MirKXeQTdmDGpnLr+XTd2Eu0jBXOEhsCqz64DqzANRXNlqE4Z?=
 =?us-ascii?Q?9MTe1TTNvMKgGqAkhWp3sFvMMzXaHmCSGKJRG9mfvw1KkHLKiCz8Zf/Ajc+3?=
 =?us-ascii?Q?Rz3FbP5z0nOTl7prCV4kbfpIgLn+tgqyz4cOr7+NN9u6WZpi3oFqaqVBSOGT?=
 =?us-ascii?Q?Iok3YZOQdhJc22QnfSDDVyO41qP59aB6EZVUKsn1vb6VHvacF3MqPKL7KVG9?=
 =?us-ascii?Q?6mCiApyGTkoT1WhS9wNYG+p5hxIo1iTPkxd/9/x+93QXDLNnzkx2gZRL50po?=
 =?us-ascii?Q?vuWHoAkxNG3rCAmPMk5fB8ayJfQyicLa0tkbJ2RJKLtyNCrj8edn08QIZ26A?=
 =?us-ascii?Q?i6iewvAmIGZJej4ZEMv/banzfPj673CEexh2FzpVZSD9Mfi0KqP5ZHr8+y7r?=
 =?us-ascii?Q?uIHff17mj5eq8zHbmumvOUMFlACJd42lz1jdsawiUNbSuUGAfYEKpQwaWEXI?=
 =?us-ascii?Q?Igu2r/YPmHzgR9cVHaw6oj1T5r//tP686GjzgS6spMnO6T/4EZ9AoKxHUzbj?=
 =?us-ascii?Q?LDRM+oDu4ScYlhaOMIb3ErzKvhVksGRT1xZ+O8c7TWGERW+tWAj1b3aFtKCH?=
 =?us-ascii?Q?6su+MLdYlhmD/YXSJAdirRFX98J89v3n1r/vHievdKhrcGy0PTxs4NsPxjvs?=
 =?us-ascii?Q?NbfvqbjquWKjUZoMELiH7n1Z7X0rptZjGc7DTa5EuID+mMZHi7hQ9cc9V2D4?=
 =?us-ascii?Q?0Xv+GU+qhz/8bR/BR2iaj4V7z0zR4h9uFBtMursfzie3Drf+pYH/cvqh9yYS?=
 =?us-ascii?Q?qAG2cf9p+YWnLrpwuv4BdrShptJYkX0zATBa60iMwXsppo09Do0XKH3pYepy?=
 =?us-ascii?Q?129ogYUujHivuvg6GggGF+8IPei12WnOcZFSYMqjt531RzBbYOLKYV5+sa/7?=
 =?us-ascii?Q?eipjjU/Y4xZxheroItfRFLzQpkh2yi6VnMW3rTS8A1VqE1WonjFcf3g3Z8rJ?=
 =?us-ascii?Q?r89A3Szy6jDVY2VGF9bFacAPOQnMaZb6jRqnGu8Vd4qCJStfnG3f/se5WhAS?=
 =?us-ascii?Q?OmHOGgbR6fDvUwJnibqFtZxcW1XtFKJxgDnHq/vcZIaoWrwcigT2v1G4Csmf?=
 =?us-ascii?Q?8UZhwREhfAqAIs2zBfsOncq0d6dwBL87eNOaX5q0XEAft2p4Z7rk1pdUU0ZH?=
 =?us-ascii?Q?dKAtAiHUQxAiL7KUPrkFHh2mhoKldP3rm4rowV4I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de33f68-2319-4c02-4177-08dabdc02df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 17:23:52.8321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5rW8CkwIAu1G7U+aHK2Mbe5j4F3HYpQR2NVdNXLOU0PXNZCxHwzltcPoEVZ4cHcNXuOsjdzqui7bjIcwQ28JHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4408
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Nov 2022 at 01:47, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 31 Oct 2022 18:13:19 +0000 Shai Malin wrote:
> > > Then there are stats.
> >
> > In the patch "net/mlx5e: NVMEoTCP, statistics" we introduced
> > rx_nvmeotcp_* stats.
> > We believe it should be collected by the device driver and not
> > by the ULP layer.
>=20
> I'm not sure I agree, but that's not the key point.
> The key point is that we want the stats to come via a protocol specific
> interface, and not have to be fished out of the ethtool -S goop. You
> can still collect them in the driver, if we have any ULP-level stats at
> any point we can add them to the same interface.

Understood.
We will suggest a new design for the stats, together with the=20
capabilities enablement.

