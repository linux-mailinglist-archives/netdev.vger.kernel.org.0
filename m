Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCF1648EE2
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLJNdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLJNdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:33:18 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C320611A04
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6a+nD6y+0k8hSmoj4wNCEG9F9mZ2g5aJw3jblSNhgKoNSYVAeQ3w6c5JdiUGZ9xX6DyICHE1vBSIFxEUnhfdHA55yviZ16GX2BmEdPjNjpOh4sBlXy8zkSQ/pzH/fbvNnAYxHiUfqx444bgp+hrl2hXhyCN/2qnGGpEjfCX9Tq9z8J8Ttxeg5gkckvfWu7kE7Sco7vHoqDNsB4Bd0V93RVOTLCIalw/LGQzqZhoSWRAkuh8f4nWQBPS7K9jAA9NLwKhOj9gXGTN7XTvYUTdRns2kHe9ymJVbb5QCxc1e17lFpNmavlmUGPq1KyzS4GskJ7hesblhFJ/VFoo5Don7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuCMPih4pfutIhIHC0yYlTVOYFxEPhnD0DIBx8tym7M=;
 b=QfcJLPIQrgckU0q7HrLble5drOgerYQ5sp+m+dKPPYipYgmtB3KgoUtW3VAu/0eue8qH4xji0Br74xK1jR/YUtGE488u9nBUhYEY8gbmLrFawr2h4ndXgMNMX/QB9ALepQGXU2QfAetMJo1FCxEul7BleTJbG1N7UeSYha/Of5biwehIMv4aWsVEBi3pfl9eC5mQa6gKCJbtJV2aeVgzZ5pE2F5i5ADYPKuv5cl47RDPRnVL+1RRzpD+syBzbLiFgj+BNK/Q6NB+Yjk+xe558r4yfYhfIn71pN9DrV6vkFmk2KvaDpBo5u+tx5GK1IET/RANV45RyHwYLnUEay+QGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuCMPih4pfutIhIHC0yYlTVOYFxEPhnD0DIBx8tym7M=;
 b=mNkpkNP1AWlGeXSDY82hBN2wkR4a6TDS6O5B1KeOxC7cvvcA0VnUOzo4IF0pfmpix3ea3MOxUqSMA3QdGGQTJL47PKD8TyJULNUQbnofAO7G1Q3uK9KAL2sPuwBnnbwcumMV7wPZk19X3Z5m9kjd6RNmc5pGVV+7dwzXjlYYrIFYQ/jdsLeSLlIgOF4ONxl27ieaD5fMHjixxyF0/x1NKj63AWJdHXfH7ZIFyhU96480Xz0htriw6jzY5Oc/Ey/dYCv/4z4cyg/yidmazK1eErm81zMA1Ah43EZpr9prtlcCZ40UnSZhZPuy/YaqtPYjafGl0iPyZPBI5njF56SY8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7107.namprd12.prod.outlook.com (2603:10b6:806:2a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Sat, 10 Dec
 2022 13:33:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 13:33:15 +0000
Date:   Sat, 10 Dec 2022 15:33:09 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 09/14] bridge: mcast: Add support for (*, G)
 with a source list and filter mode
Message-ID: <Y5SKlVl6cuSp1Ib1@shredder>
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-10-idosch@nvidia.com>
 <22583106-8f39-0c7e-1c61-47ec5c614418@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22583106-8f39-0c7e-1c61-47ec5c614418@blackwall.org>
