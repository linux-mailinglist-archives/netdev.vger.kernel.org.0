Return-Path: <netdev+bounces-11270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C92B732573
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D70A1C20F37
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0644D63D;
	Fri, 16 Jun 2023 02:53:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB63817
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:53:40 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71366297C;
	Thu, 15 Jun 2023 19:53:39 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f7677a94d1so175893e87.0;
        Thu, 15 Jun 2023 19:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884018; x=1689476018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PeQcyVvQd35gvg0Q5bl83ripKoD4zdxyC5dpHXUCgQ8=;
        b=edhIdPAtNhERnXnhjZiBeAyokijKoqw5wFSRniTKNbImMzwboh6sAlKJtp6krKiLqD
         +Zq56xq+MUxNSCKY9olSWo4ITNXyaglKL5uAE/1orLonCMJ/RFboUZu9Lk/EwUUTQ45y
         sfsPSu5hkUn/7/EEXol48gnALTuRaxRIwq74vfvwQfDOLf4Trrmds4WjqmGXXgPJ/Jry
         2gCoV1U3y7o/7wRwOvapFJVwFuZs9DrYoPfQPrQhRumjEpaR7fqvnWm8R5Xh+oxQleJt
         NXc6aLT10cyMrgG2G9AyOCxLqfQvxWWWrHOmTh5+EFbSxTTMJHhMS859SJRZWVRePNA8
         OyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884018; x=1689476018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeQcyVvQd35gvg0Q5bl83ripKoD4zdxyC5dpHXUCgQ8=;
        b=gCVqeYlJ5sjXApucCCAH/CVYMRv/ZK7eqUwjHyWI1KhAXtIT+m7+vv/lg24mPbgtuo
         zOE4r+cqnguxwfs2OLbAYNtcaNy1GGLzQUviOkyXd+rlArlz1LtEvzVps00p1Z1IFJtl
         JbexuhTRQ139seUl3IBzK1ZDRR1MnRwt3uvM4V2OxRVzDYULZYid78Gr1VrVWE6fL1SD
         Jn/LcykWwnbOEA9iFEqrjfnfLfeW6/SNUqszujRqxe1KRUaAHh01cu9ZfEBBGBlnq18/
         KXC7e2FurjDlDVNjVIjBAFTo/0eG8EnGdnBZor8becfWYgtWd8NjI/RoveQeIYB5Laa3
         1frA==
X-Gm-Message-State: AC+VfDyOCFsvP8bg5rfQg+3waPpSaaLra7+aBYqePYm/n98fq9UmZV10
	zWjWSeQ2u/ARjzqfQP57Rn0=
X-Google-Smtp-Source: ACHHUZ67TVTk9qXe6h1Ou3Utuf+4Q6WQCIv/PcEdfrfjhSpFBZKtVFo4DFESiS/5EHeQtQMd4rRa5Q==
X-Received: by 2002:a05:6512:3288:b0:4f0:1e7d:f897 with SMTP id p8-20020a056512328800b004f01e7df897mr347357lfe.17.1686884017644;
        Thu, 15 Jun 2023 19:53:37 -0700 (PDT)
Received: from arinc9-Xeront.. (athedsl-404045.home.otenet.gr. [79.131.130.75])
        by smtp.gmail.com with ESMTPSA id v15-20020a1cf70f000000b003f8d770e935sm890328wmh.0.2023.06.15.19.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:53:37 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v5 3/6] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
Date: Fri, 16 Jun 2023 05:53:24 +0300
Message-Id: <20230616025327.12652-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616025327.12652-1-arinc.unal@arinc9.com>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
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

BPDUs are link-local frames, therefore they must be trapped to the CPU
port. Currently, the MT7530 switch treats BPDUs as regular multicast
frames, therefore flooding them to user ports. To fix this, set BPDUs to be
trapped to the CPU port.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e9fbe7ae6c2c..7b72cf3a0e30 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2262,6 +2262,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	/* Trap BPDUs to the CPU port */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.39.2


