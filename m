Return-Path: <netdev+bounces-5116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EC870FAEB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F0741C20D3A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FE819BDB;
	Wed, 24 May 2023 15:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610A19BCD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:55:53 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A05D10C0;
	Wed, 24 May 2023 08:55:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-510db954476so2071759a12.0;
        Wed, 24 May 2023 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684943723; x=1687535723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7LdBgIV1bh1fo6FylCea76KdRL0HYKexuUROPDAB0uo=;
        b=f3Xa6wDSMCovecd4rnzIqeLgzE1iG4hEYndY3nIpg/ykend7PCIRZAkGVel3pXhJ6W
         KapejeG9gsaOUKXU+1Oc5reaXwu6WteJC+bU6lCAVURmalCpVvqFv1qC7jJFMqm9H1D+
         3PqZ4ZOrV/lwr5aMRxf9APWfHppiZy2T9emXkkrHp6RWnwlKGAk69cnyn2yJuzgqYLmo
         7n+BGLf72ikHb/+2cEL4dJtKpV+XmlnguLor2Wf35U2eXjlRXrKf4iMYDzUzxJ+xfJmM
         r49j7TXg3ry8gmwWQE9C/3P3L6Wvs3rSUQzIwfweRnnsNy9cNCzlem1a78jYboD7Qnba
         lcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943723; x=1687535723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LdBgIV1bh1fo6FylCea76KdRL0HYKexuUROPDAB0uo=;
        b=Xao1b8aUr//ignOHbXNqLCnK3/PaMnLU86yTqJOC9lkKpEZbTNRu3E1sQVHwbN8fKJ
         OmvKLkCrmpZEkG95cvVvFpOezvGqKsPGise1Kj9sk20qnWSgndh05BRuhOxe1Sh8Y5yl
         kH4bfjLrbK0Go0cLnpo3cjr9QUdezFIoxx2eFNYoWQV6pYGmX/P4gMI0wDlN8uJrMkrM
         vJfmMQpsO8qMNqo0f4elXX+y4MOqC/TTEN0xoiNKmO9HhHlrz6hef1+izG8XX+cVFsnV
         shUAWnugrGInXpxgYzVg0sWhH+CUQaSpNKdygsxskQoegAuKTfoEU5GXqMsqKzT1Gv61
         ijFw==
X-Gm-Message-State: AC+VfDwhYd+B+OlV976zNcIocZS5hslc8CbfVXFDWDuBv0KMS5NjTLjF
	Iju91Wzzf9K2JBbPPyhBhMZ6vsEXlB4=
X-Google-Smtp-Source: ACHHUZ7QzSiLyiTE3Jk3CaWxCPl+G3k3sptkmI/qzlz9NNrLdx5IOcqZPDnEXNF90D7tWh8czglxiA==
X-Received: by 2002:aa7:dcc5:0:b0:50c:451b:d0f0 with SMTP id w5-20020aa7dcc5000000b0050c451bd0f0mr2078368edu.37.1684943722242;
        Wed, 24 May 2023 08:55:22 -0700 (PDT)
Received: from Osmten.. ([103.84.150.66])
        by smtp.gmail.com with ESMTPSA id f4-20020a056402150400b00510d8e43fe0sm68847edw.7.2023.05.24.08.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:55:21 -0700 (PDT)
From: Osama Muhammad <osmtendev@gmail.com>
To: krzysztof.kozlowski@linaro.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Osama Muhammad <osmtendev@gmail.com>
Subject: [PATCH] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Wed, 24 May 2023 20:55:06 +0500
Message-Id: <20230524155506.19353-1-osmtendev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch fixes the error checking in nfcsim.c in
debugfs_create_dir. The correct way to check if an error occurred
is using 'IS_ERR' inline function.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
---
 drivers/nfc/nfcsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 44eeb17ae48d..3b377704e2b5 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -337,7 +337,7 @@ static void nfcsim_debugfs_init(void)
 {
 	nfcsim_debugfs_root = debugfs_create_dir("nfcsim", NULL);
 
-	if (!nfcsim_debugfs_root)
+	if (IS_ERR(nfcsim_debugfs_root))
 		pr_err("Could not create debugfs entry\n");
 
 }
-- 
2.34.1


