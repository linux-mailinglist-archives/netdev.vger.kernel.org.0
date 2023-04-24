Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4376ED8B5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 01:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjDXXTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 19:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbjDXXSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 19:18:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A70AF12;
        Mon, 24 Apr 2023 16:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be+NcpD9/szAUlX+s7D1r4TssJpOD0f1+qOo+BnN8fMr0nsJyDqaHxDN1qrTq+CpopGzSoAdtYkrpflqSEIrAH4xVgDOwwJyS/kugBcoU3Oju8tYtAahqslw0djZ0nya6U56vO1zaM8O41/BEC3P4l1ziJJN7Rchv9yEjylZoH3tvHxg+idXDDUPTonv9M0P+ofUn1d6B5Sn5UgzitGyS2nNkc7RunQVEbgRNKVzWFGv4hUWo7IxzES1lslliGnbtQGn8LGSIFV0g0+pJGs/GXov8p7YvoOJG2Pmn/RUrcbdlP0aSv6JX2XUY0d91Qv3Mo3UG9yfOTpeaeyYhsgLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSUFjRyWKGVLa4ap/jushtlwf3zWrldwbevRdhgohfk=;
 b=bleuHglin3vyH+4RNU5oQ87UpNdKqoEsBUGDDOqTYTz33RsWu7FF+X32vnovrBe9xlejsf51Ww+S25H8lG1sGmQlU2FhHi5e6IDGz2lPVV9V8CNjA1sNAK313BNeGPG/nMlqiggqOFpfduHsUVMfqdX0yxcOQo40VFdMSev5NFR668O/itKo9k2JGpSPninfLnGlOYOD3Nt5dGF65xo8H6QcA/fXU3bfQdLPtCNUeraOXtelWIZSxAKX70nWTyt9VY0nu6dpY7NfKUqoVGd8mxV5gPRL8ucy7Tr8s+MkA1YhhZkU5MIzGxkt1SuhAURpeFjlTRxPTARxHIoucpYAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSUFjRyWKGVLa4ap/jushtlwf3zWrldwbevRdhgohfk=;
 b=TBxDsJHSEN+2WUIpdQdSLYPPYhaIGKNUmNLT24PackK+3swX2tPzMpWsoYd5GOzrv8I0yfgjK0z11HM0PWCBqMlo+UhtHHaYfHcNUCYhc5vvjXKSPCh7ppZuwfy38s5CXm+9O8IHzSz0KIVd8Qn5h7j8FxplBHe1Ftuhqa6m3G2b5AE/hqA6AxIRCEBSnrIFHB7aF1TySMzf2r8Ymow35FQouzKVW+vdWvryrX7rsBDeAoxMjQuPRJ5A0Jwy4ELKWapKsxDDi6ywPLekNQZLjtt/LXicDZRvGi/p2FD7ymCf58+bT763HLeMgHw+VIrUmfF6s79N0GGbVVmtZvJOUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8830.namprd12.prod.outlook.com (2603:10b6:a03:4d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 23:17:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 23:17:12 +0000
Date:   Mon, 24 Apr 2023 20:17:11 -0300
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
Message-ID: <ZEcN92iJoe+3ANVc@nvidia.com>
References: <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
 <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
 <ZEcIZspUwWUzH15L@nvidia.com>
 <4f16b1fc-6bc5-4e41-8e94-151c336fcf69@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f16b1fc-6bc5-4e41-8e94-151c336fcf69@lucifer.local>
X-ClientProxiedBy: BL1PR13CA0276.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8830:EE_
X-MS-Office365-Filtering-Correlation-Id: 1190a044-5fcd-4e73-e8ea-08db451a08c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBgxsJdabisYKmoc/oJ0mqX7+jPJ2dQzHO4Y4+KmGKBKThQRQrfxuYld4UxrdXiXeZyPoWk26qt89Cb6IIBD3W4sr6tuV4Hvsc49EfoDTiDs8EX52UJGwHadjvxFif9QnNy6aI6qVdRYKgB+trw6uS5e4FoM67l258FWbFZrGmhXbC1gG4giuep7buCskFCWHLQypbynAqQZU2DpCWemGydd1BpV5bMtq0Ju1mYHAreHXRkXOkxGd44k216PE+Kc4I6+mLoG1kKO9o9PqvNs+UpIDrPRm8lz5BRhbh0L8AwocCEEfxkWQsAGi7DQrw+ks4jyDdqKXdcTM7Uf2eZuq75YeQ3OVXN7nmhGPlBFtBZeoornxlYM6hAMTbq1z9S6C2wOwHrQ0+3DeFAgRuwNb45/1IU+mhsvQlJUsm8ZXIehDAK7fE0JZojwhLgtERoa9CNWfwjrpEHAfRsChU/e2q3hbXmsScMyHBO4hla8At+le/VihXYGbkrBcll1wd03ADD9kxLTWjl4Culi98gOidIzMQFgURl5vvedTZqB/jn1Id9al6T+fckfhvlANe3XmYo0nDLgp61z+eb7bzADb27sPJydoUtEEyg5oJ2YFXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199021)(6506007)(26005)(6512007)(86362001)(2616005)(186003)(5660300002)(6486002)(36756003)(8936002)(54906003)(8676002)(316002)(41300700001)(4744005)(2906002)(38100700002)(66476007)(66556008)(66946007)(4326008)(6916009)(478600001)(7406005)(7416002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+iLPiU+p6HZmm6VsdXfrv7LMdu0xh2QmepaTZo/h/pqjzKBQJiW1UaweWSe?=
 =?us-ascii?Q?zTMu38JFoBPwNR9FsYu9mZmLI6b6JK/d/Cp09QP1wXjTycOzrG7QUR+FNK5Q?=
 =?us-ascii?Q?llY6cnHbuMTCDBrMoM1tjSBw3MKc4CUpus2ao06p4wJiY6Z+GpX7E4B0IPSJ?=
 =?us-ascii?Q?haM1xyp2DeBIkShg3t90lcm3w0+YKNnzqd4vTcFqDQmI5dYeaYpGnzNiGim/?=
 =?us-ascii?Q?9WxZWOwCQ1lLDbFF26jPUZdxMqjYTBty4wkSW/tvMrXVhJzp5v6rV1dF5qRq?=
 =?us-ascii?Q?6Ra8czDqF5uV6IOCzxehgkyH+xfihTllAD0K9iqEY1XBl4+Z7qcROiDfFma9?=
 =?us-ascii?Q?9kHqQv5Jvr6gwoOCVNsXw794F8eeCrZ71d5wc/l92gtBNAUgD5WMeH6VaDAT?=
 =?us-ascii?Q?yC3eGVG1LKwf6c/jQKkHNldqCIMdDUxF7Pi6k7k6LS+n217JwYr5PuunGdGN?=
 =?us-ascii?Q?FCAyJfPef+ypbZuzehHrzPjsvXFPUw60Kea5pZkCU21M1Tpd80FFg6YAy7hf?=
 =?us-ascii?Q?VG/vzHOzaPpsUuMZOxDg30Zb97Zes9bHWZNP+/rc3crxKZiZDYKksdbhmXCL?=
 =?us-ascii?Q?gzwjAJZl/hXd7QZkAXx4l2aQ59o9t2Ht5WsRb3yrCNzQvhFLVjoibkhEcncl?=
 =?us-ascii?Q?96EkLLDf5NukmL2QX8cqJmv5LaNwSjRy5jjY5dFeLUbvojJolqjRPQRUcPo5?=
 =?us-ascii?Q?gmKHGqwIfy/OEVgGb75SEUTf0erJmrMiSu30lfAd3k15/NYX5S7Twu/5vtNi?=
 =?us-ascii?Q?oKb/8Ox0kkmh7K9/6dW9Yq/7MHECugkYqL969M41YgoIVSU2Mbqv4k4hprrR?=
 =?us-ascii?Q?4QB2hrN12FYNhArTMEP25tqLqQM8Kamu73xEj9wbA435upwLe38NDX77sXzO?=
 =?us-ascii?Q?yj95a5+psv3KdcFGNZtsuHxyCJmxLU5i9vrO+ueY1F8dtdYGQWcgrv8+dGhH?=
 =?us-ascii?Q?df0JSYkFtQtdpC3KZ0rrw3cgXaf8HvY5fCh4gj2n8vFxYLdk0MhHLmP0s3P4?=
 =?us-ascii?Q?K6ifmFXEy44XV7u1mk6bde5WkDO+Yue96yBRs1fW3M62qDgiq1fJ7kt5M+5y?=
 =?us-ascii?Q?qYqQy/BuFaDRoxT8kEzUZnianqGaMPxpST8cjRJfU5KOcxdJH5iHDofQ+RJq?=
 =?us-ascii?Q?1bbPInzdTU4JO6U4v6iocLCxEPVXtCUI79nSAM8rJ/+v2MH7cpDlbeHNAp2s?=
 =?us-ascii?Q?5IYodo+N/Fi5rqgH52snhatgkaxgX0uZ1bOezxCmN547w81TF92ZgBCkvQ0w?=
 =?us-ascii?Q?oOoof9XHJmky4/Oek27CTwx0e4LCBTwNSmLW/I5mfNENrFblNUvPIXQaqrsl?=
 =?us-ascii?Q?LIi73OTFTf+nrjNMKYc5VkfaYjt0N6pydRXKa9/pWODisWn/vjNohF1XJ0Gc?=
 =?us-ascii?Q?NVFkNnm+amATy8hFC68ZmpUmWUfdibWfnODNOP5/wOjmQdNh4HKdNI6oWNFA?=
 =?us-ascii?Q?67E6K6eFQNKlTut3IZTfWbIpF0Dz1AVEyoW44ZNu6WGlEhjSXshosF0+ujKk?=
 =?us-ascii?Q?mEbSLhWFog8HKu5bHQyZSxLA4vuVg5kEWonbr3hojQzLi3S0kJFzHjQ968lx?=
 =?us-ascii?Q?F5Q/P+/3VoI4uBrHbZ4tMkDRBmxDp06UzN6w+lME?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1190a044-5fcd-4e73-e8ea-08db451a08c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 23:17:12.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpKkJWeouBGfXQ/N5o2HCtSp4cSf5p9d5p74uKWM7C5HS93HweFgDJYeLDkT2Nt6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8830
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 12:03:34AM +0100, Lorenzo Stoakes wrote:

> Except you dirty a page that is mapped elsewhere that thought everything
> was cleaned and... not sure the PTLs really help you much?

If we have a writable PTE then while the PTE's PTL is held it is impossible
for a FS to make the page clean as any cleaning action has to also
take the PTL to make the PTE non-present or non-writable.

> If we want to be more adventerous the opt-in variant could default to on
> for FOLL_LONGTERM too, but that discussion can be had over on that patch
> series.

I think you should at least do this too to explain why io_uring code
is moving into common code..

Jason
