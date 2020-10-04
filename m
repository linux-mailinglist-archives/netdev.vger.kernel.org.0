Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934B1282DDA
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgJDV6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgJDV6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:58:18 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA29C0613CE;
        Sun,  4 Oct 2020 14:58:18 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id w11so8580886lfn.2;
        Sun, 04 Oct 2020 14:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oOhluhYAiPBTUYrdM9LSRq7lG4jP45lnUbBYj7Hf0f4=;
        b=s9/GF8RR4WY5o9WPl/J0PZtZyKw4VULFySS3YBYB0TnjcyHGJWLhGPAoE5/jgqN2f5
         fnzi30B6o415vjpIjGuQMGedaysv+uuTCPzl1oF1xTVj4GtoJSZosPxAyd+QbLuiBwzR
         OqGkaqxjeUDyASmorOK3pDDde0r0pFqGlBIwNpFfvz3SGqcWYacjr0RHZuNCQaZZ4ZvD
         gevWp5ovsY1xMjV5froU2P3wb20q6YP05+sgYlHQfdD7cOtGKjrirkbYHTWJ3nys4OKS
         gTIaUX1suDA8/BSWwEQ5kFONEkw4pzK8BpvtZjLb3wbaW7VNGopa2ZVu0oB5k0bsQQEa
         s/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oOhluhYAiPBTUYrdM9LSRq7lG4jP45lnUbBYj7Hf0f4=;
        b=ZSj2BJmgY4c6i6jYHrSHGaglklwCXglP+jWe4U/2w4q4QPOv5xJs/vxLpaLjgGoJG3
         1uzED+j83gXboRdh+mkz7YpL0FjNxaeXUrjE1lSG0hdUQzAv1ENDgmfnsEa+Z0h/zpiM
         H97R1ms3MyX/qFSiZa/ndRZUirGgKXhjVmAi88j23a+X48wGWhgjhiMbIyZ7KmUPhaXU
         HLLjt0oboGER2fE0pwyJu3bVb9vhDX5suE/msVRF/ox9xDtSdn1RtSmo0BQGotmhWHg5
         OmilyBy4/BxvlWO2EGfurd2aKbhtQNq13QCSyIelw833tgKc5Ml0lVLdEz3y6qf00L2w
         sjDQ==
X-Gm-Message-State: AOAM532wx9ru+vzmW/bVnvqgpvn9Ou0EtAnYJUygfaBfj/ggOut+lebA
        qnjjPpdgMUCoBBtj52L51I0=
X-Google-Smtp-Source: ABdhPJys/SinQuFNrnXsCrjQ4WncHNCpBViFjRmtAm6UxXNsw5u1LQjD96cMQVbNVV4mACEN59qijQ==
X-Received: by 2002:a05:6512:3222:: with SMTP id f2mr2460652lfe.268.1601848696720;
        Sun, 04 Oct 2020 14:58:16 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id r17sm310255lff.239.2020.10.04.14.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 14:58:16 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org
Subject: [PATCH net-next 2/2] net: openvswitch: Constify static struct genl_ops
Date:   Sun,  4 Oct 2020 23:58:10 +0200
Message-Id: <20201004215810.26872-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
References: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of these is to assign their address to the ops field in
the genl_family struct, which is a const pointer, and applying
ARRAY_SIZE() on them. Make them const to allow the compiler to put them
in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 net/openvswitch/meter.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e86b9601f5b1..9acdd5a8428c 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2231,7 +2231,7 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct genl_ops ct_limit_genl_ops[] = {
+static const struct genl_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 3d3d8e094546..8d37f50a3f29 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -672,7 +672,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	return false;
 }
 
-static struct genl_ops dp_meter_genl_ops[] = {
+static const struct genl_ops dp_meter_genl_ops[] = {
 	{ .cmd = OVS_METER_CMD_FEATURES,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
-- 
2.28.0

