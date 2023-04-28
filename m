Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15F06F1B88
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346431AbjD1P2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjD1P2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:28:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4649E1;
        Fri, 28 Apr 2023 08:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN6Ar/ZDYftIZFL+jXcOjZ9kU0FvXdr2Vz7PG4Jok9IhiR6KA/9esiEbgk7x8IqGOsUjaw/aMCYFo+8CjQfeAw8eKyrDC7eV7gsa0b/qtukkpe1cwIiha6cb0E9PoJcjz1j5BiYrYhYS74N2sf+v8CsC9aTIqaHnSAJLiE2ViVUdOEnmxp33pFroPFgGNNunmSWbH4XeQ2PaqoPil6ScS7NjOhzcVKF0T42YDKitpcujYRJUgvXzyntNfrZYtFb9i4ZQIeI/dA0RciT6WEyZZyG4SMkH0/FEHvNRUjvWRLZg7eF4bek0xc3ep8g9b+6JPRtGo2A0gAngkLlWC+mzmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvFMNhfDCXMZxLZyxFgb+3vq4JyL6U5sTKrYkkeSh7A=;
 b=EIR6esVLaAaj+yXOgfJYIKuXTNIYC46OzuYnZ5wCRgYyy18pV8Pe+finoXM/MM7H1cSzMvBWR05QDxtatAdHMcqtGr7cpePcX3PjMuPfo3RKAdDEwwQUzTBgnU1s7IsOBoWLS79VVItRlBmiifVDJjUREP9zsO6iFxQ8NH6APTQMaTgc2uCUdlGI2d9LDt5cpjDL9HI4mUDo3s2rV2qMQGKTQYRrIanAOzE87hcOfVhhZaTBnuKJP48g5FcTo7vBNIMdFjyDbQEIxcNb5AuK6V7PPu3hM8RpUfG7R3gl1KEo0T7IIBfMm31FJNYxsGFzAEVgSLq5G8U8Q9Jhztn2yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvFMNhfDCXMZxLZyxFgb+3vq4JyL6U5sTKrYkkeSh7A=;
 b=cVWVPCqRRrW3Y7TmqWGWgs+l7uOw3htZeS0O8edPlI4SbmVZwEgF0aSM2YMTe9QW0yuG5qwGUBsJgYgSYhkzY97CMyTzDeEkzji/3n0DW71rzSu+nMVzSpkbzSmF3m+neiRByVEy9fqz5kbJPq2b4lld15fvz6Vp1WE6Vy7o7CGCb5XteFPme2FS4nFeQNqGIH7lvOw7BRot566XPTcBI1ndipr7kLcn3XvkaIMEgEv0vKDjl9GE2cx7jBImMBIGzdIKZFCJZb7zW8j1I4kA9qElp37vn91Ezi6bSNpBpXN593EbkjltwbFgE+QMagObp4lwEXD6VkHvTzAt2vXL0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7722.namprd12.prod.outlook.com (2603:10b6:208:432::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 15:27:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 15:27:45 +0000
Date:   Fri, 28 Apr 2023 12:27:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEvl717EANEu8113@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
X-ClientProxiedBy: MN2PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:208:160::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 86458e87-2f96-4461-8030-08db47fd1d4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OT/bVm429jZdc8ZpTOTBTz8d5P74u27TZ+0ckMukm4Y0Q80/tlGc8jneXV1ghkNSmIO0Ee20Ieu9TK9CQaZC4LzTxDTO5eXrLWqkHc6MhoJ0lTz/HOrO0C5tunCPyCvEySgGRML6JPiGYfWEn+Nax1Zz4VvFk6UWVeJaFVQzdWysADoboZqdkLntlJJttbgTbIOoOATzQiOeKFPFKhLP0i412YXCk6Xd6bbUKg9mtSxnFgjWiSyAPqjL0Nfm+h6xwzZcaqa3tiyiMw1Jejjem0Gwo+TGzz16rElOBD1bvJxhgqz+4LmG7TT2JODPnXj1HZsmzyiOpviQml3yoSDaTxCzzH7mYFnSDNYnD4XHtkbpDZXdokJdaSiXX6c685apbS9EZuI3nJJFnSbQ4VgDMEWbgk4uttmiwsTI82sUQqG0AgWtK7XLMNKtSDXXKzCNTVwCas2AKSMEpM/g20ZIeC3JqTbcHenaBSurL11K8qozU3ECZZOcv8enPl680ifgNaOv5MekuWcGOntydDO/KAAsStaSZsTRsVHGr9H/hNDqnNfPLfGtLGg0VWPFPq9y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199021)(66556008)(38100700002)(5660300002)(66946007)(66476007)(8936002)(8676002)(41300700001)(316002)(86362001)(4326008)(7416002)(6916009)(7406005)(186003)(26005)(6506007)(6512007)(6486002)(36756003)(83380400001)(2616005)(2906002)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J2XwqdN26nv/ouioHeX87z7B9ARKEiU2ewg+gWNjIUUGFix8OGPu/fof8wE9?=
 =?us-ascii?Q?guhtBmg6e32NYLy6Am8kdUDZL4rzN5pA8wCr+Wb+Rt5qEhNud0cigQ1u5N4E?=
 =?us-ascii?Q?9nXfWFi9TOwD+DIEG6+7B1i4LEZ7Eb6BsaRPyjdEUrwpwrykzuCJJRyMTCug?=
 =?us-ascii?Q?j6pUu0exWhCT14eYtI9/vODJk5u6IYMZNW0sVw81tUe1ZwtFn5yOzHFFKkET?=
 =?us-ascii?Q?zo68JSC/spK5yMOdxC+uxsaMjRyPH3DztzN9ELgKCXJWyJuuvRZuYEHVNuSp?=
 =?us-ascii?Q?K/pRYZZAaSjDYsWD36L7I410l/dgVR1vwiP5hEt66dpAeDxuVkNFXDHGtz99?=
 =?us-ascii?Q?zxIxHdEUHBlVDdmdQ11jTNUmO+s0Vhb8CfcwTeCEMy94abhKQova+krCTIW9?=
 =?us-ascii?Q?aSfxruooguG+isXNZ0fKrtY38T36dzPCCj7V1Pt9wW0wrzgCqd3I3BIdN+e8?=
 =?us-ascii?Q?+TF8Isb4iyRw5cOZI1qgAtwk0lRRTyuy0jquiJnhoYvhbWG3/8RhR/ugOlbX?=
 =?us-ascii?Q?K6V+xdUV35WIuJj+yFyw8r8E242ELUd8D0c7eGHkfEgDAlBFHALoVjrNLH7G?=
 =?us-ascii?Q?Qg5wGLf9P9bNBU1U5xDHSe9O6JJPjI4ye76FPcq1VLAGCd+eWCm/nDaTN0+5?=
 =?us-ascii?Q?JpxFQ76pbDwe8AspdWsYnPGYaGCvgYsxQny/OEXhHhTsDbryNFmVymgCRcTU?=
 =?us-ascii?Q?yDBauVCh4chmbLjOizXDOS77KhRrSsLehFVEeCaS2uZEoBYuXCDDNlMYeJZb?=
 =?us-ascii?Q?LqHrRVTxclZXr78dBDZy5PEe0lm7cytHfRwrffuqJsE2YfgWcZubr84AEQNi?=
 =?us-ascii?Q?L61xi5Lm9VlfT7Sxk4IL4nAjWrAR+GfO2uVUGzip5EcUbGq2tXWdUsC5vUiF?=
 =?us-ascii?Q?W1AJ0vPvF0wM3cBPiQWcuYjJ1ojfXfupoY1d8XviLUwgoFd6fIRmez9cWUCy?=
 =?us-ascii?Q?i0eHPtJJCxuiMh2MddZqxYhOjKDq6y1+JusZBvG7gOk/u+ZJ8gdgqAxNUozW?=
 =?us-ascii?Q?n2GNlRqF2rbjMEHjyPT1KDS96qKEH7F4pAgvcAJ4ebaZFcS6cXJwFhX+pZqA?=
 =?us-ascii?Q?3ssYYy9v+jTfckI2C9sDPjoZjDTup03R4KRRHJxA7UUzIw7HGFszh6bLn0T/?=
 =?us-ascii?Q?R5ccWsF+9eXUskHxMg8XriFet9VyIKPr9cLS+jHbC2mQbeMtTMl6q8qsbc4V?=
 =?us-ascii?Q?F17UnzWs3jKWk1E1qsUSAcF7nXVV/0p4TiMmrjLEYnsjiTQ/y4uL6C7atoyB?=
 =?us-ascii?Q?b7+5JPx7dMsD5w1hMP6WuSV65GTkHpGqUILlopoiTyMKCBqL6nWT2auGxx6l?=
 =?us-ascii?Q?iTVcaDFaCmHdeDChSl2UHzjb6a6t9pgcbzjSKmvUuURu9O0xW3gmZRsxlWLv?=
 =?us-ascii?Q?LHFMnNaaLWbf8SkXoHaPq8PbbdOa3SnwoyESPYJWUoQOKlsnstyy9yTfAdUu?=
 =?us-ascii?Q?f3IU2sUCgAbgkLxq1mKQmVRS+/W/2UwyagisMdSkecBIpzNBSBY3jr5U88qC?=
 =?us-ascii?Q?e8eRjnY8sumewPAX/J4hmWsPS0mbahjnW4zF8sEzGMJZbJVRAq5YaINQXv6e?=
 =?us-ascii?Q?+gviITcIjmRuB5/+jIsI8lNGPz2J2OJ9DcL4RZNl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86458e87-2f96-4461-8030-08db47fd1d4b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 15:27:45.0051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vR69WvcLgeWrQtDNIWAl5ebj/qQLAG+dh1PY3QhgExyQ5VjDO0h1Sec4UK9CNbYF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7722
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 05:08:27PM +0200, David Hildenbrand wrote:

