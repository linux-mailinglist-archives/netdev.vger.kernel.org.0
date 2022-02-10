Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9614B130A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiBJQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:38:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244451AbiBJQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:38:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47EBE9F;
        Thu, 10 Feb 2022 08:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c03Zp4kkZaZZVw/d9zONGGSZGVOhkk1mGLFbiqW4WVb7lVIpU+MrOHxQf6uS20aYX6hIgn/PzML4c6ksOOoAyXmMzGbZyKAmInbEgHvwsyfJOXYzLsHnm+ULfROj3Axmd1OyrNyINqyKj/jnqr8Nb0Dnc2Bx9g1lmzGa2LiGFHM8+5nXqjZVrzq9ZVOndWZn5G81Vh90DTdLSDxMEvXOqq+Lo+9Mb6Jo1V+gd35bq+K0ulIRFRsDaD2YcQVcTZYGLWp4oGft/OiqsZQkGzAo75twqFUL1ZKEVp54pXiDMBXWFZn8VFHbMlEIDMr4MMH35fh7USkPSd7VB6dKkAPOWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTmdPTUiB1q+xKxC1Ot9E9P9xBzVBglbvNw3YMgs8Tg=;
 b=eIHehQ4qsA4p9CskuTUdP/yAsO/J/QG+rYxOaEj4+zBjzkEeDkC0+VJ699+4WlcGLMYS0igVy+7HJWjC6SFXuoC9MylFH+PZs5HM3ULi/PkIs06wxsi9BZpgkmw3221hvDnLbhqh4j9X1TeNbNc3QdSBGUje4yHu7AFXRSD4C2yZAxw3g/Jn6SXouSVwGen50gPlweZxdUFfTuetU+YEqUsZrrNGrsG9cZ8+v6mVLYlaYka2EQ/it1yLawr31GsFFywGVwsQja0N9t0oz6y0YHJiDvSG9zv/piDZpf/QINRjNvsVmIv7Jrb6gw5HNui3LYWi4BQ1uiPNeT9wcNfj+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTmdPTUiB1q+xKxC1Ot9E9P9xBzVBglbvNw3YMgs8Tg=;
 b=bT6TzPxQbiBq2IBFMGtldhd3Uhf5A4WVTyeDaI2kymeHxvl+3ttN84VdQ/0H376nFuRP46qa6+zH4gQxm4X3NZZWq3cH1Q15ITp0zYqVwmKA4dWx3z75pkedR7vZAOnQb2Kvtb4IU1rjYdLgNlzjoUqKIh4vWDuDoC+msKjSVAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM5PR11MB1339.namprd11.prod.outlook.com (2603:10b6:3:d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Thu, 10 Feb 2022 16:38:00 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Thu, 10 Feb 2022
 16:38:00 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
Date:   Thu, 10 Feb 2022 17:37:51 +0100
Message-ID: <2534738.AP0T11PbZZ@pc-42>
Organization: Silicon Labs
In-Reply-To: <87a6ey3d0e.fsf@kernel.org>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <39159625.OdyKsPGY69@pc-42> <87a6ey3d0e.fsf@kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0118.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a62a4f3-e030-4c6e-d245-08d9ecb3b30d
X-MS-TrafficTypeDiagnostic: DM5PR11MB1339:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB133923ED16A065A92DFC6900932F9@DM5PR11MB1339.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4oiJDqbmrjExSJS4ptuYUIjeXGXXRuCbTxqN5/0WyAIxwe5/7zLYZzovAyVOO7GqWlhnGe6nOKijeLcRrrJO3gQXKDdOqV9SXW1OIhk1KE9/wbynDx3bmMWF4UduA609Zzy8DfwDzUNEDo7ZF1gVhnLtNURUTrqo9gQW7DtMt9EVDqUHRM5dvSxbvMCnmTDNB9tmkyeQbxrBzMpCAfjpFr9LobQ9PsPUP/Aw00gGS7GSYSD60BX+omVPKSIu8Iw5zNP1UWT+D/NAdbvLiZG/hnVHGMXMyIbUBKUWJRoEU8ErsYp+rE2946S9lKRHiYmHz8AANqCd1D/XPtkoTiAGlxkcBw0xayDJXwFyVhjtru6NyI0Xgqu8TvcbfegRtaYYTgOh8793t7D4z3+7Ykm0h/mUSf5g9GFEg8mnE366N1r4dPDY3iMZ1Qn4EPiCScCwzDhLRt6dOupwyWpr/ApTw8r0W6kyi98giG8ER6mzMwWkBxlQnEZMD0LeT4F3JeaLikZwordK7kFJEmOeUtkczEKyGqyEIf4FCnV/rHVMdI+D1242kvrh3NBcDWfl+7+DiRK4JpnmcRKpW/6X2CM6Y6N/pw/jVa4mm29YwZ+solsojtUUPTr7YIN6oPGmsaHJ6Y14kZ46cWJgS9B900z3F+BiLyg8RYu0dONNQW3w64vTMR8XfKE4zXuxVGl7WjYzwnlNI0FS6VCLaUWSAweDlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(6486002)(38100700002)(7416002)(508600001)(38350700002)(26005)(186003)(83380400001)(5660300002)(66574015)(4326008)(8936002)(52116002)(8676002)(316002)(54906003)(6916009)(66946007)(66476007)(33716001)(66556008)(6666004)(9686003)(86362001)(36916002)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?X8riKY7zQJ9pEza02PoeEwfR8pX51fVrA4sVvXf42gz0A2Ft4t0pE4svHO?=
 =?iso-8859-1?Q?d5nlSngZswA1LaWrvySO7FwHurEeP21SW8Mj0iaW1cn18fVQaOLQfmyFIY?=
 =?iso-8859-1?Q?XBjggXIv5z/TbmgZfaZVrj0uTPnO4JU8hQB/xpeAtl755GJ9Uib3m+uiTg?=
 =?iso-8859-1?Q?GTpd59B6cBvz0bFxZWmLiBpTcJXZ6ZFZiZB0lXvhIHuqb1fMpL/JEtksYS?=
 =?iso-8859-1?Q?oYK23+jolVMdeF3Zj4rSPcG21TCGRbTa6MFRr+8dPiu/0n3cPK6+5G4aQi?=
 =?iso-8859-1?Q?sHPoxyYe9/qmX7Lph6A+r9W5BVqrCJkonuFn/2QzwOZbuEutjGdpXukMNY?=
 =?iso-8859-1?Q?3ZCFaKx6dujmLgn1/9/FkoPIUgimmIsuIjOawLcI5dhDbBVrXUuZfZsC0v?=
 =?iso-8859-1?Q?2EruMLlXLqN/sqTdUVcixLhmbs2dhzHPQ2SjGJEzoaisPQcsEymB5odt6C?=
 =?iso-8859-1?Q?Zu6mRiTumuDpctEJ36xMyzCG5sN3p4KNVLuhcn+zsWOimOBk/wrFhc+eR9?=
 =?iso-8859-1?Q?+XEhOJTxAvmzzgXp4w2frcxLoa87DeKlYdrvrzicgIPqB9FpZTwdg+phSo?=
 =?iso-8859-1?Q?b6XjY4nTPJ0gkR8vjB53YkiHkKCF2u3fTi8JLn6nT8kvxRUisspDfJSy1h?=
 =?iso-8859-1?Q?1iVWt1BlQkSpV+JmLx3sKeNmjDj2vETCkjF2z/74VuDT0dBexIvVmnE8Gw?=
 =?iso-8859-1?Q?SV7YoFZb1/p8hNo1PW2HmHKgA04owDRaf+47b2gPJc9JIRRzJ8Ow8NaInz?=
 =?iso-8859-1?Q?saUpcpLc/QydTkO0Zbx67cUDcqlR7Vn0oHZGg2vF02YIQPXdWasHyQVsDr?=
 =?iso-8859-1?Q?LdfQ4zKx2XaHt7VFjFgoHn+vR7dQoLV2Rwu/7vGxZwZJnDZ/uXFuxYzGzN?=
 =?iso-8859-1?Q?tdwRQltR0whMrvsVgnc+Eaad7d+c0YK0gOX4/ZbwCFS+dbzEZjao5n58xB?=
 =?iso-8859-1?Q?to8kXKHY4dOMsghSwqB2FtKifvDOUQJbmVorgxIYNpbFRQcxjM4qq1a08y?=
 =?iso-8859-1?Q?gA+jVTCDTTXe55SuqND08aZuRmty2h6MeVBCnIJ4QqLMEPz5F7W2Ei4b7l?=
 =?iso-8859-1?Q?eccA57clhYXkYB62/wzkk4907IZN+mA1aEPIeeIz+Q+SFcg4uvCmumo7x4?=
 =?iso-8859-1?Q?mOnGag7tQ1rwc4a5/z11Un8R7LpYfPdULY1r9VFqsk8XUTEjUXjGximnej?=
 =?iso-8859-1?Q?7H+iZ1i6ddsYMmZCvIyh4DIpmYyi6rPZKeD8I9PxaUcIox3BsEdFL4/+Jj?=
 =?iso-8859-1?Q?BWvFubdJYK7Iooznxl70cC6T8+aSPUgSws9cL6eJSsGXxN2oF6SirUdU1g?=
 =?iso-8859-1?Q?W81tw6MvleUWkoIHilTZEw0i65ekouGGKltetzcwb2sWNP2VmdGFXgix+v?=
 =?iso-8859-1?Q?/wmlANL1awmQoQ0u7RUx/oECK7IRgfWUUDTPd89TtCLGclkPzEOZwgb89y?=
 =?iso-8859-1?Q?qiucx++q122HlJWpcPq/qaKvAK1I5hLR7aEsteCZAbt1R2cRrF0wA1XJKh?=
 =?iso-8859-1?Q?vF6MKtKrw99d9BAFfDpjTOFQIoG+p/y7zUVrQ7TGEnel26Xz+VZuTWfipq?=
 =?iso-8859-1?Q?R56K+OyLTKtAAim6CGK4I4B2bL1P9FdANqRZQKcg6Wb+ejbKdCF5olVhgj?=
 =?iso-8859-1?Q?yhLCM7p6fbNZ9zVSvcFrnKs4jj02+PG2Lc2VVX1LCVaHLIMvIo0OP6P+6o?=
 =?iso-8859-1?Q?9/dwsfSa1g8Q2uLRsV8=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a62a4f3-e030-4c6e-d245-08d9ecb3b30d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 16:37:59.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaUJdvj17JAAD4H1Wy+d0NBFLOpFMZ3UCMbzEtsv2GTd4THgunx3klKBkt1UXivwR2q7UMegTXtk97DvVfmDDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1339
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 10 February 2022 17:25:05 CET Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
>=20
> > On Thursday 10 February 2022 15:51:03 CET Kalle Valo wrote:
> >> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >> > On Thursday 10 February 2022 15:20:56 CET Kalle Valo wrote:
> >> >> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >> >>
> >> >> > Kalle, is this function what you expected? If it is right for you=
, I am
> >> >> > going to send it to the staging tree.
> >> >>
> >> >> Looks better, but I don't get why '{' and '}' are still needed. Ah,=
 does
> >> >> the firmware require to have them?
> >> >
> >> > Indeed. If '{' and '}' are not present, I guarantee the firmware wil=
l return
> >> > an error (or assert). However, I am more confident in the driver tha=
n in the
> >> > firmware to report errors to the user.
> >>
> >> Agreed.
> >>
> >> > If there is no other comment, I am going to:
> >> >   - submit this change to the staging tree
> >>
> >> Good, it's important that you get all your changes to the staging tree
> >> before the next merge window.
> >>
> >> >   - publish the tool that generate this new format
> >> >   - submit the PDS files referenced in bus_{sdio,spi}.c to linux-fir=
mware
> >> >   - send the v10 of this PR
> >>
> >> I'm not sure if there's a need to send a full patchset anymore? We are
> >> so close now anyway and the full driver is available from the staging
> >> tree, at least that's what I will use from now on when reviewing wfx.
> >>
> >> What about the Device Tree bindings? That needs to be acked by the DT
> >> maintainers, so that's good to submit as a separate patch for review.
> >
> > There is also the patch 01/24 about the SDIO IDs.
> >
> > I think the v10 could contain only 3 patches:
> >
> >     1. mmc: sdio: add SDIO IDs for Silabs WF200 chip
> >     2. dt-bindings: introduce silabs,wfx.yaml
> >     3. [all the patches 3 to 24 squashed]
> >
> > Would it be right for you?
>=20
> TBH I don't see the point of patch 3 at this moment, we have had so many
> iterations with the full driver already. If people want to look at the
> driver, they can check it from the staging tree. So in the next round I
> recommend submitting only patches 1 and 2 and focus on getting all the
> pending patches to staging tree.

Ok.

> And the chances are that a big patch like that would be filtered by the
> mailing lists anyway.

I believe that with -M, the patch would be very small.

--=20
J=E9r=F4me Pouiller


