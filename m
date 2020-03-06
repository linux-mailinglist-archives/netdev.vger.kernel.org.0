Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05917B597
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCFE3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:29:36 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40167 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCFE3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:29:06 -0500
Received: by mail-yw1-f65.google.com with SMTP id t192so1079148ywe.7
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=miNN8i4IwcvOjiB/qs3BU+cs0LOJ0WZgNaPZTHxNf20=;
        b=eslwFNq4PwCC6+Z4KsPepXRVMSQtjU60CJu4GIG6B7Jnm4GZgJE8XkeUHt+m8sYvds
         Vb3v8FWdY/Hm7Tzv2QWOSvmxWCRZA1Q1yD2R6rTHqF0WUw8XWuYnojK+8Gzhbvnty8b1
         4FvH9hKarM9faVP8AInLEsBWcB7CTrpeDbz8B+hwcTyTXoHH1F9L2iAZtZOdn8xNMZcd
         U0qjD73Dgm3vDJkC8eBdPh7pIcbBn++HjfXSEfbn8Eu+1PLU70HJ3MKuMjeyjdKnjrrX
         WG6/hgDgSof0z3abT9dUiOIGO0mE3Pt9dt2vYe6ncLAoY1prfQBYsXM42eiTP9qihY8l
         C40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=miNN8i4IwcvOjiB/qs3BU+cs0LOJ0WZgNaPZTHxNf20=;
        b=iyz7mx5KTWXkuuQS2LTrba0r7rM9z9GtfaRPloWh4aJ9s4H5jGFp6XDQftPxaS+SHw
         0SWO4BaqNEAImJpZj4z+rwcOPmJl5CkvUX3aE3SEafB4daS/HClOiiaKEJNzwTYtZ8oS
         pe4t/35AcO5BIF4vBuzApUzkRVQCuyY/YEykRqBBrfgzECNZ2TAVNYxgchQAMn/NCL/d
         mAgLTWsEoxBiFFPNvgNc+DCKCC37Scz9hVKzG3iy+kqhbWVMrtixh7AA5r6NA034Uo0x
         owgB/YfrlJluFyPXBhztWcHA5OhZEsojgmQKW2RUVSC9HdHzdQaPeAjnIbpjJ/BChc/d
         PrwQ==
X-Gm-Message-State: ANhLgQ3pzGth8Jf1dvJMk6baq87gZ1KgNAFzZESFiuHqBEc1lzkTlpyN
        OCRLkY2E1XEGNI9Ema6x9wKbCQ==
X-Google-Smtp-Source: ADFU+vvvxCEfuf1gOKNFIP8+FrNcl9hJa0D2HXoL/aVi6uaZ18AjxRORPUKqhxu509Q6FwPA0HW7Tg==
X-Received: by 2002:a81:49c5:: with SMTP id w188mr2205995ywa.186.1583468945849;
        Thu, 05 Mar 2020 20:29:05 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:29:05 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
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
Subject: [PATCH v2 15/17] soc: qcom: ipa: support build of IPA code
Date:   Thu,  5 Mar 2020 22:28:29 -0600
Message-Id: <20200306042831.17827-16-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
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
index 66e410e58c8e..02565bc2be8a 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -444,6 +444,8 @@ source "drivers/net/fddi/Kconfig"
 
 source "drivers/net/hippi/Kconfig"
 
+source "drivers/net/ipa/Kconfig"
+
 config NET_SB1000
 	tristate "General Instruments Surfboard 1000"
 	depends on PNP
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 65967246f240..94b60800887a 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/
 obj-$(CONFIG_HAMRADIO) += hamradio/
+obj-$(CONFIG_QCOM_IPA) += ipa/
 obj-$(CONFIG_PLIP) += plip/
 obj-$(CONFIG_PPP) += ppp/
 obj-$(CONFIG_PPP_ASYNC) += ppp/
diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
new file mode 100644
index 000000000000..b8cb7cadbf75
--- /dev/null
+++ b/drivers/net/ipa/Kconfig
@@ -0,0 +1,19 @@
+config QCOM_IPA
+	tristate "Qualcomm IPA support"
+	depends on ARCH_QCOM && 64BIT && NET
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
index 000000000000..afe5df1e6eee
--- /dev/null
+++ b/drivers/net/ipa/Makefile
@@ -0,0 +1,12 @@
+# Un-comment the next line if you want to validate configuration data
+#ccflags-y		+=	-DIPA_VALIDATE
+
+obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
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

