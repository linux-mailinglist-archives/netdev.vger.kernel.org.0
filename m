Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609B448C300
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 12:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352812AbiALLTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 06:19:14 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:47424
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239752AbiALLTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 06:19:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4Vsgi9bLfvHuVZwe/jNJgM0Z0/ctF3AFOo5VtNXkJ+NrgTvs0tdwjA5wCXl7c/2qIhGLy3NcviB0IEcK4ssHJETTSJti8jkMxIy4DASWC+MI3Wd6mbGDal5ICTCeUDd2ewDU6Kv63sp0un6U2N9/ZDQMTKXuYvklIxW1EylbflxZ46yp8j9fDqq0sxRc6Uyb6T0KlTy3cy57pMFHEV0tu6rPdgj5KF5zWesieHgWo5HLdB9uvydoRAyCIE53rfbl81KKr/TBIN4rVm75MW+p2c00I7ESJk27DtQ3RvYbfb5pRRiMKYwH1x/SPowvz4g/CF5u4Qs+1OC/bFVrf3h2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jifdYK1/h7Q2K4AxJkSjVwIGSjtseKBg7mOfTn8sf4=;
 b=az4N9gzvO6A5gNqmikQkfAmTJ471gH5tq2UAPmO37sGjktVmqOrQ6CaEDnbacHUz/4+6BrLicpw4p3RaFU6vLTA35ylu1xRje9ulDAzYtTostxTmQ7ey6Mh+wk5hoVw6Hd8k+HGr+tV4tYeEM+R9cLIybGPStJYNf9bB/aWsIVUo9ngNvgblFFPCmQtCHK51mYAuZP8WiThleLxMP9I+hbPDwdKorMHboTOSbxh0wkSXGHFCrZSUggXL8AmWbMGlBBddmFUw1ZDeN0tfmlaY44/krS7iXmLJMwkIA//SkvEHHhYiFSXfuE8KrQNrBP5gSKO+S7y0UmID6LbbM+l+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jifdYK1/h7Q2K4AxJkSjVwIGSjtseKBg7mOfTn8sf4=;
 b=gApMu4//nij1QBmFFLndCiiwUm1W0T4Kj9zIAM+OLFnbc+f+tyag7uv+0EoS8/37Zoni+bPQEjw5c5vi4kXfUmigYXDnQn15iuIPy3vKmx1JfMuGSDDWZFWfg6YHvVBGsyIWhDJHCUnpxE381z1Ft6BlgP8IKUq5AEiwbc7TB/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from CO6PR11MB5650.namprd11.prod.outlook.com (2603:10b6:5:35a::9) by
 DM4PR11MB5278.namprd11.prod.outlook.com (2603:10b6:5:389::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Wed, 12 Jan 2022 11:19:07 +0000
Received: from CO6PR11MB5650.namprd11.prod.outlook.com
 ([fe80::584b:bb3f:c96a:b0b]) by CO6PR11MB5650.namprd11.prod.outlook.com
 ([fe80::584b:bb3f:c96a:b0b%6]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 11:19:07 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Date:   Wed, 12 Jan 2022 12:18:58 +0100
Message-ID: <42104281.b1Mx7tgHyx@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220112105859.u4j76o7cpsr4znmb@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-9-Jerome.Pouiller@silabs.com> <20220112105859.u4j76o7cpsr4znmb@pali>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P251CA0012.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::27) To CO6PR11MB5650.namprd11.prod.outlook.com
 (2603:10b6:5:35a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf507a75-cb5d-45c9-0be6-08d9d5bd5919
X-MS-TrafficTypeDiagnostic: DM4PR11MB5278:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB52786F51127D6D735B67342093529@DM4PR11MB5278.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNa5+0lM5k7695qKHFCvObFHna4d7tQV0AmENkPJW8TtMoI8RRiK3924LxeLN30TKCaFvBcM1ZrFEvifq9LTHchVlYl2rlQYuOiLaBLaONnsYsKY6wzN8+axzyqLYMlf+KiYLwPKhCU0AQajUK9VfWiYJL6/D1yzpG4dEQFu9C44opGNU1j2K09UVnrOat700vpfk2np44ipzaDrOSvFnQRm2Sq89JPuNw+dYjaUnNa1buiao/nhVz0YbqOuMoxfftkO8bHzjZV1Ri/gOpTxC1HAZjs2LAaXUNudDF8uXdnvEu/4PyMpseiUVmxHraN0F2Cx0jKscIpUp0mixojTaYNgPWulEN76vXUQVIiY83ohZCxV2jbAi/PzA406zQ05HH9RbLxaUASBfoYTmR8oOqW3g5F2pXo/fxYXesx7O0JmrD/+xkb2PHKLtveJddch0BqBX+22y2oS3NMwthhr44h8RdP7ItkejaCmg5m1ZHf3ndBTCYnOSw1t4Sm/cpIf6dP+ubwOF6RVPPxBXNJ2EheV6fpbLlvOHPfNrdtXOcZD+5gkrPHMgEbwU4eMSVlxBbX1LXER61fGjimVUUywVeUKqk3pskLWcHIC8lJB6yQcTIQ3coJSdim92sVFfmKx6xsn7ZPmhoWHF4jYs0lF1xJimL+a3RsxJc1Y7fstmz3Gf4yMrpEE34hsjK5Q2zUsmKcfKY0YXvzIl6h/y953BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66946007)(7416002)(66556008)(66476007)(54906003)(5660300002)(38100700002)(86362001)(316002)(6666004)(2906002)(9686003)(6512007)(33716001)(6916009)(4744005)(6506007)(4326008)(508600001)(36916002)(52116002)(8936002)(6486002)(186003)(8676002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?oXltm3vX/4bodzeI6Kq8Bwn+QTJmmWTfQveByhYCVY6QngWRj7w8uNGQS1?=
 =?iso-8859-1?Q?e9hpC7s72OXKqEjFOXix+UaT9KsG37xVqSdcl9JFZJka4ZKgxXcscwxeYO?=
 =?iso-8859-1?Q?Bj1EgUd4nADM92cUP4TZin3BjIRlMhLCyBauVZfWlo903Gqs+FJwCSKGw1?=
 =?iso-8859-1?Q?ARe+DnClV3AsG2a1uaRR/L98qrZoyHu6hluCe+VtXLlLhJaEvNMeSvqSi1?=
 =?iso-8859-1?Q?mxJe/aQrHzNOAekSJ/WpFmdDDGvZNfq4j09AkLiwG1VW7i1dkp26hNWTKG?=
 =?iso-8859-1?Q?++zjIB7mCcRHHETvl5EJWh70AUid65bmz1U3so+AsfHyAH+RJoyDs/5uW7?=
 =?iso-8859-1?Q?FW22pe4Yb9fRbpK1povqKzqF7GrAZG+A3Q8yYl0kF+DNWijTVZrLtO4eNZ?=
 =?iso-8859-1?Q?BuHtE4hOPvVBIv6NT0GRtXUSFds8V9j0/NOoRAK1hufvmN93NhsTcVMrQm?=
 =?iso-8859-1?Q?2B61TdFcpKZzAcrMTF9EaNVmBZcykUhNgvAl6+C4LU8zcsZ/6QnoRd6rk2?=
 =?iso-8859-1?Q?pePnVKRSOOOEiSyHD/AopXkSWO0jvz4VEW7vGdJlF5XeoiDQG/9hEoQqv5?=
 =?iso-8859-1?Q?E4A2FwVwTgqwni+ASAHtGPoPztI4i9YMWzCtxVAhYH7IL8yFANGJNjTavS?=
 =?iso-8859-1?Q?WE1s6BzTDDo2sCGxBYaG9Za58XxVH4s+imJRAmnE2b4XEtcJx41VZt+T65?=
 =?iso-8859-1?Q?Gxbjx0sfE6sXvxNVJfRhGcH+rOp44H4YmEBvbJ92pS+EoR5gDMZSFRODvF?=
 =?iso-8859-1?Q?ecmDv/rPR8XlKCASHtXy30mRbnzO/rhiCwLW6ypIMl5CpXPgB+lD1prgO5?=
 =?iso-8859-1?Q?lAOID2BfqkJYS6eBitg7LyaGKWg0A3tv9AhHRQM+pQ1SscBBoMasqqSAlv?=
 =?iso-8859-1?Q?R6gOphlB+RQNfBefwG7m1ua+sFydxkALE0m/coxj+3b4za823EUfKdp2AQ?=
 =?iso-8859-1?Q?otgEDnGUk/+tLvyhl+t7U9oGR0qpOu+MD4R7ydlKbLsVJ9wP2nlBbVG75U?=
 =?iso-8859-1?Q?DNeIldozZxlFP1DaFe5LOI2fzFa9c05ixLuRvbqssDvRmexbtYogtXkG9l?=
 =?iso-8859-1?Q?Nz8/xUF+a6AtKEcHbhRuih9hb/n+/oFmmQVFnJtRfnQpBE6Bm/9w0lkOgC?=
 =?iso-8859-1?Q?XtVeMmvEMlpWEP9VuxOS6cKJICSmFKCYH+/lgnVd6YIAN/yVOaYOrBRdqr?=
 =?iso-8859-1?Q?bvUi9c7R+/+wAaiteNXEhkbLmO2aWMlxQrkl/bRKVDDtRrFSiGP7+YbSEE?=
 =?iso-8859-1?Q?u/K7c0y9ddJ6dsmIObNGCr0QHNNjRTXQbm2VMhpul8547KMxMH6sRd8Oua?=
 =?iso-8859-1?Q?xorv2fBHQ6IDFGt7L+bfRhfOKK2k0/Zi47QIm94QGjx4mAwwJKvMU6cKV2?=
 =?iso-8859-1?Q?sfY7ePcMMIKkTnpuV523x9X88nfghfEpvQI1SvmMF3p0mImSjfNo23xPRe?=
 =?iso-8859-1?Q?BWH6n4Z/4JMp9tDZ7rebdXFnXVjeqL4+WdPzgZRfYJoTFqvuVvmORCHben?=
 =?iso-8859-1?Q?m961L3ZshMUjDWPfVHdel4k0aHugee/jKs02bar7ref2KZnz8avK1gpDNu?=
 =?iso-8859-1?Q?bRWw7vQ0IArbHW305WvJfbReux4TzIIRqOLU3yFWlJbm3vjnZvirG9w9h7?=
 =?iso-8859-1?Q?4EwJtKcIYCkDcPs5pToSZRZHQ3fobMFM+ZYYzl2lsXu0ZD4JaLTy6dQNG9?=
 =?iso-8859-1?Q?OKyl5Su+LCb+3nCSPY2bGkDRSvozH2teTMN0OuoL6ZV3zIYP/QIlTF0goL?=
 =?iso-8859-1?Q?Rby3Ragvz0KEs43kh6mfpsV1E=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf507a75-cb5d-45c9-0be6-08d9d5bd5919
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 11:19:07.3265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yL8J5cheTH/Wv7aAZk8NCxtrqJ/E5zKwEWHg7EirJ2OLWWHty3YCJnbQeDSo5yWEqZ9OB++UIK77Z410B815w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5278
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 11:58:59 CET Pali Roh=E1r wrote:
> On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200)=
 },
> > +     { },
> > +};
>=20
> Hello! Is this table still required?

As far as I understand, if the driver does not provide an id_table, the
probe function won't be never called (see sdio_match_device()).

Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_SILABS
and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does not hurt
to add an extra filter here.

> > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > +
> > +struct sdio_driver wfx_sdio_driver =3D {
> > +     .name =3D "wfx-sdio",
> > +     .id_table =3D wfx_sdio_ids,
> > +     .probe =3D wfx_sdio_probe,
> > +     .remove =3D wfx_sdio_remove,
> > +     .drv =3D {
> > +             .owner =3D THIS_MODULE,
> > +             .of_match_table =3D wfx_sdio_of_match,
> > +     }
> > +};
> > --
> > 2.34.1
> >
>=20


--=20
J=E9r=F4me Pouiller



