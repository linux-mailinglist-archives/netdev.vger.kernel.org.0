Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2814FDEE4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiDLME6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351801AbiDLMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:43 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA9353E01;
        Tue, 12 Apr 2022 03:59:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z99so13258040ede.5;
        Tue, 12 Apr 2022 03:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gQ6t5VVe/uNOUtGlR6al3lXmeQqaLcWf63crRRXcTk=;
        b=k5d4BJQUWbrYgrpJj8fdrxKNd0SI1t4byvzs/kLRovHkFvzheN5XoaJeUSmHWy1z5+
         G5Fpiiu7ef/yCnHOJCUGJ93cYOMzvJZCfQcdNPi2YUOXnEzwFzLdtHS0aPhTyP+HiK0p
         LcCWd8b64+3PZ9IObEW24vfr+j+6g4i3Mg5tyJAbWPKYFLQ0dgfDkcX5nYmdcL1jK8By
         fmb57i3fnbHVMC5wHmqvjwCJQQKg1xDyFVmdP4ZGibnbuCaQdiTxPNIBt7ezZ/pRk7K7
         UcXXoKdJ8izMDX11hccsEj1VbMT8BwF3B+E7x9H2s+/iFGjafwGZcTND1RR9vqNiPJw9
         gwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gQ6t5VVe/uNOUtGlR6al3lXmeQqaLcWf63crRRXcTk=;
        b=Dvh6HuhJtcf5tJE/3z2zFRf6o9Jaxf3VfhrDVo8XLgBHuMU6w/z47iPdB7YOX/XGJ6
         ebkV1ZJDPBaAiw7QwF3Rq9SjUQMibJoQomQB85jJgOATJcLoCnqCcXIyC9cZ01G3ceo3
         rU6yB9/LFxtU4H+c9wN/FvjqSdqmO/RPEXkG9BMg+ZgiUgJVmzLoHvIYhFzIE7Rs20kk
         5lf7P6f/NpVHXdIhZmBRXA+TIwE28uxGK6yJNsLWAuKwAG93ddtPmSIOh3GLZZZlrOQE
         krFtVBRLhqXB2jJEs5pt5rfP/pFAenB2cdo9e68YG37VT3QZTQOaTsunCyjsAPLBJ+b6
         LPEQ==
X-Gm-Message-State: AOAM532tVFW6T4nh6vmgBuNqM+zKe1bRFnnF4fmVag9PYWj/WDiJot6j
        1lO42LZcVuOsDFc+tQW7R7E=
X-Google-Smtp-Source: ABdhPJz//QqFUOZQmqJ6nLmpzZRJxNW+5wj6QSPtLJAJrD0qf6F3toSCEta4MTg4CC0fCCaAdc6EzQ==
X-Received: by 2002:aa7:d39a:0:b0:41d:828d:c75 with SMTP id x26-20020aa7d39a000000b0041d828d0c75mr7570738edq.27.1649761150095;
        Tue, 12 Apr 2022 03:59:10 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:09 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v2 14/18] sfc: Remove usage of list iterator for list_add() after the loop body
Date:   Tue, 12 Apr 2022 12:58:26 +0200
Message-Id: <20220412105830.3495846-15-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer pointing to the location
where the element should be inserted [1].

Before, the code implicitly used the head when no element was found
when using &new->list. The new 'pos' variable is set to the list head
by default and overwritten if the list exits early, marking the
insertion point for list_add().

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/sfc/rx_common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 1b22c7be0088..80894a35ea79 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -555,7 +555,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
  */
 struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 {
-	struct list_head *head = &efx->rss_context.list;
+	struct list_head *head = *pos = &efx->rss_context.list;
 	struct efx_rss_context *ctx, *new;
 	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
 
@@ -563,8 +563,10 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 
 	/* Search for first gap in the numbering */
 	list_for_each_entry(ctx, head, list) {
-		if (ctx->user_id != id)
+		if (ctx->user_id != id) {
+			pos = &ctx->list;
 			break;
+		}
 		id++;
 		/* Check for wrap.  If this happens, we have nearly 2^32
 		 * allocated RSS contexts, which seems unlikely.
@@ -582,7 +584,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 
 	/* Insert the new entry into the gap */
 	new->user_id = id;
-	list_add_tail(&new->list, &ctx->list);
+	list_add_tail(&new->list, pos);
 	return new;
 }
 
-- 
2.25.1

