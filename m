Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D877BB95
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGaIZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:25:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36853 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfGaIZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:25:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so68713417wrs.3;
        Wed, 31 Jul 2019 01:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjYY++Oj52N1EnyRbEN9KyQWKnxZJc8wkF23HftyvEg=;
        b=Z6uvUuIs297lVyxTd9i3Nisc1oE+haTrOheQZNabaXEhm101/SzjvCCbgJC5VFApSy
         vaxTs22DvbRLUvqDlfnKIgWr6gU7rqbOBzi1oabsOWZ7EamQUECghHo8zy5RSIwFiggt
         bUmo2rGJE/pFTkTcdXBpHM8dnWHxJ4kSD0Uo2LbcDxKvp4FaOR9lhBQxU20YhgEODUTQ
         qzeZIuagDo6MkBfRQ8SBs5BrZdZKRuTwSGC4d3r4yDnSwwPWS5ytMKZ7ARYxUVC8NAj/
         JMulxa6SMHFKENPRce7zy9K41UeyD2WzPw5LmPSN3AHyT8U9bkVIOnXFTM9zLitUfCr4
         OZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CjYY++Oj52N1EnyRbEN9KyQWKnxZJc8wkF23HftyvEg=;
        b=rdF7dMnLOE3NXnQuUbr9KluTSkTeZX5LM1Vz1E+QN+IGK1oALV2LLivD75NCtsjSx6
         ZYvNuGRq5ke9nHarZK/kdQJ8GUqQj1VGdL5sdenQSy8HUIV0OB4YQ5usxDB/0yfzjnlz
         6T4LQ++wVBJoH7T3pnWqga4QrD4Yy0+80qr7mUD8T/snlASqx5dlinxA09ADnROX4knb
         x+WJ3Chd3O5jxFvFnHsd3F67ayJV5eCmPmwEv/9h8Cr03b5Xb0uSjs1yCMEdQPghcSyU
         /GGuVVVDS1A5dyMvtXD4pMjjmPChYzN/lYOxLjKYFWBCmXHpDM420jZsj5pTmp9hNKij
         2ALQ==
X-Gm-Message-State: APjAAAUdgufCFqtf6PKTPUmDLSzyNlNOLs5qiVFk7w/kEfZ4OO9/XoKH
        QWHjt8OoMAeMUZ+BIIQETvrGNvLn26E=
X-Google-Smtp-Source: APXvYqxvsnRdIl7Zw1x4ILFCcllHcw9ziPN7lx74sQA7epi6alHZJrsJ615cEEHm4bTRExn4NhNj5w==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr49557198wrv.247.1564561543490;
        Wed, 31 Jul 2019 01:25:43 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c78sm93223959wmd.16.2019.07.31.01.25.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 01:25:42 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 0/6] net: dsa: mv88e6xxx: add support for MV88E6220
Date:   Wed, 31 Jul 2019 10:23:45 +0200
Message-Id: <20190731082351.3157-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the MV88E6220 chip to the mv88e6xxx driver.
The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
not routed to pins.

Furthermore, PTP support is added to the MV88E6250 family.

v2:
 - insert all 6220 entries in correct numerical order
 - introduce invalid_port_mask
 - move ptp_cc_mult* to ptp_ops and restored original ptp_adjfine code
 - added Andrews Reviewed-By to patch 2 and 4

Hubert Feurstein (6):
  net: dsa: mv88e6xxx: add support for MV88E6220
  dt-bindings: net: dsa: marvell: add 6220 model to the 6250 family
  net: dsa: mv88e6xxx: introduce invalid_port_mask in mv88e6xxx_info
  net: dsa: mv88e6xxx: setup message port is not supported in the 6250
    familiy
  net: dsa: mv88e6xxx: order ptp structs numerically ascending
  net: dsa: mv88e6xxx: add PTP support for MV88E6250 family

 drivers/net/dsa/mv88e6xxx/chip.c |  49 ++++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h |  15 +++++
 drivers/net/dsa/mv88e6xxx/ptp.c  | 106 ++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/ptp.h  |   6 +-
 4 files changed, 147 insertions(+), 29 deletions(-)

-- 
2.22.0

