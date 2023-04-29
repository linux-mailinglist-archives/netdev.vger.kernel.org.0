Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61B16F2719
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 01:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjD2XBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 19:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjD2XBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 19:01:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B393E10C8;
        Sat, 29 Apr 2023 16:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRvlAc+gOYeNsn1WfUamGMpCQoxYL//qgUtBctRQEoXtb9RmmukVnGYjo8JwGIkUBA3WumR63X+H0YpEwmR/suMqVwvRHSb8DQ0558N2jwU5OiDKxLqLZy8GZzxwc01FQ/EkrtfPiQ7piIScoVYefPF2fniPy8aHvUKpzi75fadZky3hUmFdfbiM9dfRW2fpfpHgUePaDEfQLjSe8X7ZpVYralkOz+FGe4x7Aqfi+g0+E6tKHAPkXrHTy8TxL1CpU3wUDiBpkjlcHkHl8Bhu9O8nu30LMN3ENfT+odCj7YJBWyas4InGVbs87r/cgtvq137UbeGevtqsWrMlzyH4HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAzOe1E4oP2JwXEcXxp6XW35UWYUCw84ldO05T3Lkns=;
 b=OSdqdPu6++EViRy5+TCQXx483JM7E1WSCZjWTlEQQC37YURFg1WhPhakzYYfn3k0LO007sIHk8KPidsFMjRPt7tfuP4rsuplkytM8R7u9gYoeczngLihuFpi/jVKXc9JDrQOuuKmQI6mI34p+AdW/u5arSm8f4217yD/Uav/qVi+7rT2eOUV6x9C8L28xmCMBTRvNjKbJRjXeCYXHyTamHmbXYpVCk0Ff+2nFOdJVI6ma0FDWCvVDB1EVn3wnOVCm/gUaiBkLuREPbjpOnNwF5KacrYC9tBp/wV6BCtuUhaUFqgnGUWTSiN3EAnK94ThYzouxkQ34/+YIVPMAz7auQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAzOe1E4oP2JwXEcXxp6XW35UWYUCw84ldO05T3Lkns=;
 b=VGyzzmF1+NMk3/44UfdcLMGPB2/TiBWSVUfz2wUAHcGixvciyadploRzein9W0ydIKCYtiUWFC3nLQ9Yme8QQ4LC3UF0h6jACCA6akfXq7O0Snr1+RDd/Fb+Lg5t2tMrJpwqZejD/Qh6Zz1WqvYqwngDqOts332NO1mZx4p/TPD/xxZxld/yCX/cULGRR2UyDsRDBk4rMn7lElZ7LAJqkB1ISponpil36ssWOwUG6Yj75aN46nuAS6/bE9fLN1qsiHb6td6R3HGhxpJn5T/ytmrByekMwctJN29bdmZAHHAI8rk8GKaWo2aL5bLzvo8T01HqdyRmS1s8RJOSiF/Wlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8162.namprd12.prod.outlook.com (2603:10b6:806:33a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.27; Sat, 29 Apr
 2023 23:01:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Sat, 29 Apr 2023
 23:01:13 +0000
Date:   Sat, 29 Apr 2023 20:01:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     David Hildenbrand <david@redhat.com>,
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZE2ht9AGx321j0+s@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
 <ZEwVbPM2OPSeY21R@nvidia.com>
 <ZEybNZ7Rev+XM4GU@mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEybNZ7Rev+XM4GU@mit.edu>
X-ClientProxiedBy: BL1PR13CA0370.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: b7f0a4b6-9920-4195-1190-08db4905a0ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvroNd8IL2CEBwf7HOaNb5bO5VEaDVE6NkxfYjBMiWUADkzRfdEWJIDTRN+Eyk22dK4E5bVjbEPinPBV1L6r6v6qepFNdzXmWQQFVOto1cKtP7O8uME9zC30QDajes9ov2jVD77kDx1dE5L0hQFOUGlq6u6AQLvBt0+l1xVy2+cQqBZz/gr1Jtrqvhr1loi/H2VFqloj447qCvJKk5PUKCUs+UCtmIWUZR3oeVl3Ssqxy2au9U101FWNMdAZtVQk7j6ACCpji0eMR4qTNWQOc4I1oj8nwozYJ6i6t/2BWQd89vQaJ0M3gjUhqsWQbcN9YM/IdlmfBb7AtAWOKVyG4WNMIbM+vsbo8/P8qE+DYpf58XecgrPmrCSOJgtYhYObYrh+y9nCLemmOIwCLJCQuCuCigzzOf6HW4+bYR45z6hc+yXVFlFLPLg3nXwQrm1Hp+tWogx0+DNbv4MqPNkyPmUUTTAPcfTq2uiO+Cyr54jMH04rJ+69/cZ8gHRf3BsHdETM76uCiFJpPKZ/LbPWvaei3k3rTBW8PbV4caYzQ/uBut60wgL+BGORNgjlnQq1ZRgJHnLxLSr0dtpGuaXCO6iyEDt9XHFWI8lvD1kvqjI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(316002)(6512007)(6506007)(26005)(186003)(41300700001)(2616005)(83380400001)(66476007)(478600001)(54906003)(66556008)(66946007)(4326008)(6486002)(6916009)(38100700002)(4744005)(2906002)(36756003)(86362001)(5660300002)(8676002)(8936002)(7416002)(7406005)(66899021)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iE0OKmkRiV3OCd4usK7tt+/I2b7ADXN9MFJv9oHh2+6omO5t018JxSVLeAI8?=
 =?us-ascii?Q?3bkcI+iHJm/IKJevp6X8c515vNGHtpMnVi9BTx9pSk23U48tuAYS/d8kl90a?=
 =?us-ascii?Q?cQwz32+xyEe1e4trNfj3WEGeF1MlEUuidkRLorfOcQ+E6rDGPVYTTb4jkNuO?=
 =?us-ascii?Q?VgvYwvI5SYSwcwyTR3HzFQKHoiREZqZAT459owUGvea8sXMdY1av3n6PA/AI?=
 =?us-ascii?Q?SqlyyXvZ3+2Znu06TR+ldDD11Z5JNs6J+gZ1l3SHmgyCTdIhr4oFlPEJ7116?=
 =?us-ascii?Q?UVaHuJjw/Tp88nqDhMOZoWTd5LxyamWp7FLxEbVE7JvypAXHgdhDpifYioZQ?=
 =?us-ascii?Q?j3MoK7hytJI9Mr/DsB4Uckp3+JLthoOWeN3eWreRU26D1Jd1lPs3jJHGhtGm?=
 =?us-ascii?Q?mZQPfzuLRbUWQzteFu22zSQ4Kqtp5sPm60XQw/5qaoBi0K9zTuChq5RAs7hG?=
 =?us-ascii?Q?+zcPULtvzHx+IRy5wK9QFuStnLLycVYumWYNHUKIv7kKmcIep2X8yUdUBxRe?=
 =?us-ascii?Q?oLcoCPRnwKL+wZgVksgJaCuDB6vQn0r8fHmx79xQXAVOwNVRPJsnX10vgBHI?=
 =?us-ascii?Q?CnaN8ZlrrFrudWgQ12LzAEJ2CMNYpWJyGnte91s2I5VP1GP13GYD/F21nWel?=
 =?us-ascii?Q?Cg9I0ltOvtG5iT8jpxXk5a8wcMU8Qt8IrL+yKAfsyuGkFvXLwTtsntKwzfjQ?=
 =?us-ascii?Q?np/cKeTA0iLtmWPJ1JpfZPgbDs7nT69AyXwOKB2Qx6el5jCKYozHGbr45/mI?=
 =?us-ascii?Q?kadHaAw6dR/x4vRoh/XA7glfEUxGN/spAG0f1Msuza11uHQ8Q/nezLCRxrw4?=
 =?us-ascii?Q?ZKjDgYfF6VMZFsfLQVtzNvjy0d9AM2vlgykgWzkoazxMT+ZXjkSJksIKdIqD?=
 =?us-ascii?Q?Y1FUG+czFcDT3O2pwl4q8698854OcWiiLDZKVQyopd+Ns+wvmSfHuutmA1Ak?=
 =?us-ascii?Q?HYFKNEmcayaUYe1VwY5eY0M2yaIAntpf4mFNCzVmp9NkGlnJUnLt/fCk/yUy?=
 =?us-ascii?Q?QH5zXlWdn10aTXHJWUcYY9DP+ANP4cxYg6kCuTTzFobUwfPX5ZPalWOICLju?=
 =?us-ascii?Q?ewYwSBWMl/p4W0xJ5CE0kHfNOgJXedjExoINm0KUcovJrC2ODHrEkmvEjXU3?=
 =?us-ascii?Q?TRlX2eKJFnk1fsQ3zhSr1HXdWN7h2L31dTh41F/vIsGiZLj9vOeIfy+uZVZF?=
 =?us-ascii?Q?gDOWaAHgXw1eaeRMiTYy1u3Q6okOj7Fgp7mA9jsePe+/mNwxtGdM+ykZ0C2R?=
 =?us-ascii?Q?eLTJgYS0VVUGcV/Ph1n4kDsh0dBHogUZpvK8UwkageVPAJHWyb/YiMupN3Qc?=
 =?us-ascii?Q?35dg5GuHI6JRXIjAW2bsanRMj8ENVqD8RT1Xs6ot/na5+h+g+WVS/ev6LoW+?=
 =?us-ascii?Q?c9YH5aVBdWW6+ZDgkiUuuybN3vu4xrskLXzxhy5sE8I7ScbzRf2a4vP8lfaW?=
 =?us-ascii?Q?MNPFLoqdhI4HvN0Qt2XtS/kA+IANIdBuoKa2Qg1/yZ/WUMRA2L1Nh5wuw2SH?=
 =?us-ascii?Q?ee7T2OlxRK6PALE3QIFwX+T9XQ+hR0s57u8+dqD5Bc5YblOZwS1HLXIR6LvS?=
 =?us-ascii?Q?hRb06Q/7QA/njs9VES4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f0a4b6-9920-4195-1190-08db4905a0ea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2023 23:01:12.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSGh5gs93kWmWsiRmyswfGfTbUstHzbWQYn2DRr4ZlUBnrGex5QPWGFEimC42Dzj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8162
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

On Sat, Apr 29, 2023 at 12:21:09AM -0400, Theodore Ts'o wrote:

> In any case, the file system maintainers' position (mine and I doubt
> Dave Chinner's position has changed) is that if you write to
> file-backed mappings via GUP/RDMA/process_vm_writev, and it causes
> silent data corruption, you get to keep both pieces, and don't go
> looking for us for anything other than sympathy...

This alone is enough reason to block it. I'm tired of this round and
round and I think we should just say enough, the mm will work to
enforce this view point. Files can only be written through PTEs.

If this upsets people they can work on fixing it, but at least we
don't have these kernel problems and inconsistencies to deal with.

Jason
