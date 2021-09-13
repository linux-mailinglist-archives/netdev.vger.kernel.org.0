Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F1F408D27
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbhIMNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:23:34 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33816
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240929AbhIMNV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:21:58 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 757BD40267
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539241;
        bh=q1oAxRnHPjktEWHzE6nf5nzfFGa2oa1TQ40ADKZqt7E=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=aRcZGPEKgySaylI75jb8nJAkdGYSIxPfpVOl9Ds0/jKcQI7AEJ66R6q8WqVGM4PB0
         tgPEA8wfYI3/UrFWnrbKXJdBTMpIjp0cdtEDkxbLhp9a2jg9FvyeKUqI25jQ63X6LB
         l4OAFyFuK85269qiQ0YW99a3IK9zgYt4c7abaDDKrdCEgIiOhDKJE80HmV0a1OrrUo
         8qAfqa/8KPLjCF+hqSMGtkMo4JnLvx/95TRbQ0HM4/87futXm2xLbmOoBjnZvuWcFn
         o3VBs70swyVj+L+u8clnhUtXqfNkoSPz2zrl57+nkaRbyMo5r8Hgo6D27abp+2Fxs8
         q+nv3UoZ2jsHA==
Received: by mail-wr1-f72.google.com with SMTP id r5-20020adfb1c5000000b0015cddb7216fso2581778wra.3
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q1oAxRnHPjktEWHzE6nf5nzfFGa2oa1TQ40ADKZqt7E=;
        b=7MHzvrHOPsJONa4/SWRIUQRugm/dLyzAfCXXsz/sPBAvgVEBi3f1uXbEpSZSIs7C+J
         0zq3vK3OjL9yHVS2JraGh3VKCNRxBqZqlDaSicGtqUzpNxMeVIvVACz0EEnPBhSImM1q
         u5GRvOhtD954HNUCbcBbTwknVX17/u+jTqTIN3R1X7Gd0MAUnou8MBD8o2wA0LheQvJZ
         JBEU2PaNr1GcWS3Gat7Z3eGlJkQ1L4vZb2xYUZR47CcvKdClAhEZdX9MDBY0aLb4X++q
         VzwJptzRUCG+7JoA54mClW/jnTJpYCHKRnAZSYexXLBuCg1pqaBabGWTTE3bC73JhTbL
         vTzg==
X-Gm-Message-State: AOAM531AKsQBGitMkOSyj2NOSYwmxWhAsfJAi0vM59HU3GhSOzQNDe6h
        TClWNA1uDWwBRoBMj6QPg0eXEKXIMI7vI+G8IERqtanZ5Drt9djjWZOI4BY4G72VCbZRCy5Op8+
        uGpuYHjIatHnH2WJMVZ6aRgUhCR8rP0LlVw==
X-Received: by 2002:a5d:6792:: with SMTP id v18mr12575244wru.416.1631539241172;
        Mon, 13 Sep 2021 06:20:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTOtZe+s81L7x4FZ5sAOlsPP679r7GY65Ei3OGctm0ZlMIdQFVPXzyTPmiKUdFX6lmNBgSKQ==
X-Received: by 2002:a5d:6792:: with SMTP id v18mr12575229wru.416.1631539241031;
        Mon, 13 Sep 2021 06:20:41 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:40 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/15] nfc: minor printk cleanup
Date:   Mon, 13 Sep 2021 15:20:20 +0200
Message-Id: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes since v1:
1. Remove unused variable in pn533 (reported by kbuild).

Best regards,
Krzysztof

Krzysztof Kozlowski (15):
  nfc: drop unneeded debug prints
  nfc: do not break pr_debug() call into separate lines
  nfc: nci: replace GPLv2 boilerplate with SPDX
  nfc: fdp: drop unneeded debug prints
  nfc: pn533: drop unneeded debug prints
  nfc: pn533: use dev_err() instead of pr_err()
  nfc: pn544: drop unneeded debug prints
  nfc: pn544: drop unneeded memory allocation fail messages
  nfc: s3fwrn5: simplify dereferencing pointer to struct device
  nfc: st-nci: drop unneeded debug prints
  nfc: st21nfca: drop unneeded debug prints
  nfc: trf7970a: drop unneeded debug prints
  nfc: microread: drop unneeded debug prints
  nfc: microread: drop unneeded memory allocation fail messages
  nfc: mrvl: drop unneeded memory allocation fail messages

 drivers/nfc/fdp/i2c.c          |  1 -
 drivers/nfc/microread/i2c.c    |  4 ----
 drivers/nfc/microread/mei.c    |  6 +-----
 drivers/nfc/nfcmrvl/fw_dnld.c  |  4 +---
 drivers/nfc/pn533/i2c.c        |  4 ----
 drivers/nfc/pn533/pn533.c      |  4 +---
 drivers/nfc/pn544/mei.c        |  8 +-------
 drivers/nfc/s3fwrn5/firmware.c | 29 +++++++++++-----------------
 drivers/nfc/s3fwrn5/nci.c      | 18 +++++++----------
 drivers/nfc/st-nci/i2c.c       |  4 ----
 drivers/nfc/st-nci/ndlc.c      |  4 ----
 drivers/nfc/st-nci/se.c        |  6 ------
 drivers/nfc/st-nci/spi.c       |  4 ----
 drivers/nfc/st21nfca/i2c.c     |  4 ----
 drivers/nfc/st21nfca/se.c      |  4 ----
 drivers/nfc/trf7970a.c         |  8 --------
 net/nfc/hci/command.c          | 16 ----------------
 net/nfc/hci/llc_shdlc.c        | 35 +++++++++-------------------------
 net/nfc/llcp_commands.c        |  8 --------
 net/nfc/llcp_core.c            |  5 +----
 net/nfc/nci/core.c             |  4 ----
 net/nfc/nci/hci.c              |  4 ----
 net/nfc/nci/ntf.c              |  9 ---------
 net/nfc/nci/uart.c             | 16 ++--------------
 24 files changed, 34 insertions(+), 175 deletions(-)

-- 
2.30.2

