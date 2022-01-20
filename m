Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDE34955D6
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377779AbiATVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377777AbiATVME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:04 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79972C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:04 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id t18so6261577plg.9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Lu8Ofe9OiOomvfdmKceVGmq8zIVB6BYh6XUCUGTXdg=;
        b=w1w6v8pEOL/+Ge1FFFavo5OL7raZfrz3kUhWo7RGBs2qv+U4sZaigCZzr1LJxcIWl6
         LszkeFAmil9FYpy7OtChAXWGunjhW47Y1+BStxHupExnNdXiYxl1jx3TgqSS0CA86pgb
         ZRcLsNXoDmhLA2Zf8xeKlXwqbBHIlQdeglHl8UB3ywzNZaXW7gbs5jbrsmuAJrUjb5Zx
         41QtKyfeXnTDZ9PpsaPW0nbp8/ACwHEkZw26HbPA/V3oAH/WS72sJlXS2fm9tuLbGoU9
         ys3sZxNmrgcIpnKGTcAvKLGO+FYx3d3GLRMrZ4CTq07b/3XbUM+vY/4xon35rW528xAG
         plvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Lu8Ofe9OiOomvfdmKceVGmq8zIVB6BYh6XUCUGTXdg=;
        b=iAKa09CKbjYYw6F8TFaFptza1NONfkzCdGaL79WPM0hp+H6/n8Wr0MZJSU59fg7P4L
         nGqpj3m41LhDGhBmhzAMgz2+Gs3vbNPGxPZDmty8s4hZPvIAnn/iNX+h6VKplLZmJGNM
         xdZe4LA5VNFihXSr901uZKtl7sla/fztlxiHYaKZYa9yfw3DjswTOq8i8WiT5xkIUhuB
         JSPWTvxfBuRtj2agNpb/J5+uG9qLTRgpUxETYsAuRX+YwdO7lqeW2YfpYSiZeu3PcDzv
         tEPkyAPNGhL2VVEG2UIfB0Fq3TUf9zlCX854Cg9lzm4sGSLQf41ZvXjJ0OUHzW0H/aXX
         qqTw==
X-Gm-Message-State: AOAM530zaWt6d9Uw7NOu2PbbsHRgbQ0MJXgLTOCDuWjO7NUhqUfmsbcy
        cl/QdoTRi6Zt8HHqcOMiUmu0g/dD4jptCw==
X-Google-Smtp-Source: ABdhPJw9dHfdYJF/MQFO9ryObJNXV+ULwPiDddLVYsIjhDlN9MmoTcyFSGNoyKjwjivfrnhd2kLsIQ==
X-Received: by 2002:a17:90b:1a8a:: with SMTP id ng10mr975280pjb.175.1642713123741;
        Thu, 20 Jan 2022 13:12:03 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:03 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 07/11] can: fix clang warning
Date:   Thu, 20 Jan 2022 13:11:49 -0800
Message-Id: <20220120211153.189476-8-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 854ccc314e2b..6ea02a2a51c4 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -330,8 +330,9 @@ static void can_print_nl_indent(void)
 	print_string(PRINT_FP, NULL, "%s", "\t ");
 }
 
-static void can_print_timing_min_max(const char *json_attr, const char *fp_attr,
-				     int min, int max)
+static void __attribute__((format(printf, 2, 0)))
+can_print_timing_min_max(const char *json_attr, const char *fp_attr,
+			 int min, int max)
 {
 	print_null(PRINT_FP, NULL, fp_attr, NULL);
 	open_json_object(json_attr);
-- 
2.30.2

