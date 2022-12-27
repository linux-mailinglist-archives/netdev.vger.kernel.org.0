Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1476570FB
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiL0Xaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiL0Xai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:38 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A52B1D;
        Tue, 27 Dec 2022 15:30:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m21so20870944edc.3;
        Tue, 27 Dec 2022 15:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gNI4glAP8RCHIX0Vc1rrjcz+Kvrw2hTC3GBQO91dTzE=;
        b=PgAZ5aZt60CG6sLLPDEVEddXtgBvZGHfbo1q7Kaoz+jVwewez6JV0OjWtiLxgYp3go
         ZB/sbiE+D/1GRwsm29iOS73d+TJblGHu+/6dMjl7e/jSdgsbZ/tGayRqj4SlrwUkN/FZ
         20AzPMvBQCXMRBBOu0pmzBPTV+LKLIwmHCYIzCZ9Byq6xzVZc808I0LoDRtTCmanS219
         exX6w96YxESVe38a7SieSwm7goZ0V3nfc3KZvT99EgrQY61Oj4Pn8V5Xk4wj0DchHoqf
         QTAZxF1fH6HQJ3toICNcXwmpSgvjPw8fM9I8ujGwxoGCvJsV8013XlMduN9sXK9gJDN9
         Z4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNI4glAP8RCHIX0Vc1rrjcz+Kvrw2hTC3GBQO91dTzE=;
        b=VOrEV6O+1RjGwO4f3/HGUDBv0qC4KE3TjMviH2gG1xZGiEZCmSnchLvIhWt5ZwTfND
         IHdpgpN26/moSnH+rCHmt4agaoJGwgToAtyT2oUPypkDvq4olhr+47B0+jGEVAY3Dbz6
         8H4bsFwv2VZdHwHANy9JYD2AzD7DKdGN9w/oFPIl42yJr7Usy//7ODNmTyHh2ZMKfm74
         529x9FoIdFhSwwd/ltQvbT+EvcNxg6UPFyDKUMkUtKCcjdpI0rMjxuj1+NSmzuD8BO9y
         ERvux4ECYoFKuc3wE62owLURxv0CaE5yliHrDIH/k/LjIcNNvvKtJtGofXZ0LDfkyKE7
         KnXA==
X-Gm-Message-State: AFqh2kpjcIzhUbpNiXXevs7B73TYFp9mtSj6UueOZdTehN46SwzQ9EqQ
        wtIoxxp6N3frBG/ufdcyxHAng6jnWVA=
X-Google-Smtp-Source: AMrXdXtHXTSThumsWgqSjQD28Ytz9upkuh0X8wck3S2bYI+sMZUeOkNp1Rj+Gpe9CHiPCzeYET7Dhg==
X-Received: by 2002:a50:ec19:0:b0:46c:fabe:837b with SMTP id g25-20020a50ec19000000b0046cfabe837bmr19326490edr.41.1672183834861;
        Tue, 27 Dec 2022 15:30:34 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:34 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH v1 00/19] rtw88: Add SDIO support
Date:   Wed, 28 Dec 2022 00:30:01 +0100
Message-Id: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently the rtw88 driver has gained locking support for the "slow" bus
types (USB, SDIO) as part of USB support. Thanks to everyone who helped
make this happen!

Based on the USB work (especially the locking part and various
bugfixes) this series adds support for SDIO based cards. It's the
result of a collaboration between Jernej and myself. Neither of us has
access to the rtw88 datasheets. All of our work is based on studying
the RTL8822BS and RTL8822CS vendor drivers and trial and error.

Jernej and myself have tested this with RTL8822BS and RTL8822CS cards.
Other users have confirmed that RTL8821CS support is working as well.
RTL8723DS may also work (we tried our best to handle rtw_chip_wcpu_11n
where needed) but has not been tested at this point.

Jernej's results with a RTL8822BS:
- Main functionality works
- Had a case where no traffic got across the link until he issued a
  scan

