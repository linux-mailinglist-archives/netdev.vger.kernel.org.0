Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD814F9DAA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiDHTcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiDHTco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:32:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A6C18B38;
        Fri,  8 Apr 2022 12:30:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0n944ltrVWtvtHx5kNUwWIHr6ojpcxgTh39k8mLqvN+inVHDo5/BtdHuCqlTU1dkM6ygnFDQ8kLenZ9AJfVVREEFcxt6D9m6y7TikgKU0y7jSdq/gZMnPBrxDXYs5bxyMkL0sbaWUDi8/SPKpjxo7wnLJNpx5TslgRQS+Ztv2tyhYO4KZMLn8mGK4WB+7apP9DGwAH/ALxxQ6snxD4KXwPW2RRVWTy8m8nEPKZRHDJXtisiInEmSoRrQWcvlYGB2yw+MD7MxCj614tVdHm+XwvKCPByvMJ8k5VvHFPbmnMCSpfcMxJ044cAVDjDusJCBn9EJ4dcc3fU8aEJQOlt1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQAmiGTYxVf50mFwXtw4Aw1DnBwKiMVFu3c0HauMokk=;
 b=E/OyrFow96+oyYxZ4DCVe5dz+hRhZz7T61qqZZFQj9VEXTgAfrRV3WTB36KDL/Bez9hW0OkNNgD4rmvB+oHKNm3n3DyCzc8UHSX9RIXW4rOxBR5b9cgjD5po5xng1iIP4WLPF46XBI0UnTfWrTiAB8dFWbDcBcQnMb7nfZybTBeCjFyHY/S47ocygNj4JmVQRRnPvWh63oxCxVsu9kZVu0X3hSsNQ/QLW54mRa1oBZLOUduuXnBWKolp7a8586nIBlJbucGQnAxkz/LPk3zNSdigan5hj3EGnGD6FJJ2dyqr9iiyWT+eiHXkIkAIT2hy7CkhlDwVq7JjPYwqCjYppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQAmiGTYxVf50mFwXtw4Aw1DnBwKiMVFu3c0HauMokk=;
 b=WnIXsjWT30DT3jXBX92T9oNQuhpaOB1fzJn/leGM2Aa1zVadzzvdp/7kTQIBrQXV4sMpQ6rluGWJ2YvoqAZoAU7cMhgyVEt9TXtg90QJUaR+xnk33uUPVb8zbRBbNljS5kqtSrK+m5saeHshzolJXX8+DgHAcSEWhVsU1sxk2M3gJTz1CshjBu1LEmcmoahIJPrq9sE9b6/+gtAD3sReZ+q+XtSe2HKD0cPTJ/hXMVr9ZQOK9djkMLvPnC/B12Ia0LM2tEVgxQs6JyJt1sDQSUin8fhTr3+kEvjRRdSB8XxF2ktjWrN0ISCfPyHRNPdSx8EIdzlpeT39DLVBqgC67Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4109.namprd12.prod.outlook.com (2603:10b6:208:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 19:30:38 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::61df:b339:9c79:1943]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::61df:b339:9c79:1943%4]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 19:30:38 +0000
Date:   Fri, 8 Apr 2022 12:30:35 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Nullify eq->dbg and qp->dbg
 pointers post destruction
Message-ID: <20220408193035.2uplgfjnfjo4s4f2@sx1>
References: <cover.1649139915.git.leonro@nvidia.com>
 <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
 <20220405194845.c443x4gf522c2kgv@sx1>
 <Yk1Hc8l5bs25wEcE@unreal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yk1Hc8l5bs25wEcE@unreal>
X-ClientProxiedBy: SJ0PR05CA0109.namprd05.prod.outlook.com
 (2603:10b6:a03:334::24) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14ec3ad2-9cf5-41fd-17bc-08da199642ad
