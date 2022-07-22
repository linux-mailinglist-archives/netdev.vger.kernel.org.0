Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6753C57DF34
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiGVJnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbiGVJnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:43:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8750E1D0;
        Fri, 22 Jul 2022 02:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UACXUeiC3Fr4E/5PFNNGji52V2g+pO6XXRHsNYJHNecFx+LenzkpGYF0vrJrK7aBbynFiFlhIezqiLa27Rqo3or2FfhclQnZVWQkWN2nZrMBdRroUffMXh29PpL0cM6Rllty9knu+QofWZnA0P6e1oMjqSXsBvWpzsT2rdi5A4iHnx6UX7UyXg/8GvBsQCHX2iXTMnDFNBBdHhnG9rIJKECVNYiKjAr1WdBdqG3KE8sHGIC0TJQ2RhJtdc6wg34k5z/drSScglLprTv4zUMJzmZUCsn7kV8VC5lpCnU3xW2/FXejFVJkL+QeJnCNRRjIvTJvcyDoTktPMaSIJA2ofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkG0WxWYxOAEi++qYl+06aMsrq7I1a2qzoP38jfk8Ts=;
 b=PhyMijlZpdjTuATyR5K7QQQ7wzOrhRhCZQAk5RVN2JGSQdKWYjmZeTshkX1F6ImV+/cdSUVwS+7LLd7qEwqtL1u8q84wX9cFELMyZg+qJCpXvXbLuEEbfMANJnE6QEKjNPuHIs4eP5Zz1pxSwIZUyYnAmpCf+wxr+aBfunSFbK+HjtGHSmcREZOtzbkUzNvBHD87+8cFuKdgEsdBj9Xok4/8L183CouIVkmcwZ8HDFVBv8TD/cK4Z1kRZc0jRLV/qdmvLamk3F8JgFzsXKjci/OPUFfA9cxZEE7egmUT2MmFoqJNeb5ysuU1iylUe2z4/2Ds0dCKM/ZoyVkDZosR8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkG0WxWYxOAEi++qYl+06aMsrq7I1a2qzoP38jfk8Ts=;
 b=RpJr1grnEhND3zTU4JNyKVluXeXD2Wy2l0V1wytJWx5ELxCxG60CfXD4z2n8wNZx3GHdMGkpfE49SnDe1s3c7QT+Glfq8mgf3XFGZO7iNeRjtqww+lGnAMgBdMhjvQLJwRAaB33QNAtG/BZN3te9vgAoxiq78XX1uX1nKhD+fgq0HO9aBxQGCpeQ2PD86T8jOmMUB2yZXyVdiUMpR0Q2A+SFh0WX0ZaQYQ70oKD+1M2SRJCG5vx8AZLRBKuB5T+KDo+9lWD085Nonq69l0tG1gcricpkML3hyTrUIcrf1YXy1oTmNzp236rDfyUJqwcOoKu3Jk8ws2jNPu52veqX9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 09:36:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 09:36:41 +0000
