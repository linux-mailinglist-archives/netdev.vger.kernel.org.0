Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF72E524822
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351627AbiELInG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351728AbiELImo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:42:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5234504A;
        Thu, 12 May 2022 01:42:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJH6Q/9KUlo5RoSK75zGnL9j//xVm6Z+OlxhqzSACIO9FPckVzZzYPtdK8YMUswyXe1b+q+VE5dFlN5j0/pqDIFhwyAcF/5PHxWU+56M16uTUpW7toM56TvRDgqSfa4Z32lhRV2jgKE8G2Vt3a1lvx5ZZIY4N+ESTLoWe9xFIwKKxCyiydcjBfU0sMC0TtV/bpAr7geQpYn73aAWhKg9lcyscFsTLP92+xt6F2RY1/vKmsBKpKadkNXxkzHDzfr6HvTNOdSy/6D+ABBeyEQQC1IN8mgMWi09pnDUiViMc+/DwFRk1xCD5qG7lHuY2QXE/Pbeg3vcjo059XiCyu1viw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYz0eM6fXd67zyrv4B2b+ZkmS2jAJPiEvLLUTnhSh3w=;
 b=i+5U1uTmUTCSnJqoD1nuwtORmsqbBkENM7xHYEipPgRw49PJE+2edVPJzhu6ZrTl/ftcdlCTet+triQf9p36mMO9KHdGTPR8cELpUXUS0t4cucIMr2BKz8zCun2vhgDh3/G+LIR1tAxp0ePr0O3T6lfUZlm8LSEFnAELVWTuKPQhhxDV0cDJiPz9PIZUxDR5834bhwvkjxnB97E/af8BuIAtyG7FzO66ziKRWINuNY44EYcdW6Lp5res1O3oOKMzOWqpQfU3otxjx6C9mm977lPRFEBUjC67YaRoWmrNghagZFZk4q37Pz0/2RX3BSc7Lilm71lYF2uiMgU9sdPBIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYz0eM6fXd67zyrv4B2b+ZkmS2jAJPiEvLLUTnhSh3w=;
 b=lwm5JqgjkEqXy9vId0HdDHHK820D17xXG6IcHCGFfLsy/SWGTufiaAfk0Uco/HpWT2NSjHZr4BcaikxuKmtwFM0ktnCHckTxAj0+hmSEsZBQmUEgia7svlJT3V1RF2ZPT6xGXjGJklWkNw3xQf3EqDljJ+q3FTJt9WZGdxc5Im0yxLYndtPXsU6/3QeVNtDHWKqLVdD6Yw39wKZEZVSSsOcsR31LsE8+2W57UHXU8Jyfvzhrb+1jr0SQew5VXUwZce6LFWW6lnZXsAe5ClLYemrS02u+yQPNxUhC6eJYcYx0n74ZJTKhFYWf7db7RC4Bfhq4Fgz4FWY5h76CO1zegA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 12 May
 2022 08:42:28 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 08:42:28 +0000
