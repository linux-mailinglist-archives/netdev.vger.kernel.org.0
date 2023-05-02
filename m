Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390E76F44C5
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbjEBNLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjEBNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:10:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF184EF7;
        Tue,  2 May 2023 06:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXcDjzbIVixs2DoiDBSmZlSYKn/XZcYekxiwdaiP8AkLmvMUsuVMCWeLdV8hBUe8DelY6ewgNovqoHs1J05m6mS7YC2IRkRQe+WxKJIzTUcFq5cQ85DaJFJx20iwOoliPmo4rNqefrlbzj/M3PJHEEiFwXuF0Uz8t29ianmHxk8Vf9HWqD17RO0DTzyCfUgRh3q7q+XDuaLKwzS9W2KfF1yAAyNCskuQx0u79E1eas7xp/iADxhYwwphZvG3Ir5yB8PnXpnASToTwNV2kXQ50Y9NJn0OXeGZy7CgZ+X+C7W0r7l9Eq+oKdLWwFfYRGqUwAksEHdeFQ/yVTzzV8hDXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPzkKvPpTdvfzNrxnLWsHP21hcsohDSdzBNDgvttGUg=;
 b=Y3Ii/EyhpbQf95fGwgeFJXke2h0KZdE95W4iXBvV++VjzhewhnRoY6eEtzMcXUQTUe4Q8raob7NGtQ+mvk9jO5WRr0+YUyeK1/FCU0MDzzQjrECOm9Q0IycKUkfL2BLRibFVlI535dFzj71EwvNkSBhj7G3kIh3EEt1ue1CZMprfzPfAN7IDs/SBbW90h/LLxT4Nwj4z5EFAilGXDPH6Z2u/rv64B8Mczivb8wKVPDL9vipGeRznGCNvMKX8h/4RBXoCYSqL0QiH70T50ONCCsYf+30mOg0HqF/4YrBERJQ+H0um0ehpaECgQEPfaVfhtGI2CcjDxh0iFPbq3hDzVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPzkKvPpTdvfzNrxnLWsHP21hcsohDSdzBNDgvttGUg=;
 b=lda4FKlG20ZiVRXAfqPehlQypUh2ouh3dUfVD/V/xog5E9K2IH8hZG6QUFBxgomTcxT0sXutm7v50P+4pgXTUDmW4YHs+mMLYXGbJI1otyNLINB6HtrcKDHXv0YzYyc+/Dr7ewGeL8Vk4WhvVQl2HO4umf26ROZZjtHD22VCOhNDLlDsXV0Y1G1ZB84kfTRFGPXtQvpPgxRevTmebSG1Wd1uQRSXSWsb7hRbbDOPSQOX5P0/r0KCitw37Xk+xMZ0c6gF1PPZW7sHzxEsv3ttbW6TUxJTzhqYBIZEcQUC7h0odJhvtR+kVwbGhFE/TLVolBPfQ1X/74ffxz3ET1z7Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 13:10:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 13:10:52 +0000
