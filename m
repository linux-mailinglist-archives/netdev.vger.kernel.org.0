Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EEA41B4C4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241953AbhI1ROU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:14:20 -0400
Received: from mail.z3ntu.xyz ([128.199.32.197]:43040 "EHLO mail.z3ntu.xyz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241894AbhI1ROU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 13:14:20 -0400
Received: from localhost.localdomain (ip-213-127-63-121.ip.prioritytelecom.net [213.127.63.121])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 080C6C8FD4;
        Tue, 28 Sep 2021 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1632849159; bh=H6qRnt0d6DkSG6XCjWovvAv1Yd1ZJca084HuTz5xLb4=;
        h=From:To:Cc:Subject:Date;
        b=Q3b0yRTwwD+aKK7blIwsuddDXzTbl7klzAcxKeFsygIt8a+uI4Je8Jyy5DhdKpAa9
         8s3QSHhZQ6PZoqcy7unw4SD6+F1bxYlMF0PEkxiuNuNSAMNE3sKL9VsP9SBLqr4Gdo
         Ly1epUaCyovZqBHUZ88Y2cOeNzRtBCEVRI/JbnE8=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, Luca Weiss <luca@z3ntu.xyz>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qrtr: combine nameservice into main module
Date:   Tue, 28 Sep 2021 19:11:57 +0200
Message-Id: <20210928171156.6353-1-luca@z3ntu.xyz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously with CONFIG_QRTR=m a separate ns.ko would be built which
wasn't done on purpose and should be included in qrtr.ko.

Rename qrtr.c to af_qrtr.c so we can build a qrtr.ko with both af_qrtr.c
and ns.c.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
---
 net/qrtr/Makefile              | 3 ++-
 net/qrtr/{qrtr.c => af_qrtr.c} | 0
 2 files changed, 2 insertions(+), 1 deletion(-)
 rename net/qrtr/{qrtr.c => af_qrtr.c} (100%)

diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1b1411d158a7..8e0605f88a73 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_QRTR) := qrtr.o ns.o
+obj-$(CONFIG_QRTR) += qrtr.o
+qrtr-y	:= af_qrtr.o ns.o
 
 obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
diff --git a/net/qrtr/qrtr.c b/net/qrtr/af_qrtr.c
similarity index 100%
rename from net/qrtr/qrtr.c
rename to net/qrtr/af_qrtr.c
-- 
2.33.0

