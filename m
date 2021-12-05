Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1DB468AC2
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 13:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhLEMV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 07:21:59 -0500
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:32480
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233599AbhLEMV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 07:21:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbNSmEoUYbfBLqlDGoQsrx57rwCzWFgh7IDbvxp0/AnHx39hJDgLNmr4rEFlja2s6qgT0WSePIDcCrmQz+SSzJJFVp+xuRcUIakisXd/5OUznl47rTbw1npbg0NOn80BRyaM46dEYY2gMqzAuE1Kva252L59D82s9qLdTY/fJYkztdWmt3jDQiLSqeD8D/IQ+GsBGscHxHc0KeqktsjuTaflSwn3iTL3bJJ9ja+3ziv7RIAWDrJCp5KPQW3E4QHwBi4Du56e+mx6miu+nyJqf7xAPFnJxEuyweutZpCBRNlWpK8Bs/k9kw1GUVUtleu8XbrUC7uEIEnrIhVnTWBt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sy2VJzrlwZ8N/SeGhRXRnsPo92xAgA3fCrM0CuKCryg=;
 b=PlPCh0CKLfCoY8g9aTKF2AmWLAmTD578sum9ABE4fosT1pe0pM33ddJumLADvbENFE0GH7INWQJ9+NUDfbFxZTDdjxnWTjSiBLy6PePc+kNI9UqJejAnYtrIiv8z3sfC02jxCR/wiCqcyP9STupPsGK33m+Rg/hDzNCbUAbQ0pH0aE3H1MK1sC96Ca7/f9SkuN5OQrfOv+zYG9D4qgKXEtfOijyA8Y9rZpOeUK/O0mc8iVfvManaP5hu45cee4GOax6Sg8BN1T39ReuXiAu+ONmgfK+KfGsgP+jagJhZEAGRr6lFzcyrpH3OrmZhHukiqN9akX6vRWoA394yaeu/VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sy2VJzrlwZ8N/SeGhRXRnsPo92xAgA3fCrM0CuKCryg=;
 b=J8HNb+qBCVceK9S9IZqkkMhLD9vSl3t6E+MiFtpfiLjBFtomzdw1UD9bVxmMAG8CRTPViwYchfutfVrxp3Jqr3bBv4kRc0hm7DDNjrjNMxIvPL0OsHzTdJCEwiqGCqWLsDTBEkH+D8xjEPlIlfUy31dq7glKUx+vPJ0e+HlN7zlqgUkllT+Zhk4lph/xvFq8wxN/TeooZ1DnWPbi4ahLW5akbuv9KdQAOCOlFl4K3ysJdqE/FEE02eIhSqyrNxdMH5OD1nqPq/HXwBsKZDfTAI66eztqF6Ck9D5RfOCOqwygNGXD6TqYrd2yW3nuuyp0DCZz3oLwiTa1JJHV6ng+1A==
Received: from MWHPR04CA0064.namprd04.prod.outlook.com (2603:10b6:300:6c::26)
 by SN6PR12MB4767.namprd12.prod.outlook.com (2603:10b6:805:e5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sun, 5 Dec
 2021 12:18:27 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::3e) by MWHPR04CA0064.outlook.office365.com
 (2603:10b6:300:6c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Sun, 5 Dec 2021 12:18:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Sun, 5 Dec 2021 12:18:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Dec
 2021 12:18:26 +0000
Received: from localhost (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Sun, 5 Dec 2021
 04:18:25 -0800
Date:   Sun, 5 Dec 2021 14:18:21 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next] Revert "net: hns3: add void before function
 which don't receive ret"
Message-ID: <YayuDSbYTEdLdeMG@unreal>
References: <ec8b4004475049060d03fd71b916cbf32858559d.1638705082.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec8b4004475049060d03fd71b916cbf32858559d.1638705082.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9114981-337e-4587-8eab-08d9b7e9575c
X-MS-TrafficTypeDiagnostic: SN6PR12MB4767:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4767787203D97F65AA0778DABD6C9@SN6PR12MB4767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jy7i85fJTzd6+wwcSMaVXzuYN9uvwKCqKa2EGPnQlhf/OnLBsAQqcHTB0sO29k/rXyAuIyUP5ut8npYwF6eflcBO1SOY3m6oM+E3j1a3W8hxtlpjQvY602cSmFvRFrH0enZCi+B0z1/5KhE8xqu1TG9zT2IkUdQR3PgxFW3trx6I5tYhkjI1q7lk/3LTooiJO81t1tUdA+mh7mPJMv9wP+slQ0B8bJjAnuDR3kxT/Q2Hv2yaYKadV/u++oHuKrx+1hXmTrtrrWpHUOK6I+VwB/HSExFVU/owD3d8CPLEj4v7U5L1Hoar8p+mDoHRmm1mUwheNfect4KkJgEnqu8qoTHLv+FwcUwd4SBRRQL+M+gxObaIPe6QxKxgJqrouojtjQdhuoCaGN2bWkn2DLZ2Wysb5S48uPXJTHAhiqvdDWoksK0LowY1PPtr7PXe9iqQfGMb/b27HgBLrWwyz4eeUse+JfD2LhQ6r8qNO42rDDl091RgZPnTZbyUsz7zk7HU4dOASSW3qSTGOr9yz1DwBdYTwtHFXG/0VZY7jW8v4rrNiacNol5smV3wgiSIVAZK+vy/Oo7apdXz0v70rF3I8TCheK5UIc5ShEnXq+IOAh/j2mDe7o/X3OY9mfpCfC8tHXkwtc011JRXlZ9zSBix1N8/eBaef7R5173KXfJRkywJjLntHJv44l+w3ogcw0f+P/EBvhwNKzS8EncEg25W3jRxSmNwiDTINyyd3i9T6qPiWVPyWxyEQ0Q7Y1cOvO4bJEIJb2QLbATw9P0QJhUX21L907n1wUcQj42OJiYw1SEPO9cZfLyA/3pJufpDAR9QEePovbeRhx2GCNbRtW0RMZxZGb0Dz+xCUhy0lwoHvl7b2v/1gzd3DGJmRGDJyu5GzLx16zUSYq/NN+cJ+gMVig==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(40470700001)(26005)(966005)(336012)(16526019)(70586007)(47076005)(508600001)(54906003)(83380400001)(426003)(110136005)(70206006)(36860700001)(186003)(5660300002)(6666004)(356005)(86362001)(316002)(7636003)(4744005)(40460700001)(8936002)(82310400004)(8676002)(4326008)(9686003)(33716001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 12:18:26.9488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9114981-337e-4587-8eab-08d9b7e9575c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4767
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 01:51:37PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> There are two issues with this patch:
> 1. devlink_register() doesn't return any value. It is already void.
> 2. It is not kernel coding at all to cast return type to void.
> 
> This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.
> 
> Link: https://lore.kernel.org/all/Yan8VDXC0BtBRVGz@unreal
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

It was already sent, but not merged yet.
https://lore.kernel.org/all/20211204012448.51360-1-huangguangbin2@huawei.com

Thanks
