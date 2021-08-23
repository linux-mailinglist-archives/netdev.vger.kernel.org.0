Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395C73F5179
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhHWTpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:45:45 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:31841
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230506AbhHWTpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:45:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7QeA42woW9InPCMgYy4lUCdlpd4zVn0Hs5t5Z0i+b/hF8ElXV1zOx5bruqweYjSutH/rONKEQkDy550f1Ffy+WMylVK7YKvuZYkT+ZIT+Wv82iWbYNlOWvC3OaBTCd8/05eIprwVJ4cYBoy2DDXh6/MeZGswHtNZcU15CnV8Oii2lOB20ciZOQBUiLcl2Fhs1V7wg9/xcgdel5uM7LdKD5IRgA6Y41djbqyI2JBhlntTZPHZ3z0bFaQ/gx8j8gfmb3xooyRfW7vfaLdbGAIynSe/ZoAI7AUopbR3XbuJJ9kVQmHHSN1kywwHJobYuZMaY98eAfe87ly4V+9dmagZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDwWtKvqUwIVZV04msXulzd2L5FpIMS0dugyeNdMWbE=;
 b=QceCWUniXqVQYP5fsHjqX+i5lj+Rsu52ujUSMiW9Meosg5NXSO0Z2SYELaD3IZhVjkVYNPpQM6D1BWAO/63LMvBo3kXDpD0tO85E2UPr24qVplWoyOjnGfggis172D37as6UGMjqtzTAtSjdbMDbRGdc+a4G/T8eXOiAaSzckSiiIJxgtDPqrbuVKlNcgBvOIGXML4x5Ikd5TYFzKH1LbQBEEP0QUSfRHdG8kXHio08qfoeTAZKsbr1YlnBtE19jgDlJTd//mYxqPAtREkSDrPzMx+KMcRm1ooK3b1nZFdVOHLz9L7OA4UE1MeGB1x4qvYNI4LQTFVXxIPyE6pt7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDwWtKvqUwIVZV04msXulzd2L5FpIMS0dugyeNdMWbE=;
 b=FqXUa2SCYJCI1yVZaIrL1mg30HovMsKJHs4Ik3/LjR8AAws8MupGFr9vL201HfXNWLEwsI7dBJqHpP8p3QWNNH12U9BfK0PR6TfBvBADKK81YAkpDZ37rSiKTVoHH5/BZYZeu834qaCvfVjXxgh8ckAeX5SgXBVhbyM/f1S85+pUURQTCTg3TR+8kP/azv0yQRBnz7AwZ3Sl7eXiCtmjdXQRUU6+JYJLBU0wIxAB76NZx6TP2Ma66R8bL8OYuh/ZG6CWvyLljJwRs6lCC7t5TlQ7w5485IcH+7PGI0vbMSgwkc8Ik5dleQsvv5SBMErqQ+ElI9s+BxuHUzqTJWu9kQ==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Mon, 23 Aug
 2021 19:45:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:45:00 +0000
Date:   Mon, 23 Aug 2021 16:44:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 10/10] RDMA/nldev: Add support to get current
 enabled optional counters
