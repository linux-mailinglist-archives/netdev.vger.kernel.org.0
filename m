Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C44FE107
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353770AbiDLMuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355275AbiDLMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5067D4D;
        Tue, 12 Apr 2022 05:16:28 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l7so31496545ejn.2;
        Tue, 12 Apr 2022 05:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PxsivQPQxoWJpzdCzth3DXDecoJwiEJJ2qSzCxa8YbM=;
        b=lWOmxFnPNwbm8PLBwdGYB1wolXb20JkNG0Q9pmhmmpJXoyEiLdbikuZifyIR8QCi4U
         +qB+LtEDYjxmQm1ifVf51eNsGKXi2+3HOgUTtQgHjmNO2k9CJa4JCEKAz7UhweV+p2Nh
         2GRyY0LdytDmgW+0bDSA3FBVyc7TNpZzDS52UpyzdK9JVPmEWoEkmSCk9kpp/KXwFqJJ
         Ulwjm0QuNrOqoygRv2YyUwtQ7/c0tIl3XMGfR+VV698YR69zb98JZwbzoDIgzWC/DZuX
         IJEd8OeqWKXt8DxPaUHVcowJTXIZXcAwu2q2xrftFeG+Cf+KebJF7io/jVKXsw0VgnQW
         i0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PxsivQPQxoWJpzdCzth3DXDecoJwiEJJ2qSzCxa8YbM=;
        b=cdkpHcORFRBl65b1G/wQey+3JQSZXNTNfVmkpAilZSmal7rdr6B29m20y42JqvWsKO
         B9hLjMEr9nAqhdMsLNxhqTFJJsV5vxCWB0l2wStzeEa9fGY4///DmMiTJawbV4mJZbER
         CQAvL9Ryu5Q6KGpXC9qW74h9aKubxv9HvfA2zygzwLFbUR30z6AwLYIl/eU2RfEL9cuz
         VKuyihrRfRMU68U/D4z2DWigF1V2Fj3ZR0fL/GAWxGLtm6gF8a/deLZOY7gEC9woIm4l
         w/zGSNNvnBWqXHTpZtZeD0JxIPY2ekLnCf6Y6Vrfn0QpWYznvYuj84KMOJSEezlMRyhJ
         QsFQ==
X-Gm-Message-State: AOAM5327OCdwNI557xrWfj7qrBRguxiTOyGRPsfu8ODFpJ5mK7Siw8TP
        L6VjZ4dNXhVmKSvWa9uhfw0=
X-Google-Smtp-Source: ABdhPJxAdCFtUSX3ENrld4C1yXNOR/WQGNKAc/WgL1/eO9a/L10FloY6hbye5LONG2PmrbSXS9K7/A==
X-Received: by 2002:a17:906:d552:b0:6e8:4ee4:748 with SMTP id cr18-20020a170906d55200b006e84ee40748mr19352388ejc.58.1649765787342;
        Tue, 12 Apr 2022 05:16:27 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:26 -0700 (PDT)
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
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v3 04/18] net: dsa: sja1105: use list_add_tail(pos) instead of list_add(pos->prev)
Date:   Tue, 12 Apr 2022 14:15:43 +0200
Message-Id: <20220412121557.3553555-5-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412121557.3553555-1-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When passed a non-head list element, list_add_tail() actually adds the
new element to its left, which is what we want. Despite the slightly
confusing name, use the dedicated function which does the same thing as
the open-coded list_add(pos->prev).

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index e5ea8eb9ec4e..7fe9b18f1cbd 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -49,7 +49,7 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 	e->rule = rule;
 	e->gate_state = gate_state;
 	e->interval = entry_time;
-	list_add(&e->list, pos->prev);
+	list_add_tail(&e->list, pos);
 
 	gating_cfg->num_entries++;
 
-- 
2.25.1

