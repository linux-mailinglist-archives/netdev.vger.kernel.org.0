Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718BD691040
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBISXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBISXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:23:03 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5677860321
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:23:01 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id m12so3000734qth.4
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 10:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OTfzY/Chfs7uqsAiNDpZ6trUEll/L71CbJHJALFQZM4=;
        b=DJLHE80cm2ZtcScbPjB3jkl1zPCVeS9NEMKViyY+OTpQLwK6D0kg6ElVae4AKU+Jka
         SL90Vfbk8qTR3pv34qEO9KUGIbs9ebJdXWsPNSVfLzkUyxq6yMiSzxKIjPwEsAxt8ixh
         /avGwCoJmwamxNuQ7t6t0aXK/VczWGZmzLApZmBAwGbB/yOajj2PJHYjhY8GvKh5aoaX
         sOrpAxqgzLC3V7xn4atGu8ox3Twpu6PiDnbdidfhYAV4Up0w8MQ/YJqh/AHf9G+L0woQ
         Ok+MCxGY5UyofFCk091V1XqjXmz5RN/HabbFHxwl9pGHseR9iVNXQEy82zzFhkmQq/b9
         LsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTfzY/Chfs7uqsAiNDpZ6trUEll/L71CbJHJALFQZM4=;
        b=0hp69GVd37JTexG7SUwKoWzp2b+vQS+3qeqF4rurhVrKRJOkFtriCdIgQ/I3eTFIO2
         TWficBWeZKQaN7kxF3GSNCeXUyZW8SBz2OEnELwe/USIrxRJsDETqs13tSBWKVxsjO+X
         WFIju8Fr3nhrhjUZCQEyQcGlwNJNp/KfRpsIxMeeGs8qWdv1RNtkRGK0xeL+/H8wzMUw
         0+rMQ0nf/84Q9P2clCrB2lq0JcZ3/RV2ue7rOivwu5xfAvCtmobK7ZkT6NqDh3s8DKil
         1Z+b/JWFC8veaSqB6epdThbdkpgOMZ4FOzOvSR2o0NF4ejMC7sjheXzaT/2K/ILnr+lk
         sb4g==
X-Gm-Message-State: AO0yUKWOOfsa1vBN9K3RJlfhKsO2C2VaQqhTYVNwozYoxfoEoiNk44ci
        3uupY/C+jNJCy6IwmBB45L0OZXv+pKGm1aP9JfqEWQ==
X-Google-Smtp-Source: AK7set8h+mdHWWDG4oLkSXScXaXN0cqzbhlR6uKGYD/Kkjxgn8UPf05SLjNs0A3Mgg8gR3fUoGHSuYUgsGUadNOQpDk=
X-Received: by 2002:ac8:5783:0:b0:3b8:6a00:87ca with SMTP id
 v3-20020ac85783000000b003b86a0087camr2389017qta.81.1675966980408; Thu, 09 Feb
 2023 10:23:00 -0800 (PST)
