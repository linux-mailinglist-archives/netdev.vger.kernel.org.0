Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FAF3DF100
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhHCPDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:03:24 -0400
Received: from mail-mw2nam12on2103.outbound.protection.outlook.com ([40.107.244.103]:18689
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235368AbhHCPDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 11:03:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXEY7QtRdJAVagb/E/JbasZKw3b/GFfkcYpjcyirYlU2M+r2QAnE+PTQ1/NlJitmA0CkgcKWAwoSipAa6TC2iHDDcvyLZ6zjHUl8HJIr2sCHCuRBb7CEUrpF2KEEk7YYw5VaHxmbmxn4uVdypxLYe0vx+ZhS9bLOemU3OdL4I5o67iM07nz5VkGlxCchVkPMoWwJou0YhCLZL3bohYnj5NsJA5IUiBakQ+YY9di+Hq+BQsTOFAE9hBuPeaad/1xBjZdATlhTspmmJnRR6Xr5CcGEoH2GpPc3x1ABZgL9WSJqQjjZXdFbOopOyn3Ct3gaDfPHgdtdTAat63Wnp5uQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owR0EAJY5b3HEA2qdF8TldMywv1j3MFlp7e76zOhPFc=;
 b=QGJobsMBX+0d2o/DLnGH8U7mUJPf6gEbAkRjkPiSGLCrCuhvb4VL4MsKgTVNjDYnerCxDXlQSQu/w9BNoSSgti+7EFv7koB3bnw0UgZMna8eBuHNNMlBLS+ksrurXdpRBmOIBSWhnb8bsbqew5KxlIP/uMdvMZ9xp8/uD+FF6LuqEdaZQ+951j4XTd4UX+2cc4ZCpUsuxr5Oq7tGsiQj++R7DbkHPm5Pal4DJay0J4pnaLNfyWl2TwIupBxSBSXrBXTD9eE4i8X7OSkHcSPp/v5moMebw6yZ9xVACVI4hAwwxtwXRWMSey9peIKh9MSAsAxJcj4pdSMOJTymJmUmKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owR0EAJY5b3HEA2qdF8TldMywv1j3MFlp7e76zOhPFc=;
 b=RdfSnV7fQwBQ2ZNhN+ADlg1Z34EAder8tg1AoaPPIOyK5B02017V0tyHdkOX+a2klmW1cDRMCWsK87rvX0k7I7UQ4njsJTkqZkdZv3xVklfirKJrOyx8TNSTlbFAC2Uo0XhQRxL9JzfIKuwP8KM88c8qQ9845RMhBEpa6T4/P44=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4985.namprd13.prod.outlook.com (2603:10b6:510:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8; Tue, 3 Aug
 2021 15:03:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 15:03:07 +0000
Date:   Tue, 3 Aug 2021 17:03:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, alexanderduyck@fb.com,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 0/2] net: add netif_set_real_num_queues() for
 device reconfig
Message-ID: <20210803150257.GB17597@corigine.com>
References: <20210803130527.2411250-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803130527.2411250-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO4P123CA0437.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by LO4P123CA0437.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a9::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Tue, 3 Aug 2021 15:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ac9cebf-a43f-457f-6d42-08d9568fcd3f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4985:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49850DD7818D3A5A0F0D3DF3E8F09@PH0PR13MB4985.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gmLi1KqzgB3nqUuibygXoIgSej4uHz3p0K6FOvoiCPCuD18ap2GUE1/qMXym0T9bfazkN/bRmv8uojvhcV/9eIt4c5Ut65ZR+3DldiyP76rkbIbbs+3hIU8FpUYFZjgy24rnDTXiaJpO1ro4hkhVO/ZrH3JSlmmTdngZDLR4QeKvYQl+0qUy07QjnpUY20UR3tsvWxMp1T+FD0fxPBu+s9oKQfPKBUJeceSqRwO5u6mt0/VbfJ7oIp1QnA/tw6Ze2fNyR7JBoRIX1N/bvm4CZQsH6mU/fmz3ZkE/sTJ9VaZR+iCr5gpGjPG2gEGd2TuRhhWEdORpqKQ+KIPO+Ziucr8q1cenlpTUYHj90+F2HdiHd3rQrZKy4kVTMQRRyGl/PPFJ9dW2zbYK7a1d9QxHrXlJ6TbfeTmyKAY2f39ODmX9ITaeeBPcowZiH0j8Xu+If+QjYd0+k76hnZCeKlF154Bvdq1uabhsU5VM1df2fmV5FayM4mViOLqK8psEqr8ngd97Kd33SrV00X5q5qy9Tz61++ywQO6L73O9JXfMZk3m4zsuvcCop4GTaQOwVwLxkH9PtqNpuVCZ9NbnKPmfNinkd9Y6mJKxTo1unukwvDLl6otkT6v3PXQanrfEpfQOHbcn4d2r5hnAj44Z5+5R5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39830400003)(136003)(366004)(346002)(36756003)(8676002)(6916009)(1076003)(7696005)(4744005)(44832011)(6666004)(38100700002)(508600001)(52116002)(66946007)(2616005)(66556008)(66476007)(186003)(4326008)(86362001)(2906002)(33656002)(8886007)(5660300002)(316002)(8936002)(107886003)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HrsxThkhCHp/cdOCaFj7SR8CrMrtI97OM1jb+yiOvMlcNUr/dj614v6wr3WV?=
 =?us-ascii?Q?0OOYfNbA2bHNlNa2R3JYTJu31LL9mfBLXsuGxMly9eSBICqtAQuAseGcpVSM?=
 =?us-ascii?Q?Z3s6imbCEYNJZ8+k0X64vJm1TUuYVQa/RUEDsapMY4/aYImgUzinI7Iu7X77?=
 =?us-ascii?Q?QhjSzWOUigsNePppYEMY7NeARQtckmyhuOmXYAYak7Mg38uxZSgFWz54UEOD?=
 =?us-ascii?Q?GKmSMP1P8jonxx3qHRP2RD5hpPWt9i4QKCWooUBAdR6t7GUCSIHSyGnRC++a?=
 =?us-ascii?Q?nMw92gukWmNfHnXGovampq47tBIbPfOUrwFcQvaGpaNkAchZXYKPWOclKjz6?=
 =?us-ascii?Q?0kuB03uPXYn78JqHbLSpQyXI5TQ4DeH3hghSIUWosdK+508fvdfj1ArTtFGL?=
 =?us-ascii?Q?5L0wMJrCj2L7yY7dGeD8YW8eohpK64zMzQUZ7SLEVFnor5tp7qzwhOyr7GSJ?=
 =?us-ascii?Q?lnHE1e4dSJJob2ARCtDGGL3th3P3ENiiWtboKRexQU3Ni08sWs8t9H2q8I/u?=
 =?us-ascii?Q?2OwCT+JzRpI1IolYpYA6fNcBN5vjGFKSzNcC66hjyGl39HOAFFjim3rJ4YoW?=
 =?us-ascii?Q?AoKWSAEWuqh6cGtiW9z8fX0BMo7G3K8Uc5cjfulQtCpUj9fcUQYAm4NR11yY?=
 =?us-ascii?Q?p94tLhij3DvAYTudSuPXVSFRU8eW/kZ7IzFfDP19KRU9EJXLq/Ti2FDWZQ5T?=
 =?us-ascii?Q?Aop8k5iFXRT1AcWYnJjlTjWPlvSLHw8z6piV2NdCR6wNnriZZeAd3B7V+09U?=
 =?us-ascii?Q?aojwFbWsVyYqfZNnhR98M8x8C9Nw/VyMbs5SzRvG/2qpickhCHNVo2C+pt/e?=
 =?us-ascii?Q?/qnB9YLUPJBVgQBU7Xf7eSiqm6nFcGB/CGYVvIBDbJg/lHpk7C4pIXFTVW55?=
 =?us-ascii?Q?afyHMR6ep0CtRPx/GgsL6yk3LRd5aHwQJUB+ZuJscs0pNEpLLEcK0kZOmvk8?=
 =?us-ascii?Q?AwmcpT8m46IMI3XHDslN9jZZTKVg2ph9//8NfwHmG8QTi+WgsYVOEPhu7We1?=
 =?us-ascii?Q?qVvciiygS6dstgyPyXL7LGx73e9LK9uOdJTZmLrdUT2YuSwBPZayPwpUmlME?=
 =?us-ascii?Q?UKCvcHjsuRqywYobvljurqKTVbssnb7z2ZBFqcuWGQjt28+8LGoNdOp0fRTc?=
 =?us-ascii?Q?4c0R3Iy/EhAmuC3tsuEuH4Bzspx2bt5WXIPMYNp+PL/zBoNlsVOuGG85HUaC?=
 =?us-ascii?Q?CPXEDpI6ovBM6ram5+bWTHsAo24Ig70/ZDyMU7Hn99BAqIKwleAO1+eAGKPb?=
 =?us-ascii?Q?Gwl3c+3URyIEpyTesgiKagfZOXxyKCKQGytkfda7WiyX+HRcgY4tb3JZKsdA?=
 =?us-ascii?Q?Ru9rR2AxJzvxRmu4YPEKSvg83VKlh5GrnTtody6I5Kx2Ra5RxBzqrx6xIo9F?=
 =?us-ascii?Q?mHKyRM8Zeqts7uf+b8M1izlIO3FY?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac9cebf-a43f-457f-6d42-08d9568fcd3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 15:03:07.4558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSE8MUSq+c9p+291yZ02u3qolViapjB2JtI7QbW06gkad/HAb/moERgRLXEGf4fOMD8t11FTnu4KDRzbCe6KCPdK+4Jy1eiPQtw+9csMn9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 06:05:25AM -0700, Jakub Kicinski wrote:
> This short set adds a helper to make the implementation of
> two-phase NIC reconfig easier.
> 
> Jakub Kicinski (2):
>   net: add netif_set_real_num_queues() for device reconfig
>   nfp: use netif_set_real_num_queues()

Reviewed-by: Simon Horman <simon.horman@corigine.com>

