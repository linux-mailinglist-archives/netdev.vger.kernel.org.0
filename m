Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9566BF6E2
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 01:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCRAXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCRAXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 20:23:49 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D184519C54
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 16-20020a056a00073000b006260bbaa3a4so2437092pfm.16
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679099027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXWQq7pZNb2Qr91BMJaQI2TVkAr5dxBPMbErA++ZpiQ=;
        b=SPdzF7ivLePZIgv4AoletMKSNrj7akdvi+lbyvjavEEipFcxXPNgJiURl07I/PT11J
         n/gxz0vyi78oAexwWxJVH1/oNjWFxe/Y5hEK2tPVzOpTCSXDzUDYGv0phrwR6OPSt2QF
         jSKB+VNOfUXwMmgceRtp1UC9mjpk73huVS/N+3wen5YZDvwxGqccDiVDi858HYF2jQVt
         ukvB7mBFsuBtmx+ztDvPlFqAwhOzWCF+y0ID2Kzz5maHYf9pQEu6xPrB8sZ8hnWISPla
         UPgzWiyf5QW/Z1fcarZhC8GRHzSo9Q2pZTK7+zbJCBFPemWYGD2RKbWoG4QYvRhylJCs
         ZpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qXWQq7pZNb2Qr91BMJaQI2TVkAr5dxBPMbErA++ZpiQ=;
        b=kbtCm5nLEFe6+ypDi8p14Dtwr/Y4ctLEWLXq2Xnox265hLBbrMd51WlI/JVd/HRokl
         i8q4zKp70GrwX1LjDVFfsiCHOMAVVkHlp+Kxts2fI78pGjMBN0qFb3fdhE88PfaA8MxQ
         fq9goCvI/P7T79pbkZPSRISuLElxkp0iXd1eW3I1oyczj7oPPKN55/9a1ICllr1zgu5p
         t5y7AEDKhv/B8/bGum1Q/0HCNpHLHy1CzVEiGGqxEJx+BRVzOeYJXPlk2dfySWqlU2Tj
         EXOZGVa+W5kh7FGVzBuPgZ8vxXC0ObMG9SSWSriOH2jfqWiRp+JB51earprbehG/mATb
         aqwQ==
X-Gm-Message-State: AO0yUKVUdxnJgp4o9cgCJF8pUnkU5OIxKa6BqWQF8x9h8d68mdoPYgmm
        a68klQhBQPjIWyoSr8fG8FoQXz4f0dj2U2KLAkh0FTcWWtqWc7DO2eMj3Qx/fRPeUfOVGwq9rdt
        inELu6UKCNl8ie4ctnToVIvajtoeuWjUkBiNwK5l4LW9J7S7JD+BszA==
X-Google-Smtp-Source: AK7set9daD/UTdoiY36srGAEoCh/G9GbxZfRMDc4PLs5bYPJZ3AQ2mhOpF7S6VzkCI5uTZ2aAO8IWG8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1a8e:b0:61c:67d2:a332 with SMTP id
 e14-20020a056a001a8e00b0061c67d2a332mr2165833pfv.3.1679099027250; Fri, 17 Mar
 2023 17:23:47 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:23:39 -0700
In-Reply-To: <20230318002340.1306356-1-sdf@google.com>
Mime-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230318002340.1306356-4-sdf@google.com>
Subject: [PATCH net-next 3/4] ynl: replace print with NlError
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
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
 tools/net/ynl/lib/ynl.py | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 21c015911803..6c1a59cef957 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -67,6 +67,13 @@ from .nlspec import SpecFamily
     NLMSGERR_ATTR_MISS_NEST = 6
 
 
+class NlError(Exception):
+  def __init__(self, nl_msg):
+    self.nl_msg = nl_msg
+
+  def __str__(self):
+    return f"Netlink error: {os.strerror(-self.nl_msg.error)}\n{self.nl_msg}"
+
 class NlAttr:
     def __init__(self, raw, offset):
         self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
@@ -495,9 +502,7 @@ genl_family_name_to_id = None
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
2.40.0.rc1.284.g88254d51c5-goog

