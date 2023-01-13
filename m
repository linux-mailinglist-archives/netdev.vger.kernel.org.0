Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42375669A13
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjAMO2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjAMO11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:27:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4301A93C2D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:17:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEWVt2cbgN2I0l6aqGWkdIqHwRi123q2BgMwDqLfmS2s9DK2Y/W60eRNV5FhTEwc1qcNDSX99nUb2hlRPt0QtT6DF9mvHT0o/5+mRL9fJhuXmqePL7k9XMPqae8yZkma8zlC7hHk5PkANu7lxrEQ6eLw5bOnSBr5eN4RgtpwMlu/2SHLxCCNMp3PaLTQwhss/xO/l9OTWLWiCocnnMY1yOOTfU5E7v5yqw2W8i7j8Jvkyl2GWloC9tmtU/qKKKnOXdBJ4EmNa4geLCKicE5ycOsF/Nn8IH8Oo2vTUQjs39546gVYUWfghexmpQqVdXhqARGEmzYNJZLKYVqhy0bwqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTGZnEWLYt90PwPx+UOcfqjxZ/C9+Z75hrlGfxtiQ30=;
 b=ZxQD3bn0xJJmWHDrpoQU78WuPHtXzGsUiXk4phbB28HAb+fiHdigNFyoE64PHj6u3+/lfQiSyMXmJlNqt4DYHk3IoIHd1+KBK5q8iku+lcbP0w1cVmXG3hybAekQna2DQefVbFLcxgflc8K7f0xo4fUTVVFiJdjim+Z8+RY4X/HEBlRqzP+Ui1nuf+iY0rWlIl6sBzPFUHHeBo6OO4+QuzATAOHK+JziXu161+/tdIaPjED2oulD4gM0nyUrD+umkMjB0Kwtio0LwmSXxPNmA6cB7yqr8yJBXjBmFxkBc8hXlRENJrNgMn9U7ZFzU01HsF2ua3e6cW8EvhNLmuVIdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTGZnEWLYt90PwPx+UOcfqjxZ/C9+Z75hrlGfxtiQ30=;
 b=jyZ6MwTXxMQJ1CyVZOVvNDnvNRt6f3A7ZDOtlinRvJ5CpDG9XDyKU27Y7ABxEe+xvET8mnKIBRwWuQR1i+RT+OEnWuvkWVG844aRTLXSs0q6100A3PxatSbyyLZQZ4vWUAeyp/ULpiKzvEV+DomfcSphVmQqPTmuYt7n5gMYi8zu52eFCwXyuxEzV6j/X3lEt9GG+ul5WQsLyGg3b5OiAQvXidJZQ4+Ikwqxq0kTFDXcJ+DqNl8snsmKcJnywltAnKdqqO8nlU02Dk0tMUGDVyOH0M3VQ0ZvfdOJtu5tGgPn8ahdrG+nzrjnY1zWJ05EMT2dzQ5vVfewz4FNLgc0TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BY5PR12MB4273.namprd12.prod.outlook.com (2603:10b6:a03:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 14:17:24 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Fri, 13 Jan 2023
 14:17:24 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        Boris Pismenny <borisp@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: Re: [PATCH v8 01/25] net: Introduce direct data placement tcp offload
In-Reply-To: <20230111204718.215bc22c@kernel.org>
References: <20230109133116.20801-1-aaptel@nvidia.com>
 <20230109133116.20801-2-aaptel@nvidia.com>
 <20230111204718.215bc22c@kernel.org>
Date:   Fri, 13 Jan 2023 16:17:20 +0200
Message-ID: <253358ett73.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BY5PR12MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: 389f1245-ef14-4946-a1f0-08daf570e482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laL/33RrlCiw+xYGxwiPq8hE6ImPQGV0xX1MR0J6b8wGRvxbe3pqlXimNuurvA3xI58Hwxj+qB9HEn5XglIOpWGX+BMBkfDCFcYO6mriIYwxakYlTeSB6b4Xe+yvkU/rMcxqYl5dUcv5GsHDNMPsOf/ejwEKX8VBbdy59Qajz0+g8USdhs/9z3/MndCcBK8ek0USMuae/oOuRvH/MgVgrO8cthEY3vX3txGmvPwexWziMh3Q7VlFbK1BRgnhaJTL8VPSeWZKxs9W64xHroQfEO/cS9T/FDSqR2kYE04n7Wcub0hPFh7m/RRcZh3F/yLVhK9Xl/dpBwbgqSqtBPZqN6G+kyCUo/6vpzr0N93mjDshaST1dQal3i0TBPqeso1C9m/Md8dcLBV6r5gf0aNfss+xBfB55tLSY+yZWB65imDHu+qGoY3UHkjuuHL9Ei1oe/66+2BUzs4EQDNafiymbw22JcfLXJBy48jOgqGLa+bfSguGTSg9uvChg5EIjWtHKRDtpdKqKMdc4qZ2HLN7/85LZFJJwAhAMOhGfiiRb95jIJyzg66Nroy6QWQHDR4wI63OXgVbww4P9I1v33bGrYmhjdGCaWqP7sHQpXsPGId8s7SK2lo09rEQnv7VXh69RQ7NwP5a/eT1YrBD1+uZyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199015)(6512007)(9686003)(26005)(186003)(478600001)(558084003)(66946007)(316002)(66556008)(6666004)(107886003)(6506007)(8676002)(4326008)(6916009)(66476007)(6486002)(38100700002)(8936002)(7416002)(5660300002)(41300700001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iATMr5BvrRCCBBvcQsyZMlXULmokoQWZ0Pohk2/s/9FFYRY7VJFLvpOAenVP?=
 =?us-ascii?Q?T1D+eYyB+NRYLs0Si0Cw3/eMTptlA6nUCBXNB2l+VZ59aTQEolAbqsKL/owF?=
 =?us-ascii?Q?bInEdrwfl8mSrByAuRdrpp3sqNxYwniGqJO5YXzirN/Ji8s1NtfeXf4Dy4uN?=
 =?us-ascii?Q?o99/ISUrPNFSA00G/A+BGujx/YFX5rGiLW9dyYV3Kx1wCOy00j0Q4/rqntX5?=
 =?us-ascii?Q?o34hX/m8UjvlCJCleK8Ze43q5OHPKlIxoXbUHKQdXL5jZVhLgnyPSbd1q848?=
 =?us-ascii?Q?/Bbrz04MsPO3IMOIBEHZU7QlDbPGUl6kivLoTVX7bjbNbYhPfe8i5as8nfzs?=
 =?us-ascii?Q?x9QwUFWQI8ZLmfyL4fXXUwRWNQhsCA63nbQ8GvppOU6Per0Q58+WVIRtkIRR?=
 =?us-ascii?Q?uZCyL4jQuLsJRPIerfmx4zPUWSC6GSYkFMgoo7hn0bVcCGaW+K+VAdXO9G5c?=
 =?us-ascii?Q?2fQU6Y/TfiNhIJaDI8H5O6pk2Ly3GccHRl/gpeEuX8wxY/nxCK9wB20ri5xv?=
 =?us-ascii?Q?+y45f5xU/a/ueK6PUP3hIio27CkqWtWtZMc9+pEtdzx4cGEnY34pk2hwBXdU?=
 =?us-ascii?Q?84sxkJQ2gDIjAqO9XsECIoVpBY6MHHqsjOxcC6KayHaS9GPfivdjcLuQFmJm?=
 =?us-ascii?Q?oAsWAQGNsUqUPhJBLNCohfsjyTSobWIeJxIkq+VyKIwW+phVmXl9P5W98I21?=
 =?us-ascii?Q?idrDt1fEoZ3ei7PUxPgIgf9zQGlgT4Sx+V03m89PC9SqjND+nl68E4pn0yXa?=
 =?us-ascii?Q?UyR5sd37I4+wQ/E1NlcrbC7VvB/89N59TA/LQ5i8xAZeIDeN69ESMamT4ekl?=
 =?us-ascii?Q?V75fFIu1H05g0NqH7mPk5WMv5TPZ66y1mypC2smYIJuhT6rwb1PdW502JBLm?=
 =?us-ascii?Q?3PMwdTeamT50pL4j8RGINSfB093fKDgpvyIFvKVyvm2B+7Od6oGyXZyhtHOd?=
 =?us-ascii?Q?lPsN27jsTjI1DAQGB8AMC3vzEvmzwe7OtB29PTKM2skX+HKGla0wPOBkCbId?=
 =?us-ascii?Q?d2G7IzGqGqya1uYZt5Pc6DfZriFmgfzcxUg+F7hqE9qaHSgMpby7hVoDY906?=
 =?us-ascii?Q?7t69yH5i6b/GZdhRoQPxarUZgDzugQ8G0IbM9+0IbgxYrLfG6ilnCkI1Lno4?=
 =?us-ascii?Q?h0eY6VJACoLXat079Jvy8qIhUb9wGqYOlzHvVAPKtJTCg73SQWUHIG4GOyyc?=
 =?us-ascii?Q?xLPWceIVUwbzbn/ko4T22+eOyDOIuFxCxaosN/XouL6Qv0GxlK7eWVn1ifE6?=
 =?us-ascii?Q?39W8BZvZJuJeipMQi8x5KO32zcjTyl0JSudJitPs9MzR2Rz+uByce8drEuG0?=
 =?us-ascii?Q?jV5b6yqrsVW0sKFuLyiuKq+lKFnh8qpGiR00z6RBM5zD2OOoY5aj/Lx6HWn5?=
 =?us-ascii?Q?XE1RBHE9S2mdQLh84wTVe619THMbT3bmaFBkLbZrVj4yGvi61juPJ5UPdM1i?=
 =?us-ascii?Q?1CTf13ZGHX2usYmlLdhH7C9DRI8jetVVGkdIJbsqeYe1s2DhmDZ3rOipk9l3?=
 =?us-ascii?Q?0uSM/WvH7RIIMqyppOINr71t4JyQ+p5TCGgCH0DfrUqs8mXfts1SOwJTxGoZ?=
 =?us-ascii?Q?a5ZW8b07ty8SrVrD3pCm567Mrp/6DO2EAutqELpI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389f1245-ef14-4946-a1f0-08daf570e482
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 14:17:24.7598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4jCfvEPYDrDQaSzdbQQ9x94oYuaNfEI868/Cs6nR0J5+V1HWK8+nBefvqaJpwZAYQEZ6/An8PsvimBprGWLhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4273
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> no need to prefix all the members of this struct with ulp_ddp_

Thanks, will be fixed in the next iteration.


