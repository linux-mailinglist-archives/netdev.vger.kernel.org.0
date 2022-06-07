Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A453F477
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 05:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiFGD1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 23:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiFGD06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 23:26:58 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 26411B82FA;
        Mon,  6 Jun 2022 20:26:53 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.78.144])
        by mail-app4 (Coremail) with SMTP id cS_KCgBXqOBkxZ5i2ftgAQ--.11653S2;
        Tue, 07 Jun 2022 11:26:37 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        johannes@sipsolutions.net, gregkh@linuxfoundation.org,
        rafael@kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v6 0/2] Remove useless param of devcoredump functions and fix bugs
Date:   Tue,  7 Jun 2022 11:26:24 +0800
Message-Id: <cover.1654569290.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgBXqOBkxZ5i2ftgAQ--.11653S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW8JFyDtw18XFyDJw1UZFb_yoW8Cry8pF
        48Kas7ZrySkrs8uayxJF1xCas8J3WxWa47Kr9Fv3s5W3WfAF1rJr15uFyFkryqqFW8ta43
        tF13Jr13GF9aqFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUnYFADUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEOAVZdtaEx5gADsH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes the extra gfp_t param of dev_coredumpv()
and dev_coredumpm().

The second patch fix sleep in atomic context bugs of mwifiex
caused by dev_coredumpv().

Duoming Zhou (2):
  devcoredump: remove the useless gfp_t parameter in dev_coredumpv and
    dev_coredumpm
  mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

 drivers/base/devcoredump.c                       | 16 ++++++----------
 drivers/bluetooth/btmrvl_sdio.c                  |  2 +-
 drivers/bluetooth/hci_qca.c                      |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c           |  2 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot.c     |  4 ++--
 drivers/gpu/drm/msm/msm_gpu.c                    |  4 ++--
 drivers/media/platform/qcom/venus/core.c         |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c   |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.c       |  2 +-
 .../net/wireless/ath/wil6210/wil_crash_dump.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |  6 ++----
 drivers/net/wireless/marvell/mwifiex/init.c      |  9 +++++----
 drivers/net/wireless/marvell/mwifiex/main.c      |  3 +--
 drivers/net/wireless/marvell/mwifiex/main.h      |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c  |  3 +--
 drivers/net/wireless/realtek/rtw88/main.c        |  2 +-
 drivers/net/wireless/realtek/rtw89/ser.c         |  2 +-
 drivers/remoteproc/qcom_q6v5_mss.c               |  2 +-
 drivers/remoteproc/remoteproc_coredump.c         |  8 ++++----
 include/drm/drm_print.h                          |  2 +-
 include/linux/devcoredump.h                      | 13 ++++++-------
 sound/soc/intel/avs/apl.c                        |  2 +-
 sound/soc/intel/avs/skl.c                        |  2 +-
 sound/soc/intel/catpt/dsp.c                      |  2 +-
 27 files changed, 50 insertions(+), 58 deletions(-)

-- 
2.17.1

