Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4441453E3
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAVLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:35:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34669 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAVLf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:35:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so3365013pgf.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=LfqOfJrqdoE3fZkzWLNk39t0NJZLn1Prv0YvkB7gL53HSOM49XhMgnezSGfycdaEUI
         zdgPNye7ASiNBpB1KhUW718cl6uC23WDi3SlWEzN5WNURN+rubV+qlDBpM/E4VkcdKhg
         YGeHtVBfOasE6EeNnhi6Nohv28qxRPfjB80RNSDVErPol31qwHmbSHE/YQ9Dqn5AQl6t
         o0ePAJEtvxtV9HePTq56iHTRR+WKeOCj2lkKTn9dsYFRrhNESWbGLbX6npcMSQeQlawk
         uIAWOhqID325MwCuAH+ftPp3n/juy1Sr3mWzAYmBGwnzp/aqkLEXzU8mIrS823yJyhQ4
         7+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=FQ/ATTzJ6o7G0sNR8TK0DMfUx6laqCHXLDR86x0N1TFyojy2JVlLHlMwVE9O+GfeFl
         AJtkBaOxoxOL6jtp5QVv9Mw0aoBZhmu08cnfXunwZmQBGRR/J3L03ltlHecIk374WgPE
         wocX+7gipvx7unFuBnB2OGyfozw7LAdgq7Xu+io0cP/w5Cgx/CglyvGHMiwK0/t4JzTj
         iBLAU6BgMZfeQou//3eT/TKzL+HcOGAzgnu9nYoufo7nL/ei2lY8q33MmJDc12+/2DJw
         OgPFK1jSet3WeDHttkiSJw07lgxl2qZFS4HJtqgUiaivZ5UUZ2PPdQRbHo6ZgIwYctbm
         eMBA==
X-Gm-Message-State: APjAAAUmLWu9VGqvIU+OD1FtN5yQh/8Irn8bE3A9mgyZbVZbl5PXXiI/
        Z/b3OJu+KZ9bjebH6my69tQCAbTE4Y2T9KK5
X-Google-Smtp-Source: APXvYqyCV3nzKEz/chWOBDaOFCM20jcLl437Ca7RksVZQnunKYdUEL3Zr+GEV88EvaFkmI48rURx6A==
X-Received: by 2002:a63:213:: with SMTP id 19mr10810643pgc.160.1579692957311;
        Wed, 22 Jan 2020 03:35:57 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:35:56 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v6 02/10] pie: use U64_MAX to denote (2^64 - 1)
Date:   Wed, 22 Jan 2020 17:05:25 +0530
Message-Id: <20200122113533.28128-3-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Use the U64_MAX macro to denote the constant (2^64 - 1).

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 440213ec83eb..7ef375db5bab 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -10,8 +10,8 @@
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
-#define DTIME_INVALID 0xffffffffffffffff
-#define MAX_PROB 0xffffffffffffffff
+#define DTIME_INVALID U64_MAX
+#define MAX_PROB U64_MAX
 #define PIE_SCALE 8
 
 /* parameters used */
-- 
2.17.1

