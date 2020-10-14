Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DB928DD7B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbgJNJYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730688AbgJNJUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:20:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035B0C05110B
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 23:50:14 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id y16so3923248ila.7
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 23:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4ElDEesyg0K0qnDmN25EoqLVZHDvVGnEe9oIGE+GbpY=;
        b=yGsJGrunBc8kcDsuG6rQsb9Gi1UWyLuGHPMOjfNqcJYM8NYjLqrxTBD9axJuRe18zU
         HQkqtoT0925++y4wEzZBq13ntiRfp+ztZ0mDXnUdL/DvJhCreJEXfAa182D+qe97LEkO
         irPKkX4zfBbl1xcfW5PpBAR52e4Oxl4tjn5J3Yh3jn1ITYtzYpjqrPFLqodqCN8XfrUk
         dLs6vZPItghAdRarI9xQ1Cxs2V5c5nxJNBgLLgZBspfGmq2VhatarOyYFOVd0EAD4080
         lhCt/ii1JOENmaqe3S7tG0tp2S0XruPJjXdxCV4VttS68y59UWFitMvHdujhyBd/saDj
         eSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4ElDEesyg0K0qnDmN25EoqLVZHDvVGnEe9oIGE+GbpY=;
        b=Z2Ye4a4rl3xi2ndZHnHxNagtyz0ei40MnWYXn0iE1elD3fqQxdEqQ89KokgSQn6MXG
         tXtxjv38p/unsJq4DGi5u1Fv5ssyAo2Q80vvkAhjto7hoguFzG3+aTllsudCAQUCGSLx
         kAfzJJi43yBlZAx8iDcoaF0PnwszdMGeqpdBDhDOCHdOssTWJ1g7iHNstvbyeZD8ktwN
         ZUfwzHYrCnf7erssjKLpdsjkJAu1MjFoepx3bbijn5yzmV8BWvpfwgwEzdwkag4WtP6d
         T8f6FR79U9lPcOQNW5K8kvhkGkgHtyBy2zdTOs3h6ZrrzBIPZ2rpIDh5Ytj5ZUXsPIFF
         gyrw==
X-Gm-Message-State: AOAM530wEi395WU+uH2gb7QBEvBhvD0bnxlHhivZm+1QQwhQjfgZD9DL
        gvKvxvxY+IT6q0sROzuomievwT1+7EQojn9Wlc9KSQ==
X-Google-Smtp-Source: ABdhPJwp3I8FXlHDe3+yUeiJIWIJmB6SHTRFkbQNvXxGizAU1lL1FALkkQgXS5sL9C/VXtC/MPUiLkp0WUpyy1PrrpA=
X-Received: by 2002:a05:6e02:5ad:: with SMTP id k13mr1306184ils.71.1602658213139;
 Tue, 13 Oct 2020 23:50:13 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Oct 2020 12:20:00 +0530
Message-ID: <CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com>
Subject: WARNING: at net/netfilter/nf_tables_api.c:622 lockdep_nfnl_nft_mutex_not_held+0x28/0x38
 [nf_tables]
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, Florian Westphal <fw@strlen.de>,
        fabf@skynet.be, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftest netfilter on arm64 hikey device on Linux next
20201013 the following
kernel warning noticed.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: f2fb1afc57304f9dd68c20a08270e287470af2eb
  git describe: next-20201013
  make_kernelversion: 5.9.0
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-next/879/config

steps to reproduce:
---------------------------
# cd /opt/kselftests/default-in-kernel/
# ./run_kselftest.sh -c netfilter

