Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A463420E2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhCSPY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhCSPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:27 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26A1C061761
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z136so6490826iof.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmHxdK3XCfKcg/e1EYSJiFRbbaJwpxSQMNrnpC/NWjI=;
        b=NmltFTe+5/KkMVI2XO70QRX8FQHizwSbYiQDlXpP4tyobqToVixLzlCBjfDwZwf/zP
         sNRfo45JdHir9STTgenjNcnTEAncgT+UV97V4Vj/2YDSBxxANaF2GJE0b3aeThKk3s9A
         c0UkXp7S/Q9xRh3U7SxCpKdaFe3htRei+Bpk7VFOrh0yuT/SyJXARdOybD5Vs4ISBqNu
         cIR5QCjTcFUYxTvEg+Sxd4uvtLqcfIjBpIuzD7Z53JwSBHpg8vl5+R/GIkPggYLZwZCV
         i/FC+BWYddgYrJi0mY66JyVrHiOBcps8Y9Fp0JE7cTNWrbYVkPe+M+vr5m37zcOhRy/x
         qXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmHxdK3XCfKcg/e1EYSJiFRbbaJwpxSQMNrnpC/NWjI=;
        b=ShYWGC0IPbG4tEsCmkHO75e8BRDYIc22zlYWLcsfT0Z01vJD0ofSGkS50DTjkUZN18
         jV62y7g/p0Qkbm66X/THXYyM/swT7wlVSzntib6tphB402oEn9QqJms1wC4VZNITz6pl
         rKcjdnUXRW51erFhPRipw2UZc/pmDu1O1QU/kCxLTPyqvMojfpFtKZ/ioyhn4/iffk+P
         RjuSnoR14TvAg+AOeZGt2J3YHa2kM137+e3jGHE0Mx5W6jcMmA+7hye7bNQhrtLdnDX3
         mPWfiedEDuOU80fzf+G+EWR0dcpX4y67PzJrYSwx57jrNN+QjQrw4SHAjqHxO3WmRGBU
         ig9Q==
X-Gm-Message-State: AOAM533mzi+XW3fE6rY27h3tczszQ66uUpG6UaKxbJ119ju8y/5WU2v/
        gwZbnB1vCSvmyZvJ97MD2QqTyA==
X-Google-Smtp-Source: ABdhPJyjn6kP44lXnduHT7xY3b/2Dn9SpIU2Yh0ygWXnXyqVcG2KN9hiBT6klPcqtYN//GGC2MumaA==
X-Received: by 2002:a6b:7c4a:: with SMTP id b10mr3205560ioq.170.1616167466320;
        Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: make all configuration data constant
Date:   Fri, 19 Mar 2021 10:24:18 -0500
Message-Id: <20210319152422.1803714-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
References: <20210319152422.1803714-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of the platform configuration data should be constant, but
that isn't the case for the memory regions, interconnects, and
clocks.  Fix this.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 6 +++---
 drivers/net/ipa/ipa_data-sdm845.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 997b51ceb7d76..01681be402262 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -300,7 +300,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 	},
 };
 
-static struct ipa_mem_data ipa_mem_data = {
+static const struct ipa_mem_data ipa_mem_data = {
 	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
 	.local		= ipa_mem_local_data,
 	.imem_addr	= 0x146a8000,
@@ -310,7 +310,7 @@ static struct ipa_mem_data ipa_mem_data = {
 };
 
 /* Interconnect bandwidths are in 1000 byte/second units */
-static struct ipa_interconnect_data ipa_interconnect_data[] = {
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
 		.peak_bandwidth		= 465000,	/* 465 MBps */
@@ -329,7 +329,7 @@ static struct ipa_interconnect_data ipa_interconnect_data[] = {
 	},
 };
 
-static struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 88c9c3562ab79..401861e3c0aa4 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -320,7 +320,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 	},
 };
 
-static struct ipa_mem_data ipa_mem_data = {
+static const struct ipa_mem_data ipa_mem_data = {
 	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
 	.local		= ipa_mem_local_data,
 	.imem_addr	= 0x146bd000,
@@ -330,7 +330,7 @@ static struct ipa_mem_data ipa_mem_data = {
 };
 
 /* Interconnect bandwidths are in 1000 byte/second units */
-static struct ipa_interconnect_data ipa_interconnect_data[] = {
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
@@ -349,7 +349,7 @@ static struct ipa_interconnect_data ipa_interconnect_data[] = {
 	},
 };
 
-static struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
-- 
2.27.0

