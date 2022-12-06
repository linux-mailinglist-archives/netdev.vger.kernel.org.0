Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6860F6440E3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiLFKAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiLFJ7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:59:39 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BE727DD2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:53:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJehf0YOWeSH1yWelBBF6XCr/3GJeK4zNGdBn3XFg+b82dw2SGLKEeHk1BgAAuJfmWzpHi4gTElyrbEAQlnHIW2xgB6GoioNHWsp5BEyBqtqCtGD8tAgWSJOz2dBH7fiZFA1yFiGW6wceA3zqS4qqGr95ZYWP7/K5CrihA6kXEi3TWg705qW+piqUoEU9/0v+C2BmFhJy842xpvoGn++kHvW3f8OScNYKJnliJLIXgY2JccCYxA6UvBs9H3dVhbHQSlUDqKaoJeg2A2jiHCWsLJQkwax210gGIMjUMas0p/WvAG9H5vqkArrUiffB2V//OHJe6kbHZCTFPGb59GpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2B6AHJXFALDd5ILm1KFjZGfIO27q+8yVBqX4xszsbU=;
 b=F4JnggASE0ndBSDvgtIVNw5QSEfXsJvVbShowmDRulKbXsM9gN4FsTGxhJclqJU9NFX9ORi5MHMVxKzEb+iMNOeQ/1SkRAZ7CIO2OOG4XCs/rQA0iIrduD3ippYoutJOI/oJqc0uF8zsU3NO7VdSfStVTZb81YI+1cL+UR/pjoDGZqN5kksSeRcVEm8Lgz+vIepvhM39r/si1OaY89pYF3GA7oA6pHO8STO73ko9VrmITd/nLZ3+8oBpIgx7tTC1U9ddTRipaaOsw0X20Y7ImgRruaU64r20Lson5fK7VN0x+6P7WemHwHWG2+mFJS3bMQUULw52GmGsGv9bmZqfnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2B6AHJXFALDd5ILm1KFjZGfIO27q+8yVBqX4xszsbU=;
 b=NgOW3f/lmlZ2GN5qLKND9rLiPEdRg/rTae16VdiWAWiFGJTS1Wt9qItdlqeq0UK69dyl8lwn37x3kwHLx/pQ30C324EpHvKcQTRKe7Q1Ag+AO+qZ+MYLxm9COOXMwEfW7pQnAeqacJpPu4HYux5cefDOm7BshfJHuoKKm2kDPo0FKEwTGahHU41NQ/8KYi5QsumDp6QaIpAd/CtH9aBDNQtug4eJH6Rr+JeXxGLRAvgM912zEu0c8r4zNrxDA39BMf/ZjTenM2du48zNJixPeKQf4H++TkGVUjRSFJFcd/i6RmUwORvZrAHzWv4Jra6P5SzE71fhUilnDliMu2Yn2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7234.namprd12.prod.outlook.com (2603:10b6:510:205::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 09:53:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 09:53:08 +0000
Date:   Tue, 6 Dec 2022 11:53:03 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 1/8] bridge: mcast: Centralize netlink attribute
 parsing
Message-ID: <Y48Q/xoACOyFaozp@shredder>
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-2-idosch@nvidia.com>
 <06490c08-bf5e-1714-f56c-1a6068fb2ec9@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06490c08-bf5e-1714-f56c-1a6068fb2ec9@blackwall.org>
