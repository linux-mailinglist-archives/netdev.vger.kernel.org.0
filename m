Return-Path: <netdev+bounces-5484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE3C71198C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0841C20F61
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FA1261C9;
	Thu, 25 May 2023 21:49:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832C24EAA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:49:46 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A20B170D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:24 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f805d07040so2268591cf.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685051363; x=1687643363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b9oQQEcQI1nKAm6uixVG0PKEiMtQci0LL4e5riL3yY=;
        b=Hjin/XYbx7VeVEP0X3YARthb2xefjOQhQU0+Qj7YBCpxMJ13D8pVDHGrh5RTqVbkvf
         cW0odLnmOToygKD9ts8kqgl8Y1S1R6fxT0eWHXWKR5K6WGzi5efPGG8qMdon2dYsoTCU
         1C/cJSKFdtXpuFxH9oAYUlLyU5lsmCSgSazWUNsxT3JxgXFfBlZmrP0UWcUag0eiEP1q
         Ur8Qs/PUfrhBksfe0EmW6a5ImbCjwRzwyVNfqRx+Z5WgNQ1vAGpgvLOo4n9oeXsb/8sx
         naLWvuionS5Q4uQ0Fifsf4U8kHF6qtDLXzhbAk/Td0rbFhXa0jwrGTxseJ2Oy26Vi6xf
         MjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685051363; x=1687643363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9b9oQQEcQI1nKAm6uixVG0PKEiMtQci0LL4e5riL3yY=;
        b=TPqOgxAQqsM5nomtVUcS2aY7TkcnqLNvtHtX/v/igChYw5vhwMLFUAzGLkjRrjc8wN
         gS/wuIFjx49l8lg0tjn0SOzmzcJW8UU1zfX+Zkspo9G6DvnphxuoR3iGpwrVfmWNrzrE
         Ul0FlwTonBEnPdlD13fumomHoAWFd4wOVnisAOJjSIpDjTQPeZaJBiBwe0xZ/LRR29kK
         2Z2CMYzAgFex+zpt066r9OBfXv+e5orGuXx1SNx1IqN3S4IQkRZ635e2kG343+MgwLYe
         ASV1VFE1qZyY9HawOAMHhpTQDiGhx3Ty9lOLFzdy3U3ByvVdmm/T2ZZwmyVCQxQU6WfN
         HCSw==
X-Gm-Message-State: AC+VfDyBCWNy/B7oZxDkfPrEpcaado6UsTcx1obR9qnaEaQ9ezeaghvH
	bEz8dvVf71tHYsZJ2GwTHHGXk2jTnvp56A==
X-Google-Smtp-Source: ACHHUZ6SFJRhU18yCnx9kxWrc1xoOv8R64Mi9egL44gb55G9XixlOO6iIWNUplnal4eJRcB17CGOOQ==
X-Received: by 2002:ac8:7d48:0:b0:3f8:364:70da with SMTP id h8-20020ac87d48000000b003f8036470damr1121880qtb.32.1685051362969;
        Thu, 25 May 2023 14:49:22 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x7-20020ac81207000000b003f7f66d5a0esm735742qti.44.2023.05.25.14.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:49:22 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net 3/3] rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg
Date: Thu, 25 May 2023 17:49:17 -0400
Message-Id: <b1fb9330f06ad743b51e50f398b1208d2fb47af6.1685051273.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1685051273.git.lucien.xin@gmail.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
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

This fixes the issue that dev gro_max_size and gso_ipv4_max_size
can be set to a huge value:

  # ip link add dummy1 type dummy
  # ip link set dummy1 gro_max_size 4294967295
  # ip -d link show dummy1 |grep gro_max_size
    dummy addrgenmode eui64 ... gro_max_size 4294967295

Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/rtnetlink.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 68a58d0a7b79..4c7d84072bd4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2398,12 +2398,24 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
+	if (tb[IFLA_GRO_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GRO_MAX_SIZE]) > GRO_MAX_SIZE) {
+		NL_SET_ERR_MSG(extack, "too big gro_max_size");
+		return -EINVAL;
+	}
+
 	if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
 	    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
 		NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
 		return -EINVAL;
 	}
 
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]) > GRO_MAX_SIZE) {
+		NL_SET_ERR_MSG(extack, "too big gro_ipv4_max_size");
+		return -EINVAL;
+	}
+
 	if (tb[IFLA_AF_SPEC]) {
 		struct nlattr *af;
 		int rem, err;
-- 
2.39.1


