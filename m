Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D553264A7B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIJQ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbgIJQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:57:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B265C0617BC
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:03 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n22so7011235edt.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fAH3AMhZDn1R/+5bvFy6azffVwmUepN6/YxtDPdESyA=;
        b=uJW/E9SJT2701cUrRXFteP6wxau2rdA+MJ+tAsOkWo608TslSKo+7dgbUOQbB1dQOq
         wYix776IeKg3c/ASGg/Zx4gOUOibM0XX8Ukt3S40wVzhoWX+LsJvBlBqAhpoj6X3fNH5
         VkXqSLCWC13Wausj/K+sccKWWciJDQcrcq5trBCgqVCFfaCV5SDB5ocdFcyzvimkyknJ
         np2uh4Us6t4cCtdA1jn8obT+UoghIpxeFDPXa7EfiVjUAJHJhG5lgpX49/oiam9DsPHX
         FVC90mQL7VjSxZyN3Z6JGZjsIdRsuNKh9q1fNGnrctB2heJFH2lflDiNMjNcbNajbfaG
         HvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fAH3AMhZDn1R/+5bvFy6azffVwmUepN6/YxtDPdESyA=;
        b=UB2ENeRvapVi2T3mPwYy6U3wxP1dIGf7wAODNvVZxI8zJtG3zeIq6ydo34rjHW97H6
         vYHVwLzAJVQT5Vj+YLtfpS5xN4G2FWsJonH34I7mP2I5zvriYOOE4kNeYE6IGYCniyKa
         R9jCfwjXUpfRcTxK+ftUCxSIhVU1r4nm+gH+Rp9Kkg+BFSUs50GXGl80VEpBLfPYZb/O
         s+Pfzfe2ODMg0kgp9YudzHNroqSR9lystjxHhw6YGyPqHxLicNUCsClzq4uGO2lpKI9u
         aw9EV9swBYsAxb5VSPokC3GPzbT3ZY7sD5h0QRoYtfnq9goS1RduYkS6i7QqxQY+QVMq
         ZIYw==
X-Gm-Message-State: AOAM530yvX/A6SmrcsdfqkNhwMlLS+6DYiMUdZ1qJFKgDJe+2ART5kfj
        GGERnqsEkuUoEveoxWy9NRM=
X-Google-Smtp-Source: ABdhPJyXd2PnJ1aEf2mqTsorxNxVDGD8VSx12i8mBt9tOit5JsBaWHvZ0pt4+/OMSt6wuS39weQ6hg==
X-Received: by 2002:a05:6402:1495:: with SMTP id e21mr9974987edv.146.1599756542197;
        Thu, 10 Sep 2020 09:49:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o93sm8108024edd.75.2020.09.10.09.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:49:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] DSA tag_8021q cleanup
Date:   Thu, 10 Sep 2020 19:48:53 +0300
Message-Id: <20200910164857.1221202-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series tries to consolidate the VLAN handling in DSA a little
bit. It reworks tag_8021q to be minimally invasive to the dsa_switch_ops
structure. This makes the rest of the code a bit easier to follow.

Vladimir Oltean (4):
  net: dsa: tag_8021q: include missing refcount.h
  net: dsa: tag_8021q: setup tagging via a single function call
  net: dsa: tag_8021q: add a context structure
  Revert "net: dsa: Add more convenient functions for installing port
    VLANs"

 drivers/net/dsa/sja1105/sja1105.h      |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 226 ++++++++++++++-----------
 include/linux/dsa/8021q.h              |  49 +++---
 net/dsa/dsa_priv.h                     |   2 -
 net/dsa/port.c                         |  33 ----
 net/dsa/slave.c                        |  34 +++-
 net/dsa/tag_8021q.c                    | 138 ++++++++-------
 7 files changed, 265 insertions(+), 220 deletions(-)

-- 
2.25.1

