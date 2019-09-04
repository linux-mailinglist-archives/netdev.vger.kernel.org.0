Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF0A889A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfIDORf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:17:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52037 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbfIDORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:17:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id k1so3532961wmi.1;
        Wed, 04 Sep 2019 07:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VQ9zhovu0VtY5dlO+aIxXSe5qICuVntF1g5nKJaGXzw=;
        b=e2C4N8oBlhmJVogaSLPm6ruy+6StkXRVtFx/uoDRI8Eppp7bDaR69q0h22P3IxWmYG
         lBK/1zbFxO4sNfEJS8JPWDQHHXQDuVR7Ih+YBnpm60I8FCP/dU/WFCTMEyoRNDAbiwlt
         fu4zjtQRHX6BfT0Y3jqx+TPT/VJ+af56uL9Hl8BNa0w5c8SAYLgcBUkAC+mQsEwopGuY
         UbgCiKoufgP7/TtScWvnF2p/9gz7cUGae7k95/yTShePQkYlsEPpvFaAjbdtFgWpNNLc
         W4jKReqSjb2XEvq3AuKaQgcD8opxgmGD3ifB/IWn7cDHm+Jo4IpRMxJP1vZfAxJhuTao
         9IKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=VQ9zhovu0VtY5dlO+aIxXSe5qICuVntF1g5nKJaGXzw=;
        b=La31E2lEoHBbXt4JCtFuiekzQe6FA/lOCTFKuY0aPnMoTIcXeVTbgAvw+LWyRc1ddh
         7ylijahNodCfHuqvWJbfAJ/gtGs3/KN8WJwGlfmfaldEkFmZ+edp09FiBJrvh25mc6Ib
         14wAfsESmoYrIaFIWCt9erYvLHUUfRsMhdAF+VMxokxpQObz+23SVde/WqhMqJNAAW7L
         gqO6POC2MF7mx7FTuBiuTiNs/Xb8Z9n48Xr1czgBpK77x+0VyrnjVlxloAj+X7crt6Bb
         Kx66R7KDDnRfILjq+XizX3kEU2qE5WE9De/L+IEl9vuv5kT1i7KXL4iRpWqMT+n7UDqr
         7nkw==
X-Gm-Message-State: APjAAAWZkB9UqQ2VtW95EiIZxUfau8jZ4SIHGt78QiobMKcJ+gBq/FKb
        kdRWolOXJDHZFuN+2HGP68s=
X-Google-Smtp-Source: APXvYqxwSC4B/sfRKNq7HX/G79ZLS/hRbQrOxtUFfFU30szFy88WIfTAPhFGet+rSz+23qoaJojjwg==
X-Received: by 2002:a1c:a558:: with SMTP id o85mr4606355wme.30.1567606652845;
        Wed, 04 Sep 2019 07:17:32 -0700 (PDT)
Received: from localhost.localdomain (ip5b4096c3.dynamic.kabel-deutschland.de. [91.64.150.195])
        by smtp.gmail.com with ESMTPSA id q19sm39809979wra.89.2019.09.04.07.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 07:17:31 -0700 (PDT)
From:   Krzysztof Wilczynski <kw@linux.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qed: Move static keyword to the front of declaration
Date:   Wed,  4 Sep 2019 16:17:30 +0200
Message-Id: <20190904141730.31497-1-kw@linux.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the static keyword to the front of declaration of iwarp_state_names,
and resolve the following compiler warning that can be seen when building
with warnings enabled (W=1):

drivers/net/ethernet/qlogic/qed/qed_iwarp.c:385:1: warning:
  ‘static’ is not at beginning of declaration [-Wold-style-declaration]

Also, resolve checkpatch.pl script warning:

WARNING: static const char * array should probably be
  static const char * const

Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
---
Related: https://lore.kernel.org/r/20190827233017.GK9987@google.com

 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index f380fae8799d..65ec16a31658 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -382,7 +382,7 @@ qed_iwarp2roce_state(enum qed_iwarp_qp_state state)
 	}
 }
 
-const static char *iwarp_state_names[] = {
+static const char * const iwarp_state_names[] = {
 	"IDLE",
 	"RTS",
 	"TERMINATE",
-- 
2.22.1

