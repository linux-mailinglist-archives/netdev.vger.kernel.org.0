Return-Path: <netdev+bounces-1137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C348C6FC518
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D15DB1C20B5D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679FE182B5;
	Tue,  9 May 2023 11:35:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B98A182A9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:35:25 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184922D62;
	Tue,  9 May 2023 04:35:23 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so2872364e87.3;
        Tue, 09 May 2023 04:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683632121; x=1686224121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zWM9Ku4QEF1MXGuje7rt5LFZjeiu0mnfAywbxjklTg=;
        b=GsClSg+96jqtWjYLPTKM5pAJI4Eo2Ah8uaXlBAjQknewgiD5RpDgLbDOeUHrrdfrQj
         WuJ0Y6pxTynTReP5smOZrhhjFAN7AVjy0gOR/IKJNhvNZClw6ASSuIfokJ9+WvofxOfM
         9aiSdbQK+suvq1C0Pe2xoy/YOi1G5c2WKReuwgQnwIZzkeM7IQe3cyRksKtFDaOGZUtP
         8DIdgFxhvFepNFy7jRPo+Ql7m1jw76sq13DjFpna9nCCeyHhYRiio1PUxHCQV5R1mK0y
         BKnop1iVJlY7vVgXY4M91QeAEczd+kz22dym4iKCDv7/g5OAC4QJ0cZ1hyOiQUyv/PPn
         emdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683632121; x=1686224121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zWM9Ku4QEF1MXGuje7rt5LFZjeiu0mnfAywbxjklTg=;
        b=RMKOH9b99MAbRuR1Jtt11HX7oB1/jl14YpVE610gw2hHDWqic3havwTbznUiO4Qkum
         xepGieogzkqQuaDwBj+j7Kc4vp1Bi9ffy/39mktLhx1QgYN9voKWd/ly7cQKtyVLQUu4
         iR7kn0ivenuA6c0p5rXxvwh2AEovLMjIXr0M5EgfXYGWFCBmZpUmeE496QSlt99vsrSF
         1OJZPiJaAgzoE3mndM7qdFDUEiGWQ5B6xuSWubRPGrx59tYdWl+8onON0K0z2F8ETiQn
         LEbmIhvqZhWB+5rnhWXKtfzc1omCSEAwVChgDIUcz3KS19f/H9l2JIoQFzQOazH189SO
         Rnrw==
X-Gm-Message-State: AC+VfDw9jZSvHMFDiyCuKj3OH2IvIAZw5xypEeCKLS6rWP8quHYQUTWl
	HcWdG7T/OGjJ+n/gr1JWRG8=
X-Google-Smtp-Source: ACHHUZ4rSmlvz0jORkDZiqRrHk7JyLuRrDC5VraFbgQQXsHmS+H1SxrFJ8w8Mx2ICmrN1/BOlrRVRQ==
X-Received: by 2002:ac2:46f8:0:b0:4ef:fe49:e14f with SMTP id q24-20020ac246f8000000b004effe49e14fmr647454lfo.20.1683632121311;
        Tue, 09 May 2023 04:35:21 -0700 (PDT)
Received: from localhost.localdomain (93-80-66-133.broadband.corbina.ru. [93.80.66.133])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac24570000000b004f25ccac240sm108940lfm.74.2023.05.09.04.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 04:35:21 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH v2 4/5] net/ncsi: add shift MAC address property
Date: Tue,  9 May 2023 14:35:03 +0000
Message-Id: <20230509143504.30382-5-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509143504.30382-1-fr0st61te@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the shift MAC address property for GMA command which provides which
shift should be used but keep old one values for backward compatability.

Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 net/ncsi/ncsi-rsp.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 069c2659074b..1f108db34d85 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -9,6 +9,8 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <net/ncsi.h>
 #include <net/net_namespace.h>
@@ -616,9 +618,12 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
+	struct platform_device *pdev;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	u32 mac_addr_off = 0;
+	s32 shift_mac_addr = 0;
+	u64 mac_addr;
 	int ret = 0;
 
 	/* Get the response header */
@@ -635,7 +640,17 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 
 	memcpy(saddr.sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
 	if (mfr_id == NCSI_OEM_MFR_BCM_ID || mfr_id == NCSI_OEM_MFR_INTEL_ID)
-		eth_addr_inc((u8 *)saddr.sa_data);
+		shift_mac_addr = 1;
+
+	pdev = to_platform_device(ndev->dev.parent);
+	if (pdev)
+		of_property_read_s32(pdev->dev.of_node,
+				     "mac-address-increment", &shift_mac_addr);
+
+	/* Increase mac address by shift value for BMC's address */
+	mac_addr = ether_addr_to_u64((u8 *)saddr.sa_data);
+	mac_addr += shift_mac_addr;
+	u64_to_ether_addr(mac_addr, (u8 *)saddr.sa_data);
 	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
 		return -ENXIO;
 
-- 
2.40.1


