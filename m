Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99507391318
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhEZIzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:55:35 -0400
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:60161
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233150AbhEZIzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 04:55:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICuWi+LSiQRLXFjY54U7riwJUWRQUEewCbTlYIzx00mH9k2pER4uskaDdBsCEs5IcMGpyZQVgaPErjRMRC4+0JnbIj8/dHabNU+OObw1K2duec/WdTDw+/gfI/IrZ3im1ixjP0cygv52utMsTVMK/3J3tGVj4mLjqz3Z2JFLVUw6cQGoBiQHz5+KNK5WYca6o3z+l1myU0KARgeSg6QI/kQluq1j211xiblSZWHnTfCkIVLMy+ygSAcQOyfg/Ol3I+gBVVDkVA1WbzAdSKGQPvxM7wtqJmte8xu8g22W9WmuBVa/1Wel64nOHbT8HpSSVxShofIc3L4fKDW6XKnHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Gp9MqEnuDzjwz35GyzdcLIDndnVpcUkmgYHnpD5N7s=;
 b=JRJGpCWVP9ZWOpwxuXjzVy4nVwHJBzx1jk8iw08stpXmCtXKwiExLTe4tacaoJMyiFGduUnDhPvNcKooM4gjZyCsH3R1bl3pjnegk06s9NCQzzFRbAUm2dhW500QgVVrJPOTeTeoy+XeUsu5xT+CZdCj78IrSPF4OwjBKas5dATUkmoOWjRBIpA1w1Pr/7NC4vhMz8A1crtBS2w8f4+rqsAUggOzwtgcmlNHr4M7tUgoGlz+5HvFN2KL2CPiLQ3nKQxek+5CMXoNEkrxm4YkkI96iTsoD24S/nmQvT0nUWR+tkbcSXhK0XfzZeqe/c2wNTyf++YLhw+BrLcIMW8VBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Gp9MqEnuDzjwz35GyzdcLIDndnVpcUkmgYHnpD5N7s=;
 b=Mgb8yHYNH0sf/QJKNDktu4L6PpiFBs34mQ7YEbdx7B/Hk1UR9ZlUVRuumy7G1Wm7ntmKjEKAcm3xHREY+BpAjOmK+cnxqk6HFZFO3NRE+b3AcADNhNqYEnQO5leGoima/aU+20UyfxrWJqAmZ+fRFTkp3aGTwFGWgei3xXONeuDdJEPmCzxPXp5Yno0CWqcwzwqEoin6+1xFlkMiJcBbsyj4CR4h/tlnyx0chXE96wfaWqTwyjgkFpD1YsBjaXSS3Dc8YK5PIG9xsp/dHv5I5Toq1EWWAmLZ6xefnlCkAh6FlGR9DYRPli5VmJUJCZPj94TZOEbT0+vomsefqvD4fw==
Received: from MW4P223CA0008.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::13)
 by CH2PR12MB4859.namprd12.prod.outlook.com (2603:10b6:610:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Wed, 26 May
 2021 08:54:01 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::1a) by MW4P223CA0008.outlook.office365.com
 (2603:10b6:303:80::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Wed, 26 May 2021 08:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 08:54:01 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May 2021 08:53:54
 +0000
References: <20210525113316.25416-1-po-hsu.lin@canonical.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shuah@kernel.org>, <skhan@linuxfoundation.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nikolay@nvidia.com>, <gnault@redhat.com>,
        <vladimir.oltean@nxp.com>, <idosch@nvidia.com>,
        <baowen.zheng@corigine.com>, <danieller@nvidia.com>,
        <petrm@nvidia.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCHv2] selftests: Use kselftest skip code for skipped tests
In-Reply-To: <20210525113316.25416-1-po-hsu.lin@canonical.com>
Date:   Wed, 26 May 2021 10:53:52 +0200
Message-ID: <87y2c1swnz.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0176b126-049f-4e81-d595-08d92023cea1
X-MS-TrafficTypeDiagnostic: CH2PR12MB4859:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4859036419BA5F7985DEEFA4D6249@CH2PR12MB4859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVtH75vtpxOgmNkFSU5cG+z37Po7Gx/0HONJzsyIQKzIZ/eqcRH+Gf+4nc+Ne7U3NE7ZF977NSI5uobwSYaq8QgV6CPDSVPqJbhLUwGK5SNZbpyYvprzvwzcym+jdvey1eGx7ZF5j9XREuIv82CMxM+XPtD79VBcn1BHLjcpLWCF69srRR8IZ1QaaiI40QOsqfGUn6NkIOZXN1cIIglJy1tV4S1uLDtUnLZ+W3jzhsivJknnpRA7zGa6cwvCqXfcGttnxuIVCgarkXTOXxukaJ6+yihqY7p6l7xDl0jbZENIOcFThDJ9krvZu4eFOT4LLgegjAbC5aDsrGqQGN8f38keioCdfJFQW/o1BrxWiBLHs7UnxRtvsUU11H6mzq1p396UbH+x+lnv+qK1sGMVpKghmY3gGbZKPVdJWzQiunVxr0sHXKN0BIb4u6QPIR0BqDoyev2zPbN6/frmaqY/r6ctItpst4fRnDtN1Kwme/ZVpeETVegxQrCAhYYo7NqVMqsGArg4QAWWX0JJDUYa/kwRAAc5ZbAZRFKr7hfdIoi8O9ZZDEwAVd8S3bUmUzE4Cd8eNGx76C+Twy3azVyKbiDFg4VKlYNdFbOnid1WkFVFWLzLYvJCo7jo4mKDb0/AtCGvtef9Ok8IOz4qjBplsphjFAtMObNIxWxfNUXTs9c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(7636003)(356005)(426003)(336012)(54906003)(82740400003)(47076005)(316002)(8936002)(8676002)(36860700001)(70206006)(70586007)(82310400003)(478600001)(66574015)(5660300002)(2616005)(36756003)(186003)(4326008)(6916009)(26005)(36906005)(2906002)(86362001)(7416002)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 08:54:01.1113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0176b126-049f-4e81-d595-08d92023cea1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Po-Hsu Lin <po-hsu.lin@canonical.com> writes:

> There are several test cases still using exit 0 when they need to be
> skipped. Use kselftest framework skip code instead so it can help us
> to distinguish the proper return status.
>
> Criterion to filter out what should be fixed in selftests directory:
>   grep -r "exit 0" -B1 | grep -i skip
>
> This change might cause some false-positives if people are running
> these test scripts directly and only checking their return codes,
> which will change from 0 to 4. However I think the impact should be
> small as most of our scripts here are already using this skip code.
> And there will be no such issue if running them with the kselftest
> framework.
>
> V2: router_mpath_nh.sh and outer_mpath_nh_res.sh sources lib.sh,
> there is no need to assign ksft_skip value in these two.
>
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

I want to note that defining ksft_skip=4 in every test separately is the
current practice. I agree with Willem (in a parallel thread) that this
stuff should live in a library of its own, but there is none currently.
When there is, it looks like the conversion would be mechanical.

Which is to say, IMHO this patch makes sense on its own as an
incremental improvement.

Reviewed-by: Petr Machata <petrm@nvidia.com>