MIME-Version: 1.0
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Thu, 9 Feb 2023 23:52:24 +0530
Message-ID: <CAMi1Hd3hYo00ieqWNJyXzBmknKkb1y76T8xKUVZBJGXMvRSpNg@mail.gmail.com>
Subject: ath10k: wcn3990: hitting kernel warnings while running hostapd
To:     Kalle Valo <kvalo@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using WiFi hotspot (hostapd) on Dragonboard 845c
(sdm845|ath10k|wcn3990) running AOSP, and I run into following
non-fatal warnings when a station disassociates from the AP. I wanted
to raise the issue in case anyone had ideas what might be going wrong.
Any known issues? I can reproduce similar warnings all the way to
v5.15.y (or may be older LTS versions as well but didn't try yet).

--------------------->8----------8<------------------
[ 9759.346966][ T1989] ath10k_snoc 18800000.wifi: failed to install
key for vdev 0 peer 8a:55:b5:61:9c:a7: -110
[ 9759.356962][ T1989] wlan0: failed to remove key (0,
8a:55:b5:61:9c:a7) from hardware (-110)
[ 9759.394757][ T1989] ath10k_snoc 18800000.wifi: cipher 0 is not supported
[ 9759.401548][ T1989] ath10k_snoc 18800000.wifi: failed to remove
peer wep key 0: -95
[ 9759.409545][ T1989] ath10k_snoc 18800000.wifi: failed to clear all
peer wep keys for vdev 0: -95
[ 9759.418574][ T1989] ath10k_snoc 18800000.wifi: failed to
disassociate station: 8a:55:b5:61:9c:a7 vdev 0: -95
[ 9759.428742][ T1989] ------------[ cut here ]------------
[ 9759.434103][ T1989] WARNING: CPU: 3 PID: 1989 at
net/mac80211/sta_info.c:1307 __sta_info_destroy_part2+0x108/0x150
........
[ 9759.721639][ T1989] CPU: 3 PID: 1989 Comm: hostapd Tainted: G
     E      6.2.0-rc7-mainline-00015-gdc06692108da #1
[ 9759.732680][ T1989] Hardware name: Thundercomm Dragonboard 845c (DT)
[ 9759.739088][ T1989] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT
-SSBS BTYPE=--)
[ 9759.746812][ T1989] pc : __sta_info_destroy_part2+0x108/0x150
[ 9759.752620][ T1989] lr : __sta_info_destroy_part2+0x6c/0x150
..............
[ 9759.841441][ T1989] Call trace:
[ 9759.844616][ T1989]  __sta_info_destroy_part2+0x108/0x150
[ 9759.850069][ T1989]  __sta_info_destroy+0x2c/0x40
[ 9759.854826][ T1989]  sta_info_destroy_addr_bss+0x34/0x58
[ 9759.860189][ T1989]  ieee80211_del_station+0x1c/0x40
[ 9759.865208][ T1989]  nl80211_del_station+0xdc/0x250
[ 9759.870136][ T1989]  genl_family_rcv_msg_doit.isra.0+0xbc/0x128
[ 9759.876119][ T1989]  genl_rcv_msg+0x1f0/0x280
[ 9759.880529][ T1989]  netlink_rcv_skb+0x58/0x138
[ 9759.885112][ T1989]  genl_rcv+0x38/0x50
[ 9759.888990][ T1989]  netlink_unicast+0x1cc/0x298
[ 9759.893659][ T1989]  netlink_sendmsg+0x1d8/0x448
[ 9759.898328][ T1989]  sock_sendmsg+0x4c/0x58
[ 9759.902562][ T1989]  ____sys_sendmsg+0x314/0x3a8
[ 9759.907226][ T1989]  ___sys_sendmsg+0x80/0xc8
[ 9759.911634][ T1989]  __sys_sendmsg+0x68/0xc8
[ 9759.915946][ T1989]  __arm64_sys_sendmsg+0x24/0x30
[ 9759.920787][ T1989]  invoke_syscall+0x44/0x108
[ 9759.925286][ T1989]  el0_svc_common.constprop.0+0x44/0xf0
[ 9759.930746][ T1989]  do_el0_svc+0x38/0xb0
[ 9759.934799][ T1989]  el0_svc+0x2c/0xb8
[ 9759.938594][ T1989]  el0t_64_sync_handler+0xb8/0xc0
[ 9759.943521][ T1989]  el0t_64_sync+0x1a0/0x1a4
[ 9759.947929][ T1989] ---[ end trace 0000000000000000 ]---
[ 9759.975839][ T1989] ------------[ cut here ]------------
[ 9759.981188][ T1989] WARNING: CPU: 4 PID: 1989 at
net/mac80211/sta_info.c:417 sta_info_free+0xa0/0x110
....................
[ 9760.266646][ T1989] CPU: 4 PID: 1989 Comm: hostapd Tainted: G
 W   E      6.2.0-rc7-mainline-00015-gdc06692108da #1
