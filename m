Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813CD5659ED
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiGDPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiGDPfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:35:17 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8131004;
        Mon,  4 Jul 2022 08:35:17 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id i11so10305879qtr.4;
        Mon, 04 Jul 2022 08:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTFFfHOI6YQnG89YTN0BkL6VRe09wxYBVtRGLdKuo8w=;
        b=gVghicEsmuyGCIDY81GeyF84eDZx7G9skjtQt0H7mZlRNXE0kFviMDBORxqroJKvSE
         o0voT2Vzh9iVPqwT6mpMZ1RtJsKz8/yzBIzmTQoWAAsARkxQnSPGsbFVIx0wvOJdcRVP
         NOvBjQPdBRnxVHICSzONRJAWVazCY2pumxvP9VvXUYBUiRA1uXDmWQ37tey76vMbFqlp
         YtW+m3PnMXwjJqO+YsCm4UVNRGiHSOvAFtzZAsdtmWyjJSNljdzFaaeqOmJ0GFnG1686
         3twPEBJVXfcBPiYx7h8rIB/H5Z2bwUuyuGv2gfxiYzM4hKtbGXXS/IIk63YvY7c1Z4H0
         +5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTFFfHOI6YQnG89YTN0BkL6VRe09wxYBVtRGLdKuo8w=;
        b=cxs6Z+lXMmNZ47aSeTz0WGUOrjwD08g1c+1RTyYaULwKTwjxgZUPlEGOwXit9jZsV6
         hvI+oCLrmKTr2A1+ONCwoPut9cmapXUt+EDbmCs4uJvJo2jFOJuymOyri30X64aXGqu8
         cVoVEScGRh+yk1exVcsq+OUovmWLKfYGW6hvDN1BDACppQMrIwoTsnPIvorAVcFbQ1+V
         5D5O68FtoT8MT8OtrOqtdZNPF75K2idEAnno7xZFdYD1evAANlmUsVGZm0jQR1giimxE
         7WUDBa2dzshPBFx2wOWbipxc+CLDu9sfv+BENwobzPsxq8HSKkXOIh3x8wbGtbqdiO+y
         Htvw==
X-Gm-Message-State: AJIora8/9PECCcxpZT7lRG/TtxekEbgP1b32oqrhRt64Rgt6kdqK0sGe
        U99ijd+FnP3Rvwc7UwYBMfY2+fkonoM=
X-Google-Smtp-Source: AGRyM1vT6Mo6kTLC6nM0pEYLN4asr2m3uh+jSITKRTeb/3wuu2MhvClW0zuembMAq3Jn0SLvlR2oyA==
X-Received: by 2002:a05:622a:1193:b0:31d:40aa:26e with SMTP id m19-20020a05622a119300b0031d40aa026emr9534146qtk.462.1656948915754;
        Mon, 04 Jul 2022 08:35:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a05620a0f8c00b006a34a22bc60sm24366909qkn.9.2022.07.04.08.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:35:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.9] net: dsa: bcm_sf2: force pause link settings
Date:   Mon,  4 Jul 2022 08:35:07 -0700
Message-Id: <20220704153510.3859649-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 40b3adf7ad99..03f38c36e188 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -671,6 +671,11 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (phydev->pause) {
+		if (phydev->asym_pause)
+			reg |= TXFLOW_CNTL;
+		reg |= RXFLOW_CNTL;
+	}
 
 	core_writel(priv, reg, CORE_STS_OVERRIDE_GMIIP_PORT(port));
 
-- 
2.25.1

