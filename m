Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6745564E4D
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfGJWDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:03:43 -0400
Received: from mail.us.es ([193.147.175.20]:42716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfGJWDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 18:03:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE967819A2
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:03:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D4C9DA4D0
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:03:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91E87DA704; Thu, 11 Jul 2019 00:03:40 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87861DA732;
        Thu, 11 Jul 2019 00:03:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jul 2019 00:03:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.194.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 603C34265A31;
        Thu, 11 Jul 2019 00:03:38 +0200 (CEST)
Date:   Thu, 11 Jul 2019 00:03:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: Fix kernel NULL pointer dereference
Message-ID: <20190710220337.tbflwdku4332ewo5@salvia>
References: <1562766304-20272-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562766304-20272-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 09:45:04PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> [  697.665184] BUG: kernel NULL pointer dereference, address: 0000000000000030
> [  697.665550] #PF: supervisor read access in kernel mode
> [  697.665906] #PF: error_code(0x0000) - not-present page
> [  697.666297] PGD 800000104e636067 P4D 800000104e636067 PUD ff4b02067 PMD 0
> [  697.666710] Oops: 0000 [#1] SMP PTI
> [  697.667115] CPU: 31 PID: 24466 Comm: modprobe Kdump: loaded Tainted: G           O      5.2.0-rc6+ #1
> [  697.667867] Hardware name: Huawei Technologies Co., Ltd. RH1288 V3/BC11HGSC0, BIOS 3.57 02/26/2017
> [  697.668620] RIP: 0010:tc_indr_block_ing_cmd.isra.52+0x4c/0xb0
> [  697.669029] Code: 83 ec 40 65 48 8b 04 25 28 00 00 00 48 89 45 e8 31 c0 f3 48 ab 48 8b 06 49 8b b3 e8 04 00 00 44 89 45 b0 c7 45 b4 01 00 00 00 <8b> 48 30 48 89 75 c0 85 c9 48 8d 4d b0 0f 95 45 b8 48 85 c0 4c 8d
> [  697.670132] RSP: 0018:ffffc90007bf7958 EFLAGS: 00010246
> [  697.670537] RAX: 0000000000000000 RBX: ffff88905e2cbae8 RCX: 0000000000000000
> [  697.670938] RDX: ffff88905e2cbcd8 RSI: ffffffff823a8480 RDI: ffffc90007bf7990
> [  697.671352] RBP: ffffc90007bf79a8 R08: 0000000000000000 R09: ffff88905e2cbcc0
> [  697.671761] R10: ffff888107c07780 R11: ffff88902c249000 R12: ffff88905e2cbcd0
> [  697.672173] R13: ffff88905e2cbac0 R14: ffff88885596bc00 R15: ffff88905e2cbcc0
> [  697.672582] FS:  00007fe0b4095740(0000) GS:ffff88905fbc0000(0000) knlGS:0000000000000000
> [  697.673335] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  697.673746] CR2: 0000000000000030 CR3: 0000000ff46b4005 CR4: 00000000001606e0
> [  697.674156] Call Trace:
> [  697.674563]  __tc_indr_block_cb_register+0x11e/0x3c0
> [  697.674998]  mlx5e_nic_rep_netdevice_event+0x9e/0x110 [mlx5_core]
> [  697.675411]  notifier_call_chain+0x53/0xa0
> [  697.675812]  raw_notifier_call_chain+0x16/0x20
> [  697.676223]  call_netdevice_notifiers_info+0x2d/0x60
> [  697.676633]  register_netdevice+0x3fa/0x500
> 
> get indr_dev->block after check it.
> 
> Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
