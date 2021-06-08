Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D688E39ED55
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhFHEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:55 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:37659 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhFHEFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:55 -0400
Received: by mail-lf1-f45.google.com with SMTP id f11so29739329lfq.4;
        Mon, 07 Jun 2021 21:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2T7mIKspOgOa6iTte+bN4zWzDmpXAFYCXaoc2hPlut8=;
        b=kTFV8DhKMJsh1Yus1Ow1Db/nNszmSRADk8rAAwc/E2XYFMMmZqRQ2AfF5e/VO8mwJY
         GZkRjgfKv37q2f8BSobmwrTbWCHdIxBeB5dgUaKPMtQUqTUqO1RmtNI0QcRlguGz5EmW
         Fd2GF+x0YI6miZQf+gCqc+AUQWhJwCJU6pmaW76DrRbTfhCAfSIP+R/1iiS6zHLq67km
         PocKRfirjesACDsRD9bQnwZgJ/q8mRhBHv7akoOZMk0mH1HZgKgZ1iFg9VCGx4ITJHEW
         8QKtPlZToaW92W4Yt8HRKcyaGJKCv10I7V92lustFmRVI0QifJFXLDZ8UvnmWBdSBQG9
         N7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2T7mIKspOgOa6iTte+bN4zWzDmpXAFYCXaoc2hPlut8=;
        b=O0k166V0nKBSxAfWdtoKp9bYWC93ufOALJVEq35iKxAo5sbhmy2sp98z/hq2Sy2OYO
         fhsQTljUBsT8oxK6e4aYMEmfYTZHFnK9F0+gL5yonal84WSmlFnd5Mt4INhs0+6hlaxq
         chn9wmmuly0btwr3byrafSbYyHxzSpP04WOzCd9+0dzbB/SmCG0Z+5+VZ+5bDp/SWeqV
         CMa/TnvKhBGyDsvHx69ReG1JyWIWLBLEv7ndOjg/QiPhNnMw4SYXGOCbJ6atuF3ncB+8
         5f9Ke0LXkkXV2+fpIP6Ymy4Cm/PkMRRkaH91zFwWg766A4waU1fKm6FQE6un7MfcfEJL
         AgKQ==
X-Gm-Message-State: AOAM5314uqq5er7AGRgHGCcVNfVlJmtXwEaIprwcQj3Ybx7SrDx4MBq5
        CkKSQIw5QIhmq0m0161qVizNKPjeFHg=
X-Google-Smtp-Source: ABdhPJzXt8hdW4gKAPUGP3uhN1h4UA2IIXI01v30gewJbphkSxI1315OBuOEUukvter7mU7Bi+3xBg==
X-Received: by 2002:ac2:4c0a:: with SMTP id t10mr13415850lfq.401.1623124972121;
        Mon, 07 Jun 2021 21:02:52 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:51 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/10] net: wwan: make WWAN_PORT_MAX meaning less surprised
Date:   Tue,  8 Jun 2021 07:02:34 +0300
Message-Id: <20210608040241.10658-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is quite unusual when some value can not be equal to a defined range
max value. Also most subsystems defines FOO_TYPE_MAX as a maximum valid
value. So turn the WAN_PORT_MAX meaning from the number of supported
port types to the maximum valid port type.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c |  2 +-
 include/linux/wwan.h         | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 6e8f19c71a9e..632ff86398ac 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -250,7 +250,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	struct wwan_port *port;
 	int minor, err = -ENOMEM;
 
-	if (type >= WWAN_PORT_MAX || !ops)
+	if (type > WWAN_PORT_MAX || !ops)
 		return ERR_PTR(-EINVAL);
 
 	/* A port is always a child of a WWAN device, retrieve (allocate or
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 7216c114d758..fa33cc16d931 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -15,8 +15,10 @@
  * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
  * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
  * @WWAN_PORT_FIREHOSE: XML based command protocol
- * @WWAN_PORT_UNKNOWN: Unknown port type
- * @WWAN_PORT_MAX: Number of supported port types
+ *
+ * @WWAN_PORT_MAX: Highest supported port types
+ * @WWAN_PORT_UNKNOWN: Special value to indicate an unknown port type
+ * @__WWAN_PORT_MAX: Internal use
  */
 enum wwan_port_type {
 	WWAN_PORT_AT,
@@ -24,8 +26,12 @@ enum wwan_port_type {
 	WWAN_PORT_QMI,
 	WWAN_PORT_QCDM,
 	WWAN_PORT_FIREHOSE,
+
+	/* Add new port types above this line */
+
+	__WWAN_PORT_MAX,
+	WWAN_PORT_MAX = __WWAN_PORT_MAX - 1,
 	WWAN_PORT_UNKNOWN,
-	WWAN_PORT_MAX = WWAN_PORT_UNKNOWN,
 };
 
 struct wwan_port;
-- 
2.26.3

