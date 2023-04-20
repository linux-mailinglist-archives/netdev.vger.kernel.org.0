Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C646E925E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjDTLYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjDTLYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:24:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2D6A5EB
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXCd2ElUDXxrjDfs4wJR9M2LPD06RXYiTJbgekNAprG22z1HyRyG2u7OM0X92iM1MDyFYXfkpvnlST0FAktkXtEG4FCvNKr+lIhUbF1n+ZJ2nvlUaaVg43lpu24+E2Kc6JXNXJTEJwQ6pQZrHyMegtJjc2xRdPLpmgfkJoMj9TtRgluGaGmS9KfLJX9B+OUwe14tnlHSof5aUgTwP4mQqKfB0X/LQ/sDm5Y+DUN++vWyW89gTXoglYQSD4rUklXmmkaAx6q5M4M5TRuTp3d6YxKsirEmsDO6YgD/mqHh583LSIrFtR+eLpsTSB34tHUEbmffbo6SwZI9q00zoz9kkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFtEajWJkg+jCXxYCoGKHh+OYwDbh6ZLpgLSoEyEfiY=;
 b=WFsLn0kDkrip1OKqXqv4IVhc6P2frtqVPWMYpO0MccRwsE4yJiYU/yKpEc8fbsPO7/keK7vud2RYN5YkgCMy7p8qdn5MqzJ32A/B7sYKveY78HU06B8brRt1ZreKVjv2w+m2IVPltrScTRQSW9KYgj3cdsHktiG4TdufcwRuBZBNjtPV2Vr/tMNDNoqpxaU4oe3NTHiJ3zkD3DPGaMo/IGzuxcuyndQwt/JMxi+w/J7DYlKfg5DTszta1d0Dm4TDj7Ar4sFiITvXEAyZ1yPqBfJdVykdg/Tz3DK9Q3d4fQ8Gly0x57SOiQThmS7Cke6ba87FYQ1uU9Hz0WwBbfRXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFtEajWJkg+jCXxYCoGKHh+OYwDbh6ZLpgLSoEyEfiY=;
 b=RsIvcTvxyD1nI8VQPbsIwYPSqBemngR5CyjTkk7ICxIgAc8fNqo8xmgoGZmXZnHGVSAMpw+PkPSb/anY29XpXXbk2szP2hdrLubPzoF19+RG9mhMSgPQppgExqaHh/zDPLiw2QGNf6nDktY/lAI4WLDPUL3EQNyRIsefBR0mv1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3634.namprd13.prod.outlook.com (2603:10b6:a03:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:22:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:22:42 +0000
Date:   Thu, 20 Apr 2023 13:22:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 5/5] net/mlx5e: Refactor duplicated code in
 mlx5e_ipsec_init_macs
