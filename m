Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFBD49655F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiAUTCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:02:01 -0500
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:27559
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230332AbiAUTCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 14:02:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEuAGuy4ne6VsgA2UM/I1LoPZeDJgsbcz7HJx1O6d3/p3do42GGUanfYcnp7peqlYQWvFeEl4UzNYMtQ67hDE0tJbs17/N+iqDtREFojuXGeLDO+rEH9gGPJZXjy6jrmMiQHMIixRvAxnN3Zb/y2ADNpSNhNRdfHKjPBQlHcO5yF8zwciNyCSmdDIVQT2ckz9pEyRBhRa2oGYIWt741CnZe7VFMlRt7FP8bLruvSRy0N9oZVtNw32D6WyijUZSGHJDJLn4eEOHYV1Sd30Py//Z/Wun/6DQ5JqXdURsHEN9+4ycelkE18HymboKWvdRS+18t+szef0Y7bAqamXljRTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFleOHm5Hy1xolyRALbRHro3u4iLFqgJCNABtG3YFss=;
 b=Iybez2EUpdEEZm7gJ/Fi0jvXUj/l8C+BYsNpOMHwgSJ/g+p7AnWSixe8ZMai48Mgo1Zbx8HJSrU2TzYFPxf22+BU+oPo4Din+Q83tcspYIpT2q5lgVNCOZlYOLvoGbEudkShJJkhG/2zUy07K+31qmgJQt2RmveooVQtNR8p98+cUpWJPGO+4gX4ewHBqmbCrAXcHEZhB+O/4ZfNSAnr9ZFaD2scsUm6mxiL3LgM429OvA+ceHDM1v6EJ9GViGlyGBn3D2pI7ByoK0DrWBUqmEcK+jTuUfqckyMvf0ma1VS7WclpznqHssZAWCnHPpJ59mO6waQnMClHOkCBrJ+a4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFleOHm5Hy1xolyRALbRHro3u4iLFqgJCNABtG3YFss=;
 b=idchh+Em44Yey41KPjGE7sUABMzpdIS6f5LrIZt/WyCmnIseKbywg20MQ0wsF7LHJFGiQ/mx2mziaHdsjOeAymP6FiyDKmBWTom7HkcvI47MwwCcVAJIwl+bSmqcExiK0fMfUde64bJXsDU21Ss7EvgPzjAHV8tWp0CXccdSxDSCUIwcBbaIgrlblE0l98wHv8jhtqFCC3fHuNI2a0ocdDx7DE0f0mIar6UdXqz4PAtHtW8Pq6zRTmSGIWZVSRsho32E1SjBzYlpbYDxJI8Muw2fE+F4ahHQorn9mUxnB5/zIaLmgEtuFw6AZe8MOUPDxFxTpRMHVA1jMfWS7pdRSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4870.namprd12.prod.outlook.com (2603:10b6:a03:1de::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.11; Fri, 21 Jan
 2022 19:01:59 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%6]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 19:01:59 +0000
