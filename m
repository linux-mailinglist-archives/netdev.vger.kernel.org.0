Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F231D43DFBB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJ1LJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:33 -0400
Received: from mail-dm6nam10on2114.outbound.protection.outlook.com ([40.107.93.114]:22785
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229835AbhJ1LJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKjpIvle/FBgUwO9tpbf4GDJ5gCC9zib6XVdS6+C0wZG3GfomPYCqvg3ROhoZcG5MHLQDlm6KZgBopNOlPIOKfuFfzevRiz54qeuFuaspA2H2T+EkDCHj2t1VbEt24PXs5rx4/U65rc0BYEARyVpkvMb90eqkJMMbjHtjsjtpmjw4BKo/eUJFYnWrOzdZuRjjJy0yGX6FqIEHkoVpBDA0KunfOPPs1TZujoQQUlKc9/QXsKTRCOi9raaEC6c20fkbVH0fDzeFydOx7WEbzL4fo+IaGX6bA0/g4rv3P5ETSJi9DMMUM2SCTUb6NtkrdQjSw4C0QJFnmSVDchBHgRO0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSwYv808utLGJ57r16mOajuNoEtkefHTjrVICJkWUOk=;
 b=fOactAgIv0SQZLXoSpDLcMhOInuoHds3Oqi8SnhSK7JrWCsreBEECCRM/RMd4pMKqr5dcNb+DOH70m37bj6MHTEcylSVlJO1AmO4hiw9MgaF+mJUGAuT74a1qQZ9nZk0cpV9RK8+dlLXpr80S3YXoQrW2ivb1+C5pHu+/I5DWUTtg016WObp0yGHkvGzpp34B3cMTvSl6X6ituxolm/8j6wtQctCLXXaZH1biB6ChgcF3br3v1IWj7g/FIo0k4OcYt82qOjiXs8qJPnDsPs66HgNPXh9c+KJAmmNuH1cH+W7eafn6NhFogT2xB8lYm0YS8oRdbNHY92Y4jHBFgfoBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSwYv808utLGJ57r16mOajuNoEtkefHTjrVICJkWUOk=;
 b=Vr16aGjcXvGPO0uTOKVlgWToGstjnpsRMbrsEXxEgUjrGPCuTijcKmyFeH10Cpmbz4zPbzGiBKWiQvH6Z1GSbxwKxNNc8i+VlSGfZBlAAbWSQa3aAPMst3MOxpk/VX0e3wr9QJWstJXJEogm1F4NuSlfeRIeY8diQd3oeUWBTX8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5764.namprd13.prod.outlook.com (2603:10b6:510:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 11:07:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to net device
Date:   Thu, 28 Oct 2021 13:06:38 +0200
Message-Id: <20211028110646.13791-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e671ac1-4aab-4673-47e5-08d99a0312d1
X-MS-TrafficTypeDiagnostic: PH0PR13MB5764:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5764465256E6186AE7628B87E8869@PH0PR13MB5764.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbZX8C4zDErasuF6cf/YSIjOIjTHqhZwg98+adfhvgmdl9Flswxo/bRQP2m9EmHfm4FWg2zpy9UPjybiD6elJUk0qrGLXBvWVQHAn0g/EV4fc8nP4Nhh4zloJICfM+xT+x09cAwx1woXrDZqPNs/szdQjlfO3zpjdzFFXVcLwr1rjNLlSREfd3h0myJi9ZTsGfZ7evgPjhCpx0LiLNOgp3slq0Niy+RNZxNd3Le+obxkKJCyJgdgQpYtBREkx8tyocF9+Oh/Y0CczrZI9jHmHcMXE42M00iF04rtZIZRICyar9DKI3vMhX69Y+DgjshNWSMkQX/bAlBUvMYZr8Y+VjEM+Rq67DrWLsLtJ/JMqhMV4gWFt8CitSB8jCzyvSxFTNuwx3rTyfWkZpaxQKuVfEkDWSxTGYQjPOFJVmNmqDrezMzIw8ljeXPIMcnhiNAPQfqWMSUiEwy8r4DJxwSsrkziavsPL1fFy58eeLiHR53IXTDqFwr55LTEmbxjoE4HvG+kB75DbalFZJ9il9LtzcPeEYyCov5Exi6101+Q8FLZLjyW3X8TEFC2oNs6gkvswLa1oDK2cX+6DF1W6OvyhE7SSR54VpDMNAMD+7yHgN/WjnECUIyzfiLwNheEORHjyWcS/13kYP23TrJp3UerFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(136003)(366004)(376002)(346002)(6916009)(6486002)(83380400001)(6506007)(4326008)(5660300002)(1076003)(6666004)(86362001)(52116002)(44832011)(186003)(36756003)(8676002)(508600001)(38100700002)(107886003)(316002)(66556008)(66946007)(54906003)(6512007)(66476007)(2906002)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kDOzJdWuXV32y6+uA7fwCW3f2t0FdrCh3dRmgIwIDKX0AMi/hpEj6z4vy5z2?=
 =?us-ascii?Q?ujyyRO6XQpi3Z7WAN0lDuDCALSaXgAePxGf2y74AGJiKyDOw6RAm32OBMGeh?=
 =?us-ascii?Q?kN8asw5DOm6GwQrpmaXOlTxI4JtrNyq4JBb4UgoqqTrnKc5EiVncRMh6RRJS?=
 =?us-ascii?Q?tK1xgJZuDKr/OjnT7Nz0ZYPff/KJvBFD1YdqY/p9uz4WAa3u7SMui+Y75XTF?=
 =?us-ascii?Q?cTERcLhUDdiZxjtYoM6u32UV5GYFPwjT6AzvZPPER82qBf0LuOW1OFAE2xrs?=
 =?us-ascii?Q?HBnQzIIECPiPQIWCR/4Y9OskU6H22bkXVspd/GGiJy9Kc6BvhkjECsh0VVBw?=
 =?us-ascii?Q?P6Yu1VUmb4T5A6JpiHn420JtXf4zIaWDlrDz18g2X9vceyrlwwRxqJNxBsP4?=
 =?us-ascii?Q?0OSgcnhsk0OMZx0kiVsboVVkRHLPi0cXBtBt415+nthpbjvE9lOTFjjoPwj6?=
 =?us-ascii?Q?vw4PKWcJKmx4b5OyMRR4tXfLUh+Vt0zM5ziGStKON5NzFxQEfAUzZpB/Fo5x?=
 =?us-ascii?Q?/CeK0Qyckpba6EkYTOsHXxVEPYxzWFDYP9ZaY0WjyleCNm/vt6SJK2Wck6xW?=
 =?us-ascii?Q?bEstmhlVlGloW/rzllzQJ1HrAQR04webAT+B+w9jR9Tt0++QiMolejEg1CdS?=
 =?us-ascii?Q?G+DMlmPTd/LbifYsqxycJZ3DbW8TzGdFq4jbFMlNbT2ioVAKu3S/E3+zQksB?=
 =?us-ascii?Q?OSNkyq8+lLNkdi6U21IJjhhfJ9afLLf+jh3HT54kW47CQWDgjzZ5QF6npyS2?=
 =?us-ascii?Q?XNPo1hryygbjxYqNAt0SmtL8mpd2NKqIFjdVKmGWkbgNQ2kOc5wEdvu5eLsi?=
 =?us-ascii?Q?ME+Nm50hK60FWtmXciubiVGxXBxLEYBsWtR/0wXtomrh4mb+KJZ4XChAxy6U?=
 =?us-ascii?Q?26bBtlg5Ae+XpEvIcsITfuL30J1xeUjz9/xTJm9t8RNCdItcia0552cVu70t?=
 =?us-ascii?Q?tDKhxNE784t/z4m/UYt9iROSUOSkP2UebfFufI2xqonABar/HCbXYra7q3iX?=
 =?us-ascii?Q?HFAUIdFV6pag/jCnLMh8h2eENGSmlYho9SXrXwAOfUaOAJch/2tLxIc8IWGe?=
 =?us-ascii?Q?gsMbIkgSxBfSiwRyV5/YUshOJdzK78ocJfQcP0/0Oxu4PC5lQ9Oq0AcgEw2N?=
 =?us-ascii?Q?aBxpo4B8+4SID/18NhRiZdXHEtPMHhoU+UMrg9Y0B65rdMVIjT+JW4+xWIeh?=
 =?us-ascii?Q?nmAaviDBXA2J4GyxFsrB+qw1wLUTCXVP8vISRHXRZGBAyIpg7Z4471Rcodh0?=
 =?us-ascii?Q?+0tUvKbQZUx7bzKWRCq1XeKNMT+fZ2otUfKO83mKuplzIRap7huDQ9iShxtq?=
 =?us-ascii?Q?4IQEFYXFcF4se5tCOTwHcBByA0elKB4jRoJYR6tZNaCRfbYAV26lR1ZvkDn4?=
 =?us-ascii?Q?ZaMyENRPcYYO9PJkBH4QYsZBmYdEQ73GKNjh9/u07gJ5C2iFC2cymZ60GaVm?=
 =?us-ascii?Q?7rHDTkUhQUqnohky/ssSseciZ3VSrLI0i54OI44rW8Gaogx063rYN+pv6scO?=
 =?us-ascii?Q?i4LqVO2312/ZoPKH+dJPH0cRORSHdmbjRKK7bKwgNznAceFn+Ial2r3/Nbng?=
 =?us-ascii?Q?pDawPphXvXaTxwXP2F7wxukU0+QvZnyZsmv2FaKOwbLzAfCl80dU4+M+BBli?=
 =?us-ascii?Q?jK72F71HDvbqIrFX9z232L3kCsiqsqe4WlKq7Bx4exH9Q5ZUYdAw6uy1IQZc?=
 =?us-ascii?Q?97u/ng+nF3In7c9gTh6VvtYsVJHOMIrqJAwuPtKoLzJGmhdbmgRSjYmNup85?=
 =?us-ascii?Q?LZzWJOZzcA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e671ac1-4aab-4673-47e5-08d99a0312d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:04.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ/jaHOnzG/4VWlY/HOXjNlD7KBPpokS/ygTOrueLTJvYBj7mUTEZqgoe4aRwkBNGHUuk/fEOSt5D4gfm1w+nKO6dDj4geZMutrM0XqFFho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5764
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

Tc cli command to offload and quote an action:

tc qdisc del dev $DEV ingress && sleep 1 || true
tc actions delete action police index 99 || true

tc qdisc add dev $DEV ingress
tc qdisc show dev $DEV ingress

tc actions add action police index 99 rate 1mbit burst 100k skip_sw
tc actions list action police

tc filter add dev $DEV protocol ip parent ffff:
flower ip_proto tcp action police index 99
tc -s -d filter show dev $DEV protocol ip parent ffff:
tc filter add dev $DEV protocol ipv6 parent ffff:
flower skip_sw ip_proto tcp action police index 99
tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
tc actions list action police

tc qdisc del dev $DEV ingress && sleep 1
tc actions delete action police index 99
tc actions list action police

Changes compared to v2 patches:

* Made changes according to the review comments.
* Delete in_hw and not_in_hw flag and user can judge if the action is
  offloaded to any hardware by in_hw_count.
* Split the main patch of the action offload to three single patch to
facilitate code review.

Posting this revision of the patchset as an RFC as while we feel it is
ready for review we would like an opportunity to conduct further testing
before acceptance into upstream.

Baowen Zheng (8):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  34 +-
 include/net/flow_offload.h                    |  17 +
 include/net/pkt_cls.h                         |  61 ++-
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  48 +-
 net/sched/act_api.c                           | 440 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gate.c                          |   2 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mpls.c                          |   2 +-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |   2 +-
 net/sched/act_police.c                        |   2 +-
 net/sched/act_sample.c                        |   2 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |   2 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/cls_api.c                           |  55 ++-
 net/sched/cls_flower.c                        |   3 +-
 net/sched/cls_matchall.c                      |   4 +-
 net/sched/cls_u32.c                           |   7 +-
 28 files changed, 661 insertions(+), 54 deletions(-)

-- 
2.20.1

