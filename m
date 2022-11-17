Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2462D28D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 06:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiKQFDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 00:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiKQFCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 00:02:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D76BDC7;
        Wed, 16 Nov 2022 21:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668661344; x=1700197344;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OuCSI4HMl8azstPKGlPk5ir+YqcNEfjRL0PQut3Vgbc=;
  b=m2GZ4LYv7f7P9ZZP+6KXMoZD7QMRk+RBeCnpQQEEQfFMIT8qj/e3nWK5
   EeNUpUGJwDZKubSdOGBmcTOXYrutspeU5C5ksQ/vij1+wcmEm8QPRGIxL
   yOGcrdhwUDKtzwDLgUBOuKjNUsF9OOTI2QFN2s8GpnwgBNdT41EuSkxpK
   XkUdW7ydBpVDjYDGn85Av1cdmmq5ztMMj29Rmn2SqMrjFAYr2w3wX87RN
   6K/8fIusMc4F/TtygPZUKmFBm8uBe9kIe82r6qiCkksXiyWbrW8i2vdWp
   6G5bvLDJxKEgUKg5uEiyxCkW+3wPoina7B0/+ZoGD55Qr/Ixa1yJUdzhp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="293154574"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="293154574"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 21:02:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641948340"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641948340"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 16 Nov 2022 21:02:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 21:02:23 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 21:02:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 21:02:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 21:02:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTsldhXOXDMNCkV8bNrAAcc4ueD69ayWbY27Ne7erjcAA47+uzWKkBquk3gPmPWKIz4eMbhP6VeBSN2ZqQoHGvavDhSPReITNPj6U3qRmCqFXSKx21odJ+nXtSMWOJcHKnVyB5BqiFu7rGpnNBKO4vsz/sqV/iq0544Jv5IMAF90UW3tDfyZZZUCi51RrrUcq5Vi4Su/bS8vEyjwYYhq/lCxS3R46UmknD6g5idqdQQr+IjJAwKOzEBtwr98l8GmK46JQlc2XCGEVls+Pkp/nREFYlR7q3h6L09l0rvpOiIVNW41Fm4rjGdksa2hO9wR6o9x5+QBSC4c2LJrD0vs6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qC0fn1eMdqdrVy+LOMY0jIGHLwSDp3dzgg+0cRMtMag=;
 b=HaiNu1dZ3KDx6umparPhh0RCXKqfQtB8giruvOt7EiREHn7j8exC2fUqiNdYiKQ7Z1WxDW/XTNCXMEwwMcL2na6LQKhFJY4wQpkjUvSE4lpF95iuRP/OdFb3qpKtYYW+VX+qhJM+s8gFBSFZlu/6xg9Ley/t5A69AXWWGI3uLOUmLcAegtqmbhj3Z2tm2Wnp4OKHR55k8tSp/sVIEpl2PhB4CAk/P2O+V8qlaOWkxUfiGAU6u2ROd3bnuaOCaxe/pnySEaCh9FNYUlgvqDaD0V6VjN84gGLrgbqbRaGS7mSDYM2I4yenpXiqzs9vydcvFrL0viIG7LaNhiZ8wr9YGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by PH0PR11MB5829.namprd11.prod.outlook.com (2603:10b6:510:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 05:02:20 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::78af:67f1:f3ad:a5]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::78af:67f1:f3ad:a5%6]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 05:02:20 +0000
Date:   Thu, 17 Nov 2022 13:02:41 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <joannelkoong@gmail.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <martin.lau@kernel.org>, <mathew.j.martineau@linux.intel.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <stephen@networkplumber.org>, <syzkaller@googlegroups.com>,
        <william.xuanziyang@huawei.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net 4/4] dccp/tcp: Fixup bhash2 bucket when connect()
 fails.
