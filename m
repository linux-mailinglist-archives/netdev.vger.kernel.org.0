Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64880D09EF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfJIIcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:32:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44898 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIIcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:32:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id z9so1665351wrl.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0L8KhSBedc1ORGEmw25dchbEDXW19aN+b4PJJKXx/f4=;
        b=YbIs+K7OBBIurXIxZG0RTZeOXdX3ptrxeyOWzOE9U5NUUeNSPYcWebw4gVOs9zQK4O
         QIo4WrP4/iIo/TtrrEETaKrk57AM4qH1RzXYYqEJj2SZbwWVPMVLJjmR05/q8pJA0vQX
         Oqgdk89C6ryromuRgk7BhPF0XYj8nZdMV2ec/59DiC3sOz1Gz3ad3IiPLBjoLOt/5PSJ
         jQHfmziNa9AJrQQXfsDAwzX/2YLaCvOOk4x5JShwwwhm/WuZZbQOGEJGrjn57Oak8HPH
         EqogNcFbO/A7dqUH9pw5u1SazaeeXzkN46uCj5VIh1QJW414GtGJ/GFnqb/3/AuHMBhx
         e+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0L8KhSBedc1ORGEmw25dchbEDXW19aN+b4PJJKXx/f4=;
        b=diIuzI3R7UknS0BUYm1k0BaCqnskAck4RogWAaL2WpDWANkKEqgL3gYcDLX8zyIdfz
         siN9P3QEe4bU8s6LLF+iFr2/AzD7lg+7E+jU6tmjkMjD2tHtVdti2x6fKjDO4M/BsNdD
         WGFYUCQnekhggV+7GLO7ESEM8rUD2Ijmc1KRJPU61p39vAr6jVGJcJL1XNbWND/LFaNf
         ETiXG/3rwWF53nrbjz8i40q/Dl4gLiruO6htNO9UoHd1ic17LRbQwYDdUUtxxp+pGBzE
         BPJBhq02lZ5DpTIrymvam2tTxcPVZa3HW/rfaw936l3CPtC8ZmH+UL4C0y3abnbFfDhN
         iicA==
X-Gm-Message-State: APjAAAW1HCKN8eBojKrSavGqLWSfsjBOdb2ZWmbATC7k7w/WSvbPZLpX
        ykYTFikgmX0kgoVTjfrJZKVB0CH0nwA=
X-Google-Smtp-Source: APXvYqxcie65q1JTwjXjYlp+UVUW84oz1UGhReR+N1vkK+z/VD7DCodzrLyhSHd5Ftt0YraCiNNycg==
X-Received: by 2002:a5d:4ac6:: with SMTP id y6mr1753323wrs.173.1570609953509;
        Wed, 09 Oct 2019 01:32:33 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id c9sm1332795wrt.7.2019.10.09.01.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 01:32:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, ayal@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2c] devlink: fix json binary printout of arrays
Date:   Wed,  9 Oct 2019 10:32:32 +0200
Message-Id: <20191009083232.21147-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The binary is printed out into json as an array of byte values.
Add missing (removed) start and end array json calls.

Fixes: f359942a25d3 ("devlink: Remove enclosing array brackets binary print with json format")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 51aba6e200cd..8fc1f3b8b35a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1930,6 +1930,8 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 {
 	int i = 0;
 
+	if (dl->json_output)
+		jsonw_start_array(dl->jw);
 	while (i < len) {
 		if (dl->json_output)
 			jsonw_printf(dl->jw, "%d", data[i]);
@@ -1941,6 +1943,8 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 	}
 	if (!dl->json_output && !is_binary_eol(i))
 		__pr_out_newline();
+	if (dl->json_output)
+		jsonw_end_array(dl->jw);
 }
 
 static void pr_out_str_value(struct dl *dl, const char *value)
-- 
2.21.0

