Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3101A6366B5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbiKWRLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiKWRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:11:50 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FB7C63
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0xPa30vtxAlyMy51w1MHgvbDha7XQdBn/fg8F92hbEOtxXNhvvfqhkhRtbr61dPRh57hKrLz1ONt8IGICo/Y8bi8FxcKNXl6fC6wkgFLpN9QqyTidUsdbxAvv0guDuYLqj6lYFs26f+rOZoELcnNlU74KXl0YAaPbBNMJQI9TLatX85MNT9Q/qBCxbVPqD/twziOBv7KKiXWgPzvAXZx6rN31bOsnvykbyrVqSFzlKKKZoy9iBF967uRJ3v9dG8b3Y4WKel0q4HrB1Aewo5QyNfc8VLbtBkm7pyCAK1WSO+QdTc3wg3lP6f3ppCE7lGH51woNeIYwal5/ZPeg4nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PGGtYADA8VKVvqbLu9W9FdcFxtVntNHuVk7M8YgO08=;
 b=JLNT29dx0cHlLyiWG7K7gWAxh/5MmyQIWjOBcVwge6V1CpVru3TromWzDTZJTY40reBFSqRhdBQPARJOc3Y7VdD4rRBcj8R1aTwb/R7NfMAsBJgn9hlmMV23nHQgtawGg4W64lTctGhxggiPbfhbkgvsjpM5NzqUdBFfxgse9HzAyD6HwwF724km/uas7NzcdCRwmV/zYoXBmv9DzP6I3fIn6Qq9wRrawfosi5zqMfd6HNzVmR7TvJ5dF3ROM9EzLlbZgpVPrml8XXaOQsMSgFHycKsgWuRYPboGRFOg135q/uFzuldTw8wQXQykU/jNKtxoyX9q65SYvq9tCtidOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PGGtYADA8VKVvqbLu9W9FdcFxtVntNHuVk7M8YgO08=;
 b=VIwxZ4LZ1q0QBxsIpDhyVPobVSbg8DK03XoYVVripOulbhTueeKh9HB+s1H7yCuYtSpnxVLugY/ZBYYFG25gZhsA+zlc2icY8EwUs3amLg1UXblKuByX5hBtQf56bI3w0o/r2BLmoCU7rDmjCNYT88dsvLSvVQAITFRG3pnE6vQjwnZpdEt8C+EM56zW54BcDtlfcyJ+YinXssOc5F4AjFDlmfVH0Au17cEpW0FcIBI9TU+bODmmaW+R+YqMILZ9o1gzLliO3eOKEUoDuG+lRXXBQXxSbcp4jOEGMuOwYd93+uev7i5Uhj9bKUcxJBaYxSqiEim3Mr25WfLKUyEh3g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 17:11:46 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0%5]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 17:11:46 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: RE: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver
 probe phase
Thread-Topic: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver
 probe phase
