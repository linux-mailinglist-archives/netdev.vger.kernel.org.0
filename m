Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D574BA56F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbiBQQJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:09:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiBQQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:09:40 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16A0184E47;
        Thu, 17 Feb 2022 08:09:25 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw13so8391657ejc.9;
        Thu, 17 Feb 2022 08:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ys6GvyIzdvZ2LM1dv7bCYtsjMt7DVaFxpDK/D/m+fNU=;
        b=YDO2Cbqp2Xy7UnC16BUrgaQPd5JEadXK7LanbBRM5YeIKheT3amK7MoTd4JmC38IKB
         z4rcD4YqFOifcMVee9ahjOLLL1eQOVledHublXzvHQ8XNFh46ZBesQGSNWjc38muCiWp
         J1KUfC5yzWchQO4uPxrcgQzBaFlbI5Cx9sc2jQjSzBd+b4uRE2MJdXwnCzUO4vpsJub5
         cSAya6YewswZpgAqpW2yQqqg6hkj/Nf2x2hQ9IB1QAuyGwRU8MT5EVeC2rKNFJKwMNPs
         ZVBYpsk4SCYjroN7ax4cR20GELreh9yom4/fRE0Ls2lSkr9U3bDIqnw8YNMuhfvEIZqZ
         VP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ys6GvyIzdvZ2LM1dv7bCYtsjMt7DVaFxpDK/D/m+fNU=;
        b=pCsKuq3F4isqdw1TYihzmHSp3YbA07PVd2xbe+mGgBHb0GEEtkWGqrbKZjpavfYBaE
         175PxoSwljH0VFvnZRGKP0KAk3mv6xh0wbJ9MLYJxh0YALDvrrQrfzZAh76W0BOrVYVp
         OB8aG6/nOndsXfmAj0u8p94YWmCxZxOJmQtSP3upO+UEuppKpDv/GqWCsdtkzZ6SwWH9
         4npTskoNMo9bzyJf7OYAsWGDSvR+3L2BuPfiz+WHuKQAHFupS2uIzCO5A2iaIWCiVsUr
         GIYGU1EWof90frgAzkXmEEa4/aVUhP4H6voxgoyZmtbTOU9IKLlkWSm/0Gb2CQJcD1Af
         g+BQ==
X-Gm-Message-State: AOAM531Q216dk9/gp+sSf1aGzH5rY8ryncSvcnBYrpt+ggftlotYHg8n
        IvcnkJTQ+aiB//bMQzqx5Co=
X-Google-Smtp-Source: ABdhPJwhJqSZriQ8pKdVyIFUxb22KfdZARIqPdmMVBQLpozLElaV3GDU7fVmun2Jej0brrbH76hIOg==
X-Received: by 2002:a17:906:d0ce:b0:6cf:37f0:2718 with SMTP id bq14-20020a170906d0ce00b006cf37f02718mr2947116ejb.224.1645114164144;
        Thu, 17 Feb 2022 08:09:24 -0800 (PST)
Received: from hw-dev-vm01.evs.tv ([212.222.125.68])
        by smtp.gmail.com with ESMTPSA id x14sm3568194edd.63.2022.02.17.08.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:09:23 -0800 (PST)
From:   Fred Lefranc <hardware.evs@gmail.com>
Cc:     Fred Lefranc <hardware.evs@gmail.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net/fsl: fman dt binding: add fsl,max-frm-sz & fsl,rx-extra-headroom properties.
Date:   Thu, 17 Feb 2022 17:05:27 +0100
Message-Id: <20220217160528.2662513-2-hardware.evs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220217160528.2662513-1-hardware.evs@gmail.com>
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describes two additional parameters that could be optionally added
in devicetree.

Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>
---
 .../devicetree/bindings/net/fsl-fman.txt      | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 020337f3c05f..bcd0cf8ca9e9 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -117,6 +117,26 @@ PROPERTIES
 		erratum A050385 which indicates that DMA transactions that are
 		split can result in a FMan lock.
 
+- fsl,max-frm-sz
+		Usage: optional
+		Value type: <u32>
+		Definition: Max frame size, across all interfaces.
+ 		Must be large enough to accommodate the network MTU, but small enough
+ 		to avoid wasting skb memory.
+		1522 by default.
+
+- fsl,rx-extra-headroom
+		Usage: optional
+		Value type: <u32>
+		Definition: Extra headroom for Rx buffers.
+ 		FMan is instructed to allocate, on the Rx path, this amount of
+		space at the beginning of a data buffer, beside the DPA private
+		data area and the IC fields.
+		Does not impact Tx buffer layout.
+		64 by default, it's needed on
+		particular forwarding scenarios that add extra headers to the
+		forwarded frame.
+
 =============================================================================
 FMan MURAM Node
 
-- 
2.25.1

