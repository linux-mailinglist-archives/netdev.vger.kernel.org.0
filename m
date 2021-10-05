Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4917F42205B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhJEIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:15:03 -0400
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:7552
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233079AbhJEIPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 04:15:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dro6R0M8kZZWMa/ADIs2waPYd7oJg/oXwy6xm0sac5YTZkVA4+jmjKbBmSHxsOtg5c2AC9ZIrV+cmeD84gFCy99DszEWA0D+psi5Jbt3zymxa2NYi8fwBwmmrSM9HQ2ZjeCXep9BSYBeBmbfuFukjIjS9LkvAYaI0EGD5MMSzEAcNOIKbKAWL6+C+WY0mC9z5CM4S2Rx0yWjo/XEuICCK93yZJN1s9qUaCQUWeufwJdd0sMiObRqfFBrggkrGtVbyAsdUhrs8LREiZKYwm1aU+kM9si7r6SNd6MXOyGbbhruT46OSqSKpbWzBQymQRIg4GKQ8bWVQfVN2jyB7jnHFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKrfD/33W0mY9h3j/KCH9Zwe0jb1xRDgXra8d8uLDWk=;
 b=MxEYBCJZVAgkbbMbmA63+Q1VbHyybeCdPqhvz87cILmiu0POiwm9g0q/Uf71e3J06ylpXSJPNud7F2rBKSUwriNVicBdmJW4cq42gCHYMWYjSJQnwa3kNebFYv5vEDwIvh9ICaLiVPtW/x2ZqM47y71Q9jQIlmBfD6wiHPLI3FNE7LGWi6IrrcQ/v1W55oJ3LMuaI05W+YhEVkqll/JaYS12am4uIn9htPpi/FUkOZYNf8oYCTNrG8rmIQeP/gljPeNu7dIkTzAdQCIKk3XcO84EDatDHojgSNyUgjnjVnQ9JjfpwMRzK3/ZGfYXMoUzM7DX3W6PRg+XYMUXhTjfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKrfD/33W0mY9h3j/KCH9Zwe0jb1xRDgXra8d8uLDWk=;
 b=gl2YB1w8Rbhpp/nnHnsVrxhgKpL0cSqa9Kw+FRts2PxdR8mvGZqDMp3f9YRHl3CZwT9C+9jSEZy4nXaJK887Q0fXLFuDVYUaIv+5Lp/lYM0cjQJnkXKzalZKQHBQ5HfEwvwceif89rUvSuE5InlGeM7sZJez0WnNqxYvVrFY6cc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5675.namprd11.prod.outlook.com (2603:10b6:510:d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 08:13:09 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 08:13:08 +0000
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
Date:   Tue, 05 Oct 2021 10:12:32 +0200
Message-ID: <7452745.X2mWs0JoBS@pc-42>
Organization: Silicon Labs
In-Reply-To: <8735pgggka.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <3660480.PpQ1LQVJpD@pc-42> <8735pgggka.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0066.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::23) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0066.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 5 Oct 2021 08:13:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bb5a6a9-c23e-4051-6107-08d987d7f738
X-MS-TrafficTypeDiagnostic: PH0PR11MB5675:
X-Microsoft-Antispam-PRVS: <PH0PR11MB56755F6972849C1C9FF8389E93AF9@PH0PR11MB5675.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5/VuKeEEeQuNj6dMKvyHA7N/BfdzckJLYVhzwdZAlnhYPDI4YQNfIqy/xYEdqWdKsty2S1yNl6GnC9UROQoSHh8EAyujmYmK2zt9VZgnujjRr7MUaw4zCK5YQ2Iw72NXp9LOJVZD+hP3zQqR07SZdMbRsrhQvre9eGc48LZpChC39uQiJ3rXECnu4lHa6bnqXmjSAMsB+yg6U3p9eBuJbeixIsAN7RzxdD93dflaH1kB8JrG1Kk4fuSSHcNhLFJUxGATqPVBLObaX2yZskBvdWFpoyuTKLoxB7JhKLVR0BKTmfjZD5dk7XTe4g4cLlRNISMJoVKrvuJInaxG3V6ksGaydHPT/9cjzVWN3Z0JzNvwaFafe8gr//mnGtXXYvEfQthr15/MXpGqJG1ETai/c7ZThxOkiKkFdCezm1NOj8ov8bfJ1Ly+sgDm4Csp4nbwt2RNJOHtEYH9G4MC92Who2CUwTV5pddipScUw80TxX1q38FUh6Dp/456zFAv1g+oaXO3qjaONJ4RZ9mUARBAogec8W99aFm287uvFJW0P9biz/mF1owgi2aEB6J3QevOQxxLcby5ktbA+ZSzWJ0JumZZydsl/uyKtoMmmOOWHFLTw1scLoVLZ1WF1UbwG260bgcia4tYeLEJymCVy8XctR3t4X4q+djCPpZGlwIGUucBsRuPxZoOKBS9jXMfm0qynXpcTnFKYXkjFRrBqGLR6ut3DYFzkcok1dEoSwdz3w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(316002)(54906003)(86362001)(6666004)(508600001)(6512007)(9686003)(2906002)(52116002)(33716001)(5660300002)(6486002)(956004)(66946007)(66556008)(66476007)(7416002)(66574015)(6506007)(8936002)(83380400001)(8676002)(186003)(26005)(38100700002)(38350700002)(6916009)(4326008)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+9VOkZS96RBi1NSmim7XCJAeFhlF0EJjGraA2Zo5rWy7ZtRv0YXWba4BKm?=
 =?iso-8859-1?Q?w5ZvL/uSa6m/LR5kOSrp7isWIFPiY+7qhFfhul9evqTq48DWqh0FqTgFPG?=
 =?iso-8859-1?Q?HpPLMUlqby/od0mj2BmKNy38K6BpFFwTENvObno8yEaanbkoYV+7soDE92?=
 =?iso-8859-1?Q?JKzYJLvH1ZGoT4iz1iQItkh8PlMCQ7OEnS/hM3Pfi9rH88Qw8OPX1Slxq4?=
 =?iso-8859-1?Q?17V5W0tMm6FjOJD/gkyFNCjXK2Ltc8FKUJR+99VfKOJfKibo2YRtYIs/wz?=
 =?iso-8859-1?Q?iFlG4p2jUGAioyOAI59jjzHoMP4qMv1G38LlnO7PA4tG+n1MNpPl2u39iI?=
 =?iso-8859-1?Q?egc5FyZRZxEUslDetxjckAikovBtfLNMMgAyLJk6yLIgqz6t+u5xclAlnH?=
 =?iso-8859-1?Q?ga79RjQyV2bU7bBd8Ja3vvqFhebOi0vtEZUarsOZzuu5Bmd7iAierWFtPg?=
 =?iso-8859-1?Q?EexxFljEnGlrnA0akIcuvuPTMnUQaGi2UQtZx+bNXfSgrK6aj6aWr/aU30?=
 =?iso-8859-1?Q?KLy+7JBTQoNXnV/JBp5UCNbYqcFVtcNOwzXNLcIn1DqIl0ZmVOlFcN9AY2?=
 =?iso-8859-1?Q?Eua0Z/qgvi2iIRXDH6eMK4KH/hEfd8ilbPFN1FvUEfxVQ8xphTf5yMoHTG?=
 =?iso-8859-1?Q?+R9crfVymc2pwDpTPnQS0VirhohsAHvaZp8ZufyJ0OJzgObIZN0ceEpIYY?=
 =?iso-8859-1?Q?AiqjanVDDABLFPwdoGLhharaHlWBWSYa3yjE0CT8+45ZfvTSc8eNjoWilF?=
 =?iso-8859-1?Q?ekOJT4fbiuyBa8MlsPI0I4Vr/Gq1aBZGdFe0sJmD+kbvfDDkdPiRQnmyY4?=
 =?iso-8859-1?Q?ItvXp5yxRfNncAYAPjtrUutuoHgInflJIzVsPxwmGMkrOydCIL69AmyHo6?=
 =?iso-8859-1?Q?lDLkbaVQof6gDlc6r26Y90yUjrTaSuIVrTz9l6AxtAltBox/B/g3Vaq0r9?=
 =?iso-8859-1?Q?vKIGZ78nQd/CfHAL43s9SvoNcQXl4NqD8ymR0C7RNQwBjDNUkgQxceNcWN?=
 =?iso-8859-1?Q?RvFhvsaC5FxUuZdZYYQBoPvDuQ0B2rqJeT7GbJiRHGqe1xoMeAI7VvCyuZ?=
 =?iso-8859-1?Q?f0ACrjMUdGUSYjRybnUhk5a3iThx91ybowEpV1GY6WTtuVjeRgSrNUns0D?=
 =?iso-8859-1?Q?KFrUa2BvdnYvVR335/K0QDCAKV/GJlMb+NDGVpDur7P8970Hc9YXBX7D6T?=
 =?iso-8859-1?Q?LPC32hNcxNZ65Y5+vDIwPYLbgy1MI++9aYkGX/KWImm8rYVewo6cnWJ88R?=
 =?iso-8859-1?Q?35KQJ+u1SB5mh947Mwebyvev812s5SyLvCdSL9KP4rmvwtGYTNF/sMVsnd?=
 =?iso-8859-1?Q?3RkVtjLOB3IpmMYZg9v48UDGkzJunLs5A+A1CMXh0sJa0AE00Gx1r7QPKI?=
 =?iso-8859-1?Q?wOa+ULO6Th?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb5a6a9-c23e-4051-6107-08d987d7f738
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 08:13:08.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/EOULx31YMLrJESbjME1JzHdQ03ZROvc4K6wi1EUh3T6WUE2bcWSW3R3GOd/quZsIMMIb9fczrpLEmYpd2GWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 5 October 2021 07:56:53 CEST Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
>=20
> > On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
> >> CAUTION: This email originated from outside of the organization. Do
> >> not click links or open attachments unless you recognize the sender
> >> and know the content is safe.
> >>
> >>
> >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >>
> >> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >
> >> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >>
> >> [...]
> >>
> >> > +/* The device needs data about the antenna configuration. This info=
rmation in
> >> > + * provided by PDS (Platform Data Set, this is the wording used in =
WF200
> >> > + * documentation) files. For hardware integrators, the full process=
 to create
> >> > + * PDS files is described here:
> >> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/READ=
ME.md
> >> > + *
> >> > + * So this function aims to send PDS to the device. However, the PD=
S file is
> >> > + * often bigger than Rx buffers of the chip, so it has to be sent i=
n multiple
> >> > + * parts.
> >> > + *
> >> > + * In add, the PDS data cannot be split anywhere. The PDS files con=
tains tree
> >> > + * structures. Braces are used to enter/leave a level of the tree (=
in a JSON
> >> > + * fashion). PDS files can only been split between root nodes.
> >> > + */
> >> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> >> > +{
> >> > +     int ret;
> >> > +     int start, brace_level, i;
> >> > +
> >> > +     start =3D 0;
> >> > +     brace_level =3D 0;
> >> > +     if (buf[0] !=3D '{') {
> >> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> >> > compress it?\n");
> >> > +             return -EINVAL;
> >> > +     }
> >> > +     for (i =3D 1; i < len - 1; i++) {
> >> > +             if (buf[i] =3D=3D '{')
> >> > +                     brace_level++;
> >> > +             if (buf[i] =3D=3D '}')
> >> > +                     brace_level--;
> >> > +             if (buf[i] =3D=3D '}' && !brace_level) {
> >> > +                     i++;
> >> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
> >> > +                             return -EFBIG;
> >> > +                     buf[start] =3D '{';
> >> > +                     buf[i] =3D 0;
> >> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + s=
tart);
> >> > +                     buf[i] =3D '}';
> >> > +                     ret =3D hif_configuration(wdev, buf + start,
> >> > +                                             i - start + 1);
> >> > +                     if (ret > 0) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
> >> > options?)\n",
> >> > +                                     start, i);
> >> > +                             return -EINVAL;
> >> > +                     }
> >> > +                     if (ret =3D=3D -ETIMEDOUT) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupt=
ed
> >> > file?)\n",
> >> > +                                     start, i);
> >> > +                             return ret;
> >> > +                     }
> >> > +                     if (ret) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
> >> > error\n",
> >> > +                                     start, i);
> >> > +                             return -EIO;
> >> > +                     }
> >> > +                     buf[i] =3D ',';
> >> > +                     start =3D i;
> >> > +             }
> >> > +     }
> >> > +     return 0;
> >> > +}
> >>
> >> I'm not really fond of having this kind of ASCII based parser in the
> >> kernel. Do you have an example compressed file somewhere?
> >>
> >> Does the device still work without these PDS files? I ask because my
> >> suggestion is to remove this part altogether and revisit after the
> >> initial driver is moved to drivers/net/wireless. A lot simpler to revi=
ew
> >> complex features separately.
> >
> > Do you want I remove this function from this patch and place it a new
> > patch at the end of this series?
>=20
> I don't understand, how that would help? The problem here is the file
> format and that's what we should try to fix.

It was just to be able to review this function separately. Nevermind.


--=20
J=E9r=F4me Pouiller


