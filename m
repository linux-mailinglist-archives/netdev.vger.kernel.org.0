Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD01D5310
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgEOPE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:04:26 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:31329
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbgEOPEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:04:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neoyRm2cyq5rixkunA48MlHOVpip3VEGoQ+tFUCEc7XGY3AWaDer24/8tIil154WzB5fO/qi2CCJ9leGby2TRSx9s1G/erfqBW0I3aEgNbJjJ4rBKA9OWJymF+TnFS5Rmq6MDUWq9+M7ZtPaAnHAkiHKsSTxAy4jT2mJB+pWaszRl3+SCjhVQYRsUvPCK8hMCmViSOwiJHD3vxXSb/75Q2mp2UgNo6tCLX9ny7UXvUTOsolkrqIqIQrMmpa1g9R3UXMDw6E7LjGlvwyQH211cG8SAfEmHNNPjjbx0LtKLNr4ywFwpvb91wDOu7EVrS/ya5pZMuLtdIaUX3NQX2bCsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zX5SV0c+pxgX6+6MtHuhZNM5JbBEem/4AsYhAvU5Zsg=;
 b=cYg9ILUFBEIH4j2X8/1Ht6QwPEhfsHRnWEAFkfmrjJXSeTEK/fLiXUl9haMS8U0pbfrWkmCpmDRXfg7teJ8aCDsxmgzWEj6pzPDmnFiXaPGFLjKs9HAgF/3OwWBullzHcUSOiidJubwvcUNbtfXG/66BgHMKjPyF3SyXxhUTPs6kAaspLH3yVm3Klp9FEQrAw3tCKrQFLXYtS/W/KdqYcExLJy3ejhVm0h3QuVwtt54P3TP1UsBNH0XIptAOnpia1Y9XrMlIMujCf/L/Zl2+Z1n3vx3fLj+UtzEWM5U+q2mkM83N5eqVygNDv2Ptu0rLoz+SvbAzxT4/olfWQ/U4GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zX5SV0c+pxgX6+6MtHuhZNM5JbBEem/4AsYhAvU5Zsg=;
 b=dQUkS6GbDGv4S21a7VEoPy44ukNfAyoF+op7emuPTpfJ0CG9z+Pij0bgo7ZF73cXAnFHt8k2A8OmITY3Fd28q9ynBLby8pX7nvyyREChJkxfJybgkZ6Bnni3R3AN1qrin2ghlYfo3fOJc/tb4uyUnGU1clgHeepFHDhT+qs4Z1g=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=silabs.com;
Received: from CY4PR11MB1766.namprd11.prod.outlook.com (2603:10b6:903:11a::23)
 by CY4PR11MB1606.namprd11.prod.outlook.com (2603:10b6:910:d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Fri, 15 May
 2020 15:04:22 +0000
Received: from CY4PR11MB1766.namprd11.prod.outlook.com
 ([fe80::31b4:ca69:21c8:3e49]) by CY4PR11MB1766.namprd11.prod.outlook.com
 ([fe80::31b4:ca69:21c8:3e49%11]) with mapi id 15.20.3000.022; Fri, 15 May
 2020 15:04:22 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 05/19] staging: wfx: fix coherency of hif_scan() prototype
