Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50B6ED82C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjDXWxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjDXWxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:53:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472B9900D;
        Mon, 24 Apr 2023 15:53:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTzt31VDdhaKHRIpPk0MUGsEi6KBpNMrdhZXCUbeR1+eB78b8JpiP0/wzvv4UR3TTLpV4jIkDEvmR2W2USb7s+ddZqpccsIutq40Mg9M7CuC/pwSJv01gH+25AN3kCgOhdKwetl/DkRl2JerpyDOFFhl7PtQq0QOX1uTaSKsEda3bXzdxsauq/Lk6TOBCm7S+5hAZb5h62zWZi/D3ot+6GyhppnNDBv5snB/ekYJ35t25alnX6NNuZiuFfQi6CZNdzBlqN+FANv98w1abyaWbiG97/1vwoNw79k8SQN7/lG/rGKLsJbzSlfpyP95zljkXqNe/5x9Ma71YvS0dV+VTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gMjttjyVWGIkGTsOTDAB5kkziD272xbAfNnCdW1+rA=;
 b=fV3bYZzz6TtS1qGHRVV3R9gh0+t8Rs4JgGmHMTTMlt+RHaHGpYKpG/204hTS3H8y5oqwcOyzFKGhwZMH4fRHzdMp2N1/2zkvt3WrWDlqqMn9bGljlCoNroD2R5nkuQaFSwomrcPQx8Q/bx7tl84iJut/z3u5oEDFyQM01BumSww1v71ikV1F91Iltm5HSJYgsKiioxoa5yl9cfk8acruEXFqE6k26v/2sZDILOL5/YwPD87tsMLiy1TnyNNwUM8662ZvQXMBtDg46+XVswHi1V0pUF28GAvc8p4qXebCn5THnZU7m5mOVEVuiMeeIYGjbUadRZ5sek+0jxnvfw3Isw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gMjttjyVWGIkGTsOTDAB5kkziD272xbAfNnCdW1+rA=;
 b=EKu5smBzYrnz4oWmc5xMY1oT5LCStxJukR/4dxPlKhyCTFH78363a4JFsmjqk/rqIAqTk6Ncf69i26xfJdkGkQq/x4C5IWMD/Cl3FExlIk18gE5RGuFGzNKRmwH3lRGMN0E4BW0SqHWLlk/Qmokz4Grptn4kh/BX72P0b6X81zYEGsMumJUoanTPMekXCJoqJNXn9ITGaNFohZp+drpRXAUIXL8bgHPs+Enh5gv0OCtwpBFN1ooALI4K0rQoBkgVe59seaxJNzpwHpSwre4pEHJybSxX2az59+xy0ZwyECOx3BbgHuVQXNBdC93XX09Epo0pCEqtcIIt7bbUJwKpDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6269.namprd12.prod.outlook.com (2603:10b6:208:3c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Mon, 24 Apr
 2023 22:53:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 22:53:28 +0000
Date:   Mon, 24 Apr 2023 19:53:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
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
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEcIZspUwWUzH15L@nvidia.com>
References: <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
 <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
X-ClientProxiedBy: BLAPR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:208:32e::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c033db-f2ce-473b-96f1-08db4516b7aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CX1YcVODM7u8wia4NmuuanB44MCuOfBER4zJmFV5sBCQ9yW7FuoZO0m/8T3mxdK4AVAOUx7dpcI1jw5jIjdtUK1EXU27obXht8zG+ZKy1/8sb+zDsXrw3FM+f6OMBX/AtVf74UzCHdImIADG0jPgKBYEmFygctinDperNT+ms2R5RJTbQRW5G3SKvqSOQjlaI1ztE+sOn1T81WzHGTStmS58+me2cZxUBZUsDIHw3tgsm8ZkPiFnnoCcv1q7ydwGHNb0NSSPFq9xcWAO4xeCaAreJ+Z3tGLdfG1YGLu0xweo/ZIWkg9dUPSo/s/0+7zVTKkroOA59UaWnNiRFUENffdlaJlyZcrSvRIssL+6kc0HUL0e7Jhmt55E3vJSlYHbNuDECmMiBM1m3CijLEZaY8ZTYk8qUjav2dvkAEX9Uj63dtYKLAXOQCAeCNxVtTnUEL+hsc6KqOUv/lDDjIgrM52H2K+yHKKIrpI/STNQJP1FwW6QPhwl3IYyXqegnYYsJ9/Ccq5FWCBRssGl4j8RbH9MWUPjc2j+nvl476mjxb6I2srfznBUKbpeKatM/cQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(186003)(6506007)(26005)(6512007)(6486002)(4744005)(66556008)(5660300002)(66946007)(2616005)(38100700002)(6916009)(4326008)(41300700001)(7416002)(8676002)(8936002)(66476007)(7406005)(2906002)(54906003)(478600001)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EcRyB6RaRLMENvnfrGriy0+hRLoo+38zLtuHUjuX9gdIXbMiHpeLnF8xhEAU?=
 =?us-ascii?Q?yF9v/r+Y1Dr5DAMfzYntmB+xLt3GBUr1di8TS053Ctly12dQ+ObI+auT4m+n?=
 =?us-ascii?Q?05ewclsn+00IS7Whydil4sIS6nh/RejQ3TYQxwAGAQ9c69SBV4na6kAVioVw?=
 =?us-ascii?Q?PFutE33tjyDnoAyvekTiKkd6YCcFq3VubozoOb6+lAedptZ/AjBQIwWY9WkZ?=
 =?us-ascii?Q?sIkHXSsxkAM2n4sG8QT6vrbjP5i7xq0Qy72wzdlhtoFDuxwxJeVKV2oCQfwI?=
 =?us-ascii?Q?s3hI6P420ITze8DIG/OLdEeXsTDKfArY050HhP5Ox8yfwb3LSeoUkuzFtjmu?=
 =?us-ascii?Q?Trjy829l9bz72uVqlulMycg0xdlw1kaQjall/sX0oYMavzRrSFBpKnorPTTJ?=
 =?us-ascii?Q?dUgKinueEbTgZhyjcRYqVZ6o4jd7kH8ksltIPKGRWlixLE3U8ICvSwcSI87F?=
 =?us-ascii?Q?Lg3odLHq499TaFg8QTSKmxAq/l65XHoOHyYirZCw8W4wazlbDEWrjmAyuc5d?=
 =?us-ascii?Q?tyxbgspa4lz5Nej8S0zUg83zOJ/bmNYHayJnCwY1PDl1cmi37D5sTap0T4Ia?=
 =?us-ascii?Q?EsbrtdCMSdQvAMAom/8j+yA8+c5onbrgRBvYf2Ty/fMTAVJ+Wpv8ADadbrEK?=
 =?us-ascii?Q?SLDfK0pBO8uH3B2uachFWeYFjODq1m7/1LUt4wk8Ozuy4i/0g2Jt7wDflPtQ?=
 =?us-ascii?Q?F4YCka2q+rFz9Uk+dMXiap1//3M3xPOZAIKltWch07BXg5ojm3+I7xbiZ21G?=
 =?us-ascii?Q?N1CfIoKqnPClh2YH3Ew1rcJontdpoEBfjC+3ztMlc7B1sUxvcWkm2AMeyC3R?=
 =?us-ascii?Q?xRnLKqAxmeNb2hC3ULlRzgub11utC7H7FF3yPDM3y6MibZLOh5rwdyJq6Owl?=
 =?us-ascii?Q?EO3nmmWSwSCEmFvpm57apLrByOfUPnFMNGFCKeHvpqtMNA3rsQxmFBATH+jA?=
 =?us-ascii?Q?a4h+N3C2WWQWvPW/upVGNlgrl5U1bS5f8yNjLCANyuY8T8gzmZ/JjKJlya9j?=
 =?us-ascii?Q?60aIJCKGj9WrGkMn5lM80DdkJe6b3XF4P3r3Vt3tYvzMjUDe3QdDQf7koaI/?=
 =?us-ascii?Q?dctAslhOr4p6/BiBvkci98aZxanskgbE2bED9GBvNlX83fLhmcCTUdSaCBi5?=
 =?us-ascii?Q?zNXpuki89tzzWtmvHj2yrMGXLIG7QBrv9aJbtxNzNwtq/pAM8gKj72l0Z0RS?=
 =?us-ascii?Q?4JdSeaWF9Q5XmvBmpVLoYx4Y9UGG63F605zpaNNrXLRQNe37JS/quyf1M+ja?=
 =?us-ascii?Q?GaDPUVlBov3Fw8I9iJyNCjzuK+dPuyLTUlg5xCCxIp0Jr43MG5Mq9dpEbQ88?=
 =?us-ascii?Q?Zy4P6KzHRcy+63UqKoHllf82oO1BGUu53B2Z50r5OrOdVn4dQRz1dV9OOQcg?=
 =?us-ascii?Q?qm4vAAz63fivi5MJ0w3pthyJv1Zmi7WhRoqAnslrNI/MAVJN/zstdUp1eg6I?=
 =?us-ascii?Q?mh1Xf2BkVilHVRk7+YIvONAvj4b24DJ481TSC0PqxRBPdYUDHRai0WqIrGol?=
 =?us-ascii?Q?PCcAWru8dMg/Sf5IP2nk66OmKwqr8FawwZTN5BZF+SoiQ5EB0t9UyMCbujDl?=
 =?us-ascii?Q?7ynNcQBgmYsgXdpjLijAa4RO9EkOMAndB+wF9l6Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c033db-f2ce-473b-96f1-08db4516b7aa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 22:53:27.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2qaO/vQ9CmG46IZKDQOC76JaRXEzK3LP4Af7oS2U693mi56h3E+x6qP9midZSmC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6269
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 08:18:33PM +0100, Lorenzo Stoakes wrote:

> I think this patch suggestion has scope crept from 'incremental
> improvement' to 'major rework of GUP' at this point. 

I don't really expect to you clean up all the callers - but we are
trying to understand what is actually wrong here to come up with the
right FOLL_ names and overall strategy. Leave behind a comment, for
instance.

I don't think anyone has really thought about the ptrace users too
much till now, we were all thinking about DMA use cases, it shows we
still have some areas that need attention.

> Also surely you'd want to obtain the PTL of all mappings to a file?

No, just one is fine. If you do the memcpy under a single PTL that
points at a writable copy of the page then everything is trivially
fine because it is very similar to what the CPU itself would do, which
is fine by definition..

Jason