Message-ID: <Y3XAce5qbbs978y4@xpf.sh.intel.com>
References: <Y3WbBb/cWSopB6j6@xpf.sh.intel.com>
 <20221117032014.80364-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221117032014.80364-1-kuniyu@amazon.com>
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|PH0PR11MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 3420c212-ab47-433b-77ec-08dac858e802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMddyJlCOLJYX8twWFccgmu2hJajVntvDp8x6/C6CGV1OvHSpBiswoJMeizNJc413DM5tOZQSpXh2/c6nL6Uto4OaK0sHi+3SlIFTssUDKbPQCQCd5vP1fznto3r8z0pvdfSeQQj2vm/01eqtCfZRCek/iOyq+efk3bIVE4B59dniDeL8DoncEWdgXMVRdwNxFx+otnHY6qXylJ0x6K5GECL9/UwSKQ71jjyUyVNmCB/04TAzTTvqnufQ/3X67O1D6MjGM7oNg67Ok//Lh7f2/loAfVzt9pGYuvO00t6ODCj+MmeYs4DBqZwjjB2WRD6VMxt/NxBlZPWC8ZB6bBI8TTkQPj+F/ENzragNsij74Sa1aUBfm44O65g7bfERiNXgfBAU8MdKd6NEgrNdW3F0CAyHYh2HdT8cM8RgixEHVYTNvuJkWQLLTQETcOen6mJzdp0UZfXHzickWSqLLT6qsjkdo68GpCx5qSXcLXff17T7xO28Nwn3374khdoziJ6bXFiYAYoOpsSAudkRvd72/ATV5iwBQNBdCZCjzzpaTu+g+uYQv/g/fNj3Ym48fzdkT5G/4yp32YSBd6QigrRNKMBnftgmxAZpogEk63stnar4bDC/kdCn/6D5JEYUKO95h3JTVWkvQ754mLsDBHyrohhWqDFbu4LE0Y0G6VIta71S1ALNG49oblzEmUwyUhMYd8+giQ4MZapTe5RyzEyWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(2906002)(8676002)(186003)(4326008)(86362001)(30864003)(82960400001)(44832011)(316002)(45080400002)(4001150100001)(53546011)(38100700002)(6916009)(41300700001)(5660300002)(6486002)(66556008)(7416002)(66476007)(66946007)(8936002)(478600001)(26005)(966005)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?120TiNkJeFMXCNfZcyvKQ6UO7E0XBZ5Yhe4mOAfH8qKRSCL4B6w0MnLAx4s6?=
 =?us-ascii?Q?NMTo7YfZRlyHGXdG5NZ7U3C0mCfmJUIcLw3GFoUXheDH01R23k4umFZ2DFgb?=
 =?us-ascii?Q?r4AO3FJ77n/UCzR17mDLLPSamsgmK82tAqTNNfRal8qwQ46+nLn1b+03qDTT?=
 =?us-ascii?Q?QAaJOfKGKyCdEbtjstYEfUBKY2Nr/U9tKYHR05ETeFdSI9kLvkhVxuEfLYzl?=
 =?us-ascii?Q?bHmCn+gEJbE2DIDxGtn/Z6WQ3oPzIOdSzJNFHl1iZ+AbgSiEYOZFEQI+WMm5?=
 =?us-ascii?Q?ubIKgTyES6+mWY3wlJCdmq39h9xvHhMci3JSPmiv1pfPUCCXU8x9ViV5zCSK?=
 =?us-ascii?Q?/aL8KIwaR3QPgRGyW/JeChYtwBBmHc7RSsI4auGM6dJb+5iGrkTcfFj3JgEu?=
 =?us-ascii?Q?4pNQdiHIOhDlIwpESjc97SGsWGCb/BKmUJrKEzEsNtT/76oHslbv+GvwtrFf?=
 =?us-ascii?Q?FdwFn1KJzRag5urYcEm6HYcmienWth9+naQZUWbMknTWzLeylOvqTFTGXrt8?=
 =?us-ascii?Q?X67O7mK+FycD2w9h3ylDRc4TXWRMijvw+VxinBgeDP+g6ZFRhABWFPrOmiBJ?=
 =?us-ascii?Q?tQFFlXYMqaEIF+gJB4aTyJqltKjxQ8L9MWrPB3iiylByxJ08Ux304tug8PFU?=
 =?us-ascii?Q?PHlrli0PJWYOep6ZGxc/We+YuCHUZD7CfjifTnRBVIUVU11Mg1IYk9pdYxzL?=
 =?us-ascii?Q?9Zzot3qqbcoZV90NHnK2oSLJEmNYYBrr4NOXupsdXnfo+p1xn9mQEeTHbYGR?=
 =?us-ascii?Q?5znwed4DQML4m38aAc5wpNK1HOKTKhemozaiOHGGJn4hu8bmRc5AV4BMJiJ4?=
 =?us-ascii?Q?IL4kCCUq2EX7SUsUuWWaiitA564wmD54k4m5Ym9GeL+pIOFejt0DN94ZHXKG?=
 =?us-ascii?Q?xDIuqYG60TF7tw4Xn0tkRxFQUsCkaQjmyk9XN9hfLWw5+l4XN9J+OtVrHIdI?=
 =?us-ascii?Q?7FcgNpWAiuP9ZulZXrnHz9ZqfKXwHVSuMyomeHHAi3rTsAYVJOZXqX42nhqb?=
 =?us-ascii?Q?2Q3iD0+9MtDGAUtDD9NdCKY+NPyQM3gUlCbSzzr1l8Ldfb+/2PRmay+DAtqu?=
 =?us-ascii?Q?3q1OF7Us8etXhvig1R6IK46gG8FX1ge7LEnPn8AFNLTtoXJSPokFST8yrLOz?=
 =?us-ascii?Q?7ShffdVVgkaIWfBLvAT9Dx2yFuQQ07Ps0nY+FNbLkOeLNt5dqEs6ymNzOoZB?=
 =?us-ascii?Q?2wUJx497PAVL3Z9UbXGSz8Ev0Sq/q0qNKqOlEsuwW8USbRGOEr+kvUFA15Nu?=
 =?us-ascii?Q?dpBhHPt+cynuLmUr+fR8DmB6Lut8PyxoJzAG7bViYuuTfElikE3xmH+ADSa8?=
 =?us-ascii?Q?TYHZy72CC87UrxAU7sTH4lb7EWM83+3xHGXFkY652T9uffOIuICQh7sfyUse?=
 =?us-ascii?Q?DU5F+M970cIi0l4+b+QjbQ0qJhvOkDuLQwEAHWjzozy7eY4sLzQw4pLbvCAq?=
 =?us-ascii?Q?ez1y5LihQLs+sUFSzxX8ljgsrRqAsrNkMHfhpuu3bpjRxd8yfofnrQJvwIuS?=
 =?us-ascii?Q?BVKCasULfY8yMBd/IeoeTPJLXMoae8+3Uh09EO6qwCfZKAzeJpejZjfszkZC?=
 =?us-ascii?Q?hdYMmxn6Dnd7ReAmcdpz4Cu1icsd1nVLzWS1+iIJN1J0kGIGgHCV2B1wFgLx?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3420c212-ab47-433b-77ec-08dac858e802
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 05:02:20.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m70QeUEMePhcyFkGMfXmd/1aVIpBHEcOIs7X4V7HHup1xrdTQhTaeH5dp1+NExAqdDOlhfWwSj2JwgK/jVvODg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5829
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki Iwashima,

