Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD0346E6D6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhLIKpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:45:38 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:51497
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhLIKph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:45:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgeFuL5MexsMVdzr3W6gWd4oot9HoTOAfGFeCj5NGBpFcY19IIxG51/KLx7fcYjMGv05MXUAxLx0bXPQrWPXIpjohliAjfQ83cWfr9XlVHkX50AH0IWN9Jq1eLIYjYxd8VJP4cxtQnxj8E2lSzc5si5Ob7cMxHsQsZU/NM3zVQKl26otTIEWFMcsbxUNJDBf7vROSlQHQKwI3ARB2LglOKt/8CLfZ9Ftt+NutjdSszYXfnUa3+ALOJRuVlpfHU+AEEk7WP6yt3s1aZfVZlTR+lkma9z9tVT554PqTtXhXbM8nr4cmmdUQ6/bbYvodCTLkw/OF6TSrmNKnVJy7sWVxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3GxVqEAh2FB3kKejEtsMIgFYLkd7JM6eOh0Sv61vIY=;
 b=Tk/1kX8xMn4In22hO4g2iWkFpHsTpK2MvhsGXLJKZ8Fqdgp0eCf6G7y+dd/5j+xt3gCotiGNHgCkgsD9aFez3XXz7iinZ9iG8hyBef53e9mfwD9kc9IYse09lCRtPClRYutFGhRgfCCkFb6VOZa7imEn82uaKf5IfNM1VVYJKAdo2C6tJpKecDlKfaXTg4DKF8Zg1ToZhwuXKbpj9agN7gMSdU5wsf1cXto1tjnLHplLmtZ0U2JysAUS0TBC9/x87HFtuH574dnsJbISubboulPqtEX3tCDI5jkDOZOP3xYGnDtWS1ZM5hPK06ABzciVHgGsQGauc5lbZUVzau1pOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3GxVqEAh2FB3kKejEtsMIgFYLkd7JM6eOh0Sv61vIY=;
 b=CKTKluNu0ZoY67qyOmkfWbOuf89O7e0P42VmDwh+J34/9tWPYDmEdIVgvv822l+VUhbsd+2zX0ZIv1XoZ+0grm/YOIAJUHc1zn2QY/J0szdT1Bj2sEhuQaYB20B4IW0yJxr5TkzXTlOSbokukU5cF9UvtycQDDTG0yvFQmXN4Wg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5716.namprd13.prod.outlook.com (2603:10b6:510:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.8; Thu, 9 Dec
 2021 10:42:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 10:42:01 +0000
Date:   Thu, 9 Dec 2021 11:41:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH v6 net-next 00/12] allow user to offload tc action to net
 device
