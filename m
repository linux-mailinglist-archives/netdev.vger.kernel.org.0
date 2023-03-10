Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DBF6B51DA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjCJU34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjCJU3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:46 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1223A11786F;
        Fri, 10 Mar 2023 12:29:45 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a25so25620494edb.0;
        Fri, 10 Mar 2023 12:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G6RMjj4HXLgRxvg6k3W2allczXLY1BGD7jCTuasoT2c=;
        b=Sb5FKk9n2gD3ey4gsm9jGqsSAw/agoabvmZRKotxa0OT3qHJO/V8OS1BRLsMlgR5Ol
         XH0fBmMXsQi99lFRIODLSdAXeR9IM8w+G439qXS2tN5OfSPv4rUmr0gAX7BM8r0+Cdp1
         S7gbT1vkNk+g8aKJ/KDojxR4UCpB/o9LzKFx0PsGpgZyH5MHreLYLAUsVJfmx5250SdQ
         A7YCJNsW+S22kgiziQCfF3uxiIT/NYjfpKPpctsgtykygMlBCJKz/WlRxpsUkFkzsgtX
         C2mrWT3mw/QzU/KvGBDXBS5t85yDAn1opkdvM6J37I3/F/h28j5wflHMLhuMWyI3LgrO
         oD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6RMjj4HXLgRxvg6k3W2allczXLY1BGD7jCTuasoT2c=;
        b=W1oMSGliFitwz/XpWWLDnfgYQrGEGCzwlesgZobSjNNUMD+O9cP4apBzggRgCVgUvJ
         CNHF0y55P4+tccCdG0/ZRZUCXrxSVRf7eVJp7l9o5NpKn9yYZHOyx1Efn8deeg6LijLK
         X9cV8LdANF4Y+NT4QEpaCKfUqxPm7fPN4pbc1rl+N7OGLGvonQUJODF65/g//HMN9Dgj
         9sw7aOV60DhnRgAvUSfLb5dtVTOlG3/tFyuQ51hs96j9w8lE0HXXTqXo42nPnPF6kdq4
         HRsO23xFdon4jsf1RTixWOIY4XuJgUDBEMWgBirWMy98veAVgPn7uBJsq96LL78z3/DT
         lgDg==
X-Gm-Message-State: AO0yUKUvhzZqDElWAi9K3QBpGrpEtzZn792c0zl71Gwt3Ze2HufeOX6P
        1wGGNyOQUbUa07C9Ke/Rrji4/D5lemo=
X-Google-Smtp-Source: AK7set8lbBDR9ubGt9HZWyB4HJ3DY4xiBOmnpA7WuaZleVsh35qBOy/fYpWwMgbUtE64mqy1Q+WrEw==
X-Received: by 2002:a17:906:6945:b0:8b1:77bf:3beb with SMTP id c5-20020a170906694500b008b177bf3bebmr27040633ejs.24.1678480183087;
        Fri, 10 Mar 2023 12:29:43 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:42 -0800 (PST)
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
Subject: [PATCH v2 RFC 0/9] rtw88: Add SDIO support
Date:   Fri, 10 Mar 2023 21:29:13 +0100
Message-Id: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
 drivers/net/wireless/realtek/rtw88/mac.c      |   51 +-
 drivers/net/wireless/realtek/rtw88/mac.h      |    1 -
 drivers/net/wireless/realtek/rtw88/main.c     |    9 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |   12 +
 .../net/wireless/realtek/rtw88/rtw8821cs.c    |   35 +
 .../net/wireless/realtek/rtw88/rtw8822bs.c    |   35 +
 .../net/wireless/realtek/rtw88/rtw8822cs.c    |   35 +
 drivers/net/wireless/realtek/rtw88/sdio.c     | 1251 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h     |  175 +++
 include/linux/mmc/sdio_ids.h                  |    9 +
 13 files changed, 1654 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

-- 
2.39.2