crash log:
----------------
# selftests: netfilter: nft_trans_stress.sh
[ 1913.862919] ------------[ cut here ]------------
[ 1913.869773] WARNING: CPU: 2 PID: 31416 at
/usr/src/kernel/net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
[ 1913.885399] Modules linked in: nf_tables nfnetlink act_mirred
cls_u32 sch_etf xt_conntrack nf_conntrack nf_defrag_ipv4 libcrc32c
ip6_tables nf_defrag_ipv6 ip_tables x_tables netdevsim 8021q garp mrp
bridge stp llc sch_fq sch_ingress veth algif_hash wl18xx wlcore
mac80211 cfg80211 snd_soc_hdmi_codec hci_uart btqca btbcm crct10dif_ce
snd_soc_audio_graph_card snd_soc_simple_card_utils adv7511 wlcore_sdio
cec bluetooth kirin_drm lima rfkill dw_drm_dsi gpu_sched
drm_kms_helper drm fuse [last unloaded: test_blackhole_dev]
[ 1913.941924] CPU: 2 PID: 31416 Comm: nft Tainted: G        W
5.9.0-next-20201013 #1
[ 1913.954131] Hardware name: HiKey Development Board (DT)
[ 1913.963342] pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
[ 1913.973483] pc : lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
[ 1913.984271] lr : lockdep_nfnl_nft_mutex_not_held+0x18/0x38 [nf_tables]
[ 1913.995018] sp : ffff800013bc3550
[ 1914.002559] x29: ffff800013bc3550 x28: ffff800013bc3930
[ 1914.012197] x27: 0000000000000001 x26: ffff000045dc4e00
[ 1914.021880] x25: 0000000000000001 x24: ffff000045dc4e00
[ 1914.031565] x23: ffff800013bc3930 x22: 0000000000000001
[ 1914.041298] x21: ffff800012750000 x20: ffff800013bc3668
[ 1914.051068] x19: ffff800012750000 x18: 0000000000000000
[ 1914.060876] x17: 0000000000000000 x16: 0000000000000000
[ 1914.070699] x15: 0000000000000000 x14: ffff800009996d48
[ 1914.080534] x13: ffffffffff000000 x12: 0000000000000028
[ 1914.090418] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f
[ 1914.100355] x9 : fefefefefefefeff x8 : 7f7f7f7f7f7f7f7f
[ 1914.110325] x7 : fefeff53544f4d48 x6 : 0000000000007ab8
[ 1914.120339] x5 : 0000000000000005 x4 : 0000000000000001
[ 1914.130388] x3 : 0000000000000001 x2 : 0000000000000000
[ 1914.140454] x1 : 00000000ffffffff x0 : 0000000000000001
[ 1914.150529] Call trace:
[ 1914.157789]  lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
[ 1914.168967]  nft_chain_parse_hook+0x58/0x320 [nf_tables]
[ 1914.179342]  nf_tables_addchain.isra.66+0xb8/0x510 [nf_tables]
[ 1914.190340]  nf_tables_newchain+0x408/0x618 [nf_tables]
[ 1914.200734]  nfnetlink_rcv_batch+0x4a0/0x610 [nfnetlink]
[ 1914.211284]  nfnetlink_rcv+0x174/0x1a8 [nfnetlink]
[ 1914.221351]  netlink_unicast+0x1dc/0x290
[ 1914.230589]  netlink_sendmsg+0x2b8/0x3f8
[ 1914.239840]  ____sys_sendmsg+0x288/0x2d0
[ 1914.249117]  ___sys_sendmsg+0x90/0xd0
[ 1914.258154]  __sys_sendmsg+0x78/0xd0
[ 1914.267140]  __arm64_sys_sendmsg+0x2c/0x38
[ 1914.276705]  el0_svc_common.constprop.3+0x7c/0x198
[ 1914.287041]  do_el0_svc+0x34/0xa0
[ 1914.295928]  el0_sync_handler+0x128/0x190
[ 1914.305567]  el0_sync+0x140/0x180
[ 1914.314535] CPU: 2 PID: 31416 Comm: nft Tainted: G        W
5.9.0-next-20201013 #1
[ 1914.328670] Hardware name: HiKey Development Board (DT)
[ 1914.339812] Call trace:
[ 1914.348184]  dump_backtrace+0x0/0x1f0
[ 1914.357841]  show_stack+0x2c/0x80
[ 1914.367181]  dump_stack+0xf8/0x160
[ 1914.376615]  __warn+0xac/0x168
[ 1914.385732]  report_bug+0xcc/0x180
[ 1914.395242]  bug_handler+0x24/0x78
[ 1914.404783]  call_break_hook+0x80/0xa0
[ 1914.414725]  brk_handler+0x28/0x68
[ 1914.424358]  do_debug_exception+0xbc/0x128
[ 1914.434744]  el1_sync_handler+0x7c/0x128
[ 1914.445017]  el1_sync+0x7c/0x100
[ 1914.454625]  lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
[ 1914.467351]  nft_chain_parse_hook+0x58/0x320 [nf_tables]
[ 1914.479276]  nf_tables_addchain.isra.66+0xb8/0x510 [nf_tables]
[ 1914.491818]  nf_tables_newchain+0x408/0x618 [nf_tables]
[ 1914.503774]  nfnetlink_rcv_batch+0x4a0/0x610 [nfnetlink]
[ 1914.515899]  nfnetlink_rcv+0x174/0x1a8 [nfnetlink]
[ 1914.527525]  netlink_unicast+0x1dc/0x290
[ 1914.538318]  netlink_sendmsg+0x2b8/0x3f8
[ 1914.549125]  ____sys_sendmsg+0x288/0x2d0
[ 1914.559959]  ___sys_sendmsg+0x90/0xd0
[ 1914.570557]  __sys_sendmsg+0x78/0xd0
[ 1914.581111]  __arm64_sys_sendmsg+0x2c/0x38
[ 1914.592241]  el0_svc_common.constprop.3+0x7c/0x198
[ 1914.604152]  do_el0_svc+0x34/0xa0
[ 1914.614497]  el0_sync_handler+0x128/0x190
[ 1914.625540]  el0_sync+0x140/0x180
[ 1914.635652] irq event stamp: 0
[ 1914.645091] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 1914.657471] hardirqs last disabled at (0): [<ffff80001008975c>]
copy_process+0x68c/0x1910
[ 1914.671402] softirqs last  enabled at (0): [<ffff80001008975c>]
copy_process+0x68c/0x1910
[ 1914.685201] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 1914.696977] ---[ end trace 180274a5ab806f4e ]---
[ 1917.244483] hisi_thermal f7030700.tsensor: sensor <2> THERMAL
ALARM: 66385 > 65000

Full test log link,
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201013/testrun/3302070/suite/linux-log-parser/test/check-kernel-warning-1839079/log


-- 
Linaro LKFT
https://lkft.linaro.org