On 2022-11-16 at 19:20:14 -0800, Kuniyuki Iwashima wrote:
> From:   Pengfei Xu <pengfei.xu@intel.com>
> Date:   Thu, 17 Nov 2022 10:23:01 +0800
> > Hi Kuniyuki Iwashima,
> > 
> > If you consider bisect commit or some other info from below link is useful:
> > "https://lore.kernel.org/lkml/Y2xyHM1fcCkh9AKU@xpf.sh.intel.com/"
> > could you add one more Reported-by tag from me, if no, please ignore the
> > email.
> 
> Hi,
> 
> Thanks for providing a repro and bisecting, and sorry, I didn't subscribe
> LKML and haven't noticed the thread until Stephen forwarded it to the
> netndev mailing list today. [0]
> 
> The issue was brought up for discussion [1] about two weeks before the
> thread.  So, I would recommend that you check netdev first and send a
> report CCing netdev if it is a netwokring stuff.
> 
> The issue is reported by Mat[2], me[1], Ziyang[3], and you, and all of
> them were originally generated by syzkaller.
> 
> If we added all Reported-by tags, they would be:
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Reported-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reported-by: Ziyang Xuan (William) <william.xuanziyang@huawei.com>
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> 
> But adding my Reported-by sounds odd, so considering the order, only
> syzbot and Mat ones make sense ?
  Ah, that make sense.