[ 9760.277675][ T1989] Hardware name: Thundercomm Dragonboard 845c (DT)
[ 9760.284076][ T1989] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT
-SSBS BTYPE=--)
[ 9760.291782][ T1989] pc : sta_info_free+0xa0/0x110
[ 9760.296524][ T1989] lr : __sta_info_destroy_part2+0xf4/0x150
.................................
[ 9760.385123][ T1989] Call trace:
[ 9760.388286][ T1989]  sta_info_free+0xa0/0x110
[ 9760.392673][ T1989]  __sta_info_destroy_part2+0xf4/0x150
[ 9760.398026][ T1989]  __sta_info_destroy+0x2c/0x40
[ 9760.402763][ T1989]  sta_info_destroy_addr_bss+0x34/0x58
[ 9760.408115][ T1989]  ieee80211_del_station+0x1c/0x40
[ 9760.413115][ T1989]  nl80211_del_station+0xdc/0x250
[ 9760.418027][ T1989]  genl_family_rcv_msg_doit.isra.0+0xbc/0x128
[ 9760.423987][ T1989]  genl_rcv_msg+0x1f0/0x280
[ 9760.428374][ T1989]  netlink_rcv_skb+0x58/0x138
[ 9760.432943][ T1989]  genl_rcv+0x38/0x50
[ 9760.436805][ T1989]  netlink_unicast+0x1cc/0x298
[ 9760.441461][ T1989]  netlink_sendmsg+0x1d8/0x448
[ 9760.446117][ T1989]  sock_sendmsg+0x4c/0x58
[ 9760.450333][ T1989]  ____sys_sendmsg+0x314/0x3a8
[ 9760.454984][ T1989]  ___sys_sendmsg+0x80/0xc8
[ 9760.459371][ T1989]  __sys_sendmsg+0x68/0xc8
[ 9760.463672][ T1989]  __arm64_sys_sendmsg+0x24/0x30
[ 9760.468498][ T1989]  invoke_syscall+0x44/0x108
[ 9760.472982][ T1989]  el0_svc_common.constprop.0+0x44/0xf0
[ 9760.478422][ T1989]  do_el0_svc+0x38/0xb0
[ 9760.482467][ T1989]  el0_svc+0x2c/0xb8
[ 9760.486245][ T1989]  el0t_64_sync_handler+0xb8/0xc0
[ 9760.491164][ T1989]  el0t_64_sync+0x1a0/0x1a4
[ 9760.495551][ T1989] ---[ end trace 0000000000000000 ]---
[ 9760.500964][ T1989] ath10k_snoc 18800000.wifi: failed to clear all
peer wep keys for vdev 0: -2
[ 9760.509735][ T1989] ath10k_snoc 18800000.wifi: failed to
disassociate station: 8a:55:b5:61:9c:a7 vdev 0: -2
[ 9760.519547][ T1989] ------------[ cut here ]------------
[ 9760.519548][ T1989] sta_info_move_state() returned -2
[ 9760.519562][ T1989] WARNING: CPU: 4 PID: 1989 at
net/mac80211/sta_info.c:420 sta_info_free+0x108/0x110
..............................
[ 9760.889840][ T1989] CPU: 4 PID: 1989 Comm: hostapd Tainted: G
 W   E      6.2.0-rc7-mainline-00015-gdc06692108da #1
[ 9760.900872][ T1989] Hardware name: Thundercomm Dragonboard 845c (DT)
[ 9760.907270][ T1989] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT
-SSBS BTYPE=--)
[ 9760.914975][ T1989] pc : sta_info_free+0x108/0x110
[ 9760.919801][ T1989] lr : sta_info_free+0x108/0x110
...............................................
[ 9761.007538][ T1989] Call trace:
[ 9761.010703][ T1989]  sta_info_free+0x108/0x110
[ 9761.015185][ T1989]  __sta_info_destroy_part2+0xf4/0x150
[ 9761.020537][ T1989]  __sta_info_destroy+0x2c/0x40
[ 9761.025277][ T1989]  sta_info_destroy_addr_bss+0x34/0x58
[ 9761.030625][ T1989]  ieee80211_del_station+0x1c/0x40
[ 9761.035632][ T1989]  nl80211_del_station+0xdc/0x250
[ 9761.040544][ T1989]  genl_family_rcv_msg_doit.isra.0+0xbc/0x128
[ 9761.046507][ T1989]  genl_rcv_msg+0x1f0/0x280
[ 9761.050901][ T1989]  netlink_rcv_skb+0x58/0x138
[ 9761.055469][ T1989]  genl_rcv+0x38/0x50
[ 9761.059340][ T1989]  netlink_unicast+0x1cc/0x298
[ 9761.063995][ T1989]  netlink_sendmsg+0x1d8/0x448
[ 9761.068650][ T1989]  sock_sendmsg+0x4c/0x58
[ 9761.072866][ T1989]  ____sys_sendmsg+0x314/0x3a8
[ 9761.077520][ T1989]  ___sys_sendmsg+0x80/0xc8
[ 9761.081906][ T1989]  __sys_sendmsg+0x68/0xc8
[ 9761.086206][ T1989]  __arm64_sys_sendmsg+0x24/0x30
[ 9761.091028][ T1989]  invoke_syscall+0x44/0x108
[ 9761.095512][ T1989]  el0_svc_common.constprop.0+0x44/0xf0
[ 9761.100949][ T1989]  do_el0_svc+0x38/0xb0
[ 9761.104993][ T1989]  el0_svc+0x2c/0xb8
[ 9761.108768][ T1989]  el0t_64_sync_handler+0xb8/0xc0
[ 9761.113679][ T1989]  el0t_64_sync+0x1a0/0x1a4
[ 9761.118066][ T1989] ---[ end trace 0000000000000000 ]---
--------------------->8----------8<------------------

Full log here: https://www.irccloud.com/pastebin/P4cJCw0H/

Regards,
Amit Pundir
