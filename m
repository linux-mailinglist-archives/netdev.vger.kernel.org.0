Return-Path: <netdev+bounces-8351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 449AA723C8C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B9028153D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44EE0290E7;
	Tue,  6 Jun 2023 09:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B8A125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:07:58 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6FD109
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoZlcnu5FqR0r/PIEtE+pm4yDysxJ2o6/WK3n0pYjG9315BzlOv2Yb/iK8VHzJcpD+xEPJ9B0rku7miUVFJg5/9rI+ynQ5L0hV00t5l4sAHuRmiIZZID0EuWjnZU74HSH2LFb2QfrY1RFPjixtI4+SAFCh72H1+m5hXmL8tuFo4IxK6+g1hUlJH7HDWwbZNe2ZVKZCmCqodpYW7sXdH9OIC2VUgR16T7A8N36LIQJHFzoAYm/lxKqZGJy2HYvwFLVl+JFLJ4p37m/f6Rqz0+otqaRG3luTcuVfZq1s8Y8LJbMTIOmCBjiABhhvyBvEMVvM8d8zCDrFtoS8ux/cK0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjVezmjnAW7TpccvOWoJoxku1GyScIhpk4E4keOLamU=;
 b=KdjIc0lZBUFq0kUlq+zzrh32xmpX+1hS5yPqSj8khUrO4CPu8dPNupPjPPNCTw3P82hFcCe/Fd8MqvflrCrVVyf6k+8G0yWjXG8Y8WTDLZgifqjGPQ0/rwLWkJWJahy+LHmiCJ85r7so1Lmb/z9q9lFDeDsIIjoknXA1YViki9sLok2RL2iT5W5SeYKxXdePMzH3PBWF4g2RrQtJIST+GIPRl7IDXTpj4X1U2CqUTzliXNsTt0v0vRGPImoeXJkuUwDjuIOdzFNVKBLJbNQuqv2qUufMPz23rimmQGi+9PT5wSvCYs5iqARFiZDXHmr79TdedZgTC+1K5VfF75PUrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjVezmjnAW7TpccvOWoJoxku1GyScIhpk4E4keOLamU=;
 b=S6rqW669OemIijUDIop2GWoOoCaYSx0eJ1IjrhJt9CZpZ0mY+UDcgg00N6p8VL6FXMjzO8/YgOqwwrGa5kktKk31lQCwYX7WWCHUG5AcaNNGG+yx3EvwtRd6tmZKJK1MiveWoFMHvM76WW0YV6UCp/kTdxHpK9W/WkhFgNBBsYM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5802.namprd13.prod.outlook.com (2603:10b6:a03:3e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Tue, 6 Jun
 2023 09:07:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:07:55 +0000
Date: Tue, 6 Jun 2023 11:07:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net 1/4] net/mlx5e: Don't delay release of hardware
 objects
