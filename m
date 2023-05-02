Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B36F497E
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjEBSKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbjEBSJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:09:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B56173A;
        Tue,  2 May 2023 11:09:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKy52yGeYLK1zoI7wxJ+imcn9iYlZ0PPbWZkjM7PRscAaSF2YcdXGu6GZsHHByuTQUUf8allT04Vv4dW6/qC5xtVB+je19bSP1imAcSFRMeAFYuE53+7wDqSvXUzFnuy5FtgyDxb/90nHey7QKDbZicIYtVRQNylfd4UxV+FU9paBQJcxtD+5ZQ8rG2aX+pN5zbLIPpsdBlg7/V5ET1wxHe60ICCj4mCpZBxmR3E9BvbdYFTFYYZjGzGKuSSBEXB45b6oDR0EX6vJkNcM8BRjikabwCtpGygzh7xRQBag9ylhDqxhh/9GbuAlluXtJaUcrABf6/SS5RLyLw4vHP6+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7+2MIEVoGgjMoFqsaFaiOHF2G2Y2Z3pQ7O/Pmm5vHk=;
 b=WbZCIv8AfkLkhqeD1B8aC5XYJQKafh+MHG3XJE19eF7lvYBTzO9wyr6caZV1zUxYMWvRgrTR7TRDm7c3HAiA6DQXC4kMNMKjHHaOrxyShAcTYyLeToCCchKztS4xVtv9DXBN5xjY4cErDBKtc7msDST9rvzyuQ7NO0Io6es4VkA+nkiCfe+VKFITT9WXM6iWLv5mLmbHZaDxyJtyVy7EFTl/aui0TuDP2zx3ELHJLjCZokz6J5uPrI1relXc/X9d7UvJPSPIGur5F9ib2yKUrT974/bF6V5rxmhRPDFmu2EvMeXHACnzcgG59F0arqbJQ6Af/XKXYTJgj5P6MpTeCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7+2MIEVoGgjMoFqsaFaiOHF2G2Y2Z3pQ7O/Pmm5vHk=;
 b=stk/Ofcsi0M+8qQlQ8pJjm7/FMix5WHIt1dUBaIF/kR+A52DnXo3DYQOwUQ2fkMV0y/FhlHIPr4u/3ppuOPkwfYXlTSumMO1+lJ6MRw1cBBq7lnIXiic3vGSmgGLwd8rTkonoZRTReFQ/4jHiRI7kd6LAiWBSwCUjBaUmgR3QesRKA7JzLzhtAZ207NXTlOmJMT0Wr88jXhTfRORn1nt8jM9UiYD48o5sMXhiRufVIeMUDsA5nrjRxEjN1lghtDW+PcmrySZSLOZKKwF/b4ZtatU6ZafAjbPHbo7sPq+s4zR8dmT9AYq1Bi1IZitxp2Qk0/u09w/CFevK11YWQUIDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4474.namprd12.prod.outlook.com (2603:10b6:303:2e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 18:09:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 18:09:50 +0000
Date:   Tue, 2 May 2023 15:09:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
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
Message-ID: <ZFFR7GamoeWybmff@nvidia.com>
References: <ZFEqTo+l/S8IkBQm@nvidia.com>
 <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
 <ZFE4A7HbM9vGhACI@nvidia.com>
 <6681789f-f70e-820d-a185-a17e638dfa53@redhat.com>
 <ZFFMXswUwsQ6lRi5@nvidia.com>
 <2d023b34-643f-33f7-af5e-7e6dce2eed46@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d023b34-643f-33f7-af5e-7e6dce2eed46@linux.ibm.com>
X-ClientProxiedBy: MN2PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:160::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4474:EE_
X-MS-Office365-Filtering-Correlation-Id: d340836a-bf36-45d0-b972-08db4b386b83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yW8y0QunysQoIAZE5PlT1kp8ESnqtRd1wWxuwNPYFWXHYrPxfjkXfr94y3oJa5z3AmVoxYPC906EZYcUC75gjYjhuX2RXCxey44p56KyHX/bAUZKw7jVjj6KZJ8gNmpq7zPuA972EZl9OVqHdiDB5a1t13F+iulz4rnBoPqB5RcDlje5GSLxcTjPFtQGVYp1PQBifwlf4spriR5CBBKOSXs8lKF1OtjQerV+BGkVsmsh6uMRiAjCw4q+LIguiEDwNAbFP9i/RNgnfjjeJExDCCXtaSgzYRjAfz6Gl/F4WXu6zlGwyGV4egZeRwMwFLN5iNkVPoxOwGt3OT41qzStBszwnXEnUk/6lSjdtXCKDmJ7/niR0z4ubVVr3o/MvfXnbkijCw18slTLXx7HeNOQUoHmLsoWgbLKBM9ZbnIFJSyF4QIe/EH45K+sJVX5Dxqncjpo+QwzrXa4HmoTpsLih8F8bT7szntHovYnNkerWDMSsPnq2vKC4ps0iz/7NmbD3jzykRlGYRO/7/Ou3Q2pBcaUNel4uR56aqs8GnIoqtZUYxaZIMiNS7M8Dy/WWxKo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199021)(41300700001)(5660300002)(83380400001)(2906002)(2616005)(7406005)(8676002)(8936002)(7416002)(316002)(6486002)(6916009)(38100700002)(66556008)(66476007)(4326008)(54906003)(86362001)(478600001)(36756003)(26005)(186003)(6506007)(6512007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HZhfMHn/Dp51vtyUbqyNy6p5XOu5KFHhkl5VDbb9WEoJXWhq8Wwr6EoDzu0i?=
 =?us-ascii?Q?yOPNxo9yHf+FUtT8rNlyMMnmtoUuj6WacN1pYGHDG/HicxvrnU3cS88KBztH?=
 =?us-ascii?Q?hB2a/k+Sz6FW3F6UXnmG8uvbFR/yqPvGy027NDiMQpo9TSgcoe3si5Vy84An?=
 =?us-ascii?Q?hIMdYqY2SBfN5g/EcUAOMV1TJFdZaIqjFT9myJppB6hu+BEBs697EbeLG7B1?=
 =?us-ascii?Q?Pq1uTYmAz1PESwkAKis7B1CaTNUFCyZuXEMcxL4b7wVWlYKVdwdB2owm/ktW?=
 =?us-ascii?Q?CaHyMMLeM5wqOtgDwqpLOEWKvFyAuHbSpA0VUEHZ92Bb4+oR54RwG0YMjdx0?=
 =?us-ascii?Q?6ehM0r9N9ojAps8OEi2sESVMGCDY+10EZzvCrI29fzOovEDJ9t+1A2EwrU5H?=
 =?us-ascii?Q?f90hrjMEJ7oQhxc+7QALUSFvxEY3QnJQrM5cFTQJ7Fla/8DWm19bPRdg1PGE?=
 =?us-ascii?Q?dthkhB8l3nIiawjqFMb/fSU7dMKBLTDIAlfMKQgE7IDj7yAm/a6jRlGjs5A4?=
 =?us-ascii?Q?jxrmWQXfNYC+/p+i4xpXxJZULCpkdD4UaSpRX63SNQQftlmrMG6l1i8o6ipJ?=
 =?us-ascii?Q?cYW6a3GgTB5KZFQad764+DGs2iJ4FOMr+zKzOAMZMJND38M2ZFPiSG9x3bWU?=
 =?us-ascii?Q?/P8aTsbURcsTJBrXFZjs3/BHGPFHyC4HaKRDOzBUujJZdFWu4DlAH46fcqIV?=
 =?us-ascii?Q?6liDDsQWM3XH8wdQPM/8KnNWbBqR5pRqDJd7ItAdd/K+A+1q1169MqjfWth8?=
 =?us-ascii?Q?HrVdOrZgrx+e/Ts5PQ19LOn0HSIpEHO5G/A6UQgEbIjd3aM/+SGdESHrumAx?=
 =?us-ascii?Q?8Vj96q220ld7H5LWwN4g4xea5tU4RfwHVmqJtNOHDvTjzcUN8wmU+Gc7+5le?=
 =?us-ascii?Q?bABk4cQNV2+XEIl9gkVF55xo5eOvd1KnQ5cUvvm/iKhGXNO9dFTLvhpZcC0Z?=
 =?us-ascii?Q?yk5/FfcjCP5chAaFvNPo41K7cts6QGYYieLAoKtVjvROuirjRVeLOZkHqCDU?=
 =?us-ascii?Q?vhvt6o0l7POErfFLoJ0Qg84bkRx1uhKA549ufPxywvMZf3EBdc/s5irvSzSB?=
 =?us-ascii?Q?pgpTTY0i5zPiULo5j5R+hE5oVxgXGrVxw5/LmrlNpFUI6fYXSKekZ58jO+9K?=
 =?us-ascii?Q?edkrDEmYsJxOa6vnKILsb7knw/9wyAXJ58Kg2gwwf34/Mq1Jd+5dJU+Dgz9D?=
 =?us-ascii?Q?+R4aeG1FQEOhY5aINWjKF/t0Cgc5w1JUPBNVpcXLLQJhdXEEoaeykMtbn9hs?=
 =?us-ascii?Q?Up/uzAGQLm2iwJ8h358GhFpkAkZ7e9Z2DoAv/JXsMSH6ZhdjONTXq9mFotol?=
 =?us-ascii?Q?8ONilEUT3sDhfMLPdLAsc6cb0ZUqkRMm9m+iV0HUUmbGZiTw5afKBwic91ag?=
 =?us-ascii?Q?8doBnPJt0mMQwXWJPDnaXv5DxL92pmqhcXB6dBYjvJlDC/CrUzaiqy/HYdcJ?=
 =?us-ascii?Q?sF9Nz89Y4ZXwI1K0vOx6ENtf1lcBhfCU/tFTbBqIJL95XLAN+0NI4oWZ+pj7?=
 =?us-ascii?Q?edFJdrtPgMBwPkCw+V1QJ9LMAxXEY+mhh+KyP5SpAJAOr/anRwu8bXNAXXag?=
 =?us-ascii?Q?jR3wjHST5bUP1nxLRP/Tf58O4MAJsmLKgtMV546y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d340836a-bf36-45d0-b972-08db4b386b83
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 18:09:49.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARE9B6aPzX3CuAJaD4uIljG5Ie+2lAO5Fkzejmc5KnpMfrpr+N2F9b8u402zbd4E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 01:59:09PM -0400, Matthew Rosato wrote:

> >> I'd really be happy to learn how a better approach would look like that does
> >> not use longterm pinnings.
> > 
> > Sounds like the FW sadly needs pinnings. This is why I said it looks
> > like DMA. If possible it would be better to get the pinning through
> > VFIO, eg as a mdev
> 
> Hrm, these are today handled as a vfio-pci device (e.g. no mdev) so that would be a pretty significant change.

I was thinking more of having your vIRQ controller as a vfio-mdev, so
qemu would have to open the irq controller as well as the kvm and the
PCI device

> > Otherwise, it would have been cleaner if this was divorced from KVM
> > and took in a direct user pointer, then maybe you could make the
> > argument is its own thing with its own lifetime rules. (then you are
> > kind of making your own mdev)
> 
> Problem there is that firmware needs both the location (where to
> indicate the event) and the identity of the KVM instance (what guest
> to ship the GISA alert to) so I don't think we can completely
> divorce them.

I should have said "kvm page table", being in the KVM ioctls is sort
of OK - but I'm really skeptical that KVM is a good place to put HW
device wrappers.

> > Or, perhaps, this is really part of some radical "irqfd" that we've
> > been on and off talking about specifically to get this area of
> > interrupt bypass uAPI'd properly..
> 
> I investigated that at one point and could not seem to get it to
> fit; I'll have another look there.

It is a long journey, but other arches have problems here too

Jason
