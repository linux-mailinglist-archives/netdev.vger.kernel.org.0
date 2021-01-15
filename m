Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523F12F8652
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388466AbhAOUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388198AbhAOUKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:10:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF068C061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:18 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so8462618wma.5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 12:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aiJUe/D+M6zdYoqU8/tCGnMlqOxFrCNb2GHwWBgB6XE=;
        b=dSqWxy5oJbUPhoGZ0kJkRd2cNEx5u2GKs2BvohoeKfNCcPJhr2Eu60z6vjzxq/40aN
         glgoqChgxqONYcrADHOUNx2SAbmIdyugzHGjcwAfK+IGJbWjyqOFoCOnNrJsRyuZ73GM
         ajB7yxsGQvusQMPlxvi6EQSO7extZO99Jze3AkqqxSQlrR9cBUH7LFx9BHVjWO4NVWZI
         EiRX3iCscVdNpnfjJCMuIQEvt/MdUGmvt9JbNZuSoBP+A2j09IlgIriYQv58JVaXSLpB
         eWTUAgMgNSZG8vtSDnHBneQoIxOiEZXrirrBiXBWfYRfCWc7r1+5ZlnwZDhU1hIS7a/5
         b5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aiJUe/D+M6zdYoqU8/tCGnMlqOxFrCNb2GHwWBgB6XE=;
        b=Zfsr+k8sNhj9UJELgIQTWATCOUWi/C2FcnaFUMFooIRIQeOc3IhU7fpPGx9a8K1x8q
         nDU8UDvaR8SMy1D73uTP6zGPCWSTl+gQiOZdk+oZjN/uJa5lZSiksfM/cmT2eGXI6/n8
         W3V7yENZ4b/+EpjO620s0lCJpUyjgna1cap/bFntzT+duAiehNwOYx+lXErKlxz9X4sA
         DdXURptvJbR6A9NEAxynxh3GhquaBeoJGCYBXKOHhxDf8VxpwD6yZkyZbtaV+7w8rnEm
         ZO522UpjVgVxu2uYjtAuyHJ71WSDarEF7D2NJ5XlluEQv6NV4CWK9KKtm1FrR4xzr8ys
         Ez/Q==
X-Gm-Message-State: AOAM5320uKZMuOIydB75OXizMqMpsCVj01IWAytJ4xzpLgp/1IcNbBnN
        NYEK8mXNhzXnJw23H4+SMm+oEw==
X-Google-Smtp-Source: ABdhPJz6z8ooRqEJMuEtAZ3z0VQGV3ToTw4T17vOw6fkh1inINUIw2LGxPtLCYYvw9uakPUqYWmMKw==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr10484579wmj.148.1610741357695;
        Fri, 15 Jan 2021 12:09:17 -0800 (PST)
Received: from dell.default ([91.110.221.158])
        by smtp.gmail.com with ESMTPSA id d85sm9187863wmd.2.2021.01.15.12.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:09:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 2/7] net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
Date:   Fri, 15 Jan 2021 20:09:00 +0000
Message-Id: <20210115200905.3470941-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115200905.3470941-1-lee.jones@linaro.org>
References: <20210115200905.3470941-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'dev' not described in 'frontend_changed'
 drivers/net/xen-netback/xenbus.c:419: warning: Function parameter or member 'frontend_state' not described in 'frontend_changed'
 drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'dev' not described in 'netback_probe'
 drivers/net/xen-netback/xenbus.c:1001: warning: Function parameter or member 'id' not described in 'netback_probe'

Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: xen-devel@lists.xenproject.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/xen-netback/xenbus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 6f10e0998f1ce..a5439c130130f 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -411,7 +411,7 @@ static void read_xenbus_frontend_xdp(struct backend_info *be,
 	vif->xdp_headroom = headroom;
 }
 
-/**
+/*
  * Callback received when the frontend's state changes.
  */
 static void frontend_changed(struct xenbus_device *dev,
@@ -996,7 +996,7 @@ static int netback_remove(struct xenbus_device *dev)
 	return 0;
 }
 
-/**
+/*
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and switch to InitWait.
  */
-- 
2.25.1

