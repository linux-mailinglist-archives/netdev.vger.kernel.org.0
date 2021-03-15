Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0F933C18E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhCOQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:21:57 -0400
Received: from mail-dm6nam10on2085.outbound.protection.outlook.com ([40.107.93.85]:30689
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229713AbhCOQVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 12:21:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDCa+FE2SlNaPQZOlJdyY5wCifHM8IKCs3WVGb1N1OqGuVMeM83Gm8/1ElstNISO8BdPp35CX/vQhZPDtb2jdZW1fHle5PmCYBk5SqeKG1u8XU7YUchQtQvuZtGguqqukTCQ10xjLgs56WcJYZvF+rTyZSEJot3hAAW0gsrtG3xkCh+cFYgRRtgPKXA5IeK8B51NPA4huAYJMdBRH6SCxa+R2XQI3hUBoapUjHFgjRDQcDSCFV6bUItDR17v/nRspRS/3okxAToDWoduSrWqByED+cW82h5Q+6UdECYS7PGpYpUSrTiFxslKzG1YAdZT6gHG/QxaylkRDANOMxHx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6pKbWCmNSZ3xR//zdNy6w6dycO84GzoenS4inDxOQU=;
 b=BlIptnu7x2DdZH73AxiOB3R9D7da9EZaq95OV/DoN+F+Gc02I/v6LuQxUSI5hTP0ZW/MvuYkUwl5XN25rOJKWHnEeZ+l+MRKxB0KXZpJlJQR53i41ZLW6Mlv/5tUMOvSjjz3CJgGon7nq44HpPxrGVCc1bxa+j3tcMc1QKPlGy1Cb/JwbK4aIVvDAwzryF2O2I6s3O9V4q2d7fT0RYyq6ocXgJYAZrKReBZFk/xL3cfK6zR8EkO/GHmuVlveNMn41gs0xyTIkBcTrLZBDYSp+Cg9Kh3bZAbGzl5YOMaalw5+9uTYYTKQwNHKEYEY8hKFifp9Y57YA/Nci+WE39h+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6pKbWCmNSZ3xR//zdNy6w6dycO84GzoenS4inDxOQU=;
 b=mqx7cnoFjywfJJBV6UMt9zaF9EaAxPoHulLhJ7MzAyWy3Dmk+dcw0KUStxfycGBwBqi0vDiB6rL0LUxkme5HCeFN6GZs6MZLYv2UghFluHF3QWWARozaHg+x21rj4z0FN6TM+X3kJ6hVgHLGzLRqylviULil845knT6qSlhq1Dg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 16:21:41 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 16:21:41 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v5 03/24] wfx: add Makefile/Kconfig
