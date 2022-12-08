Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5206646CA7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLHKXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLHKXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:23:10 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8187368697;
        Thu,  8 Dec 2022 02:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670494983; x=1702030983;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Sr1IPdbNt1Ksqq7QWJ5ZGomsbdElkqdxEYTv3YewdL8=;
  b=i1EPQiUixqMx/6SiNvskI4y9cyj1ifTGpSLx2D+6WcuQV88TKF6UNg1O
   i7/NAu87z/vgbrixRurVGj2l9c8hucTdULfb+ljXR2W/yMkjPi78Fm0u6
   fxI0fDJvK2VKTFnc5dfjQQKiwU6ePoaPcJ+jlFa6LdZSWiZ0LwOJ1lYvk
   850Ws2sew2WhY4sn/qTTV/eKRMKn2dAM+XnsHJ7UPZnmIv9KMmOkfh9Tr
   pqVBZ9XfL+3KLmD7s5GDo8CJUccKJMlJUWW/QE3yFaFoxUVT9DdrvC6wL
   E7Q9cW0Gnwie1ydfK6wkE52K3xREo207WEbfnFx2dn6i8j+y7V8MQsOLZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344178190"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="344178190"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 02:23:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="753499719"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="753499719"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2022 02:23:01 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 02:23:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 02:23:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 02:23:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 02:23:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNaYeAwi7qeDjhsjJ9b34kr730LcBewRW6qIglNxcJuj/9IaNZeko91QuNMNQY9rtUoivdYMEWTBkSiWjzeQ54CXRBIpskwhmYCjgbHV5gvY8EB7434GObUkBpD27y5v9/fbpOlwe4pO1CJZNsqLFhFYdvIZU+p/bFtbxHPkSWO4VYPXpxLfJtgKkb+tgi6e7Zj8Yo7QuAYxDfcrgRkPKtgogGTa5CVj/uekx6DXYKnY9S0WsA/IIIGc0pevpBMaHrl9eLG47QMRbPHJ8y/Ie0f6lrM+Xxjp74Inx7lkDE/p4ArmgTm8CHRyNLy1CWznlhnRkO8OQU2htzXu6th7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCLiU5M71RDn3EZfse5qCm6V5JSZh2DooSTLJmT1Ewk=;
 b=A8j42qs6CLVmVRkCjREfM6h4uDA3lkyKy1NITSA7WrQOSjsWji9ngWQzH2Fv7Scoo1sfkcY4X37S+Xp4ICGf+QhfPEMcTy8F20gNcfMLlN8O5IvqLKgQ3QlIYiPi5NPcWtKYhVsJ+CDw7ZlY3RoUGsQEHgYDYU4V2bErFh1mHOnghHeEaA+EhtHW0iBX41X7ZEWzJb7fmLNo1aiZRBsmLbexxeCa+SuQBDbbNi7d95PlXPgcQUCb2wuVBlBisBZwFBhfQJ/UulhkBRpTF5u4CtLt5HM3etw8twgWLb+eIXWhSQUmnsaXKnR2/H55oCuLeI6izzIbLNfCtz7hUix99A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by MN2PR11MB4630.namprd11.prod.outlook.com (2603:10b6:208:24e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 10:22:58 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::1564:b428:df98:96eb]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::1564:b428:df98:96eb%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 10:22:58 +0000
Date:   Thu, 8 Dec 2022 18:19:50 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Vlastimil Babka <vbabka@suse.cz>
CC:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        <syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Andrii Nakryiko" <andrii@kernel.org>, <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, <jolsa@kernel.org>,
        KP Singh <kpsingh@kernel.org>, <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>, <song@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rasesh Mody <rmody@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>,
        "Andrey Konovalov" <andreyknvl@gmail.com>,
        David Rientjes <rientjes@google.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH net-next v3] skbuff: Introduce slab_build_skb()
Message-ID: <Y5G6RnoyZC78UO4q@feng-clx>
References: <20221208060256.give.994-kees@kernel.org>
 <6923d6a9-7728-fc71-f963-3617e5361732@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6923d6a9-7728-fc71-f963-3617e5361732@suse.cz>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6304:EE_|MN2PR11MB4630:EE_
