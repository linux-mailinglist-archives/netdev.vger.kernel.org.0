Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C062496971
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiAVClC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:41:02 -0500
Received: from mail-bn8nam12on2114.outbound.protection.outlook.com ([40.107.237.114]:38102
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229603AbiAVClB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 21:41:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUC5+NbE1e94xU4yzXm1tjhZrwUSHUmHUSPd/YLEZYO/wzaWM9TiLiCNpMj0oE35xohwHNcXkTUmk6q0200+ceowXAutzb1bru5hNJ1AD9tVVbisM2B7mK6C/f9phyR0xuYXAJ9l9hZw6FFZR1tsRKcGOIxrNvMRHiBxALsFH9pJOGEJsZzg+LoHxVosOhgSx+qBaEhn3e2mG2d3kp1c01UttWy+ZWTRAOji+r6NpaxNSawLu0A+rMcA/pdIbDArboayQ3xZMEs/LUogtz01f4/w3s+DOZL8OOeKVI7PUAIBXOuTbDMRq0vttFBdowTRZfeYS4F1k0697kBQ+G4gpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9BoLsPO+w5iMqzv1V8UMsCDJ7hsdYtEGuw7b+EzV6c=;
 b=RFtcrqZrAeTgVRzzMUx62lB4NnAfmN9d6ZVMIOp+zymI36qhdJMmUpr5+4sM55keFPAFvGV+YgrRnbNIkaw5spL5uoUXuHz3toHGF7iHjelGlvx9hJwV2LYUZpLEIeCgdxmugB48ptwRb46bcxtaWAz5XUF/UvSNOrzHsCyJHyAw9nKBCvchiJFXXEciiBjzil5ZtVNCp4ENUmb4z3LucAQl6TUpTK9UxA+uYrmEj6k9OHUMsjougsVu7/pi5D59i+44/9yP3sMAm3QYgzgrKSBQQ9KyIlyYRmlOqRum3nkxn73/sOpPSpx1f/km469lnoX2n0xJPfpUdXzt+Rh8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9BoLsPO+w5iMqzv1V8UMsCDJ7hsdYtEGuw7b+EzV6c=;
 b=WoBs6cUJpfo6gwWjPxs5fICfASy5VpyzYaELekJsGq3wI4sTL/2hLrIuM4v3qyML1oF19Ud/t8pQTUyMQJf8fDKjZfEnChcoj1faPlKm82XTAWIUFe2XDsUT7vmazdaYmpVfHtlCRQBiNw6mbAN1eUSMpkSkjprQfEKOl4VPNqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR10MB1596.namprd10.prod.outlook.com
 (2603:10b6:3:14::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Sat, 22 Jan
 2022 02:40:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 02:40:58 +0000
Date:   Fri, 21 Jan 2022 18:40:51 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
Message-ID: <20220122024051.GA905413@euler>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com>
 <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
X-ClientProxiedBy: MWHPR15CA0033.namprd15.prod.outlook.com
 (2603:10b6:300:ad::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66dbdd6e-d597-48b4-6dc2-08d9dd509eef
X-MS-TrafficTypeDiagnostic: DM5PR10MB1596:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1596ABE141B37601DB4C19E0A45C9@DM5PR10MB1596.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3l4RMv8CjpMmAjns5cYFLrTSzzaYEQGUEpPffjaFs1VDat48/zhvjkS6Yp85zXNE9p4rpQmkyFxaK1NPhJPZNvsyJkaSYuXEVqN2hBEmYE+hgMxtBYq/MoxzO++OAd3OqFvQmu81ij4e357pfgzRVZo5zO0FXJc6ys4FSDo35h2sl3fNgwGPoWGgLiRR4bq/g8WcLr0lrOSmU6DVwBIGiqECu7dKQTmP3Mxtvq48CsZB7KrNz5rtEwXHNzgV5FrLK4GnM2GqJ5NhEpCtDW17C8YK9qJZziCTnIDgY1C7YgYbs5Dh7aeS4TtqvdTzjUY88HRTdXtoSlFemGki07h3EeaV1jpC+quQMb0sEHPUDTAbI5VsS1CyP7q7L6yDMEeYNKQcoW3tFlrPoV3cTxhyQP1MzZQtnxlK2fovQchCVWtdD9UeupqgtsTW6/Si26Qxrv4Oj9FWjs3dLryvJcrlJxPWeHuUL3Yn6EznqXWGz4jjm2R2wiqPzTKM6wxCopwVhXvblmb79VqWl9AH3Np0//R3pt5HfKOnhytmi9vpIoMV9jgJka5acES3Pcg+lbq+/jKNaVwijd0U586H4lbMNMGq6ge3j/idtVTQ1tLB+HubiCfUBoSVdqGccOJKThMfSFxYxR0B0j/3HHZoD2CCIt3s56X8HieOzd0op5o+dR5il5j2oHfyNAIypUZy3fdwDmvBCBEz599iwAKlLOjBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(376002)(346002)(42606007)(366004)(39830400003)(396003)(33716001)(5660300002)(33656002)(6486002)(4326008)(66476007)(8936002)(38100700002)(44832011)(38350700002)(2906002)(66556008)(186003)(8676002)(53546011)(54906003)(7416002)(6506007)(316002)(9686003)(6512007)(52116002)(66946007)(508600001)(86362001)(26005)(6666004)(6916009)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mMtSS6OdGpKEDmE4XiM9Styg2lhHcGKOUtrM5lEthT/Om/idK1NyP1UF6o4U?=
 =?us-ascii?Q?ydyAV4cmcLbAphyCL2MQFpK0paN/LuNFQaStkwMMhqgJSB+bTgFDTrEkAie6?=
 =?us-ascii?Q?j2LmgUXxUjed81Zcqq3nvtvGOKfajTrN8/LJkFHBJ0cx4KcHbDQ+smH33onM?=
 =?us-ascii?Q?SrFINbVb9MZykcNqK3er6PK8BDUDluzFongQ2Hrmedy8WD4b2iDKRVznI5cV?=
 =?us-ascii?Q?QSrAysCg66KzBjjZzga6S5U17EhP99epUlQ0qvrfUQnZViSGkWg/RxlJYcqF?=
 =?us-ascii?Q?2RZxgSfVh9fCH4tvN73PHM26yNrHCEEqwC1HEXNkzrUh2UmdCRKKfQEzZl22?=
 =?us-ascii?Q?tGF3Ec2RmNRhNtOoSoQvKPchuUDmYU5GXjC6eJIDdfc25fzCu0XZAt5Cbx8t?=
 =?us-ascii?Q?arjC7ngf4uq41oQUCEEfmZa6pXi4bDC8yyw/Kdft6hCC852OHa5ZPpUZ/SY1?=
 =?us-ascii?Q?bN7uV+snG6qRnH0AlXrmZUjJA+ITC59S9/MaCnwZzYCWI9+hZz3gidRBcupm?=
 =?us-ascii?Q?vpCfvmkgGLZTgSIou/9V8Lo9Ple1eYR41T2jXLrBksnPM96q9BgJr92mvong?=
 =?us-ascii?Q?szPyyjFozQuCKeljpQSXw926QFxFeQmed1P9d9Ox7mXJgJTgvedVUCc5fyGu?=
 =?us-ascii?Q?emSjdr/+gYeq8J8Mhoyh6pAunhOI3r3FAwlbTLcMim1h2uQUoJfHn7kim+tS?=
 =?us-ascii?Q?hXgoUeRt6SZwVWQ9IWVoBy1ERDfbw7z6XjpvEVFebPkaUOonN9bk+loRG6X1?=
 =?us-ascii?Q?JxQamM44Jy8cmx3CLLeIez21W8ZSGviS3XWJGesSQfuk/vHhz9c9SV66U5a2?=
 =?us-ascii?Q?o6ie9DgUnJNhimtBqTEgy0Tc5W/tfUdKb4NCIq2Mqi2Z/XnZdyDg+cmglXz4?=
 =?us-ascii?Q?ijAh5VDcHtrWhA9b4MJWe0EzGr5Ky2M2YYDUvyGuSLnb+t1KHluULdaZcntb?=
 =?us-ascii?Q?45Dralu+VSl8j0u2Ok40EQjVP5R5NeOaPIvinBkE+ojm3odLWV5CnnkQ7ucX?=
 =?us-ascii?Q?x/xx3CRyewDjqR+HE3vTk2tqQ+t+Vh6b7i2As4vc98eWzoQQ/y43+VMs7YQ0?=
 =?us-ascii?Q?4RC+5vQ3y+9CogZGM80z22nlaCmPTORgkmKSf1QRg2/kcrFmbDfBb+qbmgLJ?=
 =?us-ascii?Q?BYeRRlTmVJoAao/tzsKyEx9gDmJMcsdkswpL38nykkjtG8m7vd8AWRowlja+?=
 =?us-ascii?Q?wj2LVzlFvWd8xbRhv5isQ36bvdrUoNilJcc+tgSiUrvKhONkGxkItTcJJmpF?=
 =?us-ascii?Q?u/mCNhbccCl5tdogOv6Nj99IDQNpP8Ax+RjosC0EvQNYs+Vcd2YViSFA5Mqb?=
 =?us-ascii?Q?DMiFAjIkYlpNAlDR2kxORxnfirvuDhDG+sl2a7om3qC6leS6pk9jsgnuqBR/?=
 =?us-ascii?Q?SBGXXSiTdgI/eABI/8kP7ZxiQ01laiagCBRhcrRYIUQo75FoPzqEEBvRdoLn?=
 =?us-ascii?Q?ChWmmXrlk5efz0Z2O1voumoX0LSIYMY7EOwhJXkRR961hdkPTcNrbglah2GW?=
 =?us-ascii?Q?P01R4rSNMRrux6PTXHKDOaxQUQYB2/CTHle69b9+XwOLnuExcGuguUUEBeY9?=
 =?us-ascii?Q?YOBZuopp5Y6BwrOxn0HV7qNzbl2sSaoPmQrwz93NNSI7ToWPV9Jt3gK77XHH?=
 =?us-ascii?Q?glerE2V1NY2uNLyGrLyHo9H1TYxUS/ImX64cNHUZdVPll78+f7DzDnL6WQ1s?=
 =?us-ascii?Q?B1vyt7QcLpt9joTbwgSiRgahS9c=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66dbdd6e-d597-48b4-6dc2-08d9dd509eef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 02:40:58.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZTknn6VO8FZ7XNfwZLzbFGohNxR6ad9jdLVfvWb5O8Hsz8Qu9RbOHvhR/Mjl6rGLUd0yGrmKbiyb1LSeA2y7KRTcKq1DPriF/U3zmaDfNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1596
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
> On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Check for the existence of page pool params before dereferencing. This can
> > cause crashes in certain conditions.
> 
> In what conditions?
> Out of tree driver?
> 
> > Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
> > allocated")
> >
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  net/core/page_pool.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index bd62c01a2ec3..641f849c95e7 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
> >  {
> >         page->pp = pool;
> >         page->pp_magic |= PP_SIGNATURE;
> > -       if (pool->p.init_callback)
> > +       if (pool->p && pool->p.init_callback)

And my apologies - this should be if (pool... not if (pool->p. kernelbot
will be sure to tell me of this blunder soon

> >                 pool->p.init_callback(page, pool->p.init_arg);
> >  }
> >
> > --
> > 2.25.1
> >
