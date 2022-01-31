Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666D14A4CAF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380688AbiAaRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:02:10 -0500
Received: from mail-mw2nam12on2057.outbound.protection.outlook.com ([40.107.244.57]:5427
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1380211AbiAaRCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLrz8tKlhgoAYlzZk01VfPQQabKhzwUlLC3FeV1hbZVdY5wbyGPk+LtcqOMtQlQpCpsq8odvWIiBAr7BdkvMYY/M1mNffD10NaLAEWn6hUl2oWSKpykbbZbMVhf5UsRnxXZHwL/jJRwvXWAhHukfP2slFYIsVn6GIFJ7iFvBvW66DwMDFDNuRuxmxhcpbzM/hzqACyuYOcGaZ3lfcL7DloCuY+nPrgsoWbO9kdY9OFgPAj2N03+YKVkwUqq9rxDp2m2MXkjEbuxoxBZJWc8y6k9SbmEBNv1aXOfk5MU/S9xJwAsS0ulUW2RRsmVv1y1XGh2T9a8RPrFrVgQSoFLIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7A7PZ6oUUT4TDCOIHdSV9dQ8DR3I3ocJABis4b6UjGY=;
 b=jOe4M5VAS+kW8dczLIY2xeB32voi9yBB5qGX93qrt6WCJ3R3gKjh94lpLsKoz8c7cmZueCkL5V06BnaDquBbtgMguKkli81Yy4yruUK8R9DLP+yFQwz5IAIjwMEMSvH5r2ryeOHGdr5xESAnQUrEXeBpAGjmxtBuJ5ey1G8gkVnN8RrmIQhh4jGn4CnfRcf3tOT91j90Mo3wQXTphsMvuPVrTmUAov42iwgKtb8dPb52bRj4PZ9QH+y5bvWnembgH4kAS9BHW2Nthz4Qw89f/mziMjRwkZ52bX7v3JOzDsWJDv4A+xiyw3XN3QKfcqjouRcqUdRZvpQz15EsKW8PzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A7PZ6oUUT4TDCOIHdSV9dQ8DR3I3ocJABis4b6UjGY=;
 b=HAMfc925+vlefY8kTA9E+7tREjUgBXkZY+gQfxox33ZH5lrAvbflTdq8BQ38hWUsXbtkt4HVe1Xrtsa/3UmBvXO9Kq7aw4m7Cs15S2zGq4aBiZZdeAtD7MpI5lkAirk3K/zT4uanWx2poCwILFHVYdsiWS/Wcwprvl3ZtpXLyo7Z4YpQ4xl09mprXChb9e7/s+RJodllRC/hZEEyyUo7PEHFKScxzLkCot2GFLUl1myPMsGu6R5HTx2tds1Kj2DYuaFy1LDymCPmhS5M1FkD3Rxxml1A1eip6gBfZo704oESUHOO8yWRsGHikKz3Xf0V7nwbFqRjK35PDTtQdFhSiQ==
Received: from DS7PR03CA0020.namprd03.prod.outlook.com (2603:10b6:5:3b8::25)
 by DM5PR12MB1740.namprd12.prod.outlook.com (2603:10b6:3:10f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 17:02:07 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::82) by DS7PR03CA0020.outlook.office365.com
 (2603:10b6:5:3b8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Mon, 31 Jan 2022 17:02:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 17:02:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 17:02:04 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 09:02:00 -0800
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-6-tobias@waldekranz.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Shuah Khan" <shuah@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        "Petr Machata" <petrm@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] selftests: net: bridge: Parameterize
 ageing timeout
Date:   Mon, 31 Jan 2022 18:01:15 +0100
In-Reply-To: <20220131154655.1614770-6-tobias@waldekranz.com>
Message-ID: <8735l3ltyy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df6486e7-7044-4c34-8748-08d9e4db695b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1740:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB17400842FC60C690683EAC2FD6259@DM5PR12MB1740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQZsq9qnrF+AL77bUlckLa6JJ+BAvjgmE3NuYW8Jj+NNCIFJ+deuczpccBxRlycwq5cIU8p2Z57hYv/WD67z++lx8uZPwn8GzFbFuZMdptlBMQ+HaFvAEoxDnd7v3rChP6wDoQkOC2VzY/WHE6G/JkZR6cj8KGbz37wKJye6ynVitJhQxREGgECv/2AowaWTk4A4GPGQ9s54DFicDD7J7CDKfFAXqSlRl6zOwWGJI++Gz8xEAYu3GJ2IZP2IvKbjpi1N5SEg+rrhB/t1ACMAi93F39YfQSi8ftJ/K7ZA6bpVwIjj7QVUcqdL380S/Ejyo1mEYMtAFvCbZ9AFFyfuTT5ngvFVx/rz50ky2qkU5q62YpWV8GtiWiG3pqFPFAqRY5XRJT9FWCfaAA0BZ83/uU/3ll93MnWKCHSKN2n+EfiFsJDaC9qzKxc8O/pQMLxsaFMbKMgSebhwMWTkpMtfMasRHaEmozAQokCY7nVR7gQgiFf1n3AfWjLqo+QIfba3ngeZJ46/nEkezCEsQxYcUZJ7Y7UDcV0lw59MWxKavbpQNg69/hpyY+if6rQsmB2Vu+QxGZI10/3e03ovfLhs4/MLbsDsFeVNJqMKW5hkqOW7aKchP9mbNHOHWVRVZClB4giUOFL6YluL824Y5BEua7X+VnXse5FZanzTx5e2FOGkv0vVyb4rxMCgYN0mLp28MVlhhoDby8wgfucBNWqp+Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(47076005)(316002)(86362001)(4326008)(6666004)(356005)(8676002)(81166007)(36756003)(70206006)(8936002)(70586007)(54906003)(6916009)(508600001)(16526019)(186003)(26005)(426003)(7416002)(5660300002)(36860700001)(2616005)(82310400004)(4744005)(2906002)(336012)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:02:06.4650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df6486e7-7044-4c34-8748-08d9e4db695b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1740
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Tobias Waldekranz <tobias@waldekranz.com> writes:

> Allow the ageing timeout that is set on bridges to be customized from
> forwarding.config. This allows the tests to be run on hardware which
> does not support a 10s timeout (e.g. mv88e6xxx).
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