Message-ID: <ZH73Zd+gP7/Gpyuy@corigine.com>
References: <cover.1685950599.git.leonro@nvidia.com>
 <e89e4c68b70d8b469e7a31613d56ce2974bc943d.1685950599.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e89e4c68b70d8b469e7a31613d56ce2974bc943d.1685950599.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ff17e2-1b5e-4459-880e-08db666d8419
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2XMyWCX7dJSVa/sfnQuC6r9f99sDKOLhrjT8dhmkpAStdHdzJmRDDb8qG2GmxtnmPeeAvQ0GWMCTSkrMMmjnBvRJnC/OV1QE3UKazCRBz28f3UkEbIr4jiizHyged5969SISiJZCxQWZ1EqaAxsVmqXQe+fuGMW93yJW6n9GSfLmwNcCllJFR6+DC1mRypjpphVxT2EIj5tkGL8HlLEitY0+9bklCYNC5knA2O27inLdWdSuJqrOJnui8Fd0wH2vu85BQCtL77drAYQNO3RIhPQAa9rXJ0ViGwnI/RVr0RbdMrwIdSGjJEaqE06dU7tGJLdZrj+HJb07+ibX1MY3eHgqryI3E3Kt12OwZrXYAr01NP5K0qLXsfyEd8xHkY6f/NgPGlP9iAxO1is28KXI0DB/YwXG5x3fIKZHkfJzPMgIE8sivtdrCWTPzBzjqyIKc41jCTd1MQPnzbEZxAQUEaeyDb3zdL7n3GrwRRf/2rlDqV++wmT7wq6ZlyqorXSrZj0bke+hcsoyOFEbHzNVxRGuRzOmLIxCFYzojdVFpUY0IXgCT/RwluJz+izIfcWV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(451199021)(6486002)(6666004)(6506007)(186003)(6512007)(83380400001)(2616005)(36756003)(86362001)(38100700002)(54906003)(7416002)(44832011)(5660300002)(316002)(41300700001)(6916009)(8936002)(8676002)(66476007)(66946007)(66556008)(4326008)(45080400002)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XsExLFT5PFyyyALqOVaAQaccPzY32N7TGI2Wl1qPMMroJI/UfTK8RsfYttnZ?=
 =?us-ascii?Q?VFj3iHl9SmNFkXsDajAtIRB1Yf4yyDCbwWSSOjcnuD4OUcB6iWE27hjqYV41?=
 =?us-ascii?Q?tbPiAfpuJ+36RGX/5GUY22aWEpsb4YQFOV4nNIoaayj5cqRfeAOQf3410KxP?=
 =?us-ascii?Q?VUF0AkFq1FOKDpMatX0Gh+iX+isj7Yel3a0iFWTQNN37StSJo072XXsLXLgw?=
 =?us-ascii?Q?G5rWHLnM1IJdpmmIzQ+RAme9rD+yARmN1FFIvmvnmXwQAJzt5TUujJ4ZE2Ho?=
 =?us-ascii?Q?Bh96xuWfZ4K6rOB74G0a0MNMe9g48I+JBqWvxJ3NCNnwDiHAIWIfUxhBRboV?=
 =?us-ascii?Q?tl9FDRj3lDub1DW0wRPMxgckRKlzS/4tnQEokAAnWLBl9dRM3/IByg6SF2dh?=
 =?us-ascii?Q?xBAwFu6SmrWCvKkxm6TvAji/rc3A7mNFBfcrNX3JBsM5lOGNBvY6WjQPnvG4?=
 =?us-ascii?Q?eNWcUny7awZEJlIv9owTQkLmgrgVUhTF9Tl3bTip6k1BNVuwMYFvzBh7bYSW?=
 =?us-ascii?Q?NmfqkJIrnCERKOkeJSnTvbfCFYw4p3mDUTK2w0vQwFX2vnJfZ+lUScOY0qoB?=
 =?us-ascii?Q?M1ceXPg+JtrT0htnoA2gDyGaoWuwDQPwsftuOcRUFvpOCP5P8dsD+y+LPhh9?=
 =?us-ascii?Q?P1wG9wiFlzcuDfNp/BijPht1ZFO56PgjRrDG5J/DOJOXaEP5KsxaoxzdQZ/R?=
 =?us-ascii?Q?mkABXDTO/C5rctzcbX3qRRDxn5GA0aQX8f4ZWfjB3wmtwHTMp67Arapp7wD4?=
 =?us-ascii?Q?N4FWAjlQ5daLlV2b5lw4GmulojUf52kl7ePv9uutavZ7XBQxvUjhRchde+sm?=
 =?us-ascii?Q?+HsFXmpeEP+RLarCAcGXUzwRijiVZlK235empWoSFdi0o+KLuD9hzHw9BCsy?=
 =?us-ascii?Q?IBXfanUUS14xZrGjDmpHk9AdPzTvUMAtLliN2eXBRzCTMfVPxXLBCYg1qMTx?=
 =?us-ascii?Q?bMHJV32c4KyucxqNEWfO4NfE/DHDBC9tokA0wuvQDbjGtYY3NNkKr9qbcIaj?=
 =?us-ascii?Q?TCYyV0BdoD/81w770OrR9YP9Fr+nwpeuLZfQC4w5n3/ns6zZBo0JKQJ1zu73?=
 =?us-ascii?Q?nkP0KrEqGaG+Qh5szZcqI7G/n4843MUb32m8/+RNECrD/kKRqRYqQHf5RdEC?=
 =?us-ascii?Q?56uH3nnqYYzMwWFL5s7h6pyk7ZYFOQvMDPSp7FEtbR6F8IABevELn0iUyO4m?=
 =?us-ascii?Q?s9q7oQ+z66QNT/oJTqDemERGD64C8NyFs+cFYTvSGhxmailaBu24EY0rp0tg?=
 =?us-ascii?Q?nRm0DEZrStYFAltsOtHI8B/nm7tqWgyznTT7xrYBcGzAcssunZt1+5T6JGXW?=
 =?us-ascii?Q?AY1UfQ8C3HJ7h1WbTjBqj/fE17rVEuUF3+d71iaqpYr7eOm4uPx5PzY8MQXZ?=
 =?us-ascii?Q?6I93jmEu0HBy0mJ6JeEEL9ecpAmk2oiLsoWVZl/aUaBrIzGY7jmVb5bukTyV?=
 =?us-ascii?Q?2T1P0OdSaAct9Js/QyScQg/GC8v3vP2JwI+qWPGGu8Kxo7A/twHrgpNlmhYG?=
 =?us-ascii?Q?t2yKkOvAjSDMMeZRJsjnCxeHDonEHkcLf4Ym9j8pgPqDHbpIxYh2IX6d1b1A?=
 =?us-ascii?Q?0QzKa4QqOTIKGSCHHA6WwGxHzzekZfs9bCKtBLo5n22DeakNXswCt2y0cs/e?=
 =?us-ascii?Q?+LmLeWhJUiYX5kV6DG8r7j5Af6ki6cNBM/RWwhNIygqPBRPVcX1Z/cyEOFlo?=
 =?us-ascii?Q?RUtCbg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ff17e2-1b5e-4459-880e-08db666d8419
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:07:55.7817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2xVedE8Eph00KbkqXlgpUJykebZG57FonMhGZcTSmOZFUWwU8t4TDvTcXe4k9zmOCPNf59PLpAk3q5q3LyE8kfg9AOLA23oJVxqX8mObaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:09:49AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> XFRM core provides two callbacks to release resources, one is .xdo_dev_policy_delete()
> and another is .xdo_dev_policy_free(). This separation allows delayed release so
> "ip xfrm policy free" commands won't starve. Unfortunately, mlx5 command interface
> can't run in .xdo_dev_policy_free() callbacks as the latter runs in ATOMIC context.
> 
>  BUG: scheduling while atomic: swapper/7/0/0x00000100
>  Modules linked in: act_mirred act_tunnel_key cls_flower sch_ingress vxlan mlx5_vdpa vringh vhost_iotlb vdpa rpcrdma rdma_ucm ib_iser libiscsi ib_umad scsi_transport_iscsi rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay mlx5_core zram zsmalloc fuse
>  CPU: 7 PID: 0 Comm: swapper/7 Not tainted 6.3.0+ #1
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>  Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x33/0x50
>   __schedule_bug+0x4e/0x60
>   __schedule+0x5d5/0x780
>   ? __mod_timer+0x286/0x3d0
>   schedule+0x50/0x90
>   schedule_timeout+0x7c/0xf0
>   ? __bpf_trace_tick_stop+0x10/0x10
>   __wait_for_common+0x88/0x190
>   ? usleep_range_state+0x90/0x90
>   cmd_exec+0x42e/0xb40 [mlx5_core]
>   mlx5_cmd_do+0x1e/0x40 [mlx5_core]
>   mlx5_cmd_exec+0x18/0x30 [mlx5_core]
>   mlx5_cmd_delete_fte+0xa8/0xd0 [mlx5_core]
>   del_hw_fte+0x60/0x120 [mlx5_core]
>   mlx5_del_flow_rules+0xec/0x270 [mlx5_core]
>   ? default_send_IPI_single_phys+0x26/0x30
>   mlx5e_accel_ipsec_fs_del_pol+0x1a/0x60 [mlx5_core]
>   mlx5e_xfrm_free_policy+0x15/0x20 [mlx5_core]
>   xfrm_policy_destroy+0x5a/0xb0
>   xfrm4_dst_destroy+0x7b/0x100
>   dst_destroy+0x37/0x120
>   rcu_core+0x2d6/0x540
>   __do_softirq+0xcd/0x273
>   irq_exit_rcu+0x82/0xb0
>   sysvec_apic_timer_interrupt+0x72/0x90
>   </IRQ>
>   <TASK>
>   asm_sysvec_apic_timer_interrupt+0x16/0x20
>  RIP: 0010:default_idle+0x13/0x20
>  Code: c0 08 00 00 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 72 ff ff ff cc cc cc cc 8b 05 7a 4d ee 00 85 c0 7e 07 0f 00 2d 2f 98 2e 00 fb f4 <fa> c3 66 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 40 b4 02 00
>  RSP: 0018:ffff888100843ee0 EFLAGS: 00000242
>  RAX: 0000000000000001 RBX: ffff888100812b00 RCX: 4000000000000000
>  RDX: 0000000000000001 RSI: 0000000000000083 RDI: 000000000002d2ec
>  RBP: 0000000000000007 R08: 00000021daeded59 R09: 0000000000000001
>  R10: 0000000000000000 R11: 000000000000000f R12: 0000000000000000
>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   default_idle_call+0x30/0xb0
>   do_idle+0x1c1/0x1d0
>   cpu_startup_entry+0x19/0x20
>   start_secondary+0xfe/0x120
>   secondary_startup_64_no_verify+0xf3/0xfb
>   </TASK>
>  bad: scheduling from the idle thread!
> 
> Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


