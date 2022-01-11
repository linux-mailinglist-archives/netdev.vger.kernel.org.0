Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6370D48A5FA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiAKDBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiAKDBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:01:14 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AAFC06173F;
        Mon, 10 Jan 2022 19:01:14 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id h14so26102481ybe.12;
        Mon, 10 Jan 2022 19:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MWvcAvXFOF/Z8QQUHp2bmP40nPXieQHtuAf08iJH6U8=;
        b=Ygv8h6i2/BRZHQOOUaST9LF3sjvhvBjSsxOidbDpbYYZ2qXItEwGd5CtwxfJP8M4pr
         VV9y6cJNqdqChts0GCDEtHIo4Et2gOKpQ2IJ1hOVDWahZqXkt/Brt9ZXDqkupMTlQM17
         D1tBfvuo410zCVwA4Q+cp0pGHsC3ACHpB1A1N0nNDeO+cUEjDwmJhNZCz+7N3k8ma8Zg
         +RWw3e+K93kdje75UlnLEgN1n3F0z2xbPU1vQ0or+UZqdwyohmLaEgyHUf2AWsm//IfY
         0J/NyWg4hwArqqdCJqvXqwpI9x/onQNTkR2quL6QaoCIGAQ6dPg0wE3oy2ChdSUi0z8T
         vFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MWvcAvXFOF/Z8QQUHp2bmP40nPXieQHtuAf08iJH6U8=;
        b=IiK+GHq8umJXAZoXXE0UPlAx7I5DQU0dCJJIOrlXJYSNf1Dw7bPpz6QrBRwqHmUQRY
         1NqyNdRZZPTsKA2yzpOll3zHb0oQhCyRjB4OlMdFDV8kxnNnWfJdhI+MgZEF2mIOHgNw
         k7WNmzZ0xQfUGV+UiZ3odoVMRG7KsDARref/LHVQXPFpKCj0wsqBuE/yE8ApxH64NEFt
         dTvuiLs2TDNjWGZwJfV1GnM13odmslxpq1gRozFti4hedzDstbehOsbELiL8WpA1UYkq
         nFwApKLdG4wZUSupZNQiJZMhif0yNy3HV9TqwgAevI/dOyAiSNag81qqpLM8Cp3GK041
         isww==
X-Gm-Message-State: AOAM530+ikpJtYfCnfDvVFQh1j2BgXfS17qB8B0p49NYwWX1kkYTRmcn
        R/H34pAASjYKWG+OdYHslQIARdq6nZApH23kGwjbmUTDDTgqaGhE5Rw=
X-Google-Smtp-Source: ABdhPJzb89UvH8xmUGtFFAYjnuqiogDNOsac6Hev3lNTOBkPEYuaxHU+CHegsrS+ixre/iUmjyFZmxqkVSRT/lBD8qY=
X-Received: by 2002:a25:4aca:: with SMTP id x193mr3559114yba.149.1641870073630;
 Mon, 10 Jan 2022 19:01:13 -0800 (PST)
MIME-Version: 1.0
From:   cruise k <cruise4k@gmail.com>
Date:   Tue, 11 Jan 2022 11:01:03 +0800
Message-ID: <CAKcFiNDyPSx_M9HJNhDJd0Omq4JFLXNjDR_9bxaSjvmPc2bXxQ@mail.gmail.com>
Subject: INFO: task hung in nl802154_pre_doit
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Syzkaller found the following issue:

HEAD commit: 75acfdb Linux 5.16-rc8
git tree: upstream
console output: https://pastebin.com/raw/AzAMX5zz
kernel config: https://pastebin.com/raw/XsnKfdRt

And hope the report log can help you.