Message-ID: <20210823194459.GC1006065@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-11-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818112428.209111-11-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:208:e8::45) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0032.namprd20.prod.outlook.com (2603:10b6:208:e8::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 19:45:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIFsR-004Dwi-7q; Mon, 23 Aug 2021 16:44:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5cdbca8-83a1-494d-0dfe-08d9666e7e5f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5333516CCE8D99A1BF0039B8C2C49@BL1PR12MB5333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9FTTmzVGXqWnKhAZYqPx9673AtR1NOS05h/00BCno1gH2er3VdHV1z3LxL27Fm8QX0it7KKVD6l8pkj2FCU6BXaCw7acCC/h5yq5i58hBYPN0lBl44wZEvJsq+aFpRi968CaF74/wT94Ctz++uUKbulSmu5RSUYecs6mEfkb0e2/r8lAQ9bGLqUEYgX27zeIL7DPyhREbfT4aMJKXBdi3dxJEA+wPFXmDGTG6mav3Jfz4J88bEU7KPLOJQ3oRV1leGBYgRnFNmAj/bTWB3V4/3DCP0PADEssNb1fAge5OPD5RQxQpflpPDJDo60jWdOZHrk/3RptZ58nhBqhDkHjaUuO/1WKjz+WSbQYtYvYiMYXd0s4iL82zDfSdh0Se8zhvgTmcL4DQZqcaboVpgwt2Q/kgSBrIruIWog3qy5TUtV3Q9JdteWBoe0TuJIsQKxm5uGuYeDFBwW1BOIOpXu9UwYMc4r+k8+FfxS/mDCoogwZEU1Bf6NErf3mNEmFP+fHeQCy++2Dgsfue8eQkBRTXp4GxbQNoHSjicxhoQxERhBo4NLGMsRwXUrQImKwpxI84obJsSQNUL9bj6PMHceFgOe8CJO8kG1Cqn8Fc0mYfJhEHAMWLIadpvDNyKNV8hrDbE53ZFJUi+m23PP9CETBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(37006003)(6862004)(5660300002)(316002)(4326008)(2906002)(478600001)(1076003)(2616005)(6636002)(86362001)(33656002)(186003)(36756003)(4744005)(107886003)(38100700002)(8936002)(26005)(9786002)(66556008)(8676002)(9746002)(66476007)(66946007)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?grSp1ooEE/W4nva/dkfTXVRru/3WdEdDaKjo4IScKEgWNaVNBGbo4g9DP+s+?=
 =?us-ascii?Q?LAzTxcb+vLa2QLm1hQIQNCxt72TdIPFa+rOapdY+6dqgUhsnDAVxkz6Zf7RL?=
 =?us-ascii?Q?tbkg5BPBHsJQ+SW+p0yH8h8woa8OyTFdtWOOdu41823AWmFLFy/S4ODywZj1?=
 =?us-ascii?Q?LZZCGWnUdMNYorjxRAA+mXMwY5LXquedxjDeRDZEHked7I0VyartdjrFgMd+?=
 =?us-ascii?Q?BjAIJVnaFMnZ47+HdyNhdwVHpPQOck/G1rYz/zZndzRDCHKLScYs/0tv0kp8?=
 =?us-ascii?Q?+BYzxhVR3INYZ6/LYYO/ctnaNru8vo7BG/FU2PIivi83UoHKexzXJYkfQmRo?=
 =?us-ascii?Q?f8c6zGlepJKCsOaz3QHujgH+uo4ipdIHFH48Yrdprn7UNGjE6saoZpB5xgez?=
 =?us-ascii?Q?OzENmJFVFIfikGAnE789d4s4SjQqDajFMbgL3N/C23+l72CEXFY6ZdDHjeBs?=
 =?us-ascii?Q?N1OOCoaAf948zc2Eueq7XfUaKiOCYinIy67cBQniWK0AWKc0THOwL/KUi9us?=
 =?us-ascii?Q?oteXIg6gPuCIvBuwAstLbncZM48VkRd5Fm380vLfJWsxL0bvM/xgRrvuKZ+h?=
 =?us-ascii?Q?3uWhQvX9x5ZnSBiVyyNVyO3Bp/NQtb7hU79aqrqxc8lmiik162hE9561l6x/?=
 =?us-ascii?Q?K/lnTiTfEw14rn32361rWFVEyme10hi7tio7ZEC9TvHjLWTw7HQCtyKiziAG?=
 =?us-ascii?Q?4L1squbcfAbkkcLnLzRjiDHIriI3o4279EPUmXb1nlojFJKZAv19LkcIP6+G?=
 =?us-ascii?Q?r1TUitlJWNvQ8t2yikcTjaDhfjZ80iVVwZ81j8l2yV4k7u4du9XIJYcpqJvV?=
 =?us-ascii?Q?6h2puzNT8IyQOumlSlC6DxSmczlmALw1hQEJdqgacdQibA/QEfFI5NmHHC8r?=
 =?us-ascii?Q?ISfgSrSdlBvsAfHvabw1hI5NXPdpxxC7PgH7rBDL/4R77gCrJZXDODMYxaSF?=
 =?us-ascii?Q?ObJCKR+2sSlIuscRQbs4DRHIaWCe9+p2PwarmH1Kbssm4Y8E1aA3mqRPOa4J?=
 =?us-ascii?Q?4+jwVSG6OThvzPhNsN9eS3wN7EzasGVRlTVlF+69tKZ/BNGUggQArkkJoDDO?=
 =?us-ascii?Q?1rMUSVl+DUKKE5zAVLxgWWpLtDIpw9rcv1lqi7neiVn9xyuJcKQkpUQlDEa9?=
 =?us-ascii?Q?G5AujH0VrQD2QxEpZGNOstTCNCjRX6ufEyef+tMNFMYQrjUEylBWT9kfXl3d?=
 =?us-ascii?Q?kSeh/oMv+ddNAunSRnK3+kAbxQop+yk+k7/6P5ocwh74cxNvWW8VTPVbCjq9?=
 =?us-ascii?Q?AIfEcoD6ChSNcSLHrSCtX4/rRZqRVxphe6PGShMpZ89/UUgsLTUrCZHQwlQ7?=
 =?us-ascii?Q?rDSA0LcXwoLt8TiyxYdy5SF+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cdbca8-83a1-494d-0dfe-08d9666e7e5f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 19:45:00.3624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSC9zGBkKDAhwKbqemFY93gwRof10rahGG2U+LGqRj7BvfFtzqaqmu05jzIK2LQr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:24:28PM +0300, Mark Zhang wrote:

> diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> index 79e6ca87d2e0..57f39d8fe434 100644
> +++ b/include/uapi/rdma/rdma_netlink.h
> @@ -557,6 +557,8 @@ enum rdma_nldev_attr {
>  	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY,	/* nested table */
>  	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,	/* string */
>  	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,	/* u64 */
> +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST,		/* u8 */
> +	RDMA_NLDEV_ATTR_STAT_OP_MODE_LIST_SUPPORTED,	/* u8 */

See, here - shouldn't manipulation of MODE_LIST be done by a normal
RDMA_NLDEV_CMD_STAT_SET with the new MODE_LIST array? This doesn't seem
netlinky at all..

Jason
