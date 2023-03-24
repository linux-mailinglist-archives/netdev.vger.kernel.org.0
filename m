Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1E6C88A5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjCXW5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjCXW5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:57:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344421B547
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o10-20020a17090ac08a00b0023f3196fa6fso1073995pjs.2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rzg6K39MFKxCI/AmXcW7GFefjGn9yU81GMrZ+K3jkh4=;
        b=ZXLqXHYHKULGnPdez3dq+JMdv2XTM+3TuSjEExrAD/pWWgrpOj1NpRnVaMcL+/K5Y5
         /kHq7yNvCgdNOIHm8xqDdNx+8o1BC/R9C9rWYqK+LjdESpdAscf9S8ldtPMtoAwMvZw3
         qfM8JcfkYVHlUNZ7qbrdID2b1CfzQBjR8+n30TYpRF9O8U461KbzDz3Vu/ZqcmGWCkmK
         b/TRGmkziQE8gH4U8db17x/imnoNvQ4fGoUsi4Po7/tWuRdbpYyfg3UxnyoGG7JdXeYg
         n38KFBrsryupneRqGFaTqc2Xo4+Dcx02NXrtWF9xvuq4S6nUFweIowCKexQj67Za6X4n
         NlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rzg6K39MFKxCI/AmXcW7GFefjGn9yU81GMrZ+K3jkh4=;
        b=OYfCVgZUFcx5L+SlL8iaNRxGzhZ52/RmVIUcSVjs7Q+p5h1RsNN9ICXhbybw4z5DON
         fjX8VR4rQJCKf5pwHj2QWY9KAVK8tr4S31M/fQmYXHcNl5i5+9T5PP+aanQ1n1KTwXAa
         gQZ/f1GqBaMto2q6hmmupwVyg5VV3QIAQj9whIXfEmCgtyjlsUGnzLZ/mLzlFgHZ+vAF
         HVHxfrSPxMPfOv3oj6jDQz2LG7m/5Wb53Re01jedPmE7IFFHHRYB6G/+h6wwkBAlxDmK
         NOPzLNLVCKMvRMQH+lpwDzOrDBuFEgfKzPA2SyHMtlP+1FXJcI3PalU1TeWyBloYFrNa
         PfGw==
X-Gm-Message-State: AAQBX9cDXlh4Eqw//MZK7FBuRY3h+4GtkxTxbn/6NN13jk0FQCzHKPSQ
        jYN55HF/HnuITdSZukas4w6ti7qtF0nitQL/xQIGYDa7RUCoPldWi39csbMqN7Ucvl9atxyUQ3+
        q2p2xSNFTnR0ReHwq0IK8L0FgEBu+XFd73e0w3mk72SrG0umXM6Cy0w==
X-Google-Smtp-Source: AKy350b0qTXX/5S7jmcldUmWPHxoapa8GVX8ErPuTPBEwQV84wKAY7q/Bwd1qLhsIXppBMsXC30EyE4=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1344:b0:625:a545:3292 with SMTP id
 k4-20020a056a00134400b00625a5453292mr2449268pfu.0.1679698623619; Fri, 24 Mar
 2023 15:57:03 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:56:55 -0700
In-Reply-To: <20230324225656.3999785-1-sdf@google.com>
Mime-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230324225656.3999785-4-sdf@google.com>
Subject: [PATCH net-next v2 3/4] tools: ynl: replace print with NlError
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
index 1220314d3303..b05c341e278c 100644
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
     def __init__(self, raw, offset):
         self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
@@ -507,9 +515,7 @@ genl_family_name_to_id = None
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

