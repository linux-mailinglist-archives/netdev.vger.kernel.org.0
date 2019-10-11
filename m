Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54582D47DA
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfJKSsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728835AbfJKSs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 14:48:29 -0400
Received: from ziggy.de (unknown [37.223.145.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337552089F;
        Fri, 11 Oct 2019 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570819709;
        bh=8swxHPxXwsk63xATldrkBomTBYaZuw+x6D4lr+gw3V8=;
        h=From:To:Cc:Subject:Date:From;
        b=ISrrQafdLjqEAPF+R8koM/uakJvBlSuc24HmfYHMFOWl9AsNwJ5CB0u0jUyKxkUCO
         ZNj8pxOddSj1gEOC8yASbtNrCLYTTicLccjtmnVNYzSHmAqk7gDJ97bIuqSv+jL6bL
         24s7VtQk34AY+hD+h/PqnXNRQ8fLTgF3yxtmicnw=
From:   matthias.bgg@kernel.org
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Doug Berger <opendmb@gmail.com>, Eric Anholt <eric@anholt.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/3] This series adds ethernet support for RPi4.
Date:   Fri, 11 Oct 2019 20:48:18 +0200
Message-Id: <20191011184822.866-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

Raspberry Pi 4 uses the broadcom genet chip in version five.
This chip has a dma controller integrated. Up to now the maximal
burst size was hard-coded to 0x10. But it turns out that Raspberry Pi 4
does only work with the smaller maximal burst size of 0x8.

This series adds a new optional property to the driver, dma-burst-sz.
The very same property is already used by another drivers in the kernel.


Matthias Brugger (3):
  dt-bindings: net: bcmgenet add property for max DMA burst size
  net: bcmgenet: use optional max DMA burst size property
  ARM: dts: bcm2711: Enable GENET support for the RPi4

 .../devicetree/bindings/net/brcm,bcmgenet.txt |  2 ++
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts         | 22 +++++++++++++++++++
 arch/arm/boot/dts/bcm2711.dtsi                | 18 +++++++++++++++
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 13 +++++++++--
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  1 +
 5 files changed, 54 insertions(+), 2 deletions(-)

-- 
2.23.0

