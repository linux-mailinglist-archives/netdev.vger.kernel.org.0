Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C629F5029DE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353340AbiDOMde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353806AbiDOMdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F36329A7;
        Fri, 15 Apr 2022 05:30:47 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k23so15160586ejd.3;
        Fri, 15 Apr 2022 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=bik80RG5BJTj91DXG4BprsO4mTgco6QGIGjMUUl1T6dHSIeviC5xOCFZG/C6Qu1H0o
         w0Wyqs2Jkg/jOvbH5xOVandyeLruRMdekZJKLlTYeZj9IvKfZ4VgGlUM03zWK2uj2yKW
         S7oTi0BiBI7hnkPTSfm2Ov2T4+2baYv+e+Eo1397jsaVCR5jVGXSGWvric8XNDkHm+qz
         2xsaNdKknQV8mDknd2sO1NRdYlgNHbPAKF6m3kIPTUthoFPBKCntItTshu/lAaNGZrp8
         X0tRh9j1wd6I4bAGXyH+CGQrKM/ETEt9Xq8lniL+7bIH88uGUvb2xi1fnTOo9RTqqdZS
         H4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cM7cNDbZdzDRR54XOLUdiPP1jrQ7jBG9dEAYVsbcNLE=;
        b=Xz5n4F9FD8CXjKVJMSpRO/usZoizg64szCphB5cNES54krIl6k7hAfw+x6H2EXhZym
         OJ0af2hDFozHwEe2UcH1GjXz9xypIED6Cf/Z/8lkMwq1haxDaTPYELDsZCNvSkFzFu41
         4geu4eRu83Ts/nhSqLdSy//IWfZxTZqD3ZlhcHELYbFcJIVZjXAQsZQoG6M6VqBse7fQ
         o/X3rfo1lI0r8ECVvCGQd2x5Kiu5IiHjIvLB3cHHez8na8rAr08+fs0dJ2+3NA5lvhSd
         PaH4teXmq12yNvH36f2tvv2XKUUTeEHvOBTuxgf8EI6EPdJz+xwOSywrg2K8SSDG5d00
         JfCw==
X-Gm-Message-State: AOAM5339yin53ls9sW0u6FfiGfAn/ShcCaPPJkgDuIhqyw+Fr/Tpu2Kf
        +pLEjfapH4n+rPoFPFSl4ck=
X-Google-Smtp-Source: ABdhPJyDoVWG26VAB7SBkp1JY1foVvcNpUoGUFZg6AUnrhSJ8MrmB1N6dz6LykMqhp6U5q2nqjcU7Q==
X-Received: by 2002:a17:907:3e0d:b0:6e8:cccd:de80 with SMTP id hp13-20020a1709073e0d00b006e8cccdde80mr6017929ejc.162.1650025846062;
        Fri, 15 Apr 2022 05:30:46 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:45 -0700 (PDT)
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
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v4 01/18] connector: Replace usage of found with dedicated list iterator variable
Date:   Fri, 15 Apr 2022 14:29:30 +0200
Message-Id: <20220415122947.2754662-2-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415122947.2754662-1-jakobkoschel@gmail.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
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

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/connector/cn_queue.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 996f025eb63c..ed77599b0b25 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -92,20 +92,19 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 
 void cn_queue_del_callback(struct cn_queue_dev *dev, const struct cb_id *id)
 {
-	struct cn_callback_entry *cbq, *n;
-	int found = 0;
+	struct cn_callback_entry *cbq = NULL, *iter, *n;
 
 	spin_lock_bh(&dev->queue_lock);
-	list_for_each_entry_safe(cbq, n, &dev->queue_list, callback_entry) {
-		if (cn_cb_equal(&cbq->id.id, id)) {
-			list_del(&cbq->callback_entry);
-			found = 1;
+	list_for_each_entry_safe(iter, n, &dev->queue_list, callback_entry) {
+		if (cn_cb_equal(&iter->id.id, id)) {
+			list_del(&iter->callback_entry);
+			cbq = iter;
 			break;
 		}
 	}
 	spin_unlock_bh(&dev->queue_lock);
 
-	if (found)
+	if (cbq)
 		cn_queue_release_callback(cbq);
 }
 
-- 
2.25.1

