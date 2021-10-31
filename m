Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6218440DB1
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 10:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJaJxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 05:53:25 -0400
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:27104
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJaJxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 05:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dw+SzcnZVsCxCIIP08XigWjGkN0me2qPyo1Mw/L6rjbhQUajDeCcPFPuw/xX/SKL2ac/UW2leucmbTStzAbNv29naCSVKITnnQNKJpuRyjNSMESqo+TrRVnHf7Ub8V4UX7K7rnsLsu1IVDp/7nmR99k+BompZqziwFTxwcrb0KQl3EML4LJ70kMDYE80PIcbgDZpNVX433xnUuvKGCYRlsJoydMavBGmq8EV0fTScbmovpYoH43OZ388EiGGyK3IkcmuD3Mc25kBkMlkVV4q9otP4aMiqEh9BbdTS68QFh3FT1ktPubUxOKQ0iK7lcsZJu087wpBm1Z7s2XPC56X/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijTtFHPCEIkKhWvv/KFmwAJOSmwIo6ZIabgaECxZZC4=;
 b=CYD3KbPFQxZPhehTnPGUxMgLCvHbv2hbMVJQXk33EHA4sUAKSjdCghqGqKxp2FUvw5lpWUKGGrceljIhda3ucJA17NIOTLAnfdfBfAM4DcUdoTV7Jj1r9TOXT9uviOymHkEMBsDWYsSRVa3fjJKIs3i4opvr99zfLNKBfbXEyWYclUsc3y4M5N5bme8VNUett6LIJQhuW7+7cE1rHVyZtVpPmpcFSLg6o/z+vUBHqQ1CONNNkMRmUfDj1K1NDyxyHuh/aFq0Y8oJuFVrWWqKQ35UepZaZ6Gb9gcSsoceqRGNloSG73hAUbY4Mto4wUUcQ2WJn5JSk1C+IKkv1opiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijTtFHPCEIkKhWvv/KFmwAJOSmwIo6ZIabgaECxZZC4=;
 b=mhLw0NLjfcLeyD0KAO6LFcyTvzpGa+04ka0RCJ8Ub5svHFFiMGbStpm8F8W8JxC/0fCAZMViNjE/XRbI00j/KyGsSiiiZo8GJJ4F1rcT2lAfAkFVapK5Me6JfuBZSBvOMVPqBCyBYRBGSLlGX/QMwoxbSA85UePtV5f4FFbNKxwEix2k+e2Yuwa/EUpMjl5F2pvn02mKSdmcn/jpTgNE/9TWrIZsKihJKMcVcdO/v8/fWU9+DtltWuToB8yGpObGEVs744iCLwDhCVSuJ3e8rKjTjgXDuE6t7BfL7qKDY0hw/9xxv6qfInowgAqNIlvENxFCKDqfuH5sWi7AL1dSMw==
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Sun, 31 Oct
 2021 09:50:50 +0000
Received: from BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440]) by BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440%9]) with mapi id 15.20.4649.018; Sun, 31 Oct 2021
 09:50:50 +0000
Message-ID: <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
Date:   Sun, 31 Oct 2021 11:50:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To BL1PR12MB5379.namprd12.prod.outlook.com
 (2603:10b6:208:317::15)
