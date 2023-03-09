Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D3A6B2945
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCIQAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjCIQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:00:11 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B44A7A90
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:00:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da10so9000694edb.3
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678377608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nz9g9n4rvXlm/eIylQ+czhCBOb/cVaZzXKEG/gRs+D0=;
        b=JKRFRmuOhAR7+U0aGCKy3HVhCYa8IDPvQeuWOVS00n3/F4qaUNFGuz0fuMwh5ZQzIo
         hzxC/Y3jhGRIzZFfEk3JltCaEtAmEpJx+NqvHpjImGonpm/OVyA2A969fudNlNASOcbl
         UMRyCgK8JnU3YPzfQCKp4Ld/SMCEnGgMqpnFeesdrgvrqNvbVqSBN793DVCcNJ5lmrHE
         4KXzQRDAzzmhWAirkqiVAS9M2vOycq+GFx7P9qvmdesgDW3CZcCzTC0irYI1cySFYZpT
         zwXTiHGbPbFBgiRd6OUVHTuvZp8Q6PpCI4gx1R3+HEDJh/fzhXeuSw0eZlGHisxKRP2o
         fGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nz9g9n4rvXlm/eIylQ+czhCBOb/cVaZzXKEG/gRs+D0=;
        b=yIkKwIa0fm4+91QaZWp6yLWTNgLNQoZ9AT447KHZt5KoAE+NAXPUN6nCMsW2ScuBMT
         ASXEaEBcypWBFhoy91Ifw/QUn5U2cWIuYuoU4RCZ6tH3wVDWEGBMXSkX2bgglfhXe5ve
         eUG2mYmL0yGECxtoVASgeLrQDGPzzRxFL9iOMVxa12Z1IgGiiSZLEc5On8k2l8gEattb
         S3eAGoHmkEmeyqBKe3io7Jlzij0zEDlC5UQYOxdCE+b3tA5hMKFdZFP8KE1QMFx+NctD
         wYSsYqFt5hK2samVjpdxmx5ngGT8hA7z5uCZzrmAlDgKR77OEVMxYGIU5F3iyu9Qcw7y
         UdDw==
X-Gm-Message-State: AO0yUKU+UIV5p7dmUKXeAbBUaDBThrzgTUk0CJaxvE1ztsQW4ZnN9wu6
        b/Gm31FO2BSaLIcxOnwzzjdqRP6MlRF6DwpC
X-Google-Smtp-Source: AK7set8S3p+hx4fkiOg0PiAI3chWHSS5VaQYmyH5f68t/KcGyPPnRRiiliTnKIrDBgAjAxHFuN2txQ==
X-Received: by 2002:aa7:df93:0:b0:4ab:5ce9:9f83 with SMTP id b19-20020aa7df93000000b004ab5ce99f83mr21546202edy.23.1678377608076;
        Thu, 09 Mar 2023 08:00:08 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id a8-20020a17090680c800b008cd1f773754sm8908322ejx.5.2023.03.09.08.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:00:07 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v1] net: socket: suppress unused warning
Date:   Thu,  9 Mar 2023 17:00:01 +0100
Message-Id: <20230309160001.256420-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

suppress unused warnings and fix the error that there is
with the W=1 enabled.

Warning generated

net/socket.c: In function ‘__sys_getsockopt’:
net/socket.c:2300:13: error: variable ‘max_optlen’ set but not used [-Werror=unused-but-set-variable]
 2300 |         int max_optlen;

Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 6bae8ce7059e..20edd4b222ca 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2297,7 +2297,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 {
 	int err, fput_needed;
 	struct socket *sock;
-	int max_optlen;
+	int max_optlen __maybe_unused;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
-- 
2.39.2