> 
> Anyway, I'll leave the decision to maintainers.
> 
> [0]: https://lore.kernel.org/netdev/20221116085854.0dcfa44d@hermes.local/
> [1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
> [2]: https://lore.kernel.org/netdev/4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com/
> [3]: https://lore.kernel.org/netdev/4bd122d2-d606-b71e-dbe7-63fa293f0a73@huawei.com/
> 
> Thank you.
> 
> P.S please don't top post at Linux mailing lists :)
Is this suggestion for me, I'm not sure which action I should do if there
is.
If no, please ignore.

Thanks!
BR.

> 
> 
> > 
> > Thanks!
> > BR.
> > 
> > On 2022-11-16 at 14:28:05 -0800, Kuniyuki Iwashima wrote:
> > > If a socket bound to a wildcard address fails to connect(), we
> > > only reset saddr and keep the port.  Then, we have to fix up the
> > > bhash2 bucket; otherwise, the bucket has an inconsistent address
> > > in the list.
> > > 
> > > Also, listen() for such a socket will fire the WARN_ON() in
> > > inet_csk_get_port(). [0]
> > > 
> > > Note that when a system runs out of memory, we give up fixing the
> > > bucket and unlink sk from bhash and bhash2 by inet_put_port().
> > > 
> > > [0]:
> > > WARNING: CPU: 0 PID: 207 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> > > Modules linked in:
> > > CPU: 0 PID: 207 Comm: bhash2_prev_rep Not tainted 6.1.0-rc3-00799-gc8421681c845 #63
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
> > > RIP: 0010:inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> > > Code: 74 a7 eb 93 48 8b 54 24 18 0f b7 cb 4c 89 e6 4c 89 ff e8 48 b2 ff ff 49 8b 87 18 04 00 00 e9 32 ff ff ff 0f 0b e9 34 ff ff ff <0f> 0b e9 42 ff ff ff 41 8b 7f 50 41 8b 4f 54 89 fe 81 f6 00 00 ff
> > > RSP: 0018:ffffc900003d7e50 EFLAGS: 00010202
> > > RAX: ffff8881047fb500 RBX: 0000000000004e20 RCX: 0000000000000000
> > > RDX: 000000000000000a RSI: 00000000fffffe00 RDI: 00000000ffffffff
> > > RBP: ffffffff8324dc00 R08: 0000000000000001 R09: 0000000000000001
> > > R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> > > R13: 0000000000000001 R14: 0000000000004e20 R15: ffff8881054e1280
> > > FS:  00007f8ac04dc740(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000020001540 CR3: 00000001055fa003 CR4: 0000000000770ef0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
> > >  inet_listen (net/ipv4/af_inet.c:228)
> > >  __sys_listen (net/socket.c:1810)
> > >  __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
> > >  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> > >  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > > RIP: 0033:0x7f8ac051de5d
> > > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
> > > RSP: 002b:00007ffc1c177248 EFLAGS: 00000206 ORIG_RAX: 0000000000000032
> > > RAX: ffffffffffffffda RBX: 0000000020001550 RCX: 00007f8ac051de5d
> > > RDX: ffffffffffffff80 RSI: 0000000000000000 RDI: 0000000000000004
> > > RBP: 00007ffc1c177270 R08: 0000000000000018 R09: 0000000000000007
> > > R10: 0000000020001540 R11: 0000000000000206 R12: 00007ffc1c177388
> > > R13: 0000000000401169 R14: 0000000000403e18 R15: 00007f8ac0723000
> > >  </TASK>
> > > 
> > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  include/net/inet_hashtables.h |  1 +
> > >  net/dccp/ipv4.c               |  3 +--
> > >  net/dccp/ipv6.c               |  3 +--
> > >  net/dccp/proto.c              |  3 +--
> > >  net/ipv4/inet_hashtables.c    | 38 +++++++++++++++++++++++++++++++----
> > >  net/ipv4/tcp.c                |  3 +--
> > >  net/ipv4/tcp_ipv4.c           |  3 +--
> > >  net/ipv6/tcp_ipv6.c           |  3 +--
> > >  8 files changed, 41 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > > index ba06e8b52264..69174093078f 100644
> > > --- a/include/net/inet_hashtables.h
> > > +++ b/include/net/inet_hashtables.h
> > > @@ -282,6 +282,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > >   * rcv_saddr field should already have been updated when this is called.
> > >   */
> > >  int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
> > > +void inet_bhash2_reset_saddr(struct sock *sk);
> > >  
> > >  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > >  		    struct inet_bind2_bucket *tb2, unsigned short port);
> > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > index 95e376e3b911..b780827f5e0a 100644
> > > --- a/net/dccp/ipv4.c
> > > +++ b/net/dccp/ipv4.c
> > > @@ -143,8 +143,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >  	 * This unhashes the socket and releases the local port, if necessary.
> > >  	 */
> > >  	dccp_set_state(sk, DCCP_CLOSED);
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  	ip_rt_put(rt);
> > >  	sk->sk_route_caps = 0;
> > >  	inet->inet_dport = 0;
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index 94c101ed57a9..602f3432d80b 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -970,8 +970,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >  
> > >  late_failure:
> > >  	dccp_set_state(sk, DCCP_CLOSED);
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  	__sk_dst_reset(sk);
> > >  failure:
> > >  	inet->inet_dport = 0;
> > > diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> > > index c548ca3e9b0e..85e35c5e8890 100644
> > > --- a/net/dccp/proto.c
> > > +++ b/net/dccp/proto.c
> > > @@ -279,8 +279,7 @@ int dccp_disconnect(struct sock *sk, int flags)
> > >  
> > >  	inet->inet_dport = 0;
> > >  
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  
> > >  	sk->sk_shutdown = 0;
> > >  	sock_reset_flag(sk, SOCK_DONE);
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index dcb6bc918966..d24a04815f20 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -871,7 +871,7 @@ static void inet_update_saddr(struct sock *sk, void *saddr, int family)
> > >  	}
> > >  }
> > >  
> > > -int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > > +static int __inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family, bool reset)
> > >  {
> > >  	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
> > >  	struct inet_bind2_bucket *tb2, *new_tb2;
> > > @@ -882,7 +882,11 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >  
> > >  	if (!inet_csk(sk)->icsk_bind2_hash) {
> > >  		/* Not bind()ed before. */
> > > -		inet_update_saddr(sk, saddr, family);
> > > +		if (reset)
> > > +			inet_reset_saddr(sk);
> > > +		else
> > > +			inet_update_saddr(sk, saddr, family);
> > > +
> > >  		return 0;
> > >  	}
> > >  
> > > @@ -891,8 +895,19 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >  	 * allocation fails.
> > >  	 */
> > >  	new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
> > > -	if (!new_tb2)
> > > +	if (!new_tb2) {
> > > +		if (reset) {
> > > +			/* The (INADDR_ANY, port) bucket might have already been
> > > +			 * freed, then we cannot fixup icsk_bind2_hash, so we give
> > > +			 * up and unlink sk from bhash/bhash2 not to fire WARN_ON()
> > > +			 * in inet_csk_get_port().
> > > +			 */
> > > +			inet_put_port(sk);
> > > +			inet_reset_saddr(sk);
> > > +		}
> > > +
> > >  		return -ENOMEM;
> > > +	}
> > >  
> > >  	/* Unlink first not to show the wrong address for other threads. */
> > >  	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > > @@ -902,7 +917,10 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >  	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
> > >  	spin_unlock_bh(&head2->lock);
> > >  
> > > -	inet_update_saddr(sk, saddr, family);
> > > +	if (reset)
> > > +		inet_reset_saddr(sk);
> > > +	else
> > > +		inet_update_saddr(sk, saddr, family);
> > >  
> > >  	/* Update bhash2 bucket. */
> > >  	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > > @@ -922,8 +940,20 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >  
> > >  	return 0;
> > >  }
> > > +
> > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > > +{
> > > +	return __inet_bhash2_update_saddr(sk, saddr, family, false);
> > > +}
> > >  EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
> > >  
> > > +void inet_bhash2_reset_saddr(struct sock *sk)
> > > +{
> > > +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +		__inet_bhash2_update_saddr(sk, NULL, 0, true);
> > > +}
> > > +EXPORT_SYMBOL_GPL(inet_bhash2_reset_saddr);
> > > +
> > >  /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
> > >   * Note that we use 32bit integers (vs RFC 'short integers')
> > >   * because 2^16 is not a multiple of num_ephemeral and this
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index 54836a6b81d6..4f2205756cfe 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -3114,8 +3114,7 @@ int tcp_disconnect(struct sock *sk, int flags)
> > >  
> > >  	inet->inet_dport = 0;
> > >  
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  
> > >  	sk->sk_shutdown = 0;
> > >  	sock_reset_flag(sk, SOCK_DONE);
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index 23dd7e9df2d5..da46357f501b 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -331,8 +331,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >  	 * if necessary.
> > >  	 */
> > >  	tcp_set_state(sk, TCP_CLOSE);
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  	ip_rt_put(rt);
> > >  	sk->sk_route_caps = 0;
> > >  	inet->inet_dport = 0;
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index 2f3ca3190d26..f0548dbcabd2 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -346,8 +346,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >  
> > >  late_failure:
> > >  	tcp_set_state(sk, TCP_CLOSE);
> > > -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -		inet_reset_saddr(sk);
> > > +	inet_bhash2_reset_saddr(sk);
> > >  failure:
> > >  	inet->inet_dport = 0;
> > >  	sk->sk_route_caps = 0;
> > > -- 
> > > 2.30.2
