Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A8D2E0F9D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgLVVDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:03:03 -0500
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:41697
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727692AbgLVVDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:03:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc8hhHoUqK38dmIebdv/PgYpb8ywtmhNdaX/FXrv19yOwGm8Gncv8fBHZpe8K6PSAA91UdPZjV+HJfNFOZ74NmUkVQnBwdsekeYqjZr8yZavV4ukANgRNEn+xjz5KqepN+xawX2hw8BCZZCkuy7D3wg3ARDqjlEHufmPpQXcFluc8uxXYpn7sVjZnLt66xv2Ggx/4kjmZZXEKuskwHhBKafunK6TlP6Bgyj3E1C9PlZ1y60iYeGVYYdTzuf0vByTNyJ/J7DuxlGzR4CdGp9puQL/fyDYeNKVsM0y4KLj8P1zm2HhA8CmjRHEh4ORfVbyXjM/qtDTMtYFOIOn+bZirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHsjut5DNGkwXAKDfSZC3xWJmrqZvlfP4INWUtgpYvY=;
 b=DqFssqkvr8Hngs1ZbRsWZYYqI6w4jninN3YSato/EXyw7PUlEBHokKguZQKeFz2YmsyROi5NSu3iHwlTH6a8aDaOOc2NzMrNu/lUUnqbfsz2wBaU+6fjvcX2Mf2/AvG+sbEYtYJaW/WqUD3q8ekVROdXupafMgC5NnKoEX3y/jck4fw3wluVwogBd1OiK3oojFrXewhUpaDPSb7MNIdUvt3KF8MmvQQWAMY3XwlQFEi1eYKauz22UfHTm8BP2wzTkWDVY7MzPkYqfokstbe+PoV9v9g7jGXNf+UpgOSM7HDIy0CBOayrHjV7mM92O9QCHvAZQzknqbcboXbujqxnZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHsjut5DNGkwXAKDfSZC3xWJmrqZvlfP4INWUtgpYvY=;
 b=h6Bym/+iFhNDYhwyydNawEDpj16r9cRbmgdUaxIyNa1fAiZzIbK63zsvuOLWYD0kNK2YPeqNfwGPItzz68VQeD/9QWfoOWYc3cuf+cJmaeagjn4JbdOCfWdyxe20VfnOB/bqp76GAfyhjElqVxyaCoEM47Eu9GW0V6BGux/eRs4=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 21:02:15 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Tue, 22 Dec 2020
 21:02:14 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Date:   Tue, 22 Dec 2020 22:02:09 +0100
