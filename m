Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDE84FB094
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbiDJWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 18:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiDJWA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 18:00:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6664E4F9C4;
        Sun, 10 Apr 2022 14:58:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWqVRrALxBriHSTC4snvBQAujJDdfMmmLorvC0jL+/oRTsZlhuW63jnzmGWdSmLkzCdXv6PjUwCfyxRMDFu2u6EPQNn4OeKXOXrjEWlf0TuzGtYISJnZ6YIc11ka81y8ebFMnH1ma3S/nBUZTcd/tW8eTBbnoIU0an4oJyn9LvmR5NcziBNE5yqsuAWP0aY9pF4kCFM0G+W9qq6f+Jb5ijGZ0Tuapl7A0awThDy8wAxGRgFhiYQKGaAOsePMly0a74ZAG1h/b4kgun24ABS3UwKd1gluH1KSU83vjkz+qC1+4S8N0p2kumhlf8JnE2Id4Ush7SzTTPsRzU8NQVHN8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZEQ+Amou9JGh/6mxGNzRC4IWj3gadU/MX6wbwU2TPA=;
 b=O5Hls49UiXmCriMb8SDXBUFGKpOixNfqQlaQrJ/HvF5jBWbm6+ifG/O8Q7+ZNvXrVUrbDjo3A+k73jFq4QHSFhQETpk+ZA+mW5CYuhlPEwod28ay+xreP41JVdEUyQI9UOJZLHA5cEdRBpwF/wuGuUm4RLIwEIH6LmjQUvBdtqCAGT+84t589pEQyQU65sSPtNsMlFLgjHp/LhNUAxQ6A6gZK8xIM2nZWf7c9FZu3PqoJHqBLvMV8nwZeiE0cC7Dp07NMAt4NgPGIpdCJ8XYzgp9q1dVx4jzuqvAjvO7TFnZclCjDtZGv8IZnO8ri8LibcEWZ7aigXEvBo+jVl2FFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZEQ+Amou9JGh/6mxGNzRC4IWj3gadU/MX6wbwU2TPA=;
 b=CJ/GUja8zNkCe4Ucs/wgmbEBP6fr1uW/VSgPcG6UiR8ICKQzbLYYgSNH1j8M1fNKZ5o7JOAQIvZAZ/OaBHU7oVQdjXPL85yaD62bf/KNRoq0LCBd33eSH9wCGrDjEXP5BQX+CkrqQwET+Y8DIL+OA025pwEM1aYc0A2Wdt7XBMaP4JoFN98Ioe0FXasT4KwRQXVIbY/jG/sydKJ4UTbfYhO8O5KI5/7nndnNRjsxt0b0SpIc9+De46L4jG79slFdg3wVZ4x7MZ7tJnwz5U8t+A++1eU3RRDaE5HI08XuDSSKN+25SZgMr1N5nyCG4OjjSaHd8qzfHLrHlezYQHzViA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MWHPR12MB1920.namprd12.prod.outlook.com (2603:10b6:300:10e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sun, 10 Apr
 2022 21:58:16 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602%6]) with mapi id 15.20.5144.029; Sun, 10 Apr 2022
 21:58:15 +0000
Date:   Sun, 10 Apr 2022 14:58:13 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 01/17] net/mlx5: Simplify IPsec flow steering
 init/cleanup functions
