Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9CA698994
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBPBBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPBBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:01:31 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035902A6EA;
        Wed, 15 Feb 2023 17:01:30 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id lf10so1434121ejc.5;
        Wed, 15 Feb 2023 17:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RburLBFwxhjygNh1BoK3XjfnjeRQncGDEMOMbUDq08A=;
        b=HZP4+wBtWumoF1mfLhkJlQu5LnNYOOfdFH8yxMQNSpyPDmSYiLpZZ28iMguN6zjDvH
         xl30mVzo0oK31cPGFOPPuUqnuRkNqnxrkxmIyNFr61vDawRV4u7pt1OyR6lhuX1XiHU6
         QQXlzne2cb8dtww7LnLnfk4B3G+Jyv1tE3G1oliYwY46AdFAwfhyOWHotg8dWdtu98JT
         pjy5Foae6xZ+sAUcLh3QghiggH4tQOB/Wen/fH/k3CJMgq5F9rG3QHEcTxbuwfShmn7Z
         gXB4gKJTKyHyRv/cGioiNGozmamEUkBaF3dH7dPN2Wz0xFLVdHAVukYPwbOrDbJl4fQK
         sJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RburLBFwxhjygNh1BoK3XjfnjeRQncGDEMOMbUDq08A=;
        b=uaBYrRSdZKsHBRd0TRAAUKTOIyccH152qwHplsLfYQ5sa3cssQkHqgeKGXRuD1glA/
         ieNI4sm6+6Wisi0h+gi+VQzSyhCKQ4S2SSwqINcUHhQY4BC6KzNX9fUL1NiL9lIcAbvr
         TDAXkgq/kaid7z3zLKTOkjTXlo+rSjnMiWVoaiQ7x0DV7lCRV28UbfvQWOMKibdRJI/h
         HloX4wzocQ9BiGL+KhFVkzFwRP+6P47UNJbSnZjAII/G+ZvLEX3rrdUgohTZ75OKPKSm
         jWjsofjfu9x3Y9ZC+1cvukXjgdaZP4CiP+oMzCYh6GFSaOgtqcXEUCku8G8OAze+NGEW
         CQBA==
X-Gm-Message-State: AO0yUKXxeCpErNpM3+K5DYP+UjxSEO/2hLJFGhw9vgs6SzIFQrWur/s1
        p+ADJB2HyR8xKCRCPr9ZcNKhLqet/7zpRYRJ
X-Google-Smtp-Source: AK7set+HcDpMaQGBx0fdo+qgfhZYfy084qaENQjiAGK8z1s3y4vX+5VJOapeSAvj1wo4u8UQiD/fGw==
X-Received: by 2002:a17:906:b352:b0:8b1:315c:be04 with SMTP id cd18-20020a170906b35200b008b1315cbe04mr3597680ejb.27.1676509288321;
        Wed, 15 Feb 2023 17:01:28 -0800 (PST)
Received: from smurf (80.71.142.58.ipv4.parknet.dk. [80.71.142.58])
        by smtp.gmail.com with ESMTPSA id jw12-20020a17090776ac00b008b14bb505eesm84947ejc.30.2023.02.15.17.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:01:27 -0800 (PST)
Date:   Thu, 16 Feb 2023 02:01:05 +0100 (CET)
From:   Jesper Juhl <jesperjuhl76@gmail.com>
To:     linux-kernel@vger.kernel.org
cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [Patch] [testing][wireguard] Remove unneeded version.h include
 pointed out by 'make versioncheck'
Message-ID: <83474b0e-9e44-642f-10c9-2e0ff94b06ca@gmail.com>
User-Agent: Alpine 2.26 (LNX 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,MALFORMED_FREEMAIL,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From e2fa4955c676960d0809e4afe8273075c94451c9 Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesperjuhl76@gmail.com>
Date: Mon, 13 Feb 2023 02:58:36 +0100
Subject: [PATCH 06/12] [testing][wireguard] Remove unneeded version.h include
  pointed out by 'make versioncheck'

Signed-off-by: Jesper Juhl <jesperjuhl76@gmail.com>
---
  tools/testing/selftests/wireguard/qemu/init.c | 1 -
  1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index 3e49924dd77e..20d8d3192f75 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -24,7 +24,6 @@
  #include <sys/sysmacros.h>
  #include <sys/random.h>
  #include <linux/random.h>
-#include <linux/version.h>

  __attribute__((noreturn)) static void poweroff(void)
  {
-- 
2.39.2

