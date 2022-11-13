Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693DB6270F4
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiKMQpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbiKMQoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:55 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0411411A1B;
        Sun, 13 Nov 2022 08:44:54 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id z1so6121454qkl.9;
        Sun, 13 Nov 2022 08:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sC6vxlfBAN7GVX9BC10B/DhPuH7UtHZh2L4PSe96EEM=;
        b=o4gnJwlsVzVVLfn3Z7aGCqUwfh+hsHoAbns/cJViDXYPOk0oiorrH9e5buLGv5PMms
         vvi5SMbyOaUALXZPjb8HEntmCDQAhlXSeTmnBLlzQcUUMjIzGZASGZeRLguDJjXlEzxX
         YH8VdNgTjzpBJk6lBAbQJvELtaNiIwNiQRgqZVU1WKhGvbeBmgqwFi+b2jXMqB1j/zHh
         5mWQqgwbR8azRC/hjVbBOxAZCpkmrpfqns2vXNvnrTjg0d+g5bhfO2TuDNjnRKqeCvfP
         EvLimGRhNIxfl3TBL5uym6pdsqGUJH1Gfxu7fVzfo6fgGVaWzreK+53Rq/aWyKoCGtwm
         tEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sC6vxlfBAN7GVX9BC10B/DhPuH7UtHZh2L4PSe96EEM=;
        b=YpoxwpnIYxNOotGinbU9CtJCFALVyzsIWRWQXQfdXI/lYYQtn5osWdJn819sNRwxjr
         9dmGLx6Pb5Xz55QifZYauV56tZI6ixVhwamH2j20lwi0e4J1l63bcyPFWYDxLbmxqiTF
         18VLx5+1fHjvucObsi+Acl9xweI0T+/E9LoTJsesq0/2PyjXRzDYuH4o09MIypZ1uT5w
         JSdKPnEjVoxirubFOFjvGgkejkFy+WwXLPpDRVySt6GJh1Yp+katjNZU44O/vWlqBqaj
         99kEbxOf+OOMmECSXQeQ4+zrmHPu615+bsmIiPlSp3mVaLitw+7B1fKpOvVtMBE8eH6B
         FpqQ==
X-Gm-Message-State: ANoB5pkR98eRT7nUR2sWOBlUEeJWbE0hvTG/YzIi9MgyeiNOb310juNl
        gOqTJUOjhv0X/w965dyKiajBpCWCKaBd0Q==
X-Google-Smtp-Source: AA0mqf5BqlWFvavr9tUo+Pwf6oPjLeldr1FlsqwkA7ylDyFB6HUjf0w9cpGfGiN6TqjXgEIOob2Kog==
X-Received: by 2002:a37:f504:0:b0:6ee:9044:56c6 with SMTP id l4-20020a37f504000000b006ee904456c6mr8304182qkk.274.1668357892915;
        Sun, 13 Nov 2022 08:44:52 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:52 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 6/7] sctp: add sysctl net.sctp.l3mdev_accept
Date:   Sun, 13 Nov 2022 11:44:42 -0500
Message-Id: <bf6bcf15c5b1f921758bc92cae2660f68ed6848b.1668357542.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668357542.git.lucien.xin@gmail.com>
References: <cover.1668357542.git.lucien.xin@gmail.com>
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
index 815efc89ad73..096ed1a82cbc 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3100,6 +3100,15 @@ ecn_enable - BOOLEAN
 
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

