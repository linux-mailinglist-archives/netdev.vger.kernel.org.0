Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5272D4C6E61
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiB1Njp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiB1Nhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:37:53 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCDF75C13;
        Mon, 28 Feb 2022 05:37:14 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id l12so5539296ljh.12;
        Mon, 28 Feb 2022 05:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=aj6KUOaZOqE3uq2D8cyeXlngR1zSjmAmzoWF1U7pslM=;
        b=VA3iZPMwP59jluFEBQuvoGvxhFeX9+DFwf7UEk5RHYeS5EAn8lp0aTqES853r9OZsY
         sEWlPl5U9HjC4jnuU2eYUWgKN3A5isMa/3Xb+W66TkLp/MQSbW2/Rt0cQulEGelx5CTM
         weFtVatykpJMFpdNW0hXJVFynYnalYkxSGEIleFx8wL3cQ8O13BwL8++wR3HgG2Jrsm9
         fDcuiB19M2VWoefvxdRMLqruIphLf1Nx2+TZ2Lrqvgnxj0LA8/BMO0u/InSH30ENTGzJ
         rysbDyxln1A58UYG4sNP/w+EDWwHDJ6dKCNOsrA3lMFFEqNxceXLKxCcwvA+hsUy+2gB
         PkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=aj6KUOaZOqE3uq2D8cyeXlngR1zSjmAmzoWF1U7pslM=;
        b=yLpmjZAy41TQfUJ6cs8e7Ta+iCMdUw+85cOaeq0m4sCZmItkoC++rFymGKmyc/5mu7
         EVqV3zKHVqF1s7HcVw4bvaiC0lyLC3LhGHvtGYUvK3AcLs64TgHDWiE1FfrmNfzdJDAh
         +m5Ywq+ju6w7wUsEWjvNuRoDxIgl/95BGVKQD4X9eJsz3NSlmmUrJ7EIVzcvdXtn84zS
         CsMXrLLT0LDibSl1qiP9rJo0WRJ5jATCf/8O4ReZ/6MZYIo+IJSV/07oJgS8CvOYG5/J
         0T0WcCb6m+d+Mp4nrK34hMQ6p9BWHKjpdpXKTsNm3FdRU4ZM2SHcJC0h1Zv6dxIpN1Bz
         aadA==
X-Gm-Message-State: AOAM531zlDwEa/dCL6QzB2huGLmQbfpQp1h3puqIgUSd+25HgD3ewamw
        NKlCmAy6axnJPwaI702y6hE=
X-Google-Smtp-Source: ABdhPJyxEhstvlkyxzKUhjRORgnKa/8C4Gtif3HPn8db0OHuxbl+3L5vfG80QePxi9c8+v7OBbkQcA==
X-Received: by 2002:a2e:808b:0:b0:238:ea7c:faf8 with SMTP id i11-20020a2e808b000000b00238ea7cfaf8mr14255323ljg.513.1646055433276;
        Mon, 28 Feb 2022 05:37:13 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i16-20020a2e5410000000b0024647722a4asm1326640ljb.29.2022.02.28.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:37:13 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next V2 4/4] man8/ip-link.8: add locked port feature description and cmd syntax
Date:   Mon, 28 Feb 2022 14:36:50 +0100
Message-Id: <20220228133650.31358-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 man/man8/ip-link.8.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9ca..800ef278 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2376,6 +2376,7 @@ the following additional arguments are supported:
 ] [
 .BR isolated " { " on " | " off " }"
 ] [
+.BR locked " { " on " | " off " }"
 .BR backup_port " DEVICE"
 ] [
 .BR nobackup_port " ]"
@@ -2473,6 +2474,11 @@ is enabled on the port. By default this flag is off.
 - controls whether vlan to tunnel mapping is enabled on the port. By
 default this flag is off.
 
+.BR locked " { " on " | " off " }"
+- sets or unsets a port in locked mode, so that when enabled, hosts
+behind the port cannot communicate through the port unless a FDB entry
+representing the host is in the FDB. By default this flag is off.
+
 .BI backup_port " DEVICE"
 - if the port loses carrier all traffic will be redirected to the
 configured backup port
-- 
2.30.2

