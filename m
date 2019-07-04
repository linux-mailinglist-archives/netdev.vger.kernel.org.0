Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5477F5F002
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfGDAVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:21:42 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33728 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfGDAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:21:41 -0400
Received: by mail-pl1-f174.google.com with SMTP id c14so2102945plo.0
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQ6L0AbSP2YO8yCvK7gY+brxpSURlc6UObyyQl2O6XA=;
        b=aQ/of6i4folDvZ/uAIwvvgpacMBssM9X74aPV+c5nAl8eLQu7fuMp7xn3jFYq9qHXw
         VFr9FZFIqe94C9vqjRHpJ+S5IH7PPuQNtHXXAWOj6hWfD+JdL/IjlPjv5y4rqcfIV+tV
         ydotsDxiPkaJbSU95pe1zPWc67POKiJ5GnGZJnNzBTjydv3d2fQ8O0idKZrQegMI7u34
         EwYOkgj3DbCy/MtmHbYXtHQvztSU/rBxuHya/c0URUkexVlZrX4Mci0uF8i+fNCzxtaL
         EarCH5ay7Q5E+C1HTaxyL9LloEr8f1+pxvRt32jzTA1qB1TeFSfqKWU3wfxZ5hQ+JWcX
         MYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQ6L0AbSP2YO8yCvK7gY+brxpSURlc6UObyyQl2O6XA=;
        b=WHekrROcnR3jB/chvQ8wY/peWJWyxsEj5LgjaHzsb6UvNnuQWPmhq8t8x9dVz7bBYb
         ISzJSoIVTLeq0zikmMI8gJNq+9yBmJaRKUuR9E500Aew/5ZPqWSPWrdVBIb3xikbsc17
         N5guMRA6SYySw0aDKsBqEt/7bbRdsi+kyyIhg1LTBQdDh6ERhAcUNfXpkvXA6ek7NQWO
         ahqCRFocdiVfyYjIc1ikW6bSS54jF44pF9opfJkThG8B9B9Y1OoNYKQ9IkVItHCYaGr5
         wPfapR7v+5Ub9LiUYgcPulvqSdZWl5I/sSiEJsOukWbH4TPP0UhQHYbPGngMj8PtBK4v
         VBew==
X-Gm-Message-State: APjAAAVj+bW5Tq91WEdY7Ak6s8cAIAwA7HTG9D2VQE4XD77ViZLJ2Fon
        fkQjSUrkN3/UmbQJMs6XGYfWrkRKlxs=
X-Google-Smtp-Source: APXvYqy7/edgRsH3n8CF0kmdtgJK6Lni96fGRePnMXUb8C0ixw2ART6LEQXMgxH8A7sa6dYY1KBSAw==
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr45937730plb.46.1562199700486;
        Wed, 03 Jul 2019 17:21:40 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id e11sm7252426pfm.35.2019.07.03.17.21.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 17:21:39 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: [Patch net 0/3] hsr: a few bug fixes
Date:   Wed,  3 Jul 2019 17:21:11 -0700
Message-Id: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains 3 bug fixes for hsr triggered by a syzbot
reproducer, please check each patch for details.

Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Cong Wang (3):
  hsr: fix a memory leak in hsr_del_port()
  hsr: implement dellink to clean up resources
  hsr: fix a NULL pointer deref in hsr_dev_xmit()

---

 net/hsr/hsr_device.c   | 29 ++++++++++++++++-------------
 net/hsr/hsr_device.h   |  1 +
 net/hsr/hsr_framereg.c | 11 ++++++++++-
 net/hsr/hsr_framereg.h |  3 ++-
 net/hsr/hsr_netlink.c  |  7 +++++++
 net/hsr/hsr_slave.c    |  1 +
 6 files changed, 37 insertions(+), 15 deletions(-)

-- 
2.21.0

