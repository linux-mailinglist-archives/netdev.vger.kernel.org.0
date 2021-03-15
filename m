Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B09D33C92C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCOWO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:14:58 -0400
Received: from mail-dm6nam12on2068.outbound.protection.outlook.com ([40.107.243.68]:56960
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229536AbhCOWOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 18:14:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKKJ5R78NifSoqcE7N4LtVAcSiYfJTt++8eIhzGpR+EEYNMwrC/7vJsLg0kfrnX/8zaNxbhi0J6jCfNNVdR4dwOtI94BywznXd4iz2fIkpON18PlqNcG2XI9wxnqfCqa1r7PEbn32tscGLPD/akkxtEUMKUNBu7dCHpulpi55BFBpZgNpnTJQ9Qkdf1Ksr9p1YCb+Z3rhoXmLHT3b6l+2YDpJOURbMYspAp3myEXf9jRvUKhQehza1m2WXnJfbHxXDficm1L2AR3kcqYHsXHeYkPRDxeZbyvAPkE/FvugYOJtWPUR8C4KDQ8ak4EnNYRueJQyBu1XJkKrNrfMUTGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmxg8sGNql4ELS07h+ZcSLFMmNauO8WIqu6c2phQAF8=;
 b=Zz+yusMhJ5XPbnhR3GhtoqW5N5Dg6AlsGwQZwFYZGWrUr+EnvBjxgYm2/E9U/Rsz++wCPgtaygm+VLgZFCZQyr90ajHj4lRsr9EEsX4jHP5m9PFkdwe886mC3w88GT9kKJtZLR5CsgvnnJHi720Dqdc7ECAYXkv99JbTb6MfK9gE18tL49wrgu/85Wpg+LuAzeU5lRlUceEwWY54hSvvrgU4l6NzXWBnoYROymJm2xTF+KnS32XF5p2vQgbWs2RtaQJ7xP1LPv9CWdc2Hgnwqn7jJJyfNU1W0vdAUNKUQKO7qNHKizsy65ZW8Yhs5MFA72nNEp09uWz11N3RLYruWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmxg8sGNql4ELS07h+ZcSLFMmNauO8WIqu6c2phQAF8=;
 b=CbB93jvvxIz26bz3fcYrEBombgLJpVkjlUkwMX7j6nXc5nVcwMRfxbgD0QfIe77QHVAN8mBzNoQvXxoqnzOknwnA5yaAefyYIasXLjLKQw4d9K/XWzNCicbgfTx0GC8DFMs5TNmn2AgrjJbKY8s80g8jvTJ9ncBZr4JV9/bxCo5wmFviHpgNPi7rBrwMD4YC47ElsJWCyXZis8XJCsCKyV33Vy7x79QmPGYuIUCFx+W6pGj6pNsJe9cWxtAcWP5dIEgGicUBJapxywrE9J1tUnMYLMGKOpvpa4WhRdaddejyVXUEwbfW8NIo4N48RzqfdL9VcdQ4BvDgyXC9yxle1w==
Received: from MWHPR15CA0046.namprd15.prod.outlook.com (2603:10b6:300:ad::32)
 by MWHPR12MB1277.namprd12.prod.outlook.com (2603:10b6:300:f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 22:14:30 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::10) by MWHPR15CA0046.outlook.office365.com
 (2603:10b6:300:ad::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 22:14:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 22:14:30 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar 2021 22:14:27
 +0000
References: <cover.1615818031.git.petrm@nvidia.com>
 <2e3328b34e571d00c7ff676624e6af2aebdcec62.1615818031.git.petrm@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next v2 4/6] nexthop: Add ability to specify
 group type
In-Reply-To: <2e3328b34e571d00c7ff676624e6af2aebdcec62.1615818031.git.petrm@nvidia.com>
Message-ID: <87o8fkgj40.fsf@nvidia.com>
Date:   Mon, 15 Mar 2021 23:14:23 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c33d85d-a373-40d6-0b8c-08d8e7ffb49c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1277:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1277BC3EE224908B5039A99FD66C9@MWHPR12MB1277.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylQTlP+hLxOvFsyHCpf3g+6PFlPvx/mDDgUBAl9yIjyZMGhw060559VgoEaSLcQT1ke2t1IqWIpH6ve5t1G0HM9xsvXiSVsoiBWwYmotfucByBevUZ0O6S8e9tSLvs+GbAiNv1u8OttUhkF5IdEULuPLjlfoPPrF9YYc0/LzYjMDVknMYBGqGeG18+sPtZEimfxypcZUAgbDTrvlva98OSkDDbmZhOdjuOzy1X+AULgvY0TDVmcScKhq1OKHbcBIs1xxikFI515oYPecVEQ9RDpHsCej0kllnuXfJ6mYCZo0sf8Gesatoj2x9bsQrSGDn7O21TUmxLbt2x8zoX1Dje6eE5YJMMud30Mf/Lv3J+gcN5+EHVWhuyIdB6Pflouwy++JZNUzyfwDJU7pw71bFJe/BLR3trg2MOEywiaDuJq+mef6g9+4BD22wGtLrOxhqNoiKOkYMt83IG3IZCCMPway50+I2yEF8FOO1yczty4hzvpd737NBar2+qxitDen4inv2Xu8lLMo1wLzxjPR4PPFeFp485t5vdh2hk5F/fn19/oCJw4yyXkpo2YPLgWdni/BmkN5Vm0LIOEkEmEAK3OFXNo6yA4VrAyr0TiltNwbSYM6qtwsZqvdFwgRcnkeEJ9JptSZt4udXiWB7dDW0ABzGIACqAE1FhBnYF446S/9PresT/Bhg2JN8dTu61dX
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(2616005)(6666004)(26005)(426003)(36756003)(2906002)(558084003)(16526019)(82740400003)(336012)(54906003)(8676002)(4326008)(34020700004)(36860700001)(82310400003)(316002)(36906005)(8936002)(7636003)(107886003)(70206006)(5660300002)(86362001)(70586007)(47076005)(356005)(478600001)(6862004)(37006003)(186003)(6200100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 22:14:30.3118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c33d85d-a373-40d6-0b8c-08d8e7ffb49c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

And I managed to forget my S-o-b :-/
