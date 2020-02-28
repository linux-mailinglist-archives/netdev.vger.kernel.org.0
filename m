Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DD8174244
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgB1WnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:43:10 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41110 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgB1Wmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:42 -0500
Received: by mail-yw1-f65.google.com with SMTP id h6so4926280ywc.8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Thwu63tEndZhNCjTPMjYo2cjrXtsXYX1t8bmnH4V9IE=;
        b=TaqKk6XgbAiRcZY7jrn0JCG57GeKqBtMP9E+5v1Q//GWXUlVc1tZtShKP134SDQBt+
         aiRaNTdwCj4sRLl9B7noAvTyTfHNHQoOZKThziYaJ9smwOY6WSBLBAZ7Ssv30r8DtDUg
         AnVEPqWTZL88gUZt7ktuf6yGGPs8Zo3KoJCxZRqaxfuceFHhIKbPxEJuWUlEDVPTzKWv
         gmHwHnayTZ04Ga0Hv5dVq+Ged408RGUzx0pqp/SyRXYGBwBIOKKHhxyc5guJntX8fcp+
         BHbwtp7MLFVyd8vJahE9siIXqP1cxNVvKUxWYVov7S8fIpl0I0OVY5E2Jfjrh4gwSFPr
         3XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Thwu63tEndZhNCjTPMjYo2cjrXtsXYX1t8bmnH4V9IE=;
        b=nV0ZA0QQHD88+dInrwscpYRnBkuSHvEalZG27wqnnlCMyLnin6dJNuCsNS0xsXpdMR
         x3hAiHWGwU1WaVetZsln1LAJ7KzK33lXwHfMpRXP/vCkSf3H1QtrshDcaYPHhI07qqL9
         e020mjVrHZMfvtrHwxs8OlZWYqYUttj/OnEC/e7ZSecxpeaS8VTNCXfDBmQfBO+w6g3X
         cV5vYdxOLpQqlzOroPtpvC8b5ntTzEvjLex4WNvWAUHJc3t7cmTLBh1c2pVK/O0sQLLE
         A0fXrHbPnd5kfpQboBGc5TpaGI9s3Yt3nEx+wYwL5/7r9Oouwh+EDP7Fr3MjjG3WjJz9
         wXcA==
X-Gm-Message-State: APjAAAVG1PdDnQxLEyi+SYW/u4a6klAzq2W1jaxqOkqyMCjnqCpi3vxN
        0HczilXIx44f+w7cRRpDiZfT5Q==
X-Google-Smtp-Source: APXvYqxQGwHuu0P48km/ZZi3ltrSEGLFPwNxngaAeUaU1f/9iK01pDAGis0Mrd4MrCrQiJ74V/yWlw==
X-Received: by 2002:a81:1bc6:: with SMTP id b189mr6405459ywb.275.1582929761563;
        Fri, 28 Feb 2020 14:42:41 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] soc: qcom: ipa: support build of IPA code
Date:   Fri, 28 Feb 2020 16:42:02 -0600
Message-Id: <20200228224204.17746-16-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add build and Kconfig support for the Qualcomm IPA driver.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/Kconfig      |  2 ++
 drivers/net/Makefile     |  1 +
 drivers/net/ipa/Kconfig  | 19 +++++++++++++++++++
 drivers/net/ipa/Makefile | 12 ++++++++++++
 4 files changed, 34 insertions(+)
 create mode 100644 drivers/net/ipa/Kconfig
 create mode 100644 drivers/net/ipa/Makefile

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 25a8f9387d5a..cac1bad327e0 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -431,6 +431,8 @@ source "drivers/net/fddi/Kconfig"
 
 source "drivers/net/hippi/Kconfig"
 
+source "drivers/net/ipa/Kconfig"
+
 config NET_SB1000
 	tristate "General Instruments Surfboard 1000"
 	depends on PNP
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 71b88ffc5587..dfa562f909c8 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/
 obj-$(CONFIG_HAMRADIO) += hamradio/
+obj-$(CONFIG_IPA) += ipa/
 obj-$(CONFIG_PLIP) += plip/
 obj-$(CONFIG_PPP) += ppp/
 obj-$(CONFIG_PPP_ASYNC) += ppp/
diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
new file mode 100644
index 000000000000..624f90f13816
--- /dev/null
+++ b/drivers/net/ipa/Kconfig
@@ -0,0 +1,19 @@
+config IPA
+	tristate "Qualcomm IPA support"
+	depends on NET
+	select QCOM_QMI_HELPERS
+	select QCOM_MDT_LOADER
+	default QCOM_Q6V5_COMMON
+	help
+	  Choose Y or M here to include support for the Qualcomm
+	  IP Accelerator (IPA), a hardware block present in some
+	  Qualcomm SoCs.  The IPA is a programmable protocol processor
+	  that is capable of generic hardware handling of IP packets,
+	  including routing, filtering, and NAT.  Currently the IPA
+	  driver supports only basic transport of network traffic
+	  between the AP and modem, on the Qualcomm SDM845 SoC.
+
+	  Note that if selected, the selection type must match that
+	  of QCOM_Q6V5_COMMON (Y or M).
+
+	  If unsure, say N.
diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
new file mode 100644
index 000000000000..a2221e91e6ee
--- /dev/null
+++ b/drivers/net/ipa/Makefile
@@ -0,0 +1,12 @@
+# Un-comment the next line if you want to validate configuration data
+#ccflags-y		+=	-DIPA_VALIDATE
+
+obj-$(CONFIG_IPA)	+=	ipa.o
+
+ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
+				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
+				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
+				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
+				ipa_qmi.o ipa_qmi_msg.o
+
+ipa-y			+=	ipa_data-sdm845.o ipa_data-sc7180.o
-- 
2.20.1

