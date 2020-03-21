Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05A918E0F2
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 13:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCUMFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 08:05:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41300 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUMFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 08:05:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id h9so10621777wrc.8;
        Sat, 21 Mar 2020 05:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EfodRmW2l478YoUF/NEMb3epOdAHJYA9K519pesBxmk=;
        b=i9zi7vf2mSwVRJeZGA7d3dFGu2uoE6XGrfBngyYBxngyzvwSCZKgcH7gd8W8uH9YPa
         fUGjBd1Z92kvMPBYwVqcuIQPlYYg/fa8ASYL89cDISg0HiXxxi7NAR8nXLubPl0A57vT
         h/Ws/GRLKAT120f8/62vnRzasDbb3528SspE8a6pyOCQsqgemnnAGJKfFAXeE1Do/Knu
         VIl3dcRdH4zxaw3fXIifN4LEOzIO8YVycMxLLW7ILxMsz4HV/xnwC/j/YW517O6TeZmO
         v8Zzog4st9TkZN3RQczcPto+8RKQeKgNzEjt4jMxJT3GC8bsr6AqRNSpe2kpxwFQgg4H
         XqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EfodRmW2l478YoUF/NEMb3epOdAHJYA9K519pesBxmk=;
        b=MXzUijT/WUjV5uStyCS6aKRy2DbraPJ5EHU2za3TYvxU6jCOAefbFedi9SQNGRpyW0
         QTF8BvjifRDoMBwjNAggmIQM6Vf1Xm7/QTXk7QGGL8gmAcI3x/CMalNb8DpW2WCDQcWF
         5+yZ3HGmP/qeLS5N60HT1KMfxVAM48YyqwFYcSDWkWpfGXdM61sipg9flhl1n0lM9K4H
         DVt7lzLqPfuNtrQLzIZj05z32SKjACe40huhdecO832FSX85B4FZgqeGFgA2gdj0ICfZ
         v7XmI02BqTN+3f/QcVAZ6BVCPmCAdBATLtWX/MoZG5Qne14NcuEgudzd55Y1CPSeZGH1
         6pkw==
X-Gm-Message-State: ANhLgQ1sMMOmTG8n9TxeWUP10JXdlvdNr9+xcmqT1JQQqJou5Rs0KHyi
        GzfR1e4UZOD70EBoROlDXDk=
X-Google-Smtp-Source: ADFU+vsKwO+JvuQBHLV7YV3cVJhZb0IeN24HEx0xAO/6OxzgxPpmQRlsCvam2SAHP0OnLpdk86PP7g==
X-Received: by 2002:a5d:52d0:: with SMTP id r16mr16496453wrv.379.1584792326004;
        Sat, 21 Mar 2020 05:05:26 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d49:b100:e503:a7c7:f4c6:1aab])
        by smtp.gmail.com with ESMTPSA id c4sm12246120wml.7.2020.03.21.05.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 05:05:25 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Cc:     linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] ionic: make spdxcheck.py happy
Date:   Sat, 21 Mar 2020 13:05:14 +0100
Message-Id: <20200321120514.10464-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Headers ionic_if.h and ionic_regs.h are licensed under three alternative
licenses and the used SPDX-License-Identifier expression makes
./scripts/spdxcheck.py complain:

drivers/net/ethernet/pensando/ionic/ionic_if.h: 1:52 Syntax error: OR
drivers/net/ethernet/pensando/ionic/ionic_regs.h: 1:52 Syntax error: OR

As OR is associative, it is irrelevant if the parentheses are put around
the first or the second OR-expression.

Simply add parentheses to make spdxcheck.py happy.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h   | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 54547d53b0f2..51adf5059834 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB OR BSD-2-Clause */
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
 /* Copyright (c) 2017-2019 Pensando Systems, Inc.  All rights reserved. */
 
 #ifndef _IONIC_IF_H_
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_regs.h b/drivers/net/ethernet/pensando/ionic/ionic_regs.h
index 03ee5a36472b..2e174f45c030 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_regs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_regs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB OR BSD-2-Clause */
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
 /* Copyright (c) 2018-2019 Pensando Systems, Inc.  All rights reserved. */
 
 #ifndef IONIC_REGS_H
-- 
2.17.1

