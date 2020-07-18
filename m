Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9234F224905
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 07:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGRFcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 01:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgGRFcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 01:32:08 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C6C0619D2;
        Fri, 17 Jul 2020 22:32:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e18so9086138ilr.7;
        Fri, 17 Jul 2020 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q91gtO58hCq0wdQ/qvG+6bdBUzXulWzjoOklqz06aB4=;
        b=tPI8bHuM7O1/hnnerKenngBwMqp2su1gAdMivuob9EcL4wNLpcBkR2ybiBj0u49weN
         ZKuNZzV7kJPt4mDVHYB0zb+CPx99m47mddbHkgJLyeQDXhRZJaV/46K8ZpH9SP33Mv7t
         JjZF0/ZI/5vJVUAo28HEArPh+175VeGJQUGW6Lj3t2Tvl41ZCHq3FTaXThbFcgZZiZqB
         IUp8dQiKenlN+U4miqSgkLAsdzlVZ2zq8Ew+5qIlPAqzVh4JTAC4bWdHXPp3N++eRTF5
         J+MV67J+r1lJ/r1R680Cjya6H8eNrU7FVKfmwezPG8T/ZwXY3E8LSxkOFFF3rvRYpqBo
         sKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q91gtO58hCq0wdQ/qvG+6bdBUzXulWzjoOklqz06aB4=;
        b=e790aQ3cn7wavss1AJOa0WGYYK+OnkaYzyrzrFA5IHCl6MnPmcTzAeDyQuq1NLsxSH
         9VJeXdrWucqfV6XOlvKZlKBWy0oYYfML8l84zTdx81eRYxD8Jfv6+QluX1W4v/o0Svk6
         1QmR3LUzLsiq7DIwOghoDduzGZBg+4bKKKpmdGiPPVrGt80F1nSKj6GSCiSiwtS7AGoc
         RFl9KxnIWJoXXI5XdUGzUc6wSU/z3UQciup+PkXhrhut8qqhzDwSznQC/zCqQM/XFTBu
         XDIjqRz9CBc9csSrb6MhiJxecgLOmCt9LaPK/hkFp3cUu3afLww3iuTg7upeWy9W0cnb
         KBvA==
X-Gm-Message-State: AOAM533sDqQdnGHaof8DYOUMU16Kg1jk5xLcPLnxuPJ0zvL770Osweao
        z1IHA4iz8wi2AkG39bOPZRX98iXc+bs=
X-Google-Smtp-Source: ABdhPJy3kHWp7oPphW6RdeZY/qdTQ0MDgUPNCS0Bvi4QCg37oB54GPB5SdgAjCgdbL4tohm7nMze8A==
X-Received: by 2002:a92:db44:: with SMTP id w4mr12509517ilq.306.1595050327391;
        Fri, 17 Jul 2020 22:32:07 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id t67sm2165163ill.88.2020.07.17.22.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 22:32:06 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Robert Baldyga <r.baldyga@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
Date:   Sat, 18 Jul 2020 00:31:49 -0500
Message-Id: <20200718053150.11555-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The implementation of s3fwrn5_recv_frame() is supposed to consume skb on
all execution paths. Release skb before returning -ENODEV.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/nfc/s3fwrn5/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 91d4d5b28a7d..ba6c486d6465 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -198,6 +198,7 @@ int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
 	case S3FWRN5_MODE_FW:
 		return s3fwrn5_fw_recv_frame(ndev, skb);
 	default:
+		kfree_skb(skb);
 		return -ENODEV;
 	}
 }
-- 
2.17.1

