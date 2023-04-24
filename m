Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8226ECDD4
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjDXN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjDXN1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:27:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0958619F;
        Mon, 24 Apr 2023 06:27:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEf7nywjKkRsIVg2dJiGyKmBLwPWTjROJc9y1Oz/EOkxRxY67068Gzi4CjhAj6algZ/qzCZYmbwKmdukMt7w8UKfzP/zzy0R4+6XsM6YHvzWtQIhUCH3zPvoHFTw2LtaNfZTLKOMePKw7TTUS0MmMlVbs/JuD7sIfpT2DTpBsEK9JbUcIWzqOLHjkLROgEnIFhzYhw4Vi5Ft/9qVZwzD2bR32rZHgAobaBAh1abteAffV/b73y3E0QZMrOH/Jq1PQ++bnR/6F4ohyESgMHzSo3/E9lw6l1DvnBJAjn60H+YNoDsu6YHd7oiajiBrhPTarBxh4PtRW70TCk9ZUxoZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFjGYeeTkkN4qYsvEfaX2quT+z3lutAUNZ/GoIkBlMM=;
 b=F/K8hBq6F56z+fW5ItunyXasAsXPDD1AUeNjEbiBf9IQ/gga+8U/fgNwZwZb/6BTyDjhsf151NRF/HPr07Z8Ucdw1Yu2fEplE3ioA8Z3O+pjgPaxkOVdrk/xb52jNxFoS2fVypX8T03X3V6rJCoHd3J88UGUp/m3N0Ng48+SXP1fL0thPemghZwrbT0CpzxrSBgU/hg+yXZFmCttXznSE96e58XgGWFy1Z4PVK5rhn3eAappYQ8vV1F1n2idTkAkxO7CNcLnbf2MzKe/76HRsIpDV78xKb9Ed5TXuKzUXHzeJJ614vXsgIHgvtWnq3TQyKKrhU9dqRO0EfsCGa+C8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFjGYeeTkkN4qYsvEfaX2quT+z3lutAUNZ/GoIkBlMM=;
 b=dgMAXgRdd0zBE42dHa+3bTRI6SGwNLfXDQLUbbckAM/1w4X5TF1qZq1CQpx4m4QrmjfkLTMUzYhp24XKe7Z6nMwkEKBwX8567oF1PYo4HlaPqCKakd0RTYRE1PKmFjCyEbfnmRBoS75bGxO+se18jYW9jKeIOQuuKdaTLaevNDBlI/3436pmNKfs94l0sweUQfayz9tKU2b+Un5cs+arIurLvXZsf4zmFPJ6PKT8501CdDcLDt2gQzSQ/lCguy9aNlxaa6UmHeGsPiCox9cLafXAEJ0zCunuQRz2bE1We/LSb8yVwGavLEI+ccztFhhNdKUqAyYyWQESrvRpBhEZiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 13:26:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 13:26:58 +0000
