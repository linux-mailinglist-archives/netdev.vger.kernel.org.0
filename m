Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054494FDF0D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348304AbiDLMF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351367AbiDLMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6FC76E06;
        Tue, 12 Apr 2022 03:58:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l7so31104712ejn.2;
        Tue, 12 Apr 2022 03:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gxZv9czNrqSsp+NwDMxwad6YKQOb4DD102M9ETWSEU=;
        b=ITHb5Z6Ro2j7h9KvVs8LnHP+X9FORr367PPN32rttpJ+hrNMecB/3XZ4h+su6UDu5Q
         UHw8l+Pjwclo5Ysc5IzDvHR9VYp8P7ICq84aWXUN5djTntioSeCBzqLrmWEVOmxMzo/i
         lTo2zLR/QC4uKo0xVTLDz3Stqpju1oz1DsJ3jrjvDHTyr+zTXgTAcEffm7Wio8myKENt
         wbSzkkHS7T+8h5HggSK/6g02VLekQa/Em0l750WCJr+KqES7vhEzWKH+ooie57tmdXlR
         7uNWoRy+loFZl+7EYx6sA58obekFJFD4IGE7LZEGMkR2VSocff0x2mtDG+azcl2C6gjr
         ZO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gxZv9czNrqSsp+NwDMxwad6YKQOb4DD102M9ETWSEU=;
        b=rfbcZ8MSUe61tPDzhcYqVo/dnDjjsptHZ3NjcOY7JkBqmJfN5oj1BVzf2ug3Wtbrtz
         0TmD95eZIdQ+b5uRJK9pd7s74/v1B//lAJERlhuQZq8JUspMjLK0rHy4duUaF4UBsw3I
         Tst+4ydUT9h17vo+NoaGEikdpRLPN/fwwdvyquHwy/sxDf450DkkjsZjdKG3zLmnO2M6
         AbVXTHutfChYy1CztKQI3E4meMFq7iWlA/g6Cx1cmMxtEeBBtdjGUrKUMB1G968z3PTo
         ucQrkyhNvAYFbk++whBZDw9FSXubTIeOGpQK+hASxN+NgBIqETpuGVMPFCwHdic5nwVu
         ArTQ==
X-Gm-Message-State: AOAM532+DLgoUmZBYLW5RYgT/dSz4T4ufwvolgqCnmVtAykGS1k3uH/H
        x+zMA/JkoyZ2ZU64XwcYWDg=
X-Google-Smtp-Source: ABdhPJzNTHWGl2lSK5El9AwYn/g4QL+TmEsz0QZcXmoF0HHdlRFYvO6ANFjRh9vxOm6k30pcEG3CMw==
X-Received: by 2002:a17:906:2883:b0:6e8:7012:4185 with SMTP id o3-20020a170906288300b006e870124185mr14014409ejd.204.1649761135581;
        Tue, 12 Apr 2022 03:58:55 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:55 -0700 (PDT)
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
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 03/18] net: dsa: sja1105: reorder sja1105_first_entry_longer_than with memory allocation
Date:   Tue, 12 Apr 2022 12:58:15 +0200
Message-Id: <20220412105830.3495846-4-jakobkoschel@gmail.com>
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

sja1105_first_entry_longer_than() does not make use of the full struct
sja1105_gate_entry *e, just of e->interval which is set from the passed
entry_time.

This means that if there is a gate conflict, we have allocated e for
nothing, just to free it later. Reorder the memory allocation and the
function call, to avoid that and simplify the error unwind path.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 369be2ac3587..e5ea8eb9ec4e 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -36,7 +36,11 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 {
 	struct sja1105_gate_entry *e;
 	struct list_head *pos;
-	int rc;
+
+	pos = sja1105_first_entry_longer_than(&gating_cfg->entries,
+					      entry_time, extack);
+	if (IS_ERR(pos))
+		return PTR_ERR(pos);
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e)
@@ -45,22 +49,11 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 	e->rule = rule;
 	e->gate_state = gate_state;
 	e->interval = entry_time;
-
-	pos = sja1105_first_entry_longer_than(&gating_cfg->entries,
-					      e->interval, extack);
-	if (IS_ERR(pos)) {
-		rc = PTR_ERR(pos);
-		goto err;
-	}
-
 	list_add(&e->list, pos->prev);
 
 	gating_cfg->num_entries++;
 
 	return 0;
-err:
-	kfree(e);
-	return rc;
 }
 
 /* The gate entries contain absolute times in their e->interval field. Convert
-- 
2.25.1

