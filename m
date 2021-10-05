Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E1A42333D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhJEWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:10:51 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:10465
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231304AbhJEWKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 18:10:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSvZphwrMdoqAVtwvBsbOkAPMTkYCREBLn4C5MplCOMItmlULd/NAMiqOGG0b1RPt6h+699UIot5AqcaQb6OBHE80E5MCTZgSF+W7qmDE56uVHNbeNl22cLlm/7UOiOG/MEFTauzCs0e3t/L5JtvUhUs2b3FVYDWogF3cFt8EYfvqNudK+fRi5/XeVPi4s0wY41p/KvXET6jOBv52czkzD3dRxloCEH6SycjBmCgYn7qIX0/Yj+Tp/xt33dRmvT1MgRrp90PMGj+dN7W9p+9vJlIWg/G/N3kh1TPXNBImva/3rKTD8qxKLGGJ5ZOeWAI8CYdIxGTzI6GLLk9APHyiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnqAwtih5zEFN81Ge+L5SWmkSDGuw0cXGzPCs+xgCTc=;
 b=Q8w9Jo2uvFTZB+tTmpf8F1jrIMG4R2UNClUZDt2KgTHFpYIqdHhgxPJlIXk/pKS+y0FvsBmUAeGXkgHOAsLjxUPA/PJZzpMchVXjrOyRR6k2WtwR7XqSH0X8/OKB3XXwlrmiPxaJ4OWfh62hBys1aCF+0Jj7RGKemJNKTlBfITLNGhVRhKPn2DKKkslJDedClgPlpdYqrh9nmrswztFqYfrCCgE0pNaQmhwTCNdgygyDpAOCZ5o5ChwI313P9mqS0As6oTfJUWD7YeK3VE1h2sgm3Ikalwth0nlK9HlzNFGuE18UguQ1CGDPN7v4164+TNuSzqoLLNWOUvRGnfFdDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnqAwtih5zEFN81Ge+L5SWmkSDGuw0cXGzPCs+xgCTc=;
 b=gd0WFkWa/wc+HBwKZPMHPSlRuWAi/aMYLr7wp1Gq3rptpFp/oAywJ47gBoCmo337EFmB2Rj83hSKsJADrfx8XTYa7dq82tK0kIA3w4i9FqwOanLgYlrRRIqLyZiQUXZ+FzrZOjS4A3AtX6/J32V4iInLN0dYkkYDKbf/+xWGEBFBzrctEhrZDIxTkD9eMEnFgUo9hAi3Kgac6CyoKPhoBHGG9yYvqaT2tmL+fT3pdTX4ky8TeZzqqTPWtUolIv5P9x7xhWhiW/vNkIOIkBR+nosqQVrhT/aU8om4KdRAHmxQK4vBrVK94hvkdZFfHl4vHWA7tOpxLDu0+OYpKhc0Kw==
Received: from DM5PR15CA0057.namprd15.prod.outlook.com (2603:10b6:3:ae::19) by
 DM5PR12MB1291.namprd12.prod.outlook.com (2603:10b6:3:75::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.16; Tue, 5 Oct 2021 22:08:58 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::4f) by DM5PR15CA0057.outlook.office365.com
 (2603:10b6:3:ae::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Tue, 5 Oct 2021 22:08:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 22:08:58 +0000
Received: from [10.2.60.14] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 22:08:57 +0000
Subject: Re: [PATCH net] rtnetlink: fix if_nlmsg_stats_size() under estimation
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20211005210417.2624297-1-eric.dumazet@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <f1fc2b74-4422-18c1-d2a1-431115f6bc8f@nvidia.com>
Date:   Tue, 5 Oct 2021 15:08:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211005210417.2624297-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9903f9fd-a157-4a41-df78-08d9884cbad5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1291:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1291B748F9895C0942124406CBAF9@DM5PR12MB1291.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6p9wZKzTjZk/z9AT791F8VoL6RSMDM1xsgaNURxKKquYV9KJyPKlboGQaFIzVVzdbwB+d2NeQMJYQ6xjl4bopPQpztcreZtW1f8bTzC5y84/bEY+Bb1w/kfhkU3k2DTE1hfrWJFAr+TQws0QS/TADZFUwBo75suzv6+gONSspWoi6/P/CDhcr1obqKbby+5AX5veCOy3lyHYKEh5cp7+GdEQecjASBasBa4xQIbCBkYQreSARRfB6jusndeIf3FpMxsnf3thQDFQqx8ucLF3voFkkGsHplUi/rPihalPXu0cVHuDRO4r+c+aV8N3MqsW+/464+YWE3iyJ2xOCeQeDlGSg4gVrMHSZ/UlnL5nyvtN06b1HdFY9OOPmn3uf1VWWIaR05jQKCIRSRSJMqCWIuvor9ZMswfhefGRrOugVWbP46gcoTPSzZ7358gWn05PXXhWzRQdCI1FX/XY/rcxcVlA8J7ms+Jgb64FrfqptWp3y6ClcFuoEAFrWDtfvT+3T41udr2A0Li5kFge2hpsFLH8tlZNO294/YsP3s6hYag0+i7wXsBBncjVPEfqVWT+6eWz/3WisuwwqZdtJR1I22wgpgdRWBo5uSONfKU8tfwYVrsvqeaHaCePqAPkdYl4G+Pvgz/UlY4TjYoPxQV9JY/GOaNAjbeMY3SGHNXElDn5b3Mi/CpOuBvpvS+yapI8072uMq+LgigN0CIrERft5ERPVmViNDWloxgHGluqmfE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(7636003)(36756003)(336012)(6666004)(426003)(36860700001)(70206006)(31696002)(53546011)(508600001)(54906003)(70586007)(8936002)(8676002)(2616005)(47076005)(4326008)(4744005)(186003)(356005)(83380400001)(31686004)(5660300002)(16576012)(82310400003)(26005)(86362001)(110136005)(36906005)(16526019)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 22:08:58.1998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9903f9fd-a157-4a41-df78-08d9884cbad5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1291
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/5/21 2:04 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> rtnl_fill_statsinfo() is filling skb with one mandatory if_stats_msg structure.
>
> nlmsg_put(skb, pid, seq, type, sizeof(struct if_stats_msg), flags);
>
> But if_nlmsg_stats_size() never considered the needed storage.
>
> This bug did not show up because alloc_skb(X) allocates skb with
> extra tailroom, because of added alignments. This could very well
> be changed in the future to have deterministic behavior.
>
> Fixes: 10c9ead9f3c6 ("rtnetlink: add new RTM_GETSTATS message to dump link stats")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> ---

Acked-by: Roopa Prabhu <roopa@nvidia.com>

don't know how i missed this. Thanks for the patch Eric.


