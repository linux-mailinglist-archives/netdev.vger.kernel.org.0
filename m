Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE7E5029CE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353415AbiDOMdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353817AbiDOMdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD4933E03;
        Fri, 15 Apr 2022 05:30:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v4so9765571edl.7;
        Fri, 15 Apr 2022 05:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PxsivQPQxoWJpzdCzth3DXDecoJwiEJJ2qSzCxa8YbM=;
        b=P0c5Dh8AAa7sb5OM8099LhwkdWs0uzk5X1uLLNx3Jd6eqx5Lgt/IcUOj+ipY349hmP
         zFr0oJ100/g8T7HFu2hZNgVAPiINcyxsFje98AfSxqbBiWv1hhtZi7jXF3sFaPuo5KpO
         +yRpASfCwTH+VZ5eTbpv3G0m0FEupA0NKKPjaNv1+6pt02WnINZlFA1Q3cLXlszsthcQ
         2JCWgtlWrm0RLFwH3f7/f8aHEwV54NuKX20RJ4kvpXtgIialHHc6Ic+lgKcQHDw8fP+3
         IQrA6guzPLfCKaU7jPWmDHySkUFxm0EsXDvOd/7sMFfIbS4/OkUgtlXsoe9i2w0T+a6g
         lw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PxsivQPQxoWJpzdCzth3DXDecoJwiEJJ2qSzCxa8YbM=;
        b=JkfEmeK3qKIHkVHaAx8uqETS0TQtTWt3quLZOxn1k7JkQL42vKLNg7YTqo5MhWomv0
         gGIacrc5Rt4SG3tjhi0XFlFUkxWB7FrFUOtrZtXIEpIcz0NiZYZFCykXbxCtCF4whaOr
         WAzJoyDATm7slZaAsCLbDs+kefoTk6uVo5mVwRmdoy9xZrKolkxEpYONm++eHgMcJE0U
         LZ4UbXwx4Zi60UaslvPkcoYYwarPFXaTT8dNDX0LGUdXaLhb24qRPV097eEJF6aGpKkg
         KGPfeEdNl2znojQd1z9fp2MRKsUFwKXAeHot4Qr4xRA6CNRghKccCr7rovgdzxgt+ffR
         wMEg==
X-Gm-Message-State: AOAM533l0LPIBHxfEtiLaKbL5x6Ea54uRWlSCcMnt0xbYhkLo2GeSkaj
        ShvCMwDyBc8tYGQQLtp6+U0=
X-Google-Smtp-Source: ABdhPJxrnUQmwDmP1a2wh10wtTWPKFW1vlmgMjhOfGBg6TlgPtgf0/ohOCzc3KvvklBKqUk/nAx7fQ==
X-Received: by 2002:a05:6402:1148:b0:413:11e0:1f58 with SMTP id g8-20020a056402114800b0041311e01f58mr7958352edw.113.1650025850637;
        Fri, 15 Apr 2022 05:30:50 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:50 -0700 (PDT)
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
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v4 04/18] net: dsa: sja1105: use list_add_tail(pos) instead of list_add(pos->prev)
Date:   Fri, 15 Apr 2022 14:29:33 +0200
Message-Id: <20220415122947.2754662-5-jakobkoschel@gmail.com>
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

