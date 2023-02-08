Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CD668EDFB
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjBHLdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBHLdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:33:07 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349C03253C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:33:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gslo3z25UlQh5KoPTS19+mdoeevwZ7Qm84aaOWwhSBR82wc4rO8VCUOKBjmcRLO8F/saWId92I84iVMnf3rOpv+vaCyzg+YUCaXovzQszsI4IfEH/poNAOrtnKQhKvznbnciOLhyRhaEG/8uXHBORt6SlSkJc3nhWJYYLqGbdqhCaci7CeWyLJ+48l4MPIYrrkj4l2lbx20tHsqmUtm+eUjcWUE6BDdnC/0eqx9L3hUGM9M1t+7IG7/3TOao9KWqq51kOyNRvyyeFwYShZfieF4u+PqcyV1OiTlmArvaoOCDFf6yPhApBrXnQaMyDstkO16fDucBng20sSWd/hp1nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSp+3Q6fZ/0b36KstNiGTMbWJdElm+nfe2fKmKIFgHg=;
 b=ZBAPK5XbyEmZ9jNpP1vBMzlUe7Dvcdo/+BftTsgQlfwwN+FKsHNTQ5UleZosCaQbDIl8IlqmTi+IdfGoo9Zv9Lib9iktXv4VKjDvTjeLFIju8KZ9G2NMIPtD2+Gqo1GOTd5XrwUDRhhCODFW7yJqLSW707J0Y7qia2qGS+1sAC9D2qK6j86BOTrx8R+eAa+dxtZi+924XYMmrIztz2t7Q8iYgn4MD4gsAJckDi6uF3w5DC7qVJHWKWhISZh/4stKO2npcjedT0tQNtx5uq/K/xWLItFF6ZX23NwF7Zs1CWjJ4UkaOihDE7R0Gt0Z4TvXdvZrAW0cxH15b8+JAtXG+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSp+3Q6fZ/0b36KstNiGTMbWJdElm+nfe2fKmKIFgHg=;
 b=U+mQX3rYLCIzqNnxtFe6N8EijcBDSmqQCAyGl1CskKTrFSecIMnkaHAggjJAqwV7NdF4UPQdTG1hWm127R7kG+3jbyCvvzj1qqs/PGspYMpDZxm4QDxarOb1AyggAaqKkPj16VFuou56BSWHWjPmQEWEwIFZgYiZJL4+RM1+CwZZ9H4dzzz9L00HVLdckhmLqndiSBDg3oofqJaiH1WcBW+cj155OJV5rZJjr6bvfT8nndZfm4X8avjxK72AwGeGECaax9yow89C/LeJDioYLgMIxdR5XU23xjP4AjD6bKmT+xdZxpyU4KuUspckUFl54Nq+3vai9r6FbflCBReztQ==
Received: from MW4P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::31)
 by MW5PR12MB5600.namprd12.prod.outlook.com (2603:10b6:303:195::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 11:33:04 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::a2) by MW4P222CA0026.outlook.office365.com
 (2603:10b6:303:114::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Wed, 8 Feb 2023 11:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 11:33:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 8 Feb 2023
 03:32:55 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 8 Feb 2023
 03:32:52 -0800
References: <20230208032110.879205-1-liuhangbin@gmail.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH net] selftests: forwarding: lib: quote the sysctl values
Date:   Wed, 8 Feb 2023 12:30:52 +0100
In-Reply-To: <20230208032110.879205-1-liuhangbin@gmail.com>
Message-ID: <87fsbgcrz1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT033:EE_|MW5PR12MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ab456c-ed7e-458d-2e40-08db09c83e33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UsmVjeJ1NDEojShlSJnzIei1WB1u1GZYfF897hyE/nsHrXDfEyBmrN+Lx75KfE6I+GYgNHAfuj1aNwJ7kycgOwZ07XX15bb2H0OYyOQ3cH96t2cCNjVfo6qPgTHP5lXxJz44a150BjjXZ3b/TzCvlD6+hX5OoNfYQ1bDdKKngkVV1A1/2MlLXrKFpjWot2T/K0s1hdx8rBLo+sRHhrn+5F8GhQindGEXS3sA3EhcZ1unfhuM5xcSkijNDsPPXnprHjFu3egjN712JAbNAYCwUkK3bCPLVaWqu6WuFhBTSrZ2PgWMR+lANNW6Y7dCWo6Sx/0lSpwKoi6qFXK9oWCYGzotBdIflCExuQPqapn2+kVg1+fxMdUzo84uKOornE+Ufs5Pgm9G+QlRJj7AGypMPeK2E8oLIlxemNRdW+dq/dij7uorzrsnLicTRPWRSCvr3YyMDXxqWp+A/8X3z2iZDF+X8rlcT2YBQ1rwvJ/vbsn7mIO/L6+rUp7m/eqN+fEcu+OJNpvP9r1te38spHFUsvp3P6wyN06oIg8c1/pOiXDcx87i0eYHM8ZkxFlI/t5DXBsG0kq65I9KbVPwa2gd9W3NX6Zh+C1SuQJP5vu7BZkCWOFZYDsz3a/jkqH694vq+7t2RbP1Zo/kdlSlDFCm6Ds6kkW7UO9Qg/WODWY5x1/L5y8Xr2bCW+xN/VlO152r81UB5K8FgGz9O+R83E/uHg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(41300700001)(8676002)(16526019)(186003)(26005)(2616005)(83380400001)(336012)(426003)(82740400003)(7636003)(2906002)(70586007)(70206006)(4326008)(6916009)(5660300002)(54906003)(4744005)(316002)(107886003)(86362001)(478600001)(356005)(40480700001)(36756003)(82310400005)(47076005)(36860700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:33:04.3614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ab456c-ed7e-458d-2e40-08db09c83e33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5600
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> When set/restore sysctl value, we should quote the value as some keys
> may have multi values, e.g. net.ipv4.ping_group_range
>
> Fixes: f5ae57784ba8 ("selftests: forwarding: lib: Add sysctl_set(), sysctl_restore()")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Yep, makes sense.

Reviewed-by: Petr Machata <petrm@nvidia.com>
