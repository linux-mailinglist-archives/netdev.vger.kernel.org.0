Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA22628EA38
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388988AbgJOBe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732241AbgJOBeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:34:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C54C0F26D1;
        Wed, 14 Oct 2020 17:17:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gv6so761636pjb.4;
        Wed, 14 Oct 2020 17:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q5OVoE3pJbhdauHqlTDobbIRkF4tseIWuc4U1qOzq+k=;
        b=A/Z6g0IJ6RJqvoV2/izYHd/zFI83zBsUvMQMKk+wJFD0U7iXs69ZqVHfm1gCLTtw1c
         jSXGeZxxttxmRx50ZBSCb8D+fru54qFF/caQxWmrmhVbbhq8KegiZLd150mvM7Eb+4wI
         7zh92ZN0K0zA3zociLwYzzbSzZbzd4P0iCwiUAkdHM/b+QFmSigWQ3A0S/WFaarzgIbl
         M5UlnQZjT6+dXqdDkSqwb3hW/fAuXH3exOe4A2Plkch6mSH8ZOcM3ewVfyRmy9Rvoyjr
         9k1K2GRsGyzkE0pQcl4J4Y5BDBGFuIH4Hhnq9aRv3TbZpxT6pQBHHVM2Ru7+8SIZx5UK
         lm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q5OVoE3pJbhdauHqlTDobbIRkF4tseIWuc4U1qOzq+k=;
        b=fZEwW0AsutYKAZNHrPm48o9qSwOhKc7E6cXtTdNvbrEOABJZ5CrbOSCU5IUonvf2MX
         qOtOcx8bIBBBZF/3hr4E0yOUInYA0JtNPay8entU0gNy3jZQXCmG2f6dNW/vh47zVnU/
         1N4KoBq0eGdjkpBnqA2MwW90hIZTekM4bJJnfNYIP46eWThrRgaFRGV0qzHU9ZO6ecc7
         mGP/Y1ApPoV71z5lgn3e9UUg7r7TEcakCxrjoXv4GeKnmedFTK0W4iuxe8GkcLPDa1nV
         wTZ/KTePARvN7sFhV7wz7zffRReRIawjHnV+jw3lP7WeHqR9isSliC9v3yV0pZM6oncJ
         0+jw==
X-Gm-Message-State: AOAM531XcvedT+YCKJvmPBvsZTKwi1KkmiCnWSNltCxpZ2puDiW5MnP2
        puk40wvNhJ0gLgq8GnkDG9/4m9HixA/6hXNo
X-Google-Smtp-Source: ABdhPJyXZSnNq/7NhUpZFjrT3ftcuE/CUx4RBJZ4VuG77OQfBJ/DtHJujHyQvVgyCv8CE/jz89HZsA==
X-Received: by 2002:a17:902:be06:b029:d3:e6c5:52a0 with SMTP id r6-20020a170902be06b02900d3e6c552a0mr1392257pls.77.1602721078145;
        Wed, 14 Oct 2020 17:17:58 -0700 (PDT)
Received: from localhost.localdomain ([45.118.167.204])
        by smtp.googlemail.com with ESMTPSA id j24sm738040pjn.9.2020.10.14.17.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 17:17:57 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH] net: rose: Fix Null pointer dereference in rose_send_frame()
Date:   Thu, 15 Oct 2020 05:47:12 +0530
Message-Id: <20201015001712.72976-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
either global ROSE callsign or default port, but when the former block triggers and 
rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
dereferenced by 'neigh' when dereferencing 'dev'.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
rose_call initialization.

Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
I am bit sceptical about the error return code, please suggest if anything else is 
appropriate in place of '-ENODEV'.

 net/rose/rose_link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index f6102e6f5161..92ea6a31d575 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
 	ax25_address *rose_call;
 	ax25_cb *ax25s;
 
+	if (!neigh->dev)
+		return -ENODEV;
+
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
 		rose_call = (ax25_address *)neigh->dev->dev_addr;
 	else
-- 
2.28.0

