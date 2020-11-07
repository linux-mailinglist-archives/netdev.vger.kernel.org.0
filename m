Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACE2AA6DD
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgKGRWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:22:11 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891B0C0613CF;
        Sat,  7 Nov 2020 09:22:11 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id g11so2449928pll.13;
        Sat, 07 Nov 2020 09:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xEaBVKWZ9KTDkaEYwsgdUA933o/1JNkBYwJLogK8nt8=;
        b=jEMULlVLKAcGh3HeNIxhljAmZ52HF9Zn10H7sVnuX1uCSNTLlYMsaP5Dw6LdzZMw71
         NuxdplZNZuvEkoSy226Uo4msoHb1vqPfsrFHpvWWRwARKuZGlmtwaEURYY9YMQ/w0xTr
         8+Ic1mPNHUg4YtwjteGYm0ICVFQcChe3QhuRgpmEEKCL570wiy0aTGU8TloXDValLcwC
         x4jHqHqEJ+AhYkOUfg3jUR2Jyt2ui1GcqsRry6iSg1it3fhL/UlTXdidwqefU3x9PMQ/
         NTxf0oTfvGzWK3Ir6OSV6wq1IQwb8ukzDVhJayB5NCWSNzrJSJGxs/9djCO3gV8D4Dsh
         oFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xEaBVKWZ9KTDkaEYwsgdUA933o/1JNkBYwJLogK8nt8=;
        b=tAjvxemyl4Z49/KJuGJvFeCNn9kq6cw66axxbU2uLw2Jb96TJtRtxJl+tP7RisWCk8
         zpua/28E12anI/BBqL36WxXisZ6oBuYi5cTp2nssaBOdmv3BXVXZfPlrIG7+yRGy2lC5
         JOqE4p5c70oBhZVBPhjyAIgYlIp1WIJllCLvyZt/yiMAgWMfnujzVEOPnBttmPj3zI1G
         RjxCb8JHMEX6FVCrsqjvf1gTRN4MKNp9S/4rE+ndOqCrt1fPHDdKMWZJLpaqJt4i0Rvq
         eY3yz/uQrvG2T5EEpOl8IPkX7LmM85I6nAs+sobCGMLlF94O0qyWs8QOkfr1pPBZushj
         ptAw==
X-Gm-Message-State: AOAM5326h+a1DHK/WZzCcUXq1kB9kD7RodItnEhxlNJWoaPibA1TWGFS
        ymNvgKpMLGMYythzuEHsjxM=
X-Google-Smtp-Source: ABdhPJyzv8t5L+DU4k8+RutN3OkCQkt4Wi9lmCPb1ODzIRGNYwLl0wb2bSS7JC6RhZLlB1tq63RGeQ==
X-Received: by 2002:a17:902:8504:b029:d6:7552:19ab with SMTP id bj4-20020a1709028504b02900d6755219abmr6220334plb.83.1604769730993;
        Sat, 07 Nov 2020 09:22:10 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:22:10 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 00/21] net: avoid to remove module when its debugfs is being used
Date:   Sat,  7 Nov 2020 17:21:31 +0000
Message-Id: <20201107172152.828-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When debugfs file is opened, its module should not be removed until
it's closed.
Because debugfs internally uses the module's data.
So, it could access freed memory.

In order to avoid panic, it just sets .owner to THIS_MODULE.
So that all modules will be held when its debugfs file is opened.

Test commands:
cat <<EOF > open.c
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
        int fd = open(argv[1], O_RDONLY);

        if(fd < 0) {
                printf("failed to open\n");
                return 1;
        }

        usleep(3000000);

        close(fd);
        return 0;
}
EOF
gcc -o open open.c
modprobe netdevsim
echo 1 > /sys/bus/netdevsim/new_device
./open /sys/kernel/debug/netdevsim/netdevsim1/take_snapshot &
modprobe -rv netdevsim

