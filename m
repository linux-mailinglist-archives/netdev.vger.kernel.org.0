Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E511C39AF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgEDMoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728869AbgEDMoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:16 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65220C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:16 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so20767491wrq.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P1mEyIL5vEg6u5pCrGBAYF7mLdI7b9AvJ6K+q+MBIR8=;
        b=lVpRqugTJN9U6Cw8d127MB/j4bCd/YQZfgehWuPV9GzKwOP2FSkSq5gj2PyZKcNuqa
         98NO9jaBm7gWSLYsMwLCJKFrymrqMxtGbq4aOe375xz8NWP9sTZGa1dsFIrq56HgQ1Nt
         hrhqxo2NFuaQxpXQmm7PGU0tvgdJdIggJvx2rQcIcggggxf+LLZ5pW+ea2HiW4KiX0pc
         pInaprUHWiaM/Q2wx46OIz6hqA2OaQ8K6LDWb+mHaQU1nuM8F8oqsX0W5AcLwdNlBxKh
         bBLfi1F/XdcjoKJAhx3esmGYWnnPhaV32aHMYLtFRJJhk38DLieD3810VHMjgWMb1ZFz
         RTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P1mEyIL5vEg6u5pCrGBAYF7mLdI7b9AvJ6K+q+MBIR8=;
        b=I3yWzQMz3fS4k0C8b14xiNmwRWEsr8trpvincUVJDFWMjOd/rnVr8kSjuYjYnhJj7y
         pOVZQzDU6wMGHjQwuu/+iXtDZDRN5n+FmuNkbPDGLn0EM7ZfVamkzL1C42Tw+jBnBert
         0cQ5UGndY3xmgEHTI6s8qQOm98vUyf3Ubrais6xdJ21CG5E0rpAmzngsYOlhl+yfmB3R
         Kj6CaKhQpjlS3yhpRqJ8fBJpbWALSoYuqOGR8AMZbYelqTiCNmslYMz8HGf6W/QszFz7
         uqrS7qUPfOdPrsZUFTX8hunQPX7pieHEgraiEdaY+Gvkl1knOim0m17ngmdC6/PqC0qP
         yu2w==
X-Gm-Message-State: AGi0Pub6esl90vTRlqZNgQA78Rr4bVUv3JF7iQV11cUJ024DvmVF1v9z
        WyHX55IsIWBF9fUego5pbpM=
X-Google-Smtp-Source: APiQypISKPFo6N79jiL8d1Zj3krsLIx5pDhoW4jFRQ4KIN+Gd2DHpCSDWwV5N0IQuJNa83FnEl1/Xw==
X-Received: by 2002:adf:f786:: with SMTP id q6mr2620775wrp.120.1588596255151;
        Mon, 04 May 2020 05:44:15 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 0/6] Traffic support for dsa_8021q in vlan_filtering=1 mode
Date:   Mon,  4 May 2020 15:43:19 +0300
Message-Id: <20200504124325.26758-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is a draft for supporting as much as possible in terms of
traffic I/O from the network stack with the only dsa_8021q user thus
far, sja1105.

It doesn't support pushing a second VLAN tag to packets that are already
tagged, so our only option is to combine the dsa_8021q with the user tag
into a single tag and decode that on the CPU.

Posting this RFC only to get opinions on whether I'm way too deep down
the rabbit hole or whether this has a chance of getting accepted in
mainline. The assumption is that there is a type of use cases for which
7 VLANs per port are more than sufficient, and that there's another type
of use cases where the full 4096 entries are barely enough. Those use
cases are very different from one another, so I prefer trying to give
both the best experience by creating this best_effort_vlan_filtering
knob to select the mode in which they want to operate in.

Vladimir Oltean (6):
  net: dsa: sja1105: add packing ops for the Retagging Table
  net: dsa: sja1105: make HOSTPRIO a devlink param
  net: dsa: tag_8021q: allow DSA tags and VLAN filtering simultaneously
  net: dsa: tag_8021q: skip disabled ports
  net: dsa: sja1105: support up to 7 VLANs per port using retagging
  docs: net: dsa: sja1105: document the best_effort_vlan_filtering
    option

 .../networking/devlink-params-sja1105.txt     |  33 ++
 Documentation/networking/dsa/sja1105.rst      |  86 +++-
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |   4 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  33 ++
 drivers/net/dsa/sja1105/sja1105_main.c        | 415 +++++++++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   |  62 ++-
 .../net/dsa/sja1105/sja1105_static_config.h   |  15 +
 include/linux/dsa/8021q.h                     |  38 ++
 include/linux/dsa/sja1105.h                   |   4 +
 net/dsa/tag_8021q.c                           | 130 +++++-
 net/dsa/tag_sja1105.c                         |  35 +-
 12 files changed, 818 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

-- 
2.17.1

