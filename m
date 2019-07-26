Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F6C766E9
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGZNGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:06:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35428 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:06:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so47624438wmg.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 06:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/jacX4raO+gSjEjjPalf4Eo+H/2OJFwD/3R9MxkKqU=;
        b=lq2+SiCFcPKOO02SSbZqzR3+Ofac1SMa5CaG5WTD2ohc6zWIuZAObxiLe5zOvWpwut
         Nia3ci2E9JHanf2SQ1BpbH5qCFHUv+xlNQvk86lGpLxFWOg+T5GaorAKF8PJ5vZcYrBa
         /SD9Dtf4AH0ELmKsO8dZfJEr/3xcPReECV+FelFQKja1PgFczK5CCsYLMbFd3n5s1gP8
         QoLiGdzL/kTObguF3h+IH7oNDXNChkHGCsuHBEMbjGISxNAIdv1tNyC5txHRvPoLPcOO
         Z7v4+GZeqF3uCBFYP933J2KKtpbjQeco89tOfX/zEMP2IzMnraX2UbRV44xjqcW213/d
         VrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/jacX4raO+gSjEjjPalf4Eo+H/2OJFwD/3R9MxkKqU=;
        b=NnWy2wzu5ZZEEAh7xUTcRjXExZcWMy4Q0BoQCrWakZ96W0dQK35x8V3XlRvmMumcMT
         JaUZNsdjHFCBKojFLa5hcPqrnIWlHMOeZkjURgItDqzheeYz6hUI2/QPaZK6FSuwpKCn
         pXYiZo4HNvcpUQkrP5Gq30fSVdTmY98mSLOU1dybxInpF0/SA0gRVH4gyFFYWlCCn9Ru
         rMKt6V9oSIzHoPNg1FROSyuwxEhh9QAT6bU6WbvAd7ovcaiZXQUYNRI63rZAXLQoEM8I
         pbRAlXn7J+XFH+gT/87FWEPF52LLEVTSPWQEjelURL5PbHghweC4dfW9uh7qz4nycYnp
         E+vw==
X-Gm-Message-State: APjAAAWQQBeiS3yAuSqkd/BOFrYp6SzbQKGZsTwrf9q1M/n/GB3MojqG
        eJcZQ9OUxIaOik5P+UgyED92zM4T+bLBWA==
X-Google-Smtp-Source: APXvYqz+mIPPVrTc01s6hE5Puu+RqqB++xPFx2cZI3wJOIFYDXkcn/Qm/e947Rqv0GN168jbNpt00Q==
X-Received: by 2002:a1c:f408:: with SMTP id z8mr59757131wma.97.1564146400296;
        Fri, 26 Jul 2019 06:06:40 -0700 (PDT)
Received: from localhost.localdomain (lputeaux-657-1-239-64.w80-14.abo.wanadoo.fr. [80.14.206.64])
        by smtp.gmail.com with ESMTPSA id z6sm46848891wrw.2.2019.07.26.06.06.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 06:06:39 -0700 (PDT)
From:   Antonio Borneo <borneo.antonio@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] iplink_can: fix format output of clock with flag -details
Date:   Fri, 26 Jul 2019 15:06:09 +0200
Message-Id: <20190726130609.27704-1-borneo.antonio@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The command
	ip -details link show can0
prints in the last line the value of the clock frequency attached
to the name of the following value "numtxqueues", e.g.
	clock 49500000numtxqueues 1 numrxqueues 1 gso_max_size
	 65536 gso_max_segs 65535

Add the missing space after the clock value.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
---
 ip/iplink_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 5bf490a9..735ab941 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -545,7 +545,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 		print_int(PRINT_ANY,
 			  "clock",
-			  "\n	  clock %d",
+			  "\n	  clock %d ",
 			  clock->freq);
 	}
 
-- 
2.22.0