Message-ID: <4279510.LvFx2qVVIh@pc-42>
Organization: Silicon Labs
In-Reply-To: <X+IQRct0Zsm87H4+@kroah.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <87lfdp98rw.fsf@codeaurora.org> <X+IQRct0Zsm87H4+@kroah.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR13CA0181.namprd13.prod.outlook.com
 (2603:10b6:806:26::6) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SA9PR13CA0181.namprd13.prod.outlook.com (2603:10b6:806:26::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.19 via Frontend Transport; Tue, 22 Dec 2020 21:02:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e92abdc6-a474-49f7-c018-08d8a6bcdbfd
X-MS-TrafficTypeDiagnostic: SA2PR11MB4988:
X-Microsoft-Antispam-PRVS: <SA2PR11MB4988C4324D97CDE6DE76E44793DF0@SA2PR11MB4988.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Jms4IfIg+E7TL/WqieQwR6kIenKxaVL/onwlr7ej6D8rTbYtOQQ9Y2JGYTkNLJlHD83nL6bQABbKQ93efPjtdetaOuw8sDZWpAy2dV1Q4/Z6v3Dbjta1SJRSIHrYCI+8yBRJ5JApNxmAx+Ltjdzi39I7Ix8vU6lo4l2GTMwaENLbzwJAKRMC8MwepYRa/ixXYzai2TP8+tQBeN+Bm0uJYCTyJTrUM0robdlyQBNBxLjz539i0MhJLxFpFcvTTFv8ZA8+QG+v0DOkLy2iXR9Cco1IOswaM8IvqOU78gkR9Gx1K13My6673eoJfFOjIFfaodppdSLNrDl05QeHb9ciKtwQd96c7CAEcYRcA/Qirs6vf5pl5yj8ZeyyZUU/i7EVzYXaU8LLBi01U1nuWCg1JzJ/ACmR5R5TRVt7zqun05wTktPVdnINtz8bXHWtpB9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39850400004)(396003)(66574015)(4326008)(8936002)(6486002)(2906002)(6666004)(8676002)(36916002)(83380400001)(16526019)(26005)(110136005)(186003)(66556008)(6506007)(956004)(7416002)(33716001)(316002)(66476007)(86362001)(9686003)(54906003)(5660300002)(6512007)(478600001)(66946007)(52116002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?QglQq2GR9IhKbtmd4ZG4Eg9LSLIsh7NdxHlKQ42SreptEPwG+VcOa9OB+3?=
 =?iso-8859-1?Q?uqibh72xrmnsQBfYOG2wiMfir8ztal4GM4dsHvKsh2PTbvbESFMWrc9wti?=
 =?iso-8859-1?Q?1Tk8M8wpjh9KsdXlq1FL0FUOAP9wZqQSKrmqMBPZzpG0JRj+rVV1En82/a?=
 =?iso-8859-1?Q?F/gcc38XE9nhfW4zjREGXFXyjbRUHCin5qDmNVJlOQaLEWDhyUi2ABWH1s?=
 =?iso-8859-1?Q?i8H93hgiP2usH13JbNaTnINIhpnK4dKKNkApQeKLeRcDrDfQdzyM/G0q86?=
 =?iso-8859-1?Q?E9C5KsK+sreSXa9Hgvc0SbZbxx+Ob43C23EXGUk8BYjZBnPwSlce0bbe23?=
 =?iso-8859-1?Q?S7RTLeAJbkHSX1hWVku2uON/jqRekXtXQtuFMgTMZP0oSDHe5+K/G6h+LR?=
 =?iso-8859-1?Q?UvxCrTIVkRNNNNU6jrHBTzKJhB5bWBvSDX12FFzhoI+WmuR0aiNqO85w5A?=
 =?iso-8859-1?Q?lZsagWyZjO7R04G5WHAmA7WbN2itgAS6pDXpXZSeb16dm8t5ze0wPTVYG5?=
 =?iso-8859-1?Q?IrBUQYF8li2/s2UsMpf9N9Lo59odmBUFx98hHJf56Sr6tF9NCIYLyCE+Ws?=
 =?iso-8859-1?Q?LCx1plNznB/sGgZPms52Qezb/9Bez6wSxntPFki9z9HgP/v98ajJ/EVQ06?=
 =?iso-8859-1?Q?assSVYBkj995HdQJTMM3B15G9kkxQi2ufoMLfD4Bu4Gk0N/Tc1kb0CmdJJ?=
 =?iso-8859-1?Q?wvxOLd5RRdrQ8cUetQASNQ2fQiDpCICmMLJdSccrEPbt4AlCuZVdgOXdQ3?=
 =?iso-8859-1?Q?6fK+ycF21LAgM/OfDfvT4sq5h5px3JdS/wmQF/d6gCdKdVPBqRFSBlKJmH?=
 =?iso-8859-1?Q?/txiZhIqJdRPtZROqZgHQZq570dP+j0eezFaoq3aUYwjF5UoedZMEgR4vY?=
 =?iso-8859-1?Q?jHSOXqwkZ/yYu2+e2+mMr4SXEwycT8wR35sCqbhUlPhW+4Ebq1IUs5t9he?=
 =?iso-8859-1?Q?kH2Wc/t2B4ufxoTh75b+XmePEztnjdt0kV/1TAxDcxFCjAFIK2ymF9lG/z?=
 =?iso-8859-1?Q?nkVcaaFautBZef6o/VJ47Loe8k6pVVEAlVtlOq?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 21:02:14.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: e92abdc6-a474-49f7-c018-08d8a6bcdbfd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBJqPxn+nQ4EKOvhH6G45wWS0c+JDjopj+UyCiDcEF63+sfvc6V+7dT31rOPhWvRGMq+Ue22Txn7Lzu1DmH9pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 22 December 2020 16:27:01 CET Greg Kroah-Hartman wrote:
>=20
> On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >
> > > +/*
> > > + * Internal helpers.
> > > + *
> > > + * About CONFIG_VMAP_STACK:
> > > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA =
on stack
> > > + * allocated data. Functions below that work with registers (aka fun=
ctions
> > > + * ending with "32") automatically reallocate buffers with kmalloc. =
However,
> > > + * functions that work with arbitrary length buffers let's caller to=
 handle
> > > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly=
 located
> > > + * buffer.
> > > + */
> >
> > This sounds very hacky to me, I have understood that you should never
> > use stack with DMA.
>=20
> You should never do that because some platforms do not support it, so no
> driver should ever try to do that as they do not know what platform they
> are running on.

Yes, I have learned this rule the hard way.

There is no better way than a comment to warn the user that the argument
will be used with a DMA? A Sparse annotation, for example?


--=20
J=E9r=F4me Pouiller


