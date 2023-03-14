Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD5A6B8A18
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCNFJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjCNFJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:09:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9882D5A910;
        Mon, 13 Mar 2023 22:09:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s17so8213825pgv.4;
        Mon, 13 Mar 2023 22:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678770588;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJwe1EkC8J3zS8Wr9IC+xL9zZ1GIIZJktIybcPhN72o=;
        b=TmbgJE70HU8Dd9gu6wAm994jqb8A93QmQvhbg5AYaMTrbW0IHRL+JT/KNmwX0/xpR0
         3+/wJnr627UZt8dwFicghcjITvtnDphsuBz7CmB8wHrHNG0AXFqnC6t2asTDLBLRC+Bu
         PezmZ6CcthSs3aJUScLLMW2QlG3vyEUJzKd1SFgj4njb5OK/wsWs3ZYeM0OUghG47Jiw
         KYXVSwRj+Y2BsW+tN6mRdf/OMWlXDqCwqd6sOLewbinS7GfbqNT5GOXVLqOi9gHT2nv/
         HuoP9RYwsautN2Rz1wySpwH1u2QE9oPerK8mVpkx9S+rvzCsS4a+MTD55chBA3mx/IV7
         Ta8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678770588;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kJwe1EkC8J3zS8Wr9IC+xL9zZ1GIIZJktIybcPhN72o=;
        b=v6iViVowmKMRbUAEax/vU5uN/Z7j3CcvHoinpuxoMGGeWPMTnjlCbFpdFre8JIJK/E
         SMLo13ErxxbgZTf+gTyeYSiWf/K2hxksALUxs7MuValo2cK1/S1ZVT9IPTXT/vVcm7Be
         tHQj+5m5rrxZUpciFO0KT7xeGN6Kjaiwwrd7ie3UT/9tOzjjS6mhNoWKm95HQyOZia07
         iB4kU+uB5XhOhc8hBwP9JeZ0MDjKXdhe6dr8WwdD30Yru76NdIn8D4v+f66GQ8XWZuGQ
         VzGp7DrAp1do4/anO8vpgMYTYIxlOVHJAsqIYzwfVGc9JZIypJt4n6Fg3+D/K0xDNmnW
         hASw==
X-Gm-Message-State: AO0yUKUqYPZ1mXqKWSc84xA6Xop9vEIanz9RL8RGnRzEtC+l9dbymSnr
        W7plFJXeD380VdaBjNDvi8CAnQhVLuk=
X-Google-Smtp-Source: AK7set8mKI5+zTeXQ0Jx2tZuCR9srHojnIsVXKy4IiVuimsx6xrFtdP0m+3jjJcMup3DyzCaE6ETWw==
X-Received: by 2002:a62:1d0b:0:b0:5df:421d:1962 with SMTP id d11-20020a621d0b000000b005df421d1962mr25570030pfd.2.1678770588027;
        Mon, 13 Mar 2023 22:09:48 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id k17-20020aa792d1000000b005a84ef49c63sm542888pfa.214.2023.03.13.22.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 22:09:47 -0700 (PDT)
Date:   Mon, 13 Mar 2023 22:09:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <64100199e8980_425812081b@john.notmuch>
In-Reply-To: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
References: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH intel-net] ice: xsk: disable txq irq before flushing hw
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> ice_qp_dis() intends to stop a given queue pair that is a target of xsk
> pool attach/detach. One of the steps is to disable interrupts on these
> queues. It currently is broken in a way that txq irq is turned off
> *after* HW flush which in turn takes no effect.
> 
> ice_qp_dis():
> -> ice_qvec_dis_irq()
> --> disable rxq irq
> --> flush hw
> -> ice_vsi_stop_tx_ring()
> -->disable txq irq
> 
> Below splat can be triggered by following steps:
> - start xdpsock WITHOUT loading xdp prog
> - run xdp_rxq_info with XDP_TX action on this interface
> - start traffic
> - terminate xdpsock
> 
> [  256.312485] BUG: kernel NULL pointer dereference, address: 0000000000000018
> [  256.319560] #PF: supervisor read access in kernel mode
> [  256.324775] #PF: error_code(0x0000) - not-present page
> [  256.329994] PGD 0 P4D 0
> [  256.332574] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  256.337006] CPU: 3 PID: 32 Comm: ksoftirqd/3 Tainted: G           OE      6.2.0-rc5+ #51
> [  256.345218] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [  256.355807] RIP: 0010:ice_clean_rx_irq_zc+0x9c/0x7d0 [ice]
> [  256.361423] Code: b7 8f 8a 00 00 00 66 39 ca 0f 84 f1 04 00 00 49 8b 47 40 4c 8b 24 d0 41 0f b7 45 04 66 25 ff 3f 66 89 04 24 0f 84 85 02 00 00 <49> 8b 44 24 18 0f b7 14 24 48 05 00 01 00 00 49 89 04 24 49 89 44
> [  256.380463] RSP: 0018:ffffc900088bfd20 EFLAGS: 00010206
> [  256.385765] RAX: 000000000000003c RBX: 0000000000000035 RCX: 000000000000067f
> [  256.393012] RDX: 0000000000000775 RSI: 0000000000000000 RDI: ffff8881deb3ac80
> [  256.400256] RBP: 000000000000003c R08: ffff889847982710 R09: 0000000000010000
> [  256.407500] R10: ffffffff82c060c0 R11: 0000000000000004 R12: 0000000000000000
> [  256.414746] R13: ffff88811165eea0 R14: ffffc9000d255000 R15: ffff888119b37600
> [  256.421990] FS:  0000000000000000(0000) GS:ffff8897e0cc0000(0000) knlGS:0000000000000000
> [  256.430207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  256.436036] CR2: 0000000000000018 CR3: 0000000005c0a006 CR4: 00000000007706e0
> [  256.443283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  256.450527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  256.457770] PKRU: 55555554
> [  256.460529] Call Trace:
> [  256.463015]  <TASK>
> [  256.465157]  ? ice_xmit_zc+0x6e/0x150 [ice]
> [  256.469437]  ice_napi_poll+0x46d/0x680 [ice]
> [  256.473815]  ? _raw_spin_unlock_irqrestore+0x1b/0x40
> [  256.478863]  __napi_poll+0x29/0x160
> [  256.482409]  net_rx_action+0x136/0x260
> [  256.486222]  __do_softirq+0xe8/0x2e5
> [  256.489853]  ? smpboot_thread_fn+0x2c/0x270
> [  256.494108]  run_ksoftirqd+0x2a/0x50
> [  256.497747]  smpboot_thread_fn+0x1c1/0x270
> [  256.501907]  ? __pfx_smpboot_thread_fn+0x10/0x10
> [  256.506594]  kthread+0xea/0x120
> [  256.509785]  ? __pfx_kthread+0x10/0x10
> [  256.513597]  ret_from_fork+0x29/0x50
> [  256.517238]  </TASK>
> 
> In fact, irqs were not disabled and napi managed to be scheduled and run
> while xsk_pool pointer was still valid, but SW ring of xdp_buff pointers
> was already freed.
> 
> To fix this, call ice_qvec_dis_irq() after ice_vsi_stop_tx_ring(). Also
> while at it, remove redundant ice_clean_rx_ring() call - this is handled
> in ice_qp_clean_rings().
> 
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Looks reasonable to me for what its worth.

Acked-by: John Fastabend <john.fastabend@gmail.com>
