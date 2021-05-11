Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347E4379C8C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhEKCJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhEKCIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BD1C061347;
        Mon, 10 May 2021 19:07:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l2so18476201wrm.9;
        Mon, 10 May 2021 19:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXAbPq5h3YA9NQN4q/AURsjkpOOLQrTGRK7wcDN+KLA=;
        b=LSUhDNpOEWoRuDWqz8Z4t533Tf++161kmGSNjNaJ69QTha2MzGLSpuyOXklvrG1GqQ
         nqQ5misA5Xy0ajxIJ0CnVWTknH2QWcYoXo/E1Ri0BPtrGULJ+ABKRdfSATx0wgtWwDQ4
         3a8VlHWujzZ/CEdfeaj3TtwmnU5n4ozfoLDzIjxGoYIl3VnNQXyB8D9FT8O2VTG49tc5
         nmCQL8aLZZVJqiHxC33eqsrB2GndDTlIK8pIiVkU9LLdgsboCZ0WyMVcD2aE+qXI963j
         M8Ftwo/3ku+7qT1MtUaEcfiP+t+MB438hbM+Y9Rab/xMTelZU7BUHsliHQSAWqO9NPkC
         BrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXAbPq5h3YA9NQN4q/AURsjkpOOLQrTGRK7wcDN+KLA=;
        b=hkwH43BwvSJU9CWeg/mJ6lx6r0ctKt9YDj+Uh8wrBj86qMYtTCuCOiJgPtQq//Aijr
         tdXRgM0/DmDVzIOM2QXyDRwWvWyvxFTvgTvlt517kf7p/lxfPVGfSnpGMk2ZubC7TLak
         QqqpOkKqFy7i7aWPH083vDyxqBDh8JFbwMTSMx6ubY4ROe6kqB5ScPbVks9wNFjGuHny
         ThmJ879hh1x33VgHTaZpueSAKWR51aAQvZuZRJlFFE8p4mxj5AdPw3Rr4uDNt5R5ohVJ
         8UTX6/nql/WXILLxxGiVtynprd7Oei5+EdIb/kIGX1j5YaBjmRYl22OicGjUVrWy8W4v
         9mYQ==
X-Gm-Message-State: AOAM530obg7EGmcJxr1FDBQxWCGEbHScOlBut658qxk7SmsLo93ZMaqG
        8p/HV6larNmditUfXXiH50s=
X-Google-Smtp-Source: ABdhPJwVN+id+mj9JFdNd/qxP6a5dwmB+unMQ8uCdOQcUbvAaDDGofYz8sij+iRvdiwbKxd21grR+Q==
X-Received: by 2002:a05:6000:2ae:: with SMTP id l14mr34045224wry.155.1620698852340;
        Mon, 10 May 2021 19:07:32 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:32 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH net-next v5 10/25] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Tue, 11 May 2021 04:04:45 +0200
Message-Id: <20210511020500.17269-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 in the compatible list.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..1daf68e7ae19 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
 
-- 
2.30.2

