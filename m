Return-Path: <netdev+bounces-4599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D1170D7EA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99601C20CB4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C2A1D2BC;
	Tue, 23 May 2023 08:53:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D554C89
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:53:15 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6E2FE;
	Tue, 23 May 2023 01:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1q8qs0yPCb3weo9DCa58Xw4axd5h+85wfFmOZsliSGIR7ifxIQ5sSiBLrhdoVVFIG+UFmSKxXDQqezZHaQx1W0NWAg9D8SFZ1/EZm7b4s2nLwVEF3HpZi4fVHOZrAYDdHDiFeB12l3Aw+XTtHoighmpFqv76oGBaAU+XESPgt3+hEr7GWqfSrM5Syailkzs3ipNIyRdqvZdpvunSk8Vo9fkm6LgD9k2kOsN0J5sJ4/4TjQT+rfmT0dcBZuR8S28IaKK1FfmnLf9NOAXWetcXMTn7V6BKWmtZtRkyO+Oo0PbE50x1MwTH5yO7JN8FFmq15PJYMcq24y2VaShehw7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GonWDkrlTfto7kDYsYi/xl1QiTAyOxqxvh1/LZWfohQ=;
 b=iaT1/VqboljnCwkADO9Gcp+6DD0M4u4duc6Qg2K1BQSsIkY04a3nhXRtBYWEoKRFa78TY5ICB6Uj27qh4mmVo1pTEGZfFfwi3f3b8t3Ad//MiPPZBdBbyKDn5R0qYzIeUvuGq3ub/S74DpRG7UhU21osrQwi8cEqDhsSz3ELUxJ2M8hW3gpy2Ua0sUsZHoBJG0iN4agLpDmndW3gX4tk6fEzSXwotolCTOTSg8tvlbRmVjbtq6deJe5I0MOvCtqGug1D2fhVq+FhZanVua7nVooN/pQjHewMKl+eCVFuPg1uhqlRCHZJ36xugh61TnHRHkB2eqsL2EmOfn2/jSzflg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GonWDkrlTfto7kDYsYi/xl1QiTAyOxqxvh1/LZWfohQ=;
 b=ABTjzYRYT+D5lJSWVaScT0knjSaN3Atk+FwSdQLQdGCCFbzRkPPVDk5d8Oy/8m7PWHleTcyfVsOIJzfLwxswRAzLOJOvmJ3EZRlWHiBqRP7Ga1fmgGsiPzgn2hwU7RCirbl8/zUpLIKgepFJlMaMAg24/TNN1CqOGDPFxlqbZz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH8PR13MB6221.namprd13.prod.outlook.com (2603:10b6:510:239::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 08:53:10 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 08:53:10 +0000
Date: Tue, 23 May 2023 10:53:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Luca Boccassi <bluca@debian.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <ZGx+7VJzthTmYHTm@corigine.com>
References: <20230517113351.308771-2-aleksandr.mikhalitsyn@canonical.com>
 <202305202107.BQoPnLYP-lkp@intel.com>
 <20230522-sammeln-neumond-e9a8d196056b@brauner>
 <ZGtr1RwK42We5ACI@corigine.com>
 <20230522131252.4f9959d3@kernel.org>
 <CAMw=ZnQ-diFqFUCEpqBTDTNojfvqaGCtZSvh8+rE_z-KBNreqw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnQ-diFqFUCEpqBTDTNojfvqaGCtZSvh8+rE_z-KBNreqw@mail.gmail.com>
X-ClientProxiedBy: AM4PR0302CA0026.eurprd03.prod.outlook.com
 (2603:10a6:205:2::39) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH8PR13MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf3854e-7a36-42e4-4263-08db5b6b2267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	edOj1Omm8I5a4k/UzYxFBU7POX0jJJbn+oAt22AAZ859epPWlz4hgYUqPZAeHlZTR64d2O7vce/c+ctLjYici9gG7sqh3JvcNgURL1XS1iLK+7UpaHXzys8ZuOuvHG6UAMtsLCqXxqDcfJbSI3zS97eRTBE8uzEEjkPuz4wgzxHjcRJ18Gbl+Jzd1sBi5bD/HzExXvux166JsK9QAvlssUa3mTCzxO7Ik91C2ETap4iXdm2asL6cMGpXDKe8FgMtymdwhTs2IrzlKMY2o3aB89DCLboIV5+MO3EGVbKwA2OFyOYO9Kzz0aU0iYIubCpGGcbNU5VtqRxzpfP8MVm9dwzhxLpfXOgCox5PL8u9nbs5Klzxb/WLe4qpo+w+pMFsY8Fd0WW+d77/7Pc53TgNyozqubtSwLai7OOFngZ6rz6P+YTOyh1EzKxDNwMF+7t1rhtLBbWd9a3Tgcb64bV6nWsvetPKtlVaPeEbqotyGBcVFu/uJXTIfJF8AgVGAX0Mdfq9hGcrHfKx5xb9fOuZ8dKw1Y/YDLFRwUfI+bZNtdCiRPYWQ7dWR45cK59VBlIAStvScFfqnOnIZJgdrhXMDpQl5fbJO67QbBrInnADIGOiZhE9bj6XDrF99exhkTJ8dOXr+dKKrqGkK1Di64NLKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(346002)(376002)(396003)(451199021)(66946007)(66556008)(6916009)(4326008)(66476007)(86362001)(2906002)(7416002)(41300700001)(44832011)(36756003)(8936002)(8676002)(5660300002)(316002)(478600001)(54906003)(83380400001)(6506007)(6666004)(6486002)(38100700002)(2616005)(6512007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2THSKVlTAm+HddOXNz7aqc7q7nAE5SnTD3hyLINQjIgURd1O7lSEeBwdHP0H?=
 =?us-ascii?Q?0zIBwUCV8RODPW9dG+hBKgLDWcCakptmguKpoRaNIYTFSVMhsW/Pgm4cCGIV?=
 =?us-ascii?Q?xkngQSqUmOb1HAlFVuX4N90SGa08XijcgBYxXu4ZHv3GdJK2YR4INMFxrKj4?=
 =?us-ascii?Q?eyIW8YF8L349ewqw7CXdP86r42q9myqCAfgmYNjoUIjnpvWP3V4dNKmbcGNE?=
 =?us-ascii?Q?TNhh1NJjj34kJmsLPQZhECCjrsvg4UtcgLC6Z+qkw/1I8CFnjT5cugyXqfR0?=
 =?us-ascii?Q?GMxSXg1ldTRxpbVpTtdUMGHDWb3OTn78pY520MiZwQPT2o5Va5LxQLiWRHWk?=
 =?us-ascii?Q?IUBsa9otLLefv9KaDnDathcW3T277H8OkACFH2MYPZJ17va32tH5UqowJA+f?=
 =?us-ascii?Q?NKX82M6dXJTNA1GgWClLKA4u8k/nSy2IxvU09F+5pvkjCPqV8BXIgWaR5mxR?=
 =?us-ascii?Q?Kcvbz6eUPgQreLamx26CiMQfU8ORyzXCbLRmQqaecOe8oS3P+wPZJZGqkC4L?=
 =?us-ascii?Q?zfTinqb0iz2gif+W735whJ5P5twNEzmV8nKec/HfnDitbFWJg8vhhzwmQq4F?=
 =?us-ascii?Q?VM5wysbwAmGg30+z0K2MPLBS4HHw9B+uwT7Baw6qCbHTC+G49yIXp97zRCK2?=
 =?us-ascii?Q?xH/YYIZoSH0Z1gl6n/tOpz4vSerrNiGkNlWePwudxWKMyyApxjBjxfx2Bqgq?=
 =?us-ascii?Q?KpIVbmIs22fvMi7EQBL+BXhRHP9ief+ms4Y8azxd359Oa2qzyOT2vGNNLZYX?=
 =?us-ascii?Q?jDdcGnvW6YALnZkbZhHjlHS3eQ//gZn6FHx7OnHEeiwnRSPES3eYYRG/YTES?=
 =?us-ascii?Q?5C/iI0ZHWxRFwVJeGV3vmJMKgwmQaE7YlcqWGKd2JTOo5ja6BHrFlH3GiWfJ?=
 =?us-ascii?Q?f9A5GHpFGUZasC6xkpIrRnOn354EaqGLU5ilnCUtpcjRJUNk+NJV9H8HjYdh?=
 =?us-ascii?Q?W046eYBr7hGptTuXffKONSvFR4dkfNLMkZU4SoigFU2ELwLY3+Be0zI35QZw?=
 =?us-ascii?Q?7XDR9jXN1PGsyNLI5cKP+ms9nwZ5iAo4KAzBAHMNf1SN7ROUYa84+uV3Yz7k?=
 =?us-ascii?Q?F4IUC7C9jisYf14YEGmCRcSGkLsS+DjchY7hNm0YFaVJt68L6S2b8HNSmLhb?=
 =?us-ascii?Q?GWiGQ8EZOrl3twJ/mM3av7O5jsgcdBO5somkRj0Gyi7Fy+4bVJVJLFePFS8P?=
 =?us-ascii?Q?fhZapf5LilnX83Uu+BoK/31MOSKlpbmNeqM/qbBjUjmY2KIH0ZLU8qvh/k//?=
 =?us-ascii?Q?RPOIkh3GAF0CVNZSQbxXYQKF4GbJ5hVmBq7eoK9yzSdtr1myLeUY7MTCdvc7?=
 =?us-ascii?Q?A88qW3WPl8vC0hPfREQ9R1BnzrCMxPNXiaA5u7JgG/1O6ervMMftl7ZxBwnD?=
 =?us-ascii?Q?Ocxc1GRJQH2r3PFZiheBB8x6/JRbIBB+kZ81J+GeMKPzvLexqA2ybpEyrYKr?=
 =?us-ascii?Q?rZQHRZMEG9YZ1Smb8luPeRrURK802mfwD27BmF7LiLfzr5QzcdJt6BgoorFz?=
 =?us-ascii?Q?L6UYYwBbLZGsZ91E/QwB52/GTeukcSviK9EBndhZ3rUMWsvNGm++P8Z5smlO?=
 =?us-ascii?Q?uqF7/kAtMtdOcuQzIF3FIY/hBSXfuRfcL7htAA1gGjJjB3TpN9QT/q4xJijv?=
 =?us-ascii?Q?hFYxVnx6P7aYA9o2KqhCo6GKIWx1ld74OW1Oq49FdZsnseAS16s0a1TXwoPL?=
 =?us-ascii?Q?3RYVBA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf3854e-7a36-42e4-4263-08db5b6b2267
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 08:53:10.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zmBpCZ0Fpat7M7StccBbFo871nYxRy4Pbl1SD4aLY3l5+VTwIhHGtmji0SKqQ6y+wtYNVbFTMNYsXNbuxeQC6+81K0LDho79ANPH0UgfYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6221
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 09:17:46PM +0100, Luca Boccassi wrote:
> On Mon, 22 May 2023 at 21:13, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 22 May 2023 15:19:17 +0200 Simon Horman wrote:
> > > > TLI, that AF_UNIX can be a kernel module...
> > > > I'm really not excited in exposing pidfd_prepare() to non-core kernel
> > > > code. Would it be possible to please simply refuse SO_PEERPIDFD and
> > > > SCM_PIDFD if AF_UNIX is compiled as a module? I feel that this must be
> > > > super rare because it risks breaking even simplistic userspace.
> > >
> > > It occurs to me that it may be simpler to not allow AF_UNIX to be a module.
> > > But perhaps that breaks something for someone...
> >
> > Both of the two options (disable the feature with unix=m, make unix
> > bool) could lead to breakage, I reckon at least the latter makes
> > the breakage more obvious? So not allowing AF_UNIX as a module
> > gets my vote as well.
> >
> > A mechanism of exporting symbols for core/internal use only would
> > find a lot of use in networking :(
> 
> We are eagerly waiting for this UAPI to be merged so that we can use
> it in userspace (systemd/dbus/dbus-broker/polkitd), so I would much
> rather if such impactful changes could be delayed until after, as
> there is bound to be somebody complaining about such a change, and
> making this dependent on that will likely jeopardize landing this
> series.
> v6 adds fixed this so that's disabled if AF_UNIX is not built-in via
> 'IS_BUILTIN', and that seems like a perfect starting point to me, if
> AF_UNIX can be made non-optional or non-module it can be refactored
> easily later.

No objections from my side, as long as we're not exposing symbols
that we'd rather not have exposed, or otherwise creating new problems.

Let's resolve the AF_UNIX question at some point.

