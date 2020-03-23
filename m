Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAD5190174
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgCWW7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:59:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52417 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWW7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:59:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id z18so1309277wmk.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8B8Ss0XpXrLzjCjQoE2oOuQ3FGgbeDoc8BpGtpOsn7Y=;
        b=hOd4hFLeFHrYTBfZxJOfWdWnnvzsigYjdxdycWDrvOA/FgzsNZS/KpuVt+1KtAV2wJ
         iFUGPIVaglqlYRmA6w3ejlBYrqt+LaMWNVaqMBGc6O0Ocn8buJ4r9kf1eGTlWuJmNwAi
         f5xDmnWrhhebYy35zhjf9Rh1J5CBjkWRroBtZ31u0vdj8o5h2YPUykMBcLtLrPeLRW++
         T8d9ukc85mKrJEWRjPgpLkDUduyy6cnYu0iqGZws/3JlZh2O7JuhcloDBdRqvo7Avj9z
         59R8twDfYrtlJxzlGeXL1a7MqgdY6rTcKzNf45P3fuIJlUM4fO1ivZTNWIE1CLLy7lSC
         f9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8B8Ss0XpXrLzjCjQoE2oOuQ3FGgbeDoc8BpGtpOsn7Y=;
        b=fXIfLEnTqyP7UaQOV0KpCldwxdGBVYXFJPXL/IwAEjWQAnsSoi9ZmRWpmpiaiTTUmV
         bCdn9goRlp+87kTt9Joy/D0ZVTuMQuJmRFO9WsV1bA6MDOi6oXOuSRa7JX5AtFEQAiaK
         ORRGI7CCVNe6vgaS+OFRxReRhoz6jZ5dXRCDInopoPhX7kCrLC4v0e/+r/Mhe91C+wPH
         bflc1ecO1pWohrRrVTMJ5QFJicGcCFNQKxitGtMYJS0xIaESEEhgtUairDac9dx+2NVN
         okybEguSahAWNtvnOIUag8Jy7Uz0hbXIcZqTRs6CGtkP8s84ToXnko11BWky66D93L8U
         Wiww==
X-Gm-Message-State: ANhLgQ3Z23EvuAJY6noilKQfW+XMbrRm15y02WeBqX40EWLoa5AXSY0Z
        owYqevo9I5AfZVtvDxFf4c7OtQeHQXuEXw==
X-Google-Smtp-Source: ADFU+vsIdpP4hJ0kx0lPj83FrGYET99YsD46tD9cE6cDqqaTBmZH09wD2G0l/axi2o1jtSn0siVm2A==
X-Received: by 2002:a1c:b356:: with SMTP id c83mr1915524wmf.10.1585004371300;
        Mon, 23 Mar 2020 15:59:31 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r3sm26332912wrm.35.2020.03.23.15.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:59:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] PTP_CLK pin configuration for SJA1105 DSA driver
Date:   Tue, 24 Mar 2020 00:59:20 +0200
Message-Id: <20200323225924.14347-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for the PTP_CLK pin on SJA1105 to be configured
via the PTP subsystem, in the "periodic output" and "external timestamp
input" modes.

Vladimir Oltean (4):
  net: dsa: sja1105: unconditionally set DESTMETA and SRCMETA in AVB
    table
  net: dsa: sja1105: make future_base_time a common helper
  net: dsa: sja1105: make the AVB table dynamically reconfigurable
  net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT

 drivers/net/dsa/sja1105/sja1105.h             |   5 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  24 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  40 +++
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 285 +++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  31 ++
 drivers/net/dsa/sja1105/sja1105_spi.c         |   5 +
 .../net/dsa/sja1105/sja1105_static_config.c   |   5 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   1 +
 drivers/net/dsa/sja1105/sja1105_tas.c         |  27 --
 9 files changed, 355 insertions(+), 68 deletions(-)

-- 
2.17.1

