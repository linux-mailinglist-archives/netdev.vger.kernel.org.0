Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4369B3F6
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBQUay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBQUax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:30:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB343E632;
        Fri, 17 Feb 2023 12:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lt8B3Xstce6Gwj6Zy6fqWTM8T1gjGCs1V/ODn3Qv1EjYtnbui6hfpz8WKTmme4EESrCd7drW6uMke7JiVSgnZYcsH3cV6v6kDqgYpUjJ1zsqvUwBS8r2ZrUbvPpoPEJUXDKWANAH6L1iiI+NXcqJRwF091+hfpSI+PairnkC+/1ichcNaWTAnDBcChfdWdpquMJCR6QdRU4TN2eUKsgmGrqhn8MFeML+bV139j18Uc+wIJY7QDRmaAC9146AaTB0LZn0lZqT/s+QLWRCGji+/EyJ5AzU7WPwEquWyjJkga66AFerIvXZRKIzvR8cwiBLnLxBpLhCzbZOU7FeyQeaeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z7e0K8ieE7BvXXauz280gPXXU7PTBkaPuH+JVYnxME=;
 b=NxJk4+ddr041Ta5JI13KZCstWmoW2t7+XfO7cIvZ4d3MNu5tUHQ9zZ37zqsrnoLIFzn0WKuO/BLxq//4NJ7736CJL34IyzOf+J4ONko3B99J6mh0P/aFjDKWE1+e4YgJs6lMXH3FD0LRdgd1KiL9iVNiqE1qwiQA/NoHXrCiL5et2e/r7bvafcDmz33pfvG8SFF26EoLLQofFul1BAiihSyOc6QdHgDVfLK4omKKdg9s9pWbGrpcV2PZqXbDyA0G4/RwsR5lcJlkrlhdRCsdXfvC6SBr7uARdvdCuBkYIGnw6i+qOfSacf5XRIH4LjMM9vi9LVFChtrg9TQfcMyluQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1z7e0K8ieE7BvXXauz280gPXXU7PTBkaPuH+JVYnxME=;
 b=As7gOnnhFH8AWbtmNmweaKWw/Gr7xNNW8lSzzsAe4GhDIbpprgqgP57Yug9kaJvi5Wb11rTiy2lsIUatTxp8vX/Us/GkBFcH4E66psJ4L45ilyODhjQ5nbq4oveYPZMzIT4nk+TP22HuVZfaFv+In4WghyjZ3GaVG3MChWmfYgooSl2p7SAb5gNLO0OAnVywNxtUcdsf9bMog4IeJy2IvtCAD84/090lOybRm/eqJrMcys7YalcAkhYkKH8CvRYXUItXiJW/kbM+IL3b9Mnfnj6GijgFb7bZ94j5AoX4eyrZ6WSRaEEfUNOG1/hKvSZHUGJVsWm0gI/6//SE8DiAsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6195.namprd12.prod.outlook.com (2603:10b6:a03:457::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 20:30:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 20:30:49 +0000