Date:   Fri, 15 May 2020 17:03:40 +0200
Message-ID: <15113296.vvBLmrQuJQ@pc-42>
Organization: Silicon Labs
In-Reply-To: <20200515135359.GA2162457@kroah.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com> <20200515083325.378539-6-Jerome.Pouiller@silabs.com> <20200515135359.GA2162457@kroah.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: DM3PR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:0:52::28) To CY4PR11MB1766.namprd11.prod.outlook.com
 (2603:10b6:903:11a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM3PR08CA0018.namprd08.prod.outlook.com (2603:10b6:0:52::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26 via Frontend Transport; Fri, 15 May 2020 15:04:20 +0000
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2131a718-60ed-492f-6371-08d7f8e13fd8
X-MS-TrafficTypeDiagnostic: CY4PR11MB1606:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1606A8DC65C5DDDD6D3F3C7E93BD0@CY4PR11MB1606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJEoiAU00Amr9c8aaG6ge5z0g4KoIscSRtDYYwko1Y9xG6B6cPulj0XzayBmqs4fl+PMB781rxqABrl3mxtla0HV732eDv5V4Gd0kIZXo6RO8uuAEmSBGbH1yA3Igmtguh0DIVvZPTInyxMpX2k9+l/a9Q0mOVf62yVKTsciTewaWhVlLJI5j2jBkRxYHsACEDnhscaLZ7vWvTfW2rkf5l8Xntmpd9P0Rm0jID0ogBuu9ZJd8c7o7FXde4WASDgaLk4njdKjx8ONT+V6i515reWBgfmdx4UoLYJMNzEiqtc6Yy2AK5TdlDTFXNYQG/NBeIs2nS9h1S72mE7ZLz13iqCZFoY3BPZKOxkwEZWQxdUEKvugupAB4izgaj6iA2+LPTYAgKy1bDBVIQXuAogq4Kpd7IzLx4Vc4wg1CYlZ5q5jRnuHlfczCh3Sy/e6qEOi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1766.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(39850400004)(376002)(396003)(52116002)(66476007)(36916002)(6486002)(8676002)(6506007)(9686003)(6916009)(6666004)(86362001)(66574014)(956004)(2906002)(6512007)(316002)(54906003)(33716001)(8936002)(66556008)(5660300002)(186003)(26005)(66946007)(16526019)(478600001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DSsthEvm9Kcf3E/U1C/TsbKrg6WpZsjhvUemb1I6UvLVXXffYKDZtFG76L1fPLTWeqgJX/u0upwFATmHxc7BqRnva+A6Ug3qFmePUQvXb8D3AyBGh4i5los3Yrpz+V4xkE9ckblQhx6SXm9F/KcIVMh6gTXl5jnwFT+955TQg/t1s05fUb3i5/ccInzDbFeAnkJrEXFN4jkA/xDVHHHp1BwOXy7ufdm8ehBtmSbtBtKrLHtGX7e5Ti/Js9n1Ms9x0Df5cmBJ/cgeHdYaxDzacX/BYe1xcgllW0TQt86DV/aCuVps1Haa0sOdurxk6L9OFO8CPL335bruWcy39iZvCOtGGdYY2hYaxvQIBHDpTjsEFjJfOWqpn3hOVC4YVQKw4QZn0+o2P1w5b70oXdqylCrDI4wJ8EXhXM4VuiXeLmWLw66dXY2nNOLRhD4UqZ3MALBNqZv9AyUYwj9MzfZMSiLOCyZlF/Cu5Y/q1bO0y/U=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2131a718-60ed-492f-6371-08d7f8e13fd8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:04:22.1229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roL3MS92I3wwr8RFifMibYvWh4qLs/ksnOx0HCOypH6zMCN578Kb+pL8Wy3p+efCWPmGTEdQ+3y4FpGfSkcwlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 15 May 2020 15:53:59 CEST Greg Kroah-Hartman wrote:
> On Fri, May 15, 2020 at 10:33:11AM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > The function hif_scan() return the timeout for the completion of the
> > scan request. It is the only function from hif_tx.c that return another
> > thing than just an error code. This behavior is not coherent with the
> > rest of file. Worse, if value returned is positive, the caller can't
> > make say if it is a timeout or the value returned by the hardware.
> >
> > Uniformize API with other HIF functions, only return the error code and
> > pass timeout with parameters.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/hif_tx.c | 6 ++++--
> >  drivers/staging/wfx/hif_tx.h | 2 +-
> >  drivers/staging/wfx/scan.c   | 6 +++---
> >  3 files changed, 8 insertions(+), 6 deletions(-)
>=20
> This patch fails to apply to my branch, so I've stopped here in the
> patch series.

Hello Greg,

Did you applied the patch called "staging: wfx: unlock on error path" from
Dan?

(I wrote that information in the introduction letter, but maybe I would
had include the Dan's patch in my PR?)


--=20
J=E9r=F4me Pouiller


