Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F376074EA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiJUKTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiJUKSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:18:48 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DB725DAF3;
        Fri, 21 Oct 2022 03:18:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id iv17so1856596wmb.4;
        Fri, 21 Oct 2022 03:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/A4q3HXrE5Zm8Jfq7QBtdlkzWJNy1pjXWdj/kLDVls=;
        b=cj9sSxFCdimjWtRyw8D7kG8AtHwWzcLT8BPA2YG8stWB07xQNMhvGRel/9RWcCEdFh
         eTG/Pr8blMWgpBHWHEZU6hbtUk3GlIsr1rt/20NOu6uCorb+/IUnUfUSYpron6dz4EUv
         yG3agISXBKHqsa2BpflAscVh6QSFLUuuUs6Yok5wlLPG0nEcEezzzYdhj9XAGWHhkU+Z
         4JE/A9x5sbIh0KzAOdS3SOkVwaOQWGN5CPMAxzmttBjX26zXan+5EZYIdFIAmHllSKJq
         hvVyqyga/a7DnLZfG6R4uVOcnT/q53vRGdNVdHHEHUboMpxT8r9uJNTvjjJ9G8UHONdf
         dJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/A4q3HXrE5Zm8Jfq7QBtdlkzWJNy1pjXWdj/kLDVls=;
        b=5/gufWgQR9EfUnHO/urSbxLbiBGFc6Q1eDHwsU0M1NIFlS8UCTJIJVpBAIAc0crZi7
         hzqMRFNQM+ORxvSYo4ghBkHTHWj+x+ao9D0/5efjp1ibzmgnzbPqnkb/yabYIVjUOHVT
         lLS3AH1nxlzpKu86YfUlxSp5ErHlghsb4+oEo8Edq/r0CrXZB3Dq/OcuiFlYZk/tU80R
         eufX+q1O6oXKYy6Sb3NrTsJHZMqMtFXIAuYcfN/5ZG318D8cof9v6Qwi44N+M8LpMevK
         sveTXrV4sxiQt/7JWh/ErcHSXMGYP1ZXrm4V32XbEugnghVkc9SOxcHN8mvmZPiXT+7k
         VQdg==
X-Gm-Message-State: ACrzQf2QBjonEihBG+nL/lxPpa/CpqO8tgSldXJO6PgyYrJoXrPXS6M3
        t+P2R9hcjxhEW1NKbTtLz1uNFrPLAso=
X-Google-Smtp-Source: AMsMyM48tf2dQfO7hQr6iPZ99mqU9YYyg/Mbx68rSS7aHJKyLp80qNh4oX/6gYCXq+MQsP10VVyZ0w==
X-Received: by 2002:a7b:c841:0:b0:3c6:ce2f:3438 with SMTP id c1-20020a7bc841000000b003c6ce2f3438mr12551544wml.51.1666347520315;
        Fri, 21 Oct 2022 03:18:40 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id ba3-20020a0560001c0300b002365254ea42sm1565184wrb.1.2022.10.21.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:18:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 3/3] io_uring/net: fail zc sendmsg when unsupported by socket
Date:   Fri, 21 Oct 2022 11:16:41 +0100
Message-Id: <0854e7bb4c3d810a48ec8b5853e2f61af36a0467.1666346426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666346426.git.asml.silence@gmail.com>
References: <cover.1666346426.git.asml.silence@gmail.com>
MIME-Version: 1.0
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

The previous patch fails zerocopy send requests for protocols that don't
support it, do the same for zerocopy sendmsg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 26ff3675214d..15dea91625e2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1153,6 +1153,8 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		return -EOPNOTSUPP;
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-- 
2.38.0