Date:   Tue, 2 May 2023 10:10:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFEL20GQdomXGxko@nvidia.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
X-ClientProxiedBy: BL0PR0102CA0016.prod.exchangelabs.com
 (2603:10b6:207:18::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: 23ecb3f0-1e18-4039-7851-08db4b0ea818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7Ic/v2qchd0RMFjyl11cIyjUADlKZk1ZOzjPyDjgG63b7vt/lDBYWflw/Lieti8ZXyyWlVumZCIAsTmXY42ntLDDztjhQmjDGBTNEn+8Ol56ZmE+WGVjy/1xDovgJLP5u0DYsXWBiPtXjDeVt+ycDv2kcLV3XaNpUXikpOQubB0cuOMeHAu2eeib80G05p9hrj0lWU4x7pVJNlKFlj8dvJ1E+DSOK/nYKwmE6nfsoMiTE6zJ0Y5PqQXvAPlixFcuOqXeiTmpzOYezGIHJEewGoRoTHpUoV3SvDzG495Z5it1PxQ9a6+PDO6FHcibCjWxDcY0DPjh62D/ziG+tB45kAKWUKzsh9hHe1AtEyqy6o56yX0/bWaI2+3f4vP9y59Dy/u+4gqLX4y+x6GuR2iGfii+MqFmnjPNNFLDD/1Cxjb6CK0WXPVrP9V8DWQXNXioHNAZnvQwuHZgLla16swwwfiwxZmzbU1R0aiysX3ge4QH/TGPzI0HtvOVKTSclDBZuOIMyZgZcFQlagRti1Cho9mN7BRv/9OsZyf/msi8xKkEQSbS1pTVoEiKu7i5xsc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(2616005)(6916009)(66946007)(66556008)(316002)(66476007)(41300700001)(4326008)(6486002)(54906003)(478600001)(8936002)(8676002)(38100700002)(4744005)(7416002)(7406005)(5660300002)(2906002)(186003)(6512007)(6506007)(26005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s/ol8sP1qd9CaVlKOICXwKfnpED2iYwmanTHyAs4yY+9gLanbFpxwCCAub5A?=
 =?us-ascii?Q?zy4jCUZvQBLJsA8aq/4nGcMpmscY6U/77yReBZUEpuIEvR566hiW5B17vY9C?=
 =?us-ascii?Q?jFWv01oMunprKM1NJtwbKfaD5wFzfkiDGxxoBku7xFA5u4ZPuaumAuXdFDf/?=
 =?us-ascii?Q?2xaGpPomp+eNtsjnswn4faf+66YitL6nBv4Qx0WduWYtL5TUZe1+BhRGc/df?=
 =?us-ascii?Q?3i3E2Y5kH52vAiFTMC/fEXbQhQ5kP8sGgvaDRoCZjrAjcc2mg7N+FZQV9eI6?=
 =?us-ascii?Q?QvM6sD7hHgRL7b4uh96nPQAZO3n6KFQLganuFa2b5HdxdfM0iG/vpbBwChs0?=
 =?us-ascii?Q?ybBHBjuMH+uY7AMAPUHWE2uSMybrRbnH52YR8ibilVGRki/I9WBppSg6tfY7?=
 =?us-ascii?Q?W5HYVeB16ODArHnEU1X0/O2jYa9u3m4A7NSyKqBv2NP6ykWhe7wEOOLlYVac?=
 =?us-ascii?Q?fF1qSiwldY/fAOs+GltOvDCvzw18jH2Xen7adhKwhfJhrEc7O+XFnHucLpJM?=
 =?us-ascii?Q?ikvroxc63Md/N8sxWZ5UOVTUOJw0NZzd2Ga7lbQl9mgENavOXbHF7Ud1xA0f?=
 =?us-ascii?Q?iOvYC7IJSQjGASQsvouWdi2tsEEn/fmUnurSvAYf1GQd1fUTFXuweW5ojEHA?=
 =?us-ascii?Q?sYbBUcbsmo5xMFKXL54J2aRRLziHUOwT4qUxcOMCWFLk1RToz5v+byW1t8rW?=
 =?us-ascii?Q?xr3WEQ6raD+Y32/z/pQpqW7sZkVqE6riaNEXrh/6Il+8XM4nVokbVmGBaJsB?=
 =?us-ascii?Q?7xSNJ5E50EmRzQGA23fEq+ENYcSDzIX493D2YqGavixLyuASWowfKsEQyJwV?=
 =?us-ascii?Q?V+esAiE3fhrgvyh31u7rb6f25J+ZMMMuAgaswRy/kFSq/lyndhOo2QTrVgD5?=
 =?us-ascii?Q?umNixl8p2lMA/0LWcEh1VxfoqwWYvVf5mXhkqtj32NRApcJmv4d0F7DgqaEQ?=
 =?us-ascii?Q?dJvesMrF4rDOxB4ie1iqOL4yOWj/aKluvIrmnNVxAc02+Ohu0BtreKN+dD09?=
 =?us-ascii?Q?AWIKhrv/WyuU3NEuukkgj2L44t111QJJMrN1o5v31foQqvxQwxO93FmiNz5i?=
 =?us-ascii?Q?p/xbAMgUg/B36RXFO372Vg8n9F+1TNiNw9gdPBha1g+0c8TSi+2E0mU7qtV4?=
 =?us-ascii?Q?nhO9TTNVJOCW/wS8AZ/npfdGiQP0c8RudDAqeG1BCyCI2BgLqLJNAoomBGZ7?=
 =?us-ascii?Q?4mEnr28mZNvY6zFoemQVZhc/EBDLBz8OKhEtmMLcMaO+3UNodfAYuTApHlJh?=
 =?us-ascii?Q?HPOP1JTvT1wYz5aRvlONrY5bEDpAVYsfvx4wazeEOcKMTXtF8qGb/zo1L1+E?=
 =?us-ascii?Q?WBjNfoWNO8VTWQlA8KyEwusloM+z2UNIKSfGW0i7j682kKmN8nq73Bw3543q?=
 =?us-ascii?Q?2xQ7cl5O5jjKjiFM3J286KdNEkj4C/b7wjvCpDZjeYyIYKZAym84vlmxtQQ+?=
 =?us-ascii?Q?E1DUCMqSKKo10HcOeRt6eBQTMFCkgwkmX+LL4lPyAYFSzes7vyCr19I1LVig?=
 =?us-ascii?Q?+6cHSX1vAzMq4tc/ZWk3i8PJ136K4/wVkm4jL5dB6x+4+WV38Jcbqf2IoLis?=
 =?us-ascii?Q?XGLjjbFdctxMtxZ910KxVk1xeG2pB2IbOZRZNE/E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ecb3f0-1e18-4039-7851-08db4b0ea818
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 13:10:52.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dS9FJcuSu5ZkRb4EF8SGWNYEifUZ6mbE5auWC1/90f5vc6k214M1A9reEHXE4eJp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
\> > We can reintroduce a flag to permit exceptions if this is really broken, are you
> > able to test? I don't have an s390 sat around :)
> 
> Matt (Rosato on cc) probably can. In the end, it would mean having
>   <memoryBacking>
>     <source type="file"/>
>   </memoryBacking>

This s390 code is the least of the problems, after this series VFIO
won't startup at all with this configuration.

Jason
