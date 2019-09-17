Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E48AB5881
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfIQX0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:26:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34295 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfIQX0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:26:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so4943100wrx.1;
        Tue, 17 Sep 2019 16:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifcz8bMK/kKMhqqQf2aNBxPpf1zyv3RqW2PL7DYTBms=;
        b=uwr4eAZ9TRclI/EqDiJYyscj0GPKcsOARU2L936yr82mFuTXD+VKxAeVD5D3LxTStv
         qZgR/amJ4Usa4QGZEPSIIdfPPWHF0XmLIP2OVIIRDE4nv/GnsMqbIhFok9Fn6rK3atus
         hrjQlcTGzPAlzFAXo5wdLXbSkHguBT3VFenpaldw6R3JyYBlEpRZBZShtLrIBREm6ToF
         Jus6ZNGzx+5ff+JtNfoLGOQUb1aF/0C/3WLg43ycm8Wk6IZGp6gOMD5VaCKi8u3rKq61
         gWDEhhau8OcjA7ny+KVkUJN+Nm7RAXCGZYcFDFMJnCapgzUWN+78EG3JFuB0kFISSLbM
         EZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ifcz8bMK/kKMhqqQf2aNBxPpf1zyv3RqW2PL7DYTBms=;
        b=Ughkq8JaNCCfv0Wl/IbeSShr3pfxdPy+WCugTULar4kgly3DiNXkF1LdbDss0MbRYf
         KKA0VP5deAt72dmUc6GZZD0v9+W23WmJJTFi31xg/CIGqUGCQELoMdM3UIzcP4CqgKpx
         RKNf1Rwdj65SyMnNLO4/S4I0tTDhF1fEzcWILBBCBDyszOchUBDq2QBVRFjgmL0+zaWy
         q5bb4ET5i1+HP35iAsAGxi9hFZo8hJ7NADWuFmCW38dDpDdfebfuFBTA0jVvyQWDsBO9
         mdRBmtuahrLa9d3bmNjIUZzLD2kQKF3fKlVklvtERxCx0d4FXi4Byr7TqeyFGe/6rsOi
         nBuQ==
X-Gm-Message-State: APjAAAWxyrO+UbtG68/SCQTAnhf/NasE4P4rN4xjPcakFc3ycKWQYTYw
        z0fMEcu9KVPVGpaiVc9MBrA=
X-Google-Smtp-Source: APXvYqwK3H57GQhCYIidXgKH6Ho27YYzao3Kg7PYbNtrYm6URvhPmtPrcpqsW0ClkS/HyOuJqNONbw==
X-Received: by 2002:adf:84c6:: with SMTP id 64mr656942wrg.287.1568762799840;
        Tue, 17 Sep 2019 16:26:39 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id g4sm3869568wrw.9.2019.09.17.16.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 16:26:39 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] ionic: Remove unnecessary ternary operator in ionic_debugfs_add_ident
Date:   Tue, 17 Sep 2019 16:26:16 -0700
Message-Id: <20190917232616.125261-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

../drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: warning:
expression result unused [-Wunused-value]
                            ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
                                                         ^~~~~~~~~~~
1 warning generated.

The return value of debugfs_create_file does not need to be checked [1]
and the function returns void so get rid of the ternary operator, it is
unnecessary.

[1]: https://lore.kernel.org/linux-mm/20150815160730.GB25186@kroah.com/

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Link: https://github.com/ClangBuiltLinux/linux/issues/658
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 7afc4a365b75..bc03cecf80cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -57,7 +57,7 @@ DEFINE_SHOW_ATTRIBUTE(identity);
 void ionic_debugfs_add_ident(struct ionic *ionic)
 {
 	debugfs_create_file("identity", 0400, ionic->dentry,
-			    ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
+			    ionic, &identity_fops);
 }
 
 void ionic_debugfs_add_sizes(struct ionic *ionic)
-- 
2.23.0

