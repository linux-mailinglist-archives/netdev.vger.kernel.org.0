Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD31B62C969
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiKPUBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiKPUBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:37 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFE863B94;
        Wed, 16 Nov 2022 12:01:37 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id n18so12635857qvt.11;
        Wed, 16 Nov 2022 12:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwSzZ6SllwRzeJYXbwainLDCTj8TeOisBj2diVYCdCg=;
        b=dvIYXUqJLT6hA7yNNZxTJvgDmyyOrofAx4TE5fFGlQWrgN6EQokXfJ7ZbNAIsNEpcv
         8c16tEe4bkaLFIwLopwoPS0iLkxMXon8xolCsPUsx4djzYBa/IvLnIKWHHWEdaIisc5/
         bqWbij5X3SP5BJDDv3DU6rP6//uVYMqIFLPOLi22WyGzzmeYLqiGOAdf/1bB414hCyDW
         wRvsyNiqHmU514iLloHv2OVjHlIAl/1lBMkghfcmu3SaN8XWlVLVwTvhO8kuYm3w5AmH
         qyp3//Vt+PqSi5tqJ38mjJl3iH8TnXIDJoIJ5peoc5M5zfTKSRNDis+EZfmfqmMF0Nty
         ql1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AwSzZ6SllwRzeJYXbwainLDCTj8TeOisBj2diVYCdCg=;
        b=PL2+iOmgkoU9cb86lQ74iXCqecFZeEBgaYsTu1J/0+hCqrGmxuBEB02NxX9STkN3RP
         xZahiFUZ1REIASVEp4cIvlAA5bNT/NR/xriMW28oncMzV5hGAFlfBV2XcJY9kEm3UxAf
         1E++NGH8Ce8kY2wrA1nJt4qegyXqG3KpG9zg+aLQC+VSC87sFtEbZssRmycIOWSmG2NR
         7ar54sDirT0VfLUOlJxyKKk7K3KMLNfwqRRDQHJcEHO+cViwRTWA56ts4dQ0oJ/Soi/A
         aFMwhrs7IJy98Sl8nMm0mdXfMMbP3Yn/NtBc3hw/mRyBWxx68hRjLDrezNOIJi5hpPZK
         oZ+w==
X-Gm-Message-State: ANoB5pmujidstsgemPnSjV1r7ZiitDxenqmXbaMlYoZN30IqJ5QwXa06
        yo+3v/ODVBmP2G2vEqRiQPStzpMR8Wjb5Q==
X-Google-Smtp-Source: AA0mqf6Tr+5Axmx6iE/VuV3UdAz1tUdSgsHYzrfWVGYy2byhWvDWJlGsqznu4uP6hF4u3Fb31fuIWA==
X-Received: by 2002:a05:6214:4585:b0:4c6:3435:c384 with SMTP id op5-20020a056214458500b004c63435c384mr17468074qvb.72.1668628896095;
        Wed, 16 Nov 2022 12:01:36 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:35 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 6/7] sctp: add sysctl net.sctp.l3mdev_accept
Date:   Wed, 16 Nov 2022 15:01:21 -0500
Message-Id: <6779a75a7180d04f8d01236249b8e9cda8071f6d.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add sysctl net.sctp.l3mdev_accept to allow
users to change the pernet global l3mdev_accept.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 net/sctp/sysctl.c                      | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 727b25cc7ec4..7fbd060d6047 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3127,6 +3127,15 @@ ecn_enable - BOOLEAN
 
         Default: 1
 
+l3mdev_accept - BOOLEAN
+	Enabling this option allows a "global" bound socket to work
+	across L3 master domains (e.g., VRFs) with packets capable of
+	being received regardless of the L3 domain in which they
+	originated. Only valid when the kernel was compiled with
+	CONFIG_NET_L3_MASTER_DEV.
+
+	Default: 1 (enabled)
+
 
 ``/proc/sys/net/core/*``
 ========================
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b46a416787ec..7f40ed117fc7 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -347,6 +347,17 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1		= &max_autoclose_min,
 		.extra2		= &max_autoclose_max,
 	},
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	{
+		.procname	= "l3mdev_accept",
+		.data		= &init_net.sctp.l3mdev_accept,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
 	{
 		.procname	= "pf_enable",
 		.data		= &init_net.sctp.pf_enable,
-- 
2.31.1