> > I think this is broken today and we should block it. We know from
> > experiments with RDMA that doing exactly this triggers kernel oop's.
> 
> I never saw similar reports in the wild (especially targeted at RHEL), so is
> this still a current issue that has not been mitigated? Or is it just so
> hard to actually trigger?

People send RDMA related bug reports to us, and we tell them not to do
this stuff :)

> > I'm skeptical that anyone can actually do this combination of things
> > successfully without getting kernel crashes or file data corruption -
> > ie there is no real user to break.
> 
> I am pretty sure that there are such VM users, because on the libvirt level
> it's completely unclear which features trigger what behavior :/

IDK, why on earth would anyone want to do this? Using VFIO forces all
the memory to become resident so what was the point of making it file
backed in the first place?

I'm skeptical there are real users even if it now requires special
steps to be crashy/corrupty.

> > > Sure, we could warn, or convert individual users using a flag (io_uring).
> > > But maybe we should invest more energy on a fix?
> > 
> > It has been years now, I think we need to admit a fix is still years
> > away. Blocking the security problem may even motivate more people to
> > work on a fix.
> 
> Maybe we should make this a topic this year at LSF/MM (again?). At least we
> learned a lot about GUP, what might work, what might not work, and got a
> depper understanding (+ motivation to fix? :) ) the issue at hand.

We keep having the topic.. This is the old argument that the FS people
say the MM isn't following its inode and dirty lifetime rules and the
MM people say the FS isn't following its refcounting rules <shrug>

> > Security is the primary case where we have historically closed uAPI
> > items.
> 
> As this patch
> 
> 1) Does not tackle GUP-fast
> 2) Does not take care of !FOLL_LONGTERM
> 
> I am not convinced by the security argument in regard to this patch.

It is incremental and a temperature check to see what kind of real
users exist. We have no idea right now, just speculation.

Like I said, if there is feedback we can weaken it even further.

> Everything else sounds like band-aids to me, is insufficient, and might
> cause more harm than actually help IMHO. Especially the gup-fast case is
> extremely easy to work-around in malicious user space.

It is true this patch should probably block gup_fast when using
FOLL_LONGTERM as well, just like we used to do for the DAX check.

Jason
