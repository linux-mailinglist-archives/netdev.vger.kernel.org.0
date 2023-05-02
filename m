Return-Path: <netdev+bounces-24-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EDC6F4BE6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04AE6280CCA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA147AD52;
	Tue,  2 May 2023 21:10:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8960AD51
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:10:18 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B98F10F3;
	Tue,  2 May 2023 14:10:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50b8d2eed3dso5756965a12.0;
        Tue, 02 May 2023 14:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683061814; x=1685653814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+r72bqexG+rME9xqJaabiEonH/iTgj+QfgYgCEcVdbw=;
        b=iTmt2cczFrVTgTBlIcDC+ivG4rOlFKXY3C/sYC8MCqxdInz15UUcN8qInwnS9oqEMV
         B5PSiQT27+5zArADX0mvbTB4NSAIblLOQX9cOW2KThSAyShhq4tzLSGS09NEwkrr4HFU
         gLR1lFXfuzfh9eTr0picITSeW3tPlXi1/ZsNMezovvGnSKSkPVz3Am2zA28RSuyKPa9L
         z8LLp4f/dtkk8nwtquS3gC6K4pJCUFna3lwgIm+Dk1ywDyVBDkyySkpk8t1r6Nc5wdMe
         ZlJxctTxGMN1Y3w5301bahtdC65gZuosH2z7u9SjUuu7laDbCPBtTtwo8lcI/SQfUzZ9
         1utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683061814; x=1685653814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+r72bqexG+rME9xqJaabiEonH/iTgj+QfgYgCEcVdbw=;
        b=f934nWEfKEbWua0+MIJ0nnJhqhu5dMNdDgQZfqmq4Q/RYwYlz7+qw4aJKaSpABlk8F
         n1G9kgMObnc3chfpo5PQ92pbY9Gax/Bt23FAz7emFCpfDg9NyNKW3nLnjTNyGQVQJUlZ
         M9PXhQV7gKbYmdIECVQiCAeOHZ+xdpRwnLKLibGkRzl1dto6NKTJ9GrytQUy2lkxSeCz
         ieamwCwNe8XVcpWNAbXpGdjRD4NoQuhE0oBP1NH6JwMUV5u780f+/ux2PBzG1PlyRgSZ
         xM1Jod3PsAw42QJiUXr9YquCQ7LIfBBqnCMaKgXlDXiZWyT75Sz1gZ4Ny9GmxzlPEYSD
         JkKA==
X-Gm-Message-State: AC+VfDzn5AFAbz3c1Vt83qqLrqqYjj731DlLr0ltgv2YcbcBtV7AEl+0
	gCr4vgbXXR5n4w3YK6whS0E=
X-Google-Smtp-Source: ACHHUZ4yvHziWGRT6Cgp5/TQI9ylFHVVk5ToXA3uzoqZOuswJi79HLre8X3Wo3N1vdkK6mynoKBsVA==
X-Received: by 2002:a05:6402:10d7:b0:50b:cc52:3fd3 with SMTP id p23-20020a05640210d700b0050bcc523fd3mr3961480edu.41.1683061814545;
        Tue, 02 May 2023 14:10:14 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id a24-20020a50ff18000000b0050bd19ec39bsm1178620edu.83.2023.05.02.14.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 14:10:14 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
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
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v3 net 2/2] net: dsa: mt7530: fix network connectivity with multiple CPU ports
Date: Wed,  3 May 2023 00:09:47 +0300
Message-Id: <20230502210947.6815-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230502210947.6815-1-arinc.unal@arinc9.com>
References: <20230502210947.6815-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

On mt753x_cpu_port_enable() there's code that enables flooding for the CPU
port only. Since mt753x_cpu_port_enable() runs twice when both CPU ports
are enabled, port 6 becomes the only port to forward the frames to. But
port 5 is the active port, so no frames received from the user ports will
be forwarded to port 5 which breaks network connectivity.

Every bit of the BC_FFP, UNM_FFP, and UNU_FFP bits represents a port. Fix
this issue by setting the bit that corresponds to the CPU port without
overwriting the other bits.

Clear the bits beforehand only for the MT7531 switch. According to the
documents MT7621 Giga Switch Programming Guide v0.3 and MT7531 Reference
Manual for Development Board v1.0, after reset, the BC_FFP, UNM_FFP, and
UNU_FFP bits are set to 1 for MT7531, 0 for MT7530.

The commit 5e5502e012b8 ("net: dsa: mt7530: fix roaming from DSA user
ports") silently changed the method to set the bits on the MT7530_MFC.
Instead of clearing the relevant bits before mt7530_cpu_port_enable()
which runs under a for loop, the commit started doing it on
mt7530_cpu_port_enable().

Back then, this didn't really matter as only a single CPU port could be
used since the CPU port number was hardcoded. The driver was later changed
with commit 1f9a6abecf53 ("net: dsa: mt7530: get cpu-port via dp->cpu_dp
instead of constant") to retrieve the CPU port via dp->cpu_dp. With that,
this silent change became an issue for when using multiple CPU ports.

Fixes: 5e5502e012b8 ("net: dsa: mt7530: fix roaming from DSA user ports")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v3: Remove my tested-by tag as Florian pointed out it's implied with my
signed-off-by tag.

v2: Add the fixes tag and information about the commit that caused this
issue.

---
 drivers/net/dsa/mt7530.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7d9f9563dbda..9bc54e1348cb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1002,9 +1002,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Disable flooding by default */
-	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
-		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
+	/* Enable flooding on the CPU port */
+	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
+		   UNU_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
@@ -2367,6 +2367,10 @@ mt7531_setup_common(struct dsa_switch *ds)
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
+	/* Disable flooding on all ports */
+	mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK |
+		     UNU_FFP_MASK);
+
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
-- 
2.39.2


