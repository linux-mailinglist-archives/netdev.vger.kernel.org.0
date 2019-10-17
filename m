Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB4DB5D2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503188AbfJQSVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33680 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438427AbfJQSVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id d22so1532467pls.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmIPeT1pNYHp6Vq3BvIlZwMcX4cET/mQclRZcOVT4/g=;
        b=TOVGwe+tQsB+n4yvuWw12VKT4C8MbE1Is0AOnzVXy0awBwR0JLrn55j5eohFgpFHSN
         Utkdu7siJx9nHRIUtAxRpdkwNJzgBI71mNZMqs7JXc4nHSYwi++/sh95KUySzMcl1FPB
         hnO/GxxuVLsT+G1vjYbYTmTS7hw5ZOabx0p8fzHirfKmbftO/SS6YDMFUAeYgWDZ1wl+
         PoYEd6v0vgnCqyR722va5UjnKQew5mdCTTVo+LBLUYJTMyWUUDVtS2LhFLr1TWof4R3/
         0Wc457ycD5xoEBPRuaj/+bMOhlkFJa9MZW3hstA8wkcDTAzDQPaAPMhqcBFjLOWyQwgG
         jpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmIPeT1pNYHp6Vq3BvIlZwMcX4cET/mQclRZcOVT4/g=;
        b=UOFA769APV6APzn8Z+YKqT8TM3+TEBSjW4uwXNCXB+inLE7uW2E7HSkKFrjEAcq0fm
         lorOyCwRl1klyoKZikcRZiJau+FXPmFwyHkbvfjB5FtBKRNMZ19lt0E+SV6DUEg5aFD/
         ucJADVgw0nzXytwmhd9KEjtZAhgQe4UHNigKzalQgKpk9j2ZMP/XNngncRKTH2MReSfk
         rN9Owvb51wYFLDn0iAY5/CzWRB4bbslzHrHOdHzuQ4zfpVsbD7HtZeIJ7gx8KouiDrea
         kLJn/XqC9JtoHEuK888bMgXj0C5BYM7Ba4wdBbYrPKlA7auLVknqKiUZzLYB5EVRacpw
         nsNA==
X-Gm-Message-State: APjAAAXKuuotaDGpkoBs9UwREpJP8JQ5BUw26VN5KzpyJtad89VrC6s6
        TsN9iIDRfccgK8h72x7uAUQbJh1C
X-Google-Smtp-Source: APXvYqzldWNaEQzKx6dj4k5EFOmCxoEMKhEAoVeIHabLZOw9cZFAqBDJVHQyY8M4nvXNOCJA30lCbA==
X-Received: by 2002:a17:902:654f:: with SMTP id d15mr5398602pln.136.1571336497761;
        Thu, 17 Oct 2019 11:21:37 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:37 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 01/33] fix arithmetic on pointer to void is a GNU extension warning
Date:   Thu, 17 Oct 2019 11:20:49 -0700
Message-Id: <20191017182121.103569-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/marvell.c:127:22: error: arithmetic on a pointer to void is a GNU extension [-Werror,-Wpointer-arith]
  dump_timer("LED", p + 0x20);

(and remove some spare whitespace while we're at it)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ia49b0baa9b8d00ccbe802780c226ca03ec9307f0
---
 marvell.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/marvell.c b/marvell.c
index af21188..27785be 100644
--- a/marvell.c
+++ b/marvell.c
@@ -118,13 +118,13 @@ static void dump_fifo(const char *name, const void *p)
 	printf("\n%s\n", name);
 	printf("---------------\n");
 	printf("End Address                      0x%08X\n", r[0]);
-  	printf("Write Pointer                    0x%08X\n", r[1]);
-  	printf("Read Pointer                     0x%08X\n", r[2]);
-  	printf("Packet Counter                   0x%08X\n", r[3]);
-  	printf("Level                            0x%08X\n", r[4]);
-  	printf("Control                          0x%08X\n", r[5]);
-  	printf("Control/Test                     0x%08X\n", r[6]);
-	dump_timer("LED", p + 0x20);
+	printf("Write Pointer                    0x%08X\n", r[1]);
+	printf("Read Pointer                     0x%08X\n", r[2]);
+	printf("Packet Counter                   0x%08X\n", r[3]);
+	printf("Level                            0x%08X\n", r[4]);
+	printf("Control                          0x%08X\n", r[5]);
+	printf("Control/Test                     0x%08X\n", r[6]);
+	dump_timer("LED", r + 8);
 }
 
 static void dump_gmac_fifo(const char *name, const void *p)
-- 
2.23.0.866.gb869b98d4c-goog

