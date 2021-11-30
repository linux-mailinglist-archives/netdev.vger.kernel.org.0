Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565B7464132
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhK3WU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 17:20:58 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:26080
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230215AbhK3WU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 17:20:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebGa4oKTpRb+YlHE0D2CCkAYdqqTjVdbe1Qvr3+xeG6ITYk19R+ZH7O6vc576pIBvmSydYt9fhoDpLvpJjd+f2+Qfon2Vr8z0EYqX85+0BTjFTLW7FDEIPevaF0sBkEGkGP5Uoch5g9Cei1B08ljmxAtilDUPAzaLCgpMIhwqc7SdzK0lIFbEgcvj8ij5UNcVyxyjPQC5E9zWslsASCLf+IhiC27eP0xeQk3NpxCGU54EVHblTW9oI919jw+WoMRMCEZbzP+3Seu69kDAxc73EWNYpjL/3mwkvnKoi0NF9S42CntYAsNOpl72Y48e8gBQuOpFAehltF8QqEAXQMXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5pW6QOvqiIX055Mu01W7/iCyQCI8fd9Vk69AZEhW0Q=;
 b=j0dfbhZj5xqbUg51FmwIYKtI7wzGWLcmQJZvtn47YRj+pm2/O0yIua/U3IyqIKchLwLLkbdCkC0MY/WSNZC+KawiphSbuUQnoeAZZoMvLiiONgcLTuWY0owyjL9okUcrq7ZbBeKRBJ4vYn0ukE0k5D1GeHqZaYutwggg+dd9+/Jvs2tJhCH7gybkZKdccukNZXRy+hFzxS7l4a80WlbLqA9zyWn769X0F2hpZ0W5SZ9yEtcjWirJK2TEHITk9cMfAF8BK1uVevIZEL7KM80G2XvpT68I3k1FPzQppuXabSUvMS1GmtCSmCXD23fVW5MhGKJIy0LzJ2jNDcZEXc/RKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5pW6QOvqiIX055Mu01W7/iCyQCI8fd9Vk69AZEhW0Q=;
 b=S4CWEDPLilu1WKXADZOTvFoXVqZ+RjrHJDClg3OBs+oCl+KdxZ2KfKXt7IGi9Ieyjq6HDWDkrALlnUU41WrpClmPb9vmfdbOsyQDzRiGL8FV6EQz1t6s5G9CkZkofpJjHutbs4MjwHgO31U1TJLigHvxQATNb91md8+8GxmI0AWp0xfxccMaKS38LP6AN5pfbpbTGTC64BjwNUB4fBJYvzDtDffeuLFrAW/0apQBfOJlaPyXpY8JsCo7LzPdkynNW8ZX7VQ3lQjAWTb4VoMG3L+8VVX6M26wULXAkQwWGBOSNWfH5jofl/KSxm4WjGH9x4FeQwXZPXi8ICneqe+6/g==
