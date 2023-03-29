Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2943D6CF641
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 00:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjC2WRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 18:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjC2WRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 18:17:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26355558F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:17:03 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m10-20020a17090a4d8a00b0023fa854ec76so8277217pjh.9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680128222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=epfKBlzUVvyn35Xi+taikuVIs64+LMMfUWi8M7oQafc=;
        b=lsJ9cP3Ou8LGHQ1M76+jeHMIOVDJquQhOft05WM9QgFjSKzbePlwTQkVHDySF7DAjT
         azaPAhz2sevwJb6v6JonGB6NTDX/tY6dbtY/mGZOR6BsX7C+oJYaCexOxcbtZ2Vy8yDC
         fMVvCNmbsvmxThoF+AKeiQmps2bmNPzcsIudyhELBpCevQX6w0wvsxOx/T2uXrKvtQ+P
         vbIzbF0f+Ga95mWIN/YPKDvlBB2UrDsNXZJ+GQ5ujWNkgtQa3bT7wKTLuMyHw4GmIKMm
         0STg4lNQTwmmrKbnjSZUYBp4xFBmX8z/7vrMnqEWUdaywacUJi6uA1Tr+d9I4bLL8liS
         HNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680128222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epfKBlzUVvyn35Xi+taikuVIs64+LMMfUWi8M7oQafc=;
        b=0vv2dqj246oiDyRloXnnMCmkDeOj1w+VhFtWCI9sKHXferE4/SN9jckABjuVy7MdmR
         ZoN4iSCksU57HCvvhdSSsAm9AvV8te5BG8ZfumEYJiNtarjg48yEmiAVzHb6bdECEwMX
         licFD6DuZzAQoLYxvVD0VuOvkq6v+xSh75Md0oYAtH6BMiYM9f0noD8eg9V58F7cuIkl
         5M0QGQe+5sG2NBI4tltCjd807ua3GHG+vRqHhldfvn5ZDRCWygIzWwOYz+78DkJGuVKB
         dQaKP0iFQ4DREuY9wr+fPQHm6thnrMyvUejyjVdaZuLiIh9TCKPh52zTHdAzrxMJJ89a
         JcxQ==
X-Gm-Message-State: AAQBX9dG0T/t5hkOEbPcby2HQClOCPYfQ43RgTfG5m7osLQYRiR4GV2W
        zAshZQEldcWDgqzStmG+qKCPcBbhtH0/QkTZtAx+wKvI+1I4NZxtYsM8ZtpZEjwbGC0OL6SMxNw
        jE5+kY63pc8lNuvxP91cOhou0MQwLbjli3+I0FXt2m4nJ9dHJhjF/NQ==
X-Google-Smtp-Source: AKy350ZW5RwhRjtfft6UecrzvWsYAAjXaD3CfpNIcFl12yZ1v2a1tLXR2X65YxyTHRse3ZCbYfn+Nxk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:4d1:0:b0:50c:a45:1f99 with SMTP id
 200-20020a6304d1000000b0050c0a451f99mr5897425pge.8.1680128222348; Wed, 29 Mar
 2023 15:17:02 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:16:54 -0700
In-Reply-To: <20230329221655.708489-1-sdf@google.com>
Mime-Version: 1.0
References: <20230329221655.708489-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329221655.708489-4-sdf@google.com>
Subject: [PATCH net-next v3 3/4] tools: ynl: replace print with NlError
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of dumping the error on the stdout, make the callee and
opportunity to decide what to do with it. This is mostly for the
ethtool testing.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/net/ynl/lib/ynl.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 8778994d40c0..373c0edb5f83 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -67,6 +67,14 @@ from .nlspec import SpecFamily
     NLMSGERR_ATTR_MISS_NEST = 6
 
 
+class NlError(Exception):
+  def __init__(self, nl_msg):
+    self.nl_msg = nl_msg
+
+  def __str__(self):
+    return f"Netlink error: {os.strerror(-self.nl_msg.error)}\n{self.nl_msg}"
+
+
 class NlAttr:
     type_formats = { 'u8' : ('B', 1), 's8' : ('b', 1),
                      'u16': ('H', 2), 's16': ('h', 2),
@@ -551,9 +559,7 @@ genl_family_name_to_id = None
                     self._decode_extack(msg, op.attr_set, nl_msg.extack)
 
                 if nl_msg.error:
-                    print("Netlink error:", os.strerror(-nl_msg.error))
-                    print(nl_msg)
-                    return
+                    raise NlError(nl_msg)
                 if nl_msg.done:
                     if nl_msg.extack:
                         print("Netlink warning:")
-- 
2.40.0.348.gf938b09366-goog

