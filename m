Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFF738E733
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhEXNQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhEXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34D1C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lg14so41704411ejb.9
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aXuWtku4Qd9j8P6Ea5mQn4gIChykotdehp8XnTnNVKo=;
        b=RXcnsZoIvMGHHFkLKMxYZwGakXVf6QoL0kEi8OwOkan+3Hu5kJGuRtmNkLm6lKfo50
         f+3UZSqy7gkjRegHKoCLIeXeiadkIRBDofbLYIQYynPVCUeR/dyf9vJc2XQPOSHlqPhK
         9MJlfcvsDfGbpp6JFss33fv6NegwbHsHwt4CV3cC/+CEdVEM7mHsv22pjWyR+xtslWL9
         f2oDltmYyBSOoHLM9x75rIPxeIKsG9NJNmB5PJcWqhiuFBRq4//vAeTrufRAk7p5rmxq
         iQMsElLH3oJMDZQ90oqyghSc0zIGDk4yqPntt9ePwXvhh14XI5c6BjUJyEQxYKDOLilj
         xhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aXuWtku4Qd9j8P6Ea5mQn4gIChykotdehp8XnTnNVKo=;
        b=Z2KwupC7RXkflA8i8MYpDIMcfpIMbyLDSvu99pBvghidtKIswiaM5F9PaESGC123p/
         sdGZkynH2NyRc4re7HXFYET88uHaesv44ma39fNSezxKHzO7GU0UaUvjhcGqQs7HEXXq
         GDlewhsP6JfLBp8UMGUEirIAwLaDsYbn0baJayI96Vn3Nv3+vwTv4vKT+CMqL0G7ntPq
         SHtm1eWQK4pfJ5YetpvM+wnl1lWFtuIloOsbKsZVPGx3inAzb6iqQWOHLsg0ymONOk2U
         i3LEcgD6a8b24QYJVNzrNsyG9R3QqlwEYugtNwWePK9jJCTdVOrn7ZWpzFagiWyIhor1
         9Sog==
X-Gm-Message-State: AOAM530DNL2T5vk7up7+30YolqMFro/BhKEzwr1o6R1C6ZS/eUoVOVuq
        xFYxzWLMfmovK74c5Tj4uE1iWZx4IMs=
X-Google-Smtp-Source: ABdhPJzzmGVMuIGIR2ZNxeeLNc6NtXmxb36e+lQdnatNRbOZB4yvtA1zyUW9IjT6ydpbgX9TiFAfQw==
X-Received: by 2002:a17:906:2ec6:: with SMTP id s6mr23085972eji.65.1621862082413;
        Mon, 24 May 2021 06:14:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/9] SJA1105 DSA driver preparation for new switch introduction (SJA1110)
Date:   Mon, 24 May 2021 16:14:12 +0300
Message-Id: <20210524131421.1030789-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series contains refactoring patches which are necessary before the
support for the new NXP SJA1110 switch can be introduced in this driver.

As far as this series is concerned, here is the list of major changes
introduced with the SJA1110:
- 11 ports vs 5
- port 0 goes to the internal microcontroller, so it is unused as far as
  DSA is concerned
- the Clock Generation Unit does not need any configuration for
  setting up the PLLs for MII/RMII/RGMII
- the L2 Policing Table contains multicast policers too, not just
  broadcast and per-traffic class. These must be minimally initialized.
- more frame buffers

Vladimir Oltean (9):
  net: dsa: sja1105: parameterize the number of ports
  net: dsa: sja1105: avoid some work for unused ports
  net: dsa: sja1105: dimension the data structures for a larger port
    count
  net: dsa: sja1105: don't assign the host port using
    dsa_upstream_port()
  net: dsa: sja1105: skip CGU configuration if it's unnecessary
  net: dsa: sja1105: dynamically choose the number of static config
    table entries
  net: dsa: sja1105: use sja1105_xfer_u32 for the reset procedure
  net: dsa: sja1105: configure the multicast policers, if present
  net: dsa: sja1105: allow the frame buffer size to be customized

 drivers/net/dsa/sja1105/sja1105.h             |  35 ++--
 drivers/net/dsa/sja1105/sja1105_clocking.c    |  36 +++-
 drivers/net/dsa/sja1105/sja1105_flower.c      |  13 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 156 +++++++++++-------
 drivers/net/dsa/sja1105/sja1105_spi.c         |  41 ++---
 .../net/dsa/sja1105/sja1105_static_config.c   |  13 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   7 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         |  14 +-
 drivers/net/dsa/sja1105/sja1105_tas.h         |   2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c          |   2 +-
 10 files changed, 201 insertions(+), 118 deletions(-)

-- 
2.25.1

