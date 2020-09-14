Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A9326958A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgINTTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 15:19:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550C7C06174A;
        Mon, 14 Sep 2020 12:19:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g4so825177wrs.5;
        Mon, 14 Sep 2020 12:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKGbni03/+MWZC7/hBbqoYRev2UK6B57mdiozLjRsiw=;
        b=JddnqwPRNNm9iAwoqKQZhgHV8tcQlhLzE02xSECcpQH5QPON1+zWAWI9Z3pfkt1XeQ
         YDdJ1Del1AQiqE73MLIMDwUiRe57kW/BDvSai11W6pGcboPKx5srCq5ToMCIKw7k+gqw
         48hoCO9h7PYCj4iFyvWBiGrtnNKcrj7udO4R7uXH7raueaW+BpveF0YdPxsi7QcFjX12
         4Ydct7OA1u5dRqE86Xh/pyTPsYWVJkWGiA+8xJN70phctgb05VT+TJI4p1v8bRv7FlHU
         F0o3EjEWUSZdC1TcSNfcgFLN798xjQ7GmmO+vdtU++p/h0yCTlQbjm25MD6fJLZkKxl4
         zjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKGbni03/+MWZC7/hBbqoYRev2UK6B57mdiozLjRsiw=;
        b=HWFyIUwu16jie2aICAdBib/8Clt56M1D4oAeDAAS/VRZn3skZ7WyxxJ7Xobm/VKEQU
         jN0mPP0F1MRF3REthgaBT5kxRwQDQ5IGifd9oP0ODFsI0AlQsm1Zcztjiy4Mwt++tgLI
         5PF74DTEWiAyUHDnfe0/dZd49gT0vUdWMFdbKvf1+GuHoKZgdp6iPaJWn85egDHRPzg8
         cE14WX4IneQPLSMH2aYKUJELzLLetLf+G6vr89kwHx5P4QkuDFHZFR0W10vDelcFJKb+
         7A5V1fCiVJeQUODjrcICcvbtqni8Pl+8Nv3A1ytIj1/U/ZAAO4+8wJiU8MhpVMI7Vgky
         9Gag==
X-Gm-Message-State: AOAM531eiHm3iLpKvZXBSRSmXgFGm/rYyLgdhOpe43owiSH4OMQ48KJR
        4WGkBGQKojCrkLz1Y5DvenibEXPmlQhgY3wO
X-Google-Smtp-Source: ABdhPJxUBzpUmmWU1XYCCWUW3ZryO7slOwvnjI69CGQm6+CraXFBeI+iKS4Gc4+bvmyKI/z1D2DDlw==
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr4266876wrt.162.1600111169912;
        Mon, 14 Sep 2020 12:19:29 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id n21sm20891266wmi.21.2020.09.14.12.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 12:19:29 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: sdio: remove reduntant check in for loop
Date:   Mon, 14 Sep 2020 20:19:24 +0100
Message-Id: <20200914191925.24192-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The for loop checks whether cur_section is NULL on every iteration, but
we know it can never be NULL as there is another check towards the
bottom of the loop body. Remove this unnecessary check.

Also change i to start at 1, so that we don't need an extra +1 when we
use it.

Addresses-Coverity: 1496984 ("Null pointer dereferences)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 81ddaafb6721..f31ab2ec2c48 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2308,7 +2308,7 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
 
 	count = 0;
 
-	for (i = 0; cur_section; i++) {
+	for (i = 1; ; i++) {
 		section_size = cur_section->end - cur_section->start;
 
 		if (section_size <= 0) {
@@ -2318,7 +2318,7 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
 			break;
 		}
 
-		if ((i + 1) == mem_region->section_table.size) {
+		if (i == mem_region->section_table.size) {
 			/* last section */
 			next_section = NULL;
 			skip_size = 0;
-- 
2.28.0

