Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B7441F14B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355070AbhJAPby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:31:54 -0400
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:16705
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232091AbhJAPbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:31:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aff8QQ7VL9plk1xg0I+ysMVvY7TOBOeybctD4IpslkaXUZzI3/vWjQP3T37NWfOaXglaKF1ajF6Boe69jNMuMgxzy8++K7FZ48VfszbHAd+Wdnh2jnJpEJJ/BsndpGeEZruIxDTCj0rTylswJ8Mn+VW/YemN//rXq5fFpZDgb1rlxCIyg9ic31fN6GcbeuTCqXdFlop5K3FBl1T/jpqq6XQLn02ttSxxHzS7UfMEDGdZi0RE0PWYbT+MAIjG02HHA4bs0+WkTzIMvveEOBZx/eMPnHXoSqERlu+ob+DTRyMZRrCAD3vHKspj1+27kv9r9/feoYoLRiAQsSPSZxrYKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBl6bLx6eXQDwq4gkscRt7z/F6U009MD/PugrdbhtW8=;
 b=S2JUEOw8fKncwJ+/oF5/Y7lueEETa5G4eaItkDpq6UlDV9B4oYl3nDEBh31jZ/PZBJctVpcJoEcni5NWiKeSh3oe0KvKaIFWIJZSaOtWSHN0iDooUH4EFCmpGeaI7eaS+g0KVOnaWigJfuyYAzRK3N7dDXoTlQUMrP/7MvjWddhd0O2tHNlK9aTTmoRhiKaACmwumZ+I+YTYDV5lH4DfnqPi5kBqxqzKoylqtETSz8s+6j9iTw5/gbbb1pf/U/Bl/G0bF5pv4bxGXwtnneGixEuufkwyE+BCK3ChjVxjrObjKTVmBlx0UWRtcOs5FSTITyywrrzq4nTQatB9I8/Skg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBl6bLx6eXQDwq4gkscRt7z/F6U009MD/PugrdbhtW8=;
 b=oHOp6SXEP9guXCN9dP5QBRl1Bp873OZXVSEtGKPX/4AA37mCn7cJGGJ9I3u0U4JsrZoU+T1tUR8q3KVfLJ2+oL+/fM8xwLS9pQ3GAkuHz6/A3BiNS5b4u3ZLx8xhScuT5N6bWfiyQnZBauWWNji8Ke/DAJrgtPIEYSF2vyGdAoI=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:30:06 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:30:06 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 05/24] wfx: add main.c/main.h
