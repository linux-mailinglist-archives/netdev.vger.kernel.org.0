Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0119D4C2053
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiBWX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiBWX5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:57:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC473B2AF;
        Wed, 23 Feb 2022 15:57:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4FqT0c8XVN7wQ7ez5+ZGNCkehYBMzqd04Jd0zUnG9ZEedGY2/XVhhP6R8mzNP2RHAdt8qBFbmDDRbBYqOMfRa5aKWHrpKqBH3HPLw860OYtFUOuhN0+4PVMTeZ9hnBVeJR8DnJPPwT41ySadesbpGorJJFVPiGEt/ra5ktfKBWmE+PHukTdpBnJwHF/ao6x0eOTIBptoLq8+EDuVq1LfyC6Vtvd3KMFz65jf0d8He0BhH1dHTcD5pjx+8EWzSi3BD9c/Q/X1+inJuekOBlDkdwSCefg4YYCr2WWqFGlP69E9v3FPFBqfjfEz7PDhHFKWgXPq1WWpRqAgTYPCwFyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od/V/1FSbGifyytfagwbq9AvfLNFjxN/VPSSGx/OJ7o=;
 b=VfklniUU/Zii5+dAN3LIZ1XHGehyirC73alT5Y/bFVazqlgxZ/kIUAfOZa22eyS4nHPKEbf0kUCagKvo+fV8bEVjczJ9Uz7jhXrdMoWE1vP9bNmTFgS8Tp/pPMT6EZbMk5S/Zd2pUbTVBmnyg3wcnW/VFQQVS87X4EMXijuYPtlXMEtE+aLuxlAJwa3b/oA85hqymiPgmyQd2nb2+DQF+Ik8OP44AfrHgDGup0Yk9XIjD7q4+AfjA4PKmjHyJZIu3l6vQW3/Y+BJHrjyDhOhWOl85Mg+2f7K7+yco5fzXm4VO4FdIm+BmCGSIQDsUc43844HhDLKJbfvlixD1nEWQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od/V/1FSbGifyytfagwbq9AvfLNFjxN/VPSSGx/OJ7o=;
 b=UEzThvUpUjGq+cONqLsAfle+H3B8BXulVxZpunEQNJsnmq98BkL7sj6HqIoyr/xkWF1bzOoivlIS+Y7NRfUfyYIYw2yPRs7zjvBoTZ+iUHXByeoppqelpJ55sM55iVskIUKqUJBcyedp6+nzT7PaClfrq/aXmWflbjPqE9/qKP1qb3Ejeidc4KMEp6IVgmfpknZV4JeP+XD/YJTKnWfmYlChO2Mk+FcGBUjjo2NinrE1t6hIpfiXsFUwg9ePWZEeph/gmo4aEKhlw0mfs4QG4l60FYdZdzynW9X5hh1k/nTRqJ7b3yqyhl9vm9bcml+LPVkZzgkSatDd89JNrUMUTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM5PR12MB1945.namprd12.prod.outlook.com (2603:10b6:3:10f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 23:57:03 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::fcad:8c45:be14:5a49]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::fcad:8c45:be14:5a49%8]) with mapi id 15.20.5017.024; Wed, 23 Feb 2022
 23:57:03 +0000
Date:   Wed, 23 Feb 2022 15:57:02 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [mlx5-next 13/17] net/mlx5: Use mlx5_cmd_do() in core
 create_{cq,dct}
Message-ID: <20220223235702.ytu6fqi4shbk3rnk@sx1>
References: <20220223050932.244668-1-saeed@kernel.org>
 <20220223050932.244668-14-saeed@kernel.org>
 <20220223152031.283993fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220223152031.283993fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BY5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::46) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ddd6134-a9db-4896-0abb-08d9f7283096