Splat looks like:
[   75.305876][  T662] BUG: unable to handle page fault for address: fffffbfff8096db4
[   75.308979][  T662] #PF: supervisor read access in kernel mode
[   75.311311][  T662] #PF: error_code(0x0000) - not-present page
[   75.313737][  T662] PGD 1237ee067 P4D 1237ee067 PUD 123612067 PMD 100ba7067 PTE 0
[   75.316858][  T662] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   75.319389][  T662] CPU: 1 PID: 662 Comm: open Not tainted 5.10.0-rc2+ #785
[   75.322312][  T662] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   75.326429][  T662] RIP: 0010:full_proxy_release+0xca/0x290
[   75.328712][  T662] Code: c1 ea 03 80 3c 02 00 0f 85 60 01 00 00 49 8d bc 24 80 00 00 00 4c 8b 73 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 71 01 00 00 49 8b 84 24 80 00 00 00 48 85 c0 0f
[   75.336716][  T662] RSP: 0018:ffff88800400fe48 EFLAGS: 00010a06
[   75.339153][  T662] RAX: dffffc0000000000 RBX: ffff88810139de00 RCX: ffff88810139de28
[   75.342419][  T662] RDX: 1ffffffff8096db4 RSI: ffff88810139de00 RDI: ffffffffc04b6da0
[   75.345629][  T662] RBP: ffff8881168342b0 R08: ffff8881168342b0 R09: ffff888110765300
[   75.348804][  T662] R10: ffff88800400fe88 R11: ffffed1022ac648a R12: ffffffffc04b6d20
[   75.352052][  T662] R13: ffff88810139de28 R14: ffff8881054a6d00 R15: ffff888110765300
[   75.355325][  T662] FS:  00007f937b80f4c0(0000) GS:ffff888118e00000(0000) knlGS:0000000000000000
[   75.358955][  T662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.361634][  T662] CR2: fffffbfff8096db4 CR3: 0000000004292002 CR4: 00000000003706e0
[   75.364847][  T662] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   75.368003][  T662] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   75.371259][  T662] Call Trace:
[   75.372655][  T662]  __fput+0x1ff/0x820
[   75.374316][  T662]  ? _raw_spin_unlock_irq+0x24/0x30
[   75.376454][  T662]  task_work_run+0xd3/0x170
[   75.378268][  T662]  exit_to_user_mode_prepare+0x14b/0x150
[   75.380586][  T662]  syscall_exit_to_user_mode+0x40/0x250
[   75.383015][  T662]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   75.385427][  T662] RIP: 0033:0x7f937b3159e4
[ ... ]

v1 -> v2:
 - Rebase
 - Squash patches into per-driver/subsystem

Taehee Yoo (21):
  net: set .owner to THIS_MODULE
  mac80211: set .owner to THIS_MODULE
  cfg80211: set .owner to THIS_MODULE
  netdevsim: set .owner to THIS_MODULE
  ieee802154: set .owner to THIS_MODULE
  i2400m: set .owner to THIS_MODULE
  wlcore: set .owner to THIS_MODULE
  wl1251: set .owner to THIS_MODULE
  iwlwifi: set .owner to THIS_MODULE
  iwlegacy: set .owner to THIS_MODULE
  rtlwifi: set .owner to THIS_MODULE
  ath11k: set .owner to THIS_MODULE
  ath10k: set .owner to THIS_MODULE
  wcn36xx: set .owner to THIS_MODULE
  wil6210: set .owner to THIS_MODULE
  cw1200: set .owner to THIS_MODULE
  brcmfmac: set .owner to THIS_MODULE
  b43legacy: set .owner to THIS_MODULE
  b43: set .owner to THIS_MODULE
  mwifiex: mwifiex: set .owner to THIS_MODULE
  Bluetooth: set .owner to THIS_MODULE

 drivers/net/ieee802154/ca8210.c               |  3 ++-
 drivers/net/netdevsim/dev.c                   |  2 ++
 drivers/net/netdevsim/health.c                |  1 +
 drivers/net/netdevsim/udp_tunnels.c           |  1 +
 drivers/net/wimax/i2400m/debugfs.c            |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c       | 15 ++++++++++-----
 drivers/net/wireless/ath/ath11k/debugfs.c     |  7 +++++--
 drivers/net/wireless/ath/wcn36xx/debug.c      |  2 ++
 drivers/net/wireless/ath/wil6210/debugfs.c    | 19 +++++++++++++++++++
 drivers/net/wireless/broadcom/b43/debugfs.c   |  1 +
 .../net/wireless/broadcom/b43legacy/debugfs.c |  1 +
 .../broadcom/brcm80211/brcmfmac/core.c        |  1 +
 drivers/net/wireless/intel/iwlegacy/3945-rs.c |  1 +
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |  3 +++
 drivers/net/wireless/intel/iwlegacy/debug.c   |  3 +++
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |  3 +++
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  1 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.h  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  3 +++
 .../net/wireless/marvell/mwifiex/debugfs.c    |  3 +++
 drivers/net/wireless/realtek/rtlwifi/debug.c  |  1 +
 drivers/net/wireless/st/cw1200/debug.c        |  1 +
 drivers/net/wireless/ti/wl1251/debugfs.c      |  4 ++++
 drivers/net/wireless/ti/wlcore/debugfs.h      |  3 +++
 net/6lowpan/debugfs.c                         |  1 +
 net/batman-adv/log.c                          |  1 +
 net/bluetooth/6lowpan.c                       |  1 +
 net/bluetooth/hci_core.c                      |  2 ++
 net/bluetooth/hci_debugfs.c                   |  6 ++++++
 net/bluetooth/selftest.c                      |  1 +
 net/bluetooth/smp.c                           |  2 ++
 net/mac80211/debugfs.c                        |  7 +++++++
 net/mac80211/debugfs_key.c                    |  3 +++
 net/mac80211/debugfs_netdev.c                 |  1 +
 net/mac80211/debugfs_sta.c                    |  2 ++
 net/mac80211/rate.c                           |  1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c    |  2 ++
 net/wireless/debugfs.c                        |  2 ++
 41 files changed, 117 insertions(+), 8 deletions(-)

-- 
2.17.1

