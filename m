Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838536C2C99
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCUIhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCUIhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:37:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2096.outbound.protection.outlook.com [40.107.102.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BEE1CBDF;
        Tue, 21 Mar 2023 01:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igxHvUekYn38rBFcVTyZ6/LVGY7r6tPKrervHRYVeEuXS3SnXtzQvM3DGNrjjgSkje/Un3wqfVgK/GueY//FP2VEq+16WZoNFmtRENtK1qb8WyQURUl1QW4quXq+Kl9Mx6/o30STZRovgOZZ+CjYHnUN4ww/n8PavqoF8fx8qwVqjnQvHXCew22qDvJPsoruRxT7vKda+CCih+ouDNgRwJdBq7N9gczmq+lO/1h/PYk+EaAjzQLali3EK6SXvcCzkVQyR/G7EIFf4ljqyehZVOxHQp/Deol/H8d5lFqW0OG+WeB9o+8+L/Hj1l5QMGE8mPBkPWKXwag7AsZ+KNwdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjcqlEi3IPTeRea2A3PrK5ebQVqQeXo3W2+tp4UQYgU=;
 b=BBaok625yXLPJmfJEUKHg5UhmSGKZGCLSI0t4bvLG8IzD3P+ufYi6B0cndqjKo9tV6mGgJ21X4JdBtOtSB9iWe5zCKyetHl9COP6q1+N5t01e2YDZro5PR8ClVt9tRyi5V5giyBBV5FvY8EGI8km7/Mu0+5BhDmmmn8DlZ4MbJSUeadn4RGLASVCoqbwUuU/WVWafpwS+kNUPR2lqBmOtrCI9cDwPbnJIjqXNNHFtGAqmERlT6SrtHZfVBhLlLTMDxX35ECc1oipgzNVopptDiFTiZe8aXR/X+6ZHadQUEdIzFk6F0VW4rsm1wwUaw7aSefwx6ODLWovx5/NW6hbbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjcqlEi3IPTeRea2A3PrK5ebQVqQeXo3W2+tp4UQYgU=;
 b=aB385sNEmkUl9fIx0yIgvuNWIpto6RRTHegyWlQF8eCiggo/Zzr1o9ThgZPU6cXLTsfs1ejl4F3cxdB1UBXxHXYIwhaT7OsRTLL/FWeIR7nU+I9KP7lWeJaQfdV7RsoFwjpGDos40Il160TWjMO5K4IxuNLNDFnD5Dl+EQaqtdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6116.namprd13.prod.outlook.com (2603:10b6:510:2b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:36:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:36:29 +0000
Date:   Tue, 21 Mar 2023 09:36:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jia-Ju Bai <baijiaju@buaa.edu.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211: Add NULL checks for sta->sdata
Message-ID: <ZBlsh0JFBagmPNCA@corigine.com>
References: <ZBiOhAJswYcAo8kv@corigine.com>
 <9b213efb-8c7a-497d-2e08-f404d174a6ae@buaa.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b213efb-8c7a-497d-2e08-f404d174a6ae@buaa.edu.cn>
X-ClientProxiedBy: AS4P190CA0067.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 77fc3513-ad48-4795-2f06-08db29e75e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LteDi4Mmu8H7SICrGWFm6Urh+zBQMrnzE8Ay92gf0eEXH9xbVqtoDkvDHenwCzd89HC+HsMmzgCejtDP7Fdhb9uDvgtDGfs51dhCuxyEDd5timsde6EIiMRS6qTx63iCVnk9lFW//XMu+zj/W3UFFs/Yn1f3C3VMUX3wgkyDd+iqarBTz3ZkwtkdpGVzw7OGF/W+KrbFOyAWsF4m2EIKHAfbX9mpwnGtnX46S/GQOt6pEj8uFvIYeOT6ytDcyxVYO/oofJnaKxyiEH/IBKJQkz81eCJ3Wk2zzQUc4+6SKVdg/bDEma+rrZ1zaOTozMin4G+DUl7FekBinVLKmn+TKiQC5Ycdbr4jLTifc9lwk3TBuHxFeopLUIm61tmvn39pIzlFZQJpwiZoQsCR3ZvkItPhqXkL2buFRjeEuK98sxVTdOi5DPILgwaKLmKsJKup+iJJZerHYslsvwUU6phh9MXjwQwe5cmy2LBt9gtwF0VRGpo59nrvzUH8OcMlJqBzbQVk7UhFWdmON6P/pyQJj3fYzXGGt80fWgnzA7ZrRyZfOcgxbHQaSbo/j8jItKa9XN4idYpySplf6Zqfs9BHyaBwVw5thtZyH6JZ6Ag8yn8h8gRyhY8vS5FKauiGqIsb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39840400004)(136003)(366004)(451199018)(86362001)(36756003)(66476007)(478600001)(66556008)(66946007)(8676002)(4326008)(316002)(8936002)(44832011)(41300700001)(5660300002)(6916009)(966005)(6512007)(6486002)(53546011)(6666004)(2616005)(186003)(2906002)(6506007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rz4LPGDwkRdBax+cwkoGHRGzaSlBiVve116Esr8kEEHTuegtMA8z3/CQ8u3M?=
 =?us-ascii?Q?/RjSxsTPNTv5VGBjZfStA68YUZVw66s5K4mKPpdBA9DQ/+3H4Xx4Ohyi5Smh?=
 =?us-ascii?Q?OtMZngQEHMct68K7gVKs2K1XzMRqbWZhYUyG+pKrpibjajJJTB6c9lHWUP03?=
 =?us-ascii?Q?CK/WTYWHkw7USxDaJVE2pzx+E1Qo5cppvuWsIOaazTI6kIUrmAyIrOsJFnVz?=
 =?us-ascii?Q?Md/qeOsmj+XDyYikn6ovg78b3WdAiC1+jIwZuCtpL0s5QOXNsKzEp+htJ6dB?=
 =?us-ascii?Q?wDld6KTUbbegNdDQUJCUDLhLfIUOLaWNHUOVEH89xnDMCAQzatKnTA5bECE4?=
 =?us-ascii?Q?w06NGsuIdh0Rt8Y3wC8Kh/SS4iyTj7xhv+iVhjd2KZKmen4IyFMm9Ejl3kgV?=
 =?us-ascii?Q?knqycakWHUbsM/6NiTQyncr3oyXWOUvpv/pPeNFYnqvHYDGwjIFV69uFpLD2?=
 =?us-ascii?Q?wEHAg1Uf/8EFcoBcYe7ystR4Ij2VvS+xrXktSbhWHrcoIwtgx0sCtpziRu4A?=
 =?us-ascii?Q?Ps+B01c0z/s0tV6dxrjd2dwh2PKkZu22C5KAB64mZI9Q+gL0uAPwF6JMzRsv?=
 =?us-ascii?Q?PsoxMzdMzOVAoVHGoaJPgXM0DjRIhawHwe0CKRQlfUMOAcVzx2uNccDk6kg9?=
 =?us-ascii?Q?FsvAe2kq/bYBIOaUN2kGkj/nLMcQMnxW1siBiV7Pb7PPQTw+bM56vfQgAvqq?=
 =?us-ascii?Q?3cGPvPw8L3eoDzh/o2ewnsNR0sg69YC1FWGPog5DieN0jY2SEkMSKIARjnOD?=
 =?us-ascii?Q?dG5YfhNPSfpGXuQjrpdouYX4IaKUjz1u9cmI5v1WLdXtUeondYnpzIwuQ+8X?=
 =?us-ascii?Q?zys78Aa/o06NB4I+LReEVsxOw1IJoF5aQ0ujYQg7Om8BPEVXKBevoMBIfsPD?=
 =?us-ascii?Q?UYFlQjM9lg/3mCpRhi2NB2TLSdo8pmf3bFgQi9Y2ewvc0y99UJR1KPE0fTdD?=
 =?us-ascii?Q?fXTSohMinLS5ntTppVpISLlCAeojQz/M56pILvDAwBJHO9K38PzOzaTU1Adn?=
 =?us-ascii?Q?qdUx+UfhPsx3CQ3pGxEKm8jFx/cthsxF0WIWp+EvMOoS/dBGvwfSGZwPKrgM?=
 =?us-ascii?Q?d9efEKGuLXyJMbPrNrXgatoE7kGt2H2spSpzHHsBra6GxQmbxSsjDAEqZmms?=
 =?us-ascii?Q?L1uOB8Smy9BMx5gPDVDYbeMf80eYKIyaf4MFZ91t7WrohGCLC0RgERDxXaoo?=
 =?us-ascii?Q?F7xY7V+m7KeW18yLCtTmwwH1zpxpsNJA5vna4uhbN4sQsear9WDmq04LDJ+Z?=
 =?us-ascii?Q?8x5n3e8YazVBa2evlMlwVMCHNw02R62AXXztEw1Qybtd9MZBlGwilhb+pR5W?=
 =?us-ascii?Q?cx4XHWpSP2ty+wHOGp7jhb7tOW+xJ4aeaWNikohwzVNobdB58+xi6JF7H7mR?=
 =?us-ascii?Q?2hQkbtLudb2a17LLsfoMi/nYAfhHDdubeqKaWcFXFjRjhbz+FYPu/ro9z9CW?=
 =?us-ascii?Q?9GcxHYo44vDheB96PrNTiZmZ9VQTi35eFlp+ddiUZlg+Y6UKRUPAl48cLGMt?=
 =?us-ascii?Q?ZO76lksHOpIoWxPrq5gTXk6SFiSubjpMAo9SgR9z/QtQqwNTV03/9/PIsKq2?=
 =?us-ascii?Q?yAIUcH/CMy5G4uo9ZjQfOiDRuArH2QiLmtxUp0htXo9MSHZZD4kPxWPM0kOT?=
 =?us-ascii?Q?n1I+adRUGINBjMaw0NHE+0CMLIW6ajMJy8om1oFkieJOUUAntzUlXaj+jFu7?=
 =?us-ascii?Q?5x1RTA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fc3513-ad48-4795-2f06-08db29e75e06
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 08:36:29.6110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gheicHfwVaQG2fIjM0qrSZSZrmp11D57swc/6u+1l4W42mTfpyA68EAagjGBSx8nE4x52ST2HK38BBSyQNY2uxs8rQykAk7JNC+NWje4gCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6116
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 03:40:40PM +0800, Jia-Ju Bai wrote:
> Hello Simon,
> 
> Thanks for the reply!
> 
> 
> On 2023/3/21 0:49, Simon Horman wrote:
> > On Mon, Mar 20, 2023 at 09:35:33PM +0800, Jia-Ju Bai wrote:
> > > In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it
> > > should be checked before being used.
> > Please run checkpatch on this patch, and correct the commit description
> > style.
> > 
> > ./scripts/checkpatch.pl -g HEAD
> > ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 69403bad97aa ("wifi: mac80211: sdata can be NULL during AMPDU start")'
> > #6:
> > In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it
> 
> Okay, I will revise it and run checkpatch.

Thanks.

> > > However, in the same call stack, sta->sdata is also used in the
> > > following functions:
> > > 
> > > ieee80211_ba_session_work()
> > >    ___ieee80211_stop_rx_ba_session(sta)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >      sdata_info(sta->sdata, ...); -> No check
> > >      ieee80211_send_delba(sta->sdata, ...) -> No check
> > >    ___ieee80211_start_rx_ba_session(sta)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >      ht_dbg_ratelimited(sta->sdata, ...); -> No check
> > >    ieee80211_tx_ba_session_handle_start(sta)
> > >      sdata = sta->sdata; if (!sdata) -> Add check by previous commit
> > >    ___ieee80211_stop_tx_ba_session(sdata)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >    ieee80211_start_tx_ba_cb(sdata)
> > >      sdata = sta->sdata; local = sdata->local -> No check
> > >    ieee80211_stop_tx_ba_cb(sdata)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > I wonder if it would be better to teach ht_* do do nothing
> > if the first argument is NULL.
> 
> Okay, I will use this way in patch v2.

Maybe it is not a good idea.
But I think it is worth trying, at least locally, to see how it goes.

> > Also, are these theoretical bugs?
> > Or something that has been observed?
> > And has a reproducer?
> 
> These bugs are found by my static analysis tool, by extending a known bug
> fixed in a previous commit 69403bad97aa.
> Thus, they could be theoretical bugs.

Thanks, understood.
I think it would be worth making that a bit clearer in the
patch description (commit message).

> > > Thus, to avoid possible null-pointer dereferences, the related checks
> > > should be added.
> > > 
> > > These results are reported by a static tool designed by myself.
> > > 
> > > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > > Reported-by: TOTE Robot <baijiaju@buaa.edu.cn>
> > I see 4 copies of this patch in a few minutes.
> > As per the FAQ [1], please leave at least 24h between posts of a patch.
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> 
> I am quite sorry for this, because my script of git send email was buggy.
> I noticed this problem after sending the e-mail, and now I have fixed it :)

Thanks, I realised after I sent my previous email that something like that
might have happened. Thanks for fixing it.