Message-ID: <ZEEgfDgZYS75+7Dk@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <bac66f9dfa9b72ff606573fdba6f3ad2d28c8c88.1681976818.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bac66f9dfa9b72ff606573fdba6f3ad2d28c8c88.1681976818.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3634:EE_
X-MS-Office365-Filtering-Correlation-Id: c4adbf3e-48d2-4801-7d93-08db41918eb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKRKiLcdec4Np7HOc6Dp62QlE8XD7flTViQSHhV1TsHDlOuVD4rxcO8cKL9s2HNnGjlLcAttoatiiulYj1aXXpZLsn+ODU5L22PI4C5fxeQT7nqyYvmfpGLX7L/451Rtz0nTe/3nCd5G8mDzzsX+udhAczYrFiH3xA5U9xyiB6HLZHIUMJ9LQozAC8iZVaeenWcooBs2SFA+PRkDuBShAJOA5jKqfenoEGpx7JJ7bPZCftQ2kOoqbpJM+TUn7P7fSfywtiMkUXK8mmEqpYZGw/kQLgAlkbnzbhgU5xix9rPg+i7/az9a3YPAx25iz7gKxRqWozhUVoQ3vIkjUXvNdiz9QFM32ep1WnQRAm1XInHYcPEy87dIH4pjY+Cq/L2zTeVgnqqopwZFg4fu4RYDDLzqEwq1wLPeRiKQe4ozBOlydFY7oxshktG/mQReo64T99CP7N8guOcJUMnPVGMqAZVIsnXdD0hwqMU9BSgc0RwaWdTdABGk6I7RTEWSMSYUvNzNflwyT+BrGCgVCVNF0Lv9olnAQFO2pjXgG9YM3q+OLjT/woPNj4qNN6kAXzfa/vEtVQVaXdExchc7CuwUR21Mf2FMkCcatwFr3xTO+3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(396003)(39830400003)(451199021)(54906003)(478600001)(2616005)(6506007)(6486002)(6512007)(6666004)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(316002)(186003)(7416002)(5660300002)(44832011)(38100700002)(8676002)(2906002)(8936002)(4744005)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShXVcYvHGJiYJ5T4ZgbvPXtwZGLr5Xnc3PXaKzl1xnhQczr3QjJhaLCNk3Pe?=
 =?us-ascii?Q?iuUl1J6O9ZuU4a0C84KEpEcdZOwq8YzbB6mjtirsisCO+4kTBEeZNVmYE/iB?=
 =?us-ascii?Q?jjfNqWILfGnq0cC/CvVHg54qTn5S/R6A0gXCz7VjCHc5ydjUFVLpjlo77ekJ?=
 =?us-ascii?Q?i1zTb4cuKrdF1IqsYJwCKfWuq2ijLqBIcG1d7ERC5icyqvarfD/WqVfYtqlG?=
 =?us-ascii?Q?z8PgZUivbqkVzOXvakM9JZg6CgFb3GSUa7NIAzx6ZzMo3afk/pjt0/cEr1Cg?=
 =?us-ascii?Q?CvTDRZeS0hU4LnW4q1FS+kV9DfyBqhw3OMoPd0tmT14MH7nkc/OjZjny/jGL?=
 =?us-ascii?Q?O58nOLxqZrCajCIin2+mMq68fvzACVJK4IYzl57b5DjnKwXZ9JCFDxasq9qI?=
 =?us-ascii?Q?MDIVKt2xxNkZ3nIu5PsuZUdKqzLm250k0ltWO6e6Mq1dpE1hJOfPCS7fDqhg?=
 =?us-ascii?Q?F3VKljHYelaJdQDXyxenOovzHSTfWicrI9b4O+iYT2bwrjAWaVvPnSGSMkAR?=
 =?us-ascii?Q?NlK8lc2YIQRK5rQq07m0BjnNOs+pSiExoD9K065Ps8PRUu1LiqajmI0LuWxu?=
 =?us-ascii?Q?Fr9/v0xHvMTz8MlkozU5prVQWQ0NCYolOWaCKwjz1lHdCRcOEHpAHum6zC8d?=
 =?us-ascii?Q?r0e2n5NhaupMmjCYidv3AStsBIjlDGdt1gaclAz38woc4t0c7gGlZO1Xplh1?=
 =?us-ascii?Q?XpEBWV/w1s3AXPSOAY65UDITVb7ny4iTHlO2KTJ6FLyyidCq8t1QGLh4fbMr?=
 =?us-ascii?Q?/8Y/1uv/Lgn9OAUOCM0n/3WpSU2YPHWxYgHRQlCUz7Ro8fdUUDlyEeZdgQPC?=
 =?us-ascii?Q?K9Fj/lOTDsQASLA+/y51w9fL9Vz3LV1+ROu3Tm4xvOIAoS/x38ECZ7hPCDUr?=
 =?us-ascii?Q?2ASevSjmctjmDjTFsI7mJqAnpWY8EM14NCWsgak30FSAbBBSmq4lNks3528W?=
 =?us-ascii?Q?2m4ZbjV0DPQVGHhKp8NVNc4+kNtYREDPSQCePwAvR9l1MR4XCjKl2B3aGGiH?=
 =?us-ascii?Q?z/5Zclpw0J3+KhfN0KrhtYwp4Qmbb2KIjHc8WhHRe3oWXCb9iw1w7qW20+uf?=
 =?us-ascii?Q?2Pr7elCfCi8/BwnpfuhZ3KOnbguA7UEl3/5Cb6s2bp2DJIAKYtL7VL0i9Zuo?=
 =?us-ascii?Q?u3mL6N4Mw6iciiobE6Fw82oVr+cGvBD7TGGkFTV9XKalu16VFg0u25Wn9KNe?=
 =?us-ascii?Q?o1+zJCf1S71RW52GDL3/qnQB2sMJu4rqrkoTKDvQXHcqK4WbTmem5sbGoy2w?=
 =?us-ascii?Q?mpki8Xcx5FlACGdOdQO9KBLinoW/d71GsvXG+BbUtH2fWFmE1mBP5lU+/OVy?=
 =?us-ascii?Q?jkKqB3G6WL0Dl3dsKB6AgHew1A+W3zt/4zG8qQgJ26fOiV17e3tnqUiwqsEf?=
 =?us-ascii?Q?5ZuBu0rmtu8CfJKKOviWL0oKd5qdglQEOG3R+awpvSf7CNaIPF2MwwhMyLsW?=
 =?us-ascii?Q?+heMsKh8tEN+kmQHalHyXM/q/Mi8u4B+D+87jn3ETPc4ea6lKqHqhpUnoqv5?=
 =?us-ascii?Q?JOkjKS+Ld1VG/Pink/av7gxDE56vQNPd4ovyhYAd9pbWbKGVfWAdw6PWN+oG?=
 =?us-ascii?Q?yRxXzPz98mcJAG4UzCFT2FfHpzsKUP6zNnXDlpHNOYp9jCazM91EYKSVDq4C?=
 =?us-ascii?Q?R93RS9+/qZXBSsMQEc12UMJL9N915YjOVZz+E5RLTW8pfA8YWGGuxwgtbPLm?=
 =?us-ascii?Q?earbxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4adbf3e-48d2-4801-7d93-08db41918eb1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:22:42.5375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KsG5zuHLFaXgmkAk4czQmKiJjwBctKFsV6SP5SVkLhFNsOCotyO4ipi2QcEDFvbqLkwZt3M0EngG7iqG/w8ClTk7FbLUd5e6ooXKQXVadwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:02:51AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ARP discovery code has same logic for RX and TX flows, but with
> different source and destination fields. Instead of duplicating
> same code in mlx5e_ipsec_init_macs, let's refactor.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

