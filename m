Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22575788FE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiGRR5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiGRR5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:57:02 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F242E6AD
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:57:01 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id m10so5434982qvu.4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wg4COycJyI9sk7+JmYkrdfWGHhPsLDOofYkTEEydFWg=;
        b=Fqu+GxJuIHKWO2F4h5YvVtEJvYk5vgCyZrfPuO3scKyUjuyIJcUF8jc9rx7ky7BjCs
         iYeLJ0KVG9Ic+N9gJRmSk/sGVT9VK8e44wRNqgKa06k60AzXZvWG3XWXbVYJO2rEYeea
         dcryZ8F0+oHotmnthZCISwIAxQHqd7Z5b/ZqXrDStvGhNwylJkrzy8F/NYKmHdOgwKaM
         Q8xsrqWce/PnAiiE+kVDFmd907rECRDOaEHFX17fioCAoY/RLgbnleyzXpGLQkk6l1l4
         mOwLCP2hAfm8/oZFdMg3acSd4446AWs8jZhpcmA2PODZe9uWw649BJuLbIZKSG1MYuXF
         4eJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wg4COycJyI9sk7+JmYkrdfWGHhPsLDOofYkTEEydFWg=;
        b=R4J9qKYsvafGssg7K/A411eqsU8+Smc27bQV6biFx41o7bDkch+8t/1hXIJEK6kEL2
         6J5hHa7GpbLdBmBeWvhbbEVshXFgffWmTdPwNHSUzTjvhPbqy154L9kHw+JSJyo3kFa8
         z8bPyzWvCX6QRAOF35VEUp9QAy6tmj6yXQ7gNLPIuPO5vV628/sY4LvBkZ+wUSFcW2Sy
         LE+hEtRsTD2vtVAE554ENS8wx9XHfxHXYJpWXqf2SNmxY/5UrksU2hXYQZ3HIjiICyG3
         PmRgWuMZxlNa/JoOprYDfPsiZ9//x8K0lPCsagxxBwsxImjfEeezjPJ79S2vv8sJ+J2y
         um8w==
X-Gm-Message-State: AJIora8zzBwRY0TmPHX06+cQTfYF2xHLqmFP6DXnmsanpJI/2C556exA
        iF5Kl/VTHP22Irac609L801HzuXsq1gkQQ==
X-Google-Smtp-Source: AGRyM1uW4Eeu7TjZDwvhP0EoyEbLX6TjO46DFqZwgV7IodURHM5gyRkmohuhaUeYqsg5JQgLLbk5nA==
X-Received: by 2002:ad4:5dea:0:b0:473:8378:ab8c with SMTP id jn10-20020ad45dea000000b004738378ab8cmr21650782qvb.75.1658167020637;
        Mon, 18 Jul 2022 10:57:00 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id de32-20020a05620a372000b006b58d8f6181sm11610850qkb.72.2022.07.18.10.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:57:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Hideo Aoki <haoki@redhat.com>
Subject: [PATCH net] Documentation: fix udp_wmem_min in ip-sysctl.rst
Date:   Mon, 18 Jul 2022 13:56:59 -0400
Message-Id: <c880a963d9b1fb5f442ae3c9e4dfa70d45296a16.1658167019.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

UDP doesn't support tx memory accounting, and sysctl udp_wmem_min
is not really used anywhere. So we should fix the description in
ip-sysctl.rst accordingly.

Fixes: 95766fff6b9a ("[UDP]: Add memory accounting.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b7db2e5e5cc5..22703560d2e5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1052,11 +1052,7 @@ udp_rmem_min - INTEGER
 	Default: 4K
 
 udp_wmem_min - INTEGER
-	Minimal size of send buffer used by UDP sockets in moderation.
-	Each UDP socket is able to use the size for sending data, even if
-	total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
-
-	Default: 4K
+	UDP does not have tx memory accounting and this tunable has no effect.
 
 RAW variables
 =============
-- 
2.31.1

