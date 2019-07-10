Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B798064E92
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfGJWFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:05:03 -0400
Received: from mail.us.es ([193.147.175.20]:42980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbfGJWFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 18:05:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7AE3819A5
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:05:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6B6BDA4D1
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:05:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ABC58DA801; Thu, 11 Jul 2019 00:05:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A164FDA732;
        Thu, 11 Jul 2019 00:04:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jul 2019 00:04:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.194.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 743664265A31;
        Thu, 11 Jul 2019 00:04:58 +0200 (CEST)
Date:   Thu, 11 Jul 2019 00:04:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] net/mlx5e: Fix kernel NULL pointer dereference
Message-ID: <20190710220457.p53fmuza3x7s3tel@salvia>
References: <1562768310-20468-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562768310-20468-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 10:18:30PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> [ 3444.666552] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [ 3444.666631] #PF: supervisor read access in kernel mode
> [ 3444.666701] #PF: error_code(0x0000) - not-present page
> [ 3444.666769] PGD 8000000812dd7067 P4D 8000000812dd7067 PUD 8207cc067 PMD 0
> [ 3444.666843] Oops: 0000 [#1] SMP PTI
> [ 3444.666910] CPU: 17 PID: 27387 Comm: nft Kdump: loaded Tainted: G           O      5.2.0-rc6+ #1
> [ 3444.666987] Hardware name: Huawei Technologies Co., Ltd. RH1288 V3/BC11HGSC0, BIOS 3.57 02/26/2017
> [ 3444.667071] RIP: 0010:flow_block_cb_setup_simple+0x127/0x240
> [ 3444.667141] Code: 02 48 89 43 08 31 c0 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 83 c4 10 b8 a1 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <49> 8b 04 24 49 39 c4 75 0a eb 2f 48 8b 00 49 39 c4 74 27 4c 3b 68
> [ 3444.668201] RSP: 0018:ffffc90007b7b888 EFLAGS: 00010246
> [ 3444.668595] RAX: 0000000000000000 RBX: ffff8890439a9b40 RCX: ffff88904d5008c0
> [ 3444.668992] RDX: ffffffffa0879850 RSI: 0000000000000000 RDI: ffffc90007b7b908
> [ 3444.669389] RBP: ffffc90007b7b8c0 R08: ffff88904d5008c0 R09: 0000000000000001
> [ 3444.669787] R10: ffff88885a797d00 R11: ffff8890439a9b00 R12: 0000000000000000
> [ 3444.670186] R13: ffffffffa0879850 R14: ffffc90007b7b908 R15: ffffffff823a8480
> [ 3444.670588] FS:  00007f357c2fa740(0000) GS:ffff88885fe40000(0000) knlGS:0000000000000000
> [ 3444.671313] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3444.671705] CR2: 0000000000000000 CR3: 00000001a1600002 CR4: 00000000001626e0
> [ 3444.672103] Call Trace:
> [ 3444.672505]  ? jump_label_update+0x5f/0xc0
> [ 3444.672933]  mlx5e_rep_setup_tc+0x32/0x40 [mlx5_core]
> [ 3444.673335]  nft_flow_offload_chain+0xd0/0x1d0 [nf_tables]
> [ 3444.673729]  nft_flow_rule_offload_commit+0x91/0x11b [nf_tables]
> [ 3444.674129]  nf_tables_commit+0x90/0xe30 [nf_tables]
> [ 3444.674529]  nfnetlink_rcv_batch+0x3b9/0x750 [nfnetlink]
> 
> Init the driver_block_list parameter
> 
> Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