Received: from SN1PR12MB2574.namprd12.prod.outlook.com (2603:10b6:802:26::32)
 by SN6PR12MB2654.namprd12.prod.outlook.com (2603:10b6:805:73::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 30 Nov
 2021 22:17:29 +0000
Received: from SN1PR12MB2574.namprd12.prod.outlook.com
 ([fe80::9126:2477:530a:bae0]) by SN1PR12MB2574.namprd12.prod.outlook.com
 ([fe80::9126:2477:530a:bae0%3]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 22:17:29 +0000
From:   Sunil Sudhakar Rani <sunrani@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dSCkqeEA8GEywETLk9s8QvqwQUeyAgAxeb9A=
Date:   Tue, 30 Nov 2021 22:17:29 +0000
Message-ID: <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
 <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a45a9b2-1d02-40c2-6da0-08d9b44f32df
x-ms-traffictypediagnostic: SN6PR12MB2654:
x-microsoft-antispam-prvs: <SN6PR12MB2654DE711BBB888408382717D4679@SN6PR12MB2654.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o+B8Lz6Ds8YzhBLKLj0YaoNQyH8uOC8tY4Cvbt8grns3ak85AYzqUZxJglt9ZqATiyJnNs5te+BbmiRJwFXfI0ewZJFaA2DRIUPpL5vQrtDb9S73sXp2RQH4pG+4+V34DHcCX1BELNKGv6GFOfuxtCYTLTBwsWamo1G/WlNNpYGxk75w2jE9nx568Cj+eiZz8K5is4wgf1qdWIZ9nPCXSIeUE0QaD9mmAI+gnxPJjvzcIgPLy/M89CYZqhck9p23xgIF1bbUzkgsSqBTSL7LSk5Rpn6DmynkMYhRUQSaD65DdEOXuPlq6kT2tS9trvCPTz5bx9ndph+pVyrtyPPLOiFT19bPRjiA8crcwjai3PC5UYoeR7MjE67LvPcKhfthNO6L8kFps45/CcQeu3VV2vzd6nSnybS9efGLTI0yqqYg+5XUIuoI4ppDsKhxzE8zMyyu+XLqIop/0hmJcdKuOwtd+udriTS0Xt8Hkn5j0z3DhMpSR7ZsSkylh1jhGIc1oiM9IeGG4CrNJsbT0ADOyUJCwBZJN20Hr5bPKpcTqr62TDX64MCOdq9sO+iA2EtZuwXp6EBwyJnjM2bnbrvFSxfmTn4z7C+iRPOyxkjcTBhnNxsttHM8W/4lTLtaKWpri3OIVLbgGxCVz+RDH55Yv4gJzyjEEmxmWYBsV4mw3hA5s9VAtLr4LkVi/6tJ9cQGb5i6Wi6WgyYfIoNzyL8HNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2574.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(107886003)(4744005)(508600001)(9686003)(38070700005)(54906003)(8676002)(6916009)(66476007)(66446008)(64756008)(4326008)(55016003)(76116006)(66556008)(71200400001)(8936002)(66946007)(38100700002)(122000001)(83380400001)(5660300002)(52536014)(6506007)(186003)(33656002)(2906002)(7696005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nIT4yyNVdDk0iOQDhN+amIZCWQEidyIhLEyCa/ZSsdaz4QaznG/lRLHWcXHN?=
 =?us-ascii?Q?mR6cRKVQsKg+UPvBl+nFPHESZCIZ0i+btKHiXJKvaEE3rtN5NKgEhEOHQtQI?=
 =?us-ascii?Q?0j6ICMaWgOBUdqE+kN/otqRvrPKIz8UaCbimbwZ0AUWM6iNM8rXe5a6boKs+?=
 =?us-ascii?Q?0FMWyDquHV7TnmTrJ+8z/S/KhaAoks4dokvlxJYo55CD9tWWyOSSGnzQOIiE?=
 =?us-ascii?Q?q1YNuTcoElIR2FpBbWypjhqGAPrAgtL+NASZiI2OZoh8/eQUMv5nmaMwrFjq?=
 =?us-ascii?Q?rVPIQLzTr85mVXG/aba/P+Xo07I0OCzMFfrqx0yeKuvvfihh7qHx1vDZsGqX?=
 =?us-ascii?Q?Ipm9KC4e4rhGwoiKN2kcbHnW7WcvBQVtQyJ/yLv+X+k/Ao8fCOT3agor6pij?=
 =?us-ascii?Q?pWR2PHnMy02bQzQe038NmJRbTE6a26X+Ork9y3rTdV2Mely6gTw07lgs3vs0?=
 =?us-ascii?Q?+gvub7+9b7gxckXqKTFbBVvDFDF/Sz/cCYH0F7i1Pg1atXFGrC3MOiL9qLh+?=
 =?us-ascii?Q?K+4IxmJb/aK3vk/ifyjf0L1qjwTKVrn5Aqxge+j05sG/H989PGZ7oR96BDW1?=
 =?us-ascii?Q?MWdtW2dmu+hoSy/P3Hgdo6Bnm9OecerKFaHfH0Jxpd/nd0+DNZyomZdmBhJF?=
 =?us-ascii?Q?L35RNZ8SA5mU5Oq9MtFYOiHd/ZVaznzPAcNSkKpMxkQ/yTZMxmfMylvFCQ9B?=
 =?us-ascii?Q?pi2D6W4mv8SkSEYRuAKw1orfAfjbqT1guG/0vfOU3HwXD77hlZZXPAEoQhRN?=
 =?us-ascii?Q?lIPzv1l0th5jdRHkRHnbWFFY8+AfX8emTFMprTxFsSVRi5sgBkyuCxXe6LnT?=
 =?us-ascii?Q?MC2mdUo8DPa1na3V+LPmftnTXqfgvEpHrign0Z7gdYFDKISIMmJzTLnIog4+?=
 =?us-ascii?Q?MSYNsOPY8hTfO/AvQATVMLe8xZIgwnmttsBLKqale5gGVaIDayHPxWFOZgPk?=
 =?us-ascii?Q?cTVln8OkiAPmB0B0MRcsWXykxqVUg2ar/CxIxrCJwuzmqlEsd3dbXj1mlN9r?=
 =?us-ascii?Q?rVidpCq11IlrSvtMx4Df/tvd70yR2uS/ueCJ52M+gHP2PneG8J0tFDOfQ6Qs?=
 =?us-ascii?Q?yWRajwmhgTfPZjyD6ISEaLaZAwCCe5OB70KtMyfQRxj0coXpOidXAAyA8I6C?=
 =?us-ascii?Q?BI+ctnOfcbAKrrdNWtHL4kJsnaIQ8FSRpemK8iiIRkZ0Es4pPYAkoGHR2PAe?=
 =?us-ascii?Q?qr7K4hDzvHOFtdVfKsqde2YOc5Y7TRVVtWBs05TEu1BNXQukKmzgA7W2nl4Q?=
 =?us-ascii?Q?//ryNAhQxNwOnt+zqJOibLy231+eXADEqQbhmbfKByB1Ww6OlLl88zmGJ8q+?=
 =?us-ascii?Q?WIZMnBwgcrDQcvFiOFHVXjCMzUQpYbTMt4sKyLQv4WykRFapRNoxayrIh7Ks?=
 =?us-ascii?Q?JZbDpT9gzQJx3PqsydDaNkSaKs1qXtkllMlMXqeiHQg53PqN8yu+8JVVJT2r?=
 =?us-ascii?Q?CglhcCOsZdjvYNRcEUzrGcerVzETbzFZ59wio9154v4bPrigf6hHeVVRTwmN?=
 =?us-ascii?Q?qz3lsPYd2BWpDtfThhkJFd5L5bke/1hlqwrCAbTSiYYBevqF1AjDFC30mgJc?=
 =?us-ascii?Q?SJgHwraJECfX7tWlr7oeuNI8ZrBAJJS0vQ2w24ddyN5ppYnBEiTinJZXYaO6?=
 =?us-ascii?Q?mVvyrre5z8TWVPID80XG2LTSgVRhxqAOTqiJDEkfFDDgPnvpUu80mwOvMRqr?=
 =?us-ascii?Q?VcM0sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2574.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a45a9b2-1d02-40c2-6da0-08d9b44f32df
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 22:17:29.7086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JX/incsfpaJhPMflqcyRbRKCXhymyyiyDPyLJKFJTQSt0GdDbrH9kAsVVF2q0grtRVJeHdalg3awIoZODQnLkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2654
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Mon, 22 Nov 2021 16:43:06 +0200 Sunil Rani wrote:
> > The device/firmware decides how to define privileges and access to
> resources.
>=20
> Great API definition. Nack
Hi Jakub,=20

Sorry for the late response. We agree that the current definition is vague.

What we meant is that the enforcement is done by device/FW.
We simply want to allow VF/SF to access privileged or restricted resource s=
uch as physical port counters.
So how about defining the api such that:
This knob allows the VF/SF to access restricted resource such as physical p=
ort counters.