Thread-Index: AQHY/hoarLn6+L5AG0ugeVCTd05akK5Mm6QAgAAiW5A=
Date:   Wed, 23 Nov 2022 17:11:46 +0000
Message-ID: <PH0PR12MB5481CCCC9A6F7649EBEAF538DC0C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-4-saeed@kernel.org> <Y3404H9uBoVqCQgb@boxer>
In-Reply-To: <Y3404H9uBoVqCQgb@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SN7PR12MB6931:EE_
x-ms-office365-filtering-correlation-id: 8ed8a241-ac87-4134-b79d-08dacd75cd07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4GIWqum3ZksjUSk2SzuvDfQ+vinhBEWVcEi9kefRlrAq9TuZyivN/JAEJDp24hJD+PsOTfUBzqPwF5/UER+/Jj5NBevcFrgUt2BEdgUp+45TePeoPNy5cOW0smMSUKYDa1SPzep8TcQZD+a/ouJckonT09NHaQZGrKlVw94rTE8y0be97hL20qJmkXhwJ/K390azmXfaL9UB2jojFloNfDxFOF3TBH7oGZDOeaLTiDOKBPePStmw8Q8G7iT/+9kketjO4ATj/OdG5Wq4sRbgBqNKsn24W6tnMUXSLYwY56rc/CRNHRem/w/6g95saoYYY7bYNpv5Be2wL3TpWy9JCWjhN+De6hrLL4T4GUHNfkT5BF4BBosyzuyU0XH0WsqGCPol0qVOFBMckghZt1h6iFWTLLvSuV+chGoE9nc5gKzSo9ijqYIlZ01En+NE4KCkx4Xb4iV5BkCo9aT5vvnuugXH4prumPQCcouQfftg4HnOaG0QWWf2u080BnrPMjX7nCZAF+XVdYQFfGg066ZNY80s9DMYpaB7KbAqgcugRPSL5dG9JdJ6T8yae+tq87XfYXYbhPSZaq0mIYlIzlzLVHPqE0MdDztQBbrzbMU5Xq7/uqjhkO7SgnTA9kyCnZ4MA4xvNfmJk6ftj/QFJT4hUn97jtbB8bO3WCYomyj9p1+o6QikKpJ0ir3DVOMV/yq6SwXEcbozARaXvXtdlgp9c89xSAL5elUnHwDlLuykJMuAAATLAkrt+5qmkILDLG/ybErSlfIDbuqeqeInqi6bIF5svnkLm3wcs/0XfPrFNyw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(2906002)(8936002)(5660300002)(316002)(55016003)(54906003)(66476007)(41300700001)(478600001)(66446008)(966005)(66946007)(66556008)(33656002)(76116006)(64756008)(8676002)(52536014)(186003)(83380400001)(6506007)(7696005)(9686003)(71200400001)(26005)(4326008)(86362001)(110136005)(38100700002)(107886003)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8jFXLkzfe3N5pQ0OhEmG7xQDVG3aw5VMOd7a38GHvTYxGccA1ymW2m0nNq4l?=
 =?us-ascii?Q?hkJH4t+eKYTgvemUV/QW1LBcB370EnQa0o3ZYZH7H92NT1ayfV47mRy7FY1p?=
 =?us-ascii?Q?D9kfGyj8IwyS2eWVGnkQ6gVNOqceEskk2SD2fJoXF17Sd/Frqe8eRkmS9tG1?=
 =?us-ascii?Q?iADXGxFFrr7/RjWR2GVcmlX98MaazxjNFd5NxPdDjo0NDq+x2Ipx+mXtrkk8?=
 =?us-ascii?Q?tqxOmD2nMqhZ5VM94UUnGhnJH8pMr4sYLdc1FO9JKFIHwf7GtdhCx7LY1JEt?=
 =?us-ascii?Q?vKDj8qRanZD8xMF4rf9dSxy8k0MGnGKextQPbp9xe2TXc8uEfuDbjgj4oaUE?=
 =?us-ascii?Q?i/LUQ+JlgnFqwGijMSm8lNLSUu2GReeloKX4SFz9VaIadv/IzDiHksDdPEeQ?=
 =?us-ascii?Q?LjGX5Nlx9J4fm1kvKYgR7DWJY74AhKg/fZ+e1Rcp+G72K8rADJrzue91gjvA?=
 =?us-ascii?Q?sgN1k0jiUEgDOwALF8T8dsmUOLV7WMbgRzJ8KD/O62I1Zix1Zsghzp7gU/oC?=
 =?us-ascii?Q?lpeG5xWchFYGtuZivKzxj8jwhf6knf/+RunWPRBZrJ1pBQcZIbuBeXMBVcNO?=
 =?us-ascii?Q?EDqrk1OlIIiGWq1eAYwv+kqpwKHfRCuPmt/Qv1hmybC6Q404yC0xqk2b0Kxd?=
 =?us-ascii?Q?lFL2Zb1iVO1Oq7qOo0ePQxeC1kRDz+XUIm8PTEqEIMMjfWs/61BYuFM/Mqec?=
 =?us-ascii?Q?UNKSktN+FSQUcf+xVKC39LDa82WwK90MIiLoWw6Bwj+h8ScJzPm8CM0EZOo+?=
 =?us-ascii?Q?q8x96EOmlC5zCaTJyCCaW8LX7iYkxPBunsTnoAlS2fHBupdak1pYCRmEsJuI?=
 =?us-ascii?Q?5ZAtH1c+szu90pw8rZwGdZKYBZskkxxvT1X6Mr39anF62XTdyB0WaQJVXY7y?=
 =?us-ascii?Q?W81y2uGTsG5ctv8jSBJ6u2XMNU6KtHZrpSVPImeEAt6SPGq+daDEFXKX9Rb1?=
 =?us-ascii?Q?GXSx/dbJyZ4o/3Ku0HMDcyDTvjKhWxKZcbJ8uxQL0KEVPhsA3qU+3R7kW4jo?=
 =?us-ascii?Q?syRjvrm26F/0oOc5XPxEYuylRScPbk2kUHbcRxtXEhe+W/p+9+PGF5q/ChSQ?=
 =?us-ascii?Q?9O4379i6Vqn+iJMMTEsqiVoSxgTmzD67p712tZ2gSmnpj7QTpMcbJf2tu+Ev?=
 =?us-ascii?Q?/GJkNC4YDZk8t26J3xrqXYrRbAmaQEvZXNXx555GBR+PeENZ/qWkTvvG82W6?=
 =?us-ascii?Q?oRMuuwpGC4H3lSxJSkutoy6+34ziFJyLyTTcrpJyWRxLevHaPiBhajstiip1?=
 =?us-ascii?Q?1wNqBgeccm0U+lZLJFZ7/2oqSdxHGfWFfJ9QT33tD1sxmJL6icNlCQg6Xk6O?=
 =?us-ascii?Q?pG54UMf2qsU4dpoKv/fEsSs+ugA2zHSVF+w2SIed8GdzRV7KrpajvXgx9r4i?=
 =?us-ascii?Q?YhSHsoMUpMUjizFCMBmTBvW41P6kBJ1KnHfl/esKiBwHwdHt+oV7XWfu5AKr?=
 =?us-ascii?Q?bINNPG4m3E4fZE0Odl+JThH/lEKIbPu1BstImyVQYFFUVyR7TQskpOBcEFoI?=
 =?us-ascii?Q?r1VBF10iD1zAYPA78xfSlOEnyKzneFJwwOLIMpeGG7ekLB8dtS84Ess9VHX2?=
 =?us-ascii?Q?w0KAazTEXk4GoOcS/M0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed8a241-ac87-4134-b79d-08dacd75cd07
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 17:11:46.0424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /SyeY6ScZo/r0tVzdfBJ0xYoloKfJmYY7jqiAk0EHlsXLFYPrzZZFuqDPVzWraS9E09uQOpE8Ie1Y/9BTrjSSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Wednesday, November 23, 2022 9:58 AM
>=20
> On Mon, Nov 21, 2022 at 06:25:48PM -0800, Saeed Mahameed wrote:
> > From: Shay Drory <shayd@nvidia.com>
> >
> > When SF devices and SF port representors are located on different
> > functions, unloading and reloading of SF parent driver doesn't
> > recreate the existing SF present in the device.
> > Fix it by querying SFs and probe active SFs during driver probe phase.
>=20
> Maybe shed some light on how it's actually being done? Have a few words
> that you're adding a workqueue dedicated for that etc. There is also a ne=
w
> mutex, I was always expecting that such mechanisms get a bit of
> explanation/justification why there is a need for its introduction.

Linux kernel has a clear coding guideline is to not explain 'how' of the co=
de.
It is described in section 8 of [1].
It largely expands to commit log too as code following [1].
So, commit log and comment skipped the 'how' part. :)

You likely meant to ask why workqueue is used and not 'how'.
Having in the code comment is more useful than the commit log here.
So, Shay already explained this in the code function mlx5_sf_dev_queue_acti=
ve_work() where wq is created.

Regarding mutex, there is well defined mandatory checkpatch.pl requirement =
to explain what does this mutex protect.
This is also covered in the code comment.

[1] https://www.kernel.org/doc/html/v4.10/process/coding-style.html

>=20
> Not sure if including some example reproducer in here is mandatory or not
> (and therefore splat, if any). General feeling is that commit message cou=
ld be
> beefed up.
>=20
> >
> > Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
> > Signed-off-by: Shay Drory <shayd@nvidia.com>
> > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> >  .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 88
> > +++++++++++++++++++
> >  1 file changed, 88 insertions(+)
> >
