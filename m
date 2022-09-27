Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30355EBF03
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiI0JvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 05:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiI0JvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 05:51:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F92B7F1;
        Tue, 27 Sep 2022 02:51:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmB/zElAVsRoEcECQ7nqaYGnS/fhVNEFKFSpIgu86oV3qOSUs06kw2xAATBaKj68EAE1nHNY3NloDUmuLe8MsdlR120CR9+a5K+01Mt0xYnC4kdtXdIt8cpM+Qzk5UobUGsovCdt5sQsZN3GXLDRjl1z9bxDzDqNVf22TAJ4k1G4vQL4wfzm4AXOxzfQTHohUHG0R1rNBOnTgEE8gixktuICJxZQHiBNq/ccmrRV6XbmcYdQA6rYpmXOz/4z57HDl6CgM94alUTQ+udUm3KzJg1M5Wuz2hv7YeySo4HO6a3VjBdBWVPCjwb1dnbVLOinuiCwXiFNWQ72gqRqTpIBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epIjPrBaoXiv0MKUpdJb+nD5MKbMZOo0Wt51J3erKmc=;
 b=WDcnvI1cVgGg3rNb3tLGUrJTuYDHAH6PmVHT+OOLbKTeaZN+fh+HsRSXNGud8dMOnfLQBIcQ5l/E03rBQD7VqkpfLa9P0eBfbeOXZ3K58yZ41gO8Ud72XRqQddAnwwBA+LP3tA7q1pD478cqiN2DgRcnvRb4+3/EPPoHx1kvNq5pFh9jWmdOcNaXQT7ydMdAvcHgLjAN+RzDj4KVcAxx2RVv03U+9X3ghrG8YdIFKVo6cjy2bnK6LaeyfoKVrNfGKZx3d11izlQdHi/Xxlt2IrOtT6Td989UTUnA6R9ntmpTzHKOz90ZWL1H4/FOvsAicx4aAIJZ7UPGuzleMkcVSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epIjPrBaoXiv0MKUpdJb+nD5MKbMZOo0Wt51J3erKmc=;
 b=skSZlSxSSRgaXgUxgLHYtx3RWXlEiIt6M/c5sEGxghJ/Oh5dgKSIn/txED2xdAGMCKhz/FBONQlLmbxrincJYofZhT05UK+SDw1JiAAPTPe2WcXjVCvskRy033Dkgp7CmPSpNnGmbWi6AKpSvgP2HKSJcbBPI43KuwphUVCWI+rsiI4VSrIRk6TzwgD5jnAHvSfuic+GY1eXg8dKKDS6rMinSprDQaDmu7GmT3YqHq+DwY3a+pyPqPtRmL4F9cCF1gPV4LZq2/t2ngD4kcE6q1uKC1+/X3dZ/PzsClIVFMEXqZF6uAzDiKjItceoDICXS+BSQ4s4S+p1OTsvBNN/iQ==
Received: from MW3PR05CA0027.namprd05.prod.outlook.com (2603:10b6:303:2b::32)
 by BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 09:51:14 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::60) by MW3PR05CA0027.outlook.office365.com
 (2603:10b6:303:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.9 via Frontend
 Transport; Tue, 27 Sep 2022 09:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Tue, 27 Sep 2022 09:51:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 27 Sep
 2022 02:51:02 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 27 Sep
 2022 02:50:58 -0700
References: <20220927004033.1942992-1-keescook@chromium.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] mlxsw: core_acl_flex_actions: Split memcpy() of struct
 flow_action_cookie flexible array
Date:   Tue, 27 Sep 2022 11:50:42 +0200
In-Reply-To: <20220927004033.1942992-1-keescook@chromium.org>
Message-ID: <87o7v1w3gg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT039:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: 4718857f-4deb-496a-6fee-08daa06dd114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j07zoUNJnhxW+udkQhgC8qf93WwdXJXQhYM0ePiKho4xN/rGitUNoyEJR4Je2bXn3dw2dn0YqbGESSFQUKiB4rlCwvAmzpqZ4Hv0DUS5JmkUuO0EQgkHBhhdjVtgyzffd2MvelLMz1KDxZPFfDOxpLSUWaxmIw3DBW0U6MmRoivCMOhnpnqkcz6lJx3q913qp8ErZpg+tqLcF0mIQsbfAfBKEki3VrUjMwDP203nnJg6NThi+4bod0tekQC1niiSH/XyKevN+73yaR3THob/QgrU6JOMTyZ1v6Btwl/s8cqv5yQbYR5Go6VDc41I7LzLxqk0haI9zYS9wlvu2F/vikSWzvcoQpp6haIJA8XELLcSVh73N5Iyqg1J0pIEOQwTG2TB+JC1R2ujVgN/rXJpBu4kviI2TXs3wLNvOmQnSTDOdzE8atnPFUtsGQfVPu+rHGwTvXhUqnXi4sPFFP+8333RL/JxAF8gtmXYPr2sq5JZVzKeHBpl3RA8jaZiAo25VneKo/1312tqjkx1/khs1G3ykmZ/DRBAtqxHmQgOci9w/Ibz8y45RplQy9XwELp/JQAOAouR+FBhMYFQR8laUTadyJi36g0eF0MDx66Cf9X3DLYw8T8wt4qUB04oveuEwPm9jtlgKobt+vOCVakUVTF2ByEwjGdoZtpo/fjvx+7rHk4QBpVHIXFRYWOrhVcwfycZX2AWFU+4Yz70VIUMsanXS4GboHh7QHf6MSgRYgVOu11xBEUoNFBc17rrvalMLUw1hHf/UkTQEIGKUjBr5uILU+K4fsm6/E06HySTmTcODnlgVuprlYcsQWV2Gs18wED2XhMuhwA1W6tu6+0+3YPENVt1UV9SIfp74iDXXo8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(83380400001)(336012)(426003)(36756003)(47076005)(82740400003)(36860700001)(356005)(40460700003)(7636003)(8676002)(70206006)(26005)(8936002)(70586007)(4326008)(4744005)(2906002)(41300700001)(5660300002)(86362001)(6666004)(2616005)(966005)(82310400005)(316002)(186003)(16526019)(40480700001)(478600001)(54906003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 09:51:14.3659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4718857f-4deb-496a-6fee-08daa06dd114
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kees Cook <keescook@chromium.org> writes:

> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
>
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org
>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Petr Machata <petrm@nvidia.com>