Date:   Mon, 24 Apr 2023 10:26:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
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
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Chris Mason <clm@fb.com>, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEaDoZOeUOAwcWER@nvidia.com>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <ZEZ4VCyfRNCZOO8/@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZ4VCyfRNCZOO8/@infradead.org>
X-ClientProxiedBy: MN2PR19CA0001.namprd19.prod.outlook.com
 (2603:10b6:208:178::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: 23a1eb77-5898-4366-4ca5-08db44c79480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jsi40t7IrfOfKRsnvVRf7O7JkbAaLgfzIAWfd5o7Y384ySO0yncZRG3JPtAnuFFv37B7YkyIFBdgYNSVIxIeH+1/Bc9PvCw+O9DQdMC40nTn1BCEySsAfzVIHk7Otnb+KnuL978XYA7JAcOVFUfEMqU8wAP3cVedFh8+NHdaJM95XJK+JNcC5Uctocobz3U6TmYctSThvHjXxhKPX8SfbSYneC1RJF74y5t5OEeDR81fYVFbs9QrNfBBniu8ExThENGgUpA+kzIkUI0kUDVPmWXPNPUNQHhTUED7e4RNf0jPOStahQc7ULYDYjdCdedm9tofSnLR7SRnPP+H6ryHG47Er6KFoGFkcwzht9x/fGqNxwyldBthIoPWwRMvjOicBdRz3WacfsrpvM/zsuLEtYmwlwX+0bjaOEZZzSTsZVUV/Kt6utumK1/MT6QjH0S8MXtuC/FeQBggltS0m3I7F5K2+o2WHObp9USFjZxEf38OCkkGIHa0vBQQqVQ+LElUKKOiGALvcg1Deykggq8XdFraKNTcPEWJMNQDLoFsYqxveok8cFR3BTYP2TyaPRCl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(4326008)(7416002)(7406005)(8676002)(8936002)(5660300002)(41300700001)(36756003)(86362001)(6512007)(26005)(186003)(107886003)(38100700002)(478600001)(6486002)(83380400001)(2616005)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8TLYZHomVqVSwPT7qwqhcJb2irjrF+ASC/DAeIwZtasxGA4dJUl1mbdWdb4B?=
 =?us-ascii?Q?+sEFSyVpRoSNF2vspK7MWFRBO9/Pu1RGnTMFZaSsqQAh1q8rOsmgnEV973VL?=
 =?us-ascii?Q?sJxkXl3ag8PaoNTx8tjMEFg9DJb5E69udRdihOaHa3JTfKfoMfz4LBBH0bEL?=
 =?us-ascii?Q?CkqUaSv2X9lLdi2YgLJwTxmn1oqVws0jw5xc56UQR36FTm6dNdy8nb65FzXR?=
 =?us-ascii?Q?T0uc9ZXkH6ufqwww0JmgQM50BtSyjtgzksG+Wb+4qeb2e8nIBPYzLkX1e4RW?=
 =?us-ascii?Q?BYwuhNBbNtoSsy0paDIxquObynWsUdke4eZEYFfeNufWxOcKJbJPVk4zaUEU?=
 =?us-ascii?Q?sOx5cWqOtbUp+lf/x9/6XaPO4npkne3RxzjBONZObkgWWKSqEdcOxXtU2hwB?=
 =?us-ascii?Q?GoW7H7BvCFIEGu23UtCzOLmR6RY97e6/IR+oQFtHwbjWsCwKfJFheJ5eIgVZ?=
 =?us-ascii?Q?kbIXXv1aqRQHFHEqgMW8FehrjAxFmpGJzOmLGDzivjUsy5BZ7hp59hl1fG1V?=
 =?us-ascii?Q?WQ83cO9uMDpSNylYfqTJyNDljRYLTAKch8n4n9nClz6/vKIRCN/tCN1dU4Jy?=
 =?us-ascii?Q?UdOqiT7o/IoVSnvXyzQGF2QBsR3ANQHEhRnS08VN6CkLkn7VDgtlPrdMhiBs?=
 =?us-ascii?Q?6Q8ycaHBf1s0m0y0hgPbXHBn2EVVnSNZEFYstzzZLD1wk3+KcSubYFir+2Tm?=
 =?us-ascii?Q?rOoiGR2YWy6yCLJ8HcxjM8MPakbVYcM9qiHpdrHmvW4otifmgIFB6efTtcUM?=
 =?us-ascii?Q?k/xqQ5Q0JnHSq1OlGxTUJmTgO6AU0lR88xnH6chSraz8VRrnVW1Px0NwYvyp?=
 =?us-ascii?Q?0yWCsptxiyDwt8br1qSuLHHW/3olK55ClLlpOqsciQGILJG7H41zdz5kSX2b?=
 =?us-ascii?Q?xrawefhi7XlUSpyrtwhIfENMRGQY4+XxZtXLOyZJPWsuYkxj362P6d8tc6Q7?=
 =?us-ascii?Q?RsY9tzWthBrt2yHbiNALLHZYYs8RYwSB231YroisL8F8C6wzn5QfgRWCCJ1l?=
 =?us-ascii?Q?Wyf5H7gWzWKIjZQW9EL+jr9iis4fhZKFApByqwOdIrvBzabw8wYEGDIlgVXE?=
 =?us-ascii?Q?WIoZpZOkTFbY7ootvjzsrYcaL1iOfQ3h2beBCJD5dYM8ylc9XNjcwhNBA79m?=
 =?us-ascii?Q?x9yWpehvhdB3KYy7uI/VJzIXpur69oppobR4JBmKVzyIDgl2DRC1brI0uwcv?=
 =?us-ascii?Q?k81WmN5T3AFCfOzgyhBjrnEtF7czH3LqBR/3+tzkjMGsSQUKAkJfkPUIz8y4?=
 =?us-ascii?Q?14fQ6wfbAYK/1yWFz42SBti0ICLwjB8A+WSnZdAlF3FNMxlZPwjF2MvPcEZk?=
 =?us-ascii?Q?d+G+KqcXgwf7hUA1YqwgGeXHf0fY5tPAtSV32XODKtMQHnOhRaHwi1qy91Oc?=
 =?us-ascii?Q?8Fy7J4II8AuZS7WCV1zmzI54KPWjM76Qd59/6b37vndZ1Rf8lEO2oMNB6aCY?=
 =?us-ascii?Q?DxN+X6S6TXhJngLCa2zXWaGREEx0CdORIRDfmQS64FfBOiBw1e6R+XtkJjY0?=
 =?us-ascii?Q?ExpRUFtSo0AI0bQEQn11bKLsC9ZtnKZhEoYWj2gl5Ks9igPIGbaWoRNTldt3?=
 =?us-ascii?Q?I1eBc1bFCZ72eJTNCwb0sNr70vATBadnHCDesWJS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a1eb77-5898-4366-4ca5-08db44c79480
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:26:58.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Rc+aFe3tzMhZ//e6fjXDnZYy/oKklpmjOLH/p7xDRE6CMcZ3vjgcfJUcsOOhAsY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 05:38:44AM -0700, Christoph Hellwig wrote:

> > I wonder if that is really the case? I know people tried this with
> > RDMA and it didn't get very far before testing uncovered data
> > corruption and kernel crashes.. Maybe O_DIRECT has a much smaller race
> > window so people can get away with it?
> 
> It absolutely causes all kinds of issues even with O_DIRECT.  I'd be
> all for trying to disallow it as it simplies a lot of things, but I fear
> it's not going to stick.

I suggest the kernel lockdown mode again. If people want to do unsafe
things they can boot in a lessor lockdown mode, we've disabled several
kernel features this way already. lockdown integrity sounds
appropriate for this kind of bug.

Maybe we can start to get some data on who is actually using it.

> > Alternatively, perhaps we abuse FOLL_LONGTERM and prevent it from
> > working with filebacked pages since, I think, the ease of triggering a
> > bug goes up the longer the pages are pinned.
> 
> FOLL_LONGTERM on file backed pages is a nightmare.  If you think you
> can get away with prohibiting it for RDMA, and KVM doesn't need it
> I'd be all for not allowing that at all.

Yes, I think we can and should do this.

Jason
