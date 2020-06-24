Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7720733E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390615AbgFXMWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:22:51 -0400
Received: from mail-eopbgr40077.outbound.protection.outlook.com ([40.107.4.77]:5177
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388696AbgFXMWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 08:22:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUzW0CBOSQOEAWYiirxNd+sHsC2u2db4blWjyNpFMVXxJar0he0JWJiNsNGnWS6rBuvYnxHB9bp8dVcmmjOmbTHIyYdGkZ7Bg3xb2hxfN6MexC3l9k0kRwRDQHHkq3MJy44yIN7EWe/eaHbqdSRx340MXDDt4gfZ2pcdog5uinzRUU9NOie8Uuu/KMjZjmUMQ3kKX5TJ8hU2RGi2nKtMiRNaJYZ6RojnXrcqW+Npap7cY4PNLCyfhV2iaYmm67qBnIXCCLaQoGP/kytw5qANa7XR/szPX0V3TpJbWluBdRmye4BZB/pH6DesYfFd4Dh5/u4oV6zd5nTwIHr6m9SbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1o0w9cuSeZCaJwcGe2apqpNrLhJRCA6jLTfC/6IymZM=;
 b=HwQdikNVZo2jpndBXtJA3wbi32aYVOZKRR7zm57hkowlhMpmBxynElRu+TRG6Ksg3WGDGlKvOn1LzdARukd451QpC1DCFs3j/jDG7St5yY+S/GWbJ1tQszfRVDyb4vZnDKx19f499alNIzaBBDDgPre4wn8S3eZ0ePQHl3BI9Can3RX+uv3Png5FXMge5B7i5KidFYo6Nz3lr+7oWPQdtgP5xual1PRCQ6qAjilfhBcZoRI0e3hXch7RSr5ieiG/2fxOc8d4fY7KQvpKAyScBc+5sxSCh3cSAm7yqRSh3gEn+pBb7SAy18VXa7ICjE5SoDWYRWJY+0PJqoi+UvHxvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1o0w9cuSeZCaJwcGe2apqpNrLhJRCA6jLTfC/6IymZM=;
 b=CrXtNXg4hTCCkgis/mBlLf1GvduvLhdVrfyJrzSEu2WgL4toEBZIlX71AMD/XvydQBQB8DISB6ZZlZQRvZCEm3QgjK5tJ46CcuXBjcm6d5fKJS/o48On4gMc/Nay6A19dnvQVjBA0U3OJi15bxTbfb3imv/P/02SjWnTsXPdMeU=
Authentication-Results: ucloud.cn; dkim=none (message not signed)
 header.d=none;ucloud.cn; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6629.eurprd05.prod.outlook.com (2603:10a6:20b:142::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 12:22:45 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab%6]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 12:22:45 +0000
References: <vbfbll8yd96.fsf@mellanox.com> <20200624103057.GA30577@salvia>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Maor Dickman <maord@mellanox.com>, wenxu <wenxu@ucloud.cn>
Subject: Re: Crash in indirect block infra after unloading driver module
In-reply-to: <20200624103057.GA30577@salvia>
Date:   Wed, 24 Jun 2020 15:22:42 +0300
Message-ID: <vbfmu4s8xgt.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0059.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::27) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM4PR0101CA0059.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 12:22:44 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88b5503b-b90c-44a4-e588-08d818394cc1
X-MS-TrafficTypeDiagnostic: AM7PR05MB6629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB66295036661575925FBC1054AD950@AM7PR05MB6629.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPIuGmfoILUlGqJMcEjiMpeclaRm5RPmcqhaIGLa6woCQLy2VxMO6LnW7jcsXluObjPrjgnXyHmFWzTHE433sbftFsbISPJHmTQtyt7cQ/Fj+CKuYbRRjYkayL9jDYeX1FYNa+KnwZpqqVlSzUPKyEqUdq5OBViC7OnYesz9t+VFSh2FlbbI4PRWyxc3lxNQeOQ/TgUPhlgndY1NFptvIDGvioPPnPcbSdy46VrL+RyZPue8LDNRB+5Uusj9/aLLPbmSIN/TtHvgF5ImLVzvCxoiSQPZx1fpr/r21DNPMCdmMmvEC1yN4B837fNDLc6t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(54906003)(83380400001)(5660300002)(2616005)(86362001)(956004)(2906002)(4326008)(8676002)(52116002)(16526019)(7696005)(186003)(66556008)(66946007)(26005)(478600001)(36756003)(6916009)(8936002)(6486002)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rsja2HwYgNCLBz7KOHfzjAn4Mj3eSSCE14mvhQvhRmmokOQjZW07Zm9F/mZCLt+Ai9krF/sibu1Q4PHrU4nPIH1edaXY655PPzlPyzk+diMHoswzyJKBApc8VGgg7HShwGiCINnqfizQml6BerPiyGRpOdqe6g5gh/0vUh1KXPY1s4Qo3qop5P4xOeUBHmMfKXO2UOQ2QBemxYbhzyrCJA7O90h25cbaYGm+Mi4K+B5a8z9WRUzHAAyQs/s0pauBOjZ449KVZQMtk41/+I67aa7Oxevalfiq9Cqkf8cIRQRHsxFaKMRiHlPu0o6viQkgzhJukzqlDMHx9wthKr54SFuR+Sl3I76XAdlRa5immrUYi1mV7KMoETQsiyQh9vlSkc8NKiCHIYtyEyGy084c7omONtysH4rVMxBlxHz3ERKkNHOMPrazLvCxUC6D6VIVZXgHscufJnGlLB8TvNxC4gSi2eUUT4l62t2t0H70a4E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b5503b-b90c-44a4-e588-08d818394cc1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 12:22:45.5601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQFE/ObOmiJAijNLN/l99l7svtyY/OYz0XkszlwYNFeu0KcTq/rsTI7bUrnVH8CrnwJ5Bmt3Eji9etuga0WuXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6629
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 24 Jun 2020 at 13:30, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 24, 2020 at 01:22:29PM +0300, Vlad Buslov wrote:
>> Hi Pablo,
>> 
>> I've encountered a new issue with indirect offloads infrastructure. The
>> issue is that on driver offload its indirect callbacks are not removed
>> from blocks and any following offloads operations on block that has such
>> callback in its offloads cb list causes call to unmapped address.
>> 
>> Steps to reproduce:
>> 
>> echo 1 >/sys/class/net/ens1f0/device/sriov_numvfs
>> echo 0000:81:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
>> devlink dev eswitch set pci/0000:81:00.0 mode switchdev
>> 
>> ip link add vxlan1 type vxlan dstport 4789 external
>> ip addr add 192.168.1.1 dev ens1f0
>> link set up dev ens1f0
>> ip link set up dev ens1f0
>> tc qdisc add dev vxlan1 ingress
>> tc filter add dev vxlan1 protocol ip ingress flower enc_src_ip 192.168.1.2 enc_dst_ip 192.168.1.1 enc_key_id 42 enc_dst_port 4789 action tunnel_key unset action mirred egress redirect dev ens1f0_0
>> tc -s filter show dev vxlan1 ingress
>> 
>> rmmod mlx5_ib
>> rmmod mlx5_core
>> tc -s filter show dev vxlan1 ingress
>
> On module removal, the representors are gone and the ->cleanup
> callback should be exercised, this callback removes the flow_block and
> removes the rules in the driver.
>
> Can you check if the ->cleanup callback is exercised?

