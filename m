Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD06860AE89
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiJXPHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiJXPGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:06:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D6C1552E2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 06:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqDv5d9EoyldvZK6/Y59le8B2f62Y2Vsk5mTIckBAc1M6++Ut/2IX3DgCtn4Q/iga4ah25QxIqD4+yJAl8laOJYMfswEdduKXLMOFB+ngJUbQ5HgQwMNheoL+Nxc5Okfv97cE9mC8esDXY5CLzKFUrN+wvLbcgImkUfe7MFG9Bib9Z40L5I45f7oXr5/tmB37lP/YaBGMLk5It6mWUHNXIo6sqCRVWwgbiHUmB0GptjDQwJZVqT1UvihgeAUUjfYB6JN7IL38AZsy2O5I5S1Dn1vgF1j/vgdkWgML6ITcKdeQ8M9JQ7pD8Ckr3H5csCOttdYn8w8UrBqtAowoFM3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26UdGesoCp58z3sSEuteC0+nLku1JGd3KI5hEhbUEyY=;
 b=Acdb6uYfbEf9DFLDCC4eHtIFngaJOUcnTeAkIZJwDjIk5KTNH3wC11tVqxQymxdK7Ye1rR0IaWOHg6QvBQc0sAIQIl8F7FZTqkpOYMdgWfjOnstLDo9dgkZDQurotGA5JrrBGRz2P+2kBs+uOXySohWpJ0FFr7Y5He9ZTCr9xEP0HlP/O3SPuHpQj+yFzXkckXg0UBcPHQQhty0aikPQYcqZxY+uNL9tHOIoFxyt7+5GoKTM2ct2hhkKdCeZNfzHiSZ+zU+jnaY85iGha6a/bKa3tKrPUeOS4tgHFrWXlKvzcYXwxkE5z5TCI/907CwhCb8HuYHFxZ2JSfMT8UnEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26UdGesoCp58z3sSEuteC0+nLku1JGd3KI5hEhbUEyY=;
 b=A+01OlAEHDmG1I6rbdoyz2ZxJesBpxVb7EaeonW/aqNWVKjIP5W7gLGG8/zOkz8kxUcMtnk1sft8kByAyERZ8sPgYQON5WKnxkeHB0et/56cUZb9YHCU1Lh31eUkGEnk/CusBKgUAh5EYSEmYwdjKUqCps40dZ332mCodU0GToIU3aSsNqKZMIKSKSEHDfkyw2E6jGQnTjsa+7j9ERgro+bEaraDk9Y/xe1ieOodvqT+SJFlte7XyENaNbcp2pZqz0Ye8VlCI/XI2ZdxCP5Qj/LBCv1UJ+4EKMijhohRv7JGqCByl6GvMBa5iY46Ec8InHBMs0SsMCLiQkMWKvsccg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5986.namprd12.prod.outlook.com (2603:10b6:8:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Mon, 24 Oct
 2022 13:09:07 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 13:09:07 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v6 01/23] net: Introduce direct data placement tcp offload
In-Reply-To: <Y1Z1XzLusUVjfnLp@unreal>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
 <20221020101838.2712846-2-aaptel@nvidia.com> <Y1Z1XzLusUVjfnLp@unreal>