Date:   Mon, 15 Mar 2021 17:21:35 +0100
Message-ID: <1718324.Ee3sdLpQUQ@pc-42>
Organization: Silicon Labs
In-Reply-To: <YE95OCx5hWRedi+W@unreal>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com> <20210315132501.441681-4-Jerome.Pouiller@silabs.com> <YE95OCx5hWRedi+W@unreal>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0501CA0026.namprd05.prod.outlook.com
 (2603:10b6:803:40::39) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0501CA0026.namprd05.prod.outlook.com (2603:10b6:803:40::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Mon, 15 Mar 2021 16:21:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 451c8c1a-81b0-4c90-1211-08d8e7ce6aa2
X-MS-TrafficTypeDiagnostic: SA2PR11MB4988:
X-Microsoft-Antispam-PRVS: <SA2PR11MB49887E7043FC68AE05E2C8F3936C9@SA2PR11MB4988.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yws90bhY7xZB06uSIhmcuEWtAZ63WoYzyK0MUb+0pzsj/WmyAbNcYx/YR7HhfXCOHnS1rUpCektCjJbW62+Ay5wvQlhtPvVDysJ5Ifm6NkJdFH74xPXT7lapKd0Kz+nIZYhsBfIPjobLyBr6JEoIzKt55WtaZ+vn6cua85UPycYIEhn5trspHvGo3DAtQrDpcXRP/v6Fh2+ISZ+gR9Jojs6v9TXbgM55wLl7l/5VNOZrtveYgpnXFWdZemL209OabFmVnopSoy/2ZT3Sp7RORgMFlZapf5z1WyWJIWnFexc7W/zMIpCvOfV6AZZZ8WW0bSAR7nbXovl7WdGQaNdIZKVaJCE10gKWMTy23VZntuHZvt1SNmJTHqJpcA7NjTHBoDrLLy9DZpmgGmKwSyqlKkzKP7byyueXxcEYzqndsDPPCfkmmHsO4JXSSh9HYMrfn/wIMdFU93IDq3/aKYe0ewoHF11XjMPEQ6U3R/L4zXCYeoLhEns3O9pE74eir2JRhW+HVPIQjIJ4xOr8iCNsr/Ul55qkRtj5Oe84IEW/8MsbtNdMcQPxauA4UGtZ5fVfWwiHF3nRSdFsFV5odFq8DAKjacwRuwF8IF8qdqjqa8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39850400004)(376002)(346002)(8676002)(54906003)(6666004)(8936002)(6506007)(66556008)(86362001)(52116002)(5660300002)(4326008)(66476007)(33716001)(7416002)(66946007)(16526019)(316002)(186003)(36916002)(2906002)(6486002)(6916009)(478600001)(66574015)(9686003)(6512007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?DILDYqzm+VHU4BPrXmUBks5XwLyzWFfeixSsbRj6NmlrYIlMRACdRhIxTv?=
 =?iso-8859-1?Q?Z82Leow0o/BG7O1NbRc6lxrxqXF7jJLeMGsH8XLiB3r4+olh7Smy/iwu+y?=
 =?iso-8859-1?Q?CgYgIiBIWpNvHieQgSw6RKJrxpXUTLTpJeDCOe1aNMu4BXo2Uavek7qBB5?=
 =?iso-8859-1?Q?5rXPPXyumC2tTzp+8uxEVJJ0hJFiN7D4rnBxUwxa0yzT+PXlZsPd0xWmFp?=
 =?iso-8859-1?Q?5fDdUMIQGF2qlqsfhVngHb2Fhr/N1UJHq4do96XqLWhLvTU4x+Ckx4X8Yy?=
 =?iso-8859-1?Q?YWUKXcXu/gIC4JlnvheYTDhIrqajA/+7W1GSGA2c+bnpk+q061peR9wJB5?=
 =?iso-8859-1?Q?KQvmp3bcvkEoYxgbjPMaOAk+gl9j9B2VWBP8t5pptyXH/hWi/JiUyk+uoM?=
 =?iso-8859-1?Q?1P6D4r0F6zP9YiLIrLdJk+PJutu1uj2Pr2E67MtZr7xAif3VTYMqNk9iMP?=
 =?iso-8859-1?Q?qoWMRYHhaQcRYJ7VJuOwtgLPGwcISbP9wWs+byq4aaIy4yRqYM3kG+HZAr?=
 =?iso-8859-1?Q?AfvopAOlqS6aL85t0ww/RJIEpjPMPl/nl91vcF/KSfVhHa01ophcx4Z4vy?=
 =?iso-8859-1?Q?4fy0tGebNUgOuVcN/3HKTe+Pn8BkOeNOxanEOUvtpB5dGjlQnozYBL8iG+?=
 =?iso-8859-1?Q?Y7Ixxp/ePO52Iep7jPdzmtn6XAEK4/Qp0qZf9CIKGfxsGqEoh9eha9aoBJ?=
 =?iso-8859-1?Q?yisS49eyJQEKEmJ8K4Y+3qFRa7oORjkXSzRnvgqxnylluPiXLDqruhCkuT?=
 =?iso-8859-1?Q?Ckk4q47RSAO0zeJ2Gk3aAuCgoK/q+yddW/MJhYos3NfKn3FcGjVV2dF/2u?=
 =?iso-8859-1?Q?7SsGgNgYjtr85FfEQQvQr0p+iNnsYfP4GZFiGc0CDD2IC7DG5YpJS5Kenc?=
 =?iso-8859-1?Q?697BsZ/G/StSDc/tPGNO/EJjNcyfdwxKK0ei0GnUDIUIDhtKzzHpHzhguT?=
 =?iso-8859-1?Q?YnXiGnfL+catHna5MUSo2kiCfYo1kqsGTUq/Fa0YqkKe+vMIMisio7AqYh?=
 =?iso-8859-1?Q?a/cK3+Ltjl72/eyqxqHgcaHN31VO+uRuz7wFhRgBlHvHsgs4npzTJICFBX?=
 =?iso-8859-1?Q?lQKPK3x7K6b17HPDVYBL25B3Es0QGIXWQpXsy53nTtDuv5kLJL+j36uV7o?=
 =?iso-8859-1?Q?bxrMiiVMD2SW3Da8righAZuc36OnicNJpCPseH7Sk6kV5hOHuS3R2CCYO5?=
 =?iso-8859-1?Q?tk/AGX4QNkG1cy3phnWBJxTHHsuY9XrzwfWD6K9+NfPqfyMwKx9TMiOZ/N?=
 =?iso-8859-1?Q?IZx4TvStiq8U2nGUi1EWLmQIobD8GjNOb4pXOUwNnM0C1knYOI6ay2h0Hy?=
 =?iso-8859-1?Q?P+u1l9xOcDVzcyT+3EuQ8UDWmsnqRMU1D++ONfcRUxvQZHXSgQbIGpACCu?=
 =?iso-8859-1?Q?E8tj/Z9L7eEkYW6g9u7TykghXsl8vcBxyS79rcruEkf/rKKdPBZbnOavba?=
 =?iso-8859-1?Q?X0WuAob7VhoG/uPh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451c8c1a-81b0-4c90-1211-08d8e7ce6aa2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 16:21:41.3869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEZxqvngO1emAD8foyJ5z3zpRwjozA2ncoA/rlu/pRthwMBXqaTST/ibg4VA7n+4KyK67v1FbnQdlwnhAiLmJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Monday 15 March 2021 16:11:52 CET Leon Romanovsky wrote:
> On Mon, Mar 15, 2021 at 02:24:40PM +0100, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/net/wireless/silabs/wfx/Kconfig  | 12 +++++++++++
> >  drivers/net/wireless/silabs/wfx/Makefile | 26 ++++++++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> >  create mode 100644 drivers/net/wireless/silabs/wfx/Kconfig
> >  create mode 100644 drivers/net/wireless/silabs/wfx/Makefile
> >
> > diff --git a/drivers/net/wireless/silabs/wfx/Kconfig b/drivers/net/wire=
less/silabs/wfx/Kconfig
> > new file mode 100644
> > index 000000000000..3be4b1e735e1
> > --- /dev/null
> > +++ b/drivers/net/wireless/silabs/wfx/Kconfig
> > @@ -0,0 +1,12 @@
> > +config WFX
> > +     tristate "Silicon Labs wireless chips WF200 and further"
> > +     depends on MAC80211
> > +     depends on MMC || !MMC # do not allow WFX=3Dy if MMC=3Dm
> > +     depends on (SPI || MMC)
> > +     help
> > +       This is a driver for Silicons Labs WFxxx series (WF200 and furt=
her)
> > +       chipsets. This chip can be found on SPI or SDIO buses.
> > +
> > +       Silabs does not use a reliable SDIO vendor ID. So, to avoid con=
flicts,
> > +       the driver won't probe the device if it is not also declared in=
 the
> > +       Device Tree.
> > diff --git a/drivers/net/wireless/silabs/wfx/Makefile b/drivers/net/wir=
eless/silabs/wfx/Makefile
> > new file mode 100644
> > index 000000000000..f399962c8619
> > --- /dev/null
> > +++ b/drivers/net/wireless/silabs/wfx/Makefile
> > @@ -0,0 +1,26 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +# Necessary for CREATE_TRACE_POINTS
> > +CFLAGS_debug.o =3D -I$(src)
>=20
> I wonder if it is still relevant outside of the staging tree.

It seems this pattern is common in the main tree. You suggest to relocate
trace.h to include/trace/events?

--=20
J=E9r=F4me Pouiller


