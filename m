Return-Path: <netdev+bounces-4178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2F470B805
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC2E1C209A7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544FD79C5;
	Mon, 22 May 2023 08:50:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EC94408
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:50:34 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75ACE;
	Mon, 22 May 2023 01:50:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d18d772bdso4961341b3a.3;
        Mon, 22 May 2023 01:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684745432; x=1687337432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NJhELKwtMjd03gNF7KmpEmVCJma8B6XT7EEG5otj68M=;
        b=ApcHDbXTiygQvtexd+vH27HcMnwm6bAyv7n6XhOBgE++bWis9vPRqHRS0W6qj5V7DR
         mL5tEC5V7b7/FTroGNrJMazKDOznlB5qH/axuJJeAgq8MC0+ykmqNx5K8iUbqTN3wuRq
         PPSaBggEStKjiLJP/tUl1j7ogRWr0hYF3m9KDRsVamU7UsFj8kaAeBVE09hT6s7x43is
         HqyQ5pfLphm3MK2dL6jdmiGUxET985tsdSBN/vCXQmh8NGz7pIXzdj10SBZ5Y0R4J5gB
         X84ThREsJJGV8FfhQQjm4sVUphClHcb+Edgn7WKcbhuDILxuGPF8UtoSSov/vwb79hvQ
         haDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684745432; x=1687337432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJhELKwtMjd03gNF7KmpEmVCJma8B6XT7EEG5otj68M=;
        b=U7ZUpx3/MTHXGDCOli6HWhaAQ3XD+hm00wI935krr5Qyq7xHPT44EPCq8sRSWTq2rO
         Zj2DgZT/B9ntvD17QIXCZ/VvQVakpXa5U5nkyJaHZ5xF/QVy4cjcwemxRkLsBKcJbjXq
         fVvAzm1Rtsi6CrfCgVmguVkCGDrAEGCiVafvLKb/73IF6ZdbyMw+zP/xLyzWEIqepL+G
         d6xoJ0cxc85JUfbo13doOJhkkE+5uXjquInBFDk2EJ2yRVjoJAT0e3dHeGiFozb2iNIx
         /DtDOfgI2eJugdu2p7ZCjeRKvO0L/CEfm9p8TzpbV7xL15+6/vWYkZnpIIiNYEQdNn22
         kPvg==
X-Gm-Message-State: AC+VfDygYMabSxt09wJZBAvdvg7T7ZJh9JVlQ+67ypCk2jH+hJip3XGv
	//N0UARjhbFCnBOWQ3AM+rw=
X-Google-Smtp-Source: ACHHUZ524pmmQh/7hgo03RLWHzP+ui6VLuXisoysGbVKTbXezkSO3sbxAKJtkMiccFEkQI5HkBBPnA==
X-Received: by 2002:a17:902:e5ce:b0:1ac:b449:352d with SMTP id u14-20020a170902e5ce00b001acb449352dmr12242806plf.61.1684745432206;
        Mon, 22 May 2023 01:50:32 -0700 (PDT)
Received: from redkillpc.. ([49.207.202.99])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902c19400b001ab01598f40sm4319367pld.173.2023.05.22.01.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 01:50:31 -0700 (PDT)
From: Prathu Baronia <prathubaronia2011@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Prathu Baronia <prathubaronia2011@gmail.com>
Subject: [PATCH] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date: Mon, 22 May 2023 14:20:19 +0530
Message-Id: <20230522085019.42914-1-prathubaronia2011@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use kzalloc() to allocate new zeroed out msg node instead of
memsetting a node allocated with kmalloc().

Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
---
 drivers/vhost/vhost.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a92af08e7864..579ecb4ee4d2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2575,12 +2575,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
 /* Create a new message. */
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
 {
-	struct vhost_msg_node *node = kmalloc(sizeof *node, GFP_KERNEL);
+	/* Make sure all padding within the structure is initialized. */
+	struct vhost_msg_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return NULL;
 
-	/* Make sure all padding within the structure is initialized. */
-	memset(&node->msg, 0, sizeof node->msg);
 	node->vq = vq;
 	node->msg.type = type;
 	return node;

base-commit: 4d6d4c7f541d7027beed4fb86eb2c451bd8d6fff
-- 
2.34.1


