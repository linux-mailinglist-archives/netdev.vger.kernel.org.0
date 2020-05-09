Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FF51CBDB5
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgEIFWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgEIFWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 01:22:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4429C061A0C;
        Fri,  8 May 2020 22:22:43 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so5249492pjh.2;
        Fri, 08 May 2020 22:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IW9oMynxNbAxIXq+iueR3C41x5az9WQ9tDb3Pf9cYdw=;
        b=cPAyWuaLwdCNR2vGJgdea+viRdTO0ouN3kqkaLUFGl70fDhNwYArUIPYcGG71KqqRS
         9Ot7KrjSiKwOVvICVun6qOt6jhOSSTnO1/SVDRss+Uw7z7lUwPS3YrvrrsCmiyX+Jn60
         Ye0h9Y0rcpgOWe1hRgKFl1dVMPe0XkwXYvRIWiUpaEyg54OPS1TJTE2VSA4sVvgpMEku
         pM9/AsPE4cV+Rv/QqCa73j/MLMTQgpS7PkS3aMlvIvcF1zdKxivl6mfJWZb5+Slb1Kai
         /7SixSPEbdBJsDSo8Gb1zmrhSHGYsQE20OQ1Xlary/MKIIO8odDX1riWKO2Lx0Oy0h4V
         owgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IW9oMynxNbAxIXq+iueR3C41x5az9WQ9tDb3Pf9cYdw=;
        b=MoFbLzFF76yJJO24YyL5/wvS6TqvLymi7oQgZ/kRTRuMEu81JwRYey6QDywG6M1kZy
         wqtrIKwSvlefSPpdAg9iaNcM7YXDxQzKDskdsr3dg19zKSLf2yQbwyj1zT/fGm1ednm/
         zOMKRwG9QY6A6XE+1qvyRUXcZ31L+apO9ECNaJ1+9xHCP3kIwLsrgmAF9gklNE7nQgcy
         BE53ak0WZt0Ay9NI/ZnT3J0jeQrkKG9GIHe5UkEGu2EFy+9BmD58DnQe2TbQKHJkZ/XO
         8n3AdG0tLu4dzhqHwB9QTmCoxJYq5Orx/MVm4fasJ7YDJ3ZmVTfOJoikH6hLKY+Neyx2
         vDFw==
X-Gm-Message-State: AGi0Puatlft09JpwMHgwxaM2wwpTLb1GLoBG6TNnlKykRshINi/VIbdD
        qGIqfuvcLJmgPgTPDHVQpM01LnxO
X-Google-Smtp-Source: APiQypJLCbFI5YC0NeudLv276IpktoyrHFBQJQWK1RneRAHqqPuE11PDVQN9gyhjXxBNrgjiDV5Opw==
X-Received: by 2002:a17:902:aa44:: with SMTP id c4mr5527420plr.302.1589001762957;
        Fri, 08 May 2020 22:22:42 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id n10sm2620454pgk.49.2020.05.08.22.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 22:22:42 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID' packets
Date:   Fri,  8 May 2020 22:22:35 -0700
Message-Id: <20200509052235.150348-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This appears to be a common, but hard to debug, misconfiguration.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libip6t_REJECT.man | 15 +++++++++++++++
 extensions/libipt_REJECT.man  | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 0030a51f..b6474811 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -30,3 +30,18 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 \fBtcp\-reset\fP
 can only be used with kernel versions 2.6.14 or later.
+.PP
+\fIWarning:\fP if you are using connection tracking and \fBACCEPT\fP'ing
+\fBESTABLISHED\fP (and possibly \fBRELATED\fP) state packets, do not
+indiscriminately \fBREJECT\fP (especially with \fITCP RST\fP) \fBINVALID\fP
+state packets.  Sometimes naturally occuring packet reordering will result
+in packets being considered \fBINVALID\fP and the generated \fITCP RST\fP
+will abort an otherwise healthy connection.
+.P
+Suggested use:
+.br
+    -A INPUT -m state ESTABLISHED,RELATED -j ACCEPT
+.br
+    -A INPUT -m state INVALID -j DROP
+.br
+(and -j REJECT rules go here at the end)
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 8a360ce7..d0f0f19b 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -30,3 +30,18 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 .IP
 (*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
+.PP
+\fIWarning:\fP if you are using connection tracking and \fBACCEPT\fP'ing
+\fBESTABLISHED\fP (and possibly \fBRELATED\fP) state packets, do not
+indiscriminately \fBREJECT\fP (especially with \fITCP RST\fP) \fBINVALID\fP
+state packets.  Sometimes naturally occuring packet reordering will result
+in packets being considered \fBINVALID\fP and the generated \fITCP RST\fP
+will abort an otherwise healthy connection.
+.P
+Suggested use:
+.br
+    -A INPUT -m state ESTABLISHED,RELATED -j ACCEPT
+.br
+    -A INPUT -m state INVALID -j DROP
+.br
+(and -j REJECT rules go here at the end)
-- 
2.26.2.645.ge9eca65c58-goog

