Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614014CF7F8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiCGJvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbiCGJu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:50:58 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1E661A3B;
        Mon,  7 Mar 2022 01:44:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guLVFBWwsdaV3lNFAMJxo4Aikamhb6ldFeHSTPb5pELOZSRribzytVQ/d+1RvD0O8NJ/8PwF4MKuK+vE1JwvHSwOUK7zOg1VfxM2EVzVypIdqgqDl1Xi3eE/cw7wqkNSm7deoZeJbxsvVkwI6SfUSIgcJjUfgZWHrkHuCss4Nn+XXP31up1CMTcwGzKRYnw6L0rXatUbF+vZypj/tMbjwYsy13EckHplB7JMVOVEKztTUYdSpVbl02X8ufiTsRBTELz89HaiKv2fRyai0UbWNRKN8x5+6XxSs3ZZH1fQvr1Rz8z7X3lbjhzCVhVt85Y+g6qO6/CtCaXqz/aM13MBiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pow5pQn20Bk40GvH2a4BuZ0BZMAnvGe2VBix6ZWbMs=;
 b=A2qrigPyJGBsui2zSuBTwArvtHZ388Lhyxu50Grw8BSRw0TNWqe5dz4Fmzqw4FMbJ5CmV/XNyMx1qfFp4822+cALR4ncG9uo8aEqKG9zKIrTZyMIApOL9wtEa2eL/xCsBbPkda8xSrzQXOqYgktMnPbfqZLApPDXQr/Hu0GsEn4orizoH1zzKLD1iAzm2dz6y8Z/HmWKOBIowNNw/lfm0n0vr/6P4Lg79+8a0ASTj5tN398JUzos32ovR3AxOBFO0+nGiFwRVWfm1d90tp3xV9e5edb13gGxJdkMbFh/YVaGv0IGRFi03oIz4jZzaLfAWSKQ4gZZFegp0x3kvYPUTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pow5pQn20Bk40GvH2a4BuZ0BZMAnvGe2VBix6ZWbMs=;
 b=bmdFmPA8wGSyFy/AV0J6P4j1/7q0OKQYnSybV1HKmB5J6hKh7SbOEA1ciMgjxwpwFL367IS+LwJjjWfyKf/tT8wZjAIBNUFxMmqCFSvrESiMV2iorMCVdx0rNtT7FMw1T/rEsZkEOANfufcf/GtQTyKcZiMJNXTeOSBKn41A51hObI4OPHEAP/wK9DffqvkSuiZmABgUfb/PGrDV5hw93/DCBqXCkiPTHDUe8L1UyX768zfmg/9wE7AXfmOenF1l9c/b/qk31xaWlZGfoOMdti5PjLsiEy8amxestWMRVzfloY/Bo1pdCuXFMN0VEB1czzlCcme0Sdzr1ltCi8tEtQ==
Received: from DS7PR05CA0065.namprd05.prod.outlook.com (2603:10b6:8:57::10) by
 BN7PR12MB2708.namprd12.prod.outlook.com (2603:10b6:408:21::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Mon, 7 Mar 2022 09:44:21 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::20) by DS7PR05CA0065.outlook.office365.com
 (2603:10b6:8:57::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.17 via Frontend
 Transport; Mon, 7 Mar 2022 09:44:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Mon, 7 Mar 2022 09:44:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Mar
 2022 09:44:18 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Mar 2022
 01:44:14 -0800
References: <20220305181346.697365-1-trix@redhat.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     <trix@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <edumazet@google.com>, <avagin@gmail.com>, <yajun.deng@linux.dev>,
        <johannes.berg@intel.com>, <cong.wang@bytedance.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>
Subject: Re: [PATCH] net: rtnetlink: fix error handling in
 rtnl_fill_statsinfo()
Date:   Mon, 7 Mar 2022 10:43:28 +0100
In-Reply-To: <20220305181346.697365-1-trix@redhat.com>
Message-ID: <87sfru9jwz.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c68a1a-30ab-4467-4d72-08da001f0e73
X-MS-TrafficTypeDiagnostic: BN7PR12MB2708:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB27083BD979E894CD984111B4D6089@BN7PR12MB2708.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhHb2C3DS4Ccsfv7qQ46y4f61mp3DktlD2TTG9TBjFQPptoegfAJjWRRZBNhxSuliF5YyshYYJRcg//9rZRgMgBg5dig0lPmT60vaNPd6itq+2KAPnmfSdu3EGfoP48FgMa6IodoqVEWDqFWxOFcEOxxIu0R4ssITbtPn/UVIvKNTJbbS+LTwH6SXyt3dEDg++MCPjbdyFnACqNl8MAN+OTBKlsg6oL7SoL4x2voEUWH28noWSZVcGWiZc+yY7Qyn3tSZDmJdQlPAFBBeEVqW5/WZQfyG+plMw0ddzM/orKbUr8ppVieGYK8chFyO9GXA9RvFgRfVPG+bM4BsW5Hg1NxkQd0kHmU0v55d9u0lM26BftobSfuSpz3dZz2jSeNYnVAaXzJtfkRxlpzaK+/kce6g3h9v1SVOWId4Qrl4eiaMCD5ZvETwfNZ3H70WERzdSczg6szxbPzmNM4OijM0PyXbclRu4NMc+W/6Qf/BlZ4pmQ3L1zHnX60uuajkmCKMUgosZfS3CfKHjEFa19SJw9KQ4onfYVUcv2mYCXZW8w+9gb8QBlB//DTEbmnT8AibDt+DxrfxYr5ny80UNzftbHGBRYp2MkEqS4BecPv1NjIyhU9Bnm39eNqtdVQclY3YlyxRnyMWRhHvTVRyxIgWhKyKKfb/QizLI/ICdIej06bzCrT6j5BbhFfKlV9CCQsl0dQ8V0asW4mu6n74T+9sA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(186003)(4744005)(36860700001)(54906003)(6916009)(16526019)(508600001)(316002)(47076005)(40460700003)(82310400004)(70586007)(356005)(81166007)(336012)(426003)(8936002)(2616005)(6666004)(83380400001)(86362001)(36756003)(7416002)(4326008)(8676002)(70206006)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 09:44:21.1207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c68a1a-30ab-4467-4d72-08da001f0e73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2708
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


trix@redhat.com writes:

> From: Tom Rix <trix@redhat.com>
>
> The clang static analyzer reports this issue
> rtnetlink.c:5481:2: warning: Undefined or garbage
>   value returned to caller
>   return err;
>   ^~~~~~~~~~
>
> There is a function level err variable, in the
> list_for_each_entry_rcu block there is a shadow
> err.  Remove the shadow.
>
> In the same block, the call to nla_nest_start_noflag()
> can fail without setting an err.  Set the err
> to -EMSGSIZE.
>
> Fixes: 216e690631f5 ("net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns")
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>

Thanks!
