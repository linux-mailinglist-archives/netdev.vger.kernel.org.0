Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25C64CE632
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiCERPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 12:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiCERPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 12:15:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4A82B7F0
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646500495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0l403f5Mr+eL7bpML0lL2OSBYrG2pVDxEyNmYkFEjMU=;
        b=LvmQT+PpTxFRxtL7xE2722qN/z0xZ2OWar0IEzEPI7UhYmqN5wS70Qe+BmDuvyWHgYvrtS
        7o5XOj6fbNl5moi6dTjuYn2HEns0KtZa2sOSveQggRjC450CEsTIJ5PwmVRNJl+6PrKOk3
        mPiNX/8ewwLZM3aBjwytLHGLsXwy05I=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-GODLXnU4OQWBqs6_oknnMQ-1; Sat, 05 Mar 2022 12:14:54 -0500
X-MC-Unique: GODLXnU4OQWBqs6_oknnMQ-1
Received: by mail-qv1-f70.google.com with SMTP id o7-20020a0cfa87000000b004352258d2d1so9080468qvn.10
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 09:14:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0l403f5Mr+eL7bpML0lL2OSBYrG2pVDxEyNmYkFEjMU=;
        b=S950tg9Ctrc7t//1F2vD++mTlxY/xxywJ8il46xtbnjmIvWLZ93P0yJzwBDaa+zRGx
         N8QI+kAmntnh0JKdn4cGqa5LpkLIT/vLRDgNB5uhjjuxxHrfghHvDJQxZNOGCxKnFSlj
         ajv026KbZQ3KfRNw66g1XKWioe8jTPpZZyUc35Uya81fBBL98S/Ku++IWczluznXg/Ti
         o+FSP4quX+cGPgtDddYmfkQc41vPuy28jRqkjZmBLDKpIVCGxGs+A1kVSaHbiAMi/tdi
         N69CZwvONEoRcVHnDKWEtZBZZer8FXqYt20ajB4Vnp+J+LimOpYIh8QemkVRqmx236Tk
         Ud4Q==
X-Gm-Message-State: AOAM532lsN6N7/cIQiYhWO5Qe+dKiQUrx3/RcDepqh22vC4sXvJQ1d6s
        xbz+TV5KgHz+NWJXovfH0J5yjhx1m0GBSogcSpPpvfwhgv2gpNYwvwIMiffkG/JnujVtpiy6UWW
        oUs8iWmfHeix6Vj+x
X-Received: by 2002:a05:620a:4006:b0:67a:f431:dbfb with SMTP id h6-20020a05620a400600b0067af431dbfbmr1687592qko.733.1646500494095;
        Sat, 05 Mar 2022 09:14:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/CSIyOclA3zgRSv8u7wpyWf8o7WbJ+0Kc40wi5YWUyKIdoknnxnBkCjzOU1XHq7D0/kOm0Q==
X-Received: by 2002:a05:620a:4006:b0:67a:f431:dbfb with SMTP id h6-20020a05620a400600b0067af431dbfbmr1687578qko.733.1646500493882;
        Sat, 05 Mar 2022 09:14:53 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id g7-20020a376b07000000b006492f19ae76sm3908647qkc.27.2022.03.05.09.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 09:14:53 -0800 (PST)
From:   trix@redhat.com
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: dsa: return success if there was nothing to do
Date:   Sat,  5 Mar 2022 09:14:48 -0800
Message-Id: <20220305171448.692839-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this representative issue
dsa.c:486:2: warning: Undefined or garbage value
  returned to caller
  return err;
  ^~~~~~~~~~

err is only set in the loop.  If the loop is empty,
garbage will be returned.  So initialize err to 0
to handle this noop case.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/dsa/dsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 06d5de28a43ea..fe971a2c15cd1 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -471,7 +471,7 @@ int dsa_port_walk_fdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -491,7 +491,7 @@ int dsa_port_walk_mdbs(struct dsa_switch *ds, int port, dsa_fdb_walk_cb_t cb)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	mutex_lock(&dp->addr_lists_lock);
 
-- 
2.26.3