MIME-Version: 1.0
Received: from [172.27.15.108] (193.47.165.251) by FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Sun, 31 Oct 2021 09:50:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ede4bc4b-0d73-48df-8f12-08d99c53ec00
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52701008A7107C5BDE5DFF70A6899@BL1PR12MB5270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wNe1l1UPbQbo0KJuQLVVnRBBybTdDnsve7sG2aO/w0D55IhqgV2u3Ly9HK4aNgh1IqSqjPPtcmOBVnT4e2HpGGsJ+423ePaTv4k7hh8rGnoa0d/K0sLcixVGo14AcGUL5EGOTl9117LsDu48219cPpJUvyxYJdZ8hSaS+faouPtjzhcfrybmIfI1QCKswq6mWrJhhXBIOGBqSBgbzHsvFFrByqFvG7jtzXcNKRzP5xujR0m8AG9ur4KSI8CZFLUq6I/cmd9kBBKlzPabhRgRSnuN80a2ZziSdIJaK6w7vYXoBZZAXJgNPEZke4Haci9hfaV78GfIyDJzITNjtS11b6oN86xJB/ZQX08adMwRgYE2N+YaZCso2QHZQE+Gjl9bVrvK46e6xnUOVr++aIL73MV2Y/lL2bOi+UBKqV+kUI+xZh2/Nf6hebZXQIf+SbugGNMeoDDH03ksCcmOy7TM5rhSSXZlF/mIl/qPLfJFVi9ZSCBqrXIpIp+KsLudxuDv0/CIGAg7GCt7R05lkSt7wtO0/rmNNq14c5/KGYsYa01mIH/0PrLq1+rqJpoL0umECdFC7ykBDJPzfy1DPNs6vgzl5GfBRdPgIhMwA8gLhIPjRsV7/Lk4q5LQYmS8fRXaIyHeTbvQAU/iA+jvjK7YK8iIewjf5Xbn8iPuIkjWMj8oioJxf4S95X8qAl8Z4H/D/DwgNEmwOv5AbPPNzastthddkcLb2+DAYwrzp7kLD2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(186003)(956004)(508600001)(2906002)(26005)(16576012)(5660300002)(31696002)(83380400001)(6486002)(66946007)(54906003)(8936002)(8676002)(31686004)(36756003)(38100700002)(66556008)(4326008)(66476007)(53546011)(2616005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHdFdDE3VTJLYnJhbmw5RnpVcmZsb0s0blMvT1BSQ0pnSXlVRU5LRXJ2NjBH?=
 =?utf-8?B?Y2JvRzFxQ3BVanU2WDFyc2lqTHVFY0lPZUpHb2ExZ2ZzbEdhbGRTL3dnalBp?=
 =?utf-8?B?eXg3N3BMbWdUYmdxQ0JWSVh0Y0J4OUlVM0lOb2lRei9DeHFkbVJ6MWlaMlNH?=
 =?utf-8?B?ZDRqbVhuSGFaczA3RmQ1eDZMSURtYUNJZC9BVk92dHpaUnZtZXRra0xaWU5I?=
 =?utf-8?B?andWeDVrNlgxSElnSmxseWhEWDZmKzRMKy9jN29CaDg0Zmgra1NTa3hTSjJY?=
 =?utf-8?B?N215NHJ5aFdGUGFvRzFGS0dGbWtKT1VPcnJkYkdkZUpBTk9wNzVMVXBYcENE?=
 =?utf-8?B?aDBXQ0gvMXZsRUJYbTVGY2Q3QldJMmNWSDJsSWxWWjRzb0E3QUM4aWE4NFNH?=
 =?utf-8?B?ZEpDU1QwL0lyRGZoaXlsSWI5TTFZcHJFTjYzcEpRSUEzWTlMU2ViOUNxTkM1?=
 =?utf-8?B?ZFBMR2lpZFNOb3ZveGlSdUR0NUJWWFRxRFNqdXM3OUxKb1NONFFleGE0SFVl?=
 =?utf-8?B?TnBOenl4WjdRck1VUDVvVUk0eDFsUkpnVktyRUt2MmNZZEhORnE5SnB3dHlW?=
 =?utf-8?B?ZUtpZlNaYi9ja0hwbkYyUWlNU3loeVFqaUhUbkpWbG9Kd0o3RFI4Y1NZaVNV?=
 =?utf-8?B?eEttdGs3Q2FlT1VmcEs1clpEMk9rZGczNUdlVXV5bjNJcW9mbUpydTVIWXAv?=
 =?utf-8?B?QjQzVi8zczV6V3VKWkhPM2VON1NtZWErbEJmejNFQTVSckVSOVp6ZTNnR0po?=
 =?utf-8?B?S1EzOE1uOFY0b0VBN3V6ZWRSTlBYajlKUHdBWEhEbEUzQ0g3VmxNMEpzcFdp?=
 =?utf-8?B?dnpuTUdTNHorNDEvYlhxN0M2L2ZqQVV0SDd2d2llU3BQQlFqRDdJU2xUcllk?=
 =?utf-8?B?NTZvTXRzUDFhYjlVRFFwK29mb2wvZlc5UzdtK3EvZjI3UlJZQ1JoMUxiT2du?=
 =?utf-8?B?Y3cxbmJtZFRZVkFGNXVqWndCcFYxNFZ2TGdPVzUxVklBbGQ2TkVlVHVoQ0lK?=
 =?utf-8?B?VE5qcmVDSHRLcUxPZGdSdDdRWnJUZHI4bXk0VEVQaGlZaEhmMmxveXBTOVJv?=
 =?utf-8?B?YVdydDU5eHBNU2gyZGFDZ1FFVzdKYmhCczZpR283ZzJzbVB5VnB1WUVDTi9p?=
 =?utf-8?B?WVM1RmdKaVN0S29DZXhWRkZod3Z2ODhBcVVENEJmNzNkU1lVL3dUZm5mbVFC?=
 =?utf-8?B?OWs1RUJUZjJEV3N3dWhWeHhQSmJ0ckg0OWo4QjZ4bmxMN2paNXcyaFBLaVJo?=
 =?utf-8?B?emMzZG5jRkh1WmYrYnlnOEMwTDBMSlVuVFFKNEJKdEJ5a2hDNVhGR3BqWk5h?=
 =?utf-8?B?TkwyUC9RYVlNQkxubiswS25QTnJGcVFvanh3K2wzcmtWeW9HWWZGbHExN1Y0?=
 =?utf-8?B?TUU1OGR5MVlVRzZBeWNTOXl2N3ZmQVp2L3dNUXBKcDA2WTkxRFAxRzQ4dXZt?=
 =?utf-8?B?Y1BXMndoZk9VZVJmZmp2bWRLMmxIdVNhRW4wVjJ1WnRFTTVzekhqbTMyN0Nn?=
 =?utf-8?B?elFHd1NBV2pweisyOGZob2xrVnJnS2ZydXgwanNvVm80Qy9zRjZNS1RmYkJB?=
 =?utf-8?B?dy9FbTRWeUxtOThtSnpDaHdzM1AxdXZld1A4bVhKNFNpV09rbDBHQ2MwMzN4?=
 =?utf-8?B?VkFTVWFPZlIvcFpLR0d3eTRWWnFOQ1lTZTFidURvTk9WVk8zcURlSVlTb1JF?=
 =?utf-8?B?TFhnV0Y5TGpTYy9RaXZtRFE4dUZnY2RnQ3NVMTZBM1RHaG4rTkpTT0phbGZK?=
 =?utf-8?B?NElRMjJUY2ZpVVhIZEZtVUpVQ2Z2Y1c0bmx6elQvOHliNWptdjl1MzBiRWI4?=
 =?utf-8?B?MDlHbm5rVGllemtSN0lCSVJQbFpROTNKL1Exem1tY0VuY2xQUExuR3Fwdklk?=
 =?utf-8?B?UUxzWFcrZ1BjaHZEWXc1bzRibzRNekZKUGp6RDlJT2xBcHlPditzTENOQ0Uy?=
 =?utf-8?B?RWtEVGRzWkx4dzF3R0swaFV5SHVWYzM2RW5IS1FUSk8zQyt1clFHS2lCUnh2?=
 =?utf-8?B?eTVUZzFZNUQ1eGpQUzBZVVBtVFR0cWs3ZlJuQlBtZE5haFRBdE1WMHJ0RzBu?=
 =?utf-8?B?NVh3c2daYVB2RmdGV1RxNUJmMTFrYXRqTHJEMGpVTnFXcjZBb0VoYy9xOFBN?=
 =?utf-8?Q?JBAs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede4bc4b-0d73-48df-8f12-08d99c53ec00
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2021 09:50:50.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXwTHDs27rNAZcrAx33+tWrAYohWAtswFpNjDsWbFgRFsq8IMXkq7pThnqMNjyZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2021 2:06 PM, Simon Horman wrote:
> Baowen Zheng says:
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used by multiple flows and whose lifecycle is
> independent of any flows that use them.
> 
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
> 
> Tc cli command to offload and quote an action:
> 
> tc qdisc del dev $DEV ingress && sleep 1 || true
> tc actions delete action police index 99 || true
> 
> tc qdisc add dev $DEV ingress
> tc qdisc show dev $DEV ingress
> 
> tc actions add action police index 99 rate 1mbit burst 100k skip_sw
> tc actions list action police
> 
> tc filter add dev $DEV protocol ip parent ffff:
> flower ip_proto tcp action police index 99
> tc -s -d filter show dev $DEV protocol ip parent ffff:
> tc filter add dev $DEV protocol ipv6 parent ffff:
> flower skip_sw ip_proto tcp action police index 99
> tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
> tc actions list action police
> 
> tc qdisc del dev $DEV ingress && sleep 1
> tc actions delete action police index 99
> tc actions list action police
> 

Actions are also (implicitly) instantiated when filters are created.
In the following example the mirred action instance (created by the first filter) is shared by the 
second filter:

tc filter add dev $DEV1 proto ip parent ffff: flower \
	ip_proto tcp action mirred egress redirect dev $DEV3

tc filter add dev $DEV2 proto ip parent ffff: flower \
	ip_proto tcp action mirred index 1


> Changes compared to v2 patches:
> 
> * Made changes according to the review comments.
> * Delete in_hw and not_in_hw flag and user can judge if the action is
>    offloaded to any hardware by in_hw_count.
> * Split the main patch of the action offload to three single patch to
> facilitate code review.
> 
> Posting this revision of the patchset as an RFC as while we feel it is
> ready for review we would like an opportunity to conduct further testing
> before acceptance into upstream.
> 
> Baowen Zheng (8):
>    flow_offload: fill flags to action structure
>    flow_offload: reject to offload tc actions in offload drivers
>    flow_offload: allow user to offload tc action to net device
>    flow_offload: add skip_hw and skip_sw to control if offload the action
>    flow_offload: add process to update action stats from hardware
>    net: sched: save full flags for tc action
>    flow_offload: add reoffload process to update hw_count
>    flow_offload: validate flags of filter and actions
> 
>   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>   .../ethernet/netronome/nfp/flower/offload.c   |   3 +
>   include/linux/netdevice.h                     |   1 +
>   include/net/act_api.h                         |  34 +-
>   include/net/flow_offload.h                    |  17 +
>   include/net/pkt_cls.h                         |  61 ++-
>   include/uapi/linux/pkt_cls.h                  |   9 +-
>   net/core/flow_offload.c                       |  48 +-
>   net/sched/act_api.c                           | 440 +++++++++++++++++-
>   net/sched/act_bpf.c                           |   2 +-
>   net/sched/act_connmark.c                      |   2 +-
>   net/sched/act_ctinfo.c                        |   2 +-
>   net/sched/act_gate.c                          |   2 +-
>   net/sched/act_ife.c                           |   2 +-
>   net/sched/act_ipt.c                           |   2 +-
>   net/sched/act_mpls.c                          |   2 +-
>   net/sched/act_nat.c                           |   2 +-
>   net/sched/act_pedit.c                         |   2 +-
>   net/sched/act_police.c                        |   2 +-
>   net/sched/act_sample.c                        |   2 +-
>   net/sched/act_simple.c                        |   2 +-
>   net/sched/act_skbedit.c                       |   2 +-
>   net/sched/act_skbmod.c                        |   2 +-
>   net/sched/cls_api.c                           |  55 ++-
>   net/sched/cls_flower.c                        |   3 +-
>   net/sched/cls_matchall.c                      |   4 +-
>   net/sched/cls_u32.c                           |   7 +-
>   28 files changed, 661 insertions(+), 54 deletions(-)
> 
