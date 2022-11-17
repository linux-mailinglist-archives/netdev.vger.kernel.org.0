Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8FB62D1DF
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiKQDsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiKQDsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:48:12 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB4F6A693
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:09 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q71so844025pgq.8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y76ZfgfBJidUYPCMV+vRUvTiWIMgw/TUrl068PoooHY=;
        b=Aemg2d4QHeMmhfW2XzWUcy31KiogjSTiFrtce4XLqG0KVm5jfdmiYfrZ2ArThv9/7x
         f1gfdsFx5oC8Ei13sDch2N797DGQO7gckIlinDLr/1tBQ+0U7VGHI4uTWH5s5Vq3nAWp
         hM9WNOcZ3KWF3JmF4zvl/vNfVUZJdTtonnviUos5qWRerGb37/ZZx6ZXonN+zzw/AZFE
         +iENrziPTgPFINegygwCVzy9mvOlfcsEdS9UP2PbXDpMpXsfTdWAGi0YU+QQv3U/QgBu
         vOGhYA3MG2Egle2KpY6/qVA5bkNGZFIBPVRl9tflfAf6ICL3YjfK6y+pSoapycA0fzAF
         lDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y76ZfgfBJidUYPCMV+vRUvTiWIMgw/TUrl068PoooHY=;
        b=AbmUk2rbcCWt1yeeUqB9t+PDZEE9uKjChCaJ4alsAP8qFltFMHvKZYVHo+1eLXZLYS
         EwkUutCHnjB44r1OTA+Wglo6QisX7gVMrZ0hV0TZc+73WFk32NesIrN8i150SGmcqT9z
         mte+8Gk5KgF7LUiSJocKiETr1s9lxCjp/YSPpbqtNf/gl20jhp2E3H48lyUVAwopl4OR
         FAXal8umeUSzdsjJL9cFMkvllAcC6jcVvJHU/f0cXaNfXhMM6pBn77krwfQEdxlQi9AL
         zl+Jbz4XHejnJmH4LLmE+4tIhnOxdpkD9lNizq9wi8hSwvmhy6HdaPfZhFu6T5DNdskM
         rJfA==
X-Gm-Message-State: ANoB5pmlqI8F6mzzTZA5BIyJLx2fCCpOP+IRuRK+6XpRh21kjzGm7pMx
        xi9vEW20ofEop16LzNQV2sUDoQ==
X-Google-Smtp-Source: AA0mqf4xP4Gzh0YATcEke2N5kYhIF0LDU3y/SN0UeWuBkH4qnD5qlWTNifLxKNRS4UN91g1M8fuZQQ==
X-Received: by 2002:a63:2310:0:b0:457:a1a5:3ce with SMTP id j16-20020a632310000000b00457a1a503cemr390886pgj.416.1668656889309;
        Wed, 16 Nov 2022 19:48:09 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b00187197c499asm13016723plb.164.2022.11.16.19.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:48:08 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v4 net-next 3/3] dt-bindings: describe the support of "clock-frequency" in mdio
Date:   Thu, 17 Nov 2022 11:47:51 +0800
Message-Id: <20221117034751.1347105-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117034751.1347105-1-andy.chiu@sifive.com>
References: <20221117034751.1347105-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio bus frequency can be configured at boottime by a property in DT
now, so add a description to it.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 1aa4c6006cd0..80e505a2fda1 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -68,6 +68,8 @@ Optional properties:
  - mdio		: Child node for MDIO bus. Must be defined if PHY access is
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
+		  Non-standard MDIO bus frequency is supported via
+		  "clock-frequency", see mdio.yaml.
 
  - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
 		  modes, where "pcs-handle" should be used to point
-- 
2.36.0