Message-ID: <20211209104152.GF30443@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR0701CA0004.eurprd07.prod.outlook.com
 (2603:10a6:200:42::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73df9b63-a6f1-4c0e-fa9d-08d9bb00883e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5716:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB57165D3A72B90D5ED8C96561E8709@PH0PR13MB5716.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DS5IoqV9vVxv/8IYqd4Kz7qEozAiZWBqz2TDgM4jWPD65EvQu8NioNQKwZgKfA83/bBZvJOWO9XR5O0JhiZ018rKvxCA5AhN8sIGLU2k11MbwiQZCu6KZA6yjCulwj4Ajh4cUcIsPV6NjRueXY1mPtZwsCwmN99ghZj7ZSMjcKHxoGljzMK2f+9DELifIQMrM200iV8pSUvTrrMTRX6k/kmP7w74yrIav3Ds+wni8M1lRt0K4+B+GLBW3kg5IyvL2H4IlupdwOuXDDWDUTwbcZeB3dXV25oUX1jX4xnLgHOsr7VNAyr7IjYnNw9WWfa4L5c1B9GDtWxXevB3wLZvPqNOweY8iDZJ0WV/NTRonJnSHnvmyd1gVRHumhDTbDayMPYZWSMTWGmHqm++sidWmrdwqOqfCQ6zaal0eM4kDylRBLcnu7OjKjet9mljzgknIJpzLDbiggMw2+ILW+Y6lHRMAKT0i/NTq7/QxXgoNrFGTi2XBiz2/o1CdWaoRdrIoDcoC2SEpzHzoWWQ7z1EhYzBCDBfIt7XtpesTpD+rN8PRyTUr6omVSYygBCr8dCzN8yqPGb55Fene32gEby2ksAA7bG0z6+J0hVo44BWsNnop8E3ylsH93UChbjrKNd8zdvLIM8jWkBOGkEZEo+u1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(346002)(396003)(136003)(366004)(8676002)(8936002)(6512007)(508600001)(38100700002)(6486002)(44832011)(1076003)(36756003)(54906003)(33656002)(316002)(2906002)(83380400001)(66476007)(52116002)(66946007)(186003)(6506007)(6666004)(5660300002)(6916009)(2616005)(107886003)(4326008)(86362001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5stG3OnEklWFZEfVbtefCCjbk0PHLEsboCnWm1gWXpC4TkJeZaGsYSmN0TWy?=
 =?us-ascii?Q?2oG8/dM4jEKhoZi3Vo+i162G4d5lYRJAD04JQpo3obf0PO7SZd8pNQ2r+xQz?=
 =?us-ascii?Q?fCriCWJWloGFOKj+DjWr4zWiFhpjg4tbfS2SHYQ7Cydbnc1b3otVoRlSGqQf?=
 =?us-ascii?Q?xc9ikEYnIfpO78mY5WQQH4fKdMu/aSTnT/c7S8MiG6LRFE9qqROKR4X8lQw0?=
 =?us-ascii?Q?gkxJSIMVCiHk1nDxzGWnff7MB1DolGKz/oN7yk0VNRlw57pC7CJldtsr8BBj?=
 =?us-ascii?Q?nR1a62N8Icd8jwYeTGY4maXz4xrftOXZXVriW7CingGLOGL9ATA+px+XOnIh?=
 =?us-ascii?Q?Gsx/ngRQCCoklxgTgcGvIOUxH1Dc8rkMXGD4m/Cyka+gll6Filcf6jyFAehD?=
 =?us-ascii?Q?YiQSfi0OH8p10bba3EurWlX/KuurP7p/TB2pGJ+OQpb0e6N/pkHca4DLeGz6?=
 =?us-ascii?Q?rOq0b82eYFSTaOdbGaQ3q/GR0fZNhOv4dZKsDOiu2bCCDfxAo+h+TEtogsfW?=
 =?us-ascii?Q?8nvEQ+7N8pApUpGbum6O63HOmQ+rGO+973trxsMuGDQkVdByp6IbfQ+L9eBN?=
 =?us-ascii?Q?nGvnIVmYjrl3EL30kOkJ+8IeQAqlk5vQNjTcNfc2pYuMzo9/6rymsWPwcitX?=
 =?us-ascii?Q?hOyoHnUOACncbjrwFT5sqUnCvaDe8SSYSvb7f5pmTplDYGmDlXo9Xh9zCDMl?=
 =?us-ascii?Q?bSZFRvxLqbFyJiDCLFBLU1FDDqRfjIJBxCEU8STxQiNHj3ZXEUSS7DwiwphX?=
 =?us-ascii?Q?NAAZHad7PCysZLdjhB4dAq1DoI0y2DevZ2A4bl+idt49e1RCEa+AMajTxQKR?=
 =?us-ascii?Q?ZZeb0Ii8KrIkS0V23G1sfKs9ht+keyWNs65a6rqSrApmuP/YiFCW+pa7iwoo?=
 =?us-ascii?Q?IW4j2JTbqvmfzRMpCPW8p264Smu/UWsQPoy/tAFMmN/t7mee/HVKZGBoTesy?=
 =?us-ascii?Q?rgWDiw7mIOlcKGlmTQb6R5p+EUI3CqzD7x5gpyXJergHnvxfVU/uPw9ifB1o?=
 =?us-ascii?Q?qagQZkhMeaC40RrzPjbMgpVYvQ2o9DggYJVpR2qDHFkFELweotzWvy16ERMV?=
 =?us-ascii?Q?gX57LLRH05ddZdvlTNr74dM5tBJLSoXu9clm6Q9tsHExYPhfgP/NEI9bI3GK?=
 =?us-ascii?Q?DCOslUo4eDNDgKYLQzRsJe8UuNvCdxGpWjPRz4OqLMUK7ByIUAxtfqLssRz9?=
 =?us-ascii?Q?VK2r37pOMklGz1/4A32+jdlQN1RK6DvHhq14hPBMAhVaqLpfDvT9pZOFmlsH?=
 =?us-ascii?Q?DOk3O5hXayUPZ8jths2g5XjyDyE/Icm4RwXzW/dLH4QkOJTce2xQ4unl5M/r?=
 =?us-ascii?Q?b3k9meImReYt3yOmTx7FP6Rodb3yUGVRlnqidtRey5DJdQJORt82NxScmzsw?=
 =?us-ascii?Q?4PZzr8kTRFqLVplovHDXyE+mPSlh43WisaUZNz5XM4fBUphZGJyQX+5sE4dr?=
 =?us-ascii?Q?P/pz1qMUwabxuFXhi2X7B3dWJj+XfdXheQ7HQAhyxq+g8TIxfoucl8i2U2bM?=
 =?us-ascii?Q?xGgP2wJTcklzlLik0A0OVwff6mkAOb8iyOMT5Mb0wftpzWyGoBXZ+Lz18tRD?=
 =?us-ascii?Q?D5eQuTBGyoYhOe17UQUjswpxcBahUozf2ifiCNo2hcP8haVp34rEipLmKiz0?=
 =?us-ascii?Q?zDvhjDupdxDwKle0xmkBeZVKAf2r2ZHhU8w9q0kCBvQxyBfCFLc4iI08pI8B?=
 =?us-ascii?Q?kXoB1D6JXQRVrcYb8fIV01PMBZuMTfkOZVkAre0lzLdZt0o7W/VVnmwSqJgv?=
 =?us-ascii?Q?5qjuzdTMU8cZ8/Mrywjd0H7nntm2JKg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73df9b63-a6f1-4c0e-fa9d-08d9bb00883e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:42:01.1760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bln/rNuX2RwQS2wXv5Ly4zwYaiBGQ4hyg2KyxL/rHt+3G95nK2iDBadlGMbXZYXAVzU2HqHUo0bGqwwhx04ZbF7QxMFF+EFRAvo0Eadztvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 10:27:54AM +0100, Simon Horman wrote:
> Baowen Zheng says:

...

Sorry, I appear to have included two sets of slightly different
information in this cover letter.

Please ignore the following two paragraphs, and instead refer
to the two after that.

Ignore this:

> Baowen Zheng (12):
>   flow_offload: fill flags to action structure
>   flow_offload: reject to offload tc actions in offload drivers
>   flow_offload: add index to flow_action_entry structure
>   flow_offload: return EOPNOTSUPP for the unsupported mpls action type
>   flow_offload: add ops to tc_action_ops for flow action setup
>   flow_offload: allow user to offload tc action to net device
>   flow_offload: add skip_hw and skip_sw to control if offload the action
>   flow_offload: add process to update action stats from hardware
>   net: sched: save full flags for tc action
>   flow_offload: add reoffload process to update hw_count
>   flow_offload: validate flags of filter and actions
>   selftests: tc-testing: add action offload selftest for action and
>     filter
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
>  drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>  .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
>  .../ethernet/netronome/nfp/flower/offload.c   |   3 +
>  include/linux/netdevice.h                     |   1 +
>  include/net/act_api.h                         |  27 +-
>  include/net/flow_offload.h                    |  20 +-
>  include/net/pkt_cls.h                         |  27 +-
>  include/net/tc_act/tc_gate.h                  |   5 -
>  include/uapi/linux/pkt_cls.h                  |   9 +-
>  net/core/flow_offload.c                       |  46 +-
>  net/sched/act_api.c                           | 450 +++++++++++++++++-
>  net/sched/act_bpf.c                           |   2 +-
>  net/sched/act_connmark.c                      |   2 +-
>  net/sched/act_csum.c                          |  19 +
>  net/sched/act_ct.c                            |  21 +
>  net/sched/act_ctinfo.c                        |   2 +-
>  net/sched/act_gact.c                          |  38 ++
>  net/sched/act_gate.c                          |  51 +-
>  net/sched/act_ife.c                           |   2 +-
>  net/sched/act_ipt.c                           |   2 +-
>  net/sched/act_mirred.c                        |  50 ++
>  net/sched/act_mpls.c                          |  54 ++-
>  net/sched/act_nat.c                           |   2 +-
>  net/sched/act_pedit.c                         |  36 +-
>  net/sched/act_police.c                        |  27 +-
>  net/sched/act_sample.c                        |  32 +-
>  net/sched/act_simple.c                        |   2 +-
>  net/sched/act_skbedit.c                       |  38 +-
>  net/sched/act_skbmod.c                        |   2 +-
>  net/sched/act_tunnel_key.c                    |  54 +++
>  net/sched/act_vlan.c                          |  48 ++
>  net/sched/cls_api.c                           | 263 ++--------
>  net/sched/cls_flower.c                        |   9 +-
>  net/sched/cls_matchall.c                      |   9 +-
>  net/sched/cls_u32.c                           |  12 +-
>  .../tc-testing/tc-tests/actions/police.json   |  24 +
>  .../tc-testing/tc-tests/filters/matchall.json |  24 +
>  42 files changed, 1144 insertions(+), 290 deletions(-)

Instead, refer to this:

> Baowen Zheng (12):
>   flow_offload: fill flags to action structure
>   flow_offload: reject to offload tc actions in offload drivers
>   flow_offload: add index to flow_action_entry structure
>   flow_offload: return EOPNOTSUPP for the unsupported mpls action type
>   flow_offload: add ops to tc_action_ops for flow action setup
>   flow_offload: allow user to offload tc action to net device
>   flow_offload: add skip_hw and skip_sw to control if offload the action
>   flow_offload: add process to update action stats from hardware
>   net: sched: save full flags for tc action
>   flow_offload: add reoffload process to update hw_count
>   flow_offload: validate flags of filter and actions
>   selftests: tc-testing: add action offload selftest for action and
>     filter
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
>  drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>  .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
>  .../ethernet/netronome/nfp/flower/offload.c   |   3 +
>  include/linux/netdevice.h                     |   1 +
>  include/net/act_api.h                         |  27 +-
>  include/net/flow_offload.h                    |  20 +-
>  include/net/pkt_cls.h                         |  27 +-
>  include/net/tc_act/tc_gate.h                  |   5 -
>  include/uapi/linux/pkt_cls.h                  |   9 +-
>  net/core/flow_offload.c                       |  46 +-
>  net/sched/act_api.c                           | 451 +++++++++++++++++-
>  net/sched/act_bpf.c                           |   2 +-
>  net/sched/act_connmark.c                      |   2 +-
>  net/sched/act_csum.c                          |  19 +
>  net/sched/act_ct.c                            |  21 +
>  net/sched/act_ctinfo.c                        |   2 +-
>  net/sched/act_gact.c                          |  38 ++
>  net/sched/act_gate.c                          |  51 +-
>  net/sched/act_ife.c                           |   2 +-
>  net/sched/act_ipt.c                           |   2 +-
>  net/sched/act_mirred.c                        |  50 ++
>  net/sched/act_mpls.c                          |  54 ++-
>  net/sched/act_nat.c                           |   2 +-
>  net/sched/act_pedit.c                         |  36 +-
>  net/sched/act_police.c                        |  27 +-
>  net/sched/act_sample.c                        |  32 +-
>  net/sched/act_simple.c                        |   2 +-
>  net/sched/act_skbedit.c                       |  38 +-
>  net/sched/act_skbmod.c                        |   2 +-
>  net/sched/act_tunnel_key.c                    |  54 +++
>  net/sched/act_vlan.c                          |  48 ++
>  net/sched/cls_api.c                           | 263 ++--------
>  net/sched/cls_flower.c                        |   9 +-
>  net/sched/cls_matchall.c                      |   9 +-
>  net/sched/cls_u32.c                           |  12 +-
>  .../tc-testing/tc-tests/actions/police.json   |  24 +
>  .../tc-testing/tc-tests/filters/matchall.json |  24 +
>  42 files changed, 1145 insertions(+), 290 deletions(-)
