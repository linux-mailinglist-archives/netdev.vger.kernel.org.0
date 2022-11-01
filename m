Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A5B6147D2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 11:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiKAKlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 06:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKAKlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 06:41:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9733618360;
        Tue,  1 Nov 2022 03:41:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so9626623wmq.4;
        Tue, 01 Nov 2022 03:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7Pe2nrgeiyZg8ID37Ige8MwH9qNBIQiYrCcbJSksgFI=;
        b=Y6YrCkEQsgOc7ZDWGKxi3Wkox/e6LYXmnJtkUXGypr79o8IHyXPlONne0anADVbPeG
         5oEMkznQDrPVzR0DQXvWvH54Ov554LfRfqdOELVQhEE0+kxcjulVOxcu7NhkrrdjVWk6
         9LFUZcqxmHZ7Wc7xLHk/3NsiRnCPu5SPE6XNA1/34y9ChsR5cYfDJPtivp1aWpOr48JW
         qRWfCox9pAodZfOtbvu0douBihtk1+a0W0oUZ7XF5YJSCJb2kcHY56wUmcAlPwQdxPZD
         nMjXz8I+DhibL1w+xIb05y8Zz8mvPiJcdLM+trx9f7LkEcuhMoSG6GQZGkQLeT+JO9zE
         3AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Pe2nrgeiyZg8ID37Ige8MwH9qNBIQiYrCcbJSksgFI=;
        b=JFRrebWwsRvMcUVWMNMGLwtMnD4ygJNejgwRRETzOI1amxWXGju8sw3X0MNixNw4ME
         EYLjSxOfKWjF+t6qdf8nlbCrV4HRQPw5Ch2cdzY/7zhrDmSpp2xiZvd7J+PlV76ZLoGg
         kX8QKYRugdLw9aMElGDsAfxlrNpfFMM8df242RZQqQiJyfmc8ncCCYjZ6TUhyNeoSYEK
         9zTwNiINaAm2nTvIaJpX/Zj33Vn9d/g7Cn6FxifTYsD1Ovnx/veQaskbuxj4wkOuhZpl
         4q7YvjgDdvS+YHXZ51ALrwON3GB0pEvR03CcjK0C+dcqstG8UsST5MZFFC5MeJH6v2IX
         GPTQ==
X-Gm-Message-State: ACrzQf2M9Rc9dg40KF9MN0LS3WDCSai4GSe2Sdc9BKHMNvXtghyuD/Ul
        /DZnkqepHO8n/Bnnz7o8xTg=
X-Google-Smtp-Source: AMsMyM7IAKYIwvuvbcyWM+yWofRtGf6bwmSRDO1+LzjepNvIn0/kw2Cu6ZZW2RuMAvkqzd3YvnAc6w==
X-Received: by 2002:a05:600c:1c98:b0:3cf:77cc:5f65 with SMTP id k24-20020a05600c1c9800b003cf77cc5f65mr72335wms.25.1667299266115;
        Tue, 01 Nov 2022 03:41:06 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id o23-20020a05600c511700b003cf54b77bfesm10436628wms.28.2022.11.01.03.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 03:41:05 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rds: remove redundant variable total_payload_len
Date:   Tue,  1 Nov 2022 10:41:04 +0000
Message-Id: <20221101104104.29878-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable total_payload_len is being used to accumulate payload lengths
however it is never read or used afterwards. It is redundant and can
be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/rds/send.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 0c5504068e3c..5e57a1581dc6 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1114,7 +1114,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	struct rds_conn_path *cpath;
 	struct in6_addr daddr;
 	__u32 scope_id = 0;
-	size_t total_payload_len = payload_len, rdma_payload_len = 0;
+	size_t rdma_payload_len = 0;
 	bool zcopy = ((msg->msg_flags & MSG_ZEROCOPY) &&
 		      sock_flag(rds_rs_to_sk(rs), SOCK_ZEROCOPY));
 	int num_sgs = DIV_ROUND_UP(payload_len, PAGE_SIZE);
@@ -1243,7 +1243,6 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	if (ret)
 		goto out;
 
-	total_payload_len += rdma_payload_len;
 	if (max_t(size_t, payload_len, rdma_payload_len) > RDS_MAX_MSG_SIZE) {
 		ret = -EMSGSIZE;
 		goto out;
-- 
2.37.3

