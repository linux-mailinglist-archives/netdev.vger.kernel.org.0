Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD03536E7CA
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 11:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhD2JRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 05:17:51 -0400
Received: from mail-eopbgr760072.outbound.protection.outlook.com ([40.107.76.72]:37359
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237314AbhD2JRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 05:17:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwrVYvmFZ8OYEAOPZRLRoLk4hJgqNHNb1DSd1QmMVx1h7kBZW9sAnsaEO+f1+JpwcxLPeHtoW8zu2Qa88vCEgmkR0qmuiqFqHrBc83t85T0APUpkP67aAXgmrNnAwVlrxaoof2oo2cMUg3WhZR/c4O8yiPIynwh03SC4Stcmn45/2eaAfOMVIBM16i9G5hsV9wT+hACQRd0B4Xl/5Iv3u0Erc8C+1ZLJJDzB1ysObLaqLorLnkoTOmSQNRixX19rdDm3ebbmPL0Q4GL2GFklZ0EPQJf6f8j6CVrg3L9yVBOsJ5v+mY5hZFxskYOcKphNkn1zlYRnV5WuGqUTg9z1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlOlc3ku5zllIKLUsvd1bX4RkQWFtCZzPu5sVdLEaTE=;
 b=gyfIelc9/bH25++KrHqSQGRtIsHlAN70M00hN77e2EdRkl0Hle9rBAKlkT/tfIBP/aHrdUIgKLNj1oicCmRaU4Wt1De9nRfYL6dIU5BLW+UbdCDTYR6TUUYwVMFFNdi1x8XTHhQXk89PUXF0m2d//N5XKFCN4LFWQd6FVKBbGkbNcK2ntdIjrXyurJwtlMPx4vfLaaFXRKWB3aXZYnK9+WixGqgtcNMTK9dhjmo5wMlUvTKzwaa1qDuhBjTijy5IAJD5QE4Sls1u+EhBVPts1g+C0E38zOyguuyUSRCh0l8NQC4eb/EdCVem3rfIM/5prKaBSR11Sa91pM7+NBp6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlOlc3ku5zllIKLUsvd1bX4RkQWFtCZzPu5sVdLEaTE=;
 b=rqyivefL1wmaihOj5oGwISXN4bOgLhWgiUUlcWzgaBQ7iUwkG1yv7N9GTYEluxpLAwngqzy5ND9+dgoNMY890CJ5nvp0V4/7er3621WoFrdqNGPAqPKjKy+mMZIJpHFA18qEJej2m4jK6RaekUgawF21pUAUKI1xS7/2kcheMgdJQZy2ejasJyAfcxlMp4xFILw2LZUax014mvBcOBtR4GfULCZOSUgnFUUC08oSa+1o+Sc96M21V+7cXtjX4H4EXSVlo+WYCpAVO4yfBt6PpPKg4iF9cnliYDFQg4DzKBwTKPnzJIjWK7WrdEYd9CzqqRsmZ5ABk6iUq0z68PYVww==
Received: from BN6PR12CA0038.namprd12.prod.outlook.com (2603:10b6:405:70::24)
 by BN7PR12MB2658.namprd12.prod.outlook.com (2603:10b6:408:25::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 09:17:01 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::59) by BN6PR12CA0038.outlook.office365.com
 (2603:10b6:405:70::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Thu, 29 Apr 2021 09:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 09:17:00 +0000
Received: from [172.27.12.209] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 09:16:58 +0000
From:   Aya Levin <ayal@nvidia.com>
Subject: ethtool features: tx-udp_tnl-csum-segmentation and
 tx-udp_tnl-segmentation
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        "Maria Pasechnik" <mariap@nvidia.com>
Message-ID: <c4cd5df8-2a16-6c31-8a13-4d36b51ba13b@nvidia.com>
Date:   Thu, 29 Apr 2021 12:16:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96282bf2-794c-4a91-83f4-08d90aef8bf9
X-MS-TrafficTypeDiagnostic: BN7PR12MB2658:
X-Microsoft-Antispam-PRVS: <BN7PR12MB2658874F3A91ADCAD695BC6FBD5F9@BN7PR12MB2658.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39jIVIg1D019nHiSIBtQ1sYnzSiAYFlpeWNY5jBgkY2WTJUZzY7rkV+moV/mFoFt0N9g9ZEJ90/w8jgvVi9BhnNvfihZ0v3b6ekD/zdwL4c5WDlENXZ3NEKwXNGL9NfvdZ0bpmYWB4OjOZ/n1uxRjKFMXZNPTzTOfs43WQUVOcB7WImDmF/qyLZ3qp3fqY3zUcy40EhVKFMyOHZIB+zcMloY/DRjw4sbC6BPLVohEmkewu85s8WDMrOBalbFWHTQhHdA0Pm2JAo7ljScBtRnyI+mIVj6MGEkFROAbp5VmJOms8dro4XOg0xrLyCFscMjRjGy7xswJyZlojZJ4khQIFs6pMP/r23bZBoYhJ63OCOmmmgnBZ4cQ9tjlYb+/Uc3619An/p/nUJwNNzWjkVCvhJjyqK0hWTCxoZIO0VfCO7U5cXg0kKIKtc1X0r9C1HIEH52ULsgxqO3VmHEr0NCoYYbV/LmJ58UcHHKLUYKRTbAXz8nFt+VwZjvbURPj2lokiMgm2EEMq/SWpyQQPHPT2SafH6C0mY9qPcy2x0tjaPKnjPu3t05guV8NI4P1Gd2+aeA1RkBKkec5CfKKkiYW3Fkx6Uv76Br31m64brm2T24WMIu0hII2wcIlMLgNuu2IOhm/Donf2SJsIqleH05irM5id4c1eimrGdwbXiPB7hAFCDXZFu4Eq5w5ZJ5dnmI
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(8936002)(6636002)(2906002)(54906003)(36860700001)(70206006)(186003)(2616005)(36756003)(26005)(16526019)(31686004)(356005)(7636003)(4744005)(86362001)(5660300002)(31696002)(426003)(82740400003)(336012)(107886003)(36906005)(4326008)(82310400003)(110136005)(47076005)(316002)(70586007)(6666004)(16576012)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 09:17:00.9723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96282bf2-794c-4a91-83f4-08d90aef8bf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I see a strange behavior when toggling feature flags:
(1) tx-udp_tnl-csum-segmentation
(2) tx-udp_tnl-segmentation

I had a guess that tx-udp_tnl-segmentation is responsible for 
segmentation of inner packets (SKB encapsulation + GSO) while 
tx-udp_tnl-csum-segmentation is responsible for checksum of the inner 
packet (SKB encapsulation  + ip_summed == CHECKSUM_PARTIAL). But testing 
proved me wrong.
What I see is that tx-udp_tnl-csum-segmentation controls TSO on inner, 
while tx-udp_tnl-segmentation has no effect - none of them controls the 
inner csum (ip_summed == CHECKSUM_PARTIAL always).

I looked for answers in documentation 
(Documentation/networking/vxlan.rst), with no luck.

Is the above behavior expected?
What is the role of each feature flag?
More specifically: Why are there 2? What is the difference between them?

Regards,
Aya
