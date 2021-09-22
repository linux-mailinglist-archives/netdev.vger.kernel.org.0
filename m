Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F88414D58
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbhIVPvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:51:10 -0400
Received: from mail-mw2nam12on2103.outbound.protection.outlook.com ([40.107.244.103]:31521
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231712AbhIVPvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 11:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJanfF2BOcPpp1i4ao17WoKJatWTD7QPUH1bJfFb3M+5QEk1Fm4Sa/GzJNJh0kmOi80NjdW4z0Sd23kZ5VhwbU4dIyRWHtFXE7bqk1zuCX9XXh0KhMQ/nQLF4GFn69Kcpc82Zm3cLO8WRe1NCGNef2d2nb6c3Og1G+AAF+aljw5zqJJoD6G6C+oDUtjXgWqAXdyNSPxrgAs88eaaTc0b1wkcJcY2KN6OSvkim/npio8XeC17BPvQRgef5DyJ9fVdqbqg+j7maeVF3Gu+tFYiNe9CVPrHkmBPBcPzOs43F8Wu7Hu3BZ4bdUb0Xc/YmXCSGO6UHruvQriTZ0UlmTbF3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IFRzp3lbnP52ham2eb87y7tV+9YSthKT50J39Yiylug=;
 b=P1IC9RNYgY6822nF/cJaH09WTOp+9Wg5l8mlc9x0aoRxJfKmzRimTPKR+Mr2IweNdIs7dLza2qfmecMrwobSmy7flSFSbiTo1GCkwRehS8UG5FHKORZXy8iIdsTxc1d/do8nFlqLRI0EbUWh6KEMlWBcj/D8ZKN+XgPTdhV2ltzTvfQG8tqRhjOsAJn+qCQ/ptq4WEkSDZk+0dES/SwBkjltYOA6WCnEvLT3XnWVvyAl7x1Is1DydXXpw3+gdDPD/l90q27zO8Nkw/KfmK2kTvRGgLaofls8uZYlDCouhTdO1DSivMVu5fRZiKDfx8cGtTl/cRtAfDHPZsK8tmt3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFRzp3lbnP52ham2eb87y7tV+9YSthKT50J39Yiylug=;
 b=IOZuKE8mww9peD9CVA5MGW8ALfV5UBpFHtU5R0FeemHji9wOJ9h//GN5/Kcm02rjofAXuPyG4IokSbl9hUE0uAriDjW9P2E/XuYz4TafucnWx+nXDk63dKBWQUSW10Nx9bMPhq0EqW2wqxERuJQ1Lqj/R/PK7L7XII/rAUI2+tQ=
Authentication-Results: sipanda.io; dkim=none (message not signed)
 header.d=none;sipanda.io; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.9; Wed, 22 Sep
 2021 15:49:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 15:49:37 +0000
Date:   Wed, 22 Sep 2021 17:49:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Herbert <tom@sipanda.io>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
Message-ID: <20210922154929.GA31100@corigine.com>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM8P251CA0021.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 15:49:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75441ed5-0798-4ed6-087b-08d97de094e6
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-Microsoft-Antispam-PRVS: <PH0PR13MB477821EFD7D5A30742E76067E8A29@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEyg3RVoytGR++3ifQ7Nm4/Mr4aVC7nqecDIzRLdhy1oveEYRtGAjvlV/JA1V3qjFENqK8ZAARBVQhbi5Bd84TbaZJpDw//5Ft2JP378YMSm0emX0A6iIGvzzjZJ2Rns/t2CNhYJ6fDX0bpRaiDPeVh7AfBlu0ZfzdWV4ddQDFtrC/6zmSYJsfQlhPYdzKi4+AkuszZ6g07o6JSvVFUpXezeZw6k7iXQ8fhW4fs1EI4D0q0m67/BNyjcfV5yjDj1dUPqfWp9l4qdulvzuJIaSkVZB0KhVg/rrktHUKxfZQThubqSBArKTk8Q6W3J69yxLiyHWjV7pDb6TmvBAsyUqbOG8drXIHr8x3z3EbrdeSCFXpciy6MwkQvQv7Ln0hJZqzNzhF/fO5hXG37Fkgs/V3DH0C2Uu8cX8YAimPf3+cM0IpxfnNQw5navoaQnxJA6/PKfltmuAk5tL6P/l5iPE4iMiFiIyQotCOo4y4GPDSJdRvUI8V+gV0ZPOerZfMMw8KP9D8WrWVWrxTI/x62RBXJJnN0+fWpjhKQeal6R2xRZ/u3uRgUvExe+3/tvjv9EaN6PLX5UMMnixDlhR0yg8eGctkj6YvGN89lS9tCOlN280L4xg6JPssUwL/O6OFcnOypmNZunxBXYT6yo9GqGzNK5ZvqyTvDtgtZBY4o5aR/Dc84XfwvXL2f6ylWnLLghqHHgNLREEOwcpGWinRFv9sutfywAipmhBtePhUXS/ZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(346002)(376002)(396003)(366004)(52116002)(7696005)(8886007)(7416002)(316002)(8936002)(4326008)(86362001)(2906002)(83380400001)(66946007)(53546011)(38100700002)(6666004)(44832011)(36756003)(6916009)(54906003)(508600001)(8676002)(33656002)(2616005)(55016002)(66556008)(66476007)(966005)(5660300002)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kcfsVYB9IX6JIfgZV7rc7pL8ktENTsHbIwcC/nB9GDmHFZY42klnHCrJDlvR?=
 =?us-ascii?Q?W++DTE2K44AToBgL5eI4GEUTigFnJWG4qXB8YU451hfoLktE9QOcrYzQWADs?=
 =?us-ascii?Q?X78QHu3tHgxWLsOEdbLBweOePrzOcP7ExcBGS4IDM+h4Pa6FTaxrqr5YkZOu?=
 =?us-ascii?Q?ThFEls4kHK0omUpovhHq1XLAtulxj+m6rAY7KO+Rkrr1MGAeipocFzy8gpK5?=
 =?us-ascii?Q?4POE3Z0oIJtPwUBJi70AV75lMFRmEa1aNfOw4Y68o/P5gINt+5to8FY0wtu/?=
 =?us-ascii?Q?rT5fDweJLaQZw021LJVNtJvKtLARLgiSSCYfXKT/u9DFNLZwILSJv70YqkiD?=
 =?us-ascii?Q?4FE23pFztoUCwZnKE/0zawGR881gprTh6XfzLmmyvKktFF7diBBGXSyRj2Fx?=
 =?us-ascii?Q?Tj0qeYZQNMiNTHajAK85k1WxLMmnFTajNfqZvSQPkMoOvgwJ29MgKOhMWbm6?=
 =?us-ascii?Q?5wWpCgUo1pZ19DpIP8DcNHedPsiF95VbCFwP961Xe6IXbJH4cNAbljnHC8u5?=
 =?us-ascii?Q?iiPWqtamXUDr20+IgERPYsuVJKXFyiF7hHqO48jbLONIM7aqbJvTzv4Ep60+?=
 =?us-ascii?Q?feiDi+jJqeDamTklbmg7LgXKAD6fpIZe2pBtPbEl90G1jo7PfNYfsS/mxnCS?=
 =?us-ascii?Q?Pr3w+FjMEMNtQ7bnuwmXnmU0Iid9yAJFFFNxUmrQUqehecUVi2OkdBN7qoKn?=
 =?us-ascii?Q?7xfSYj0p1PMfp0YKL5ZE/0dte26c/liInlxfCtKfEXlTJ7B6/cMtEmhv1dql?=
 =?us-ascii?Q?27VIIO6nSRiQ4j13MZnGXZzrHrnkBqXvFAlLchXDjkQnTilow4TspMcaEUTW?=
 =?us-ascii?Q?y5Ma0rwLFV/HczBfk/0TBSVxvjrcnHtbRDAsXPdVizNjgVMxwOkDcRrKOo6b?=
 =?us-ascii?Q?2f9XKsZr0xnRxzJva+IZWyeXi8yA4cDBSQuJRyoI/62zSnwKox/KtVGogclh?=
 =?us-ascii?Q?TTUJoAcxzW4pr++HrYaC7oAGSXAPynapDSkTVU5UKfYSiMNY2QvgZynD0o8v?=
 =?us-ascii?Q?E5xklczkNIsaW4cIdij4vhrT81O933gi+00dHVWqFdAdUeO6Gyym25hFw3AS?=
 =?us-ascii?Q?ns3Y+DowzryFUpQDLSk3k1dnfH4WIkFPlAiEnk5pkq0S5spfsqRUjXtkPTRa?=
 =?us-ascii?Q?FN4YoBq+A8bTwFmRcm6vHTE8NdLOi2+d9oaMOMKlh3f/J8ivl4w+zzBaS4kv?=
 =?us-ascii?Q?0jClJMYN8h5M+HqPnnlsfyHwopBgFf3/ueGmoy1g8VnyxTrS8PD4/OblEpio?=
 =?us-ascii?Q?v7yHIeu06CHuo80tT6zrsps0sZmXJwmBYNFf0GieTo7R9LvBxjG54hQy/cve?=
 =?us-ascii?Q?ZNaTWC/AMG85mzI1A0jAYCujlSp8/d0TmHwAPyycaPSCqJZiDoRSld6OU+7V?=
 =?us-ascii?Q?D/xLGx1WAujYkDSZrW23c0FqLzak?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75441ed5-0798-4ed6-087b-08d97de094e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 15:49:37.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k66/ChZXwZv8EzQ1bc4Y5ZMc5Toed5/1z2vKPifKC52VdHNtzYeUUO24UpUSjxpufqTGVDAzdVhBLAh8uh3F7oiRKu8EfvD82bGU0dJsc0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 07:42:58AM -0700, Tom Herbert wrote:
> On Tue, Sep 21, 2021 at 9:46 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Wed, Sep 22, 2021 at 06:38:20AM CEST, xiyou.wangcong@gmail.com wrote:
> > >On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
> > ><felipe@sipanda.io> wrote:
> > >>
> > >> The PANDA parser, introduced in [1], addresses most of these problems
> > >> and introduces a developer friendly highly maintainable approach to
> > >> adding extensions to the parser. This RFC patch takes a known consumer
> > >> of flow dissector - tc flower - and  shows how it could make use of
> > >> the PANDA Parser by mostly cutnpaste of the flower code. The new
> > >> classifier is called "flower2". The control semantics of flower are
> > >> maintained but the flow dissector parser is replaced with a PANDA
> > >> Parser. The iproute2 patch is sent separately - but you'll notice
> > >> other than replacing the user space tc commands with "flower2"  the
> > >> syntax is exactly the same. To illustrate the flexibility of PANDA we
> > >> show a simple use case of the issues described in [2] when flower
> > >> consumes PANDA. The PANDA Parser is part of the PANDA programming
> > >> model for network datapaths, this is described in
> > >> https://github.com/panda-net/panda.
> > >
> > >My only concern is that is there any way to reuse flower code instead
> > >of duplicating most of them? Especially when you specifically mentioned
> > >flower2 has the same user-space syntax as flower, this makes code
> > >reusing more reasonable.
> >
> > Exactly. I believe it is wrong to introduce new classifier which would
> > basically behave exacly the same as flower, only has different parser
> > implementation under the hood.
> >
> > Could you please explore the possibility to replace flow_dissector by
> > your dissector optionally at first (kernel config for example)? And I'm
> > not talking only about flower, but about the rest of the flow_dissector
> > users too.

+1

> Hi Jiri,
> 
> Yes, the intent is to replace flow dissector with a parser that is
> more extensible, more manageable and can be accelerated in hardware
> (good luck trying to HW accelerate flow dissector as is ;-) ). I did a
> presentation on this topic at the last Netdev conf:
> https://www.youtube.com/watch?v=zVnmVDSEoXc. FIrst introducing this
> with a kernel config is a good idea.

Can we drop hyperbole? There are several examples of hardware that
offload (a subset of) flower. That the current kernel implementation has
the properties you describe is pretty much irrelevant for current hw
offload use-cases.
