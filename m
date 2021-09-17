Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D140F5EB
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbhIQKaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:30:39 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:50956
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242934AbhIQKae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 06:30:34 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A472F3F4BE
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631874551;
        bh=6nkF1q/vzOOF+WmaUamUG6Dayh5+2aRPAbU59eAVA1I=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=MZzU9UDoBBZdRpuGKJxngydEV0gvUoYE5wvhu19HnMTLCkRsMDjIVwo5aUzShLcr3
         5sib9lJsnKHCZ1/9k7jAE+hNPu9hIIHxzZcESgEzSmi8DyGsZJA5gT6SZEzWlNT/1R
         Fqfe6Df/8YaF5a6wch2jDd8ojGsPnEba5u0YUOXqtL1K/UEr3cxePTLtpIGlbtMeSn
         Ef+ocSfsLXJNJd44NJsTOGaEi+1JV1HskEKH4+/vh4R7XkrhoIDwgR+kUOL5elH34t
         pp5QZZDYTQWgqRhe37IKM6nh3CZt6Myn5YKWBsvprXPvNjl+aeJI4D9Myvd3lOVu6W
         sYJzTQd1FPwbQ==
Received: by mail-wr1-f71.google.com with SMTP id h5-20020a5d6885000000b0015e21e37523so3554326wru.10
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 03:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6nkF1q/vzOOF+WmaUamUG6Dayh5+2aRPAbU59eAVA1I=;
        b=tQdV40EocCpmicnUxHpBv5F3ei/D9ohSBdjhhHWk5uV7AtV2lWcjT3Dw1XcSPx0YLS
         j7ikZUifOB8XspLPRvnF28eywhi4f47Q63Y/2pB4ATzA4Tb6pf/Q0SLHQK9KC8Yp72Xe
         n8P8x7uBqMPAl4YIfCmxLLEqkmCLz8e6++e5URdwOrqnUIWUB+Palo2FihhZzSol523/
         fQQqHLVmmP/4B0FsAXYpO1oAlZEJsUJZXd2orm/AULA/Tfozr7B+ucYGIZgY8NYBfqKk
         8Mvow9i52Eo+t0ycLqFAhGUX+E3EYmkP1Wn3aNJMaHO7OYBz3jrmzaF7xGG0q5C94HB6
         PwUw==
X-Gm-Message-State: AOAM531fVP/BqvzwrYHucOQNhjRiU/qQA3Jst+BD8nE+DqwKQR+M7oQT
        6dzTs5ivzX+kb9lP97pvX0LZf8CXu3MJ+zPXKkKwY2UMhDxLIiXc6gEacEyen98w8b2X3oHTUdT
        A+HSLrIJ5L33iEGRlMDPEBM/ypVpbk2Vi5Q==
X-Received: by 2002:a5d:444a:: with SMTP id x10mr11203592wrr.360.1631874551392;
        Fri, 17 Sep 2021 03:29:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfdrM+fEx6KhlE7ltFlZ5KnPF9rsYVzDu+ZzxcU3gF6vhY10MhrnkMCHgNj6YnhxdkkVbRow==
X-Received: by 2002:a5d:444a:: with SMTP id x10mr11203568wrr.360.1631874551216;
        Fri, 17 Sep 2021 03:29:11 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id d8sm6651413wrv.20.2021.09.17.03.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 03:29:10 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-staging@lists.linux.dev
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Drake <drake@endlessos.org>
Subject: [PATCH v2] MAINTAINERS: Move Daniel Drake to credits
Date:   Fri, 17 Sep 2021 12:28:34 +0200
Message-Id: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Drake's @gentoo.org email bounces (is listed as retired Gentoo
developer) and there was no activity from him regarding zd1211rw driver.
Also his second address @laptop.org bounces.

Cc: Daniel Drake <drake@endlessos.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Drop also bouncing dsd@laptop.org.
---
 CREDITS     | 1 +
 MAINTAINERS | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index 7ef7b136e71d..d8f63e8329e8 100644
--- a/CREDITS
+++ b/CREDITS
@@ -971,6 +971,7 @@ D: PowerPC
 N: Daniel Drake
 E: dsd@gentoo.org
 D: USBAT02 CompactFlash support in usb-storage
+D: ZD1211RW wireless driver
 S: UK
 
 N: Oleg Drokin
diff --git a/MAINTAINERS b/MAINTAINERS
index 15a5fd8323f7..84ba171c85c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17839,7 +17839,6 @@ F:	drivers/staging/nvec/
 
 STAGING - OLPC SECONDARY DISPLAY CONTROLLER (DCON)
 M:	Jens Frederich <jfrederich@gmail.com>
-M:	Daniel Drake <dsd@laptop.org>
 M:	Jon Nettleton <jon.nettleton@gmail.com>
 S:	Maintained
 W:	http://wiki.laptop.org/go/DCON
@@ -20750,7 +20749,6 @@ S:	Maintained
 F:	mm/zbud.c
 
 ZD1211RW WIRELESS DRIVER
-M:	Daniel Drake <dsd@gentoo.org>
 M:	Ulrich Kunitz <kune@deine-taler.de>
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
-- 
2.30.2

