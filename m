Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5A4CB1A1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245426AbiCBV6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240079AbiCBV6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:58:01 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6595E157
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:57:17 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2dbd97f9bfcso34467917b3.9
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 13:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=reQKMgSenPFCzwhlu3srHo4UM19BojX4bR4b1u4koLA=;
        b=QvnXfvaekWRfcgpgUQ+IJ+nHwQ4i+FoMrHvyNarzfbxv2JYN9+fyuG4Hd8suD5A/ZQ
         Z6CK0Uo25KUkSDA0gsFcJDUZhmxfoHgRVbvJs7mnumfeyqdEaDIYowewh2OMq7C9lA2H
         Ljs8lqbweiqRH9klClsxoUZFSc173Xas4rzHhg5h9Tfafc7+7DFssUtb4ddAh2DNveg7
         BBSXJkURPVlD2HW3kcmPmaXltu+zKmt5wO8CxWN0ZTFs7hPRUmhmu3/raecwZ7RE7ytm
         QtX1d+0Hhr0WZWvTf2tmLGJlPh116Obb48t3iVmvx4rK4mCrsmBX/IE0t87bvf1AZL4N
         rJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=reQKMgSenPFCzwhlu3srHo4UM19BojX4bR4b1u4koLA=;
        b=wsCNPVA2AmVDDXY813DHcyC/IK4ZCiVqvxQqmzWjBhEt/H/6Ej+ElRwoRL+bdWIaom
         QHb8gEMBgjwzFckUzFbGniXhXzllkh4bNISx9LaVIGPMtQrzxDzu57Ahfnvfh2Fu2Hrc
         yhCyY1mG1nyKH2L+3lHpLiJfiDv8XYYovGviWhhUlhUvprx0Occ2GlyLdEmIaD2ngTRy
         f7wR14UsfKY5eIVoTwAiAFGJLScbff9ocDXYbX8JkbW6tK59X8PO9KDT+g0MW4NL6mC5
         QqMp6QnpGRXNhsrGKlqmwkP2yD0wFa+VqrF0SZHECA4nKWHdzbbcbjJfFZskOY/l6g80
         n7Hw==
X-Gm-Message-State: AOAM531RxtNhw/nt7E+Vylf9BRgWchVRYSExWjTcxHMhP5JcgIUCPWCo
        wDcFqzaGbF19W2gfaUvNihr53ZrShxxT+VJqoT8=
X-Google-Smtp-Source: ABdhPJxetPoK5jxsN9xvBHnXQs9pkvigQJbcGaGrE/QH+kDzt5lyROejYfAotn4Y4trBQWtGlPe6cH0lMxbUWGE4/WQ=
X-Received: by 2002:a81:110f:0:b0:2db:fe4f:fe with SMTP id 15-20020a81110f000000b002dbfe4f00femr7825952ywr.90.1646258237007;
 Wed, 02 Mar 2022 13:57:17 -0800 (PST)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 2 Mar 2022 18:57:06 -0300
Message-ID: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
Subject: smsc95xx warning after a 'reboot' command
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On a imx8mm iotgateway board from Compulab running 5.10 or 5.17-rc the
following warning is observed after a 'reboot' command:

[   23.077179] ci_hdrc ci_hdrc.1: remove, state 1
[   23.081674] usb usb2: USB disconnect, device number 1
[   23.086740] usb 2-1: USB disconnect, device number 2
[   23.088393] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.091718] usb 2-1.1: USB disconnect, device number 3
[   23.094090] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
[   23.098869] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.098877] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.125763] ------------[ cut here ]------------
[   23.125860] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.130393] WARNING: CPU: 3 PID: 119 at drivers/net/phy/phy.c:958
phy_error+0x14/0x60
[   23.130397] Modules linked in:
[   23.137550] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.145367]  iwlmvm mac80211 libarc4
[   23.148439] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.154175]  af_alg caam_jr caamhash_desc caamalg_desc
crypto_engine rng_core authenc libdes btusb hci_uart btrtl btintel
btqca crct10dif_ce btbcm fsl_imx8_ddr_perf bluetooth ecdh_generic ecc
spi_imx spi_bitbang clk_bd718x7 at24 caam error rtc_snvs snvs_pwrkey
imx8mm_thermal imx_cpufreq_dt pwm_bl overlay iwlwifi cfg80211 rfkill
ipv6
[   23.193841] CPU: 3 PID: 119 Comm: kworker/u8:2 Not tainted
5.10.102-stable-standard #1
[   23.201764] Hardware name: CompuLab i.MX8MM IoT Gateway (DT)
[   23.207433] Workqueue: events_power_efficient phy_state_machine
[   23.213362] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[   23.219375] pc : phy_error+0x14/0x60
[   23.222954] lr : phy_state_machine+0x88/0x218
[   23.227315] sp : ffff800011743d20
[   23.230631] x29: ffff800011743d20 x28: ffff800011207000
[   23.235952] x27: ffff000000008070 x26: ffff000000008020
[   23.241273] x25: 0000000000000000 x24: 00000000ffffffed
[   23.246595] x23: ffff0000002e44e8 x22: ffff000000161c80
[   23.251915] x21: ffff0000002e4000 x20: 0000000000000005
[   23.257238] x19: ffff0000002e4000 x18: 0000000000000010
[   23.262558] x17: 0000000000000000 x16: 0000000000000000
[   23.267878] x15: 0000000e9816052e x14: 0000000000000000
[   23.273198] x13: 000000000000002f x12: 0000000000000198
[   23.278518] x11: 000000000000c6f5 x10: 000000000000c6f5
[   23.283838] x9 : 0000000000000000 x8 : ffff00007fbbc0c0
[   23.289161] x7 : ffff00007fbbb600 x6 : 0000000000000000
[   23.294481] x5 : 0000000000000008 x4 : 0000000000000000
[   23.299801] x3 : ffff0000002e44e8 x2 : 0000000000000000
[   23.305121] x1 : ffff000000161c80 x0 : ffff0000002e4000
[   23.310442] Call trace:
[   23.312894]  phy_error+0x14/0x60
[   23.316125]  phy_state_machine+0x88/0x218
[   23.320144]  process_one_work+0x1bc/0x338
[   23.324158]  worker_thread+0x50/0x420
[   23.327826]  kthread+0x140/0x160
[   23.331061]  ret_from_fork+0x10/0x34
[   23.334639] ---[ end trace 2cf86ece81b89776 ]---
[   23.339391] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.346550] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.352312] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.358863] smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
[   23.384599] usb 2-1.4: USB disconnect, device number 4
[   23.394062] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[   23.401921] ci_hdrc ci_hdrc.0: remove, state 4
[   23.406444] usb usb1: USB disconnect, device number 1
[   23.412082] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
[   23.438063] imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
[   23.444895] reboot: Restarting system

Would anyone have any suggestions to fix this?

Thanks
