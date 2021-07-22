Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492B33D20BB
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhGVIjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:39:18 -0400
Received: from mail-mw2nam10on2128.outbound.protection.outlook.com ([40.107.94.128]:22880
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231322AbhGVIjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:39:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcWqH2BPL/E5sxpTD/oTL2ndtFRz7E1Udn+4RVLb+ToE2gNUlJ/pGf3PoyHSrLDMy47g7QTx0/k2VpyCXhpjcMMAEUSP2XnAPF3g5RPaWKzImBlcqbpKGs0dHAhtTg9IZUy7TRfJoE/5vwdm4bd5wIzfCE06VcWKY8arLFU/0gF5rj2tjkbWdRH82X4kfQQrsFqZcqHrhtnE1axGlv5E3a4iHcNX7M6tKZW8wcOzpUl26/MIgD/TvwBw+OSY2DfqNTZPPt+GHkeTLsHKOy1gBd0Q6Aka0FlE53ZDBrMX3Rgxa+kdLXNLGr5e1CBL+D8uJBub+9typSRzZYzLu8xktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZacHZg/iRfFA+ZKE9BCNIpZil2u0271VYRoSH5G1AU=;
 b=Kjuw/lau1zSZlxjm/yf276CjbCc9vw1GxuekKRZhFNgPPQQ4UHYACbbxGjVv9JKT7nisFd/BeE+X78GQ9ZpEISlJilERC9iF3kGZAdRvF+iqHr9HZGpbtm6I3Dz+iHOc3VLyhA/L8SmiRThJA0guKR+C2asUaM9S+ENeJM1tH+EQqpOU17xEdfCq2vLJ9mBhvjlxVA0H8onzt1O9BaMWzqji6ckp9JXjn5g67Q0gRKoJQRDTLkiWGf8lflq0n2kQh8qXY2MkkhC5CdFgnnrFo1JfM4gL8DxhsgNI+rPDj0ymoIdhMbAmFfphnw623IlsUZQJRsX81NdH4DGx2yYvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZacHZg/iRfFA+ZKE9BCNIpZil2u0271VYRoSH5G1AU=;
 b=mV40ojAHRXRpjoaHOOQMxjTWflNMYX6gtwP5W/OV85XRnD6U2Z0N7W/SkB6Wi0uO7fWehqX9N1BuLIKEBH+qN5tFEJQBdTAXXdQnUaozFVwylGWYJ59b365uiQSvCXbU1jlCpNnepmcJrEWgw90CiIS6Q6hsiC3PtVwmPTwQoeM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 09:19:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 09:19:51 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/3] flow_offload: hardware offload of TC actions