Message-ID: <20220410215813.sxqmvmm5wkeguj6y@sx1>
References: <cover.1649578827.git.leonro@nvidia.com>
 <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
 <20220410164620.2dfzhx6qt4cg6b6o@sx1>
 <YlMR/CHoS3xg5uRL@unreal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YlMR/CHoS3xg5uRL@unreal>
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d37de0-b136-40de-ff34-08da1b3d36d1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1920:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1920D68C57407B22FD121CECB3EB9@MWHPR12MB1920.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZI98aAcoUd8e+RHbP74QrqQm2yJGIcCcfU+hRjefXGsFl91cNj6YNigpj1BqEdb8B5VUpEH8FU1PenkBZ5xUAdewv1Z0smVz++BsFyhd8lBrLLCBfb3xX/MM2kv45emBQpBqz3XAjoTkCbjHDtwViHuN/ALrGY+uKMqLBvwIikUHOOMMXcQwIc+TwUX+csQlAWivElPUDvGm5bTGIGoBtGvzNbSr+kXu3IwrjD4dWiqtivVpxmXz0CeXCdNYDOiMSvR4Ro/FOg0LKfLRNsFv3yxxEf4eluFtpBv6ywWld3Pig/WSi9n1X88zuvTdRSmbTGBrQ1trsqoNjL1FgqKouNIXrS1cnvUOZXMNQ6JYhtlRBFJRX41+k0g2g+9f5XpaWnZmwBoY509+35LL5fBhnl9goK42lt7KmVMl71jyK3INLpcn/yXEi3L3r/nn5G8j+GwV46AqhhhCECy/BFdaf3G9SJoS0JhiHB/29uu6cTvy9S00oKuTv5Ks26OnpMY8VyCKaMkcDNVaDstEmHgd9hAIo2EK6cNdVf2Es/x8PnDMicFLKaxCRinfSyft52IiCmVdV3ihsEXpFIEW7LJrpM1AcQO9l7Ke33q/OY77QNdXVhc4KaWt8Dd2MutzaIGAQun9xOnvSUOiyJ5qXQjfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(86362001)(38100700002)(2906002)(9686003)(5660300002)(66476007)(316002)(6512007)(6506007)(1076003)(107886003)(54906003)(508600001)(186003)(6486002)(6916009)(33716001)(8676002)(4326008)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYwDCpuwUSQoX7SEfO12K5TC4es0pY81ut3tjbMouLakoGgY9CawN0SJN7ss?=
 =?us-ascii?Q?dRtRM6y+okXAH85aa8BtBwnRKI8QgdflyXJ74uGxYPQEPtWklMLRQngTbfHU?=
 =?us-ascii?Q?8Ogfqz1aospQgF/fvk1wk6+ajsONoGXKsFc/nKak/oSwPIGGaAHJrDcyILXH?=
 =?us-ascii?Q?YnOOMbI2Slbon6voMZkJ0UVjob7bSXT+8kxpkmZx2/U7c4qe9z0i1zAvcA/Z?=
 =?us-ascii?Q?LD1hUccyhTqcDavURX5pzGZsihoaP9ztK2MRFXY0OFHXuN689R+uMzm6egLI?=
 =?us-ascii?Q?WtUrzgmGDtyEkPPonYfu/6Thf2nu/OwIHbA6aF9faXR3DzbCIfUVAx3Ls0le?=
 =?us-ascii?Q?BF6emvAW/LRKKnr9vG1zvOCoG0Cb5oYfy+TcOR1Oy0v+iiRmDTitKqijrMFi?=
 =?us-ascii?Q?uNTaJ85kh3DzuHyRi6VL+cdwGKUVflIc0epuu3+P+ZnaeEwTLhyBWpQ+UTOz?=
 =?us-ascii?Q?OBJFj+yxslMsCmWemwOMLMelruVVuk3R07zlxNlK347bqEsioT81KlSeRDYZ?=
 =?us-ascii?Q?M3dgkWN7VuwL2rmOdsHEN/2XYM+/DVDFXoGQ+lybWZUO5VsQuUPuIFy0+Tkq?=
 =?us-ascii?Q?Ub5vhVobIa7ab75VN7mQ1GbJeIYiN99KtXAwdMNqJcSAm5Exg4nRGeaA6Zdf?=
 =?us-ascii?Q?eLETaRYR73/VAQ45Nv+sFbHSrI7Qhfm/EHeEFu6nvS04Zfz4DXzwZ7mKopTe?=
 =?us-ascii?Q?F2vdSKAj1ayAhpyccwJyLbKRY5pJ86rACMbi7/hMoeWYfFKYimoJHuLojhwK?=
 =?us-ascii?Q?bqXLIoVtmIuBbsGR+Rl4T8Mlqg5Vs2FIKvke/ki+tA268tK/X2EYuE1Yq+Ww?=
 =?us-ascii?Q?R5zNgc5xCkVnilotP2lHgC3zO2ZJuHJ1PPNyv2LWL8mSO63Z/WdN60n+B2jH?=
 =?us-ascii?Q?8LiTPtMU/E0ddrLiofTA4DYW99BomVoPYMpZ1KhWa43HcfQQRy1uXZahFLIG?=
 =?us-ascii?Q?7CN+BEHDL5ypOSC6st1oFlMMfOmbKmKSYm7oimqndXPM4C6FpAHrTwku1GeA?=
 =?us-ascii?Q?WEK7n48IsThUCSnohqaMMdOr2LvUJ0fUkaVYOWHyHnoJdd9tMy3dzAwM6kjx?=
 =?us-ascii?Q?e+zdGojsdluxqGsIz85mva2f/9sjVGpQ5TFxroDPXZeVht7vGblDlQjtN9iB?=
 =?us-ascii?Q?xUac+zrgCtyxuKK8DuWNVkvh7bA+WxMPHC/fojAvQ9Vg96esR7PK+MXiBdMs?=
 =?us-ascii?Q?57VY3jfkpv6z9pSJ10cFR1d2blBE5l2VpjQc8oXPq2hZmYUV+hzheWgZoHvj?=
 =?us-ascii?Q?Gfq3fr3dk7hQzI12lD4XB3zTc9gs+SRpd2K8rntZBMr9O21h9U8m7PzzAqpc?=
 =?us-ascii?Q?xt/d/bfEVdz20T93H07rAzcRZrrPlFe/AS/6Cgme4D0IqjO7bTp6quDwZ4p4?=
 =?us-ascii?Q?Pn9lcJA2/gBBUL2jOiKgueD08XWKtq3yp9N/ZCvvBTc96fynq9Z8Q7KUD7+J?=
 =?us-ascii?Q?mxJ33CjBNvWFg8RAdpkPB58krDgrQHKJavr5QO45JUpzMDNHwlJpLwm7jvRU?=
 =?us-ascii?Q?yOtOLsN4fN2Vvg41dNSjuAqy6Ef4PONKhI+cHt+2doXGKvq9HDdxXglTn9zK?=
 =?us-ascii?Q?UKmKLtYTZtgmw222ynKK+Mi+glzwykBAKzDHnsHiXbuX+YZs9FEzDBPyJyP4?=
 =?us-ascii?Q?H9fHU2RB8EiJnYjpre1CdppFCxfthFPLcBFa+SypGwasbDTc+sBLNf5kWNx1?=
 =?us-ascii?Q?gy6zlFjDlDXqddqdhUmhSPsrih8CxC8EHraDOz/c+7Ey7my4qlwgfdHkyoru?=
 =?us-ascii?Q?32djT+yt5BKevPL/4dfjE9nzMEWXGEM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d37de0-b136-40de-ff34-08da1b3d36d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2022 21:58:15.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwiE/9hdbCJmN2cGKTqnefz1EFN4G4+GJJbJ5tc1oyib9pL1W2dNGo81U3aKoyYyj4WVtyt1eFwpI7/c53ufnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1920
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Apr 20:21, Leon Romanovsky wrote:
>On Sun, Apr 10, 2022 at 09:46:20AM -0700, Saeed Mahameed wrote:
>> On 10 Apr 11:28, Leon Romanovsky wrote:
>> > From: Leon Romanovsky <leonro@nvidia.com>
>> >
>> > Cleanup IPsec FS initialization and cleanup functions.
>>
>> Can you be more clear about what are you cleaning up ?
>>
>> unfolding/joining static functions shouldn't be considered as cleanup.
>
>And how would you describe extensive usage of one time called functions
>that have no use as standalone ones?
>

Functional programming.

>This patch makes sure that all flow steering initialized and cleaned at
>one place and allows me to present coherent picture of what is needed
>for IPsec FS.
>

This is already the case before this patch.

>You should focus on the end result of this series rather on single patch.
> 15 files changed, 320 insertions(+), 839 deletions(-)

Overall the series is fine, this patch in particular is unnecessary cancelation of
others previous decisions, which i personally like and might as well have
suggested myself, so let's avoid such clutter.


