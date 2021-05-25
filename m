Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0124338FEF2
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEYKV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:21:57 -0400
Received: from mail-bn8nam08on2079.outbound.protection.outlook.com ([40.107.100.79]:63521
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhEYKVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 06:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ld7yTabDpKR/9RYRCVS6abQMP4/DVllZTGJQ9AWic1rnbwkB0x66Xm987yp/n+W+u6RzNP6sOKzyrTSJhG9IKNRWg0eEc+5AKMzVP21g4A3eBQE+6He0qUS0Z+H69SAIgCykkInSiuXqYrpaGpDYjsOJOz6QO0HZTkBVDl3fwuSvHsdDZkRYsqXThSwQMHkvqgrct/VyzUJ23kD21g+loetsSg20qHmUm5UVh/0h3Xl/cg0ZIO0NiufI+uJvj4LXibHwFgDwbiQmX8/RvlREyIH04Fyx8z/5y3bsEm0vFggwhzkY0YK4v8JUOFmSZNPt/sT2Qq9jj1QQiGAo+oTNsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uZjFDB/Wk4ILTn0pFImmwMyQXLl25vy1ZvK4G+SZsY=;
 b=FNvFqQgHaV0CfNuWS9BRgC3mW4Hfl4OSBZTUDbkJwNlvIRhIcNgNtpWGVx6one1JlA5ghO2HQHr5Ew/Hp3Yw1oXO8a7G8h7mML6SDrBXJnHn1cSIDq7g8Inz34RauhEc55YcFFgGuUgk7FB7kOW4BW+cYRxCM7IvNv194Mr+PLblCbvSpj8rC74UIrKn5na8g2uidwwCeVl0MtKDA2jZsiyrMkgQfGYlC74gCnOjLhHPG11D3Cx3a44h6b6ftc1vp0alsSEBAJ3sTD0XLTPyaVZUcL0+CPo7OUxtI3dv2h6Y8/qnIqALnxAa4ZKCSkQbB1snjNWilcir/X530tfkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uZjFDB/Wk4ILTn0pFImmwMyQXLl25vy1ZvK4G+SZsY=;
 b=lAWW3p1CH8JD/j75hnm0GbM/f4ITJrNaxfGkGZ9/4MCxc1nLkI8DtLf3Fxdo11ENyDJ3FLeOBJzttm86T7LVP7roGZtMv1iI67Jv9RAtIGnRuq1U6Gk7S6KV1upVAU6UZhUfudh+ORJl7KLOWJBEkUTgKW3qXeTdLiTahxZOmb4QX0/7P1tpF0FM4AitL+Kh58hOsmLno0Knu34/AIu5XvJasLnFWsz198Y6GlQiyARedBVz/Wc1wijhteapmgB8s5QqoDzUHHfQeVUfP6y/sgRQkGkUHMi6/1nIs12lmzSZNp7ECgWVwlbY2w5VF5B3GxOIfX/SDhSmhlKNOxX+eg==
Received: from BN0PR04CA0170.namprd04.prod.outlook.com (2603:10b6:408:eb::25)
 by CY4PR12MB1510.namprd12.prod.outlook.com (2603:10b6:910:9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 10:20:18 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::79) by BN0PR04CA0170.outlook.office365.com
 (2603:10b6:408:eb::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend
 Transport; Tue, 25 May 2021 10:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 10:20:18 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May 2021 10:20:06
 +0000
References: <20210525061724.13526-1-po-hsu.lin@canonical.com>
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
        <petrm@nvidia.com>
Subject: Re: [PATCH] selftests: Use kselftest skip code for skipped tests
In-Reply-To: <20210525061724.13526-1-po-hsu.lin@canonical.com>
Date:   Tue, 25 May 2021 12:20:04 +0200
Message-ID: <87lf83cdyj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff606f4b-aed5-423b-3a3e-08d91f66b242
X-MS-TrafficTypeDiagnostic: CY4PR12MB1510:
X-Microsoft-Antispam-PRVS: <CY4PR12MB15102F4E8B0E9FBA47D8EC21D6259@CY4PR12MB1510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ig+lNGve9ax08yKL9YWMDP4uu8NSb/mb2vwEnOlM1+yeMWk75xhWZ3stoIPY9kdmrYUw24zzu7lQC9l875ILH4uDojmZOvM3jWm/LQ0BNGaa9kVZOuMBzGD19/Wsb2szY65zx+S7J7r2u/ZYuiflFPWxlsri/vqSfU+Sysbu5A9i4Ju0CfgReNrW849PK/fnenmzeoBs1tfu2B4CY/MLnC/WeRtr5Ss0o9YqFFh5gFliz8D5cYlXumadwcobnGNL8D3bqs8UPre673SDBHCm7chriBu2pKfh8h4Li7k1wodLfPNsei3l6HTdGP2oySuruTPcKvqEh8s1ONIR07b0i+h9RJrKO10hKqVQznTzGt1KEQaANTJIRw8hmpTskQaI+99drtIadGWFT1XPOrN3xCR/7LBG9GYd9U4zkNVDawWb4+S4hLqGdB7CEZP37synvlOW9ZuHKU/AntmQnphBzlKjAk3f+4o/2eJWSNrY/PVBpjp7uWHjPqafqRwKcyBq2mz0aqEsFerqHcx8PZdApXMpWeKvlevvNC41g8LMyQJ/Oa0B4PdtOwOM0xmjC3hX1wtM4+MmCHPt+Cpx40bHcQSQCFkHVFWfHmtFGICvzl8kFTs+AaGIRDHrSoFf0J+wF/EFF7sytOcGJjJ+bvGm/K+8IxaMmPKGGdRoAkpO20=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(478600001)(7636003)(8676002)(82740400003)(26005)(5660300002)(2616005)(36860700001)(7416002)(316002)(36906005)(36756003)(336012)(54906003)(2906002)(4326008)(426003)(70206006)(8936002)(356005)(70586007)(186003)(66574015)(16526019)(107886003)(86362001)(6916009)(82310400003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 10:20:18.5626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff606f4b-aed5-423b-3a3e-08d91f66b242
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Po-Hsu Lin <po-hsu.lin@canonical.com> writes:

> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
> index 42e28c9..eed9f08 100644
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -4,6 +4,9 @@
>  ##############################################################################
>  # Defines
>  
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
>  # Can be overridden by the configuration file.
>  PING=${PING:=ping}
>  PING6=${PING6:=ping6}
> @@ -121,7 +124,7 @@ check_ethtool_lanes_support()
>  
>  if [[ "$(id -u)" -ne 0 ]]; then
>  	echo "SKIP: need root privileges"
> -	exit 0
> +	exit $ksft_skip
>  fi
>  
>  if [[ "$CHECK_TC" = "yes" ]]; then
> diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
> index 76efb1f..bb7dc6d 100755
> --- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
> +++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
> @@ -1,6 +1,9 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
>  ALL_TESTS="
>  	ping_ipv4
>  	ping_ipv6
> @@ -411,7 +414,7 @@ ping_ipv6()
>  ip nexthop ls >/dev/null 2>&1
>  if [ $? -ne 0 ]; then
>  	echo "Nexthop objects not supported; skipping tests"
> -	exit 0
> +	exit $ksft_skip
>  fi
>  
>  trap cleanup EXIT

router_mpath_nh.sh sources lib.sh, which you changed above. This hunk
should not be necessary.

> diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
> index 4898dd4..e7bb976 100755
> --- a/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
> +++ b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
> @@ -1,6 +1,9 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
>  ALL_TESTS="
>  	ping_ipv4
>  	ping_ipv6
> @@ -386,7 +389,7 @@ ping_ipv6()
>  ip nexthop ls >/dev/null 2>&1
>  if [ $? -ne 0 ]; then
>  	echo "Nexthop objects not supported; skipping tests"
> -	exit 0
> +	exit $ksft_skip
>  fi
>  
>  trap cleanup EXIT

Likewise.

Unless I'm missing some indirect dependency, no other selftests in your
patch have this problem.