X-MS-TrafficTypeDiagnostic: MN2PR12MB4109:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4109B994FE9682589DD763F1B3E99@MN2PR12MB4109.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v71LTvBqoMAlOdgXUWubHTiEBOI7q8wpTc1lWFIrhgyVNrxQZYmAtw/xA9wuKwX+pSzJQupSjASDmSZMeaqbl8/o8zVdbbCQUIKXCWHkOxWRcsvDq3B7VArTecaY9I+4RJ8+D8Q4Ri1aPuaskcjXTiVr6DWVnARrmSIH3WY02h33g77cDhFLRbjB3FCFtNThpH09Z94OrFwh4vafYoLQy5MTdW4KFByx9VtlC78suT2Y2EOegofzvy883xmQsbID86JQOFbhAWOYIDbtwafAu9nBf3Nui9zUVPyfq7iWdqy9MEqjqFENUuVq5Bh90G3ZFeaVqHm5pUSNm46p3VPf4xCzP3IpBUt6bIl/0tYg1dNBbcMIPhU0Qf6LeqQ3m2TdEQRZdSoOFI8E82b+JEC+DHrvVKx8okYpifMcDwAow/hK29jXv9m+AAPDI243MGOua+06zQKrSQLBgxRVjW3AFhuzDCP4G2mmSXZwl2AB49DqWCLA1IBckrdu4SQ+lE1uYRrQ9NJ4gXW88Q2R4SpLuvCAmTHZl5Knz3zcBKj7L6Zzy63/F7I81JavU2mVzI0mPP39NnuXLGmDJ/r9UOUxi3c80Xpfa4+g00tW6AD6Stoa6nLMLEx7OhtC+3o8LDnvaANKNMSQ0OIgkJ4UoMV8oZaUgNx8Ts23PJKkKj3SJTzrfSJj/A01A0MTPeIYLYjYph7kcAszL6S9wS2Fk3vya49SOK5SGTjXocEVtA/mX2U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6666004)(45080400002)(316002)(86362001)(83380400001)(6506007)(6916009)(2906002)(54906003)(1076003)(107886003)(33716001)(186003)(9686003)(6512007)(508600001)(66946007)(6486002)(4326008)(8676002)(66476007)(66556008)(5660300002)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NIxgw1EtApTyXM7dL2LEIhNSAgheLysZwKLePxfVd4p3Ogs4HwtJSVA8hmLH?=
 =?us-ascii?Q?VaS1Q3tzoQ2s4TJZSgtGRHx7FSZGBVcyWl+nreiZsnn+xhDVjdPsgNoN7ELo?=
 =?us-ascii?Q?ZLPBCVLl0UVyP1HMxULw7Sofq0jK1qjPxPM2t+opQxiEZ7hcep9h+V2HFt2D?=
 =?us-ascii?Q?U7K6gWz/BQ27Q0yI6yuFtsBcPINLKxJ26CXFYrXr/fhK5NUo+G3JOZqtpWEC?=
 =?us-ascii?Q?aLttJiqSH1zkX+YlOSZmY+/DePpIueUCAWxkwOtsmopg2R5bb+yrktRycyUB?=
 =?us-ascii?Q?r7Hql6A1aXWsx+XToetjtrBPzC73r4qVj1uUhoUyhvTPWb1PUeFLSzr6dRU3?=
 =?us-ascii?Q?qqcJcQaQr0lh3Hg3Vg7S0JVoCA2EJ+vHwC7HCJP7ahxhwyNvhvgD8U00sPKg?=
 =?us-ascii?Q?Bkjpg5Faf61Qr4LtzQt6Y368PqHDrei9bdXnX9Fjjs69Cb5Bi+U/MCeMeVA/?=
 =?us-ascii?Q?SVeh3UF2pGoia1tKdEl1yWmn/TtvEoDmCv13dDoIqI/abfLAizbjtZJRiSNp?=
 =?us-ascii?Q?/DSW+CaYLW8EykhOU58Gpa+E6w9XlYL/CEfsN21whjjMybf93aU9Am6XrxhO?=
 =?us-ascii?Q?PfUlOauva0rWyx81JZHREEovahXeAmWUouwrToxBi2mk5oLDa9fksqleARUy?=
 =?us-ascii?Q?otwuSNW9o53Xshs3bk7FDVxzhdgWLqy8qyLP74fNHB2YV1qY5VsTHawUb9Qe?=
 =?us-ascii?Q?eTqO+ZXSm8yweD5Fpth/IdKoh7CqKJDOcFJK7OAdfoVYYUHeID4bMaDpkZKI?=
 =?us-ascii?Q?VgqrSi6/lqGfZvF+IgwaeBcydTMWwvaj6lWxSw855cSoa6OsbaXyo5hh35ht?=
 =?us-ascii?Q?QVl6bBVGdz+WBhJhTAJXtKHPVRmTJLpAI2OowYDF6ViYTwAGmeO9mvxRM1gY?=
 =?us-ascii?Q?k/mgNFIQ3don5inf0cB2ukTSxUnw3hnJP/Pbsha3CiFM1ItNbqy+KUibMhBz?=
 =?us-ascii?Q?l16kdgMKNREwIhWGDMR9plvhOvW3FnTmHgarAlRUJc4auetxLoxXBbcZlWXZ?=
 =?us-ascii?Q?CvYBNrF46sazSwulqvqKcU0cFJRxRbQcmcm4zOdE7OKWgUfhPDNhveN5gckC?=
 =?us-ascii?Q?JkGWkktVVMlujJSV+YTxVjTFWWXqINaLMBvcv9tR1VIgqplDG40ZiyuGH/UT?=
 =?us-ascii?Q?/g1rLYIV+5AjYBKwbSZ4MV+PWuNnkYTSzWY9cLVnmxJNKhT5UAKZpby1kQDk?=
 =?us-ascii?Q?x+sazniz9rFyuha89Y1F8r4yu8tkedyseu6wHag96Pnb53ggYJzNRy0/Xtua?=
 =?us-ascii?Q?geLjVbXwdQNnsU5yCFGK6pg9/pL2StKU6ukPwpoYJlzMnihNXMW6DRUC9iVD?=
 =?us-ascii?Q?yrRcMF1yaalRzm/KKxie9ABU2g9ee2k6xokMgrO4QBpHlknKmeGoYYNDhySe?=
 =?us-ascii?Q?N+fsB/eAEijid3OiPS5JUrIRCwNJ36Y8XSAskRKSVp3xjH8dqoIV2n6d7gzj?=
 =?us-ascii?Q?tFcE336cfIdJ3aOVP7wooJ9D8T3X8ixuvJcdcYtzwSV4P5R7aGuAqrrPDI/b?=
 =?us-ascii?Q?y7qQo1tttbOc9w/U2pmBGwbWpOybnTwhY6zocnO+gJz4UQ98ZSM9IIAK7uIl?=
 =?us-ascii?Q?rrscAchvzNWgKNgIsTNdtlrV2HJam2tlrASJtn19mEhJDXuxjvhAGCcqFarf?=
 =?us-ascii?Q?cOHh75Pu8Q6uzKMo5DE1rhzFo8uxADYf5n9/ROUw8k34BjQAB6or9Zn1wGnW?=
 =?us-ascii?Q?30w7qQz1+OBNBcToxPQPuTc0jKGBTT9dmAB+2W6z2yfJV+levckwsGnkGS63?=
 =?us-ascii?Q?FjSQ5J3E1yCP344LsGbJx9GwJnt6f7A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ec3ad2-9cf5-41fd-17bc-08da199642ad
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 19:30:38.3587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/SMfO0+AVDZJ9gjBEowmYm8oQxg9HZFWekx251V7qIkIdJNdq8FQrH2jNPGFD5xX5Nfjijiuqc5sTOQvqpdPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4109
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Apr 10:55, Leon Romanovsky wrote:
>On Tue, Apr 05, 2022 at 12:48:45PM -0700, Saeed Mahameed wrote:
>> On 05 Apr 11:12, Leon Romanovsky wrote:
>> > From: Patrisious Haddad <phaddad@nvidia.com>
>> >
>> > Prior to this patch in the case that destroy_unmap_eq()
>> > failed and was called again, it triggered an additional call of
>>
>> Where is it being failed and called again ? this shouldn't even be an
>> option, we try to keep mlx5 symmetrical, constructors and destructors are
>> supposed to be called only once in their respective positions.
>> the callers must be fixed to avoid re-entry, or change destructors to clear
>> up all resources even on failures, no matter what do not invent a reentry
>> protocols to mlx5 destructors.
>
>It can happen when QP is exposed through DEVX interface. In that flow,
>only FW knows about it and reference count all users. This means that
>attempt to destroy such QP will fail, but mlx5_core is structured in
>such way that all cleanup was done before calling to FW to get
>success/fail response.

