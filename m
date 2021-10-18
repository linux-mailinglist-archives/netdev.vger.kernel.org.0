Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7A432661
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhJRSeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:34:01 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:60740
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhJRSeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:34:00 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DDE423F4A4
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 18:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634581904;
        bh=HFCqmmgGshFFk9Syuf7ZjEDzMD/vEAtb4d+n4IvelGU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=wbA4lAFcAOvtL2j1H50kauWIDO+EDcbk4MNh0bbr8VKoJ3Ryu3RJfWPrtvGKqC7LC
         Nrtks3FnZR/BUhRIBS1khpWmbX/i5CweGpGAZHst6ETOLc0CFPcF7BIf3XOg3EEcKI
         +7rXy/BxleEhUn/huOU6PUTUjLUpfpPzM5rLQA4JqKnKh2+9LawnkmYqGQloGlIpw1
         nffA/RtLLUEzoi6NjL6eb3ZeSfmhMeL0SEw0ASuDM7yts8W5PEaALAaqd2AhgW0hbO
         NlNY3dbxgj13qzVjzUHjyiEXm0JlUp+iu9bO4UA/X2d7iR/RzV6RZcV5rKbUqpwTGU
         qZAgl+0Qjt0ZA==
Received: by mail-pl1-f199.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso6778195plp.12
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HFCqmmgGshFFk9Syuf7ZjEDzMD/vEAtb4d+n4IvelGU=;
        b=qYX5IkM1yJy2c3MkHQPvUSZcCJQ+slGCRV3iYxQAJLfgJ56X1jZOP2rEFwb2r5PrbG
         sshnaXKUBaFmLuugbB+AGROmv9wKp7gD9FZwNxFuExOFQMLQXhUlf7cfLTw4rJS/YjPr
         LuKsM/zIKqG6xec5ADqDi3sP1npLbxJ1NYa5PepES62Xzx7ZYhbVgaiy5PwnmpGl7tks
         acRtn2hgutSuc3WIkTlMa0C0WgxHS6IlBiyIDZOiBZH++1cDVe9QvV8CDZJC0U6SYdHT
         8XqKW1b/bme/OouVBnBTjJ0BV40z0IDo+f0yJf6KxSJ6bdOHUjxHNJQcgFs+EFj+uX+p
         uyRw==
X-Gm-Message-State: AOAM530g+S6DNFBR+8wPd1gvucMQm1wXF1qypnhQK0SZZDaYrJHW0Vfn
        HROdKMloTquDYfYINYoiKsjCOYZMmI7bIONOie2Cc8p+Iz5UYuwE6Zc7wE9vqMw9w+PtpLHmNos
        gxiG0JwZn21/JIAtTW0eaSSzg3ik6NJ+PLA==
X-Received: by 2002:a17:903:3092:b0:13f:663d:f008 with SMTP id u18-20020a170903309200b0013f663df008mr28686682plc.13.1634581903336;
        Mon, 18 Oct 2021 11:31:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeZKqqzL7kOSOOmZKx3zrVqfqotBymsSZ8Z+rtKngOuFribJIyCUFc4W1ckNYy2Q0PUArrJA==
X-Received: by 2002:a17:903:3092:b0:13f:663d:f008 with SMTP id u18-20020a170903309200b0013f663df008mr28686657plc.13.1634581903114;
        Mon, 18 Oct 2021 11:31:43 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id x31sm13807633pfu.40.2021.10.18.11.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:31:42 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     linux-s390@vger.kernel.org
Cc:     tim.gardner@canonical.com, Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][linux-next] net/smc: prevent NULL dereference in smc_find_rdma_v2_device_serv()
Date:   Mon, 18 Oct 2021 12:31:28 -0600
Message-Id: <20211018183128.17743-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains of a possible NULL dereference in smc_find_rdma_v2_device_serv().

1782        smc_v2_ext = smc_get_clc_v2_ext(pclc);
CID 121151 (#1 of 1): Dereference null return value (NULL_RETURNS)
5. dereference: Dereferencing a pointer that might be NULL smc_v2_ext when calling smc_clc_match_eid. [show details]
1783        if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
1784                goto not_found;

Fix this by checking for NULL.

Fixes: e49300a6bf621 ("net/smc: add listen processing for SMC-Rv2")
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-s390@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5e50e007a7da..ff23d5b40793 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1780,7 +1780,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 		goto not_found;
 
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
-	if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
+	if (!smc_v2_ext || !smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
 		goto not_found;
 
 	/* prepare RDMA check */
-- 
2.33.1

