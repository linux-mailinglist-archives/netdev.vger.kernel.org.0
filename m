Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F5754B867
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiFNSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiFNSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:17:39 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B354C10578;
        Tue, 14 Jun 2022 11:17:38 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id fu3so18748884ejc.7;
        Tue, 14 Jun 2022 11:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zlxLQghINcwpBBsM0/p3CcCOZ7i22A2lnQ7cKrK2rr8=;
        b=CAjCuZSPmDBEdogayl9o3yMowg7yRBFTWik3utSQS1qfrquhV5xZzaYg8pfFCQQL9b
         D8C0Sb++YzZHG8FnX32WlMJUgKWGTpKYouCxXCP+mEuRrkaBMzKW7wS91pYk6vtAaV0P
         m/JPsbKZ93uaiDfcVFphsRUL35/w0+D2KXwkM7dezeHJOQLETlVibqmjAiAseaCP0yWS
         awiTfy0BflEIHu+TuKNcJh8gCd6RH85XDcQGlBdMEl8D+XoWvUyQJW1xmP1Hn++rM4S+
         kH61pQBLGsLwstv+W3FG0vuWerIY02BGqT8zV/W7OdfV95UPpzWwfa8L6NgTn7gDEfgN
         UPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zlxLQghINcwpBBsM0/p3CcCOZ7i22A2lnQ7cKrK2rr8=;
        b=fejBygwv5qUcBBSvadJbI/u5egUDhpWT4CQxHSLdTx54RbZcyU1INnuMN3VWFbAk9B
         a+ayJjfAY55Da3cWCt0ZZyN9XHQfpvPwcIHBbOF8fVt6cnsm8BBOemduttVrY0DBrzoe
         y4o+0ka2WHJFNkNTGnoc589H0ZPgrpdVmldCQ+dA58ELjdKUyPuijtrBTp2U/ivrf/SX
         opaRa2PAWyKmapxVsjY49qKdkkaifV/XMDw8oA8aGvnE1yxeD03qWfXqe+NpDnn2L5N+
         +Idfzc7/RCCOLYKcPWjAmFh6F6zmrIGFTPYimzipyhZivFrXdjq6VEBhyTy9P2+qGZ8k
         KLIw==
X-Gm-Message-State: AOAM5317F9EoFaf8IkBiBOYL9trgSIhbgi9WzG/RC0IntGzPaf9R3AFl
        /VMWoHYhVyxFuASC3Z1bwtU=
X-Google-Smtp-Source: AGRyM1tCfHvLfmDn+3dB7UiGXXttKkmfLmtQmjvy2DFT6tieK/C/0AxeAt4s2uzn+aQ2pKNPx3GHJA==
X-Received: by 2002:a17:906:52c7:b0:6ce:a880:50a3 with SMTP id w7-20020a17090652c700b006cea88050a3mr5431791ejn.437.1655230657145;
        Tue, 14 Jun 2022 11:17:37 -0700 (PDT)
Received: from linuxdev2.toradex.int (31-10-206-125.static.upc.ch. [31.10.206.125])
        by smtp.gmail.com with ESMTPSA id q4-20020a50aa84000000b0042617ba638esm7558884edc.24.2022.06.14.11.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 11:17:36 -0700 (PDT)
From:   Max Krummenacher <max.oss.09@gmail.com>
To:     max.krummenacher@toradex.com,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1] Revert "Bluetooth: core: Fix missing power_on work cancel on HCI close"
Date:   Tue, 14 Jun 2022 20:17:06 +0200
Message-Id: <20220614181706.26513-1-max.oss.09@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Krummenacher <max.krummenacher@toradex.com>

This reverts commit ff7f2926114d3a50f5ffe461a9bce8d761748da5.

The commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work
cancel on HCI close") introduced between v5.18 and v5.19-rc1 makes
going to suspend freeze. v5.19-rc2 is equally affected.

This has been seen on a Colibri iMX6ULL WB which has a Marvell 8997
based WiFi / Bluetooth module connected over SDIO.

With 'v5.18' or 'v5.19-rc1 with said commit reverted' a suspend/resume
cycle looks as follows and the device is functional after the resume:

