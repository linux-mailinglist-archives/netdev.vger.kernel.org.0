Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844DD457F89
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 17:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhKTQls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 11:41:48 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:34400
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231390AbhKTQlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 11:41:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CclvOvqRR9+A5a3BuGU2uDenB5juh/HBZEGCqJIk04zHbBHtTHWTN0uaAE/18cfUz5adO+WgKv9AmwxNA7BljHxWRjFy3IyI7L6903vNbWHgkszOTDtgDJQckq+SR4pinayxqCjHu2J8wSpF/g8qXUt1/lb+OpEdeea5bcsAkLZOkGR4Mz7Tu4XXFZA6SvxZmap64yGGJ+g4FFjhExpIqP9h+dtKaK9vwIK+jF7Nfo/zGuTKm1H4ukwNC6XhNVbC0I9iOtgZH4xBqcqaDdR9ZBi4OXiCY8h2jf2QZ9QW+pvm164yOZL+khKajDx986ZgGQLGIjGOO5/IdQUdxWYXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8w7VI9nHrW6Bo6BciDf+xS3BZ3J5x4jhQl3BnKXQO8s=;
 b=BnVi5iB1oaOPrgP6ZnE4ZxwQV8qkdrdCtP23JUxiuaKx+PjuXWS3Ak4ZlydPWrUrwqV2gvuDVAsDmZzFqM4OLmQjG+FRHjeRtVXdWqTO6YdYdVCf+nHL2rkZzGBzN6egPI9NgZtvTBUkc5Zbx4M/phDU0jOtOj3X+M23M6ONrGgbmYhiMfzBLy0pbMhHDgKpU34TM0B7P1cP4dmXXZICUHlpRJYuae3KT0KZpPshfXHKgldGgNDdur82VKT+EMY+f69eDzJPMio7gTVfduTYQugrTk3jRUfrmHzyfHs8PpUOAl7e43cJjlsqf2tffHQ5b1btt9l8XJ3TDr2GRmXhzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8w7VI9nHrW6Bo6BciDf+xS3BZ3J5x4jhQl3BnKXQO8s=;
 b=OzI5LlCqHPNpX6uVrcEhrZCBcAghaAd2si+aEI8gR4Rb5L71GMreMvUbJV3OOJy0E8PJUj1gvxaCMroHBFcpZClkPrMkxrAu+JhqSEv7f6AbdI0pKXTyOQ2eXkq0uS3j4UOdNwcSbm0/ASTAv1Qj/skkkJjx76NKYgnEags6GdBW4//aqvdDp0bLcA+Io+cqFZ4V4H2QVapDcd5U1Z8c3OWaDaBD67Wrlc4p7EE30xkqjanhqa3GmXwadCPpRTiwHXca50ZCNfWTKJLDAeoLDRFVKfPtGenO9Ygg39VqK85agPEkKb9YOHUhhs8/RzIxTt2fefYkGpEa+GKOP1dpJQ==