Date:   Fri, 22 Jul 2022 12:36:35 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: fix devlink use after frees
Message-ID: <Ytpvo24UKH8b0KXG@shredder>
References: <YtpEiJz26qVoZG8s@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtpEiJz26qVoZG8s@kili>
X-ClientProxiedBy: VI1PR08CA0181.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28ead47b-e58f-4a97-9e53-08da6bc5aefe
X-MS-TrafficTypeDiagnostic: CY5PR12MB6597:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3RnB7BTqJqwMUUDr/oeLREQROhfv0Inw7+L7o9qzpRvqdFx8tCiB9pVCYUbWglJWd+nS8EiVgVFt50djtD9zcxrj7M2A9ldUxZ5N4eW2dBuBy4/RCEN8yh/lUEQV44UpAnPXZRLYCOJhcRyMTLBLPWo0QUKCIYxm8zrSiOIW9Fn9zPiyfyyL4JE7Ac9ACIvCDbR1wCjSmebt7zfY8P78Y9DYyiIuxGI4jhDrZanmXW4uyn0W/L8t99vA5oRK8JBaczJLFxNJ4UAR7t3vY409iVI5UhoNDJ2p9Tzt0ViEm8xtkjL7SU27kqv3Yhwu/V6ho79DyW8vT+ztmGW+9yf7tiZsOzYNNSSllJWhhKDUVw8xV1zINIDm/O2hfCzQ4f6x4U+dWYtj60j6LM5qv9qYFSEBwHpgmSbQIRcndy7zBqlV/yoPmmRR9gVXloycUmQNAVLDHTNsAuURnFILGuTPhlMN2V+umAF8wfw613DQa6S24WHlmAXcZxuOuZgnjdqRGciLV6YMK7Pc13Sk3bjJo6VHuu/LZTQrJkGjBUHe0eIwOx9CNbfnQZOXTg/+WYpL57uxDVKCPG5vHrUQy9wmMlXjfd632BV1z7wNUmAX3khwWFuKF3whR1XUdHJOGUpem1nUFE8eVF4B0APcNg9WZIE16xcs7sMK68O9/O9l01DWflPX0m4Zv+XOPQadXPhGv9SDqZpy2AfEpjTZmt+ycwNVhBQTrdO7CvTV/W/d78nU6Yo70MyBhzDWZJ7pz8ZLXf1+uyJ09NeoGUAHUBtOf1h4uO6NdzCkvobZRIDbYfO8vrszyvBjajrEDQMCimQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(83380400001)(86362001)(38100700002)(33716001)(478600001)(4744005)(6486002)(316002)(8936002)(5660300002)(4326008)(966005)(54906003)(41300700001)(186003)(2906002)(6506007)(66476007)(6666004)(66556008)(6512007)(8676002)(26005)(9686003)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vqWDYsUcZZm/PFWaqOPqZ4/70olMRRjS1s7mE+sGShpqNRFqIHfCP+93UF34?=
 =?us-ascii?Q?JGfnu5FSa9fvZ/eIP9tX0oCvm/Gy3MPMWDt1xb/qdgIJZdTvJ4x7X/fuJiFj?=
 =?us-ascii?Q?MaWb8pGyItZwXRwOZN0KSe9i9cYZNwewIvQvV9BtuohdqeKCvfSJyyS6H6e4?=
 =?us-ascii?Q?Moq0j9bFzDMX0JtVO4uvdNF2g8d6EHjy5depymtotRazeiLfS55h8+LJSlWr?=
 =?us-ascii?Q?4/nYyishwzFnUJuVCPrgPUnsF/TZjy/MuI24qaL7JMsrn5Pl9OK6iaM7GANp?=
 =?us-ascii?Q?6iHVvsda8z0nnvFAanH284gkhdy6yc3tSaxBV9EX/3QyIhjL8DPKv4R9B8tT?=
 =?us-ascii?Q?47X1RhICk9JALBmlPiIpfXFbeU7Lm2pzsz3iY5jUqwY8xmnNaiMr6bP8h/D/?=
 =?us-ascii?Q?aQH4Zllg646EUgsWP7RFy24kOAj4DNjbEkV/H3EBGTyC8RV+o1kdyr80nVOb?=
 =?us-ascii?Q?MFFKcmI4rLW/pzKeO/MqqzwHhnUTGpHn9Rvg88vRt5wixZztziIRchzxvJIt?=
 =?us-ascii?Q?JjQW0y9SLic9ZzTgzPiXAXNwwLO194QRluq/CK5vRybsXLKlnSMOl9NoeaHB?=
 =?us-ascii?Q?TY+XBZuegJx+7cuOn/NQPMljiitB+WPrqZvMzRyAbTOvLpPASbHDnSBltEzH?=
 =?us-ascii?Q?8X5qppD/J9l8S+T5AVQ3B/ranjAijmiHxmz8iGslePNtt0Mv8E/rP8rd+rrA?=
 =?us-ascii?Q?JjCBwDzLOxPQBe4nwPrvBohYD4LVwuzyidrKpIBtpcEpP/3BSiypFZm25L1M?=
 =?us-ascii?Q?YIRTcsog1zAzbHlMsqJPaASfxg9IqUGitb966lfJo++HHtQm531FqIe8SxKd?=
 =?us-ascii?Q?C/UHvTFCtywVNkxgXwf8nCTAXlKxjCtEgX6PH51leEhTYp+Hmt7XDGWC+NXk?=
 =?us-ascii?Q?475/s7NJvcrr9X7pU7q5Jgf9TgvbUA6C5118Yr6Z8eC+Y6gBP80TZBH8yPOy?=
 =?us-ascii?Q?x4GJy/aqmf3n+MINeUSCw/XYmaftcgCwNUBGSU7xYazij41DTy/CVmkvmuw7?=
 =?us-ascii?Q?21NljHK8UTz87mzD7J8CeY1DHrEQjwF+KbMgCMImesOaMc73OXj1GnHqZgn1?=
 =?us-ascii?Q?mKi5ZR2PDJoYl5YemJhS8ONSDEfZl2EkPeW9pvN+YJyN6nrx/5vkfZF2s6c6?=
 =?us-ascii?Q?QyfsAJCxpXvaKefLNkJIavwLOQzLQrB/YyEbh5CEhUhu0xBoNHsq2MK2364T?=
 =?us-ascii?Q?mUJ8zcpSlpc5SNk0gbIqNP4pbSqeosgYcqRumnveIsoV4Sdv1+tsmVO/OVIi?=
 =?us-ascii?Q?eUZsE+RjymwQSq2Auz4cdXEIvrWHgGyYvJUza1Kng4yx7GbzAE3VRlgxGkaq?=
 =?us-ascii?Q?BEwqc86ShSirSzs2MJrHVeftxF1g1cmWuj2kfn/p0yjuGX6yGcd19/LzRw4R?=
 =?us-ascii?Q?zajg8GVFxr5wzAXPtizZ16GqiDGvTkJPhJNdvhKw9wXLJOzn4ak/YQgjIkTt?=
 =?us-ascii?Q?KIsW3d+IzMMbnKyywax89NSUM2TdbnvK5O5KKXyhejcmnQcEI25MRI3gPI0K?=
 =?us-ascii?Q?3YARzYow9+peKO63aUQNc1LKkKiABTqcMe8De3MVMPjBtOsBJ0BZCVU5XUn2?=
 =?us-ascii?Q?m8uom9P8vDVH4DxBfUnF4itsQwGkzR1GJgufu5Fk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ead47b-e58f-4a97-9e53-08da6bc5aefe
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 09:36:41.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgKfZWNJfj9BTAEwsYXO9Bqvpbg9iq7qGOsk3QxAykWuv/xnFDvIzGN/qXGvZRUhpxZVqTOWUUW0l5yKBq51WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 09:32:40AM +0300, Dan Carpenter wrote:
> Unlock "devlink" before freeing it instead of after.
> 
> Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for the patch, but a fix was already posted yesterday:

https://patchwork.kernel.org/project/netdevbpf/patch/20220721142424.3975704-1-jiri@resnulli.us/
