Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5024B661214
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 23:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjAGWqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 17:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAGWqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 17:46:12 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A80B1BC9F;
        Sat,  7 Jan 2023 14:46:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjsLY2CJM0UH0OtHt1fM8GbfTU2jRRvFCGh77JHKYFF+0pmsEjUHxWPGYsHohO//n63HVfvx86VAc2hw3AcJcrWptbhQESB7y7Gom8tTk2KuE1DG2UK8J/v030rWLKpvdUqlr/oBdvVtq0RKIJf7TALrEwpvSNiuZTQ2NgGthJpnhI3CztiilXPVOCPZharFDZwwXpnKHS0jtwta7qWymRbXTeHZuEndOJ3DOPnVvriRLiPK1qitjX54U05X/euvrQgaXGqoenTkLsaUtzcieOgKPZt3V0MfP81wvtTblOFYWmAzZeW9TUKNZI3ePrmJV3xTNOutc4BkhdpIt7h75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPZqDCFp/4OriRWD0Qw9BaBsAvX4JgHWhsp4XzuqFbw=;
 b=VO2qfy1cDHq7dOV5PVQF3iovjxYZ8J11I8ZzZUyK/TFnGZNAdtb6tFV6gGlom5C/AdliDm6Kr56617Uf7w/heBS97I865/PMySge2M+fvVqG7UhwdZIm88q56tTxUbRRscyDfNokoXhhGvpQ5Au0vtfCF+JEbmaTBkl7xKFWXdSJmQHBb69AUup8hRJwiFQEemXu8/VDoEbEysRrTJcdUp17nuPiL0d4vWsjohhHdL8IL5bCtTytbBHTcyArWRWfZFY8oxe+hFelmJtgw0lMqIMKVf4AW5Vt/fQSAKoNT31/Y71VtJZwAXFb0ZKPJ2PlDJ51C0ZQccrSq6xbwrXUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPZqDCFp/4OriRWD0Qw9BaBsAvX4JgHWhsp4XzuqFbw=;
 b=kTgP7M/ALZ0aXOaV0FHH1tXuMpybh7ko1XjXO9HkZiel0aStTHFfg4dsYy8SujgZFbtbgBtUU3jeS3Pm3b1C/ugD/8P9vQ4snUp7WWlBiv4qzWv/GOflOZcTfIdRmf1yRY+7WFEpGfWYEE6k8PWWsGQMTOyAzAdEC4uvsZn10FyyE/LxJwDRUfjCFMP494xPSnyk0k/ZX3JqEd/hSaKECudtGTKT+AdCnmHt9Tn6fj12vWglQ/ck0JD6pNj6FziGjd+pTtukbZ3ouYe42XO/rsUIRgQnTr+1QTuaiRVFuQUYwe8LV5ghOtB7NxgLOXJoyy1xC+V8R/B8PGGna8C+pg==
Received: from MW4P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::22)
 by DS0PR12MB6605.namprd12.prod.outlook.com (2603:10b6:8:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sat, 7 Jan
 2023 22:46:06 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::49) by MW4P222CA0017.outlook.office365.com
 (2603:10b6:303:114::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Sat, 7 Jan 2023 22:46:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.14 via Frontend Transport; Sat, 7 Jan 2023 22:46:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 7 Jan 2023
 14:45:54 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 7 Jan 2023
 14:45:51 -0800
References: <20230105232224.never.150-kees@kernel.org>
 <87v8lk7x9r.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Kees Cook <keescook@chromium.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] mlxsw: spectrum_router: Replace 0-length array with
 flexible array
Date:   Sat, 7 Jan 2023 23:44:52 +0100
In-Reply-To: <87v8lk7x9r.fsf@nvidia.com>
Message-ID: <87eds67ylf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|DS0PR12MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 04193b49-a12f-4840-bbb8-08daf100f62e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yiCQb1DYqOlvLrLA9gT8cokGmzchoLIi3JY8Ap8KBCV7444FO29pTMy/DeVG8RqHwYZqERFT2Xdx59nf1zzfa5yLwRKTaWwQEIoDrlOZ4tB455fTI5xsQgXBc4kUuN3a8hs3+nZvIgyua6hlruE87gMb18SR8r1C8TIfcY3nJXF36hDz4SehbqU1ZQgi40Rz5/+1J5SI6RMXYK7ofZnpkbPY7N/So2z822b94ifBHrd2tOidttXfoGfqDVA1XgU7PLpZemqV1Vxw/azpS9XRF7A3s2B/euQL4Q3cmCUk/v/BJcgAJ6cxvlpbHEBCgPtLp/PfchzWArmXTx9YC8F1XfSiK9mJ/HwN/eV/OVnumKYuh3LbWW4ZrK8R1X9rSc9VNdUEWhQzh/RDZTTckpI6+U7r+xrEc9KAEcnVTKmWVxDOuSNx3Z/9YdJSqIaTJx2eZvONoS5OcuEC4OKSbJArrGTOeatsxXL7SQfFyi3bXnY4zGi6PaocDokgUDVa+/tB74yhyr8JGLPF9s54lzLTsVXUm1ZdfinjqUEhHS0XE3NyAa7gi0M/kHbXwWHRo4uv9sian2qz8txRKxKklKLyOJx3nnC3OYD8IV6VIxBoxhP782X5uooWsCPPbUsdn9S8qIpJq9x6RlunIyv6r1DjjVNlPNIxGujHc1dTx2YhI848ZbaR0babcbqV0EeEZ9+uaPw8sreuE48ZJTa3e+ex7Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(4326008)(70206006)(8676002)(40460700003)(70586007)(86362001)(7636003)(356005)(478600001)(36756003)(316002)(82310400005)(37006003)(82740400003)(54906003)(2616005)(6200100001)(426003)(4744005)(6862004)(5660300002)(41300700001)(336012)(186003)(36860700001)(8936002)(2906002)(26005)(16526019)(40480700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 22:46:05.7960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04193b49-a12f-4840-bbb8-08daf100f62e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6605
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Kees Cook <keescook@chromium.org> writes:
>
>> Zero-length arrays are deprecated[1]. Replace struct
>> mlxsw_sp_nexthop_group_info's "nexthops" 0-length array with a flexible
>> array.

[...]

> Thanks. I'll pass this through our nightly and report back.

Looking good.

Tested-by: Petr Machata <petrm@nvidia.com>
