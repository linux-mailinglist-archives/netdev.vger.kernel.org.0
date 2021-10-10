Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0B427E5A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhJJB6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJJB6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6600C06176C;
        Sat,  9 Oct 2021 18:56:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z20so51777122edc.13;
        Sat, 09 Oct 2021 18:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uPNQWTQgfdkkXKMJr1+g12wykYFN16QL/UUyG9V1XkY=;
        b=iacgUq6wRHa6bgglCVtjO0k5/unJechUMi7MLOQrTqSl+YHQfJtmOz9s88UC6RXjPI
         OOJZt2+iIcVW2ndbpxQrp60ZJ5ryJTJivhxFMdHYOcAqKfu88GijmuyuLTRw4z+aHbCp
         XQ/VfY/vlEmo8k15202BoFb5+cYKuE+YVMCFgwT0y+KDKa99uUcVshr1VED0I210B2kR
         C4yj6EBwjf87aJ9rH5YIB7aByFdMSXABVEFdBcKk+h8TppmNRashW7wJl73foNUbkg4r
         jQo41ZQQuynAkXku6JoezazpzXo9xR0ZBBbSaIjJju/sPnzYHFNd5LTCmYjn1na2PEKk
         7nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uPNQWTQgfdkkXKMJr1+g12wykYFN16QL/UUyG9V1XkY=;
        b=KxRFDEPn3AnzQh54ABpL2aq+ILdmSoWvRR6cG/too8dhIxDy7uRdcXEQ8k5B/sunZ7
         4PLLtLDeJ1XrLkKFQiZC5oEZ+Jmc3RqR5RxaSr/n56Hsm9rL1jQ3dWemHScArZDktVBH
         92re5tnLdE3HjFt4itrBGMOnTdpjG/GvHsnbfGy+3hWp8JZC+UKOBv+AvwXxoA9G9YE7
         zVteJC/E+qbpfuI3Pfgm6qKGvvcqypVBSKnwThqmg6pHFYdqnigfNoaeDjP50x5CCr9P
         xCx5n6Cyz1YrB4sTsw2vCtKOz6gsPThMLRxZMzqQQ9OWSXG2uBVt6PCJzTCXKExCDFV2
         1roA==
X-Gm-Message-State: AOAM530FLjU4Gm4RtvpCpEGI4Uid95UbzKeJOqiZzYa21Mu6k/ZZaiS7
        x3VyNRQxtpBGylHrKIdM9Fk=
X-Google-Smtp-Source: ABdhPJwnGodBxejFlUse8L38nO3MsgNkgzzgE2g+mj/SWGoAdluYkC/uMHBaLWZ06gIXCtRJ52tn4Q==
X-Received: by 2002:a17:906:1451:: with SMTP id q17mr15573069ejc.214.1633830980172;
        Sat, 09 Oct 2021 18:56:20 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:19 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 10/13] dt-bindings: net: dsa: qca8k: document open drain binding
Date:   Sun, 10 Oct 2021 03:56:00 +0200
Message-Id: <20211010015603.24483-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,power_on_sel used to enable Power-on-strapping
select reg and qca,led_open_drain to set led to open drain mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 05a8ddfb5483..71cd45818430 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,17 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
+                           drain or eeprom presence. This is needed for broken
+                           device that have wrong configuration or when the oem
+                           decided to not use pin strapping and fallback to sw
+                           regs.
+- qca,led-open-drain: Set leds to open-drain mode. This require the
+                      qca,ignore-power-on-sel to be set or the driver will fail
+                      to probe. This is needed if the oem doesn't use pin
+                      strapping to set this mode and prefer to set it using sw
+                      regs. The pin strapping related to led open drain mode is
+                      the pin B68 for QCA832x and B49 for QCA833x
 
 Subnodes:
 
-- 
2.32.0

