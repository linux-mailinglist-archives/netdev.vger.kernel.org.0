Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9556E3B0834
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhFVPHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhFVPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:07:32 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2CAC061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:15 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id f5so9367814qvu.8
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5KwXJCz6ZDJvvMYUBRHhUw9tz+yXYvHIljPpXhAYsJY=;
        b=dfvcVNWpee72gjGlkhxt/ifCTRTb/7rogfp3bEokpWyHlQQGpsfqQfECpnk1MxRzRM
         LXbJn/F35CvK8Uu0CWV64mbAxqYjs17Kl6JQjfPIjY+porEt0Z8Vo47UiWmSmKDWoR9U
         aOpoAOM5sPOtaVDm7Y2h0nb1yuWHk/3oMxS/8C5pi5gV0j9g8dMbjYm4NV7m+Haigg1a
         FOuj/P3KT63EIVd8h2fki4/klFdmYREvpgtoWFYRi14GP7Hk8UPc8bZ5l87kSjX0S8aR
         XhBiq2UUI2wQ/GrRoXcVKmz42f32WhSuo7VsrndvlpVJn9Rfajp6jcwgXo2p+S9pi1gV
         Ot3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5KwXJCz6ZDJvvMYUBRHhUw9tz+yXYvHIljPpXhAYsJY=;
        b=FNPZsvem21qSaFlRqL8UAXDtc3t+aSkcVjiyiDQA5bla2zTGcAqbxj+XkEKztOvjtm
         +yOzep5b0jWHKc9sbkTsUF7CvLlKaTa7TpA7ypAHZgWOb3ernmNstJF/TD8FzRj8/R09
         o643/E6N3g9/kuwi239r/hfwqOvb5Hi2130cJxYdnPwFw/f6HMICdDSqjZOQ3ZZxI0Mn
         I7lbbHDn/Tux3HQX4kQAxFoklM6IDefn5B2hoTMu/nUQB912O4Zd58QmowQ69fCDi8R+
         K/kfYsx0Ob+ABs6EiQ+X9zhoOk7Gw/J7Fjr95o1hGd+5218BvaKiwRJXK4GfGKEtctuJ
         Icew==
X-Gm-Message-State: AOAM532vRz85R74S1drDCNFhcfSKbjMpTHuWB2TYSAZcPY4Pi7qdJdad
        GPbfcI7dRnBggx2YmupOjDE=
X-Google-Smtp-Source: ABdhPJwFmsexor+kVrrxqrfEqpDj9KbkJ82xvefQFZ/34W0XUhXdi4nTt7vDeVrTEUJ/E6ycRYhTXA==
X-Received: by 2002:a0c:e481:: with SMTP id n1mr22049660qvl.49.1624374313488;
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:6106:596a:c2e4:c4f2:9f1e])
        by smtp.gmail.com with ESMTPSA id g11sm1791973qto.91.2021.06.22.08.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DBF16C0780; Tue, 22 Jun 2021 12:05:10 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 1/3] tc-testing: fix list handling
Date:   Tue, 22 Jun 2021 12:05:00 -0300
Message-Id: <2ba12684b1e79d0ab8214d1198441cf1fa6bd31f.1624373870.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624373870.git.marcelo.leitner@gmail.com>
References: <cover.1624373870.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

python lists don't have an 'add' method, but 'append'.

Fixes: 14e5175e9e04 ("tc-testing: introduce scapyPlugin for basic traffic")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
index 229ee185b27e198dd1a1ec7a4408751e54428d60..a7b21658af9b463cef8c9b3d4023f222426f239b 100644
--- a/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
+++ b/tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py
@@ -36,7 +36,7 @@ class SubPlugin(TdcPlugin):
         for k in scapy_keys:
             if k not in scapyinfo:
                 keyfail = True
-                missing_keys.add(k)
+                missing_keys.append(k)
         if keyfail:
             print('{}: Scapy block present in the test, but is missing info:'
                 .format(self.sub_class))
-- 
2.31.1

