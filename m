Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02AD24E080
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHUTO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:14:56 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:30460
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbgHUTOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWyS3qsNFefrZM/iQGJ9w8Bxz79b/YBlxhC4h4BgOal3ccbWxy2Ur3XRocGfbqteKzaPvQ/5gR06cZw0d/WZpWnM/xQ12m91ge5CIPuZZCcSexBUaZpAFhJX03DtTE4IhKo7OznTSwvHp1lCBKS7ck/2gTljn9hbbVyTMpnzz/xZHPMggSXdv8nsUuKgoT7NcjA9F4oKEOSI/KgWQ+hrmtfm790jm0/F+aLL+YFnx03fEDxf4DqZo+H6CIqXxi/abYhi2d7R9Wu1PM830XsPIRnxgeRVElaLXza8T9h/j/qdxBFoakhAgSrhoJBKGITKz2kKWwmzqBioy2AjwH1H5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDUy6QPskbeoBd5tH/Ko4zrd4SkYNbyDYmigZjWRzxA=;
 b=kqzdbwCsxSyONbRGs2wsPJuD7bxEKxyhMcF1tO6DVwgSky3P9QFzriKoTyWf9l+WOyGooQBR79WHeihvoxmUUX2PCOlwhcM9b9tJiwqogTSu41dhfEMlNmXaMPLBy16telekNFTpqIAgd8WpAZOUeYT70o0QzTD9KA1tMSPutZ+W8/M648O90g3XIqtx9BsAhE4eArdqrjNVonIsQVj40ltEtGxtM31ZHNMospMvHmWllEO7qTXD2h5bVqq9rglesAMHOobU2cmaID5yldO96vchkCGjzZGBlGZxMG7ukful6mzjOJu/naYWRbIu1Bm/gIv/qzXtrO6HztSZB05TXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDUy6QPskbeoBd5tH/Ko4zrd4SkYNbyDYmigZjWRzxA=;
 b=Un6HjB+y7raZ/yBZi/kS43JjY8DFPevd/bhuGyRRRCbqnmN5TRyla2a+2ftvIWP3e50EKossJl3Yxm7R1tAxg0iPsCO05+dcFakSQvSRGqmykbCAEUQ5SN7lV31E3FLxgjhY4zABVQVxokraonbEoFQ5Unj10LTPGO76FbDW04w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM4PR05MB3348.eurprd05.prod.outlook.com (2603:10a6:205:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 19:14:51 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9%6]) with mapi id 15.20.3283.022; Fri, 21 Aug 2020
 19:14:51 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/2] devlink fixes for port and reporter field access
Date:   Fri, 21 Aug 2020 22:12:19 +0300
Message-Id: <20200821191221.82522-1-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19)
 To AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 19:14:50 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0546030-37c9-46c8-78d1-08d846067a52
X-MS-TrafficTypeDiagnostic: AM4PR05MB3348:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM4PR05MB3348D909ED4DE9D9EEB68161D15B0@AM4PR05MB3348.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIAEYryUGDGmsuCH/4xVwbEufhK5TiBB8DSiODqmcMu+x9oK9vT8aqndb7PpfoIi1VjdN5fF+5jDle1S0bSirG23TZmf6wZ6FzdlDnJ/aYMrbBURMmaMWBTeAqEdK8Izf7W1CHxbel7OeMrNJPUxLxEeILQddcWU1ih02u7LxrmdW49Tt3RF/gzvBvZTSjPBV/XeUGkA98rvSr7WE99PGLxSMshma1mFEWetfRXBbZfK9K6l0FYot3wWoPPz2l1aSSBvkWMmovOvq524rL/u0XPyuKAAXfalcOEU7icFf99SBjHBLC1UqZBnoBWSrEJRS3p6J2wS6AI9HcfdFGG8jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(5660300002)(2616005)(316002)(1076003)(36756003)(8676002)(4744005)(956004)(6666004)(8936002)(508600001)(66476007)(52116002)(86362001)(6506007)(66946007)(16526019)(6486002)(66556008)(83380400001)(6512007)(186003)(26005)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o91J0MHXdk7xkbg1dB7XOzaW7Sibm2OL/L6Tw6Y0BqWR65uYsYz340znTqB3R1muT+ZF064+sqbH/AEjlTxxiar8CMvcffeYGsr8s2RCZRBbFHuFaGY5ejtn1eJzSgR7DjfcjVnoCsw/OMOEZB6/dDKdW1BDg7ByJhJaVXzxrxruDNCvBtzumJiDeRThUmWtCRLppO4wqEPTm1zDi4VBv1aRsekxSRM85fusaCA+2/zRK99x+wBV/u5MivlowxUuxb09og5nmQTHgfaEGTJ92K4Jp1ZuxxoCwc9K5hYYNiz5LtpFt4nWKEeRQ+oTT0Uzy9rpzLzP4xHHt6kk+bh0hhyrUSsVvhmVwzBHuQ4Uw5IEZSSAotlNyOr9HGNGIBIkwahKYnTRb67fnPoYqtrmI0FBKoANjHD6hOLaNW876yLGShfy/GKUa3xnmDqZ8tw3yC15R65KAS0KPLk6MPqSMTG8OmgtXaGp5tLGH2EZ7nwqJajrgeN57MogNISy3zMiTGvN0Dhb7E0/zia/FT+ZFapkjaN/b/iJswp2yrPyQIjiLD3kIS2N5qbI7IO94iXh37RUtSNp3s2ywZ0OwWKiZkbMu0+jk19wbcCmHZGdTumjdS4d7Zb6ycCFNb3djqOd0koQIQe9XfEll5NcYIBUjw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0546030-37c9-46c8-78d1-08d846067a52
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 19:14:51.2166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgbjNu5k1gUSnw8breaM2J0o4WUFYtpfQuGgvn6c649p8P5I6SCcwJgrEhn0NqjVdE1FabVDrppP1eM95Ir4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3348
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Hi Dave,

These series contains two small fixes of devlink.

Patch-1 initializes port reporter fields early enough to
avoid access before initialized error.
Patch-2 protects port list lock during traversal.

Parav Pandit (2):
  devlink: Fix per port reporter fields initialization
  devlink: Protect devlink port list traversal

 net/core/devlink.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.26.2

