Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2AB3ADC62
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 04:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFTCzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 22:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhFTCzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 22:55:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD74C061574;
        Sat, 19 Jun 2021 19:52:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v12so6666032plo.10;
        Sat, 19 Jun 2021 19:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4gE1UXUdRdz6eukgpcCvaOI9F8pK5g/stV5KV8OaApU=;
        b=TZQTIJ1ytVDHkDfWlg4L3uBz1a7EY5wQemSUrR2I5IeKC4X5hesgbUSWZdl4rcn43R
         db5IF3TU0yFnGMxBtpYjqxRO75yQ8g1aIs5AkdHV/CF9cgtVd/r5mgIe9Dv2rhEf94LD
         QKDjQS+hQ+wEqO0C74reQrmVSE65fcgQjPZo9Y5NUamcT9SOhl3jZmyZqwRW+ICTxYlB
         Cl7+P2YOWGYevW9sg+n1lBKYlNJsh13bN80yHAZdFoQWasjagkJhmNkPsHcTrJfSGtp1
         05eTWkzJ1N7j7/hCue1w1rDXmogtSyNr7EniVFJJj5x6XfwBW4Lu+Qac/ng13Fi7V/m8
         F4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4gE1UXUdRdz6eukgpcCvaOI9F8pK5g/stV5KV8OaApU=;
        b=soYNd+j0sdj1HPezx2KNXArSFlnXcFxyQfQ/Q04GiuE+9BjK2MqKYM7mrZoyr+E3v6
         kDkKl2C+q8ezq+PLR0/H+9YwKMiIOEfbNGunimzd4dyC4Uc5+kxR9ZHdIcx1uEq52zRF
         L4TVnFBkObK5pDcoLc5WVnmQdxqg0BycpWdcvCxSMlT+5iFS3hnmXx/sGnRBR3Sn1/CM
         xF7I1Z2c2ubCGDZZ3Bim+goOZ+MvR9w9CJPD2CxWK5GqgQZcjtrbqXZXy8z+mN91Y20c
         qBPersZ4sawzRxU3ixqio3UzDgrTix7wu0S2Agu8EKsbgiMfLbHEIoYo/wrVGTq5FKtK
         mimQ==
X-Gm-Message-State: AOAM533nC1u0PjGUrxr9As7DLu1QfvelYpJC9ShLRxj2yCnFErMu7JyU
        dsPvvj7y6lFUVAvoGMRUgYg=
X-Google-Smtp-Source: ABdhPJxkc9vmvlV1CJKEN/lgkpGzYDW3T3HnXwQOf5gmy85CQ8Utm9IrFPkZW23YLSd5U/I/p8W+3Q==
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr29572306pjb.63.1624157568193;
        Sat, 19 Jun 2021 19:52:48 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id p11sm11775548pfo.126.2021.06.19.19.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 19:52:47 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [RESEND PATCH v2] nsfs: warn if ns->ops is not provided
Date:   Sun, 20 Jun 2021 10:52:38 +0800
Message-Id: <20210620025238.2820-1-changbin.du@gmail.com>
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

