Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0407A1B51E2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgDWBej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:34:39 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CA3C03C1AA;
        Wed, 22 Apr 2020 18:34:37 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x23so3424171lfq.1;
        Wed, 22 Apr 2020 18:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DAjDO2syVihYfSYHVPHnBlRhOt9duNjgHctpjQ0ix6c=;
        b=eUVd8k2O2d2zxPxp8rFtZ7IDbc6v/LYYWEtLilnhk89o1oS1POopQeOtxW9hMjQyrg
         hnw/uKRLApQXMBqmHw/Wt1ybEHUXEO/j3o89rYQ66McADGjAU4fNtKTq2EaPMwpreHHd
         bXwGW7BOqm+gSJUhWf2JJAt2AEr2eKDsv1ao6iRVY3v24ywl8+I3ExhuRUVChw7ndNmr
         Omd48AdkdaZ/KhfwVtv3jM/KGdyyGL4+zhSwzouhXsYP2T6uJLH22W/sYD184aEu+sCF
         qaA0MweY69Y5u+ZdsvkDLb8XI4t27jeR3Y5DYLWq+tQJWM9QY2KbDHod5HHOL/FRyekp
         dPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DAjDO2syVihYfSYHVPHnBlRhOt9duNjgHctpjQ0ix6c=;
        b=JFBOPHlJXmorpcAWw8baAoQhv2uFR+YrT8gkkI67rR2TYX4sGj2N2Ljo9KC1xDOk60
         K8ey5apnP3Z5Hd7PsNCU+wVKYKp6bS1j9uqaglTgw0DRIaGPiGueVMCYRgPQ/wl6BKlD
         INhUx8E5zSueCxEXEEpmshE0cuy2y1xSiABo8N+kQ6hEGhPqMeeZ17SECt41MBMnMmok
         F1qgn4+0a/yNW5cVImOCgV2HfRvrSiPOHVBBZ77iNDBZsWUyY4ZKpJonWuHRazd7XUMr
         lvsaXHhF9Mpi92oFmuBuXq22LUN0ed2scXoZMzAWu6gNt3W4VARsxPkxBh7NXdvPitV0
         pt+Q==
X-Gm-Message-State: AGi0PubDDIJ+VBkSg2FyMbevtE29hHp8hI4LFevKpe32BBrphV+IV2Za
        qR2btzHK/hqlmXfJp3M6i/Q=
X-Google-Smtp-Source: APiQypLVF8k5uqxjiwCBFvVf1xeH58dehjnKwlyRN+zx1HBI6paxUET+mG4Tcr86VknKMveN0sPEbg==
X-Received: by 2002:a19:946:: with SMTP id 67mr848245lfj.142.1587605675892;
        Wed, 22 Apr 2020 18:34:35 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id h21sm564967lfp.1.2020.04.22.18.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:34:35 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Christian Hewitt <christianshewitt@gmail.com>
Subject: [PATCH v2 0/3] Bluetooth: hci_qca: add support for QCA9377
Date:   Thu, 23 Apr 2020 01:34:27 +0000
Message-Id: <20200423013430.21399-1-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Hewittt <christianshewitt@gmail.com>

This series adds a new compatible for the QCA9377 BT device that is found
in many Android TV box devices, makes minor changes to allow max-speed
values for the device to be read from device-tree, and updates bindings
to reflect those changes.

v2 changes: rebase against bluetooth-next

Christian Hewitt (3):
  dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
  Bluetooth: hci_qca: add compatible for QCA9377
  Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices

 .../bindings/net/qualcomm-bluetooth.txt         |  5 +++++
 drivers/bluetooth/hci_qca.c                     | 17 ++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.17.1

