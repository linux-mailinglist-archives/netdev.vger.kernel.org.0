Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244C76D87CB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbjDEUHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjDEUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E134C3F;
        Wed,  5 Apr 2023 13:07:38 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eh3so143955077edb.11;
        Wed, 05 Apr 2023 13:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=exrZyViPkoOx94plegkgtuiHtZ8ZlAwSXBuBbxC1EA4=;
        b=owC4MP3dr1KtLO215AZTPqDCxSTXyjyo/SEWZ0UHEt1Ex/di6Vf/uAW2pNPj3IEjvy
         uuYPNnRCcn0kCJ5usjTx+244dN0W+AqoD60wgsZeU0HAkdvrzC1lqMo8tC7DtFbzPbOR
         fUcjMN9/+dT1GLqi4vsQ5AILCsCGEjwyq6eRycteh2AK5E1xuluYnfBqK6/+/tgJIeNA
         Ew3WOsJECdoukq5kyNP2zGXfkqYAVTlA8QyAvN22bwAAsSkLuSyH4udDIelWsr5sSQme
         hrSlJzXkCEFHSLGRCVq6zA9xc8skam8q3OhfbLutukrek7K4aabaDmzC2YAaOw+wwV/A
         js8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=exrZyViPkoOx94plegkgtuiHtZ8ZlAwSXBuBbxC1EA4=;
        b=5Vwr2nS+5YuDeo7mN89wmaj+LIRu+nTIZ9O93mBuFfmcV7m7fXnMjToLmGKuuHMKp5
         /d7LjGz7GVYsCZNL5L0l2m3NAmZhTylS0jWGNmR4Fk05oynT+LU+Hj18L2bazSm/mxIQ
         na3iqAt8Qpmz2GEvqhA0mKQWE3W+PTdth5EeBHd0odD3V8MebJFMVOpgFXvzCPu3VYTm
         OCQVikrQL/q8JD5rEjhKLNL3XoYUJwp/nlALMgQx3IqPVK+HHCpG1Ni1DGyBDpu1GnPV
         enToJDVINGHTMJ78YzpSJIb4Xzku3fpfdQS4K9Mn/mEmDn3cju3fOJnLF2FaFVw//4I/
         IQDA==
X-Gm-Message-State: AAQBX9fkcC6rAxivBk+5jdSp6WidCKZP+z7zai29AzGxA5wsb3m7bwI9
        g6MaO+3D2gXWEQsGcSiW4q6rK6jqF5nfYw==
X-Google-Smtp-Source: AKy350Z7WaxHcbyUi4HMpQ1AIP2F/AdSgfJpilKsMLl9Gjyrm6rqI3zrvS9+PfFlrMXQvKrtW/IUCg==
X-Received: by 2002:a17:906:a409:b0:92b:f8ce:4e75 with SMTP id l9-20020a170906a40900b0092bf8ce4e75mr4391340ejz.72.1680725256204;
        Wed, 05 Apr 2023 13:07:36 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:35 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 0/9] rtw88: Add SDIO support
Date:   Wed,  5 Apr 2023 22:07:20 +0200
Message-Id: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
- RX throughput on a 5GHz network is at 19 Mbit/s (this seems to be
  an combination of the location of my board and the cheap antenna
  which are both hurting RX performance)

A user shared his results on his own RTL8822CS off-list with me:
- 50Mbit/s throughput in both directions

A user shared his results on RTL8821CS off-list with me:
- 50Mbps down and 25Mbps on a 5GHz network


Changes since v4 at [3]:
- use reverse xmas tree sorting for variables in patch 2 as suggested
  by Simon Horman
- small boolean statement simplification as suggested by Simon Horman
  (also affecting patch 2)
- fix typo in a comment in patch 2 as spotted by Simon Horman
- collect Pali's reviewed-by for patch 5
- collect Chris' tested-by for patch 9

Changes since v3 at [2]:
- fix rmmod / shutdown of the sdio.c module
- use IS_ALIGNED consistently in sdio.c
- direct/indirect read improvements which means that we can now read
  and write registers on older RTW_WCPU_11N cards. also this fixed
  potential IO issues with direct (instead of indirect) writes on
  SDIO 3.0 cards. thanks to Ping-Ke for the additional insights
- sorted SDIO ID entries by their value
- removed paragraph about RFC status of this series from the
  cover-letter

Changes since v2 at [1]:
- dropped RFC prefix as the majority of fixes were either addressing
  false positive smatch warnings, include ordering and other smaller
  fixes
- RX aggregation is now enabled for RTL8822CS as either the recently
  submitted firmware update for this chip has fixed the performance
  issue or an update of my wifi AP firmware. Either way: there's only
  a 5% difference in RX throughput in my tests now - compared to 50%
  from before
- fixed suspend/resume (tested on X96 Air with Amlogic SM1 SoC)
- build fix to not break bisectability

Changes since v1 at [0]:
- removed patches 1-8 as they have been submitted and separately (they
  were indepdent and this helped cutting down the size of this series)
- dropped patch "rtw88: ps: Increase LEAVE_LPS_TRY_CNT for SDIO based
  chipsets" as the underlying issue has been fixed - most likely with
  upstream commit 823092a53556eb ("wifi: rtw88: fix race condition
  when doing H2C command")
- rework the code so we don't need a new HCI specific power_switch
  callback by utilizing the RTW_FLAG_POWERON flag which was recently
  introduced
- various patches include the feedback from reviewers and build
  testing robots (see the individual patches for details)


[0] https://lore.kernel.org/lkml/a2449a2d1e664bcc8962af4667aa1290@realtek.com/T/
[1] https://lore.kernel.org/linux-wireless/20230310202922.2459680-1-martin.blumenstingl@googlemail.com/
[2] https://lore.kernel.org/linux-wireless/20230320213508.2358213-1-martin.blumenstingl@googlemail.com/
[3] https://lore.kernel.org/linux-wireless/20230403202440.276757-1-martin.blumenstingl@googlemail.com/


Jernej Skrabec (1):
  wifi: rtw88: Add support for the SDIO based RTL8822BS chipset

Martin Blumenstingl (8):
  wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
  wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
  wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
  wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
  wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
  mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
  wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
  wifi: rtw88: Add support for the SDIO based RTL8821CS chipset

 drivers/net/wireless/realtek/rtw88/Kconfig    |   36 +
 drivers/net/wireless/realtek/rtw88/Makefile   |   12 +
 drivers/net/wireless/realtek/rtw88/debug.h    |    1 +
 drivers/net/wireless/realtek/rtw88/mac.c      |   53 +-
 drivers/net/wireless/realtek/rtw88/mac.h      |    1 -
 drivers/net/wireless/realtek/rtw88/main.c     |    9 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |   12 +
 .../net/wireless/realtek/rtw88/rtw8821cs.c    |   36 +
 .../net/wireless/realtek/rtw88/rtw8822bs.c    |   36 +
 .../net/wireless/realtek/rtw88/rtw8822cs.c    |   36 +
 drivers/net/wireless/realtek/rtw88/sdio.c     | 1394 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h     |  178 +++
 include/linux/mmc/sdio_ids.h                  |    9 +
 13 files changed, 1804 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

-- 
2.40.0