Date:   Mon, 24 Oct 2022 16:09:01 +0300
Message-ID: <253y1t5weqa.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0500.eurprd06.prod.outlook.com
 (2603:10a6:20b:49b::25) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: f895abfe-3e02-4dbc-32da-08dab5c0eeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYnPDpVe+o7pDqfthW1WqW9mB9gTdNydNoVqCjpzambgKaGyheE50sAJJI013WnXE5J7gWW1Rx9LDZ5qp3Rp8vjd0dafZ4gaIG2vgWAxx9P5N4sCOc+gfpLtkh1o0iI45wd23OmLBs5Qagu4giI3E8+yQVOHw+I59qjmEK0e/0kwgfsBPA5rdbIbDIhyGbgyxbeZAPOvWTihIatZlzOvFWvdIbPZZucrhbfs5a01kdQJq0gQs4Jf7uX0anBgXICpYDVNuwcMUtn5Zyv5EL6a7w78FIbDoPFgwbWE+ohL21Ynx+7NW+XhaVBKaGIPZSBlb856Rr1Qd7NL1kGcpRvqQSVzs+snxn+JuH33ljlT3C57atche4hw4Cm0VmOWCxNLNSn3KOQeWOCbWc6o94Hcohmu4HlRtmB47FEPacUfEKdzijbRF8C5sxaTEx+bqDaYj51UbmCLWibnf9yoFZXKVeeEDx8RJs/EpOkZah8m2xD6Bbj9b6c48qB6SxZUm4zu19av/tRccM/OvIzQAhZtwLlKyMdIesdnbAKtAtMidNQaGY10sFf0Ol6S/vyDcxrMmESNsGV/5pHxh+KTsOruNdiwyNR57GaNcBe7s/P0pOZFpF3+odD2gcljSi2xEPbbCoXz4KqmJorgPk7+PHrCclLcj+sA2XEXxTYymlkHm3a0scAFaQ5ilaZnqcbd0JJEwPJ8SoO5+U68U1G99SehXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199015)(316002)(66556008)(6916009)(6666004)(66946007)(8676002)(66476007)(4326008)(478600001)(6486002)(5660300002)(6512007)(41300700001)(7416002)(186003)(8936002)(83380400001)(6506007)(86362001)(26005)(9686003)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/PG6blt6IyYj8E9hsmqa6nQAAiNTNVw/D+UHuVDf8Xgx/Jn6/TPAEJpVr2Mh?=
 =?us-ascii?Q?4jfDZ4ZBGR4j9PKVuZjUH0LLCqHvE1BozZ5C7Hzd8AzSFvcjSLnk6WygVjBK?=
 =?us-ascii?Q?cocQw5Rva+aP22kLch7ugQOKdmBoM6lqSH7FVFwtG/E2bYKTmAn1x/yQXpZg?=
 =?us-ascii?Q?4s/TDdkF2cqvNG6OgZVKHek1lbe4ryQU46kgFrqsQTrNnvlANEiotoeSj8JV?=
 =?us-ascii?Q?NKz+CPfScoY2XBYc9GZ/nY8w/eYmbUOrzfJqzt7kG33x+6362bISiJRHtOgK?=
 =?us-ascii?Q?ubZj6duhHvU9xkKbSgJwv1qIB/QfNMT9xH0tXeMndSK08NdUw81UeNa9CSJf?=
 =?us-ascii?Q?nT6T7J/F4X6Pqs3lmd9VA9+YPeLOcnDr8RWNybf844baO7q1vP7TGHBHiWGE?=
 =?us-ascii?Q?EmAt8B1SziX1DCiNQGM+YUoafjsNzGrxAYYRprF9AEoKhHqWI00wys7ql/jO?=
 =?us-ascii?Q?DradED7FuJZK5n3vnkCe58GZsAlay9Ym2a1tzSf1pMVbyFyijnJXGc42NMQL?=
 =?us-ascii?Q?CRc7vNQkVQPxOooQf3MbBNCx5VqxxAd5tjbqIZNEgKiLhUcxT/Y5MIWQ056l?=
 =?us-ascii?Q?fGAPk824U5sTgMLnsD9L5ob/Sv0WlfDyM/eamqza+RncXUjQe2X32nGWwfec?=
 =?us-ascii?Q?xNw8Z96PfQmygZcb4uV6GTL3K7gG0oDm2afIkAeYNSgI5gYpWJGCUELrRmFw?=
 =?us-ascii?Q?fJnBXALwhDpbGRDLqqgR/usN34vnA5I45SL79NxCQ2+Y/eESXU60PIvJ8eJA?=
 =?us-ascii?Q?7tTagUzVbEvl7mnajVvzXP7Ok7mJS2H/UHj8XnohamEgnSvDuR3q/82jw/lF?=
 =?us-ascii?Q?AwPC2ufdNt/RcOJ9Rvd/d26vZxb53MCvH1kaVjMYcxT0yWbjtuK4kNWG5ung?=
 =?us-ascii?Q?+A30DWJfxeAU1fdAn78uP9UypTIfMsyViZw7QQOzpuEB0amWHMb6sGVd/+6K?=
 =?us-ascii?Q?pJSwHhoq1OyX3ePH1YZfnknblQpcg2SLNXPTzUT1k/U5JHknKG+Eu/WVCmOZ?=
 =?us-ascii?Q?p+4j2cXrEjNr4fYnhuop+H5ESlnTdDqLjoppL+4B0+RiNpD5bU5aWApojGUt?=
 =?us-ascii?Q?/rf2Ih7wIjL48EE97gYvSR3tTaCIftH46d54E8cC+iGBaR2ljCSwvuBlY01V?=
 =?us-ascii?Q?8rBhZQzvqpr0ktQ4aL4PuTO8Gw9WZvHzFSw3TYdCrtzm4LCDDWsEYNjxnCXE?=
 =?us-ascii?Q?DC5ZeJyWXGjHzjWUUpcbtQ93CvIfyTXySohEaTinoghmCIP34qpsaaEUtON3?=
 =?us-ascii?Q?h0LKz37kQXVcLO44oE7EI1RgK/EO8xvRU7+zKb33d1ar8U6VnjJpGGkFbSY5?=
 =?us-ascii?Q?ggq0fjD+sEg1jvWMxgnloFBujQcww5L7vdnmwBOlh4vH0R/4LpjB8eDFAInp?=
 =?us-ascii?Q?NFWL3aDgvjD/TyTj6gVIaU3fia+mc4eqZXvE49hiCneKdAziSks9Pcgyo3P3?=
 =?us-ascii?Q?V8MbJnJow/ZNPSsCaWDxLPNR6LvoRjHmYQtL1GyiaY4qgZlEqAeuUpNeVrks?=
 =?us-ascii?Q?+SCbnvRy20f5MnhscPIA0uBxwZvP5BXOfq54VQ6HZYWlKdA3hM6ZUTVjTrFd?=
 =?us-ascii?Q?VP/mr0R40P5GP5ia4BWWV6xCSoFFK3L4dPGwXhM2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f895abfe-3e02-4dbc-32da-08dab5c0eeba
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 13:09:07.0812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3rows/ZVSZp8EsR91udaCmYeb3H9ICzOJ6rZSfIgX+7u5Pzhju9owPmGDBoB9cYttMrymueytmo7U/g8jDHbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5986
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> writes:
>>       __u8                    csum_not_inet:1;
>> +#ifdef CONFIG_ULP_DDP
>> +     __u8                    ulp_ddp:1;
>> +     __u8                    ulp_crc:1;
>> +#define IS_ULP_DDP(skb) ((skb)->ulp_ddp)
>> +#define IS_ULP_CRC(skb) ((skb)->ulp_crc)
>> +#else
>> +#define IS_ULP_DDP(skb) (0)
>> +#define IS_ULP_CRC(skb) (0)
>
> All users of this define are protected by ifdef CONFIG_ULP_DDP.
> It is easier to wrap user of IS_ULP_DDP() too and remove #else
> lag from here.

We have changed the macros to inline functions (as suggested by Jakub).

There are other users in later patches which are not wrapped.  In fact
we could remove all the #ifdef wraps in this commit but I followed the
conventions of the file.

>> + * ulp_ddp.h
>> + *   Author: Boris Pismenny <borisp@nvidia.com>
>> + *   Copyright (C) 2022 NVIDIA CORPORATION & AFFILIATES.
>
> The official format is:
> Copyright (C) 2022, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
>                  ^^^^                            ^^^^^^^^^^^^^^^^^^

Sure, will update.

>> +config ULP_DDP
>> +     bool "ULP direct data placement offload"
>> +     default n
>
> No need to set "n" explicitly, it is already default.

Sure, will update.

Thanks
