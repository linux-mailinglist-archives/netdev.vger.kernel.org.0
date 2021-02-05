Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695663107E1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhBEJa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhBEJZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 04:25:34 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D61C061797;
        Fri,  5 Feb 2021 01:24:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i63so3933601pfg.7;
        Fri, 05 Feb 2021 01:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qexEQoeH1VSbD2lPxl3p/1QlcpcYLIFQ/7sBV8TdkfY=;
        b=mOhJhH0meN4iXus5taRNl4EEa/TV0a9rUklNoG9lKnCj394FryVY2ue+nOLqRCORsH
         ANR6Qux4ysp2fjLT9wcU+QraHsjrr9vX8I8O9u0BTYYkDObK8QmOVcaxaQF3S7wRnoPn
         n5JBzYGm/ZxqHTwBPpfQKIKdHId1eiMkESyQmNNdlGfNl0hMX7s2LEsCJuI3Q2LBZTP5
         vAk8MZ1+k3iKBIpW/Ur2d8rQheja4JrZydTHOzyhW2JVPEs9S/40l3IQf6ELiI/LF4FF
         ZjMB2+xAy8TrlBe8xE8SnZ1Qlu3hPtcBWYhFBPHM0ujq4IniuGUWrfQk72JwIYcIBNR0
         RgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qexEQoeH1VSbD2lPxl3p/1QlcpcYLIFQ/7sBV8TdkfY=;
        b=S5ocn/D9UNNoooFTq7zsS1qjbTU0G2d5N60fHO0qlQSsPkx0NKI4sWRXfnbBZC5YuH
         HU3IqmEcu2VK7YLq44Eqm5WPtW5EKC4HoD77xmTeg0OzEW9Om3ZqPJnVuU/18k/4LIgI
         WaIeYUQg9YId+xoX1q4HF4RgdP5MfE+g0ey3hvkuHhdFn3LabcqL18qXX1jqoN4YwBfM
         X2xH1IUA4vS/HH7F1+afn4ugA0Y+v/3gCpNh0k9fERkd0Rm5RS/YeJOuvKdpD35GDHMW
         1+NufqGXuN0VyDtgu5lmx8p01BZg2mdIbZFZsk9Lez807xACodNhHC6RIZuhaqIWN9N3
         w7eQ==
X-Gm-Message-State: AOAM532L+cVE02Jy1Uft2bD4KBhegZPhXEsOLWEugE5lOCsroup82KwZ
        77ssIa5bPRS0iF5BwxfDwcY=
X-Google-Smtp-Source: ABdhPJxxfbi6YegTNvDkPD0QsamZIF6xpsZ+DRE/W0qlYkXNz9++Lfz6Q/36hw76w+jvCWo820ZMIQ==
X-Received: by 2002:aa7:94a2:0:b029:1b8:eba7:773e with SMTP id a2-20020aa794a20000b02901b8eba7773emr3734384pfl.51.1612517093664;
        Fri, 05 Feb 2021 01:24:53 -0800 (PST)
Received: from localhost.localdomain ([103.200.106.135])
        by smtp.googlemail.com with ESMTPSA id a6sm7902129pfr.43.2021.02.05.01.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 01:24:53 -0800 (PST)
From:   ameynarkhede02@gmail.com
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, nathan@kernel.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Amey Narkhede <ameynarkhede02@gmail.com>
Subject: [PATCH v2] staging: qlge/qlge_main: Use min_t instead of min
Date:   Fri,  5 Feb 2021 14:54:33 +0530
Message-Id: <20210205092433.4131-1-ameynarkhede02@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amey Narkhede <ameynarkhede02@gmail.com>

Use min_t instead of min function in qlge/qlge_main.c
Fixes following checkpatch.pl warning:
WARNING: min() should probably be min_t(int, MAX_CPUS, num_online_cpus())

Signed-off-by: Amey Narkhede <ameynarkhede02@gmail.com>
---
Changes in v2:
	- Remove superfluous int cast from num_online_cpus

 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 402edaeff..213bd11e7 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3938,7 +3938,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 	int i;
 	struct rx_ring *rx_ring;
 	struct tx_ring *tx_ring;
-	int cpu_cnt = min(MAX_CPUS, (int)num_online_cpus());
+	int cpu_cnt = min_t(int, MAX_CPUS, num_online_cpus());

 	/* In a perfect world we have one RSS ring for each CPU
 	 * and each has it's own vector.  To do that we ask for
--
2.30.0
