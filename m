Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9D511D93
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiD0QML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242207AbiD0QLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:52 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A3C48D3F3;
        Wed, 27 Apr 2022 09:07:52 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e23so2488911eda.11;
        Wed, 27 Apr 2022 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEe777jf21mNuBLYmQSjDhGs0vKSqwrqRu+k2WAlJJI=;
        b=UamABqmz85uwD6pNa9ppky+li2Rl66SIvHGPZAkZVVplDfguBN2gvzOkJOhaiRqNGo
         w4fvmZjgVfGNJF5AOxd1tcte4r2cbB7t/uoyu4KztE/vthdmIXv5I6UY49yp1+DYS7Xh
         9j/TlXjAQ2gDG8dwmHMyRfHk1Kw64P83QqoqtW05BXmUo7o/LsgKDe8SC8J+Sghxk4zd
         335vq71ir8P7aETUROxG1BwEZox7dWCMHuxGLLBDs7zGmUOfhUYMOY+X+cEaRcJgk1PB
         GzHiotygYFSraZoVwVsqkjC3NHG10ku3IkPGBiw38mQdLc4oh1SaC8DmzpJzLf5WJ73Y
         AhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEe777jf21mNuBLYmQSjDhGs0vKSqwrqRu+k2WAlJJI=;
        b=VJlG6jQSWxUh7VQ3Kj0B9DPICQc0R4EUBQwZaFqWGBbIwO5Y+70dUkmxg1lEUBR5x2
         wAHWHU9LfMfDkcjEOMR3rod67zse2E22xDWPuEkrrqtgDt9MIEA2aNhgG3q/Vx5bEqCM
         Tslu32Kzrxy2ZZ1Cy6d7PASfFuJOEVirOMLuIXGO0zoskJXAYZIQeG55eM/FtA4lalW1
         XDK/h5VPpBGi2V2BLs8XB/low+5M0zZrRLuVoYnE0Emy5wPa5Vs4+UmJRFdoOEPbaq1f
         /oSXqMrXTOj26r7NfhKRMvHLaMhFuCZss1/bpxCGe0KP3ZE0XYFscqEWA+z1pnmqNhAB
         +a+g==
X-Gm-Message-State: AOAM533BYG7MB7VSWSYtuIA2Sv6IzB7V5CGsZcS95FnP88iYo+NQz5Qb
        gc6RdHVFs7I3FXZil0hzoL4=
X-Google-Smtp-Source: ABdhPJySlXKZf47ps6kDqshs4fRxCzYc+L5zpCq3TvKUZGNFin1KNz+UcjSbrxBlctSBknb4gNbpAw==
X-Received: by 2002:aa7:dd45:0:b0:425:8cea:8c76 with SMTP id o5-20020aa7dd45000000b004258cea8c76mr30819280edw.353.1651075637990;
        Wed, 27 Apr 2022 09:07:17 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:17 -0700 (PDT)
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
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v5 03/18] net: dsa: sja1105: reorder sja1105_first_entry_longer_than with memory allocation
Date:   Wed, 27 Apr 2022 18:06:20 +0200
Message-Id: <20220427160635.420492-4-jakobkoschel@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

sja1105_first_entry_longer_than() does not make use of the full struct
sja1105_gate_entry *e, just of e->interval which is set from the passed
entry_time.

This means that if there is a gate conflict, we have allocated e for
nothing, just to free it later. Reorder the memory allocation and the
function call, to avoid that and simplify the error unwind path.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

