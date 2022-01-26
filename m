Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A36849D482
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiAZV26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:28:58 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:13952
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232452AbiAZV25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 16:28:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abUeIqOHOLBHU9TyIbDmpnSmH88zcT/RDxFk0lfDXA15sPBrCkqcCLk5csxCg7VkFvC63csuLAXcSoe6/NqXzakmCOzgCpE2+NjnA/jaM+Z26+auJrBVnyiLsASwz1EGmdpmV9epifozlt6G5hNBKuNcZqWsAMaiqfv992ovHadOurMqhV3rEOWP5YdSXkk2Xjd2VKDEoZJc06PucAAvPsMQf6e9T4IZpGrOVjq5Cwx0ylYVfQC5LFnGZkhBBX5uSC5p/0HqOdZV2m8uI1EnoBmCcsotzrHdjxhcGkrodMz2JHjwbE0A4tB7S42lgz/myhj48o8rxOZCHJbUKVDewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NP2bJthyL9CJGkz8ipJbIKyMnFlUK2mZsZfUMaludo=;
 b=BxKLzl1Th1w+K0X2Ilz91JcS1DIdkBrlLkpf/zyN0vyBwScCv2DaMA3QNRJfvNcra3xLYkCRg9SFKhSDUqMSj+f4EpO5QaYf92Bd3ahQ+8fGxp0JsZHXxumFQu5CH63RztANz3VLFcZ1ef+Cq2Lfinuu8fTPZPBfLTBygldvJYqJXgMRVnHku0FVbertG7/Q73+uXU/xBGTbxOew9pvVm2fg+wXwkcPneKLSxfSawgxYApW1a7jOO+woh03+zCbEKo618YVqeEyiagek/WjXppO9cf3ck8PP8Qd+CewCS9l7gtzhpMX6R1aaJNOCHSw605XHfYs42pS9QwH6gqzI2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NP2bJthyL9CJGkz8ipJbIKyMnFlUK2mZsZfUMaludo=;
 b=P55Q3F6q/74dhNTKRX5jE3Ru58i3ssfe87Ax1MFiRJH1j+2Kyp4m6+V5hxFSqLzgKtVXtlz9aT/gDmTKtRIKsCceIdTHST+Zu6FGjSSXzVdsGPZAEUzvZB7HRW/G3UlaW7kBGPtkQWB1tRTyM35aIUQvuGXB6uGHZVdbxiARiP9mteEoKcZRLKORv73Ey2SNVc54AfKTvdB2aPNIPA4d+b+yQb9JpMcDvaFdfx9M/JRrl1RiOK6uUdw1Gp7BdKx21CAqXCFr2rl6uY24JObuPWg/6D3LcUloP0DxrW0XJKiArlPwK7e5Y938msyHN33Ljbha+4IxyVkidcCvbsIqeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 21:28:55 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 21:28:55 +0000
