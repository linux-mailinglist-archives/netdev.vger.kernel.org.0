Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18E56F494F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjEBRqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjEBRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:46:19 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D5F1701;
        Tue,  2 May 2023 10:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmdlhR2a0mdH9b8dfZjTSW34KrJPwLPUigIMKXP8fnPw++A3ph0BnRMF8yuAgOWYEAxWFRnTzYtQsC3j4UAXmp7OamV7wnTo+psSIkviZeeCuQ5l1fX+X2REHTaa8zyxm9eXN0z7/u6PZ+j3JJ6oSMd7pSYf99WdH8YbhyjGHJnKJ03NbxhrNtD3hn1zAkhfAd5zC9lqueAC4f6O8w7fD52zex6Rc42vFINktU4DWgRL9JotLkay/UCuGcF9vLk8PfFwwhelZFKv3ZYwrCU5HefBBv56O/j9a9nhI1uKRifkxf7bNdR3DT5faUpNrPHmGRSenA1IXNNBZiqbfhFcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFLbfVtwQ/E+3BAfOsfkGRj9yaoz/+NMqcp7EQVQZ40=;
 b=DbdCdgClY21gLLRSULHSRryq43U8rgk/72A4TA4kO41I+9hrj0VA15d0EkZYS7KB8nI57Ul9H0cZXvXy6QCwb1nllGThlhKEp2X8CSSmICWCqGUlwK0HVKvaSsjMVXSVOmr3Q94tD/Kto4k8FY7EnBZm1Awx+c6xWXhuo0ACSghyfwfyrB0AMmRwg2y55xHe934EaxB43EnJzdyheHXEAIY4Qp52euF1RDGfj+CzUGZApHpGzsyqmHLIFQ2hlFz3QSfOM87MLw/8tes2bwk2Q6fW0o/WxwsR6Cv+kfmEoBLCxJ03f85TydYoByxo8lsjDtDV5ATcOH6yRR6X06N36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFLbfVtwQ/E+3BAfOsfkGRj9yaoz/+NMqcp7EQVQZ40=;
 b=gFRGDlSLpo+GO6PuRS5LMu6MYak/MX11oeQ++TDvKRkpvDKMqXxNbtWGHRMrd5nnet5i40Z3iN8lZZM7fuPWlTOWb6jRzh/HaSKpf7D+2AfJm4gAJ5MivM/lHAwWQOPpDtLjzyGmU7Njf5CtcBEVrm6JJ6uAS8ASfU6o/azeQF2HOPmnSj2A9CyvUn2WfNOZglsta7AbUqfuWxjsNS+hoQjKALf5GJdHqku3GKt7kp6ahIeH+3HKIC/NNhSkPjYGk3upLQYwcQJzNV18YBgi2Qd/WoIl5XquYFpE3rc+E+lTPCkkpzYitBXgJTgd/bj9hU1Ooxf6WZf5vTiSBsV+eQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5932.namprd12.prod.outlook.com (2603:10b6:208:37f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.28; Tue, 2 May
 2023 17:46:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 17:46:08 +0000
Date:   Tue, 2 May 2023 14:46:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
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
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFFMXswUwsQ6lRi5@nvidia.com>
References: <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com>
 <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
 <ZFE4A7HbM9vGhACI@nvidia.com>
 <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
X-ClientProxiedBy: MN2PR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:208:23d::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: f263c8ef-4c66-47bf-c184-08db4b351c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzveCANXv7AmxecU8qwVaWubD83rzG7WTtvQOCy0tvWJ56ntPMI9+cRyvADOy0zIreNfAJk3Qc3AZXJbokCNfudT14I1kXqqrSHYqxCoZlIX8ZOzD9+T/vUW7GiPkHrHYUl6hKClwSKX28GthZONCMQNy8Z6FNyGBLNpCDdArzvzG31/8VmOPOpgQLF+2Cd9BlzK7CmpVuN2nESPEwfS2/vari5Sjdd9Yj7OuEj26TTtcnvYsR/QSMatwvfp6Tki1PTBOj97WQRfEVtluEfCZvuafDfBDzyNxItRLM1BmKIZ/PcbkdB0zxxaq1Gv6XrIGdmqQpESKmEf6rZTvHvAPaotYYmBPWBoyRwphPLUhfx63564pDAOOrEQe2778s3sHCVd2wgXSGl+p0IdWiOQnTrWRbESB/bdlxY+blyNDEbTJazTl9aZs6ppIwgkUi7kT7vvFLdoy1D1bPhyQQiJ4VPLsQqHntQtyK4cT/DF0dy6PcL28Rn9Wit98cTCJNEnbRIyrn9FC5nhAVlhxbMdjzb/aso0WztaukFqqllI9fn0+NE6EdhIe6O9iT6vnCbl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199021)(6916009)(66556008)(54906003)(316002)(4326008)(66946007)(66476007)(36756003)(38100700002)(186003)(6506007)(26005)(83380400001)(6512007)(86362001)(53546011)(2616005)(5660300002)(41300700001)(8676002)(478600001)(6486002)(8936002)(7406005)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WjG02a0WTtvQXfHQB6Yx99cPcy4NA/yizgji/vIWjQq4Oa42vW76aYpMtXzz?=
 =?us-ascii?Q?+Qj82LcCETiCRZ+fbeosg1kxUmuQDl0uR47DyOZG/K3Y80O06V/6kO6Snfz7?=
 =?us-ascii?Q?p7JW4Uu8TonB4OwnNmzjHv2A0jxhtCwDwYhQNvT4aSH+kdzS/UmjGlcbX/6T?=
 =?us-ascii?Q?CLimEP76FjAQy23JSYOqGFbSzgdLgjKYj9yQx4xP2OVnnDNJxenMJ1f/jdQL?=
 =?us-ascii?Q?lTjgZD9B1+9rEiaUaNS/N9sXlUPOrA76Per9Ybf7VRjo6ir4+5JMCkmLvbb9?=
 =?us-ascii?Q?OyehMC7LVQT94TpSMkQcP9kPmMQe67TAioAxNWu2p2bDxm8oNUf7o4wv+jHu?=
 =?us-ascii?Q?eJDnRgRqfChOI0KtO19Dgsin9d5aXU02R5+gukZhzRVlyI6hDpklxPbOZ4sa?=
 =?us-ascii?Q?ovv7h+2bSzU0IEBCX2EJ5uYRYyP18BYwvEwJ35Dc4q/BqFX+YT9XmSS9KjKx?=
 =?us-ascii?Q?UaKFqKU7ghPXFHOkOknEjGWdLb714rQB4XsfszuUqUrw5nX3E34P/YH2Ob4b?=
 =?us-ascii?Q?Hai2PUDwBXDp2aD3tVb0+miw9U+mgIkbwO4WcG57LbYpryv+AQMXFLBOsQe5?=
 =?us-ascii?Q?M4+V0NtxDSH3G5gpaT7PZn0kzaOdLjV8CDAN5rBKAKisjQZNvKCitbBVFbf1?=
 =?us-ascii?Q?dZMsnMD3OAFrnXj/0X035B9XFcuu2xvNTf0b/oq7VAnlbxKbucNa16kS7YCM?=
 =?us-ascii?Q?LgqPOC871MLwm99x67N/xTgTFnmOIt/edUgD4H5H9eKDBl2NhiNPsL7YobWO?=
 =?us-ascii?Q?BZYHnc1OlSm+NmUxAjFUN6j2D+1QgLb6V9Uz8ixZA0uRsIrwUKmFZ/B0dSwT?=
 =?us-ascii?Q?W9xhK5sHQwwu/wFk2gdrdDj0vVSnUZSUGyqlzFaS3QBLK0QgAgrgawN4aTZJ?=
 =?us-ascii?Q?AOX9kd2q5IToPn4nAqN2szCiLn7ArL/JMzLwElG+IXc3dVc659tVhdQ72RIj?=
 =?us-ascii?Q?xnEGLj0OiAYaGY4a/W/MPHMc9fdpeDTm/gvhBrXVGt+h6VsFNyWGmJ4S329J?=
 =?us-ascii?Q?Nl7YeVrhrrbwes2V0sdrZHp7H+Wqo4C1XKS1cWMNI534x7x+GERzyJIBZkKV?=
 =?us-ascii?Q?58Bfb8hh8gclgU6WLImX0QiWmXa7UNiF76Q9I/8G2s1ABqJiU+mYvZz3eMCD?=
 =?us-ascii?Q?XX9nJV0pjztJkRXhttRwtoTFjUaTNbVwsWCtSvTWzRXuT/jjRC8N/urv8RL8?=
 =?us-ascii?Q?mU/kkjOtpJiqpDHmGhfMvUvAfMRut/LqjTW6DEHmJQ8CDJl9hFMzpItZjshW?=
 =?us-ascii?Q?XiUsxg9jWT4D6uiugqJINElqtbCIRIW1LehfHN6vwI7fkE1FL3LDPRrbYsMM?=
 =?us-ascii?Q?Fhn6iGmAnUgOWXnR+NEe2bbrN3lyeGSZOPFzPA4sf6V5yIo6sUrez7x/xbHd?=
 =?us-ascii?Q?4clizHJcOt29v60mhytF+ffdA4amnM5/8OmhSd28ZbmhSyY3DBb4IELhaLJt?=
 =?us-ascii?Q?EdLAVqfqOK98GIAA2dOgxeSsy4HsIeG6umsvYL8kwT8TZHCqSrpbSEMzbvMO?=
 =?us-ascii?Q?CdaMitKKtbwKRhH94xYf29hE+3KfJbbF6Orz3D44n/s8sPtlmq8e9TsD5VeD?=
 =?us-ascii?Q?hqC57/hiBoo1tKEqsdgtj6y7FdpQud3yV3ENjMWS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f263c8ef-4c66-47bf-c184-08db4b351c16
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 17:46:08.2186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+tQAcUeKUUEhRGg0QWvPJZKwAwodGnE2fmVW22m6rJbsC/BQ6LYoml+Mz0SxKV7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5932
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 06:32:23PM +0200, David Hildenbrand wrote:
> On 02.05.23 18:19, Jason Gunthorpe wrote:
> > On Tue, May 02, 2023 at 06:12:39PM +0200, David Hildenbrand wrote:
> > 
> > > > It missses the general architectural point why we have all these
> > > > shootdown mechanims in other places - plares are not supposed to make
> > > > these kinds of assumptions. When the userspace unplugs the memory from
> > > > KVM or unmaps it from VFIO it is not still being accessed by the
> > > > kernel.
> > > 
> > > Yes. Like having memory in a vfio iommu v1 and doing the same (mremap,
> > > munmap, MADV_DONTNEED, ...). Which is why we disable MADV_DONTNEED (e.g.,
> > > virtio-balloon) in QEMU with vfio.
> > 
> > That is different, VFIO has it's own contract how it consumes the
> > memory from the MM and VFIO breaks all this stuff.
> > 
> > But when you tell VFIO to unmap the memory it doesn't keep accessing
> > it in the background like this does.
> 
> To me, this is similar to when QEMU (user space) triggers
> KVM_S390_ZPCIOP_DEREG_AEN, to tell KVM to disable AIF and stop using the
> page (1) When triggered by the guest explicitly (2) when resetting the VM
> (3) when resetting the virtual PCI device / configuration.
> 
> Interrupt gets unregistered from HW (which stops using the page), the pages
> get unpinned. Pages get no longer used.
> 
> I guess I am still missing (a) how this is fundamentally different (b) how
> it could be done differently.

It uses an address that is already scoped within the KVM memory map
and uses KVM's gpa_to_gfn() to translate it to some pinnable page

It is not some independent thing like VFIO, it is explicitly scoped
within the existing KVM structure and it does not follow any mutations
that are done to the gpa map through the usual KVM APIs.

> I'd really be happy to learn how a better approach would look like that does
> not use longterm pinnings.

Sounds like the FW sadly needs pinnings. This is why I said it looks
like DMA. If possible it would be better to get the pinning through
VFIO, eg as a mdev

Otherwise, it would have been cleaner if this was divorced from KVM
and took in a direct user pointer, then maybe you could make the
argument is its own thing with its own lifetime rules. (then you are
kind of making your own mdev)

Or, perhaps, this is really part of some radical "irqfd" that we've
been on and off talking about specifically to get this area of
interrupt bypass uAPI'd properly..

Jason
