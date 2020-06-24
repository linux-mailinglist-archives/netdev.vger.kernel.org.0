Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973212074F7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390916AbgFXNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389484AbgFXNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:55:35 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2004C0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s28so1540294edw.11
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1zAOdZm7Qj9V094J0F+nxMLOJGRCtjmRtSPDzUo9vs=;
        b=rRLUJiuoYToKI9r0oVHkOca6kLuMPvh7W1ZOImleg/YjTZg3bZMx0OenzWTiosdh89
         SlrxUfvcB4LkjS9RcX9Nq3Y9E06n40mZpb3FI+rWwPsT2uuW39sWnnJyRJSPkuJvor9a
         ZrqPBxZfaKdoafXEA5vm63h05OyCqjZqPAZt7455ohIP/7Bzvdes6ddkNzv9XioW8bkR
         r7nhvAwJABLCdTcTgpMbDLcULTrETA+EJfDSsyuu7YtMZw3YDDYMJMX1dsH+JETmoyWQ
         a0oKy9x4OlhH4lJ4Fakvf14OWJkAyVIqBOPfgwD9PZpP3U+rMYB8v35q7CdPq5ivZlrn
         5NNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1zAOdZm7Qj9V094J0F+nxMLOJGRCtjmRtSPDzUo9vs=;
        b=ZMYhomQg4ebET9CjY9okozYWzKd0QdLy4V20Kw5HH2wt+6Ai/kIKwBCnhhrRcNEQBe
         slyeD1d0nJK1Qn1s5pCm/brvUKjD2NTYk5EihnHrNjpUL4V3/43A8ciqh5uYxWJHWFLn
         SJP8qaTJqgCCeNKh428otfhhXwqIglFyeDfAVXjr020gnXRZJCJC7ITo5SHRhPIwrtfe
         9eeN//rHYHIoAm9en3qJ3j/j3zWtDe04UfA62m4SbpaDfOmOf5cVhykvqMZNXOELzc9V
         3QGZ40i0tjhrhPe8hse6aJqYYMteM/xUKc9vfhxgIyVQ78ogHXs1IiIf7kUlnrpsR9oD
         zNBw==
X-Gm-Message-State: AOAM531L4j0f9Fa2HPSVUCHtk7QhAa4XfIGfUvtEkNwRzy6Fu2sPBJSU
        LKpttxH+o5nhJPSPB0NjhD6cQLa6
X-Google-Smtp-Source: ABdhPJyI7mqJBdee6YEuJI50j5FBh68nCIdv34Px60TXYX2EhO70gn7tqyyuiZ1BwiFpZfVobjcNVw==
X-Received: by 2002:a05:6402:3069:: with SMTP id bs9mr26201690edb.194.1593006932360;
        Wed, 24 Jun 2020 06:55:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id j5sm17756649edk.53.2020.06.24.06.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:55:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        po.liu@nxp.com, xiaoliang.yang_1@nxp.com, kuba@kernel.org
Subject: [PATCH net 0/4] Fixes for SJA1105 DSA tc-gate action
Date:   Wed, 24 Jun 2020 16:54:43 +0300
Message-Id: <20200624135447.3261002-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series fixes 2 bugs in the tc-gate implementation:
1. The TAS state machine keeps getting rescheduled even after removing
   tc-gate actions on all ports.
2. tc-gate actions with only one gate control list entry are installed
   to hardware with an incorrect interval of zero, which makes the
   switch erroneously drop those packets (since the configuration is
   invalid).

To keep the code palatable, a forward-declaration was avoided by moving
some code around in patch 1/4. I hope that isn't too much of an issue.

Vladimir Oltean (4):
  net: dsa: sja1105: move sja1105_compose_gating_subschedule at the top
  net: dsa: sja1105: unconditionally free old gating config
  net: dsa: sja1105: recalculate gating subschedule after deleting
    tc-gate rules
  net: dsa: sja1105: fix tc-gate schedule with single element

 drivers/net/dsa/sja1105/sja1105_vl.c | 327 ++++++++++++++-------------
 1 file changed, 167 insertions(+), 160 deletions(-)

-- 
2.25.1

