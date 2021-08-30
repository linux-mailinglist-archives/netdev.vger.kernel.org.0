Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B476B3FBE8E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbhH3VwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbhH3Vv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:51:59 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354B3C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:51:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p38so34316060lfa.0
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6D7C8KRAkhxxsIqhvNWrBv5HlP7UidVdExfZcYDeQJw=;
        b=SblI9iNNZ4Bdsmhn3qbjHRPQVgM+WSSDC5MTiBJoBIlJ4ETa3xU7sNB5rz6TsCgdCm
         lm3obWABS+/IjTN4SmUZk80GVLiogpAAgTenNi5DvmZNCJHRUkwPMFJ0RoRG+JE62Xek
         L1nkMldiTEAdN2Qj+kWHm/TKUQBhChMfN3ZXZXxb70eXBnmw6tNqtOQI02MDwGElpdVq
         oB8rO9IR9pgO1zSeC74Tgqq/vgDjRhtYfNbYeIWziBxCaNuoskBzkSDJh0he6XyHzfih
         tfat2Eu4AJhCeDcG9jcjTvZwmRhql3j761L+tbkXBqBudFY7jF2Ort1CpkF+nH7nbbj9
         oBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6D7C8KRAkhxxsIqhvNWrBv5HlP7UidVdExfZcYDeQJw=;
        b=muBAu6LeXRqRX539FP5sqwr+ME3MQcLBeEDWamKKLQP+PqmXuZYYLOCcvq2lrg33Fz
         pYM1az7PMrCJqP46vqRuMLxrch1ghw6cOM0VWII0VI+7W+yQnDKWC5axJnV8cwfriIOK
         H39ZLatbTE6rs+qt8Wi9wYgYkcvA8PlSBaN+9fJidzI21Txe1uynVhijXKgz5UdWmMof
         7a0maHv0mXBtMI7KXwWSBr5/w/hZFhFLI7UffKhV8I18sej5F5atL4f+SGIXv7aGqcjm
         CKPPiopD5YhW9ZkMoFGezhM7HVGVz6izKvVrEr9Jm2DEpK5RmQ7OLuQKhAqf1gVREUbE
         v/yw==
X-Gm-Message-State: AOAM5311VogMZtJj2HhjlbsFkFbPmZZlfcroW83q8bEQHbxZ9lh20uQ5
        EeCHWejnY7zng6LGXRIGR/e5mg==
X-Google-Smtp-Source: ABdhPJwF/EmWfxRNkPLFoDWAzJueKvuJifNTmOvnKCBSArja9IBqPmB6QY2o5pU4qlWw4AGMvG+Dag==
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr19574658lfq.250.1630360263519;
        Mon, 30 Aug 2021 14:51:03 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id h4sm1514049lft.184.2021.08.30.14.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:51:03 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/5 v2] RTL8366RB improvements
Date:   Mon, 30 Aug 2021 23:48:54 +0200
Message-Id: <20210830214859.403100-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few impromvents: the bridge offloading
support from Deng, then dropping of custom VLAN setup and
then some extended support suggested by Vladimir.

ChangeLog v1->v2: some fixes and more patches!

DENG Qingfang (1):
  net: dsa: rtl8366rb: support bridge offloading

Linus Walleij (4):
  net: dsa: rtl8366: Drop custom VLAN set-up
  net: dsa: rtl8366rb: Support disabling learning
  net: dsa: rtl8366rb: Support flood control
  net: dsa: rtl8366rb: Support fast aging

 drivers/net/dsa/realtek-smi-core.h |   1 -
 drivers/net/dsa/rtl8366.c          |  48 --------
 drivers/net/dsa/rtl8366rb.c        | 188 +++++++++++++++++++++++++++--
 3 files changed, 180 insertions(+), 57 deletions(-)

-- 
2.31.1

