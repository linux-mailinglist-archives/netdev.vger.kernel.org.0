Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A514EDC8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAaNrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:47:51 -0500
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:1811
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728659AbgAaNru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 08:47:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9apxW4gZCTql3E72n3bZB7C+c8gSOe80SAHOX5vLh05cHz4NpDwK8pg+FIc6wXWcQPS8c9u1H9/5DCGgOs/ergYJ6MWzpB9baJM6FMuHAI1Pe2L5TSfVKxHuKozqCCCyWvBp5/3mb2hPEeUVEXvCfD52OJsDGsyH3/eVTfkhOcneK+8TODNgBXoUzAEluAcnu3wKfzSpz33Rj5Qm9tMz3wK1U41+CNINTCsJba1IP01m+B7pPZt8TxgnoezGZt5svgxZtpWcmyuEuOUojUiDr27LhsYpQ9h/yaCSl0eEBESdzNFCh6QDV+R5UHolzzISLqjnXkOo3bF1XyYf1Pr6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hgaxi8MbBSnQJULIoR7gA/P53uyF7UsXANPuKSbmOc=;
 b=fAOyTv8NqSXCGp8ZOCHoPxnqOhdWbIjX/MG5JWwwVnQVzfsmQCmZEYm0aRjKeBMKwc1c5hoTAJ17J7bFGTI0AjWX0y8x1XZBhUrdzgkG4HDoqRm9sK4A+/BjFy8S7kZ2QkIerpijs45rlzjbUOTmnaCYknrH4nw3XSrXByzv2M9VJJq5RDwVopx9rSN7ZdIh39hClO0Bz61b/7+X/lAi8dRJWEpqLb6KjOD14d5Yoi4aXZHGZyBZ8p+tqxCvViQV+sK/xOGUcIJj0B68EV+jVn/EU4k715vZNkjZjto1mgtwbU7eRVLSBvdA9Y9ypmMSYxLdBaQMnLohvnVv9XOp4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hgaxi8MbBSnQJULIoR7gA/P53uyF7UsXANPuKSbmOc=;
 b=YfAegl3ZgUt3lThrcYfI+6ozGbuE0tDcUU3t1v2aTwDl3n7FqESZURw5mNmy5er70LxQCGIp0OxtToc37Y/MW39bK7HAOg83ZHaXgi5n8XoKkl5c1C1Eph8XBUCbQR01R0g83paiN8KOEin5PShSEJq+S1ahEwZBxaU8TrabACc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from VI1PR05MB6734.eurprd05.prod.outlook.com (10.186.163.17) by
 VI1PR05MB6544.eurprd05.prod.outlook.com (20.179.27.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Fri, 31 Jan 2020 13:47:46 +0000
Received: from VI1PR05MB6734.eurprd05.prod.outlook.com
 ([fe80::5d57:f705:a027:9cb8]) by VI1PR05MB6734.eurprd05.prod.outlook.com
 ([fe80::5d57:f705:a027:9cb8%3]) with mapi id 15.20.2686.028; Fri, 31 Jan 2020
 13:47:45 +0000
Date:   Fri, 31 Jan 2020 15:47:42 +0200
From:   Ido Schimmel <idosch@mellanox.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] mlxsw: spectrum_qdisc: Fix 64-bit division error in
 mlxsw_sp_qdisc_tbf_rate_kbps
Message-ID: <20200131134742.GA132810@splinter>
References: <20200130232641.51095-1-natechancellor@gmail.com>
 <20200131015123.55400-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131015123.55400-1-natechancellor@gmail.com>
X-ClientProxiedBy: AM0P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::21) To VI1PR05MB6734.eurprd05.prod.outlook.com
 (2603:10a6:800:13d::17)
MIME-Version: 1.0
Received: from localhost (79.183.107.120) by AM0P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 13:47:45 +0000
X-Originating-IP: [79.183.107.120]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 618384d5-3a8b-4692-6b95-08d7a65426ca
X-MS-TrafficTypeDiagnostic: VI1PR05MB6544:|VI1PR05MB6544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6544B5786C0B5515762843B4BF070@VI1PR05MB6544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(8936002)(6486002)(16526019)(81166006)(8676002)(54906003)(81156014)(66476007)(316002)(6666004)(66556008)(66946007)(33716001)(4326008)(186003)(9686003)(2906002)(26005)(956004)(6496006)(86362001)(478600001)(52116002)(6916009)(33656002)(4744005)(5660300002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6544;H:VI1PR05MB6734.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a/VRNO7D6qIUx1APwYtaQAGpMFPiW7gBQu1E3NmLOYrCbcroQnlW3/7uTs7zgaP0Fm0wk8WSHysDH20jCc2cdAeTNf8d/QmP+Td4ntCsHwtBFB1TXGWGf4O6tjD+K67Bjl/313klBqGtxn9YQCsGaMAAv8DrPxNlLViHdA2nDBABaCNafo6kYXlMLX5A6Cx2majLB8a67OQMRKrL+McHQTB+WkCdE34qnWRLDmpwv8uqKuwaZzMUPjbWfFr7YaLqaTRbzgLMcgjzsFGw6YPsBeH5p7qiBKLSIifoeWJoA/ziSDd/6XxiEzWJQaPgHawbyly4HNKk/maenom7pIiB3HXZ1m4aY4DkKkaBWxyVBnvIxmXdD6Y8t0cXujz3zQhBsJEWKamCLzNc+/EMoeJk/JCCA1ZemrD/erkbkAHR9n50JuwLGLB622o0hU+9OfPs
X-MS-Exchange-AntiSpam-MessageData: QPLUvxJJ+EHfIgwfd0RSjWAWLV4UFQj3edCmySLRO52GY0Wji4Iqriw/C9vkNOkTFgifChn1BxpZu3xTTINRxrE+IRtZEAIaUFPbI4qfbXnAIKoloQMSx2ZOAltUpwmN30TU75hfcyQjHPV5H9XJxQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618384d5-3a8b-4692-6b95-08d7a65426ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 13:47:45.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCgPbxHGV5rk1tWlyMPCnp6nNAwPtrsJTS/jE7iTSVAJI01xKEFZdggoFvZkjl7iWTXVB8QT+bbO6YHCCwEZ1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 06:51:23PM -0700, Nathan Chancellor wrote:
> When building arm32 allmodconfig:
> 
> ERROR: "__aeabi_uldivmod"
> [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
> 
> rate_bytes_ps has type u64, we need to use a 64-bit division helper to
> avoid a build error.
> 
> Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks, Nathan.