Date:   Thu, 22 Jul 2021 11:19:35 +0200
Message-Id: <20210722091938.12956-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 09:19:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73e0a641-6827-4281-f099-08d94cf1dbda
X-MS-TrafficTypeDiagnostic: PH0PR13MB4841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48419ABB8B137895BEFF4E5FE8E49@PH0PR13MB4841.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRzzxowyf9udwG1F6YQuW9Gkoq13An3W8SnPrvdsZ97cTtam5V9ElUGFsNa0VCve93Iti0b7+dRIYRSFOwKdhkZgq0Gppgm6HohTAOrDIl3iChBtXFbgJYf0vOwVA1fGvtAUTeSfz5LjD3c8A4N0aj2W6/WTV7spDg9CFjnvo6/XbmNt7LWVbf5j2cHV4ogZHHvsNGVcg+ZMSPqbFYSZjiH0w6MonVci4cuieDTiBXObLD2+lzzUfXIZt3aLUm9ZEEVt/esAV8pxBeMrTwXiE3Nq95bmhxJk1Sic9H3KCwXFon/clQ5kQ8tzcsp0E/gsVBKB4CiiOrtvomT/jFQLd3qfVD0AE+aMLOF9aJvoPkWQJoqxdB8mrvr/gsZFNI6QyJW81GqpO96Ed7P0PBQ8cY4cyV+PRLyQyAtsZ+HCr/gCaf5MRhvUhLdm3PfakC6L1QRgij7o5ZZwahiNw3G8TE4a2X8PjBXf7OUfdfAv0QzMTjY19gxjKWJ5DmTMzrDq5uE1f86txLffSZ4+5r6au+aY57nZFSEORQndFWYqirP1tK4de/LUe3//vx76WpSU1Za/8unllQOLvl3Jx2tdwh2xwrZAM2GRMK2rKVLhZekUXRRWXs7RAevdP5tVL0TpU3OStO7QF8ktg9F+n4V/oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(6486002)(86362001)(8676002)(6666004)(2616005)(6512007)(2906002)(54906003)(83380400001)(36756003)(66476007)(66556008)(8936002)(1076003)(107886003)(66946007)(110136005)(4326008)(186003)(44832011)(38100700002)(508600001)(316002)(52116002)(5660300002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TkoGg3pWznPzvZGO9TBLlljjIi2De293i3tOwsWrsTklWLh9kPw/KTmXCdGi?=
 =?us-ascii?Q?GKalkzKPZdZ3hz/V8PwBOhAVWafGHA2wSnl4EEuxCTQtXSp+jn8SLTBDCaqx?=
 =?us-ascii?Q?Su2K6BBkkjfJt+a2fhpDKftuTMIqoiKTOJEComQoVEbL+ITXEXBvLfSn+Avf?=
 =?us-ascii?Q?nO8KMH99n0lmU9D8MA+wAnymqtGz+mDspU5CkIMGjeVo5Itc4E8xEJ8FLAvS?=
 =?us-ascii?Q?BcrUtL/KuxNya/SJBTG9vISl9qGo6syx8XQdleeYopPGM0ZNsda7iQh0w1a2?=
 =?us-ascii?Q?OrzgVK1UC7QzLGYlSfCrepcDWQy3nWxGq5neD3MlFnlNSRmpGINnMLWyxgqq?=
 =?us-ascii?Q?0lAVuNYJwYkVCCdGuAH5dE5LlyKj5zUHG34jCl+VggQ2DEs0IAw/at4y4umi?=
 =?us-ascii?Q?1qhrP8+RRiTP1HIjixICVf69f+tBVTt6uO5d0rE1Cl5MafyXOl6X+MWxiSOX?=
 =?us-ascii?Q?RWuPQ7ctIuhk1WuaRefRABrAY07LJYgYiRMDDpnyHpqsMIiJRu5yg9a2G/yF?=
 =?us-ascii?Q?3KkguHjE6NEr84vUVNGvL+6SKJeu299sNNgRK1HxznNgkPLlwdpODwhAOt5U?=
 =?us-ascii?Q?JFmDTIfW7tieSod5b3Peoqg7x7CAF//zwQLMj1mn2KmbHwvyBlAlsMh4Nz8i?=
 =?us-ascii?Q?VdfyrS4YPN7r0B5qkfgLHnyQS8QEjNf1G3Ir6EWvaamEVrt+LY3H9HGVXz2i?=
 =?us-ascii?Q?OQrK023Apoa1k7VwpgCiPKM8L/qrm0I3kKwrd112USdfwdm0sZp+5LwCNu3y?=
 =?us-ascii?Q?T8p77yE56pkkJtwjz6jnITw2BrLAzMzilSuCNcM3DGP8+ISKI3nTsBUuEYzz?=
 =?us-ascii?Q?UHaPcr6xvv1LgCgCw7WHeo2Vv3a/UZIGEDMuitMuCmjSlxJ5KM4r9zqdIYvD?=
 =?us-ascii?Q?q5pxWqd5wWHa/lYap5budH1dVJC3tRwgHyFt2s+Riy0FHC8qLZoUWUQmJa9H?=
 =?us-ascii?Q?eAFRMn7Xd4hugJ2oaADsbcQhCBUdfTa3Ku5VZm/T+cSILIkAZolvUlj14uDm?=
 =?us-ascii?Q?i9vrxx1r2fQMpIDDePn1QMyhOXFzkOeSHAFPPNMCcFIuGRQoyS231NPuvLA6?=
 =?us-ascii?Q?pzu0DhXBKLi3TxPsXDmxGfZA6lQgtXqiripNuMmGB+u6T9nZKBTUux6Veiw5?=
 =?us-ascii?Q?tGQIcPjEfTc8snrwwEy5GEH8JxwDezJRzDctCiXAgT+/h3vSiiFhlegqXzqg?=
 =?us-ascii?Q?oCBYucsL282aKKVel0aFin0p1Qj93WJBxDeYPVbSKVQvK4FzVvc+2bZWU6M/?=
 =?us-ascii?Q?hZN1yrXMfzYf0NNM8f6lWdbMcoxgAN9Rf5JLEFEOseLV6QKwDMOOsQga/uAv?=
 =?us-ascii?Q?0eS1X6NbSyIJi4teQmsCt2SNl1CcLo/foKt77JtSgH/SD1p3Q4QqmWsKf0AZ?=
 =?us-ascii?Q?8xXT97+EpvNt0t+xldBI+8GEq4v7?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e0a641-6827-4281-f099-08d94cf1dbda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:19:51.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAUhWW4VihDXE2Z4x21TL3qu6dCRMk/GMfOFbaORTO3wkgKbAqMZxvau8r1WURHjp9dMjZ2nrORb85Rbiq3zF4EqkvtrBej2geOP82TyIDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
tc actions independent of flows.

The motivation for this work is to prepare for using TC police action
instances to provide hardware offload of OVS metering feature - which calls
for policers that may be used by multiple flows and whose lifecycle is
independent of any flows that use them.

This patch includes basic changes to offload drivers to return EOPNOTSUPP
if this feature is used - it is not yet supported by any driver. 

Changes since RFC:
- Fix robot test failure.
- Change actions offload process in action add function rather than action
  init.
- Change actions offload delete process after tcf_del_notify to keep
  undeleted actions.
- Add process to update actions stats from hardware.

Baowen Zheng (3):
  flow_offload: allow user to offload tc action to net device
  flow_offload: add process to delete offloaded actions from net device
  flow_offload: add process to update action stats from hardware

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |   1 +
 include/net/flow_offload.h                    |  15 ++
 include/net/pkt_cls.h                         |  20 +++
 net/core/flow_offload.c                       |  26 ++-
 net/sched/act_api.c                           | 162 +++++++++++++++++-
 net/sched/cls_api.c                           |  42 ++++-
 10 files changed, 264 insertions(+), 11 deletions(-)

-- 
2.20.1