Date:   Thu, 12 May 2022 01:42:26 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] fortify: Provide a memcpy trap door for sharp corners
Message-ID: <20220512084226.id7jghqbadluze5k@LT-SAEEDM-5760.attlocal.net>
References: <20220511025301.3636666-1-keescook@chromium.org>
 <20220511092417.3c1c60d9@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220511092417.3c1c60d9@kernel.org>
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7102d372-55c8-45d6-ab88-08da33f35866
X-MS-TrafficTypeDiagnostic: MN0PR12MB5811:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5811A97F6FD53A34F0EDFF90B3CB9@MN0PR12MB5811.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oj7bOxfjEnagrL1Vk9FMxJdPBM3iNHqBgEp3jBQZvm9SAaT+8x92MX04SOQ5ECFKuiwHmuyFEEnL90fBBuYEOt0Ke3PSIvepU4nSlRR0PYV2I37CqAaOep4l5El+wHnVIQ1yNr3lHPs0Y49hMakixvLvTECPI5XLDht5qEGoZ1sd6C1LRoCUeKPJZXt/8JmNruhQuGLxCToTe6YXQjEaNI+e+HKYga9Dmm2apGz/JnETcMhTr4PR0SmdHuYkyNStluL6/8cUpZkMKgVadYQWlFtbSGn9SV8C1EcEOXSKpBYHQ2zMxEkMpsogtcXQqVLXL9GWLK10UweDWPBm9pdcYTv6hYHq0lHVYnweSpFWBETvGUuSkWO/Mk9X/qThRuewlpjQnR7un1kDbQDHUOoxW+m2EMXDr8d8RP+o+d3Pep55XW1hQhRjkP4ltcQGBuGdNhs3mMRkk6NYOLB4jbTFcd73QKPPt1nQ6aGotBYbQpYosYSY6e+ea1bIZudOcDR7wtDDm9erY8aj2HNuWvmSbvZTUG/AyXCJMnivdV0oWjG4KfubRt/BDRVvurzZugPo3RaTX6HVKI+PTGWT4jzqLfZemGzHcllXwssQulav3mz0j47dpWTGI7RbmHpzGXr8u/QQsklx3M+J1fUfYuo30lWvB8vAXRbTCuHvVMybZ5lRiKuDQxv7AudZG+bJdHt8o9qM2oqx70yoZGu24E6Q0WG1MOclqOSwAWb9mMArV1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(7416002)(38100700002)(508600001)(5660300002)(6486002)(966005)(9686003)(66946007)(316002)(6506007)(4326008)(66476007)(66556008)(54906003)(6916009)(8676002)(83380400001)(186003)(6512007)(1076003)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MeglJ2F6pEYczcRzLaZbLhAcs+VKQmsRJKnprvCuT9TH/XBBj7uQMAZRJV9j?=
 =?us-ascii?Q?sJFCGRpCwdPLdtxhXh6C9mbBU51s1dI+6QtArPNrQyOgHKqyCgmGr4tyilmn?=
 =?us-ascii?Q?pJJ5R+WTBeR5fl0UufvD9sP9hn57YlxMl4XU4kb7CLUTa1ulPgRbXX4ea2wu?=
 =?us-ascii?Q?y+4Rul40MfcgVTAzJAi5sBn8moBA5nS0sRh2t2tM4skyyWO633mtaN+xFubk?=
 =?us-ascii?Q?ixk2dARC8J7w/v75w89IbViZFfOk1FQEr2u7ywifuRbAKgw4JmVIDgdHmUDy?=
 =?us-ascii?Q?eHUV2xvsSlYTwV+T0CFLcRjiR8Kh6EqPqXiFBJzFEs3UTr5O/vF/casoT4Vt?=
 =?us-ascii?Q?x3kAFX+OT5TwaYGvD7QKZl2EsOZ91PT0jT2HXqvI25khIUh96dDO1/6PY80G?=
 =?us-ascii?Q?nR6gZy3sGno5o9syX5BwchaEnhdhV+dI4ROkXN4Iofh7pdtdDl1ew1+acCKt?=
 =?us-ascii?Q?JpLkMkYVPUB+NZbBblI+ok/seAgbAxN3OFg/4wd3vLxMPBgOWzl7nUNCEJp4?=
 =?us-ascii?Q?ogZ5gxFJ0IJKa3WCnebDPnOluU4Bz8i+7mDA2o5+uv7UF+ITIRWBtecMf9Zo?=
 =?us-ascii?Q?vDLlhiKXuVr/mZSaDl0VWh++AIwZry514OIkENbR9RfWsdLj5ge+lY4IQiIF?=
 =?us-ascii?Q?IaBKqaG2fDxxYY3rR6wEDW0+lrxOHzl5GPktLBPbMnJQ4oYZ3rpcX+QBlfhx?=
 =?us-ascii?Q?sCkMoY9Rc2Olm1l4uyId1bs+kuIAjuw1gJLvyjpUfwhE0IdOUVZEXvIMoIS1?=
 =?us-ascii?Q?briJM/9ovEuF5ObjCSxDOjSHw/2nbENPmR+lxvc418rNDgv4HQzYIyakmmNp?=
 =?us-ascii?Q?FMys0smo+9zpd3B5mlekeI1Uu6cJYtZzHUROjT19HNAt6iR+cr5wihHWQwoL?=
 =?us-ascii?Q?bvcUtIs456FUxw8wYuGear8tdiw87qTB8b88+DxnWVC4KWzXTvYr2R3atAuY?=
 =?us-ascii?Q?3NRwhUrYQpxIHuUVD1lFI+oc1TCX2zExHnTI0Yo3iiovMhcrRMyxt5ZjSOE+?=
 =?us-ascii?Q?6J4ztJ06NbLOtUhzNOen59bLJZkz0Dxrku8bWsMQWkN4x+2CChc9pl/Yg/cX?=
 =?us-ascii?Q?oSoQsHf4XgWl6fId9CxipW4jfyugljDUJgw98NPIRHS1QP7TN0i1lMWKgsri?=
 =?us-ascii?Q?uZv+1fxG8UtLije8ksa9jFC5mOINCmD1fsoHku3u6Ppmx3K6t/2ClpVXltBN?=
 =?us-ascii?Q?Bk15IqB5tVlHvbuktoRBJ4NruwbivhevM6b1gulQBMm5LPZZHnj7cWr3tIvZ?=
 =?us-ascii?Q?zUbD6s2DBXTG0g4aAM5r/AF4m0WgDcZPsSzjQY/Qm2Ib8pMRp3WsgrGNg7FW?=
 =?us-ascii?Q?mTwia+toECPNKcPfMRYISStJHpLG2splad9/PcR0sahV+1ncQRC/61w0Ill+?=
 =?us-ascii?Q?Gh7ro8FrM2L5yGM8cTNNYBmQeJJQsLdT/YQXOFiGSlx0O3MEoA+IHNvIva5d?=
 =?us-ascii?Q?bFw+kD4jNfRdYdwvrudV1J/pFNX0j7NkCOmxrphKUim6QeRL6aut/qTSTsgV?=
 =?us-ascii?Q?7o53chlBxF5fnoJEe+Qi4nfCKnYMGV3ldkSMLdPCysyfdiT9t09FtZ0d+JFu?=
 =?us-ascii?Q?y+aur2rwvHociiuzR72YLZ9l2Bb77ldjG3O+iNxoV/NrfuQhDrio1zrzOkdv?=
 =?us-ascii?Q?mLlkqTER4E0jftAxVVmSjPF2vJ4j+4ZX9aLrrzFWVkhCmHwtyyMeJy+wiG8M?=
 =?us-ascii?Q?RMqGhXJUwlsVfAbZqXwAOADkp6PRcLDA1xnBjKXazLZmT0TrLctofkKOt2Kl?=
 =?us-ascii?Q?yZlZ77zhw8gYqC08SsOGCy7eY+InuGY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7102d372-55c8-45d6-ab88-08da33f35866
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 08:42:28.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fhcm9rDDR4smXg2hEKew1g8Kf/I71sH2OPVz0rMkcikuC1LJn3qREge80SDDg2sbMwK7YC+dUNVbqvcLL3PLbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 May 09:24, Jakub Kicinski wrote:
>On Tue, 10 May 2022 19:53:01 -0700 Kees Cook wrote:
>> As we continue to narrow the scope of what the FORTIFY memcpy() will
>> accept and build alternative APIs that give the compiler appropriate
>> visibility into more complex memcpy scenarios, there is a need for
>> "unfortified" memcpy use in rare cases where combinations of compiler
>> behaviors, source code layout, etc, result in cases where the stricter
>> memcpy checks need to be bypassed until appropriate solutions can be
>> developed (i.e. fix compiler bugs, code refactoring, new API, etc). The
>> intention is for this to be used only if there's no other reasonable
>> solution, for its use to include a justification that can be used
>> to assess future solutions, and for it to be temporary.
>>
>> Example usage included, based on analysis and discussion from:
>> https://lore.kernel.org/netdev/CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com
>
>Saeed, ack for taking this in directly? Or do you prefer to take this
>plus Eric's last BIG TCP patch via your tree?

Please take both, I asked Eric a question on the BIG TCP patch, but I
won't block the series.

Thanks!

