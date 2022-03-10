Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA94D4537
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiCJLAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiCJLAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:00:37 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1D813AA11;
        Thu, 10 Mar 2022 02:59:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl1tJGgGODt1fC+Vkic+6rHvUQa7dtMJI80AmR1IXUWXgxzLcJvAYX3BigQxvWsTMsRJ4sSGSXPLkKuQjdaqys8j5xyLlKYtKIaCJN2GwB7w9Zpq4tt3f2vKBd/IZReEhWFTCTvgLMof6/WgBs5NEeTv0a+R4wGDGhroilzZ+INeHx+nlW6timGMnlqvx4sqR/Zy3JRKPtw9jQYBloysFwqIJSOiRfu8GDtiaPgczMCZKZx1KSuuqYfo1znt02x5JsQhwpWCKUvYFCC1iJJscMH+YD6xqxnZJb7SGPJhMlXaBzzM+/h0o5g2ebs+UCedrSsuLuw0imA17TG7Z5+BLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeBGEz9//XCVk/yOAr3QpB4M4WmTxxFM++6Gr9qsL4M=;
 b=ioDaxgzedX+FseN3EmLWVaFtBIeAZ4Qgxnj0mcsE6v5b4nzGVEDg/xRFLxzhHu8p6mxtvV/A7ku0vOk6HtP+p29iuDhwAihoOcMwF0/i01tGVgGDba488Tz6+igiyPTtUm2aYWWd4U8c29t083auJyKXyN4U0FfCq8lGaGQkbATqx3qQGQ72xIdE6nIp/XbvSrd8iCCmnda+4timBpqxYZF1KUihN+U3gIzdcf8MFp+u/rQcoRtD4WRRGzTgNWxYK36SRw/OEuaUihNehueuP205kVW9jFLszEH6V4OnNupoTesiYXBVmhfHK/10pAw4/9w6Fo2zYtKl21pVf0J/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeBGEz9//XCVk/yOAr3QpB4M4WmTxxFM++6Gr9qsL4M=;
 b=WqR2FUMFYDoFNpTpNWRjgRkz71/BhyhiMNj6q4AibSbyY1nPRHfgWRPSkJB8yImrN6o0Zv0FCmjsYuL/68i0OMds/MWtOub0NtnNbSF5qyHo2Ca9Kdc9rYvQzHF/s8GHoashho5db5jLh8d6fOHyKtROwFSwcA4fF0LbSA4BbbpXHPB96qdGUiuXQgkThjAba7B8KOBFHgO0TqEyqHROjWpy7WoApJJLmjE/ZjtGI9Hw90I/e6AHSUwuOJSIBNZDm0UBJo0k+9NK4DCoTtno1L4u7wdixU/oBIO0eVsLiUbNp+1XDtIzIr6bnsbi4RBdcWSaiX6xkjmeGWhqCmesew==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:13c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Thu, 10 Mar
 2022 10:59:33 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 10:59:33 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>, "mst@redhat.com" <mst@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: RE: [PATCH] vhost: allow batching hint without size
