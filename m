Return-Path: <netdev+bounces-10072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E245272BD1D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E30B1C209CC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA518C01;
	Mon, 12 Jun 2023 09:53:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6EF8828;
	Mon, 12 Jun 2023 09:53:16 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2123.outbound.protection.outlook.com [40.107.101.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406505BB0;
	Mon, 12 Jun 2023 02:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMl2qdVTW0qPZSFnSr92hDZrWkWuo/sEWoRIvIiVM63vYPGCOYS1/73Jxm5B6h/dYH6znxiO3uhvpw1cMl8YZCXX0LyGES3o3IVD1dVcGtnDZFD9M6dKtQ3MULFwMek6mNdYaCqkF/OGf+zoQJ/4NTVhErJXg6gCN//7E8O8DI8ITcsuieuZ7DQ5CvdR3+s/KbkJU/g8rgGKcStzhQBnDI2S/O4J79II8JH7yttqIB6Bcg8pa2I4b2xfayHetjuzD1vk2VtIkkPNoUWpz0IrXSR+8MaCSd04B7AfqWtF56JNvKywy2XXWebLGKujhU5wOU5BuDmZQGsezu3Ybwedxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzSrWYlTV3dEjy/jsSI1XSdPbRAILZRO/NQ6OIJbAOM=;
 b=ncJkFMZ9k1Z/Cgz7ax+9mgl47QQM8DdKoaCgZkJmhNH6dwvNG+PzTmnsRF7C/dCAqg85gJ9UJJ4bwMcSirdA0hioCBIm1F02pl9ZfJZr8+GZGM7Kq6vrEayiKtQ+otIEz4dFIHuyem5PLG5YRsGuj9e5mhiQSusqNw89WGAZjr7OzBeFKPXVSADq4F11coyRQU7U7YcAHyeFJ/QRxlDoKl9CpmGsmzbNJDrRLoYbfwTwx8sbT/6Esgv1jdDHDL+osLW1c4oxubJ7kdLGTXzO0SYP9YOktfw5uwVfxCMoJBsOxyfwixoQlNWq2d8yO7GwGibvB49VCvKLkzr8WPIwMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzSrWYlTV3dEjy/jsSI1XSdPbRAILZRO/NQ6OIJbAOM=;
 b=Gi7bhptYqzow5puOWyu88UYIZf6jUPlaAjAJm6/TsG/gvwheTR3pQM07dS/NqShAp+Rdz+Bb8miqtkH6+qIyggL5/UMjbtoNXmD/2HYyMU1BCLEE4giTcOVXDbfHlN1dKQhdazlj1Z1iCjlsz9pxe85fRcFUpM9mEl+nSyyawJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3717.namprd13.prod.outlook.com (2603:10b6:610:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 09:53:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 09:53:09 +0000
Date: Mon, 12 Jun 2023 11:53:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 7/8] vsock: Add lockless sendmsg() support
Message-ID: <ZIbq/CeWowEq+nvg@corigine.com>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-7-0cebbb2ae899@bytedance.com>
X-ClientProxiedBy: AM0PR04CA0054.eurprd04.prod.outlook.com
 (2603:10a6:208:1::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3717:EE_
X-MS-Office365-Filtering-Correlation-Id: 782a562c-4550-48c5-c915-08db6b2ad44b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	frGqxNmZW+J6BegJdT2APZdNJM6bsEY2GjDUZex6LdHEZbmTpQIDH8TkR6ZVefjEM/DSQgfatIR9XuFu2fqOSrSx7r/wWpJv0QuImAo+ElneTN1twy8bwFZrx6dFBh1yiTjTyZsmim383CyEqRy5+XwIdXtueF8LUrTj06a9pyWkAugMXqHFD3SxC0KyHbWFYbDaFQjh5h0DGVU4IRtqL87KzRUMluEGuMdK94Phoxk72S7nkcyODWB7Jhm8NmfyafatVX3j1RiqVqr3VFgsf4irPjraDAZuvxSdfYlbVyfmUU7wdaRTlK6GUURD9ix0gc0DN9CSybkSjFFyxycx0bHZ5WgkL0YJ1P2UwgoDEAoUcMHMsDRR0ShpgmbcJFhPv5Wn4wwaS9S/dTGDLSJOOZWCKencc0tCDFIDoa5nhYMiNDMxDOHGzzvNJFTwkATVlYNRIUpfMvEVnhMqid+RZCgGFmOjp+OBVk6PbXwrmv5oMN1kP6pvZvdOxH2D1RuwSPvaht7GzUtZHkLUlmMT6cDXyzNRCzHQj4ZiX7NT/6Kzi+HAjkXZtOSM9rfkB9hiX/IBaKQTjYqIyQOxDbqOeCV5qj/zCl51JKu/3Iad0GQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39830400003)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(38100700002)(86362001)(36756003)(478600001)(54906003)(44832011)(4326008)(6486002)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(66556008)(66946007)(66476007)(6916009)(41300700001)(316002)(186003)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xvv6W6+sc8D8w/zddHVCBve+ti0k6uxzOP4gKGC+AlzklUa2u1Mi2r50l980?=
 =?us-ascii?Q?7T2c4OPmwFEALS5o0Ia52Chs3ky5GafByULONv16HDRlFltPAKXdaXzck4lV?=
 =?us-ascii?Q?lV6kCNBFpwDhAz0kpilKwVHaPOdYjsKP/+UxW2+daZYsoxme30WEJF6RGhEx?=
 =?us-ascii?Q?MogrPwwSF32TM7GAR4zDsA/et89I7pILkXWqpq1XbSD4MBk/OLWpDCcuLU6r?=
 =?us-ascii?Q?i9Zgj1qFdnAXc4uM4NO7J5SUGw3ivGnmuGT0WPIMdk+zbtl8Xr3YyYjmHNYR?=
 =?us-ascii?Q?s6+SrsZLYDQY2GKOn/rBmYTMvOedR1CRDuG3UbYDrJChzZgr4XnPz4MNgjA6?=
 =?us-ascii?Q?Ug3J7vRdA9Rdbuzj2l/wGpuYxpR7suM0QU+A95JAJ1F2i1S10qdS1cfHP9os?=
 =?us-ascii?Q?xwAN/1tCKfGlr1QJQ881iPDnhCU8SjfSPsnx0SwX4iAfuaA3aMqOmOi27m1M?=
 =?us-ascii?Q?UNTd8t2RaCZeG4NktfNYjE1Npuht3izd08/q3DyPYXoWLuU2lt7QB0VnrjCF?=
 =?us-ascii?Q?pfqBIbCbefblo4g9w1jLnBjBYo5czjDwzs+UenkaZ2VnqDRFHd18qfQERgrX?=
 =?us-ascii?Q?LwfgK/N4AJNUAWDF4ROP7UFmiIKyIqyz8Y+KalJWHImaQr4swpF8JoRX6olT?=
 =?us-ascii?Q?Qw697Ld0bETK9ZjQ50wO1R2mfz4tG4bW2vlYIQ6z0ix8n0k2HXl5qZoEMVP+?=
 =?us-ascii?Q?6wbEukuJ0L1cMaBQGGQgvs0NAatqoOwl1lH1Gxll5xw+VTm6Kxz/64RPF76U?=
 =?us-ascii?Q?hRxSlc5zOwWlqYU22tGg43vDQxJBdekg8SgSeHTmDv6KipyfK7DlDUg6bbvG?=
 =?us-ascii?Q?y+EmbipBMxCTV0+MRiGa+NswdLuIn9BujJYzVL17SFGj8ArTHOS5YFm1LIjd?=
 =?us-ascii?Q?gI+6v58KGRu8RGMn+J7v/V1j/1km1/pxaBmoEge70qxAuFzyXy1UFGAImk1P?=
 =?us-ascii?Q?Qh4r8vP35TLX7A16XT2/+q+hDKrS/D26CjXqzABU4Ps7N+c41Dk2r3WGgo7k?=
 =?us-ascii?Q?rixXfRep5v3iPFaO8/NsAm+W/eQIeYEvaU3MXYfrvyTl9xMez9lcsfkQXmS/?=
 =?us-ascii?Q?4AZNmde/4wuIrW1boeJ/pN/Z69niLw6kISbeVjhrt/kD3nBKb3i7mH64LowC?=
 =?us-ascii?Q?Lp/UBnS8QN8wZMQ7HtcNJyTi4GdVVxmzh/KBozJVRv8XyBjoudliHmjGeF3R?=
 =?us-ascii?Q?TX7M7sywV5oedRspHdFVq44AhIHjMt4iqVTvKwXd3cQfIUB+5meAnei1/NRB?=
 =?us-ascii?Q?XrrLbSlXhX3paMpTCPaWskGC2Q5YroTJrDMOiuEO9lMCgvoR9Be1J1DmPpWC?=
 =?us-ascii?Q?0DZWzthMq+sCmxsWKFJzK2LcyIW63B6YW0B2bZjxCIuKcz8KDTZx6Ni5tSB2?=
 =?us-ascii?Q?fgXsiJRihIYe5SnQm+UfFYHT6GCXEYLBN/c8b2a3qHi5BsLLyDjqdnNVV90t?=
 =?us-ascii?Q?Kyt08wB+vwmAbIBMN02yRIRW597kMtME2PP5WtMCEiXJ8zZmA+r+GaCPyl+k?=
 =?us-ascii?Q?otT0YwzeJ63Qp4cVNvQH2pAFx8sR835HGzn/7Xvs7kCbN0/QnFaUC8cY3Zf2?=
 =?us-ascii?Q?vlSPNrPQUWQp+hLqxsdg7uHEHNyfxbFFtBGWXijanrNYD88V1p7qfksydpaU?=
 =?us-ascii?Q?3r4eIL7LpSMPDDLX7CvM4vLuMRN3oomV0wlidifWQl7NU971k6csY9fa6Vgi?=
 =?us-ascii?Q?ND5RJg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782a562c-4550-48c5-c915-08db6b2ad44b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 09:53:09.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0F7eC0zaMxHxGzqGfiSPyrAyAlPc+XVpufa+OwXFWNbiGNkf2cM/EMiI5nWyBRGzpu+A1kTaZOX1aEBCNDc00YJv274JNNKyDpL0tgxiuVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3717
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 12:58:34AM +0000, Bobby Eshleman wrote:
> Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
> it does not scale when many senders share a socket.
> 
> Prior to this patch the socket lock is used to protect both reads and
> writes to the local_addr, remote_addr, transport, and buffer size
> variables of a vsock socket. What follows are the new protection schemes
> for these fields that ensure a race-free and usually lock-free
> multi-sender sendmsg() path for vsock dgrams.
> 
> - local_addr
> local_addr changes as a result of binding a socket. The write path
> for local_addr is bind() and various vsock_auto_bind() call sites.
> After a socket has been bound via vsock_auto_bind() or bind(), subsequent
> calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
> rejects the user request and vsock_auto_bind() early exits.
> Therefore, the local addr can not change while a parallel thread is
> in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
> Change: only acquire lock for auto-binding as-needed in sendmsg().
> 
> - buffer size variables
> Not used by dgram, so they do not need protection. No change.
> 
> - remote_addr and transport
> Because a remote_addr update may result in a changed transport, but we
> would like to be able to read these two fields lock-free but coherently
> in the vsock send path, this patch packages these two fields into a new
> struct vsock_remote_info that is referenced by an RCU-protected pointer.
> 
> Writes are synchronized as usual by the socket lock. Reads only take
> place in RCU read-side critical sections. When remote_addr or transport
> is updated, a new remote info is allocated. Old readers still see the
> old coherent remote_addr/transport pair, and new readers will refer to
> the new coherent. The coherency between remote_addr and transport
> previously provided by the socket lock alone is now also preserved by
> RCU, except with the highly-scalable lock-free read-side.
> 
> Helpers are introduced for accessing and updating the new pointer.
> 
> The new structure is contains an rcu_head so that kfree_rcu() can be
> used. This removes the need of writers to use synchronize_rcu() after
> freeing old structures which is simply more efficient and reduces code
> churn where remote_addr/transport are already being updated inside RCU
> read-side sections.
> 
> Only virtio has been tested, but updates were necessary to the VMCI and
> hyperv code. Unfortunately the author does not have access to
> VMCI/hyperv systems so those changes are untested.
> 
> Perf Tests (results from patch v2)
> vCPUS: 16
> Threads: 16
> Payload: 4KB
> Test Runs: 5
> Type: SOCK_DGRAM
> 
> Before: 245.2 MB/s
> After: 509.2 MB/s (+107%)
> 
> Notably, on the same test system, vsock dgram even outperforms
> multi-threaded UDP over virtio-net with vhost and MQ support enabled.
> 
> Throughput metrics for single-threaded SOCK_DGRAM and
> single/multi-threaded SOCK_STREAM showed no statistically signficant

Hi Bobby,

a minor nit from checkpatch --codespell: signficant -> significant

> throughput changes (lowest p-value reaching 0.27), with the range of the
> mean difference ranging between -5% to +1%.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

...

