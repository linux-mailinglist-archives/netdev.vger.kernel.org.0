Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684333D4A30
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhGXVHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:07:45 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:58398
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhGXVHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:07:42 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 0487D3F359
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163292;
        bh=G9KCxkZ1DdC15NET5kZk+LZOMEIZ/z14F2Hvsqu6jDI=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=ZJU0cdpCYfx3grk1C7T83yGbEWk07y1MEa4GZeIFZMT9b4zzOQd/OqzVpGBq+XWgu
         gUW/aTMt5Tc4kqXz4jIWBj1W41YNyfqErIbrx03Pa3eV9o7Kqb6Y3Py5YiEGOyP9lt
         cZerehvKvwKPbFqaKE/aagOt4RWK/XjxMoIP37uh+ErpjHq4QWBREmYCW2QTJzgGj/
         ZbpyQEq07eDgtRGpZs5hoQdGPuNrlKoPZ5da1CjrFQ6vA+Bag1jUjtgJxdyRRL5nC3
         I0c30CgTkZMayWkf1psaMVc8SpT3i0Cj+I40vWQtkAVp60646NB6eXS20DNfCVBrQT
         OQKytz+B60cbw==
Received: by mail-ed1-f69.google.com with SMTP id dn8-20020a05640222e8b029039ef9536577so2803541edb.5
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G9KCxkZ1DdC15NET5kZk+LZOMEIZ/z14F2Hvsqu6jDI=;
        b=Hysg/XOrwmwDiFjtVcC2qhGcfdtTn+UQ7tqswbU0/rDehjAZCvjsEPkcujbQckZvEA
         ZQxRzarimk6hcxPJmCEzkOGpqANHMjHU00B3q+FnB2YpF2G3jiusBoEsVWfSUoTfnkxb
         7vtTaWFcU3t9eQEOL278Ijj51MIPW2eje4YYVfMwvFuTp9Gi9NXmohcHVf8wOScBImPW
         cu1a0fj6aMaEGnnDEXw7grrQ8LW1fQNutjPuhz6LVO/jzTfjoFBS1GulvDYCYh/gVEEI
         F9mim3Q0GGpBvwtaGRw3NFHYgAMhdRdJi6Mch0W6sV0TkzdNj+jHE15LDaqkZuzE4t2c
         nytw==
X-Gm-Message-State: AOAM533jREsmUajp0lVhOM9wXzFfuKQXyhKDRxxB/Fouxn5rcn8NlPgW
        9dhWgQnl3FYYK41l5qXDuFkN3QLQZjscsVSbl6R/KvHbSZ+8kKY7k34p4t1JG44nSzxapdTJP/Y
        pe8SnoYnj2zPVh85V5Jv4DNhrr/PjIBesAQ==
X-Received: by 2002:a17:906:8047:: with SMTP id x7mr46582ejw.453.1627163286813;
        Sat, 24 Jul 2021 14:48:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOmFVBri8CQWcWZUF1IqokLpZwOavdWOwnGXxKa0UI7mA9/SGqL9hAGuBdFfYDwRxhCsOSoA==
X-Received: by 2002:a17:906:8047:: with SMTP id x7mr46579ejw.453.1627163286677;
        Sat, 24 Jul 2021 14:48:06 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id j5sm8383005edv.10.2021.07.24.14.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:48:06 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 00/12] nfc: constify data structures
Date:   Sat, 24 Jul 2021 23:47:31 +0200
Message-Id: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Constify pointers to several data structures which are not modified by
NFC core or by drivers to make it slightly safer.  No functional impact
expected.

Best regards,
Krzysztof


Krzysztof Kozlowski (12):
  nfc: constify payload argument in nci_send_cmd()
  nfc: constify nci_ops
  nfc: s3fwrn5: constify nci_ops
  nfc: constify nci_driver_ops (prop_ops and core_ops)
  nfc: constify nfc_phy_ops
  nfc: st21nfca: constify file-scope arrays
  nfc: constify pointer to nfc_vendor_cmd
  nfc: constify nfc_hci_gate
  nfc: constify nfc_ops
  nfc: constify nfc_hci_ops
  nfc: constify nfc_llc_ops
  nfc: constify nfc_digital_ops

 Documentation/driver-api/nfc/nfc-hci.rst |  2 +-
 drivers/nfc/fdp/fdp.c                    | 11 ++++++-----
 drivers/nfc/fdp/fdp.h                    |  2 +-
 drivers/nfc/fdp/i2c.c                    |  2 +-
 drivers/nfc/mei_phy.c                    |  2 +-
 drivers/nfc/mei_phy.h                    |  2 +-
 drivers/nfc/microread/i2c.c              |  2 +-
 drivers/nfc/microread/microread.c        | 12 ++++++------
 drivers/nfc/microread/microread.h        |  6 +++---
 drivers/nfc/nfcmrvl/main.c               |  2 +-
 drivers/nfc/nfcsim.c                     |  2 +-
 drivers/nfc/nxp-nci/core.c               |  2 +-
 drivers/nfc/pn533/pn533.c                |  2 +-
 drivers/nfc/pn544/i2c.c                  |  2 +-
 drivers/nfc/pn544/pn544.c                | 13 ++++++------
 drivers/nfc/pn544/pn544.h                |  7 ++++---
 drivers/nfc/port100.c                    |  2 +-
 drivers/nfc/s3fwrn5/core.c               |  7 +++----
 drivers/nfc/s3fwrn5/nci.c                |  8 +-------
 drivers/nfc/s3fwrn5/nci.h                |  2 +-
 drivers/nfc/st-nci/core.c                |  5 +++--
 drivers/nfc/st-nci/i2c.c                 |  2 +-
 drivers/nfc/st-nci/ndlc.c                |  6 +++---
 drivers/nfc/st-nci/ndlc.h                |  8 ++++----
 drivers/nfc/st-nci/spi.c                 |  2 +-
 drivers/nfc/st-nci/vendor_cmds.c         |  2 +-
 drivers/nfc/st21nfca/core.c              |  6 +++---
 drivers/nfc/st21nfca/i2c.c               |  6 +++---
 drivers/nfc/st21nfca/st21nfca.h          |  4 ++--
 drivers/nfc/st21nfca/vendor_cmds.c       |  2 +-
 drivers/nfc/st95hf/core.c                |  2 +-
 drivers/nfc/trf7970a.c                   |  2 +-
 drivers/nfc/virtual_ncidev.c             |  2 +-
 include/net/nfc/digital.h                |  4 ++--
 include/net/nfc/hci.h                    |  6 +++---
 include/net/nfc/nci_core.h               | 12 ++++++------
 include/net/nfc/nfc.h                    |  8 ++++----
 net/nfc/core.c                           |  2 +-
 net/nfc/digital_core.c                   |  4 ++--
 net/nfc/hci/core.c                       |  6 +++---
 net/nfc/hci/llc.c                        |  2 +-
 net/nfc/hci/llc.h                        |  6 +++---
 net/nfc/hci/llc_nop.c                    |  2 +-
 net/nfc/hci/llc_shdlc.c                  |  2 +-
 net/nfc/nci/core.c                       | 25 ++++++++++++------------
 net/nfc/netlink.c                        |  2 +-
 46 files changed, 108 insertions(+), 112 deletions(-)

-- 
2.27.0

