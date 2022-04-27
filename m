Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B366511FF5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbiD0QM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242296AbiD0QME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA353E6E6D;
        Wed, 27 Apr 2022 09:08:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k23so4384556ejd.3;
        Wed, 27 Apr 2022 09:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+mtTmsePMUlrvbA5Gxvy5O64p/39QZZ8B6LTk09adM=;
        b=Hkxy0IEKCInDQhIHwWszLgmHYH27wUiu5nhfHuSds0ny6zxcsjzJuFYvcasAraAcXK
         XharPWt16KsV4QDb7JrdvuM+8RmU4T647/y4Q7CWjLDD3mAEnFszewgn03OsKGZqTGdZ
         dtOQrwcZI0OESJSOMYKI2hNrmU3D7pbiUhKIbTR4NH+J1DfH4RABBaFqwCQIYrJsN1if
         YK4UXm1CsKw+Ez+Pa7EFZlXghqP7Pn9WA+VKpmdLvuXvhIgkfSips9y75xTHfdoIGsty
         RcwT9fu+KvxsSkFr+hi488HDN0jqDbibcol5pUUb1ymbFcQ9cJxycGmwzR0BEKkWZSDO
         uidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+mtTmsePMUlrvbA5Gxvy5O64p/39QZZ8B6LTk09adM=;
        b=FOFaOHd/04qf4zFAYXgGEsRCfTFhvCnlD2kh1bVY6AQcpAVI6sATJae5YuAIv2SOqp
         tQaEsi66rPqqVTal4lu61C3rOEls1+TkS1PCyvuYkBXqHKSpIDM7FQXwgaF8pc2PqMHR
         KA7oHUL0WnisQG8AJ6vJsgL24gAn02SnE0RsknPbEdZ3w9A4XiLydT0MG5pEd1idthHj
         NJk6A6u+1/qnqe3nYnNXxL2CA5Mac7MQqVCLkgJ/qyvsog6k/QAm3URDOpHhpvPVhzgc
         8e1gEj/yfw6fWprmcFqPhsQ4iA/d8oKGcJV32j9B+sHqMte/fg5NmXDFi0wI0BVJVBjy
         4trQ==
X-Gm-Message-State: AOAM533bgpMqGdOlsCCxCzetPINt8/YtAFvvj9WwwYEdnm8EeTTIZLdN
        K+aZCuNSH3+APOD+8PzH/Vw=
X-Google-Smtp-Source: ABdhPJzxa9+NcJtLVPAcuSDhYJGek9dFCba/k1LpR14Atj5Kkk4JNNCxTqiszf04IOdTXlAqnpMKBQ==
X-Received: by 2002:a17:907:3e92:b0:6f3:8ff4:66b2 with SMTP id hs18-20020a1709073e9200b006f38ff466b2mr16219496ejc.697.1651075653001;
        Wed, 27 Apr 2022 09:07:33 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:32 -0700 (PDT)
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
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v5 14/18] sfc: Remove usage of list iterator for list_add() after the loop body
Date:   Wed, 27 Apr 2022 18:06:31 +0200
Message-Id: <20220427160635.420492-15-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427160635.420492-1-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
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
 drivers/net/ethernet/sfc/rx_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index fa8b9aacca11..74c056210e0b 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -560,14 +560,17 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 {
 	struct list_head *head = &efx->rss_context.list;
 	struct efx_rss_context *ctx, *new;
+	struct list_head *pos = head;
 	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
 
 	WARN_ON(!mutex_is_locked(&efx->rss_lock));
 
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
@@ -585,7 +588,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 
 	/* Insert the new entry into the gap */
 	new->user_id = id;
-	list_add_tail(&new->list, &ctx->list);
+	list_add_tail(&new->list, pos);
 	return new;
 }
 
-- 
2.25.1