X-ClientProxiedBy: VI1PR07CA0197.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a43527d-b487-450c-33fb-08dadab31710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SNt/qBgeUeNJj3TeFy8+v8Snuhs/l5GcggzSnUEAFS29vUJk8ti1neULLZPpnT88QGoWl69IHmkITGy/wojVopRUxnEe+qwgya3myCb6k6piPLk5DcVq63ycNaTDoe/Yc0ba2Gc5hfYWAAdaQjnOvDvdVl24y1ID8gf7aHiYok6PWMXXX8Q4NliT2erYA78nKBy2QKOx3Hui84NDaPsvmMjaF22BqwoL26y55kXMkPGV4PBlODycGttC7e2Gi1yfXDunUmievLKpn0pphv2FIeaMKY66K4+qmN7sc7x9aodbW1E6aKlHikHwmi2pcvETdLXWVUdsZGuSP+K1+8f2aibzMGGqmhVQwUdbXvVWhJxq1WYlelIyKTims0MaBap4DolfxTwsg0MFou3rd7JmifzD88k+Am+NiMied5KJtuXy5rZSU6CXqyr8li/JG8uEwl0bZZVjFabrKhnOv/fjd3MnTkrm/OSjFGoH5EGIsOZfju3Euwpr5cQli5flp152l/fy13nRSeB73x4Q3ekJbIqIh5Aoqi5NYrAeysE2BDA4w0j7b4hTIcLWOV2AZDi95RTlqj4kAD3ApfvgouSthTlkjZOdbANPOsjOj7F6ph2wgvxfmnHNi8Od4PeOsUg6QRryGedJXqcrodt43RZdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(86362001)(83380400001)(41300700001)(107886003)(53546011)(6512007)(6506007)(2906002)(6666004)(8936002)(186003)(478600001)(5660300002)(9686003)(26005)(6486002)(316002)(6916009)(38100700002)(66476007)(8676002)(4326008)(66556008)(33716001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mKrULLc6gCpcyxhNAJjmci5ntd8F393qQmlOvljM2SWADJqk2jdm4amHSmYK?=
 =?us-ascii?Q?aDWB9ZU3rubrteolce5yZGHVxUoY0zyoSBueltFKdfDkT5KuTOaVmBnl0eFV?=
 =?us-ascii?Q?OVwV6amEIk5qg9AscrXfU01ro4rBkVKZ5Ioc0ayEqKySxUb6cIixP+8EjlEf?=
 =?us-ascii?Q?Lma//QLRNYpkwfk0MAmfa1XAAviRxQzbYzFq/oCu8wQTmxiUGmiRwyyYzi8M?=
 =?us-ascii?Q?LSsLTBKd39m1clsUwaakX06VT+3Grcxo1HJcHBNmPi/UbNQ02yZV0fp42Au0?=
 =?us-ascii?Q?OsCgIEvdW7btcA1eXPZvnVAf/wWJgdJW5D+vuJJ1NsYRyJuSWGoATbaaZrZD?=
 =?us-ascii?Q?CFzjyxYu5E+6lIHTL3x70U9bKaSD2UxiIVe7q+Kcuph1bBJ+nfGxPnXFk1dT?=
 =?us-ascii?Q?NHOVVyopG/6IgMrw4EmKjNF0bmPZjZ84PHcKfLiENkkAWOtO/rGakrSAMhQY?=
 =?us-ascii?Q?3Sz4evWaPyXkt7K8tb9y7DX6zc4H1gEt4LL2I0kLcIE4Y7LUVUIBZqkPpCgo?=
 =?us-ascii?Q?z2FnJ+5is4eZrPJL2QeARSngdbaV8q+xm13edpMehmOVukVaaI1Gtbz3vdR2?=
 =?us-ascii?Q?j6LnT5YruVY3oNstNW/Evpx5PHxbC647W+TptGeXqeUmZ3LxEzxo/JUQqnS+?=
 =?us-ascii?Q?b8FXL6fhEK2XWcv3K3pDeif0zeoCuOQniTGL3pbyE9oPlgtPnaamfe9LU3cA?=
 =?us-ascii?Q?pUuLDwq1loqUjOn/TD95nCPevBZvdB87kX+TMEmJ3N1QZetC06HYPHw4N0hV?=
 =?us-ascii?Q?FyF4knH4y4XosCIl4u+ZRvnrvk/pOE6yPvo00OLWuGQUFGqL2slbQzSBEyr0?=
 =?us-ascii?Q?XlkDlOVW20qdb3aGP4vaLJSgsHiMbeYScCfA5WmCeCaG5V3zB1gP9xRjLOlj?=
 =?us-ascii?Q?AUG4aiiPR1hvZ6Rb5J8/lIHL0kgnR3RLtvd2Ru6wH9IpSuqnH1G57Ob5Smf7?=
 =?us-ascii?Q?/lsB/30JlP/zOOawgE1uASsdXYP2D1UUxgaWDKm2StBLt8CZMY4I5M6p+Wxf?=
 =?us-ascii?Q?T3QLOLRjuY4wvD7YDmjtDhJOC67+kRnebh8WiqLYqXgLGly/iFnKVM8YZUdq?=
 =?us-ascii?Q?xAjSRP/ZRtS0ps3t5tOwGpHkdODXFZ2UP3DN07DUlx9qb30qRpsGhHv9yUqp?=
 =?us-ascii?Q?Jk7CAlhCQAPIGz7fdXT4bhuAITPiNnpBDGmu3Qsj2Rmi15ZAexNsIofzv1Hv?=
 =?us-ascii?Q?N2z8H1mQX6Xa10KnRxcYK9HX+oNFO/cpNDKIKC8wJ74jLMCrWZyC8u7ajEEH?=
 =?us-ascii?Q?69Y2YJJcsyMfGZSSp1SkYYPAZ4XBulWJMSto+v29bHPTHVVcsD6vSblKqyAr?=
 =?us-ascii?Q?KvupPTIlPgUKr4Dm1mQ4UK1hutvmIrr6ngIgj6LZt1FVSMonyulmzOaxuXj9?=
 =?us-ascii?Q?PqMc8XdWPSGP9HpqfzczEr7CqMoGbcFqQmm6HTBOHCJC+kBeglykLOC0PvlT?=
 =?us-ascii?Q?2OIXyTbklEU69Hm29eu82CwYxfl7jLkfU68WHc3GZzXfOehU1wCNSXplR3Xv?=
 =?us-ascii?Q?hdRIFDXITGq2Iy/sbW12aEmZnq1dj4kvJ1uyf9T4NjDyDJrHfCAf1o+C240A?=
 =?us-ascii?Q?DBVyFBesUCP54Q0zIlx/e7Jo4yS7tcr68fDYEmme?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a43527d-b487-450c-33fb-08dadab31710
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 13:33:15.0097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYHQYKTP6xiUwXExIDZHuyO+oRZK7F2ayI2LFRm44vaH0YwAYH2T0cDxjWEXGZqZr3EsR24UjXdu8Okq2ILf3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7107
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 09:41:05AM +0200, Nikolay Aleksandrov wrote:
> On 08/12/2022 17:28, Ido Schimmel wrote:
> > In preparation for allowing user space to add (*, G) entries with a
> > source list and associated filter mode, add the necessary plumbing to
> > handle such requests.
> > 
> > Extend the MDB configuration structure with a currently empty source
> > array and filter mode that is currently hard coded to EXCLUDE.
> > 
> > Add the source entries and the corresponding (S, G) entries before
> > making the new (*, G) port group entry visible to the data path.
> > 
> > Handle the creation of each source entry in a similar fashion to how it
> > is created from the data path in response to received Membership
> > Reports: Create the source entry, arm the source timer (if needed), add
> > a corresponding (S, G) forwarding entry and finally mark the source
> > entry as installed (by user space).
> > 
> > Add the (S, G) entry by populating an MDB configuration structure and
> > calling br_mdb_add_group_sg() as if a new entry is created by user
> > space, with the sole difference that the 'src_entry' field is set to
> > make sure that the group timer of such entries is never armed.
> > 
> > Note that it is not currently possible to add more than 32 source
> > entries to a port group entry. If this proves to be a problem we can
> > either increase 'PG_SRC_ENT_LIMIT' or avoid forcing a limit on entries
> > created by user space.
> > 
> 
> That can be tricky wrt EHT. If the limit is increased we have to consider the
> complexity and runtime, we might have to optimize it. In practice I think it's
> rare to have so many sources, but evpn might change that. :)

Yea, we don't currently have data as to whether this limit is OK or not.
Once we do we can make a more informed decision. Some options:

1. Slightly increase the current limit.
2. Remove the limit and move to an RB tree instead of a list.
3. Only install (*, G) EXCLUDE entries on the VXLAN port and let the
VXLAN MDB do more fine-grained filtering.

> 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> > 
> > Notes:
> >     v1:
> >     * Use an array instead of a list to store source entries.
> > 
> >  net/bridge/br_mdb.c     | 128 +++++++++++++++++++++++++++++++++++++++-
> >  net/bridge/br_private.h |   7 +++
> >  2 files changed, 132 insertions(+), 3 deletions(-)
> > 
> 
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks!
