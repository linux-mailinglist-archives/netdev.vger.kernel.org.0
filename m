Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657136C23D0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjCTVgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCTVgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE76BEC40;
        Mon, 20 Mar 2023 14:35:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i5so5445687eda.0;
        Mon, 20 Mar 2023 14:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679348122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2UnmpqwKVAU8oeRsfpYY5D9iVmuh2uYDzzxMIpO1jg=;
        b=BwZ4L+ER5q/vgZc5gSLbKyOEKOPDzUSwGbdpv+Sz5/CSm35BzRHhK7CNYJboVMqMTV
         MKZpTW/rP+IUmnwp7TKZQRJJQOJ2XQj78xb+D6asJe3z+vNPx8tSFZln30WQ7odLNbI5
         XGres3/7PIjFDpyHzDtCUaUVhJaVhurftQ9s0yo+V4Cc2ScaEb+UsberOolpor3J8rvj
         7c4un2pvNnSOVv9L387+mTms153ZB/tseeKdsybE+o5aZ1Mn+Wi+h1m6Kpi/eZ3H6LdT
         FiL5W/3aGoyJ3t7K1AEIl1fIwhjMb+ngZG1hTGmgl0GaGqW6uTSa2uN/YmlNGVxPqQrg
         4/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2UnmpqwKVAU8oeRsfpYY5D9iVmuh2uYDzzxMIpO1jg=;
        b=UkYDCZFRpk104TpV/vi1bVYHQEkVAAwNWHvAVX6qPB+FKnOPxeIcCqFpL9tQBxC/F/
         HFUsyS1jXieauJ+41lIbZPcF5KrIM4E5emwud+HKs71PU7xL+8aEoZDZELDfqFj8/Mxl
         NaiQ3nZoZ6Ho5wcm/171/rTFnW/eqxx5Rcn3F1MadAO235l3n+ER6b+IS8XOkZWS8m2Y
         J7YS+tRKIkJBYFaB26ovERsLVbPW3o5oeqzXlnCbGfWSPwm+FkXRZuU8UuK36q7lKOOV
         1Jo+DTVK8j44JOZVHv8K3/dsM2Z9GtivDKxeOx6WKkXhlhSmKhHBIwPAKkEHa69XIqWj
         tKrg==
X-Gm-Message-State: AO0yUKUOk+PlLxvSYqY8QU+kpqOOZM7ajRpLZcxkXcIRVtCrl14OsdOv
        fcX0h9rcd0/zymzMiJzDFrDbeoe+WSs=
X-Google-Smtp-Source: AK7set/NcSCiD9cQbN3ezzEy6Kq+2dOLWAVKWRTXDCDsbrKj2HHf+tvsy9tLiB9j314ApBKHXuToKg==
X-Received: by 2002:aa7:d913:0:b0:4ac:d34b:c2a9 with SMTP id a19-20020aa7d913000000b004acd34bc2a9mr1077797edr.14.1679348122209;
        Mon, 20 Mar 2023 14:35:22 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-73dd-8200-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:73dd:8200::e63])
        by smtp.googlemail.com with ESMTPSA id z17-20020a5096d1000000b004aee4e2a56esm5413201eda.0.2023.03.20.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:21 -0700 (PDT)
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
        Larry Finger <Larry.Finger@lwfinger.net>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 0/9] rtw88: Add SDIO support
Date:   Mon, 20 Mar 2023 22:34:59 +0100
Message-Id: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
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
- RX throughput on a 5GHz network is at 19 Mbit/s (this seems to be
  an combination of the location of my board and the cheap antenna
  which are both hurting RX performance)

A user shared his results on his own RTL8822CS off-list with me:
- 50Mbit/s throughput in both directions

A user shared his results on RTL8821CS off-list with me:
- 50Mbps down and 25Mbps on a 5GHz network

Why is this an RFC?
- I think it's worth to get another round of feedback from the rtw88
  maintainers
- As with most patches: testing is very welcome. If things are working
  fine then a Tested-by is appreciated (with some details about the
  card, throughput, ...). If something doesn't work for you: please
  still report back so we can investigate that problem!


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
 drivers/net/wireless/realtek/rtw88/sdio.c     | 1252 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h     |  173 +++
 include/linux/mmc/sdio_ids.h                  |    9 +
 13 files changed, 1657 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

-- 
2.40.0

