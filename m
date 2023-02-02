Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90E3688A7F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 00:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjBBXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 18:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBBXKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 18:10:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEEF7E072;
        Thu,  2 Feb 2023 15:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yn1HJ/n0g2L7P6E/0+wQC9ReIPEE30y4Osbt0PVzUzrven4PS0/NVsyxiVzdrWTS2G8b1D9gIk5Rjt2eZynl1jrtYipKsb/LMAJuOeBR7l5oEfbbQ+uZ3vSbzoHLmRwc4LYL5cWIEX8pKpnEKQkvjtYgSf12beSqW3Rw5FeMeHVRUig5PNtIo1HtYCg+Xv5ujJlplUo0J9GNttjJI1q8DX07p67cloSsfsF46ZftxcFqvMNgvUOmRurUJKOQr6OHGvWjGjifDQnFEshNYFR4vCB6EP/lLe8FoYA11wd6CKyCJB/67TWCmvqzOVvCRRmqBGUOQDaNj1bfr0WnBJ6juw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tr2Ebzf1DRZmEpW8tFadmDos1lad6Am+wKvd3NzT8r0=;
 b=mfLYXmAHa6HNq18aU7nBQ9NVU3sGQw+V+r0e6IgwXmbODh8GzKqvR6OL1i//+AX/8RdCLZwXCrBZdYJFY9xn6fPM24DWJpQCIGcMI3wuLEk09MB8wV/CZhN5SR7hvu5B77SXnwqUJvYonr9jYS6UP6/XX//CKYcVbldT2kJNIQV1qBbEeNuC/k6dtUIraZkmFfdo05RwJyQ1+qgKYIHSPfTfrKp4fIKFMXDR3t3/FhS7KA4Ynv1mdeyQqGREs+pLWQZjZzXlqkGw+nwtJhOByx4MM4vESXkrqJqgYw300fUfmDCAVmfJq+e4upyilJjP2hb4y/8gBatyWPvrF6Z7xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tr2Ebzf1DRZmEpW8tFadmDos1lad6Am+wKvd3NzT8r0=;
 b=CiCiTU1utKHQqVYMmaj1rCnCwfcon7zLqCyWOTO2fTDkEN9i6xpRuPaMfVZH0QckysKWTDZvvmvPIEugOvP7utwQZ/X+7w1m4xXeB7VAoTwtnsY5ghI8WBh6ynUiw6M+YInAVjgbkT2AmMEr1dufssIv8tz5gytB8IjZwERnqnU0Qf27MQodoIvjGZ5TSiGsbuXTN+NRCjZi3i88Wv4N0B1b3yO+6lhHbOsjtQyyKYtdEd71fN5E3GUrochBsrNKWsAWjiRqqJTuflIXcleUKzpkq4Pn3lIe+IW3euyM9S9USkL2rffdlhxXJ+CzD6vuAmGPFTJTzGzuAirTqw0DQw==
