Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9712E48C24B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiALK2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:28:46 -0500
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:28393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352556AbiALK23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 05:28:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0x7EZXJlPjKkErhc/sKOIebF57U9ejazlGFG3eQyeZ+cwarN1MtCeB/bNw+GA09QNyePqjZI+fi3+cR3cr+kE0IM7Gvx7TF+L5LyYKQxR/NtddkPjWTPBNyX8n/2MRTBLT6GqzlFzSOJPZzFvTYv+N90HzSrmSz/Li9HOFAOvTmMa3uDvCy5bS6Mrd3LHcGqw2x5XWQGITRBnIWJUoqJAiYRV/BwujPDjLbOsPmbkLOaS1Q/E2njOZFvajwFp1xonyxvwnoO3M2Ovde6v1MU7VO30MwRxDx5Pxi+Hr95MbZ5ld9FHPwOiEPwvC+ixsqNRGLgKZ/JtjUrZBx514SPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzDKMSFD2Qtwrkg9kG8uFXAmzmZ0TrijuITL3Vvre7E=;
 b=OliG+Dmx8tEM7oQCnQvh7Jb59CqrpFQsduobUvgozNyjr41WbWiKiedhX4t8rQXMQp/O7ZyLU9sBIMeNQa8DgVY5OAmZKsTkSqcTWv+oL1AN3V9yNihnEQDrrSTdit/oJrGyOxJHYBjM/M8GyiANK1fxjxcURZu1W8lhnFvhWGHh8ySnrzjLoHMclrjwBCSFyNwLybvrxuHSSgJEALrUMvTJWwlI9l1aCcZ1soBDydXxsjvJMZDgi/rf4D4goHRF/4ftqgP+YQU2msSc09UbijE4rjTVU1oYEOveqitHHrNeBi0Ik6vxbYq4IepJOtyH5hEB/kou7V67+zCoY50eoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzDKMSFD2Qtwrkg9kG8uFXAmzmZ0TrijuITL3Vvre7E=;
 b=Vvuccn9Cz+5wbjGg4oDsP2WyhD43RC+EIxSdp5VyQ7o6DIwzxgEMsyfgnrMMFsL9gx59pOLRCbHKsTyv2dwH0CTgLUBR20Bs9t9SU8cFd1OR2XKYIr7h+tVyxpDV7ai1FINE9jbXDJ+2tacd64FsQzlT7p3aNZfhO4DRfVlhAQzjyZgRqF/St/P9Zudm9N7pwEal5hE2bymINCyzxO5m3ICNFPEeCqQCAaLxH2+WT/XOnAc2tW+cy8uy0599G0U41p5fqquW0+ORVy5BdE0L/Moy7ocKaGrcSMO3fXHIEQ5om495Zee4PvWmPbQAIP/KAbeAC4wm3SWCeLh/vloydg==
Received: from DM6PR07CA0079.namprd07.prod.outlook.com (2603:10b6:5:337::12)
 by BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 10:28:27 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::a5) by DM6PR07CA0079.outlook.office365.com
 (2603:10b6:5:337::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Wed, 12 Jan 2022 10:28:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4867.9 via Frontend Transport; Wed, 12 Jan 2022 10:28:26 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 12 Jan
 2022 10:28:24 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 12 Jan
 2022 10:28:24 +0000
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (172.20.187.18)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Wed, 12
 Jan 2022 10:28:21 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH] sch_api: Don't skip qdisc attach on ingress
