Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B44408D71
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbhIMNZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:25:43 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34146
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241170AbhIMNX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:23:28 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A589740278
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539248;
        bh=hZ5N4zB6ne7AqKTWsazgl2eww5+7SrfSBiF0jiwRIRU=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=V1WQ8oEoicl90mvQNd5qeVdtYBcGUzTnTBdbkiexfaoQVW3anJPjherjStF0XGr0n
         XcnthW4fF+R5Z1Qfwov06Dg0CC/Vz4UCYpzlijha2Edn0zHU/JPvG/QU1Zb/q9pqnX
         qRz0PfdjRJxcAgp4R4w7Nz+BH/AUiO7T7h3N7R4xEPccqgozuJG0thaGJ2fX1jg4Hz
         p28zpnUJldrV+m4q4FvWan2YvAyvEEHkInelVt8xYyLC3z2Dix1bdrd/JfSlEhe7Qv
         bpX/m0i7vaAyZMSnf7u3f3GBwEx/lZsANcfWoxbhLgGlDLM/wcasF0zYN+87b67gpp
         oJGhQlKs9CDZQ==
Received: by mail-wm1-f72.google.com with SMTP id j21-20020a05600c1c1500b00300f1679e4dso3599353wms.4
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZ5N4zB6ne7AqKTWsazgl2eww5+7SrfSBiF0jiwRIRU=;
        b=uIt3wlRCunpiQRlZJiwicAPxj636oFIo5G9c0gMkdpK/vxyBHalAYSxa/yGG0aXQxO
         uhJH8C+aF4Ln3mG1te2NZIKZNyWWcVL6eS+n1tZZELSxGFHPJJ7Ejs3pdwzTyPYbvnYy
         1+IRMBHcRd6EAVctOCj1aK4iXE9DwquLJAY70HksBBvIIzJJwQFAUHf/A8Zu5WRIDjR9
         bSIiQLJeET5TZsjOvdzgu7mKjyHe7mldIYxIAmoxZjUqX1uzNmNMTTmRS4iUZOukG0hm
         Gk3/NCkF39lu9Mj29lUhyie4J3Q+dMLs0TPGRvSRYjyie21JPukEuvER/8xs5EWvOHRV
         yd+A==
X-Gm-Message-State: AOAM533Fk0opcNQjPTX/wLTYeDXQyrbsafGG/wQiSfLiIk7llX/JozUI
        QkAltj+/+I74N250+QIFSn6K9SyXxM/d1ff6nioGf0gXSKyQJTANXk42uiodDbTfxuZPO64OpBy
        imko30xbmyWE0iD3JImC4wcrs5xd3qpzLxg==
X-Received: by 2002:a7b:cbd4:: with SMTP id n20mr11406231wmi.136.1631539248162;
        Mon, 13 Sep 2021 06:20:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGW1ojaPyD1M/BS656w+4FJLzZXRQcOiJW5oHFj8BydpZT1RYPdlEY9jeHIFid1HBy2UQTIw==
X-Received: by 2002:a7b:cbd4:: with SMTP id n20mr11406199wmi.136.1631539247756;
        Mon, 13 Sep 2021 06:20:47 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:47 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 04/15] nfc: fdp: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:24 +0200
Message-Id: <20210913132035.242870-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 051c43a2a52f..f78670bf41e0 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -335,7 +335,6 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 		return r;
 	}
 
-	dev_dbg(dev, "I2C driver loaded\n");
 	return 0;
 }
 
-- 
2.30.2