My results with a RTL8822CS:
- 2.4GHz and 5GHz bands are both working
- TX throughput on a 5GHz network is between 50 Mbit/s and 90 Mbit/s
- RX throughput on a 5GHz network is at 19 Mbit/s
- Sometimes there are frequent reconnects (once every 1-5 minutes)
  after the link has been up for a long time (multiple hours). Today
  I was unable to reproduce this though (I only had reconnect in 8
  hours).

Why is this an RFC?
- It needs a through review especially by the rtw88 maintainers
- It's not clear to me how the "mmc: sdio" patch will be merged (will
  Ulf take this or can we merge it thorugh the rtw88/linux wireless
  driver tree?)
- Any comments / debugging hints on the reconnect / no traffic issues
  (see above) are welcome
- My understanding is that there's a discussion about the rtw88 Kconfig
  symbols. We're adding four new ones within this series. It's not
  clear to me what the conclusion is on this topic though.
- As with most patches: testing is very welcome. If things are working
  fine then a Tested-by is appreciated (with some details about the
  card, throughput, ...). If something doesn't work for you: please
  still report back so we can investigate that problem!



Jernej Skrabec (2):
  rtw88: ps: Increase LEAVE_LPS_TRY_CNT for SDIO based chipsets
  rtw88: Add support for the SDIO based RTL8822BS chipset

Martin Blumenstingl (17):
  rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()
  rtw88: pci: Change type of rtw_hw_queue_mapping() and ac_to_hwq to
    enum
  rtw88: pci: Change queue datatype from u8 to enum rtw_tx_queue_type
  rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
  mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
  rtw88: rtw8821c: Add support for parsing the RTL8821CS (SDIO) efuse
  rtw88: rtw8822b: Add support for parsing the RTL8822BS (SDIO) efuse
  rtw88: rtw8822c: Add support for parsing the RTL8822CS (SDIO) efuse
  rtw88: hci: Add an optional power_switch() callback to rtw_hci_ops
  rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
  rtw88: mac: Add support for the SDIO HCI in the TX/page table setup
  rtw88: sdio: Add HCI implementation for SDIO based chipsets
  rtw88: mac: Add support for SDIO specifics in the power on sequence
  rtw88: main: Add the rpwm_addr and cpwm_addr for SDIO based chipsets
  rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO based cards
  rtw88: Add support for the SDIO based RTL8822CS chipset
  rtw88: Add support for the SDIO based RTL8821CS chipset

 drivers/net/wireless/realtek/rtw88/Kconfig    |   36 +
 drivers/net/wireless/realtek/rtw88/Makefile   |   12 +
 drivers/net/wireless/realtek/rtw88/debug.h    |    1 +
 drivers/net/wireless/realtek/rtw88/hci.h      |    8 +
 drivers/net/wireless/realtek/rtw88/mac.c      |   62 +-
 drivers/net/wireless/realtek/rtw88/mac.h      |    1 -
 drivers/net/wireless/realtek/rtw88/main.c     |    9 +-
 drivers/net/wireless/realtek/rtw88/pci.c      |   50 +-
 drivers/net/wireless/realtek/rtw88/ps.h       |    2 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |   10 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |    9 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |    6 +
 .../net/wireless/realtek/rtw88/rtw8821cs.c    |   34 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   10 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.h |    6 +
 .../net/wireless/realtek/rtw88/rtw8822bs.c    |   34 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |    9 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |    6 +
 .../net/wireless/realtek/rtw88/rtw8822cs.c    |   34 +
 drivers/net/wireless/realtek/rtw88/sdio.c     | 1242 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h     |  175 +++
 drivers/net/wireless/realtek/rtw88/tx.c       |   41 +
 drivers/net/wireless/realtek/rtw88/tx.h       |    3 +
 include/linux/mmc/sdio_ids.h                  |    9 +
 24 files changed, 1763 insertions(+), 46 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

-- 
2.39.0

