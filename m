Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A63604801
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiJSNsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiJSNq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:46:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B8172506;
        Wed, 19 Oct 2022 06:32:04 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id q9so40023218ejd.0;
        Wed, 19 Oct 2022 06:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44Y6rKJn569B0Ledh04VG4kfOWeXNWHzbX7P9B3WEhs=;
        b=dpJqkjKciYIviPCq4WSl7PWBLe7lOArO2MMC+weZcyz5airKWp/mTA0/j4aFZ+OTpm
         mfaalgeVGpsmsjyj7orwCLzFEtmADZxQ57c/kyU4C3teaKSV1JwEK01GXYHZUPjvWPC1
         ER7BCxNiM/9bLBm6aEnyF2wbiSSghzKNEXRpwtm+CzQ8nTVUBBtNAlL4rJFinH6vAXk5
         MpEGKcrrWcwgisqfq9jbCT+mfygernhGHav1n+ndLYwLweMHDDsdhvTpmFaoLgPlQD60
         ZDTlvel7H8ctzdUuKrLTcwVerslnnDbPutYFqjCSq3eFgfUrR/NMFxMqBWcjOorNQCYE
         HS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44Y6rKJn569B0Ledh04VG4kfOWeXNWHzbX7P9B3WEhs=;
        b=h+2pToYwWy3/klFsTThv8jRfd7DVbuQFlsYtdKrWXk7iyJmT3+jB1x0jClwXHpdWfh
         RG5tHm5oQ9lnusDD3zmgT/Zr2HKhZGlhzU8Yyt5Q4VtgE6TZTyg4xPaOBA3IIOQBRgXf
         64WZVFAO5rADpmEDwf+Ve+gpc6IxilmMPgNjd7agN6gh8BNNklJxDq2VEf4bnNCd9RVS
         IanGYZp6BIwYOxC6EXxH4iDaoXe7ABCuQABvkgK8GH1RHWuHaZUTc1sQg1vi8Hu2u4Rc
         NbyUf3ipfbZ6akfomj7WkjBdeyxDcGe8vdiVdbNMpG4moMUXBUOFGXNkiRoP0vqpYPGw
         4QXQ==
X-Gm-Message-State: ACrzQf1ltOgyaaE61hTOUCsiRr4X6IApDHnuA4rr4U0SttuTQnJQOr3F
        5oQmNbu9jRt1nA50hJLDdSnl7BGX4OXndQ==
X-Google-Smtp-Source: AMsMyM7ZSvihs4kkMZ0T2RSCSUCIRV9VOxcSTtatBBCOxc+sD80A8oi0OmPEAoNU4cJLNT40TtRsrA==
X-Received: by 2002:a17:907:6288:b0:78d:ab30:c374 with SMTP id nd8-20020a170907628800b0078dab30c374mr6853882ejc.266.1666186305491;
        Wed, 19 Oct 2022 06:31:45 -0700 (PDT)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906768e00b0077a8fa8ba55sm8894792ejm.210.2022.10.19.06.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:31:45 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 2/2] Documentation: ABI: sysfs-class-net-qmi: document tx aggregation files
Date:   Wed, 19 Oct 2022 15:25:03 +0200
Message-Id: <20221019132503.6783-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221019132503.6783-1-dnlplm@gmail.com>
References: <20221019132503.6783-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for:

/sys/class/net/<iface>/qmi/tx_max_datagrams_mux
/sys/class/net/<iface>/qmi/tx_max_size_mux

related to the qmap tx aggregation feature.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index 47e6b9732337..9c69ffa64b51 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -74,3 +74,31 @@ Description:
 
 		'Pass-through' mode can be enabled when the device is in
 		'raw-ip' mode only.
+
+What:		/sys/class/net/<iface>/qmi/tx_max_datagrams_mux
+Date:		October 2022
+KernelVersion:	6.2
+Contact:	Daniele Palmas <dnlplm@gmail.com>
+Description:
+		Unsigned integer. Default: 1, meaning tx aggregation disabled
+
+		The maximum number of QMAP aggregated tx packets.
+
+		This value is returned by the modem when calling the QMI request
+		wda set data format with QMAP tx aggregation enabled: userspace
+		should take care of setting the returned value to this file.
+
+What:		/sys/class/net/<iface>/qmi/tx_max_size_mux
+Date:		October 2022
+KernelVersion:	6.2
+Contact:	Daniele Palmas <dnlplm@gmail.com>
+Description:
+		Unsigned integer
+
+		The maximum size in bytes of a block of QMAP aggregated tx packets.
+
+		This value is returned by the modem when calling the QMI request
+		wda set data format with QMAP tx aggregation enabled: userspace
+		should take care of setting the returned value to this file.
+
+		This value is not considered if tx_aggregation is disabled.
-- 
2.37.1

