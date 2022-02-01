Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225C64A5FE3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbiBAPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233666AbiBAPUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:20:12 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5CDC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:20:12 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id x193so34034981oix.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BBdeBDeWe4L/TtMbSsfhRAxJzzdZO/Rm/72NYji0NwQ=;
        b=NloSbR3SJDW43zgH2svd5O4WVMUfNxE7p5HLjFefXaY3oU9EAFMOK+tOfFuDpCwMNd
         OzNgXvNdVLBBuIFCLwpQfTw3RpEedAYzEUP9lNJ0CM0ibSITwL5z3kQRzMEEtqXJcDX3
         9vv4GNn6DUlEvbCkZbZM5dV6nFXX+V4f/IoAZpikTq3l6eaxD6jEFM9TAAxZjJyjGxVn
         929Xf12pU3QeuPpvtki52JuHNdLOEBz3rOn7IqD1jD4GjsV/LFo2q6IHJh20ha6msqZa
         blVwLb8pBktlCDfFch/OnDA0xTPYHWV/hjBMTsPMgUZZiMCWIHg+wZO5UuFjNa1Oldky
         HYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BBdeBDeWe4L/TtMbSsfhRAxJzzdZO/Rm/72NYji0NwQ=;
        b=YYOGxe+dwNwOC2MnbwIGTCNnYXNG1EnZwFEkdVCbN86jR7LQ654ucX46y1bYuI8EOY
         SLI5uUDNAK6KbG2Q1BfvEsXxrpD1PcHutKDxfP4SCkHBbbXi2b5VMNuleocP5l/EuEnf
         GRZNCg+LMZgtPdK+I+gY1Iz3AcY6uMlmn3gZ+ULI9zpn/gIv+gzvWW+q2CrpY+tzKT5/
         cyj6vcLRoWn1OIon7IBnqHlB6dreau/EzWcHdyu12v3kCc7fakJN732NHwfNIwBt3Mdl
         Uedo8Tuq4TtvDF20kGC6H/BwAfuqeja5WM9BCLVlYlFM8b1NsGP1+YyFaPBVgkKPxCDt
         /BYQ==
X-Gm-Message-State: AOAM532lmHvTZ2DyvkggoPjnV6dtiZknQREVytMI55T/Pp6/3FYsgRly
        BzTfDEHEKQuwVdmeGRGFD9HA9t82+iQomRXk
X-Google-Smtp-Source: ABdhPJy4rbteZ9uDUMzebaLzNRpy7yS8+Jk6Hd/HnoxTZZSqrPCnKjbHXr+o22dobIDIZ58ddyUjvQ==
X-Received: by 2002:aca:e103:: with SMTP id y3mr1546833oig.146.1643728811358;
        Tue, 01 Feb 2022 07:20:11 -0800 (PST)
Received: from localhost.localdomain (177.205.163.238.dynamic.adsl.gvt.net.br. [177.205.163.238])
        by smtp.gmail.com with ESMTPSA id q3sm12441459oom.9.2022.02.01.07.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:20:10 -0800 (PST)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, vladbu@nvidia.com,
        marcelo.leitner@gmail.com, kernel@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>
Subject: [RFC PATCH net-next] selftests: tc-testing: Increase timeout in tdc config file
Date:   Tue,  1 Feb 2022 12:19:20 -0300
Message-Id: <20220201151920.13140-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some tests, such as Test d052: Add 1M filters with the same action, may
not work with a small timeout value.

Increase timeout to 24 seconds.

Signed-off-by: Victor Nogueira <victor@mojatatu.com> 
---
 tools/testing/selftests/tc-testing/tdc_config.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index b1ffa1c932ec..100a3df464db 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -21,7 +21,7 @@ NAMES = {
           'BATCH_FILE': './batch.txt',
           'BATCH_DIR': 'tmp',
           # Length of time in seconds to wait before terminating a command
-          'TIMEOUT': 12,
+          'TIMEOUT': 24,
           # Name of the namespace to use
           'NS': 'tcut',
           # Directory containing eBPF test programs
-- 
2.34.1

