Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22F76A9AA0
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCCP2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCCP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:28:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2099.outbound.protection.outlook.com [40.107.220.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F7218B36;
        Fri,  3 Mar 2023 07:28:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqbWpFeOL58lUkLBgRBaZ68TTQgOuCS6rdGHGwj/pLXE0ce6P9ERwTUMLu/CUL1In56rz6Vl1K8taJQbB97wCLlq8NLAXpXTWDqutfTT8k5p4m+O/qMW/5kmLJw7Ics6JS13T2pSB+sQu/vLBXQr6ZHoBUBmScI+4H0iLh09ghVtJRkUKwFC2B3Kdl0aPM4fnok9G67B8zyLxLtIdfbZCjNNV6rpLyV+R+3WJmSY7+R9siVvo4uvMsyzec7iaoA1WRL07G5e6UhNRT2ZOqA+F6kWdUwxto/mD3vKHsSLqiDUKtcxGtGxTtPyu4B3H/BhKhAE46SEYegascQmqs+HKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sqf/ByWaQ+0Pz4koCQwYaFWxHgf0qZ6x+SAnf820p3E=;
 b=i5Appv2eukA+GIZD4X+NJIXdx9ykGPzEKzWFtKm6Ry8VaLv6Fxzc5CitJ0GCqM6D9/fzKXNI2pK9E/8W2rtm4XaYnFbXyQogGmHfYWPM5EGNxMEGmwYh2zLZFoxovy+73dQavcsNpaA6sqb3RN7FTcNUjZE97a4J90ERmh6HOHBav5FNBMjUWtrs5+cvOybOCQLIYOazJdf8cmBKBe3hn1nuyoZBkUZrcm1nTpKGAX0bvAiIjbCAV4iokYtNlI5xdzRJLI6WpaJED4juBngnBAygz84FjYUqB1+eIgta1mpqt+fTkEflV36JhpYztA7mrVj35HbexK850thgfHDQ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sqf/ByWaQ+0Pz4koCQwYaFWxHgf0qZ6x+SAnf820p3E=;
 b=Tbu1pluhIPmdzLSrtZINbQWuc0zTtUTSnjuoX6kobcWRfR0pN7kDzaeADKjcZj8UHmrUdblKApZ6gU2PWKraGpeVgLWYU/8oMUl2D3rWkBuKJe1JslzPEkakk2mHcoeNyJaGA6bsd8SlzB8TnddLqYSENG+CNAjB8Yj3BBSKr2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28; Fri, 3 Mar
 2023 15:28:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 15:28:40 +0000
Date:   Fri, 3 Mar 2023 16:28:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     syzbot <syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com>
Cc:     alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [wpan?] general protection fault in
 nl802154_trigger_scan
Message-ID: <ZAISIS/h9UV6Ox+r@corigine.com>
References: <000000000000adec0205f5ffcaf4@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000adec0205f5ffcaf4@google.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM8P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: a68eb8db-9c13-4eea-cc62-08db1bfbf719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/oU3XMrEOP3KxNtZzekdVulOW0BAZJ0qKMzklQ6YyqBEfDuZj5S0GI9OpS+Re00+WugYILC0FUz8WJ9c3b2wtdRgRN2U7LzhpIuP8GRhz6TOBmuDdc2YAp4zG18r7mYbD8NAhSIgpDadnyB5F2CAKVVcJnaJd0USK77t7dKDKhVxMDM40EVObZZAAIBda2iMVP9L8ccChlcZ/tWkhtKdW2XxKowm5/yVjeA48M+J2saAKErz9FIPSxJFzClke310PbMwnqkQ6wDbwbPVZutK56HYTslLk5pkyzIMMK5MRXDYJapyO1w9rSqeCvWdKteZEZnG4BeRIZb3r9TLSKZkX7Se9EzFq43utNhIViiZmvVFit19Ni20O6rKn8Zt3Q9hVsqB+NIX2fA6u4GesJJZldnDOSCHtLe/T8h85efinRabGfLfUd14U1W+ZqjuodlyWaO00FSe0Nam/23NiLtVufiKDmT+tCKEf9GpGmKmpHedpi9UB8T+Ekj+nSj/perK+IP60fXCLsRwM3OXsSMuL32qyzqMNLsXtmMUPljao07uIxD5rBH9uLzecw2QrP2XlEjNO0br6xMTSnFr7PgReO+O3YgNdPq/xGmyOCVJSkRX4HjL8p6g8gcWm8I1JSEIT9QIuCLF05xZRhPr+KGD6vo5VjsE+uWGybTTSD1HSaJGdM8UhCbt3VCh7WljcMmYm31OgCvUimYTrioDJynVDk8aXJglhGG6KKwqGJAKYE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39840400004)(136003)(366004)(451199018)(66476007)(5660300002)(7416002)(44832011)(36756003)(8936002)(86362001)(38100700002)(83380400001)(478600001)(6666004)(2616005)(6486002)(966005)(6512007)(186003)(6506007)(66556008)(4326008)(45080400002)(8676002)(2906002)(316002)(66946007)(41300700001)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OeuEnPfoWHaRhcaVndX8aduYhwaE0mw0t1WNGcaDNxXyxNGbdmfOF66sV/wR?=
 =?us-ascii?Q?/iUvHPuSDv/x/lw5FPYUXZpGYo3ANjBkenV3CNZ8BegJt/4JT9hK9kvPwaDl?=
 =?us-ascii?Q?ScbWjXiDnaTg9t79yTWqBt3S2x6aDrwZNL1bfOEsdFW9HMk647hqNULKUsvz?=
 =?us-ascii?Q?TZuqXSzB1vaib8n7ryLIK9jzxFFnixXvcl/aXwj1dUwr35U1CagNOtenhcR6?=
 =?us-ascii?Q?zuY6cgxix0CwxgwowvKdA5bY6KGliZunP8I+lsEmYjOo1RQIYl6znuyIvRVC?=
 =?us-ascii?Q?1cSvb3IEXcVR5OFUhJp1o3FbEVvVcPjlHH2dQqmVMrlHbaBhc/ZGBV5UydFP?=
 =?us-ascii?Q?8wYaVjtzUqKRyWGxxBFT8YdwD9IsVFsvQECn0bPVtg6/t+TL47uGXd/Hn1eV?=
 =?us-ascii?Q?7EY7mFHOL63FqrgnsfB6f5hhYaqHoCVIF3DsI4bS2Nldq6hrKBYOeIWzdCR6?=
 =?us-ascii?Q?Rgckm7TOuG0oQO0z0pMmt6iExYNv2uyOwwYOi9ObP1LiRkwirsUEyqtxZgti?=
 =?us-ascii?Q?JVYH9vOreMVT0uyN+VVcZmw+HZJtipe8EOp9opB8wgait6QqI4NrifwpubkX?=
 =?us-ascii?Q?5WLu933JhC0B1PzHpoJdirEybQmxvogHED7woBQRzDM32+yVyO4FvXQ18Et2?=
 =?us-ascii?Q?yjmM/i7XQhzvnzLk5ZTxPyPuttNMrvkU9aUePrDwHDEamTOgSyQhsF1f0klu?=
 =?us-ascii?Q?KnaDpQE6HnKQBeFCuV2O+zRj4QkxvczYdavA9cTIeVgf/0rfxXV3n8/P3HtI?=
 =?us-ascii?Q?i0yCiiBXg1VGCTMm2U6JZdZKPRvUjjxAJbfMdtCmfETDGNH2DryIPFW4ZdqT?=
 =?us-ascii?Q?6lQsonE2Oyw2Caylti7qcg4E9gV/DbnXiaPdYqz3uTO5t9LJDo5N3rrgZKG0?=
 =?us-ascii?Q?fc+S4eIlx9GpRkcXVDUfPs2EryFxU9z6Qb+qGMcJEVZPDc7o1I8+3N29zPRc?=
 =?us-ascii?Q?xEz+4PtlT0MzEVmN0zYfuxcfIr1qxwPbJk8TO8uU64135lnrqH0leSxTOnGD?=
 =?us-ascii?Q?J4YAPRR5NInQUhR8lIeWc0yPe84v0Guf8BVA+UM0ohyogCezVK/Kilcqs4Cz?=
 =?us-ascii?Q?nJpxJ1R7APsrbMeD6TmUU/FBZMzsErP69c9hKxjVIvDTnLEGpJszuIkSh6vn?=
 =?us-ascii?Q?G7sBTPLcZVhmzO+ApbsOKR/EIqd5UbeckIxu/aJI6UhjOKmK5G57Ns+Rv4b9?=
 =?us-ascii?Q?gXi9L9PhZ8FH1DQfy5DBnpdbKIQLwsbU3VZvg7Q0N8YB/awBkUn7M3z48tBW?=
 =?us-ascii?Q?lyq+l6jZX4Elfx+tBiGn4mvm+5VRqPNuw/WD2IhFz1IyvM9wwKOySOw3NVcM?=
 =?us-ascii?Q?kAd0IcYtO3IWIAI+dpYS0BSyI6Ykq3d6BH81wjK5zCLGNUABDM/lsI8Jire1?=
 =?us-ascii?Q?crXd8EiwfCUmQ8LF8rZFqrwpq70Ue8LB77Xd1CYPLij77S7nTpDSTi8cOIQl?=
 =?us-ascii?Q?uqBNrJENA1XJmgaZ3K9q/syYpK5xEfIN9htH/2PETlvMWj431fSXc0tpnoxc?=
 =?us-ascii?Q?T/sVBoV+8H1cA+mr1Fz3dCcfz2R/pMUHQPvR36f5mxZXXOBsQyRik31P/oqn?=
 =?us-ascii?Q?bswKabQ6ujhTa2U3Pt7m7SDdyY0V736Z4XaHXaUc5+3SVSirWX9UP2z57NtX?=
 =?us-ascii?Q?ATPSVUpIIzeOR9VQ9SO/zgDUU4gU6E88PpvVLbQGbVfnp0NTeBOv4I2Wje+I?=
 =?us-ascii?Q?IoC2HA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68eb8db-9c13-4eea-cc62-08db1bfbf719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 15:28:40.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXgf+ewVEEbBNIiYJ6rZIAGMYkhO2f129/ki6ZKIHq0nFkS4hCBYm9Q/1WcENX4p5RZ+5j8+AbycYX59xTYP/lJ3Zj3AaMJu61JP8eevH9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 06:30:49AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f3a2439f20d9 Merge tag 'rproc-v6.3' of git://git.kernel.or..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12df1a7f480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=81f5afa0c201c8de
