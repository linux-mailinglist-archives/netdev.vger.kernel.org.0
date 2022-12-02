Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDE46403E7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiLBJ7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiLBJ7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:59:38 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAB198570;
        Fri,  2 Dec 2022 01:59:37 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso3828093wms.4;
        Fri, 02 Dec 2022 01:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=AOJ2FXR01+n3tpmlO9f2hRTJxeAqDo2HtHNsfh+qCTde+csQXo0ZciHvGYtgaRFNX3
         AaQaqGy1RKq6abrm03001pYiWegV4XfJZz2Er3NkcQNxT+7/6r8AOtcdFKCxkex5pAyr
         wPbIP8cv08IIWFLJK0VyDnlxRjXfLyOIsH/3iG9En6CSYsmJMN/fqPsh93Ic+fZeQHwn
         MSLzLa5lV4fdLJA0qUKb6s9kMWeNAw0uEF5tkFsv/WSS22EZ3k/8ZUHU3G2rq13ON7Pa
         kzOtk1jIT46VQ4C+YtONu/7pF7dt68MxUaE0GTaVrS55lM5szVC8TGE/d4WVKJHUjhHH
         5w0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=yYVymEHsf6GTXfP5OwWUe0KXQnW+77qgS8JEqUkq0YYx0TjltJLnCziWsI+uCR9Nug
         pP9ohMizA0iDn/OAxPiV2PbRW5134Zb07PNv1aoUpdvHr8puQZ4v+rqGFdzRErFslkeh
         7j/ZyqN1YMxBGS4XDStXBqsDi9XaQfKoa/wi9SLr2qh/uDusKm7jaI3gk6kZqCXa/qjW
         Lw5IAP6jxnHKyYb+YtFvu3aEzc6pNIimgkHnLihqVA/UcWei8IPV3NBTvEBaC9sebLYj
         AT8Ns+8vgIv/5p+r+D3n4vbKawT1GlmNoXGLGuOX24r327uoz3QX7zV/ilW5BrdgFvsL
         r8oQ==
X-Gm-Message-State: ANoB5pnRFgDU/nSzrCAXM3hVm7ijSetndqBXGECfkVrT4RGd8AifqWsu
        1RddzDG7qC306ODaMyNu3xo=
X-Google-Smtp-Source: AA0mqf4QmeBFiYTqm7ho17tjYz/1mvwlQvsmS5hChxIB7uI9Xr5Ktghxz4CkotL+ZWb5FmhpZQYdnw==
X-Received: by 2002:a05:600c:35c8:b0:3cf:cf89:2f02 with SMTP id r8-20020a05600c35c800b003cfcf892f02mr40625512wmq.2.1669975175650;
        Fri, 02 Dec 2022 01:59:35 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id s1-20020adfdb01000000b002420a2cdc96sm6517851wri.70.2022.12.02.01.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:59:35 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v4 1/4] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Fri,  2 Dec 2022 11:59:17 +0200
Message-Id: <20221202095920.1659332-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202095920.1659332-1-eyal.birger@gmail.com>
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
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

This change allows adding additional files to the xfrm_interface module.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/Makefile                                    | 2 ++
 net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (100%)

diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 494aa744bfb9..08a2870fdd36 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the XFRM subsystem.
 #
 
+xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface_core.c
similarity index 100%
rename from net/xfrm/xfrm_interface.c
rename to net/xfrm/xfrm_interface_core.c
-- 
2.34.1

