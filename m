Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C9547901
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 07:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiFLFU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 01:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFLFU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 01:20:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BFF47056;
        Sat, 11 Jun 2022 22:20:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z17so2978301pff.7;
        Sat, 11 Jun 2022 22:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xj6/KX50FekJjTpLTPqTssqKYApqg9fngLCkTaEBqV8=;
        b=k4Nhl0GsSp6+JAoBrZRfuXI0veblVRqtvhIWSgoXsHmyPmh3Ic2Hp/elgB71bj43AZ
         tZa1OxcOtWK5C6ixfQ3D+mYJ58HxlSM4/lNPmkGSfhfsOEdeGcxPemx1+zHZu8hN6tRz
         43zQaatbdYdUUghpbN9H0VvTVWeWt2yL402OJNfq2KXCeDSKLI24QiFTDJSfe8zZ/A6Z
         64N9yrcd8BKrEYhBbSOCukjSYUKITrvTatOYge7RRvMFgjnBtvSfjfs+iF8vLVL5bkqS
         TV1pbNp7KlJwEB7Ou1h6Gi346uVFuOpkDM23m2P/xhlBQg+ajSRf3L7xEiGwMH9WdTIv
         3vUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xj6/KX50FekJjTpLTPqTssqKYApqg9fngLCkTaEBqV8=;
        b=4JEFRfE0UTNtzkBCWb9M7Yva7rEap2+xZkoOxB1MnaE7IpMO9IGLoaYeMXZDkxN7Bt
         JFY1SqaFCeS9mhp0TcWQRT/uWdOc/n8cOWe3LLTIgSPEKBM7sFB1IGuyGwHSuAU47XR1
         gchxmiXFvodLk+FDEtyJEDnj2AySs42yNfWtnrNB4OgieoD68K7mH4Jq0q1bt4isQEnV
         ZgY+gFaojp5irQvDOEPjE+5PaE21X0NQNQc8fz9UI+vSSywwSNxNGPDRxbwPLt8WCOKr
         GVfmu3cO23eXLXMGxdpjYOOhCDM0XqVbXujfKL9fXuynwzR6FCSKWlVuV0goEn0RFcoA
         wMtg==
X-Gm-Message-State: AOAM531TmMLrvOg8Bq9BR2JHAUcsCwI19k1aKWj/XD7S8tZ8lEAU8CZc
        rBRINAHFgM4sBwLEE5UrlH08tvnPyfIVQQ==
X-Google-Smtp-Source: ABdhPJxJAYfx23k+RSV7iSzLgCe77PjpW4Of05oOjFh51dL6IK3ZQLZS71rBMDpG1a1ieluLnXfuGw==
X-Received: by 2002:a63:7749:0:b0:404:1c03:9244 with SMTP id s70-20020a637749000000b004041c039244mr9027890pgc.145.1655011222465;
        Sat, 11 Jun 2022 22:20:22 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id im15-20020a170902bb0f00b0016141e6c5acsm2330471plb.296.2022.06.11.22.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 22:20:22 -0700 (PDT)
From:   wuchi <wuchi.zero@gmail.com>
To:     mhiramat@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] lib/error-inject: Convert to DEFINE_SEQ_ATTRIBUTE
Date:   Sun, 12 Jun 2022 13:20:15 +0800
Message-Id: <20220612052015.23283-1-wuchi.zero@gmail.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
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

Use DEFINE_SEQ_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: wuchi <wuchi.zero@gmail.com>
---
 lib/error-inject.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/lib/error-inject.c b/lib/error-inject.c
index 2ff5ef689d72..4a4f1278c419 100644
--- a/lib/error-inject.c
+++ b/lib/error-inject.c
@@ -197,24 +197,14 @@ static int ei_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static const struct seq_operations ei_seq_ops = {
+static const struct seq_operations ei_sops = {
 	.start = ei_seq_start,
 	.next  = ei_seq_next,
 	.stop  = ei_seq_stop,
 	.show  = ei_seq_show,
 };
 
-static int ei_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &ei_seq_ops);
-}
-
-static const struct file_operations debugfs_ei_ops = {
-	.open           = ei_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(ei);
 
 static int __init ei_debugfs_init(void)
 {
@@ -224,7 +214,7 @@ static int __init ei_debugfs_init(void)
 	if (!dir)
 		return -ENOMEM;
 
-	file = debugfs_create_file("list", 0444, dir, NULL, &debugfs_ei_ops);
+	file = debugfs_create_file("list", 0444, dir, NULL, &ei_fops);
 	if (!file) {
 		debugfs_remove(dir);
 		return -ENOMEM;
-- 
2.20.1

