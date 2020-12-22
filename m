Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196E72E0FCF
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgLVVUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:20:42 -0500
Received: from mail-eopbgr700072.outbound.protection.outlook.com ([40.107.70.72]:4609
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbgLVVUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:20:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2pbrt1/B5Ys+UNTwcxW4TuP1lv0WurkOCA6a4SAan/LNINH9tthxG0AsKw1qQb8fbtKYMPkHlfSPDx9BN5a4yNN6f6+mLIVU1hrqUUHj6iAmXiBVerfbEIBquEPQP1MleefR7EySmBRAlUaAvhk/lwx/bIvnvufb1mwZm4xCb4zfObrk8ODIhsZe+G/zR71jOFVdDmR21G3gImcONaYf/6wAP8A3rPHWVr5VOC0X7uoB/W3nG2uY+m3nHUG/pHUNMnq1fDuIi52Xs9rQh0tuA6ax2mTXxZX6orl0gszOmTwafL8dTe5qhqwUd0UIbHmrDPUpeJE59OYJMsHIZ+Gpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2H65VfoglVU7uCSWkPYTYyM4ek3Snpa6OxsdklT6its=;
 b=n2Z7gEHFve28gL9OPy9GjteE3QqSG+878WjU6q3vvCxjLD3paiSP3tdFfgnGjSjL6t3W+Q79yqwsSSPAhGsgWl1G5ikqwlJIN297Bkk/EILRB2WGQrtMFacK9yxYu6dcyN77ipXZ0TubMUy7ATDoqJOQQcHpybZXMFK69lAcnvQqL6lpTPXmRgPrlEoqywMVnd1OYXoGr2NAqa4Aa0VJHFftKi4HMFTA1Da3ZNFpNpTGENOKiieIY98gMDMWCU3joaxgJUvUT4qMRMj28ZqQe7RegexG6oWoNc9elQt7OLYNb5KOcCTto1GZOwhf8zWmgX0uF5dCjxJ9pv488R8s7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2H65VfoglVU7uCSWkPYTYyM4ek3Snpa6OxsdklT6its=;
 b=FPJep2fPFh0RMvMPoIQnpmPioHm969i2eTNjWZkwo485WzE+m53bY/Y+UI8DwwXQlddkGs9H5eCRhW3NEq67qfBgZhzbikbdAkCJg2rHomFlihU/xFw3VY51shIHv17ACKNqTC4jYk1gwHpmHbb22BJOjxBGOMxBM0YFzFZUlek=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Tue, 22 Dec
 2020 21:19:56 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Tue, 22 Dec 2020
 21:19:56 +0000
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
Subject: Re: [PATCH v3 03/24] wfx: add Makefile/Kconfig
Date:   Tue, 22 Dec 2020 22:19:52 +0100
Message-ID: <9810105.nUPlyArG6x@pc-42>
Organization: Silicon Labs
In-Reply-To: <8735zxanox.fsf@codeaurora.org>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <20201104155207.128076-4-Jerome.Pouiller@silabs.com> <8735zxanox.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:806:d1::22) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SA0PR11CA0107.namprd11.prod.outlook.com (2603:10b6:806:d1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Tue, 22 Dec 2020 21:19:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b92f5a8c-1311-410b-1ea0-08d8a6bf54f9
X-MS-TrafficTypeDiagnostic: SA0PR11MB4637:
X-Microsoft-Antispam-PRVS: <SA0PR11MB46371B6EDD267A3FA9F578A593DF0@SA0PR11MB4637.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99L3hI0mk1ojn7DljnWCRGwU5Gbcsq8/M8e7iSIULRjVb7ix1MuCoaQXpzvkDdZpJq4s0ZpZCMz8HiAjkEon39LLcRTrCnqoT4WsqThH/RfCz8W4asi7f53FtpyBNEnaZbO1ME/mM3cNNhsM3oV93bUs3oU/GYnMeA5TqDNwpaqHPwreBnCEujniXtvIYHvFwmjmAq8LUiqhfzu4K6kihEii8gk2icXCDkYHv0qWA3LObECwD0Oz18oO2BMKQcXU6QAXJ/MiWTxirpvAMmaIafOJZv792XA0tKfR/MG57ZEC7jBekPVLrqCdkKl8/dd/rrKocGJld5aWw5Y44qsYOU+h7ADUIdi/yQbXQ/76xthKi5vMXBIfFtSq0yENgAS7O1aRcvTIl6dW2F4hsjgpkyENOeSwwhXVCtxgjyEa/WIdyKaGeyfDza7YBpiNRVMO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(346002)(366004)(376002)(136003)(478600001)(33716001)(6916009)(956004)(6506007)(4744005)(8936002)(5660300002)(26005)(8676002)(52116002)(7416002)(9686003)(66476007)(2906002)(6486002)(54906003)(66946007)(66556008)(6512007)(4326008)(316002)(186003)(36916002)(16526019)(86362001)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?I5u2OfllaY56m+hmFlXAWvgcUAOOtQA86eKQd79alU8pfluDZ8Iys2EEXK?=
 =?iso-8859-1?Q?8jT640Hq4ZlUa2Kh0x4CwSHabWWoLj8J68qjXVerWbuOBB7PcTwJfmoF2i?=
 =?iso-8859-1?Q?leBVDveU39TshGxpdArXa8B4TccR4oVybyvoi35nIPL/CrUWNLxiroo1B6?=
 =?iso-8859-1?Q?LxvblEytecMm5h5I4FDqGubCpDdAUS3b9e5dfKBOO2gOBfpEZ8nB8P14v+?=
 =?iso-8859-1?Q?Ua8jvXoYVJ4DXct5vDIF0GDJPjJw9lweIfBehD8vgbD5nemWOCn78AamQF?=
 =?iso-8859-1?Q?X9kyxlRUh93OL4nCYl2UMKs5ZIl1pA/oviEQBxK35JzHDxBjRebqp1iv5E?=
 =?iso-8859-1?Q?Ahi63E4yoGiRQvLU4hYUkvYWiEwd2m3xMcFlyTSUaJjbb/utHzMaXtAoE9?=
 =?iso-8859-1?Q?jpqCz0EMH6UMuJfzERPGBFLevxUeCMxM5u2GstIcMvt9osz0wptPOuHD5N?=
 =?iso-8859-1?Q?JtnKsMHXDlKJdld31fNuHzVLwAxARMj4K5HYlePYirCZxv7n7U8fn0QxBq?=
 =?iso-8859-1?Q?M+ZQXQsq3ADxJRRquJrpQGxopGm5i69RcIe7j3IktoGPJPWWkoH4sEBW6O?=
 =?iso-8859-1?Q?jIUt8FJXw672D+ZzwXjks7FvAANoRtpNoP+QMHGEe2qmqjNFepChU+CjLx?=
 =?iso-8859-1?Q?zigrVIY1wCjeYjs6zWPS2PzVuc1nN4LjEbjXAMTzEOqJmUQbGPaTsOXkQh?=
 =?iso-8859-1?Q?Y6IM/A/YM3YJQeIVD5rRjYuVoDGK/VlIZwcB6z//A2EjLHQHszjjKDS21U?=
 =?iso-8859-1?Q?BkRdL/Mu2rfweiyQ0USMcU+L1pmDDbOlmaoNDANaWf/o8VWK8+B3SyZ88Q?=
 =?iso-8859-1?Q?PunZNZEQvyRHW2hsN+KkK+xL0JmEkK/b/dY1pOBQTzO71xus3dDyYdHgva?=
 =?iso-8859-1?Q?cvRRRRaCcXtRwA08f+av2IimpGFDqCkSP+2O/HNFvdJKnEENKykr5ICB32?=
 =?iso-8859-1?Q?j3woVl47foVC+HUWHJQTim57KAE1Gk3E4rEhx3WZIQGZS550J846FgBuf5?=
 =?iso-8859-1?Q?c43PsLsbzcWNQvbtnegowQXLdaG9Hpj481bljI?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 21:19:56.6702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: b92f5a8c-1311-410b-1ea0-08d8a6bf54f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: monzteXiqpMyUZIaNGqy05B+TKQm/6QViz8sb++VN4c4GESGhxxXHqfFrgCoyS897kp440lEPabD9wK7zQEYFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 22 December 2020 16:02:38 CET Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> [...]
>=20
> > +wfx-$(CONFIG_SPI) +=3D bus_spi.o
> > +wfx-$(subst m,y,$(CONFIG_MMC)) +=3D bus_sdio.o
>=20
> Why this subst? And why only for MMC?

CONFIG_SPI is a boolean (y or empty). The both values make senses.

CONFIG_MMC is a tristate (y, m or empty). The substitution above
ensure that bus_sdio.o will included in wfx.ko if CONFIG_MMC is 'm'
("wfx-$(CONFIG_MMC) +=3D bus_sdio.o" wouldn't make the job).

You may want to know what it happens if CONFIG_MMC=3Dm while CONFIG_WFX=3Dy=
.
This line in Kconfig prevents to compile wfx statically if MMC is a
module:
       depends on MMC || !MMC # do not allow WFX=3Dy if MMC=3Dm


--=20
J=E9r=F4me Pouiller


