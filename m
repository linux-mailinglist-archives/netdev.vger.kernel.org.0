Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84944C44E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 16:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKJPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 10:25:21 -0500
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:62560
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231148AbhKJPZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 10:25:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKsRNufuRuUVkPPQlZdrsrLQR1rA5VfFuvpDYodZ82HNJN4I79V9xEXFZ5WT60KUiBUEDsPITOIOLO7MrjLM8ch1jZJMWzX4M10RGMnKJf9iQIrhVgLA2HDvU/cyzZwSi0r6iDxpT4TIp1ENE5rEeYyVwCd0qc+HAPKamd/DtQLCEwjSWHrWnmxA6vhYjHhS6rhdfc22uC2jmhSW74W8DvnT/uRJInepjIPu9pTpbXK4JSaonqroH8ejYUr4UM3yoiL8DWJWan7+eQASw4Zy9qPT3MGjowk6BUExOkvaXEg/Xg1Dsv7w1ztGv3NZTXAIT2zjOUwEDZK64c9UVFi3Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by9ETsJWtHkjSJvxkIeQ9KqEHEU8mK8gW7KalWXU8eY=;
 b=lm5lRroqOLv7XBjW6Pj9LDHuSwi/ia9k2kmM6zBBWE09zTJczOwuUsvaskI0xoh6NdccoPgKpJwk4EnGi+auLQeJ1UclziI1E5wP994fn66EG5zE0bcZvnNYy4C6tDgqZOckEZOwN8zyOgXug9hsytYxyV1rklpfSugtuE2JmHJkLpay6xVBjHFzRKPbtzxqkCgME8RvG1RBFRxWbIch/raI2zi9CWI/WMR1bu/aBGy21Qki0W9i6odXMcelolCd2gmMGz3iCGlgSovUDZupHRs/HGmCfcaV+nbYCrJaSUDFpQ/Qt/zr24y2zcMJrewRFF0EXp/450+1gtzyb2JiLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by9ETsJWtHkjSJvxkIeQ9KqEHEU8mK8gW7KalWXU8eY=;
 b=dQ9zMCDR/pMisfaRi0b4n+bNniUZ14++bnIezs2O0pM38C8lwAXjsaqoaF5ML6pFViNd2jh7mkRwOmpkyp3sr2gjGzT0cluK1uTHSDRzK69/7vUp+vx1tN5uoRqY3eEhfArThDBgLnXxS29qZfti/D4SbRa+apljP5QGS7UClpVd/o+jRoEwXlY6IonLr4tXW3myKTdk+QtA2AaT3nRIL3WqcQePNgvB1Z284fcLYy1+32BaMogv6Nf6JYq04xGHVpWPsyEw9tNM7FLMHKmXI4tlA5dZ3ff9gjvgdxj+ytZ1XTf6sM/gzI+kel2mmtxkKlgDRXOrVmcA1RaB4sYMcQ==
Received: from MWHPR03CA0015.namprd03.prod.outlook.com (2603:10b6:300:117::25)
 by BYAPR12MB4629.namprd12.prod.outlook.com (2603:10b6:a03:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 15:22:31 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:117:cafe::ee) by MWHPR03CA0015.outlook.office365.com
 (2603:10b6:300:117::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Wed, 10 Nov 2021 15:22:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Wed, 10 Nov 2021 15:22:31 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov 2021 15:22:28
 +0000
References: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
 <25844618-b63d-251b-f8e1-1f0c045b87f3@mojatatu.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <komachi.yoshiki@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: Re: [PATCH net] selftests: forwarding: Fix packet matching in
 mirroring selftests
In-Reply-To: <25844618-b63d-251b-f8e1-1f0c045b87f3@mojatatu.com>
Date:   Wed, 10 Nov 2021 16:22:25 +0100
Message-ID: <871r3oc9xq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 343f46f7-1ffd-4d76-93aa-08d9a45de9d9
X-MS-TrafficTypeDiagnostic: BYAPR12MB4629:
X-Microsoft-Antispam-PRVS: <BYAPR12MB46295E5DCF6D76AA72B30381D6939@BYAPR12MB4629.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdxhbA96APjFwz9HW6ouSpObMQcOIDcDWJlYhIzKMx+7l+zDI98vVWMbrah25pcMis+Yfd8kuBb9ADFhXT/Hi8yWci4TVhuYNJA3hd8miqr4r+k4xP+hx6RykZcuCZKGiyF0YH0SnA2t0LArIpw8mz3gcSFNM6AVubwugwNViq1i9tH8OGiheQlq7kcYH5dceIwXPXLrXF5gdOg44La8nIDIJhDnS0HGUWs8Jf39+zmqvU2/uccqpRhoSfmDDicx7sf5yDTdqgUqx7rIMqMVCPlmst6k1dokNblgw3L5SBNNFqY51PUpihDaLWCuhqFbYKJQmEH8vbnlaAtmcL9oMN5mkuLvuUDpnA6pa6XkyNLb+wcbI0XozMscwxYKnspQmW5Vm1aXWZulxYW+majzLrDXtpBikCZHfUIaIoQWsaxEo7DbxkanU13kCQ0ZRQ9l3SM5DF69h0aJqWbwi2etc6pMhc0avPDHg7P4toO2FBLlxUicFNMuJQbmwxckfsmssDT2O2to0c6xIHWUmrmmifC8kZKWzlwPzNDpzgAb9Oxz44sxf609cATY4Il9SFeMfZLWpIUWerYlX+qu9qx2Yga2kDgdHe0j/4ut40Qwjdd8edEYxeovyNch2+RhYhp4BfJ3GMCjAmUgT+TDOUcEW7ILmZcbd43stHwSmMPFDSoK/sFN7A6B3xw1EnRqKEsTtVWXPoOWLcaGWQ448SbwBw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(558084003)(316002)(26005)(508600001)(5660300002)(8936002)(6666004)(356005)(186003)(16526019)(36906005)(336012)(8676002)(54906003)(6916009)(36860700001)(70206006)(7636003)(82310400003)(4326008)(47076005)(426003)(86362001)(2616005)(2906002)(70586007)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 15:22:31.1080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 343f46f7-1ffd-4d76-93aa-08d9a45de9d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4629
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jamal Hadi Salim <jhs@mojatatu.com> writes:

> While it makes sense to look at outer header - every other script
> out in the wild (including your selftests) assumed inner header.

It didn't so much make assumptions as happened to work despite being
buggy. But yeah, fair point.
