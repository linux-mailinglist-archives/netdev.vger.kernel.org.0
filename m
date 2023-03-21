Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69236C30E7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjCULxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCULxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:53:12 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248910AAD
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6dunNIGLuFEsojcG8C9SpnRZ9A3ctlI6U5HzdVXz0vWs4o2p/g7ZSddHYh74+FS9mIvdoZhKhh2Zsf4yG5e1vEzCl0elpSi/9gOnkI+CUa3t0OTA2ptq866MrhFEfx6g3qucF1Gk60ojTmduwf0ZbRG2VPLcO64xGxQgaMDUxtG4o6Pkghjq266rNJ9MXqIC9SO9XQzoMagv9x/4u1+fXeSzFg7u7hHi5DqRXZyIKxKficd+e21blfhwN/FCVck1sYioWhNOw6LofEs5m3T97PohriDF4qI4d0Umtv+ZHiwQ1vKvslgE0FCH5jZNQVKR/m1rMg426TzeW79g+9quQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjSmCf5p1ojbdlYmCt6uCkqWhzlb8GqNif4nJ7kSfWs=;
 b=S9aJEpeMXxfuE5VL2fa8I1EkT7sGuxJr9rZPsRa9Trppn/lMO1RbuXIl+eKBDx8v76gGDz2AW3EO18WRQnJfY+SYWd3nih7o7IPqUeqZMFiTyH8Z8h05dcPP4TcarDtmDsGoS3AMmlf99g5gnQ7oVT0Q+fdBjCfu8USEtWGZzmCPnxuXNkGKiWORcAxbs0Cw0P6sRPjevbAveQVs+zLWoTIYz8GlGNpoqKHeffpOeBSOcc8n1nKaY6SCQyLh4IStrvOmyjHCjVWRgRwuWk2EVq6ljsA8s1A6M50a/lDwJoevUnNXZfDxo1uNX8zufywZvaziDmIZWucxrmhkRVc4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjSmCf5p1ojbdlYmCt6uCkqWhzlb8GqNif4nJ7kSfWs=;
 b=dBlGyJhM2DTDctiZFj+Vr11XHS9QfxbxDdGLL66sn/+YC0xm1RCB0/6ls2QfJo5fnUxW6fTFkPyvVY6ViqKMIWEIq4xNaFpNoYFNM67YEW7OCmTx7RBL9jcjx1QTh+liCHXrGShWCM7Na02jrAFz386QD8fpUTVTVvATQKKJRJogRRyyC6TaCUuQFKTl8fvz34Lgfke6QOpmNux3kO9D8zHQQsl7FHff+a40WEHPNNxxfi742fsM4s+TBWHyKOLHdP/gY7RYOfe6Wr8t7oEomMdI2gip95zcodeX8Iqg+01HbeWbi0mMxlm+7CHNXIViBRyVLvtJWmOjhLl4IpISCA==
Received: from MW3PR06CA0020.namprd06.prod.outlook.com (2603:10b6:303:2a::25)
 by CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:53:06 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::1a) by MW3PR06CA0020.outlook.office365.com
 (2603:10b6:303:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 11:53:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.16 via Frontend Transport; Tue, 21 Mar 2023 11:53:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 04:52:53 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 04:52:50 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 0/3] net: Allow changing IPv4 address protocol
Date:   Tue, 21 Mar 2023 12:51:58 +0100
Message-ID: <cover.1679399108.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT044:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e02950d-5d52-44bc-ba33-08db2a02d54c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IY1exSogBrqfCRd+plyCEjZxqXpPimhMO57135xvJgntCpxHKrXT0BJla4SreWM/hjmQn/FoBMiPXaYP6TCnLdU3MLg8QMyRPUYrFHB6vrfQ1exa6pvl2/uesFcq4Mn/N8J3rP5Z5eUpxgPJ2zc3FqwgLG51Rvb4EcrPWVFp/NoMX6FXgTBNZD8Sjco4F8knyqYSrMuUadWiHVbV4JWRgyiSxcFCAothlcE3uPczvF39LF/tnnDAK3kg+Ce2OlXoSJimELTUotWQHNFTggtOzpIEFtCCyxPEtFWgx5hFCMlrOmQBIo14jIqhL9r0Sp0AZiGpct21GZpffYB8NOggsMQQ1SmNmhreGNnJM5P6dW1MAuDh4pYMkQQ3hIxbj1dO3dzoqPAnc81hMiT6/kfkMjbI9D10i1mjsYgfU8TdrA0UaZoijxv2EWD649XtA636GcVBJtNzgBZ9v57vXWsZBCMz15in1IZpiOmwDyh2T2iP8HqRxZXb1uf7sY9faSqbQmDZ0+AmmAWLZncz40AhvlpaxVPS9a/ilDDSz5i01WP4c5V+eh0h9bGPTNtHpWZNB+TUJWGLV8ZX5sZ+0ShJsUGbfMlEvnukOeMfvTFZwanIUFWRnAwszKRcblyTQ2hebKhjVKPkJmzBpi7D5+MrENruQSQARr8+uClyiLefcfJLG0qI/5lt0cyqSA2DFuECN87Sv2GOk3Flt5LGEsmZmx3uXeCKyZWb/12S+wC5qBqzf5gtTzH2ocEdagHc06xt
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(2616005)(107886003)(16526019)(426003)(4326008)(47076005)(83380400001)(478600001)(336012)(316002)(110136005)(70206006)(70586007)(8676002)(186003)(54906003)(26005)(36860700001)(8936002)(5660300002)(41300700001)(7636003)(82740400003)(40460700003)(36756003)(2906002)(356005)(82310400005)(86362001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:05.8371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e02950d-5d52-44bc-ba33-08db2a02d54c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 and IPv6 addresses can be assigned a protocol value that indicates the
provenance of the IP address. The attribute is modeled after ip route
protocols, and essentially allows the administrator or userspace stack to
tag addresses in some way that makes sense to the actor in question.

When IP address protocol field was added in commit 47f0bd503210 ("net: Add
new protocol attribute to IP addresses"), the semantics included the
ability to change the protocol for IPv6 addresses, but not for IPv4
addresses. It seems this was not deliberate, but rather by accident.

One particular use case is tagging the addresses differently depending on
whether the routing stack should advertise them or not. Without support for
protocol replacement, this can not be done.

In this patchset, extend IPv4 to allow changing the protocol defined at an
address (in patch #1). Then in patches #2 and #3 add selftest coverage for
ip address protocols.

Currently the kernel simply ignores the new value. Thus allowing the
replacement changes the observable behavior. However, since IPv6 already
behaves like this anyway, and since the feature as such is relatively new,
it seems like the change is safe to make.

An example session with the feature in action:

	bash-5.2# ip address add dev d 192.0.2.1/28 proto 0xab
	bash-5.2# ip address show dev d
	4: d: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet 192.0.2.1/28 scope global proto 0xab d
	       valid_lft forever preferred_lft forever

	bash-5.2# ip address replace dev d 192.0.2.1/28 proto 0x11
	bash-5.2# ip address show dev d
	4: d: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet 192.0.2.1/28 scope global proto 0x11 d
	       valid_lft forever preferred_lft forever

Petr Machata (3):
  net: ipv4: Allow changing IPv4 address protocol
  selftests: rtnetlink: Make the set of tests to run configurable
  selftests: rtnetlink: Add an address proto test

 net/ipv4/devinet.c                       |   3 +
 tools/testing/selftests/net/rtnetlink.sh | 181 +++++++++++++++++------
 2 files changed, 142 insertions(+), 42 deletions(-)

-- 
2.39.0