Thread-Topic: [PATCH] vhost: allow batching hint without size
Thread-Index: AQHYNFPH5bsK1il8h0WZSXsQ/7flA6y4cyJw
Date:   Thu, 10 Mar 2022 10:59:33 +0000
Message-ID: <DM8PR12MB5400C4168D42B9B2AB804358AB0B9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220310075211.4801-1-jasowang@redhat.com>
In-Reply-To: <20220310075211.4801-1-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66b9329a-08f2-4141-8d7c-08da02850f64
x-ms-traffictypediagnostic: PH7PR12MB5688:EE_
x-microsoft-antispam-prvs: <PH7PR12MB5688BA74137E6150B95F5EEFAB0B9@PH7PR12MB5688.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O7Lh0bMxFWSY9v2SuSG95h8owhjPijIBSg9XO47fAvDVFTFZd9rUjEbeJVeu3WZRw1ZuasA+hCY1+kUSNFht67PoDvZHA2TBgiDvKMsiKFn3bVevNf6yFuo9XNspDfYLg5iRuaABYZRqDVIOoHWeOwUFmWXV80fDEqNkikrOoiSa9ZLbK51vdn4dyOukC8o/EvjhvTv+X3Bfxfkinq0S/uKSYFr3HGwLv6QikypI2EtbPdBKiaV9pyGRrbHAMfOrdFJq1X7MtHRqytFaRptcDaSHrlUnrAJ9xsAN4LcTmNJdpPYt74q8DmvpAYQgiULTQ+AcMzDiQZnTpkt0nQTFFj42L920oWi6qn/g4BogHBMPzqQW6h8QlrOZL7AL3LunV8KGytiqft3xobtw76ivSDPBAlCt76QkrVmYJQXLA0E2nArOLwAushPJvXIF30RotFbSm78Cw7s/br0BRTA/rwQkYFFipRg6vPdbyXKIv3T+5nQ/UlwUaairu/sKzVyphPVlIUH1yIBqu/A2Bt4mewrQYmbGKwnSrjnYCmhv/YVLaHEB6qcxZEEa3PEiNpEt25Lzp+ENBI57FVapAFkisqb7CiBXvIkMQCSPdmbwRiYcrNTJYvSlMo/MtFraWIlaSa8fl2nSlM0AOqyd1qGlqTesrlFqHz35kS/h8NqES6JxmCMyJsO1qgTxZmsINZ3NUhfY2f1gbyucvATpkkb4aA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(55016003)(83380400001)(2906002)(33656002)(316002)(38070700005)(4326008)(71200400001)(7696005)(9686003)(54906003)(8936002)(38100700002)(5660300002)(26005)(186003)(52536014)(86362001)(66446008)(64756008)(66476007)(66556008)(66946007)(53546011)(122000001)(8676002)(76116006)(110136005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FLeZqi80Ep4aWj2umkx24P3lZRL5imFC79FAKjj+dN8jwwhPbJRP5qFZ4oJ9?=
 =?us-ascii?Q?suwli6tKEt57yeOS1CuNxYkmU0oP9veeFeUOoXmIidFFEK/32xP8FURdz94U?=
 =?us-ascii?Q?bjyGdCinUh7zk5QB8LBGMl1nDkS6lW2gUwHqv6DLWWRsNp7d8Rjr1nlK0F4c?=
 =?us-ascii?Q?DRIYxt/oa+pnfNWzFJejMzR7XpE6x6gWsn9VvZHu46o9Uc5eQZD3a3oOWtrx?=
 =?us-ascii?Q?ZlXkAitBcH2Ip+LGT80BSSLMug4q06QF28fTSjzpVHv2FmbS3omVx2531fjY?=
 =?us-ascii?Q?1cfrb8MztgDY3163rUMC1JSz6IQu+SPrtpEYrS5+SJqHuxES04oca9P4bFXL?=
 =?us-ascii?Q?yzbJzJ0ofYVNf2pEKBoIjc/DeRNZgaZirecGnf4NwOvgN8cP3a5XlXaC7KT3?=
 =?us-ascii?Q?S/coqc55atmmoGcIWxCsLpqfD3A2Qv2xSaVOLHTfVcmjmWZlLMbR3a5SXrgi?=
 =?us-ascii?Q?AVb7wuEpUgOjyvR22t3bc8pTrDWcka+wgCyuxN0/3mEuGiJC3UWGnpL3sYrc?=
 =?us-ascii?Q?pjJw9rCr92PJhVWHwNN75EuPPcxoeZmo28vMsOQekyscbweF/NeK3w0NOLep?=
 =?us-ascii?Q?epfmDR/Dz3tIoDi/LI27+fJfqB8Xq0gTg7PCqhQU0ZtdO27W6XV1zGQ28XOP?=
 =?us-ascii?Q?TNtdlBtP1QZCWu89T/0YfCkLSjJNikuykSzD9DH63IcHqtqnum7nHwbIPjwr?=
 =?us-ascii?Q?+0Rw7GDf0beWWr4+sWGDXuGvQeAFeikaKjo0C/p95relQ5CWZIy3dn4T20L2?=
 =?us-ascii?Q?6nw7n3uK10Hn2nGXc+FFNerWGBf+JIeFuelTOwonkLJdiyWbFplx/E5R/r2w?=
 =?us-ascii?Q?lM4jMaESORMXvZdDXfyNtlnACAqXKt56QO+tHqsraMUs9rU7oE43wB+gLle2?=
 =?us-ascii?Q?7M5ARIb1tybnQMEaWDv8vn/d3ac+Iyt9CEOiw+cNiUjo4MCwp3w3SDaw6z/7?=
 =?us-ascii?Q?LXJpVdqtTvx7BAbc+TUiV/iNCxJsiT06b+qz+tAk0ziQwA4T3XtUldbyT2b4?=
 =?us-ascii?Q?PxnJzSwRXGCCuOET05P+GIJ42p/d4wERuuJlAZ71yV89sgpDcOn+6ilxqZ6R?=
 =?us-ascii?Q?bPKo+hod1By05MwJ63YAAVMAHs2KMXX5NSRnX+2oT/eUea0XeUeSXqSOO6rf?=
 =?us-ascii?Q?mQCy1IYOA/LxRjoiZqdtOiFHX4lPanvEhJYiEWC/mpsp5qnKMfwc2xsZMBWm?=
 =?us-ascii?Q?uvCQv1IOOKJBWf7Cm+HStsJkIEGu/aHEPdtVNn/PzasQiERliXMmW9+FJPrb?=
 =?us-ascii?Q?Y7n4U2tItH/lLQ6Z1JGyAUlq+jOmEbPM7uvxGYcIRrOwk/prF/ZmiAzEdvpb?=
 =?us-ascii?Q?TwE66EaOnYsv/3X1h7uk1xNf+iupkccz4VMUn1VTG6RKpa1uLWlahkfC4oRR?=
 =?us-ascii?Q?LRYCenDVUMzJHI1HqSSv+fTW0KfxajJm9qzXushLHRGIS6RSXCHindpwCz0Z?=
 =?us-ascii?Q?6wCAxPOUQ9mmmTljOoWGay396NTpcLQ04YpnY/emQuGDWOmJDoaqB3CPth1A?=
 =?us-ascii?Q?T2NUdOfx53ISc6EW/8Czkfd80KypBPMwOKlv1K+jjS2SqxLXklrN0UvlpQ?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b9329a-08f2-4141-8d7c-08da02850f64
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 10:59:33.7875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iapFDWAiDO7InpLglT56xpy4I99KpG4OOz/MBZkWp1qclL/iPIutzUvnTfp+5r2z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Eli Cohen <elic@nvidia.com>

> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Thursday, March 10, 2022 9:52 AM
> To: mst@redhat.com
> Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org; netde=
v@vger.kernel.org; linux-kernel@vger.kernel.org; Jason Wang
> <jasowang@redhat.com>; Eli Cohen <elic@nvidia.com>; Anirudh Rayabharam <m=
ail@anirudhrb.com>
> Subject: [PATCH] vhost: allow batching hint without size
>=20
> Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
> entries") tries to reject the IOTLB message whose size is zero. But
> the size is not necessarily meaningful, one example is the batching
> hint, so the commit breaks that.
>=20
> Fixing this be reject zero size message only if the message is used to
> update/invalidate the IOTLB.
>=20
> Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entri=
es")
> Reported-by: Eli Cohen <elic@nvidia.com>
> Cc: Anirudh Rayabharam <mail@anirudhrb.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 082380c03a3e..1768362115c6 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1170,7 +1170,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  		goto done;
>  	}
>=20
> -	if (msg.size =3D=3D 0) {
> +	if ((msg.type =3D=3D VHOST_IOTLB_UPDATE ||
> +	     msg.type =3D=3D VHOST_IOTLB_INVALIDATE) &&
> +	     msg.size =3D=3D 0) {
>  		ret =3D -EINVAL;
>  		goto done;
>  	}
> --
> 2.18.1