Date:   Wed, 12 Jan 2022 12:28:05 +0200
Message-ID: <20220112102805.488510-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54a92702-977a-4ae2-b8c0-08d9d5b644dc
X-MS-TrafficTypeDiagnostic: BL0PR12MB2484:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2484506FC795270242AE0C50DC529@BL0PR12MB2484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SAneaFq+HThBvLggbYE9g6kyi27fM5ehBt0BWS2KeBorZH52fBd1ESwZ5pa0eutWqJDdrAAdRWkRHgySIo1rcJ0FedrPJ+Yn5SeNgqRvvvdzil2gl7noQhFN+D1mLllVQ/d+hMt99FhJxk79PdU3/zi3O8OubamfzUWNjcdaPeglUiiAsou5U109Uf0fpy6MI3VJ20jrdXYxjtI6iTxSsdVS8itDLUvX9Xwbt9ikPmvo6FqbO/niL5VAI3FR/2iCHfMBcF0kESRSSjyv4itRqtXgFv3G0FNnP+kzcK3U4imxYMhtShEHfnYf6Z3SE8322wKkdwd0Grxm6EdeOuxr8CEClqTR1raoIdwlzq0Up1areo0MZjiSDn2WL+eHeYongbBhYi+/TEhwlqxV3CBA3sr4TVb7IAL4nWNb3GpB+cBiBNSfNUnWmoUUhmCkxpsn5HdvvX3e9u0nW4rwbsvwOtUChBZCG2xmDNMPXIoYkiIHVeTaENztDsdYOQW82jHQgrMzD2yevMNRkTrH38frdQb+sIxHYlPeFHNVtsJnnibY72iVbyHQ9v3RbrCJTz/Gmc78mx9P30DNHvB7lUuLf5cKpWlCva7m3dn3tL8B/1GN3udCezIjsyrEFvb00VSoSHXENF9R3v3uqK39pkm+if+wweYBRgLovdIzvIE1Xw+E1DvbZ5RXim/0uZ0woeHsyBukjZIaIxYUQc7iei2D898RGhrtFf06PsT/PcV6d2EVhMs+cC/x4Lfe2bE73evsUQCqdi/gMneQtoFWAa5pmBLKO8MkDqGCubAMXuqdr4=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(36860700001)(47076005)(426003)(356005)(316002)(82310400004)(83380400001)(336012)(4326008)(107886003)(36756003)(6666004)(2616005)(81166007)(186003)(40460700001)(110136005)(2906002)(54906003)(70206006)(70586007)(8936002)(1076003)(7696005)(26005)(508600001)(8676002)(5660300002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 10:28:26.4465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a92702-977a-4ae2-b8c0-08d9d5b644dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2484
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attach callback of struct Qdisc_ops is used by only a few qdiscs:
mq, mqprio and htb. qdisc_graft() contains the following logic
(pseudocode):

    if (!qdisc->ops->attach) {
        if (ingress)
            do ingress stuff;
        else
            do egress stuff;
    }
    if (!ingress) {
        ...
        if (qdisc->ops->attach)
            qdisc->ops->attach(qdisc);
    } else {
        ...
    }

As we see, the attach callback is not called if the qdisc is being
attached to ingress (TC_H_INGRESS). That wasn't a problem for mq and
mqprio, since they contain a check that they are attached to TC_H_ROOT,
and they can't be attached to TC_H_INGRESS anyway.

However, the commit cited below added the attach callback to htb. It is
needed for the hardware offload, but in the non-offload mode it
simulates the "do egress stuff" part of the pseudocode above. The
problem is that when htb is attached to ingress, neither "do ingress
stuff" nor attach() is called. It results in an inconsistency, and the
following message is printed to dmesg:

unregister_netdevice: waiting for lo to become free. Usage count = 2

This commit addresses the issue by running "do ingress stuff" in the
ingress flow even in the attach callback is present, which is fine,
because attach isn't going to be called afterwards.

The bug was found by syzbot and reported by Eric.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reported-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c9c6f49f9c28..2cb496c84878 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1062,7 +1062,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 		qdisc_offload_graft_root(dev, new, old, extack);
 
-		if (new && new->ops->attach)
+		if (new && new->ops->attach && !ingress)
 			goto skip;
 
 		for (i = 0; i < num_q; i++) {
-- 
2.25.1