Received: from CO1PR15CA0059.namprd15.prod.outlook.com (2603:10b6:101:1f::27)
 by CY4PR1201MB2550.namprd12.prod.outlook.com (2603:10b6:903:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Sat, 20 Nov
 2021 16:38:42 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::57) by CO1PR15CA0059.outlook.office365.com
 (2603:10b6:101:1f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend
 Transport; Sat, 20 Nov 2021 16:38:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Sat, 20 Nov 2021 16:38:41 +0000
Received: from [172.27.0.193] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 20 Nov
 2021 16:38:39 +0000
Message-ID: <129f5e00-db76-3230-75a5-243e8cd5beb0@nvidia.com>
Date:   Sat, 20 Nov 2021 18:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Regression in v5.16-rc1: Timeout in mlx5_health_wait_pci_up() may
 try to wait 245 million years
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Amir Tzin <amirtz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     netdev <netdev@vger.kernel.org>, <regressions@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <15db9c1d11d32fb16269afceb527b5d743177ac4.camel@linux.ibm.com>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <15db9c1d11d32fb16269afceb527b5d743177ac4.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0822dfdb-1aca-4194-6aa0-08d9ac443673
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2550:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2550E042BC6B770FF2684D4DD49D9@CY4PR1201MB2550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzr16T/09RHWNcyR2TOmx1jnLI48dhsRG2UTaErvVKf2f3a5pks2dXCCXsBC0JWtOXwxnQLE/UN/Qv0mq5dRibLUF2XUQ8fZ/kEqyGdXgpTPXKxJmo+Gfjy0DkaMNTroof8PflBoie2rJajBY8H36E+fI5qGEy8aWkMSq303lYHnHG5xG/GoFzqW7bQuaB4ec731r9ONj8RMsSAoR8R/mYCnFE/jtgsBmtxLHN1asBg9kl/C61mwSiodMzTPrplllaTF+kml5uyUz6pis0CwcLO7kahhA38iinrvOlLXeJS+Bd8LWbAcnh0kn8E+bUR+fRcvnvSU+cYJD3eygkUi62QpsbH7N0n/dypZ/mXXAzYDFDVa4Ryy7Jv7t82XuXUH/WpDMzaRe581SJEsTkow1tHW2jD1UisL+QJBVs6Ug1lkHv1I4UBPFeoHe35QrKHPmqz2Amik1aSX4xArafosR6KeP5OPd5XpBgE43l2YgIcJBBgDF5Y/52LGtGvI199oqsT5wih3YHyspqZJ1Ky94wFtF4Nn88Dl/FG746Fso+7KaFhaBF9Ow/cWpk9yIfL4HSeVWOUEtQRiikr0qXjT8+6GJtR+OQBlILtoObc5Ie+Nvf3miu3TKFwTD/tz3u+SVAjZj3vxm1MavX0wHMQLStPSCwEheZTFZMUVOI+8TCyGAAOF6IHlD86X4N6RTEzw78IgbWJKHpAoQH78P4gGUUmzQ5CLmw9i8iK4uFu2rq0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(47076005)(2616005)(70586007)(5660300002)(82310400003)(16576012)(110136005)(8676002)(31696002)(426003)(508600001)(356005)(36906005)(2906002)(26005)(86362001)(336012)(316002)(70206006)(186003)(6636002)(16526019)(36756003)(4326008)(31686004)(36860700001)(8936002)(7636003)(83380400001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 16:38:41.9833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0822dfdb-1aca-4194-6aa0-08d9ac443673
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for reporting Niklas.

This is actually a case of use after free, as following that patch the 
recovery flow goes through mlx5_tout_cleanup() while timeouts structure 
is still needed in this flow.

We know the root cause and will send a fix.


Thanks,

Moshe.

On 11/19/2021 12:58 PM, Niklas Schnelle wrote:
> Hello Amir, Moshe, and Saeed,
>
> (resent due to wrong netdev mailing list address, sorry about that)
>
> During testing of PCI device recovery, I found a problem in the mlx5
> recovery support introduced in v5.16-rc1 by commit 32def4120e48
> ("net/mlx5: Read timeout values from DTOR"). It follows my analysis of
> the problem.
>
> When the device is in an error state, at least on s390 but I believe
> also on other systems, it is isolated and all PCI MMIO reads return
> 0xff. This is detected by your driver and it will immediately attempt
> to recovery the device with a mlx5_core driver specific recovery
> mechanism. Since at this point no reset has been done that would take
> the device out of isolation this will of course fail as it can't
> communicate with the device. Under normal circumstances this reset
> would happen later during the new recovery flow introduced in
> 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery") once
> firmware has done their side of the recovery allowing that to succeed
> once the driver specific recovery has failed.
>
> With v5.16-rc1 however the driver specific recovery gets stuck holding
> locks which will block our recovery. Without our recovery mechanism
> this can also be seen by "echo 1 > /sys/bus/pci/devices/<dev>/remove"
> which hangs on the device lock forever.
>
> Digging into this I tracked the problem down to
> mlx5_health_wait_pci_up() hangig. I added a debug print to it and it
> turns out that with the device isolated mlx5_tout_ms(dev, FW_RESET)
> returns 774039849367420401 (0x6B...6B) milliseconds and we try to wait
> 245 million years. After reverting that commit things work again,
> though of course the driver specific recovery flow will still fail
> before ours can kick in and finally succeed.
>
> Thanks,
> Niklas Schnelle
>
> #regzbot introduced: 32def4120e48
>