I added some traces. On module unload mlx5e_cleanup_rep_tx() and
flow_indr_dev_unregister() are called, but not tc_block_indr_cleanup().
Maybe this is the problem that wenxu fixed in one of his patches? I'll
try to reproduce on net branch.

>
>> Resulting dmesg:
>> 
>> [  153.747853] BUG: unable to handle page fault for address: ffffffffc114cee0
>> [  153.747975] #PF: supervisor instruction fetch in kernel mode
>> [  153.748071] #PF: error_code(0x0010) - not-present page
>> [  153.748189] PGD 5b6c12067 P4D 5b6c12067 PUD 5b6c14067 PMD 35b76b067 PTE 0
>> [  153.748328] Oops: 0010 [#1] SMP KASAN PTI
>> [  153.748403] CPU: 1 PID: 1909 Comm: tc Not tainted 5.8.0-rc1+ #1170
>> [  153.748507] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
>> [  153.748638] RIP: 0010:0xffffffffc114cee0
>> [  153.748709] Code: Bad RIP value.
>> [  153.748767] RSP: 0018:ffff88834895ef00 EFLAGS: 00010246
>> [  153.748858] RAX: 0000000000000000 RBX: ffff888330a30078 RCX: ffffffffb2da70ba
>> [  153.748975] RDX: ffff888333635d80 RSI: ffff88834895efa0 RDI: 0000000000000002
>> [  153.752948] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed106614600c
>> [  153.759173] R10: ffff888330a3005f R11: ffffed106614600b R12: ffff88834895efa0
>> [  153.765419] R13: 0000000000000000 R14: ffffffffc114cee0 R15: ffff8883470efe00
>> [  153.771689] FS:  00007f6f6ac12480(0000) GS:ffff888362e40000(0000) knlGS:0000000000000000
>> [  153.777983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  153.784187] CR2: ffffffffc114ceb6 CR3: 000000035eb9e005 CR4: 00000000001606e0
>> [  153.790567] Call Trace:
>> [  153.796844]  ? tc_setup_cb_call+0xd8/0x170
>> [  153.803164]  ? fl_hw_update_stats+0x117/0x280 [cls_flower]
>> [  153.809516]  ? 0xffffffffc1328000
>> [  153.815766]  ? _find_next_bit.constprop.0+0x3e/0xf0
>> [  153.822079]  ? __nla_reserve+0x4c/0x60
> [...]
>> 
>> I can come up with something to fix mlx5 but it looks like all other
>> drivers that support indirect devices are also susceptible to similar
>> issue.
>
> How does the fix you have in mind look like?

To call flow_indr_dev_unregister() from right path. But you are right,
it is already called, so we just need to determine why it doesn't
perform the proper cleanup.

>
> Thanks.

