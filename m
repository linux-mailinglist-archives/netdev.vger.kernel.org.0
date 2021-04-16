Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA80362BF8
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhDPXnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhDPXnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:43:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2AC061574;
        Fri, 16 Apr 2021 16:43:23 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso15421117pjh.2;
        Fri, 16 Apr 2021 16:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e70KR8HO4oVR9eCw8htk494MmB+WhNStBW+JwBy4STc=;
        b=fAYGKPBgKOrl0ahifyH0mCUBt+dgRsT/H/9InFp6YB5gR/egsNbmRBGS0OQ6q/Jy8U
         quTlmpeD5yFPppeGYkkOsEuoKvFgU4HXOJ8Eyvg+twPm4f0NIWjilNd2woC/VwjyS18d
         flAzN5c0h7coGNwHYFlLIv0FmyIsQSuCvITlhEQ8kSzExFUz/Kz9gK2AJnChWK5jCWwN
         ZA4vUyHblBhbWNWWmPfRHiCZdhlvSaIwvOghczoUDcIchm7gVm3QpOgrpovYceuEiHHO
         ypyPglEYW6BzQ9oDcsa5TFtNGkbsQJNYFnNTS1NoCmAOC2vRQ1Z2n0StmA9jboI4xNu4
         ByVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e70KR8HO4oVR9eCw8htk494MmB+WhNStBW+JwBy4STc=;
        b=dhcHRnQLnvaVNS1L4hru9c52w1eIKzAnLeNuWNU2EcsmIkXSL3x9bFDaOpQCeMLnry
         8v96qbGzhy8bQW6agdXwkqEVy27QsH+GO5BhMSqp1SgvCSswDxBTtnZUMNfCxkksp8Un
         7Tm7J/2i4POYkkOioxOeABC9NnmaIa3hdpdh9Ka+0zUGNKmuobXbAm6Ua08k2eyKJdpH
         TmZ6nzGHv1snwfMHPzjDu+CgGrVNwlTLnTR/1nhsfySF4Dyf72BgxS2EUJLUZGWitZtM
         rtvoI+x3o6UE36OfJ00gALcjvqRqVrSmQZXbzaskX1TEV3SDZgJ0iY6IVIn19KfACZMk
         TdFQ==
X-Gm-Message-State: AOAM530lwjvMDYfZA8ci/WfbWp59lZ1jg/jg6mFYEIv6czY5l22Snfpq
        V7/Rz8nQCaeYMsoh+1DKWOQ=
X-Google-Smtp-Source: ABdhPJwnh5S/TvaysVx2FmlVwrIayQTns6v0WzJabl3SMNVu4l0yj5WxwuYELXbXUjiTxzpHfeE8/w==
X-Received: by 2002:a17:902:b494:b029:e9:6c43:8beb with SMTP id y20-20020a170902b494b02900e96c438bebmr11992616plr.70.1618616603400;
        Fri, 16 Apr 2021 16:43:23 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/5] dt-bindings: net: fsl: enetc: add the IERB documentation
Date:   Sat, 17 Apr 2021 02:42:22 +0300
Message-Id: <20210416234225.3715819-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Mention the required compatible string and base address for the
Integrated Endpoint Register Block node.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../devicetree/bindings/net/fsl-enetc.txt         | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-enetc.txt b/Documentation/devicetree/bindings/net/fsl-enetc.txt
index b7034ccbc1bd..9b9a3f197e2d 100644
--- a/Documentation/devicetree/bindings/net/fsl-enetc.txt
+++ b/Documentation/devicetree/bindings/net/fsl-enetc.txt
@@ -102,3 +102,18 @@ Example:
 			full-duplex;
 		};
 	};
+
+* Integrated Endpoint Register Block bindings
+
+Optionally, the fsl_enetc driver can probe on the Integrated Endpoint Register
+Block, which preconfigures the FIFO limits for the ENETC ports. This is a node
+with the following properties:
+
+- reg		: Specifies the address in the SoC memory space.
+- compatible	: Must be "fsl,ls1028a-enetc-ierb".
+
+Example:
+	ierb@1f0800000 {
+		compatible = "fsl,ls1028a-enetc-ierb";
+		reg = <0x01 0xf0800000 0x0 0x10000>;
+	};
-- 
2.25.1

