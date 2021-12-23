Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0747E202
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347883AbhLWLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347881AbhLWLIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:09 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF5C061756;
        Thu, 23 Dec 2021 03:08:09 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id p7so7714600ljj.1;
        Thu, 23 Dec 2021 03:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AIxig2RTBFVfYYo4FfiMlQHzX8KyhSHk6+94kt28iGg=;
        b=gMCx5RVpM32NN7w2NYmYUxYXwhoEhd4MjYxU+eKuI2A5dBkdYinO+Cur5UAk8X+f5n
         W2QwQu/4SgHiAmC58cPDmpRg3HgS+w91jz0/TYal2hzYJ67AKihM7nihEeik0MmWGCPn
         qCJMZPOxY34rvYSGcwK6TehYh2KDEID84D0IPJkKBkgPLt35ihmGTZ53Nwy3nMQBxkEV
         5iEGajcP6Myhsgprkg4UB56U8+LRHo/83JP96bQyD+ecHXkQ6LLval5oH80JAlEGxWmD
         j9FhP9LV/miVnExuUdInTwNF6iQGQ0CbzPq2ruhesSYub53tfXANe3TIxezUhKKMTDP+
         Gg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AIxig2RTBFVfYYo4FfiMlQHzX8KyhSHk6+94kt28iGg=;
        b=juuKsTnifPyXLJ9/+aGKWjx53js0GbzG2svJTtO6JucvLRCts/hEOWXoqB/JgxbdOG
         XNQnsXolhAQV9+UsJiNfh81x7r30W92NYKAeQg63DpKGhsL1OQuLWm3ZkUFJiW7wgh+z
         uK2Iy+umAUGK7bxd4J6hx9EYfXUK/eWl5+kCTE0jgx8CQGGnObjAnEe7VsO4RoHooUPo
         Oew8lWdjLIaVHNWolbo6diDSKgx/8EIQxFKmfnS0tMCGVWJ0HNhxTkiJnNn/mN/ppAl/
         d4uxLRjEDfkfY7K6PYSOEsWu6zcntQHYnUmN/GTZejiDzyIXNsbyXO7BuLt19IGRcuhp
         ZJHA==
X-Gm-Message-State: AOAM532FcSKfcvSI9XQNRfXD+t6gaiKuSWPspWueivAG37ibztHwcdnX
        fgjT43T4MeBfO/BQe97ckyk=
X-Google-Smtp-Source: ABdhPJwuuf+vvycPVuTIuDiqX5ygVekHwb6hCOfnl/98iXEYjWJmMl2UW8tR5YZBfv0BKZi20LVndw==
X-Received: by 2002:a2e:6e0d:: with SMTP id j13mr1294170ljc.124.1640257687427;
        Thu, 23 Dec 2021 03:08:07 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:07 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined cells by names
Date:   Thu, 23 Dec 2021 12:07:53 +0100
Message-Id: <20211223110755.22722-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223110755.22722-1-zajec5@gmail.com>
References: <20211223110755.22722-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Not every NVMEM has predefined cells at hardcoded addresses. Some
devices store cells in internal structs and custom formats. Referencing
such cells is still required to let other bindings use them.

Modify binding to require "reg" xor "label". The later one can be used
to match "dynamic" NVMEM cells by their names.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/nvmem/nvmem.yaml | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
index 3392405ee010..83154df25c27 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
@@ -43,6 +43,12 @@ patternProperties:
   "@[0-9a-f]+(,[0-7])?$":
     type: object
 
+    description: |
+      NVMEM cell - a part of NVMEM containing one specific information.
+
+      Cells can be fully defined by a binding or stored in NVMEM device specific
+      data and just referenced in DT by a name (label).
+
     properties:
       reg:
         maxItems: 1
@@ -64,8 +70,11 @@ patternProperties:
               description:
                 Size in bit within the address range specified by reg.
 
-    required:
-      - reg
+    oneOf:
+      - required:
+          - reg
+      - required:
+          - label
 
 additionalProperties: true
 
-- 
2.31.1

