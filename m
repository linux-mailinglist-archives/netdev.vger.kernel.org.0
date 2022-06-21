Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B35552C58
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347238AbiFUHtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347590AbiFUHth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:49:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFDD2409B
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y6so11832008plg.0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4y5Zh8jm0qtwXpPHEKBpl4vEtjbGQBLkZQmwRYcXp0=;
        b=MVVbbfPp9HnNa3Ly5aCn3oprwMdyuHhh5aEhr7TCKqqpXJ6dOhiDznyoryWAKD6m7V
         DFJ/oCy8ErhlP2rGPS5F1ZSEl+mSpLiFy4ylMNdsUpe+N2fku2sdxDVVG8sG8aNR4E3V
         sd0FENb8uHep+MRrDnOUo8Hg9zC7SJvkiW0v//Ber6eRLDAxG+C5P7MSTOMsFwkpbTQl
         OlkdAh6hHeD5jhOR/Vv1xXC52v3DxDAWtqk5xTMXllFS5HklmmAkbasjcnGFt4LqaSJW
         vAbyzhY4wgg/3tj8Dell/7njH/pgfBRilRjxi/8tfVbR53PQ5D3A/xCoCrPl3sXMes4H
         1lVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4y5Zh8jm0qtwXpPHEKBpl4vEtjbGQBLkZQmwRYcXp0=;
        b=UBn6SM2lRdpyd3OZH0SzHHrlLkoim/4l5Re5qYVaokE7oNtYqL9y6N13DdBpAazBrL
         E+J5V/grIiCfq0vnqEWF75z5iiXGl98PcxsmZLzKkyamgH64wggXfovkdefDIUAkfRqR
         dbQND6n9vt4CsL+RqPLgEEYU/xcKwgyeNvfXUYvJHwmwgJ5Q4ASiybMx3djzdKRURxzW
         Biwpr2FmiDmKcQM/+f4+XWGU8AzRz7nKhR/EjZ/mwK1Zve3pj+g/ylMwxrJQN5OaIRXG
         cFoY9o0tfSzT7cTh3jkc5nltvHxxBa3bJbvZgXN07MWu9ZYmfsm6eUYLbSErdEGPQUYC
         GS5w==
X-Gm-Message-State: AJIora/eqFOkphkVVoz84RQA0QEXKyMTDAGicBnG6Z6ftXSdqViu2mqV
        NGv0O6u68c2wjzjy68GkeCoCZptNiOY=
X-Google-Smtp-Source: AGRyM1sc8qgz49arJS3mZcDDAGf8e9a9Sn5OiD9SAazX/2nHOuZB4wkn8PLoQ0NGB4a5go3l7DG/cg==
X-Received: by 2002:a17:903:2308:b0:167:62ae:28fc with SMTP id d8-20020a170903230800b0016762ae28fcmr27393415plh.100.1655797775413;
        Tue, 21 Jun 2022 00:49:35 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mm5-20020a17090b358500b001ecd3034b66sm8119pjb.54.2022.06.21.00.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 00:49:34 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next 1/2] bonding: add slave_dev field for bond_opt_value
Date:   Tue, 21 Jun 2022 15:49:18 +0800
Message-Id: <20220621074919.2636622-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621074919.2636622-1-liuhangbin@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
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

Currently, bond_opt_value are mostly used for bonding option settings. If
we want to set a value for slave, we need to re-alloc a string to store
both slave name and vlaue, like bond_option_queue_id_set() does, which
is complex and dumb.

As Jon suggested, let's add a union field slave_dev for bond_opt_value,
which will be benefit for future slave option setting. In function
__bond_opt_init(), we will always check the extra field and set it
if it's not NULL.

Suggested-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/bond_options.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 1618b76f4903..eade8236a4df 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -83,7 +83,10 @@ struct bond_opt_value {
 	char *string;
 	u64 value;
 	u32 flags;
-	char extra[BOND_OPT_EXTRA_MAXLEN];
+	union {
+		char extra[BOND_OPT_EXTRA_MAXLEN];
+		struct net_device *slave_dev;
+	};
 };
 
 struct bonding;
@@ -133,13 +136,16 @@ static inline void __bond_opt_init(struct bond_opt_value *optval,
 		optval->value = value;
 	else if (string)
 		optval->string = string;
-	else if (extra_len <= BOND_OPT_EXTRA_MAXLEN)
+
+	if (extra && extra_len <= BOND_OPT_EXTRA_MAXLEN)
 		memcpy(optval->extra, extra, extra_len);
 }
 #define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL, 0)
 #define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL, 0)
 #define bond_opt_initextra(optval, extra, extra_len) \
 	__bond_opt_init(optval, NULL, ULLONG_MAX, extra, extra_len)
+#define bond_opt_slave_initval(optval, slave_dev, value) \
+	__bond_opt_init(optval, NULL, value, slave_dev, sizeof(struct net_device *))
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.35.1

