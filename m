Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E25179C58
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388490AbgCDXYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:24:24 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34315 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388412AbgCDXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:24:23 -0500
Received: by mail-pf1-f196.google.com with SMTP id y21so1788379pfp.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 15:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8RcEnVTQtvXuSUtk0HSx6oYEGyBpBCmhpIUGG48JhjU=;
        b=ZqnvlaVT2kbZZUhMXW6jHH7Ikf9jPv6OmNKt15UZYvxPIyTpSaR+MYcpo8bcCdyFam
         iKAYFxEEmaMommWZ8B3UJzJZGciyv00SeJGyAAeT6ITbL08caxvrEeK9W0IlYxxzxEeu
         eQirmGfglwmHZtDqKaVBxfLWGo89noc/DjYlcQihJwbLIRkXMREyfOu+r9s6VvLOa0ch
         WVUPQKnY1MF7AlztlyQGiBojPoaz6NhYPQTYtIwUS0ZY5QIuugEHp5N0Ax17mLi7QlwK
         zvGp9JZ0WkwoggnKW2PjN3g7zKJP8bPvrpS29sGQc9eJ3JjnbnNZAgANJfDtCk7GXpA5
         rAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8RcEnVTQtvXuSUtk0HSx6oYEGyBpBCmhpIUGG48JhjU=;
        b=QSrqfazuRANhPoodnVObtnStE+hKpHVNBr8dLNDUMSFiQmqQp31pPIiX6z5hLHmXJK
         BmqA6+5X+jdo8wZTLRLoAMuzD0ChK2aeDgMh2fnyDIy/sRNLQTGxJHPS+LXD2K1ejyMn
         /hx0Pxtg13GoRBHnUIwAF23vCPEhABBHe6d9hkPJQdBkpT3UERI7ogQkHjKdgoq/+hXT
         UVjXWoP5R5kFKqX6uUtGeObp37nCYriXeIu5txb2Wlg0HR1glcc9AjoVIDgW8YIAyGOh
         VbLdmBNhgc5GzZ/pf1XG7nkI+eGyEcrPxvGmkWuj2Fk/j7XPiOlPs6ayaXs9zNrurXXT
         f6yA==
X-Gm-Message-State: ANhLgQ2x7aDl4a0mgwL7W4KIYNofobPcASznStel+1GAgTY2W0Mi6OCu
        /ZELoCI0Va6Xw+PmaHIUdJY=
X-Google-Smtp-Source: ADFU+vsuKvyRjkrNv+iUpGX8PvvCOO5ynTWasuEbdScniB21zMRxz5MGl9qIYwQPEBm2mCmuSPgBww==
X-Received: by 2002:a63:fc51:: with SMTP id r17mr4646647pgk.292.1583364262590;
        Wed, 04 Mar 2020 15:24:22 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d1sm21647406pfc.3.2020.03.04.15.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 15:24:21 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 0/3] net: rmnet: several code cleanup for rmnet module
Date:   Wed,  4 Mar 2020 23:24:15 +0000
Message-Id: <20200304232415.12205-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to cleanup rmnet module code.

1. The first patch is to add module alias
rmnet module can not be loaded automatically because there is no
alias name.

2. The second patch is to add extack error message code.
When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

3. The third patch is to use GFP_KERNEL instead of GFP_ATOMIC.
In the sleepable context, GFP_KERNEL can be used.
So, in this patch, GFP_KERNEL is used instead of GFP_ATOMIC.

Change log:
 - v1->v2: change error message in the second patch.

Taehee Yoo (3):
  net: rmnet: add missing module alias
  net: rmnet: print error message when command fails
  net: rmnet: use GFP_KERNEL instead of GFP_ATOMIC

 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 36 ++++++++++++-------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 11 +++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +-
 3 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.17.1