Date:   Fri, 01 Oct 2021 17:29:57 +0200
Message-ID: <3660480.PpQ1LQVJpD@pc-42>
Organization: Silicon Labs
In-Reply-To: <87y27dkslb.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-6-Jerome.Pouiller@silabs.com> <87y27dkslb.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0194.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::14) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0194.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 1 Oct 2021 15:30:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1885bd0c-edb9-4327-eb66-08d984f05869
X-MS-TrafficTypeDiagnostic: PH0PR11MB5658:
X-Microsoft-Antispam-PRVS: <PH0PR11MB56584AC122FCBE2B7E56216393AB9@PH0PR11MB5658.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+Tg2PW569Tm8bsCyUInsiH7BxwSxmUmmYphdUfrF+rRmg/hgsd3gUe8bfG/ZUvr1IA9PVK8ZN5VZNhj00ynbF08WS/YF5AaaG3YlAq2TAsE8QOEYb/myj2sNcZvSqFAjUlB0tix0Cvt9H7ocrHcRyG2oc3+iE7h7GdDiQ39lhNmMoa9+lcpeBQY8MqyDvW4jGKcxs/wYUav0gilOHDhsdmmPy/paUX8uUI8ggvbt052vIFRnROdPh6nAgVbA5sQADEuWoR3df35MbolLRqKwHxVUAWUCh634EP81gR2SBZOgsANBKDNhF1piixEXh6EEE/wEqG3Xt7irqnGEk7NSIiniQ2IbUkRzadbkuwZ5Q3QVg5b2bwJ/gAmBP45BhlKZl5dMEothIig0NvX/QdTP5lwLBbpn4iwTN1hd1bjc+rW00NS2aVjaxy6IDuwLf87vflzuR9sVk6KDEJLP+dClWskdE1X2TyHrQVk9xKG37kzAMMsAJlVPxnOMPuDjnFozS3kpJjPcJ3T7pzKdW5Sv6RjbmG22Z+ARLak7grXi9T2qridVw7CLJkjNYuCQW66vc/zcJbjOsVMJsV9j++2M2VIcJozig+riXpX1iwufYj4Fd7/voxcUTGMXpy6XRdJmV1cSItGCzjVf/K9OpyVIMcrDW2inlgKxESHOqoat/lFkefYaXg58jH8Wg6/jsV/TwaCVcN8pvkjSrpSXrPZh4GGUIGWI87hbxMAzQnZmHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(956004)(66556008)(83380400001)(7416002)(8936002)(66946007)(8676002)(6486002)(38350700002)(38100700002)(2906002)(6512007)(9686003)(54906003)(36916002)(316002)(52116002)(6506007)(508600001)(6916009)(66574015)(5660300002)(86362001)(186003)(33716001)(6666004)(26005)(4326008)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Dho7OF8/i0n+7ZUFx2zRJJBvM1ZNcsnfUcRWCJ7pQpBvGqiYAsYXsjs0TU?=
 =?iso-8859-1?Q?N2MZ/3hsVa+xOyGRn8D/n25M8KfLUI89KBI05+eqigbJ1iIkeCKz1x52sO?=
 =?iso-8859-1?Q?RPX/bCtIZZ5Fc7Y8vZQZl2f4CSOW2l5awstvVvZsCz6TgnE88PG28bvVWo?=
 =?iso-8859-1?Q?0NpkwsRAdRT2cZxCQK0Mc/Pn93b2IC180XA9zc4P3+oCq3hJ8OODprAc0n?=
 =?iso-8859-1?Q?yX53It2kmV0Dl/bAfiRwlNMXDon+pg3zTwJAzYErUuyvDpXrFFZvkSaP3u?=
 =?iso-8859-1?Q?Us9mXX7z50A36Bg5N5tVxJEuUbJ0uYOzniE7fnMdNvphBGORZDdaHHkykd?=
 =?iso-8859-1?Q?8k3NvxCwgQLJiGYL/SD8Vc28rVPPEv0KeAomTI2lY7d1XXbYOUiJotgbca?=
 =?iso-8859-1?Q?lStlJUsc74D3YwH3tVyvVnvMOifPkoeEyKq74YEoPrYbKU6iJxt5KB7GW2?=
 =?iso-8859-1?Q?+1cS5PuCiwHGqkxf1SQf8P+Bg21R1NRWeAy8XvWXo+tDJLTRIDL5BOifXj?=
 =?iso-8859-1?Q?YLsAlXF6Qna72YEUpamWSXec8IEdiMidRuXcaD7W+U38BS4RSNuzcrZ69R?=
 =?iso-8859-1?Q?hp+ZdSkimHaBB9phXVJuHCb4zpJgGRPSrG3hLouF7KI3hSDrQUxAZF/6Yr?=
 =?iso-8859-1?Q?PzKmBnE/LtCUBuRynGDjNNR9kGFWYJGc4382hYeTOJMsDRQd35dNGwOHIB?=
 =?iso-8859-1?Q?5x6T/P7rv48kBAhqJj1VrfeszzszsHU2t2cf79ct5VEJExemZNFXqXPick?=
 =?iso-8859-1?Q?p3EFXCwDVWBqnGgIwVNspOywM5GmuFNB87QWe+eTbapNni4+wkQtePVt5G?=
 =?iso-8859-1?Q?LzVCAP7owU7ks5JmR1H3pn68Rkfee0uCOT/g7GuaPM0sQSjm631hYP+x1t?=
 =?iso-8859-1?Q?ozjnk8atX7d0BgtG4wOfVLd5R00iUxaocyGfasGY4ms7Wwg7nu+ydNP/L1?=
 =?iso-8859-1?Q?/oyJE8LRFLpSSA2YXm6VvOBHwzE7N9BnCR7aJfC7T7HTy3wYEV4tuwKwkP?=
 =?iso-8859-1?Q?ePSKmC4yqiMQKUEQMnYGZfkgwOkptQeTHi34mcFI8osZTu31CVs9fkBemf?=
 =?iso-8859-1?Q?p7D4aRBCeFci7uzjJUhgRnwl0xyXk1k4InH7bTbNxhUL1LEAQHPvtN4zoU?=
 =?iso-8859-1?Q?21RewsC/KVAgCxfbiKzajYQzpAH1ix3siyY6CGLkkQmFmkwXmYtQ03j3AX?=
 =?iso-8859-1?Q?52A4eaaRp0AiPiiXG/SmDBucFujsunrc4V+2lVUliGfrmAhWS7YFXgUmJS?=
 =?iso-8859-1?Q?XpDsAkFTEbXG8rONTo5ya4MrC+YdpUWQxDbVDwHLbGVy2VvcR5cxjMvIPG?=
 =?iso-8859-1?Q?ri8VrAVi8c53JigKhJkeF3nNZVcS96HQxvcOLKOrpkdI/HPiDt6dnliSaS?=
 =?iso-8859-1?Q?aYmTX3Jv0d?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1885bd0c-edb9-4327-eb66-08d984f05869
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:30:06.1443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6368N/pM+krc7SYbrkUIRA+i3RTCS3rrLWfjkNIax5rEnYoUGfQcWdjXlXKwnfEYZSF7tgHDwPo6vBcrOG41w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> [...]
>=20
> > +/* The device needs data about the antenna configuration. This informa=
tion in
> > + * provided by PDS (Platform Data Set, this is the wording used in WF2=
00
> > + * documentation) files. For hardware integrators, the full process to=
 create
> > + * PDS files is described here:
> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.=
md
> > + *
> > + * So this function aims to send PDS to the device. However, the PDS f=
ile is
> > + * often bigger than Rx buffers of the chip, so it has to be sent in m=
ultiple
> > + * parts.
> > + *
> > + * In add, the PDS data cannot be split anywhere. The PDS files contai=
ns tree
> > + * structures. Braces are used to enter/leave a level of the tree (in =
a JSON
> > + * fashion). PDS files can only been split between root nodes.
> > + */
> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> > +{
> > +     int ret;
> > +     int start, brace_level, i;
> > +
> > +     start =3D 0;
> > +     brace_level =3D 0;
> > +     if (buf[0] !=3D '{') {
> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> > compress it?\n");
> > +             return -EINVAL;
> > +     }
> > +     for (i =3D 1; i < len - 1; i++) {
> > +             if (buf[i] =3D=3D '{')
> > +                     brace_level++;
> > +             if (buf[i] =3D=3D '}')
> > +                     brace_level--;
> > +             if (buf[i] =3D=3D '}' && !brace_level) {
> > +                     i++;
> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
> > +                             return -EFBIG;
> > +                     buf[start] =3D '{';
> > +                     buf[i] =3D 0;
> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + star=
t);
> > +                     buf[i] =3D '}';
> > +                     ret =3D hif_configuration(wdev, buf + start,
> > +                                             i - start + 1);
> > +                     if (ret > 0) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
> > options?)\n",
> > +                                     start, i);
> > +                             return -EINVAL;
> > +                     }
> > +                     if (ret =3D=3D -ETIMEDOUT) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupted
> > file?)\n",
> > +                                     start, i);
> > +                             return ret;
> > +                     }
> > +                     if (ret) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
> > error\n",
> > +                                     start, i);
> > +                             return -EIO;
> > +                     }
> > +                     buf[i] =3D ',';
> > +                     start =3D i;
> > +             }
> > +     }
> > +     return 0;
> > +}
>=20
> I'm not really fond of having this kind of ASCII based parser in the
> kernel. Do you have an example compressed file somewhere?
>=20
> Does the device still work without these PDS files? I ask because my
> suggestion is to remove this part altogether and revisit after the
> initial driver is moved to drivers/net/wireless. A lot simpler to review
> complex features separately.

Do you want I remove this function from this patch and place it a new
patch at the end of this series?

--=20
J=E9r=F4me Pouiller


