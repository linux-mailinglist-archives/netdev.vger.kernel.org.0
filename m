Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E75D3CEDCE
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353034AbhGSTrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387027AbhGSTpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 15:45:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491EDC0613E8
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 13:19:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id u7so21436683ion.3
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 13:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MTo4LBHxr6WcVmPmqqb31U3oy5mXIOOOFkovyYtikHI=;
        b=Z20dqVx+5d90dMhiE/vjpGdOXMC1EvHJXuai9onFKR9y5dKdqhCv2b2/gxpC1QdMad
         G87t0rQXarGllXKi43YQNITaKnuiD6mzmMXvEwAi4lLmNZbP4kDEMlCZfuC2Ksu2KjLQ
         qb2w1OqHx7hVwVQ6TlnoMKc/sjz5VX6som42BeYp7BNsMsjC/8DEztAzR/swltXWUHr7
         wuJAnNjJoxvQrGO97pZeLKNN4MIUTYzmO6ARnfp79nvbOMOzm+1QP8uAWfj22/6SywJO
         nsCjvdla2p1FHxAPP+VM0dS2Z5zZBtjqQjqPJ/Uiq9cWnZw+xtWr9WleMzIgSPBggp7M
         kjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MTo4LBHxr6WcVmPmqqb31U3oy5mXIOOOFkovyYtikHI=;
        b=lklTmSdTM9FYDeA74rTAOqMQKsNgIMzVJGGQJIUk92daLzMftwjpbm4m05qm/TbPE9
         ooXwo+l9/rrANcpVS0QoBQCekRSCmbS2y7/j2yqhb13FPHNSv6A7Nl3F/XQWAZodjaRc
         ClUdcWSJxg6RMzCAxHI0C5jmy7ZGJUKhkLHPDTPHZ8/XG2R1GtRuteRpQaAVFDWnTVD8
         aHgwKv+19aWW387iT2mAPyivUFDewamunY/t0YCuV6b/t5JOZEf9mCqIcT7AqZSfqHiO
         RrWHAr42bnbKrVwB8Dx63c4hr2OeL3N8AVngZ+XfdrZRRle8dka9NtE+Cd7C6vcPCdmK
         L9EQ==
X-Gm-Message-State: AOAM530FQJaaDOpBaHGoPOpDOyecHULG8/Fwfi0a6cRzn5v8Nrg5ShVw
        feZdHSyhM8IvNi3MsFgRFmP87w==
X-Google-Smtp-Source: ABdhPJyE7UgDop/g8zbvqQ4eMEP3B+0g67LVNr62XYPmnF9zFUkmiXlumKMdcyXKMiYYGHC9EjBRYg==
X-Received: by 2002:a6b:e90b:: with SMTP id u11mr12746940iof.134.1626726220561;
        Mon, 19 Jul 2021 13:23:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m184sm11123652ioa.17.2021.07.19.13.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 13:23:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: fix IPA v4.11 interconnect data
Date:   Mon, 19 Jul 2021 15:23:33 -0500
Message-Id: <20210719202333.3067361-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently three interconnects are defined for the Qualcomm SC7280
SoC, but this was based on a misunderstanding.  There should only be
two interconnects defined:  one between the IPA and system memory;
and another between the AP and IPA config space.  The bandwidths
defined for the memory and config interconnects do not match what I
understand to be proper values, so update these.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v4.11.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 9353efbd504fb..598b410cd7ab4 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -368,18 +368,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
-		.peak_bandwidth		= 465000,	/* 465 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps */
-	},
-	/* Average rate is unused for the next two interconnects */
-	{
-		.name			= "imem",
-		.peak_bandwidth		= 68570,	/* 68.57 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps (unused?) */
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
+	/* Average rate is unused for the next interconnect */
 	{
 		.name			= "config",
-		.peak_bandwidth		= 30000,	/* 30 MBps */
+		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
 };
-- 
2.27.0