root@imx6ull:~# rfkill
ID TYPE      DEVICE    SOFT      HARD
 0 bluetooth hci0   blocked unblocked
 1 wlan      phy0   blocked unblocked
root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
root@imx6ull:~# date;echo mem > /sys/power/state;date
Tue Jun 14 14:43:03 UTC 2022
[ 6393.464497] PM: suspend entry (deep)
[ 6393.529398] Filesystems sync: 0.064 seconds
[ 6393.594006] Freezing user space processes ... (elapsed 0.015 seconds) done.
[ 6393.610266] OOM killer disabled.
[ 6393.610285] Freezing remaining freezable tasks ... (elapsed 0.013 seconds) done.
[ 6393.623727] printk: Suspending console(s) (use no_console_suspend to debug)

~~ suspended until console initiates the resume

[ 6394.023552] fec 20b4000.ethernet eth0: Link is Down
[ 6394.049902] PM: suspend devices took 0.300 seconds
[ 6394.091654] Disabling non-boot CPUs ...
[ 6394.565896] PM: resume devices took 0.440 seconds
[ 6394.681350] OOM killer enabled.
[ 6394.681369] Restarting tasks ... done.
[ 6394.741157] random: crng reseeded on system resumption
[ 6394.813135] PM: suspend exit
Tue Jun 14 14:43:11 UTC 2022
[ 6396.403873] fec 20b4000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
[ 6396.404347] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@imx6ull:~#

With 'v5.19-rc1' suspend freezes in the suspend phase, i.e. power
consumption is not lowered and no wakeup source initiates a wakup.

root@imx6ull:~# rfkill
ID TYPE      DEVICE    SOFT      HARD
 0 bluetooth hci0   blocked unblocked
 1 wlan      phy0   blocked unblocked
root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
root@imx6ull:~# date;echo mem > /sys/power/state;date
Tue Jun 14 12:40:38 UTC 2022
[  122.476333] PM: suspend entry (deep)
[  122.556012] Filesystems sync: 0.079 seconds

~~ no further kernel output

If one first unbinds the bluetooth device driver, suspend / resume works
as expected also with 'v5.19-rc1':

root@imx6ull:~# echo mmc1:0001:2 > /sys/bus/sdio/drivers/btmrvl_sdio/unbind
root@imx6ull:~# rfkill
ID TYPE DEVICE    SOFT      HARD
 1 wlan phy0   blocked unblocked
root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
root@imx6ull:~# date;echo mem > /sys/power/state;date
Tue Jun 14 14:59:26 UTC 2022
[  123.530310] PM: suspend entry (deep)
[  123.595432] Filesystems sync: 0.064 seconds
[  123.672478] Freezing user space processes ... (elapsed 0.028 seconds) done.
[  123.701848] OOM killer disabled.
[  123.701869] Freezing remaining freezable tasks ... (elapsed 0.007 seconds) done.
[  123.709993] printk: Suspending console(s) (use no_console_suspend to debug)
[  124.097772] fec 20b4000.ethernet eth0: Link is Down
[  124.124795] PM: suspend devices took 0.280 seconds
[  124.165893] Disabling non-boot CPUs ...
[  124.632959] PM: resume devices took 0.430 seconds
[  124.750164] OOM killer enabled.
[  124.750187] Restarting tasks ... done.
[  124.827899] random: crng reseeded on system resumption
[  124.923183] PM: suspend exit
Tue Jun 14 14:59:31 UTC 2022
[  127.520321] fec 20b4000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
[  127.520514] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@imx6ull:~#

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>

---

 net/bluetooth/hci_core.c | 2 ++
 net/bluetooth/hci_sync.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 59a5c1341c26..19df3905c5f8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2675,6 +2675,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
 
+	cancel_work_sync(&hdev->power_on);
+
 	hci_cmd_sync_clear(hdev);
 
 	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 286d6767f017..1739e8cb3291 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4088,7 +4088,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
-	cancel_work_sync(&hdev->power_on);
 	cancel_delayed_work(&hdev->power_off);
 	cancel_delayed_work(&hdev->ncmd_timer);
 
-- 
2.20.1

