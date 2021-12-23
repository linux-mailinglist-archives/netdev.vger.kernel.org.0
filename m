Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFDA47E206
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347919AbhLWLIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347900AbhLWLIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:12 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB389C06175A;
        Thu, 23 Dec 2021 03:08:11 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id p8so8487530ljo.5;
        Thu, 23 Dec 2021 03:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84LeHW/e19a5g89AaewWo8yiJv+44/hW3Ak/xWdyyA8=;
        b=LnZGA5tObecQRuwxdzey7KYJRuQO7Du0GYRah5VyFrCTa6a0Chg6WIzADqa51h7qpp
         +8TczdT/VPZHAagcOijkp1UlluvbIuWap+Bt/h02HLcq/v0dhmNQQ6/YtXanFiiWpjGk
         w7wu3wSBqLJ1fHWJju2xPOTWHC3xGrK/K22SkPMeC+AbwUvfha/G5wmThbNZgq7Gd9jm
         JlNG6TVGuRk1oKyoq2E8YfJfK4aQ/XfPR07sk7V1A7tnDwbAlfJoLZcheQJr8Zru7q2l
         x1C0XMQFZaM+amyqrESqPUctvg3ESz0+OY4v5MtZpz2GLH89bemWgs4wcc3OWKBEjJxo
         eLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84LeHW/e19a5g89AaewWo8yiJv+44/hW3Ak/xWdyyA8=;
        b=HixRQIUUeMBUSGV9ZckDiZh8or5GqmXpcttjktbCqIxbBu/QMsAXVxARm1D/x282T4
         P4VPwCcmLZgkLbtxqRGAdP1bWU0IHUnQ9N99nUhuxVLIZzhWyHznTRGGSUb8yXlCsCCQ
         15nMxoaamouyO84Qy9QXs9AsDOPdjaMX/JaDN9NT/saaKd5B3pzh0URMcxT+zA+3Y98M
         zDn6i8mLcKJsIlFyVgiqPsbc3O/PItFj+rxHiNdP6GgOrHkuYnel8LsP399jmiKvQOiO
         lJ3gb09YXNZENvyJRAhnMglleHnglWe+7t2JRS4OkOr3SQ6Zwk0dzMJkUwX6iFpjnmKs
         PQxg==
X-Gm-Message-State: AOAM532i0BQNAkKGHOoRbBGogMkmS+Vr+FqH71kGyKsnS3vyCAUfnEyJ
        Z0+7mAs5yhSjl5LELiGDJ8w=
X-Google-Smtp-Source: ABdhPJwHtj537VAWY1ZrCuOV3QEoO+Y8FoZA8+jyb0dgmaT1NpPfixRyUYbGFo0vvvpZ1afm2Rbwng==
X-Received: by 2002:a2e:9192:: with SMTP id f18mr1316446ljg.211.1640257690200;
        Thu, 23 Dec 2021 03:08:10 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:09 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 5/5] nvmem: core: add cell name based matching of DT cell nodes
Date:   Thu, 23 Dec 2021 12:07:55 +0100
Message-Id: <20211223110755.22722-6-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223110755.22722-1-zajec5@gmail.com>
References: <20211223110755.22722-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

When adding NVMEM cells defined by driver it's important to match them
with DT nodes that specify matching names. That way other bindings &
drivers can reference such "dynamic" NVMEM cells.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/nvmem/core.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 45c39ac401bd..5fe92751645a 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -499,6 +499,33 @@ static int nvmem_cell_info_to_nvmem_cell_entry(struct nvmem_device *nvmem,
 	return 0;
 }
 
+/**
+ * nvmem_find_cell_of_node() - Find DT node matching nvmem cell
+ *
+ * @nvmem: nvmem device to add cells to.
+ * @name: nvmem cell name
+ *
+ * Runtime created nvmem cells (those not coming from DT) may still need to be
+ * referenced in DT. This function allows finding DT node referencing nvmem cell
+ * by its name. Such a DT node can be used by nvmem consumers.
+ *
+ * Return: NULL or pointer to DT node
+ */
+static struct device_node *nvmem_find_cell_of_node(struct nvmem_device *nvmem,
+						   const char *name)
+{
+	struct device_node *child;
+	const char *label;
+
+	for_each_child_of_node(nvmem->dev.of_node, child) {
+		if (!of_property_read_string(child, "label", &label) &&
+		    !strcmp(label, name))
+			return child;
+	}
+
+	return NULL;
+}
+
 /**
  * nvmem_add_cells() - Add cell information to an nvmem device
  *
@@ -532,6 +559,8 @@ static int nvmem_add_cells(struct nvmem_device *nvmem,
 			goto err;
 		}
 
+		cells[i]->np = nvmem_find_cell_of_node(nvmem, cells[i]->name);
+
 		nvmem_cell_entry_add(cells[i]);
 	}
 
-- 
2.31.1

