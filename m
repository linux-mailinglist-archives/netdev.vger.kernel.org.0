Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B4DB6A96
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbfIRSf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:35:58 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36178 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387586AbfIRSf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:35:57 -0400
Received: by mail-io1-f65.google.com with SMTP id b136so1608888iof.3;
        Wed, 18 Sep 2019 11:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y0ZbiMWzuVtjfJ0MNgVp3pIWOMCNszyb+paLaeLgqw4=;
        b=c5kYpaBgC6qnxcLnl7dtDuyJM/ucCt1IkUpvlTkAdWDjn+4HMtSvqQ6dddidNimYKz
         4ct9O28YUvl61Na+RTnvpkNffJE/M5cAZrpExdaWZcpXeXnlh+rdY1Mcz2njV4sp3CLd
         O/IdPNH8uDyauOI1s7O7/Fd4mW3KBUmNvjVU8h3bWgaS9kEap/sS1HHoJksGxxmG/OyJ
         CtoR37RY2sJJVlNdj3CwmzXNDvw5X8nu9FPGGJ9tVg8sZ+KTrQMlmTygzM1oSb7SVVZr
         EWr0wznTMX/PmgiFF8muKq9vDgctYSC1mz+1gAZmnE8enOd5uZaH6FchzDch7KRYeJJA
         8Xig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y0ZbiMWzuVtjfJ0MNgVp3pIWOMCNszyb+paLaeLgqw4=;
        b=J5CKglWPBQDYl2QREer9wOiXcEcar6sloqZ8E+tnBWSzU2ZYpUkMijMmqL2IMn8HLa
         6BorbyRlRAbyhYxhnMmoCbKOfGBpXN0s4RD98COam87FM58BwFPtIIZoFJ9GQUv/ECSe
         MT3YIIm87LJapW0imdvzTkzg8Jgu0OvkRBMqZDcnbihWxKO8u9i8l+LLaE7aJWLSwJOZ
         /N9fuwoDFkRpN2/h0GizEwpt7xlddh3BTjBlkJPJzMo0bqNZiPYHfUOonKwwsbVc/ay8
         +Txp1M+2D6hiy4eRh1qw6flMNJkMYjdDmW4tUIL2pFYuY399NwZOkOYVC22wcw2oSRAI
         NF8Q==
X-Gm-Message-State: APjAAAV+jwza5oK+xc7RycH2H4fjxGf6G4fbngjET5XizZzOOdYmgjhF
        IzDKoSNRkxLsbGisLuckTqA=
X-Google-Smtp-Source: APXvYqwXcHDLbgxIHjLUqk9wNbIjPqYoLXb3R/BN/hRqZrhTEDPjIzDGSbJmh8ZF+w3D3DJTkyUu7A==
X-Received: by 2002:a6b:acc5:: with SMTP id v188mr6875202ioe.268.1568831756719;
        Wed, 18 Sep 2019 11:35:56 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id s201sm8348190ios.83.2019.09.18.11.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 11:35:56 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/5] Introduce fieldbus_dev configuration interface
Date:   Wed, 18 Sep 2019 14:35:47 -0400
Message-Id: <20190918183552.28959-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a (userspace) config interface for fieldbus_dev.
Add support for the HMS FL-NET controller, which requires config support, and
	is its first in-kernel user.

Sven Van Asbroeck (5):
  staging: fieldbus core: remove unused strings
  staging: fieldbus: move "offline mode" definition to fieldbus core
  staging: fieldbus core: add support for device configuration
  staging: fieldbus core: add support for FL-NET devices
  staging: fieldbus: add support for HMS FL-NET industrial controller

 .../Documentation/ABI/configfs-fieldbus-dev   |  90 +++
 .../ABI/sysfs-class-fieldbus-dev              |   1 +
 .../fieldbus/Documentation/fieldbus_dev.txt   |  60 +-
 drivers/staging/fieldbus/Kconfig              |  14 +
 drivers/staging/fieldbus/Makefile             |   5 +-
 drivers/staging/fieldbus/anybuss/Kconfig      |  17 +
 drivers/staging/fieldbus/anybuss/Makefile     |   1 +
 .../staging/fieldbus/anybuss/anybuss-client.h |  11 +-
 drivers/staging/fieldbus/anybuss/hms-flnet.c  | 520 ++++++++++++++++++
 .../staging/fieldbus/anybuss/hms-profinet.c   |   2 +-
 drivers/staging/fieldbus/anybuss/host.c       |   6 +-
 drivers/staging/fieldbus/dev_config.c         | 383 +++++++++++++
 drivers/staging/fieldbus/dev_config.h         |  41 ++
 drivers/staging/fieldbus/dev_core.c           |  28 +-
 drivers/staging/fieldbus/fieldbus_dev.h       |  56 ++
 15 files changed, 1211 insertions(+), 24 deletions(-)
 create mode 100644 drivers/staging/fieldbus/Documentation/ABI/configfs-fieldbus-dev
 create mode 100644 drivers/staging/fieldbus/anybuss/hms-flnet.c
 create mode 100644 drivers/staging/fieldbus/dev_config.c
 create mode 100644 drivers/staging/fieldbus/dev_config.h

-- 
2.17.1

