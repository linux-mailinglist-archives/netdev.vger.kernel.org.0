Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3746EDE2B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjDYIdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjDYIby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:54 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EC813F8F;
        Tue, 25 Apr 2023 01:30:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-94a342f7c4cso993044366b.0;
        Tue, 25 Apr 2023 01:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411442; x=1685003442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/D1JJY2efd4MnhHjjsGtT2ihX1VwbDlUSIIDF4L4q84=;
        b=MdGnAaVBAbp6NdQd8eUgROd9+A35ntfLrjaupUxW4um9PlATT9SpQ0suUF7e65UZsy
         FmMSaZ+k6228RiadOeUTPmhfleMuTqOat/hleVMHN02HFqCIt3uahp0+ud3oP02/T7It
         2seYADYIbk6ri5luYeAJB8k/qV+yA452jzabz4MMx76vpNfHa0INEs19a3TCOWrj57Gg
         hoP5Gwk8sOpq0H4TT6cNJV62yuQ/pa2b7Al2RDlV5ziDniAuF8CY/CpW+2IC3mXC6cr+
         8K7PubBfFZNmLl/lbyMIfG2i0RcH5kc3hE6V3xWq8GgWQCRq6sY+SVVeb12xuu2Oba+0
         /r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411442; x=1685003442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/D1JJY2efd4MnhHjjsGtT2ihX1VwbDlUSIIDF4L4q84=;
        b=cOcGSQxgSWx/Nl+NhIPoObv7tOqJSJinrmjJi8YJcgTH11uTx/YLJtSsmDqC9I6ien
         h6RoxmmG7yMEL1qk0W7WZOvXzMxWbqcoAreYu5jyjLWPwHR4/wftILJaAkpRIx3QW5sY
         EA1DHEngciXWrAm7HIrt1p0Nx+IQEyfwM9dsYvu3I2uFovCPWJFnMOlntsVsbZbXk6M7
         oVGte9xSIsSotz8fVWUhU4bFQMUVO3PiuA19/925gFqaOFM/vveJ/OSlSDgnSIpsjPUx
         UuVRF+nqP/UqxLBdYTukj5D7+OsAVl+TE828SBbFgsZMgLo3lJoPfV4n/WRNnwDKrLea
         pDlA==
X-Gm-Message-State: AAQBX9fgKgyY6gvX4T6Saga4JEVABaKhRtT8VUBKDhMroDWxlpvZgCyf
        y3mAel5wv9m467goyob4jpo=
X-Google-Smtp-Source: AKy350Z2cHq6TTjVjeqLcsqKIeyLyBvveCOJGizdgwy5K3mli08J4kAj0H3irh4zvu/MRjz2pdZDkg==
X-Received: by 2002:a17:906:8a44:b0:94f:553:6fd6 with SMTP id gx4-20020a1709068a4400b0094f05536fd6mr12551081ejc.24.1682411442106;
        Tue, 25 Apr 2023 01:30:42 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:41 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 20/24] net: dsa: mt7530: set interrupt register only for MT7530
Date:   Tue, 25 Apr 2023 11:29:29 +0300
Message-Id: <20230425082933.84654-21-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Setting this register related to interrupts is only needed for the MT7530
switch. Make an exclusive check to ensure this.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index bdd3f63fe1ef..651c5803706b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2034,7 +2034,7 @@ mt7530_setup_irq(struct mt7530_priv *priv)
 	}
 
 	/* This register must be set for MT7530 to properly fire interrupts */
-	if (priv->id != ID_MT7531)
+	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
 		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
 
 	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
-- 
2.37.2

