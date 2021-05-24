Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6A38E65D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 14:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhEXMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 08:13:59 -0400
Received: from mail-dm3nam07on2043.outbound.protection.outlook.com ([40.107.95.43]:47328
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232665AbhEXMN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 08:13:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akatcHfIeR5esUfuYxpiiKQhetiz0F5YdtMOpQdTyKl0IBD/Q9yNJsZilKsUD0BUFOocwhwZP5pF07/URxcHHwmhoedWKugVa27TUaPsxUTCEIqJi7B9V7xhftyZQ7ChDjJOUFHqBf7Vog36HIp/rUq9l7z+I8nqTJwO2KhCmFK5/dhZx9vl65VdJdpsWWy+Ad/erYmwKuA8U4/s3M0YRyfx8afNbvSz+lEdSrEsv1fHYIhnfLuXisM1nN8eYx1foJwKmc1ZA7kuAwlYQ8phdfneX672oJBNAWrcZRjZdZzDWOTkdgnfTh7m+cifAfvb8ywZ5/wtJSkYXa1aZzU8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2CiiBoKGQ4dp4BshMHGmQTNMgPDQ8lU5lM2WNQYUaA=;
 b=ROOed92EncbSA9O18n5DyAyJvbMQKexmRcZ0IQP2g70DYe17tYihmBqg2tQZsUoXfius0cPu9O28W1KCO3FrXk9EuWoA2Z0JdOmj/FgopbDPw/26+8gDBGMqOTlktRJLVifQAIJ3LZ9EMQ1LF7iJ35CxQE/P5apfKjnBEHbLrv0C/1TQpdHR/gq4E057NQxA61jRsNYYwXY9Rdv343LaN4PozsDvA0J7OH4t1qJvVQaMasKMwnNpLlA8O2hTNdE24mwAPRhL0aF3S4LE47S7hgZFTIdvJV8YQyGLsc8FuVl4X4HFNQ9czuRtQCwcFvwfq9N27uHbZfwAbpJfvQHvUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2CiiBoKGQ4dp4BshMHGmQTNMgPDQ8lU5lM2WNQYUaA=;
 b=ak3bCWh1s77BP2jb2EJuBNgx4eW2EAuqLz6Z0A2NG1+nVI19/S5v1qt01AuvxM8jHCYxcVVk93NpZ0ZHiJ+EcuGTVaQf9Gnd6QavdNfNVAplQyhAr22tW2mYjTgwGjb99Q3KHwDJxGBzTV6TKjmU/O/y1gQZRqQx1VarNt4o6x0HLc5bl4Ri8hv3nAKObt1omAQi/aWBU+JaMKjOfHj4NjqB32kk81BrCYkQpL/owH09fNDVEgZ/inLdfaoQMKpVjK42NkJKz4Blq0gfSAZtrljWJLqbr1oBOteBqxdi/r6AHoPnsrshQrHQdCQ1vB56DBjjgsz/pd3m3PfwU8A3jg==
Received: from MWHPR1601CA0018.namprd16.prod.outlook.com
 (2603:10b6:300:da::28) by DM6PR12MB3019.namprd12.prod.outlook.com
 (2603:10b6:5:3d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 12:12:29 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::75) by MWHPR1601CA0018.outlook.office365.com
 (2603:10b6:300:da::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 12:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 12:12:28 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 12:12:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 12:12:25 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net 0/2] Fix use-after-free after the TLS device goes down and up
Date:   Mon, 24 May 2021 15:12:18 +0300
Message-ID: <20210524121220.1577321-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65a6fa80-6a09-4088-20a6-08d91ead3358
X-MS-TrafficTypeDiagnostic: DM6PR12MB3019:
X-Microsoft-Antispam-PRVS: <DM6PR12MB30192FE5957DD04EBBE01492DC269@DM6PR12MB3019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d26eK0BlBSogHZuTxve2iao5BMrksbJstGhHnbi/TXfAGWlagJG3i1/ILwpFnMa4K4k21R6CrX9gQ0wKgWfhRCG6+F4qEebmfLlKsMVLFdytLnB+ZnVIbuJGmPf27p1hbQvKKqvGqidVCshmmOE7cK/xyG64FxMo26bde+LyQg5nzL1o2m8fIFucZBV6fz4Hhj8rwLoG7jnjvxg/YxHHpCSBedsT7G5+kEIwEIAqti4D4L8kO1ZQ8E7R8EJJ2/1fXdxoYOG7RmqLzsCb1QKHaIs5QPQq0D4sTZn03Sn3D9KnYSfdzF8lMn91zJDqLPN1edLEajEMrvlOsvYGVe2BCiaLtPeOwjc1VSve29a/954uIA9R2b2Ch2mdCaCFSy6BK3CdL7wapYAEMFXbRUpOt+caLojpnYErlOyezOROCbiS7VAF1GfRxT3IxCT+ScnPWzLYFtmQC6c6ekvnlsdeaYVWJsArSq4Fe/uKWYr0sHeVMZ8ZKXgOuktU6y7tqi+QPNECVlkZIGAjuqyKgDXQT/z4EJSpa6a9Hr8cId1sfNiCMmHLlhmFAM3f1f4B+2OIgP5SxwqLolL8ALyeLM03M8p4nRH2PhTtxFmW+5CS5odwnS/MvjtJO8MsHfovACt4PQpDsFfuA+rt43VxqMww/1sFrfNO3x/mnr0RNF2AkrM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(36840700001)(46966006)(82740400003)(7636003)(110136005)(54906003)(4326008)(26005)(36906005)(316002)(4744005)(36860700001)(83380400001)(8936002)(356005)(107886003)(186003)(2906002)(2616005)(426003)(336012)(5660300002)(82310400003)(70586007)(6636002)(7696005)(1076003)(36756003)(478600001)(70206006)(6666004)(8676002)(86362001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 12:12:28.8125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a6fa80-6a09-4088-20a6-08d91ead3358
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series fixes a use-after-free bug in the TLS offload code.
The first patch is a preparation for the second one, and the second is
the fix itself.

Maxim Mikityanskiy (2):
  net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
  net/tls: Fix use-after-free after the TLS device goes down and up

 include/net/tls.h             | 10 +++++-
 net/tls/tls_device.c          | 60 ++++++++++++++++++++++++++++-------
 net/tls/tls_device_fallback.c |  8 +++++
 net/tls/tls_main.c            |  1 +
 4 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.25.1

