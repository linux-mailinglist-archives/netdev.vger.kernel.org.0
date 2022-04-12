Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA84FDF30
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350337AbiDLMGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351373AbiDLMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:37 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E24A7805D;
        Tue, 12 Apr 2022 03:58:58 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c6so6729086edn.8;
        Tue, 12 Apr 2022 03:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=esB5mepgr5nyvG9nrRmGTzzqc+m2Rur7gox62JB2JxA=;
        b=PuvOlw8FCBCG5e+EE/ntog+d+HeeY8K1lZiupPOEKAdCgqu2LkYctFFE46dcuaKWxD
         JqH+76Qb0X+BMNsfA9Q8hPEBX7h/TK52EayIDurkbi0ZXZFsbAEpG97HJRgmTx+tICGE
         lCvlWrFaheyN2vCP4qZCLM2U9CPNc/5RzLPcE9ceZCqgdyWliGLOkuRdsOz6o3J4ilD+
         TbQcxAbbz+3lTN4E+LeC2njmuDn5Cn6HBynXRNM7hJygrqlMJHf3cKhdC3wl51iVwJOp
         0ejiDVcQHPks45Uwbw/G/4tvBL/Muq1Ge9wW11L6vmzrxnOckDr79bjZ6ilLKC8GJuHB
         DezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=esB5mepgr5nyvG9nrRmGTzzqc+m2Rur7gox62JB2JxA=;
        b=gBmZAzPWHFFw4H27IfKgUQaGYdp1os6V8L3uzpoRydj79usOrunuXdUspSCWAzBABB
         QU+aMHjx2UulIiE4WUJr//096z1oL/OuraV+7XHja4pCrPnCaMqO+k2MiZMxcwOjRo6J
         vPcPug0BHt+NurW/nZDx1Ox/xXIqpmN2gaUOe9M9SND0S07cCV6zJVSwlwG6AzEL+kQl
         A7iN/D6laFhrSnMQklknmjdSSRpkt3h81D+o60u6CURsgS6MMP1EmceT7PVbyJKjlpWc
         LjNJH499NDnztSb/H2nWCXfyQ0iKA+fydOiXkHQVKL5hkVSCPJMqPBz34G7/64/WGqr2
         koKQ==
X-Gm-Message-State: AOAM532/l5fr+roP00gFCx9yiba5gA7IKw8E9c8EOfhTf0Qcws1u72uK
        P9Q8wbS7OWTycyL3lptdjYU=
X-Google-Smtp-Source: ABdhPJwWJgCDTrqPfiqP3TWBYTxeilB8kDG9V7L+j1ctwcQCz/eM8OQpB3keuCQCrlhlGAhb4nEDcw==
X-Received: by 2002:a05:6402:5106:b0:419:45cd:7ab0 with SMTP id m6-20020a056402510600b0041945cd7ab0mr38052671edd.116.1649761136889;
        Tue, 12 Apr 2022 03:58:56 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:56 -0700 (PDT)
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
Subject: [PATCH net-next v2 04/18] net: dsa: sja1105: use list_add_tail(pos) instead of list_add(pos->prev)
Date:   Tue, 12 Apr 2022 12:58:16 +0200
Message-Id: <20220412105830.3495846-5-jakobkoschel@gmail.com>
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

When passed a non-head list element, list_add_tail() actually adds the
new element to its left, which is what we want. Despite the slightly
confusing name, use the dedicated function which does the same thing as
the open-coded list_add(pos->prev).

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
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