Date:   Wed, 26 Jan 2022 13:28:54 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] net/mlx5e: Use struct_group() for memcpy() region
Message-ID: <20220126212854.6gxffia7vj6cbtbh@sx1>
References: <20220124172242.2410996-1-keescook@chromium.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220124172242.2410996-1-keescook@chromium.org>
X-ClientProxiedBy: SJ0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b258e0b-9b82-443d-677c-08d9e112db1a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB346534AEEAE88EAEF3A8562BB3209@DM6PR12MB3465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XsZDkOXmgDhAz3sIUhuHMXFS5FA3wL+oYsQDiOUKVZh5ktJBuxQ20dwGb5EZoSmkOKA8Zm3juVdp6G0bcJUeEwLr2R16TspLXBcYoWmM9VDsTsyNmRV6GePu+DWTMuO+GVQvcxvjaOrRZqXY+U0Sb1VxJLvECreQwXyXI752hapAa0hxWPOhJcrV1eSxKXo8XyRknbzFVUpthZqGcG7qLKq1SDtDzzcrlq9YDWQBVZmnWwYuqkQQmOH85wLTPJMEDeoKwqmyc+WypD10/pkak39DbXUqJ1XkpriMVSEWKPvYg2qwYHp15S5QNDkEukhq8Y2W08qSHU3ZH4BqQjOKYwZK0yKe4zjHELUJYgX+Sw63GKyzYJkrSMjq5z2Z9P9CRvF4zY+tQ+JaHHWTIB/hk0I4lUcSdRm2CX5EuoTeno2tGA2U4zXL0usgwcjibY4e6JdK1J2UmK4uNKFZtOI9+EfiCDQWOwx41WGJOltLoWHLW5KL2/jsGweBBNjJZOlZWXGGnklrTtCVWnqsmhR8gq4n13Oy8qE/R3Pw+DNIfHwM9TysH91M8XCDgvkRbJR1Pws7GlQI9CKJ5v30GLw/pPxDql1GNQOo3xmbuQLPKjH03vC/PdorDmQiNi62jsCHXTMhA8uXREMasH9+7vPUe8OGUp2PBUTf/pPhESlru4LrOLOKDAYjiHxWewgg6EcKZ4WL97fd+AqpGBBkdaNlNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6486002)(6916009)(6506007)(186003)(26005)(54906003)(66946007)(9686003)(52116002)(5660300002)(6512007)(1076003)(4326008)(2906002)(8936002)(86362001)(8676002)(66476007)(66556008)(38350700002)(83380400001)(33716001)(38100700002)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j1NQITr0IzDNVzoQD3l7n9B7r/5JAEJfcBw13VtbKd1nJnRlVRLI5s+CWFtF?=
 =?us-ascii?Q?TYd9C2Pci2Qj18FBMtVdqDKYz8l8+VLyCySzqTaOEcXBih73tLkMOIaV60CI?=
 =?us-ascii?Q?8bpTePdQmZ9pN4V1iZjRhUbKh1W2xEn20XkxSdby+vPjdjUJqbawVjX+qEO7?=
 =?us-ascii?Q?Da/3zBFz7Gbk0HNQiLeCKL0f5u6Y8DDvJDElpRQcE97hIk3bhX9s4B2eodKM?=
 =?us-ascii?Q?ZcWk4K2b/o8BlJ/Pkv43Z2op7vdQW8kptX/BUtkp5Z2fAWtXyn/5EytVlkcW?=
 =?us-ascii?Q?V2LCSk27lBC4VThOEAXqMmqOje7bH0et7SY7/wH52u3cXJTvwfk5BnHOQ3f3?=
 =?us-ascii?Q?kf3Mc6WOSpYK6gG+lNufRtrUf2BI8U46bNFu3M2PYD0gVnfw0as/cxULgMfP?=
 =?us-ascii?Q?OKw2yT/3p8E+LexWD3TARM6oX31QCvDxMh7xgAvAXV4VU9S5LUsaEuTbPN79?=
 =?us-ascii?Q?tfzEnorLMkfkp1lf15ONubqwvcXXgWo+kgwE6AtBd9w5pfaBDnhL7H50aQ9D?=
 =?us-ascii?Q?eL7p10uCScGMbEXYkulL/zV0uYYsTm5UceGJFwrhVeBUG4l5o5+b/0+uQ7mb?=
 =?us-ascii?Q?SOsNF/Ec5WBHifIzjooT9GAxvrLwlvg3J5S9Z/Uy93TcUDR+sNMcU9UAuStC?=
 =?us-ascii?Q?KgTBIWK9zNllIOhVi9zrUU2NPqntkZ6vOQV8LIgS6YbI4S13edOm+hMi+i3J?=
 =?us-ascii?Q?hkv5QToJy0ttP/gUk9FNtFT0WxwtJvqcErStmyzrFh9FqRsCplOyxHxFrQ8t?=
 =?us-ascii?Q?y7+eZvsomPWT8b6jIZ9pa1RMXpIHQlE1n+S4wdWVmaFPCqZu9o/qF3in858e?=
 =?us-ascii?Q?4NGJfoNNTfilNgZflR02pcxUaqHwlAy4gg4tuuvNd9Wh/Pz/HQ74+F+AOZ+O?=
 =?us-ascii?Q?dY4rHARyMQTmNr/sjgFu5NSw8D6tlQqy198ALR5yL9i51zFhcNT7eRb8k0Yy?=
 =?us-ascii?Q?JR+TGoZlyN3lEMh0ho/hXvWtN/y239HdqJrJZi1ENYHb57/4SH1r2Eip0ezN?=
 =?us-ascii?Q?cfkjBxufcX0OZn3JTNE0onKaWxFFfWqXjHw0p1z/WKvV5ihItGtC4MoXkJr/?=
 =?us-ascii?Q?NL03fTtO7nNM+k36Ux18rRMzqU+e4eT6NiJ1q6V1rub0T2e2yHdbmW5inQw9?=
 =?us-ascii?Q?dTI0bM1PJoZtxx/e+3qc1u2Oy6tSzCl9fyNmEd5z6yMr1MaRuHQItk2N1cRp?=
 =?us-ascii?Q?5JUuieqNzUsD0XmzE5dvRibmFpcyjkXzqol/ORg0JbYVl/f2IREpPvL8j83j?=
 =?us-ascii?Q?OthADUXcPEz5tnb8XeUvvatJOc1ebqnVqlXSJa9d2llHi5wx+JgMLFfEPomL?=
 =?us-ascii?Q?cjORI/x0L4TgojgOXWOB4yL/FXMI6yKe0zrwK2HfFcCFOSbrnwCmk05/5EK1?=
 =?us-ascii?Q?o8Tmc/i0KpH9QXp536AA8QdwaG0O/3HjQZRi0l/17svSniFnwMplzC5hGxVu?=
 =?us-ascii?Q?wHy2/6sk2/xzydTgL5fn6TNKqrSiqhYoIxxR24Hqrf6pUY+NnG8/yzqrpUPm?=
 =?us-ascii?Q?hSQGJWhzCRz2yQcg6Qu6qnzpALPHbdM5JSkCcACGQVH4jUzTl6K1L0wqsZZl?=
 =?us-ascii?Q?IreCLJNWq+wLu+TIG8ptqo9G7wt/yE9bEtQcZLKjdSQ5Oxtup+IYCY/pZD5M?=
 =?us-ascii?Q?2vTb8nSUOi65wNfB3d5AmE8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b258e0b-9b82-443d-677c-08d9e112db1a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 21:28:55.2657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjiQvI+PixBiPe3fBCeaBdNeK9RNEPLws3EMNmVtOt4hqpXE15GJ1q3KZ+Xg65VIvZ63HI+jIRQBIqXSGdRZjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Jan 09:22, Kees Cook wrote:
>In preparation for FORTIFY_SOURCE performing compile-time and run-time
>field bounds checking for memcpy(), memmove(), and memset(), avoid
>intentionally writing across neighboring fields.
>
>Use struct_group() in struct vlan_ethhdr around members h_dest and
>h_source, so they can be referenced together. This will allow memcpy()
>and sizeof() to more easily reason about sizes, improve readability,
>and avoid future warnings about writing beyond the end of h_dest.
>
>"pahole" shows no size nor member offset changes to struct vlan_ethhdr.
>"objdump -d" shows no object code changes.
>
>Cc: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: netdev@vger.kernel.org
>Cc: linux-rdma@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
>Since this results in no binary differences, I will carry this in my tree
>unless someone else wants to pick it up. It's one of the last remaining
>clean-ups needed for the next step in memcpy() hardening.
>---

applied to net-next-mlx5
Thanks,
Saeed.