X-ClientProxiedBy: VI1PR07CA0185.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8db5a5-179b-4956-077f-08dad76fadfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJW7V0nK27tuU7xpRdzB3tyxcRQaKtJziq+fJH2D6G9grGSnjYJQcpNzPbkeQavqpuMrydN1sWRhMqICeAlSQSk/rsKPCl2jn8Rp5EpOxHO8y0xNJtqmHBZFih+437EsJHwsSB5qQ1RE1u9vuxll0KVHBgLLqOC8AiIuSCzizgGV+X3mUwgIAeTX3Ye59g5Bu3d3BvzeX+EYW16ohRIXtgcjyMMjJInBY0sgAh9W/AM1Xg0IhNJ4h0XJdwqHMCzguu56HfgFNYp6yRWAdRkj4YgL0wUUo6OEDa/P/Yr5j0dyA0OD8NVaKWFFZXTaiFejB6xb7eT3C8FrcatN20WgAvGmIO34xMIGqA8qITXout+gUi/Agu8etW1J6k5zFJ9j5vYXGnrIBty6wycNkSR8g8mddbpqgUUqv7e/CPfwPFG3QcV8zngpHhItqNUj9huz5IgdrfPRuIXlCj9y8I4o6XJa72wZTTCvdM0olSgt1wdxXn6wPP11yYA87nUOkY2QWX9c0ZbWTHBnPW3R2CgG0CCk7GrH/3qyYestIkD8vkRh/vtcfFwKY1dWWImwjnGoWnhIMHiCWp6fh0caSqBkMm5pMc20wFW4r3AGVKPstGYrvjctHbTl9S1yJeDhpkskTJtUSGKUktUUycMt9xHCIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(83380400001)(86362001)(8936002)(5660300002)(6486002)(4744005)(4326008)(2906002)(41300700001)(33716001)(8676002)(26005)(186003)(6506007)(478600001)(9686003)(6666004)(6512007)(107886003)(6916009)(66946007)(66556008)(316002)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1xTlHB86cwIuZZA7GUKuRfSvOC/C25yUb+vul6em4BmMBvOhz5LFm9xEhFLc?=
 =?us-ascii?Q?lhRIr0IX+za35+Xh+jtcWtzt8xy0puAPNRyLz9YN53PtghxgjaZrfKcKmNGv?=
 =?us-ascii?Q?C/SRmXVGLes81DxrgwTcGNnWM9x3V9MMVyPeC7vnkD3SJgZ/++4nx9dQFvfi?=
 =?us-ascii?Q?okv5LfH9y7Bs9A5QRD3/DuV9quZ+lCduyk0d5dGQimYjjDT9CnPLcBK9+8zs?=
 =?us-ascii?Q?XZoNo8kuwIDVg8l4Ua4QMoqu58bABjkVh+06BWfmTcLTWNwqVoH7ATZnjcTy?=
 =?us-ascii?Q?KwttP9E6kcTbbiv+6btL3uD1yV08J8Pmqcl9YpWU6DFFHuQt3VHxVGvEu6Pr?=
 =?us-ascii?Q?Ims1xuOJdd69KCuuG8Uf2WpML3YaX96lmXYrGQjrXEU6KQ1FXKhsI18RSvCH?=
 =?us-ascii?Q?awkl69q1XSxRKzNvj3iSHJHiGgOgqlsJ+nhqd0ktDUK9zyChTXJrNzDpahaX?=
 =?us-ascii?Q?qGR8KrfNXkbJXu01DDMwtrFasO9pM6VmcDs5J8f5j3FHmNIQAIkRarSdQBde?=
 =?us-ascii?Q?g5VZ0QsNMbwm0Q+WsiBNhmltjfadNIxPBHPB3+p1WI6gskamJtAN0zCxpmvK?=
 =?us-ascii?Q?DvDyGPqF0FJxKl0m2EZX9azxyGEX+1/QLnJgfFryXjbvYeIdl6peL8aGqPzI?=
 =?us-ascii?Q?TVSnnoX1ARqEEoUVJ/9F+MwrFG7NX3TQcd8S3pRlbp6tR/BFja7MemkCCV6N?=
 =?us-ascii?Q?bdOmN2BQ+7OytvwxroPabdnDRFFZmnxGvw0gZo8V4T+U3Z9m4WXx9pG170n+?=
 =?us-ascii?Q?/Xp/7tz3HXXm9872ZutFcBgs6nQHkCbFUGNCsnljtc8GZTvsoQbXDxnvngPH?=
 =?us-ascii?Q?eCCWft/ddPl+uUS5Ko7KhHPknDEbgPAE+c4xs7bZ58YC2pxWNlB3JWScJPKy?=
 =?us-ascii?Q?ZN59i5PSPp2tX0psABlNZhIm6qFv6r1UUT3NDIQOqshzj6q/EUgcO2hdcAO8?=
 =?us-ascii?Q?Wbi4tXoIwyN0Ga3q0F+B+e/GB9t5TfI5fQEv9kNpsKnh2WCvnS/sc4tWO4Xd?=
 =?us-ascii?Q?4sUZbyoHQ9IAn5n+7T8lXKJzOK8qLkhtnFLziVcHN58dEMFWDsSAmQEcWAFQ?=
 =?us-ascii?Q?+Q+W42FmVb6SOCkgOOwLsYnFLTYf/KZ7aOK0ydQt1ojQcX85yZMH6j4J5i8r?=
 =?us-ascii?Q?HLmuoI9qs1t6lS5YSh/7kSkhRJzPoad4NOhBWN5Pk+iZovWFa2o7uO01s5/p?=
 =?us-ascii?Q?65ttrWUwX8EAPKc6cF/rWOwePGvKZzmerioQTVsllObqo+RkJ1pPn+iqM5kM?=
 =?us-ascii?Q?Qb4y2EMr0Hj4faJyAtR/c43gNpC69eMFA9Y7GQMmiRkD4LqWTEeJdUIhdp1V?=
 =?us-ascii?Q?TmcUskqwkApM0p1ffRJCX98IQy+HQrPgrTm+tPoFHVFuvOROBUka3N0TIv8m?=
 =?us-ascii?Q?WH9rnSK3O5HWj3AUFGifSS6MnG9ogUotx7v9wcZgaxxKw5TqXaG2mcxprKlk?=
 =?us-ascii?Q?Ph+RHxQUyy0U+O8PXX2vbliBn9dFMJHugCEzv8lA5acuxv9oIkq89Oze9R3k?=
 =?us-ascii?Q?wGMr2Pib3Wpe4s+5QOVM7MCEZ6Ck7hq2gY8xUYILhbtQOUmqgwMTYDGxi++R?=
 =?us-ascii?Q?ONWSPd7g48218Wu5rv85q2+sM1jY472y+UYMsHWC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8db5a5-179b-4956-077f-08dad76fadfd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 09:53:08.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rh/nw9b2ON+3k8jCVO0REZmzqBU6Bcls/vhxt39pPsVfhJ8qWgfnzvdTebZvkNR5CPS+DvV2FWgK5FTtFJuSOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 01:34:08PM +0200, Nikolay Aleksandrov wrote:
> I just noticed the skb argument is unused. Does it get used in a future change?

Nope :)

> Also a minor nit - I think nlh can be a const, nlmsg_parse_deprecated already uses a const nlh.

Removed the 'skb' argument and marked 'nlh' as 'const'.

Thanks!
