Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEBB14334B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgATVPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:15:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44574 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:15:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so948571wrm.11
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4oXytMPdEANUsQRQNkRZ/o5/IqdLerjtd6+wQduYXZ4=;
        b=Cy8mQHph5Ep2Xhkunt0mqgoKb0TlqyITjFw9YGfAfwyLllgpvkh2QdZaIF8PqX73Pu
         JRJ0rvx4ssws9kOy9LtJLEMc6R/Bi62Ra08fN2el+p+knxs+dFugY244BUlDY/t9Umm2
         eyOBFmka1XWt941nPZIOALGg5x39kQPknFQRkhBfKmQ14jQaQOBnm7cc9c2ecfwBUk9j
         mt7bmYwG8O8TqJ+gK4rDm3vtV108nGUV01CoJ1bdk5xWGFu8UFGnjaHoeZHFuuFgWGOZ
         URhT+OtYdWD0MbnWBrKAZCjeZS978c99dhnfZ1MMDdhFgLcrJY/6QZCOGQchvINwZy2t
         HTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4oXytMPdEANUsQRQNkRZ/o5/IqdLerjtd6+wQduYXZ4=;
        b=GPYr30tru3r6lws3awAqRr2xF4kP+XKKTVy5bnx4wX38dg5oFncXWZg0QTG2R9qbVV
         p166O7uF/RG2KaBNAqP2jbIpIIBBWSNrE8bIDJaazrm6qEMeY9A7+QWz+Ee51JolLaW+
         VrhATwc02VoHxjTH06jPqL0OONSXJUW9i1BBzfCQgc/RixnRwEl+axPKRSvePboRq4RC
         FsxvvtYBlCl/GDOQjr1ZaMZBLAkY51cG9Q75BeUzqqkAq0WMSaZC6eZx981vA/MAwzkl
         mhXcW3szamObuaxxEEcZX1G/rBbMo8/5kQ7dcek1K9JnLGjaaaXo8HRubD0+rf6Zm8tL
         kYtg==
X-Gm-Message-State: APjAAAWtZguBOuA0BP8tONyxc7MaXkZecJjTxAEnZ/2YUn/xuysGM3mp
        5QRXLw/8Ak/cRFFRDP+GDbClbP+p
X-Google-Smtp-Source: APXvYqxT1QLDT8hYYfuCNfeOTZfDvICoOa9eYxGBZd6ZWWiAiDxov0H7AqkqVPjBzzHs1F/+f0gSRQ==
X-Received: by 2002:adf:ffc5:: with SMTP id x5mr1436027wrs.92.1579554920171;
        Mon, 20 Jan 2020 13:15:20 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id y7sm1555198wmd.1.2020.01.20.13.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 13:15:19 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: phy: add new version of phy_do_ioctl and
 convert suitable drivers
Message-ID: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Date:   Mon, 20 Jan 2020 22:15:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We just added phy_do_ioctl, but it turned out that we need another
version of this function that doesn't check whether net_device is
running. So rename phy_do_ioctl to phy_do_ioctl_running and add a
new version of phy_do_ioctl. Eventually convert suitable drivers
to use phy_do_ioctl.

Heiner Kallweit (3):
  net: phy: rename phy_do_ioctl to phy_do_ioctl_running
  net: phy: add new version of phy_do_ioctl
  net: convert suitable network drivers to use phy_do_ioctl

 drivers/net/ethernet/agere/et131x.c          | 11 +----------
 drivers/net/ethernet/atheros/ag71xx.c        | 10 +---------
 drivers/net/ethernet/faraday/ftgmac100.c     | 11 +----------
 drivers/net/ethernet/freescale/fec_mpc52xx.c | 12 +-----------
 drivers/net/ethernet/rdc/r6040.c             | 10 +---------
 drivers/net/ethernet/realtek/r8169_main.c    |  2 +-
 drivers/net/phy/phy.c                        | 12 +++++++++++-
 include/linux/phy.h                          |  1 +
 8 files changed, 18 insertions(+), 51 deletions(-)

-- 
2.25.0

