Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D333E0ED2
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfJVX7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:59:04 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36675 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbfJVX7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:59:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so11689953pfr.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EZE4n1CEWwiXxhRvw+llQhWwl7SDzXEz2LUWqMyCyoc=;
        b=OYP94qq1KXzG8qkoTUtJsYtwfF3KbCaXoCXwoFM58OREYUwZScaNOP9TAG/0BZcDcE
         z7cFJHDWAlDvGkIfvj0lCSdamFMvqquNUYm2ZOv7EiuaL6LKAqPEjbBRV4YAru6BT3SN
         UDja75rkf9TT3V/M3dPqO3u2CnCy8kRohoHfpF9J8MGhn6HDh3JdWsQ4nE8wcashD3M4
         mpjUSEjBl9jSaONr1BxaHVIff2kiPOYTWXHqcy9NGIi7JnrF42rDFL7hhnKQvksIyJgs
         QjMKkaOS1SL1naYMJV07OqW8mPg6xQyWoPwKFyMiFWIqlmhGbHmDSK0ixtxYLfLsKOe7
         dkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EZE4n1CEWwiXxhRvw+llQhWwl7SDzXEz2LUWqMyCyoc=;
        b=Tf7V1t7fmQG39r4rRMzzuNZzW7BgM/VCQFCssYXo6yxWgIoTim72Wzkz+uGJp14okG
         UHfgiNOSJfoRghMh+8QVooN5KP0FU10QXsOEz2exYnujb38+mHAHkxq1Y6W3hyxxhS64
         YZEM6/61cp/CwnjwjVrCl+/ay/4Es4S3BNbAiQM/rMlz2BkKZbvo3adCngpjSXDl0Eqi
         81hLE5xkxzoc6hYNwpUephrQ33PJL/E/raDZMj/M7CC+9Idiv/apHeN9xVzjgh8mnbtB
         7M1axeZmvLsDqfNZcMLvvAOt0QKSrh+piKjIbBfkBVsn+8LgDa/WqCeZATd2DjtRb6Kz
         I5Fg==
X-Gm-Message-State: APjAAAWIroeXJ+yOXNS1O3AqRrHLokvq+mLTzilG5h5EzPDf7Yi3iRwo
        ByiNMYhCMnynJn1YJEbVL6P2oM/EKYI=
X-Google-Smtp-Source: APXvYqx9pTOclgB70Cy6+ONGkCAj6YhIpmBOKpcfYsDYCJCdnE4xQRDRdEYth4eM8tjPoGaDXR6Z5w==
X-Received: by 2002:a17:90a:9dc5:: with SMTP id x5mr8138638pjv.85.1571788742768;
        Tue, 22 Oct 2019 16:59:02 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com ([4.14.35.89])
        by smtp.gmail.com with ESMTPSA id f6sm21010028pfq.169.2019.10.22.16.59.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 16:59:02 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com, daniel@iogearbox.net, ast@kernel.org,
        magnus.karlsson@intel.com, brouer@redhat.com
Subject: [PATCH net-next] xsk: Enable AF_XDP by default.
Date:   Tue, 22 Oct 2019 16:58:31 -0700
Message-Id: <1571788711-4397-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch enables XDP_SOCKETS and XDP_SOCKETS_DIAG used by AF_XDP,
and its dependency on BPF_SYSCALL.

Signed-off-by: William Tu <u9012063@gmail.com>
---
 init/Kconfig    | 2 +-
 net/xdp/Kconfig | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b4daad2bac23..229eceeb93d4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1631,7 +1631,7 @@ config BPF_SYSCALL
 	bool "Enable bpf() system call"
 	select BPF
 	select IRQ_WORK
-	default n
+	default y
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
 	  programs and maps via file descriptors.
diff --git a/net/xdp/Kconfig b/net/xdp/Kconfig
index 71af2febe72a..77fd51d6a5d7 100644
--- a/net/xdp/Kconfig
+++ b/net/xdp/Kconfig
@@ -2,7 +2,7 @@
 config XDP_SOCKETS
 	bool "XDP sockets"
 	depends on BPF_SYSCALL
-	default n
+	default y
 	help
 	  XDP sockets allows a channel between XDP programs and
 	  userspace applications.
@@ -10,7 +10,7 @@ config XDP_SOCKETS
 config XDP_SOCKETS_DIAG
 	tristate "XDP sockets: monitoring interface"
 	depends on XDP_SOCKETS
-	default n
+	default y
 	help
 	  Support for PF_XDP sockets monitoring interface used by the ss tool.
 	  If unsure, say Y.
-- 
2.7.4