X-MS-TrafficTypeDiagnostic: DM5PR12MB1945:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB19453A8AEA66FD01E334AC1AB33C9@DM5PR12MB1945.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZaXff13b+M1ifGwcxY23Y7d7GPIAr5NQ3PlBwL2EGO7dODX/fUaiXGwyURdcHmubjW6tjdH7d0FHzlDFc3M2t3/2PtBuW5yoi2ZkYQqZgvkmqukIGV9fzmO3VvltAONnkdnmLzjj2ezTUuTis0nzX28dV6T13wl+tzyssSj1FrCl6CRc3FTZD+OsyVP2lYZ7nqRMRZXB+Q8LrRrr1viWbF0dsJdraF0brDrb/ZvmEIVPWQDEcC91fDg3oq/g4IX5S+X9+1FIhAwbdOhwcThsfKgDX5pGqMghsv1GIwQLMyCAVRsNocLGpYDYkSl47QVlyfUMF28Fn4r1LY7/pUkC36Fku/QCSsenNJ2nrrSopQldHSNuYagyTHtEwmKGelO5LQ/LkL8Ew9K9UEEQBRxvm1l48ohALOO+k+5rjPNhWnPkCX/sFFEhKIsWA/VHLjC43iinKBY5L4JaQrMWBcM63Q6d5hcndMMXjWohDEdZQKi5Mn/mMy8ZhuPxePiaQG7T6G/wS+ZOzK5lzTFtist8b8D83bsC3hUStaaxgMyggLXFOlJCrqhVNTi8lK2e/0oEYJt4skxF2DscFjZAeddETQEcFquTgnL0QkRcqNHSbYS4xS9sSgQaHpKFZmlOqrRXwyjV9JLdtF0kJPDnqyvhwhD+QqtiCDjN1nk9UXiv3hp7LnE3y15TruhJbtfHcSEwhw0M83bg5tpyDreiRHEdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(107886003)(52116002)(6486002)(6512007)(508600001)(6506007)(2906002)(38350700002)(9686003)(38100700002)(33716001)(66476007)(5660300002)(8676002)(54906003)(66946007)(6916009)(4744005)(4326008)(26005)(8936002)(316002)(66556008)(1076003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?czq9ekkIK17YG1tc5rkXgLOhLRh9cPqZDpL+Q1i27yAlNNG+r+Jwcgz4kscb?=
 =?us-ascii?Q?5jQK0Bh3LXnw4C7BB6XM4TqnLA0b9MfA+r7alx54rxJ3Ht+HFe8FKo14G67G?=
 =?us-ascii?Q?nSd71x5XRlzDuFOGmUwycBBkEmCBVyP6feBRrIt0TzeGwpPRjdHLRxwwfPuT?=
 =?us-ascii?Q?y7OdjFouN1c46kMBRYVeAunP/ap0HgppD1HPUFS0/XaO5zmWq4DXYiNMxxW2?=
 =?us-ascii?Q?0Rg12Ad2QavEmienbJk8r3+hRQNEdqQMDKEtypwR+BjEstQs48NzH8GRZMio?=
 =?us-ascii?Q?qkX3qONruzB7l/EXZ5U/PHZVZWpxLI/EoVNKaJa6gNVPq8AuT6Rh7X1e/YEG?=
 =?us-ascii?Q?l1sRG0qOZ3kyeaHtaNUh7HYOhbU9+VsBkclGXbN2M5ys8awrsFEluTOEn06b?=
 =?us-ascii?Q?N1nsHLwSggnpC0B1ENvzUR4CIyYp039THEHmndppLSDCLDNmBIZLqpAFijsh?=
 =?us-ascii?Q?kVUejCkY5KrBD8p+WR7NyfuZ/wnmm/TuDL/ahSp+a0EfidP5DwLE3MwTzc35?=
 =?us-ascii?Q?+CSHPhuG/bCrjo4zYvfhjzfv2wwnrIA5znPCMHBCsNroq/9/8tUo77kUmFTQ?=
 =?us-ascii?Q?BEmzNcZuKLagK5vQ4CYc3Ub3AUnTUH7e8iMU6PjbAonoGEAiiB1rQgbJ8SvP?=
 =?us-ascii?Q?ogC9fr2rgd6YT+m3vvNE+KaxjgV47lQrzMEEXSCm6RovZy5BKjkTeTkRAF2q?=
 =?us-ascii?Q?ri/+Kun0v7N1br4FN+r+US/0yljY+UpTlIOrfZpxt1Ag12DkqwTBe79TCyTt?=
 =?us-ascii?Q?EzbOWsnoJCkElKHcBqeuKFyqOCIacz4JIOUDU/pQcjpV9097hAPuL/y6J2w1?=
 =?us-ascii?Q?bYZmiQQN5R2woi12v5qx3n6nWfH2iNp8Xn2zbwj+kc19LqoxHZ8xSlabP7HS?=
 =?us-ascii?Q?ZMAwji2ccp/Yw3wzitdrfCXSJRz/blItG6OCenMgMNhfHP+/m5FZbbS2mQCJ?=
 =?us-ascii?Q?8kzLRmP8mQPavZZ9Mtvrhtx2/c6EWs7S4uARfsNij2TGe19tpcROnF+PB5pD?=
 =?us-ascii?Q?nZI+bJ3f+YPa+dR4lsp+TkEZSe5K98xfDwhSMbFFFLLhd9lZtXtbnYV3ekIS?=
 =?us-ascii?Q?DL+1C4FBJVLm2ax2JCKGYVkCRaolcvRxWb0LrCXiE1v31MBRM/NxiKIO9/vu?=
 =?us-ascii?Q?vA5n1fEJky6rYkEc9j1BeeFMq7PCqvOgDzY89M0rI/u+yEA7gt5ljlIs7NAa?=
 =?us-ascii?Q?vqchfDg/kJ/zraMrOC1agSYXZ7w+forGHFNSyT3grJwCijuC2ayWEmyAf2fy?=
 =?us-ascii?Q?Yj3qXt7DCgYoe6seoOSfYAS/9A31xq9Luz07QbPbRUJNSGt9zAi/frQ5za2v?=
 =?us-ascii?Q?rFa59qQK1oHL/YkgLoB/inr9WRfOtHiZkRvA5ZwQoJQNbmojpoHXNFh/YnI5?=
 =?us-ascii?Q?0h7/U4vJeZMEqXm236B13u+TC4cFJCPpRqliL9OqZIyozf7T6f7xa8C6Grx7?=
 =?us-ascii?Q?gb4sZ0kzukV7VHw5nTCLRTcQXLTMMPODrCmxiiQVoByuoyheAUEwfFMa2CaM?=
 =?us-ascii?Q?XGtYB617IKs/Zx33jQuDP+YrSo+tWlZmhrcTYOVyooCPL5nev71bJVZExjGj?=
 =?us-ascii?Q?bKxOEkODe2F+JIAHAARBmtZlTJww1FKW/P2inwM7FSGetQpgXOwpZbniw1lm?=
 =?us-ascii?Q?3SvAk7hqEo0oaugou+cQMiA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddd6134-a9db-4896-0abb-08d9f7283096
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 23:57:03.7714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0W71rJ74I+Za/LzELvb/V1n7aEqI2H+6lTvxBFkB6NkrZnGgiRgqbtDrRKGBC7ycZEUgUOx2n9KRduvj0gByQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1945
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Feb 15:20, Jakub Kicinski wrote:
>On Tue, 22 Feb 2022 21:09:28 -0800 Saeed Mahameed wrote:
>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
>nit: double-signed

different emails, the patch was authored back then when i had the mellanox
email, If I want to keep the original author email, then i must sign with both
emails, once as author and once as submitter.

The other option is to override the author email with the new email, but
I don't like to mess around with history ;).. 

