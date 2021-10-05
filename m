Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9953422CFA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhJEPyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:54:02 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:35296
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231513AbhJEPx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVGEMfLbCljqwnZs7lgIStaSWg7l8BNMf3UPEqFMF5xa3xfUn5ZTslcTdo8MaRwGyWuIbzY6b/+eTvFoXX/9Xt50sgX5Z7Ne6iPBUrJuu5TfspoODtEJbc5cCODdu/H8h8K/MWSUT8aLWSj7qlr43zEumBn3CHcihysxRmiH5eBOtXia6JkIj9EFEt3N3UAYFVvhN/Lwxm1jfhKQB+xnfehNGOTmBgfvZmHZ6MXCd90FVvt0W6/vbwWh4b3G6vgaiQwaEEsdHkgb99hiLHE968+8rLTFwggHhBHivx3KQL8ZFjjw+Q+8N/7Ne6el+7zrwkLRGLR7VnSqtFyF4qTJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeT0vEChMaif+4gBNAqFbjKsV+BifZE+jr0xDMov3vs=;
 b=XYfU3SrVhtrWtltVjq4TYHAPXywLk3qDAHQJQUJTlnTwrDm2ksM6a8whw8lZtAkF25d6tkK3FQsCOScswJDynRKedJM2BrnCShfd0A2infAQjrHTmXyXu8Q9d/9vZ0pkUc7Se86L1f1vB7SMCer5ETC1vHPHc2yvl1vqEsNd3EXit5OY/7B9o5v+eCwOifNsSJEVOuI9X92gWHn8fcK4i6GXtWxDsC8pQP7t2aXajbKB7AwD+guXb2WJ1hwPthMG8r8z+MbZA12UpGtGuw3RygOvJVyinqaf0hhLyfWr/BqKftuSnsif0Jtw+V5h0L+QVKJhw900SCDqbpDC11amJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeT0vEChMaif+4gBNAqFbjKsV+BifZE+jr0xDMov3vs=;
 b=d6e3UHnxTfGFooXsiod0ejy9EDWneQLyZB7Bomvap+dqc8iZWDOUXAFfdow0BFULlG3cjxO5QfNUsPRy2hyFj+veualodCIWrohyR7q/mC7e7NQqa0gO4XZFDzNpdRiYzf99reGHQXuTpC44qHfmZp8ERAJne/jGthliKfuGmmg=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5578.namprd11.prod.outlook.com (2603:10b6:510:e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 15:52:06 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 15:52:06 +0000
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
Subject: Re: [PATCH v8 00/24] wfx: get out from the staging area
Date:   Tue, 05 Oct 2021 17:51:57 +0200
Message-ID: <4889546.ZpuqzhuOv5@pc-42>
Organization: Silicon Labs
In-Reply-To: <871r4zft98.fsf@codeaurora.org>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com> <871r4zft98.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 15:52:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61939c2e-aa38-4e2b-2039-08d9881814f3
X-MS-TrafficTypeDiagnostic: PH0PR11MB5578:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5578DBD4282FCD775085C33B93AF9@PH0PR11MB5578.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p21ZfmCNPodqz51impDmf0ZHXFkzswqOT2hWLCCKUb2UQ9/RvkdLFCjbftFL8XzxaQRPGFrcklmS38z+LkQcaxVmC1/SUJ2jatCGFaJ6W3D45Hulb80zwgUF4UWG2KlMZyJOA08RwmStEeE0LrgXZvxMUtlDpX+hg+8zdCkAIg1eVcUJlUWTZTcL5j8vtvPXLKRpjrydBFo5uPy/pEXsYX+pczp/hnZjxPuQf1J9GQDRl51dCStPvPGbuFj7OkpRJ2Hp80vUeXFXJATY+08IsZC57SFP1o6vKCe0jpHVXFM03OB8fPjuZZniLbf1ha5z2tltj4UKhdlupcemMwsGL9GV+sKktiBBnRWExddOhjKidw795kGI/sV57HaLsGCzHubCrHk/920V1kHoYFHagnMozcy58WNLXnS2kDYcRo1wGS5SSWW7Tl9Rm/RkRmjgeTQ/Zdk0yGnrBSXXXyhzO91ymIjTYi9jiLlsh7u/VQg94BIOoF9Qn0NWQ4lc1WJXBX/aJhHP+2tf3bI3ErKzvkRZgJ/xdtap5SmsYeEsFEUA9YnfjznD//nHVjV8b6OgFaYP/9xWKPCC/R841jUheBx9uqzGNoL1GmUoasyLg36Y+CNhslkI45FV8dyW5BTnhZRL+Qh0dwcNouZG5VsVxjO/y5ZvjxNmVzCpk81Kxv3pbNLnweiTvPQUfBnz+BkDGqpGoa5hTjGSTlGOFsHQ6DNFXVMBMyNzVgLG+72EAYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(956004)(66476007)(6666004)(6486002)(2906002)(83380400001)(6916009)(38350700002)(7416002)(66946007)(508600001)(38100700002)(66556008)(8676002)(36916002)(52116002)(54906003)(186003)(86362001)(4326008)(33716001)(6512007)(9686003)(5660300002)(316002)(26005)(6506007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?OyuMHW3XwZO/30HFEQHpaZOGca9yJ7joeOWtRvHDcDufB32V67ASSF9mrI?=
 =?iso-8859-1?Q?OgJfUMWUTlpnMdYBILDu0zVU3HMPXNkORlIHKqdZlJzb2EzH/Vd6qp895p?=
 =?iso-8859-1?Q?WcU0veNYvOdaEOMc9n9lmztxOCpC+K96jBxznhePQ9ptefciRZpU+9x4Is?=
 =?iso-8859-1?Q?SssXk30lIK2wlh51YhfqLpJevhGhRgDf2sq/wUgOU5tFr1mVmeDCVtxl9H?=
 =?iso-8859-1?Q?OG/mB9nNDZN9mqcHPB8+ov9G/3sTZLHakHd9Fw7EzdUzng6LaSRx6VrmqW?=
 =?iso-8859-1?Q?ow5OlbUshEKAEbglptgVJNnH5jaT/KnvuPHLx7zPNXhdoMWl9RX143sC0F?=
 =?iso-8859-1?Q?zGWDjVo3EDPi2ADdvtIFFJjvimjJYseEfu4Gceg4/R7RXfTi9RJcuVlEZS?=
 =?iso-8859-1?Q?nsgZ9CJ3IyMpsj++OKxyh5vHzvu1TkQYNmF2wiC+yNhx6TcX83cDNkddWX?=
 =?iso-8859-1?Q?V2HN43DTpaRGBjlqQE0VWK3Z/RdwsPIiveqy5hbMylDQhFXCLhy0qpYXjv?=
 =?iso-8859-1?Q?ubjqROzgAbSUBkDKZ52az2lgt2KOzT/ONoqiZBXLFH4sv0m1VLzKswwM2X?=
 =?iso-8859-1?Q?GBuUlVmkcHMR5iaZ4zI/2jNF4uXVF/j5NdZ7giqEgZti0Zk519/2kX/j5W?=
 =?iso-8859-1?Q?x8Ut5bvcsc74S1jJglLkwUt0JqZuVXTuF+KKulTY8KzlnPZYtaD0u/u48m?=
 =?iso-8859-1?Q?SDHHD7uRdAJwBmyhOIYrS05Xxfu74pan7AZDKUeLJbTpNMTDfvHlTaneif?=
 =?iso-8859-1?Q?cWG+hedlSXKAVRqauWg7/18o3BWy36ldO+ORb/eJ74dkg0SS1nagy8YNyF?=
 =?iso-8859-1?Q?Vo8sJEtYF2se6d7BFk8SRtM2/YhDjiqjS8lM+kIr5TSgYr2cer9x1nqf/z?=
 =?iso-8859-1?Q?TItJpPMUVxm7uajejDyNSPDBGuTIXDgApqsyTedXypG9RNZxQmqJAqhznd?=
 =?iso-8859-1?Q?gS0JPpIP2fA0KZyN1RHjrDy/5+1BOm8UU59Vep0fvE8INiUBagHfMjt3Ds?=
 =?iso-8859-1?Q?vH9IIn3BLMk0vHaUaqaVoDZsEkudvoWpTNaS8wAfwyVCsnle8dJiMZBoRd?=
 =?iso-8859-1?Q?I7YrSHgzMLlpfXkOQUnNdZH+QXomBk+jMgc/f4cjVQ4bbg6QIk3WWmnZyF?=
 =?iso-8859-1?Q?w5t0NfDEX2x1NOEjG/i3avsSHatznSF7nNyUJE5HqK1jJX0HZ1qDFTKVPo?=
 =?iso-8859-1?Q?BBUuo3c3/qK3WapPEUtD6cG8QVkp0la06yvj4Dk4KWZ/+hmuX78Why7xhj?=
 =?iso-8859-1?Q?QnFIoeackBsBkUzb5eU/pjKpSelpAJc7QAbKopWYB32Wt+FijpB5D3rvXc?=
 =?iso-8859-1?Q?q7XhLZyqVt7pZ78ID6cn8fXDdfE8/xNCJKnsbqjNUic6YP0kbOdkwFoeeu?=
 =?iso-8859-1?Q?C5oegqADDM?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61939c2e-aa38-4e2b-2039-08d9881814f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 15:52:06.4474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2sm+SNyVlESG9caz3wDZ3VOTB4iNUcE2Tn0tw/xZk5v+oRPkaF8sUy5gR++Aqi2bqpPFTFFRBcl+TvHROfNZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5578
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 5 October 2021 16:20:19 CEST Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
[...]
> >
> > v8:
> >   - Change the way the DT is handled. The user can now specify the name=
 of
> >     the board (=3D chip + antenna) he use. It easier for board designer=
s to
> >     add new entries. I plan to send a PR to linux-firmware to include P=
DS
> >     files of the developpement boards belong the firmware (I also plan =
to
> >     relocate these file into wfx/ instead of silabs/). (Kalle, Pali)
> >   - Prefix visible functions and structs with "wfx_". I mostly kept the
> >     code under 80 columns. (Kalle, Pali, Greg)
> >   - Remove support for force_ps_timeout for now. (Kalle)
> >   - Fix licenses of Makefile, Kconfig and hif_api*.h. (Kalle)
> >   - Do not mix and match endianess in struct hif_ind_startup. (Kalle)
> >   - Remove magic values. (Kalle)
> >   - Use IS_ALIGNED(). (BTW, PTR_IS_ALIGNED() does not exist?) (Kalle)
> >   - I have also noticed that some headers files did not declare all the
> >     struct they used.
> >
> >   These issues remain (I hope they are not blockers):
> >   - I have currently no ideas how to improve/simplify the parsing PDS f=
ile.
> >     (Kalle)
> >   - We would like to relate the SDIO quirks into mmc/core/quirks.h, but=
 the
> >     API to do that does not yet exist. (Ulf, Pali)
>=20
> So is this a direct version from staging-next? If yes, what commit id did
> you use? Or do you have your own set of patches on top of staging-next?

I am based on 5e57c668dc09 from staging-next. (I have not rebased it betwee=
n
v7 and v8)


--=20
J=E9r=F4me Pouiller


