Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88A041720
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407721AbfFKVsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36802 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407712AbfFKVsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:15 -0400
Received: by mail-qt1-f193.google.com with SMTP id p15so9040756qtl.3;
        Tue, 11 Jun 2019 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PresJl7oJlXIEHHC/IExtDBOZnrpFJgCQRhAg3ApC4U=;
        b=uxCh8Pugjb4tk3ieGWCto/bcWqHBA2VaCGGcw8kol7mD43R3w8INt4InkUJJMOw61d
         RmPEt2pc5tJpHF1pH4kxH+TTWmUraNsCyBP6KsEuqmsCRc7lxwlS+snNPw5Fvc+76P1k
         fQYOTcvJTe+uTi0/20Ev6c5Gd6nUpX7sbgdnidvwxSWDxxr4fPkCqDT2wV3BfK0ZcGZi
         cq6NOh3OXD75DybtVJLErl0inSHHte8nxF1cGs/UM5tV36Gzl69jG0UR8Cd/1Snfmzh2
         zrLM7nzyE33XrVAdDf62HW88kCvlFm24+U9MGGxR9ZiJvNVVUkRhCJYdRkwc4RKxOp5b
         70eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PresJl7oJlXIEHHC/IExtDBOZnrpFJgCQRhAg3ApC4U=;
        b=L15ipruIkVZHs1nSQ4eNNHF+FF3Ou7kgxV7nqzYFK6og4Wj81qvrihaO7svoHuGJQW
         o6euPf0VdMn8AWf89kE4wIIJtNnVZH5AzlK8RqelNdFfFH+f4rD6/q7W0S9mDT2DBjsg
         fw5LOzbzwZHTJ6qP2Jwc45HhhUMOi813riqPjmqYzblzuYc88yltq32t9qbEymYKxoKP
         37RyysPFW5M9y9Ya7PW3lejX4XTQ03Vt3GBkZGqg2L0WPgVKmV6jXQfEOp+RZWHuWm60
         Ab1fYrR4OCa4fB66AFTD0ZToydtRkQ6lNcIjr3gZ56Q3iZfhWh+OWrJVK2tgKcGgKe9l
         eNEQ==
X-Gm-Message-State: APjAAAXO074clqEVPu7tHVfHRhm4BfGfrx2lOfMlZPKx3ApImaqCX/0z
        cfV1kzE5QQfZDESro8fxzOBWLK1KdVM=
X-Google-Smtp-Source: APXvYqynBoW97Yhg6k90xh5WNliD1E+rqnvkhw23DLWGyfPeVC714W7xavm5WD1mBVYUICD5qzERZQ==
X-Received: by 2002:ac8:19d8:: with SMTP id s24mr66656560qtk.44.1560289694747;
        Tue, 11 Jun 2019 14:48:14 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f26sm1064392qtf.44.2019.06.11.14.48.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:14 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next 2/4] net: dsa: make cpu_dp non const
Date:   Tue, 11 Jun 2019 17:47:45 -0400
Message-Id: <20190611214747.22285-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611214747.22285-1-vivien.didelot@gmail.com>
References: <20190611214747.22285-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A port may trigger operations on its dedicated CPU port, so using
cpu_dp as const will raise warnings. Make cpu_dp non const.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 82a2baa2dc48..1e8650fa8acc 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -181,7 +181,7 @@ struct dsa_port {
 	struct dsa_switch	*ds;
 	unsigned int		index;
 	const char		*name;
-	const struct dsa_port	*cpu_dp;
+	struct dsa_port		*cpu_dp;
 	const char		*mac;
 	struct device_node	*dn;
 	unsigned int		ageing_time;
-- 
2.21.0

