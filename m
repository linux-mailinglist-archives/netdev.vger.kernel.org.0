Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F028483E00
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiADIVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:21:34 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:37176 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232321AbiADIVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:21:33 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C9F604C0061;
        Tue,  4 Jan 2022 08:21:30 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBx4UT1d4UT/68UAKapuzVTgcO5XMAWzsNfTYO6tyW6ayBD9EMc09yNiPgxNBsrQ4PAJFiC6xOQ5MvmIncbDuubXOEu+k8M7A7BXVNBTS1wPNioG3xFejvqUCFvaneBLuGeC+1heYIC49UeTH2zDSx344ZQWsnhOfij7oqxj9JYKSBN9LsVIkx1MP+qEigX/i0AaZoYMaD8vJZnJDnRAJpZL5nxZyyV0IsbsTTyOC1L9kRJxmwtlIrsbNxumi1HZHvCkPZ8J1kD5gxCgEZSS1MetFhUb7fsH7CotFqZ/DE/5kT6Y9IL6+L+chUtrdtUUfZvwuKkYbUWvQkChg9/8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDryGJ7yceiuCk+nA9+PGbRCqfpVGZAu5JrIDJ6wd/c=;
 b=mfM8PpdOA5rw4/fxuzK++0q16Ld4Tc7uXdPCOzVy64DAVGyD7WH+rik1SWPmKGwuRwNS67t/x7GNQwTLYc3pJYoAWTS3llzwBMSpPT1s62JZM2A1S0nUaNeTrSwNSX2BRxba+Ok4YsTqk/0hVQdxNdw/rN1j/JUzlMaxHN/lI6hZaWoipFt4955/i/Q8NvPI8nRzUBxiiVry3/ngvh880JhlCkzIQ0RilK3LIAgMMHCog4UOOnzPru4NhE5WX/RewNvgwru2uWy5VQTh5/otejaRbgP4dqgIMSSxPDGeBNcAsObXGEFAH9xZ8sp8lW5f0bJW5bOpysXiMLovvZURag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDryGJ7yceiuCk+nA9+PGbRCqfpVGZAu5JrIDJ6wd/c=;
 b=cJnU5CrRQ3s7GQ31zDba6QIuA9RIHlxKpLDdkd7sHMEo5RjzbIpRsUpKXBnTkAfzSipPYO2fZ/tJQM/o9p4LCZjVKlOHksiE8NpW+ya4sIO8M6QaJJyg5vyVhwcun608t8RMdOVOT02ZTIwCbERP/w+MjoHUz/Mut5bmy1MT3Pg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB5853.eurprd08.prod.outlook.com (2603:10a6:800:1a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 08:21:29 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 08:21:29 +0000
Date:   Tue, 4 Jan 2022 10:21:21 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220104082057.x34hxf7pf4tdo3zd@kgollan-pc>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
 <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
 <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
 <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
 <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM5PR0701CA0019.eurprd07.prod.outlook.com
 (2603:10a6:203:51::29) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98201edc-19c0-44aa-9dfd-08d9cf5b356d
X-MS-TrafficTypeDiagnostic: VE1PR08MB5853:EE_
X-Microsoft-Antispam-PRVS: <VE1PR08MB58538356905D913AD8F4ADBBCC4A9@VE1PR08MB5853.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjNn3iVNOtxB4NZcZRybWrmuv/WwlqbsPc+20fJ3kZybasI/h3mnTKRq1lXBuDG0mxU7vO9gSxUpt/i9yfHAVWrh2ykyaJyGOVBuwo3n+KEvnrcsLXapBaRLfFFghhVEE1BkjMOvZv1iPlqQs2WorV4/T+SAgn5ZObiMQNGmFL0j8WyEgOVoPYIFD2KRxWg2VCOrcHxbPMUOOvISeXShzTIfKFScsY2uy3MZsaDPZkBOtClAWMqmYFVgy1ukPe5InR6M3/L+0h9+9epgOWzbrORNA6dnUDBhgOAejt739v1Ir4/zJRl1nrcVgq5CUYijXu1rIP+bJ0UTdgHOwh12VhKaKyuOoVcBFS/Q5JeYh/oqsqeKCpEfp7NzgR+XuTkUuO3CRqjCZzLKKUGA8qn7BfV0Y95KWD7QjTzQBC738GjaJHBUDw0fmSGZq33ddUCjav5J7O6l88ZSVWqtm3kafCx+geTOtd5F8BM8xtth9qTzfHEE56YUuA/BQmZtSAmNal80iemQJ/FlWK55Gq/E1kY2yrHA0dr/h3kTTdcFPgLXokvQI0Yrwi9l4ghtU1ei3ft/eJthFcnPNAHHN11eXC7s4KBOmP5HiMFYFz6WBFKBg8gwhvdc7bpqDKrH4otmyih67H7fjZNGrXcCpRmbdHttgE89jozR80SUGV5sdRHAJLnNW/1WMnb0K85OISrmST+krEhEkYcHVbIFIkKhaNPUvUElVHjVi2W9U3m4N+J8t9joVwF+LFNC1ixdC7cVg22oBIa+BViaQVi5tiWX57IIyTO0SKprfC//W6cXd9Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(86362001)(66946007)(66476007)(53546011)(508600001)(66556008)(8936002)(52116002)(4326008)(33716001)(9686003)(8676002)(6506007)(5660300002)(6512007)(316002)(6916009)(2906002)(38100700002)(1076003)(966005)(38350700002)(6486002)(6666004)(83380400001)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?plygLYfz/f6EHyIA/yUJvIEKZ08Vfg1DUWrow3vm3dMh2txQ+PrdGr39XO0C?=
 =?us-ascii?Q?Hq+nu1Vs6cgLl9stQMu3Z6sa9KP/jo6FXBMBdWfiKMMrtd7y9e3f7ET3D09P?=
 =?us-ascii?Q?Qomu6Gdhw8+0xwRAYgx/lL1cmMxjH9RcNRwbhg+Ez//c/wyg1XHREQqp2o98?=
 =?us-ascii?Q?PZdKChWyKPNa7ZSqgCI2E34mHyMa5XuwOKTbCNIVKohfjyD2/KpWz09oReE8?=
 =?us-ascii?Q?VG5OqcHW4En/BMY13CLayvzCd3VD6U56VvOmbvx24zalqT+7PTePgCZSfq9L?=
 =?us-ascii?Q?EVqFhQahu2eqGaaUT7Q6sgbSEVsDTtwsTQrf6Fcb3RR3rH6EWkbindapVgZH?=
 =?us-ascii?Q?uZO9e/QSsu7OTFWH9wHYEO+UZmFAjX9XMQLX1qq+oJXzGYhYkWlcBASgTsl1?=
 =?us-ascii?Q?Kq5maf36EeG8nxUmAZ3ynzn9cx4P7gHC+O5Zuu8brxxMH4VkXAdqlDEb0jJc?=
 =?us-ascii?Q?1Jl7xs5dIiVLKwKcyTLXNU/uVGE4l7qJiKJtBJTBvHVcDjLxqP4bJ7fSnpca?=
 =?us-ascii?Q?vvtvmuA88as90s3mSGYJiWGl2H0OQ6ofCl4HArsEkDamaTBjFy7iBxc7W6gc?=
 =?us-ascii?Q?byl9yJ6GWnDOnImj3N1BFAte2YJZZ/XzX7YCFr4vCGkjBlQpK/y4CnbTCmGq?=
 =?us-ascii?Q?6YGNeiHlJQfnJB7UpVIeI7OaFpf6WE9OesXGv40JowOyBVY3LJp3SxRfHKb0?=
 =?us-ascii?Q?w3QIgnk/8THbxeFTKKBOMgy3OskT9ilgX+AbXUuAaJZuPcKXw2QnzbGH0fdw?=
 =?us-ascii?Q?V2swy9AD8BiDwcFDKCVPmarC3o8F66GSDo6myyEpyvXKmwP7RlWj9d2tK0Wm?=
 =?us-ascii?Q?w0i7xxQ9gYi5oP3hjZWiq1syxg3LZzDL+eI9RtIM1pi7zExsCcFekIrkXPLv?=
 =?us-ascii?Q?mPybB9NFWO0GF9Iwo7kDxrNkP7RYU4qizAWA27uxmsiHlSizzZY3p4iWLp8D?=
 =?us-ascii?Q?a2F4D/6qePrWfd+5AEvdodn1qdMyqqVxFdl/hklunRrm1x5GRYQVUpPiXt1K?=
 =?us-ascii?Q?OPfSJpsY14ZusujVkEuS/9jrC6n064rZDQ3MZtVu0ngFRrLTSZjZlecNurFn?=
 =?us-ascii?Q?Ele6mx9lpuQXedJ/RcZg+nEB3E6WYVIKwTHYsAwb/pOydbdm56nXCqhmHoHR?=
 =?us-ascii?Q?CaC3PWOplSTlJYBljeSg3sgMbRkn0lrmhkc5uBVccVv08hAJ80XYxQTHhEyy?=
 =?us-ascii?Q?B7uU9pz5dLliKDa9zv8dP6FYrAI05o/VPpqdpvyRUPp2JiiHzstlDgIn2YZr?=
 =?us-ascii?Q?xVR9CYYOwPB3EL2kxQ/n3NOUYtHHyeaZNIKjQLc2TJY0bR1upuYGwDWivXv6?=
 =?us-ascii?Q?gTHPPqLBTh5RN9FFub0/+t1zJAyaI5D9Bzf3CLLDbEuIDeSi8vjosrtR50RV?=
 =?us-ascii?Q?PAel5/fCi4V113mNDZNEbtOWpvyY/JpkCz0572TpoNSR3Y6O5DnIdUlEoXMp?=
 =?us-ascii?Q?v9yuGft1RwJnHWrso31m5lNxplbM0BTnNWzK3P8qq9lMts/AWR0K0xJY1Ea1?=
 =?us-ascii?Q?dGu+fWVRb7JBkUL8/BD61MI4OQSH0AH2Xd4KgTkAedMCzONEjkAALppmwEV6?=
 =?us-ascii?Q?XuY6emLi1ix5E3doa27cCKqvg1Eqkhr69hyg99EIPE3yg6bseTUMUB80ISbo?=
 =?us-ascii?Q?1rRfolFSx1MwGctOrwrssgfCdYoC3bP5VRQt5mZF6hs3FN1z5S89Fio/sWh5?=
 =?us-ascii?Q?foNXExZQV436cWOVdZeBhbXRzXw=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98201edc-19c0-44aa-9dfd-08d9cf5b356d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 08:21:29.6674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gILKpL8Jx+sNGNXOlPK8CoH7Rp5rjtdHUG5j0sTl0SFD/Rryh+5VOyDYPXgMtgFGTBQCz6lGiH/iXDaJ/cBz+tNLHWeWXpaPs0zezSYiMgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5853
X-MDID: 1641284491-PZjyetU2pNte
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:45:44PM -0800, Jakub Kicinski wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Wed, 8 Dec 2021 17:18:48 -0700 David Ahern wrote:
> > On 12/8/21 5:04 PM, Jakub Kicinski wrote:
> > >> I think marking the dev's and then using a delete loop is going to be
> > >> the better approach - avoid the sort and duplicate problem. I use that
> > >> approach for nexthop deletes:
> > >>
> > >> https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_netdev_net-2Dnext.git_tree_net_ipv4_nexthop.c-23n1849&d=DwICAg&c=euGZstcaTDllvimEN8b7jXrwqOf-v5A_CdpgnVfiiMM&r=-WbGKi6-8WU3IfnrkySymtcZWJMn_aVdolIPebPZGu4&m=td9sv1_NnALM3QjLFg8h9u1P7DUJJL2YhzqyneZ95Gc&s=nEGgvxCwd3MrSXWhv-5Fo7mUlBkuKbHRBAO4VO9mG2o&e=
> > >>
> > >> Find a hole in net_device struct in an area used only for control path
> > >> and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
> > >> and delete them on another.
> > >
> > > If we want to keep state in the netdev itself we can probably piggy
> > > back on dev->unreg_list. It should be initialized to empty and not
> > > touched unless device goes thru unregister.
> >
> > isn't that used when the delink function calls unregister_netdevice_queue?
>
> Sure but all the validation is before we start calling delink, so
> doesn't matter?
>
> list to_kill, queued;
>
> for_each_attr(nest) {
>         ...
>
>         dev = get_by_index(nla_get_s32(..));
>         if (!dev)
>                 goto cleanup;
>         if (!list_empty(&dev->unreg_list))
>                 goto cleanup;
>         ...
>
>         list_add(&to_kill, &dev->unreg_list);
> }
>
> for_each_entry_safe(to_kill) {
>         list_del_init(&dev->unreg_list);
>         ->dellink(dev, queued);
> }
>
> unreg_many(queued);
>
> return
>
> cleanup:
>         for_each_entry_safe(to_kill) {
>                 list_del_init(&dev->unreg_list);
>         }
>
> No?

Hi Jakub, I just sent a V6 for this patch. Just wanted to note that I
tried this approach of using unreg_list, but it caused issues with e.g.
veth deletion - the dellink() of a veth peer automatically adds the
other peer to the queued list. So if the list of ifindices contains
both peers then when 'to_kill' is iterated, both the current device
and the next pointer will have their 'unreg_list' moved to the other
list, which later raised a page fault when 'to_kill' was further
iterated upon.

Therefore instead I added a big flag in a "hole" inside struct
net_device, as David suggested.