X-MS-Office365-Filtering-Correlation-Id: 057287f2-e0d3-4bed-7a2e-08dad9062d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvd7fnLM/ionTWV/wERScwTkrfJQFYoIFc42PYIIMMGZf5U52HHJ+lTIeFbLH5wCKkbFEvZOXC+/vmLcKCPyPN0hycn147Z0iW8QkbsqNI3dIUNLKAX5zN6ywmvs22HAi4drM+EcqEJ9EVZuomFT971qw5vn1NHmwgTclOry/7EQk+oqriZ6K+J7JCyP2OdvsJOcQnEqyaBOPPGB36VOTazvXlS4II7Dc0NTcnqrSYXIrtODBQuWYZ86/mPeihp6NhrIfGvdkXNqJeZr37Qp0zMaRZU+k4gBx+2sl9PtFluOXYE3Y3+AHKYjxvVwCWmbk6BI7WKo2M3z+gtz75nQ/T5NGtjoqCMGR7AAAyFItjGWGyMfnguVmDiN6BscwZWQUV0r4dvRwErqTYWnQSXquOaWYStV9CGh7l/2rtyJOj9JbeqpoZIGhH1Suw9I09DC0e/ALoZsRlMKj2Ee5rHs9yyVXbAb5fz+zWIm6ZDiryAhFGdRLA0sG4UeKn34O5LgXFIHUxX9+QMZPf+cZJMR1pv5IEUXKQWDok2iaUbaquccmIvtdkWMpUAKG9ovLSYQLuV7IThM9F+lGclGWczi8W/vm9utUIAh/UEss0tWo3ZppVY6JYh4+9PlHkxEKHkqRoQyqtF6bL5QEAwtDG1YhoPxUeN2wQexKwz/s2lmdf7XQoVHIKpzdzcZuiq9IMSL/OcOyTHIKO+JDdEkXLqpIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(33716001)(6916009)(6666004)(82960400001)(316002)(2906002)(54906003)(53546011)(966005)(44832011)(6486002)(478600001)(6506007)(8676002)(41300700001)(86362001)(186003)(38100700002)(4326008)(8936002)(9686003)(66556008)(26005)(83380400001)(5660300002)(66476007)(7416002)(66946007)(6512007)(7406005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4f5NMh0OpjLZnN+CNxRmF+wK2OOm7cf1caArr8af5lYbxdJxyopqtBO/agK?=
 =?us-ascii?Q?BxKWcYuMcVhIee0wOcgyZm6KIpJJgekJPOcJLG9ZfVHDdTiIIVWULlR/Cdui?=
 =?us-ascii?Q?br2GTyAjy70yGoy+q5L9xRjO+mbDzgdMevo5scmeTVNSBmVC6teKnbvtY/jH?=
 =?us-ascii?Q?X+e1WUIqPeCotyvHcIl8oUSPsRn04WAST0lRMD/RDiFSBXWohbT0Xp7axWIS?=
 =?us-ascii?Q?hkHGZQWFlWdUDHUstfx45c2PwAYF/dcCEGStgwRv/4+3po1N5EbMH2ASx8Wt?=
 =?us-ascii?Q?vciySkp3lIAgHihooZ9qbfyPHj/nS73wn3skDw4u2ugq4/0V+1zJ9Ah9U4ht?=
 =?us-ascii?Q?3kktVZXTedQfmlFi64e+OJePcNEm3tMmmFTUqbid80+q3f6HbkTGr8DVY4F+?=
 =?us-ascii?Q?9yXdl6E7SBNKx+Fgp5sxTfO4MQ5hyxjLmeKIt+DLZgr9kdxTm125+e7skBc6?=
 =?us-ascii?Q?SbVViJWgO18mNiCFuMQTHFVSdRAQJspL4aIUGphPmCx5Pt5wrcLXarSAql2y?=
 =?us-ascii?Q?EWz6TEcTL+y7W8t+rG+EltbTpeTGPLQ9xzZo2jJgkgJ5KSP0SfoMCuNdGd3Z?=
 =?us-ascii?Q?pmC7620hsZWV3n9NJRjvgFiKqAI8L8dRKRmwfuOVcUx6Uh79e8VUnmiZYI1R?=
 =?us-ascii?Q?WdoDUdWLIuVHZO3tHp8LQqKcWETepTbV0sp1OKUXygAYOcTX3XfP4IuKmdXx?=
 =?us-ascii?Q?g+4MdUR7praMERKrlcWYCPI7Dny/Kp3+ZrHTyol4Q5ZSNTSKFSjManzr3q10?=
 =?us-ascii?Q?IWdXDLEWI2HNY9EB6GLyKDAYZ30qK8A/O9airI6eRpc+D8w6rk33O+tx5ntq?=
 =?us-ascii?Q?YLYqSZFlHjJTgH9GRgVF5ba8nwEfn0Fj1CWNsjHuPiy89cKm9BnbwxqsTc0b?=
 =?us-ascii?Q?LIbNR3bUK/h4nR0UhXFIg5XQ+YIZCp3ZKsbM8tmw0msJjVdRwEx9ROPlBL6m?=
 =?us-ascii?Q?imlPTn15X0lP3E2p/iWVLDjlLb1Rof0aTDqy5/EkFWj0jypZsKk6jGbjAiZa?=
 =?us-ascii?Q?Wpb2lPOEXoRDJiKccjG7+b0V7D/rAkSp/wgHpjjiBx8lBnbt44eGs15RpzWN?=
 =?us-ascii?Q?p0n+Ba5JHteL6KHfpQ+XRtaxRQ/qxMiB6cXW4OK5NwCzwrePHSs3trH+WrOr?=
 =?us-ascii?Q?h1JKdaP2Ee5WPJ469P3nwcuwYB1zuQfXpo837It/85cqoTH0D8ln1oeZRWkC?=
 =?us-ascii?Q?SlbnAyyrGjFFzKDhMv8hQJD0eZBFIF0/5V0QDkFfVas8K8jY8XxLudqQQ4TL?=
 =?us-ascii?Q?pG2kIMBM/8qRg8FytSdMGQWrGYjUd0GEfeYqqu+dj16z7sClYvWjMC8T9bM+?=
 =?us-ascii?Q?aEwyI8TFbmt+X2UqeZbO3tP93+wRxxkrWgsA+4/4YkUbnCvOcxBkt3pGfH18?=
 =?us-ascii?Q?GY7S+ovuvDMM0BvT0QdHjVGDWqGhsFskNP93Ce3jq088Dv9+5puzxvh1JGn4?=
 =?us-ascii?Q?KeBWX/QKH6/AH4isDQPF/XEiu20kzcBX0p1yNmcaPDyizzujRiSHuxoqjSij?=
 =?us-ascii?Q?Fp9zOdPpO1Ruev54d938MWTcW7wpxd5UJSbCASquFKkzpkVKtZ0jNbFs6Hz4?=
 =?us-ascii?Q?OTwUyMp+6u3GXMRnglHZXNTux7dcufz/MAGTH8rJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 057287f2-e0d3-4bed-7a2e-08dad9062d67
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 10:22:58.3633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3p3sCT6jbHx2oS75b9WuLiMglR9DY7Wo++v0iSvpCbc1P37hNtYfQyfTpDEyRxsirLBmXpsoirkzbVZ9h+0Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4630
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 09:13:41AM +0100, Vlastimil Babka wrote:
> On 12/8/22 07:02, Kees Cook wrote:
> > syzkaller reported:
> > 
> >   BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
> >   Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
> > 
> > For bpf_prog_test_run_skb(), which uses a kmalloc()ed buffer passed to
> > build_skb().
> > 
> > When build_skb() is passed a frag_size of 0, it means the buffer came
> > from kmalloc. In these cases, ksize() is used to find its actual size,
> > but since the allocation may not have been made to that size, actually
> > perform the krealloc() call so that all the associated buffer size
> > checking will be correctly notified (and use the "new" pointer so that
> > compiler hinting works correctly). Split this logic out into a new
> > interface, slab_build_skb(), but leave the original 0 checking for now
> > to catch any stragglers.
> > 
> > Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> > Link: https://groups.google.com/g/syzkaller-bugs/c/UnIKxTtU5-0/m/-wbXinkgAQAJ
> > Fixes: 38931d8989b5 ("mm: Make ksize() a reporting-only function")
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: pepsipu <soopthegoop@gmail.com>
> > Cc: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: kasan-dev <kasan-dev@googlegroups.com>
> > Cc: Andrii Nakryiko <andrii@kernel.org>
> > Cc: ast@kernel.org
> > Cc: bpf <bpf@vger.kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Hao Luo <haoluo@google.com>
> > Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: jolsa@kernel.org
> > Cc: KP Singh <kpsingh@kernel.org>
> > Cc: martin.lau@linux.dev
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Cc: song@kernel.org
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: netdev@vger.kernel.org
> > Cc: LKML <linux-kernel@vger.kernel.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v3:
> > - make sure "resized" is passed back so compiler hints survive
> > - update kerndoc (kuba)
> > v2: https://lore.kernel.org/lkml/20221208000209.gonna.368-kees@kernel.org
> > v1: https://lore.kernel.org/netdev/20221206231659.never.929-kees@kernel.org/
> > ---
> >  drivers/net/ethernet/broadcom/bnx2.c      |  2 +-
> >  drivers/net/ethernet/qlogic/qed/qed_ll2.c |  2 +-
> >  include/linux/skbuff.h                    |  1 +
> >  net/bpf/test_run.c                        |  2 +-
> >  net/core/skbuff.c                         | 70 ++++++++++++++++++++---
> >  5 files changed, 66 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> > index fec57f1982c8..b2230a4a2086 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2.c
> > +++ b/drivers/net/ethernet/broadcom/bnx2.c
> > @@ -3045,7 +3045,7 @@ bnx2_rx_skb(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr, u8 *data,
> >  
> >  	dma_unmap_single(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
> >  			 DMA_FROM_DEVICE);
> > -	skb = build_skb(data, 0);
> > +	skb = slab_build_skb(data);
> >  	if (!skb) {
> >  		kfree(data);
> >  		goto error;
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > index ed274f033626..e5116a86cfbc 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > @@ -200,7 +200,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
> >  	dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
> >  			 cdev->ll2->rx_size, DMA_FROM_DEVICE);
> >  
> > -	skb = build_skb(buffer->data, 0);
> > +	skb = slab_build_skb(buffer->data);
> >  	if (!skb) {
> >  		DP_INFO(cdev, "Failed to build SKB\n");
> >  		kfree(buffer->data);
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 7be5bb4c94b6..0b391b635430 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1253,6 +1253,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
> >  void skb_attempt_defer_free(struct sk_buff *skb);
> >  
> >  struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
> > +struct sk_buff *slab_build_skb(void *data);
> >  
> >  /**
> >   * alloc_skb - allocate a network buffer
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 13d578ce2a09..611b1f4082cf 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -1130,7 +1130,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
> >  	}
> >  	sock_init_data(NULL, sk);
> >  
> > -	skb = build_skb(data, 0);
> > +	skb = slab_build_skb(data);
> >  	if (!skb) {
> >  		kfree(data);
> >  		kfree(ctx);
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 1d9719e72f9d..ae5a6f7db37b 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -269,12 +269,10 @@ static struct sk_buff *napi_skb_cache_get(void)
> >  	return skb;
> >  }
> >  
> > -/* Caller must provide SKB that is memset cleared */
> > -static void __build_skb_around(struct sk_buff *skb, void *data,
> > -			       unsigned int frag_size)
> > +static inline void __finalize_skb_around(struct sk_buff *skb, void *data,
> > +					 unsigned int size)
> >  {
> >  	struct skb_shared_info *shinfo;
> > -	unsigned int size = frag_size ? : ksize(data);
> >  
> >  	size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >  
> > @@ -296,15 +294,71 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
> >  	skb_set_kcov_handle(skb, kcov_common_handle());
> >  }
> >  
> > +static inline void *__slab_build_skb(struct sk_buff *skb, void *data,
> > +				     unsigned int *size)
> > +{
> > +	void *resized;
> > +
> > +	/* Must find the allocation size (and grow it to match). */
> > +	*size = ksize(data);
> > +	/* krealloc() will immediately return "data" when
> > +	 * "ksize(data)" is requested: it is the existing upper
> > +	 * bounds. As a result, GFP_ATOMIC will be ignored. Note
> > +	 * that this "new" pointer needs to be passed back to the
> > +	 * caller for use so the __alloc_size hinting will be
> > +	 * tracked correctly.
> > +	 */
> > +	resized = krealloc(data, *size, GFP_ATOMIC);
> 
> Hmm, I just realized, this trick will probably break the new kmalloc size
> tracking from Feng Tang (CC'd)? We need to make krealloc() update the stored
> size, right? And even worse if slab_debug redzoning is enabled and after
> commit 946fa0dbf2d8 ("mm/slub: extend redzone check to extra allocated
> kmalloc space than requested") where the lack of update will result in
> redzone check failures.

I think it's still safe, as currently we skip the kmalloc redzone check
by calling skip_orig_size_check() inside __ksize(). But as we have plan
to remove this skip_orig_size_check() after all ksize() usage has been
sanitized, we need to cover this krealloc() case.

Thanks,
Feng
