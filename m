Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BA63680D0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhDVMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:49:07 -0400
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:42272
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236400AbhDVMtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:49:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmAR3AAUsLGreJIQsvEc1lsC+BG36yW61v3kMIBJX0Qow8t1ffVqUCNin5JNtEvQSCfAykuIKnyhW71tZMI4fBm/D/9oNCRnShD9acsq6IzHYNpSDg87KyVUL7KVzn6G3SL36uiknO4f4IV9t68yQdlWM55zZtLJeVdgegoUUpd9lfmHTd3gN0y6GomBtJM2k75uAoeyNU8EyQ9fH0giEt5MZdQXSBiHLQRW0oqeoSKTW+pHb/mOPDgxWm+LUiwCkpzTqfYgNqj3l0f0QK0T1HstZX86kZiCBAXmvzl4w7uw2afpVh0d1dFGjadeduG/HJSGKn7RyhpJVDG5KwQu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bPKZ/aelUMXzg0H/04htL/UYm5gLAnC07mQFnr0DLc=;
 b=RBxbEuB4VVe5x+mdQSFnrpD6bhIf7yB/eYB7R3fb6P+V25GKqTfc7lClwfuEVBQ0Y42BrKHRV5otUPR/U9sgiDtviG/ugF+3lLY9SDERcm4d2RdV/xjcWDd4HUtIJrJJZLA8ktuipuRHOSzTGBscDz0O2AREyZrD6oLgzeZNDzwYTayFhrLz+s/kmV19mIQvEgv279dy5TuxNAltrulcSciuM7fwjeWFbSFiVbSgEMtDJ8etdzDgfHYaga5q1/R5e6C/7qmsMfs8HSKShZT5U/rhgZ09bZB/CScgD5IPVjl14lX1aCT0NAIFNsBF0QiXLqT3a3tN7cgU4YQv14Xxyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bPKZ/aelUMXzg0H/04htL/UYm5gLAnC07mQFnr0DLc=;
 b=tYm55cSTrXqo7KbzkUpEPTpjGw54rpLUvSlwrvKthi9R/4j2Dbqm2CkdUEtKE2qG7j8gJ9+XvcolV93x93Rm50/Hlxvwwm7vgeoXLj0D/f7v34PrlVcowqqzUKeOqJhEt8ruXlKBgT9psxnBupiQueP9170Zx2MGV3sk8xss5f2Wq/g5SPMZV8mX2IThE2ekc5GEb+1dXjeYs8K6UhdoWz1VHYQeGvzFdNJ5MsB9R4MqP5kEbFHF+xRN9cLmCV7H8nr0PdggY5LOwsdb/E6z8gBTwm0RACvA98vkfuFs6sElfyGwoJaUrGCI/1RMvXIestjnplSRsEP2vUqsqCAkNw==
Received: from DS7PR03CA0134.namprd03.prod.outlook.com (2603:10b6:5:3b4::19)
 by CY4PR12MB1751.namprd12.prod.outlook.com (2603:10b6:903:121::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 12:48:28 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::97) by DS7PR03CA0134.outlook.office365.com
 (2603:10b6:5:3b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Thu, 22 Apr 2021 12:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 12:48:28 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Apr
 2021 12:48:26 +0000
Subject: Re: [PATCH] Revert "net: stmmac: re-init rx buffers when mac resume
 back"
To:     Thierry Reding <thierry.reding@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <qiangqing.zhang@nxp.com>,
        <netdev@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210414151007.563698-1-thierry.reding@gmail.com>
 <161843460976.4219.11833628435503987516.git-patchwork-notify@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d51f9f85-9093-86d7-fe41-a4353eb6599b@nvidia.com>
Date:   Thu, 22 Apr 2021 13:48:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161843460976.4219.11833628435503987516.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96c734aa-6863-40a1-952e-08d9058ced86
X-MS-TrafficTypeDiagnostic: CY4PR12MB1751:
X-Microsoft-Antispam-PRVS: <CY4PR12MB17511499F933CE88DB0DD64ED9469@CY4PR12MB1751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6GG4iriimIWyEFg0Q5i7RCit0Xk4v8QrO3dmLep2nl9hsjZa5NSoh0CzFSOh1IL7IrEyAW689wFVb6rxaVB2AnNigHwNxfTT02dlqUAD9rO/qXARannB6YPQL24ui334PxGaXbiFO5IC7M/ZyiEGm2wfSBWtVIjT+W+yLhvYbTt/UKZiFYZGeWbdf4Vcp8cqPpA2jWi0SDFp3acdEeZmiij32nXy/xqHieIdONu30HN6G3/K2pmKFr+WBBHCgv+NKIdrVdnYOjc6sG8kwqW7x4oLdHlu91lUgVRffnW4kg157MmEoTZzlRYkvQ9yZwYvp10ZaEecwoOPAIUUqZSoBUys4s+lW9aq7GX5+mOhLv20Pf8ttHCEpWpY/+Y54Qn5xyOdqWsG87RLBjg7BdSURm3ZsDmencSHxyl2D4GYgWNN/URb9vtMsF3s2ojcLVFOWjEqVEhX8KvsSgF7ysQuwIXtMhRbK19HxoELee3vvsJqwxPwR7qxmoEsJOCRu04G9tek6yI9+KNQilGDtPZnyRB4FccR2AFcZ+tdw9vwbnS65FBuYSwzE5U1nAlwWIA6rNa50uX5/6+me8zXs7DY5HyBv0NYJzCWx4TvRkydCls0KcO9vxE4C5peHf4WffLR5tCQkmqHRCB9Dv0zuxQ8FORacAcTpR01X/FY9E+4zJbrilUuxJjjqkbafcR5RhRnJceTuSHYvylpOsYDoL4gsZwvFqberQ8hKJmOIOa9/CWeWs6yUr/o5HTTJypvOcUWz7rql1A/tsG+s7fHZ+oIQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(478600001)(2616005)(186003)(86362001)(31686004)(4326008)(8936002)(36860700001)(70206006)(70586007)(8676002)(5660300002)(36756003)(82310400003)(36906005)(82740400003)(16576012)(356005)(110136005)(336012)(4744005)(83380400001)(26005)(2906002)(7636003)(426003)(54906003)(966005)(316002)(16526019)(31696002)(53546011)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 12:48:28.7136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c734aa-6863-40a1-952e-08d9058ced86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1751
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On 14/04/2021 22:10, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Wed, 14 Apr 2021 17:10:07 +0200 you wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> This reverts commit 9c63faaa931e443e7abbbee9de0169f1d4710546, which
>> introduces a suspend/resume regression on Jetson TX2 boards that can be
>> reproduced every time. Given that the issue that this was supposed to
>> fix only occurs very sporadically the safest course of action is to
>> revert before v5.12 and then we can have another go at fixing the more
>> rare issue in the next release (and perhaps backport it if necessary).
>>
>> [...]
> 
> Here is the summary with links:
>   - Revert "net: stmmac: re-init rx buffers when mac resume back"
>     https://git.kernel.org/netdev/net/c/00423969d806


This revert is needed for v5.12. I was just checking to see if this
would be merged this week?

Thanks!
Jon

-- 
nvpublic
