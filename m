Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0520B498340
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbiAXPNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:13:13 -0500
Received: from mail-dm3nam07on2052.outbound.protection.outlook.com ([40.107.95.52]:44193
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240539AbiAXPNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:13:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuzAZOZ3sUrbU2IMPSE/jjXWZ6XMIWHezmwwoJ5L6EqeWcMTRaPrLdzQVJ0gUUWFXPEyEIrWqnPJiCC/ep0Tt4VBhQJLYtfiR2Gj1NZ5QnrPWcws7R91KqOopjYXWE+ec+n2QETdX9gNptJh0puSJVGcjZXaYMgWz295t3RPPNPJizDlDMOSj4hWwORZ/ccgtdNuI0sGhkeH3/pDI5gAJl5r15cKFA/R0YVisUbY/u/dmlL3dsP+F9rKN+SQhoKRxWN6BTwDXq+/6cqVyElmoQfetzzNo1MRlivFNtIcLYxK2cX/Di11EYp98Pq1DBsQSzUayTRW3ywObI671ToxZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jtvb5t9cA06BY/orVb7kQ2HYfItsUoTme8hwtbbxHD4=;
 b=NdufzpgPPn6P9gYIfvYMdzWbotEsFZtDpYBaky26lFeli1bAMSFqBC31hFyt5qp/RTdFq8ma251d31fzgRczrALnqhTnpr4w/+T63+y/oWwnWQUve2dprtYPBkTfeSv9jejXPMp6/FTpeQr5qDADf2CnUMQiP54qk+Id6Cz0gGhBh2yF9wHDbvaUrwHHIC2lyBVkKpCXUEGW3HeV3KPjYdiJFjLJSFPvBU0olFNNugK7uxm4bxMScH2W+MVR12zo4Avf/pSAUa1ui5cFDZ2H+ooTbK9V2bclomks7/rxDKeaKHrrVvmNOi0HRobzNbsDUuIQhQ2kXehNAKyBDdYx+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtvb5t9cA06BY/orVb7kQ2HYfItsUoTme8hwtbbxHD4=;
 b=Q3rnHZAc+cBV7O/t/SJQMlMN7Ncn16f69lvKYXFjwDloFYreliZMUIwG8FuGkr3U6peECMa+wvufGDJadH2rmwiHjI6Anke6rLpMii7f7dfwsqtRlYmOp1B1H20DSw93KnvTSW989ohUdVz/2qZ8JLxF7NTzeEofeDZGSqXvLIrRfM/wDNOCyGzikte9JrTTVcdMP6yG7DZLxWX2tp8gLRS0cApQn4jNV+FQqXSSrCxV2Qm1j2O/KuBtFyQyCth1fHD4x+1trB7vyP6G7YWDeFaoEs9IdmvamyuoMRdvg08JM7rW1iPVAWMiySK2FJ7lz28XCzVafM4X9ZpVPJdO7w==
Received: from BN9PR03CA0239.namprd03.prod.outlook.com (2603:10b6:408:f8::34)
 by MW2PR12MB2409.namprd12.prod.outlook.com (2603:10b6:907:9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 15:13:09 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::1f) by BN9PR03CA0239.outlook.office365.com
 (2603:10b6:408:f8::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:13:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:13:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:13:04 -0800
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf v2 3/4] bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
Date:   Mon, 24 Jan 2022 17:11:45 +0200
Message-ID: <20220124151146.376446-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151146.376446-1-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5adb986a-de79-4429-cf14-08d9df4c07a8
X-MS-TrafficTypeDiagnostic: MW2PR12MB2409:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2409CF311567F7EE8F5B16A7DC5E9@MW2PR12MB2409.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eekp1h9PiO/J3xoLUfdRFVUewVL8bzAoza5aZJqXDH2Xw+vop53NhK3Zr2J8hg0BqC8Z18AH+/pQe4fKlgGCj9f2pgUtZZyVkrk5fgeGyso5ofFQHXASFdR63qT0aMGpUswGEuBfWBV0j5XII29XSerDWGkbLIVJAUwxqdRrSJ7BhtZmoN6fFkrrtpZrrRRy8Aqj1OOc2jlDhN39YQxuuF+wZilnOoa1UfacFJEmSqwlg0oTtIn/CFHsYI6fYLBH41GPPydahMgYUCHbmgJb+coQE4+XhX9HVOIwd1MK2X2gU5m9NERPhKJUatqH4QxpnNN8c/CbGZ7LF5j2EcDjl6mL25byBkPwioa5wT6lMHMq1CyqdpghXkR+vJ2Nb7jdgR9TGAUEN7qZlFA7up+M0f2SUmvNaFakVLLH7r+x8YVcjiVFSv56XnWhlm9lMiN2IzpjuD5yV2gbxknA5ZrQ4lpSArOQrEzrQ14fqXZegqsdmbZjo6b1EXvZQFvrq1iGSiKTjV59x0tpfGWwI/dn0pf4w1OVJr0yylLW8v2V58UFFZJmRgieFpFBLZPLRlvSSNuPY9T1guNpvaLVN8yLJ/DUGchCNqLzvvF+cEgHLv1KSq49DLqK3OKXgKax6K5RyKoqqA3tUb24Ts0fPprFszfTvxCt093lXIQmqdOHLCOx849yh2BacSu9sqyLscemmVVpW2To5314kJY3AQ6E9tQjXbaUakrY018rn61yB6oeMGZHoktu6t9j58QTfxEV8PZ16W5F6q1P6RpMqnbsIO3aHd3ua8Q/boctHh90wEY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(46966006)(36840700001)(2616005)(426003)(82310400004)(508600001)(5660300002)(70206006)(81166007)(36756003)(8676002)(47076005)(26005)(86362001)(336012)(8936002)(7416002)(1076003)(107886003)(36860700001)(40460700003)(2906002)(83380400001)(4744005)(110136005)(186003)(7696005)(54906003)(70586007)(6666004)(356005)(316002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:08.6773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adb986a-de79-4429-cf14-08d9df4c07a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_SYN_COOKIES is off, bpf_tcp_check_syncookie returns
ENOTSUPP. It's a non-standard and deprecated code. The related function
bpf_tcp_gen_syncookie and most of the other functions use EOPNOTSUPP if
some feature is not available. This patch changes ENOTSUPP to EOPNOTSUPP
in bpf_tcp_check_syncookie.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 780e635fb52a..2c9106704821 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6814,7 +6814,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 
 	return -ENOENT;
 #else
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 #endif
 }
 
-- 
2.30.2

