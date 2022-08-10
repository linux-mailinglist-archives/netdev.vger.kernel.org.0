Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133D358EFB5
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiHJPwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiHJPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:52:09 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81D765541;
        Wed, 10 Aug 2022 08:51:52 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso1227700wma.2;
        Wed, 10 Aug 2022 08:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KeuLRkJHac7T18EvJz7V2qjxDYwlB1JNeLqOJx59kSU=;
        b=NwaYFZmlXQkYLPFX3ZTPko8HcLgEHLwlrcyFvHq9hm7vQV2IwxrttH0/p8/BnnmZQl
         BTO0b3I01yD4gVwVuca1h/jbv+Cfysmr/pwkJd2AgCZmA4nNJaqDDMtHbPuEcJweTVo2
         579S6P3KHIkfq4qhjgykgSQx3GEN7jkMGKOWCq1fqwahARcWVFoKAElwF2/ur8B6ClIo
         4VUYL64JbAwxyO16ryqLgQ35TM4VOjpGgJE30dWaAoTd8zwN9ejtzD9yLFz3cxaGQo9r
         I+xFxR/ul8X0T8pEmed+ACyAEzgpzPI6KoqWeaF80317jz0w1JJi3GWEirlZLAj1Zjjz
         DcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KeuLRkJHac7T18EvJz7V2qjxDYwlB1JNeLqOJx59kSU=;
        b=RZ8EOPfH4zHrwmQxojqmbzpzfAX88SLw2BiN77K8tAA0hFNufyQsKeQHIt8NHAefZB
         8U9nhdE+zB/lVRky3cASaN+fF2+PYfJOaOCJzEZ7G8MhBHX+vVPC/qrFg4sP5FumvUwQ
         +3tyDHiBfWVlzId+XeUlBtgnEQHXe9xD6aEjIzJcGSJVeGfGrdoltei9wRB7Y0Nnjx/f
         itK+XycLz9yp2tW9DoXq0tk8wQ9CqJWsl8IEVM4EZ+QdS5YG655EhqdQBDiudKV9iBHq
         E0RSRzphbWSCV/Tc9F9pwZH1pYbuBlwN7nYk8flxk5DM/A9cVITM5sxWZ68DUort9mmR
         uzhQ==
X-Gm-Message-State: ACgBeo3hAES7nOXwi4NiBTWzmqN7h7vBETrXLSBrS60UjJI1+OiIK5KV
        /BCIvYY+2SoEZkSviKhmjVobRdZr4i4=
X-Google-Smtp-Source: AA6agR6Ld0dgt8VkL4NPznZl6LE5uIBV6RhDIhjeXAmILYOIjoMjQERHnQMZ5pvfGHOhFOpmDqlmgQ==
X-Received: by 2002:a7b:c852:0:b0:3a5:407a:76df with SMTP id c18-20020a7bc852000000b003a5407a76dfmr2851591wml.101.1660146710481;
        Wed, 10 Aug 2022 08:51:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 10/11] io_uring/notif: mark notifs with UARGFL_CALLER_PINNED
Date:   Wed, 10 Aug 2022 16:49:18 +0100
Message-Id: <19cad183acc3a44b17b76c1719ad30c80aeff1ef.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We always keep references to active notifications and drop them only
when we flush, so they're always pinned during sock_sendmsg() and we can
add UARGFL_CALLER_PINNED.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 5661681b3b44..dd346ea67580 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -66,7 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
 	nd->uarg.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	nd->uarg.flags = 0;
+	nd->uarg.flags = UARGFL_CALLER_PINNED;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&nd->uarg.refcnt, 1);
-- 
2.37.0