I wasn't talking about destroy_qp, actually destroy_qp is implemented the
way i am asking you to implement destroy_eq(); remove debugfs on first call
to destroy EQ, and drop the reentry logic from from mlx5_eq_destroy_generic
and destroy_async_eq.

EQ is a core/mlx5_ib resources, it's not exposed to user nor DEVX, it
shouldn't be subject to DEVX limitations.

Also looking at the destroy_qp implementation, it removes the debugfs
unconditionally even if the QP has ref count and removal will fail in FW.
just FYI.

For EQ I don't even understand why devx can cause ODP EQ removal to fail..
you must fix this at mlx5_ib layer, but for this patch, please drop the
re-entry and remove debugfs in destroy_eq, unconditionally.

>
>For more detailed information, see this cover letter:
>https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20200907120921.476363-1-leon%40kernel.org%2F&amp;data=04%7C01%7Csaeedm%40nvidia.com%7Cee8a0add0a154e055f8508da17a2d6fd%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637848285407413801%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=xD54MMVFSeONDeQyPHOinh93CPWjp2rUEL7F3izc210%3D&amp;reserved=0
>
><...>
>
>> > int mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
>> > {
>> > +	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
>> > 	int err;
>> >
>> > 	if (IS_ERR(eq))
>> > 		return -EINVAL;
>> >
>> > -	err = destroy_async_eq(dev, eq);
>> > +	mutex_lock(&eq_table->lock);
>>
>> Here you are inventing the re-entry. Please drop this and fix properly. And
>> avoid boolean parameters to mlx5 core
>> functions as much as possible, let's keep mlx5_core simple.
>
>If after reading the link above, you were not convinced, let's take it offline.
>

I am not convinced, see above.

>Thanks