[ 1251.721354][   T59] INFO: task syz-executor.0:2134 blocked for more
than 143 seconds.
[ 1251.722724][   T59]       Not tainted 5.16.0-rc8+ #10
[ 1251.723664][   T59] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1251.725148][   T59] task:syz-executor.0  state:D stack:27536 pid:
2134 ppid: 13069 flags:0x00000004
[ 1251.726742][   T59] Call Trace:
[ 1251.727272][   T59]  <TASK>
[ 1251.727788][   T59]  __schedule+0xcd9/0x2550
[ 1251.728512][   T59]  ? io_schedule_timeout+0x150/0x150
[ 1251.731002][   T59]  schedule+0xd2/0x260
[ 1251.731762][   T59]  schedule_preempt_disabled+0xf/0x20
[ 1251.732627][   T59]  __mutex_lock+0xc48/0x1610
[ 1251.733367][   T59]  ? nl802154_pre_doit+0x645/0xd30
[ 1251.734194][   T59]  ? mutex_lock_io_nested+0x1410/0x1410
[ 1251.735387][   T59]  ? __nla_validate_parse+0x2df/0x2400
[ 1251.736727][   T59]  ? nla_get_range_signed+0x520/0x520
[ 1251.737977][   T59]  ? rcu_read_lock_sched_held+0x9c/0xd0
[ 1254.756569][ T3364] lowmem_reserve[]: 0 0 852 852 852
[ 1254.757520][ T3364] Node 1 Normal free:36116kB boost:0kB
min:24292kB low:30364kB high:36436kB reserved_highatomic:12288KB
active_anon:15552kB inactive_anon:191888kB active_file:0kB
inactive_file:56kB unevictable:1536kB writepending:0kB
present:1048576kB managed:872480kB mlocked:0kB bounce:0kB
free_pcp:4952kB local_pcp:776kB free_cma:0kB
[ 1254.852260][ T2256] Node 0 DMA free:6572kB boost:2048kB min:2472kB
low:2576kB high:2680kB reserved_highatomic:0KB active_anon:12kB
inactive_anon:4636kB active_file:0kB inactive_file:0kB unevictable:0kB
writepending:0kB present:15992kB managed:15360kB mlocked:0kB
bounce:0kB free_pcp:8kB local_pcp:8kB free_cma:0kB
[ 1254.856691][ T2256] lowmem_reserve[]: 0 1333 1333 1333 1333
[ 1254.857666][ T2256] Node 0 DMA32 free:98544kB boost:85540kB
min:123560kB low:133064kB high:142568kB reserved_highatomic:16384KB
active_anon:10888kB inactive_anon:467648kB active_file:4kB
inactive_file:1424kB unevictable:1536kB writepending:0kB
present:2080768kB managed:1372868kB mlocked:0kB bounce:0kB
free_pcp:4416kB local_pcp:316kB free_cma:0kB
[ 1255.151925][   T59]  ? nl802154_pre_doit+0x645/0xd30
[ 1255.152819][   T59]  ? rtnl_lock+0x5/0x20
[ 1255.153500][   T59]  nl802154_pre_doit+0x645/0xd30
[ 1255.154329][   T59]  ? __nla_parse+0x3d/0x50
[ 1255.155330][   T59]  ? nl802154_dump_llsec_dev+0xba0/0xba0
[ 1255.156224][   T59]  ? write_comp_data+0x1c/0x70
[ 1255.157031][   T59]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[ 1255.158010][   T59]  ? genl_family_rcv_msg_attrs_parse.isra.0+0x1ae/0x280
[ 1255.159174][   T59]  ? nl802154_dump_llsec_dev+0xba0/0xba0
[ 1258.792471][ T1340] ieee802154 phy1 wpan1: encryption failed: -22
[ 1258.882579][ T3364] lowmem_reserve[]: 0 0 0 0 0
[ 1260.285180][   T59]  genl_family_rcv_msg_doit.isra.0+0x1e4/0x330
[ 1260.286249][   T59]  ? genl_start+0x670/0x670
[ 1260.287076][   T59]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[ 1260.287968][   T59]  ? __radix_tree_lookup+0x21b/0x2b0
[ 1260.288832][   T59]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[ 1260.997983][ T2256] lowmem_reserve[]: 0 0 0 0 0
[ 1260.998899][ T2256] Node 1 DMA32 free:21864kB boost:0kB min:27368kB
low:34208kB high:41048kB reserved_highatomic:0KB active_anon:0kB
inactive_anon:66040kB active_file:80kB inactive_file:0kB
unevictable:0kB writepending:0kB present:1048444kB managed:982908kB
mlocked:0kB bounce:0kB free_pcp:4064kB local_pcp:1984kB free_cma:0kB
