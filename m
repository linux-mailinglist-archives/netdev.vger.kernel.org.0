Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6751DF00
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347109AbiEFSYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392404AbiEFSYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:24:00 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBAD57B08
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 11:20:16 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id x22so6602574qto.2
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 11:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnV6x3yvJYvlKCHyeqtesD+ZXPo5WDnn9+bfpYO4eGU=;
        b=C9Jd8w5oXJ9UwnIhxdIXoOit2DYqy4ZTbWazkCY58TprFtfeEs/tC9yniTTtFH4Nwy
         5yKbU3UjTahOTyHMMRccs0k4g9Zz0sfCcFtXG+Fj4Ag442cdpv0ue4qAO6RSzxzu5G1k
         G8E+eIbjTjtzxUK444F23KofS0LZPiKNEJR8xFdnj59zA3cF/r27dlwTpSOdK2yUGXhr
         lz+Ivluff1yACsmkvd+6eIFbAzuyLy8BPC8Q4F7mZCsh1sIKEIe/VJEh8uL7Ps0npHiR
         toaOFzrfZBMauW8L3puHRywxyAym2z23/vYBW98b3lmM4ycFzOd/XubaPztxUREvlOs3
         nnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnV6x3yvJYvlKCHyeqtesD+ZXPo5WDnn9+bfpYO4eGU=;
        b=YSiM64AZ7CK+iDbbdDWxx4SvJirGyzNJIMWSp4JH6wJ8OjDfQgYSrBKijE1JUut1z7
         NzbUYpJ77Em1fMbG0VGLCkQGQs/wJD1Zn/PSHJ3LE+8qAAe1zRs+X5/u7VPG8twnzpzz
         X3FAEN5h4a6Zk0/lbPhZCD4u0dMkp/8Xe7qlWutc4ocAEN3rG9z0wvd4yKhG8E6Rt6VO
         iXx1XjUpwmYAcfA7I+p07ZPxv9m0isGouliq41gGTgAM6I0htt9Yn2azNFRO34vexKTQ
         TTJFTTlT4C4eJSsbvRDCpTb0wZ3BFqafrvzfK0c26bEIUUiJf5Ov/axssh6zVadIT/uk
         1tzg==
X-Gm-Message-State: AOAM5333uNYD9NyuM3cKZFrtdkMGi4UppdFiVUVXtk7auT9fsmGc+zyJ
        KhJgrN1T9G8wGP0PnCSKgSHNI7103B8=
X-Google-Smtp-Source: ABdhPJwZe+fP1NSjcRO/NDkpyUpibXKywpXAwkNKRqshKV/MvZetUdPZGzsrP6D40o1wbGVfKTGuaQ==
X-Received: by 2002:ac8:5c08:0:b0:2f3:c715:1f0b with SMTP id i8-20020ac85c08000000b002f3c7151f0bmr3411245qti.419.1651861215045;
        Fri, 06 May 2022 11:20:15 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v32-20020a05622a18a000b002f39b99f6a7sm3176529qtc.65.2022.05.06.11.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 11:20:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] Documentation: add description for net.core.gro_normal_batch
Date:   Fri,  6 May 2022 14:20:13 -0400
Message-Id: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe it in admin-guide/sysctl/net.rst like other Network core options.
Users need to know gro_normal_batch for performance tuning.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Reported-by: Prijesh <prpatel@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/admin-guide/sysctl/net.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f86b5e1623c6..d8a8506f31ad 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -374,6 +374,16 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
 If set to 1 (default), hash rethink is performed on listening socket.
 If set to 0, hash rethink is not performed.
 
+gro_normal_batch
+----------------
+
+Maximum number of GRO_NORMAL skbs to batch up for list-RX. When GRO decides
+not to coalesce a packet, instead of passing it to the stack immediately,
+place it on a list. Pass this list to the stack at flush time or whenever
+the number of skbs in this list exceeds gro_normal_batch.
+
+Default : 8
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.31.1

