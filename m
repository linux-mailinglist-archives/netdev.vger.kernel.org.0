Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F0C4AE8C0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiBIFGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377689AbiBIEcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:32:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28546C0612C3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 20:21:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EltcyhPNOLv24xawhrFxSCOgHk6i58rFUb/cDtQ8Iot/NMw98HFlHiQhAsGkfcQYVwIpDrvGn1sdbcluOW/G2ov/c4F5GcG0o//6V/k3gvxmOqR0dgLXDqPXcsDetAPQc92fLOxJwRBgWZ8EFsW7uklLo+RsOxG63lKNdmYS5bP3P9wSPb73RRaGZQ3vMq1bPNGRolEyHM71+CLDAn0ac9MdK7eIf2t3FCKwE2+2ypyksBbpT18mLvfOK6uyWzrHt7hUwe86Y3CkWm/VWxyS3vJ3Y7gIPMclMUqnm1Fp0dM6UvXDAN7LxYi8qMc6oPcTwj8bxT6IKG7er33+adyUKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gs3CKUP4GE/hQeAemgWCK6UsPJdEWymGUhMyNnvxemc=;
 b=PmYENQq8X9gYEMpO8B2R4G/UZyNaeNQPM+jxwNJrqB6ghOELPeaR03d8bMUAH6tg5FByECLytAGTMht5g11lX3NcAl/gJyNL3702EVa2JgLSaoYC2slXf06N2N8B5vrCMHbL5bkm0sN0856dq/gENXLOGviF0YuSspN4QcJG/mXoKDLa70LiyGLe1IUz7i9BqLQ9wBHFr8E5KsiHwnMIR1pCqxWK/wcU+cO7oLPLVL02p24k06/lCjGF3mxm3Mq/4iemQLUitDFCJya3EH08DxbT546rq0l0RV11HnpzHo03LeXKmTID7H8AnP20mEH3ByNjTXhaDRMY1Zu7FOZhTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gs3CKUP4GE/hQeAemgWCK6UsPJdEWymGUhMyNnvxemc=;
 b=gOUuN3GiIDju96bsxgCLmYHRBGNzhgLCbx3d/RI2Se5llF4gnB0/GHHjE41wuAKkGh2pTAzMYB3FEzNz9UdWI48NXhh6AJQfDMvNpekfUbiGaaZcZZI0Mjoadx4nZr43rQ8UTPE7i490Y1ASylYw76C+nTWkKSH1mRqT+jdLlhf0LaPJ8GAT30rj1LUkpU2yPTR8bXfYyww3gFy3Vw3pBpMB4x49EnX+ODXdQ2R1HCy9XDTymIdf7ZDCqIGIwBUP4LOoAe1c9eYXFYu47VXZOT7W4q7UwwTO7ezoUmUpI82Tkq9AhtEr/6U+VbPU8wpOWfXgoLvfrEG9yVLXW/YLrQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB3038.namprd12.prod.outlook.com (2603:10b6:208:cb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 04:21:14 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 04:21:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPAgAE+YoCAFykAAIAAD3gAgAX9ApCAAnZGkA==
Date:   Wed, 9 Feb 2022 04:21:14 +0000
Message-ID: <PH0PR12MB54818E260064412F2390A2B2DC2E9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
 <PH0PR12MB5481901FE559D9911BCE9548DC289@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220203191644.focn4z5nmcjba4ri@sx1>
 <PH0PR12MB5481385A3F7D9A3BFC91B1BCDC2C9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481385A3F7D9A3BFC91B1BCDC2C9@PH0PR12MB5481.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c42ac0d5-a5db-4912-a424-08d9eb839c81
x-ms-traffictypediagnostic: MN2PR12MB3038:EE_
x-microsoft-antispam-prvs: <MN2PR12MB303868E835FBE8EE1582D3C1DC2E9@MN2PR12MB3038.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4RcKZjFjkGOJG0UyETuueJOFIgkAd06ZtawVodlhEsZNFrsEK9TOAklibI1tmP6Oa/28mTwKQmLUB71XhrCFSPomq94cYA6Is/IvSuGzbZE76b4yHE9Th0WMMNPTxjZQ9T12WkCZSRNck8EDBEM8h0ZhY5wgVtPIblQtOxnaAv27yZ8LdW0F2aQRQDDX1IxJreL585Tk0SRqFmPtJ06Q1wlBc1N/LJy9EEXtsFxQxp95KUSuCien5cwXNz3BVTFxnK9Si+xcafvHv/EZ5se7BOGNtADjJrrcZvN1FsP76FpmsvyL+8eGa1nlr2MMKicxAwgv85WMiojffBoFwSV0k/SbeJNQOFrpw6WNQhPItXSpfuZKeVnW9Qpkm5KMp/BM4KCtsOv1cNJtg2ITp9kNT66f4enOcrXx3Bqej3Ma7g/s5gGZ0t91oy1tSVosanSvHzOpsAYg49E6lBpqRuzNqqvThwJOIYAiLhJJdWwl1IHQU1mbcld0H/Gw+VhcaqxVakxYk49PkeQKgDY87onmbJ+zPvPAoBF/uoa1yB0gjPbA7YXEEOc+QDgn/V0FqQPz1oDrjH+KJ7bJzAIMmhG9ZuuzttcV6A57sNSmQLiEKQEnTvNwe+CaJ1Ox7Yaw41Mn6CuEhTNFN9ZwfawqgFdKIgpOpIjofNTSwj5EmYR11VcaWb0c3FwiI6/JSSvJSF6nYR2/p3c6A4wmD89dF/ZW1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(9686003)(66446008)(26005)(107886003)(52536014)(64756008)(55236004)(83380400001)(8936002)(7696005)(6506007)(55016003)(66476007)(316002)(110136005)(38070700005)(2906002)(54906003)(122000001)(33656002)(71200400001)(508600001)(86362001)(66946007)(5660300002)(76116006)(38100700002)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y6EOExDRW7hR58AV6DN7dTWCBXtlJUNKR4vheJsRr6C8TAlT/+Qi8lFgx+io?=
 =?us-ascii?Q?PHqAqraO23X3E/SxTGDxPkbUNbq+nALA+G/0/G+Hw0F0ESrAjeHhurKT2z4I?=
 =?us-ascii?Q?lh9vTVUIl86Q1qLIG7YHPa3NY8nd+piYOHFez8R9YXBPhOKReOdSjshMuKgZ?=
 =?us-ascii?Q?rN+Z4K5BmqRxq2ms1L5rdd5ACRqBY89Ntr3/oLoNH86u7FB4yUHQPQ+Agsxb?=
 =?us-ascii?Q?DKCVUTt4QnYMmIb2jhk76X5b/GONZsQ7cfQbqsGirU159A/zQj1ZRXXwkY/E?=
 =?us-ascii?Q?gt+1Ft6C0zkmrH9vbdzyEXVK9tj+XutpvyrH+YafMlMMoPP5QWhU/NOOVZy6?=
 =?us-ascii?Q?cPwV05Fw3/W0QolQVgK3xxmDQrbQvZ2DdY59fYJbRPC9pb0x8DGLrpqYYd+o?=
 =?us-ascii?Q?7ws2ay2tkXTSZQ88h395nZqo2w2lbWduTB00W8x4z+rxVLBNKLo8xecVsgGJ?=
 =?us-ascii?Q?RC4nWpkZVx9ECdIhllUt5d3SiHy+bwbDUBx+g6KcxJqNGZGclDUk5SN1HoGV?=
 =?us-ascii?Q?nWBAx02o2SkZGGCtDrwtym0Vsit1dLS7PRKALqnVwspxOyy71dCQ+PxvWe6O?=
 =?us-ascii?Q?6A0w9rwFpW+sSlEvgNpwrsIbkuTdot9RNdkZtcxdQObgnEyfdDrXduIsxpCO?=
 =?us-ascii?Q?xvP19UuL+haN72FzyvbDjhUJH9X9Buc6eR1sLYrOf1ICPLZWapYi9YvR+wR4?=
 =?us-ascii?Q?vfusYA60b+NNQzkkfMLNWtW4d2+49iFQKoC14vpkbGjkSKDJDPvQWbY0DXvb?=
 =?us-ascii?Q?as2lUIMFPCn4JONcbJYG+W5lUb6mZ/GVSX+9Qp4qsE9TkWme6LYNVDu+kUK/?=
 =?us-ascii?Q?LfQHc4kept1WnIgw2oOhrF2IgT5mez72Y8Wggxh6cxmE9iUwrGpevUolZhLE?=
 =?us-ascii?Q?zT1MOTOzYCZF4PVK8dPWHOz+JRW4rcfpATPYn9npwqIQmRj+dv93MGGI1Clb?=
 =?us-ascii?Q?aILuRGJR1se4tUcFK4Y3lCnE+bjLYJxAOcnCoSJ5i78f/K6MxFhrC99m0A4y?=
 =?us-ascii?Q?6miLPRTwccq/crdaXvC0Hq3nTHEmA8gLm0iT2xQLx9dPmdNTNbiuAqxNnLqP?=
 =?us-ascii?Q?GwmuZJWMIrIqkZ7ice2YIIuwCXeSBbam5K2NK2i3o6pgkZLkK94x8J8HKms8?=
 =?us-ascii?Q?7136pipQH7vSgUZ32bgjFS0DOj0TU+1hK96Gnx6BNG1qud+Sl/FK3gCrHnqt?=
 =?us-ascii?Q?9M399hdUcZ7fsUbE/2d9F39nNrUZUl7sItCYqoG1LHy/60ws7j+SkRXXTDxD?=
 =?us-ascii?Q?bRf/C9u5/8YS1EXRMtrkFV4nqlFkP/cFJp1qYbyV6euV9Tf0LQCaII+02nOI?=
 =?us-ascii?Q?LknlR7cqyDtYVRstCAKnCEpz1xZs3LVZB0acvNFTT2hDxna8cKRztuYdaH0k?=
 =?us-ascii?Q?AH35YvmCi59dBenkevLqrcBXSwDWiQEEWAeHqJ6Ze8oNzYGnPw39WJK7hhMq?=
 =?us-ascii?Q?hTqAW6Pgp0TWkU6H/ypDjHRvsgTF3pwtpYu5DmJPH0PcVxU53gsXKyHiVY+q?=
 =?us-ascii?Q?KoY1mX4PgwfeW+a+lNyvkBYp1SgR8aTRqVGriDpraKcp4rJdQ3fjfcOmnIlt?=
 =?us-ascii?Q?i1wSZU311FO5ys116axMsPLkwZsC0X41FtdombDCNXYpYujXBX4wkXFL2Our?=
 =?us-ascii?Q?XwdSuRJVxE9BycxTIdFuhJk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42ac0d5-a5db-4912-a424-08d9eb839c81
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 04:21:14.7683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWUlZ7bgs13UcbSE/iH7ASffo6vntKR6VQ5ocROFoH3PM2xe0/IN+V3IEs/k/yPtSQJ0uzGi0pzktz8fhD1fNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Parav Pandit
> Sent: Monday, February 7, 2022 8:15 PM
>=20
> > From: Saeed Mahameed <saeedm@nvidia.com>
> > Sent: Friday, February 4, 2022 12:47 AM
> >
> > On 03 Feb 18:35, Parav Pandit wrote:
> > >Hi Jakub, Saeed,
> > >
> > >> From: Saeed Mahameed <saeedm@nvidia.com>
> > >> Sent: Thursday, January 20, 2022 6:11 AM
> > >
> > >> >And _right_ amount of X bytes specific for sw_steering was not very
> clear.
> > >> >Hence the on/off resource knob looked more doable and abtract.
> > >> >
> > >> >I do agree you and Saeed that instead of port function param, port
> > >> >function
> > >> resource is more suitable here even though its bool.
> > >> >
> > >>
> > >> I believe flexibility can be achieved with some FW message? Parav
> > >> can you investigate ? To be clear here the knob must be specific to
> > >> sw_steering exposed as memory resource.
> > >>
> > >I investigated this further with hw and fw teams.
> > >The memory resource allocator doesn't understand the resource type
> > >for page
> > allocation.
> > >And even if somehow it is extended, when the pages are freed, they
> > >are
> > returned to the common pool cache instead of returning immediately to
> > the driver. We will miss the efficiency gained with the caching and
> > reusing these pages for other functions and for other resource types to=
o.
> > >This cache efficiency is far more important for speed of resource allo=
cation.
> > >
> > >And additionally, it is after all boolean feature to enable/disable a
> > functionality.
> > >So I suggest, how about we do something like below?
> > >It is similar to ethtool -k option, but applicable at the HV PF side
> > >to
> > enable/disable a feature for the functions.
> > >
> > >$ devlink port function feature set ptp/ipsec/tlsoffload on/off $
> > >devlink port function feature set device_specific_feature1 on/off
> > >
> > >$ devlink port show
> > >pci/0000:06:00.0/1: type eth netdev eth0 flavour pcivf pfnum 0 vfnum
> > >0
> > >  function:
> > >    hw_addr 00:00:00:00:00:00
> > >    feature:
> > >      tlsoffload <on/off>
> > >      ipsec <on/off>
> > >      ptp <on/off>
> > >      device_specific_feature1 <on/off>
> > >
> >
> > Given the HW limitation of differentiating between memory allocated
> > for different resources, and after a second though about the fact that
> > most of ConnectX resources are mapped to ICM memory which is managed
> > by FW, although it would've been very useful to manager resources this
> > way, such architecture is very specific to ConnectX and might not
> > suite other vendors, so explicit API as the above sounds like a better
> > compromise, but I would put
> > device_specific_feature(s) into a separate category/list
> >
> > basically you are looking for:
> >
> > 1) ethtool -k equivalent for devlink
> > 2) ethtool --show-priv-flags equivalent for devlink
> >
> > I think that's reasonable.
> >
>=20
> Right. I was thinking to put under single "feature" bucket like above.
> Shall we proceed with this UAPI?
>=20

Can you please review above interface? We would like to enable users.
