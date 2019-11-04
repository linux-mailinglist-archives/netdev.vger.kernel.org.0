Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936A5EEBE3
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbfKDVvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:51:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43920 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730600AbfKDVvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 16:51:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so18876368wra.10
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 13:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YH+66H3pr0wX9j3AM2k8jyzoPr8DfMqdC68kDe9KGyo=;
        b=MMMYAIhcJG6aScMn2rRtV9ZGpxkgE29LgKKsavByvywPvqGUwzaTgq0vCEifvFzzQk
         XGxxooiMMBE12GGkCoAExDK3jsPIzirwk31ZMT/EBcTehsJ8xwp4+rDSQq+h8B23rmt6
         m8NCy6u85o+6fVhrfTdbtITw84amfY+SZyoxHVcGaQPOnBPgu6/s0cyCFXcfaiKvCUgc
         mkNUklqebt7iQ6HgsVMty3NPxqspu88fxNwulS8q+MAquXiVC8dhXNJfi8CHXvHosAa3
         I1i7d6r5IpxQPBMsrznHEz2MgB1/EaGf7qzDWkRWJZ6XvQK5X3QBgubmKIa7aHXvoXas
         06RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YH+66H3pr0wX9j3AM2k8jyzoPr8DfMqdC68kDe9KGyo=;
        b=j4KIxgmBIjUVHOx295rSN8RLGkQsuKikt0uPUmBxoOgA0KKjzLQTrfyW3gQZn9kdMN
         4XefM+EDaQfveSGYG30DkhbXxAFF9Bh7CpOVet9XH5HDbVuofGMiLc9yozCCmyZvbiID
         8wkCkYl7dX1gUZBsJAL0upsbWfQl6SHOkaz3QnuXGAnTC069pkuFs+f+miIhXlpCiNwf
         Vn4M5xDL+j/ZhDLjhZ9f5AYxmGiVw7jw8wZPzOFyTap/+PFG0KJ/CnALPxUU6mocAADs
         pdoctqxvvydjHNG10CS5T5rp+DuMZUzz9SDTKBdnyJpRyF0I+HkqVfSgLcmQLirwUSkD
         Gh2w==
X-Gm-Message-State: APjAAAXpmkK0nbJUR8aI04frhFEpkZzyU5J/xgq5g4MrCGh1YyYU7DbQ
        8sqIyHcenlCVWvgbg2U/rNFf/7ys
X-Google-Smtp-Source: APXvYqyo3S/6ROPA9yaqRGQ11nOdvakjhRTX4CU1KN1Bzkb7tqfkSWvUc0ZQZpCiRURu5Ws4qN0skw==
X-Received: by 2002:adf:e9c7:: with SMTP id l7mr25426517wrn.57.1572904305047;
        Mon, 04 Nov 2019 13:51:45 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t133sm21439302wmb.1.2019.11.04.13.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 13:51:44 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v2 0/2] net: dsa: bcm_sf2: Add support for optional reset controller line
Date:   Mon,  4 Nov 2019 13:51:37 -0800
Message-Id: <20191104215139.17047-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Vivien,

This patch series definest the optional reset controller line for the
BCM7445/BCM7278 integrated Ethernet switches and updates the driver to
drive that reset line in lieu of the internal watchdog based reset since
it does not work on BCM7278.

Thanks!

Changes in v2:
- make the reset_control_assert() conditional to BCM7278 in the remove
  function as well

Florian Fainelli (2):
  dt-bindings: net: Describe BCM7445 switch reset property
  net: dsa: bcm_sf2: Add support for optional reset controller line

 .../bindings/net/brcm,bcm7445-switch-v4.0.txt |  6 ++++++
 drivers/net/dsa/bcm_sf2.c                     | 19 +++++++++++++++++++
 drivers/net/dsa/bcm_sf2.h                     |  3 +++
 3 files changed, 28 insertions(+)

-- 
2.17.1

