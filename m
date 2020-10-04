Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D9B282DD8
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgJDV6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgJDV6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:58:16 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47971C0613CE;
        Sun,  4 Oct 2020 14:58:16 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s205so5637688lja.7;
        Sun, 04 Oct 2020 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3dKZTDt6G8XKOcAV1DqfJccWFLxAePSGcng6uVIbTY=;
        b=gvhKs664s6KYp21EWxh76Wbt8d89d8VkZXnWbEuZBhzNU9j/EllaObArfpvt25kFtn
         ITK85AkptQf5tjMrL3sr0w0NzvWpiV3ROoFjWw2y35yQ/eC1zD5wizorGRX+SjwCC0aM
         5YT1D+unV1cvBKTVATSGVxJWYAgDJFPl7vKlhKy6/yFXiYhVjJ8sgAWGvBTx3RI16np8
         yX1crWa34Mi31FZLjj9a0pH4b+EnbBWrNd6XHVGUml6YZQSKh8xLUY7l1N8xwNxA/dzS
         GORw6RRkFAjd03XmWBa6L8qDmilH6RR1J3Wdne5JrEmKpzfWUooDabBB4gDblK5lSdxq
         Z1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3dKZTDt6G8XKOcAV1DqfJccWFLxAePSGcng6uVIbTY=;
        b=o/2igazKgiMLoGrqIo00N6l1w7psQjb+6jHxaCdHDscOdDY0B8yFzKEJNkf+vb0o/+
         h7INjlNflPOISA4U6Tq43tc5f4BigqaM7vzNpI8+5+tgowx+u6BCqBSQCnRmT7rkm+gb
         Uqr3pVSZnO0cWWPygj+zLBqpOOwXFUQ7abzYstLDSNC1V2UyeGhgKv/nJoJuj3vrDp1z
         movgwCs+QVlDx6WpvT+MgBO60DDrrxA/bd394BLZd4xbUfbnmBMwrCzGiPWTlrNYAtWU
         BUds1bFmIs5PqhCGBhALUGrx17L5PR1zMqmTpcb0MXLSLm3WL+XlKdWB6BVGj7y2QX/Y
         Mm7A==
X-Gm-Message-State: AOAM532u26JmHvrTzV1miou9iv80ejP094izCKnpi8qrZbnd8sBbBJ40
        q7iieMUcbxUaG4uooygrOiI=
X-Google-Smtp-Source: ABdhPJxBG2okHfbAFU/M8PWQlrvmEEk18oxxn5+7CnvLkGLpO8nWznXkZOoQDeJJEzWVVUDjhiIWJQ==
X-Received: by 2002:a2e:9dc7:: with SMTP id x7mr3726106ljj.447.1601848694658;
        Sun, 04 Oct 2020 14:58:14 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id r17sm310255lff.239.2020.10.04.14.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 14:58:14 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org
Subject: [PATCH net-next 0/2] net: Constify struct genl_ops
Date:   Sun,  4 Oct 2020 23:58:08 +0200
Message-Id: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make a couple of static struct genl_ops const to allow the compiler to put
them in read-only memory. Patches are independent.

Rikard Falkeborn (2):
  mptcp: Constify mptcp_pm_ops
  net: openvswitch: Constify static struct genl_ops

 net/mptcp/pm_netlink.c      | 2 +-
 net/openvswitch/conntrack.c | 2 +-
 net/openvswitch/meter.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.28.0