Date:   Fri, 17 Feb 2023 16:30:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v2 0/4] Rely on firmware to get special mkeys
Message-ID: <Y+/j967Tm+TRBAoE@nvidia.com>
References: <cover.1673960981.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673960981.git.leon@kernel.org>
X-ClientProxiedBy: MN2PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:c0::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 825941ef-cc63-4bd5-11d0-08db1125db3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2vFykTLFyHBlB5+GwdceLKIuxTMce1306iU1BOm2hTQsGmuqVzp0BoaVWaQB8VWfpMCxaZ/hADf2FK8enx2y9mLFKmmuKj++K9wQYLveC9l5GZVgu73un4ocdQJC8VKgv/J56cyRTjyE7PJu4g+LJgLNNZVvJ8R5LIulEtKaOCaT3Wit3oyC22E1XqndlaJL3vC7EXDxnDh0s6MnAPgYGz+PDYKj7avQXT9x0Lp7GUg6RivqXwuHAXKAOKdiZqRtd6WXJZCVoVbxq4koIRwJUaOALC7HVXmtULF/s2e8zZc+3X2AWSGQ3IqUpRWrFF6vvZSoUPw2AQAPy8suslaJFsGGiLjh+80GZsL59cOvp1Xx7iQeNa4L+czRmlIv5Y+fhdTCWFd20dsqcBoMQMlIQ5c88vqAEiHpP0POsHRsPpszPGxEc2sqqY1Le3aHFvCh+9nR3kLlB4/yVrjOtNtUlf6XuSqCFeXQd68dxFCARCPhrDbG+83+wJMkDVT8iDr9OqTTYJgSIt5VC8hjLnnFVbKpZh81Y+C192eVYcl2vdp5BlxSNqj4OWRzxQo69ln0AKJaAlISijOQXFmttsvT3OWLCs/u1Jo48+aeHIqh6pGjROO3vc1mK+LV1z/VLVuF+yskdr15ENl43dQaGmROfthkYilVcUZzqUwc6NB69geeJfevo9cVdMXHzjssQisBU4r7m2Iv1NSHZYsUH55UqsHh1PmxyRCHqyU8jCsd38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199018)(107886003)(36756003)(2616005)(478600001)(26005)(186003)(6506007)(966005)(6512007)(6486002)(38100700002)(66556008)(316002)(54906003)(66946007)(4326008)(6916009)(5660300002)(8936002)(66476007)(8676002)(41300700001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UbDczWYOZG8JQPqadBIHLZDk7WJHQV7D9GRcJJ65E2inJR3vy6ZnSMR1JWUR?=
 =?us-ascii?Q?NlpujT42dXnOYNYxHg/idZ1ELJToEHMGIluSZM4uMmuymt1nDG9nPfICohim?=
 =?us-ascii?Q?I2icEot3W84J1e6HLV8Jlvf9/BjByaczqxTfSZL67sZOS6a0WrK7M1eGMFNk?=
 =?us-ascii?Q?7U5fM4rbrRsP0Uh+f0IMGzVWTStzWK6b9ltOE4Sy4gUobHe3L7vfLK/dIYVv?=
 =?us-ascii?Q?xTtfDZNWK8zju57BtE73mQGPiD/KdWIm8RK/8PU+hQNwzlezMgeZi1xBkrys?=
 =?us-ascii?Q?pGXqppM/oskqwQiLGWN/vFIvBWnF/XVQBLx6FRNJQAqHgO6rmq9pAlTSqatC?=
 =?us-ascii?Q?kn+IqL9q5sIbMMX4DeUCHs5E9PkMzQ3ACsa5nQOfS2M8cjFX5ek33WwhhF+P?=
 =?us-ascii?Q?ZheP/fQs9B6CmzzTlZ7aO2Rmc2oJy3L1FfUayPd2YyCj0QBY6tgD+LpGIh5f?=
 =?us-ascii?Q?FcBrgpqiAHx7stRp5qidvW0X7DrVCmrnJEz+rmSeyeBbHK4LNbQdCnF6lB2s?=
 =?us-ascii?Q?ANVn+epjl8MgvSMITkmao/W7EE/WScfaAaZNPaHuUXZoHTcdTXugb5N1R76d?=
 =?us-ascii?Q?rJhVgAYA1US6gTeya+n1Gc1oHHd552apfHLFsccYnxc6PfyWJw/SmmTUXDnT?=
 =?us-ascii?Q?z5VeZyz8/MNkEF0vo1jlWLYa9Qk6Q+Iho3vkV1rGqn4mIBAUQ5lRRTr0iOr2?=
 =?us-ascii?Q?+zZk7Ugo630AzRbFrWbeUEsTHH5CIJtH/Ur7fKfgq52b7zZt3YB/NzZA3ggK?=
 =?us-ascii?Q?3O8Ch4OEWrgJO2WoE+aclPMonV4mAMmwzPJ5kP7O5nL+LgZgX7Z4p664GlG/?=
 =?us-ascii?Q?yNyhiSMKOufnKFwZi7YpCAbW+qdsa16fBuNvne76z/XITfrcJt6xv8McSV0X?=
 =?us-ascii?Q?IHCFGCN+W/lXl4OvBKwZVxr/yrJW4HKNiK2JgyCSGozo0N5ZpxZX/9Ruj7MZ?=
 =?us-ascii?Q?EgFzxMv+TsEpAMKjGsDKL3dqyJ2dUNaAwPgOkCMpN+fLLhq6RSIQ0sYQFhsb?=
 =?us-ascii?Q?wrc1WUhE2pr+dg8PpKVINFJsBnsPDJ/TT5RB5fvpgYDknefCGstY+1/kJWCr?=
 =?us-ascii?Q?fbOOe3Rt+OfEv8/LJIQZ5wWxrzW879g0tbw10PEnGqlwzfpYnVRnwTXyFV8/?=
 =?us-ascii?Q?qJ/8hygPAW5FZ1oihfrG7ds4pNU4bE6ALHCaibrmhLUFif1ATms80IWKkYcw?=
 =?us-ascii?Q?jVu83tNt1e33B5uvZ8Dnoifn+296FoIh1zEyIfbcJCBerPnQavDt0j3oCERM?=
 =?us-ascii?Q?ZYcYfBWhRTpOerJvSxonKrxHpmrUelcGPvM4biFxSYRl7WrvUi1K9VoSRXXC?=
 =?us-ascii?Q?8kFa8yNbI0a9ZPU8OcyXzJz3Ze18YHgHKaZFHTywlAgJsho4tLXyfVPrZYQq?=
 =?us-ascii?Q?MwTSHubOtpdm0c/jhXktvU7b4ip6Ibg7YSKMjGg8lJTgx6owZ3AQ1dJLflYz?=
 =?us-ascii?Q?Dmik/4CewTd7ePO0/BXlRH2lHkJof+imrwCqCDVpIkYGoHQDqINBr33a3nQL?=
 =?us-ascii?Q?pAUfvXCSnSYFwtw+DaNBc3uP+M/BzvkejWDtE/N5djnVlEMzVgpPyPJIZ3ot?=
 =?us-ascii?Q?pLk33YEafFcwUuq77nTnDmSODHepYmw6gcxRJrvb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825941ef-cc63-4bd5-11d0-08db1125db3c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 20:30:49.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTcD+rX1omN3ihvM1uR6B3iMD9Gq4ognZmaZ23vDta0s8zs1vOuIoHFrc1ZZob5C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6195
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:14:48PM +0200, Leon Romanovsky wrote:
> Changelog:
> v2:
>  * Took a liberty and rewrote net/mlx5 patches
>  * change logic around terminate_scatter_list_mkey
>  * Added capability checks to be before executing command
> v1: https://lore.kernel.org/all/cover.1672917578.git.leonro@nvidia.com
>  * Use already stored mkeys.terminate_scatter_list_mkey.
> v0: https://lore.kernel.org/all/cover.1672819469.git.leonro@nvidia.com
> 
> -----------------------------------------------------------------------
> This series from Or extends mlx5 driver to rely on firmware to get
> special mkey values.
> 
> Thanks
> 
> Or Har-Toov (4):
>   net/mlx5: Expose bits for querying special mkeys
>   net/mlx5: Change define name for 0x100 lkey value
>   net/mlx5e: Use query_special_contexts for mkeys
>   RDMA/mlx5: Use query_special_contexts for mkeys

I pulled this into rdma, Saeed/Leon if you need these commits in the
shared branch then you can fast-forward the shared branch to:

commit 1b1e4868836a4b5b375be75fd4c9583d29500517
Author: Or Har-Toov <ohartoov@nvidia.com>
Date:   Tue Jan 17 15:14:51 2023 +0200

    net/mlx5e: Use query_special_contexts for mkeys
    
Thanks,
Jason
