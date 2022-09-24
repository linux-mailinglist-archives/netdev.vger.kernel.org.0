Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE025E8F95
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiIXULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 16:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIXULg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 16:11:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00DD43620
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 13:11:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2xMVtyOcpXFNBXb1P3K4BKuD6uvLc3gUFnbRNYRhY9cCC4yVM5/fWpenRIa2prl91OmUbnvjROumBvLi/fW69S3nTEAb5m9Mzn86Ao2+KbDe/Wjnkl+vhNbZtwfUdKsBmrCnPUNzwhbIJ7MELIA1MZlgdOhnRKy4eKC1MlMjtpIcbHz6c4mEfihmzyrSY4cz70aYnnRpuD8Z3TVfjr4vti3h95hLuN+4/9Pio4Se1nB8WDu1ibzbFqx+RTrUBecAL4MTXC7sJzUoocWP5hjRgKjPw+r/CVj0dYg5fdt/xdfIb9shb/n4e5CSShxL9vaNrbVXlEZ5b+gVrs+to8cgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLGAIv8UmiG9Peu1ku+RQmPOT+SVVuhHBXLww7TRd4M=;
 b=IePfVL4KvnLExRvukcCJikeV2n/IgAEfWKjiyDHmavPudGdg8bnmyJiN06VMxaPh8RBksOkxssQX89iJyM8sLGJMD+vSv2Pft0bw1QTlLXjL1ymqIGVpkoMdKBhAReKglyLGQ7y8FuG03JcoKsavh28Y6jzHUqZKiWDabI3z8QkX+a3N6f4lfOMJ/g3pc62SSDIQhrkh9Vj3u6y7YYMl1TzMEuJY23Xsuwz8atsR/orUA2IRpGhQvQ5LMdoUXPV2jcKeHtOJYIEZ+WwgFUVlM2UyTHLZsS8QQrHiDYNe+yqQcRk2h3r8pkHu9U47+Li+4Knbh93lHA5wpOK8+7zOTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLGAIv8UmiG9Peu1ku+RQmPOT+SVVuhHBXLww7TRd4M=;
 b=oLwWC8APY4TZNtsHNwLWytQF/RufqK1x3pdu4pTufidTpx3NS+QHG+ulj4kzjebBNCkQ5CE1gwo3k4kQEk7/VNm4Jza+tT7mHZK7CS2Wm6l4epaUvbvrXT9MJubGjkE73O7h1xAnNLVoqCpZ5cZywftNyyvVIbpllnbXij+0Y6rTKKFP+kQMnO0+jZnilMXAauVjyO5LS0fJ5LcerCUhmZTSA6m/mFGKzOIVtkzL3oqsVVK/IjtgA57uMSw/Fni/tQY6IFPOEvPE8bJ8G1PLeJ+nvwGZub6k9lQ2Y53Punjfs9+s9sipBp8HwdawXhHBktZscLcTS5jzQ3Hq1vr79Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4920.namprd12.prod.outlook.com (2603:10b6:a03:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sat, 24 Sep
 2022 20:11:33 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::2473:488f:bd65:e383%5]) with mapi id 15.20.5654.023; Sat, 24 Sep 2022
 20:11:33 +0000
Date:   Sat, 24 Sep 2022 13:11:31 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5: Make ASO poll CQ usable in atomic
 context
