Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9DF4181AF
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbhIYLkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244587AbhIYLk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 07:40:29 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5F9C061570;
        Sat, 25 Sep 2021 04:38:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r23so10102651wra.6;
        Sat, 25 Sep 2021 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RWcU2wxdMqhCzxhAoNFRTMb2fbcbT+16RrjB3ao6kCg=;
        b=i7eLxxAoMqyCe0UyKR4JmAdw+Rsxt4Tiihvqi3MGkFBTSchBi3S1G8UQzDwFKgLLqo
         nWYfXVfRQUorrpcG4y2eIcolNEp7mLcoNaNSoy5TElpjgOowcUcWtg5l04s3R7ifM7SW
         KklfNaTBmrP7OOLiheXVtDJLPJYkjiM62QPyWokb4eQE2Z1pMY56DwvsStzendwx0Mth
         HNzoiF0QWLGr+P1niU29Khn7sr1jJhhXEDJeVUVy102ltrloMrxOlxIq3xCse033uCNS
         Q9Nnc4V2Tr3YsxvOTmvSofHMn6VeEwcbBJZQvDbLW7BRnyoNJVMiWAath9wHShKWEksv
         5clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RWcU2wxdMqhCzxhAoNFRTMb2fbcbT+16RrjB3ao6kCg=;
        b=mIQYE/xZJLO22vPKXZtWwIFY2OYSQ2AOfGW84RbSAZ+xaoVLCpSYPIU7PU07Ls+tGw
         xHIZOfybQeG8BxzSpMIb5458YN2OATzoMJNAT+n1XOwTxbrA8d410rL8JMRITDjBeh+L
         m2c5ky10+3IqMCZqnYRwQTd8E9fwrPTqFwb6SY4ZzxKxLoeu6NNSZhMqsBgmPD6L2ZuI
         U1RU5tdjpXm1+gKvHAaD9jEhS/Z0/YdiuHjj9j/gNui5S+BVgqHXjjNEATRb8qpQik8N
         92opFeH8FciqCmGGihjZe96kqvjQGS3hsG07Xh05E9D0uOca6Enh5ENvnufqIhwJeBhu
         rJmA==
X-Gm-Message-State: AOAM5319WdhzMSUWaQa6R/Pfp68m7zZRUM9hFr0u07jx1LrKbtqIV+br
        7Jv/VA0yM1KOx9urSCICRT8=
X-Google-Smtp-Source: ABdhPJwmz8CY/4ndyNY2z9yrhwa69A/l9cZ4hgWpxf1QrcV/GxW9onVCSAVM4OqysTt6dy1ln1TayA==
X-Received: by 2002:a5d:4601:: with SMTP id t1mr16374056wrq.298.1632569933732;
        Sat, 25 Sep 2021 04:38:53 -0700 (PDT)
Received: from oci-gb-a1.vcn08061408.oraclevcn.com ([2603:c020:c001:7eff:7c7:9b76:193f:d476])
        by smtp.googlemail.com with ESMTPSA id c4sm11033157wrt.23.2021.09.25.04.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 04:38:53 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: NSP: MX6X: get mac-address from eeprom
Date:   Sat, 25 Sep 2021 11:36:28 +0000
Message-Id: <20210925113628.1044111-2-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210925113628.1044111-1-mnhagan88@gmail.com>
References: <20210925113628.1044111-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC address on the MX64/MX65 series is located on the AT24 EEPROM.
This is the same as other Meraki devices such as the MR32 [1].

[1] https://lore.kernel.org/linux-arm-kernel/fa8271d02ef74a687f365cebe5c55ec846963ab7.1631986106.git.chunkeey@gmail.com/

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 arch/arm/boot/dts/bcm958625-meraki-mx6x-common.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/bcm958625-meraki-mx6x-common.dtsi b/arch/arm/boot/dts/bcm958625-meraki-mx6x-common.dtsi
index 6519b7c61af1..5de727de6a4b 100644
--- a/arch/arm/boot/dts/bcm958625-meraki-mx6x-common.dtsi
+++ b/arch/arm/boot/dts/bcm958625-meraki-mx6x-common.dtsi
@@ -39,6 +39,8 @@ led-3 {
 
 &amac2 {
 	status = "okay";
+	nvmem-cells = <&mac_address>;
+	nvmem-cell-names = "mac-address";
 };
 
 &ehci0 {
@@ -53,6 +55,12 @@ eeprom@50 {
 		reg = <0x50>;
 		pagesize = <32>;
 		read-only;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		mac_address: mac-address@66 {
+			reg = <0x66 0x6>;
+		};
 	};
 };
 
-- 
2.27.0