Date:   Fri, 21 Jan 2022 11:01:57 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Alex Liu <liualex@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Add support for using xdp->data_meta
Message-ID: <20220121190157.uym2zftvbegnbdy3@sx1>
References: <20220120193459.3027981-1-liualex@fb.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220120193459.3027981-1-liualex@fb.com>
X-ClientProxiedBy: BYAPR06CA0039.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01fea4ab-bce0-4fee-d81e-08d9dd108007
X-MS-TrafficTypeDiagnostic: BY5PR12MB4870:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48706920453CA2F5D00ECE84B35B9@BY5PR12MB4870.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rph+Ohlt5r06oS42ScelHUGtmUA6lPZCKRYzoz8KTG44cYBMadMETZWFYWfCTEN6PJqnUn+ckjmS1mOLvro6OqEhPlDVdT7oxKhrjuyqPwf+xOFz1MVwQIVhoaq+HtCEabR75kR33FnJvCjAUOFa8bcDbAyV8lx5V4Uq04PgZLF8iP0CtaGrDVTNS8PC/utBtj2PdU/Wwimuf19Y7C5eA3U4y6xLZoE5IytNgFVIHgm2I/o/DDhpL/DtyOYnyinJnSmapm3oG1jgmYqQ/chyKeaRARVrGuvP8AAUtrq4AE7pfUFr6o9YKS7Q2Q8ctLX8D4f6psNTe96pz8tCtL54tIgqy8OOCC4uWX9dZQNnFp8M4d/YAiEvIfvK/DN5oY4qJg2s7AMxOeQUfJN2irExF/MqLnPCqcBS0CqYkAS/qs0qCAyYQAlu9dIR2d67FPfNYC2tMlA13cpGiTSdUR1nuRQDHvz1PyWRsWBsZxXD82Kz6wW/4dZ7QsjTIOySTC8K1VV/zqRmEJqIOC0N7QuSsrsQ8fB1VvLkuHMVo4gNvWHkD3BXKxz9DbF2HF8/WLSAA/1IGb3E3o0p9R45ESgutT9Q0I4658exxDhQZkcWg8tCPLk9AyKLAJ7Zi7uFHeTIg/GpHMah4Y1bH2TgpaUigwL6Wzk6SJTUvDmxHKFmuG8zlTIAwLnT//W06QcD/KGLLebmTozDyNEEZ1+TIqHWeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(52116002)(66476007)(8936002)(186003)(26005)(6506007)(6916009)(66946007)(33716001)(86362001)(8676002)(66556008)(6486002)(508600001)(316002)(1076003)(9686003)(4744005)(38350700002)(38100700002)(6512007)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eCPkLZEcgzhHGzDn6SrxUOKtSAHYMIgcX0rLtynM8zDMswq/3SLFe9uFpp8d?=
 =?us-ascii?Q?23F7FfDWziykPXX5EQcQu5f7VsUPiKMuHx1Iw6dhdX2B6SOndDbzi8jxJTcs?=
 =?us-ascii?Q?UpMvtM24tIrH7TgGlq/+zwh0Uh5ptf/3X6E2GzpE62qwFPgSvr25WvXmKEl+?=
 =?us-ascii?Q?2Q4eAm8cCrSoE1eAjlY5vgnqTP+ZaSXLla7fuozi0v3gEuJv050oE0/xZzTo?=
 =?us-ascii?Q?OgeqqTos5cbw3HOxc14IKdYEW7sA9NZQ/7K3u5RS7N4nuDFKtEAkgoWbjCsC?=
 =?us-ascii?Q?VDAVsrXNMnI7PGnBPQCoEVqIv5appoXgu/S2fEWGWkkoiNzaLCAnfmWvK6Gi?=
 =?us-ascii?Q?YX/gpldSp9OBrL2tm+BcS5SJ7rFLZCRxByXnLqSW0ufruSQ7yq9C0UNDG/ko?=
 =?us-ascii?Q?AEGZe+S+66ILmSr6I/BkyoKxh+kLXgmaOcheeTWIs/XkERiXm9HJCXtY405K?=
 =?us-ascii?Q?iAQCS6R154BW/RzF7kIkpZ7M5ohevxJ1SRvgn+zTBavcmg66ZUxlH6kG4k1z?=
 =?us-ascii?Q?dARv4v2a4TFRUYMI8SPMX4FrNxBRuNqVpkMFRoHBXLaNj1QK28h75mPcZ5xF?=
 =?us-ascii?Q?CwPMDhYSy38DYSY6lgBFAQJ2mwkwcuIyC8KjFVcQlM8uNAGvuPZDSH5snzKX?=
 =?us-ascii?Q?EMGpNI+B/dCfbvAzviNWxp+SZxaPzdpJNjn3nxhbbK9lXm/2BUO2RHEeshbc?=
 =?us-ascii?Q?auW2ln1QSPiSeTZfckHIJSyCjzCk37KYNzzq5VoCeuJBWxC1LeRuHE+blVkq?=
 =?us-ascii?Q?ToBNgfUGlgUfTHOSclMLQWLeFRFxMX0QBet8MkZ0lIJFIRp+O4KgQB/MeFj3?=
 =?us-ascii?Q?RkMGOvgrQNuhPFeunWDA77jPOguaPO1HUYT0wUUWQ7SqOfsNutADnvvBKDcV?=
 =?us-ascii?Q?xam3mn/3w5CGlh1ZF8mb6qreB2zoOnpMSbXE01t4r3+MDhRdW7OzXG5CEqAY?=
 =?us-ascii?Q?UWaEzFJdSIF0TkcwCOIkLwGbiTuXX6qZ/E3H0ctzEUKmahLVPZ+p1ptLHLHo?=
 =?us-ascii?Q?kffo2zOekUygPlQ6gXw2Ma19FBOYLgy6pb7ZKb7AXgHzct+l+nPatOCY3o8x?=
 =?us-ascii?Q?eVNfOlsLDRTGc87RmdT+VCDg6KqI35oQxJb+8b4FcyLYUkURCRlDz/NrO24w?=
 =?us-ascii?Q?+FtbRr226HIL45YoDHTKeUDoUoAIQbRWHt3LJJ2aYY80rQFRnXHnCo1hILdx?=
 =?us-ascii?Q?A/WiWdEZpD6wYEFWRbHof7q+pqWT3e3O2EI9Tnr5N9t4mjDqKBbNN4frxO5W?=
 =?us-ascii?Q?YVEPtKzkSBbq9LzzKLhMhZDXHioYK52oV5AMiePyg5yNuI7olYoIQO5Aeb3u?=
 =?us-ascii?Q?tOouAdiLA1FqdZH6cNWlnK0eSGa49qSnYJ0VybcW2WIcSFlIGF9uVbTZD7y2?=
 =?us-ascii?Q?oTvz+k32I548KdTCCQ/wc8X5DJvUtyOLWdpy1puHVgY64ebtl456y/o+YH2/?=
 =?us-ascii?Q?Wf84yU6NvYBvqh5QY10kjXAnhCnDaV1Qbozl+p5Cy4n/1H/k2PiDqDdhxnuf?=
 =?us-ascii?Q?NtmvUq1/jlDsDbisyWhw+rxbLr4Tk3b007m0u9cyIwoIncZvhXsdOTm3+E0s?=
 =?us-ascii?Q?OAEFgR04s1gFo5KGMASUHkFypSy/ChBG3VdxVU0E4ZCVvSDwgO9aFseYMY2D?=
 =?us-ascii?Q?oAi6EC8Qucc286UBu7IpQ7g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fea4ab-bce0-4fee-d81e-08d9dd108007
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 19:01:59.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksxl1zVWNKr989BwtAERVIwKsJueFQxxozSG9xvNzvnoRHgx68kbHS2q0b4qbSBrh8LV515VVgGzkaYoDfXMYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4870
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 Jan 11:34, Alex Liu wrote:
>Add support for using xdp->data_meta for cross-program communication
>
>Pass "true" to the last argument of xdp_prepare_buff().
>
>After SKB is built, call skb_metadata_set() if metadata was pushed.
>
>Signed-off-by: Alex Liu <liualex@fb.com>

Applied to net-next-mlx5, will send upstream once net-next reopens.

Thanks,
Saeed.