Message-ID: <20220924201131.6r2wslhqovcdhq5z@fedora>
References: <d941bb44798b938705ca6944d8ee02c97af7ddd5.1664017836.git.leonro@nvidia.com>
 <20220924172425.bfagbky4h5tbcxf4@fedora>
 <Yy9RuS1AaEe45iLZ@unreal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yy9RuS1AaEe45iLZ@unreal>
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|BY5PR12MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 803b7513-ca5d-4669-c25e-08da9e68f98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNS5yWV7mHwD0ccmPPSsdFvAGvL8MiaphycKCrUe0O7IRpAYGc3SoHFrN+9O2F8BY3l65zLOVE/fPb3UEPxaLo3xf2WGPOTm8HDEAlEJrYq/aCpzQ/aPLRLiFUiuMRb5ddMIifYRGhLrugXPXnRww0MkH5usIRpr+TWn2nhKF5BHujICPL1i7rdrxv2lgY5SU9Q9PmAfTKJZT6jNZzagX4BSakSNDGYNerpC80+aRnRvrsm/vQSixGY+cTNYA/N+qyJQUEY5zD7VUPM3bipLVHPjzCu8L6pYxne1l8678UwVFyUb4enRozSdzlmVHgNhjjo8u/4YZp30823nCAAIhe0rsiyjkz/w6Bh9eQWIw+FQwW034CqNzYVG4DASy3aFSLLC7UtNO+1R7QyLnxvRLxUrnYjxN5zMIqj498HarrFl2qhz2ddJ5CXelP9zZbh+pX5nZY5UjZZlcDQ+ln9iG442RlFORM+qXi4/d64Zr95Nd6Ej6t4kXNbS42Ld+eTmiE6BbDIJ3j004DSxOcWjMxlUM1m/yHIx50Hjl2fmWLIzGuae+TtKo7FDLTZ0B4CyIY5vEfRz2lJEZ3QIYjeqtoD3lJHaeV/1Y8Xsg0MKk/jt+xW0uBX2vnQ2ukyOB4DgbJtJfytaurzJhPFlnGGD8OS+BFNgddwB+QJvTH1H7M2Hn2fGtvieyeLhIUMyZD2ORPmdlq9tM+Wt4sShcWOXfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199015)(38100700002)(41300700001)(9686003)(26005)(6512007)(6506007)(186003)(1076003)(83380400001)(4326008)(8676002)(54906003)(6486002)(478600001)(6916009)(316002)(66476007)(66946007)(66556008)(8936002)(86362001)(5660300002)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p6y/R9pOTwOVzu0mSEEhJknF2eDN9ozfZ0znP9EP2f7/f26kA8SoS9IDCr3i?=
 =?us-ascii?Q?bsg0UuGp2SmEdq9xLzDWmgex7CDbgSW+T744TwPRQvOTbtpqwV0nQW5FTYlz?=
 =?us-ascii?Q?qCyT9F855LNyO7eYhwWprPVujhbJGWi8qhfQwlZ6JMbNryL67hRJS6pqTS/M?=
 =?us-ascii?Q?aG9HRI4S60NhArBV1XRonF7dui5YcrfV6ch+XdKxw/eBShD4DUF4aSrUSiry?=
 =?us-ascii?Q?FhpK8pXOzwqPtLuIlRxHBANe1/x66Sn9RFVxRhcjE129OG58jzhCR2mM5L7T?=
 =?us-ascii?Q?+vbKuLMLkogfsiJmTsPzXQ0sMx1B2QG3dochQc3MZSLcT9J96F+llitL8SEf?=
 =?us-ascii?Q?5H8Hrhpy12/sg/yRAIEsEo7cww3At/CPIslgMBCGia/IyOpkZ/5Nbwv4/AB+?=
 =?us-ascii?Q?qE4sXB2V4nNCcZB+ODx++udvStGxGjB6pjR5hLN/bO69xL5Ux2zr52nXtCgI?=
 =?us-ascii?Q?uB5lwxjYVP/taLXdDpr5Dj1R+qlsKpeyJdVATBIsf4KA3rPlqMMBRhLkABRb?=
 =?us-ascii?Q?7W7HE4/HojzUl9TbYh8Xh2tYIFL9Zm8oZaMr7eJ3nHwkWVd4z8feVHDWfD1Y?=
 =?us-ascii?Q?2H4IaDOs+NqFivr4+/3pBi0/gW0ArQTtgC6nxzzMUrLi0czN9IzYc7Vw0Eh8?=
 =?us-ascii?Q?u8yIZZ/f0Gl4k5HGCsjI5GdpmmXKUnsdKecVfluy76H7AbySVkYIouT60ukC?=
 =?us-ascii?Q?no5tlbSFmGf1ZG3fYK0F5tMgI7kJ8S1b+5ttM2SRDdYULJTE+e8Mc7yxxJvG?=
 =?us-ascii?Q?NueK5cLGtWveICLqj3IiGCw08lgpaYh0pqFUEeCokFcO+hVOhEzx16DPgLMO?=
 =?us-ascii?Q?YeCSLzLxmj8yvs5Xyi44LiWf9rc3KuCPg2IwGBeeDnuKrxGV4tpO8q2WBWGL?=
 =?us-ascii?Q?VfvzIX7TtBU/Mmd+6yzz2MqOmtOaufF1ZTTWCQYE5LpMjqbJg8T2yaOs1H4O?=
 =?us-ascii?Q?YkiBCmpZW8MzCI23Obr68Sv8+fzG+f5gENq4sYwj7oYIu/6P7F4Mik/ZALbK?=
 =?us-ascii?Q?wOZxi3aVzKOscX0ZKo0LtDx2VXdbj+GOtKmcpkDCrIe5U3DmZp8ZUMLXxcwR?=
 =?us-ascii?Q?GGQcmA8euU399rSDh3ReIWP15rCI3aEEaTpsl/si8iCOVtyn4Tm9/kcRQQz0?=
 =?us-ascii?Q?FiBZWePjctsDOxFFR+m1ttTGepDs3nXJh9smCi7DIqR/oeY9YpcMQPselKgC?=
 =?us-ascii?Q?mmLlH9EFKv85Pswtjxpm/0TXQ76evXjwVWtcxExQKnTb7R1LIBnDTe0pQNKW?=
 =?us-ascii?Q?/IORnKFXkQM7NTmzQdiKn3njoAffwK5MlOBLDIXIwS1OfnpBCzEPj4LSA5P4?=
 =?us-ascii?Q?Bw1KW1TpCT/A894+1Gzz8OHEQrMFWQI/HvwvCQAqmi5gw51UpuexIA3sq52R?=
 =?us-ascii?Q?lxnzPMEPH2Yxen7MTxmCJ31ttTOihkiy6dgfbNGt1/dyVxdww+EOXa6BXSeG?=
 =?us-ascii?Q?MuDuZFhRy+Oj6aVXmUpd3v62fA7sbM3cm8WTNERPcrYWW0L91H0i/elatbjV?=
 =?us-ascii?Q?Crp3IVRBsQt3yIKvNmhUz/XebwZazzK/QvivV2UmyM0TAsWgEPKD6YKhJzEO?=
 =?us-ascii?Q?cz8mbr7oR64NDE9zSB8CbP7uDwR7fok8973s3v/S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803b7513-ca5d-4669-c25e-08da9e68f98c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 20:11:32.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/4CLH2pfd+THL70Y1oOQRSjCIC7okm36OvxZ1FfC9UMsK9olquTMF4bK0W7/hO7NqwmFl92omSj/2eH2YZxiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4920
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Sep 21:51, Leon Romanovsky wrote:
>On Sat, Sep 24, 2022 at 10:24:25AM -0700, Saeed Mahameed wrote:
>> On 24 Sep 14:17, Leon Romanovsky wrote:
>> > From: Leon Romanovsky <leonro@nvidia.com>
>> >
>> > Poll CQ functions shouldn't sleep as they are called in atomic context.
>> > The following splat appears once the mlx5_aso_poll_cq() is used in such
>> > flow.
>> >
>> > BUG: scheduling while atomic: swapper/17/0/0x00000100
>>
>> ...
>>
>> > 	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
>> > -	err = mlx5_aso_poll_cq(aso, true, 10);
>> > +	expires = jiffies + msecs_to_jiffies(10);
>> > +	do {
>> > +		err = mlx5_aso_poll_cq(aso, true);
>> > +	} while (err && time_is_after_jiffies(expires));
>> > 	mutex_unlock(&flow_meters->aso_lock);
>>         ^^^^
>> busy poll won't work, this mutex is held and can sleep anyway.
>> Let's discuss internally and solve this by design.
>
>This is TC code, it doesn't need atomic context and had mutex + sleep
>from the beginning.
>

then let's bring back the sleep for TC use-case, we don't need to burn the
CPU!
But still the change has bigger effect on other aso use cases, see below.

>My change cleans mlx5_aso_poll_cq() from busy loop for the IPsec path,
>so why do you plan to change in the design?
>

a typical use case for aso is

post_aso_wqe();
poll_aso_cqe();

The HW needs time to consume and excute the wqe then generate the CQE.
This is why the driver needs to wait a bit when polling for the cqe,
your change will break others. Let's discuss internally.

>Thanks
