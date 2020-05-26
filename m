Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF23D1E2B67
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391421AbgEZTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391413AbgEZTEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 15:04:48 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA541C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:04:47 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b6so21746562qkh.11
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wm9NBJ18IEAnXEz3WPyQh3gi/oLSar76LNhWKDBk3rg=;
        b=Le06XNdC42SAXGojZUcsQ5EiSyA4ouzCbEjUYBE5pKaCIPqfX8wL5TdHVAPQ9Gv0sQ
         rPX89baDlSGqOC3Gs3AFrF7eaqR6VEINE2Drsze7XbEPDrxS1mez1HsUh7fYmcGKv0gF
         d+1A7Xdv/yJak+GYzNnI9AlIRMnvR1dm/Lutm+5q35Xz8OYi1YW1oLoLDNUEs6h9qaeW
         8+50SNTDufg/i8mIOEyIOOyxFsURUXKagk341ewf3veQ8fvwWRmNLkoYV61t6Qy7HC9J
         9cBb1A7HxcikrDfbo5l9MQNg3xZZQwqdDoIAmr3bL+7WTREWy3zqh+6I2nRpFrAyTYWP
         oF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wm9NBJ18IEAnXEz3WPyQh3gi/oLSar76LNhWKDBk3rg=;
        b=d7NjVzWPp7XymS4mh9QHDFf62M7teNIzrAImzy+zl60VDdvaVmBL/EXKHk1VxFq7BC
         MdNJa1KEuX41OidmbydlxsH8xEMGWY5bYB3nV8ZxQlJAOmhkmsMh4dTcehw1Bbdq5PJi
         aMvmELPgXXpQoz8K5u1W7v+/aUWVKHUMjMnRwhmlMyNBA2ZE+7/NXa47Uu5hZv4EvF+Q
         XtLuVAJ9eev+JAT1itigieINCDdwBJr+4gVyNuXGAdgYR1X8QS5c2A3oR7843Zx7xRrg
         XGD+vHyIrr2PJ9JO4GftkXXmz6rKonf/ZNTue8wHM5JMsk6wzz1FXN/2gYszjowUlaao
         3hTQ==
X-Gm-Message-State: AOAM5323lRZutt1o+4TerTgAH0Iq42znUfnEP0x43wZjdFxLCknk9xwV
        M84l8u6IwGlMma6sfpe3Yf7NbEsg
X-Google-Smtp-Source: ABdhPJwlhDe06mHWs0zDi2nTvsyjmFHXklh20NbnwhcS0MWYmZbBhsEPqKdrmEzjlSeltGcwtZjQyw==
X-Received: by 2002:a37:72c7:: with SMTP id n190mr316416qkc.270.1590519887093;
        Tue, 26 May 2020 12:04:47 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id r138sm406965qka.56.2020.05.26.12.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 12:04:46 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Subject: bpf-next/net-next: panic using bpf_xdp_adjust_head
Message-ID: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
Date:   Tue, 26 May 2020 13:04:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf-next and net-next are panicing when a bpf program uses adjust_head -
e.g., popping a vlan header.

[ 7269.886684] BUG: kernel NULL pointer dereference, address:
0000000000000004
[ 7269.893676] #PF: supervisor read access in kernel mode
[ 7269.898821] #PF: error_code(0x0000) - not-present page
[ 7269.903970] PGD 0 P4D 0
[ 7269.906516] Oops: 0000 [#1] SMP PTI
[ 7269.910021] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G
      I       5.7.0-rc6+ #221
[ 7269.919076] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS
1.6.12 11/20/2018
[ 7269.926661] RIP: 0010:__memmove+0x24/0x1a0
[ 7269.930766] Code: cc cc cc cc cc cc 48 89 f8 48 39 fe 7d 0f 49 89 f0
49 01 d0 49 39 f8 0f 8f a9 00 00 00 48 83 fa 20 0f 82 f5 00 00 00 48 89
d1 <f3> a4 c3 48 81 fa a8 02 00 00 72 05 40 38 fe 74 3b 48 83 ea 20 48
[ 7269.949548] RSP: 0018:ffff9c09cca04c68 EFLAGS: 00010282
[ 7269.954781] RAX: 0000000000000008 RBX: ffff9c09cca04d78 RCX:
ffff8bfc475a20fc
[ 7269.961927] RDX: ffff8bfc475a20fc RSI: 0000000000000004 RDI:
0000000000000008
[ 7269.969068] RBP: ffff8bfc475a2104 R08: ffff8bfc475a2100 R09:
ffff8bfc475a211c
[ 7269.976229] R10: 0000000000000012 R11: 0000000000000008 R12:
0000000000000004
[ 7269.983376] R13: ffff9c09cc9f57b8 R14: ffff8bfc475a2100 R15:
0000000000000008
[ 7269.990518] FS:  0000000000000000(0000) GS:ffff8c011f240000(0000)
knlGS:0000000000000000
[ 7269.998623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7270.004381] CR2: 0000000000000004 CR3: 0000001a72a0a004 CR4:
00000000007626e0
[ 7270.011523] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 7270.018682] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 7270.025824] PKRU: 55555554
[ 7270.028539] Call Trace:
[ 7270.030990]  <IRQ>
[ 7270.033014]  bpf_xdp_adjust_head+0x68/0x80
[ 7270.037126]  bpf_prog_7d719f00afcf8e6c_xdp_l2fwd_prog+0x198/0xa10
[ 7270.043284]  mlx5e_xdp_handle+0x55/0x500 [mlx5_core]
[ 7270.048277]  mlx5e_skb_from_cqe_linear+0xf0/0x1b0 [mlx5_core]
[ 7270.054053]  mlx5e_handle_rx_cqe+0x64/0x140 [mlx5_core]
[ 7270.059297]  mlx5e_poll_rx_cq+0x8c8/0xa30 [mlx5_core]
[ 7270.064373]  mlx5e_napi_poll+0xdc/0x6a0 [mlx5_core]
[ 7270.069260]  net_rx_action+0x13d/0x3d0
[ 7270.073020]  __do_softirq+0xdd/0x2d0


git bisect chased it to
  13209a8f7304 ("Merge
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

but that brings in a LOT of changes. Anyone have ideas on recent changes
that could be the root cause?