> dashboard link: https://syzkaller.appspot.com/bug?extid=bd85b31816913a32e473
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1597f254c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15053e40c80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0719d575f3ac/disk-f3a2439f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4176aabb67b5/vmlinux-f3a2439f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2b0e3c0ab205/bzImage-f3a2439f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 5076 Comm: syz-executor386 Not tainted 6.2.0-syzkaller-12485-gf3a2439f20d9 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
> RIP: 0010:nla_get_u8 include/net/netlink.h:1658 [inline]
> RIP: 0010:nl802154_trigger_scan+0x132/0xc90 net/ieee802154/nl802154.c:1415
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 3f 0a 00 00 48 8b ad f8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 d0 07 00 00
> RSP: 0018:ffffc90003397568 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: ffffc900033975d8 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff89cec1a1 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff888146fb4c90
> R13: ffff888146f82000 R14: ffff888146f820a0 R15: ffffc900033975f8
> FS:  0000555556c9b300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055be8d9c04f0 CR3: 0000000023513000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:722 [inline]
>  sock_sendmsg+0xde/0x190 net/socket.c:745
>  ____sys_sendmsg+0x71c/0x900 net/socket.c:2504
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2558
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2587
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f416cc9ee69
> Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff243fe498 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f416cd17380 RCX: 00007f416cc9ee69
> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 0000000000000000 R09: 001d00000000000c
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
> R13: 0000000000000003 R14: 00007fff243fe4b7 R15: 00007fff243fe4ba
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nla_get_u8 include/net/netlink.h:1658 [inline]
> RIP: 0010:nl802154_trigger_scan+0x132/0xc90 net/ieee802154/nl802154.c:1415
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 3f 0a 00 00 48 8b ad f8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 d0 07 00 00
> RSP: 0018:ffffc90003397568 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: ffffc900033975d8 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff89cec1a1 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff888146fb4c90
> R13: ffff888146f82000 R14: ffff888146f820a0 R15: ffffc900033975f8
> FS:  0000555556c9b300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055be8d9c04f0 CR3: 0000000023513000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	48 c1 ea 03          	shr    $0x3,%rdx
>    4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
>    8:	0f 85 3f 0a 00 00    	jne    0xa4d
>    e:	48 8b ad f8 00 00 00 	mov    0xf8(%rbp),%rbp
>   15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   1c:	fc ff df
>   1f:	48 8d 7d 04          	lea    0x4(%rbp),%rdi
>   23:	48 89 fa             	mov    %rdi,%rdx
>   26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
>   2e:	48 89 fa             	mov    %rdi,%rdx
>   31:	83 e2 07             	and    $0x7,%edx
>   34:	38 d0                	cmp    %dl,%al
>   36:	7f 08                	jg     0x40
>   38:	84 c0                	test   %al,%al
>   3a:	0f 85 d0 07 00 00    	jne    0x810

I believe this is fixed here:

- [PATCH net] ieee802154: Prevent user from crashing the host
  https://lore.kernel.org/netdev/20230301154450.547716-1-miquel.raynal@bootlin.com/

- pull-request: ieee802154 for net 2023-03-02
  https://lore.kernel.org/netdev/20230302153032.1312755-1-stefan@datenfreihafen.org/
