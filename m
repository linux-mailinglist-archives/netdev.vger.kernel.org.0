Return-Path: <netdev+bounces-12207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9FC736B29
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0FE71C20C01
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDE414AA3;
	Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C9F10961
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59BA10FE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f867700f36so3872455e87.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687261258; x=1689853258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJfdnRF9Vl6raSksJddU5E+UCkdBzgf8ixFIV7tG5Fw=;
        b=aCHgr6eVSbF0sSWS5KVz9OjzuyyOGXqeZUBI0EscRJLFniU0QgYOewzKkCo2rbRrx8
         ijBX2GBsdGtOaWilHopc/qpeNyp6ZgmM/8dFQPmUE3Rtvzj+9l9NhwhMAB6dax5F+hTu
         6kahIyVtuf4p69CJYbUfyrXFSVXC4gFGziL6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261258; x=1689853258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJfdnRF9Vl6raSksJddU5E+UCkdBzgf8ixFIV7tG5Fw=;
        b=gA+siw8h5c1FtlLDFIbUF4T6f1e518iKnwhOZGlnTMdbAA+kWx3QGiqOBdWCdWMAO1
         ifR/U75pfyUAOi8CRFgxXn5V30PptMcRQzCVDGKcCbsfHwRomB/PC5dDVsGWnJFnivVW
         DHP4agpde0Sk+AdaC5dosVqNBc540RsUpprVNIaAPz7E0mghj1sQ8NJEAfiXA8GjF+CL
         enz2PeabMnkSKMQGtM92qEkPgLZXPMqBUlG41V8AWsaeGXKzYlpXgLl4Fkw87fYHDaWM
         m20W4g9BKnRNWVQ1W9mIAEd2e1sRv53TOFBGYCW00u3dh4NRCecFu7s77f+Pd9uKFKXV
         j+fA==
X-Gm-Message-State: AC+VfDyNlGRCHJq6kcVrXY/dUQKpmnOfnu72KRXhUd4e4+kvQWwXWWXR
	hD1zLzpQgFQAy7vi//MYBSSnCA==
X-Google-Smtp-Source: ACHHUZ6aWAoO8+VPVomym/NUP8XMNnTvJPPQS+D3kdspQ2LETykVC5sXLHUYealrRYHrLzJsXjIZxA==
X-Received: by 2002:a19:8c14:0:b0:4f8:7333:d1fd with SMTP id o20-20020a198c14000000b004f87333d1fdmr3097994lfd.34.1687261257806;
        Tue, 20 Jun 2023 04:40:57 -0700 (PDT)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id d12-20020ac2544c000000b004f84162e08bsm329879lfn.185.2023.06.20.04.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:40:57 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: dsa: microchip: add ksz_prmw32() helper
Date: Tue, 20 Jun 2023 13:38:53 +0200
Message-Id: <20230620113855.733526-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
References: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This will be used in a subsequent patch fixing an errata for writes to
certain PHY registers.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/dsa/microchip/ksz_common.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2453c43c48a5..28444e5924f9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -582,6 +582,13 @@ static inline int ksz_prmw8(struct ksz_device *dev, int port, int offset,
 			mask, val);
 }
 
+static inline int ksz_prmw32(struct ksz_device *dev, int port, int offset,
+			     u32 mask, u32 val)
+{
+	return ksz_rmw32(dev, dev->dev_ops->get_port_addr(port, offset),
+			 mask, val);
+}
+
 static inline void ksz_regmap_lock(void *__mtx)
 {
 	struct mutex *mtx = __mtx;
-- 
2.37.2


