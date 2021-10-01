Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5283541EC9D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354135AbhJALys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:54:48 -0400
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:24544
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231133AbhJALyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:54:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PF2wx5KX3L3ssxII5DHuhQ8UsojXdGgVt0a9mDJUiGpvv7R4taVAY4Ng5Ve/4d1NvAxqKuVfk2rp4QLK2FpkofM8WksQGgJoVLtHvneboeQvPhKuOOfoQHMB/SF8BCxareQTfWl6ZNJwsIi+/N5lW0HOScx0I0GPv7Hejm9T5alwmwieIhyRa+i9OICJz9F4CHsF/WXHGISQjZ/ei1Abzj8l0hKLoyEAlM5uCTBXCpqM9n7mYYm99jStdTKndtX0KMcI5/9ucqv1OzYQ0qKIQsRKk99/Iu9HU0OzJoK7aU2XPirmhcwsZufbrzjo62FFlgZRe0KudIUpOqMrJ9n0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uQVQmCCcdqXRvymnACL+z84QiDgGmyUA9JMRPe8c8E=;
 b=Bopz/+anZvj+vplU5NFRJSoYx3y6RLh+e20Iv2B6igtNImPgeK/C+rYdMUn02+OUYb07/aKs7ly7NHd8eA9BEo2/mOSvLOh9IuN+885+OQw+f0oQM7ZNKVVbwzoWt+KHWRhJMgi0GgJIAnG7A2RPvNEtukRKTBbzCxtBgHkgacAi1xtcEkujS2i6K6LKSrO1RnHPE/9M3HVrih9Aho4MZH2XsDfjUn+tBEeXykXnjnBhQnbjwJ99LBKEvCuj6ToN9SFhnRSchz21Ux+rrNqdzpDJCi2hePDahxTOK4qNXQoHoYyzpDDIdBDgAztmbRp+dSrvAgQXLF4vozaTJWlFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uQVQmCCcdqXRvymnACL+z84QiDgGmyUA9JMRPe8c8E=;
 b=hHR08VWXcSPm8/jR+uIUF2uIW5Eg4imgjofPXr2ADn56RQ0Jvtp7HAdC676umavN3E8KDeWnM6EuVe/4jsdA+HFW6X6Pi9Zi4FtRt/Wyi03KTqqwhomIpdZqCS6Pb7vgoJ6goRv9tmOTfpawxRv9MffoNJlEfaVc8b+zBaSds1I=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 11:53:01 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 11:53:01 +0000
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
Subject: Re: [PATCH v7 12/24] wfx: add hif_api_*.h
Date:   Fri, 01 Oct 2021 13:52:52 +0200
Message-ID: <2600267.GQK6fj20dd@pc-42>
Organization: Silicon Labs
In-Reply-To: <875yuhkm4c.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-13-Jerome.Pouiller@silabs.com> <875yuhkm4c.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0101.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::17) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0101.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 1 Oct 2021 11:52:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2142f08e-1ed3-4cfe-51f8-08d984d2050a
X-MS-TrafficTypeDiagnostic: PH0PR11MB5627:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5627341A393EF18D641AE25F93AB9@PH0PR11MB5627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIJzTsizmqYMoZGmFhtXcchPz9kXjGgOgNZ6aijvYn9JBHGBHtg30T/3D/yH5nn7nGPJGRFzvGjWYurhlY3dd2oDofzOZ/fFNyl7prMB0ui7vtLkmGoueHThGWZzKUPDr09kHUozcVGGTP3z2E9zfMV4cqHv27sy/OiV6d725hV5p0tlNi0UX9PYS04B8VtRaJm1lx7TQrqhq8HashftU9VNA9dFlFFVx2oK9UaWkXCLlhWtrsGXDwGcwLTa9PRgt3EkEZOqX1PJkYaOwrYY0Jw6wiz2d7lc74PohTPVj3nmZX4VUz1uWlWnExCGxiB5xFtU6VQW/gcFpQfACKa0x6bWc455yphv6MXRCwEdcev9aXT3HGXI5XSYRcbYcc8dZ4DmYuRwsbw6gvQAtrMu1y3GLT/LEXX2k8dlJ02oYtUg9GwA8iFYwnpio32nuuc8POSH4SMp8YZoq0rzosIdnOBIozQI6gBn5Fny07329uFyA6TbsRJxntlYcaO28XI9uMg5ZgYgT47O2seMCVwJkOsPM31aLb6+GPa9xSX1QhMuEnorJMtIwdVfCUrhD4u87nnFdMdGYcGGHu622BD2qRTG2PZ8gOKZTPVdHV8Z6iuKPk6h0CSRQNyprrJXlFBA7oU9QZlDBTgnbhuRdfr9vRpaq/nSBsMtdlrZOe87k4k4h7Od6HA6ccvCe9ZtNFFOA04HGz1yhL18i2vIrM+AT+ELrANssaoKXUttoz++/Is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6506007)(8936002)(5660300002)(6486002)(186003)(7416002)(33716001)(86362001)(83380400001)(956004)(8676002)(66946007)(4744005)(52116002)(508600001)(9686003)(26005)(316002)(38100700002)(38350700002)(6512007)(6666004)(4326008)(54906003)(2906002)(36916002)(66556008)(66476007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?z5MZtWqncYJGrN4PesfpBQhUjC1QQ0wo9UulZxReNIYRLpHAR9kiMo3NB0?=
 =?iso-8859-1?Q?TJtj0yER7a40T45EK2GbsIWkyRykLu3N8KG3KoRu30uDBCkoPvbCmZHPj9?=
 =?iso-8859-1?Q?RT/IOVMkoCxszru6SftERaM18bIxNJxzenn+ugF3VPjJoQOsuTGsIwlTSC?=
 =?iso-8859-1?Q?Qy22Rbvgdnv/eLhgg7fH96pGoFaeYZ+yiPkWO2Mtdl3O/AlgdsukfgxaIi?=
 =?iso-8859-1?Q?R+KNrwUK2uJxVHI2Ujn7QpbTQprbf2/nxIkPvo9+ceoYYvoTvsb9ns6Z5g?=
 =?iso-8859-1?Q?guCnHVfAzJqK61o/iDIpWxLbUMrdJSsYniJWgRTcNXvc+LKW45OT+Tl4xk?=
 =?iso-8859-1?Q?dLl05S0sm1wPfn/NWezWej+zPqT5M75y3BMGTJ/erBoQYgZ5L0y88XpaeF?=
 =?iso-8859-1?Q?Mav3QObJ5rSkf+XuIgbMxNfn+k7lyMAWxN07yt0OgsGCeClhrcrF5pZLYu?=
 =?iso-8859-1?Q?4dZ/R8zZgYGYfm01OXhw4Mtu3axLgx6vpKsB972HXOYUBQiAXRliG9g9wE?=
 =?iso-8859-1?Q?2bRRAl0skEt/vOr872b8Bvfjdf/wV8/m8iFoDPLdRFA06ApJtrbL0D9tkD?=
 =?iso-8859-1?Q?oOAcyS0zhEdTolOgSnFwf1q6S5ZtcWHjta/Dnb9uebZdQrJ8DTqudNaTix?=
 =?iso-8859-1?Q?btrnUgRJJYzjHFKgSwdmxvvXWrZQUIw/iowkrBg0iqKXg7YTK1nibt0lEz?=
 =?iso-8859-1?Q?P6lEdZl3MImPwg3ZTCzuomQoMkhqW5sZAEFfMGoC9ernsBS/fkTHVQVAxx?=
 =?iso-8859-1?Q?XOEqA7Vvska06F6hrOP/teKkNrExqtPXVU3LJZodBfkwWFFw6Ri/a6JpGV?=
 =?iso-8859-1?Q?dFk2Q8dScleAz3IFa/QpyoDE1Gia5cQl2aovl1MP+nG08AsqE8qVuFvEP3?=
 =?iso-8859-1?Q?6C1ePenvHWK5uBLOBGVA8KS9Ofas8I0sSMWm0jB6qDntDXpssY+sPPtToG?=
 =?iso-8859-1?Q?nTlOcihCuas7XmYBEAWDYpSBF8i940GeXjEzGZiTys1p6jiawV1U9rzOQ6?=
 =?iso-8859-1?Q?F2hUKy2uJd60cjXnOXwf66VcKzUZM8RpbnkYJRDuasMv2yt6Ah083Ux+qf?=
 =?iso-8859-1?Q?h2ucMtkgCbZ6xD4QmjoZyMv1TxrRqTrWH7IAwV2xm9+V1cbfd54q47PEai?=
 =?iso-8859-1?Q?LScmjJZ1Spx+AmON7WiojoFjkzwNFZ+qVcZZGkhCZeePp84yyGAiu/oJC3?=
 =?iso-8859-1?Q?OmS3Q5vHFBwPrH3mDaGTERf3Dy2UuRSoWHVRULBAp4EZ/BcJdyJ5lGGHqa?=
 =?iso-8859-1?Q?+MdpvIMOsAfQw0wrDPWpUMXs5CYx1hMc7nf5QEoVMa1BKCSh+PNeOKM0jE?=
 =?iso-8859-1?Q?lwX/9mJejyGV3HplPN1H1iGfh3ZJ8RhaKIuy34ywM5O/PCpqi+fRpb/4x4?=
 =?iso-8859-1?Q?D4Nb/egmez?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2142f08e-1ed3-4cfe-51f8-08d984d2050a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:53:01.6094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4qUHNVEY2yqblAV+4R3O44LqtRUJw/jFfdalMFU5HYlHWqofSfJCE5JIQmuyedSr9oiLDRkUCWSShZwlNh0aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 1 October 2021 13:41:55 CEST Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> [...]
>=20
> > --- /dev/null
> > +++ b/drivers/net/wireless/silabs/wfx/hif_api_cmd.h
> > @@ -0,0 +1,555 @@
> > +/* SPDX-License-Identifier: Apache-2.0 */
>=20
> I don't how I missed this earlier:
>=20
> hif_api_cmd.h:/* SPDX-License-Identifier: Apache-2.0 */
> hif_api_general.h:/* SPDX-License-Identifier: Apache-2.0 */
> hif_api_mib.h:/* SPDX-License-Identifier: Apache-2.0 */
>=20
> Apache-2.0 license is a blocker for me, see LICENSES/dual/Apache-2.0.

Ok. It is not a problem here. I have the authorisation to change it in
GPLv2-only.


--=20
J=E9r=F4me Pouiller


