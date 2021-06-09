Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27303A1966
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhFIP1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbhFIP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:27:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F863C061574;
        Wed,  9 Jun 2021 08:25:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v13so12709665ple.9;
        Wed, 09 Jun 2021 08:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4gE1UXUdRdz6eukgpcCvaOI9F8pK5g/stV5KV8OaApU=;
        b=G/hm/++ySnLK2UvP0cHAvb6WDjA48iNhGA2kK7a0CW3giUcJJeBGy4PpvvlTV11WLr
         s2VezzMmpTrWSTv5Tpz4n/3aw8WiHs/bblv1ejOsPRT3sE5b9lxf3nCbm0brW9ICDIYK
         gRPePMBLAXW/p0vXvMQq75zso8rPbXQL2tESb1pZd79fiqZsnStzS4Dv/dzty3ZwaVCG
         wjBcUf2JZ1fHVt+3ZLjsQ12jVC1ptoTar2HPa/Cvd5DUjVKJyMd2XjMzDk7yCz2veMz6
         jUglp0sbm2UJhMFbRCe0OlWi6MC4BTKNtHegqbq4AOdDIoimMsUglkuQ6tkvFQFLLr/I
         uiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4gE1UXUdRdz6eukgpcCvaOI9F8pK5g/stV5KV8OaApU=;
        b=G9RCEzyesuYi88KZa7pu0CsRODKerR2l3vBG4APc2Ec8mMOkFEB0rVZx0lULzMjUFl
         2+zbr3eoL6xdwLYoRXPAtzcoJc5lMJ3UGtxJirnyVazj8faWmanyzSsIZnIogd2CHgPr
         WvnRvXickFqBQ4rPqdON7b160ZG3tclWY4xkBXiHc2uneXb5k0Xl8Ywa33SuRCjOKr49
         T9ljcWu6JcQ0CXMLWs1GElRybGb7IhAdQeoVwpxlQHw/ert5HfXel4xwY9lalWEO6JwJ
         oQRUr2LXZNhkTEdJPTTUHE/WSSR/fyTjRXPrgSG3vhfKF5hqw9BIVcfsJkCnZdsrsWtJ
         g5FA==
X-Gm-Message-State: AOAM533CEWdP85KphRpZI3ucTIzr5FiXjYzNzRNWeDRm/HLLp/e8bm/H
        uBL4USKu0QclbmccFyHuJWk=
X-Google-Smtp-Source: ABdhPJzHJckghRLSO4AJdlyPPTvJBsDkLFfTIJdVRhO/FzSRa0tQGv15Fb40B3gey8GhyaGbbsmoyg==
X-Received: by 2002:a17:90a:2f22:: with SMTP id s31mr112858pjd.62.1623252314780;
        Wed, 09 Jun 2021 08:25:14 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id x3sm177860pgx.8.2021.06.09.08.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 08:25:14 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v2] nsfs: warn if ns->ops is not provided
Date:   Wed,  9 Jun 2021 23:25:00 +0800
Message-Id: <20210609152500.28104-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not create inode for disabled namespace. A disabled namespace
sets its ns->ops to NULL. Kernel could panic if we try to create a inode
for such namespace.

Here is an example oops in socket ioctl cmd SIOCGSKNS when NET_NS is
disabled. Kernel panicked wherever nsfs trys to access ns->ops since the
proc_ns_operations is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

So let's print a warning for such unexpected request which to create the
nsfs inode. The issue in networking will be fixed in another change.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/nsfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 800c1d0eb0d0..a132827bddd5 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -62,6 +62,9 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
 	struct inode *inode;
 	unsigned long d;
 
+	if (WARN_ON_ONCE(!ns->ops))
+		return -EINVAL;
+
 	rcu_read_lock();
 	d = atomic_long_read(&ns->stashed);
 	if (!d)
-- 
2.30.2

