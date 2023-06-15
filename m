Return-Path: <netdev+bounces-11149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A27731BB8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3F4280C2F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E03512B61;
	Thu, 15 Jun 2023 14:47:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EE120F5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:47:31 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C02C2977
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TC0egrbze7YpuCzCNluKX3Kh7l8uHcUysRRKg9FJ0vHRxxZZO1ts+Y8m7VncuqcxsYFIaeobVFbsOBoxDBpYBJmigPE+qAXAZph430tElyMfF3PVUePbMVSHdxBp3HLV1dXAUuCQaheUd70Sxq2LqSwDrXU9xoSaI6PyQ7WsCvr+EzNLEwtdcyF7P3BgW0YpiL4FIBogNVSI2UJhN6TLQcu42ok60OYedh8uXLHYBybwxQsLStTgD24MlAT6SqZHnuVpIUPdnyGsXczGaj3F9U5J5VnaMiQmKR1xjOFFBmz/OO3zMrLsDM2bQ/n/8pPnV89jMEaV8VQpOIWSESJ7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t943Ylbp6VEe59Jt27DGWoMuMKVdFCkLprSkxe4FS1o=;
 b=ILisspv8FXeuNo4VXp5EzJvY3Bui5Ao0EZdE7E41UStw5bf1RmKhoEsQMT6F4Sgjn3A3eD9FPDsT3cMmd8g82UXBIlZSN9lVpe/RsXhQsrVv2Co0NYIt0GjRmMGjCamkPnb/uDf5SIWXvFU00Rxc+0yXGPxT/btSg+kpw2qBEm34+Lqobp9mKoBbWVQkvjb2uOe5Wu+67S8Dbhw30dqTbdynU9sWPAIgZ4WtSyuLBITT1qnb+gVrc7mzjDsC8eoquBklma4zYBQXagmsHEA90m2/12UfLcm/NwS9+jSuLsGWMyn4/DixqGuKdwItCX1a9jKL+45AdFSzAMpeaSj+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t943Ylbp6VEe59Jt27DGWoMuMKVdFCkLprSkxe4FS1o=;
 b=K0hRPQ1CrOamN+dLB0bJVoedsf5xoR5T+AScYnLBymWCXj5iUx+94XTzS+udQP07GXYggeG6mXMThnWALpfZjSjGcc/RzXgvGzVZJkq7WyvyhE7tcYYv7WrNWfSSaMpCp1oO58CnSPGDEHC98IxyME+rfHXUCsjlaV/Ws1/nS3I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4613.namprd13.prod.outlook.com (2603:10b6:408:12e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 14:47:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:47:16 +0000
Date: Thu, 15 Jun 2023 16:47:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	syzbot <syzkaller@googlegroups.com>,
	Martin Schiller <ms@dev.tdt.de>
Subject: Re: [PATCH net] net: lapbether: only support ethernet devices
Message-ID: <ZIskbZUlMhnYEUAd@corigine.com>
References: <20230614161802.2715468-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614161802.2715468-1-edumazet@google.com>
X-ClientProxiedBy: AM4PR0101CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4613:EE_
X-MS-Office365-Filtering-Correlation-Id: a7432e10-44ff-432b-f779-08db6daf6974
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JqpTgc4MksFLqpVSFmmyrOmJg7pYZQ2KhiIDbqeFDrimYnDTgAEf9WUiWoJo7UxIQcF2hi8NCcNEnvY9Immgf4dP8Ct/vgjjOcBgHVu01trJjP/SylYwopkbFdYi+xAU8znKxIEZZD6ia4P8d4SY9Smj5BtRBvaBXB+43JpeSQf4vUWggHrLnoulBROMi0x+yW4+fzmSG2maR+TkwVtEtpzIugWNAvgVuUrrXeFBUzgYBV2nsBtqV0p0rqWQGEauXWJlfZiK99p4Ghy1R+b6cMY1b2bEuynw0QTLSMCt82SfmY9UlJayXyjeVWkfW+tTG6oGKCCxEJq7UI0yeK4QIaiSwAszHfcq1qdsnoFYbDuIqredf2mgBXijxbSCUnenbaM0aM95BJJaFcWb2KGjzooGz7WGkXlJqUnlwA8cLl995bAt3GrWrB5MeqXa7EmowHxz8HOt6NW6nPay7vDxlrzNJY9NapD0OsYoldoYUPDc4thPCI3BRfR0ldiHC2wdchF5bcFErwpynR5KjgIlyHFR/aeR2ZRAjVuMp9WQiWEgxg/P9q2HIKNxMXw0AWax7LO6hSgIqE13SEMcgeHvPkg874W8B9y7bcXPbK1RU0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199021)(5660300002)(38100700002)(2616005)(6506007)(186003)(2906002)(6512007)(44832011)(478600001)(45080400002)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(8936002)(6486002)(8676002)(41300700001)(86362001)(36756003)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxlLKz6o2cV++D2GzPS5uGFc2qWnr108gzuYobvY6yeg4Wz9gHp/YxYDRuez?=
 =?us-ascii?Q?s2XYEG3Qspieq2b0ZYInA4fG3r6yBvVR0538cg/Z4G8t+Tkwi4uyJHqxJ5Zm?=
 =?us-ascii?Q?aUu6GaBTBMclKpmiv9ESqTjo7hEpDHh+R/ZwRD86DzxiX/1uXKMWN24I1iaO?=
 =?us-ascii?Q?3ygsxZxFtuqX4CLJDvVcuwP2L11Bcgd8ubYYRif3ClWzeUUB5gcWyL9JzpiD?=
 =?us-ascii?Q?03WZIwJNL/TgBkvw9juJdX+OcLKtAJBT9KeAh8UZ7GScVpKEitZbNLAsj9dx?=
 =?us-ascii?Q?JfqCmKIqRoNSBxEv6XoqJCvhxQYNHLhTfaMIWJm/jpHrUHi+dO1cpkK6JZre?=
 =?us-ascii?Q?HqJ91kmaP6QDatYTxY9w3ufRImAiCDpFGYBf257lfYs6fF451/WYgxIgm3cy?=
 =?us-ascii?Q?pK20vfnijPPXxiCfCaHYWvqdpaKZG71Va8ZsRHXMuSeh8HLvXFmoVVb2yO1U?=
 =?us-ascii?Q?r47KruVHDIPc4wOZ2fQ2NS2B+b3nrukP7ApaDZ+un7G0zJq/ZtgU0DI2a+Ql?=
 =?us-ascii?Q?dc+wajJkIziT49yw25pyGdessMH9cU3XdYXwVL0Xl9SIWXlQK7I5moRDCGhX?=
 =?us-ascii?Q?4ymMNfHXV0LlDlRuq9uWclM9L0AttK38m6c1l1UecbhJrv8cYTk5HxLeFrIc?=
 =?us-ascii?Q?9Qv36y7e/Duk5n4ID7SPR160nuzk76TRNO5qHhbfGABAI+E8E6kZSqEE7qKZ?=
 =?us-ascii?Q?j17mWWtuiyQSzcXzwsEv+b11G+Vf9swhB/O0E4KTFsu4uyyRG8NBWqc7lwPp?=
 =?us-ascii?Q?h97idZ+d6sY3El3d8PyBguLmcAXLqw4xal0CLOJxvXAOxFxP8Pw2+LH2s2Sp?=
 =?us-ascii?Q?M1CVbgaWxKSAk8i/WcI+Gpq1H3ieaE1xsFnLWJz4Qi2T4kEQ2ohYcxMIO1ar?=
 =?us-ascii?Q?OptdxDVTfgfQmAHZx8DW8ovWafJ9C9Ga7vwyfp35RfRq39QsqvChXtfYq0Ey?=
 =?us-ascii?Q?QeLD/LyKqVrtlC/ECQRwFXdq847dU2H26x3OE0ikyEB+gr4Vphm/Ufrw1deF?=
 =?us-ascii?Q?N9bioHQZf0MDp31z2toFMJxSffOEgjYbwdlDdk3NuFJ/qV0fnJdrJr6WdDai?=
 =?us-ascii?Q?hNjUxT470oaX8Y+cOiwGSU0Qd/SEk6q9riUa/2fzY3y4z7RpkY/auKvhppQG?=
 =?us-ascii?Q?Mlw/ylb57UU5sBa0eJCZJ+pGfo6PRdaUDDIYfuLAtzmrhYWuLR/L9TOV9TbT?=
 =?us-ascii?Q?Tq6mfDWDbyJnOjGtXxqCyC+eTBT2QU3Ykr+F19BE5d6Pd5cQEH67nH2D1XYI?=
 =?us-ascii?Q?nvnONQSJ/6UPkf4HLCtc5pPc1BnDomzRoWM4/0Cb234kvpoTCG4QLNOJdKML?=
 =?us-ascii?Q?+1OnGE6nCHcMmCUyPdacwVA42l2T4CjIt2164GwQnTM0P51a1894LhRLT2pQ?=
 =?us-ascii?Q?2L13wzmLfyySkYl3FfsCy0Z/0FunkAM1b0XR6PIGC/ba7MFdhDFlFBh8YYq+?=
 =?us-ascii?Q?mw6K6OYdjvnLW2JmrSFZukmwsO5g/YWMtlv1JzZiWTRcyCF2SBja8CUYF9xX?=
 =?us-ascii?Q?jxEfnvXbCvtX2TfeVk6/XEezv1hKk5BAJdL12WVev5FZOHRSXLU5t0e3ecQH?=
 =?us-ascii?Q?kg+F9o29A1oH/A2v1vL70cVXX1dxmKozTsBzO7eHXt+POIIKiMCZ8skvpSC5?=
 =?us-ascii?Q?NEKf9AaCzqKVydVc+kP5AlWwYzHlFVt/xmYsJncyNcdHZNdJ55NUAUsgiyrr?=
 =?us-ascii?Q?WAhJfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7432e10-44ff-432b-f779-08db6daf6974
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:47:16.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzOfJBGoO6akoZFsyqP3d1Pub+POoOtXsJEGIbnjVwkYn7zjpOU6Are9s00XM/K8i39n1THOOSelePOJQb5G6hzirJtBiZ/3lbQWQOOk8Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4613
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:18:02PM +0000, Eric Dumazet wrote:
> It probbaly makes no sense to support arbitrary network devices
> for lapbether.
> 
> syzbot reported:
> 
> skbuff: skb_under_panic: text:ffff80008934c100 len:44 put:40 head:ffff0000d18dd200 data:ffff0000d18dd1ea tail:0x16 end:0x140 dev:bond1
> kernel BUG at net/core/skbuff.c:200 !
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 5643 Comm: dhcpcd Not tainted 6.4.0-rc5-syzkaller-g4641cff8e810 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : skb_panic net/core/skbuff.c:196 [inline]
> pc : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> lr : skb_panic net/core/skbuff.c:196 [inline]
> lr : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> sp : ffff8000973b7260
> x29: ffff8000973b7270 x28: ffff8000973b7360 x27: dfff800000000000
> x26: ffff0000d85d8150 x25: 0000000000000016 x24: ffff0000d18dd1ea
> x23: ffff0000d18dd200 x22: 000000000000002c x21: 0000000000000140
> x20: 0000000000000028 x19: ffff80008934c100 x18: ffff8000973b68a0
> x17: 0000000000000000 x16: ffff80008a43bfbc x15: 0000000000000202
> x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
> x11: 0000000000000201 x10: 0000000000000000 x9 : f22f7eb937cced00
> x8 : f22f7eb937cced00 x7 : 0000000000000001 x6 : 0000000000000001
> x5 : ffff8000973b6b78 x4 : ffff80008df9ee80 x3 : ffff8000805974f4
> x2 : 0000000000000001 x1 : 0000000100000201 x0 : 0000000000000086
> Call trace:
> skb_panic net/core/skbuff.c:196 [inline]
> skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> skb_push+0xf0/0x108 net/core/skbuff.c:2409
> ip6gre_header+0xbc/0x738 net/ipv6/ip6_gre.c:1383
> dev_hard_header include/linux/netdevice.h:3137 [inline]
> lapbeth_data_transmit+0x1c4/0x298 drivers/net/wan/lapbether.c:257
> lapb_data_transmit+0x8c/0xb0 net/lapb/lapb_iface.c:447
> lapb_transmit_buffer+0x178/0x204 net/lapb/lapb_out.c:149
> lapb_send_control+0x220/0x320 net/lapb/lapb_subr.c:251
> lapb_establish_data_link+0x94/0xec
> lapb_device_event+0x348/0x4e0
> notifier_call_chain+0x1a4/0x510 kernel/notifier.c:93
> raw_notifier_call_chain+0x3c/0x50 kernel/notifier.c:461
> __dev_notify_flags+0x2bc/0x544
> dev_change_flags+0xd0/0x15c net/core/dev.c:8643
> devinet_ioctl+0x858/0x17e4 net/ipv4/devinet.c:1150
> inet_ioctl+0x2ac/0x4d8 net/ipv4/af_inet.c:979
> sock_do_ioctl+0x134/0x2dc net/socket.c:1201
> sock_ioctl+0x4ec/0x858 net/socket.c:1318
> vfs_ioctl fs/ioctl.c:51 [inline]
> __do_sys_ioctl fs/ioctl.c:870 [inline]
> __se_sys_ioctl fs/ioctl.c:856 [inline]
> __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:856
> __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
> el0_svc_common+0x138/0x244 arch/arm64/kernel/syscall.c:142
> do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:191
> el0_svc+0x4c/0x160 arch/arm64/kernel/entry-common.c:647
> el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:665
> el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> Code: aa1803e6 aa1903e7 a90023f5 947730f5 (d4210000)
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin Schiller <ms@dev.tdt.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