Received: from DS7PR03CA0024.namprd03.prod.outlook.com (2603:10b6:5:3b8::29)
 by SA1PR12MB6822.namprd12.prod.outlook.com (2603:10b6:806:25d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 23:10:22 +0000
Received: from DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::7c) by DS7PR03CA0024.outlook.office365.com
 (2603:10b6:5:3b8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Thu, 2 Feb 2023 23:10:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT094.mail.protection.outlook.com (10.13.172.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 23:10:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 15:10:11 -0800
Received: from [10.110.48.28] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 15:10:10 -0800
Message-ID: <1d8a8b32-920c-2c25-a530-c316c05adaea@nvidia.com>
Date:   Thu, 2 Feb 2023 15:10:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@redhat.com>
CC:     syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <hch@lst.de>,
        <johannes@sipsolutions.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller-bugs@googlegroups.com>
References: <000000000000b0b3c005f3a09383@google.com>
 <822863.1675327935@warthog.procyon.org.uk>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <822863.1675327935@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT094:EE_|SA1PR12MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c596f6-8bbd-454b-e1fd-08db0572a926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZRrvyFHKMgIgjkhRhF9RnH5FgF8iX+Av65aX/qIZSnajL/4tFT5QOGEEvwvjrxfm8WNTfy+du1hDUBPDW5j4ZP8Az4ki2tSg6mD9XojHlcbZdD6faxhPqDXC0m+4YiKer2pxKpcIrxjE6dKd0M3lTaDnZh6oKMrOKJhEFATMa9oqlZzNRT80rr6NVndjeaqHfcHs0NGN7U7osy/sd3cBy5Ce73AkFss2hJE5tSjZCabA7F5p/x9wVPvYNYM2JU7YGX4VZugsvHgrwxF5xR7oyNMrsWgX3qkubdCueuyZH3mGIBXpG9hlniTu/039+O9V8Oi2jTuHLZdJP5p3l8/Hv5Qcv1TJ+2R6CYdK0zBJYWGHcAvmU5K6snTlOWBSC5RlwpjesO/vAn233mH1O7dUj4ahSL3kxLS4+76QAERMUEqTeCCzUM7KZhERxIysF9/5wzavRt+6b77Lt8T1LlL+B74PS7aDbpvnhNEFvjuucNoWdEsBM2PN+0wNQo4Ipmyx4t/C4/iqgVkeG3zOCga1otin0pjkAptid7NFSGy94J0F+m+dBVUYh6hQmfbVCTU1/LjLwKydKVGQKpMtxQfXLzqVHMWgipPnCsYKkyo0aSPDxLmqo7ZGulrVWuT6PUS11+Ycx+v7oHb31/ys3LRxLfWlztQeszpcWrlDKKjXme9DEGwPcH08FH1iFdGrI9hili09UmG4/qgDtnvQ3UCWhG27dL2ZlnG07W5FZB9mX0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(41300700001)(4326008)(31686004)(70206006)(70586007)(83380400001)(8676002)(316002)(16576012)(426003)(8936002)(36756003)(16526019)(7416002)(54906003)(186003)(47076005)(26005)(356005)(36860700001)(2906002)(40480700001)(5660300002)(40460700003)(110136005)(478600001)(53546011)(7636003)(82740400003)(82310400005)(336012)(31696002)(86362001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 23:10:22.3959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c596f6-8bbd-454b-e1fd-08db0572a926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6822
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 00:52, David Howells wrote:
> Hi John, David,
> 
> Could you have a look at this?

Sure. So far, I have reproduced a crash using your simplified test
program (it required three simulaneous running copies), and will look
deeper now.

In case it illuminates anything, the crash looked like this (below), and
was obtained *without* setting KASAN. Also a minor point: this is from a
git branch of the last commit in the series (commit fd20d0c1852e "block:
convert bio_map_user_iov to use iov_iter_extract_pages"), rather than
from top of linux-next.

Kernel panic - not syncing: corrupted stack end detected inside scheduler
CPU: 2 PID: 27177 Comm: syzbot_howells Not tainted 6.2.0-rc5-hubbard-github+ #3
Hardware name: ASUS X299-A/PRIME X299-A, BIOS 1503 08/03/2018
Call Trace:
  <TASK>
  dump_stack_lvl+0x4c/0x63
  panic+0x113/0x2c4
  ? folio_wait_bit_common+0xf6/0x360
  __schedule+0xd1b/0xd20
  schedule+0x5d/0xe0
  io_schedule+0x42/0x70
  folio_wait_bit_common+0x123/0x360
  ? __pfx_wake_page_function+0x10/0x10
  folio_wait_writeback+0x24/0x100
  __filemap_fdatawait_range+0x7a/0x120
  ? filemap_fdatawrite_wbc+0x69/0x80
  ? __filemap_fdatawrite_range+0x58/0x80
  filemap_write_and_wait_range+0x84/0xb0
  __iomap_dio_rw+0x183/0x830
  ? __lock_acquire+0x3b4/0x2620
  iomap_dio_rw+0xe/0x40
  ext4_file_read_iter+0x141/0x1c0
  generic_file_splice_read+0x90/0x160
  splice_direct_to_actor+0xb1/0x210
  ? __pfx_direct_splice_actor+0x10/0x10
  do_splice_direct+0x8c/0xd0
  do_sendfile+0x352/0x600
  do_syscall_64+0x37/0x90
  entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f322d5116be
Code: c3 0f 1f 00 4c 89 d2 4c 89 c6 e9 fd fd ff ff 0f 1f 44 00 00 31 c0 c3 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 28 00 00 00 0f 05 <48> 3d 01 f0 ff ff8
RSP: 002b:00007ffd8c914538 EFLAGS: 00000202 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ffd8c914678 RCX: 00007f322d5116be
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000001 R09: 00007f322d7f6740
R10: 000000000001dd00 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffd8c914690 R14: 0000558a11e29d78 R15: 00007f322d843020
  </TASK>

thanks,
-- 
John Hubbard
NVIDIA
