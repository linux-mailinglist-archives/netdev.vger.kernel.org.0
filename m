Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1024034EB2E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhC3Oy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhC3Oyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:31 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2732C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so25264752ejc.10
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ylnf49stu7yAd1zDb6206mpqSv04CLyocUzralNlNAE=;
        b=ZDcMTx/5Zbvk6abuWYGP2jxaJ4uCF7FCRU2ThXtCbiG8AMscUbnhExoqfZm7uBZkrw
         8WBR9EddRixNf8fzFYGZbg356AfwRjgNn06EKGrkgT67xh1WjXhr5yhbQ+jrwvudVkD2
         aWkB9IkQpqRluiHJKmgbupZgi0CLs3iYk3P3zYzgmNtDIakpYvIPzMSwg79hk8A33NJG
         7OK0i+MWF2mAmnAcg/4enovoVXkBRJiDKzWWKPqJVWBTtHoSMzXKOU8oA8V/3hNf0vKK
         TgvdUtZO5qHLJhmadhAJNfR2m8cqXZ8YrR6zpYJ/OQ0M4TMyS1Rku21yl8TAhoi3DmsD
         o/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ylnf49stu7yAd1zDb6206mpqSv04CLyocUzralNlNAE=;
        b=omkREhVRLE+bVvqZ3zhSlifie3uVYyP3EeG6013nkrkUmwEno3thR/+SmIy616R6Lk
         XHItZfAeDS4QKzzDZg6Tja9+T3VwhNI5LLDhvo3gIpClvfq1yGdAkgO3Uzx9NWxZhHZG
         RcOZW4ippyvPmQCykFc8jPbSObRrlwVsuS0FnzF4J+/l+N6yVhwIzLdqAokO/1EjXuaC
         GAjSCmqDX9ZfilIeBKz2D4qKfnQFa8hVMNtAWwaNR2HoSN+TK19Ckin/jK3L/JdyAVOd
         IjBY7rUnKA0aD84PSOVUNE9itPWiGnwDBkRZudU3cRXnv41eNa/iSAyg7Sq/S41B4+kw
         /hsA==
X-Gm-Message-State: AOAM533LSHeJ6QnlfYrVRKRIOp1GGQ12Am7OST07bwznaKhidwyCiOZD
        M53Kedo0b/bWPzspk1j7Kqw=
X-Google-Smtp-Source: ABdhPJwE5dqXbYcHeK3LnPqb53W5DmLLBau7bW3tAJJTgyfUhawPvwskomZUr14RMjOJvC9yST/2qg==
X-Received: by 2002:a17:906:4bce:: with SMTP id x14mr32862473ejv.383.1617116069341;
        Tue, 30 Mar 2021 07:54:29 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:28 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] dpaa2-switch: add STP support
Date:   Tue, 30 Mar 2021 17:54:14 +0300
Message-Id: <20210330145419.381355-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set adds support for STP to the dpaa2-switch.

First of all, it fixes a bug which was determined by the improper usage
of bridge BR_STATE_* values directly in the MC ABI.
The next patches deal with creating an ACL table per port and trapping
the STP frames to the control interface by adding an entry into each
table.
The last patch configures proper learning state depending on the STP
state.

Ioana Ciornei (5):
  dpaa2-switch: fix the translation between the bridge and dpsw STP
    states
  dpaa2-switch: create and assign an ACL table per port
  dpaa2-switch: keep track of the current learning state per port
  dpaa2-switch: trap STP frames to the CPU
  dpaa2-switch: setup learning state on STP state change

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 152 ++++++++++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   7 +
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  75 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 190 ++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   | 121 +++++++++++
 5 files changed, 533 insertions(+), 12 deletions(-)

-- 
2.30.0

