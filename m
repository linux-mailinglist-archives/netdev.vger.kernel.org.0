Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A46F46F3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbjEBPVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbjEBPVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:21:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13D2268F;
        Tue,  2 May 2023 08:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8160N8ibt6lLcXDFZnlSaXUYMlveK+H07OKXxPvgH3kABh+cKAkmmBc0WWZlHRWFjLwkoVQnYJFHy8SivTSdr3FLvaTTsYU+OeZAiCS56TFCe4ZtvspJvEbo7gR/QbQ9TMBkmaDZOd1RWbQ49Tc6A9jfRMfLhm7f8EmFDbQ2RkF2bnRgpswjij8wmxZkN3pQZ9hqD6GM4Pjvesn3r50zkCtOMy1ITHTdRPpsO4wChDPfN71AfDFk3lEbYXP/5+uMEFdd0jA9tGN69bYf2G4eH47rtSKwXRPbt5dOuwxgesc1rzmPv91PnOzR76YlwaM3D7ShO234EbLiimUOMTriA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXHZRDDY1/oONO5YkSIVHScmleT+xOQGcl34AU5PV74=;
 b=oMOBoJL0eSuxHYD9u8+6WzAa2b1BjWA4TOxFkChhzEWXMDAkfQdb4svHPW0FOzJ67OOIk/JTMEUtDrxiE3Hdzz45KrDWv81AgaIb+DLQ4gYHF5WKbpQghOfVCDScCPco43uzi1v76TBdLxTc1nyPdZxkyscvoCcxfIK43dj5Nqjq7NtvmHXmqK5Sw4GGTEi/LsQkVfggd3E075pj1SGGVgDFsrKF7Vf3s5HG46rGEf/3xifQHSchQtblZ8Q8O9lbkuajoKTYn9ZlBUcPHY5wz83bW8LiS5UGzyAf0HaOzQTJ1x9MG+ipkAGUMk5JbFixNHS/Om2xV/fh7n0TmXgBbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXHZRDDY1/oONO5YkSIVHScmleT+xOQGcl34AU5PV74=;
 b=jw6MPqt2CsvojX/JU01Z6V06zM/+eEk/st6xEugG9wdFVo6nwM2e/8LjXdnY2qNFm743sbN0MjSHm2xCepsqZxL60c6KeeT/tGuoLctHSPW5gdrJCdydS1OIU9vBaayZN9LsviTjckbJH8zRqZZbzBwLNVsl3LBol31Rvr3hqfjP+dwQUB7jqsQLECuAOTkVQNiPEdca4SduY5FDLMkUr7AW08O18rORVWNi9iLVh2/Bv1ohmDKlOKGzUSA9rwyM9iI1jGYd6HWmiKlIIR4gu3ybiA2dJxtYZAlp5c4u5tB8xzX4fLG9/i1CoCNNPfkFGjXB4nKhtbct4Rap1yhwqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4507.namprd12.prod.outlook.com (2603:10b6:303:2c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 15:20:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 15:20:48 +0000
Date:   Tue, 2 May 2023 12:20:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFEqTo+l/S8IkBQm@nvidia.com>
References: <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
X-ClientProxiedBy: MN2PR15CA0057.namprd15.prod.outlook.com
 (2603:10b6:208:237::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e42af9d-8900-47ce-3ae1-08db4b20ce40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMtG+ai+89aB4xwBtJ/7Yvk6WsBL3AJRFDnwwNDwyDO7ExTQMBkeAob7SJhBMOL8TTSDt9ZCb5e0PgJq0qkvo1uFHHoqkuC8Temt38YY2ezv1/jgxAUSsdOyEkEbJ1wnDJLXiUYMHrPES9JD738Dtog/ERqnLnqhN3dONw00tuOXP/9c7FywSj/+/hVD2uKUmr5fj/5IKRdhbU8bTHAkGo3TB9R9KHEg5P5YWrt5BmG2J+pkoJ9adAbTtgVYM6DdQ/1Sibb5oFyfYktcix0JXryqbtWN2AME3Wg5bOPzPtiYg+HClvoEInMHlSxpLsvJB+CoTty/yOtN9ebMjMIPxxUEueNuliWzk7I2dh65pdI+GRpFtA+fbbA4gtekQpMoEIdoSF+shHLcu3LZBaCQxNV81z4lyAda67JD3Ob9h05JYSEyltS1VB9UVpvsVNiqAveG2dt41xp+IyE4S+33pH2Gl98opm7btx/Ep/kIJsmniouC6pbUZUdyTh9H/rSYiBZ4l4S0Xn9KWuWwgG4hmH95Y3aDJEkUl8RaXWbMIfZWs3R4M6JgGKZZkCLEYS13
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(36756003)(86362001)(38100700002)(8676002)(66946007)(66476007)(5660300002)(8936002)(4326008)(7416002)(7406005)(6916009)(41300700001)(316002)(66556008)(2906002)(2616005)(6486002)(54906003)(478600001)(6506007)(186003)(6512007)(26005)(83380400001)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jAuMTJR2d7EFrznZ/OIIARXRPFfZ+XTWlquCeVGKRMtTcgLfkDnWGyXYMzV9?=
 =?us-ascii?Q?2/M2svGAekNq/igDWTAaeLdBaQ8X0I+f/ub/601MkYfZhbdzJ16tSLV7GZGp?=
 =?us-ascii?Q?mcud+G9VNoSEGH/Q0J33vg/dHbBRREfRu25G08xtUpfJWMM2NqFKu9xRpnsV?=
 =?us-ascii?Q?QlhKvG7OUg/6L7R7q3xCEUDf1jf9Zx1Bsoj5UfKbiBGGLy9UGNWKbmLBUE2T?=
 =?us-ascii?Q?BJRgogeAGML3M/WzRph4anA98LP91H1NTnAMp2Eb7j3YdVTW5tzXSVy2se8m?=
 =?us-ascii?Q?95cG6PbpGi1XSbRgTuC5lJPL9/onC51cBsyiu2m7jqRazLYs8zJqZR1wc/oW?=
 =?us-ascii?Q?2JnX6drzLNde7LWWtw8QBVS15dhoEM2bX2KKN37nfymFSl3Lnjfg/M0H/mAU?=
 =?us-ascii?Q?7sL9n9POkuPt3ogK5jNbL85EL+s+wcXyBbwVWsrWtolABTwpMNiTYcIyH+zF?=
 =?us-ascii?Q?77yd07bB1VGGHZfoMjnJTccNK2GE1vOgakC8+Ka2EKvsx5tRnhmKD2tNyFLp?=
 =?us-ascii?Q?nFUT/FgfLMffFIGrzB3iO2D14DJKevrOzDI78zrnC8Vnl36vQ4u0tR7Scl8n?=
 =?us-ascii?Q?UXR4G3kyVOfBjdImS5yqgsd8BDEgp2MszJkivmnvXqzkMDpz5F/0pDn5ISDY?=
 =?us-ascii?Q?JMkZ6FAZem0IhYX2NMq0IykrgmqoRR8sdwS9kkGZu+1A87/XSRh7caNX41+H?=
 =?us-ascii?Q?GuU6ml1im1ZDALWaMTha+q81VMKxjBoj8pTmB2s8X6SDjqjcj55gHxPsTH54?=
 =?us-ascii?Q?akuqHcEkJgNBNGddT7fjqewXRXuBpvO7iRpFHslT4TktS7vtk8v+uAERaUTt?=
 =?us-ascii?Q?3LuUPj7Zo6GXCHlfHUMfZn7sn965m+XgU89g00PIgMqKdccW4UrikG0AI1xp?=
 =?us-ascii?Q?vTHrlQ1/QSx1k45yi6cABn/Bhz9n9N0pLMO+CRgplKIgwz527S8pzJIjB+SE?=
 =?us-ascii?Q?nsDtkxpmq9PQ6m91bpmAPv63FNU4FruplMQOvWXDTg2MSLsOZ/iGaQtGWkXJ?=
 =?us-ascii?Q?va+mYB38R/yQKTCiSjdNxZlqkkIXm0sj1rw3ChnPBRqJVvmng8o5wSXaB1A4?=
 =?us-ascii?Q?hvSg5rwMmajtzooeEkDMcGh7aRReQUPz8A7TAXTmS22wJfzALrhyMQgiBcCR?=
 =?us-ascii?Q?gtmIB4ClVfk+X1QWNzxOFc2Y+7MsBWJM6dPidPSz+mmSGafkn8plFgz36KNW?=
 =?us-ascii?Q?mDFrcnQC/zjlqkhP3MfE1VqgWofH4Kd/oRgv/K1kt/OgN83LWo4665CYI+WD?=
 =?us-ascii?Q?1p4LXhCMhY+aDFEHfSaIU4nT2WOgY01mi/cVNDOy8KNnxyMy/I31EkNN9zdC?=
 =?us-ascii?Q?MClumMte3gc3iONSMjVkBC4tVQKDmU4ZwweGsAFo0xQ7vYljRL5x3HsCG8Yo?=
 =?us-ascii?Q?i1n6dXLZQ/nGYXN8zepWZVqEW1JpXSvLFOiJnJ7eV94qqb18mDsNV1DJsAW2?=
 =?us-ascii?Q?/i6JtHRQrSNfU5PcyWLhwM6Pw9vNzdNLldO3an7a8/kUVZGxqgnX1x9eaWa1?=
 =?us-ascii?Q?ENlFd/PgBEtlwLbrOziVJ35KUjahARz3b50KFQCBzijhZuSUQtptog6lw1yO?=
 =?us-ascii?Q?kQv5321rdp8OXQgEgKoUnhy8tt0nLm8cDqwuFx84?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e42af9d-8900-47ce-3ae1-08db4b20ce40
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:20:47.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCXdf9/uZoM5Ip2lsfQeqcV+r5kegVrjbAJeEtdiGwUs2iQVj1AVjAO6uH24wDTi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4507
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 10:54:35AM -0400, Matthew Rosato wrote:
> On 5/2/23 10:15 AM, David Hildenbrand wrote:
> > On 02.05.23 16:04, Jason Gunthorpe wrote:
> >> On Tue, May 02, 2023 at 03:57:30PM +0200, David Hildenbrand wrote:
> >>> On 02.05.23 15:50, Jason Gunthorpe wrote:
> >>>> On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
> >>>>>> Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> >>>>>
> >>>>> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
> >>>>> pin all guest memory (instead of small pieces dynamically), there is little
> >>>>> existing use for file-backed RAM in such zPCI configurations (because memory
> >>>>> cannot be reclaimed either way if it's all pinned), so likely there are no
> >>>>> real existing users.
> >>>>
> >>>> Right, this is VFIO, the physical HW can't tolerate not having pinned
> >>>> memory, so something somewhere is always pinning it.
> >>>>
> >>>> Which, again, makes it weird/wrong that this KVM code is pinning it
> >>>> again :\
> >>>
> >>> IIUC, that pinning is not for ordinary IOMMU / KVM memory access. It's for
> >>> passthrough of (adapter) interrupts.
> >>>
> >>> I have to speculate, but I guess for hardware to forward interrupts to the
> >>> VM, it has to pin the special guest memory page that will receive the
> >>> indications, to then configure (interrupt) hardware to target the interrupt
> >>> indications to that special guest page (using a host physical address).
> >>
> >> Either the emulated access is "CPU" based happening through the KVM
> >> page table so it should use mmu_notifier locking.
> >>
> >> Or it is "DMA" and should go through an IOVA through iommufd pinning
> >> and locking.
> >>
> >> There is no other ground, nothing in KVM should be inventing its own
> >> access methodology.
> > 
> > I might be wrong, but this seems to be a bit different.
> >
> > It cannot tolerate page faults (needs a host physical address), so
> > memory notifiers don't really apply. (as a side note, KVM on s390x
> > does not use mmu notifiers as we know them)
>
> The host physical address is one shared between underlying firmware
> and the host kvm.  Either might make changes to the referenced page
> and then issue an alert to the guest via a mechanism called GISA,
> giving impetus to the guest to look at that page and process the
> event.  As you say, firmware can't tolerate the page being
> unavailable; it's expecting that once we feed it that location it's
> always available until we remove it (kvm_s390_pci_aif_disable).

That is a CPU access delegated to the FW without any locking scheme to
make it safe with KVM :\

It would have been better if FW could inject it through the kvm page
tables so it has some coherency.

Otherwise you have to call this "DMA", I think.

How does s390 avoid mmu notifiers without having lots of problems?? It
is not really optional to hook the invalidations if you need to build
a shadow page table..

Jason
