Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0104A4C0A6
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSSRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:17:20 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:47178 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfFSSRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:17:19 -0400
Received: by mail-pl1-f202.google.com with SMTP id 59so5239plb.14
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 11:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O7rv2aQ+NZXAwqWEnlsVJInaVAsSvihbId/ltqpnhno=;
        b=L1NZ6goCzBfV03VfFjkvbvXTv1TSjEjf/4k2Mk71dw+3pJ0zRjNqfHR6GkaB1rB4lh
         Vi8lL27r/YHsA6fDTXTy8wIfsLZG46ltJ1HFZ/jUsi6iVvgMk3644k3q+hs6F1ch/aic
         yECJUmwDTfpVhKZ9flqwZv5W6QcxlqtkZIWpiGDcf6DAdAwFy6qVZmsLmWSAi9nqXtcI
         Q5o0vE868amfRuXf5cwTKwHqa/pTqSZv6mp5My349i2AuauNFjLOlp3mN5QA0nGr6AhD
         xFLvIhb6Rh9xI+axDQOn6Ql1lCeaS6VQhTVEo81LPzGJBRAEzpCjLTfFPEnp9B2OPDb4
         DjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O7rv2aQ+NZXAwqWEnlsVJInaVAsSvihbId/ltqpnhno=;
        b=tYHXiOPosdMWex6UxfWM+0CRnm/CQqdnxWXsARSbSKEwfsmzNwiUz1wp8HlHUp8Erg
         VPZSjImZSTVxlfxCpluyyGZ+i2tb74ab+Gbs/YV9GWsX8Rijkm+hdra6tgFTFCA1mRTw
         ApOe1mfwwqTYrqVgj0xzo5hgtabj/geI0vgrVEljlHPSHAi/yBe/p0yOQI45U4pQ3TvL
         XJ2TCzqBo0qDQTzfJ+ugicq4TeQMNHDwtA3y/bT186+KuPM+4+qo8IazZXsLzP/oEYPE
         5F0HyPh63uuF9tKucfIlEaa3la34uSRVwrcR1gLNsD02C2/XnLRTkYVsR9yoW7Ae008v
         JL4Q==
X-Gm-Message-State: APjAAAXX3EzoPcr6S11C3qnUyVcU1jCqunkmLVpQ9cQl7Ql4dQ4ximel
        8XgQ35AMI9NDbSMaGmJxI6NrZjiUsw==
X-Google-Smtp-Source: APXvYqzCqygg6fRWJ9UuWuzECpwXNQ/ze8FCSiCnGa/FlHW33doGjRIRoYNNUX56OXyeA9DOyqBhBwCO0g==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr8888660pgl.103.1560968238611;
 Wed, 19 Jun 2019 11:17:18 -0700 (PDT)
Date:   Wed, 19 Jun 2019 11:17:15 -0700
In-Reply-To: <20190619084921.7e1310e0@bootlin.com>
Message-Id: <20190619181715.253903-1-nhuck@google.com>
Mime-Version: 1.0
References: <20190619084921.7e1310e0@bootlin.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v2] net: mvpp2: debugfs: Add pmap to fs dump
From:   Nathan Huckleberry <nhuck@google.com>
To:     davem@davemloft.net, maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
Added a usage consistent with other fops to dump pmap
to userspace.

Cc: clang-built-linux@googlegroups.com
Link: https://github.com/ClangBuiltLinux/linux/issues/529
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
Changes from v1 -> v2
* Fix typo
* Change commit prefix to debugfs
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 0ee39ea47b6b..274fb07362cb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -566,6 +566,9 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
 	debugfs_create_file("hits", 0444, prs_entry_dir, entry,
 			    &mvpp2_dbgfs_prs_hits_fops);
 
+	debugfs_create_file("pmap", 0444, prs_entry_dir, entry,
+			     &mvpp2_dbgfs_prs_pmap_fops);
+
 	return 0;
 }
 
-- 
2.22.0.410.gd8fdbe21b5-goog

